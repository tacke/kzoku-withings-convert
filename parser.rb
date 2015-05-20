require 'rexml/document'

doc = REXML::Document.new(open("kzoku2.xml"))

weights = {}
doc.elements.each('chart/graphs/graph[@gid="1"]/value') do |element|
  weights[element.attributes['xid']] = element.text
end
#puts "weights.lengh=#{weights.length}"

fatPers = {}
doc.elements.each('chart/graphs/graph[@gid="2"]/value') do |element|
  fatPers[element.attributes['xid']] = element.text
end
#puts "fatPers.lengh=#{fatPers.length}"

dateTimes = []
year = 2014
doc.elements.reverse_each('chart/xaxis/value') do |element|
  date = element.text
  year = year - 1 if date == '12/31'
  dateTimes << {xid: element.attributes['xid'], dateTime: year.to_s  + '-' + date.gsub('/', '-') + ' 00:00:00'}
end
#puts "dateTimes.lengh=#{dateTimes.length}"

dateTimes.reverse_each {|item|
  weight = weights[item[:xid]]
  bodyFatPercentage = fatPers[item[:xid]]
  if weight && bodyFatPercentage
    puts item[:dateTime] + ', ' + weight + ', ' + bodyFatPercentage
  elsif weight
    puts item[:dateTime] + ', ' + weight
  end
}
