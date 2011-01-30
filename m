Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46413 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1A3RBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 12:01:09 -0500
Received: by fxm20 with SMTP id 20so4877344fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 09:01:08 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 30 Jan 2011 12:01:08 -0500
Message-ID: <AANLkTi=4z31H+v2=Dve2FY3aw0iEBm5UQPz55Qx9UkwR@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix maximum tx power handling
From: Mark Mentovai <mark@moxienet.com>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> When setting a new regulatory domain after the initial one had
> been set by the driver, the original maximum power is
> overwritten with the new regulatory power value. This is wrong
> because chan->orig_mpwr is supposed to contain the hardware tx
> power limit.

I don’t think this is correct. In the existing code, chan->orig_mpwr
contains the channel’s maximum power in the driver’s requested
regulatory domain. There isn’t currently any field that’s used to
track the hardware limit.

The comment in net/wireless/reg.c explains the use of the orig_* fields:

		/*
		 * This gaurantees the driver's requested regulatory domain
		 * will always be used as a base for further regulatory
		 * settings
		 */

orig_flags and orig_mag track the values of flags and max_antenna_gain
for the driver’s requested regulatory domain in the same way that
orig_mpwr tracks max_power.

Your patch permits max_power to exceed the power level permitted in
the regulatory domain specified by the driver itself. This is contrary
to the design of the wireless regulatory framework. Values derived
from a driver hint must never be exceeded.

Your patch also doesn’t work properly for me using the ath9k driver.
With your patch, I wind up with an artificial power limit of 20dBm
across the board, although the hardware limit is actually 25dBm on the
AR9223 I’m testing with. This stems from the fact that ath9k doesn’t
know how to properly compute the hardware limit.
ath9k_init_txpower_limits is implemented on top of
ath9k_hw_set_txpowerlimit, which uses a channel’s current max_power
value as a basis for its computation. This means that it will either
use the hard-coded initial value of 20dBm from CHAN2G and CHAN5G in
drivers/net/wireless/ath/ath9k/init.c, or it will use world regulatory
domain values (also 20dBm) set by ath_regd_init_wiphy calling
wiphy_apply_custom_regulatory.

I don’t know if other drivers currently know how to properly compute
hardware power limits. I suspect that some (most?) also don’t.

I certainly like the idea of providing better feedback of the
effective power level, or even the power level limit, back to users.
This patch seems to artificially limit the effective power level in
some cases, while allowing a value in excess of what would be
appropriate in others.
