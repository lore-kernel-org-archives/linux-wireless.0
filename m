Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42141 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421AbcCaRE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 13:04:29 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/10] mac80211: enable collecting station statistics per-CPU
Date: Thu, 31 Mar 2016 20:02:11 +0300
Message-Id: <1459443731-4614-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160331_190431_425163_9536E1B3)
In-Reply-To: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the driver advertises the new HW flag USE_RSS, make the
station statistics on the fast-rx path per-CPU. This will
enable calling the RX in parallel, only hitting locking or
shared cachelines when the fast-RX path isn't available.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h  |   4 ++
 net/mac80211/debugfs.c  |   1 +
 net/mac80211/rx.c       |  37 ++++++++++-------
 net/mac80211/sta_info.c | 108 +++++++++++++++++++++++++++++++++++++++++-------
 net/mac80211/sta_info.h |  36 +++++++++-------
 5 files changed, 140 insertions(+), 46 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index fd5ec44..5f4b4c7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1980,6 +1980,9 @@ struct ieee80211_txq {
  *	order and does not need to manage its own reorder buffer or BA session
  *	timeout.
  *
+ * @IEEE80211_HW_USES_RSS: The device uses RSS and thus requires parallel RX,
+ *	which implies using per-CPU station statistics.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2017,6 +2020,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_BEACON_TX_STATUS,
 	IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR,
 	IEEE80211_HW_SUPPORTS_REORDERING_BUFFER,
+	IEEE80211_HW_USES_RSS,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 4ab5c52..52ed2af 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -127,6 +127,7 @@ static const char *hw_flag_names[] = {
 	FLAG(BEACON_TX_STATUS),
 	FLAG(NEEDS_UNIQUE_STA_ADDR),
 	FLAG(SUPPORTS_REORDERING_BUFFER),
+	FLAG(USES_RSS),
 #undef FLAG
 };
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9bdb009..012be85 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3509,6 +3509,8 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 	ether_addr_copy(fastrx.rfc1042_hdr, rfc1042_header);
 	ether_addr_copy(fastrx.vif_addr, sdata->vif.addr);
 
+	fastrx.uses_rss = ieee80211_hw_check(&local->hw, USES_RSS);
+
 	/* fast-rx doesn't do reordering */
 	if (ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION) &&
 	    !ieee80211_hw_check(&local->hw, SUPPORTS_REORDERING_BUFFER))
@@ -3652,6 +3654,10 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 		u8 da[ETH_ALEN];
 		u8 sa[ETH_ALEN];
 	} addrs __aligned(2);
+	struct ieee80211_sta_rx_stats *stats = &sta->rx_stats;
+
+	if (fast_rx->uses_rss)
+		stats = this_cpu_ptr(sta->pcpu_rx_stats);
 
 	/* for parallel-rx, we need to have DUP_VALIDATED, otherwise we write
 	 * to a common data structure; drivers can implement that per queue
@@ -3733,29 +3739,32 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	}
 
 	/* statistics part of ieee80211_rx_h_sta_process() */
-	sta->rx_stats.last_rx = jiffies;
-	sta->rx_stats.last_rate = sta_stats_encode_rate(status);
+	stats->last_rx = jiffies;
+	stats->last_rate = sta_stats_encode_rate(status);
 
-	sta->rx_stats.fragments++;
+	stats->fragments++;
 
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
-		sta->rx_stats.last_signal = status->signal;
-		ewma_signal_add(&sta->rx_stats_avg.signal, -status->signal);
+		stats->last_signal = status->signal;
+		if (!fast_rx->uses_rss)
+			ewma_signal_add(&sta->rx_stats_avg.signal,
+					-status->signal);
 	}
 
 	if (status->chains) {
 		int i;
 
-		sta->rx_stats.chains = status->chains;
+		stats->chains = status->chains;
 		for (i = 0; i < ARRAY_SIZE(status->chain_signal); i++) {
 			int signal = status->chain_signal[i];
 
 			if (!(status->chains & BIT(i)))
 				continue;
 
-			sta->rx_stats.chain_signal_last[i] = signal;
-			ewma_signal_add(&sta->rx_stats_avg.chain_signal[i],
-					-signal);
+			stats->chain_signal_last[i] = signal;
+			if (!fast_rx->uses_rss)
+				ewma_signal_add(&sta->rx_stats_avg.chain_signal[i],
+						-signal);
 		}
 	}
 	/* end of statistics */
@@ -3780,10 +3789,10 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	 * for non-QoS-data frames. Here we know it's a data
 	 * frame, so count MSDUs.
 	 */
-	u64_stats_update_begin(&sta->rx_stats.syncp);
-	sta->rx_stats.msdu[rx->seqno_idx]++;
-	sta->rx_stats.bytes += orig_len;
-	u64_stats_update_end(&sta->rx_stats.syncp);
+	u64_stats_update_begin(&stats->syncp);
+	stats->msdu[rx->seqno_idx]++;
+	stats->bytes += orig_len;
+	u64_stats_update_end(&stats->syncp);
 
 	if (fast_rx->internal_forward) {
 		struct sta_info *dsta = sta_info_get(rx->sdata, skb->data);
@@ -3814,7 +3823,7 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	return true;
  drop:
 	dev_kfree_skb(skb);
-	sta->rx_stats.dropped++;
+	stats->dropped++;
 	return true;
 }
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 877e983..70d6cda 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -254,6 +254,7 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 #ifdef CONFIG_MAC80211_MESH
 	kfree(sta->mesh);
 #endif
