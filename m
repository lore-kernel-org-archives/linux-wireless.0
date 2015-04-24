Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39496 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966780AbbDXJVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 05:21:17 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211: move dot11 counters under MAC80211_DEBUG_COUNTERS
Date: Fri, 24 Apr 2015 11:21:11 +0200
Message-Id: <1429867273-18271-2-git-send-email-johannes@sipsolutions.net> (sfid-20150424_112124_065692_BCFA0E0F)
In-Reply-To: <1429867273-18271-1-git-send-email-johannes@sipsolutions.net>
References: <1429867273-18271-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since these counters can only be read through debugfs, there's
very little point in maintaining them all the time. However,
even just making them depend on debugfs is pointless - they're
not normally used. Additionally a number of them aren't even
concurrency safe.

Move them under MAC80211_DEBUG_COUNTERS so they're normally
not even compiled in.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/Kconfig       |  6 +++++-
 net/mac80211/debugfs.c     |  2 +-
 net/mac80211/ieee80211_i.h | 16 ++++++++--------
 net/mac80211/rx.c          |  6 +++---
 net/mac80211/status.c      | 28 ++++++++++++++--------------
 5 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 5f698d4ec53b..086de496a4c1 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -302,7 +302,11 @@ config MAC80211_DEBUG_COUNTERS
 	---help---
 	  Selecting this option causes mac80211 to keep additional
 	  and very verbose statistics about TX and RX handler use
-	  and show them in debugfs.
+	  as well as a few selected dot11 counters. These will be
+	  exposed in debugfs.
+
+	  Note that some of the counters are not concurrency safe
+	  and may thus not always be accurate.
 
 	  If unsure, say N.
 
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 854bf42c4804..b17206db49b4 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -255,6 +255,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	if (!statsd)
 		return;
 
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	DEBUGFS_STATS_ADD(dot11TransmittedFragmentCount);
 	DEBUGFS_STATS_ADD(dot11MulticastTransmittedFrameCount);
 	DEBUGFS_STATS_ADD(dot11FailedCount);
