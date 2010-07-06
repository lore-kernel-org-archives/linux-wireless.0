Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:57174 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab0GFMd5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 08:33:57 -0400
Message-ID: <4C33228D.8000908@nokia.com>
Date: Tue, 06 Jul 2010 15:33:17 +0300
From: Roger Quadros <roger.quadros@nokia.com>
MIME-Version: 1.0
To: ext Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, Ohad Ben-Cohen <ohadb@ti.com>
Subject: Re: [PATCH 14/15] omap: zoom: add WLAN device
References: <1278376666-3509-1-git-send-email-ohad@wizery.com> <1278376666-3509-15-git-send-email-ohad@wizery.com>
In-Reply-To: <1278376666-3509-15-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ohad,

On 07/06/2010 03:37 AM, ext Ohad Ben-Cohen wrote:
> From: Ohad Ben-Cohen<ohadb@ti.com>
>
> Add WLAN platform device and control
> functions (power and virtual card detect)
> in order to allow software to control the
> embedded SDIO WLAN device which resides on
> the ZOOM board (TI's wl1271 device).
>
> Based on Android's WLAN control functions by
> San Mehat<san@android.com>.
>
> Signed-off-by: Ohad Ben-Cohen<ohadb@ti.com>
> ---
>   arch/arm/mach-omap2/board-zoom-wlan.c         |  129 +++++++++++++++++++++++++
>   arch/arm/mach-omap2/include/mach/board-zoom.h |    5 +
>   2 files changed, 134 insertions(+), 0 deletions(-)
>   create mode 100644 arch/arm/mach-omap2/board-zoom-wlan.c
>
> diff --git a/arch/arm/mach-omap2/board-zoom-wlan.c b/arch/arm/mach-omap2/board-zoom-wlan.c
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
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#include<linux/kernel.h>
> +#include<linux/init.h>
> +#include<linux/platform_device.h>
> +#include<linux/mmc/host.h>
> +#include<linux/mmc/sdio_ids.h>
> +#include<linux/err.h>
> +#include<linux/gpio.h>
> +#include<linux/wl12xx.h>
> +
> +#include "mux.h"
> +
> +#ifdef CONFIG_OMAP_ZOOM_WLAN
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

Can we consider that OMAP_ZOOM_WLAN_PMENA_GPIO is equivalent to vmmc supply or 
equivalent to supply voltage to the SDIO card?

If yes, then did you consider using the fixed regulator framework to define a 
'vmmc' supply (based on OMAP_ZOOM_WLAN_PMENA_GPIO). Then the SDIO/MMC core 
should take care of controlling this supply.

regards,
-roger
