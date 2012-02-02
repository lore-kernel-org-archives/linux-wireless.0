Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44318 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab2BBLvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 06:51:15 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so1677445wic.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 03:51:15 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyal@wizey.com>
Subject: [PATCH 4/4] wl12xx: add split_scan_timeout debugfs file
Date: Thu,  2 Feb 2012 13:54:29 +0200
Message-Id: <1328183669-21059-5-git-send-email-eliad@wizery.com> (sfid-20120202_125120_623999_36B4401E)
In-Reply-To: <1328183669-21059-1-git-send-email-eliad@wizery.com>
References: <1328183669-21059-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Add control over split_scan_timeout through
debugfs. Values are in ms while 0 will disable split scan.

Signed-off-by: Eyal Shapira <eyal@wizey.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   43 +++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index f063c70..00dbe15 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -445,6 +445,48 @@ static const struct file_operations forced_ps_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t split_scan_timeout_read(struct file *file, char __user *user_buf,
+			  size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+
+	return wl1271_format_buffer(user_buf, count,
+				    ppos, "%d\n",
+				    wl->conf.scan.split_scan_timeout / 1000);
+}
+
+static ssize_t split_scan_timeout_write(struct file *file,
+				    const char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 10, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value in split_scan_timeout");
+		return -EINVAL;
+	}
+
+	if (value == 0)
+		wl1271_info("split scan will be disabled");
+
+	mutex_lock(&wl->mutex);
+
+	wl->conf.scan.split_scan_timeout = value * 1000;
+
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static const struct file_operations split_scan_timeout_ops = {
+	.read = split_scan_timeout_read,
+	.write = split_scan_timeout_write,
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos)
 {
@@ -1082,6 +1124,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(beacon_filtering, rootdir);
 	DEBUGFS_ADD(dynamic_ps_timeout, rootdir);
 	DEBUGFS_ADD(forced_ps, rootdir);
+	DEBUGFS_ADD(split_scan_timeout, rootdir);
 
 	streaming = debugfs_create_dir("rx_streaming", rootdir);
 	if (!streaming || IS_ERR(streaming))
-- 
1.7.6.401.g6a319

