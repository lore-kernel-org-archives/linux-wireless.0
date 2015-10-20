Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44832 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbbJTIPF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:15:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: move station statistics into sub-structs
Date: Tue, 20 Oct 2015 10:14:58 +0200
Message-Id: <1445328898-26849-3-git-send-email-johannes@sipsolutions.net> (sfid-20151020_101605_896620_31B855D1)
In-Reply-To: <1445328898-26849-1-git-send-email-johannes@sipsolutions.net>
References: <1445328898-26849-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Group station statistics by where they're (mostly) updated
(TX, RX and TX-status) and group them into sub-structs of
the struct sta_info.

Also rename the variables since the grouping now makes it
obvious where they belong.

This makes it easier to identify where the statistics are
updated in the code, and thus easier to think about them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c |  6 +--
 net/mac80211/ethtool.c     | 26 ++++++------
 net/mac80211/ibss.c        | 13 +++---
 net/mac80211/mesh_hwmp.c   |  2 +-
 net/mac80211/mesh_plink.c  |  6 ++-
 net/mac80211/ocb.c         |  2 +-
 net/mac80211/rx.c          | 63 +++++++++++++++--------------
 net/mac80211/sta_info.c    | 77 +++++++++++++++++++-----------------
 net/mac80211/sta_info.h    | 98 +++++++++++++++++-----------------------------
 net/mac80211/status.c      | 50 ++++++++++++-----------
 net/mac80211/tx.c          | 20 +++++-----
 11 files changed, 178 insertions(+), 185 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 1200b6a581d2..a39512f09f9e 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -366,9 +366,9 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(ht_capa);
 	DEBUGFS_ADD(vht_capa);
 
