Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:17714 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab0IWIOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 04:14:34 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, linux-wireless@vger.kernel.org,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] omap: beagle: add support for wl1271 on the board file
Date: Thu, 23 Sep 2010 11:14:23 +0300
Message-Id: <1285229663-4224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add board configuration for the wl1271 daughter board.  This patch is based
on Ohad Ben-Cohen's patches for Zoom boards.

Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 arch/arm/mach-omap2/board-omap3beagle.c |   71 +++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 87969c7..820a198 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -29,7 +29,9 @@
 #include <linux/mtd/nand.h>
 
 #include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
 #include <linux/i2c/twl.h>
+#include <linux/wl12xx.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -48,6 +50,9 @@
 #include "mux.h"
 #include "hsmmc.h"
 
+#define OMAP_BEAGLE_WLAN_EN_GPIO    (139)
+#define OMAP_BEAGLE_WLAN_IRQ_GPIO   (137)
+
 #define NAND_BLOCK_SIZE		SZ_128K
 
 static struct mtd_partition omap3beagle_nand_partitions[] = {
@@ -163,12 +168,25 @@ static void __init beagle_display_init(void)
 
 #include "sdram-micron-mt46h32m32lf-6.h"
 
+struct wl12xx_platform_data omap_beagle_wlan_data __initdata = {
+	.irq = OMAP_GPIO_IRQ(OMAP_BEAGLE_WLAN_IRQ_GPIO),
+	.board_ref_clock = 2, /* 38.4 MHz */
+};
+
 static struct omap2_hsmmc_info mmc[] = {
 	{
 		.mmc		= 1,
 		.wires		= 8,
 		.gpio_wp	= 29,
 	},
+	{
+		.name           = "wl1271",
+		.mmc            = 2,
+		.wires          = 4,
+		.gpio_wp        = -EINVAL,
+		.gpio_cd        = -EINVAL,
+		.nonremovable   = true,
+	},
 	{}	/* Terminator */
 };
 
@@ -176,10 +194,43 @@ static struct regulator_consumer_supply beagle_vmmc1_supply = {
 	.supply			= "vmmc",
 };
 
+static struct regulator_consumer_supply beagle_vmmc2_supply = {
+	.supply         = "vmmc",
+	.dev_name       = "mmci-omap-hs.1",
+};
+
+
 static struct regulator_consumer_supply beagle_vsim_supply = {
 	.supply			= "vmmc_aux",
 };
 
+
+static struct regulator_init_data beagle_vmmc2 = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = 1,
+	.consumer_supplies = &beagle_vmmc2_supply,
+};
+
+static struct fixed_voltage_config beagle_vwlan = {
+	.supply_name = "vwl1271",
+	.microvolts = 1800000,  /* 1.8V */
+	.gpio = OMAP_BEAGLE_WLAN_EN_GPIO,
+	.startup_delay = 70000, /* 70ms */
+	.enable_high = 1,
+	.enabled_at_boot = 0,
+	.init_data = &beagle_vmmc2,
+};
+
+static struct platform_device omap_vwlan_device = {
+	.name           = "reg-fixed-voltage",
+	.id             = 1,
+	.dev = {
+		.platform_data = &beagle_vwlan,
+	},
+};
+
 static struct gpio_led gpio_leds[];
 
 static int beagle_twl_gpio_setup(struct device *dev,
@@ -449,6 +500,19 @@ static const struct ehci_hcd_omap_platform_data ehci_pdata __initconst = {
 
 #ifdef CONFIG_OMAP_MUX
 static struct omap_board_mux board_mux[] __initdata = {
+	/* WLAN IRQ - GPIO 137 */
+	OMAP3_MUX(SDMMC2_DAT5,  OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP),
+	/* WLAN POWER ENABLE - GPIO 139 */
+	OMAP3_MUX(SDMMC2_DAT7,  OMAP_MUX_MODE4 | OMAP_PIN_OUTPUT),
+	/* WLAN SDIO: MMC2 CMD */
+	OMAP3_MUX(SDMMC2_CMD,   OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	/* WLAN SDIO: MMC2 CLK */
+	OMAP3_MUX(SDMMC2_CLK,   OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	/* WLAN SDIO: MMC2 DAT[0-3] */
+	OMAP3_MUX(SDMMC2_DAT0,  OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP3_MUX(SDMMC2_DAT1,  OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP3_MUX(SDMMC2_DAT2,  OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP3_MUX(SDMMC2_DAT3,  OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
 	{ .reg_offset = OMAP_MUX_TERMINATOR },
 };
 #else
@@ -463,10 +527,17 @@ static struct omap_musb_board_data musb_board_data = {
 
 static void __init omap3_beagle_init(void)
 {
+	int ret;
+
 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
+	if (wl12xx_set_platform_data(&omap_beagle_wlan_data))
+		pr_err("error setting wl12xx data\n");
+
 	omap3_beagle_i2c_init();
 	platform_add_devices(omap3_beagle_devices,
 			ARRAY_SIZE(omap3_beagle_devices));
+	platform_device_register(&omap_vwlan_device);
+
 	omap_serial_init();
 
 	omap_mux_init_gpio(170, OMAP_PIN_INPUT);
-- 
1.6.3.3

