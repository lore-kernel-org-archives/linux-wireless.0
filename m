Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42141 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421AbcCaREW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 13:04:22 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/10] mac80211: fix RX u64 stats consistency on 32-bit platforms
Date: Thu, 31 Mar 2016 20:02:09 +0300
Message-Id: <1459443731-4614-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160331_190429_125736_31252D3D)
In-Reply-To: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

On 32-bit platforms, the 64-bit counters we keep need to be protected
to be consistently read. Use the u64_stats_sync mechanism to do that.

In order to not end up with overly long lines, refactor the tidstats
assignments a bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c       |  6 +++++
 net/mac80211/sta_info.c | 72 ++++++++++++++++++++++++++++++-------------------
 net/mac80211/sta_info.h |  5 +++-
 3 files changed, 54 insertions(+), 29 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 40981f8..1511bd1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1441,7 +1441,11 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		ieee80211_sta_rx_notify(rx->sdata, hdr);
 
 	sta->rx_stats.fragments++;
+
+	u64_stats_update_begin(&rx->sta->rx_stats.syncp);
 	sta->rx_stats.bytes += rx->skb->len;
+	u64_stats_update_end(&rx->sta->rx_stats.syncp);
+
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		sta->rx_stats.last_signal = status->signal;
 		ewma_signal_add(&sta->rx_stats_avg.signal, -status->signal);
@@ -2106,7 +2110,9 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 		 * for non-QoS-data frames. Here we know it's a data
 		 * frame, so count MSDUs.
 		 */
+		u64_stats_update_begin(&rx->sta->rx_stats.syncp);
 		rx->sta->rx_stats.msdu[rx->seqno_idx]++;
+		u64_stats_update_end(&rx->sta->rx_stats.syncp);
 	}
 
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 81f1d6c..f097a5e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -335,6 +335,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->sdata = sdata;
 	sta->rx_stats.last_rx = jiffies;
 
+	u64_stats_init(&sta->rx_stats.syncp);
+
 	sta->sta_state = IEEE80211_STA_NONE;
 
 	/* Mark TID as unreserved */
@@ -1971,6 +1973,41 @@ static void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 		sta_stats_decode_rate(sta->local, rate, rinfo);
 }
 
+static void sta_set_tidstats(struct sta_info *sta,
+			     struct cfg80211_tid_stats *tidstats,
+			     int tid)
+{
+	struct ieee80211_local *local = sta->local;
+
+	if (!(tidstats->filled & BIT(NL80211_TID_STATS_RX_MSDU))) {
+		unsigned int start;
+
+		do {
+			start = u64_stats_fetch_begin(&sta->rx_stats.syncp);
+			tidstats->rx_msdu = sta->rx_stats.msdu[tid];
+		} while (u64_stats_fetch_retry(&sta->rx_stats.syncp, start));
+
+		tidstats->filled |= BIT(NL80211_TID_STATS_RX_MSDU);
+	}
+
+	if (!(tidstats->filled & BIT(NL80211_TID_STATS_TX_MSDU))) {
+		tidstats->filled |= BIT(NL80211_TID_STATS_TX_MSDU);
+		tidstats->tx_msdu = sta->tx_stats.msdu[tid];
+	}
+
+	if (!(tidstats->filled & BIT(NL80211_TID_STATS_TX_MSDU_RETRIES)) &&
+	    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
+		tidstats->filled |= BIT(NL80211_TID_STATS_TX_MSDU_RETRIES);
+		tidstats->tx_msdu_retries = sta->status_stats.msdu_retries[tid];
+	}
+
+	if (!(tidstats->filled & BIT(NL80211_TID_STATS_TX_MSDU_FAILED)) &&
+	    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
+		tidstats->filled |= BIT(NL80211_TID_STATS_TX_MSDU_FAILED);
+		tidstats->tx_msdu_failed = sta->status_stats.msdu_failed[tid];
+	}
+}
+
 void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -2025,7 +2062,12 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_RX_BYTES64) |
 			       BIT(NL80211_STA_INFO_RX_BYTES)))) {
-		sinfo->rx_bytes = sta->rx_stats.bytes;
+		unsigned int start;
+
+		do {
+			start = u64_stats_fetch_begin(&sta->rx_stats.syncp);
+			sinfo->rx_bytes = sta->rx_stats.bytes;
+		} while (u64_stats_fetch_retry(&sta->rx_stats.syncp, start));
 		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES64);
 	}
 
@@ -2097,33 +2139,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++) {
 		struct cfg80211_tid_stats *tidstats = &sinfo->pertid[i];
 
-		if (!(tidstats->filled & BIT(NL80211_TID_STATS_RX_MSDU))) {
-			tidstats->filled |= BIT(NL80211_TID_STATS_RX_MSDU);
-			tidstats->rx_msdu = sta->rx_stats.msdu[i];
-		}
-
-		if (!(tidstats->filled & BIT(NL80211_TID_STATS_TX_MSDU))) {
-			tidstats->filled |= BIT(NL80211_TID_STATS_TX_MSDU);
-			tidstats->tx_msdu = sta->tx_stats.msdu[i];
-		}
-
-		if (!(tidstats->filled &
-				BIT(NL80211_TID_STATS_TX_MSDU_RETRIES)) &&
-		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
-			tidstats->filled |=
-				BIT(NL80211_TID_STATS_TX_MSDU_RETRIES);
-			tidstats->tx_msdu_retries =
-				sta->status_stats.msdu_retries[i];
-		}
-
-		if (!(tidstats->filled &
-				BIT(NL80211_TID_STATS_TX_MSDU_FAILED)) &&
-		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
-			tidstats->filled |=
-				BIT(NL80211_TID_STATS_TX_MSDU_FAILED);
-			tidstats->tx_msdu_failed =
-				sta->status_stats.msdu_failed[i];
-		}
+		sta_set_tidstats(sta, tidstats, i);
 	}
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f36f560..cbce43f 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -18,6 +18,7 @@
 #include <linux/average.h>
 #include <linux/etherdevice.h>
 #include <linux/rhashtable.h>
+#include <linux/u64_stats_sync.h>
 #include "key.h"
 
 /**
@@ -444,7 +445,6 @@ struct sta_info {
 	/* Updated from RX path only, no locking requirements */
 	struct {
 		unsigned long packets;
-		u64 bytes;
 		unsigned long last_rx;
 		unsigned long num_duplicates;
 		unsigned long fragments;
@@ -453,6 +453,9 @@ struct sta_info {
 		u8 chains;
 		s8 chain_signal_last[IEEE80211_MAX_CHAINS];
 		u16 last_rate;
+
+		struct u64_stats_sync syncp;
+		u64 bytes;
 		u64 msdu[IEEE80211_NUM_TIDS + 1];
 	} rx_stats;
 	struct {
-- 
2.5.0

