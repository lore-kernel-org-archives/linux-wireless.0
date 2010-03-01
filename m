Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48629 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab0CAVVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 16:21:42 -0500
Message-ID: <4B8C2FE4.2020202@openwrt.org>
Date: Mon, 01 Mar 2010 22:21:40 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] minstrel: make the rate control ops reusable from another
 rc implementation
References: <4B8C2EF2.4050908@openwrt.org>
In-Reply-To: <4B8C2EF2.4050908@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes it possible to reuse the minstrel rate control ops
from another rate control module. This is useful in preparing for the
new 802.11n implementation of minstrel, which will reuse the old code
for legacy stations.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -85,7 +85,13 @@ struct minstrel_debugfs_info {
 	char buf[];
 };
 
+extern struct rate_control_ops mac80211_minstrel;
 void minstrel_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir);
 void minstrel_remove_sta_debugfs(void *priv, void *priv_sta);
 
+/* debugfs */
+int minstrel_stats_open(struct inode *inode, struct file *file);
+ssize_t minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *ppos);
+int minstrel_stats_release(struct inode *inode, struct file *file);
+
 #endif
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -541,7 +541,7 @@ minstrel_free(void *priv)
 	kfree(priv);
 }
 
-static struct rate_control_ops mac80211_minstrel = {
+struct rate_control_ops mac80211_minstrel = {
 	.name = "minstrel",
 	.tx_status = minstrel_tx_status,
 	.get_rate = minstrel_get_rate,
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -52,7 +52,7 @@
 #include <net/mac80211.h>
 #include "rc80211_minstrel.h"
 
-static int
+int
 minstrel_stats_open(struct inode *inode, struct file *file)
 {
 	struct minstrel_sta_info *mi = inode->i_private;
@@ -100,7 +100,7 @@ minstrel_stats_open(struct inode *inode,
 	return 0;
 }
 
-static ssize_t
+ssize_t
 minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *ppos)
 {
 	struct minstrel_debugfs_info *ms;
@@ -109,7 +109,7 @@ minstrel_stats_read(struct file *file, c
 	return simple_read_from_buffer(buf, len, ppos, ms->buf, ms->len);
 }
 
-static int
+int
 minstrel_stats_release(struct inode *inode, struct file *file)
 {
 	kfree(file->private_data);

