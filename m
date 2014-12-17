Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36826 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaLQN6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 08:58:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/9] mac80211: allow drivers to provide most station statistics
Date: Wed, 17 Dec 2014 14:57:56 +0100
Message-Id: <1418824679-31530-7-git-send-email-johannes@sipsolutions.net> (sfid-20141217_145827_757077_F82CB763)
In-Reply-To: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
References: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In many cases, drivers can filter things like beacons that will
skew statistics reported by mac80211. To get correct statistics
in these cases, call drivers to obtain statistics and let them
override all values, filling values from mac80211 if the driver
didn't provide them. Not all of them make sense for the driver
to fill, so some are still always done by mac80211.

Note that this doesn't currently allow a driver to say "I know
this value is wrong, don't report it at all", or to sum it up
with a mac80211 value (as could be useful for "dropped misc"),
that can be added if it turns out to be needed.

This also gets rid of the get_rssi() method as is can now be
implemented using sta_statistics().

Change-Id: Iaa5a5238eb9950a00a67dcba0753b5e90ebdf787
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 20 ++++----
 include/net/mac80211.h                | 17 ++++--
 net/mac80211/driver-ops.h             | 30 +++++------
 net/mac80211/sta_info.c               | 97 +++++++++++++++++++++++------------
 net/mac80211/trace.h                  | 33 +++---------
 5 files changed, 110 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 2a99456b6b8f..8d11b0ca412c 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5376,14 +5376,15 @@ static void wlcore_op_sta_rc_update(struct ieee80211_hw *hw,
 	wlcore_hw_sta_rc_update(wl, wlvif, sta, changed);
 }
 
-static int wlcore_op_get_rssi(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       struct ieee80211_sta *sta,
-			       s8 *rssi_dbm)
+static void wlcore_op_sta_statistics(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_sta *sta,
+				     struct station_info *sinfo)
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-	int ret = 0;
+	s8 rssi_dbm;
+	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 get_rssi");
 
@@ -5396,17 +5397,18 @@ static int wlcore_op_get_rssi(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out_sleep;
 
-	ret = wlcore_acx_average_rssi(wl, wlvif, rssi_dbm);
+	ret = wlcore_acx_average_rssi(wl, wlvif, &rssi_dbm);
 	if (ret < 0)
 		goto out_sleep;
 
+	sinfo->filled |= STATION_INFO_SIGNAL;
+	sinfo->signal = rssi_dbm;
+
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
-
-	return ret;
 }
 
 static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
@@ -5606,7 +5608,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.assign_vif_chanctx = wlcore_op_assign_vif_chanctx,
 	.unassign_vif_chanctx = wlcore_op_unassign_vif_chanctx,
 	.sta_rc_update = wlcore_op_sta_rc_update,
