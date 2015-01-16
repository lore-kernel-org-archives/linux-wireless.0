Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40946 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbbAPJsr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 04:48:47 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/2] mac80211: support RX rate statistics
Date: Fri, 16 Jan 2015 10:48:28 +0100
Message-Id: <1421401708-8123-2-git-send-email-johannes@sipsolutions.net> (sfid-20150116_104854_744164_B0F7C679)
In-Reply-To: <1421401708-8123-1-git-send-email-johannes@sipsolutions.net>
References: <1421401708-8123-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support for RX rate statistics to mac80211. This tracks the number
of MSDUs received per rate, if rate statistics are enabled.

As the number of rates is very high (as explained in the commit log of
the cfg80211 patch) mac80211 tracks at most 36 different rates at once.
This is done with a very simple hash table format (3 * index) array to
track three different NSS/SGI/bw combinations, plus a few more entries
acting as "escape" when all three different combinations are filled.

Counters are limited to 16-bit to reduce memory consumption and when a
limit of 64000 is reached the process to send them out to userspace is
scheduled. The same happens when the escape entries need to be used.

The data structure itself is stored for each station, accessible under
RCU, and sending them to userspace is combined with freeing so that no
RCU-accessor (really only the synchronized RX path anyway though) can
still see them when they're transmitted out. This ensures a consistent
view is transmitted right before being discarded; it also ensures that
the RX path isn't blocked by any configuration paths for this.

Note that TX statistics (tx, retries, failures) aren't covered. Those
need tighter integration with the driver or rate scaling as not all
drivers are able to fully encode the necessary information in the TX
status data due to the size limit there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  41 ++++++++++++++
 net/mac80211/ieee80211_i.h |   2 +
 net/mac80211/main.c        |  12 ++++
 net/mac80211/rx.c          |  57 +++++++++++++++++++
 net/mac80211/sta_info.c    | 135 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h    |  59 ++++++++++++++++++++
 6 files changed, 306 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ff090ef1ea2c..23a104ebea93 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3690,6 +3690,46 @@ static int ieee80211_del_tx_ts(struct wiphy *wiphy, struct net_device *dev,
 	return -ENOENT;
 }
 
+static void ieee80211_rate_stats(struct wiphy *wiphy,
+				 enum cfg80211_rate_stats_ops op)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct sta_info *sta;
+	struct ieee80211_sta_rate_stats *stats, *tmp;
+	LIST_HEAD(list);
+
+	mutex_lock(&local->sta_mtx);
+	switch (op) {
+	case CFG80211_RATE_STATS_START:
+		local->rate_stats_active = true;
+		list_for_each_entry(sta, &local->sta_list, list)
+			ieee80211_sta_start_rate_stats(sta);
+		/* list stays empty */
+		break;
+	case CFG80211_RATE_STATS_DUMP:
+		list_for_each_entry(sta, &local->sta_list, list) {
+			stats = ieee80211_sta_reset_rate_stats(sta);
+			if (stats)
+				list_add_tail(&stats->list, &list);
+		}
+		break;
+	case CFG80211_RATE_STATS_STOP:
+		local->rate_stats_active = false;
+		list_for_each_entry(sta, &local->sta_list, list) {
+			stats = ieee80211_sta_stop_rate_stats(sta);
+			if (stats)
+				list_add_tail(&stats->list, &list);
+		}
+		break;
+	}
+	mutex_unlock(&local->sta_mtx);
+
+	if (!list_empty(&list))
+		synchronize_rcu();
+	list_for_each_entry_safe(stats, tmp, &list, list)
+		ieee80211_sta_free_rate_stats(stats, true);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3774,4 +3814,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
 	.add_tx_ts = ieee80211_add_tx_ts,
 	.del_tx_ts = ieee80211_del_tx_ts,
+	.rate_stats = ieee80211_rate_stats,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 156ea79e0157..59f1b2ecad16 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1126,6 +1126,8 @@ struct ieee80211_local {
 
 	bool use_chanctx;
 
+	bool rate_stats_active;
+
 	/* protects the aggregated multicast list and filter calls */
 	spinlock_t filter_lock;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d9ce33663c73..d26fe28e07f2 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -545,6 +545,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			   NL80211_FEATURE_MAC_ON_CREATE |
 			   NL80211_FEATURE_USERSPACE_MPM;
 
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_RATE_STATS);
+
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
 				   NL80211_FEATURE_AP_SCAN;
