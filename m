Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44744 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2BBKAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 05:00:18 -0500
Received: by wgbdt10 with SMTP id dt10so2349897wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 02:00:17 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Eliad Peller <eliad@wizery.com>
Subject: [PATCH v3 4/4] wl12xx: add forced_ps debugfs file
Date: Thu,  2 Feb 2012 12:03:42 +0200
Message-Id: <1328177022-26646-5-git-send-email-eliad@wizery.com> (sfid-20120202_110027_307938_C3D45CAE)
In-Reply-To: <1328177022-26646-1-git-send-email-eliad@wizery.com>
References: <1328177022-26646-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Added control over forced_ps option through debugfs.
This can be either 1 or 0.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   70 +++++++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 02da445..1c26238 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -376,6 +376,75 @@ static const struct file_operations dynamic_ps_timeout_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t forced_ps_read(struct file *file, char __user *user_buf,
+			  size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+
+	return wl1271_format_buffer(user_buf, count,
+				    ppos, "%d\n",
+				    wl->conf.conn.forced_ps);
+}
+
+static ssize_t forced_ps_write(struct file *file,
+				    const char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	struct wl12xx_vif *wlvif;
+	unsigned long value;
+	int ret, ps_mode;
+
+	ret = kstrtoul_from_user(user_buf, count, 10, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value in forced_ps");
+		return -EINVAL;
+	}
+
+	if (value != 1 && value != 0) {
+		wl1271_warning("forced_ps should be either 0 or 1");
+		return -ERANGE;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->conf.conn.forced_ps == value)
+		goto out;
+
+	wl->conf.conn.forced_ps = value;
+
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	/* In case we're already in PSM, trigger it again to switch mode
+	 * immediately without waiting for re-association
+	 */
+
+	ps_mode = value ? STATION_POWER_SAVE_MODE : STATION_AUTO_PS_MODE;
+
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		if (test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags))
+			wl1271_ps_set_mode(wl, wlvif, ps_mode);
+	}
+
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static const struct file_operations forced_ps_ops = {
+	.read = forced_ps_read,
+	.write = forced_ps_write,
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos)
 {
@@ -1011,6 +1080,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(beacon_interval, rootdir);
 	DEBUGFS_ADD(beacon_filtering, rootdir);
 	DEBUGFS_ADD(dynamic_ps_timeout, rootdir);
+	DEBUGFS_ADD(forced_ps, rootdir);
 
 	streaming = debugfs_create_dir("rx_streaming", rootdir);
 	if (!streaming || IS_ERR(streaming))
-- 
1.7.6.401.g6a319

