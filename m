Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47335 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab0L1Rhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 12:37:40 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so4468650ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 09:37:39 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 16/18] wl1271: AP mode - fetch appropriate firmware for AP
Date: Tue, 28 Dec 2010 19:36:46 +0200
Message-Id: <1293557808-27068-17-git-send-email-arik@wizery.com>
In-Reply-To: <1293557808-27068-1-git-send-email-arik@wizery.com>
References: <1293557808-27068-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP and STA modes use different firmwares.

Differentiate the firmware files by name and fetch the appropriate one
when add_interface is called by mac80211. The STA firmware is chosen for
PLT mode.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   33 ++++++++++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index de9c5e4..0751589 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -658,9 +658,26 @@ out:
 static int wl1271_fetch_firmware(struct wl1271 *wl)
 {
 	const struct firmware *fw;
+	const char *fw_name;
 	int ret;
 
-	ret = request_firmware(&fw, WL1271_FW_NAME, wl1271_wl_to_dev(wl));
+	switch (wl->bss_type) {
+	case BSS_TYPE_AP_BSS:
+		fw_name = WL1271_AP_FW_NAME;
+		break;
+	case BSS_TYPE_IBSS:
+	case BSS_TYPE_STA_BSS:
+		fw_name = WL1271_FW_NAME;
+		break;
+	default:
+		wl1271_error("no compatible firmware for bss_type %d",
+			     wl->bss_type);
+		return -EINVAL;
+	}
+
+	wl1271_debug(DEBUG_BOOT, "booting firmware %s", fw_name);
+
+	ret = request_firmware(&fw, fw_name, wl1271_wl_to_dev(wl));
 
 	if (ret < 0) {
 		wl1271_error("could not get firmware: %d", ret);
@@ -674,6 +691,7 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 		goto out;
 	}
 
+	vfree(wl->fw);
 	wl->fw_len = fw->size;
 	wl->fw = vmalloc(wl->fw_len);
 
@@ -684,7 +702,7 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 	}
 
 	memcpy(wl->fw, fw->data, wl->fw_len);
-
+	wl->fw_bss_type = wl->bss_type;
 	ret = 0;
 
 out:
@@ -820,7 +838,8 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		goto out;
 	}
 
-	if (wl->fw == NULL) {
+	/* Make sure the firmware type matches the BSS type */
+	if (wl->fw == NULL || wl->fw_bss_type != wl->bss_type) {
 		ret = wl1271_fetch_firmware(wl);
 		if (ret < 0)
 			goto out;
@@ -853,6 +872,8 @@ int wl1271_plt_start(struct wl1271 *wl)
 		goto out;
 	}
 
+	wl->bss_type = BSS_TYPE_STA_BSS;
+
 	while (retries) {
 		retries--;
 		ret = wl1271_chip_wakeup(wl);
@@ -1010,6 +1031,9 @@ static int wl1271_op_start(struct ieee80211_hw *hw)
 	 *
 	 * The MAC address is first known when the corresponding interface
 	 * is added. That is where we will initialize the hardware.
+	 *
+	 * In addition, we currently have different firmwares for AP and managed
+	 * operation. We will know which to boot according to interface type.
 	 */
 
 	return 0;
@@ -3183,6 +3207,9 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->flags = 0;
 	wl->sg_enabled = true;
 	wl->hw_pg_ver = -1;
+	wl->bss_type = MAX_BSS_TYPE;
+	wl->set_bss_type = MAX_BSS_TYPE;
+	wl->fw_bss_type = MAX_BSS_TYPE;
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 98532fc..80e0e39 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -124,6 +124,8 @@ extern u32 wl12xx_debug_level;
 
 
 #define WL1271_FW_NAME "wl1271-fw.bin"
+#define WL1271_AP_FW_NAME "wl1271-fw-ap.bin"
+
 #define WL1271_NVS_NAME "wl1271-nvs.bin"
 
 #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
@@ -311,6 +313,7 @@ struct wl1271 {
 
 	u8 *fw;
 	size_t fw_len;
+	u8 fw_bss_type;
 	struct wl1271_nvs_file *nvs;
 	size_t nvs_len;
 
-- 
1.7.1

