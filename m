Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:34769 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab0GGOzS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 10:55:18 -0400
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'Nicolas Pitre'" <nico@fluxnic.net>,
	"'Roger Quadros'" <roger.quadros@nokia.com>
Cc: "'Hunter Adrian \(Nokia-MS/Helsinki\)'" <adrian.hunter@nokia.com>,
	"'Ohad Ben-Cohen'" <ohad@wizery.com>,
	<linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	"'Coelho Luciano \(Nokia-MS/Helsinki\)'" <Luciano.Coelho@nokia.com>,
	<akpm@linux-foundation.org>, "'San Mehat'" <san@google.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com> <1278376666-3509-12-git-send-email-ohad@wizery.com> <4C32EF19.1000604@nokia.com> <AANLkTintIz-N7MwwtqhVq2LR3Ln5JTNYSbJUBSSClcA-@mail.gmail.com> <4C3306F4.8060907@nokia.com> <AANLkTin5W52fPzWToRrAzm56SLZI-taSuI16rCEhLWqH@mail.gmail.com> <4C333E0D.2070601@nokia.com> <alpine.LFD.2.00.1007061316010.6020@xanadu.home> <4C338927.5020400@nokia.com> <4C34347F.8030000@nokia.com> <alpine.LFD.2.00.1007070954010.6020@xanadu.home>
Subject: RE: [PATCH 11/15] wireless: wl1271: introduce platform device support
Date: Wed, 7 Jul 2010 09:54:08 -0500
Message-ID: <E6AFC02D8D114C129C8140932818E578@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-reply-to: <alpine.LFD.2.00.1007070954010.6020@xanadu.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Nicolas Pitre [mailto:nico@fluxnic.net]
> Sent: Wednesday, July 07, 2010 9:03 AM
> To: Roger Quadros
> Cc: Hunter Adrian (Nokia-MS/Helsinki); Ohad Ben-Cohen; linux-
> wireless@vger.kernel.org; linux-mmc@vger.kernel.org; linux-
> omap@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linux@arm.linux.org.uk; Chikkature Rajashekar Madhusudhan; Coelho Luciano
> (Nokia-MS/Helsinki); akpm@linux-foundation.org; San Mehat
> Subject: Re: [PATCH 11/15] wireless: wl1271: introduce platform device
> support
> 
> On Wed, 7 Jul 2010, Roger Quadros wrote:
> 
> > On 07/06/2010 10:51 PM, Hunter Adrian (Nokia-MS/Helsinki) wrote:
> > > For eMMC in omap_hsmmc, this is all done via claim_host / release_host
> > > which call ->enable() / ->disable() methods.  omap_hsmmc makes use of
> > > mmc_power_restore_host() which calls host->bus_ops->power_restore()
> > > which is not implemented for SDIO, but for MMC and SD it reinitializes
> > > the card.
> 
> This is IMHO a really bad design.  The power control decision has to
> come from the top, not from the bottom.  And certainly not with a
> U-turn dependency the omap_hsmmc is using.
> 
> I regret to say this, but the omap_hsmmc driver is becoming a total
> mess.  The host controller driver has to be a dumb interface serving
> requests from the hardware used by the upper layer stack, not the place
> where decisions such as power handling should be made.  Think of it like
> an ethernet driver.  No ethernet driver in Linux is telling the IP stack
> when to shut down.
> 

The point is that MMC/SD core files were patched to provide this kind of a
support. Any controller driver can use that framework today, right?. As an
example omap_hsmmc driver was patched and it works fine.

Why blame the controller driver for using a support provided by core files?

Regards,
Madhu

> > Shouldn't the power control intelligence (i.e. when to turn power
> ON/OFF) lie
> > with the bus drivers?
> 
> Absolutely!  And in the SDIO case that should lie with each function
> drivers.  Please let's stop this omap_hsmmc madness.
> 
> 
> Nicolas

