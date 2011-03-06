Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:44362 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab1CFO20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:26 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 13/15] wl12xx: 1281/1283 support - Use different FW file for AP mode wl127x/wl128x chips
Date: Sun,  6 Mar 2011 16:32:18 +0200
Message-Id: <1299421940-26292-14-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Choose a different FW for AP-mode wl127x and wl128x chips, base on chip
ID at boot time.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    5 ++++-
 drivers/net/wireless/wl12xx/sdio.c   |    3 ++-
 drivers/net/wireless/wl12xx/spi.c    |    3 ++-
 drivers/net/wireless/wl12xx/wl12xx.h |    3 ++-
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 6fda932..8ac3936 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -848,7 +848,10 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 
 	switch (wl->bss_type) {
 	case BSS_TYPE_AP_BSS:
-		fw_name = WL1271_AP_FW_NAME;
+		if (wl->chip.id == CHIP_ID_1283_PG20)
+			fw_name = WL128X_AP_FW_NAME;
+		else
+			fw_name = WL127X_AP_FW_NAME;
 		break;
 	case BSS_TYPE_IBSS:
 	case BSS_TYPE_STA_BSS:
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 521a187..5f4dd73 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -358,4 +358,5 @@ MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
 MODULE_FIRMWARE(WL128X_FW_NAME);
-MODULE_FIRMWARE(WL1271_AP_FW_NAME);
+MODULE_FIRMWARE(WL127X_AP_FW_NAME);
+MODULE_FIRMWARE(WL128X_AP_FW_NAME);
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index abbb8dc..e4e9ea5 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -501,5 +501,6 @@ MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
 MODULE_FIRMWARE(WL128X_FW_NAME);
-MODULE_FIRMWARE(WL1271_AP_FW_NAME);
+MODULE_FIRMWARE(WL127X_AP_FW_NAME);
+MODULE_FIRMWARE(WL128X_AP_FW_NAME);
 MODULE_ALIAS("spi:wl1271");
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1114b7c..6fa760e 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -132,7 +132,8 @@ extern u32 wl12xx_debug_level;
 
 #define WL1271_FW_NAME "ti-connectivity/wl1271-fw-2.bin"
 #define WL128X_FW_NAME "ti-connectivity/wl128x-fw.bin"
-#define WL1271_AP_FW_NAME "ti-connectivity/wl1271-fw-ap.bin"
+#define WL127X_AP_FW_NAME "ti-connectivity/wl1271-fw-ap.bin"
+#define WL128X_AP_FW_NAME "ti-connectivity/wl128x-fw-ap.bin"
 
 /*
  * wl127x and wl128x are using the same NVS file name. However, the ini
-- 
1.7.0.4

