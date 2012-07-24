Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-4.exch022.serverdata.net ([206.225.164.187]:29437
	"EHLO HUB022-nj-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752814Ab2GXKs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 06:48:27 -0400
Message-ID: <500E7D76.9010205@posedge.com> (sfid-20120724_124831_404118_8308878B)
Date: Tue, 24 Jul 2012 16:18:22 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: 80MHz (11ac) regulatory change
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local> ,<1343048772.4584.18.camel@jlt3.sipsolutions.net>  <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC704B@mbx022-e1-nj-10.exch022.domain.local> <1343120184.4415.16.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343120184.4415.16.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/24/2012 02:26 PM, Johannes Berg wrote:
> It would be really good if you could convince your email client to put >
> in front of each quoted line ... this is really confusing as is.
>

Sorry. Switched to thunderbird now.

>> Also, I believe there are many more possibilities, since we count from
>> the control channel -- ie. for HT HT40+ means secondary channel is above
>> the control channel. For VHT 80, you're going to have 4 possibilities:
>>
>> |-1-|-2-|-3-|-4-|
>>
>> the control channel can be any one of these four I believe? So you'd
>> have configurations like
>>
>> VHT_CHAN_LAYOUT_0_3
>> VHT_CHAN_LAYOUT_1_2
>> VHT_CHAN_LAYOUT_2_1
>> VHT_CHAN_LAYOUT_3_0
>>
>> indicating the number of channels below/above control (for control
>> channel 1,2,3,4 respectively). Similarly, for VHT160 you'd have 8
>> possibilities:
>>
>> |-1-|-2-|-3-|-4-|-5-|-6-|-7-|-8-|
>>
>> (which one could again capture as VHT_CHAN_LAYOUT_0_7 etc.)
>>
>> [MP] I see your point. But according to 11ac spec, AP will use primary
>> chan as specified in HT operation IE chan num. Secondary channel is
>> center freq specified in VHT Operation IE. So I am thinking secondary
>> channel is not relative offset to primary channel. Hope I am not
>> mistaken here.
>
> Ok so HT has primary channel and secondary, and VHT has secondary VHT
> which can again be above/below? That would make sense, but you wouldn't
> be covering it.
>

I am thinking no need of above/below convention as the center frequency 
value itself we know.

>>> +     /* This would happen when regulatory rules disallow VHT80 completely */
>>> +     if (IEEE80211_CHAN_NO_VHT80 == (chan->flags & (IEEE80211_CHAN_NO_VHT80)))
>>> +             return true;
>>
>> Is that really right? Need to document what the return value of this
>> function should be, I guess?
>>
>> [MP] I guess, it's possible for a channel not allowed for 80Mhz operation.
>
> Yeah but should it really check *all* the bits rather than any one of
> them?
>

You mean to say other bits like HT40MINUS, HT40PLUS or even DFS?

>>> +     /*
>>> +      * Please note that this assumes target bandwidth is 40 MHz,
>>> +      * if that ever changes we also need to change the below logic
>>> +      * to include that as well.
>>> +      */
>>
>> ???
>>
>> [MP] Can you explain? This function doesn't make any sense?
>
> The comment about 40 MHz doesn't make any sense.
>

Agree. I will change this.

> johannes
>
