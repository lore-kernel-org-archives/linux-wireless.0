Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47750 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935069AbeFMKqV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 06:46:21 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 6/7] cfg80211: Accept multiple RSSI threholds for STA_MON command
Date: Wed, 13 Jun 2018 16:15:46 +0530
Message-Id: <1528886747-26342-7-git-send-email-tamizhr@codeaurora.org> (sfid-20180613_124653_539722_D1CBA950)
In-Reply-To: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the NL80211_CMD_STA_MON RSSI threshold attribut to
accept any number of thresholds as a sorted array. If
user send the configuration with single RSSI threshold then
the old mechanism is enabled. Same netlink event will be
generated in both cases. This patch introduced
set_sta_mon_rssi_range_config to configure high and low
value.
Driver supporting this feature should advertise
NL80211_EXT_FEATURE_STA_MON_RSSI_LIST.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |   10 +++
 include/uapi/linux/nl80211.h |    4 +
 net/wireless/nl80211.c       |  176 ++++++++++++++++++++++++++++++------------
 net/wireless/rdev-ops.h      |   15 ++++
 net/wireless/trace.h         |   26 +++++++
 5 files changed, 180 insertions(+), 51 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7dcf9b9..4c49cc5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3029,6 +3029,12 @@ struct cfg80211_external_auth_params {
  *	the current level of a station is above/below the configured threshold;
  *	this may need some care when the configuration is changed
  *	(without first being disabled.)
+ * @set_sta_mon_rssi_range_config: Configure two RSSI thresholds in the
+ *	station's rssi monitor.  An event is to be sent only when the
+ *	signal level of a station is found to be outside the two values.
+ *	The driver should advertise %NL80211_EXT_FEATURE_STA_MON_RSSI_LIST if
+ *	this method is implemented. If it is provided then there's no point
+ *	providing @set_sta_mon_rssi_config
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3338,6 +3344,10 @@ struct cfg80211_ops {
 					   struct net_device *dev,
 					   const u8 *addr,
 					   s32 rssi_thold, u32 rssi_hyst);
+	int	(*set_sta_mon_rssi_range_config)(struct wiphy *wiphy,
+						 struct net_device *dev,
+						 const u8 *addr,
+						 s32 rssi_low, s32 rssi_high);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9d47ee6..8e2a84b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -5188,6 +5188,9 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG: With this driver can set
  *	rssi threshold using %NL80211_ATTR_STA_MON_RSSI_THOLD attribute
  *	for a connected station.
+ * @NL80211_EXT_FEATURE_STA_MON_RSSI_LIST: With this driver the
+ *	%NL80211_ATTR_STA_MON_RSSI_THOLD attribute accepts a list of zero or
+ *	more RSSI threshold values to monitor rather than exactly one threshold.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5223,6 +5226,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT,
 	NL80211_EXT_FEATURE_TXQS,
 	NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG,
+	NL80211_EXT_FEATURE_STA_MON_RSSI_LIST,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 021e55a..c0fccb4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10134,61 +10134,101 @@ static int nl80211_set_cqm_txe(struct genl_info *info,
 
 static const struct nla_policy
 nl80211_attr_sta_mon_policy[NL80211_ATTR_STA_MON_MAX + 1] = {
-	[NL80211_ATTR_STA_MON_RSSI_THOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON_RSSI_THOLD] = { .type = NLA_BINARY },
 	[NL80211_ATTR_STA_MON_RSSI_HYST] = { .type = NLA_U32 },
 	[NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
 	[NL80211_ATTR_STA_MON_RSSI_LEVEL] = { .type = NLA_S32 },
 };
 
-static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
-				    struct net_device *dev)
+static int cfg80211_set_rssi_range(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev, const u8 *mac_addr,
+				   bool get_last_rssi)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	s32 last, low, high;
+	s32 low, high, last;
 	u32 hyst;
-	int i, n;
-	int err;
-
-	/* RSSI reporting disabled? */
-	if (!wdev->rssi_config)
-		return rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
+	int i, n, err;
 
-	/*
-	 * Obtain current RSSI value if possible, if not and no RSSI threshold
-	 * event has been received yet, we should receive an event after a
-	 * connection is established and enough beacons received to calculate
-	 * the average.
-	 */
-	if (!wdev->rssi_config->last_rssi_event_value && wdev->current_bss &&
-	    rdev->ops->get_station) {
+	if (get_last_rssi && mac_addr) {
 		struct station_info sinfo = {};
-		u8 *mac_addr;
-
-		mac_addr = wdev->current_bss->pub.bssid;
 
 		err = rdev_get_station(rdev, dev, mac_addr, &sinfo);
 		if (err)
 			return err;
 
-		if (sinfo.filled & BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG))
-			wdev->rssi_config->last_rssi_event_value =
-				(s8) sinfo.rx_beacon_signal_avg;
+		if (wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT) {
+			if (sinfo.filled & BIT(NL80211_STA_INFO_SIGNAL_AVG))
+				wdev->rssi_config->last_rssi_event_value =
+					(s8)sinfo.signal_avg;
+		} else {
+			if (sinfo.filled &
+			    BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG))
+				wdev->rssi_config->last_rssi_event_value =
+					(s8)sinfo.rx_beacon_signal_avg;
+		}
 	}
 
 	last = wdev->rssi_config->last_rssi_event_value;
 	hyst = wdev->rssi_config->rssi_hyst;
 	n = wdev->rssi_config->n_rssi_thresholds;
 
-	for (i = 0; i < n; i++)
+	for (i = 0; i < n; i++) {
 		if (last < wdev->rssi_config->rssi_thresholds[i])
 			break;
+	}
 
 	low = i > 0 ?
 		(wdev->rssi_config->rssi_thresholds[i - 1] - hyst) : S32_MIN;
 	high = i < n ?
 		(wdev->rssi_config->rssi_thresholds[i] + hyst - 1) : S32_MAX;
 
-	return rdev_set_cqm_rssi_range_config(rdev, dev, low, high);
+	if (wdev->iftype == NL80211_IFTYPE_STATION ||
+	    wdev->iftype == NL80211_IFTYPE_P2P_CLIENT)
+		return rdev_set_cqm_rssi_range_config(rdev, dev, low, high);
+
+	return rdev_set_sta_mon_rssi_range_config(rdev, dev, mac_addr,
+						  low, high);
+}
+
+static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
+				    struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	u8 *mac_addr = NULL;
+
+	/* RSSI reporting disabled? */
+	if (!wdev->rssi_config)
+		return rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
+
+	/*
+	 * Obtain current RSSI value if possible, if not and no RSSI threshold
+	 * event has been received yet, we should receive an event after a
+	 * connection is established and enough beacons received to calculate
+	 * the average.
+	 */
+	if (!wdev->rssi_config->last_rssi_event_value && wdev->current_bss &&
+	    rdev->ops->get_station)
+		mac_addr = wdev->current_bss->pub.bssid;
+
+	return cfg80211_set_rssi_range(rdev, dev, mac_addr,
+				!wdev->rssi_config->last_rssi_event_value);
+}
+
+static int nl80211_validate_rssi_tholds(const s32 *thresholds, int n_thresholds)
+{
+	int i;
+	s32 prev = S32_MIN;
+
+	/* Check all values negative and sorted */
+	for (i = 0; i < n_thresholds; i++) {
+		if (thresholds[i] > 0 || thresholds[i] <= prev)
+			return -EINVAL;
+
+		prev = thresholds[i];
+	}
+
+	return 0;
 }
 
 static struct cfg80211_rssi_config *
