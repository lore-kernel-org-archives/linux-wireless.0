Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52137 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab1HMQF7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:05:59 -0400
Message-ID: <4E46A0D9.3090906@openwrt.org> (sfid-20110813_180603_104713_78273B78)
Date: Sat, 13 Aug 2011 10:05:45 -0600
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Alexander Simon <alexander.simon@saxnet.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] mac80211: Add HT operation modes for IBSS
References: <1888623.Vt5VZUN2cU@alex-1> <1312990268.3128.22.camel@alex-2> <1313152536.4022.9.camel@jlt3.sipsolutions.net> <2276990.7uHyxQX4MO@alex-1>
In-Reply-To: <2276990.7uHyxQX4MO@alex-1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-12 8:25 AM, Alexander Simon wrote:
>>  Ok, that makes sense. So you need the get_bss_ht() only for fixed mode I
>>  guess.
> Exactly.
>>
>>  >  This should answer your last questions:
>>  >  When not fixed, the BSSID configuration always is preferred. Thus, we
>>  >  would join as HT40 even though not requested.
>>  >  So, when we requsted HT40-, but the IBSS is HT40+, we would work on -.
>>
>>  ? I think I know what you mean but your example seems .. the wrong way
>>  around?
> Damn, you're right. We would work on HT+, not -, as the BSS config is
> preferred.
>>
>>  >  I wanted to have the opportunity to start HT on an existing IBSS.
>>
>>  Well that should always be OK?
>>
>>  >  The problem is that legacy station may "kill" the HT configuration:
>>  >  If STA A starts in HT IBSS and lets say Windows STA B joins, B would
>>  >  advertise that IBSS as non-HT as it ignores our HT IE.
>>  >  Then, if STA A dies and STA C joins, it will be non-HT.
>>
>>  mac80211 is STA C? Would it be a problem to use HT if the IBSS was
>>  previously non-HT? The old members will ignore it, but other new HT
>>  members may work OK? IOW -- is it not possible to have a mixed HT/non-HT
>>  IBSS?
> Basically, as to my knowledge, the only difference is that we add HI IEs. Non-
> HT stations will ignore these, of course.
> A mixed network should be no problem - as long as Greenfield is turned off
> (and i don't turn in on anywhere).
>
> To proceed with basics: I follow a very simple approach (for non-fixed freq):
> Use current BSS HT settings. If none exists, use iw config. If no iw config,
> no HT.
What's the point of disabling HT in that case. Since it's a superset of 
normal A/B/G mode, we could just leave it enabled (defaulting to HT20) 
instead of reconfiguring based on beacons at a later point in time.

- Felix
