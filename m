Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33742 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbdBJDug (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Feb 2017 22:50:36 -0500
Received: by mail-wr0-f196.google.com with SMTP id i10so13867267wrb.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2017 19:50:35 -0800 (PST)
Received: from localhost.localdomain ([92.176.165.227])
        by smtp.gmail.com with ESMTPSA id o143sm1072087wmd.3.2017.02.09.19.50.32
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Feb 2017 19:50:32 -0800 (PST)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v5 1/3] cfg80211: Accept multiple RSSI thresholds for CQM
Date: Fri, 10 Feb 2017 04:50:21 +0100
Message-Id: <20170210035023.11471-1-andrew.zaborowski@intel.com> (sfid-20170210_045048_611722_541CC562)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the SET CQM command's RSSI threshold attribute to accept any
number of thresholds as a sorted array.  The API should be backwards
compatible so that if one s32 threshold value is passed, the old
mechanism is enabled.  The netlink event generated is the same in both
cases.

cfg80211 handles an arbitrary number of RSSI thresholds but drivers have
to provide a method (set_cqm_rssi_range_config) that configures a range
set by a high and a low value.  Drivers have to call back when the RSSI
goes out of that range and there's no additional event for each time the
range is reconfigured as there was with the current one-threshold API.

This method doesn't have a hysteresis parameter because there's no
benefit to the cfg80211 code from having the hysteresis be handled by
hardware/driver in terms of the number of wakeups.  At the same time
it would likely be less consistent between drivers if offloaded or
done in the drivers.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
changes in v3:
 - define NL80211_EXT_FEATURE_CQM_RSSI_LIST which drivers need to set
   if they implement set_cqm_rssi_range_config (mac80211 is a special
   case)
 - error check the kzalloc in nl80211_set_cqm_rssi
 - add a rdev->ops->get_station check before calling get_station
changes in v4:
 - simplify the case of disabling CQM in nl80211_set_cqm_rssi
changed in v5:
 - drop unneeded NL80211_EXT_FEATURE_CQM_RSSI_LIST check
 - change the way new low/high threshold is calculated in
   cfg80211_cqm_rssi_update to make sure it's "hyst" away from range
   border to further reduce number of events
 - clarify NL80211_EXT_FEATURE_CQM_RSSI_LIST description in nl80211.h
