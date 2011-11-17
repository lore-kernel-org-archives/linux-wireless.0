Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39742 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab1KQRmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 12:42:36 -0500
Message-ID: <4EC54783.6070209@candelatech.com> (sfid-20111117_184239_839552_CF445144)
Date: Thu, 17 Nov 2011 09:42:27 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8 2/2] mac80211:  Support ht-cap over-rides.
References: <1320780995-30483-1-git-send-email-greearb@candelatech.com>  <1320780995-30483-2-git-send-email-greearb@candelatech.com>  (sfid-20111108_203659_989707_E33ECA13) <1320783128.24797.48.camel@jlt3.sipsolutions.net>  <4EB99812.3000507@candelatech.com>  <1320786130.24797.78.camel@jlt3.sipsolutions.net>  <4EBC2516.4080807@candelatech.com>  <1321529293.3997.28.camel@jlt3.sipsolutions.net>  <4EC542C4.1040402@candelatech.com> <1321550703.3997.45.camel@jlt3.sipsolutions.net>
In-Reply-To: <1321550703.3997.45.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2011 09:25 AM, Johannes Berg wrote:
> On Thu, 2011-11-17 at 09:22 -0800, Ben Greear wrote:
>
>>> We can't, but can't we like assign sdata->ht_caps = sband->ht_caps? Or
>>> maybe even calculate restricted HT caps for both 2.4 and 5 GHz?
>>> Basically what I was thinking is this:
>>
>>> struct sub_if_data {
>>> 	...
>>> 	struct ieee80211_sta_ht_cap ht_cap[num_bands];
>>> 	...
>>> };
>>
>> So we'd have to copy this data from sbands[] upon creation
>> of the interface to make sure it is always initialized?
>> This would allow us to easily support the overrides for
>> non-station interfaces, so I do like that benefit.
>>
>> Can the sbands[] data ever change for any reason once
>> an interface is created?  If not, then probably this is
>> doable.  If it can change, then we are screwed.
>
> I don't think it can change but it's not const (I think?) so drivers
> might do stupid things -- but that would be buggy anyway.

I can imagine someone wanting to poke at a driver to enable/disable
features, but no idea if it is done yet.

>> It seems you are basically wanting to copy the sband[] data
>> local to each interface (sdata), and then we would remove sband from most
>> (or all?) of the method calls that deal with sband->ht_caps?
>
> I guess. Though we still need the band to know which one to use (I'm
> reluctant to say we just need one due to channel switching etc.)
>
>> Looks like quite a bit of code churn, and probably requiring at least two
>> patches:
>>    * Get rid of sband usage by copying the sband data into sdata
>>    * Add the over-ride logic
>
> Yeah. It might be *too much* churn, but that's what I was thinking. If
> you think it's likely too much churn let's go with what you have now,
> there are only a few minor things about it I don't like much.

I would much rather use something similar to my last-posted patch.  I
think it is a lot less risky than rewriting all of the sband usage.

I'll rebase against the latest wireless-testing and post a patch
for further review, hopefully later today.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