-	DEBUGFS_ADD_COUNTER(rx_duplicates, num_duplicates);
-	DEBUGFS_ADD_COUNTER(rx_fragments, rx_fragments);
-	DEBUGFS_ADD_COUNTER(tx_filtered, tx_filtered_count);
+	DEBUGFS_ADD_COUNTER(rx_duplicates, rx_stats.num_duplicates);
+	DEBUGFS_ADD_COUNTER(rx_fragments, rx_stats.fragments);
+	DEBUGFS_ADD_COUNTER(tx_filtered, status_stats.filtered);
 
 	if (sizeof(sta->driver_buffered_tids) == sizeof(u32))
 		debugfs_create_x32("driver_buffered_tids", 0400,
diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index 3fbf9c308ec5..9cc986deda61 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -77,19 +77,19 @@ static void ieee80211_get_stats(struct net_device *dev,
 
 	memset(data, 0, sizeof(u64) * STA_STATS_LEN);
 
-#define ADD_STA_STATS(sta)				\
-	do {						\
-		data[i++] += sta->rx_packets;		\
-		data[i++] += sta->rx_bytes;		\
-		data[i++] += sta->num_duplicates;	\
-		data[i++] += sta->rx_fragments;		\
-		data[i++] += sta->rx_dropped;		\
-							\
-		data[i++] += sinfo.tx_packets;		\
-		data[i++] += sinfo.tx_bytes;		\
-		data[i++] += sta->tx_filtered_count;	\
-		data[i++] += sta->tx_retry_failed;	\
-		data[i++] += sta->tx_retry_count;	\
+#define ADD_STA_STATS(sta)					\
+	do {							\
+		data[i++] += sta->rx_stats.packets;		\
+		data[i++] += sta->rx_stats.bytes;		\
+		data[i++] += sta->rx_stats.num_duplicates;	\
+		data[i++] += sta->rx_stats.fragments;		\
+		data[i++] += sta->rx_stats.dropped;		\
+								\
+		data[i++] += sinfo.tx_packets;			\
+		data[i++] += sinfo.tx_bytes;			\
+		data[i++] += sta->status_stats.filtered;	\
+		data[i++] += sta->status_stats.retry_failed;	\
+		data[i++] += sta->status_stats.retry_count;	\
 	} while (0)
 
 	/* For Managed stations, find the single station based on BSSID
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index bd853e7bde93..2001555d49cb 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -647,7 +647,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata, const u8 *bssid,
 		return NULL;
 	}
 
-	sta->last_rx = jiffies;
+	sta->rx_stats.last_rx = jiffies;
 
 	/* make sure mandatory rates are always added */
 	sband = local->hw.wiphy->bands[band];
@@ -669,7 +669,8 @@ static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
 
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		if (sta->sdata == sdata &&
-		    time_after(sta->last_rx + IEEE80211_IBSS_MERGE_INTERVAL,
+		    time_after(sta->rx_stats.last_rx +
+			       IEEE80211_IBSS_MERGE_INTERVAL,
 			       jiffies)) {
 			active++;
 			break;
@@ -1235,7 +1236,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return;
 
-	sta->last_rx = jiffies;
+	sta->rx_stats.last_rx = jiffies;
 
 	/* make sure mandatory rates are always added */
 	sband = local->hw.wiphy->bands[band];
@@ -1253,7 +1254,7 @@ static void ieee80211_ibss_sta_expire(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta, *tmp;
 	unsigned long exp_time = IEEE80211_IBSS_INACTIVITY_LIMIT;
-	unsigned long exp_rsn_time = IEEE80211_IBSS_RSN_INACTIVITY_LIMIT;
+	unsigned long exp_rsn = IEEE80211_IBSS_RSN_INACTIVITY_LIMIT;
 
 	mutex_lock(&local->sta_mtx);
 
@@ -1261,8 +1262,8 @@ static void ieee80211_ibss_sta_expire(struct ieee80211_sub_if_data *sdata)
 		if (sdata != sta->sdata)
 			continue;
 
-		if (time_after(jiffies, sta->last_rx + exp_time) ||
-		    (time_after(jiffies, sta->last_rx + exp_rsn_time) &&
+		if (time_after(jiffies, sta->rx_stats.last_rx + exp_time) ||
+		    (time_after(jiffies, sta->rx_stats.last_rx + exp_rsn) &&
 		     sta->sta_state != IEEE80211_STA_AUTHORIZED)) {
 			sta_dbg(sta->sdata, "expiring inactive %sSTA %pM\n",
 				sta->sta_state != IEEE80211_STA_AUTHORIZED ?
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index d80e0a4c16cf..c6be0b4f4058 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -329,7 +329,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	if (sta->mesh->fail_avg >= 100)
 		return MAX_METRIC;
 
-	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &rinfo);
+	sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
 	rate = cfg80211_calculate_bitrate(&rinfo);
 	if (WARN_ON(!rate))
 		return MAX_METRIC;
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index a360b24b7df8..a4de66521e09 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -60,7 +60,9 @@ static bool rssi_threshold_check(struct ieee80211_sub_if_data *sdata,
 {
 	s32 rssi_threshold = sdata->u.mesh.mshcfg.rssi_threshold;
 	return rssi_threshold == 0 ||
-	       (sta && (s8) -ewma_signal_read(&sta->avg_signal) > rssi_threshold);
+	       (sta &&
+	        (s8) -ewma_signal_read(&sta->rx_stats.avg_signal) >
+						rssi_threshold);
 }
 
 /**
@@ -390,7 +392,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	rates = ieee80211_sta_get_rates(sdata, elems, band, &basic_rates);
 
 	spin_lock_bh(&sta->mesh->plink_lock);
-	sta->last_rx = jiffies;
+	sta->rx_stats.last_rx = jiffies;
 
 	/* rates and capabilities don't change during peering */
 	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB &&
diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
index 573b81a1fb2d..0be0aadfc559 100644
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -75,7 +75,7 @@ void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return;
 
-	sta->last_rx = jiffies;
+	sta->rx_stats.last_rx = jiffies;
 
 	/* Add only mandatory rates for now */
 	sband = local->hw.wiphy->bands[band];
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 60692d964380..8bae5de0dc44 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1119,7 +1119,7 @@ ieee80211_rx_h_check_dup(struct ieee80211_rx_data *rx)
 	if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
 		     rx->sta->last_seq_ctrl[rx->seqno_idx] == hdr->seq_ctrl)) {
 		I802_DEBUG_INC(rx->local->dot11FrameDuplicateCount);
-		rx->sta->num_duplicates++;
+		rx->sta->rx_stats.num_duplicates++;
 		return RX_DROP_UNUSABLE;
 	} else if (!(status->flag & RX_FLAG_AMSDU_MORE)) {
 		rx->sta->last_seq_ctrl[rx->seqno_idx] = hdr->seq_ctrl;
@@ -1396,51 +1396,56 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 						NL80211_IFTYPE_ADHOC);
 		if (ether_addr_equal(bssid, rx->sdata->u.ibss.bssid) &&
 		    test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {
-			sta->last_rx = jiffies;
+			sta->rx_stats.last_rx = jiffies;
 			if (ieee80211_is_data(hdr->frame_control) &&
 			    !is_multicast_ether_addr(hdr->addr1)) {
-				sta->last_rx_rate_idx = status->rate_idx;
-				sta->last_rx_rate_flag = status->flag;
-				sta->last_rx_rate_vht_flag = status->vht_flag;
-				sta->last_rx_rate_vht_nss = status->vht_nss;
+				sta->rx_stats.last_rate_idx =
+					status->rate_idx;
+				sta->rx_stats.last_rate_flag =
+					status->flag;
+				sta->rx_stats.last_rate_vht_flag =
+					status->vht_flag;
+				sta->rx_stats.last_rate_vht_nss =
+					status->vht_nss;
 			}
 		}
 	} else if (rx->sdata->vif.type == NL80211_IFTYPE_OCB) {
-		sta->last_rx = jiffies;
+		sta->rx_stats.last_rx = jiffies;
 	} else if (!is_multicast_ether_addr(hdr->addr1)) {
 		/*
 		 * Mesh beacons will update last_rx when if they are found to
 		 * match the current local configuration when processed.
 		 */
-		sta->last_rx = jiffies;
+		sta->rx_stats.last_rx = jiffies;
 		if (ieee80211_is_data(hdr->frame_control)) {
-			sta->last_rx_rate_idx = status->rate_idx;
-			sta->last_rx_rate_flag = status->flag;
-			sta->last_rx_rate_vht_flag = status->vht_flag;
-			sta->last_rx_rate_vht_nss = status->vht_nss;
+			sta->rx_stats.last_rate_idx = status->rate_idx;
+			sta->rx_stats.last_rate_flag = status->flag;
+			sta->rx_stats.last_rate_vht_flag = status->vht_flag;
+			sta->rx_stats.last_rate_vht_nss = status->vht_nss;
 		}
 	}
 
 	if (rx->sdata->vif.type == NL80211_IFTYPE_STATION)
 		ieee80211_sta_rx_notify(rx->sdata, hdr);
 
-	sta->rx_fragments++;
-	sta->rx_bytes += rx->skb->len;
+	sta->rx_stats.fragments++;
+	sta->rx_stats.bytes += rx->skb->len;
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
-		sta->last_signal = status->signal;
-		ewma_signal_add(&sta->avg_signal, -status->signal);
+		sta->rx_stats.last_signal = status->signal;
+		ewma_signal_add(&sta->rx_stats.avg_signal, -status->signal);
 	}
 
 	if (status->chains) {
-		sta->chains = status->chains;
+		sta->rx_stats.chains = status->chains;
 		for (i = 0; i < ARRAY_SIZE(status->chain_signal); i++) {
 			int signal = status->chain_signal[i];
 
 			if (!(status->chains & BIT(i)))
 				continue;
 
-			sta->chain_signal_last[i] = signal;
-			ewma_signal_add(&sta->chain_signal_avg[i], -signal);
+			sta->rx_stats.chain_signal_last[i] = signal;
+			ewma_signal_add(&sta->rx_stats.chain_signal_avg[i],
+					-signal);
 		}
 	}
 
@@ -1500,7 +1505,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		 * Update counter and free packet here to avoid
 		 * counting this as a dropped packed.
 		 */
-		sta->rx_packets++;
+		sta->rx_stats.packets++;
 		dev_kfree_skb(rx->skb);
 		return RX_QUEUED;
 	}
@@ -1922,7 +1927,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	ieee80211_led_rx(rx->local);
  out_no_led:
 	if (rx->sta)
-		rx->sta->rx_packets++;
+		rx->sta->rx_stats.packets++;
 	return RX_CONTINUE;
 }
 
@@ -2376,7 +2381,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 		 * for non-QoS-data frames. Here we know it's a data
 		 * frame, so count MSDUs.
 		 */
-		rx->sta->rx_msdu[rx->seqno_idx]++;
+		rx->sta->rx_stats.msdu[rx->seqno_idx]++;
 	}
 
 	/*
@@ -2413,7 +2418,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 			skb_queue_tail(&local->skb_queue_tdls_chsw, rx->skb);
 			schedule_work(&local->tdls_chsw_work);
 			if (rx->sta)
-				rx->sta->rx_packets++;
+				rx->sta->rx_stats.packets++;
 
 			return RX_QUEUED;
 		}
@@ -2875,7 +2880,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 
  handled:
 	if (rx->sta)
-		rx->sta->rx_packets++;
+		rx->sta->rx_stats.packets++;
 	dev_kfree_skb(rx->skb);
 	return RX_QUEUED;
 
@@ -2884,7 +2889,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	skb_queue_tail(&sdata->skb_queue, rx->skb);
 	ieee80211_queue_work(&local->hw, &sdata->work);
 	if (rx->sta)
-		rx->sta->rx_packets++;
+		rx->sta->rx_stats.packets++;
 	return RX_QUEUED;
 }
 
@@ -2911,7 +2916,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 	if (cfg80211_rx_mgmt(&rx->sdata->wdev, status->freq, sig,
 			     rx->skb->data, rx->skb->len, 0)) {
 		if (rx->sta)
-			rx->sta->rx_packets++;
+			rx->sta->rx_stats.packets++;
 		dev_kfree_skb(rx->skb);
 		return RX_QUEUED;
 	}
@@ -3030,7 +3035,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 	skb_queue_tail(&sdata->skb_queue, rx->skb);
 	ieee80211_queue_work(&rx->local->hw, &sdata->work);
 	if (rx->sta)
-		rx->sta->rx_packets++;
+		rx->sta->rx_stats.packets++;
 
 	return RX_QUEUED;
 }
@@ -3112,7 +3117,7 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 	case RX_DROP_MONITOR:
 		I802_DEBUG_INC(rx->sdata->local->rx_handlers_drop);
 		if (rx->sta)
-			rx->sta->rx_dropped++;
+			rx->sta->rx_stats.dropped++;
 		/* fall through */
 	case RX_CONTINUE: {
 		struct ieee80211_rate *rate = NULL;
@@ -3132,7 +3137,7 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 	case RX_DROP_UNUSABLE:
 		I802_DEBUG_INC(rx->sdata->local->rx_handlers_drop);
 		if (rx->sta)
-			rx->sta->rx_dropped++;
+			rx->sta->rx_stats.dropped++;
 		dev_kfree_skb(rx->skb);
 		break;
 	case RX_QUEUED:
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0b8dd1cca6d8..f91d1873218c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -331,7 +331,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;
 	sta->sdata = sdata;
-	sta->last_rx = jiffies;
+	sta->rx_stats.last_rx = jiffies;
 
 	sta->sta_state = IEEE80211_STA_NONE;
 
@@ -339,9 +339,9 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->reserved_tid = IEEE80211_TID_UNRESERVED;
 
 	sta->last_connected = ktime_get_seconds();
-	ewma_signal_init(&sta->avg_signal);
-	for (i = 0; i < ARRAY_SIZE(sta->chain_signal_avg); i++)
-		ewma_signal_init(&sta->chain_signal_avg[i]);
+	ewma_signal_init(&sta->rx_stats.avg_signal);
+	for (i = 0; i < ARRAY_SIZE(sta->rx_stats.chain_signal_avg); i++)
+		ewma_signal_init(&sta->rx_stats.chain_signal_avg[i]);
 
 	if (local->ops->wake_tx_queue) {
 		void *txq_data;
@@ -1066,7 +1066,7 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 		if (sdata != sta->sdata)
 			continue;
 
-		if (time_after(jiffies, sta->last_rx + exp_time)) {
+		if (time_after(jiffies, sta->rx_stats.last_rx + exp_time)) {
 			sta_dbg(sta->sdata, "expiring inactive STA %pM\n",
 				sta->sta.addr);
 
@@ -1810,13 +1810,13 @@ static void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 {
 	rinfo->flags = 0;
 
-	if (sta->last_rx_rate_flag & RX_FLAG_HT) {
+	if (sta->rx_stats.last_rate_flag & RX_FLAG_HT) {
 		rinfo->flags |= RATE_INFO_FLAGS_MCS;
-		rinfo->mcs = sta->last_rx_rate_idx;
-	} else if (sta->last_rx_rate_flag & RX_FLAG_VHT) {
+		rinfo->mcs = sta->rx_stats.last_rate_idx;
+	} else if (sta->rx_stats.last_rate_flag & RX_FLAG_VHT) {
 		rinfo->flags |= RATE_INFO_FLAGS_VHT_MCS;
-		rinfo->nss = sta->last_rx_rate_vht_nss;
-		rinfo->mcs = sta->last_rx_rate_idx;
+		rinfo->nss = sta->rx_stats.last_rate_vht_nss;
+		rinfo->mcs = sta->rx_stats.last_rate_idx;
 	} else {
 		struct ieee80211_supported_band *sband;
 		int shift = ieee80211_vif_get_shift(&sta->sdata->vif);
@@ -1824,22 +1824,22 @@ static void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 
 		sband = sta->local->hw.wiphy->bands[
 				ieee80211_get_sdata_band(sta->sdata)];
-		brate = sband->bitrates[sta->last_rx_rate_idx].bitrate;
+		brate = sband->bitrates[sta->rx_stats.last_rate_idx].bitrate;
 		rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
 	}
 
-	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
+	if (sta->rx_stats.last_rate_flag & RX_FLAG_SHORT_GI)
 		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
 
-	if (sta->last_rx_rate_flag & RX_FLAG_5MHZ)
+	if (sta->rx_stats.last_rate_flag & RX_FLAG_5MHZ)
 		rinfo->bw = RATE_INFO_BW_5;
-	else if (sta->last_rx_rate_flag & RX_FLAG_10MHZ)
+	else if (sta->rx_stats.last_rate_flag & RX_FLAG_10MHZ)
 		rinfo->bw = RATE_INFO_BW_10;
-	else if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
+	else if (sta->rx_stats.last_rate_flag & RX_FLAG_40MHZ)
 		rinfo->bw = RATE_INFO_BW_40;
-	else if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_80MHZ)
+	else if (sta->rx_stats.last_rate_vht_flag & RX_VHT_FLAG_80MHZ)
 		rinfo->bw = RATE_INFO_BW_80;
-	else if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_160MHZ)
+	else if (sta->rx_stats.last_rate_vht_flag & RX_VHT_FLAG_160MHZ)
 		rinfo->bw = RATE_INFO_BW_160;
 	else
 		rinfo->bw = RATE_INFO_BW_20;
@@ -1879,45 +1879,46 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	}
 
 	sinfo->connected_time = ktime_get_seconds() - sta->last_connected;
-	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
+	sinfo->inactive_time =
+		jiffies_to_msecs(jiffies - sta->rx_stats.last_rx);
 
 	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_TX_BYTES64) |
 			       BIT(NL80211_STA_INFO_TX_BYTES)))) {
 		sinfo->tx_bytes = 0;
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			sinfo->tx_bytes += sta->tx_bytes[ac];
+			sinfo->tx_bytes += sta->tx_stats.bytes[ac];
 		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES64);
 	}
 
 	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_PACKETS))) {
 		sinfo->tx_packets = 0;
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			sinfo->tx_packets += sta->tx_packets[ac];
+			sinfo->tx_packets += sta->tx_stats.packets[ac];
 		sinfo->filled |= BIT(NL80211_STA_INFO_TX_PACKETS);
 	}
 
 	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_RX_BYTES64) |
 			       BIT(NL80211_STA_INFO_RX_BYTES)))) {
-		sinfo->rx_bytes = sta->rx_bytes;
+		sinfo->rx_bytes = sta->rx_stats.bytes;
 		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES64);
 	}
 
 	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_PACKETS))) {
-		sinfo->rx_packets = sta->rx_packets;
+		sinfo->rx_packets = sta->rx_stats.packets;
 		sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS);
 	}
 
 	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_RETRIES))) {
-		sinfo->tx_retries = sta->tx_retry_count;
+		sinfo->tx_retries = sta->status_stats.retry_count;
 		sinfo->filled |= BIT(NL80211_STA_INFO_TX_RETRIES);
 	}
 
 	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_FAILED))) {
-		sinfo->tx_failed = sta->tx_retry_failed;
+		sinfo->tx_failed = sta->status_stats.retry_failed;
 		sinfo->filled |= BIT(NL80211_STA_INFO_TX_FAILED);
 	}
 
