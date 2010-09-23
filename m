Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47868 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab0IWLpi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 07:45:38 -0400
Date: Thu, 23 Sep 2010 14:45:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"tony@atomide.com" <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH v2] omap: beagle: add support for wl1271 on the board
 file
Message-ID: <20100923114528.GL4580@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1285230003-5065-1-git-send-email-luciano.coelho@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <1285230003-5065-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Sep 23, 2010 at 03:20:03AM -0500, Luciano Coelho wrote:
> static struct mtd_partition omap3beagle_nand_partitions[] = {
>@@ -163,12 +168,25 @@ static void __init beagle_display_init(void)
>
> #include "sdram-micron-mt46h32m32lf-6.h"
>
>+struct wl12xx_platform_data omap_beagle_wlan_data __initdata = {
>+	.irq = OMAP_GPIO_IRQ(OMAP_BEAGLE_WLAN_IRQ_GPIO),

can you pass IRQ as a struct resource ?

>+	.board_ref_clock = 2, /* 38.4 MHz */
>+};
>+
> static struct omap2_hsmmc_info mmc[] = {
> 	{
> 		.mmc		= 1,
> 		.wires		= 8,
> 		.gpio_wp	= 29,
> 	},
>+	{
>+		.name           = "wl1271",
>+		.mmc            = 2,
>+		.wires          = 4,
>+		.gpio_wp        = -EINVAL,
>+		.gpio_cd        = -EINVAL,
>+		.nonremovable   = true,
>+	},
> 	{}	/* Terminator */
> };
>
>@@ -176,10 +194,43 @@ static struct regulator_consumer_supply beagle_vmmc1_supply = {
> 	.supply			= "vmmc",
> };
>
>+static struct regulator_consumer_supply beagle_vmmc2_supply = {
>+	.supply         = "vmmc",
>+	.dev_name       = "mmci-omap-hs.1",
>+};

this should be:

static struct regulator_consume_supply beagle_vmmc2_supplies = {
	{
		.supply		= "vmmc",
		.dev_name	= "mmci-omap-hs.1",
	},
};

>+static struct regulator_init_data beagle_vmmc2 = {
>+	.constraints = {
>+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
>+	},
>+	.num_consumer_supplies = 1,
>+	.consumer_supplies = &beagle_vmmc2_supply,

please tabify, it's easier for reading, same for all below:

	constrants	= {
		.valid_ops_mask	= REGULATOR_CHANGE_STATUS,
	},
	.num_consumer_supplies	= ARRAY_SIZE(beagle_vmmc2_supplies),
	.consumer_supplies	= beagle_vmmc2_supplies,

>@@ -464,9 +528,14 @@ static struct omap_musb_board_data musb_board_data = {
> static void __init omap3_beagle_init(void)
> {
> 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
>+	if (wl12xx_set_platform_data(&omap_beagle_wlan_data))
>+		pr_err("error setting wl12xx data\n");
>+
> 	omap3_beagle_i2c_init();
> 	platform_add_devices(omap3_beagle_devices,
> 			ARRAY_SIZE(omap3_beagle_devices));
>+	platform_device_register(&omap_vwlan_device);
>+

trailing blank line. Also, you could just add omap_vwlan_device to
omap3_beagle_devices.

>diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
>index 4134f44..8bb028e 100644
>--- a/drivers/net/wireless/wl12xx/wl1271.h
>+++ b/drivers/net/wireless/wl12xx/wl1271.h
>@@ -60,7 +60,7 @@ enum {
> 	DEBUG_ALL	= ~0,
> };
>
>-#define DEBUG_LEVEL (DEBUG_NONE)
>+#define DEBUG_LEVEL (DEBUG_MAC80211 | DEBUG_CMD | DEBUG_ACX | DEBUG_BOOT)

some debugging trash came into commit ??

-- 
balbi
