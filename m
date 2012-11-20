Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:47052
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616Ab2KTL77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:59:59 -0500
Message-ID: <50AB70B9.1010505@posedge.com> (sfid-20121120_130002_165980_40EEF7C4)
Date: Tue, 20 Nov 2012 17:29:53 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>  <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>  <50AB3EE1.8060101@posedge.com>  <1353400890.9399.3.camel@jlt4.sipsolutions.net>  (sfid-20121120_094103_819884_8535CF9F) <1353404398.9399.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353404398.9399.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2012 03:09 PM, Johannes Berg wrote:
> On Tue, 2012-11-20 at 09:41 +0100, Johannes Berg wrote:
>> On Tue, 2012-11-20 at 13:57 +0530, Mahesh Palivela wrote:
>>
>>>> +	for (freq = center_freq - bw/2 + 10;
>>>> +	     freq <= center_freq + bw/2 - 10;
>>>> +	     freq += 20) {
>>>> +		c = ieee80211_get_channel(wiphy, freq);
>>>> +		if (!c || c->flags & (IEEE80211_CHAN_DISABLED |
>>>> +				      IEEE80211_CHAN_PASSIVE_SCAN |
>>>> +				      IEEE80211_CHAN_NO_IBSS |
>>>> +				      IEEE80211_CHAN_RADAR))
>>>> +			return false;
>>
>>
>>>> +	for (freq = center_freq - bw/2 + 10;
>>>> +	     freq <= center_freq + bw/2 - 10;
>>>> +	     freq += 20) {
>>>> +		c = ieee80211_get_channel(&rdev->wiphy, freq);
>>>> +		if (!c || c->flags & IEEE80211_CHAN_DISABLED)
>>>> +			return -EINVAL;
>>
>>
>>> For loops in both functions seems to be similar. One return false, other
>>> return -EINVAL. Can we remove duplication?
>>
>> True, but they check different flags. I suppose we could have a common
>> function where the checked flags are passed in, I can try that.
>
> I'll add this to the patch:
>
> http://p.sipsolutions.net/24eb25fb98ef2d0b.txt
>

Looks good to me Johannes. Overall your VHT channel config 
implementation done so well.
Partial regulatory check in nl80211_parse_chandef() has to be modified 
to include BW check. I see your TODO comment there.

Thanks,
Mahesh
