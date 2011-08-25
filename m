Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40183 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab1HYPJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:50 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so1744420wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 08:09:49 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] wl12xx: add beacon_filtering debugfs file
Date: Thu, 25 Aug 2011 18:11:00 +0300
Message-Id: <1314285060-5088-4-git-send-email-eliad@wizery.com> (sfid-20110825_172000_365775_9ED58F75)
In-Reply-To: <1314285060-5088-1-git-send-email-eliad@wizery.com>
References: <1314285060-5088-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow enabling/disabling beacon_filtering by debugfs,
in order to reduce the log size while debugging (beacon
filtering is disabled by default in AP mode, as beacons
are needed for ERP configuration).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   42 +++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index d59354f..d227385 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -655,6 +655,47 @@ static const struct file_operations rx_streaming_always_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t beacon_filtering_write(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
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
+	ret = kstrtoul(buf, 0, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value for beacon_filtering!");
+		return -EINVAL;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_acx_beacon_filter_opt(wl, !!value);
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static const struct file_operations beacon_filtering_ops = {
+	.write = beacon_filtering_write,
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
 				     struct dentry *rootdir)
 {
@@ -767,6 +808,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(driver_state, rootdir);
 	DEBUGFS_ADD(dtim_interval, rootdir);
 	DEBUGFS_ADD(beacon_interval, rootdir);
+	DEBUGFS_ADD(beacon_filtering, rootdir);
 
 	streaming = debugfs_create_dir("rx_streaming", rootdir);
 	if (!streaming || IS_ERR(streaming))
-- 
1.7.6.401.g6a319

