Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35078 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab1AYPiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 10:38:04 -0500
Received: by bwz15 with SMTP id 15so248264bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 07:38:02 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: add debugfs entry for dtim_interval
Date: Tue, 25 Jan 2011 17:31:23 +0200
Message-Id: <1295969483-17136-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When configuring ACX_WAKE_UP_CONDITIONS (before entering psm), we
tell the firmware to wake up once in N DTIMs (or beacons).

Allow control of this value via debugfs (for debugging purposes).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   60 +++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 36e7ec1..1edc89f 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -293,6 +293,65 @@ static const struct file_operations gpio_power_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t dtim_interval_read(struct file *file, char __user *user_buf,
+			  size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+
+	return wl1271_format_buffer(user_buf, count, ppos, "%d\n",
+				    wl->conf.conn.listen_interval);
+}
+
+static ssize_t dtim_interval_write(struct file *file,
+			   const char __user *user_buf,
+			   size_t count, loff_t *ppos)
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
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
 				     struct dentry *rootdir)
 {
@@ -401,6 +460,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(excessive_retries, rootdir);
 
 	DEBUGFS_ADD(gpio_power, rootdir);
+	DEBUGFS_ADD(dtim_interval, rootdir);
 
 	entry = debugfs_create_x32("debug_level", 0600, rootdir,
 				   &wl12xx_debug_level);
-- 
1.7.0.4