@@ -10228,16 +10268,11 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	int i, err;
-	s32 prev = S32_MIN;
-
-	/* Check all values negative and sorted */
-	for (i = 0; i < n_thresholds; i++) {
-		if (thresholds[i] > 0 || thresholds[i] <= prev)
-			return -EINVAL;
+	int err;
 
-		prev = thresholds[i];
-	}
+	err = nl80211_validate_rssi_tholds(thresholds, n_thresholds);
+	if (err)
+		return err;
 
 	if (wdev->iftype != NL80211_IFTYPE_STATION &&
 	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
@@ -10275,6 +10310,8 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 	}
 
 	err = cfg80211_cqm_rssi_update(rdev, dev);
+	if (err)
+		cfg80211_rssi_config_free(wdev, NULL);
 
 unlock:
 	wdev_unlock(wdev);
@@ -12922,21 +12959,13 @@ static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
 }
 
 static int nl80211_set_sta_mon_rssi(struct genl_info *info,
-				    const u8 *peer, s32 threshold,
-				    u32 hysteresis)
+				    const u8 *peer, const s32 *thresholds,
+				    int n_thresholds, u32 hysteresis)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-
-	if (threshold > 0)
-		return -EINVAL;
-
-	if (threshold == 0)
-		hysteresis = 0;
-
-	if (!rdev->ops->set_sta_mon_rssi_config)
-		return -EOPNOTSUPP;
+	int err;
 
 	if ((wdev->iftype != NL80211_IFTYPE_AP &&
 	     wdev->iftype != NL80211_IFTYPE_P2P_GO &&
@@ -12945,8 +12974,46 @@ static int nl80211_set_sta_mon_rssi(struct genl_info *info,
 				NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG))
 		return -EOPNOTSUPP;
 
-	return rdev_set_sta_mon_rssi_config(rdev, dev, peer,
-					    threshold, hysteresis);
+	err = nl80211_validate_rssi_tholds(thresholds, n_thresholds);
+	if (err)
+		return err;
+
+	if (n_thresholds <= 1 && rdev->ops->set_sta_mon_rssi_config) {
+		if (n_thresholds == 0 || thresholds[0] == 0)
+			return rdev_set_sta_mon_rssi_config(rdev, dev,
+							    peer, 0, 0);
+
+		return rdev_set_sta_mon_rssi_config(rdev, dev, peer,
+						    thresholds[0], hysteresis);
+	}
+
+	if (!rdev->ops->set_sta_mon_rssi_range_config ||
+	    !wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_STA_MON_RSSI_LIST))
+		return -EOPNOTSUPP;
+
+	/* Disabling */
+	if (!n_thresholds || (n_thresholds == 1 && thresholds[0] == 0))
+		return rdev_set_sta_mon_rssi_range_config(rdev, dev,
+							  peer, 0, 0);
+
+	wdev_lock(wdev);
+	wdev->rssi_config = cfg80211_get_rssi_config(wdev, thresholds,
+						     n_thresholds, hysteresis,
+						     peer);
+	if (!wdev->rssi_config) {
+		err = -ENOMEM;
+		goto unlock;
+	}
+
+	err = cfg80211_set_rssi_range(rdev, dev, peer,
+				!wdev->rssi_config->last_rssi_event_value);
+	if (err)
+		cfg80211_rssi_config_free(wdev, peer);
+
+unlock:
+	wdev_unlock(wdev);
+	return err;
 }
 
 static int nl80211_sta_mon(struct sk_buff *skb, struct genl_info *info)
