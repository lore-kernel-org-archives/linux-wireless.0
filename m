Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54188 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbbFROGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 10:06:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: protect u64 statistics properly on 32-bit
Date: Thu, 18 Jun 2015 16:06:43 +0200
Message-Id: <1434636403-9871-1-git-send-email-johannes@sipsolutions.net> (sfid-20150618_160651_571189_0D27DF45)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

On 32-bit architectures, the various (new) 64-bit statistics
aren't protected against reading while they're being changed
(which isn't atomic unlike on 64-bit architectures.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c       |  5 ++++
 net/mac80211/sta_info.c | 68 +++++++++++++++++++++++++++++++++++++++++++------
 net/mac80211/sta_info.h | 17 +++++++++----
 net/mac80211/status.c   |  2 ++
 net/mac80211/tx.c       | 14 +++++++---
 5 files changed, 90 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3a1462810c8e..eae50d095930 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1425,7 +1425,10 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		ieee80211_sta_rx_notify(rx->sdata, hdr);
 
 	sta->rx_fragments++;
+	u64_stats_update_begin(&sta->rx_sync);
 	sta->rx_bytes += rx->skb->len;
+	u64_stats_update_end(&sta->rx_sync);
+
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		sta->last_signal = status->signal;
 		ewma_add(&sta->avg_signal, -status->signal);
@@ -2376,7 +2379,9 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 		 * for non-QoS-data frames. Here we know it's a data
 		 * frame, so count MSDUs.
 		 */
+		u64_stats_update_begin(&rx->sta->rx_sync);
 		rx->sta->rx_msdu[rx->seqno_idx]++;
+		u64_stats_update_end(&rx->sta->rx_sync);
 	}
 
 	/*
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9da7d2bc271a..494422729132 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -328,6 +328,10 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	}
 #endif
 
+	u64_stats_init(&sta->rx_sync);
+	u64_stats_init(&sta->tx_sync);
+	u64_stats_init(&sta->status_sync);
+
 	memcpy(sta->addr, addr, ETH_ALEN);
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;
@@ -1811,6 +1815,45 @@ u8 sta_info_tx_streams(struct sta_info *sta)
 			>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT) + 1;
 }
 
+static u64 sta_get_tx_stat(struct sta_info *sta, u64 *value)
+{
+	u64 res;
+	unsigned int start;
+
+	do {
+		start = u64_stats_fetch_begin_irq(&sta->tx_sync);
+		res = *value;
+	} while (u64_stats_fetch_retry_irq(&sta->tx_sync, start));
+
+	return res;
+}
+
+static u64 sta_get_status_stat(struct sta_info *sta, u64 *value)
+{
+	u64 res;
+	unsigned int start;
+
+	do {
+		start = u64_stats_fetch_begin_irq(&sta->status_sync);
+		res = *value;
+	} while (u64_stats_fetch_retry_irq(&sta->status_sync, start));
+
+	return res;
+}
+
+static u64 sta_get_rx_stat(struct sta_info *sta, u64 *value)
+{
+	u64 res;
+	unsigned int start;
+
+	do {
+		start = u64_stats_fetch_begin_irq(&sta->rx_sync);
+		res = *value;
+	} while (u64_stats_fetch_retry_irq(&sta->rx_sync, start));
+
+	return res;
+}
+
 void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -1849,20 +1892,23 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			       BIT(NL80211_STA_INFO_TX_BYTES)))) {
 		sinfo->tx_bytes = 0;
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			sinfo->tx_bytes += sta->tx_bytes[ac];
+			sinfo->tx_bytes +=
+				sta_get_tx_stat(sta, &sta->tx_bytes[ac]);
 		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES64);
 	}
 
 	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_PACKETS))) {
 		sinfo->tx_packets = 0;
-		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			sinfo->tx_packets += sta->tx_packets[ac];
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+			sinfo->tx_packets +=
+				sta_get_tx_stat(sta, &sta->tx_packets[ac]);
+		}
 		sinfo->filled |= BIT(NL80211_STA_INFO_TX_PACKETS);
 	}
 
 	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_RX_BYTES64) |
 			       BIT(NL80211_STA_INFO_RX_BYTES)))) {
-		sinfo->rx_bytes = sta->rx_bytes;
+		sinfo->rx_bytes = sta_get_rx_stat(sta, &sta->rx_bytes);
 		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES64);
 	}
 
@@ -1934,12 +1980,14 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 		if (!(tidstats->filled & BIT(NL80211_TID_STATS_RX_MSDU))) {
 			tidstats->filled |= BIT(NL80211_TID_STATS_RX_MSDU);
-			tidstats->rx_msdu = sta->rx_msdu[i];
+			tidstats->rx_msdu = sta_get_rx_stat(sta,
+							    &sta->rx_msdu[i]);
 		}
 
 		if (!(tidstats->filled & BIT(NL80211_TID_STATS_TX_MSDU))) {
 			tidstats->filled |= BIT(NL80211_TID_STATS_TX_MSDU);
-			tidstats->tx_msdu = sta->tx_msdu[i];
+			tidstats->tx_msdu = sta_get_tx_stat(sta,
+							    &sta->tx_msdu[i]);
 		}
 
 		if (!(tidstats->filled &
@@ -1947,7 +1995,9 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 			tidstats->filled |=
 				BIT(NL80211_TID_STATS_TX_MSDU_RETRIES);
-			tidstats->tx_msdu_retries = sta->tx_msdu_retries[i];
+			tidstats->tx_msdu_retries =
+				sta_get_status_stat(sta,
+						    &sta->tx_msdu_retries[i]);
 		}
 
 		if (!(tidstats->filled &
@@ -1955,7 +2005,9 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 			tidstats->filled |=
 				BIT(NL80211_TID_STATS_TX_MSDU_FAILED);
-			tidstats->tx_msdu_failed = sta->tx_msdu_failed[i];
+			tidstats->tx_msdu_failed =
+				sta_get_status_stat(sta,
+						    &sta->tx_msdu_failed[i]);
 		}
 	}
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 0fbf3f348446..4f4f32f08a90 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -17,6 +17,7 @@
 #include <linux/average.h>
 #include <linux/etherdevice.h>
 #include <linux/rhashtable.h>
+#include <linux/u64_stats_sync.h>
 #include "key.h"
 
 /**
@@ -450,7 +451,6 @@ struct sta_info {
 
 	/* Updated from RX path only, no locking requirements */
 	unsigned long rx_packets;
