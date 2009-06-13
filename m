Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2518 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZFMU6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 16:58:17 -0400
Date: Sat, 13 Jun 2009 16:57:37 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
Message-ID: <20090613205737.GA30439@hash.localnet>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com> <1244685780-28930-8-git-send-email-me@bobcopeland.com> <20090613132144.6c7783bc@mjolnir.ossman.eu> <87bposnmxi.fsf@litku.valot.fi> <20090613220908.271865cd@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090613220908.271865cd@mjolnir.ossman.eu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 13, 2009 at 10:09:08PM +0200, Pierre Ossman wrote:
> On Sat, 13 Jun 2009 19:00:41 +0300
> Kalle Valo <kalle.valo@iki.fi> wrote:
> 
> That doesn't make sense. If the card doesn't have power then there will
> be no device and no interface to bring up.

For SPI, you would register the platform driver with the SPI subsystem,
which gives you the ability to call the set_power callback at any time.
There's not a problem starting the driver if there is no device (as I
understand it, SPI is so simple there's no way to probe the bus anyway).

It would be nice to allow the SDIO driver to similarly invoke the
platform->set_power() callback at interface up/down time (that's why
there's wl12xx_sdio_set_power() which does nothing right now).  However,
then the device will disappear from the bus...

> +	wifi_ctrl->set_power(1);	/* Power On */

Except for the problems outlined above, this would be invoked from
wl12xx_sdio_set_power().  But without it being up at start, probe()
won't work anyway.  So it sounds like wl12xx_sdio_set_power() will
have to be a no-op for sdio devices unless there's some register
we can poke on the chip to put it to sleep.

> I think this should be somewhere under arch/ in the board setup code,
> where currently you have some code adding the "msm_wifi" platform
> device.

Yeah, in fact I tried that a while ago but something didn't work right,
some ordering issue perhaps.  I'll try again.

-- 
Bob Copeland %% www.bobcopeland.com

