Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47536 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab2A3L5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:57:53 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so3321396wic.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 03:57:52 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/12] wl12xx: add dynamic_ps_timeout debugfs file
Date: Mon, 30 Jan 2012 14:00:54 +0200
Message-Id: <1327924857-1250-10-git-send-email-eliad@wizery.com> (sfid-20120130_125757_619492_D807CB9D)
In-Reply-To: <1327924857-1250-1-git-send-email-eliad@wizery.com>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Enable read/write of dynamic_ps_timeout which controls the timeout
of the dynamic PS implemented in the FW.
dynamic_ps_timeout is the timeout (in msec) until going back to PS
when there's no Rx/Tx

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   67 +++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 5e96e05..156a774 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -312,6 +312,72 @@ static const struct file_operations start_recovery_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t dynamic_ps_timeout_read(struct file *file, char __user *user_buf,
+			  size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+
+	return wl1271_format_buffer(user_buf, count,
+				    ppos, "%d\n",
+				    wl->conf.conn.dynamic_ps_timeout);
+}
+
+static ssize_t dynamic_ps_timeout_write(struct file *file,
+				    const char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	struct wl12xx_vif *wlvif;
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 10, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value in dynamic_ps");
+		return -EINVAL;
+	}
+
+	if (value < 1 || value > 65535) {
+		wl1271_warning("dyanmic_ps_timeout is not in valid range");
+		return -ERANGE;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	wl->conf.conn.dynamic_ps_timeout = value;
+
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	/* In case we're already in PSM, trigger it again to set new timeout
+	 * immediately without waiting for re-association
+	 */
+
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		if (test_bit(WLVIF_FLAG_PSM, &wlvif->flags))
+			wl1271_ps_set_mode(wl, wlvif, STATION_AUTO_PS_MODE,
+					   wlvif->basic_rate, true);
+
+	}
+
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static const struct file_operations dynamic_ps_timeout_ops = {
+	.read = dynamic_ps_timeout_read,
+	.write = dynamic_ps_timeout_write,
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos)
 {
@@ -887,6 +953,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(dtim_interval, rootdir);
 	DEBUGFS_ADD(beacon_interval, rootdir);
 	DEBUGFS_ADD(beacon_filtering, rootdir);
+	DEBUGFS_ADD(dynamic_ps_timeout, rootdir);
 
 	streaming = debugfs_create_dir("rx_streaming", rootdir);
 	if (!streaming || IS_ERR(streaming))
-- 
1.7.6.401.g6a319

