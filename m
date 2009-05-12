Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38557 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZELUGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 16:06:12 -0400
Subject: [PATCH] mac80211: make noack test available
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 May 2009 22:05:40 +0200
Message-Id: <1242158740.14227.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's this internal wifi_wme_noack_test variable that
we use to set the QoS control if set. For one, it is
unlikely that it is set. Secondly, if set it needs to
influence the IEEE80211_TX_CTL_NO_ACK TX control flag,
and finally we should also be able to set it at all, so
make it available in debugfs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs.c     |   38 ++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/tx.c          |    5 ++++-
 net/mac80211/wme.c         |    2 +-
 4 files changed, 44 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-05-12 21:44:01.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-05-12 22:03:26.000000000 +0200
@@ -1087,7 +1087,10 @@ __ieee80211_tx_prepare(struct ieee80211_
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	} else {
 		tx->flags |= IEEE80211_TX_UNICAST;
-		info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
+		if (unlikely(local->wifi_wme_noack_test))
+			info->flags |= IEEE80211_TX_CTL_NO_ACK;
+		else
+			info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
 	}
 
 	if (tx->flags & IEEE80211_TX_FRAGMENTED) {
--- wireless-testing.orig/net/mac80211/debugfs.c	2009-05-12 21:45:00.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs.c	2009-05-12 21:48:24.000000000 +0200
@@ -135,6 +135,42 @@ static const struct file_operations rese
 	.open = mac80211_open_file_generic,
 };
 
+static ssize_t noack_read(struct file *file, char __user *user_buf,
+			  size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	int res;
+	char buf[10];
+
+	res = scnprintf(buf, sizeof(buf), "%d\n", local->wifi_wme_noack_test);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
+}
+
+static ssize_t noack_write(struct file *file,
+			   const char __user *user_buf,
+			   size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	char buf[10];
+	size_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+
+	local->wifi_wme_noack_test = !!simple_strtoul(buf, NULL, 0);
+
+	return count;
+}
+
+static const struct file_operations noack_ops = {
+	.read = noack_read,
+	.write = noack_write,
+	.open = mac80211_open_file_generic
+};
+
 /* statistics stuff */
 
 #define DEBUGFS_STATS_FILE(name, buflen, fmt, value...)			\
@@ -275,6 +311,7 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(tsf);
 	DEBUGFS_ADD_MODE(reset, 0200);
+	DEBUGFS_ADD(noack);
 
 	statsd = debugfs_create_dir("statistics", phyd);
 	local->debugfs.statistics = statsd;
@@ -330,6 +367,7 @@ void debugfs_hw_del(struct ieee80211_loc
 	DEBUGFS_DEL(wep_iv);
 	DEBUGFS_DEL(tsf);
 	DEBUGFS_DEL(reset);
+	DEBUGFS_DEL(noack);
 
 	DEBUGFS_STATS_DEL(transmitted_fragment_count);
 	DEBUGFS_STATS_DEL(multicast_transmitted_frame_count);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-05-12 21:48:30.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-05-12 21:48:37.000000000 +0200
@@ -766,6 +766,7 @@ struct ieee80211_local {
 		struct dentry *wep_iv;
 		struct dentry *tsf;
 		struct dentry *reset;
+		struct dentry *noack;
 		struct dentry *statistics;
 		struct local_debugfsdentries_statsdentries {
 			struct dentry *transmitted_fragment_count;
--- wireless-testing.orig/net/mac80211/wme.c	2009-05-12 21:43:32.000000000 +0200
+++ wireless-testing/net/mac80211/wme.c	2009-05-12 22:03:37.000000000 +0200
@@ -133,7 +133,7 @@ u16 ieee80211_select_queue(struct net_de
 		u8 *p = ieee80211_get_qos_ctl(hdr);
 		u8 ack_policy = 0;
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
-		if (local->wifi_wme_noack_test)
+		if (unlikely(local->wifi_wme_noack_test))
 			ack_policy |= QOS_CONTROL_ACK_POLICY_NOACK <<
 					QOS_CONTROL_ACK_POLICY_SHIFT;
 		/* qos header is 2 bytes, second reserved */


