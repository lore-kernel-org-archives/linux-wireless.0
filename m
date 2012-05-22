Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:43367 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab2EVGsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 02:48:01 -0400
Received: by obbuo19 with SMTP id uo19so11243132obb.40
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2012 23:47:59 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: add command to get current rssi
Date: Tue, 22 May 2012 09:45:30 +0300
Message-Id: <1337669130-4229-1-git-send-email-victorg@ti.com> (sfid-20120522_084822_922814_095B43F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get current rssi (in dBm) from the driver/FW.

Instead of reporting the signal received in the last
rx packet, which might be inaccurate if rx traffic is
low and beacon filtering is enabled, get the singal
from the driver/FW.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h      |    4 ++++
 net/mac80211/cfg.c          |   22 ++++++++++++++--------
 net/mac80211/driver-ops.h   |   11 +++++++++++
 net/mac80211/driver-trace.h |    6 ++++++
 4 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4d6e6c6..279126a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2231,6 +2231,8 @@ enum ieee80211_rate_control_changed {
  * @get_et_strings:  Ethtool API to get a set of strings to describe stats
  *	and perhaps other supported types of ethtool data-sets.
  *
+ * @get_rssi: Get current signal strength in dBm.
+ *
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -2370,6 +2372,8 @@ struct ieee80211_ops {
 	void	(*get_et_strings)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  u32 sset, u8 *data);
+	void (*get_rssi)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 s8 *rssi_dbm);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0221270..41bdf02 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -353,6 +353,7 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 	struct timespec uptime;
 
 	sinfo->generation = sdata->local->sta_generation;
@@ -388,7 +389,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
 	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
 		sinfo->filled |= STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
-		sinfo->signal = (s8)sta->last_signal;
+		if (local->ops->get_rssi)
+			drv_get_rssi(local, sdata, &sinfo->signal);
+		else
+			sinfo->signal = (s8)sta->last_signal;
 		sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
 	}
 
@@ -517,7 +521,7 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 	 * network device.
 	 */
 
-	rcu_read_lock();
+	mutex_lock(&local->sta_mtx);
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		sta = sta_info_get_bss(sdata, sdata->u.mgd.bssid);
@@ -546,7 +550,7 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 			data[i] = (u8)sinfo.signal_avg;
 		i++;
 	} else {
-		list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		list_for_each_entry(sta, &local->sta_list, list) {
 			/* Make sure this station belongs to the proper dev */
 			if (sta->sdata->dev != dev)
 				continue;
@@ -603,7 +607,7 @@ do_survey:
 	else
 		data[i++] = -1LL;
 
-	rcu_read_unlock();
+	mutex_unlock(&local->sta_mtx);
 
 	if (WARN_ON(i != STA_STATS_LEN))
 		return;
@@ -629,10 +633,11 @@ static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
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
@@ -641,7 +646,7 @@ static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 		sta_set_sinfo(sta, sinfo);
 	}
 
-	rcu_read_unlock();
+	mutex_unlock(&local->sta_mtx);
 
 	return ret;
 }
@@ -658,10 +663,11 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
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
@@ -669,7 +675,7 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 		sta_set_sinfo(sta, sinfo);
 	}
 
-	rcu_read_unlock();
+	mutex_unlock(&local->sta_mtx);
 
 	return ret;
 }
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 6d33a0c..cbfaf72 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -845,4 +845,15 @@ drv_allow_buffered_frames(struct ieee80211_local *local,
 						  more_data);
 	trace_drv_return_void(local);
 }
+
+static inline void drv_get_rssi(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				s8 *rssi_dbm)
+{
+	might_sleep();
+
+	trace_drv_get_rssi(local, sdata);
+	local->ops->get_rssi(&local->hw, &sdata->vif, rssi_dbm);
+	trace_drv_return_void(local);
+}
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6de00b2..fc91ac4 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -1218,6 +1218,12 @@ DEFINE_EVENT(release_evt, drv_allow_buffered_frames,
 	TP_ARGS(local, sta, tids, num_frames, reason, more_data)
 );
 
+DEFINE_EVENT(local_sdata_evt, drv_get_rssi,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
1.7.5.4

