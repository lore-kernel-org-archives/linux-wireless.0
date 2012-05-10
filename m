Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43685 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702Ab2EJJQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:55 -0400
Received: by wibhn19 with SMTP id hn19so250127wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:54 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 65/78] wlcore: create private static_data area and add operation to parse it
Date: Thu, 10 May 2012 12:14:10 +0300
Message-Id: <1336641263-5761-66-git-send-email-arik@wizery.com> (sfid-20120510_111747_073282_EC2FB27B)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

The wl18xx firmware has more information in the static_data than
wl12xx.  To be able to parse that in an abstracted way, this patch
adds a priv area to the static data struct and an operation that
allows the lower driver to parse it if necessary.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/boot.c   |   53 +++++++++++++++++--------------
 drivers/net/wireless/ti/wlcore/boot.h   |    1 +
 drivers/net/wireless/ti/wlcore/hw_ops.h |    9 ++++++
 drivers/net/wireless/ti/wlcore/wlcore.h |    6 ++++
 4 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 9b98230..ed718f7 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -45,10 +45,17 @@ static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 	wlcore_write_reg(wl, REG_ECPU_CONTROL, cpu_ctrl);
 }
 
-static int wlcore_parse_fw_ver(struct wl1271 *wl)
+static int wlcore_boot_parse_fw_ver(struct wl1271 *wl,
+				    struct wl1271_static_data *static_data)
 {
 	int ret;
 
+	strncpy(wl->chip.fw_ver_str, static_data->fw_version,
+		sizeof(wl->chip.fw_ver_str));
+
+	/* make sure the string is NULL-terminated */
+	wl->chip.fw_ver_str[sizeof(wl->chip.fw_ver_str) - 1] = '\0';
+
 	ret = sscanf(wl->chip.fw_ver_str + 4, "%u.%u.%u.%u.%u",
 		     &wl->chip.fw_ver[0], &wl->chip.fw_ver[1],
 		     &wl->chip.fw_ver[2], &wl->chip.fw_ver[3],
@@ -57,43 +64,43 @@ static int wlcore_parse_fw_ver(struct wl1271 *wl)
 	if (ret != 5) {
 		wl1271_warning("fw version incorrect value");
 		memset(wl->chip.fw_ver, 0, sizeof(wl->chip.fw_ver));
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	ret = wlcore_identify_fw(wl);
 	if (ret < 0)
-		return ret;
-
-	return 0;
+		goto out;
+out:
+	return ret;
 }
 
-static int wlcore_boot_fw_version(struct wl1271 *wl)
+static int wlcore_boot_static_data(struct wl1271 *wl)
 {
 	struct wl1271_static_data *static_data;
+	size_t len = sizeof(*static_data) + wl->static_data_priv_len;
 	int ret;
 
-	static_data = kmalloc(sizeof(*static_data), GFP_KERNEL | GFP_DMA);
+	static_data = kmalloc(len, GFP_KERNEL);
 	if (!static_data) {
-		wl1271_error("Couldn't allocate memory for static data!");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
-	wl1271_read(wl, wl->cmd_box_addr, static_data, sizeof(*static_data),
-		    false);
+	wl1271_read(wl, wl->cmd_box_addr, static_data, len, false);
 
-	strncpy(wl->chip.fw_ver_str, static_data->fw_version,
-		sizeof(wl->chip.fw_ver_str));
-
-	kfree(static_data);
-
-	/* make sure the string is NULL-terminated */
-	wl->chip.fw_ver_str[sizeof(wl->chip.fw_ver_str) - 1] = '\0';
+	ret = wlcore_boot_parse_fw_ver(wl, static_data);
+	if (ret < 0)
+		goto out_free;
 
-	ret = wlcore_parse_fw_ver(wl);
+	ret = wlcore_handle_static_data(wl, static_data);
 	if (ret < 0)
-		return ret;
+		goto out_free;
 
-	return 0;
+out_free:
+	kfree(static_data);
+out:
+	return ret;
 }
 
 static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
@@ -400,9 +407,9 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 	wl1271_debug(DEBUG_MAILBOX, "MBOX ptrs: 0x%x 0x%x",
 		     wl->mbox_ptr[0], wl->mbox_ptr[1]);
 
-	ret = wlcore_boot_fw_version(wl);
+	ret = wlcore_boot_static_data(wl);
 	if (ret < 0) {
-		wl1271_error("couldn't boot firmware");
+		wl1271_error("error getting static data");
 		return ret;
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/boot.h b/drivers/net/wireless/ti/wlcore/boot.h
index 094981d..a525225 100644
--- a/drivers/net/wireless/ti/wlcore/boot.h
+++ b/drivers/net/wireless/ti/wlcore/boot.h
@@ -40,6 +40,7 @@ struct wl1271_static_data {
 	u8 fw_version[WL1271_FW_VERSION_MAX_LEN];
 	u32 hw_version;
 	u8 tx_power_table[WL1271_NO_SUBBANDS][WL1271_NO_POWER_LEVELS];
+	u8 priv[0];
 };
 
 /* number of times we try to read the INIT interrupt */
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 1555c3e..c590b6f 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -158,4 +158,13 @@ wlcore_debugfs_init(struct wl1271 *wl, struct dentry *rootdir)
 	return 0;
 }
 
+static inline int
+wlcore_handle_static_data(struct wl1271 *wl, void *static_data)
+{
+	if (wl->ops->handle_static_data)
+		return wl->ops->handle_static_data(wl, static_data);
+
+	return 0;
+}
+
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 85fd3d9..1967873 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -26,6 +26,7 @@
 
 #include "wlcore_i.h"
 #include "event.h"
+#include "boot.h"
 
 /* The maximum number of Tx descriptors in all chip families */
 #define WLCORE_MAX_TX_DESCRIPTORS 32
@@ -72,6 +73,8 @@ struct wlcore_ops {
 	u32 (*ap_get_mimo_wide_rate_mask)(struct wl1271 *wl,
 					  struct wl12xx_vif *wlvif);
 	int (*debugfs_init)(struct wl1271 *wl, struct dentry *rootdir);
+	int (*handle_static_data)(struct wl1271 *wl,
+				  struct wl1271_static_data *static_data);
 };
 
 enum wlcore_partitions {
@@ -373,6 +376,9 @@ struct wl1271 {
 	/* RX Data filter rule state - enabled/disabled */
 	bool rx_filter_enabled[WL1271_MAX_RX_FILTERS];
 
+	/* size of the private static data */
+	size_t static_data_priv_len;
+
 	/* the current channel type */
 	enum nl80211_channel_type channel_type;
 };
-- 
1.7.9.5

