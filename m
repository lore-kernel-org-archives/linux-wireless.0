Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:35830 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932082Ab2FGUj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:39:57 -0400
Received: by lboj14 with SMTP id j14so774587lbo.7
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 13:39:45 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 4/9] wlcore: export raw binary with the FW statistics in debugfs
Date: Thu,  7 Jun 2012 23:39:23 +0300
Message-Id: <1339101568-25346-5-git-send-email-coelho@ti.com> (sfid-20120607_224005_339499_C03E19EF)
In-Reply-To: <1339101568-25346-1-git-send-email-coelho@ti.com>
References: <1339101568-25346-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of parsing all the binary data returned by the firmware, we
should simply export the binary and let the userspace do the parsing.

This commit adds a new file to debugfs to do that.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 827a728..689a847 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -944,6 +944,25 @@ static const struct file_operations beacon_filtering_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t fw_stats_raw_read(struct file *file,
+				 char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+
+	wl1271_debugfs_update_stats(wl);
+
+	return simple_read_from_buffer(userbuf, count, ppos,
+				       wl->stats.fw_stats,
+				       wl->stats.fw_stats_len);
+}
+
+static const struct file_operations fw_stats_raw_ops = {
+	.read = fw_stats_raw_read,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
 				    struct dentry *rootdir)
 {
@@ -968,6 +987,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(irq_pkt_threshold, rootdir);
 	DEBUGFS_ADD(irq_blk_threshold, rootdir);
 	DEBUGFS_ADD(irq_timeout, rootdir);
+	DEBUGFS_ADD(fw_stats_raw, rootdir);
 
 	streaming = debugfs_create_dir("rx_streaming", rootdir);
 	if (!streaming || IS_ERR(streaming))
-- 
1.7.10

