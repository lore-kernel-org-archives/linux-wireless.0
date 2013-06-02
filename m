Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:46655
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752060Ab3FBPfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 11:35:37 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH -next 1/2] cw1200:  Rework SDIO platform support to prevent build problems.
Date: Sun,  2 Jun 2013 11:35:31 -0400
Message-Id: <1370187332-18813-1-git-send-email-pizza@shaftnet.org> (sfid-20130602_173540_685611_B796DE0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on discussions with And Bergmann, this patch changes the SDIO
platform code to default to supporting the Sagrad devices, allowing for
it to be overridden in board setup code.  This renders the cw1200_sagrad
module suplerflous, so it is now removed.

It also moves the documentation that was in the cw1200_sagrad source to
the platform header.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/Kconfig           |  17 ++---
 drivers/net/wireless/cw1200/Makefile          |   2 -
 drivers/net/wireless/cw1200/cw1200_sagrad.c   | 106 --------------------------
 drivers/net/wireless/cw1200/cw1200_sdio.c     |  26 ++++++-
 include/linux/platform_data/cw1200_platform.h |  37 ++++++++-
 5 files changed, 66 insertions(+), 122 deletions(-)
 delete mode 100644 drivers/net/wireless/cw1200/cw1200_sagrad.c

diff --git a/drivers/net/wireless/cw1200/Kconfig b/drivers/net/wireless/cw1200/Kconfig
index 13e3611..7a585d4 100644
--- a/drivers/net/wireless/cw1200/Kconfig
+++ b/drivers/net/wireless/cw1200/Kconfig
@@ -13,20 +13,19 @@ config CW1200_WLAN_SDIO
 	depends on CW1200 && MMC
 	help
 	  Enable support for the CW1200 connected via an SDIO bus.
+	  By default this driver only supports the Sagrad SG901-1091/1098 EVK
+	  and similar designs that utilize a hardware reset circuit. To
+	  support different CW1200 SDIO designs you will need to override
+	  the default platform data by calling cw1200_sdio_set_platform_data()
+	  in your board setup file.
 
 config CW1200_WLAN_SPI
 	tristate "Support SPI platforms"
 	depends on CW1200 && SPI
 	help
-	  Enables support for the CW1200 connected via a SPI bus.
-
-config CW1200_WLAN_SAGRAD
-	tristate "Support Sagrad SG901-1091/1098 modules"
-	depends on CW1200_WLAN_SDIO
-	help
-	  This provides the platform data glue to support the
-	  Sagrad SG901-1091/1098 modules in their standard SDIO EVK.
-	  It also includes example SPI platform data.
+	  Enables support for the CW1200 connected via a SPI bus.  You will
+	  need to add appropriate platform data glue in your board setup
+	  file.
 
 menu "Driver debug features"
 	depends on CW1200 && DEBUG_FS
diff --git a/drivers/net/wireless/cw1200/Makefile b/drivers/net/wireless/cw1200/Makefile
index 1aa3682..bc6cbf9 100644
--- a/drivers/net/wireless/cw1200/Makefile
+++ b/drivers/net/wireless/cw1200/Makefile
@@ -16,9 +16,7 @@ cw1200_core-$(CONFIG_PM)	+= pm.o
 
 cw1200_wlan_sdio-y := cw1200_sdio.o
 cw1200_wlan_spi-y := cw1200_spi.o
-cw1200_wlan_sagrad-y := cw1200_sagrad.o
 
 obj-$(CONFIG_CW1200) += cw1200_core.o
 obj-$(CONFIG_CW1200_WLAN_SDIO) += cw1200_wlan_sdio.o
 obj-$(CONFIG_CW1200_WLAN_SPI) += cw1200_wlan_spi.o
-obj-$(CONFIG_CW1200_WLAN_SAGRAD) += cw1200_wlan_sagrad.o
diff --git a/drivers/net/wireless/cw1200/cw1200_sagrad.c b/drivers/net/wireless/cw1200/cw1200_sagrad.c
deleted file mode 100644
index 3f884ac..0000000
--- a/drivers/net/wireless/cw1200/cw1200_sagrad.c
+++ /dev/null
@@ -1,106 +0,0 @@
-/*
- * Platform glue data for ST-Ericsson CW1200 driver
- *
- * Copyright (c) 2013, Sagrad, Inc
- * Author: Solomon Peachy <speachy@sagrad.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/platform_data/cw1200_platform.h>
-
-MODULE_AUTHOR("Solomon Peachy <speachy@sagrad.com>");
-MODULE_DESCRIPTION("ST-Ericsson CW1200 Platform glue driver");
-MODULE_LICENSE("GPL");
-
-/* Define just one of these.  Feel free to customize as needed */
-#define SAGRAD_1091_1098_EVK_SDIO
-/* #define SAGRAD_1091_1098_EVK_SPI */
-
-#ifdef SAGRAD_1091_1098_EVK_SDIO
-static int cw1200_power_ctrl(const struct cw1200_platform_data_sdio *pdata,
-			     bool enable)
-{
-	/* Control 3v3 and 1v8 to hardware as appropriate */
-	/* Note this is not needed if it's controlled elsewhere or always on */
-
-	/* May require delay for power to stabilize */
-	return 0;
-}
-
-static int cw1200_clk_ctrl(const struct cw1200_platform_data_sdio *pdata,
-			   bool enable)
-{
-	/* Turn CLK_32K off and on as appropriate. */
-	/* Note this is not needed if it's always on */
-
-	/* May require delay for clock to stabilize */
-	return 0;
-}
-
-static struct cw1200_platform_data_sdio cw1200_platform_data = {
-	.ref_clk = 38400,
-	.have_5ghz = false,
-#if 0
-	.reset = GPIO_RF_RESET, /* Replace as appropriate */
-	.powerup = GPIO_RF_POWERUP, /* Replace as appropriate */
-	.irq = GPIO_TO_IRQ(GPIO_RF_IRQ), /* Replace as appropriate */
-#endif
-	.power_ctrl = cw1200_power_ctrl,
-	.clk_ctrl = cw1200_clk_ctrl,
-/*	.macaddr = ??? */
-	.sdd_file = "sdd_sagrad_1091_1098.bin",
-};
-#endif
-
-#ifdef SAGRAD_1091_1098_EVK_SPI
-static int cw1200_power_ctrl(const struct cw1200_platform_data_spi *pdata,
-			     bool enable)
-{
-	/* Control 3v3 and 1v8 to hardware as appropriate */
-	/* Note this is not needed if it's controlled elsewhere or always on */
-
-	/* May require delay for power to stabilize */
-	return 0;
-}
-static int cw1200_clk_ctrl(const struct cw1200_platform_data_spi *pdata,
-			   bool enable)
-{
-	/* Turn CLK_32K off and on as appropriate. */
-	/* Note this is not needed if it's always on */
-
-	/* May require delay for clock to stabilize */
-	return 0;
-}
-
-static struct cw1200_platform_data_spi cw1200_platform_data = {
-	.ref_clk = 38400,
-	.spi_bits_per_word = 16,
-	.reset = GPIO_RF_RESET, /* Replace as appropriate */
-	.powerup = GPIO_RF_POWERUP, /* Replace as appropriate */
-	.power_ctrl = cw1200_power_ctrl,
-	.clk_ctrl = cw1200_clk_ctrl,
-/*	.macaddr = ??? */
-	.sdd_file = "sdd_sagrad_1091_1098.bin",
-};
-static struct spi_board_info myboard_spi_devices[] __initdata = {
-	{
-		.modalias = "cw1200_wlan_spi",
-		.max_speed_hz = 10000000, /* 52MHz Max */
-		.bus_num = 0,
-		.irq = WIFI_IRQ,
-		.platform_data = &cw1200_platform_data,
-		.chip_select = 0,
-	},
-};
-#endif
-
-
-const void *cw1200_get_platform_data(void)
-{
-	return &cw1200_platform_data;
-}
-EXPORT_SYMBOL_GPL(cw1200_get_platform_data);
diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wireless/cw1200/cw1200_sdio.c
index e78bb37..913a3eb 100644
--- a/drivers/net/wireless/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
@@ -30,6 +30,21 @@ MODULE_LICENSE("GPL");
 
 #define SDIO_BLOCK_SIZE (512)
 
+/* Default platform data for Sagrad modules */
+static struct cw1200_platform_data_sdio sagrad_109x_evk_platform_data = {
+	.ref_clk = 38400,
+	.have_5ghz = false,
+	.sdd_file = "sdd_sagrad_1091_1098.bin",
+};
+
+/* Allow platform data to be overridden */
+static struct cw1200_platform_data_sdio *global_plat_data = &sagrad_109x_evk_platform_data;
+
+void __init cw1200_sdio_set_platform_data(struct cw1200_platform_data_sdio *pdata)
+{
+	global_plat_data = pdata;
+}
+
 struct hwbus_priv {
 	struct sdio_func	*func;
 	struct cw1200_common	*core;
@@ -262,7 +277,7 @@ static struct hwbus_ops cw1200_sdio_hwbus_ops = {
 
 /* Probe Function to be called by SDIO stack when device is discovered */
 static int cw1200_sdio_probe(struct sdio_func *func,
-				       const struct sdio_device_id *id)
+			     const struct sdio_device_id *id)
 {
 	struct hwbus_priv *self;
 	int status;
@@ -281,7 +296,7 @@ static int cw1200_sdio_probe(struct sdio_func *func,
 
 	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
 
-	self->pdata = cw1200_get_platform_data();
+	self->pdata = global_plat_data; /* FIXME */
 	self->func = func;
 	sdio_set_drvdata(func, self);
 	sdio_claim_host(func);
@@ -376,7 +391,8 @@ static int __init cw1200_sdio_init(void)
 	const struct cw1200_platform_data_sdio *pdata;
 	int ret;
 
-	pdata = cw1200_get_platform_data();
+	/* FIXME -- this won't support multiple devices */
+	pdata = global_plat_data;
 
 	if (cw1200_sdio_on(pdata)) {
 		ret = -1;
@@ -398,7 +414,9 @@ err:
 static void __exit cw1200_sdio_exit(void)
 {
 	const struct cw1200_platform_data_sdio *pdata;
-	pdata = cw1200_get_platform_data();
+
+	/* FIXME -- this won't support multiple devices */
+	pdata = global_plat_data;
 	sdio_unregister_driver(&sdio_driver);
 	cw1200_sdio_off(pdata);
 }
diff --git a/include/linux/platform_data/cw1200_platform.h b/include/linux/platform_data/cw1200_platform.h
index 4454c16..c6fbc3c 100644
--- a/include/linux/platform_data/cw1200_platform.h
+++ b/include/linux/platform_data/cw1200_platform.h
@@ -41,6 +41,41 @@ struct cw1200_platform_data_sdio {
 	const char *sdd_file;  /* if NULL, will use default for detected hw type */
 };
 
-const void *cw1200_get_platform_data(void);
+
+/* An example of SPI support in your board setup file:
+
+   static struct cw1200_platform_data_spi cw1200_platform_data = {
+       .ref_clk = 38400,
+       .spi_bits_per_word = 16,
+       .reset = GPIO_RF_RESET,
+       .powerup = GPIO_RF_POWERUP,
+       .macaddr = wifi_mac_addr,
+       .sdd_file = "sdd_sagrad_1091_1098.bin",
+  };
+  static struct spi_board_info myboard_spi_devices[] __initdata = {
+       {
+               .modalias = "cw1200_wlan_spi",
+               .max_speed_hz = 52000000,
+               .bus_num = 0,
+               .irq = WIFI_IRQ,
+               .platform_data = &cw1200_platform_data,
+               .chip_select = 0,
+       },
+  };
+
+ */
+
+/* An example of SDIO support in your board setup file:
+
+  static struct cw1200_platform_data_sdio my_cw1200_platform_data = {
+	.ref_clk = 38400,
+	.have_5ghz = false,
+	.sdd_file = "sdd_myplatform.bin",
+  };
+  cw1200_sdio_set_platform_data(&my_cw1200_platform_data);
+
+ */
+
+void __init cw1200_sdio_set_platform_data(struct cw1200_platform_data_sdio *pdata);
 
 #endif /* CW1200_PLAT_H_INCLUDED */
-- 
1.8.2.1

