Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:43540 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab0GHDj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 23:39:58 -0400
From: "Ghorai, Sukumar" <s-ghorai@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	"Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, "Ben-cohen, Ohad" <ohadb@ti.com>
Date: Thu, 8 Jul 2010 09:09:22 +0530
Subject: RE: [PATCH 15/15] omap: zoom: enable WLAN device
Message-ID: <2A3DCF3DA181AD40BDE86A3150B27B6B030E10C9B7@dbde02.ent.ti.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
 <1278376666-3509-16-git-send-email-ohad@wizery.com>
In-Reply-To: <1278376666-3509-16-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
> owner@vger.kernel.org] On Behalf Of Ohad Ben-Cohen
> Sent: Tuesday, July 06, 2010 6:08 AM
> To: linux-wireless@vger.kernel.org; linux-mmc@vger.kernel.org; linux-
> omap@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org; linux@arm.linux.org.uk;
> Chikkature Rajashekar, Madhusudhan; Luciano Coelho; akpm@linux-
> foundation.org; San Mehat; Ben-cohen, Ohad
> Subject: [PATCH 15/15] omap: zoom: enable WLAN device
> 
> From: Ohad Ben-Cohen <ohadb@ti.com>
> 
> Make it possible to build and use TI's wl1271
> device on the ZOOM boards.
> 
> The device is an embedded SDIO WLAN chip
> that is hardwired to the 3rd mmc controller
> of the ZOOM2/3 boards.
> 
> Signed-off-by: Ohad Ben-Cohen <ohadb@ti.com>
> ---
>  arch/arm/mach-omap2/Kconfig                  |    5 +++++
>  arch/arm/mach-omap2/Makefile                 |    1 +
>  arch/arm/mach-omap2/board-zoom-peripherals.c |   15 +++++++++++++++
>  3 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index b31b6f1..7fee11b 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -131,6 +131,11 @@ config MACH_OMAP_ZOOM3
>  	depends on ARCH_OMAP3
>  	select OMAP_PACKAGE_CBP
> 
> +config OMAP_ZOOM_WLAN
> +	bool "OMAP Zoom board WLAN support"
> +	depends on MACH_OMAP_ZOOM2 || MACH_OMAP_ZOOM3
> +	select MMC_EMBEDDED_SDIO
> +
>  config MACH_CM_T35
>  	bool "CompuLab CM-T35 module"
>  	depends on ARCH_OMAP3
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index ea52b03..ac1bad9 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -129,6 +129,7 @@ obj-$(CONFIG_MACH_OMAP_ZOOM3)		+= board-
> zoom3.o \
>  					   board-zoom-peripherals.o \
>  					   hsmmc.o \
>  					   board-zoom-debugboard.o
> +obj-y					+= board-zoom-wlan.o
>  obj-$(CONFIG_MACH_OMAP_3630SDP)		+= board-3630sdp.o \
>  					   board-zoom-peripherals.o \
>  					   hsmmc.o
> diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-
> omap2/board-zoom-peripherals.c
> index 6b39849..3128cd4 100644
> --- a/arch/arm/mach-omap2/board-zoom-peripherals.c
> +++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
> @@ -16,11 +16,13 @@
>  #include <linux/gpio.h>
>  #include <linux/i2c/twl.h>
>  #include <linux/regulator/machine.h>
> +#include <linux/mmc/host.h>
> 
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
> 
> +#include <mach/board-zoom.h>
>  #include <plat/common.h>
>  #include <plat/usb.h>
> 
> @@ -168,6 +170,18 @@ static struct omap2_hsmmc_info mmc[] __initdata = {
>  		.nonremovable	= true,
>  		.power_saving	= true,
>  	},
> +#ifdef CONFIG_OMAP_ZOOM_WLAN
> +	{
> +		.mmc		= 3,
> +		.wires		= 4,
> +		.gpio_cd	= -EINVAL,
> +		.gpio_wp	= -EINVAL,
> +		.register_embedded_control =
> +				omap_zoom_wlan_register_embedded_control,
> +		.virtual_get_cd = omap_zoom_wlan_get_virtual_cd,
> +		.ocr_mask	= MMC_VDD_165_195,
> +	},
> +#endif
>  	{}      /* Terminator */
>  };
> 
> @@ -282,4 +296,5 @@ void __init zoom_peripherals_init(void)
>  	omap_i2c_init();
>  	usb_musb_init(&musb_board_data);
>  	enable_board_wakeup_source();
> +	omap_zoom_wlan_init();
>  }
[Ghorai] In general we can avoid OMAP_ZOOM_WLAN and MMC_EMBEDDED_SDIO as kconfig option. 1st one is board specific and 2nd one could be generic sdio code. As I mentioned in other patch too.
> --
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
