Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42074 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab0KRLdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 06:33:07 -0500
Received: by mail-fx0-f46.google.com with SMTP id 6so1460042fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 03:33:06 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 16/18] wl1271: AP mode - fetch appropriate firmware for AP
Date: Thu, 18 Nov 2010 13:32:29 +0200
Message-Id: <1290079951-16793-17-git-send-email-arik@wizery.com>
In-Reply-To: <1290079951-16793-1-git-send-email-arik@wizery.com>
References: <1290079951-16793-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP and STA modes use different firmwares.

Differentiate the firmware files by name and fetch the appropriate one
when add_interface is called by mac80211.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   31 ++++++++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bf13569..708b699 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -657,9 +657,26 @@ out:
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
@@ -673,6 +690,7 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 		goto out;
 	}
 
+	vfree(wl->fw);
 	wl->fw_len = fw->size;
 	wl->fw = vmalloc(wl->fw_len);
 
@@ -683,7 +701,7 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 	}
 
 	memcpy(wl->fw, fw->data, wl->fw_len);
-
+	wl->fw_bss_type = wl->bss_type;
 	ret = 0;
 
 out:
@@ -819,7 +837,8 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		goto out;
 	}
 
-	if (wl->fw == NULL) {
+	/* Make sure the firmware type matches the BSS type */
+	if (wl->fw == NULL || wl->fw_bss_type != wl->bss_type) {
 		ret = wl1271_fetch_firmware(wl);
 		if (ret < 0)
 			goto out;
@@ -1006,6 +1025,9 @@ static int wl1271_op_start(struct ieee80211_hw *hw)
 	 *
 	 * The MAC address is first known when the corresponding interface
 	 * is added. That is where we will initialize the hardware.
+	 *
+	 * In addition, we currently have different firmwares for AP and managed
+	 * operation. We will know which to boot according to interface type.
 	 */
 
 	return 0;
@@ -3098,6 +3120,9 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->flags = 0;
 	wl->sg_enabled = true;
 	wl->hw_pg_ver = -1;
+	wl->bss_type = MAX_BSS_TYPE;
+	wl->set_bss_type = MAX_BSS_TYPE;
+	wl->fw_bss_type = MAX_BSS_TYPE;
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 8ba2812..aeb8673 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -123,6 +123,8 @@ enum {
 
 
 #define WL1271_FW_NAME "wl1271-fw.bin"
+#define WL1271_AP_FW_NAME "wl1271-fw-ap.bin"
+
 #define WL1271_NVS_NAME "wl1271-nvs.bin"
 
 #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
@@ -412,6 +414,7 @@ struct wl1271 {
 
 	u8 *fw;
 	size_t fw_len;
+	u8 fw_bss_type;
 	struct wl1271_nvs_file *nvs;
 	size_t nvs_len;
 
-- 
1.7.1

