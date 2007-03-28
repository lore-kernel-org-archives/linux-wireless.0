Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48700 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbXC2LID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:08:03 -0400
Subject: [PATCH] fix debugfs compile w/o debug counters
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 23:09:22 +0200
Message-Id: <1175116163.5151.145.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ouch. So I made a rather stupid mistake when doing the debugfs stuff in
that some things aren't properly ifdef'ed with debug counter support.
This patch fixes it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Workaround: enable debug counters...

 net/mac80211/debugfs.c     |   20 ++++++++++----------
 net/mac80211/debugfs_sta.c |    4 ++++
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/sta_info.h    |    2 ++
 4 files changed, 18 insertions(+), 12 deletions(-)

--- wireless-dev.orig/net/mac80211/debugfs.c	2007-03-28 22:57:03.937731699 +0200
+++ wireless-dev/net/mac80211/debugfs.c	2007-03-28 22:59:12.287731699 +0200
@@ -246,12 +246,6 @@ DEBUGFS_STATS_FILE(rx_handlers_fragments
 		   local->rx_handlers_fragments);
 DEBUGFS_STATS_FILE(tx_status_drop, 20, "%u",
 		   local->tx_status_drop);
-#endif
-
-DEBUGFS_DEVSTATS_FILE(dot11ACKFailureCount);
-DEBUGFS_DEVSTATS_FILE(dot11RTSFailureCount);
-DEBUGFS_DEVSTATS_FILE(dot11FCSErrorCount);
-DEBUGFS_DEVSTATS_FILE(dot11RTSSuccessCount);
 
 static ssize_t stats_wme_rx_queue_read(struct file *file,
 				       char __user *userbuf,
@@ -292,6 +286,12 @@ static const struct file_operations stat
 	.read = stats_wme_tx_queue_read,
 	.open = mac80211_open_file_generic,
 };
+#endif
+
+DEBUGFS_DEVSTATS_FILE(dot11ACKFailureCount);
+DEBUGFS_DEVSTATS_FILE(dot11RTSFailureCount);
+DEBUGFS_DEVSTATS_FILE(dot11FCSErrorCount);
+DEBUGFS_DEVSTATS_FILE(dot11RTSSuccessCount);
 
 
 void debugfs_hw_add(struct ieee80211_local *local)
@@ -360,13 +360,13 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_STATS_ADD(rx_expand_skb_head2);
 	DEBUGFS_STATS_ADD(rx_handlers_fragments);
 	DEBUGFS_STATS_ADD(tx_status_drop);
+	DEBUGFS_STATS_ADD(wme_tx_queue);
+	DEBUGFS_STATS_ADD(wme_rx_queue);
 #endif
 	DEBUGFS_STATS_ADD(dot11ACKFailureCount);
 	DEBUGFS_STATS_ADD(dot11RTSFailureCount);
 	DEBUGFS_STATS_ADD(dot11FCSErrorCount);
 	DEBUGFS_STATS_ADD(dot11RTSSuccessCount);
-	DEBUGFS_STATS_ADD(wme_tx_queue);
-	DEBUGFS_STATS_ADD(wme_rx_queue);
 }
 
 void debugfs_hw_del(struct ieee80211_local *local)
@@ -419,13 +419,13 @@ void debugfs_hw_del(struct ieee80211_loc
 	DEBUGFS_STATS_DEL(rx_expand_skb_head2);
 	DEBUGFS_STATS_DEL(rx_handlers_fragments);
 	DEBUGFS_STATS_DEL(tx_status_drop);
+	DEBUGFS_STATS_DEL(wme_tx_queue);
+	DEBUGFS_STATS_DEL(wme_rx_queue);
 #endif
 	DEBUGFS_STATS_DEL(dot11ACKFailureCount);
 	DEBUGFS_STATS_DEL(dot11RTSFailureCount);
 	DEBUGFS_STATS_DEL(dot11FCSErrorCount);
 	DEBUGFS_STATS_DEL(dot11RTSSuccessCount);
-	DEBUGFS_STATS_DEL(wme_tx_queue);
-	DEBUGFS_STATS_DEL(wme_rx_queue);
 
 	debugfs_remove(local->debugfs.statistics);
 	local->debugfs.statistics = NULL;
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-03-28 22:58:07.635731699 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-03-28 22:58:20.591731699 +0200
@@ -647,13 +647,13 @@ struct ieee80211_local {
 			struct dentry *rx_expand_skb_head2;
 			struct dentry *rx_handlers_fragments;
 			struct dentry *tx_status_drop;
+			struct dentry *wme_tx_queue;
+			struct dentry *wme_rx_queue;
 #endif
 			struct dentry *dot11ACKFailureCount;
 			struct dentry *dot11RTSFailureCount;
 			struct dentry *dot11FCSErrorCount;
 			struct dentry *dot11RTSSuccessCount;
-			struct dentry *wme_tx_queue;
-			struct dentry *wme_rx_queue;
 		} stats;
 		struct dentry *stations;
 		struct dentry *keys;
--- wireless-dev.orig/net/mac80211/debugfs_sta.c	2007-03-28 22:59:49.973731699 +0200
+++ wireless-dev/net/mac80211/debugfs_sta.c	2007-03-28 23:00:22.353731699 +0200
@@ -222,8 +222,10 @@ void ieee80211_sta_debugfs_add(struct st
 	DEBUGFS_ADD(last_ack_ms);
 	DEBUGFS_ADD(inactive_ms);
 	DEBUGFS_ADD(last_seq_ctrl);
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	DEBUGFS_ADD(wme_rx_queue);
 	DEBUGFS_ADD(wme_tx_queue);
+#endif
 }
 
 void ieee80211_sta_debugfs_remove(struct sta_info *sta)
@@ -234,8 +236,10 @@ void ieee80211_sta_debugfs_remove(struct
 	DEBUGFS_DEL(last_ack_ms);
 	DEBUGFS_DEL(inactive_ms);
 	DEBUGFS_DEL(last_seq_ctrl);
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	DEBUGFS_DEL(wme_rx_queue);
 	DEBUGFS_DEL(wme_tx_queue);
+#endif
 
 	debugfs_remove(sta->debugfs.dir);
 	sta->debugfs.dir = NULL;
--- wireless-dev.orig/net/mac80211/sta_info.h	2007-03-28 23:01:03.437731699 +0200
+++ wireless-dev/net/mac80211/sta_info.h	2007-03-28 23:01:15.009731699 +0200
@@ -124,8 +124,10 @@ struct sta_info {
 		struct dentry *last_ack_ms;
 		struct dentry *inactive_ms;
 		struct dentry *last_seq_ctrl;
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 		struct dentry *wme_rx_queue;
 		struct dentry *wme_tx_queue;
+#endif
 	} debugfs;
 #endif
 };


