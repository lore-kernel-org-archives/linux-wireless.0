Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:57354 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaGFMTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 08:19:11 -0400
Message-ID: <53B93EBC.7010107@broadcom.com> (sfid-20140706_141925_618207_337F1B79)
Date: Sun, 6 Jul 2014 14:19:08 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
CC: <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] bcma: support for PCIe Gen 2 as host platform
References: <1404645103-26100-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1404645103-26100-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06-07-14 13:11, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> I got reply from Bjorn, that we should *not* depend on PCI_EXP_LNKCAP:
> http://marc.info/?l=linux-pci&m=140457671930896&w=2
> 
> So the change since RFC is adding a list of PCIe 1.0 and 2.0 devices.
> Use PCI_EXP_LNKCAP only as a fallback, in case someone tries sth like:
> echo "14e4 4360" > /sys/bus/pci/drivers/bcma-pci-bridge/new_id

Do you have to know this before or after enumerating the cores? They
have a different core id, right?

Regards,
Arend

> ---
>  drivers/bcma/host_pci.c        | 32 ++++++++++++++++++++++++++++++--
>  include/linux/bcma/bcma.h      |  1 +
>  include/linux/bcma/bcma_regs.h |  2 ++
>  3 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
> index e3333053..df20a50 100644
> --- a/drivers/bcma/host_pci.c
> +++ b/drivers/bcma/host_pci.c
> @@ -13,10 +13,12 @@
>  
>  static void bcma_host_pci_switch_core(struct bcma_device *core)
>  {
> +	int win2 = core->bus->host_is_pcie2 ?
> +		BCMA_PCIE2_BAR0_WIN2 : BCMA_PCI_BAR0_WIN2;
> +
>  	pci_write_config_dword(core->bus->host_pci, BCMA_PCI_BAR0_WIN,
>  			       core->addr);
> -	pci_write_config_dword(core->bus->host_pci, BCMA_PCI_BAR0_WIN2,
> -			       core->wrap);
> +	pci_write_config_dword(core->bus->host_pci, win2, core->wrap);
>  	core->bus->mapped_core = core;
>  	bcma_debug(core->bus, "Switched to core: 0x%X\n", core->id.id);
>  }
> @@ -194,6 +196,32 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
>  		goto err_pci_release_regions;
>  	}
>  
> +	/* PCIe Gen 2 has some regs different */
> +	switch (dev->device) {
> +	case 0x0576:
> +	case 0x4313:
> +	case 43224:
> +	case 0x4331:
> +	case 0x4353:
> +	case 0x4357:
> +	case 0x4358:
> +	case 0x4359:
> +	case 0x4365:
> +	case 0x4727:
> +		bus->host_is_pcie2 = false;
> +		break;
> +	case 0x4360:
> +	case 0x43a0:
> +	case 0x43b1:
> +		bus->host_is_pcie2 = true;
> +		break;
> +	default:
> +		/* Fallback, e.g. if someone uses bcma-pci-bridge/new_id */
> +		pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &val);
> +		bus->host_is_pcie2 = !!(val & PCI_EXP_LNKCAP_SLS_5_0GB);
> +		break;
> +	}
> +
>  	/* Map MMIO */
>  	err = -ENOMEM;
>  	bus->mmio = pci_iomap(dev, 0, ~0UL);
> diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
> index 452286a..9f98e2f 100644
> --- a/include/linux/bcma/bcma.h
> +++ b/include/linux/bcma/bcma.h
> @@ -315,6 +315,7 @@ struct bcma_bus {
>  	const struct bcma_host_ops *ops;
>  
>  	enum bcma_hosttype hosttype;
> +	bool host_is_pcie2; /* Valid for BCMA_HOSTTYPE_PCI only */
>  	union {
>  		/* Pointer to the PCI bus (only for BCMA_HOSTTYPE_PCI) */
>  		struct pci_dev *host_pci;
> diff --git a/include/linux/bcma/bcma_regs.h b/include/linux/bcma/bcma_regs.h
> index 917dcd7..d02f8b5 100644
> --- a/include/linux/bcma/bcma_regs.h
> +++ b/include/linux/bcma/bcma_regs.h
> @@ -59,6 +59,8 @@
>  #define  BCMA_PCI_GPIO_XTAL		0x40	/* PCI config space GPIO 14 for Xtal powerup */
>  #define  BCMA_PCI_GPIO_PLL		0x80	/* PCI config space GPIO 15 for PLL powerdown */
>  
> +#define BCMA_PCIE2_BAR0_WIN2		0x70
> +
>  /* SiliconBackplane Address Map.
>   * All regions may not exist on all chips.
>   */
> 

