Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47050 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbbGOLJs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2015 07:09:48 -0400
Received: from dflxv15.itg.ti.com ([128.247.5.124])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id t6FB9mmx014895
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2015 06:09:48 -0500
Received: from DLEE71.ent.ti.com (dlee71.ent.ti.com [157.170.170.114])
	by dflxv15.itg.ti.com (8.14.3/8.13.8) with ESMTP id t6FB9mmE017518
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2015 06:09:48 -0500
From: Guy Mishol <guym@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Guy Mishol <guym@ti.com>
Subject: [PATCH] wl18xx: add dynamic fw traces
Date: Wed, 15 Jul 2015 13:58:17 +0300
Message-ID: <1436957897-27602-1-git-send-email-guym@ti.com> (sfid-20150715_130952_905840_CF114DEF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add option to dynamically configure the fw
which debug traces to open

Signed-off-by: Guy Mishol <guym@ti.com>
---
 drivers/net/wireless/ti/wl18xx/acx.c     |   23 ++++++++++++++
 drivers/net/wireless/ti/wl18xx/acx.h     |   13 +++++++-
 drivers/net/wireless/ti/wl18xx/debugfs.c |   48 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/main.c    |    5 +++
 drivers/net/wireless/ti/wlcore/wlcore.h  |    3 ++
 5 files changed, 91 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
index 86923d5..b7a70bc 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.c
+++ b/drivers/net/wireless/ti/wl18xx/acx.c
@@ -280,3 +280,26 @@ out:
 	return ret;
 }
 
+int wl18xx_acx_dynamic_fw_traces(struct wl1271 *wl)
+{
+	struct acx_dynamic_fw_traces_cfg *acx;
+	int ret;
+	wl1271_debug(DEBUG_ACX, "acx dynamic fw traces config %d",
+		     wl->dynamic_fw_traces);
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	acx->dynamic_fw_traces = cpu_to_le32(wl->dynamic_fw_traces);
+
+	ret = wl1271_cmd_configure(wl, ACX_DYNAMIC_TRACES_CFG,
+							acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx config dynamic fw traces failed: %d", ret);
+		goto out;
+	}
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index ce29713..d92211d 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -35,7 +35,8 @@ enum {
 	ACX_PEER_CAP			 = 0x0056,
 	ACX_INTERRUPT_NOTIFY		 = 0x0057,
 	ACX_RX_BA_FILTER		 = 0x0058,
-	ACX_AP_SLEEP_CFG                 = 0x0059
+	ACX_AP_SLEEP_CFG                 = 0x0059,
+	ACX_DYNAMIC_TRACES_CFG		 = 0x005A,
 };
 
 /* numbers of bits the length field takes (add 1 for the actual number) */
@@ -406,6 +407,15 @@ struct acx_ap_sleep_cfg {
 	u8 idle_conn_thresh;
 } __packed;
 
+/*
+ * ACX_DYNAMIC_TRACES_CFG
+ * configure the FW dynamic traces
+ */
+struct acx_dynamic_fw_traces_cfg {
+	struct acx_header header;
+	__le32 dynamic_fw_traces;
+} __packed;
+
 int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
 				  u32 sdio_blk_size, u32 extra_mem_blks,
 				  u32 len_field_size);
@@ -419,5 +429,6 @@ int wl18xx_acx_set_peer_cap(struct wl1271 *wl,
 int wl18xx_acx_interrupt_notify_config(struct wl1271 *wl, bool action);
 int wl18xx_acx_rx_ba_filter(struct wl1271 *wl, bool action);
 int wl18xx_acx_ap_sleep(struct wl1271 *wl);
+int wl18xx_acx_dynamic_fw_traces(struct wl1271 *wl);
 
 #endif /* __WL18XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
index 66bb4d0..0cb7e38 100644
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -370,6 +370,53 @@ static const struct file_operations radar_debug_mode_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t dynamic_fw_traces_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 0, &value);
+
+	mutex_lock(&wl->mutex);
+
+	wl->dynamic_fw_traces = value;
+
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl18xx_acx_dynamic_fw_traces(wl);
+	if (ret < 0)
+		count = ret;
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static ssize_t dynamic_fw_traces_read(struct file *file,
+					char __user *userbuf,
+					size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	return wl1271_format_buffer(userbuf, count, ppos,
+					"%d\n", wl->dynamic_fw_traces);
+}
+
+static const struct file_operations dynamic_fw_traces_ops = {
+	.read = dynamic_fw_traces_read,
+	.write = dynamic_fw_traces_write,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
 int wl18xx_debugfs_add_files(struct wl1271 *wl,
 			     struct dentry *rootdir)
 {
@@ -551,6 +598,7 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(conf, moddir);
 	DEBUGFS_ADD(radar_detection, moddir);
 	DEBUGFS_ADD(radar_debug_mode, moddir);
+	DEBUGFS_ADD(dynamic_fw_traces, moddir);
 
 	return 0;
 
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 638bfc5..213af48 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1137,6 +1137,11 @@ static int wl18xx_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	/* set the dynamic fw traces bitmap */
+	ret = wl18xx_acx_dynamic_fw_traces(wl);
+	if (ret < 0)
+		return ret;
+
 	if (checksum_param) {
 		ret = wl18xx_acx_set_checksum_state(wl);
 		if (ret != 0)
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 807d764..6787fb0 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -522,6 +522,9 @@ struct wl1271 {
 	/* the current dfs region */
 	enum nl80211_dfs_regions dfs_region;
 	bool radar_debug_mode;
+
+	/* dynamic fw traces */
+	u32 dynamic_fw_traces;
 };
 
 int wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.7.9

