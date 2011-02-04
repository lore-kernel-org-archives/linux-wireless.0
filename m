Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57506 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab1BDUAf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 15:00:35 -0500
Message-ID: <4D4C5AE1.7090803@openwrt.org>
Date: Fri, 04 Feb 2011 21:00:33 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mark Mentovai <mark@moxienet.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: fix maximum tx power handling
References: <AANLkTi=4z31H+v2=Dve2FY3aw0iEBm5UQPz55Qx9UkwR@mail.gmail.com>	<AANLkTikNUv2VuL8ftQAF_x4R-ccB0Y_aPFFdF52UBnBt@mail.gmail.com> <AANLkTikxhPHQ_50cKoJn920n9A0hVssoZZfJRCsw=CH+@mail.gmail.com>
In-Reply-To: <AANLkTikxhPHQ_50cKoJn920n9A0hVssoZZfJRCsw=CH+@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-04 8:42 PM, Mark Mentovai wrote:
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
> “hardware transmit power limit per channel” value, unless you were to
> examine all of the possible rates and perhaps antenna configurations
> and other parameters. ath9k_init_txpower_limits doesn’t do this.
> That’s why I saw the patch restricting transmit power to be 20dBm even
> though the CTL data would allow higher power.
> 
> In other words, I think babcbc295fee766ca710235e431686fef744d9a6 was wrong.
Right, for testing the tx power, we need to override the
twiceMaxRegulatoryPower parameter that we pass to the set_txpower op.

Additionally, we could examine more rates, but I haven't seen any card
where higher rates have a higher tx power setting that lower rates. I
think Atheros internally also uses the tx power setting for the lowest rate.

Other than the different rates, I don't think you need to examine more
configurations. The power increase by using multiple chains is already
added to the max tx power value.

- Felix
