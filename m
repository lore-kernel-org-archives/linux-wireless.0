Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57154 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab3ATWbu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 17:31:50 -0500
Message-ID: <50FC704F.5010706@openwrt.org> (sfid-20130120_233153_885887_F80F9A11)
Date: Sun, 20 Jan 2013 23:31:43 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.8 2/3] ath9k_hw: fix chain swap setting when setting
 rx chainmask to 5
References: <1358715322-46447-1-git-send-email-nbd@openwrt.org> <1358715322-46447-2-git-send-email-nbd@openwrt.org> <CAJ-Vmontz33Fzx5_=D=LDFoWEkmWSO5iku3aiv5S+gQJCDD3og@mail.gmail.com>
In-Reply-To: <CAJ-Vmontz33Fzx5_=D=LDFoWEkmWSO5iku3aiv5S+gQJCDD3og@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-01-20 11:05 PM, Adrian Chadd wrote:
> Hiya,
> 
> What's the motivation behind this?
> 
> The reason why the PHY analog swapping is done when the chainmask set
> to 0x5 is because pre-AR9280 chips didn't support arbitrary chainmask
> configurations for TX.
> So it could either be 0x1, 0x3, or 0x7.
>
> The AR5416 2-TX 3-TX reference design has TX antenna on chain 0 and 2
> (hence 0x5, as you know), so:
> 
> * One should never be allowed to configure a TX chainmask enabling
> chain 1, as that plain won't work (there's no actual TX bits on the
> card itself; it only has the RX related switch/amp/etc);
> * If the chainmask is set to 0x3 or 0x5 on a device that has 3 TX
> chains (ie, anything AR93xx and later with 3 chains and 3 TX capable
> switches/amplifiers on the NIC itself) then _strictly speaking_ I
> don't think it's necessary to do the analog swap, but that's when
> you'd do it.
The analog swapping was already there, I just changed it from being
enabled based on the runtime chainmask to being enabled based on the
EEPROM chainmask. I don't know if the analog swapping is still necessary
or not, but I think it should not be enabled on a 3x3 card when
disabling chain 1.

> The AR9130 and AR9160 have the same limitation. The AR9280 and later
> don't, but the AR92xx chips are one or two chain, so this doesn't
> (strictly speaking) need to happen.
> 
> For FreeBSD, I'm going to add code to enforce that the configured
> chainmask doesn't conflict with the EEPROM chainmask, in case people
> try to do stupid things.
The code in ath9k already does that when it calculates the runtime
chainmask from the user's antenna selection, the user does not set the
chainmask directly.

- Felix