@@ -859,6 +861,16 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		/* TODO: consider VHT for RX chains, hopefully it's the same */
 	}
 
+	/* if the HW has more than 12 legacy rates, some assumptions in the
+	 * data structures break - in this case don't allow the rate-stats
+	 * feature flag.
+	 */
+	if (WARN_ON(wiphy_ext_feature_isset(hw->wiphy,
+					    NL80211_EXT_FEATURE_RATE_STATS) &&
+		    max_bitrates > 12))
+		hw->wiphy->ext_features[NL80211_EXT_FEATURE_RATE_STATS / 8] &=
+			~BIT(NL80211_EXT_FEATURE_RATE_STATS % 8);
+
 	/* if low-level driver supports AP, we also support VLAN */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3d79d498e7f6..8188ecdeaa8d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2292,6 +2292,56 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 }
 #endif
 
+static void noinline
+ieee80211_rx_handle_rate_stats(struct ieee80211_local *local,
+			       struct ieee80211_rx_status *status,
+			       struct ieee80211_sta_rate_stats *rstats)
+{
+	u16 rate = sta_rate_stats_encode_rate(status);
+	unsigned int start;
+	int i;
+
+	start = status->rate_idx;
+	/* for HT - use only the base index */
+	if (status->flag & RX_FLAG_HT)
+		start &= 0xF;
+	for (i = start; i < start + 3; i++) {
+		if (rstats->entries[i].rate == rate ||
+		    rstats->entries[i].rate == STA_RATE_STATS_RATE_INVALID) {
+			if (rstats->entries[i].rate ==
+					STA_RATE_STATS_RATE_INVALID)
+				rstats->entries[i].rate = rate;
+			if (rstats->entries[i].rx++ > 64000)
+				goto schedule_dump;
+			return;
+		}
+	}
+
+	/* The last six entries are only really used by legacy rates - so
+	 * not that performance sensitive.  For HT and VHT though, only the
+	 * first 24 (3*8) or 30 (3*10) entries can be used, so try the last
+	 * few in the list as "escape" entries. If any such entry is used
+	 * then schedule dumping to userspace unconditionally to avoid going
+	 * into this code path frequently.
+	 */
+	for (i = ARRAY_SIZE(rstats->entries) - 1;
+	     i > ARRAY_SIZE(rstats->entries) - 7; i--) {
+		if (rstats->entries[i].rate == rate ||
+		    rstats->entries[i].rate == STA_RATE_STATS_RATE_INVALID) {
+			if (rstats->entries[i].rate ==
+					STA_RATE_STATS_RATE_INVALID)
+				rstats->entries[i].rate = rate;
+			rstats->entries[i].rx++;
+			break;
+		}
+	}
+
+	/* if we still didn't find anything, drop the stats for this packet */
+
+ schedule_dump:
+	ieee80211_queue_work(&local->hw, &rstats->dump_wk);
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
@@ -2310,12 +2360,19 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 		return RX_DROP_MONITOR;
 
 	if (rx->sta) {
+		struct ieee80211_sta_rate_stats *rstats;
+
 		/* The security index has the same property as needed
 		 * for the rx_msdu field, i.e. it is IEEE80211_NUM_TIDS
 		 * for non-QoS-data frames. Here we know it's a data
 		 * frame, so count MSDUs.
 		 */
 		rx->sta->rx_msdu[rx->security_idx]++;
+
+		rstats = rcu_dereference(rx->sta->rate_stats);
+		if (rstats)
+			ieee80211_rx_handle_rate_stats(local,
+				IEEE80211_SKB_RXCB(rx->skb), rstats);
 	}
 
 	/*
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 79383ef0c264..2ca35425d9ab 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -497,6 +497,9 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	local->sta_generation++;
 	smp_mb();
 
+	if (local->rate_stats_active)
+		ieee80211_sta_start_rate_stats(sta);
+
 	/* simplify things and don't accept BA sessions yet */
 	set_sta_flag(sta, WLAN_STA_BLOCK_BA);
 
@@ -882,6 +885,7 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct station_info sinfo = {};
+	struct ieee80211_sta_rate_stats *stats;
 	int ret;
 
 	/*
@@ -919,6 +923,10 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 
 	sta_dbg(sdata, "Removed STA %pM\n", sta->sta.addr);
 
+	stats = ieee80211_sta_stop_rate_stats(sta);
+	/* station was already unlinked and rcu sync'ed before getting here */
+	ieee80211_sta_free_rate_stats(stats, true);
+
 	sta_set_sinfo(sta, &sinfo);
 	cfg80211_del_sta_sinfo(sdata->dev, sta->sta.addr, &sinfo, GFP_KERNEL);
 
@@ -1950,3 +1958,130 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->expected_throughput = thr;
 	}
 }
