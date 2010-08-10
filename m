Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62839 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933359Ab0HJWN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 18:13:57 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v3 9/9] omap: zoom: add mmc3/wl1271 device support
Date: Wed, 11 Aug 2010 01:12:28 +0300
Message-Id: <1281478348-24833-10-git-send-email-ohad@wizery.com>
In-Reply-To: <1281478348-24833-1-git-send-email-ohad@wizery.com>
References: <1281478348-24833-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add MMC3 support on ZOOM, which has the wl1271 device hardwired to.

The wl1271 is a 4-wire, 1.8V, embedded SDIO WLAN device with an
external IRQ line, and power-controlled by a GPIO-based fixed regulator.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/mach-omap2/board-zoom-peripherals.c |   34 ++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index de88635..82776bc 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -17,6 +17,8 @@
 #include <linux/i2c/twl.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
+#include <linux/mmc/host.h>
+#include <linux/wl12xx.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -29,6 +31,7 @@
 #include "hsmmc.h"
 
 #define OMAP_ZOOM_WLAN_PMENA_GPIO	(101)
+#define OMAP_ZOOM_WLAN_IRQ_GPIO		(162)
 
 /* Zoom2 has Qwerty keyboard*/
 static int board_keymap[] = {
@@ -185,6 +188,28 @@ static struct platform_device omap_vwlan_device = {
 	},
 };
 
+struct wl12xx_platform_data omap_zoom_wlan_data = {
+	/* ZOOM ref clock is 26 MHz */
+	.board_ref_clock = 1,
+};
+
+static struct resource omap_zoom_wl1271_resources[] = {
+	{
+		.start = OMAP_GPIO_IRQ(OMAP_ZOOM_WLAN_IRQ_GPIO),
+		.end = OMAP_GPIO_IRQ(OMAP_ZOOM_WLAN_IRQ_GPIO),
+		.flags = IORESOURCE_IRQ,
+	}
+};
+static struct platform_device omap_zoom_wl1271 = {
+	.name		= "wl1271_plat.2",
+	.id		= -1,
+	.resource	= omap_zoom_wl1271_resources,
+	.num_resources	= ARRAY_SIZE(omap_zoom_wl1271_resources),
+	.dev = {
+		.platform_data = &omap_zoom_wlan_data,
+	},
+};
+
 static struct omap2_hsmmc_info mmc[] __initdata = {
 	{
 		.name		= "external",
@@ -202,6 +227,14 @@ static struct omap2_hsmmc_info mmc[] __initdata = {
 		.nonremovable	= true,
 		.power_saving	= true,
 	},
+	{
+		.name		= "wl1271",
+		.mmc		= 3,
+		.wires		= 4,
+		.gpio_wp	= -EINVAL,
+		.gpio_cd	= -EINVAL,
+		.ocr_mask	= MMC_VDD_165_195,
+	},
 	{}      /* Terminator */
 };
 
@@ -313,6 +346,7 @@ static void enable_board_wakeup_source(void)
 
 void __init zoom_peripherals_init(void)
 {
+	platform_device_register(&omap_zoom_wl1271);
 	omap_i2c_init();
 	platform_device_register(&omap_vwlan_device);
 	usb_musb_init(&musb_board_data);
-- 
1.7.0.4

