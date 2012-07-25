Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:3529 "EHLO
	HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715Ab2GYEBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 00:01:30 -0400
Message-ID: <500F6F94.3070400@posedge.com> (sfid-20120725_060133_796392_057DBE5E)
Date: Wed, 25 Jul 2012 09:31:24 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: 80MHz (11ac) regulatory change
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local>  ,<1343048772.4584.18.camel@jlt3.sipsolutions.net>   <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC704B@mbx022-e1-nj-10.exch022.domain.local>  <1343120184.4415.16.camel@jlt3.sipsolutions.net>  <500E7D76.9010205@posedge.com> <1343128638.4415.17.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343128638.4415.17.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/24/2012 04:47 PM, Johannes Berg wrote:
> On Tue, 2012-07-24 at 16:18 +0530, Mahesh Palivela wrote:
>
>>>> indicating the number of channels below/above control (for control
>>>> channel 1,2,3,4 respectively). Similarly, for VHT160 you'd have 8
>>>> possibilities:
>>>>
>>>> |-1-|-2-|-3-|-4-|-5-|-6-|-7-|-8-|
>>>>
>>>> (which one could again capture as VHT_CHAN_LAYOUT_0_7 etc.)
>>>>
>>>> [MP] I see your point. But according to 11ac spec, AP will use primary
>>>> chan as specified in HT operation IE chan num. Secondary channel is
>>>> center freq specified in VHT Operation IE. So I am thinking secondary
>>>> channel is not relative offset to primary channel. Hope I am not
>>>> mistaken here.
>>>
>>> Ok so HT has primary channel and secondary, and VHT has secondary VHT
>>> which can again be above/below? That would make sense, but you wouldn't
>>> be covering it.
>>>
>>
>> I am thinking no need of above/below convention as the center frequency
>> value itself we know.
>
> But we don't use the center frequency of the overall Ht40/80/160
> channel, we always use the center frequency of the control channel.
>

11ac Draft3.0 section 22.3.14 says VHT channel is specified by
dot11CurrentChannelBandwidth, dot11CurrentChannelCenterFrequencyIndex0,
dot11CurrentChannelCenterFrequencyIndex1 and dot11CurrentPrimaryChannel

primary channel comes from HT Op IE.
chanBW, chanCenterFreq0, chanCenterFreq1 comes from VHT Op IE.
So multiple secondary channels doesn't seem to be a valid?

>>>>> +     /* This would happen when regulatory rules disallow VHT80 completely */
>>>>> +     if (IEEE80211_CHAN_NO_VHT80 == (chan->flags & (IEEE80211_CHAN_NO_VHT80)))
>>>>> +             return true;
>>>>
>>>> Is that really right? Need to document what the return value of this
>>>> function should be, I guess?
>>>>
>>>> [MP] I guess, it's possible for a channel not allowed for 80Mhz operation.
>>>
>>> Yeah but should it really check *all* the bits rather than any one of
>>> them?
>>>
>>
>> You mean to say other bits like HT40MINUS, HT40PLUS or even DFS?
>
> No, I mean all the bits that are part of CHAN_NO_VHT80.
>


CHAN_NO_VHT80 is actually 2 bits. NO_VHT80MINUS & NO_VHT80PLUS.
Is that ok?

+	IEEE80211_CHAN_NO_VHT80PLUS	= 1<<6,
+	IEEE80211_CHAN_NO_VHT80MINUS	= 1<<7,

+#define IEEE80211_CHAN_NO_VHT80 \
+	(IEEE80211_CHAN_NO_VHT80PLUS | IEEE80211_CHAN_NO_VHT80MINUS)

> johannes
>

Thanks,
Mahesh
