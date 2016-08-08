Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:51829 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbcHHIu5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2016 04:50:57 -0400
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id u788otIQ017219
	for <linux-wireless@vger.kernel.org>; Mon, 8 Aug 2016 03:50:55 -0500
Received: from DFLE72.ent.ti.com (dfle72.ent.ti.com [128.247.5.109])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id u788otOS004393
	for <linux-wireless@vger.kernel.org>; Mon, 8 Aug 2016 03:50:55 -0500
From: Guy Mishol <guym@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Guy Mishol <guym@ti.com>
Subject: [PATCH] wlcore: mesh: add zone time sync support
Date: Mon, 8 Aug 2016 11:57:06 +0300
Message-ID: <20160808085706.22668-1-guym@ti.com> (sfid-20160808_105102_155058_B7AC5AA5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add zone time sync support for mesh role.
This allows to configure the mesh peer
master of each zone for time synchronization.

Signed-off-by: Guy Mishol <guym@ti.com>
---
 drivers/net/wireless/ti/wl18xx/acx.c     | 29 ++++++++++++++++
 drivers/net/wireless/ti/wl18xx/acx.h     | 13 +++++++
 drivers/net/wireless/ti/wl18xx/debugfs.c | 59 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/event.c   |  1 +
 drivers/net/wireless/ti/wlcore/wlcore.h  |  3 ++
 5 files changed, 105 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
index 4be0409..b5525a3 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.c
+++ b/drivers/net/wireless/ti/wl18xx/acx.c
@@ -309,3 +309,32 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl18xx_acx_time_sync_cfg(struct wl1271 *wl)
+{
+	struct acx_time_sync_cfg *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx time sync cfg: mode %d, addr: %pM",
+		     wl->conf.sg.params[WL18XX_CONF_SG_TIME_SYNC],
+		     wl->zone_master_mac_addr);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->sync_mode = wl->conf.sg.params[WL18XX_CONF_SG_TIME_SYNC];
+	memcpy(acx->zone_mac_addr, wl->zone_master_mac_addr, ETH_ALEN);
+
+	ret = wl1271_cmd_configure(wl, ACX_TIME_SYNC_CFG,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx time sync cfg failed: %d", ret);
+		goto out;
+	}
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index 342a299..2edbbbf 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -37,6 +37,7 @@ enum {
 	ACX_RX_BA_FILTER		 = 0x0058,
 	ACX_AP_SLEEP_CFG                 = 0x0059,
 	ACX_DYNAMIC_TRACES_CFG		 = 0x005A,
+	ACX_TIME_SYNC_CFG		 = 0x005B,
 };
 
 /* numbers of bits the length field takes (add 1 for the actual number) */
@@ -388,6 +389,17 @@ struct acx_dynamic_fw_traces_cfg {
 	__le32 dynamic_fw_traces;
 } __packed;
 
+/*
+ * ACX_TIME_SYNC_CFG
+ * configure the time sync parameters
+ */
+struct acx_time_sync_cfg {
+	struct acx_header header;
+	u8 sync_mode;
+	u8 zone_mac_addr[ETH_ALEN];
+	u8 padding[1];
+} __packed;
+
 int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
 				  u32 sdio_blk_size, u32 extra_mem_blks,
 				  u32 len_field_size);
@@ -402,5 +414,6 @@ int wl18xx_acx_interrupt_notify_config(struct wl1271 *wl, bool action);
 int wl18xx_acx_rx_ba_filter(struct wl1271 *wl, bool action);
 int wl18xx_acx_ap_sleep(struct wl1271 *wl);
 int wl18xx_acx_dynamic_fw_traces(struct wl1271 *wl);
+int wl18xx_acx_time_sync_cfg(struct wl1271 *wl);
 
 #endif /* __WL18XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
index 86ccf84..9e28748 100644
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -408,6 +408,64 @@ static const struct file_operations radar_debug_mode_ops = {
 };
 #endif /* CFG80211_CERTIFICATION_ONUS */
 
+static ssize_t time_sync_zone_addr_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos) {
+	struct wl1271 *wl = file->private_data;
+	char buf[(ETH_ALEN * 2)];
+	int ret;
+
+	if (count < (ETH_ALEN * 2 + 1)) {
+		wl1271_warning("Illegal MAC address: wrong size");
+		return -EINVAL;
+	}
+
+	ret = copy_from_user(buf, user_buf, (ETH_ALEN * 2));
+	if (ret < 0)
+		return ret;
+
+	ret = hex2bin(wl->zone_master_mac_addr, buf, ETH_ALEN);
+	if (ret < 0) {
+		wl1271_warning("Illegal MAC address: invalid characters");
+		return ret;
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
+	ret = wl18xx_acx_time_sync_cfg(wl);
+	if (ret < 0)
+		count = ret;
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static ssize_t time_sync_zone_addr_read(struct file *file,
+					char __user *userbuf,
+					size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+
+	return wl1271_format_buffer(userbuf, count, ppos,
+				    "%pM\n", wl->zone_master_mac_addr);
+}
+
+static const struct file_operations time_sync_zone_addr_ops = {
+	.write  = time_sync_zone_addr_write,
+	.read = time_sync_zone_addr_read,
+	.open   = simple_open,
+	.llseek = default_llseek,
+};
+
 int wl18xx_debugfs_add_files(struct wl1271 *wl,
 			     struct dentry *rootdir)
 {
@@ -576,6 +634,7 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 #ifdef CONFIG_CFG80211_CERTIFICATION_ONUS
 	DEBUGFS_ADD(radar_debug_mode, moddir);
 #endif
+	DEBUGFS_ADD(time_sync_zone_addr, moddir);
 	DEBUGFS_ADD(dynamic_fw_traces, moddir);
 
 	return 0;
diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
index 2c5df43..b36ce18 100644
--- a/drivers/net/wireless/ti/wl18xx/event.c
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -22,6 +22,7 @@
 #include <net/genetlink.h>
 #include "event.h"
 #include "scan.h"
+#include "conf.h"
 #include "../wlcore/cmd.h"
 #include "../wlcore/debug.h"
 #include "../wlcore/vendor_cmd.h"
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 8f28aa0..1827546 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -501,6 +501,9 @@ struct wl1271 {
 
 	/* dynamic fw traces */
 	u32 dynamic_fw_traces;
+
+	/* time sync zone master */
+	u8 zone_master_mac_addr[ETH_ALEN];
 };
 
 int wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
2.6.4