+	free_percpu(sta->pcpu_rx_stats);
 	kfree(sta);
 }
 
@@ -311,6 +312,13 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return NULL;
 
+	if (ieee80211_hw_check(hw, USES_RSS)) {
+		sta->pcpu_rx_stats =
+			alloc_percpu(struct ieee80211_sta_rx_stats);
+		if (!sta->pcpu_rx_stats)
+			goto free;
+	}
+
 	spin_lock_init(&sta->lock);
 	spin_lock_init(&sta->ps_lock);
 	INIT_WORK(&sta->drv_deliver_wk, sta_deliver_ps_frames);
@@ -1932,6 +1940,28 @@ u8 sta_info_tx_streams(struct sta_info *sta)
 			>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT) + 1;
 }
 
+static struct ieee80211_sta_rx_stats *
+sta_get_last_rx_stats(struct sta_info *sta)
+{
+	struct ieee80211_sta_rx_stats *stats = &sta->rx_stats;
+	struct ieee80211_local *local = sta->local;
+	int cpu;
+
+	if (!ieee80211_hw_check(&local->hw, USES_RSS))
+		return stats;
+
+	for_each_possible_cpu(cpu) {
+		struct ieee80211_sta_rx_stats *cpustats;
+
+		cpustats = per_cpu_ptr(sta->pcpu_rx_stats, cpu);
+
+		if (time_after(cpustats->last_rx, stats->last_rx))
+			stats = cpustats;
+	}
+
+	return stats;
+}
+
 static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
 				  struct rate_info *rinfo)
 {
@@ -1967,7 +1997,7 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
 
 static void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 {
-	u16 rate = ACCESS_ONCE(sta->rx_stats.last_rate);
+	u16 rate = ACCESS_ONCE(sta_get_last_rx_stats(sta)->last_rate);
 
 	if (rate == STA_STATS_RATE_INVALID)
 		rinfo->flags = 0;
@@ -2010,13 +2040,29 @@ static void sta_set_tidstats(struct sta_info *sta,
 	}
 }
 
+static inline u64 sta_get_stats_bytes(struct ieee80211_sta_rx_stats *rxstats)
+{
+	unsigned int start;
+	u64 value;
+
+	do {
+		start = u64_stats_fetch_begin(&rxstats->syncp);
+		value = rxstats->bytes;
+	} while (u64_stats_fetch_retry(&rxstats->syncp, start));
+
+	return value;
+}
+
 void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	struct rate_control_ref *ref = NULL;
 	u32 thr = 0;
-	int i, ac;
+	int i, ac, cpu;
+	struct ieee80211_sta_rx_stats *last_rxstats;
+
+	last_rxstats = sta_get_last_rx_stats(sta);
 
 	if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
 		ref = local->rate_ctrl;
@@ -2064,17 +2110,30 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_RX_BYTES64) |
 			       BIT(NL80211_STA_INFO_RX_BYTES)))) {
-		unsigned int start;
+		sinfo->rx_bytes += sta_get_stats_bytes(&sta->rx_stats);
+
+		if (sta->pcpu_rx_stats) {
+			for_each_possible_cpu(cpu) {
+				struct ieee80211_sta_rx_stats *cpurxs;
+
+				cpurxs = per_cpu_ptr(sta->pcpu_rx_stats, cpu);
+				sinfo->rx_bytes += sta_get_stats_bytes(cpurxs);
+			}
+		}
 
-		do {
-			start = u64_stats_fetch_begin(&sta->rx_stats.syncp);
-			sinfo->rx_bytes = sta->rx_stats.bytes;
-		} while (u64_stats_fetch_retry(&sta->rx_stats.syncp, start));
 		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES64);
 	}
 
 	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_PACKETS))) {
 		sinfo->rx_packets = sta->rx_stats.packets;
+		if (sta->pcpu_rx_stats) {
+			for_each_possible_cpu(cpu) {
+				struct ieee80211_sta_rx_stats *cpurxs;
+
+				cpurxs = per_cpu_ptr(sta->pcpu_rx_stats, cpu);
+				sinfo->rx_packets += cpurxs->packets;
+			}
+		}
 		sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS);
 	}
 
@@ -2089,6 +2148,14 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	}
 
 	sinfo->rx_dropped_misc = sta->rx_stats.dropped;