---
 include/net/cfg80211.h       |  13 ++++
 include/uapi/linux/nl80211.h |   9 ++-
 net/wireless/core.c          |   9 +++
 net/wireless/core.h          |   9 +++
 net/wireless/nl80211.c       | 141 +++++++++++++++++++++++++++++++++++++++----
 net/wireless/rdev-ops.h      |  12 ++++
 net/wireless/trace.h         |  22 +++++++
 7 files changed, 201 insertions(+), 14 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c92dc03..86c12f8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2712,6 +2712,11 @@ struct cfg80211_nan_func {
  *	the current level is above/below the configured threshold; this may
  *	need some care when the configuration is changed (without first being
  *	disabled.)
+ * @set_cqm_rssi_range_config: Configure two RSSI thresholds in the
+ *	connection quality monitor.  An event is to be sent only when the
+ *	signal level is found to be outside the two values.  The driver should
+ *	set %NL80211_EXT_FEATURE_CQM_RSSI_LIST if this method is implemented.
+ *	If it is provided then there's no point providing @set_cqm_rssi_config.
  * @set_cqm_txe_config: Configure connection quality monitor TX error
  *	thresholds.
  * @sched_scan_start: Tell the driver to start a scheduled scan.
@@ -3001,6 +3006,10 @@ struct cfg80211_ops {
 				       struct net_device *dev,
 				       s32 rssi_thold, u32 rssi_hyst);
 
+	int	(*set_cqm_rssi_range_config)(struct wiphy *wiphy,
+					     struct net_device *dev,
+					     s32 rssi_low, s32 rssi_high);
+
 	int	(*set_cqm_txe_config)(struct wiphy *wiphy,
 				      struct net_device *dev,
 				      u32 rate, u32 pkts, u32 intvl);
@@ -3871,6 +3880,7 @@ void wiphy_free(struct wiphy *wiphy);
 struct cfg80211_conn;
 struct cfg80211_internal_bss;
 struct cfg80211_cached_keys;
+struct cfg80211_cqm_config;
 
 /**
  * struct wireless_dev - wireless device state
@@ -3934,6 +3944,7 @@ struct cfg80211_cached_keys;
  * @event_list: (private) list for internal event processing
  * @event_lock: (private) lock for event list
  * @owner_nlportid: (private) owner socket port ID
+ * @cqm_config: (private) nl80211 RSSI monitor state
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -4002,6 +4013,8 @@ struct wireless_dev {
 		bool prev_bssid_valid;
 	} wext;
 #endif
+
+	struct cfg80211_cqm_config *cqm_config;
 };
 
 static inline u8 *wdev_address(struct wireless_dev *wdev)
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5ed257c..9a499b1 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3942,7 +3942,10 @@ enum nl80211_ps_state {
  * @__NL80211_ATTR_CQM_INVALID: invalid
  * @NL80211_ATTR_CQM_RSSI_THOLD: RSSI threshold in dBm. This value specifies
  *	the threshold for the RSSI level at which an event will be sent. Zero
- *	to disable.
+ *	to disable.  Alternatively, if %NL80211_EXT_FEATURE_CQM_RSSI_LIST is
+ *	set, multiple values can be supplied as a low-to-high sorted array of
+ *	threshold values in dBm.  Events will be sent when the RSSI value
+ *	crosses any of the thresholds.
  * @NL80211_ATTR_CQM_RSSI_HYST: RSSI hysteresis in dBm. This value specifies
  *	the minimum amount the RSSI level must change after an event before a
  *	new event may be issued (to reduce effects of RSSI oscillation).
@@ -4753,6 +4756,9 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI: The driver supports sched_scan
  *	for reporting BSSs with better RSSI than the current connected BSS
  *	(%NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI).
+ * @NL80211_EXT_FEATURE_CQM_RSSI_LIST: With this driver the
+ *	%NL80211_ATTR_CQM_RSSI_THOLD attribute accepts a list of zero or more
+ *	RSSI threshold values to monitor rather than exactly one threshold.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4771,6 +4777,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA,
 	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA_CONNECTED,
 	NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI,
+	NL80211_EXT_FEATURE_CQM_RSSI_LIST,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index e55e05b..04143df 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -954,6 +954,12 @@ void wiphy_rfkill_set_hw_state(struct wiphy *wiphy, bool blocked)
 }
 EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
 
+void cfg80211_cqm_config_free(struct wireless_dev *wdev)
+{
+	kfree(wdev->cqm_config);
+	wdev->cqm_config = NULL;
+}
+
 void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -980,6 +986,8 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 		WARN_ON_ONCE(1);
 		break;
 	}
+
+	cfg80211_cqm_config_free(wdev);
 }
 EXPORT_SYMBOL(cfg80211_unregister_wdev);
 
@@ -1234,6 +1242,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			kzfree(wdev->wext.keys);
 #endif
 			flush_work(&wdev->disconnect_wk);
+			cfg80211_cqm_config_free(wdev);
 		}
 		/*
 		 * synchronise (so that we won't find this netdev
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 58ca206..efa690a 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -272,6 +272,13 @@ struct cfg80211_iface_destroy {
 	u32 nlportid;
 };
 
+struct cfg80211_cqm_config {
+	u32 rssi_hyst;
+	s32 last_rssi_event_value;
+	int n_rssi_thresholds;
+	s32 rssi_thresholds[0];
+};
+
 void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev);
 
 /* free object */
@@ -512,4 +519,6 @@ void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 #define CFG80211_DEV_WARN_ON(cond)	({bool __r = (cond); __r; })
 #endif
 
+void cfg80211_cqm_config_free(struct wireless_dev *wdev);
+
 #endif /* __NET_WIRELESS_CORE_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b5f755b..6707ce2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9472,7 +9472,7 @@ static int nl80211_get_power_save(struct sk_buff *skb, struct genl_info *info)
 
 static const struct nla_policy
 nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1] = {
-	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_BINARY },
 	[NL80211_ATTR_CQM_RSSI_HYST] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_TXE_RATE] = { .type = NLA_U32 },
