Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40424 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab1EOIKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 04:10:38 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so2759832wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 May 2011 01:10:37 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 3/3] wl12xx: add rx_streaming debugfs entry
Date: Sun, 15 May 2011 11:10:30 +0300
Message-Id: <1305447030-10704-3-git-send-email-eliad@wizery.com> (sfid-20110515_101045_338721_4BADC4E1)
In-Reply-To: <1305447030-10704-1-git-send-email-eliad@wizery.com>
References: <1305447030-10704-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow control over rx_streaming interval and operation mode
(always/only on coex) via debugfs.

e.g.
echo 100 > /debug/ieee80211/phy0/wl12xx/rx_streaming/interval
echo 1 > /debug/ieee80211/phy0/wl12xx/rx_streaming/always

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |  136 ++++++++++++++++++++++++++++++++-
 1 files changed, 135 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index f1f8df9..c3f1946 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -71,6 +71,14 @@ static const struct file_operations name## _ops = {			\
 	if (!entry || IS_ERR(entry))					\
 		goto err;						\
 
+#define DEBUGFS_ADD_PREFIX(prefix, name, parent)			\
+	do {								\
+		entry = debugfs_create_file(#name, 0400, parent,	\
+				    wl, &prefix## _## name## _ops);	\
+		if (!entry || IS_ERR(entry))				\
+			goto err;					\
+	} while (0);
+
 #define DEBUGFS_FWSTATS_FILE(sub, name, fmt)				\
 static ssize_t sub## _ ##name## _read(struct file *file,		\
 				      char __user *userbuf,		\
@@ -527,11 +535,129 @@ static const struct file_operations beacon_interval_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t rx_streaming_interval_write(struct file *file,
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
+	ret = kstrtoul(buf, 0, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value in rx_streaming_interval!");
+		return -EINVAL;
+	}
+
+	/* valid values: 0, 10-100 */
+	if (value && (value < 10 || value > 100)) {
+		wl1271_warning("value is not in range!");
+		return -ERANGE;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	wl->conf.rx_streaming.interval = value;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	wl1271_recalc_rx_streaming(wl);
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static ssize_t rx_streaming_interval_read(struct file *file,
+			    char __user *userbuf,
+			    size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	return wl1271_format_buffer(userbuf, count, ppos,
+				    "%d\n", wl->conf.rx_streaming.interval);
+}
+
+static const struct file_operations rx_streaming_interval_ops = {
+	.read = rx_streaming_interval_read,
+	.write = rx_streaming_interval_write,
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,
+};
+
+static ssize_t rx_streaming_always_write(struct file *file,
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
+	ret = kstrtoul(buf, 0, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value in rx_streaming_write!");
+		return -EINVAL;
+	}
+
+	/* valid values: 0, 10-100 */
+	if (!(value == 0 || value == 1)) {
+		wl1271_warning("value is not in valid!");
+		return -EINVAL;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	wl->conf.rx_streaming.always = value;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	wl1271_recalc_rx_streaming(wl);
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static ssize_t rx_streaming_always_read(struct file *file,
+			    char __user *userbuf,
+			    size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	return wl1271_format_buffer(userbuf, count, ppos,
+				    "%d\n", wl->conf.rx_streaming.always);
+}
+
+static const struct file_operations rx_streaming_always_ops = {
+	.read = rx_streaming_always_read,
+	.write = rx_streaming_always_write,
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
 				     struct dentry *rootdir)
 {
 	int ret = 0;
-	struct dentry *entry, *stats;
+	struct dentry *entry, *stats, *streaming;
 
 	stats = debugfs_create_dir("fw-statistics", rootdir);
 	if (!stats || IS_ERR(stats)) {
@@ -640,6 +766,14 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(dtim_interval, rootdir);
 	DEBUGFS_ADD(beacon_interval, rootdir);
 
+	streaming = debugfs_create_dir("rx_streaming", rootdir);
+	if (!streaming || IS_ERR(streaming))
+		goto err;
+
+	DEBUGFS_ADD_PREFIX(rx_streaming, interval, streaming);
+	DEBUGFS_ADD_PREFIX(rx_streaming, always, streaming);
+
+
 	return 0;
 
 err:
-- 
1.7.0.4

