Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55107 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1948070AbcBRUkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 15:40:47 -0500
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when building
 IEs.
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
 <1453807009.2759.23.camel@sipsolutions.net>
 <56A78E8F.1080505@candelatech.com> <1454576521.2564.6.camel@sipsolutions.net>
 <56B38FD1.40902@candelatech.com> <1455827536.2084.35.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56C62C4E.7020600@candelatech.com> (sfid-20160218_214054_539508_50A79B47)
Date: Thu, 18 Feb 2016 12:40:46 -0800
MIME-Version: 1.0
In-Reply-To: <1455827536.2084.35.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2016 12:32 PM, Johannes Berg wrote:
> On Thu, 2016-02-04 at 09:52 -0800, Ben Greear wrote:
>> On 02/04/2016 01:02 AM, Johannes Berg wrote:
>>> On Tue, 2016-01-26 at 07:19 -0800, Ben Greear wrote:
>>>
>>>> As far as I can tell, that will not work, because I want to have
>>>> multiple station devices per radio, and have each of them be able
>>>> to
>>>> use a different configuration.  So, one station may be /g, and
>>>> another /n and another /AC.  Same with APs.  In addition, some
>>>> stations may want to use all available rates for their mode, and
>>>> others may want to use a fixed rate or subset of available rates.
>>>
>>> So let's agree that we're splitting the *used* rates (which we have
>>> today) and the *advertised* rates/modes/...
>>
>> Yes, I think that will work well, and unless I mis-understand, that
>> is basically what I implemented so far.
>
> Yes.
>
>> Copied state might be tricky.  I think if we hold any copies of
>> capabilities data in the sdata, then it should be logically compared
>> with a mask and then treated as an AND with whatever the wiphy has.
>
> Not sure what you're saying here. I was thinking we'd simply do one of
> these two:
>
> 1) sdata->sband[5GHZ].vht = wiphy->sband[5GHZ].vht & user-config
>     (semantically, not implementation of course)
> 2) sdata->sband[5GHZ].vht = wiphy->sband[5GHZ].vht
>
> and change mac80211 to use sdata->sband instead of wiphy->sband
> wherever the latter is used today. That way, we can avoid touching all
> these things.
>
> I think, for example, that you missed TDLS in your changes. Changing
> everything throughout would mean that grepping for "wiphy->sband" would
> immediately show such bugs, making it far easier to maintain.


I think option 1 might be better.  For option 2, I'd be worried about
someone changing the wiphy somehow and vdevs getting out of sync.

Any opinions on the lifetime for the sdata->sband_user_config data?

For instance, could be cleared when station dis-associates,
or we could make it persist until changed or until vdev goes away?

And, while this would take care of some of the issues (3x3 vs 2x2?), it still wouldn't
let someone have full control over the advertised rates vs configured-rates
and such, would it?

So, your proposal is in addition to allowing advertised-rates to be configured?

Thanks,
Ben

>>    I'm reluctant to propose any serious mac80211 change at this point,
>> though perhaps as more of this type of features are added, then it
>> will become more obvious how to nicely consolidate things in
>> mac80211.
>
> I don't really think this would be a "serious" change? It's basically
> pointering changes, you could (and perhaps should, to catch it all) use
> an spatch to make the initial change.
>
>> To be honest, I thought my -v2 patches were fairly non-invasive
>> compared to my normal hackings :)
>>
>
> :)
>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

