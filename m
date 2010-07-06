Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:61926 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0GFRAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 13:00:13 -0400
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 06 Jul 2010 13:00:11 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Madhusudhan <madhu.cr@ti.com>
Cc: 'Ohad Ben-Cohen' <ohad@wizery.com>, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
	'Luciano Coelho' <luciano.coelho@nokia.com>,
	'Andrew Morton' <akpm@linux-foundation.org>,
	'San Mehat' <san@google.com>,
	"'Pandita, Vikram'" <vikram.pandita@ti.com>
Subject: RE: [PATCH 05/15] omap: hsmmc: add virtual card detect support
In-reply-to: <822D79B5C25543B1A6F148B39E061459@am.dhcp.ti.com>
Message-id: <alpine.LFD.2.00.1007061249280.6020@xanadu.home>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
 <1278376666-3509-6-git-send-email-ohad@wizery.com>
 <alpine.LFD.2.00.1007052134460.6020@xanadu.home>
 <AANLkTim4E4LlFERmfYA1M0HLBOoRAsQuvdW6QBNu6pC0@mail.gmail.com>
 <AANLkTinE5LygUWJsJSEE2miZF1GK58LTr8zErkuu_7yM@mail.gmail.com>
 <822D79B5C25543B1A6F148B39E061459@am.dhcp.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 6 Jul 2010, Madhusudhan wrote:

> 
> 
> > -----Original Message-----
> > From: Ohad Ben-Cohen [mailto:ohad@wizery.com]
> > Sent: Tuesday, July 06, 2010 6:48 AM
> > To: Nicolas Pitre
> > Cc: linux-wireless@vger.kernel.org; linux-mmc@vger.kernel.org; linux-
> > omap@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> > linux@arm.linux.org.uk; Chikkature Rajashekar Madhusudhan; Luciano Coelho;
> > Andrew Morton; San Mehat; Pandita, Vikram
> > Subject: Re: [PATCH 05/15] omap: hsmmc: add virtual card detect support
> > 
> > On Tue, Jul 6, 2010 at 1:22 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > > Note: the wl1271 device does support standard card detection, but
> > > AFAIK there's a limitation to use that with the specific omap
> > > controller the device is hardwired to. I will try to get more info
> > > about that, but probably Madhu can comment on that better.
> > 
> > 
> > Some correction and additional info:
> > 
> > The wl1271 device has an issue which makes the standard card detect
> > mechanism irrelevant: it is always up, even if the power enable gpio
> > input of the device is down (the power enable input does not supply
> > the power to the chip, it's just logical digital high/low input upon
> > which the device reacts).  That's why we must use software control for
> > emulating card detect with that device.
> > 
> > In addition, as far as I could find out, the card detect mechanism on
> > the ZOOM is implemented by mechanical means, and thus is not relevant
> > for hardwired embedded SDIO devices (I'm not even sure card detect is
> > supported for the 3rd mmc controller).
> 
> The card detect is supported through T2 GPIO interrupts only for MMC1 and
> MMC2. Such a mechanism is not present for MMC3 to which the WLAN chip is
> hardwired.

Many existing implementations simply have no (or a broken) card 
detection signal.  In that case, either the host controller passes the 
MMC_CAP_NEEDS_POLL flag to the core so that the bus is probed on a 
regular interval for card presence.  Or, like in this case where the 
"card" is always hardwired on the board, you simply rely on the initial 
probe which is always performed at least once when the host controller 
driver is registered.

Now the issue of having the card powered off when not in use is a valid 
one, whether or not it is actually hardwired on the board or 
hot insertable/removable.  This fake insertion thing is not the best way 
to go about it.

It would be way more useful, generic, and less hackish to simply improve 
the generic code so to power down the card when it is 1) not claimed by 
any function driver, and 2) provide an API to let a function driver 
signify to the core and host controller that it is not interested by the 
hardware at the moment (if the network interface is not up for example) 
and therefore the core could again power down the card.  This would work 
in all cases with no need for exceptions  for so called "enbedded 
controllers".


Nicolas
