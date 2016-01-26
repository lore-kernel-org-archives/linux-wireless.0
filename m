Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49754 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020AbcAZPTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 10:19:45 -0500
Message-ID: <56A78E8F.1080505@candelatech.com> (sfid-20160126_161949_047588_85D2891C)
Date: Tue, 26 Jan 2016 07:19:43 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when building
 IEs.
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com> <1453807009.2759.23.camel@sipsolutions.net>
In-Reply-To: <1453807009.2759.23.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/26/2016 03:16 AM, Johannes Berg wrote:
> On Tue, 2015-10-20 at 10:24 -0700, greearb@candelatech.com wrote:
>
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -2130,6 +2130,8 @@ enum nl80211_attrs {
>>
>>   	NL80211_ATTR_REG_INDOOR,
>>
>> +	NL80211_ATTR_TX_ADVERT_RATEMASK,
>
> First of all, this is missing documentation. It's a FLAG as far as I
> can tell, but if it's set should it affect only the advertised or both?
>
> I also think you added this because I had commented that we might not
> want to do it unconditionally, but is there really a good reason not to
> do it unconditionally? I was probably more thinking out loud what would
> happen with P2P, but there we already say "no cck" for scanning so it
> shouldn't really have any effect.

Turns out, I did want this flag.  The reason is that I might want to
advertise as a normal-ish /g station (ie, full /b/g rateset), but
actually fix the TX rate as 24Mbps (or whatever).

So, I do need a way to set an advertise ratemask vs a tx-rate-mask.

With my current patch, and my patches to supplicant, it seems to at least
mostly do what I want, but there is a user-space issue where if you set the ADVERT_RATEMASK
on kernels that do not support that flag, it will just set the tx rates instead.  Not
the end of the world, but possibly there needs to be a feature flag
that user-space could query for this feature.

> But given that we have NL80211_ATTR_SCAN_SUPP_RATES, where does your
> patch even have an effect, other than this not handling HT/VHT?
>
> I'm a bit wary that we're introducing two ways of achieving a very
> similar thing.
>
> Also, adding these overrides all over the code seems very complex.
> Perhaps we can achieve the goal of being able to pretend to have
> limited hardware capabilities by actually restricting hardware
> capabilities instead? That would also avoid having to play whack-a-mole
> with code paths using the device capabilities.
>
> I'd imagine an API along the lines of doing some kind of higher-layer
> re-register of the wiphy in mac80211 with limited capabilites. At that
> point you'd allocate a copy of the original capabilities (as far as the
> new restricted ones overwrite the data), and remove the device from the
> system as far as higher layers like cfg80211 are concerned.
>
> Would something like that work for you?

As far as I can tell, that will not work, because I want to have multiple station devices
per radio, and have each of them be able to use a different configuration.  So,
one station may be /g, and another /n and another /AC.  Same with APs.  In addition,
some stations may want to use all available rates for their mode,
and others may want to use a fixed rate or subset of available rates.

Thanks,
Ben

>
> johannes
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
