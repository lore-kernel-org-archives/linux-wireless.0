Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946544AbXBIPqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 10:46:33 -0500
Subject: Re: How to start with a Marvell driver (non-USB, non-OLPC)
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, marvell8385-devel@linuxtogo.org,
	frankh@marvell.com, rchokshi@marvell.com
In-Reply-To: <200702091524.52389.hs4233@mail.mn-solutions.de>
References: <200702090858.26294.hs4233@mail.mn-solutions.de>
	 <1171025367.2902.22.camel@localhost.localdomain>
	 <200702091524.52389.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 10:49:17 -0500
Message-Id: <1171036157.2774.15.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-02-09 at 15:24 +0100, Holger Schurig wrote:
> > > I think the biggest problem here is the firmware. The OLPC
> > > people have a special firmware for their USB dongle, which
> > > is not used in other chips, so a driver that has been
> > > heavily adapted to this firmware isn't easy to mangle to a
> > > different firmware.
> >
> > No, it really hasn't.  The mesh-specific bits are a separate
> > code path, and we routinely run non-mesh firmware using this
> > driver.  If there are places that are missing run-time
> > firmware version checks, then we need to fix those places.
> 
> In the libertas mailing list someone published the "WLAN Firmware 
> Spec v5.1" spec, so I guess that you're now using this firmware. 

Right; I think that was an inadvertent error on Ronak's part; but the
document is out there now and there's no way it can be taken back.

> But the Windows driver that I got hold on (to extract the 
> firmware) all had a 5.0 in their driver name, so I guess they 
> have a v5.0 firmware.

The WLAN Firmware document has a changelog at the end, so that might
give you the ability to figure out what pieces had been added to the
v5.1 firmware.

> But I guess this can be handled with if (fw_version >= 
> FW_VERSION_5_1) or something like this.

Exactly.  The v5.1 firmware is available on Marvell's site here; perhaps
it would work for you?  There's nothing really OLPC specific in this
particular firmware version AFAIK.  But it might be USB-only, I'm not
sure.  It would also be interesting figure out what the Boot2 firmware
version for your variant is.

http://marvell.com/drivers/driverDisplay.do?dId=160&pId=38

> > Again, why don't we work together?  We are _not_ intentionally
> > screwing over anybody else, and if there are pieces that you
> > need, why don't we put those pieces back in?
> 
> Based on the things you said, I see no reason NOT to work 
> together.

Ok, great.

> 
> > We are _not_ intentionally screwing over anybody else, and if
> > there are pieces that you need, why don't we put those pieces
> > back in?
> 
> I did not say this. I just saw in GIT that you remove misc things 
> or discussed the removed of things (e.g. CIS related code), so I 
> guessed that you only go into the USB dongle direction. But 
> maybe you weren't aware that other WLAN devices with similar 
> chips, but different host interface are available.

Right; we knew of the existence of the 8385 chip, but not much seemed to
be happening (nobody had touched the tree after an import of
libertas.git in a few weeks last I looked).  Plus arguing to keep the
ugly HAL code on the basis of future support for a chip which didn't
have any code yet doesn't fly as an argument upstream.

But that's OK, we should probably re-write the HAL bits anyway if we
need to.  AFAIK there was no CIS support really in the GPL drop from
Marvell; only the abstraction layer that would allow an if_cf.c to be
plugged in.  But trust me, it was _really_  hard to follow that code.

> > The original libertas hardware abstraction bits really sucked.
> 
> Did they release them as GPL as well?  Or do you refer to the 
> copyrighted driver that is downloadable from some vendors?

Yes, there were abstraction bits.  All the sbi_* functions were part of
the base hardware-independent layer, and the if_usb_* bits were
USB-specific.  But having a hardware abstraction layer that supported
only _one_ chip variant doesn't fly upstream, and we were asked to
remove it as a condition of merge.

> I'm already in libertas-dev, so when I have time to look at the 

And I or Marcelo should probably join 8385-devel or something too.  The
libertas-dev list hasn't been very active because only a few people are
working on it.  Who knows, if you have questions you might even get
Ronak to answer them by posting to libertas-dev :)  It might be worth a
shot.

> driver, I'll post some patches there. Rigth now I don't have 
> much, e.g. I just put the infrastructure in place so that the 
> PCMCIA subsystem detects the card and loads my driver.

Hey, that's a start.  I think the next step would be to figure out what
hardware-specific pieces need to be abstracted and to start rebuilding a
sane HAL, based on what other wireless drivers like airo & orinoco do
for the different variants (plx, pci, pcmcia, etc).

dan


