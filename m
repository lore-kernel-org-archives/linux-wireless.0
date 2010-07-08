Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:43527 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab0GHDjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 23:39:48 -0400
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
Date: Thu, 8 Jul 2010 09:09:21 +0530
Subject: RE: [PATCH 06/15] omap zoom2: wlan board muxing
Message-ID: <2A3DCF3DA181AD40BDE86A3150B27B6B030E10C9B3@dbde02.ent.ti.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
 <1278376666-3509-7-git-send-email-ohad@wizery.com>
In-Reply-To: <1278376666-3509-7-git-send-email-ohad@wizery.com>
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
> Subject: [PATCH 06/15] omap zoom2: wlan board muxing
> 
> From: Ohad Ben-Cohen <ohadb@ti.com>
> 
> Add board muxing to support the wlan wl1271 chip that is
> hardwired to mmc2 (third mmc controller) on the ZOOM2.
> 
> Signed-off-by: Ohad Ben-Cohen <ohadb@ti.com>
> ---
>  arch/arm/mach-omap2/board-zoom2.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-zoom2.c b/arch/arm/mach-
> omap2/board-zoom2.c
> index 803ef14..00871be 100644
> --- a/arch/arm/mach-omap2/board-zoom2.c
> +++ b/arch/arm/mach-omap2/board-zoom2.c
> @@ -71,6 +71,21 @@ static struct twl4030_platform_data zoom2_twldata = {
> 
>  #ifdef CONFIG_OMAP_MUX
>  static struct omap_board_mux board_mux[] __initdata = {
> +#ifdef CONFIG_OMAP_ZOOM_WLAN
[Ghorai] This is zoom board specific file, So why need this additional flag?

> +	/* WLAN IRQ - GPIO 162 */
> +	OMAP3_MUX(MCBSP1_CLKX, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP),
> +	/* WLAN POWER ENABLE - GPIO 101 */
> +	OMAP3_MUX(CAM_D2, OMAP_MUX_MODE4 | OMAP_PIN_OUTPUT),
> +	/* WLAN SDIO: MMC3 CMD */
> +	OMAP3_MUX(MCSPI1_CS1, OMAP_MUX_MODE3 | OMAP_PIN_INPUT_PULLUP),
> +	/* WLAN SDIO: MMC3 CLK */
> +	OMAP3_MUX(ETK_CLK, OMAP_MUX_MODE2 | OMAP_PIN_INPUT_PULLUP),
> +	/* WLAN SDIO: MMC3 DAT[0-3] */
> +	OMAP3_MUX(ETK_D3, OMAP_MUX_MODE2 | OMAP_PIN_INPUT_PULLUP),
> +	OMAP3_MUX(ETK_D4, OMAP_MUX_MODE2 | OMAP_PIN_INPUT_PULLUP),
> +	OMAP3_MUX(ETK_D5, OMAP_MUX_MODE2 | OMAP_PIN_INPUT_PULLUP),
> +	OMAP3_MUX(ETK_D6, OMAP_MUX_MODE2 | OMAP_PIN_INPUT_PULLUP),
> +#endif
>  	{ .reg_offset = OMAP_MUX_TERMINATOR },
>  };
>  #else
> --
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
