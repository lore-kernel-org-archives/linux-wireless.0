Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:65051 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab0JAXKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 19:10:30 -0400
Date: Fri, 1 Oct 2010 16:10:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-omap@vger.kernel.org, linux-wireless@vger.kernel.org,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH] omap: zoom2/3: fix build caused by wl1271 support
Message-ID: <20101001231026.GH3117@atomide.com>
References: <1285965206-17777-1-git-send-email-gadiyar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1285965206-17777-1-git-send-email-gadiyar@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Anand Gadiyar <gadiyar@ti.com> [101001 13:25]:
> Patch "omap: zoom: add mmc3/wl1271 device support" in the
> wireless tree still uses .wires in struct omap2_hsmmc_info.
> .wires has now been replaced with .caps in patch "omap: mmc:
> extended to pass host capabilities from board file" in the
> OMAP tree.
> 
> This causes linux-next as of 20101001 build to break as
> below. Fix this.
> 
>   CC      arch/arm/mach-omap2/board-zoom-peripherals.o
> arch/arm/mach-omap2/board-zoom-peripherals.c:217: error: unknown field 'wires' specified in initializer
> make[1]: *** [arch/arm/mach-omap2/board-zoom-peripherals.o] Error 1
> make: *** [arch/arm/mach-omap2] Error 2

Can you guys please queue this via the wireless tree along with
the other wl1271 patches?

Acked-by: Tony Lindgren <tony@atomide.com>
 
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/board-zoom-peripherals.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/arm/mach-omap2/board-zoom-peripherals.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/mach-omap2/board-zoom-peripherals.c
> +++ linux-2.6/arch/arm/mach-omap2/board-zoom-peripherals.c
> @@ -214,7 +214,7 @@ static struct omap2_hsmmc_info mmc[] __i
>  	{
>  		.name		= "wl1271",
>  		.mmc		= 3,
> -		.wires		= 4,
> +		.caps		= MMC_CAP_4_BIT_DATA,
>  		.gpio_wp	= -EINVAL,
>  		.gpio_cd	= -EINVAL,
>  		.nonremovable	= true,
