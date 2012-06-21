Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:42645 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078Ab2FUONZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:25 -0400
Received: by eekb57 with SMTP id b57so457252eek.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:22 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 02/12] wlcore: add a debugfs entry to allow changing the sleep mode by hand
Date: Thu, 21 Jun 2012 17:13:01 +0300
Message-Id: <1340287991-15241-3-git-send-email-coelho@ti.com> (sfid-20120621_161405_363992_E6C70AD6)
In-Reply-To: <1340287991-15241-1-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For FW debugging purposes, we may need to change the sleep mode
(aka. sleep_auth) by hand, and set it to the mode we want.  To allow
this, a debugfs entry is added.

Now we store the sleep_auth value that has been set and use that
instead of the quirk to decide whether we should enter ELP or not.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/acx.c     |    3 ++
 drivers/net/wireless/ti/wlcore/acx.h     |    2 ++
 drivers/net/wireless/ti/wlcore/debugfs.c |   58 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/main.c    |    3 ++
 drivers/net/wireless/ti/wlcore/ps.c      |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h  |    3 ++
 6 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index b9ec42c..b56217f 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -81,7 +81,10 @@ int wl1271_acx_sleep_auth(struct wl1271 *wl, u8 sleep_auth)
 	auth->sleep_auth = sleep_auth;
 
 	ret = wl1271_cmd_configure(wl, ACX_SLEEP_AUTH, auth, sizeof(*auth));
+	if (ret < 0)
+		goto out;
 
+	wl->sleep_auth = sleep_auth;
 out:
 	kfree(auth);
 	return ret;
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index c018125..168e046 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -118,6 +118,8 @@ enum wl1271_psm_mode {
 
 	/* Extreme low power */
 	WL1271_PSM_ELP = 2,
+
+	WL1271_PSM_MAX = WL1271_PSM_ELP,
 };
 
 struct acx_sleep_auth {
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 689a847..91e43de 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -963,6 +963,63 @@ static const struct file_operations fw_stats_raw_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t sleep_auth_read(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+
+	return wl1271_format_buffer(user_buf, count,
+				    ppos, "%d\n",
+				    wl->sleep_auth);
+}
+
+static ssize_t sleep_auth_write(struct file *file,
+				const char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 0, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value in sleep_auth");
+		return -EINVAL;
+	}
+
+	if (value < 0 || value > WL1271_PSM_MAX) {
+		wl1271_warning("sleep_auth must be between 0 and %d",
+			       WL1271_PSM_MAX);
+		return -ERANGE;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_acx_sleep_auth(wl, value);
+	if (ret < 0)
+		goto out_sleep;
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static const struct file_operations sleep_auth_ops = {
+	.read = sleep_auth_read,
+	.write = sleep_auth_write,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
 				    struct dentry *rootdir)
 {
@@ -988,6 +1045,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(irq_blk_threshold, rootdir);
 	DEBUGFS_ADD(irq_timeout, rootdir);
 	DEBUGFS_ADD(fw_stats_raw, rootdir);
+	DEBUGFS_ADD(sleep_auth, rootdir);
 
 	streaming = debugfs_create_dir("rx_streaming", rootdir);
 	if (!streaming || IS_ERR(streaming))
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 22b342f..7677cd5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1082,6 +1082,7 @@ int wl1271_plt_stop(struct wl1271 *wl)
 	mutex_lock(&wl->mutex);
 	wl1271_power_off(wl);
 	wl->flags = 0;
+	wl->sleep_auth = WL1271_PSM_CAM;
 	wl->state = WL1271_STATE_OFF;
 	wl->plt = false;
 	wl->rx_counter = 0;
@@ -1740,6 +1741,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
 	wl->sched_scanning = false;
+	wl->sleep_auth = WL1271_PSM_CAM;
 	memset(wl->roles_map, 0, sizeof(wl->roles_map));
 	memset(wl->links_map, 0, sizeof(wl->links_map));
 	memset(wl->roc_map, 0, sizeof(wl->roc_map));
@@ -5174,6 +5176,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
 	wl->channel_type = NL80211_CHAN_NO_HT;
 	wl->flags = 0;
 	wl->sg_enabled = true;
+	wl->sleep_auth = WL1271_PSM_CAM;
 	wl->hw_pg_ver = -1;
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 47e81b3..95d8797 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -76,7 +76,7 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 	struct wl12xx_vif *wlvif;
 	u32 timeout;
 
-	if (wl->quirks & WLCORE_QUIRK_NO_ELP)
+	if (wl->sleep_auth != WL1271_PSM_ELP)
 		return;
 
 	/* we shouldn't get consecutive sleep requests */
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 761a72f..eae8edc 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -387,6 +387,9 @@ struct wl1271 {
 
 	/* mutex for protecting the tx_flush function */
 	struct mutex flush_mutex;
+
+	/* sleep auth value currently configured to FW */
+	int sleep_auth;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.7.10

