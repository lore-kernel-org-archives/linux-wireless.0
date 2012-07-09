Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55926 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab2GIXCP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 19:02:15 -0400
Message-ID: <4FFB62DA.9000706@hauke-m.de> (sfid-20120710_010219_812522_C3C440DF)
Date: Tue, 10 Jul 2012 01:01:46 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC][PATCH] bcma: add trivial GBIT MAC COMMON driver
References: <1341751888-12679-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1341751888-12679-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/2012 02:51 PM, Rafał Miłecki wrote:
> GMAC COMMON core is present on BCM4706 and is used for example to access
> board PHYs (PHYs can not be accessed directly using GBIT MAC core).

I think this is the cleanest way of doing this. I thought about handling
this in the Ethernet driver, but as we need locking, an extra driver
would be needed, just for this stupid locking.

You should not register an external device for this core in
bcma_register_cores().

> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/bcma/Kconfig                      |    9 +++
>  drivers/bcma/Makefile                     |    1 +
>  drivers/bcma/driver_gmac_cmn.c            |   14 ++++
>  drivers/bcma/main.c                       |    7 ++
>  include/linux/bcma/bcma.h                 |    2 +
>  include/linux/bcma/bcma_driver_gmac_cmn.h |  100 +++++++++++++++++++++++++++++
>  6 files changed, 133 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/bcma/driver_gmac_cmn.c
>  create mode 100644 include/linux/bcma/bcma_driver_gmac_cmn.h
> 
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index fb7c80f..9319cde 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -46,6 +46,15 @@ config BCMA_DRIVER_MIPS
>  
>  	  If unsure, say N
>  
> +config BCMA_DRIVER_GMAC_CMN
> +	bool "BCMA Broadcom GBIT MAC COMMON core driver"
> +	depends on BCMA
> +	help
> +	  Driver for the Broadcom GBIT MAC COMMON core attached to Broadcom
> +	  specific Advanced Microcontroller Bus.
> +
> +	  If unsure, say N
> +
>  config BCMA_DEBUG
>  	bool "BCMA debugging"
>  	depends on BCMA
> diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
> index 82de24e..d13803f 100644
> --- a/drivers/bcma/Makefile
> +++ b/drivers/bcma/Makefile
> @@ -3,6 +3,7 @@ bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
>  bcma-y					+= driver_pci.o
>  bcma-$(CONFIG_BCMA_DRIVER_PCI_HOSTMODE)	+= driver_pci_host.o
>  bcma-$(CONFIG_BCMA_DRIVER_MIPS)		+= driver_mips.o
> +bcma-$(CONFIG_BCMA_DRIVER_GMAC_CMN)	+= driver_gmac_cmn.o
>  bcma-$(CONFIG_BCMA_HOST_PCI)		+= host_pci.o
>  bcma-$(CONFIG_BCMA_HOST_SOC)		+= host_soc.o
>  obj-$(CONFIG_BCMA)			+= bcma.o
> diff --git a/drivers/bcma/driver_gmac_cmn.c b/drivers/bcma/driver_gmac_cmn.c
> new file mode 100644
> index 0000000..834225f
> --- /dev/null
> +++ b/drivers/bcma/driver_gmac_cmn.c
> @@ -0,0 +1,14 @@
> +/*
> + * Broadcom specific AMBA
> + * GBIT MAC COMMON Core
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include "bcma_private.h"
> +#include <linux/bcma/bcma.h>
> +
> +void __devinit bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc)
> +{
> +	mutex_init(&gc->phy_mutex);
> +}
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index 7ff4bac..173a0b4 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -177,6 +177,13 @@ int __devinit bcma_bus_register(struct bcma_bus *bus)
>  		bcma_core_pci_init(&bus->drv_pci);
>  	}
>  
> +	/* Init GBIT MAC COMMON core */
> +	core = bcma_find_core(bus, BCMA_CORE_4706_MAC_GBIT_COMMON);
> +	if (core) {
> +		bus->drv_gmac_cmn.core = core;
> +		bcma_core_gmac_cmn_init(&bus->drv_gmac_cmn);
> +	}
> +
>  	/* Try to get SPROM */
>  	err = bcma_sprom_get(bus);
>  	if (err == -ENOENT) {
> diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
> index 03b2f30..1954a4e 100644
> --- a/include/linux/bcma/bcma.h
> +++ b/include/linux/bcma/bcma.h
> @@ -7,6 +7,7 @@
>  #include <linux/bcma/bcma_driver_chipcommon.h>
>  #include <linux/bcma/bcma_driver_pci.h>
>  #include <linux/bcma/bcma_driver_mips.h>
> +#include <linux/bcma/bcma_driver_gmac_cmn.h>
>  #include <linux/ssb/ssb.h> /* SPROM sharing */
>  
>  #include "bcma_regs.h"
> @@ -252,6 +253,7 @@ struct bcma_bus {
>  	struct bcma_drv_cc drv_cc;
>  	struct bcma_drv_pci drv_pci;
>  	struct bcma_drv_mips drv_mips;
> +	struct bcma_drv_gmac_cmn drv_gmac_cmn;
>  
>  	/* We decided to share SPROM struct with SSB as long as we do not need
>  	 * any hacks for BCMA. This simplifies drivers code. */
> diff --git a/include/linux/bcma/bcma_driver_gmac_cmn.h b/include/linux/bcma/bcma_driver_gmac_cmn.h
> new file mode 100644
> index 0000000..def894b
> --- /dev/null
> +++ b/include/linux/bcma/bcma_driver_gmac_cmn.h
> @@ -0,0 +1,100 @@
> +#ifndef LINUX_BCMA_DRIVER_GMAC_CMN_H_
> +#define LINUX_BCMA_DRIVER_GMAC_CMN_H_
> +
> +#include <linux/types.h>
> +
> +#define BCMA_GMAC_CMN_STAG0		0x000
> +#define BCMA_GMAC_CMN_STAG1		0x004
> +#define BCMA_GMAC_CMN_STAG2		0x008
> +#define BCMA_GMAC_CMN_STAG3		0x00C
> +#define BCMA_GMAC_CMN_PARSER_CTL	0x020
> +#define BCMA_GMAC_CMN_MIB_MAX_LEN	0x024
> +#define BCMA_GMAC_CMN_PHY_ACCESS	0x100
> +#define  BCMA_GMAC_CMN_PA_DATA_MASK	0x0000ffff
> +#define  BCMA_GMAC_CMN_PA_ADDR_MASK	0x001f0000
> +#define  BCMA_GMAC_CMN_PA_ADDR_SHIFT	16
> +#define  BCMA_GMAC_CMN_PA_REG_MASK	0x1f000000
> +#define  BCMA_GMAC_CMN_PA_REG_SHIFT	24
> +#define  BCMA_GMAC_CMN_PA_WRITE		0x20000000
> +#define  BCMA_GMAC_CMN_PA_START		0x40000000
> +#define BCMA_GMAC_CMN_PHY_CTL		0x104
> +#define  BCMA_GMAC_CMN_PC_EPA_MASK	0x0000001f
> +#define  BCMA_GMAC_CMN_PC_MCT_MASK	0x007f0000
> +#define  BCMA_GMAC_CMN_PC_MCT_SHIFT	16
> +#define  BCMA_GMAC_CMN_PC_MTE		0x00800000
> +#define BCMA_GMAC_CMN_GMAC0_RGMII_CTL	0x110
> +#define BCMA_GMAC_CMN_CFP_ACCESS	0x200
> +#define BCMA_GMAC_CMN_CFP_TCAM_DATA0	0x210
> +#define BCMA_GMAC_CMN_CFP_TCAM_DATA1	0x214
> +#define BCMA_GMAC_CMN_CFP_TCAM_DATA2	0x218
> +#define BCMA_GMAC_CMN_CFP_TCAM_DATA3	0x21C
> +#define BCMA_GMAC_CMN_CFP_TCAM_DATA4	0x220
> +#define BCMA_GMAC_CMN_CFP_TCAM_DATA5	0x224
> +#define BCMA_GMAC_CMN_CFP_TCAM_DATA6	0x228
> +#define BCMA_GMAC_CMN_CFP_TCAM_DATA7	0x22C
> +#define BCMA_GMAC_CMN_CFP_TCAM_MASK0	0x230
> +#define BCMA_GMAC_CMN_CFP_TCAM_MASK1	0x234
> +#define BCMA_GMAC_CMN_CFP_TCAM_MASK2	0x238
> +#define BCMA_GMAC_CMN_CFP_TCAM_MASK3	0x23C
> +#define BCMA_GMAC_CMN_CFP_TCAM_MASK4	0x240
> +#define BCMA_GMAC_CMN_CFP_TCAM_MASK5	0x244
> +#define BCMA_GMAC_CMN_CFP_TCAM_MASK6	0x248
> +#define BCMA_GMAC_CMN_CFP_TCAM_MASK7	0x24C
> +#define BCMA_GMAC_CMN_CFP_ACTION_DATA	0x250
> +#define BCMA_GMAC_CMN_TCAM_BIST_CTL	0x2A0
> +#define BCMA_GMAC_CMN_TCAM_BIST_STATUS	0x2A4
> +#define BCMA_GMAC_CMN_TCAM_CMP_STATUS	0x2A8
> +#define BCMA_GMAC_CMN_TCAM_DISABLE	0x2AC
> +#define BCMA_GMAC_CMN_TCAM_TEST_CTL	0x2F0
> +#define BCMA_GMAC_CMN_UDF_0_A3_A0	0x300
> +#define BCMA_GMAC_CMN_UDF_0_A7_A4	0x304
> +#define BCMA_GMAC_CMN_UDF_0_A8		0x308
> +#define BCMA_GMAC_CMN_UDF_1_A3_A0	0x310
> +#define BCMA_GMAC_CMN_UDF_1_A7_A4	0x314
> +#define BCMA_GMAC_CMN_UDF_1_A8		0x318
> +#define BCMA_GMAC_CMN_UDF_2_A3_A0	0x320
> +#define BCMA_GMAC_CMN_UDF_2_A7_A4	0x324
> +#define BCMA_GMAC_CMN_UDF_2_A8		0x328
> +#define BCMA_GMAC_CMN_UDF_0_B3_B0	0x330
> +#define BCMA_GMAC_CMN_UDF_0_B7_B4	0x334
> +#define BCMA_GMAC_CMN_UDF_0_B8		0x338
> +#define BCMA_GMAC_CMN_UDF_1_B3_B0	0x340
> +#define BCMA_GMAC_CMN_UDF_1_B7_B4	0x344
> +#define BCMA_GMAC_CMN_UDF_1_B8		0x348
> +#define BCMA_GMAC_CMN_UDF_2_B3_B0	0x350
> +#define BCMA_GMAC_CMN_UDF_2_B7_B4	0x354
> +#define BCMA_GMAC_CMN_UDF_2_B8		0x358
> +#define BCMA_GMAC_CMN_UDF_0_C3_C0	0x360
> +#define BCMA_GMAC_CMN_UDF_0_C7_C4	0x364
> +#define BCMA_GMAC_CMN_UDF_0_C8		0x368
> +#define BCMA_GMAC_CMN_UDF_1_C3_C0	0x370
> +#define BCMA_GMAC_CMN_UDF_1_C7_C4	0x374
> +#define BCMA_GMAC_CMN_UDF_1_C8		0x378
> +#define BCMA_GMAC_CMN_UDF_2_C3_C0	0x380
> +#define BCMA_GMAC_CMN_UDF_2_C7_C4	0x384
> +#define BCMA_GMAC_CMN_UDF_2_C8		0x388
> +#define BCMA_GMAC_CMN_UDF_0_D3_D0	0x390
> +#define BCMA_GMAC_CMN_UDF_0_D7_D4	0x394
> +#define BCMA_GMAC_CMN_UDF_0_D11_D8	0x394
> +
> +struct bcma_drv_gmac_cmn {
> +	struct bcma_device *core;
> +
> +	/* Drivers accessing BCMA_GMAC_CMN_PHY_ACCESS and
> +	 * BCMA_GMAC_CMN_PHY_CTL need to take that mutex first. */
> +	struct mutex phy_mutex;
> +};
> +
> +/* Register access */
> +#define gmac_cmn_read16(gc, offset)		bcma_read16((gc)->core, offset)
> +#define gmac_cmn_read32(gc, offset)		bcma_read32((gc)->core, offset)
> +#define gmac_cmn_write16(gc, offset, val)	bcma_write16((gc)->core, offset, val)
> +#define gmac_cmn_write32(gc, offset, val)	bcma_write32((gc)->core, offset, val)
> +
> +#ifdef CONFIG_BCMA_DRIVER_GMAC_CMN
> +extern void __devinit bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc);
> +#else
> +static inline void bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc) { }
> +#endif
> +
> +#endif /* LINUX_BCMA_DRIVER_GMAC_CMN_H_ */
> 


