Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43299 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3GPKpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 06:45:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] mac80211: implement the beacon measurement ops
Date: Tue, 16 Jul 2013 13:45:17 +0300
Message-Id: <1373971517-315-3-git-send-email-johannes@sipsolutions.net> (sfid-20130716_124527_913556_2D0B67C7)
In-Reply-To: <1373971517-315-1-git-send-email-johannes@sipsolutions.net>
References: <1373971517-315-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This tells the low-level driver to let all the beacons
through and update the data needed to conduct the
measurements.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |  7 +++++++
 net/mac80211/cfg.c        | 14 ++++++++++++++
 net/mac80211/driver-ops.h | 20 ++++++++++++++++++++
 net/mac80211/trace.h      | 23 +++++++++++++++++++++++
 4 files changed, 64 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3124036..fb8f6c6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2634,6 +2634,10 @@ enum ieee80211_roc_type {
  *	driver's resume function returned 1, as this is just like an "inline"
  *	hardware restart. This callback may sleep.
  *
+ * @beacon_measurement: Start or stop beacon measurement. When started, all the
+ *	beacons must be let through and data for measurement should be set in
+ *	&ieee80211_rx_status (rssi etc...).
+ *
  * @ipv6_addr_change: IPv6 address assignment on the given interface changed.
  *	Currently, this is only called for managed or P2P client interfaces.
  *	This callback is optional; it must not sleep.
@@ -2819,6 +2823,9 @@ struct ieee80211_ops {
 
 	void (*restart_complete)(struct ieee80211_hw *hw);
 
+	int (*beacon_measurement)(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif, bool state);
+
 #if IS_ENABLED(CONFIG_IPV6)
 	void (*ipv6_addr_change)(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b82fff6..34b57a9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3407,6 +3407,19 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
 	return ret;
 }
 
+static int ieee80211_beacon_measurement(struct wiphy *wiphy,
+					struct wireless_dev *wdev,
+					bool state)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	if (WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	return drv_beacon_measurement(local, sdata, state);
+}
+
 #ifdef CONFIG_PM
 static void ieee80211_set_wakeup(struct wiphy *wiphy, bool enabled)
 {
@@ -3492,4 +3505,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
+	.beacon_measurement = ieee80211_beacon_measurement,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index b931c96..7fbe57f 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1060,6 +1060,26 @@ drv_set_default_unicast_key(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int
+drv_beacon_measurement(struct ieee80211_local *local,
+		       struct ieee80211_sub_if_data *sdata, bool state)
+{
+	int ret = -EOPNOTSUPP;
+	check_sdata_in_driver(sdata);
+
+	trace_drv_beacon_measurement(local, sdata, state);
+
+	if (local->ops->beacon_measurement)
+		ret = local->ops->beacon_measurement(&local->hw, &sdata->vif,
+						     state);
+	else
+		/* Driver advertises caps but doesn't implement the callback? */
+		WARN_ON_ONCE(1);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #if IS_ENABLED(CONFIG_IPV6)
 static inline void drv_ipv6_addr_change(struct ieee80211_local *local,
 					struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index c215fafd7..d41bbe2 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1887,6 +1887,29 @@ TRACE_EVENT(drv_set_default_unicast_key,
 		  LOCAL_PR_ARG, VIF_PR_ARG, __entry->key_idx)
 );
 
+TRACE_EVENT(drv_beacon_measurement,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 bool state),
+
+	TP_ARGS(local, sdata, state),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(bool, state)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->state = state;
+	),
+
+	TP_printk(LOCAL_PR_FMT VIF_PR_FMT " state:%d",
+		  LOCAL_PR_ARG, VIF_PR_ARG, __entry->state)
+);
+
 TRACE_EVENT(api_radar_detected,
 	TP_PROTO(struct ieee80211_local *local),
 
-- 
1.8.0

