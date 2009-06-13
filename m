Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60747 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZFMTlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 15:41:37 -0400
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
From: Marcel Holtmann <marcel@holtmann.org>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Pierre Ossman <pierre@ossman.eu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, san@google.com
In-Reply-To: <87bposnmxi.fsf@litku.valot.fi>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	 <1244685780-28930-8-git-send-email-me@bobcopeland.com>
	 <20090613132144.6c7783bc@mjolnir.ossman.eu> <87bposnmxi.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 21:41:37 +0200
Message-Id: <1244922097.1852.4.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> >> This adds the wl12xx_sdio module, enabling the SDIO interface for
> >> wl12xx, as used by the Google G1 phone and others.
> >> 
> >> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> >> ---
> >
> > I think the drivers looks quite ok. There are really just a few things
> > I'm concerned about:
> >
> 
> [...]
> 
> > - Why do you have a platform device with the sole purpose of enabling
> > power to the SDIO card? Shouldn't this be handled in the arch code?
> 
> wl1251 has these lines to the host:
> 
> o four lines for SDIO or SPI, configured to SDIO by default
> o power line
> o interrupt line
> 
> When the power line is pulled up, the chip will power on itself.
> Whenever the power line goes down, the chip will power off. For example,
> the power line can be controlled with a GPIO pin from the host. But how
> the power line is really controlled, is board specific and should be
> handled in the board file. And here comes the set_power() function to
> the picture. The wl1251 driver will call set_power() function every time
> user space calls wlan interface up or down.
> 
> Pierre, how do you propose we should do this? I understood based on
> discussions from linux-omap that this is a common way.

actually this looks like a RFKILL hard switch to me. Why don't we just
integrate it with RFKILL and this way have a common interface to handle
all of these.

Regards

Marcel


