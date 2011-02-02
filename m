Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63692 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1BBJM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 04:12:27 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so8015126wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 01:12:26 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] wl12xx: add rx_streaming debugfs entry
Date: Wed,  2 Feb 2011 11:12:19 +0200
Message-Id: <1296637939-26729-3-git-send-email-eliad@wizery.com>
In-Reply-To: <1296637939-26729-1-git-send-email-eliad@wizery.com>
References: <1296637939-26729-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

allow control over rx_streaming interval via debugfs (value is in ms).

e.g.
echo 100 > /debug/ieee80211/phy0/wl12xx/rx_streaming_interval

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   54 +++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index bebfa28..43b4599 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -291,6 +291,59 @@ static const struct file_operations gpio_power_ops = {
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
+	ret = strict_strtoul(buf, 0, &value);
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
+	wl1271_recalc_rx_streaming(wl);
+
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
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
 				     struct dentry *rootdir)
 {
@@ -399,6 +452,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(excessive_retries, rootdir);
 
 	DEBUGFS_ADD(gpio_power, rootdir);
+	DEBUGFS_ADD(rx_streaming_interval, rootdir);
 
 	return 0;
 
-- 
1.7.0.4

