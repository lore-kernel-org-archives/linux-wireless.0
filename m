Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43854 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1DRLQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:16:22 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5507192wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:16:22 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 08/10] wl12xx: add debugfs entry for starting recovery
Date: Mon, 18 Apr 2011 14:15:27 +0300
Message-Id: <1303125329-27214-8-git-send-email-arik@wizery.com>
In-Reply-To: <1303125329-27214-1-git-send-email-arik@wizery.com>
References: <1303125329-27214-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This entry is useful for debugging the driver state machine during
recovery.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 8e75b09..6eb48b7 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -291,6 +291,25 @@ static const struct file_operations gpio_power_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t start_recovery_write(struct file *file,
+				    const char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+
+	mutex_lock(&wl->mutex);
+	ieee80211_queue_work(wl->hw, &wl->recovery_work);
+	mutex_unlock(&wl->mutex);
+
+	return count;
+}
+
+static const struct file_operations start_recovery_ops = {
+	.write = start_recovery_write,
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
 				     struct dentry *rootdir)
 {
@@ -399,6 +418,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(excessive_retries, rootdir);
 
 	DEBUGFS_ADD(gpio_power, rootdir);
+	DEBUGFS_ADD(start_recovery, rootdir);
 
 	return 0;
 
-- 
1.7.1