-	sinfo->rx_dropped_misc = sta->rx_dropped;
+	sinfo->rx_dropped_misc = sta->rx_stats.dropped;
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    !(sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)) {
@@ -1929,33 +1930,35 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	if (ieee80211_hw_check(&sta->local->hw, SIGNAL_DBM) ||
 	    ieee80211_hw_check(&sta->local->hw, SIGNAL_UNSPEC)) {
 		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL))) {
-			sinfo->signal = (s8)sta->last_signal;
+			sinfo->signal = (s8)sta->rx_stats.last_signal;
 			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
 		}
 
 		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL_AVG))) {
 			sinfo->signal_avg =
-				(s8) -ewma_signal_read(&sta->avg_signal);
+				-ewma_signal_read(&sta->rx_stats.avg_signal);
 			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL_AVG);
 		}
 	}
 
-	if (sta->chains &&
+	if (sta->rx_stats.chains &&
 	    !(sinfo->filled & (BIT(NL80211_STA_INFO_CHAIN_SIGNAL) |
 			       BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG)))) {
 		sinfo->filled |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL) |
 				 BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG);
 
-		sinfo->chains = sta->chains;
+		sinfo->chains = sta->rx_stats.chains;
 		for (i = 0; i < ARRAY_SIZE(sinfo->chain_signal); i++) {
-			sinfo->chain_signal[i] = sta->chain_signal_last[i];
+			sinfo->chain_signal[i] =
+				sta->rx_stats.chain_signal_last[i];
 			sinfo->chain_signal_avg[i] =
-				(s8) -ewma_signal_read(&sta->chain_signal_avg[i]);
+				-ewma_signal_read(&sta->rx_stats.chain_signal_avg[i]);
 		}
 	}
 
 	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_BITRATE))) {
-		sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);
+		sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate,
+				     &sinfo->txrate);
 		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
 	}
 
