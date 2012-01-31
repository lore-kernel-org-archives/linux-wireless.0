Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46747 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab2AaOkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 09:40:46 -0500
Received: by mail-we0-f174.google.com with SMTP id b13so66758wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 06:40:45 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/7] wl12xx: add suspend_listen_interval debugfs file
Date: Tue, 31 Jan 2012 16:44:03 +0200
Message-Id: <1328021048-8944-3-git-send-email-eliad@wizery.com> (sfid-20120131_154050_055499_15EDA5B1)
In-Reply-To: <1328021048-8944-1-git-send-email-eliad@wizery.com>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Add read/write to suspend_dtim_interval file which
controls the number of DTIM periods between wakeups
while the host is suspended.
The value while the host is resumed is controlled
by the file dtim_interval which existed previously.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   59 +++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 4dcb3f7..15353fa 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -625,6 +625,64 @@ static const struct file_operations dtim_interval_ops = {
 	.llseek = default_llseek,
 };
 
+
+
+static ssize_t suspend_dtim_interval_read(struct file *file,
+					  char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	u8 value;
+
+	if (wl->conf.conn.suspend_wake_up_event == CONF_WAKE_UP_EVENT_DTIM ||
+	    wl->conf.conn.suspend_wake_up_event == CONF_WAKE_UP_EVENT_N_DTIM)
+		value = wl->conf.conn.suspend_listen_interval;
+	else
+		value = 0;
+
+	return wl1271_format_buffer(user_buf, count, ppos, "%d\n", value);
+}
+
+static ssize_t suspend_dtim_interval_write(struct file *file,
+					   const char __user *user_buf,
+					   size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 10, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value for suspend_dtim_interval");
+		return -EINVAL;
+	}
+
+	if (value < 1 || value > 10) {
+		wl1271_warning("suspend_dtim value is not in valid range");
+		return -ERANGE;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	wl->conf.conn.suspend_listen_interval = value;
+	/* for some reason there are different event types for 1 and >1 */
+	if (value == 1)
+		wl->conf.conn.suspend_wake_up_event = CONF_WAKE_UP_EVENT_DTIM;
+	else
+		wl->conf.conn.suspend_wake_up_event = CONF_WAKE_UP_EVENT_N_DTIM;
+
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+
+static const struct file_operations suspend_dtim_interval_ops = {
+	.read = suspend_dtim_interval_read,
+	.write = suspend_dtim_interval_write,
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static ssize_t beacon_interval_read(struct file *file, char __user *user_buf,
 				    size_t count, loff_t *ppos)
 {
@@ -949,6 +1007,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(driver_state, rootdir);
 	DEBUGFS_ADD(vifs_state, rootdir);
 	DEBUGFS_ADD(dtim_interval, rootdir);
+	DEBUGFS_ADD(suspend_dtim_interval, rootdir);
 	DEBUGFS_ADD(beacon_interval, rootdir);
 	DEBUGFS_ADD(beacon_filtering, rootdir);
 	DEBUGFS_ADD(dynamic_ps_timeout, rootdir);
-- 
1.7.6.401.g6a319