@@ -9501,28 +9501,126 @@ static int nl80211_set_cqm_txe(struct genl_info *info,
 	return rdev_set_cqm_txe_config(rdev, dev, rate, pkts, intvl);
 }
 
+static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
+				    struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	s32 last, low, high;
+	u32 hyst;
+	int i, n;
+	int err;
+
+	/* RSSI reporting disabled? */
+	if (!wdev->cqm_config)
+		return rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
+
+	/*
+	 * Obtain current RSSI value if possible, if not and no RSSI threshold
+	 * event has been received yet, we should receive an event after a
+	 * connection is established and enough beacons received to calculate
+	 * the average.
+	 */
+	if (!wdev->cqm_config->last_rssi_event_value && wdev->current_bss &&
+	    rdev->ops->get_station) {
+		struct station_info sinfo;
+		u8 *mac_addr;
+
+		mac_addr = wdev->current_bss->pub.bssid;
+
+		err = rdev_get_station(rdev, dev, mac_addr, &sinfo);
+		if (err)
+			return err;
+
+		if (sinfo.filled & BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG))
+			wdev->cqm_config->last_rssi_event_value =
+				(s8) sinfo.rx_beacon_signal_avg;
+	}
+
+	last = wdev->cqm_config->last_rssi_event_value;
+	hyst = wdev->cqm_config->rssi_hyst;
+	n = wdev->cqm_config->n_rssi_thresholds;
+
+	for (i = 0; i < n; i++)
+		if (last < wdev->cqm_config->rssi_thresholds[i])
+			break;
+
+	low = i > 0 ? wdev->cqm_config->rssi_thresholds[i - 1] : S32_MIN;
+	high = i < n ? wdev->cqm_config->rssi_thresholds[i] : S32_MAX;
+
+	if (last < (s32) (low + hyst))
+		low -= hyst;
+	if (last > (s32) (high - hyst))
+		high += hyst;
+
+	return rdev_set_cqm_rssi_range_config(rdev, dev, low, high - 1);
+}
+
 static int nl80211_set_cqm_rssi(struct genl_info *info,
-				s32 threshold, u32 hysteresis)
+				const s32 *thresholds, int n_thresholds,
+				u32 hysteresis)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int i, err;
+	s32 prev = S32_MIN;
 
-	if (threshold > 0)
-		return -EINVAL;
-
-	/* disabling - hysteresis should also be zero then */
-	if (threshold == 0)
-		hysteresis = 0;
+	/* Check all values negative and sorted */
+	for (i = 0; i < n_thresholds; i++) {
+		if (thresholds[i] > 0 || thresholds[i] <= prev)
+			return -EINVAL;
 
-	if (!rdev->ops->set_cqm_rssi_config)
-		return -EOPNOTSUPP;
+		prev = thresholds[i];
+	}
 
 	if (wdev->iftype != NL80211_IFTYPE_STATION &&
 	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
 		return -EOPNOTSUPP;
 
-	return rdev_set_cqm_rssi_config(rdev, dev, threshold, hysteresis);
+	wdev_lock(wdev);
+	cfg80211_cqm_config_free(wdev);
+	wdev_unlock(wdev);
+
+	if (n_thresholds <= 1 && rdev->ops->set_cqm_rssi_config) {
+		if (n_thresholds == 0 || thresholds[0] == 0) /* Disabling */
+			return rdev_set_cqm_rssi_config(rdev, dev, 0, 0);
+
+		return rdev_set_cqm_rssi_config(rdev, dev,
+						thresholds[0], hysteresis);
+	}
+
+	if (!wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_CQM_RSSI_LIST))
+		return -EOPNOTSUPP;
+
+	if (n_thresholds == 1 && thresholds[0] == 0) /* Disabling */
+		n_thresholds = 0;
+
+	wdev_lock(wdev);
+	if (n_thresholds) {
+		struct cfg80211_cqm_config *cqm_config;
+
+		cqm_config = kzalloc(sizeof(struct cfg80211_cqm_config) +
+				     n_thresholds * sizeof(s32), GFP_KERNEL);
+		if (!cqm_config) {
+			err = -ENOMEM;
+			goto unlock;
+		}
+
+		cqm_config->rssi_hyst = hysteresis;
+		cqm_config->n_rssi_thresholds = n_thresholds;
+		memcpy(cqm_config->rssi_thresholds, thresholds,
+		       n_thresholds * sizeof(s32));
+
+		wdev->cqm_config = cqm_config;
+	}
+
+	err = cfg80211_cqm_rssi_update(rdev, dev);
+
+unlock:
+	wdev_unlock(wdev);
+
+	return err;
 }
 
 static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