@@ -1970,12 +1973,12 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 		if (!(tidstats->filled & BIT(NL80211_TID_STATS_RX_MSDU))) {
 			tidstats->filled |= BIT(NL80211_TID_STATS_RX_MSDU);
-			tidstats->rx_msdu = sta->rx_msdu[i];
+			tidstats->rx_msdu = sta->rx_stats.msdu[i];
 		}
 
 		if (!(tidstats->filled & BIT(NL80211_TID_STATS_TX_MSDU))) {
 			tidstats->filled |= BIT(NL80211_TID_STATS_TX_MSDU);
-			tidstats->tx_msdu = sta->tx_msdu[i];
+			tidstats->tx_msdu = sta->tx_stats.msdu[i];
 		}
 
 		if (!(tidstats->filled &
@@ -1983,7 +1986,8 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 			tidstats->filled |=
 				BIT(NL80211_TID_STATS_TX_MSDU_RETRIES);
-			tidstats->tx_msdu_retries = sta->tx_msdu_retries[i];
+			tidstats->tx_msdu_retries =
+				sta->status_stats.msdu_retries[i];
 		}
 
 		if (!(tidstats->filled &
@@ -1991,7 +1995,8 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 			tidstats->filled |=
 				BIT(NL80211_TID_STATS_TX_MSDU_FAILED);
-			tidstats->tx_msdu_failed = sta->tx_msdu_failed[i];
+			tidstats->tx_msdu_failed =
+				sta->status_stats.msdu_failed[i];
 		}
 	}
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 3a401d40c329..2cafb21b422f 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -344,12 +344,6 @@ DECLARE_EWMA(signal, 1024, 8)
  * @rate_ctrl_lock: spinlock used to protect rate control data
  *	(data inside the algorithm, so serializes calls there)
  * @rate_ctrl_priv: rate control private per-STA pointer
- * @last_tx_rate: rate used for last transmit, to report to userspace as
- *	"the" transmit rate
- * @last_rx_rate_idx: rx status rate index of the last data packet
- * @last_rx_rate_flag: rx status flag of the last data packet
- * @last_rx_rate_vht_flag: rx status vht flag of the last data packet
- * @last_rx_rate_vht_nss: rx status nss of last data packet
  * @lock: used for locking all fields that require locking, see comments
  *	in the header file.
  * @drv_deliver_wk: used for delivering frames after driver PS unblocking
@@ -364,22 +358,9 @@ DECLARE_EWMA(signal, 1024, 8)
  *	the station when it leaves powersave or polls for frames
  * @driver_buffered_tids: bitmap of TIDs the driver has data buffered on
  * @txq_buffered_tids: bitmap of TIDs that mac80211 has txq data buffered on
- * @rx_packets: Number of MSDUs received from this STA
- * @rx_bytes: Number of bytes received from this STA
- * @last_rx: time (in jiffies) when last frame was received from this STA
  * @last_connected: time (in seconds) when a station got connected
- * @num_duplicates: number of duplicate frames received from this STA
- * @rx_fragments: number of received MPDUs
- * @rx_dropped: number of dropped MPDUs from this STA
- * @last_signal: signal of last received frame from this STA
- * @avg_signal: moving average of signal of received frames from this STA
  * @last_seq_ctrl: last received seq/frag number from this STA (per TID
  *	plus one for non-QoS frames)
- * @tx_filtered_count: number of frames the hardware filtered for this STA
- * @tx_retry_failed: number of frames that failed retry
- * @tx_retry_count: total number of retries for frames to this STA
- * @tx_packets: number of RX/TX MSDUs
- * @tx_bytes: number of bytes transmitted to this STA
  * @tid_seq: per-TID sequence numbers for sending to this STA
  * @ampdu_mlme: A-MPDU state machine state
  * @timer_to_tid: identity mapping to ID timers
@@ -387,32 +368,22 @@ DECLARE_EWMA(signal, 1024, 8)
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
- * @lost_packets: number of consecutive lost packets
  * @sta: station information we share with the driver
  * @sta_state: duplicates information about station state (for debug)
  * @beacon_loss_count: number of times beacon loss has triggered
  * @rcu_head: RCU head used for freeing this station struct
  * @cur_max_bandwidth: maximum bandwidth to use for TX to the station,
  *	taken from HT/VHT capabilities or VHT operating mode notification
- * @chains: chains ever used for RX from this station
- * @chain_signal_last: last signal (per chain)
- * @chain_signal_avg: signal average (per chain)
  * @known_smps_mode: the smps_mode the client thinks we are in. Relevant for
  *	AP only.
  * @cipher_scheme: optional cipher scheme for this station
- * @last_tdls_pkt_time: holds the time in jiffies of last TDLS pkt ACKed
  * @reserved_tid: reserved TID (if any, otherwise IEEE80211_TID_UNRESERVED)
- * @tx_msdu: MSDUs transmitted to this station, using IEEE80211_NUM_TID
- *	entry for non-QoS frames
- * @tx_msdu_retries: MSDU retries for transmissions to to this station,
- *	using IEEE80211_NUM_TID entry for non-QoS frames
- * @tx_msdu_failed: MSDU failures for transmissions to to this station,
- *	using IEEE80211_NUM_TID entry for non-QoS frames
- * @rx_msdu: MSDUs received from this station, using IEEE80211_NUM_TID
- *	entry for non-QoS frames
  * @fast_tx: TX fastpath information
  * @tdls_chandef: a TDLS peer can have a wider chandef that is compatible to
  *	the BSS one.
+ * @tx_stats: TX statistics
+ * @rx_stats: RX statistics
+ * @status_stats: TX status statistics
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -456,41 +427,49 @@ struct sta_info {
 	unsigned long driver_buffered_tids;
 	unsigned long txq_buffered_tids;
 
-	/* Updated from RX path only, no locking requirements */
-	unsigned long rx_packets;
-	u64 rx_bytes;
-	unsigned long last_rx;
 	long last_connected;
-	unsigned long num_duplicates;
-	unsigned long rx_fragments;
-	unsigned long rx_dropped;
-	int last_signal;
-	struct ewma_signal avg_signal;
 
-	u8 chains;
-	s8 chain_signal_last[IEEE80211_MAX_CHAINS];
-	struct ewma_signal chain_signal_avg[IEEE80211_MAX_CHAINS];
+	/* Updated from RX path only, no locking requirements */
+	struct {
+		unsigned long packets;
+		u64 bytes;
+		unsigned long last_rx;
+		unsigned long num_duplicates;
+		unsigned long fragments;
+		unsigned long dropped;
+		int last_signal;
+		struct ewma_signal avg_signal;
+		u8 chains;
+		s8 chain_signal_last[IEEE80211_MAX_CHAINS];
+		struct ewma_signal chain_signal_avg[IEEE80211_MAX_CHAINS];
+		int last_rate_idx;
+		u32 last_rate_flag;
+		u32 last_rate_vht_flag;
+		u8 last_rate_vht_nss;
+		u64 msdu[IEEE80211_NUM_TIDS + 1];
+	} rx_stats;
 
 	/* Plus 1 for non-QoS frames */
 	__le16 last_seq_ctrl[IEEE80211_NUM_TIDS + 1];
 
 	/* Updated from TX status path only, no locking requirements */
-	unsigned long tx_filtered_count;
-	unsigned long tx_retry_failed, tx_retry_count;
+	struct {
+		unsigned long filtered;
+		unsigned long retry_failed, retry_count;
+		unsigned int lost_packets;
+		unsigned long last_tdls_pkt_time;
+		u64 msdu_retries[IEEE80211_NUM_TIDS + 1];
+		u64 msdu_failed[IEEE80211_NUM_TIDS + 1];
+	} status_stats;
 
 	/* Updated from TX path only, no locking requirements */
-	u64 tx_packets[IEEE80211_NUM_ACS];
-	u64 tx_bytes[IEEE80211_NUM_ACS];
-	struct ieee80211_tx_rate last_tx_rate;
-	int last_rx_rate_idx;
-	u32 last_rx_rate_flag;
-	u32 last_rx_rate_vht_flag;
-	u8 last_rx_rate_vht_nss;
+	struct {
+		u64 packets[IEEE80211_NUM_ACS];
+		u64 bytes[IEEE80211_NUM_ACS];
+		struct ieee80211_tx_rate last_rate;
+		u64 msdu[IEEE80211_NUM_TIDS + 1];
+	} tx_stats;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
-	u64 tx_msdu[IEEE80211_NUM_TIDS + 1];
-	u64 tx_msdu_retries[IEEE80211_NUM_TIDS + 1];
-	u64 tx_msdu_failed[IEEE80211_NUM_TIDS + 1];
-	u64 rx_msdu[IEEE80211_NUM_TIDS + 1];
 
 	/*
 	 * Aggregation information, locked with lock.
@@ -507,14 +486,9 @@ struct sta_info {
 
 	enum ieee80211_sta_rx_bandwidth cur_max_bandwidth;
 
-	unsigned int lost_packets;
-
 	enum ieee80211_smps_mode known_smps_mode;
 	const struct ieee80211_cipher_scheme *cipher_scheme;
 
-	/* TDLS timeout data */
-	unsigned long last_tdls_pkt_time;
-
 	u8 reserved_tid;
 
 	struct cfg80211_chan_def tdls_chandef;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index da67b84905a8..7d14bbf8682b 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -67,7 +67,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 		       IEEE80211_TX_INTFL_RETRANSMISSION;
 	info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
 
-	sta->tx_filtered_count++;
+	sta->status_stats.filtered++;
 
 	/*
 	 * Clear more-data bit on filtered frames, it might be set
@@ -182,7 +182,7 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
 	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
-		sta->last_rx = jiffies;
+		sta->rx_stats.last_rx = jiffies;
 
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
 		struct ieee80211_hdr *hdr = (void *) skb->data;
@@ -556,8 +556,9 @@ static void ieee80211_lost_packet(struct sta_info *sta,
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
-	sta->lost_packets++;
-	if (!sta->sta.tdls && sta->lost_packets < STA_LOST_PKT_THRESHOLD)
+	sta->status_stats.lost_packets++;
+	if (!sta->sta.tdls &&
+	    sta->status_stats.lost_packets < STA_LOST_PKT_THRESHOLD)
 		return;
 
 	/*
@@ -567,14 +568,15 @@ static void ieee80211_lost_packet(struct sta_info *sta,
 	 * mechanism.
 	 */
 	if (sta->sta.tdls &&
-	    (sta->lost_packets < STA_LOST_TDLS_PKT_THRESHOLD ||
+	    (sta->status_stats.lost_packets < STA_LOST_TDLS_PKT_THRESHOLD ||
 	     time_before(jiffies,
-			 sta->last_tdls_pkt_time + STA_LOST_TDLS_PKT_TIME)))
+			 sta->status_stats.last_tdls_pkt_time +
+			 STA_LOST_TDLS_PKT_TIME)))
 		return;
 
 	cfg80211_cqm_pktloss_notify(sta->sdata->dev, sta->sta.addr,
-				    sta->lost_packets, GFP_ATOMIC);
-	sta->lost_packets = 0;
+				    sta->status_stats.lost_packets, GFP_ATOMIC);
+	sta->status_stats.lost_packets = 0;
 }
 
 static int ieee80211_tx_get_rates(struct ieee80211_hw *hw,
@@ -635,18 +637,18 @@ void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
 		sta = container_of(pubsta, struct sta_info, sta);
 
 		if (!acked)
-			sta->tx_retry_failed++;
-		sta->tx_retry_count += retry_count;
+			sta->status_stats.retry_failed++;
+		sta->status_stats.retry_count += retry_count;
 
 		if (acked) {
-			sta->last_rx = jiffies;
+			sta->rx_stats.last_rx = jiffies;
 
-			if (sta->lost_packets)
-				sta->lost_packets = 0;
+			if (sta->status_stats.lost_packets)
+				sta->status_stats.lost_packets = 0;
 
 			/* Track when last TDLS packet was ACKed */
 			if (test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
-				sta->last_tdls_pkt_time = jiffies;
+				sta->status_stats.last_tdls_pkt_time = jiffies;
 		} else {
 			ieee80211_lost_packet(sta, info);
 		}
@@ -783,7 +785,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL) &&
 		    (ieee80211_is_data(hdr->frame_control)) &&
 		    (rates_idx != -1))
