Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56699 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbdJGVEV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Oct 2017 17:04:21 -0400
Subject: Re: [PATCH] bcma: keep *config menu together
To: LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <c4250321-0c2e-4f9c-7fea-aa1001d9c3a8@infradead.org>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2bdfed1b-5f74-07bf-d016-abe93f6034c7@infradead.org> (sfid-20171007_230447_314764_436303BD)
Date: Sat, 7 Oct 2017 14:04:17 -0700
MIME-Version: 1.0
In-Reply-To: <c4250321-0c2e-4f9c-7fea-aa1001d9c3a8@infradead.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/17 13:01, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Use "if BCMA"/"endif" around all Kconfig symbols so that they are
> kept together in *config menus instead of showing up in unexpected
> places. Also remove "depends on BCMA" since this is handled by the
> "if BCMA" addition.
> 
> Tested with ARCH={x86_64,MIPS} using make {n,menu,g,x}config.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Rafał Miłecki <zajec5@gmail.com>

Rafał -- ping?

> ---
>  drivers/bcma/Kconfig |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> --- lnx-414-rc2.orig/drivers/bcma/Kconfig
> +++ lnx-414-rc2/drivers/bcma/Kconfig
> @@ -10,14 +10,15 @@ menuconfig BCMA
>  	  Bus driver for Broadcom specific Advanced Microcontroller Bus
>  	  Architecture.
>  
> +if BCMA
> +
>  # Support for Block-I/O. SELECT this from the driver that needs it.
>  config BCMA_BLOCKIO
>  	bool
> -	depends on BCMA
>  
>  config BCMA_HOST_PCI_POSSIBLE
>  	bool
> -	depends on BCMA && PCI = y
> +	depends on PCI = y
>  	default y
>  
>  config BCMA_HOST_PCI
> @@ -28,7 +29,6 @@ config BCMA_HOST_PCI
>  
>  config BCMA_HOST_SOC
>  	bool "Support for BCMA in a SoC"
> -	depends on BCMA
>  	help
>  	  Host interface for a Broadcom AIX bus directly mapped into
>  	  the memory. This only works with the Broadcom SoCs from the
> @@ -38,7 +38,7 @@ config BCMA_HOST_SOC
>  
>  config BCMA_DRIVER_PCI
>  	bool "BCMA Broadcom PCI core driver"
> -	depends on BCMA && PCI
> +	depends on PCI
>  	default y
>  	help
>  	  BCMA bus may have many versions of PCIe core. This driver
> @@ -54,13 +54,13 @@ config BCMA_DRIVER_PCI
>  
>  config BCMA_DRIVER_PCI_HOSTMODE
>  	bool "Driver for PCI core working in hostmode"
> -	depends on BCMA && MIPS && BCMA_DRIVER_PCI
> +	depends on MIPS && BCMA_DRIVER_PCI
>  	help
>  	  PCI core hostmode operation (external PCI bus).
>  
>  config BCMA_DRIVER_MIPS
>  	bool "BCMA Broadcom MIPS core driver"
> -	depends on BCMA && MIPS
> +	depends on MIPS
>  	help
>  	  Driver for the Broadcom MIPS core attached to Broadcom specific
>  	  Advanced Microcontroller Bus.
> @@ -91,7 +91,6 @@ config BCMA_NFLASH
>  
>  config BCMA_DRIVER_GMAC_CMN
>  	bool "BCMA Broadcom GBIT MAC COMMON core driver"
> -	depends on BCMA
>  	help
>  	  Driver for the Broadcom GBIT MAC COMMON core attached to Broadcom
>  	  specific Advanced Microcontroller Bus.
> @@ -100,7 +99,7 @@ config BCMA_DRIVER_GMAC_CMN
>  
>  config BCMA_DRIVER_GPIO
>  	bool "BCMA GPIO driver"
> -	depends on BCMA && GPIOLIB
> +	depends on GPIOLIB
>  	select GPIOLIB_IRQCHIP if BCMA_HOST_SOC
>  	help
>  	  Driver to provide access to the GPIO pins of the bcma bus.
> @@ -109,8 +108,9 @@ config BCMA_DRIVER_GPIO
>  
>  config BCMA_DEBUG
>  	bool "BCMA debugging"
> -	depends on BCMA
>  	help
>  	  This turns on additional debugging messages.
>  
>  	  If unsure, say N
> +
> +endif # BCMA
> 
> 
> 


-- 
~Randy
