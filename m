Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45926 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933081AbcDETkW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 15:40:22 -0400
Date: Tue, 5 Apr 2016 14:40:15 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	zajec5@gmail.com, b43-dev@lists.infradead.org,
	Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160405194015.GC15353@localhost> (sfid-20160405_214026_829135_8DEDF4CE)
References: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[+cc Matthew]

Hi Lukas,

On Tue, Mar 29, 2016 at 08:20:30PM +0200, Lukas Wunner wrote:
> Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ storm
> on boot until they are reset, causing spurious interrupts if the IRQ is
> shared. Apparently the EFI bootloader enables the device and does not
> disable it before passing control to the OS. The bootloader contains a
> driver for the wireless card which allows it to phone home to Cupertino.
> This is used for Internet Recovery (download and install OS X images)
> and probably also for Back to My Mac (remote access, RFC 6281) and to
> discover stolen hardware.
> 
> The issue is most pronounced on 2011 and 2012 MacBook Pros where the IRQ
> is shared with 3 other devices (Light Ridge Thunderbolt controller, SDXC
> reader, HDA card on discrete GPU). As soon as an interrupt handler is
> installed for one of these devices, the ensuing storm of spurious IRQs
> causes the kernel to disable the IRQ and switch to polling. This lasts
> until the b43 driver loads and resets the device.
> 
> Loading the b43 driver first is not always an option, in particular with
> the Light Ridge Thunderbolt controller: The PCI hotplug IRQ handler gets
> installed early on because it is built in, unlike b43 which is usually
> a module.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79301
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=895951
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1009819
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1149632
> Tested-by: Lukas Wunner <lukas@wunner.de> [MacBookPro9,1]
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  drivers/bcma/bcma_private.h |  2 --
>  drivers/pci/quirks.c        | 27 +++++++++++++++++++++++++++
>  include/linux/bcma/bcma.h   |  1 +
>  3 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
> index eda0909..f642c42 100644
> --- a/drivers/bcma/bcma_private.h
> +++ b/drivers/bcma/bcma_private.h
> @@ -8,8 +8,6 @@
>  #include <linux/bcma/bcma.h>
>  #include <linux/delay.h>
>  
> -#define BCMA_CORE_SIZE		0x1000
> -
>  #define bcma_err(bus, fmt, ...) \
>  	pr_err("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
>  #define bcma_warn(bus, fmt, ...) \
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 8e67802..d4fb5ee 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -25,6 +25,8 @@
>  #include <linux/sched.h>
>  #include <linux/ktime.h>
>  #include <linux/mm.h>
> +#include <linux/bcma/bcma.h>
> +#include <linux/bcma/bcma_regs.h>
>  #include <asm/dma.h>	/* isa_dma_bridge_buggy */
>  #include "pci.h"
>  
> @@ -3282,6 +3284,31 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL, 0x156d,
>  			       quirk_apple_wait_for_thunderbolt);
>  #endif
>  
> +/*
> + * Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ storm
> + * on boot until they are reset, causing spurious interrupts if the IRQ is
> + * shared. Apparently the EFI bootloader enables the device to phone home
> + * to Cupertino and does not disable it before passing control to the OS.
> + */
> +static void quirk_apple_b43_reset(struct pci_dev *dev)
> +{
> +	void __iomem *mmio;
> +
> +	if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc.") || !dev->bus->self ||
> +	    pci_pcie_type(dev->bus->self) != PCI_EXP_TYPE_ROOT_PORT)
> +		return;
> +
> +	mmio = pci_iomap(dev, 0, 0);
> +	if (!mmio) {
> +		pr_err("b43 quirk: Cannot iomap device, IRQ storm ahead\n");
> +		return;
> +	}
> +	iowrite32(BCMA_RESET_CTL_RESET,
> +		  mmio + (1 * BCMA_CORE_SIZE) + BCMA_RESET_CTL);
> +	pci_iounmap(dev, mmio);

https://bugzilla.kernel.org/show_bug.cgi?id=111781 and
https://mjg59.dreamwidth.org/11235.html describe a sort of similar
issue, but with DMA.  An interrupt from the device is probably to
signal a DMA completion, but these problem reports only mention the
"IRQ nobody cared" issue; I don't see anything about memory
corruption.

If this resets the device, I guess that should prevent future DMA as
well as future interrupts.  Would pci_reset_function() do the same
thing in a more generic way?

I'm a little bit hesitant to put a quirk like this in Linux because
it's only a 90% solution.  If the only problem is the interrupts, it's
probably OK since a few extra interrupts doesn't hurt anything.  But
if there is also DMA that might corrupt something, a 90% solution just
makes it harder to debug for the remaining 10%.

> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM, 0x4331, quirk_apple_b43_reset);
> +
>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
>  			  struct pci_fixup *end)
>  {
> diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
> index 0367c63..5c37b58 100644
> --- a/include/linux/bcma/bcma.h
> +++ b/include/linux/bcma/bcma.h
> @@ -158,6 +158,7 @@ struct bcma_host_ops {
>  #define BCMA_CORE_DEFAULT		0xFFF
>  
>  #define BCMA_MAX_NR_CORES		16
> +#define BCMA_CORE_SIZE			0x1000
>  
>  /* Chip IDs of PCIe devices */
>  #define BCMA_CHIP_ID_BCM4313	0x4313
> -- 
> 2.8.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
