Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47927 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab1GFTCG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 15:02:06 -0400
Message-ID: <4E14B125.8020203@hauke-m.de> (sfid-20110706_210210_288051_83001D19)
Date: Wed, 06 Jul 2011 21:01:57 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] bcma: detect PCI core working in hostmode
References: <1309888106-30232-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1309888106-30232-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/05/2011 07:48 PM, Rafał Miłecki wrote:
> We must not init it like clientmode one, it would break device (tested
> by Hauke on BCM4718). Add stub hostmode driver for now.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
> Hauke: will you add your Signed-off-by?
> 
> In comparison to your patch for seriee, I have:
> 1) Disabled MIPS check for now (commented in code)
> 2) Enabled mode check even for driver without hostmode enabled
> ---
>  drivers/bcma/Kconfig           |    6 ++++++
>  drivers/bcma/Makefile          |    1 +
>  drivers/bcma/bcma_private.h    |    4 ++++
>  drivers/bcma/driver_pci.c      |   38 +++++++++++++++++++++++++++++++++++++-
>  drivers/bcma/driver_pci_host.c |   14 ++++++++++++++
>  5 files changed, 62 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/bcma/driver_pci_host.c
> 
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index 83e9adf..ae0a02e 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -27,6 +27,12 @@ config BCMA_HOST_PCI
>  	bool "Support for BCMA on PCI-host bus"
>  	depends on BCMA_HOST_PCI_POSSIBLE
>  
> +config BCMA_DRIVER_PCI_HOSTMODE
> +	bool "Driver for PCI core working in hostmode"
> +	depends on BCMA && MIPS
> +	help
> +	  PCI core hostmode operation (external PCI bus).
> +
>  config BCMA_DEBUG
>  	bool "BCMA debugging"
>  	depends on BCMA
> diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
> index cde0182..a2161cc 100644
> --- a/drivers/bcma/Makefile
> +++ b/drivers/bcma/Makefile
> @@ -1,6 +1,7 @@
>  bcma-y					+= main.o scan.o core.o sprom.o
>  bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
>  bcma-y					+= driver_pci.o
> +bcma-$(CONFIG_BCMA_DRIVER_PCI_HOSTMODE)	+= driver_pci_host.o
>  bcma-$(CONFIG_BCMA_HOST_PCI)		+= host_pci.o
>  obj-$(CONFIG_BCMA)			+= bcma.o
>  
> diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
> index 4228736..e02ff21 100644
> --- a/drivers/bcma/bcma_private.h
> +++ b/drivers/bcma/bcma_private.h
> @@ -28,4 +28,8 @@ extern int __init bcma_host_pci_init(void);
>  extern void __exit bcma_host_pci_exit(void);
>  #endif /* CONFIG_BCMA_HOST_PCI */
>  
> +#ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
> +void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc);
> +#endif /* CONFIG_BCMA_DRIVER_PCI_HOSTMODE */
> +
>  #endif
> diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
> index b0c19ed..dc6f34a 100644
> --- a/drivers/bcma/driver_pci.c
> +++ b/drivers/bcma/driver_pci.c
> @@ -157,11 +157,47 @@ static void bcma_pcicore_serdes_workaround(struct bcma_drv_pci *pc)
>   * Init.
>   **************************************************/
>  
> -void bcma_core_pci_init(struct bcma_drv_pci *pc)
> +static void bcma_core_pci_clientmode_init(struct bcma_drv_pci *pc)
>  {
>  	bcma_pcicore_serdes_workaround(pc);
>  }
>  
> +static bool bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
> +{
> +	struct bcma_bus *bus = pc->core->bus;
> +	u16 chipid_top;
> +
> +	chipid_top = (bus->chipinfo.id & 0xFF00);
> +	if (chipid_top != 0x4700 &&
> +	    chipid_top != 0x5300)
> +		return false;
> +
> +	if (bus->sprom.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
> +		return false;
> +
> +#if 0
> +	/* TODO: on BCMA we use address from EROM instead of magic formula */
> +	u32 tmp;
> +	return !mips_busprobe32(tmp, (bus->mmio +
> +		(pc->core->core_index * BCMA_CORE_SIZE)));
> +#endif
> +
> +	return true;
> +}
> +
> +void bcma_core_pci_init(struct bcma_drv_pci *pc)
> +{
> +	if (bcma_core_pci_is_in_hostmode(pc)) {
> +#ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
> +		bcma_core_pci_hostmode_init(pc);
> +#else
> +		pr_err("Driver compiled without support for hostmode PCI\n");
> +#endif /* CONFIG_BCMA_DRIVER_PCI_HOSTMODE */
> +	} else {
> +		bcma_core_pci_clientmode_init(pc);
> +	}
> +}
> +
>  int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc, struct bcma_device *core,
>  			  bool enable)
>  {
> diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
> new file mode 100644
> index 0000000..eb332b7
> --- /dev/null
> +++ b/drivers/bcma/driver_pci_host.c
> @@ -0,0 +1,14 @@
> +/*
> + * Broadcom specific AMBA
> + * PCI Core in hostmode
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include "bcma_private.h"
> +#include <linux/bcma/bcma.h>
> +
> +void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
> +{
> +	pr_err("No support for PCI core in hostmode yet\n");
> +}