@@ -9542,10 +9640,16 @@ static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
 
 	if (attrs[NL80211_ATTR_CQM_RSSI_THOLD] &&
 	    attrs[NL80211_ATTR_CQM_RSSI_HYST]) {
-		s32 threshold = nla_get_s32(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
+		const s32 *thresholds =
+			nla_data(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
+		int len = nla_len(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
 		u32 hysteresis = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_HYST]);
 
-		return nl80211_set_cqm_rssi(info, threshold, hysteresis);
+		if (len % 4)
+			return -EINVAL;
+
+		return nl80211_set_cqm_rssi(info, thresholds, len / 4,
+					    hysteresis);
 	}
 
 	if (attrs[NL80211_ATTR_CQM_TXE_RATE] &&
@@ -13982,6 +14086,8 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      s32 rssi_level, gfp_t gfp)
 {
 	struct sk_buff *msg;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
 	trace_cfg80211_cqm_rssi_notify(dev, rssi_event, rssi_level);
 
@@ -13989,6 +14095,15 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 		    rssi_event != NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH))
 		return;
 
+	if (wdev->cqm_config) {
+		wdev->cqm_config->last_rssi_event_value = rssi_level;
+
+		cfg80211_cqm_rssi_update(rdev, dev);
+
+		if (rssi_level == 0)
+			rssi_level = wdev->cqm_config->last_rssi_event_value;
+	}
+
 	msg = cfg80211_prepare_cqm(dev, NULL, gfp);
 	if (!msg)
 		return;
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 2f42507..f2baf59 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -750,6 +750,18 @@ rdev_set_cqm_rssi_config(struct cfg80211_registered_device *rdev,
 }
 
 static inline int
+rdev_set_cqm_rssi_range_config(struct cfg80211_registered_device *rdev,
+			       struct net_device *dev, s32 low, s32 high)
+{
+	int ret;
+	trace_rdev_set_cqm_rssi_range_config(&rdev->wiphy, dev, low, high);
+	ret = rdev->ops->set_cqm_rssi_range_config(&rdev->wiphy, dev,
+						   low, high);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline int
 rdev_set_cqm_txe_config(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, u32 rate, u32 pkts, u32 intvl)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 776e80c..fd55786 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1322,6 +1322,28 @@ TRACE_EVENT(rdev_set_cqm_rssi_config,
 		 __entry->rssi_thold, __entry->rssi_hyst)
 );
 
+TRACE_EVENT(rdev_set_cqm_rssi_range_config,
+	TP_PROTO(struct wiphy *wiphy,
+		 struct net_device *netdev, s32 low, s32 high),
+	TP_ARGS(wiphy, netdev, low, high),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(s32, rssi_low)
+		__field(s32, rssi_high)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->rssi_low = low;
+		__entry->rssi_high = high;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT
+		  ", range: %d - %d ",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG,
+		  __entry->rssi_low, __entry->rssi_high)
+);
+
 TRACE_EVENT(rdev_set_cqm_txe_config,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u32 rate,
 		 u32 pkts, u32 intvl),
-- 
2.9.3
