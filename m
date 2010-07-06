Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:59601 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab0GFRmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 13:42:37 -0400
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 06 Jul 2010 13:42:26 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Roger Quadros <roger.quadros@nokia.com>
Cc: ext Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>
Subject: Re: [PATCH 11/15] wireless: wl1271: introduce platform device support
In-reply-to: <4C333E0D.2070601@nokia.com>
Message-id: <alpine.LFD.2.00.1007061316010.6020@xanadu.home>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
 <1278376666-3509-12-git-send-email-ohad@wizery.com>
 <4C32EF19.1000604@nokia.com>
 <AANLkTintIz-N7MwwtqhVq2LR3Ln5JTNYSbJUBSSClcA-@mail.gmail.com>
 <4C3306F4.8060907@nokia.com>
 <AANLkTin5W52fPzWToRrAzm56SLZI-taSuI16rCEhLWqH@mail.gmail.com>
 <4C333E0D.2070601@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 6 Jul 2010, Roger Quadros wrote:

> On 07/06/2010 03:53 PM, ext Ohad Ben-Cohen wrote:
> > Hi Roger,
> > 
> > On Tue, Jul 6, 2010 at 1:35 PM, Roger Quadros<roger.quadros@nokia.com>
> > wrote:
> > > My point is that shouldn't this be handled by SDIO core?
> > 
> > Care to explain what you mean / give a code example ?
> 
> If the Power enable GPIO can be treated as SDIO slot supply (i.e. vmmc), then
> the SDIO/MMC core should tackle it, just like it deals with supply for slots
> with removable cards.

Exact.

> > You need card detect events in order to trigger card&  sdio function
> > initialization and removals.

Why would you trigger function initialization and removal?  Just to turn 
off power?  That's a bit like pulling off the battery from your laptop 
when you want to suspend it.  There is a better way to go about things.

> > Please share any alternative approach you may be thinking on.
> 
> OK, this is how I see it.
> 
> - Treat the non-removable card as non-removable. So no need to do card detect
> emulation.
> 
> - Treat the GPIO power enable on wl1271 as VMMC supply. Use fixed regulator
> framework to define this regulator & supply. Even though you mention that it
> is not actually a supply, it fits well in the fixed supply framework.
> 
> - When the host controller is enumerated, the mmc core will power up the slot,
> find the sdio card, and probe the function driver (i.e. wl1271_sdio).
> 
> - if interface is not in use, the function driver must release the sdio host,
> and this should eventually disable the vmmc supply.
> 
> - Whenever the wlan interface must be brought up, wl1271_sdio, can claim the
> sdio host. this will cause the vmmc supply to be enabled, for as long as the
> interface is up.
> 
> Does this address all issues?

This is mostly all good, except that claiming/releasing the SDIO host is 
about access to the bus.  It must be claimed right before doing any IO, 
and released right after that, even when the card is expected to remain 
powered.  This is not the proper place to hook power control.

Another function pair would be needed instead, which would do almost 
like the suspend/resume code is already doing.  Something like:

/*
 * Indicate to the core SDIO layer that we're not requiring that the
 * function remain powered.  If all functions for the card are in the 
 * same "no power" state, then the host controller can remove power from
 * the card.  Note: the function driver must preserve hardware states if
 * necessary.
 */
int sdio_release_power(struct sdio_func *func);

/*
 * Indicate to the core SDIO layer that we want power back for this
 * SDIO function.  The power may or may not actually have been removed
 * since last call to sdio_release_power(), so the function driver must 
 * not assume any preserved state at the hardware level and re-perform
 * all the necessary hardware config.  This function returns 0 when
 * power is actually restored, or some error code if this cannot be 
 * achieved.  One error reason might be that the card is no longer 
 * available on the bus (was removed while powered down and card 
 * detection didn't trigger yet).
 */
int sdio_claim_power(struct sdio_func *func);

That's it.  When the network interface is down and the hardware is not 
needed, you call sdio_release_power().  When the request to activate the 
network interface is received, you call sdio_claim_power() and configure 
the hardware appropriately.  If sdio_claim_power() returns an error, 
then you just return an error to the network request, and eventually the 
driver's remove method will be called if this is indeed because the card 
was removed.

In the core SDIO code, this is almost identical to a suspend/resume 
request, except that the request comes from the function driver instead 
of the core MMC code.


Nicolas