@@ -12970,12 +13037,16 @@ static int nl80211_sta_mon(struct sk_buff *skb, struct genl_info *info)
 	addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 	if (attrs[NL80211_ATTR_STA_MON_RSSI_THOLD] &&
 	    attrs[NL80211_ATTR_STA_MON_RSSI_HYST]) {
-		s32 threshold =
-			nla_get_s32(attrs[NL80211_ATTR_STA_MON_RSSI_THOLD]);
+		const s32 *tholds =
+			nla_data(attrs[NL80211_ATTR_STA_MON_RSSI_THOLD]);
 		u32 hysteresis =
 			nla_get_u32(attrs[NL80211_ATTR_STA_MON_RSSI_HYST]);
+		int len = nla_len(attrs[NL80211_ATTR_STA_MON_RSSI_THOLD]);
+
+		if (len % 4)
+			return -EINVAL;
 
-		return nl80211_set_sta_mon_rssi(info, addr, threshold,
+		return nl80211_set_sta_mon_rssi(info, addr, tholds, len / 4,
 						hysteresis);
 	}
 	return -EINVAL;
@@ -15422,6 +15493,7 @@ void cfg80211_sta_mon_rssi_notify(struct net_device *dev, const u8 *peer,
 {
 	struct sk_buff *msg;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_rssi_config *rssi_config;
 
 	if (WARN_ON(!peer))
@@ -15437,6 +15509,8 @@ void cfg80211_sta_mon_rssi_notify(struct net_device *dev, const u8 *peer,
 		if (!memcmp(rssi_config->addr, peer, ETH_ALEN)) {
 			wdev->rssi_config = rssi_config;
 			wdev->rssi_config->last_rssi_event_value = rssi_level;
+			cfg80211_set_rssi_range(rdev, dev, peer,
+				!wdev->rssi_config->last_rssi_event_value);
 			break;
 		}
 	}
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index faccfae..1184e4a 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1248,4 +1248,19 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_sta_mon_rssi_range_config(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev, const u8 *peer,
+				   s32 low, s32 high)
+{
+	int ret;
+
+	trace_rdev_set_sta_mon_rssi_range_config(&rdev->wiphy, dev, peer,
+						 low, high);
+	ret = rdev->ops->set_sta_mon_rssi_range_config(&rdev->wiphy, dev, peer,
+						       low, high);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 5454c57..76c422c 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3282,6 +3282,32 @@
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer),
 		  __entry->rssi_thold, __entry->rssi_hyst)
 );
+
+TRACE_EVENT(rdev_set_sta_mon_rssi_range_config,
+	TP_PROTO(struct wiphy *wiphy,
+		 struct net_device *netdev, const u8 *peer,
+		 s32 low, s32 high),
+	TP_ARGS(wiphy, netdev, peer, low, high),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(s32, rssi_low)
+		__field(s32, rssi_high)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->rssi_low = low;
+		__entry->rssi_high = high;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT
+		  ", range: %d - %d ",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer),
+		  __entry->rssi_low, __entry->rssi_high)
+);
+
 TRACE_EVENT(cfg80211_sta_mon_rssi_notify,
 	TP_PROTO(struct net_device *netdev, const u8 *peer,
 		 enum nl80211_sta_mon_rssi_threshold_event rssi_event,
-- 
1.7.9.5
