Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-4.exch022.serverdata.net ([206.225.164.187]:16327
	"EHLO HUB022-nj-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024Ab2G3IbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 04:31:11 -0400
Message-ID: <50164647.5050800@posedge.com> (sfid-20120730_103116_134153_388605FE)
Date: Mon, 30 Jul 2012 14:01:03 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: 80MHz (11ac) regulatory change
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local>    ,<1343048772.4584.18.camel@jlt3.sipsolutions.net>     <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC704B@mbx022-e1-nj-10.exch022.domain.local>    <1343120184.4415.16.camel@jlt3.sipsolutions.net>    <500E7D76.9010205@posedge.com>   <1343128638.4415.17.camel@jlt3.sipsolutions.net>   <500F6F94.3070400@posedge.com>  <1343209816.4463.28.camel@jlt3.sipsolutions.net>  <5010E413.9010502@posedge.com> <1343324564.4477.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343324564.4477.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/26/2012 11:12 PM, Johannes Berg wrote:
> On Thu, 2012-07-26 at 12:00 +0530, Mahesh Palivela wrote:
>
>>>> 11ac Draft3.0 section 22.3.14 says VHT channel is specified by
>>>> dot11CurrentChannelBandwidth, dot11CurrentChannelCenterFrequencyIndex0,
>>>> dot11CurrentChannelCenterFrequencyIndex1 and dot11CurrentPrimaryChannel
>>>>
>>>> primary channel comes from HT Op IE.
>>>> chanBW, chanCenterFreq0, chanCenterFreq1 comes from VHT Op IE.
>>>> So multiple secondary channels doesn't seem to be a valid?
>>>
>>> Hmm. But that means we have to specify the channel completely
>>> differently? I think we should stick to our scheme of center freq of a
>>> 20 MHz channel + surrounding bandwidth,
>>
>> ok. Let's stick to old way of channel config. Basically freq value and
>> channel type which kind of specifies channel widths. so how about for
>> VHT channel types as below. Its similar to what you proposed.
>>
>> For 80 MHz:
>>
>> VHT80_3PLUS
>> VHT80_MINUS_2PLUS
>> VHT80_2MINUS_PLUS
>> VHT80_3MINUS
>>
>> For 160 MHz:
>>
>> VHT160_7PLUS
>> VHT160_MINUS_6PLUS
>> VHT160_2MINUS_5PLUS
>> VHT160_3MINUS_4PLUS
>> VHT160_4MINUS_3PLUS
>> VHT160_5MINUS_2PLUS
>> VHT160_6MINUS_PLUS
>> VHT160_7MINUS
>
> Yeah, that would work. Lots of channel types ...
>

Yea, So I am thinking how about passing channel width and secondary 
channel center frequency from which we know chan_below or chan_above, 
instead of channel_type.

>>   > though it obviously won't work for 80+80. The question will be where
>>   > we deviate from our previous scheme. I tend to think that HT80+80
>>   > should deviate, I have a feeling it won't be implemented soon
>>   > (or ever?) anyway.
>>   >
>>
>> Yea, even I feel the channel config representation what we are proposing
>> is not really extendable to discrete bands. That's my only worry...
>
> ? What do you mean?
>

I mean 80+80 scenario is not possible to represent.

>>>> CHAN_NO_VHT80 is actually 2 bits. NO_VHT80MINUS & NO_VHT80PLUS.
>>>> Is that ok?
>>>>
>>>> +	IEEE80211_CHAN_NO_VHT80PLUS	= 1<<6,
>>>> +	IEEE80211_CHAN_NO_VHT80MINUS	= 1<<7,
>>>>
>>>> +#define IEEE80211_CHAN_NO_VHT80 \
>>>> +	(IEEE80211_CHAN_NO_VHT80PLUS | IEEE80211_CHAN_NO_VHT80MINUS)
>>>
>>> Right. But did you mean to check that all of them are set? What if one
>>> of them is set but the other isn't?
>>>
>>
>> If one of them is set, then we accept VHT80 for that channel.
>
> Yes, but is that really correct?
>

I think so. If one of the configuration is allowed we can perform VHT80 
operation.

> johannes
>

Thanks,
Mahesh
