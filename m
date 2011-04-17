Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50589 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1DQIUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Apr 2011 04:20:44 -0400
Received: by wya21 with SMTP id 21so3186337wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 17 Apr 2011 01:20:43 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: add debugfs entries for dtim_interval and beacon_interval
Date: Sun, 17 Apr 2011 11:20:47 +0300
Message-Id: <1303028447-16264-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When configuring ACX_WAKE_UP_CONDITIONS (before entering psm), we
tell the firmware to wake up once in N DTIMs/beacons.

Allow control of this value via debugfs (for debugging purposes).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |  132 +++++++++++++++++++++++++++++++++
 1 files changed, 132 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 8e75b09..684ad3a 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -291,6 +291,136 @@ static const struct file_operations gpio_power_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t dtim_interval_read(struct file *file, char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	u8 value;
+
+	if (wl->conf.conn.wake_up_event == CONF_WAKE_UP_EVENT_DTIM ||
+	    wl->conf.conn.wake_up_event == CONF_WAKE_UP_EVENT_N_DTIM)
+		value = wl->conf.conn.listen_interval;
+	else
+		value = 0;
+
+	return wl1271_format_buffer(user_buf, count, ppos, "%d\n", value);
+}
+
+static ssize_t dtim_interval_write(struct file *file,
+				   const char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	char buf[10];
+	size_t len;
+	unsigned long value;
+	int ret;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+
+	ret = strict_strtoul(buf, 0, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value for dtim_interval");
+		return -EINVAL;
+	}
+
+	if (value < 1 || value > 10) {
+		wl1271_warning("dtim value is not in valid range");
+		return -ERANGE;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	wl->conf.conn.listen_interval = value;
+	/* for some reason there are different event types for 1 and >1 */
+	if (value == 1)
+		wl->conf.conn.wake_up_event = CONF_WAKE_UP_EVENT_DTIM;
+	else
+		wl->conf.conn.wake_up_event = CONF_WAKE_UP_EVENT_N_DTIM;
+
+	/*
+	 * we don't reconfigure ACX_WAKE_UP_CONDITIONS now, so it will only
+	 * take effect on the next time we enter psm.
+	 */
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static const struct file_operations dtim_interval_ops = {
+	.read = dtim_interval_read,
+	.write = dtim_interval_write,
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,
+};
+
+static ssize_t beacon_interval_read(struct file *file, char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	u8 value;
+
+	if (wl->conf.conn.wake_up_event == CONF_WAKE_UP_EVENT_BEACON||
+	    wl->conf.conn.wake_up_event == CONF_WAKE_UP_EVENT_N_BEACONS)
+		value = wl->conf.conn.listen_interval;
+	else
+		value = 0;
+
+	return wl1271_format_buffer(user_buf, count, ppos, "%d\n", value);
+}
+
+static ssize_t beacon_interval_write(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	char buf[10];
+	size_t len;
+	unsigned long value;
+	int ret;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+
+	ret = strict_strtoul(buf, 0, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value for beacon_interval");
+		return -EINVAL;
+	}
+
+	if (value < 1 || value > 255) {
+		wl1271_warning("beacon interval value is not in valid range");
+		return -ERANGE;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	wl->conf.conn.listen_interval = value;
+	/* for some reason there are different event types for 1 and >1 */
+	if (value == 1)
+		wl->conf.conn.wake_up_event = CONF_WAKE_UP_EVENT_BEACON;
+	else
+		wl->conf.conn.wake_up_event = CONF_WAKE_UP_EVENT_N_BEACONS;
+
+	/*
+	 * we don't reconfigure ACX_WAKE_UP_CONDITIONS now, so it will only
+	 * take effect on the next time we enter psm.
+	 */
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static const struct file_operations beacon_interval_ops = {
+	.read = beacon_interval_read,
+	.write = beacon_interval_write,
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
 				     struct dentry *rootdir)
 {
@@ -399,6 +529,8 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(excessive_retries, rootdir);
 
 	DEBUGFS_ADD(gpio_power, rootdir);
+	DEBUGFS_ADD(dtim_interval, rootdir);
+	DEBUGFS_ADD(beacon_interval, rootdir);
 
 	return 0;
 
-- 
1.7.0.4

