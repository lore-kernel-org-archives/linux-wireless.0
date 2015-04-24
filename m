Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39495 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966777AbbDXJVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 05:21:17 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] mac80211: clean up global debugfs statistics
Date: Fri, 24 Apr 2015 11:21:10 +0200
Message-Id: <1429867273-18271-1-git-send-email-johannes@sipsolutions.net> (sfid-20150424_112121_692068_75E6468D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The debugfs statistics macros are pointlessly verbose, so change
that macro to just have a single argument. While at it, remove
the unused counters and rename rx_expand_skb_head2 to the better
rx_expand_skb_head_defrag.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs.c     | 74 ++++++++++++++++------------------------------
 net/mac80211/ieee80211_i.h |  4 +--
 net/mac80211/rx.c          |  2 +-
 3 files changed, 28 insertions(+), 52 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 23813ebb349c..854bf42c4804 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -219,8 +219,8 @@ static const struct file_operations stats_ ##name## _ops = {		\
 	.llseek = generic_file_llseek,					\
 };
 
-#define DEBUGFS_STATS_ADD(name, field)					\
-	debugfs_create_u32(#name, 0400, statsd, (u32 *) &field);
+#define DEBUGFS_STATS_ADD(name)					\
+	debugfs_create_u32(#name, 0400, statsd, &local->name);
 #define DEBUGFS_DEVSTATS_ADD(name)					\
 	debugfs_create_file(#name, 0400, statsd, local, &stats_ ##name## _ops);
 
@@ -255,53 +255,31 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	if (!statsd)
 		return;
 
-	DEBUGFS_STATS_ADD(transmitted_fragment_count,
-		local->dot11TransmittedFragmentCount);
-	DEBUGFS_STATS_ADD(multicast_transmitted_frame_count,
-		local->dot11MulticastTransmittedFrameCount);
-	DEBUGFS_STATS_ADD(failed_count, local->dot11FailedCount);
-	DEBUGFS_STATS_ADD(retry_count, local->dot11RetryCount);
-	DEBUGFS_STATS_ADD(multiple_retry_count,
-		local->dot11MultipleRetryCount);
-	DEBUGFS_STATS_ADD(frame_duplicate_count,
-		local->dot11FrameDuplicateCount);
-	DEBUGFS_STATS_ADD(received_fragment_count,
-		local->dot11ReceivedFragmentCount);
-	DEBUGFS_STATS_ADD(multicast_received_frame_count,
-		local->dot11MulticastReceivedFrameCount);
-	DEBUGFS_STATS_ADD(transmitted_frame_count,
-		local->dot11TransmittedFrameCount);
+	DEBUGFS_STATS_ADD(dot11TransmittedFragmentCount);
+	DEBUGFS_STATS_ADD(dot11MulticastTransmittedFrameCount);
+	DEBUGFS_STATS_ADD(dot11FailedCount);
+	DEBUGFS_STATS_ADD(dot11RetryCount);
+	DEBUGFS_STATS_ADD(dot11MultipleRetryCount);
+	DEBUGFS_STATS_ADD(dot11FrameDuplicateCount);
+	DEBUGFS_STATS_ADD(dot11ReceivedFragmentCount);
+	DEBUGFS_STATS_ADD(dot11MulticastReceivedFrameCount);
+	DEBUGFS_STATS_ADD(dot11TransmittedFrameCount);
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-	DEBUGFS_STATS_ADD(tx_handlers_drop, local->tx_handlers_drop);
-	DEBUGFS_STATS_ADD(tx_handlers_queued, local->tx_handlers_queued);
-	DEBUGFS_STATS_ADD(tx_handlers_drop_fragment,
-		local->tx_handlers_drop_fragment);
-	DEBUGFS_STATS_ADD(tx_handlers_drop_wep,
-		local->tx_handlers_drop_wep);
-	DEBUGFS_STATS_ADD(tx_handlers_drop_not_assoc,
-		local->tx_handlers_drop_not_assoc);
-	DEBUGFS_STATS_ADD(tx_handlers_drop_unauth_port,
-		local->tx_handlers_drop_unauth_port);
-	DEBUGFS_STATS_ADD(rx_handlers_drop, local->rx_handlers_drop);
-	DEBUGFS_STATS_ADD(rx_handlers_queued, local->rx_handlers_queued);
-	DEBUGFS_STATS_ADD(rx_handlers_drop_nullfunc,
-		local->rx_handlers_drop_nullfunc);
-	DEBUGFS_STATS_ADD(rx_handlers_drop_defrag,
-		local->rx_handlers_drop_defrag);
-	DEBUGFS_STATS_ADD(rx_handlers_drop_short,
-		local->rx_handlers_drop_short);
-	DEBUGFS_STATS_ADD(tx_expand_skb_head,
-		local->tx_expand_skb_head);
-	DEBUGFS_STATS_ADD(tx_expand_skb_head_cloned,
-		local->tx_expand_skb_head_cloned);
-	DEBUGFS_STATS_ADD(rx_expand_skb_head,
-		local->rx_expand_skb_head);
-	DEBUGFS_STATS_ADD(rx_expand_skb_head2,
-		local->rx_expand_skb_head2);
-	DEBUGFS_STATS_ADD(rx_handlers_fragments,
-		local->rx_handlers_fragments);
-	DEBUGFS_STATS_ADD(tx_status_drop,
-		local->tx_status_drop);
+	DEBUGFS_STATS_ADD(tx_handlers_drop);
+	DEBUGFS_STATS_ADD(tx_handlers_queued);
+	DEBUGFS_STATS_ADD(tx_handlers_drop_wep);
+	DEBUGFS_STATS_ADD(tx_handlers_drop_not_assoc);
+	DEBUGFS_STATS_ADD(tx_handlers_drop_unauth_port);
+	DEBUGFS_STATS_ADD(rx_handlers_drop);
+	DEBUGFS_STATS_ADD(rx_handlers_queued);
+	DEBUGFS_STATS_ADD(rx_handlers_drop_nullfunc);
+	DEBUGFS_STATS_ADD(rx_handlers_drop_defrag);
+	DEBUGFS_STATS_ADD(rx_handlers_drop_short);
+	DEBUGFS_STATS_ADD(tx_expand_skb_head);
+	DEBUGFS_STATS_ADD(tx_expand_skb_head_cloned);
+	DEBUGFS_STATS_ADD(rx_expand_skb_head_defrag);
+	DEBUGFS_STATS_ADD(rx_handlers_fragments);
+	DEBUGFS_STATS_ADD(tx_status_drop);
 #endif
 	DEBUGFS_DEVSTATS_ADD(dot11ACKFailureCount);
 	DEBUGFS_DEVSTATS_ADD(dot11RTSFailureCount);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 51b051b87bda..924ba0ca6bc8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1288,7 +1288,6 @@ struct ieee80211_local {
 	/* TX/RX handler statistics */
 	unsigned int tx_handlers_drop;
 	unsigned int tx_handlers_queued;
-	unsigned int tx_handlers_drop_fragment;
 	unsigned int tx_handlers_drop_wep;
 	unsigned int tx_handlers_drop_not_assoc;
 	unsigned int tx_handlers_drop_unauth_port;
@@ -1299,8 +1298,7 @@ struct ieee80211_local {
 	unsigned int rx_handlers_drop_short;
 	unsigned int tx_expand_skb_head;
 	unsigned int tx_expand_skb_head_cloned;
-	unsigned int rx_expand_skb_head;
-	unsigned int rx_expand_skb_head2;
+	unsigned int rx_expand_skb_head_defrag;
 	unsigned int rx_handlers_fragments;
 	unsigned int tx_status_drop;
 #define I802_DEBUG_INC(c) (c)++
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b69a071d7679..6336a79a7df2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1868,7 +1868,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
 	rx->skb = __skb_dequeue(&entry->skb_list);
 	if (skb_tailroom(rx->skb) < entry->extra_len) {
-		I802_DEBUG_INC(rx->local->rx_expand_skb_head2);
+		I802_DEBUG_INC(rx->local->rx_expand_skb_head_defrag);
 		if (unlikely(pskb_expand_head(rx->skb, 0, entry->extra_len,
 					      GFP_ATOMIC))) {
 			I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
-- 
2.1.4

