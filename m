Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46469 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbcDFNb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 09:31:56 -0400
Date: Wed, 6 Apr 2016 08:31:51 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: Lukas Wunner <lukas@wunner.de>, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160406133151.GA4976@localhost> (sfid-20160406_153201_591192_90A7E986)
References: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
 <20160405194015.GC15353@localhost>
 <20160405214945.1214e13b@wiggum>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20160405214945.1214e13b@wiggum>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 05, 2016 at 09:49:45PM +0200, Michael Büsch wrote:
> On Tue, 5 Apr 2016 14:40:15 -0500
> Bjorn Helgaas <helgaas@kernel.org> wrote:
> 
> > [+cc Matthew]
> > 
> > Hi Lukas,
> > 
> > On Tue, Mar 29, 2016 at 08:20:30PM +0200, Lukas Wunner wrote:
> > > Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ storm
> > > on boot until they are reset, causing spurious interrupts if the IRQ is
> > > shared. Apparently the EFI bootloader enables the device and does not
> > > disable it before passing control to the OS. The bootloader contains a
> > > driver for the wireless card which allows it to phone home to Cupertino.
> > > This is used for Internet Recovery (download and install OS X images)
> > > and probably also for Back to My Mac (remote access, RFC 6281) and to
> > > discover stolen hardware.
> > > 
> > > The issue is most pronounced on 2011 and 2012 MacBook Pros where the IRQ
> > > is shared with 3 other devices (Light Ridge Thunderbolt controller, SDXC
> > > reader, HDA card on discrete GPU). As soon as an interrupt handler is
> > > installed for one of these devices, the ensuing storm of spurious IRQs
> > > causes the kernel to disable the IRQ and switch to polling. This lasts
> > > until the b43 driver loads and resets the device.
> > > 
> > > Loading the b43 driver first is not always an option, in particular with
> > > the Light Ridge Thunderbolt controller: The PCI hotplug IRQ handler gets
> > > installed early on because it is built in, unlike b43 which is usually
> > > a module.
> > > 
> > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79301
> > > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=895951
> > > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1009819
> > > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1149632
> > > Tested-by: Lukas Wunner <lukas@wunner.de> [MacBookPro9,1]
> > > Signed-off-by: Lukas Wunner <lukas@wunner.de>
> > > ---
> > >  drivers/bcma/bcma_private.h |  2 --
> > >  drivers/pci/quirks.c        | 27 +++++++++++++++++++++++++++
> > >  include/linux/bcma/bcma.h   |  1 +
> > >  3 files changed, 28 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
> > > index eda0909..f642c42 100644
> > > --- a/drivers/bcma/bcma_private.h
> > > +++ b/drivers/bcma/bcma_private.h
> > > @@ -8,8 +8,6 @@
> > >  #include <linux/bcma/bcma.h>
> > >  #include <linux/delay.h>
> > >  
> > > -#define BCMA_CORE_SIZE		0x1000
> > > -
> > >  #define bcma_err(bus, fmt, ...) \
> > >  	pr_err("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
> > >  #define bcma_warn(bus, fmt, ...) \
> > > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > > index 8e67802..d4fb5ee 100644
> > > --- a/drivers/pci/quirks.c
> > > +++ b/drivers/pci/quirks.c
> > > @@ -25,6 +25,8 @@
> > >  #include <linux/sched.h>
> > >  #include <linux/ktime.h>
> > >  #include <linux/mm.h>
> > > +#include <linux/bcma/bcma.h>
> > > +#include <linux/bcma/bcma_regs.h>
> > >  #include <asm/dma.h>	/* isa_dma_bridge_buggy */
> > >  #include "pci.h"
> > >  
> > > @@ -3282,6 +3284,31 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL, 0x156d,
> > >  			       quirk_apple_wait_for_thunderbolt);
> > >  #endif
> > >  
> > > +/*
> > > + * Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ storm
> > > + * on boot until they are reset, causing spurious interrupts if the IRQ is
> > > + * shared. Apparently the EFI bootloader enables the device to phone home
> > > + * to Cupertino and does not disable it before passing control to the OS.
> > > + */
> > > +static void quirk_apple_b43_reset(struct pci_dev *dev)
> > > +{
> > > +	void __iomem *mmio;
> > > +
> > > +	if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc.") || !dev->bus->self ||
> > > +	    pci_pcie_type(dev->bus->self) != PCI_EXP_TYPE_ROOT_PORT)
> > > +		return;
> > > +
> > > +	mmio = pci_iomap(dev, 0, 0);
> > > +	if (!mmio) {
> > > +		pr_err("b43 quirk: Cannot iomap device, IRQ storm ahead\n");
> > > +		return;
> > > +	}
> > > +	iowrite32(BCMA_RESET_CTL_RESET,
> > > +		  mmio + (1 * BCMA_CORE_SIZE) + BCMA_RESET_CTL);
> > > +	pci_iounmap(dev, mmio);  
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=111781 and
> > https://mjg59.dreamwidth.org/11235.html describe a sort of similar
> > issue, but with DMA.  An interrupt from the device is probably to
> > signal a DMA completion, but these problem reports only mention the
> > "IRQ nobody cared" issue; I don't see anything about memory
> > corruption.
> > 
> > If this resets the device, I guess that should prevent future DMA as
> > well as future interrupts.  Would pci_reset_function() do the same
> > thing in a more generic way?
> > 
> > I'm a little bit hesitant to put a quirk like this in Linux because
> > it's only a 90% solution.  If the only problem is the interrupts, it's
> > probably OK since a few extra interrupts doesn't hurt anything.  But
> > if there is also DMA that might corrupt something, a 90% solution just
> > makes it harder to debug for the remaining 10%.
> 
> This was already discussed in this thread.
> 
> It is not a 90% solution. It fixes the IRQ issue. It is not supposed to
> fix the DMA issue. And it can't. It does mitigate it a tiny bit though.

Even for interrupts, it's only a 90% solution because we do still get
a few interrupts before the quirk runs.  There may not be enough to
trigger the "IRQ nobody cared" check, but that check is based on an
arbitrary number that happens to be more than the number of interrupts
we see, so it's basically still a race.  But as I said, if interrupts
are the *only* problem, this is probably OK.

DMA is a bigger problem.  If there is a DMA issue, I don't want to fix
part of it.  If there is no DMA issue, I'd like to know how we *know*
there's no issue, and why we're still seeing interrupts with no DMA.
If there's a separate fix for the DMA issue, I'd like to know why we
can't fix the interrupt issue the same place we fixed the DMA issue.

Bjorn
