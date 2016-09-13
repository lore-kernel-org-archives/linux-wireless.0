Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42130 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758145AbcIMVvA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 17:51:00 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 1/5] wlcore: Prepare family to fix nvs file handling
Date: Tue, 13 Sep 2016 14:50:39 -0700
Message-Id: <20160913215043.29454-2-tony@atomide.com> (sfid-20160913_235103_732762_4E3B6C3F)
In-Reply-To: <20160913215043.29454-1-tony@atomide.com>
References: <20160913215043.29454-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move struct wilink_family_data to be available for all TI WLAN
variants. And fix familiy typo, it should be just family.

Looks like wl12xx use two different nvs.bin files and wl18xx
uses a different conf.bin file.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/spi.c      | 12 ++++--------
 drivers/net/wireless/ti/wlcore/wlcore_i.h |  7 +++++++
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 0ed526e..a336493 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -80,17 +80,13 @@
 	((SPI_AGGR_BUFFER_SIZE / WSPI_MAX_CHUNK_SIZE) + 1)
 
 
-struct wilink_familiy_data {
-	char name[8];
-};
-
-static const struct wilink_familiy_data *wilink_data;
+static const struct wilink_family_data *wilink_data;
 
-static const struct wilink_familiy_data wl18xx_data = {
+static const struct wilink_family_data wl18xx_data = {
 	.name = "wl18xx",
 };
 
-static const struct wilink_familiy_data wl12xx_data = {
+static const struct wilink_family_data wl12xx_data = {
 	.name = "wl12xx",
 };
 
@@ -461,7 +457,7 @@ static int wlcore_probe_of(struct spi_device *spi, struct wl12xx_spi_glue *glue,
 		return -ENODEV;
 
 	wilink_data = of_id->data;
-	dev_info(&spi->dev, "selected chip familiy is %s\n",
+	dev_info(&spi->dev, "selected chip family is %s\n",
 		 wilink_data->name);
 
 	if (of_find_property(dt_node, "clock-xtal", NULL))
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 0277ae5..f68280d 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -42,6 +42,12 @@
  */
 #define WL12XX_NVS_NAME "ti-connectivity/wl1271-nvs.bin"
 
+struct wilink_family_data {
+	const char *name;
+	const char *nvs_name;	/* wl12xx nvs file */
+	const char *cfg_name;	/* wl18xx cfg file */
+};
+
 #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
 #define WL1271_TX_SECURITY_HI32(s) ((u32)(((s) >> 16) & 0xffffffff))
 #define WL1271_TX_SQN_POST_RECOVERY_PADDING 0xff
@@ -208,6 +214,7 @@ struct wl1271_if_operations {
 
 struct wlcore_platdev_data {
 	struct wl1271_if_operations *if_ops;
+	const struct wilink_family_data *family;
 
 	bool ref_clock_xtal;	/* specify whether the clock is XTAL or not */
 	u32 ref_clock_freq;	/* in Hertz */
-- 
2.9.3
