Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZFNPgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2009 11:36:49 -0400
Subject: [PATCH] mac80211: add queue debugfs file
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 14 Jun 2009 17:37:39 +0200
Message-Id: <1244993859.13033.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I suspect that some driver bugs can cause queues to be
stopped while they shouldn't be, but it's hard to find
out whether that is the case or not without having any
visible information about the queues. This adds a file
to debugfs that allows us to see the queues' statuses.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs.c     |   25 +++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    1 +
 2 files changed, 26 insertions(+)

--- wireless-testing.orig/net/mac80211/debugfs.c	2009-06-14 17:18:26.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs.c	2009-06-14 17:28:07.000000000 +0200
@@ -163,6 +163,29 @@ static const struct file_operations noac
 	.open = mac80211_open_file_generic
 };
 
+static ssize_t queues_read(struct file *file, char __user *user_buf,
+			   size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	unsigned long flags;
+	char buf[IEEE80211_MAX_QUEUES * 20];
+	int q, res = 0;
+
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+	for (q = 0; q < local->hw.queues; q++)
+		res += sprintf(buf + res, "%02d: %#.8lx/%d\n", q,
+				local->queue_stop_reasons[q],
+				__netif_subqueue_stopped(local->mdev, q));
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
+}
+
+static const struct file_operations queues_ops = {
+	.read = queues_read,
+	.open = mac80211_open_file_generic
+};
+
 /* statistics stuff */
 
 #define DEBUGFS_STATS_FILE(name, buflen, fmt, value...)			\
@@ -298,6 +321,7 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(tsf);
+	DEBUGFS_ADD(queues);
 	DEBUGFS_ADD_MODE(reset, 0200);
 	DEBUGFS_ADD(noack);
 
@@ -350,6 +374,7 @@ void debugfs_hw_del(struct ieee80211_loc
 	DEBUGFS_DEL(total_ps_buffered);
 	DEBUGFS_DEL(wep_iv);
 	DEBUGFS_DEL(tsf);
+	DEBUGFS_DEL(queues);
 	DEBUGFS_DEL(reset);
 	DEBUGFS_DEL(noack);
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-06-14 17:27:19.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-06-14 17:27:25.000000000 +0200
@@ -783,6 +783,7 @@ struct ieee80211_local {
 		struct dentry *total_ps_buffered;
 		struct dentry *wep_iv;
 		struct dentry *tsf;
+		struct dentry *queues;
 		struct dentry *reset;
 		struct dentry *noack;
 		struct dentry *statistics;


