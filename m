Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:45660 "EHLO
	na3sys009amx257.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754394Ab2DKTyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:14 -0400
Received: by laap9 with SMTP id p9so957484laa.38
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:54:10 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 22/24] wlcore/wl12xx: move identify firmware function to a lower driver op
Date: Wed, 11 Apr 2012 22:53:38 +0300
Message-Id: <1334174020-18957-23-git-send-email-coelho@ti.com> (sfid-20120411_215444_228714_BFFDC5BA)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Different chip families have different firmware versions, so we need
to identify the firmware to enable quirks, reject the used version
etc. in the lower drivers.  This commit turns the fw_ver_quirks
function into an identify_fw operation.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   17 +++++++++++
 drivers/net/wireless/ti/wlcore/boot.c   |   48 ++++++++++++++----------------
 drivers/net/wireless/ti/wlcore/hw_ops.h |    8 +++++
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 +
 4 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index ec94ad6..be48c47 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1198,6 +1198,22 @@ static u32 wl12xx_sta_get_ap_rate_mask(struct wl1271 *wl,
 	return wlvif->rate_set;
 }
 
+static int wl12xx_identify_fw(struct wl1271 *wl)
+{
+	unsigned int *fw_ver = wl->chip.fw_ver;
+
+	/* Only new station firmwares support routing fw logs to the host */
+	if ((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_STA) &&
+	    (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_FWLOG_STA_MIN))
+		wl->quirks |= WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED;
+
+	/* This feature is not yet supported for AP mode */
+	if (fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_AP)
+		wl->quirks |= WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED;
+
+	return 0;
+}
+
 static void wl12xx_conf_init(struct wl1271 *wl)
 {
 	struct wl12xx_priv *priv = wl->priv;
@@ -1274,6 +1290,7 @@ static void wl12xx_get_mac(struct wl1271 *wl)
 
 static struct wlcore_ops wl12xx_ops = {
 	.identify_chip		= wl12xx_identify_chip,
+	.identify_fw		= wl12xx_identify_fw,
 	.boot			= wl12xx_boot,
 	.trigger_cmd		= wl12xx_trigger_cmd,
 	.ack_event		= wl12xx_ack_event,
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 2aae201..3a2207d 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -31,6 +31,7 @@
 #include "io.h"
 #include "event.h"
 #include "rx.h"
+#include "hw_ops.h"
 
 static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 {
@@ -44,24 +45,7 @@ static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 	wlcore_write_reg(wl, REG_ECPU_CONTROL, cpu_ctrl);
 }
 
-static unsigned int wl12xx_get_fw_ver_quirks(struct wl1271 *wl)
-{
-	unsigned int quirks = 0;
-	unsigned int *fw_ver = wl->chip.fw_ver;
-
-	/* Only new station firmwares support routing fw logs to the host */
-	if ((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_STA) &&
-	    (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_FWLOG_STA_MIN))
-		quirks |= WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED;
-
-	/* This feature is not yet supported for AP mode */
-	if (fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_AP)
-		quirks |= WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED;
-
-	return quirks;
-}
-
-static void wl1271_parse_fw_ver(struct wl1271 *wl)
+static int wlcore_parse_fw_ver(struct wl1271 *wl)
 {
 	int ret;
 
@@ -73,21 +57,25 @@ static void wl1271_parse_fw_ver(struct wl1271 *wl)
 	if (ret != 5) {
 		wl1271_warning("fw version incorrect value");
 		memset(wl->chip.fw_ver, 0, sizeof(wl->chip.fw_ver));
-		return;
+		return -EINVAL;
 	}
 
-	/* Check if any quirks are needed with older fw versions */
-	wl->quirks |= wl12xx_get_fw_ver_quirks(wl);
+	ret = wlcore_identify_fw(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
-static void wl1271_boot_fw_version(struct wl1271 *wl)
+static int wlcore_boot_fw_version(struct wl1271 *wl)
 {
 	struct wl1271_static_data *static_data;
+	int ret;
 
 	static_data = kmalloc(sizeof(*static_data), GFP_DMA);
 	if (!static_data) {
-		__WARN();
-		return;
+		wl1271_error("Couldn't allocate memory for static data!");
+		return -ENOMEM;
 	}
 
 	wl1271_read(wl, wl->cmd_box_addr, static_data, sizeof(*static_data),
@@ -101,7 +89,11 @@ static void wl1271_boot_fw_version(struct wl1271 *wl)
 	/* make sure the string is NULL-terminated */
 	wl->chip.fw_ver_str[sizeof(wl->chip.fw_ver_str) - 1] = '\0';
 
-	wl1271_parse_fw_ver(wl);
+	ret = wlcore_parse_fw_ver(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
 static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
@@ -408,7 +400,11 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 	wl1271_debug(DEBUG_MAILBOX, "MBOX ptrs: 0x%x 0x%x",
 		     wl->mbox_ptr[0], wl->mbox_ptr[1]);
 
-	wl1271_boot_fw_version(wl);
+	ret = wlcore_boot_fw_version(wl);
+	if (ret < 0) {
+		wl1271_error("couldn't boot firmware");
+		return ret;
+	}
 
 	/*
 	 * in case of full asynchronous mode the firmware event must be
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 25b20ff..d9b1a46 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -111,5 +111,13 @@ wlcore_hw_sta_get_ap_rate_mask(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	return wl->ops->sta_get_ap_rate_mask(wl, wlvif);
 }
 
+static inline int wlcore_identify_fw(struct wl1271 *wl)
+{
+	if (wl->ops->identify_fw)
+		return wl->ops->identify_fw(wl);
+
+	return 0;
+}
+
 #endif
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 1c2d81f..960aefb 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -36,6 +36,7 @@ enum wl_rx_buf_align;
 
 struct wlcore_ops {
 	int (*identify_chip)(struct wl1271 *wl);
+	int (*identify_fw)(struct wl1271 *wl);
 	int (*boot)(struct wl1271 *wl);
 	void (*trigger_cmd)(struct wl1271 *wl, int cmd_box_addr,
 			    void *buf, size_t len);
-- 
1.7.5.4

