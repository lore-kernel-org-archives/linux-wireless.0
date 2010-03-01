Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48609 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab0CAVRp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 16:17:45 -0500
Message-ID: <4B8C2EF2.4050908@openwrt.org>
Date: Mon, 01 Mar 2010 22:17:38 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] minstrel: simplify and fix debugfs code
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans up the debugfs read function for the statistics by
using simple_read_from_buffer instead of its own semi-broken hack.
Also removes a useless member of the minstrel debugfs info struct.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -80,6 +80,11 @@ struct minstrel_priv {
 	unsigned int lookaround_rate_mrr;
 };
 
+struct minstrel_debugfs_info {
+	size_t len;
+	char buf[];
+};
+
 void minstrel_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir);
 void minstrel_remove_sta_debugfs(void *priv, void *priv_sta);
 
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -52,21 +52,15 @@
 #include <net/mac80211.h>
 #include "rc80211_minstrel.h"
 
-struct minstrel_stats_info {
-	struct minstrel_sta_info *mi;
-	char buf[4096];
-	size_t len;
-};
-
 static int
 minstrel_stats_open(struct inode *inode, struct file *file)
 {
 	struct minstrel_sta_info *mi = inode->i_private;
-	struct minstrel_stats_info *ms;
+	struct minstrel_debugfs_info *ms;
 	unsigned int i, tp, prob, eprob;
 	char *p;
 
-	ms = kmalloc(sizeof(*ms), GFP_KERNEL);
+	ms = kmalloc(sizeof(*ms) + 4096, GFP_KERNEL);
 	if (!ms)
 		return -ENOMEM;
 
@@ -107,35 +101,18 @@ minstrel_stats_open(struct inode *inode,
 }
 
 static ssize_t
-minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *o)
+minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *ppos)
 {
-	struct minstrel_stats_info *ms;
-	char *src;
+	struct minstrel_debugfs_info *ms;
 
 	ms = file->private_data;
-	src = ms->buf;
-
-	len = min(len, ms->len);
-	if (len <= *o)
-		return 0;
-
-	src += *o;
-	len -= *o;
-	*o += len;
-
-	if (copy_to_user(buf, src, len))
-		return -EFAULT;
-
-	return len;
+	return simple_read_from_buffer(buf, len, ppos, ms->buf, ms->len);
 }
 
 static int
 minstrel_stats_release(struct inode *inode, struct file *file)
 {
-	struct minstrel_stats_info *ms = file->private_data;
-
-	kfree(ms);
-
+	kfree(file->private_data);
 	return 0;
 }
 
