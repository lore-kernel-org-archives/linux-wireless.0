Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:32826 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754075Ab1CROU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:28 -0400
Received: by mail-wy0-f175.google.com with SMTP id 40so4351318wyb.34
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:20:27 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: shahar_levi@ti.com, ruthyz@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 12/14] wl12xx: 1281/1283 support - Use different FW file for AP mode wl127x/wl128x chips
Date: Fri, 18 Mar 2011 16:19:27 +0200
Message-Id: <1300457969-19601-13-git-send-email-coelho@ti.com>
In-Reply-To: <1300457969-19601-1-git-send-email-coelho@ti.com>
References: <1300457969-19601-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Choose a different FW for AP-mode wl127x and wl128x chips, base on chip
ID at boot time.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Reviewed-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c   |    5 ++++-
 drivers/net/wireless/wl12xx/sdio.c   |    3 ++-
 drivers/net/wireless/wl12xx/spi.c    |    3 ++-
 drivers/net/wireless/wl12xx/wl12xx.h |    3 ++-
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 54ac675..9a7ca65 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -832,7 +832,10 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 
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
index 19cdf7c..ff77361 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -361,4 +361,5 @@ MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
 MODULE_FIRMWARE(WL128X_FW_NAME);
-MODULE_FIRMWARE(WL1271_AP_FW_NAME);
+MODULE_FIRMWARE(WL127X_AP_FW_NAME);
+MODULE_FIRMWARE(WL128X_AP_FW_NAME);
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 2064a93..3b862a2 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -493,5 +493,6 @@ MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
 MODULE_FIRMWARE(WL128X_FW_NAME);
-MODULE_FIRMWARE(WL1271_AP_FW_NAME);
+MODULE_FIRMWARE(WL127X_AP_FW_NAME);
+MODULE_FIRMWARE(WL128X_AP_FW_NAME);
 MODULE_ALIAS("spi:wl1271");
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index ad04b83..890c1a5 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -132,7 +132,8 @@ extern u32 wl12xx_debug_level;
 
 #define WL1271_FW_NAME "ti-connectivity/wl1271-fw-2.bin"
 #define WL128X_FW_NAME "ti-connectivity/wl128x-fw.bin"
-#define WL1271_AP_FW_NAME "ti-connectivity/wl1271-fw-ap.bin"
+#define WL127X_AP_FW_NAME "ti-connectivity/wl1271-fw-ap.bin"
+#define WL128X_AP_FW_NAME "ti-connectivity/wl128x-fw-ap.bin"
 
 /*
  * wl127x and wl128x are using the same NVS file name. However, the
-- 
1.7.1

