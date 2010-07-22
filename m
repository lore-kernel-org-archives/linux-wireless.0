Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37402 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab0GVXSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 19:18:30 -0400
MIME-Version: 1.0
In-Reply-To: <676FD6AA0F002F49B89E70F0C5EFD22C1311192A47@dlee04.ent.ti.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
	<1279733634-21974-20-git-send-email-ohad@wizery.com> <676FD6AA0F002F49B89E70F0C5EFD22C1311192A47@dlee04.ent.ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 23 Jul 2010 02:18:08 +0300
Message-ID: <AANLkTim3RWv2-qi9UMg1imwKTJuh3GstdjMTxz64uOHf@mail.gmail.com>
Subject: Re: [PATCH v2 19/20] omap: zoom: keep the MMC3 wl1271 device powered
	off
To: "Gabay, Benzy" <benzyg@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	"Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	"Pandita, Vikram" <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gever,

On Wed, Jul 21, 2010 at 9:55 PM, Gabay, Benzy <benzyg@ti.com> wrote:
> From: Ohad Ben-Cohen [mailto:ohad@wizery.com]
> Sent: Wednesday, July 21, 2010 12:34 PM
> To: linux-wireless@vger.kernel.org; linux-mmc@vger.kernel.org; linux-omap@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org; linux@arm.linux.org.uk; Chikkature Rajashekar, Madhusudhan; Luciano Coelho; akpm@linux-foundation.org; San Mehat; Roger Quadros; Tony Lindgren; Nicolas Pitre; Pandita, Vikram; Kalle Valo; Ohad Ben-Cohen
> Subject: [PATCH v2 19/20] omap: zoom: keep the MMC3 wl1271 device powered off
>
> Keep the MMC3 wl1271 WLAN device powered off until its
> SDIO function driver requests otherwise.
>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  arch/arm/mach-omap2/board-zoom-peripherals.c |    1 +
>  arch/arm/mach-omap2/hsmmc.c                  |    3 +++
>  arch/arm/mach-omap2/hsmmc.h                  |    1 +
>  arch/arm/plat-omap/include/plat/mmc.h        |    3 +++
>  drivers/mmc/host/omap_hsmmc.c                |    3 +++
>  5 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
> index 3230801..3ab9125 100644
> --- a/arch/arm/mach-omap2/board-zoom-peripherals.c
> +++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
> @@ -217,6 +217,7 @@ static struct omap2_hsmmc_info mmc[] __initdata = {
>                .gpio_wp        = -EINVAL,
>                .gpio_cd        = -EINVAL,
>                .ocr_mask       = MMC_VDD_165_195,
> +               .dont_power_card = true,
>                .priv_data      = &omap_zoom_wlan_data,
>        },
>        {}      /* Terminator */
...
> --
> 1.7.0.4
>
> [Benzy Gabay] small comment: Please make sure that all 127x related changes are not bounded only to MMC3.
> On OMAP4 WLAN is used on MMC5.


The only place MMC3 is bound is in the board files (see code snippet
above), so that should be ok.

I can probably split this patch to make this more obvious just by
reading the diffstat if you prefer.


Thanks,
Ohad.


>