+	if (sta->pcpu_rx_stats) {
+		for_each_possible_cpu(cpu) {
+			struct ieee80211_sta_rx_stats *cpurxs;
+
+			cpurxs = per_cpu_ptr(sta->pcpu_rx_stats, cpu);
+			sinfo->rx_packets += cpurxs->dropped;
+		}
+	}
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    !(sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)) {
@@ -2100,27 +2167,34 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	if (ieee80211_hw_check(&sta->local->hw, SIGNAL_DBM) ||
 	    ieee80211_hw_check(&sta->local->hw, SIGNAL_UNSPEC)) {
 		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL))) {
-			sinfo->signal = (s8)sta->rx_stats.last_signal;
+			sinfo->signal = (s8)last_rxstats->last_signal;
 			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 		}
 
-		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL_AVG))) {
+		if (!sta->pcpu_rx_stats &&
+		    !(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL_AVG))) {
 			sinfo->signal_avg =
 				-ewma_signal_read(&sta->rx_stats_avg.signal);
 			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL_AVG);
 		}
 	}
 
-	if (sta->rx_stats.chains &&
+	/* for the average - if pcpu_rx_stats isn't set - rxstats must point to
+	 * the sta->rx_stats struct, so the check here is fine with and without
+	 * pcpu statistics
+	 */
+	if (last_rxstats->chains &&
 	    !(sinfo->filled & (BIT(NL80211_STA_INFO_CHAIN_SIGNAL) |
 			       BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG)))) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL) |
-				 BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG);
+		sinfo->filled |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL);
+		if (!sta->pcpu_rx_stats)
+			sinfo->filled |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG);
+
+		sinfo->chains = last_rxstats->chains;
 
-		sinfo->chains = sta->rx_stats.chains;
 		for (i = 0; i < ARRAY_SIZE(sinfo->chain_signal); i++) {
 			sinfo->chain_signal[i] =
-				sta->rx_stats.chain_signal_last[i];
+				last_rxstats->chain_signal_last[i];
 			sinfo->chain_signal_avg[i] =
 				-ewma_signal_read(&sta->rx_stats_avg.chain_signal[i]);
 		}
@@ -2213,7 +2287,9 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 unsigned long ieee80211_sta_last_active(struct sta_info *sta)
 {
-	if (time_after(sta->rx_stats.last_rx, sta->status_stats.last_ack))
-		return sta->rx_stats.last_rx;
+	struct ieee80211_sta_rx_stats *stats = sta_get_last_rx_stats(sta);
+
+	if (time_after(stats->last_rx, sta->status_stats.last_ack))
+		return stats->last_rx;
 	return sta->status_stats.last_ack;
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 6ee37e3..266bd4a 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -297,6 +297,7 @@ struct ieee80211_fast_tx {
  * @key: bool indicating encryption is expected (key is set)
  * @sta_notify: notify the MLME code (once)
  * @internal_forward: forward froms internally on AP/VLAN type interfaces
+ * @uses_rss: copy of USES_RSS hw flag
  * @da_offs: offset of the DA in the header (for header conversion)
  * @sa_offs: offset of the SA in the header (for header conversion)
  * @rcu_head: RCU head for freeing this structure
@@ -311,7 +312,8 @@ struct ieee80211_fast_rx {
 	u8 icv_len;
 	u8 key:1,
 	   sta_notify:1,
-	   internal_forward:1;
+	   internal_forward:1,
+	   uses_rss:1;
 	u8 da_offs, sa_offs;
 
 	struct rcu_head rcu_head;
@@ -367,6 +369,21 @@ struct mesh_sta {
 
 DECLARE_EWMA(signal, 1024, 8)
 
+struct ieee80211_sta_rx_stats {
+	unsigned long packets;
+	unsigned long last_rx;
+	unsigned long num_duplicates;
+	unsigned long fragments;
+	unsigned long dropped;
+	int last_signal;
+	u8 chains;
+	s8 chain_signal_last[IEEE80211_MAX_CHAINS];
+	u16 last_rate;
+	struct u64_stats_sync syncp;
+	u64 bytes;
+	u64 msdu[IEEE80211_NUM_TIDS + 1];
+};
+
 /**
  * struct sta_info - STA information
  *
@@ -448,6 +465,7 @@ struct sta_info {
 
 	struct ieee80211_fast_tx __rcu *fast_tx;
 	struct ieee80211_fast_rx __rcu *fast_rx;
+	struct ieee80211_sta_rx_stats __percpu *pcpu_rx_stats;
 
 #ifdef CONFIG_MAC80211_MESH
 	struct mesh_sta *mesh;
@@ -477,21 +495,7 @@ struct sta_info {
 	long last_connected;
 
 	/* Updated from RX path only, no locking requirements */
-	struct {
-		unsigned long packets;
-		unsigned long last_rx;
-		unsigned long num_duplicates;
-		unsigned long fragments;
-		unsigned long dropped;
-		int last_signal;
-		u8 chains;
-		s8 chain_signal_last[IEEE80211_MAX_CHAINS];
-		u16 last_rate;
-
-		struct u64_stats_sync syncp;
-		u64 bytes;
-		u64 msdu[IEEE80211_NUM_TIDS + 1];
-	} rx_stats;
+	struct ieee80211_sta_rx_stats rx_stats;
 	struct {
 		struct ewma_signal signal;
 		struct ewma_signal chain_signal[IEEE80211_MAX_CHAINS];
-- 
2.5.0

