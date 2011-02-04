Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47159 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1BDTuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 14:50:12 -0500
Received: by iwn9 with SMTP id 9so2505726iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 11:50:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikxhPHQ_50cKoJn920n9A0hVssoZZfJRCsw=CH+@mail.gmail.com>
References: <AANLkTi=4z31H+v2=Dve2FY3aw0iEBm5UQPz55Qx9UkwR@mail.gmail.com>
 <AANLkTikNUv2VuL8ftQAF_x4R-ccB0Y_aPFFdF52UBnBt@mail.gmail.com> <AANLkTikxhPHQ_50cKoJn920n9A0hVssoZZfJRCsw=CH+@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 4 Feb 2011 11:49:51 -0800
Message-ID: <AANLkTikn2XSROW0V42FcBoRgBBd74WXMOmvdoToJGqfe@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix maximum tx power handling
To: Mark Mentovai <mark@moxienet.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 4, 2011 at 11:42 AM, Mark Mentovai <mark@moxienet.com> wrote:
> Luis R. Rodriguez wrote:
>> On Sun, Jan 30, 2011 at 9:01 AM, Mark Mentovai <mark@moxienet.com> wrote:
>>> Your patch also doesn’t work properly for me using the ath9k driver.
>>> With your patch, I wind up with an artificial power limit of 20dBm
>>> across the board, although the hardware limit is actually 25dBm on the
>>> AR9223 I’m testing with. This stems from the fact that ath9k doesn’t
>>> know how to properly compute the hardware limit.
>>> ath9k_init_txpower_limits is implemented on top of
>>> ath9k_hw_set_txpowerlimit, which uses a channel’s current max_power
>>> value as a basis for its computation. This means that it will either
>>> use the hard-coded initial value of 20dBm from CHAN2G and CHAN5G in
>>> drivers/net/wireless/ath/ath9k/init.c, or it will use world regulatory
>>> domain values (also 20dBm) set by ath_regd_init_wiphy calling
>>> wiphy_apply_custom_regulatory.
>>
>> The real limit on ath9k comes from analyzing the CTLs from the EEPROM,
>> and using that as a max when a CTL is present. The value from cfg80211
>> is simply a local regulatory one, the CTLs take this one step further
>> and are calibration specific to help optimize performance on every
>> frequency range.
>
> Of course. My point was merely that the CTL-based calculations that
> ath9k does in ath9k_init_txpower_limits when it tries to set a better
> .max_power don’t even come out correctly, because they’re based on the
> initial values or on regdomain values. They’re not actually the
> hardware’s limits. I’m not even positive that there’s a single right
> “hardware transmit power limit per channel” value, unless you were to
> examine all of the possible rates and perhaps antenna configurations
> and other parameters. ath9k_init_txpower_limits doesn’t do this.
> That’s why I saw the patch restricting transmit power to be 20dBm even
> though the CTL data would allow higher power.

Well the final real power programmed is computed dynamically because
as you mentioned there are things to consider other than regulatory /
device limits to get a right power we need to use.

> In other words, I think babcbc295fee766ca710235e431686fef744d9a6 was wrong.

I'll need some time to review this again...

> Felix Fietkau wrote:
>> What I'm observing is that with the first regdomain setting it sets
>> orig_power to something that exceeds the tx power value that the
>> hardware is capable of using.
>
> But orig_mpwr is only supposed to be the maximum transmit power for
> the channel in the driver’s requested regulatory domain. It’s not
> supposed to have anything to do with the hardware.

Mark is correct, the device limit is also used as part of the dynamic
computation for what power you want to use, the upper boundary is this
hardware limit.

> If you can come up with a good way to compute the hardware maximum per
> channel (overcoming ath9k_init_txpower_limits’s current faults), then
> I think this can be accommodated with another field, but I don’t think
> orig_mpwr should be overloaded. Maybe renamed to better reflect its
> purpose, though.

I do wonder if the patch above introduced a regression I overlooked..

>> Because of that, the tx power setting reported to the user is wrong.
>
> I don’t think that a good way for a driver to reflect the transmit
> power it has actually put into effect (after taking the effects of CTL
> limits) back to user space currently exists.

What do you mean here, sorry I could not follow.

  Luis