-	u64 rx_bytes;
 	unsigned long last_rx;
 	long last_connected;
 	unsigned long num_duplicates;
@@ -460,6 +460,10 @@ struct sta_info {
 	struct ewma avg_signal;
 	int last_ack_signal;
 
+	struct u64_stats_sync rx_sync;
+	u64 rx_bytes;
+	u64 rx_msdu[IEEE80211_NUM_TIDS + 1];
+
 	u8 chains;
 	s8 chain_signal_last[IEEE80211_MAX_CHAINS];
 	struct ewma chain_signal_avg[IEEE80211_MAX_CHAINS];
@@ -473,19 +477,22 @@ struct sta_info {
 	/* moving percentage of failed MSDUs */
 	unsigned int fail_avg;
 
+	struct u64_stats_sync status_sync;
+	u64 tx_msdu_retries[IEEE80211_NUM_TIDS + 1];
+	u64 tx_msdu_failed[IEEE80211_NUM_TIDS + 1];
+
 	/* Updated from TX path only, no locking requirements */
+	struct u64_stats_sync tx_sync;
 	u64 tx_packets[IEEE80211_NUM_ACS];
 	u64 tx_bytes[IEEE80211_NUM_ACS];
+	u64 tx_msdu[IEEE80211_NUM_TIDS + 1];
+
 	struct ieee80211_tx_rate last_tx_rate;
 	int last_rx_rate_idx;
 	u32 last_rx_rate_flag;
 	u32 last_rx_rate_vht_flag;
 	u8 last_rx_rate_vht_nss;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
-	u64 tx_msdu[IEEE80211_NUM_TIDS + 1];
-	u64 tx_msdu_retries[IEEE80211_NUM_TIDS + 1];
-	u64 tx_msdu_failed[IEEE80211_NUM_TIDS + 1];
-	u64 rx_msdu[IEEE80211_NUM_TIDS + 1];
 
 	/*
 	 * Aggregation information, locked with lock.
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 45628f37c083..fe145668a30c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -783,9 +783,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			sta->tx_retry_count += retry_count;
 
 			if (ieee80211_is_data_present(fc)) {
+				u64_stats_update_begin(&sta->status_sync);
 				if (!acked)
 					sta->tx_msdu_failed[tid]++;
 				sta->tx_msdu_retries[tid] += retry_count;
+				u64_stats_update_end(&sta->status_sync);
 			}
 		}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c0d6af809640..9489b5da5a46 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -822,8 +822,11 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 		/* for pure STA mode without beacons, we can do it */
 		hdr->seq_ctrl = cpu_to_le16(tx->sdata->sequence_number);
 		tx->sdata->sequence_number += 0x10;
-		if (tx->sta)
+		if (tx->sta) {
+			u64_stats_update_begin(&tx->sta->tx_sync);
 			tx->sta->tx_msdu[IEEE80211_NUM_TIDS]++;
+			u64_stats_update_end(&tx->sta->tx_sync);
+		}
 		return TX_CONTINUE;
 	}
 
@@ -839,7 +842,9 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 
 	qc = ieee80211_get_qos_ctl(hdr);
 	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
+	u64_stats_update_begin(&tx->sta->tx_sync);
 	tx->sta->tx_msdu[tid]++;
+	u64_stats_update_end(&tx->sta->tx_sync);
 
 	if (!tx->sta->sta.txq[0])
 		hdr->seq_ctrl = ieee80211_tx_next_seq(tx->sta, tid);
@@ -991,12 +996,14 @@ ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 	if (!tx->sta)
 		return TX_CONTINUE;
 
+	u64_stats_update_begin(&tx->sta->tx_sync);
 	skb_queue_walk(&tx->skbs, skb) {
 		ac = skb_get_queue_mapping(skb);
 		tx->sta->tx_bytes[ac] += skb->len;
 	}
 	if (ac >= 0)
 		tx->sta->tx_packets[ac]++;
+	u64_stats_update_end(&tx->sta->tx_sync);
 
 	return TX_CONTINUE;
 }
@@ -2771,8 +2778,6 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 		sdata->sequence_number += 0x10;
 	}
 
-	sta->tx_msdu[tid]++;
-
 	info->hw_queue = sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
 
 	__skb_queue_head_init(&tx.skbs);
@@ -2802,8 +2807,11 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	/* statistics normally done by ieee80211_tx_h_stats (but that
 	 * has to consider fragmentation, so is more complex)
 	 */
+	u64_stats_update_begin(&sta->tx_sync);
 	sta->tx_bytes[skb_get_queue_mapping(skb)] += skb->len;
 	sta->tx_packets[skb_get_queue_mapping(skb)]++;
+	sta->tx_msdu[tid]++;
+	u64_stats_update_end(&sta->tx_sync);
 
 	if (fast_tx->pn_offs) {
 		u64 pn;
-- 
2.1.4

