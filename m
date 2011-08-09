Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52328 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1HIJNf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:13:35 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so210690wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:13:35 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/40] wl12xx: Use a single fw for both STA and AP roles
Date: Tue,  9 Aug 2011 12:13:15 +0300
Message-Id: <1312881233-9366-3-git-send-email-eliad@wizery.com> (sfid-20110809_111338_881345_034A572E)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The new wl12xx fw supports both STA and AP roles.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   31 +++++--------------------------
 drivers/net/wireless/wl12xx/sdio.c   |    2 --
 drivers/net/wireless/wl12xx/spi.c    |    2 --
 drivers/net/wireless/wl12xx/wl12xx.h |    7 ++-----
 4 files changed, 7 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bf05a9f..ba8dafaf 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1040,31 +1040,16 @@ EXPORT_SYMBOL_GPL(wl1271_irq);
 static int wl1271_fetch_firmware(struct wl1271 *wl)
 {
 	const struct firmware *fw;
 	const char *fw_name;
 	int ret;
 
-	switch (wl->bss_type) {
-	case BSS_TYPE_AP_BSS:
-		if (wl->chip.id == CHIP_ID_1283_PG20)
-			fw_name = WL128X_AP_FW_NAME;
-		else
-			fw_name = WL127X_AP_FW_NAME;
-		break;
-	case BSS_TYPE_IBSS:
-	case BSS_TYPE_STA_BSS:
-		if (wl->chip.id == CHIP_ID_1283_PG20)
-			fw_name = WL128X_FW_NAME;
-		else
-			fw_name	= WL1271_FW_NAME;
-		break;
-	default:
-		wl1271_error("no compatible firmware for bss_type %d",
-			     wl->bss_type);
-		return -EINVAL;
-	}
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		fw_name = WL128X_FW_NAME;
+	else
+		fw_name	= WL1271_FW_NAME;
 
 	wl1271_debug(DEBUG_BOOT, "booting firmware %s", fw_name);
 
 	ret = request_firmware(&fw, fw_name, wl1271_wl_to_dev(wl));
 
 	if (ret < 0) {
@@ -1087,13 +1072,12 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 		wl1271_error("could not allocate memory for the firmware");
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	memcpy(wl->fw, fw->data, wl->fw_len);
-	wl->fw_bss_type = wl->bss_type;
 	ret = 0;
 
 out:
 	release_firmware(fw);
 
 	return ret;
@@ -1358,14 +1342,13 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 	default:
 		wl1271_warning("unsupported chip id: 0x%x", wl->chip.id);
 		ret = -ENODEV;
 		goto out;
 	}
 
-	/* Make sure the firmware type matches the BSS type */
-	if (wl->fw == NULL || wl->fw_bss_type != wl->bss_type) {
+	if (wl->fw == NULL) {
 		ret = wl1271_fetch_firmware(wl);
 		if (ret < 0)
 			goto out;
 	}
 
 	/* No NVS from netlink, try to get it from the filesystem */
@@ -1787,15 +1770,12 @@ static int wl1271_op_start(struct ieee80211_hw *hw)
 	 * initializing the firmware. The MAC address cannot be changed
 	 * after boot, and without the proper MAC address, the firmware
 	 * will not function properly.
 	 *
 	 * The MAC address is first known when the corresponding interface
 	 * is added. That is where we will initialize the hardware.
-	 *
-	 * In addition, we currently have different firmwares for AP and managed
-	 * operation. We will know which to boot according to interface type.
 	 */
 
 	return 0;
 }
 
 static void wl1271_op_stop(struct ieee80211_hw *hw)
@@ -4384,13 +4364,12 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->vif = NULL;
 	wl->flags = 0;
 	wl->sg_enabled = true;
 	wl->hw_pg_ver = -1;
 	wl->bss_type = MAX_BSS_TYPE;
 	wl->set_bss_type = MAX_BSS_TYPE;
-	wl->fw_bss_type = MAX_BSS_TYPE;
 	wl->last_tx_hlid = 0;
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
 	wl->quirks = 0;
 	wl->platform_quirks = 0;
 	wl->sched_scanning = false;
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 5cf18c2..5b4062f 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -411,8 +411,6 @@ module_exit(wl1271_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
 MODULE_FIRMWARE(WL128X_FW_NAME);
-MODULE_FIRMWARE(WL127X_AP_FW_NAME);
-MODULE_FIRMWARE(WL128X_AP_FW_NAME);
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index b73cee1..cbf3542 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -484,9 +484,7 @@ module_exit(wl1271_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
 MODULE_FIRMWARE(WL128X_FW_NAME);
-MODULE_FIRMWARE(WL127X_AP_FW_NAME);
-MODULE_FIRMWARE(WL128X_AP_FW_NAME);
 MODULE_ALIAS("spi:wl1271");
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 6c080e9..21c5f95 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -127,16 +127,14 @@ extern u32 wl12xx_debug_level;
 				  CFG_RX_MGMT_EN | CFG_RX_DATA_EN | \
 				  CFG_RX_CTL_EN | CFG_RX_AUTH_EN | \
 				  CFG_RX_ASSOC_EN)
 
 
 
-#define WL1271_FW_NAME "ti-connectivity/wl1271-fw-2.bin"
-#define WL128X_FW_NAME "ti-connectivity/wl128x-fw.bin"
-#define WL127X_AP_FW_NAME "ti-connectivity/wl1271-fw-ap.bin"
-#define WL128X_AP_FW_NAME "ti-connectivity/wl128x-fw-ap.bin"
+#define WL1271_FW_NAME "ti-connectivity/wl1271-fw-3.bin"
+#define WL128X_FW_NAME "ti-connectivity/wl128x-fw-3.bin"
 
 /*
  * wl127x and wl128x are using the same NVS file name. However, the
  * ini parameters between them are different.  The driver validates
  * the correct NVS size in wl1271_boot_upload_nvs().
  */
@@ -402,13 +400,12 @@ struct wl1271 {
 
 	int cmd_box_addr;
 	int event_box_addr;
 
 	u8 *fw;
 	size_t fw_len;
-	u8 fw_bss_type;
 	void *nvs;
 	size_t nvs_len;
 
 	s8 hw_pg_ver;
 
 	u8 bssid[ETH_ALEN];
-- 
1.7.6.401.g6a319