-	.get_rssi = wlcore_op_get_rssi,
+	.sta_statistics = wlcore_op_sta_statistics,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4913c00539fb..f52af9bb988d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2704,6 +2704,14 @@ enum ieee80211_reconfig_type {
  *	is only used if the configured rate control algorithm actually uses
  *	the new rate table API, and is therefore optional. Must be atomic.
  *
+ * @sta_statistics: Get statistics for this station. For example with beacon
+ *	filtering, the statistics kept by mac80211 might not be accurate, so
+ *	let the driver pre-fill the statistics. The driver can fill most of
+ *	the values (indicating which by setting the filled bitmap), but not
+ *	all of them make sense - see the source for which ones are possible.
+ *	Statistics that the driver doesn't fill will be filled by mac80211.
+ *	The callback can sleep.
+ *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
  *	Returns a negative error code on failure.
@@ -2864,9 +2872,6 @@ enum ieee80211_reconfig_type {
  * @get_et_strings:  Ethtool API to get a set of strings to describe stats
  *	and perhaps other supported types of ethtool data-sets.
  *
- * @get_rssi: Get current signal strength in dBm, the function is optional
- *	and can sleep.
- *
  * @mgd_prepare_tx: Prepare for transmitting a management frame for association
  *	before associated. In multi-channel scenarios, a virtual interface is
  *	bound to a channel before it is associated, but as it isn't associated
@@ -3067,6 +3072,10 @@ struct ieee80211_ops {
 	void (*sta_rate_tbl_update)(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_sta *sta);
+	void (*sta_statistics)(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct ieee80211_sta *sta,
+			       struct station_info *sinfo);
 	int (*conf_tx)(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif, u16 ac,
 		       const struct ieee80211_tx_queue_params *params);
@@ -3134,8 +3143,6 @@ struct ieee80211_ops {
 	void	(*get_et_strings)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  u32 sset, u8 *data);
-	int	(*get_rssi)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			    struct ieee80211_sta *sta, s8 *rssi_dbm);
 
 	void	(*mgd_prepare_tx)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 2ebc9ead9695..fdeda17b8dd2 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -639,6 +639,21 @@ static inline void drv_sta_rate_tbl_update(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void drv_sta_statistics(struct ieee80211_local *local,
+				      struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_sta *sta,
+				      struct station_info *sinfo)
+{
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
+
+	trace_drv_sta_statistics(local, sdata, sta);
+	if (local->ops->sta_statistics)
+		local->ops->sta_statistics(&local->hw, &sdata->vif, sta, sinfo);
+	trace_drv_return_void(local);
+}
+
 static inline int drv_conf_tx(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata, u16 ac,
 			      const struct ieee80211_tx_queue_params *params)
@@ -966,21 +981,6 @@ drv_allow_buffered_frames(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline int drv_get_rssi(struct ieee80211_local *local,
-				struct ieee80211_sub_if_data *sdata,
-				struct ieee80211_sta *sta,
-				s8 *rssi_dbm)
-{
-	int ret;
-
-	might_sleep();
-
-	ret = local->ops->get_rssi(&local->hw, &sdata->vif, sta, rssi_dbm);
-	trace_drv_get_rssi(local, sta, *rssi_dbm, ret);
-
-	return ret;
-}
-
 static inline void drv_mgd_prepare_tx(struct ieee80211_local *local,
 				      struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 388ff0b2ad2b..967b42eae5c2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1746,7 +1746,6 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	struct ieee80211_local *local = sdata->local;
 	struct rate_control_ref *ref = NULL;
 	struct timespec uptime;
-	u64 packets = 0;
 	u32 thr = 0;
 	int i, ac;
 
@@ -1755,47 +1754,74 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 	sinfo->generation = sdata->local->sta_generation;
 
-	sinfo->filled = STATION_INFO_INACTIVE_TIME |
-			STATION_INFO_RX_BYTES64 |
-			STATION_INFO_TX_BYTES64 |
-			STATION_INFO_RX_PACKETS |
-			STATION_INFO_TX_PACKETS |
-			STATION_INFO_TX_RETRIES |
-			STATION_INFO_TX_FAILED |
-			STATION_INFO_TX_BITRATE |
-			STATION_INFO_RX_BITRATE |
-			STATION_INFO_RX_DROP_MISC |
-			STATION_INFO_BSS_PARAM |
-			STATION_INFO_CONNECTED_TIME |
-			STATION_INFO_STA_FLAGS |
-			STATION_INFO_BEACON_LOSS_COUNT;
+	drv_sta_statistics(local, sdata, &sta->sta, sinfo);
+
+	sinfo->filled |= STATION_INFO_INACTIVE_TIME |
+			 STATION_INFO_STA_FLAGS |
+			 STATION_INFO_BSS_PARAM |
+			 STATION_INFO_CONNECTED_TIME |
+			 STATION_INFO_RX_DROP_MISC |
+			 STATION_INFO_BEACON_LOSS_COUNT;
 
 	ktime_get_ts(&uptime);
 	sinfo->connected_time = uptime.tv_sec - sta->last_connected;
-
 	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
-	sinfo->tx_bytes = 0;
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		sinfo->tx_bytes += sta->tx_bytes[ac];
-		packets += sta->tx_packets[ac];
+
+	if (!(sinfo->filled & (STATION_INFO_TX_BYTES64 |
+			       STATION_INFO_TX_BYTES))) {
+		sinfo->tx_bytes = 0;
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+			sinfo->tx_bytes += sta->tx_bytes[ac];
+		sinfo->filled |= STATION_INFO_TX_BYTES64;
+	}
+
+	if (!(sinfo->filled & STATION_INFO_TX_PACKETS)) {
+		sinfo->tx_packets = 0;
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+			sinfo->tx_packets += sta->tx_packets[ac];
+		sinfo->filled |= STATION_INFO_TX_PACKETS;
+	}
+
+	if (!(sinfo->filled & (STATION_INFO_RX_BYTES64 |
+			       STATION_INFO_RX_BYTES))) {
+		sinfo->rx_bytes = sta->rx_bytes;
+		sinfo->filled |= STATION_INFO_RX_BYTES64;
+	}
+
+	if (!(sinfo->filled & STATION_INFO_RX_PACKETS)) {
+		sinfo->rx_packets = sta->rx_packets;
+		sinfo->filled |= STATION_INFO_RX_PACKETS;
+	}
+
+	if (!(sinfo->filled & STATION_INFO_TX_RETRIES)) {
+		sinfo->tx_retries = sta->tx_retry_count;
+		sinfo->filled |= STATION_INFO_TX_RETRIES;
+	}
+
+	if (!(sinfo->filled & STATION_INFO_TX_FAILED)) {
+		sinfo->tx_failed = sta->tx_retry_failed;
+		sinfo->filled |= STATION_INFO_TX_FAILED;
 	}
-	sinfo->tx_packets = packets;
-	sinfo->rx_bytes = sta->rx_bytes;
-	sinfo->rx_packets = sta->rx_packets;
-	sinfo->tx_retries = sta->tx_retry_count;
-	sinfo->tx_failed = sta->tx_retry_failed;
+
 	sinfo->rx_dropped_misc = sta->rx_dropped;
 	sinfo->beacon_loss_count = sta->beacon_loss_count;
 
 	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
 	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
-		sinfo->filled |= STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
-		if (!local->ops->get_rssi ||
-		    drv_get_rssi(local, sdata, &sta->sta, &sinfo->signal))
+		if (!(sinfo->filled & STATION_INFO_SIGNAL)) {
 			sinfo->signal = (s8)sta->last_signal;
-		sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
+			sinfo->filled |= STATION_INFO_SIGNAL;
+		}
+
+		if (!(sinfo->filled & STATION_INFO_SIGNAL_AVG)) {
+			sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
+			sinfo->filled |= STATION_INFO_SIGNAL_AVG;
+		}
 	}
-	if (sta->chains) {
+
+	if (sta->chains &&
+	    !(sinfo->filled & (STATION_INFO_CHAIN_SIGNAL |
+			       STATION_INFO_CHAIN_SIGNAL_AVG))) {
 		sinfo->filled |= STATION_INFO_CHAIN_SIGNAL |
 				 STATION_INFO_CHAIN_SIGNAL_AVG;
 
@@ -1807,8 +1833,15 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		}
 	}
 
-	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);
-	sta_set_rate_info_rx(sta, &sinfo->rxrate);
+	if (!(sinfo->filled & STATION_INFO_TX_BITRATE)) {
+		sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);
+		sinfo->filled |= STATION_INFO_TX_BITRATE;
+	}
+
+	if (!(sinfo->filled & STATION_INFO_RX_BITRATE)) {
+		sta_set_rate_info_rx(sta, &sinfo->rxrate);
+		sinfo->filled |= STATION_INFO_RX_BITRATE;
+	}
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 8e461a02c6a8..263a9561eb26 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -825,6 +825,13 @@ DECLARE_EVENT_CLASS(sta_event,
 	)
 );
 
+DEFINE_EVENT(sta_event, drv_sta_statistics,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+	TP_ARGS(local, sdata, sta)
+);
+
 DEFINE_EVENT(sta_event, drv_sta_add,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
@@ -1329,32 +1336,6 @@ DEFINE_EVENT(release_evt, drv_allow_buffered_frames,
 	TP_ARGS(local, sta, tids, num_frames, reason, more_data)
 );
 
-TRACE_EVENT(drv_get_rssi,
-	TP_PROTO(struct ieee80211_local *local, struct ieee80211_sta *sta,
-		 s8 rssi, int ret),
-
-	TP_ARGS(local, sta, rssi, ret),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-		STA_ENTRY
-		__field(s8, rssi)
-		__field(int, ret)
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-		STA_ASSIGN;
-		__entry->rssi = rssi;
-		__entry->ret = ret;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT STA_PR_FMT " rssi:%d ret:%d",
-		LOCAL_PR_ARG, STA_PR_ARG, __entry->rssi, __entry->ret
-	)
-);
-
 DEFINE_EVENT(local_sdata_evt, drv_mgd_prepare_tx,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
-- 
2.1.1

