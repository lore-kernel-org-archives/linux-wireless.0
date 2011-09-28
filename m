Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2031 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1I1WHs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 18:07:48 -0400
Date: Wed, 28 Sep 2011 18:07:12 -0400
From: Pavel Roskin <proski@gnu.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org
Subject: Re: [RFT][PATCH] ath5k: Add rfkill_disable module parameter
Message-ID: <20110928180712.1436a185@mj> (sfid-20110929_000754_492943_47EB482E)
In-Reply-To: <20110919160124.GA3218@makis.lan>
References: <20110919160124.GA3218@makis.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 19 Sep 2011 19:01:24 +0300
Nick Kossifidis <mickflemm@gmail.com> wrote:

> Add a module parameter to disable hw rf kill (GPIO interrupt) because
> in some cases when the card doesn't come with the laptop, EEPROM
> configuration doesn't match laptop's configuration and rf kill
> interrupt always fires up and disables hw. I thought of moving this
> to debugfs and make it per-card but this way it's easier for users
> and distros to handle.
> 
> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Tested-by: Pavel Roskin <proski@.gnu.org>

Tested on 2 cards in Mikrotik RB-14 adapter.  One was OK without the
patch.  The other was shown as hard-blocked by rfkill and didn't work.
With the rfkill_disable=1, both cards work.  Soft rfkill is still
working properly.

Please consider a parameter name that indicates that only hard rfkill is
affected, for instance "no_hw_rfkill".

-- 
Regards,
Pavel Roskin
