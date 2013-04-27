Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:57935 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3D0T2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 15:28:11 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 13/14] cw1200: v6: Module defining platform data for Sagrad SG901-1091/1098 modules
Date: Sat, 27 Apr 2013 15:27:26 -0400
Message-Id: <1367090847-11937-14-git-send-email-pizza@shaftnet.org> (sfid-20130427_212936_376838_C7BCB952)
In-Reply-To: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
References: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/cw1200_sagrad.c | 145 ++++++++++++++++++++++++++++
 1 file changed, 145 insertions(+)
 create mode 100644 drivers/net/wireless/cw1200/cw1200_sagrad.c

diff --git a/drivers/net/wireless/cw1200/cw1200_sagrad.c b/drivers/net/wireless/cw1200/cw1200_sagrad.c
new file mode 100644
index 0000000..a5ada0e
--- /dev/null
+++ b/drivers/net/wireless/cw1200/cw1200_sagrad.c
@@ -0,0 +1,145 @@
+/*
+ * Platform glue data for ST-Ericsson CW1200 driver
+ *
+ * Copyright (c) 2013, Sagrad, Inc
+ * Author: Solomon Peachy <speachy@sagrad.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/cw1200_platform.h>
+
+MODULE_AUTHOR("Solomon Peachy <speachy@sagrad.com>");
+MODULE_DESCRIPTION("ST-Ericsson CW1200 Platform glue driver");
+MODULE_LICENSE("GPL");
+
+/* Define just one of these.  Feel free to customize as needed */
+#define SAGRAD_1091_1098_EVK_SDIO
+/* #define SAGRAD_1091_1098_EVK_SPI */
+
+#ifdef SAGRAD_1091_1098_EVK_SDIO
+#if 0
+static struct resource cw1200_href_resources[] = {
+	{
+		.start = 215,  /* fix me as appropriate */
+		.end = 215,    /* ditto */
+		.flags = IORESOURCE_IO,
+		.name = "cw1200_wlan_reset",
+	},
+	{
+		.start = 216,  /* fix me as appropriate */
+		.end = 216,    /* ditto */
+		.flags = IORESOURCE_IO,
+		.name = "cw1200_wlan_powerup",
+	},
+	{
+		.start = NOMADIK_GPIO_TO_IRQ(216), /* fix me as appropriate */
+		.end = NOMADIK_GPIO_TO_IRQ(216),   /* ditto */
+		.flags = IORESOURCE_IRQ,
+		.name = "cw1200_wlan_irq",
+	},
+};
+#endif
+
+static int cw1200_power_ctrl(const struct cw1200_platform_data_sdio *pdata,
+			     bool enable)
+{
+	/* Control 3v3 and 1v8 to hardware as appropriate */
+	/* Note this is not needed if it's controlled elsewhere or always on */
+
+	/* May require delay for power to stabilize */
+	return 0;
+}
+
+static int cw1200_clk_ctrl(const struct cw1200_platform_data_sdio *pdata,
+			   bool enable)
+{
+	/* Turn CLK_32K off and on as appropriate. */
+	/* Note this is not needed if it's always on */
+
+	/* May require delay for clock to stabilize */
+	return 0;
+}
+
+static struct cw1200_platform_data_sdio cw1200_platform_data = {
+	.ref_clk = 38400,
+	.have_5ghz = false,
+#if 0
+	.reset = &cw1200_href_resources[0],
+	.powerup = &cw1200_href_resources[1],
+	.irq = &cw1200_href_resources[2],
+#endif
+	.power_ctrl = cw1200_power_ctrl,
+	.clk_ctrl = cw1200_clk_ctrl,
+/*	.macaddr = ??? */
+	.sdd_file = "sdd_sagrad_1091_1098.bin",
+};
+#endif
+
+#ifdef SAGRAD_1091_1098_EVK_SPI
+/* Note that this is an example of integrating into your board support file */
+static struct resource cw1200_href_resources[] = {
+	{
+		.start = GPIO_RF_RESET,
+		.end = GPIO_RF_RESET,
+		.flags = IORESOURCE_IO,
+		.name = "cw1200_wlan_reset",
+	},
+	{
+		.start = GPIO_RF_POWERUP,
+		.end = GPIO_RF_POWERUP,
+		.flags = IORESOURCE_IO,
+		.name = "cw1200_wlan_powerup",
+	},
+};
+
+static int cw1200_power_ctrl(const struct cw1200_platform_data_spi *pdata,
+			     bool enable)
+{
+	/* Control 3v3 and 1v8 to hardware as appropriate */
+	/* Note this is not needed if it's controlled elsewhere or always on */
+
+	/* May require delay for power to stabilize */
+	return 0;
+}
+static int cw1200_clk_ctrl(const struct cw1200_platform_data_spi *pdata,
+			   bool enable)
+{
+	/* Turn CLK_32K off and on as appropriate. */
+	/* Note this is not needed if it's always on */
+
+	/* May require delay for clock to stabilize */
+	return 0;
+}
+
+static struct cw1200_platform_data_spi cw1200_platform_data = {
+	.ref_clk = 38400,
+	.spi_bits_per_word = 16,
+	.reset = &cw1200_href_resources[0],
+	.powerup = &cw1200_href_resources[1],
+	.power_ctrl = cw1200_power_ctrl,
+	.clk_ctrl = cw1200_clk_ctrl,
+/*	.macaddr = ??? */
+	.sdd_file = "sdd_sagrad_1091_1098.bin",
+};
+static struct spi_board_info myboard_spi_devices[] __initdata = {
+	{
+		.modalias = "cw1200_wlan_spi",
+		.max_speed_hz = 10000000, /* 52MHz Max */
+		.bus_num = 0,
+		.irq = WIFI_IRQ,
+		.platform_data = &cw1200_platform_data,
+		.chip_select = 0,
+	},
+};
+#endif
+
+
+const void *cw1200_get_platform_data(void)
+{
+	return &cw1200_platform_data;
+}
+EXPORT_SYMBOL_GPL(cw1200_get_platform_data);
-- 
1.8.1.4