-			sta->last_tx_rate = info->status.rates[rates_idx];
+			sta->tx_stats.last_rate =
+				info->status.rates[rates_idx];
 
 		if ((info->flags & IEEE80211_TX_STAT_AMPDU_NO_BACK) &&
 		    (ieee80211_is_data_qos(fc))) {
@@ -829,13 +832,15 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			return;
 		} else {
 			if (!acked)
-				sta->tx_retry_failed++;
-			sta->tx_retry_count += retry_count;
+				sta->status_stats.retry_failed++;
+			sta->status_stats.retry_count += retry_count;
 
 			if (ieee80211_is_data_present(fc)) {
 				if (!acked)
-					sta->tx_msdu_failed[tid]++;
-				sta->tx_msdu_retries[tid] += retry_count;
+					sta->status_stats.msdu_failed[tid]++;
+
+				sta->status_stats.msdu_retries[tid] +=
+					retry_count;
 			}
 		}
 
@@ -853,12 +858,13 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 			if (info->flags & IEEE80211_TX_STAT_ACK) {
-				if (sta->lost_packets)
-					sta->lost_packets = 0;
+				if (sta->status_stats.lost_packets)
+					sta->status_stats.lost_packets = 0;
 
 				/* Track when last TDLS packet was ACKed */
 				if (test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
-					sta->last_tdls_pkt_time = jiffies;
+					sta->status_stats.last_tdls_pkt_time =
+						jiffies;
 			} else {
 				ieee80211_lost_packet(sta, info);
 			}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 464ba1a625bd..09e38a860a59 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -757,9 +757,9 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	if (txrc.reported_rate.idx < 0) {
 		txrc.reported_rate = tx->rate;
 		if (tx->sta && ieee80211_is_data(hdr->frame_control))
-			tx->sta->last_tx_rate = txrc.reported_rate;
+			tx->sta->tx_stats.last_rate = txrc.reported_rate;
 	} else if (tx->sta)
-		tx->sta->last_tx_rate = txrc.reported_rate;
+		tx->sta->tx_stats.last_rate = txrc.reported_rate;
 
 	if (ratetbl)
 		return TX_CONTINUE;
@@ -824,7 +824,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 		hdr->seq_ctrl = cpu_to_le16(tx->sdata->sequence_number);
 		tx->sdata->sequence_number += 0x10;
 		if (tx->sta)
-			tx->sta->tx_msdu[IEEE80211_NUM_TIDS]++;
+			tx->sta->tx_stats.msdu[IEEE80211_NUM_TIDS]++;
 		return TX_CONTINUE;
 	}
 
