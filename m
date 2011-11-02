Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43061 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab1KBSED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 14:04:03 -0400
Message-ID: <4EB1860E.5080800@candelatech.com> (sfid-20111102_190407_253226_AAA3AC3B)
Date: Wed, 02 Nov 2011 11:03:58 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 3/5] wifi: Allow overriding some HT information.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>  <1319778680-11405-3-git-send-email-greearb@candelatech.com>  (sfid-20111028_071147_787476_DBCC8CCF) <1319789573.3914.15.camel@jlt3.sipsolutions.net>  <4EAAD95E.1030001@candelatech.com>  (sfid-20111028_183341_942256_664FE0B1) <1320221630.3950.22.camel@jlt3.sipsolutions.net>  <4EB176F9.7090304@candelatech.com> <1320256198.7846.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320256198.7846.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/02/2011 10:49 AM, Johannes Berg wrote:
> On Wed, 2011-11-02 at 09:59 -0700, Ben Greear wrote:
>
>>> No. Neither of these can ever be increased so it's not that simple. And
>>> making it smaller is always possible since it's just advertising.
>>> Presumably you do understand the reasons for this advertising/these
>>> restrictions?
>>
>> It seems that a driver might default to a mid-range value for the MPDU values
>> because it is somehow 'better' for whatever reason, and yet it might still
>> support larger values if the user desires, perhaps because in specific
>> scenarios larger values are better.  Ath9k does set to the max value,
>> so if we do a per-driver capabilities flag as I did in v2 then we
>> are safe.
>
> Then the proper way to do that would be to not have a flag, but a max it
> can be set to. However, I see no reason it should default to a mid-range
> value?! iwlwifi for example needs to allocate enough space but ... I
> don't get it. What's wrong with simply not allowing to increase, only
> decrease?

Ok, I'll work on allowing the value to only be decreased.
I should be able to compare against whatever the hardware set in
the channel ht-info I think.

>>>>           /* add attributes here, update the policy in nl80211.c */
>>
>> I copied some of that code from nl80211_set_station, which appears to
>> also forget to check the length for the NL80211_ATTR_HT_CAPABILITY
>> object.  Is there some reason why it doesn't need to check, or does
>> that code need fixing as well?
>
> NL80211_ATTR_HT_CAPABILITY in particular *has* a policy entry.

Ahh, I didn't realize that's what was meant by policy.  Mind if
I change that comment to something like what is below?

/* add attributes here, update the nl80211_policy array in nl80211.c */


>>    From 20.1.1 of the 802.11n spec:
>>
>> "An HT non-AP STA shall support all equal modulation (EQM) rates for one spatial stream (MCSs 0 through
>> 7) using 20 MHz channel width. An HT AP shall support all EQM rates for one and two spatial streams
>> (MCSs 0 through 15) using 20 MHz channel width."
>>
>> That is why I wrote that code as I did, but perhaps I misunderstand that section of
>> the docs.
>
> No, that makes some sense, I wasn't aware of that restriction.

Well, personally it seems like a lame restriction, and at least hostapd and ath9k will
deal fine with a station advertising less than that, but probably best to
stick with the spec if possible.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

