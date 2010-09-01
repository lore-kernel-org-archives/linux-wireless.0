Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34731 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab0IAV3d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 17:29:33 -0400
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
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v5 7/7] omap: zoom: add mmc3/wl1271 device support
Date: Thu,  2 Sep 2010 00:26:50 +0300
Message-Id: <1283376410-9999-8-git-send-email-ohad@wizery.com>
In-Reply-To: <1283376410-9999-1-git-send-email-ohad@wizery.com>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add MMC3 support on ZOOM, which is hardwired to the wl1271 device.

The wl1271 is a 4-wire, 1.8V, embedded SDIO WLAN device with an
external IRQ line, and power-controlled by a GPIO-based fixed regulator.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/mach-omap2/board-zoom-peripherals.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index de88635..7ee5663 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -17,6 +17,7 @@
 #include <linux/i2c/twl.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
+#include <linux/wl12xx.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -29,6 +30,7 @@
 #include "hsmmc.h"
 
 #define OMAP_ZOOM_WLAN_PMENA_GPIO	(101)
+#define OMAP_ZOOM_WLAN_IRQ_GPIO		(162)
 
 /* Zoom2 has Qwerty keyboard*/
 static int board_keymap[] = {
@@ -185,6 +187,12 @@ static struct platform_device omap_vwlan_device = {
 	},
 };
 
+struct wl12xx_platform_data omap_zoom_wlan_data = {
+	.irq = OMAP_GPIO_IRQ(OMAP_ZOOM_WLAN_IRQ_GPIO),
+	/* ZOOM ref clock is 26 MHz */
+	.board_ref_clock = 1,
+};
+
 static struct omap2_hsmmc_info mmc[] __initdata = {
 	{
 		.name		= "external",
@@ -202,6 +210,14 @@ static struct omap2_hsmmc_info mmc[] __initdata = {
 		.nonremovable	= true,
 		.power_saving	= true,
 	},
+	{
+		.name		= "wl1271",
+		.mmc		= 3,
+		.wires		= 4,
+		.gpio_wp	= -EINVAL,
+		.gpio_cd	= -EINVAL,
+		.nonremovable	= true,
+	},
 	{}      /* Terminator */
 };
 
@@ -313,6 +329,9 @@ static void enable_board_wakeup_source(void)
 
 void __init zoom_peripherals_init(void)
 {
+	if (wl12xx_set_platform_data(&omap_zoom_wlan_data))
+		pr_err("error setting wl12xx data\n");
+
 	omap_i2c_init();
 	platform_device_register(&omap_vwlan_device);
 	usb_musb_init(&musb_board_data);
-- 
1.7.0.4

