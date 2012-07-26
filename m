Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33134 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2GZKbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 06:31:34 -0400
Received: by obbuo13 with SMTP id uo13so2489066obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2012 03:31:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50111BB3.9090802@openwrt.org>
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<CAFtRNNwY-1JLEJa_qZpUfsyQVdUQLO3CWcEB9xef-g5jPzndNQ@mail.gmail.com>
	<50107C35.9050807@net.t-labs.tu-berlin.de>
	<CAFtRNNz2qG5Fsjd1WVfA-BOSPGZ=WvMzrMwyqn8d6tfiBpkSVw@mail.gmail.com>
	<501083F6.8060002@net.t-labs.tu-berlin.de>
	<CAFtRNNxEHaON-uBjgLyeJdgN6UKfed6fAeCYPpo6xToi3dixOw@mail.gmail.com>
	<50111BB3.9090802@openwrt.org>
Date: Thu, 26 Jul 2012 13:31:34 +0300
Message-ID: <CAFtRNNyk051oLGuZOMcthf_mO6sArQzp+yCDvLQR2b=mACe9tQ@mail.gmail.com> (sfid-20120726_123139_830679_CC3E2732)
Subject: Re: [ath5k-devel] [PATCH 2/2] ath5k: fix phy_init() to respect user
 txpower changes
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>, jirislaby@gmail.com,
	johannes.berg@intel.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/26 Felix Fietkau <nbd@openwrt.org>:
> On 2012-07-26 12:20 PM, Nick Kossifidis wrote:
>> 2012/7/26 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
>>> Hi Nick,
>>>
>>> Nick Kossifidis schrieb:
>>>
>>>> 2012/7/26 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
>>>
>>>> There is nothing in your patch that suggests that's related to this.
>>>> Anyway there's a simple way to fix this:
>>>>
>>>> Just move this:
>>>>
>>>> 3575         /* Min/max in 0.25dB units */
>>>> 3576         ah->ah_txpower.txp_min_pwr = 2 * rates[7];
>>>> 3577         ah->ah_txpower.txp_cur_pwr = 2 * rates[0];
>>>> 3578         ah->ah_txpower.txp_ofdm = rates[7];
>>>>
>>>> above the for loop and you are done.
>>>>
>>>> Note rates[i] don't hold tx power values, they hold indices to the
>>>> channel powertable.
>>>>
>>>
>>>
>>> Are you agreeing that current ath5k txpower handling set from user space
>>> is not working and we need to fix it ?
>>
>> Is that a rhetorical question ? Just check out the TODOs on wireless.kernel.org.
>>
>> The current code does not preserve the tx power value across resets,
>> thats the problem and the change I mentioned above fixes it (patch on
>> the way, it's just that where I am right now I don't have bw to
>> download wireless-testing) but other than that when we set tx power
>> without reseting at least it does what it's supposed to do (and the
>> result is the same with madwifi, using a spectrum analyzer or another
>> client/monitor interface you see some power levels supported or only
>> the max txpower supported, it's really up to the vendor, not all of
>> them follow Atheros's reference designs). Your patch passes 1dbm units
>> on a function that expects 0.5dbm units, you fix the problem with
>> preserving tx power but you break the tx power setting.
>>
>> The change I mentioned above fixes the problem without introducing new
>> variables just because "Felix will use the other one", I don't
>> understand why you have a problem with that and why you think I don't
>> want this to get fixed...
>>
>>> Beside that, what about a channel switch and wrongly re-use txp_cur_pwr
>>> on a channel witch other max power levels ?
>>
>> That won't be a problem, when channel changes we 'll call
>>
>> reset -> phy_init -> set_txpower -> (calibration) -> set rate target power
>>
>> and then it's going to get limited before it's written on hw here:
>>
>> max_pwr = min(max_pwr, (u16) ah->ah_txpower.txp_max_pwr) / 2;
>>
>> txp_max_pwr is initialized on calibration (the max power for this
>> channel), then it gets limited by CTL edge information on EEPROM, then
>> by max_pwr and then max_pwr is limited by rate_info->target_power_X
>> from EEPROM to create rates[i]. We write rates[i] on hw, not
>> txp_cur_pwr.
> I think it's a bad idea to store the user's choice of txpower in a
> variable that internally gets reused to store the hw limit. Even when
> the offset isn't added to it, it's still fragile.
>
> A problem with this is that different channels have different max power
> values, so if you switch to a channel with a lower power, and then
> switch back (without explicitly changing txpower inbetween), don't you
> then end up with less power than you configured?
>
> This can be easily avoided by storing the user's txpower choice
> separately from the actual hw limit...
>
> - Felix

That's what ah->power_level already does, what's the point of
introducing another one. Do you think power_level is baldy
used/implemented ?


-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
