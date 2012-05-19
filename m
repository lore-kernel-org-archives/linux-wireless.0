Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:44145 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab2ESJku (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 05:40:50 -0400
Message-ID: <4FB769DF.5060400@01019freenet.de> (sfid-20120519_114054_517741_D7DB7510)
Date: Sat, 19 May 2012 11:37:35 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Tobias Diedrich <ranma@tdiedrich.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Hong Wu <Hong.Wu@dspg.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
 respectively
References: <20120517230400.GB22418@yumi.tdiedrich.de> <CAGXE3d_Yz=-UWO+PiJkRQ7ZSBgh_fdcwsPz6FCig2VjOOoMQOg@mail.gmail.com> <20120518162158.GE22418@yumi.tdiedrich.de> <CAGXE3d8e+hYo_MT30XUW+r4-Dq6AgqLTJxD_oGnRuR94zjZ7_Q@mail.gmail.com>
In-Reply-To: <CAGXE3d8e+hYo_MT30XUW+r4-Dq6AgqLTJxD_oGnRuR94zjZ7_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa wrote:
> On Fri, May 18, 2012 at 6:21 PM, Tobias Diedrich <ranma@tdiedrich.de> wrote:
>>> So, maybe we should do it the safe way and just register a safe default
>>> of 20dBm for all channels?
>>
>> AFAIU that would cap you to 20dBm even if you are in a country that
>> has higher limits (e.g. 27dBm in the US?).
> 
> Not necessarily because the driver won't allow tx power adjustments at all
> if EEPROM_EIRP_MAX_TX_POWER is unused.

This means:
Tx settings in cfg80211 as given by "iw reg get" e.g. are ignored
completely as long as EEPROM_EIRP_MAX_TX_POWER is unused.
Thus it is more or less chance that the device actually uses the allowed
/ correct Tx power at all. Maybe it's too high or too low. Both would be
bad.

> For these devices we cannot rely on the tx power output at all and maybe
> it makes sense to register a max power of 0 just to tell mac80211/cfg80211
> that no tx power adjustments are possible on these devices?

Hmmm, this sounds really strange. How can I see if a device uses
EEPROM_EIRP_MAX_TX_POWER at all?
It would be good to have a log entry, telling the user that the Tx power
of the device can't be adjusted at all and therefore it is possible,
that the operation of the device might be illegal in the current country
even if cfg80211 is set correctly.


Is it done the same way by the legacy driver?


Thanks,
kind regards,
Andreas
