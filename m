Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58384 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab0IOXb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 19:31:26 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-omap@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v6 6/7] omap: zoom: add fixed regulator device for wlan
Date: Thu, 16 Sep 2010 01:32:09 +0200
Message-Id: <1284593529-30100-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a fixed regulator vmmc device to enable power control
of the wl1271 wlan device.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/mach-omap2/board-zoom-peripherals.c |   35 ++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index 6b39849..de88635 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -16,6 +16,7 @@
 #include <linux/gpio.h>
 #include <linux/i2c/twl.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -27,6 +28,8 @@
 #include "mux.h"
 #include "hsmmc.h"
 
+#define OMAP_ZOOM_WLAN_PMENA_GPIO	(101)
+
 /* Zoom2 has Qwerty keyboard*/
 static int board_keymap[] = {
 	KEY(0, 0, KEY_E),
@@ -106,6 +109,11 @@ static struct regulator_consumer_supply zoom_vmmc2_supply = {
 	.supply		= "vmmc",
 };
 
+static struct regulator_consumer_supply zoom_vmmc3_supply = {
+	.supply		= "vmmc",
+	.dev_name	= "mmci-omap-hs.2",
+};
+
 /* VMMC1 for OMAP VDD_MMC1 (i/o) and MMC1 card */
 static struct regulator_init_data zoom_vmmc1 = {
 	.constraints = {
@@ -151,6 +159,32 @@ static struct regulator_init_data zoom_vsim = {
 	.consumer_supplies      = &zoom_vsim_supply,
 };
 
+static struct regulator_init_data zoom_vmmc3 = {
+	.constraints = {
+		.valid_ops_mask	= REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = 1,
+	.consumer_supplies = &zoom_vmmc3_supply,
+};
+
+static struct fixed_voltage_config zoom_vwlan = {
+	.supply_name = "vwl1271",
+	.microvolts = 1800000, /* 1.8V */
+	.gpio = OMAP_ZOOM_WLAN_PMENA_GPIO,
+	.startup_delay = 70000, /* 70msec */
+	.enable_high = 1,
+	.enabled_at_boot = 0,
+	.init_data = &zoom_vmmc3,
+};
+
+static struct platform_device omap_vwlan_device = {
+	.name		= "reg-fixed-voltage",
+	.id		= 1,
+	.dev = {
+		.platform_data = &zoom_vwlan,
+	},
+};
+
 static struct omap2_hsmmc_info mmc[] __initdata = {
 	{
 		.name		= "external",
@@ -280,6 +314,7 @@ static void enable_board_wakeup_source(void)
 void __init zoom_peripherals_init(void)
 {
 	omap_i2c_init();
+	platform_device_register(&omap_vwlan_device);
 	usb_musb_init(&musb_board_data);
 	enable_board_wakeup_source();
 }
-- 
1.7.0.4

