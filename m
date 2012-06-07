Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:60366 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086Ab2FGUj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:39:59 -0400
Received: by lagv3 with SMTP id v3so1058534lag.17
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 13:39:44 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 3/9] wl18xx: add support to clear FW statistics
Date: Thu,  7 Jun 2012 23:39:22 +0300
Message-Id: <1339101568-25346-4-git-send-email-coelho@ti.com> (sfid-20120607_224006_927440_6FC406AC)
In-Reply-To: <1339101568-25346-1-git-send-email-coelho@ti.com>
References: <1339101568-25346-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch calls ACX_CLEAR_STATISTICS to clear the firmware
statistics.  The trigger is a new debugfs file called
clear_fw_statistics in the fw_stats directory.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/acx.c     |   24 ++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/acx.h     |    9 +++++++++
 drivers/net/wireless/ti/wl18xx/debugfs.c |   30 ++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
index 01ba403..72840e2 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.c
+++ b/drivers/net/wireless/ti/wl18xx/acx.c
@@ -85,3 +85,27 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl18xx_acx_clear_statistics(struct wl1271 *wl)
+{
+	struct wl18xx_acx_clear_statistics *acx;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx clear statistics");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = wl1271_cmd_configure(wl, ACX_CLEAR_STATISTICS, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("failed to clear firmware statistics: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index 7d74b03..3e5cd9f 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -25,6 +25,10 @@
 #include "../wlcore/wlcore.h"
 #include "../wlcore/acx.h"
 
+enum {
+	ACX_CLEAR_STATISTICS		 = 0x0047,
+};
+
 /* numbers of bits the length field takes (add 1 for the actual number) */
 #define WL18XX_HOST_IF_LEN_SIZE_FIELD 15
 
@@ -253,9 +257,14 @@ struct wl18xx_acx_statistics {
 	struct wl18xx_acx_mem_stats		mem;
 } __packed;
 
+struct wl18xx_acx_clear_statistics {
+	struct acx_header header;
+};
+
 int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
 				  u32 sdio_blk_size, u32 extra_mem_blks,
 				  u32 len_field_size);
 int wl18xx_acx_set_checksum_state(struct wl1271 *wl);
+int wl18xx_acx_clear_statistics(struct wl1271 *wl);
 
 #endif /* __WL18XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
index 93c625b..468651c 100644
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -158,6 +158,34 @@ WL18XX_DEBUGFS_FWSTATS_FILE(mem, tx_free_mem_blks, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(mem, fwlog_free_mem_blks, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(mem, fw_gen_free_mem_blks, "%u");
 
+static ssize_t clear_fw_stats_write(struct file *file,
+			      const char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
+	ret = wl18xx_acx_clear_statistics(wl);
+	if (ret < 0) {
+		count = ret;
+		goto out;
+	}
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static const struct file_operations clear_fw_stats_ops = {
+	.write = clear_fw_stats_write,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
 int wl18xx_debugfs_add_files(struct wl1271 *wl,
 			     struct dentry *rootdir)
 {
@@ -176,6 +204,8 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 		goto err;
 	}
 
+	DEBUGFS_ADD(clear_fw_stats, stats);
+
 	DEBUGFS_FWSTATS_ADD(debug, debug1);
 	DEBUGFS_FWSTATS_ADD(debug, debug2);
 	DEBUGFS_FWSTATS_ADD(debug, debug3);
-- 
1.7.10

