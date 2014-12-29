Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:58179 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaL2GYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:30 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so18326432wgh.9
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:29 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.28
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:28 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/13] wl18xx: add debugfs file to emulate radar event
Date: Mon, 29 Dec 2014 08:24:08 +0200
Message-Id: <1419834253-18331-8-git-send-email-eliad@wizery.com> (sfid-20141229_072435_497850_EE53A3F0)
In-Reply-To: <1419834253-18331-1-git-send-email-eliad@wizery.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add debugfs file to emulate radar detection through
a special fw cmd (which in turn will generate radar
event)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/cmd.c     | 26 +++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/cmd.h     |  8 ++++++
 drivers/net/wireless/ti/wl18xx/debugfs.c | 43 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/ps.c      |  2 ++
 4 files changed, 79 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/cmd.c b/drivers/net/wireless/ti/wl18xx/cmd.c
index 10f9d1c..68e12e5 100644
--- a/drivers/net/wireless/ti/wl18xx/cmd.c
+++ b/drivers/net/wireless/ti/wl18xx/cmd.c
@@ -198,3 +198,29 @@ out_free:
 	kfree(cmd);
 	return ret;
 }
+
+int wl18xx_cmd_radar_detection_debug(struct wl1271 *wl, u8 channel)
+{
+	struct wl18xx_cmd_dfs_radar_debug *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd radar detection debug (chan %d)",
+		     channel);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->channel = channel;
+
+	ret = wl1271_cmd_send(wl, CMD_DFS_RADAR_DETECTION_DEBUG,
+			      cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send radar detection debug command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/cmd.h b/drivers/net/wireless/ti/wl18xx/cmd.h
index 91b3e2f..0809b92 100644
--- a/drivers/net/wireless/ti/wl18xx/cmd.h
+++ b/drivers/net/wireless/ti/wl18xx/cmd.h
@@ -59,6 +59,13 @@ struct wl18xx_cmd_smart_config_set_group_key {
 	u8 key[16];
 } __packed;
 
+struct wl18xx_cmd_dfs_radar_debug {
+	struct wl1271_cmd_header header;
+
+	u8 channel;
+	u8 padding[3];
+} __packed;
+
 /* cac_start and cac_stop share the same params */
 struct wlcore_cmd_cac_start {
 	struct wl1271_cmd_header header;
@@ -77,4 +84,5 @@ int wl18xx_cmd_smart_config_stop(struct wl1271 *wl);
 int wl18xx_cmd_smart_config_set_group_key(struct wl1271 *wl, u16 group_id,
 					  u8 key_len, u8 *key);
 int wl18xx_cmd_set_cac(struct wl1271 *wl, struct wl12xx_vif *wlvif, bool start);
+int wl18xx_cmd_radar_detection_debug(struct wl1271 *wl, u8 channel);
 #endif
diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
index 7f1669c..c93fae9 100644
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -22,9 +22,12 @@
 
 #include "../wlcore/debugfs.h"
 #include "../wlcore/wlcore.h"
+#include "../wlcore/debug.h"
+#include "../wlcore/ps.h"
 
 #include "wl18xx.h"
 #include "acx.h"
+#include "cmd.h"
 #include "debugfs.h"
 
 #define WL18XX_DEBUGFS_FWSTATS_FILE(a, b, c) \
@@ -239,6 +242,45 @@ static const struct file_operations clear_fw_stats_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t radar_detection_write(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	int ret;
+	u8 channel;
+
+	ret = kstrtou8_from_user(user_buf, count, 10, &channel);
+	if (ret < 0) {
+		wl1271_warning("illegal channel");
+		return -EINVAL;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl18xx_cmd_radar_detection_debug(wl, channel);
+	if (ret < 0)
+		count = ret;
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static const struct file_operations radar_detection_ops = {
+	.write = radar_detection_write,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
 int wl18xx_debugfs_add_files(struct wl1271 *wl,
 			     struct dentry *rootdir)
 {
@@ -390,6 +432,7 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(mem, fw_gen_free_mem_blks);
 
 	DEBUGFS_ADD(conf, moddir);
+	DEBUGFS_ADD(radar_detection, moddir);
 
 	return 0;
 
diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index f3ed543..4cd316e 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -102,6 +102,7 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 	ieee80211_queue_delayed_work(wl->hw, &wl->elp_work,
 				     msecs_to_jiffies(timeout));
 }
+EXPORT_SYMBOL_GPL(wl1271_ps_elp_sleep);
 
 int wl1271_ps_elp_wakeup(struct wl1271 *wl)
 {
@@ -169,6 +170,7 @@ err:
 out:
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wl1271_ps_elp_wakeup);
 
 int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		       enum wl1271_cmd_ps_mode mode)
-- 
1.8.5.2.229.g4448466.dirty