+
+static void sta_rate_stats_decode_rate(u16 r, struct ieee80211_local *local,
+				       struct rate_info *rinfo)
+{
+	rinfo->bw = (r & STA_RATE_STATS_RATE_BW_MASK) >>
+		STA_RATE_STATS_RATE_BW_SHIFT;
+
+	if (r & STA_RATE_STATS_RATE_VHT) {
+		rinfo->flags = RATE_INFO_FLAGS_VHT_MCS;
+		rinfo->mcs = r & 0xf;
+		rinfo->nss = (r & 0xf0) >> 4;
+	} else if (r & STA_RATE_STATS_RATE_HT) {
+		rinfo->flags = RATE_INFO_FLAGS_MCS;
+		rinfo->mcs = r & 0xff;
+	} else if (r & STA_RATE_STATS_RATE_LEGACY) {
+		struct ieee80211_supported_band *sband;
+		u16 brate;
+		unsigned int shift;
+
+		sband = local->hw.wiphy->bands[(r >> 4) & 0xf];
+		brate = sband->bitrates[r & 0xf].bitrate;
+		if (rinfo->bw == RATE_INFO_BW_5)
+			shift = 2;
+		else if (rinfo->bw == RATE_INFO_BW_10)
+			shift = 1;
+		else
+			shift = 0;
+		rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
+	}
+
+	if (r & STA_RATE_STATS_RATE_SGI)
+		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
+}
+
+void ieee80211_sta_start_rate_stats(struct sta_info *sta)
+{
+	struct ieee80211_sta_rate_stats *stats;
+
+	stats = ieee80211_sta_reset_rate_stats(sta);
+
+	if (WARN_ON_ONCE(stats)) {
+		/* error case - be really slow but correct */
+		synchronize_rcu();
+		ieee80211_sta_free_rate_stats(stats, true);
+	}
+}
+
+static void ieee80211_sta_dump_rate_stats_wk(struct work_struct *wk)
+{
+	struct ieee80211_sta_rate_stats *stats, *stats2;
+
+	stats = container_of(wk, struct ieee80211_sta_rate_stats, dump_wk);
+
+	mutex_lock(&stats->sta->local->sta_mtx);
+	stats2 = ieee80211_sta_reset_rate_stats(stats->sta);
+	mutex_unlock(&stats->sta->local->sta_mtx);
+
+	WARN_ON_ONCE(stats != stats2);
+
+	synchronize_rcu();
+	ieee80211_sta_free_rate_stats(stats, false);
+}
+
+struct ieee80211_sta_rate_stats * __must_check
+ieee80211_sta_reset_rate_stats(struct sta_info *sta)
+{
+	struct ieee80211_sta_rate_stats *stats, *new;
+
+	stats = rcu_dereference_protected(sta->rate_stats,
+			lockdep_is_held(&sta->local->sta_mtx));
+
+	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	new->sta = sta;
+	INIT_WORK(&new->dump_wk, ieee80211_sta_dump_rate_stats_wk);
+
+	rcu_assign_pointer(sta->rate_stats, new);
+
+	/* caller must wait for grace period and free data */
+	return stats;
+}
+
+struct ieee80211_sta_rate_stats * __must_check
+ieee80211_sta_stop_rate_stats(struct sta_info *sta)
+{
+	struct ieee80211_sta_rate_stats *stats;
+
+	stats = rcu_dereference_protected(sta->rate_stats,
+			lockdep_is_held(&sta->local->sta_mtx));
+
+	RCU_INIT_POINTER(sta->rate_stats, NULL);
+
+	/* caller must wait for grace period and free data */
+	return stats;
+}
+
+void ieee80211_sta_free_rate_stats(struct ieee80211_sta_rate_stats *stats,
+				   bool flush)
+{
+	struct cfg80211_rate_stats report;
+	struct sta_info *sta;
+	int i;
+
+	if (!stats)
+		return;
+
+	if (flush && flush_work(&stats->dump_wk))
+		return;
+
+	sta = stats->sta;
+
+	for (i = 0; i < ARRAY_SIZE(stats->entries); i++) {
+		if (stats->entries[i].rate == STA_RATE_STATS_RATE_INVALID)
+			continue;
+
+		sta_rate_stats_decode_rate(stats->entries[i].rate,
+					   stats->sta->local, &report.rate);
+
+		report.stats.filled = BIT(NL80211_TID_STATS_RX_MSDU);
+		report.stats.rx_msdu = stats->entries[i].rx;
+
+		cfg80211_report_rate_stats(sta->local->hw.wiphy,
+					   &sta->sdata->wdev, sta->sta.addr,
+					   1, &report, GFP_KERNEL);
+	}
+
+	kfree(stats);
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 925e68fe64c7..cd7c7b5111dd 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -354,6 +354,7 @@ struct ieee80211_tx_latency_stat {
  *	using IEEE80211_NUM_TID entry for non-QoS frames
  * @rx_msdu: MSDUs received from this station, using IEEE80211_NUM_TID
  *	entry for non-QoS frames
+ * @rate_stats: rate statistics pointer (if enabled)
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -428,6 +429,7 @@ struct sta_info {
 	u64 tx_msdu_retries[IEEE80211_NUM_TIDS + 1];
 	u64 tx_msdu_failed[IEEE80211_NUM_TIDS + 1];
 	u64 rx_msdu[IEEE80211_NUM_TIDS + 1];
+	struct ieee80211_sta_rate_stats __rcu *rate_stats;
 
 	/*
 	 * Aggregation information, locked with lock.
@@ -670,4 +672,61 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
 
+/* rate statistics */
+void ieee80211_sta_start_rate_stats(struct sta_info *sta);
+struct ieee80211_sta_rate_stats * __must_check
+ieee80211_sta_reset_rate_stats(struct sta_info *sta);
+struct ieee80211_sta_rate_stats * __must_check
+ieee80211_sta_stop_rate_stats(struct sta_info *sta);
+void ieee80211_sta_free_rate_stats(struct ieee80211_sta_rate_stats *stats,
+				   bool flush);
+
+struct ieee80211_sta_rate_stats {
+	struct list_head list;
+	struct sta_info *sta;
+	struct work_struct dump_wk;
+	struct {
+#define STA_RATE_STATS_RATE_INVALID	0
+#define STA_RATE_STATS_RATE_VHT		0x8000
+#define STA_RATE_STATS_RATE_HT		0x4000
+#define STA_RATE_STATS_RATE_LEGACY	0x2000
+#define STA_RATE_STATS_RATE_SGI		0x1000
+#define STA_RATE_STATS_RATE_BW_SHIFT	9
+#define STA_RATE_STATS_RATE_BW_MASK	(0x7 << STA_RATE_STATS_RATE_BW_SHIFT)
+		u16 rate;
+		u16 rx;
+	/* 3 * rate_idx/MCS - using a few from the end as escape */
+	} entries[36];
+};
+
+static inline u16 sta_rate_stats_encode_rate(struct ieee80211_rx_status *s)
+{
+	u16 r = s->rate_idx;
+
+	if (s->vht_flag & RX_VHT_FLAG_80MHZ)
+		r |= RATE_INFO_BW_80 << STA_RATE_STATS_RATE_BW_SHIFT;
+	else if (s->vht_flag & RX_VHT_FLAG_160MHZ)
+		r |= RATE_INFO_BW_160 << STA_RATE_STATS_RATE_BW_SHIFT;
+	else if (s->flag & RX_FLAG_40MHZ)
+		r |= RATE_INFO_BW_40 << STA_RATE_STATS_RATE_BW_SHIFT;
+	else if (s->flag & RX_FLAG_10MHZ)
+		r |= RATE_INFO_BW_10 << STA_RATE_STATS_RATE_BW_SHIFT;
+	else if (s->flag & RX_FLAG_5MHZ)
+		r |= RATE_INFO_BW_5 << STA_RATE_STATS_RATE_BW_SHIFT;
+	else
+		r |= RATE_INFO_BW_20 << STA_RATE_STATS_RATE_BW_SHIFT;
+
+	if (s->flag & RX_FLAG_SHORT_GI)
+		r |= STA_RATE_STATS_RATE_SGI;
+
+	if (s->flag & RX_FLAG_VHT)
+		r |= STA_RATE_STATS_RATE_VHT | (s->vht_nss << 4);
+	else if (s->flag & RX_FLAG_HT)
+		r |= STA_RATE_STATS_RATE_HT;
+	else
+		r |= STA_RATE_STATS_RATE_LEGACY | (s->band << 4);
+
+	return r;
+}
+
 #endif /* STA_INFO_H */
-- 
2.1.4

