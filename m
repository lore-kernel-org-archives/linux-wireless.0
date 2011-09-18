Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45813 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab1IRMJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 08:09:16 -0400
Received: by wwf22 with SMTP id 22so6827729wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 05:09:15 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] wl12xx: add dynamic_ps_timeout debugfs entry
Date: Sun, 18 Sep 2011 15:09:18 +0300
Message-Id: <1316347759-22030-1-git-send-email-eliad@wizery.com> (sfid-20110918_140919_604453_10D014A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add debugfs entry to control the dynamic ps default
timeout (value in ms).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 3999fd5..271dac0 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -311,6 +311,33 @@ static const struct file_operations start_recovery_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t dynamic_ps_timeout_write(struct file *file,
+				    const char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	long value;
+	int ret;
+
+	ret = kstrtol_from_user(user_buf, count, 10, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value in dynamic_ps");
+		return -EINVAL;
+	}
+
+	mutex_lock(&wl->mutex);
+	ieee80211_set_dyn_ps_timeout(wl->vif, value);
+	mutex_unlock(&wl->mutex);
+
+	return count;
+}
+
+static const struct file_operations dynamic_ps_timeout_ops = {
+	.write = dynamic_ps_timeout_write,
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos)
 {
@@ -769,6 +796,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 
 	DEBUGFS_ADD(gpio_power, rootdir);
 	DEBUGFS_ADD(start_recovery, rootdir);
+	DEBUGFS_ADD(dynamic_ps_timeout, rootdir);
 	DEBUGFS_ADD(driver_state, rootdir);
 	DEBUGFS_ADD(dtim_interval, rootdir);
 	DEBUGFS_ADD(beacon_interval, rootdir);
-- 
1.7.6.401.g6a319

