Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:16366 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab0GGOCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 10:02:43 -0400
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 07 Jul 2010 10:02:42 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Roger Quadros <roger.quadros@nokia.com>
Cc: "Hunter Adrian (Nokia-MS/Helsinki)" <adrian.hunter@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
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
In-reply-to: <4C34347F.8030000@nokia.com>
Message-id: <alpine.LFD.2.00.1007070954010.6020@xanadu.home>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
 <1278376666-3509-12-git-send-email-ohad@wizery.com>
 <4C32EF19.1000604@nokia.com>
 <AANLkTintIz-N7MwwtqhVq2LR3Ln5JTNYSbJUBSSClcA-@mail.gmail.com>
 <4C3306F4.8060907@nokia.com>
 <AANLkTin5W52fPzWToRrAzm56SLZI-taSuI16rCEhLWqH@mail.gmail.com>
 <4C333E0D.2070601@nokia.com> <alpine.LFD.2.00.1007061316010.6020@xanadu.home>
 <4C338927.5020400@nokia.com> <4C34347F.8030000@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 7 Jul 2010, Roger Quadros wrote:

> On 07/06/2010 10:51 PM, Hunter Adrian (Nokia-MS/Helsinki) wrote:
> > For eMMC in omap_hsmmc, this is all done via claim_host / release_host
> > which call ->enable() / ->disable() methods.  omap_hsmmc makes use of
> > mmc_power_restore_host() which calls host->bus_ops->power_restore()
> > which is not implemented for SDIO, but for MMC and SD it reinitializes
> > the card.

This is IMHO a really bad design.  The power control decision has to 
come from the top, not from the bottom.  And certainly not with a 
U-turn dependency the omap_hsmmc is using.

I regret to say this, but the omap_hsmmc driver is becoming a total 
mess.  The host controller driver has to be a dumb interface serving 
requests from the hardware used by the upper layer stack, not the place 
where decisions such as power handling should be made.  Think of it like 
an ethernet driver.  No ethernet driver in Linux is telling the IP stack 
when to shut down.

> Shouldn't the power control intelligence (i.e. when to turn power ON/OFF) lie
> with the bus drivers?

Absolutely!  And in the SDIO case that should lie with each function 
drivers.  Please let's stop this omap_hsmmc madness.


Nicolas