@@ -264,7 +265,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_STATS_ADD(dot11ReceivedFragmentCount);
 	DEBUGFS_STATS_ADD(dot11MulticastReceivedFrameCount);
 	DEBUGFS_STATS_ADD(dot11TransmittedFrameCount);
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	DEBUGFS_STATS_ADD(tx_handlers_drop);
 	DEBUGFS_STATS_ADD(tx_handlers_queued);
 	DEBUGFS_STATS_ADD(tx_handlers_drop_wep);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 924ba0ca6bc8..95ac2eb25f31 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1265,6 +1265,14 @@ struct ieee80211_local {
 	struct list_head chanctx_list;
 	struct mutex chanctx_mtx;
 
+#ifdef CONFIG_MAC80211_LEDS
+	struct led_trigger *tx_led, *rx_led, *assoc_led, *radio_led;
+	struct tpt_led_trigger *tpt_led_trigger;
+	char tx_led_name[32], rx_led_name[32],
+	     assoc_led_name[32], radio_led_name[32];
+#endif
+
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	/* SNMP counters */
 	/* dot11CountersTable */
 	u32 dot11TransmittedFragmentCount;
@@ -1277,14 +1285,6 @@ struct ieee80211_local {
 	u32 dot11MulticastReceivedFrameCount;
 	u32 dot11TransmittedFrameCount;
 
-#ifdef CONFIG_MAC80211_LEDS
-	struct led_trigger *tx_led, *rx_led, *assoc_led, *radio_led;
-	struct tpt_led_trigger *tpt_led_trigger;
-	char tx_led_name[32], rx_led_name[32],
-	     assoc_led_name[32], radio_led_name[32];
-#endif
-
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	/* TX/RX handler statistics */
 	unsigned int tx_handlers_drop;
 	unsigned int tx_handlers_queued;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6336a79a7df2..d87978cf9ea8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1077,7 +1077,7 @@ ieee80211_rx_h_check_dup(struct ieee80211_rx_data *rx)
 		if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
 			     rx->sta->last_seq_ctrl[rx->seqno_idx] ==
 			     hdr->seq_ctrl)) {
-			rx->local->dot11FrameDuplicateCount++;
+			I802_DEBUG_INC(rx->local->dot11FrameDuplicateCount);
 			rx->sta->num_duplicates++;
 			return RX_DROP_UNUSABLE;
 		} else if (!(status->flag & RX_FLAG_AMSDU_MORE)) {
@@ -1785,7 +1785,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	frag = sc & IEEE80211_SCTL_FRAG;
 
 	if (is_multicast_ether_addr(hdr->addr1)) {
-		rx->local->dot11MulticastReceivedFrameCount++;
+		I802_DEBUG_INC(rx->local->dot11MulticastReceivedFrameCount);
 		goto out_no_led;
 	}
 
@@ -3393,7 +3393,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	rx.local = local;
 
 	if (ieee80211_is_data(fc) || ieee80211_is_mgmt(fc))
-		local->dot11ReceivedFragmentCount++;
+		I802_DEBUG_INC(local->dot11ReceivedFragmentCount);
 
 	if (ieee80211_is_mgmt(fc)) {
 		/* drop frame if too short for header */
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 005fdbe39a8b..461594966b65 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -631,15 +631,15 @@ void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
 	}
 
 	if (acked || noack_success) {
-		    local->dot11TransmittedFrameCount++;
-		    if (!pubsta)
-			    local->dot11MulticastTransmittedFrameCount++;
-		    if (retry_count > 0)
-			    local->dot11RetryCount++;
-		    if (retry_count > 1)
-			    local->dot11MultipleRetryCount++;
+		I802_DEBUG_INC(local->dot11TransmittedFrameCount);
+		if (!pubsta)
+			I802_DEBUG_INC(local->dot11MulticastTransmittedFrameCount);
+		if (retry_count > 0)
+			I802_DEBUG_INC(local->dot11RetryCount);
+		if (retry_count > 1)
+			I802_DEBUG_INC(local->dot11MultipleRetryCount);
 	} else {
-		local->dot11FailedCount++;
+		I802_DEBUG_INC(local->dot11FailedCount);
 	}
 }
 EXPORT_SYMBOL(ieee80211_tx_status_noskb);
@@ -802,13 +802,13 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if ((info->flags & IEEE80211_TX_STAT_ACK) ||
 	    (info->flags & IEEE80211_TX_STAT_NOACK_TRANSMITTED)) {
 		if (ieee80211_is_first_frag(hdr->seq_ctrl)) {
-			local->dot11TransmittedFrameCount++;
+			I802_DEBUG_INC(local->dot11TransmittedFrameCount);
 			if (is_multicast_ether_addr(ieee80211_get_DA(hdr)))
-				local->dot11MulticastTransmittedFrameCount++;
+				I802_DEBUG_INC(local->dot11MulticastTransmittedFrameCount);
 			if (retry_count > 0)
-				local->dot11RetryCount++;
+				I802_DEBUG_INC(local->dot11RetryCount);
 			if (retry_count > 1)
-				local->dot11MultipleRetryCount++;
+				I802_DEBUG_INC(local->dot11MultipleRetryCount);
 		}
 
 		/* This counter shall be incremented for an acknowledged MPDU
@@ -818,10 +818,10 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (!is_multicast_ether_addr(hdr->addr1) ||
 		    ieee80211_is_data(fc) ||
 		    ieee80211_is_mgmt(fc))
-			local->dot11TransmittedFragmentCount++;
+			I802_DEBUG_INC(local->dot11TransmittedFragmentCount);
 	} else {
 		if (ieee80211_is_first_frag(hdr->seq_ctrl))
-			local->dot11FailedCount++;
+			I802_DEBUG_INC(local->dot11FailedCount);
 	}
 
 	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
-- 
2.1.4

