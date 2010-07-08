Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:34499 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab0GHDkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 23:40:00 -0400
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
Subject: RE: [PATCH 14/15] omap: zoom: add WLAN device
Message-ID: <2A3DCF3DA181AD40BDE86A3150B27B6B030E10C9B4@dbde02.ent.ti.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
 <1278376666-3509-15-git-send-email-ohad@wizery.com>
In-Reply-To: <1278376666-3509-15-git-send-email-ohad@wizery.com>
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
> Subject: [PATCH 14/15] omap: zoom: add WLAN device
> 
> From: Ohad Ben-Cohen <ohadb@ti.com>
> 
> Add WLAN platform device and control
> functions (power and virtual card detect)
> in order to allow software to control the
> embedded SDIO WLAN device which resides on
> the ZOOM board (TI's wl1271 device).
> 
> Based on Android's WLAN control functions by
> San Mehat <san@android.com>.
> 
> Signed-off-by: Ohad Ben-Cohen <ohadb@ti.com>
> ---
>  arch/arm/mach-omap2/board-zoom-wlan.c         |  129
> +++++++++++++++++++++++++
>  arch/arm/mach-omap2/include/mach/board-zoom.h |    5 +
>  2 files changed, 134 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/board-zoom-wlan.c
> 
> diff --git a/arch/arm/mach-omap2/board-zoom-wlan.c b/arch/arm/mach-
> omap2/board-zoom-wlan.c
> new file mode 100644
> index 0000000..7ed5139
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-zoom-wlan.c
> @@ -0,0 +1,129 @@
> +/* mach-omap2/board-zoom-wlan.c
> + *
> + * Board support for wl1271 embedded SDIO device.
> + *
> + * Copyright (C) 2010 Texas Instruments, Inc.
> + *
> + * This file is licensed under the terms of the GNU General Public
> License
> + * version 2. This program is licensed "as is" without any warranty of
> any
> + * kind, whether express or implied.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/mmc/host.h>
> +#include <linux/mmc/sdio_ids.h>
> +#include <linux/err.h>
> +#include <linux/gpio.h>
> +#include <linux/wl12xx.h>
> +
> +#include "mux.h"
> +
> +#ifdef CONFIG_OMAP_ZOOM_WLAN
[Ghorai] Again the file itself is zoom specific, why we need the additional flag?

> +
> +/* these are zoom-specific board numbers */
> +#define OMAP_ZOOM_WLAN_PMENA_GPIO	(101)
> +#define OMAP_ZOOM_WLAN_IRQ_GPIO		(162)
> +
> +/* wl1271 virtual 'card detect' status */
> +static int omap_zoom_wlan_cd;
> +static void (*wlan_set_virtual_cd)(void *dev_id, int card_present);
> +static void (*wlan_set_data)(void *dev_id, void *priv);
> +static void *wlan_host_devid;
> +
> +int omap_zoom_wlan_register_embedded_control(void *dev_id,
> +			void (*set_virtual_cd)(void *dev_id, int card_present),
> +			void (*set_data)(void *dev_id, void *priv))
> +{
> +	if (wlan_host_devid || wlan_set_virtual_cd || wlan_set_data)
> +		return -EBUSY;
> +
> +	wlan_set_virtual_cd = set_virtual_cd;
> +	wlan_set_data = set_data;
> +	wlan_host_devid = dev_id;
> +
> +	return 0;
> +}
> +
> +int omap_zoom_wlan_get_virtual_cd(void)
> +{
> +	return omap_zoom_wlan_cd;
> +}
> +
> +static void omap_zoom_wlan_set_embedded_data(void *priv)
> +{
> +	if (wlan_set_data)
> +		wlan_set_data(wlan_host_devid, priv);
> +	else
> +		pr_err("%s: host controller not registered yet\n", __func__);
> +}
> +
> +static void omap_zoom_wlan_set_carddetect(bool card_present)
> +{
> +	omap_zoom_wlan_cd = card_present ? 1 : 0;
> +
> +	pr_info("%s: %d\n", __func__, omap_zoom_wlan_cd);
> +
> +	if (wlan_set_virtual_cd)
> +		wlan_set_virtual_cd(wlan_host_devid, omap_zoom_wlan_cd);
> +	else
> +		pr_err("%s: host controller not registered yet\n", __func__);
> +}
> +
> +static void omap_zoom_wlan_power(bool enable)
> +{
> +	int val = enable ? 1 : 0;
> +
> +	pr_info("%s: set power %d\n", __func__, val);
> +
> +	gpio_set_value(OMAP_ZOOM_WLAN_PMENA_GPIO, val);
> +}
> +
> +struct wl12xx_platform_data omap_zoom_wlan_control = {
> +	.set_power = omap_zoom_wlan_power,
> +	.set_carddetect = omap_zoom_wlan_set_carddetect,
> +	.set_embedded_data = omap_zoom_wlan_set_embedded_data,
> +	/* ZOOM ref clock is 26 MHz */
> +	.board_ref_clock = 1,
> +	.irq = OMAP_GPIO_IRQ(OMAP_ZOOM_WLAN_IRQ_GPIO),
> +};
> +
> +static struct platform_device omap_zoom_wlan_device = {
> +	.name = "wl1271_sdio",
> +	.id = 1,
> +	.dev = {
> +		.platform_data = &omap_zoom_wlan_control,
> +	},
> +};
> +
> +int __init omap_zoom_wlan_init(void)
> +{
> +	int ret;
> +
> +	ret = gpio_request(OMAP_ZOOM_WLAN_PMENA_GPIO, "wlan_power");
> +	if (ret < 0) {
> +		pr_err("%s: power gpio request failed: %d\n", __func__, ret);
> +		return ret;
> +	}
> +
> +	gpio_direction_output(OMAP_ZOOM_WLAN_PMENA_GPIO, 0);
> +
> +	ret = gpio_request(OMAP_ZOOM_WLAN_IRQ_GPIO, "wlan_irq");
> +	if (ret < 0) {
> +		pr_err("%s: gpio request failed: %d\n", __func__, ret);
> +		return ret;
> +	}
> +	gpio_direction_input(OMAP_ZOOM_WLAN_IRQ_GPIO);
> +
> +	ret = platform_device_register(&omap_zoom_wlan_device);
> +
> +	return ret;
> +}
> +
> +#else
> +int __init omap_zoom_wlan_init(void)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_OMAP_ZOOM_WLAN */
> diff --git a/arch/arm/mach-omap2/include/mach/board-zoom.h
> b/arch/arm/mach-omap2/include/mach/board-zoom.h
> index c93b29e..61bbd81 100644
> --- a/arch/arm/mach-omap2/include/mach/board-zoom.h
> +++ b/arch/arm/mach-omap2/include/mach/board-zoom.h
> @@ -3,3 +3,8 @@
>   */
>  extern int __init zoom_debugboard_init(void);
>  extern void __init zoom_peripherals_init(void);
> +int __init omap_zoom_wlan_init(void);
> +int omap_zoom_wlan_register_embedded_control(void *dev_id,
> +			void (*set_virtual_cd)(void *dev_id, int card_present),
> +			void (*set_data)(void *dev_id, void *priv));
> +int omap_zoom_wlan_get_virtual_cd(void);
> --
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
