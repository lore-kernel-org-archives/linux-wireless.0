Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42613 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab2LZKhv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2012 05:37:51 -0500
Message-ID: <50DAD374.1090305@hauke-m.de> (sfid-20121226_113806_883160_FEB5E02A)
Date: Wed, 26 Dec 2012 11:37:40 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC][PATCH] ssb: add place for serial flash driver
References: <1356459816-2214-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1356459816-2214-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/25/2012 07:23 PM, Rafał Miłecki wrote:
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/ssb/Kconfig                       |    5 +++++
>  drivers/ssb/Makefile                      |    1 +
>  drivers/ssb/driver_chipcommon_sflash.c    |   22 ++++++++++++++++++++++
>  drivers/ssb/driver_mipscore.c             |    3 ++-
>  drivers/ssb/ssb_private.h                 |   11 +++++++++++
>  include/linux/ssb/ssb_driver_chipcommon.h |   10 ++++++++++
>  6 files changed, 51 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/ssb/driver_chipcommon_sflash.c
> 
> diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
> index fad7a10..ea099e1 100644
> --- a/drivers/ssb/Kconfig
> +++ b/drivers/ssb/Kconfig
> @@ -137,6 +137,11 @@ config SSB_DRIVER_MIPS
>  
>  	  If unsure, say N
>  
> +config SSB_SFLASH
> +	bool "SSB serial flash support"
> +	depends on SSB_DRIVER_MIPS && BROKEN
> +	default y
> +
>  # Assumption: We are on embedded, if we compile the MIPS core.
>  config SSB_EMBEDDED
>  	bool
> diff --git a/drivers/ssb/Makefile b/drivers/ssb/Makefile
> index 9159ba7..b1ddc11 100644
> --- a/drivers/ssb/Makefile
> +++ b/drivers/ssb/Makefile
> @@ -11,6 +11,7 @@ ssb-$(CONFIG_SSB_SDIOHOST)		+= sdio.o
>  # built-in drivers
>  ssb-y					+= driver_chipcommon.o
>  ssb-y					+= driver_chipcommon_pmu.o
> +ssb-$(CONFIG_SSB_SFLASH)		+= driver_chipcommon_sflash.o
>  ssb-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o
>  ssb-$(CONFIG_SSB_DRIVER_EXTIF)		+= driver_extif.o
>  ssb-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o
> diff --git a/drivers/ssb/driver_chipcommon_sflash.c b/drivers/ssb/driver_chipcommon_sflash.c
> new file mode 100644
> index 0000000..9803e02
> --- /dev/null
> +++ b/drivers/ssb/driver_chipcommon_sflash.c
> @@ -0,0 +1,22 @@
> +/*
> + * Sonics Silicon Backplane
> + * ChipCommon serial flash interface
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include <linux/ssb/ssb.h>
> +
> +#include "ssb_private.h"
> +
> +/* Initialize serial flash access */
> +int ssb_sflash_init(struct ssb_chipcommon *cc)
> +{
> +	struct ssb_sflash *sflash = &cc->sflash;
> +
> +	pr_err("Serial flash support is not implemented yet!\n");
> +
> +	sflash->present = true;
> +
> +	return -ENOTSUPP;
> +}
> diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
> index 5bd05b1..2a7684c 100644
> --- a/drivers/ssb/driver_mipscore.c
> +++ b/drivers/ssb/driver_mipscore.c
> @@ -203,7 +203,8 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
>  	switch (bus->chipco.capabilities & SSB_CHIPCO_CAP_FLASHT) {
>  	case SSB_CHIPCO_FLASHT_STSER:
>  	case SSB_CHIPCO_FLASHT_ATSER:
> -		pr_err("Serial flash not supported\n");
> +		pr_debug("Found serial flash\n");
> +		ssb_sflash_init(&bus->chipco);
>  		break;
>  	case SSB_CHIPCO_FLASHT_PARA:
>  		pr_debug("Found parallel flash\n");
> diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
> index 6c10b66..77d9426 100644
> --- a/drivers/ssb/ssb_private.h
> +++ b/drivers/ssb/ssb_private.h
> @@ -217,6 +217,17 @@ extern u32 ssb_chipco_watchdog_timer_set_wdt(struct bcm47xx_wdt *wdt,
>  					     u32 ticks);
>  extern u32 ssb_chipco_watchdog_timer_set_ms(struct bcm47xx_wdt *wdt, u32 ms);
>  
> +/* driver_chipcommon_sflash.c */
> +#ifdef CONFIG_SSB_SFLASH
> +int ssb_sflash_init(struct ssb_chipcommon *cc);
> +#else
> +static inline int ssb_sflash_init(struct ssb_chipcommon *cc)
> +{
> +	pr_err("Serial flash not supported\n");
> +	return 0;
> +}
> +#endif /* CONFIG_SSB_SFLASH */
> +
>  #ifdef CONFIG_SSB_DRIVER_EXTIF
>  extern u32 ssb_extif_watchdog_timer_set_wdt(struct bcm47xx_wdt *wdt, u32 ticks);
>  extern u32 ssb_extif_watchdog_timer_set_ms(struct bcm47xx_wdt *wdt, u32 ms);
> diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
> index 9e492be..052e9de 100644
> --- a/include/linux/ssb/ssb_driver_chipcommon.h
> +++ b/include/linux/ssb/ssb_driver_chipcommon.h
> @@ -584,6 +584,12 @@ struct ssb_chipcommon_pmu {
>  	u32 crystalfreq;	/* The active crystal frequency (in kHz) */
>  };
>  
> +#ifdef CONFIG_SSB_SFLASH
> +struct ssb_sflash {
> +	bool present;
> +};
> +#endif

I assume you want to share some of the code for the serial flash driver
between bcma and ssb. You should create a file with the structure in
include/linux/platform_data/ and share that between bcma and ssb.

> +
>  struct ssb_chipcommon {
>  	struct ssb_device *dev;
>  	u32 capabilities;
> @@ -594,6 +600,10 @@ struct ssb_chipcommon {
>  	struct ssb_chipcommon_pmu pmu;
>  	u32 ticks_per_ms;
>  	u32 max_timer_ms;
> +
> +#ifdef CONFIG_SSB_SFLASH
> +	struct ssb_sflash sflash;
> +#endif
>  };
>  
>  static inline bool ssb_chipco_available(struct ssb_chipcommon *cc)
> 

