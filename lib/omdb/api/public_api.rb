# frozen_string_literal: true

module Omdb
  module Api
    module PublicApi
      %i[find_by_id find_by_title].each do |method|
        define_method(method) do |value, **options|
          request = Omdb::Api::Request.new(self, method, value, options)

          if request.success?
            request.response
          else
            Omdb::Api::Error.new(params: request.response)
          end
        end
      end

      def search(value, options = {})
        request = Omdb::Api::Request.new(self, 'search', value, options)

        if request.success?
          Omdb::Api::Collection.new(
            request.response.fetch('Search').map do |movie|
              Omdb::Api::Movie.new(params: movie)
            end
          )
        else
          Omdb::Api::Error.new(params: request.response)
        end
      end
    end
  end
end
