Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:36628 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012AbbA3UBp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 15:01:45 -0500
Message-ID: <54CBE299.4070709@hauke-m.de> (sfid-20150130_210203_617337_FB30F15C)
Date: Fri, 30 Jan 2015 20:59:21 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org
CC: brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 3/4] bcma: support bringing up bus hosted on PCIe Gen
 2
References: <1422638566-7593-1-git-send-email-zajec5@gmail.com> <1422638566-7593-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1422638566-7593-3-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/30/2015 06:22 PM, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/bcma/bcma_private.h            |  3 +++
>  drivers/bcma/driver_pcie2.c            | 24 ++++++++++++++++++++++--
>  drivers/bcma/host_pci.c                |  2 +-
>  include/linux/bcma/bcma_driver_pcie2.h |  2 ++
>  4 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
> index 351f4af..3692912 100644
> --- a/drivers/bcma/bcma_private.h
> +++ b/drivers/bcma/bcma_private.h
> @@ -104,6 +104,9 @@ u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
>  void bcma_core_pci_up(struct bcma_drv_pci *pc);
>  void bcma_core_pci_down(struct bcma_drv_pci *pc);
>  
> +/* driver_pcie2.c */
> +void bcma_core_pcie2_up(struct bcma_drv_pcie2 *pcie2);
> +
>  extern int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc);
>  
>  #ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
> diff --git a/drivers/bcma/driver_pcie2.c b/drivers/bcma/driver_pcie2.c
> index e4be537..c8913bc 100644
> --- a/drivers/bcma/driver_pcie2.c
> +++ b/drivers/bcma/driver_pcie2.c
> @@ -156,14 +156,20 @@ static void pciedev_reg_pm_clk_period(struct bcma_drv_pcie2 *pcie2)
>  
>  void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2)
>  {
> -	struct bcma_chipinfo *ci = &pcie2->core->bus->chipinfo;
> +	struct bcma_bus *bus = pcie2->core->bus;
> +	struct bcma_chipinfo *ci = &bus->chipinfo;
>  	u32 tmp;
>  
>  	tmp = pcie2_read32(pcie2, BCMA_CORE_PCIE2_SPROM(54));
>  	if ((tmp & 0xe) >> 1 == 2)
>  		bcma_core_pcie2_cfg_write(pcie2, 0x4e0, 0x17);
>  
> -	/* TODO: Do we need pcie_reqsize? */
> +	switch (bus->chipinfo.id) {
> +	case BCMA_CHIP_ID_BCM4360:
> +	case BCMA_CHIP_ID_BCM4352:
> +		pcie2->reqsize = 0x3000; /* TODO: PCI_EXP_DEVCTL_READRQ_1024B */
> +		break;
> +	}

In the PCIe controller used in the BCM4706 there was a bug, so that it
did not support a request size bigger than 128 bytes. Broadcom "fixed"
that in the PCIe device driver code by decreasing the value, but we
fixed that in the PCIe controller code, see:

commit f4a83e578e0011ddcfdbe1c62d0916dadb4802aa
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Fri Aug 23 23:22:29 2013 +0200

    bcma: change max PCI read request size to 128

It could be that the PCIe controller used on ARM SoCs has similar
problems but supports bigger sizes now, but not so big ones.

This is just an assumption.

What is the default value for pcie2->reqsize?

>  
>  	if (ci->id == BCMA_CHIP_ID_BCM4360 && ci->rev > 3)
>  		bcma_core_pcie2_war_delay_perst_enab(pcie2, true);
> @@ -173,3 +179,17 @@ void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2)
>  	pciedev_crwlpciegen2_180(pcie2);
>  	pciedev_crwlpciegen2_182(pcie2);
>  }
> +
> +/**************************************************
> + * Runtime ops.
> + **************************************************/
> +
> +void bcma_core_pcie2_up(struct bcma_drv_pcie2 *pcie2)
> +{
> +	struct bcma_bus *bus = pcie2->core->bus;
> +	struct pci_dev *dev = bus->host_pci;
> +
> +	pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
> +					   PCI_EXP_DEVCTL_READRQ,
> +					   pcie2->reqsize);

Use pcie_set_readrq() if it is needed.

> +}
> diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
> index 8dd37dc..5fb87a8 100644
> --- a/drivers/bcma/host_pci.c
> +++ b/drivers/bcma/host_pci.c
> @@ -322,7 +322,7 @@ void bcma_host_pci_up(struct bcma_bus *bus)
>  		return;
>  
>  	if (bus->host_is_pcie2)
> -		pr_warn("Bringing up bus with PCIe Gen 2 host is unsupported yet\n");
> +		bcma_core_pcie2_up(&bus->drv_pcie2);
>  	else
>  		bcma_core_pci_up(&bus->drv_pci[0]);
>  }
> diff --git a/include/linux/bcma/bcma_driver_pcie2.h b/include/linux/bcma/bcma_driver_pcie2.h
> index 5988b05..d8c4329 100644
> --- a/include/linux/bcma/bcma_driver_pcie2.h
> +++ b/include/linux/bcma/bcma_driver_pcie2.h
> @@ -143,6 +143,8 @@
>  
>  struct bcma_drv_pcie2 {
>  	struct bcma_device *core;
> +
> +	u16 reqsize;
>  };
>  
>  #define pcie2_read16(pcie2, offset)		bcma_read16((pcie2)->core, offset)
> 
