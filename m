Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40442 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab0JMMX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 08:23:28 -0400
From: "Premi, Sanjeev" <premi@ti.com>
To: "csanjay@mistralsolutions.com" <csanjay@mistralsolutions.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 13 Oct 2010 17:53:22 +0530
Subject: RE: [WL1271 DC supprot on OMAP3EVM 1/5] ARM: Supported MMC 2
 features for OMAP3EVM
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930234405C64@dbde02.ent.ti.com>
References: <1286967077-20071-1-git-send-email-csanjay@mistralsolutions.com>
 <1286967077-20071-2-git-send-email-csanjay@mistralsolutions.com>
In-Reply-To: <1286967077-20071-2-git-send-email-csanjay@mistralsolutions.com>
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
> Subject: [WL1271 DC supprot on OMAP3EVM 1/5] ARM: Supported 
> MMC 2 features for OMAP3EVM
> 
> From: Sanjay Kumar Champati <csanjay@mistralsolutions.com>
> 
> * Modified "board-omap3evm.c" file for MMC2 support
> * Modified "mmc-twl4030.c" and "mmc-twl4030.h" file for MMC2 
> power support

[sp] Can you describe how to use the MMC2 on omap3evm?
     Also, the name of the files modified is already part of the
     patch syntax. You don't need to mention them in the
     description here.

> 
> Signed-off-by: Sanjay Kumar Champati <csanjay@mistralsolutions.com>
> ---
>  arch/arm/mach-omap2/board-omap3evm.c |   15 +++++++++++++++
>  arch/arm/mach-omap2/mmc-twl4030.c    |    1 +
>  arch/arm/mach-omap2/mmc-twl4030.h    |    2 ++
>  3 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-omap3evm.c 
> b/arch/arm/mach-omap2/board-omap3evm.c
> index d2c8dcf..6b45b6e 100644
> --- a/arch/arm/mach-omap2/board-omap3evm.c
> +++ b/arch/arm/mach-omap2/board-omap3evm.c
> @@ -611,6 +611,13 @@ static struct twl4030_hsmmc_info mmc[] = {
>  		.gpio_cd	= -EINVAL,
>  		.gpio_wp	= 63,
>  	},
> +	{
> +		.mmc            = 2,
> +		.wires          = 4,
> +		.gpio_cd        = -EINVAL,
> +		.gpio_wp        = -EINVAL,
> +		.ocr_mask	= 0x00000080,
> +	},
>  	{}	/* Terminator */
>  };
>  
> @@ -741,6 +748,7 @@ static int omap3evm_twl_gpio_setup(struct 
> device *dev,
>  	/* link regulators to MMC adapters */
>  	twl4030_vmmc1_supply.dev = mmc[0].dev;
>  	twl4030_vsim_supply.dev = mmc[0].dev;
> +	twl4030_vmmc2_supply.dev = mmc[1].dev;
>  
>  	/*
>  	 * Most GPIOs are for USB OTG.  Some are mostly sent to
> @@ -949,6 +957,7 @@ static int __init omap3_evm_i2c_init(void)
>  	 */
>  	omap3evm_twldata.vmmc1 = &vmmc1_data;
>  	omap3evm_twldata.vsim = &vsim_data;
> +	omap3evm_twldata.vmmc2 = &vmmc2_data;
>  
>  	omap_register_i2c_bus(1, 2600, omap3evm_i2c_boardinfo,
>  			ARRAY_SIZE(omap3evm_i2c_boardinfo));
> @@ -1067,6 +1076,12 @@ static struct omap_board_mux 
> omap35x_board_mux[] __initdata = {
>  				OMAP_PIN_OFF_INPUT_PULLUP | 
> OMAP_PIN_OFF_OUTPUT_LOW |
>  				OMAP_PIN_OFF_WAKEUPENABLE),
>  #endif
> +	OMAP3_MUX(SDMMC2_CLK, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
> +	OMAP3_MUX(SDMMC2_CMD, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
> +	OMAP3_MUX(SDMMC2_DAT0, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
> +	OMAP3_MUX(SDMMC2_DAT1, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
> +	OMAP3_MUX(SDMMC2_DAT2, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
> +	OMAP3_MUX(SDMMC2_DAT3, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),

[sp] What is/will be the behavior on the boards where MMC2 isn't
     available on the board?

     I haven't verified, but this hunk also tells me that you haven't
     updated your development tree for long.

>  
>  	{ .reg_offset = OMAP_MUX_TERMINATOR },
>  };
> diff --git a/arch/arm/mach-omap2/mmc-twl4030.c 
> b/arch/arm/mach-omap2/mmc-twl4030.c
> index 0c3c72d..c56f8c7 100644
> --- a/arch/arm/mach-omap2/mmc-twl4030.c
> +++ b/arch/arm/mach-omap2/mmc-twl4030.c
> @@ -124,6 +124,7 @@ static int twl_mmc_late_init(struct device *dev)
>  			}
>  			hsmmc[i].vcc = reg;
>  			mmc->slots[0].ocr_mask = 
> mmc_regulator_get_ocrmask(reg);
> +			mmc->slots[1].ocr_mask = 
> mmc_regulator_get_ocrmask(reg);
>  
>  			/* allow an aux regulator */
>  			reg = regulator_get(dev, "vmmc_aux");
> diff --git a/arch/arm/mach-omap2/mmc-twl4030.h 
> b/arch/arm/mach-omap2/mmc-twl4030.h
> index a47e685..88bcf46 100644
> --- a/arch/arm/mach-omap2/mmc-twl4030.h
> +++ b/arch/arm/mach-omap2/mmc-twl4030.h
> @@ -34,3 +34,5 @@ static inline void twl4030_mmc_init(struct 
> twl4030_hsmmc_info *info)
>  }
>  
>  #endif
> +extern struct regulator_consumer_supply twl4030_vmmc2_supply;
> +extern struct regulator_init_data vmmc2_data;
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 