@@ -840,7 +840,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 
 	qc = ieee80211_get_qos_ctl(hdr);
 	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
-	tx->sta->tx_msdu[tid]++;
+	tx->sta->tx_stats.msdu[tid]++;
 
 	if (!tx->sta->sta.txq[0])
 		hdr->seq_ctrl = ieee80211_tx_next_seq(tx->sta, tid);
@@ -994,10 +994,10 @@ ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 
 	skb_queue_walk(&tx->skbs, skb) {
 		ac = skb_get_queue_mapping(skb);
-		tx->sta->tx_bytes[ac] += skb->len;
+		tx->sta->tx_stats.bytes[ac] += skb->len;
 	}
 	if (ac >= 0)
-		tx->sta->tx_packets[ac]++;
+		tx->sta->tx_stats.packets[ac]++;
 
 	return TX_CONTINUE;
 }
@@ -2776,10 +2776,10 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (skb_shinfo(skb)->gso_size)
-		sta->tx_msdu[tid] +=
+		sta->tx_stats.msdu[tid] +=
 			DIV_ROUND_UP(skb->len, skb_shinfo(skb)->gso_size);
 	else
-		sta->tx_msdu[tid]++;
+		sta->tx_stats.msdu[tid]++;
 
 	info->hw_queue = sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
 
@@ -2810,8 +2810,8 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	/* statistics normally done by ieee80211_tx_h_stats (but that
 	 * has to consider fragmentation, so is more complex)
 	 */
-	sta->tx_bytes[skb_get_queue_mapping(skb)] += skb->len;
-	sta->tx_packets[skb_get_queue_mapping(skb)]++;
+	sta->tx_stats.bytes[skb_get_queue_mapping(skb)] += skb->len;
+	sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
 
 	if (fast_tx->pn_offs) {
 		u64 pn;
-- 
2.5.1

