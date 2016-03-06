Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35422 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbcCFW2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 17:28:19 -0500
Received: by mail-wm0-f65.google.com with SMTP id 1so7828513wmg.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 14:28:18 -0800 (PST)
Received: from localhost.localdomain (93-172-245-144.bb.netvision.net.il. [93.172.245.144])
        by smtp.gmail.com with ESMTPSA id e25sm2631678wmi.21.2016.03.06.14.28.16
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 06 Mar 2016 14:28:16 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/2] wlcore/wl18xx: add radar_debug_mode handling
Date: Mon,  7 Mar 2016 00:28:09 +0200
Message-Id: <1457303289-10401-2-git-send-email-eliad@wizery.com> (sfid-20160306_232821_940030_8131A663)
In-Reply-To: <1457303289-10401-1-git-send-email-eliad@wizery.com>
References: <1457303289-10401-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add debugfs key (under CFG80211_CERTIFICATION_ONUS
configuration) to set/clear radar_debug_mode.
In this mode, the driver simply ignores radar
events (but prints them).

The fw is notified about this mode through
a special generic_cfg_feature command.

This mode is relevant only for ap mode. look for
it when initializing ap vif.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/debugfs.c | 66 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/event.c   |  3 +-
 drivers/net/wireless/ti/wlcore/init.c    |  5 +++
 drivers/net/wireless/ti/wlcore/wlcore.h  |  1 +
 4 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
index 4edfe28..86ccf84 100644
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -345,6 +345,69 @@ static const struct file_operations dynamic_fw_traces_ops = {
 	.llseek = default_llseek,
 };
 
+#ifdef CONFIG_CFG80211_CERTIFICATION_ONUS
+static ssize_t radar_debug_mode_write(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	struct wl12xx_vif *wlvif;
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 10, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal radar_debug_mode value!");
+		return -EINVAL;
+	}
+
+	/* valid values: 0/1 */
+	if (!(value == 0 || value == 1)) {
+		wl1271_warning("value is not in valid!");
+		return -EINVAL;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	wl->radar_debug_mode = value;
+
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	wl12xx_for_each_wlvif_ap(wl, wlvif) {
+		wlcore_cmd_generic_cfg(wl, wlvif,
+				       WLCORE_CFG_FEATURE_RADAR_DEBUG,
+				       wl->radar_debug_mode, 0);
+	}
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static ssize_t radar_debug_mode_read(struct file *file,
+				     char __user *userbuf,
+				     size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+
+	return wl1271_format_buffer(userbuf, count, ppos,
+				    "%d\n", wl->radar_debug_mode);
+}
+
+static const struct file_operations radar_debug_mode_ops = {
+	.write = radar_debug_mode_write,
+	.read = radar_debug_mode_read,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+#endif /* CFG80211_CERTIFICATION_ONUS */
+
 int wl18xx_debugfs_add_files(struct wl1271 *wl,
 			     struct dentry *rootdir)
 {
@@ -510,6 +573,9 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 
 	DEBUGFS_ADD(conf, moddir);
 	DEBUGFS_ADD(radar_detection, moddir);
+#ifdef CONFIG_CFG80211_CERTIFICATION_ONUS
+	DEBUGFS_ADD(radar_debug_mode, moddir);
+#endif
 	DEBUGFS_ADD(dynamic_fw_traces, moddir);
 
 	return 0;
diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
index 719907a..ff6e46d 100644
--- a/drivers/net/wireless/ti/wl18xx/event.c
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -146,7 +146,8 @@ int wl18xx_process_mailbox_events(struct wl1271 *wl)
 			    mbox->radar_channel,
 			    wl18xx_radar_type_decode(mbox->radar_type));
 
-		ieee80211_radar_detected(wl->hw);
+		if (!wl->radar_debug_mode)
+			ieee80211_radar_detected(wl->hw);
 	}
 
 	if (vector & PERIODIC_SCAN_REPORT_EVENT_ID) {
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index e92f263..d0b7734 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -558,6 +558,11 @@ static int wl12xx_init_ap_role(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (ret < 0)
 		return ret;
 
+	if (wl->radar_debug_mode)
+		wlcore_cmd_generic_cfg(wl, wlvif,
+				       WLCORE_CFG_FEATURE_RADAR_DEBUG,
+				       wl->radar_debug_mode, 0);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index dda01b1..72c31a8 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -463,6 +463,7 @@ struct wl1271 {
 
 	/* the current dfs region */
 	enum nl80211_dfs_regions dfs_region;
+	bool radar_debug_mode;
 
 	/* size of the private FW status data */
 	size_t fw_status_len;
-- 
2.6.3

