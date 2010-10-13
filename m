Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46933 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab0JMLRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 07:17:42 -0400
From: "Premi, Sanjeev" <premi@ti.com>
To: "csanjay@mistralsolutions.com" <csanjay@mistralsolutions.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 13 Oct 2010 16:47:35 +0530
Subject: RE: [WL1271 DC supprot on OMAP3EVM 2/5] ARM: Supported for Standard
 SDIO driver on OMAP3EVM for WL1271 DC
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930234405BCA@dbde02.ent.ti.com>
References: <1286967077-20071-1-git-send-email-csanjay@mistralsolutions.com>
 <1286967077-20071-3-git-send-email-csanjay@mistralsolutions.com>
In-Reply-To: <1286967077-20071-3-git-send-email-csanjay@mistralsolutions.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org 
> [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of 
> csanjay@mistralsolutions.com
> Sent: Wednesday, October 13, 2010 4:21 PM
> To: linux-omap@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org; Sanjay Kumar Champati
> Subject: [WL1271 DC supprot on OMAP3EVM 2/5] ARM: Supported 
> for Standard SDIO driver on OMAP3EVM for WL1271 DC
> 
> From: Sanjay Kumar Champati <csanjay@mistralsolutions.com>
> 
> * Apply MMC2 support patch before apply this patch

[sp] Can you be more explicit about this change? It isn't useful
     here?

> * Modified the "Kconfig" and "board-omap3evm.c" files to support
>   standard SDIO driver for WL1271 DC
> 
> Signed-off-by: Sanjay Kumar Champati <csanjay@mistralsolutions.com>
> ---
>  arch/arm/mach-omap2/board-omap3evm.c |   13 ++++++++++++-
>  drivers/mmc/core/sdio_ops.c          |    7 ++++++-
>  drivers/net/wireless/Kconfig         |   11 +++++++++++
>  3 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-omap3evm.c 
> b/arch/arm/mach-omap2/board-omap3evm.c
> index 6b45b6e..06fab2e 100644
> --- a/arch/arm/mach-omap2/board-omap3evm.c
> +++ b/arch/arm/mach-omap2/board-omap3evm.c
> @@ -79,6 +79,10 @@
>  #define OMAP3EVM_ETHR_ID_REV	0x50
>  #define OMAP3EVM_ETHR_GPIO_IRQ	176
>  #define OMAP3EVM_SMSC911X_CS	5
> +#ifdef CONFIG_WL1271_WLAN
> +#define OMAP3EVM_WLAN_EN	150
> +#define OMAP3EVM_WLAN_IRQ	149
> +#endif
>  
>  extern struct regulator_consumer_supply twl4030_vmmc1_supply;
>  extern struct regulator_consumer_supply twl4030_vsim_supply;
> @@ -749,7 +753,14 @@ static int 
> omap3evm_twl_gpio_setup(struct device *dev,
>  	twl4030_vmmc1_supply.dev = mmc[0].dev;
>  	twl4030_vsim_supply.dev = mmc[0].dev;
>  	twl4030_vmmc2_supply.dev = mmc[1].dev;
> -
> +#ifdef CONFIG_WL1271_WLAN
> +	omap_mux_init_gpio(OMAP3EVM_WLAN_EN, OMAP_PIN_OUTPUT);
> +	if (gpio_request(OMAP3EVM_WLAN_EN, "WLAN_ENABLE"))
> +		printk(KERN_ERR "Fail to get WLAN Enable GPIO\n");
> +	gpio_direction_output(OMAP3EVM_WLAN_EN, 1);
> +	mdelay(100);

[sp] Why is this delay required?

> +	omap_mux_init_gpio(OMAP3EVM_WLAN_IRQ, OMAP_PIN_INPUT);
> +#endif
>  	/*
>  	 * Most GPIOs are for USB OTG.  Some are mostly sent to
>  	 * the P2 connector; notably LEDA for the LCD backlight.
> diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
> index 4eb7825..4213ee0 100644
> --- a/drivers/mmc/core/sdio_ops.c
> +++ b/drivers/mmc/core/sdio_ops.c
> @@ -114,6 +114,9 @@ int mmc_io_rw_direct(struct mmc_card 
> *card, int write, unsigned fn,
>  
>  	return 0;
>  }
> +#ifdef CONFIG_WL1271_WLAN
> +EXPORT_SYMBOL(mmc_io_rw_direct);
> +#endif

[sp] Why is the export required?

>  
>  int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
>  	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, 
> unsigned blksz)
> @@ -181,4 +184,6 @@ int mmc_io_rw_extended(struct mmc_card 
> *card, int write, unsigned fn,
>  
>  	return 0;
>  }
> -
> +#ifdef CONFIG_WL1271_WLAN
> +EXPORT_SYMBOL(mmc_io_rw_extended);
> +#endif

[sp] Why is the export required?

> diff --git a/drivers/net/wireless/Kconfig 
> b/drivers/net/wireless/Kconfig
> index 56dd665..dc319b7 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -31,6 +31,17 @@ config PCMCIA_RAYCS
>  	  To compile this driver as a module, choose M here: 
> the module will be
>  	  called ray_cs.  If unsure, say N.
>  
> +config WL1271_WLAN
> +	tristate "WL1271 TI's SDIO based wireless card"
> +	select WIRELESS_EXT
> +	select CRYPTO
> +	select WEXT_SPY
> +	select WEXT_PRIV
> +	---help---
> +	This driver support both the standard Linux Wireless Extensions
> +	and TI's proprietary API, so both the Linux Wireless 
> Tools and this
> +	module support 2.4 GHz 802.11 b/g/n standrd.
[sp] Can you do a spellcheck?              ^^^^^^

> +
>  config LIBERTAS_THINFIRM
>  	tristate "Marvell 8xxx Libertas WLAN driver support 
> with thin firmware"
>  	depends on MAC80211
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 