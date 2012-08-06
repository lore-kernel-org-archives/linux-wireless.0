Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43805 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2HFJMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 05:12:13 -0400
Received: by eaac11 with SMTP id c11so742626eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 02:12:12 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH V2] bcma: add basic NAND flash driver
Date: Mon, 06 Aug 2012 11:12:06 +0200
Message-ID: <2659000.qYqUYD2ChA@flexo> (sfid-20120806_111217_933385_E9F2BE4B)
In-Reply-To: <1344196987-32041-1-git-send-email-zajec5@gmail.com>
References: <1344196987-32041-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Rafal,

Some minor comments below.

On Sunday 05 August 2012 22:03:07 Rafał Miłecki wrote:
> This is basic driver for NAND flash memory that allows reading it's
> content. It was succesfully tested on Netgear WNDR4500 which is BCM4706
> based router.
> 
> This driver has been written using specs at:
> http://bcm-v4.sipsolutions.net/NAND_Flash
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> CC: Larry Finger <Larry.Finger@lwfinger.net>
> CC: Hauke Mehrtens <hauke@hauke-m.de>
> ---
> V2: Split bcma_nflash_read into three functions as suggested by Hauke
>     Use bcma_* for printing
> ---
>  drivers/bcma/Kconfig                        |    4 +-
>  drivers/bcma/bcma_private.h                 |    2 +-
>  drivers/bcma/driver_chipcommon_nflash.c     |  402 
++++++++++++++++++++++++++-
>  drivers/bcma/driver_chipcommon_pmu.c        |    2 +-
>  include/linux/bcma/bcma_driver_chipcommon.h |   88 ++++++
>  5 files changed, 490 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index 8d1f777..a58d7a9 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -53,8 +53,8 @@ config BCMA_SFLASH
>  	default y
>  
>  config BCMA_NFLASH
> -	bool
> -	depends on BCMA_DRIVER_MIPS && BROKEN
> +	bool "Support for NAND flash"
> +	depends on BCMA_DRIVER_MIPS
>  	default y
>  
>  config BCMA_DRIVER_GMAC_CMN
> diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
> index 3cf9cc9..9895c7e 100644
> --- a/drivers/bcma/bcma_private.h
> +++ b/drivers/bcma/bcma_private.h
> @@ -68,7 +68,7 @@ int bcma_nflash_init(struct bcma_drv_cc *cc);
>  #else
>  static inline int bcma_nflash_init(struct bcma_drv_cc *cc)
>  {
> -	bcma_err(cc->core->bus, "NAND flash not supported\n");
> +	bcma_err(cc->core->bus, "NAND flash support not enabled\n");
>  	return 0;
>  }
>  #endif /* CONFIG_BCMA_NFLASH */
> diff --git a/drivers/bcma/driver_chipcommon_nflash.c 
b/drivers/bcma/driver_chipcommon_nflash.c
> index 574d624..0d11e6f 100644
> --- a/drivers/bcma/driver_chipcommon_nflash.c
> +++ b/drivers/bcma/driver_chipcommon_nflash.c
> @@ -2,18 +2,412 @@
>   * Broadcom specific AMBA
>   * ChipCommon NAND flash interface
>   *
> + * Copyright 2012, Rafał Miłecki <zajec5@gmail.com>
> + *
>   * Licensed under the GNU/GPL. See COPYING for details.
>   */
>  
> +#include "bcma_private.h"
>  #include <linux/bcma/bcma.h>
>  #include <linux/bcma/bcma_driver_chipcommon.h>
>  #include <linux/delay.h>
>  
> -#include "bcma_private.h"
> +/* Broadcom uses 1'000'000 but it seems to be too many. Tests on WNDR4500 
has
> + * shown 6 retries were enough. */
> +#define NFLASH_READY_RETRIES		100
>  
> -/* Initialize NAND flash access */
> -int bcma_nflash_init(struct bcma_drv_cc *cc)
> +/**************************************************
> + * Various helpers
> + **************************************************/
> +
> +static inline u8 bcma_nflash_ns_to_cycle(u16 ns, u16 clock)
> +{
> +	return ((ns * 1000 * clock) / 1000000) + 1;
> +}
> +
> +static void bcma_nflash_enable(struct bcma_drv_cc *cc, bool enable)
> +{
> +	if (cc->core->id.rev == 38) {
> +		if (cc->status & BCMA_CC_CHIPST_REV38_NAND_BOOT)
> +			return;
> +		if (enable)
> +			bcma_chipco_chipctl_maskset(cc, 1, ~0, 0x10000);
> +		else
> +			bcma_chipco_chipctl_maskset(cc, 1, ~0x10000, 0);
> +	}
> +}

Can you define a constant for this bit?

> +
> +static int bcma_nflash_ctl_cmd(struct bcma_drv_cc *cc, u32 code)
> +{
> +	int i = 0;
> +
> +	bcma_cc_write32(cc, BCMA_CC_NFLASH_CTL, 0x80000000 | code);
> +	for (i = 0; i < NFLASH_READY_RETRIES; i++) {
> +		if (!(bcma_cc_read32(cc, BCMA_CC_NFLASH_CTL) & 0x80000000)) {
> +			i = 0;
> +			break;
> +		}
> +	}
> +	if (i) {
> +		bcma_err(cc->core->bus, "NFLASH control command not ready!\n");
> +		return -EBUSY;
> +	}
> +	return 0;

Would not it be simple to check for i == NFLASH_READY_RETRIES instead of 
setting the value of i in the for loop? That sounds more natural. You might 
also want to add a cpu_relax() right after reading the NFLASH_CTL register.

> +}
> +
> +int bcma_nflash_poll(struct bcma_drv_cc *cc)
> +{
> +	int i;
> +	u32 tmp;
> +
> +	if (cc->core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4706) {
> +		for (i = 0; i < NFLASH_READY_RETRIES; i++) {
> +			if (bcma_cc_read32(cc, BCMA_CC_NFLASH_CTL) &
> +			    0x04000000) {
> +				if (bcma_cc_read32(cc, BCMA_CC_NFLASH_CTL) &
> +				    BCMA_CC_NFLASH_CTL_ERR) {
> +					bcma_err(cc->core->bus, "Error on polling\n");
> +					return -EBUSY;
> +				} else {
> +					return 0;
> +				}
> +			}
> +		}
> +	} else {
> +		for (i = 0; i < NFLASH_READY_RETRIES; i++) {
> +			tmp = bcma_cc_read32(cc, BCMA_CC_NAND_INTFC_STATUS);
> +			if ((tmp & 0xC0000000) == 0xC0000000)
> +				return 0;
> +		}
> +	}

Use constants here too.
