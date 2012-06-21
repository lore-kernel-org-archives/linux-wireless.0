Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:33215 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970Ab2FUH7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 03:59:52 -0400
Received: by obbta17 with SMTP id ta17so953567obb.22
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 00:59:48 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: [PATCH v5] mac80211: add command to get current rssi
Date: Thu, 21 Jun 2012 10:56:46 +0300
Message-Id: <1340265406-25099-1-git-send-email-victorg@ti.com> (sfid-20120621_095957_226424_20A69380)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get current rssi (in dBm) from the driver/FW.

Instead of reporting the signal received in the last
rx packet, which might be inaccurate if rx traffic is
low and beacon filtering is enabled, get the singal
from the driver/FW.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---

v5:
	Tracer also returned rssi + sta address.

 include/net/mac80211.h      |    5 +++++
 net/mac80211/cfg.c          |   21 +++++++++++++--------
 net/mac80211/driver-ops.h   |   15 +++++++++++++++
 net/mac80211/driver-trace.h |   26 ++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6914f99..3d43ad8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2254,6 +2254,9 @@ enum ieee80211_rate_control_changed {
  * @get_et_strings:  Ethtool API to get a set of strings to describe stats
  *	and perhaps other supported types of ethtool data-sets.
  *
+ * @get_rssi: Get current signal strength in dBm, the function is optional
+ *	and can sleep.
+ *
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -2393,6 +2396,8 @@ struct ieee80211_ops {
 	void	(*get_et_strings)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  u32 sset, u8 *data);
+	int	(*get_rssi)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta, s8 *rssi_dbm);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 85ac364..0a2a56b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -353,6 +353,7 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 	struct timespec uptime;
 
 	sinfo->generation = sdata->local->sta_generation;
@@ -388,7 +389,9 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
 	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
 		sinfo->filled |= STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
-		sinfo->signal = (s8)sta->last_signal;
+		if (!local->ops->get_rssi ||
+		    drv_get_rssi(local, sdata, &sta->sta, &sinfo->signal))
+			sinfo->signal = (s8)sta->last_signal;
 		sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
 	}
 
@@ -517,7 +520,7 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 	 * network device.
 	 */
 
-	rcu_read_lock();
+	mutex_lock(&local->sta_mtx);
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		sta = sta_info_get_bss(sdata, sdata->u.mgd.bssid);
@@ -546,7 +549,7 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 			data[i] = (u8)sinfo.signal_avg;
 		i++;
 	} else {
-		list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		list_for_each_entry(sta, &local->sta_list, list) {
 			/* Make sure this station belongs to the proper dev */
 			if (sta->sdata->dev != dev)
 				continue;
@@ -603,7 +606,7 @@ do_survey:
 	else
 		data[i++] = -1LL;
 
-	rcu_read_unlock();
+	mutex_unlock(&local->sta_mtx);
 
 	if (WARN_ON(i != STA_STATS_LEN))
 		return;
@@ -629,10 +632,11 @@ static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 				 int idx, u8 *mac, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int ret = -ENOENT;
 
-	rcu_read_lock();
+	mutex_lock(&local->sta_mtx);
 
 	sta = sta_info_get_by_idx(sdata, idx);
 	if (sta) {
@@ -641,7 +645,7 @@ static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 		sta_set_sinfo(sta, sinfo);
 	}
 
-	rcu_read_unlock();
+	mutex_unlock(&local->sta_mtx);
 
 	return ret;
 }
@@ -658,10 +662,11 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int ret = -ENOENT;
 
-	rcu_read_lock();
+	mutex_lock(&local->sta_mtx);
 
 	sta = sta_info_get_bss(sdata, mac);
 	if (sta) {
@@ -669,7 +674,7 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 		sta_set_sinfo(sta, sinfo);
 	}
 
-	rcu_read_unlock();
+	mutex_unlock(&local->sta_mtx);
 
 	return ret;
 }
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 6d33a0c..9330269 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -845,4 +845,19 @@ drv_allow_buffered_frames(struct ieee80211_local *local,
 						  more_data);
 	trace_drv_return_void(local);
 }
+
+static inline int drv_get_rssi(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				struct ieee80211_sta *sta,
+				s8 *rssi_dbm)
+{
+	int ret;
+
+	might_sleep();
+
+	ret = local->ops->get_rssi(&local->hw, &sdata->vif, sta, rssi_dbm);
+	trace_drv_get_rssi(local, sta, *rssi_dbm, ret);
+
+	return ret;
+}
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6de00b2..a0f7d35 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -1218,6 +1218,32 @@ DEFINE_EVENT(release_evt, drv_allow_buffered_frames,
 	TP_ARGS(local, sta, tids, num_frames, reason, more_data)
 );
 
+TRACE_EVENT(drv_get_rssi,
+	TP_PROTO(struct ieee80211_local *local, struct ieee80211_sta *sta,
+		 s8 rssi, int ret),
+
+	TP_ARGS(local, sta, rssi, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		STA_ENTRY
+		__field(s8, rssi)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		STA_ASSIGN;
+		__entry->rssi = rssi;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT STA_PR_FMT " rssi:%d ret:%d",
+		LOCAL_PR_ARG, STA_PR_ARG, __entry->rssi, __entry->ret
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
1.7.5.4

