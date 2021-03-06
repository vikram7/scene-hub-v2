require 'date'
include Geokit::Geocoders

FactoryGirl.define do

  factory :band do
    sequence(:name) { |n| "Screaming Females#{n}" }
    user
  end

  factory :user do
    sequence(:email) { |n| "#{n}user@example.com" }
    password "password123"
    factory :user_with_bands do
      transient do
        bands_count 2
      end
      after(:create) do |user, evaluator|
        create_list(:band, evaluator.bands_count, user: user)
      end
    end
  end

  factory :gig do
    band
    show
  end

  factory :venue do
    name     "Great Scott"
    street_1 "1222 Commonwealth Ave"
    city     "Allston"
    state    "MA"
    zip_code "02134"
    address = "1222 Commonwealth Ave, Allston, MA"
    loc = MultiGeocoder.geocode(address)
    if loc.success
      latitude = loc.lat
      longitude = loc.lng
    end
    lat      latitude
    lng      longitude
  end

  factory :show do
    show_date DateTime.now
    details   "A cool show"
    venue
    after(:create) do |show|
      show.bands << FactoryGirl.create(:band)
    end
  end
end
