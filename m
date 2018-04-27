Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52472 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755199AbeD0FaT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 01:30:19 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFCv2 1/6] cfg80211: Add support to configure station specific rssi threshold for AP mode
Date: Fri, 27 Apr 2018 11:00:31 +0530
Message-Id: <1524807036-28056-2-git-send-email-tamizhr@codeaurora.org> (sfid-20180427_073023_914999_68B52BFC)
In-Reply-To: <1524807036-28056-1-git-send-email-tamizhr@codeaurora.org>
References: <1524807036-28056-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add support to configure station specific rssi threshold
to monitor station's signal strength modification. This will be useful
for the user application like steering to configure and monitor the station's
signal strength change event.

New NL80211_CMD_STA_MON command introduced to cofigure single or multi
rssi thresholds using NL80211_ATTR_STA_MON_RSSI_THOLD and
NL80211_ATTR_STA_MON_RSSI_HYST.

cfg80211_sta_mon_rssi_notify introduce to notify station's signal strength
goes out of range using NL80211_CMD_NOTIFY_STA_MON command.

NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG flag needs to be advertised by the
drvier to allow single rssi threshold and hysteresis configuration.
NL80211_EXT_FEATURE_STA_MON_RSSI_LIST needs to be advertised to allow
multi rssi thresholds.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |  43 ++++-
 include/uapi/linux/nl80211.h |  62 +++++++
 net/wireless/core.c          |  26 ++-
 net/wireless/core.h          |   6 +-
 net/wireless/nl80211.c       | 388 +++++++++++++++++++++++++++++++++++++------
 net/wireless/rdev-ops.h      |  31 ++++
 net/wireless/trace.h         |  74 +++++++++
 7 files changed, 567 insertions(+), 63 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 250dac3..7e7a0bf 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2973,6 +2973,17 @@ struct cfg80211_external_auth_params {
  *
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
  *	tells the driver that the frame should not be encrypted.
+ * @set_sta_mon_rssi_config: Configure  RSSI threshold for a station.
+ *	After configuration, the driver should (soon) send an event indicating
+ *	the current level of a station is above/below the configured threshold;
+ *	this may need some care when the configuration is changed
+ *	(without first being disabled.)
+ * @set_sta_mon_rssi_range_config: Configure two RSSI thresholds in the
+ *	station's rssi monitor.  An event is to be sent only when the
+ *	signal level of a station is found to be outside the two values.
+ *	The driver should set %NL80211_EXT_FEATURE_STA_MON_RSSI_LIST if this
+ *	method is implemented. If it is provided then there's no point providing
+ *	@set_sta_mon_rssi_config.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3274,6 +3285,14 @@ struct cfg80211_ops {
 				   const u8 *buf, size_t len,
 				   const u8 *dest, const __be16 proto,
 				   const bool noencrypt);
+	int     (*set_sta_mon_rssi_config)(struct wiphy *wiphy,
+					    struct net_device *dev,
+					    const u8 *addr,
+					    s32 rssi_thold, u32 rssi_hyst);
+	int     (*set_sta_mon_rssi_range_config)(struct wiphy *wiphy,
+						 struct net_device *dev,
+						 const u8 *addr,
+						 s32 rssi_low, s32 rssi_high);
 };
 
 /*
@@ -4076,7 +4095,7 @@ static inline struct wiphy *wiphy_new(const struct cfg80211_ops *ops,
 struct cfg80211_conn;
 struct cfg80211_internal_bss;
 struct cfg80211_cached_keys;
-struct cfg80211_cqm_config;
+struct cfg80211_rssi_config;
 
 /**
  * struct wireless_dev - wireless device state
@@ -4141,7 +4160,8 @@ static inline struct wiphy *wiphy_new(const struct cfg80211_ops *ops,
  * @event_lock: (private) lock for event list
  * @owner_nlportid: (private) owner socket port ID
  * @nl_owner_dead: (private) owner socket went away
- * @cqm_config: (private) nl80211 RSSI monitor state
+ * @rssi_config: (private) nl80211 RSSI monitor state
+ * @rssi_config_list: list of peer address based rssi configuration
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -4212,7 +4232,8 @@ struct wireless_dev {
 	} wext;
 #endif
 
-	struct cfg80211_cqm_config *cqm_config;
+	struct cfg80211_rssi_config *rssi_config;
+	struct list_head rssi_config_list;
 };
 
 static inline u8 *wdev_address(struct wireless_dev *wdev)
@@ -5776,6 +5797,22 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      s32 rssi_level, gfp_t gfp);
 
 /**
+ * cfg80211_sta_mon_rssi_notify - Station's rssi out of range event
+ * @dev: network device
+ * @peer: Station's mac address
+ * @rssi_event: the triggered RSSI event
+ * @rssi_level: new RSSI level value or 0 if not available
+ * @gfp: context flags
+ *
+ * This function is called when a configured rssi threshold reached event
+ * occurs for a station.
+ */
+void
+cfg80211_sta_mon_rssi_notify(struct net_device *dev, const u8 *peer,
+		     enum nl80211_sta_mon_rssi_threshold_event rssi_event,
+		     s32 rssi_level, gfp_t gfp);
+
+/**
  * cfg80211_cqm_pktloss_notify - notify userspace about packetloss to peer
  * @dev: network device
  * @peer: peer's MAC address
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9c36301..fa1fed1 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1029,6 +1029,11 @@
  *	ht opmode or vht opmode changes using any of &NL80211_ATTR_SMPS_MODE,
  *	&NL80211_ATTR_CHANNEL_WIDTH,&NL80211_ATTR_NSS attributes with its
  *	address(specified in &NL80211_ATTR_MAC).
+ * @NL80211_CMD_SET_STA_MON: This command is used to configure station's
+ *	connection monitoring notification trigger levels.
+ * @NL80211_CMD_NOTIFY_STA_MON: Station's connection monitor notification. This
+ *	command is used as an event to indicate the that a trigger level was
+ *	reached for a station.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1242,6 +1247,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_CONTROL_PORT_FRAME,
 
+	NL80211_CMD_STA_MON,
+	NL80211_CMD_NOTIFY_STA_MON,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2225,6 +2233,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_NSS: Station's New/updated  RX_NSS value notified using this
  *	u8 attribute. This is used with %NL80211_CMD_STA_OPMODE_CHANGED.
  *
+ * @NL80211_ATTR_STA_MON: Station's connection monitor configuration in a
+ *	nested attribute with %NL80211_ATTR_STA_MON_* sub-attributes.
+ *
+ * @NL80211_ATTR_LOCAL_STATE_CHANGE: Flag attribute to indicate that a command
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2659,6 +2671,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_CONTROL_PORT_OVER_NL80211,
 
+	NL80211_ATTR_STA_MON,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4238,6 +4252,34 @@ enum nl80211_attr_cqm {
 };
 
 /**
+ * enum nl80211_attr_sta_mon - Attributes to monitor station's connection
+ * @NL80211_ATTR_STA_MON_RSSI_THOLD: RSSI threshold in dBm. This value specifies
+ *	the threshold for the RSSI level at which an event will be sent. Zero
+ *	to disable.  Alternatively, if %NL80211_EXT_FEATURE_STA_MON_RSSI_LIST is
+ *	set, multiple values can be supplied as a low-to-high sorted array of
+ *	threshold values in dBm.  Events will be sent when the RSSI value
+ *	crosses any of the thresholds. This threshold values are station
+ *	spcific.
+ * @NL80211_ATTR_STA_MON_RSSI_HYST: RSSI hysteresis in dBm. This value specifies
+ *	the minimum amount the RSSI level must change after an event before a
+ *	new event may be issued (to reduce effects of RSSI oscillation).
+ * @NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT: RSSI threshold event
+ * @NL80211_ATTR_STA_MON_RSSI_LEVEL: the RSSI value in dBm that triggered the
+ *	RSSI threshold event.
+ */
+enum nl80211_attr_sta_mon {
+	__NL80211_ATTR_STA_MON_INVALID,
+	NL80211_ATTR_STA_MON_RSSI_THOLD,
+	NL80211_ATTR_STA_MON_RSSI_HYST,
+	NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT,
+	NL80211_ATTR_STA_MON_RSSI_LEVEL,
+
+	/* keep last */
+	__NL80211_ATTR_STA_MON_AFTER_LAST,
+	NL80211_ATTR_STA_MON_MAX = __NL80211_ATTR_STA_MON_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_cqm_rssi_threshold_event - RSSI threshold event
  * @NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW: The RSSI level is lower than the
  *      configured threshold
@@ -4251,6 +4293,18 @@ enum nl80211_cqm_rssi_threshold_event {
 	NL80211_CQM_RSSI_BEACON_LOSS_EVENT,
 };
 
+/**
+ * enum nl80211_sta_mon_rssi_threshold_event - RSSI threshold event
+ * @NL80211_STA_MON_RSSI_THRESHOLD_EVENT_LOW: The RSSI level is lower than the
+ *      configured threshold
+ * @NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH: The RSSI is higher than the
+ *      configured threshold
+ */
+enum nl80211_sta_mon_rssi_threshold_event {
+	NL80211_STA_MON_RSSI_THRESHOLD_EVENT_LOW,
+	NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH,
+};
+
 
 /**
  * enum nl80211_tx_power_setting - TX power adjustment
@@ -5040,6 +5094,12 @@ enum nl80211_feature_flags {
  *	"radar detected" event.
  * @NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211: Driver supports sending and
  *	receiving control port frames over nl80211 instead of the netdevice.
+ * @NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG: With this driver can set
+ *	rssi threshold using %NL80211_ATTR_STA_MON_RSSI_THOLD attribute
+ *	for a connected station.
+ * @NL80211_EXT_FEATURE_STA_MON_RSSI_LIST: With this driver the
+ *	%NL80211_ATTR_STA_MON_RSSI_THOLD attribute accepts a list of zero or
+ *	more RSSI threshold values to monitor rather than exactly one threshold.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5072,6 +5132,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN,
 	NL80211_EXT_FEATURE_DFS_OFFLOAD,
 	NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211,
+	NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG,
+	NL80211_EXT_FEATURE_STA_MON_RSSI_LIST,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index c0fd8a8..7933337 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -990,10 +990,25 @@ void wiphy_rfkill_set_hw_state(struct wiphy *wiphy, bool blocked)
 }
 EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
 
-void cfg80211_cqm_config_free(struct wireless_dev *wdev)
+void cfg80211_rssi_config_free(struct wireless_dev *wdev)
 {
-	kfree(wdev->cqm_config);
-	wdev->cqm_config = NULL;
+	struct cfg80211_rssi_config *rssi_config, *tmp;
+
+	if (list_empty(&wdev->rssi_config_list))
+		goto free;
+
+	list_for_each_entry_safe(rssi_config, tmp, &wdev->rssi_config_list,
+				 list) {
+		list_del(&rssi_config->list);
+		kfree(rssi_config);
+		if (list_empty(&wdev->rssi_config_list))
+			goto out;
+	}
+
+free:
+	kfree(wdev->rssi_config);
+out:
+	wdev->rssi_config = NULL;
 }
 
 void cfg80211_unregister_wdev(struct wireless_dev *wdev)
@@ -1023,7 +1038,7 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 		break;
 	}
 
-	cfg80211_cqm_config_free(wdev);
+	cfg80211_rssi_config_free(wdev);
 }
 EXPORT_SYMBOL(cfg80211_unregister_wdev);
 
@@ -1159,6 +1174,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		spin_lock_init(&wdev->event_lock);
 		INIT_LIST_HEAD(&wdev->mgmt_registrations);
 		spin_lock_init(&wdev->mgmt_registrations_lock);
+		INIT_LIST_HEAD(&wdev->rssi_config_list);
 
 		/*
 		 * We get here also when the interface changes network namespaces,
@@ -1288,7 +1304,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			kzfree(wdev->wext.keys);
 #endif
 			flush_work(&wdev->disconnect_wk);
-			cfg80211_cqm_config_free(wdev);
+			cfg80211_rssi_config_free(wdev);
 		}
 		/*
 		 * synchronise (so that we won't find this netdev
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 63eb1b5..17883ec 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -260,10 +260,12 @@ struct cfg80211_beacon_registration {
 	u32 nlportid;
 };
 
-struct cfg80211_cqm_config {
+struct cfg80211_rssi_config {
+	struct list_head list;
 	u32 rssi_hyst;
 	s32 last_rssi_event_value;
 	int n_rssi_thresholds;
+	u8 addr[ETH_ALEN];
 	s32 rssi_thresholds[0];
 };
 
@@ -514,6 +516,6 @@ void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 #define CFG80211_DEV_WARN_ON(cond)	({bool __r = (cond); __r; })
 #endif
 
-void cfg80211_cqm_config_free(struct wireless_dev *wdev);
+void cfg80211_rssi_config_free(struct wireless_dev *wdev);
 
 #endif /* __NET_WIRELESS_CORE_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a052693..382dc63 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -423,6 +423,7 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_PMK] = { .type = NLA_BINARY, .len = PMK_MAX_LEN },
 	[NL80211_ATTR_SCHED_SCAN_MULTI] = { .type = NLA_FLAG },
 	[NL80211_ATTR_EXTERNAL_AUTH_SUPPORT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_STA_MON] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -3043,6 +3044,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		spin_lock_init(&wdev->event_lock);
 		INIT_LIST_HEAD(&wdev->mgmt_registrations);
 		spin_lock_init(&wdev->mgmt_registrations_lock);
+		INIT_LIST_HEAD(&wdev->rssi_config_list);
 
 		wdev->identifier = ++rdev->wdev_id;
 		list_add_rcu(&wdev->list, &rdev->wiphy.wdev_list);
@@ -9864,6 +9866,14 @@ static int nl80211_get_power_save(struct sk_buff *skb, struct genl_info *info)
 	[NL80211_ATTR_CQM_RSSI_LEVEL] = { .type = NLA_S32 },
 };
 
+static const struct nla_policy
+nl80211_attr_sta_mon_policy[NL80211_ATTR_STA_MON_MAX + 1] = {
+	[NL80211_ATTR_STA_MON_RSSI_THOLD] = { .type = NLA_BINARY },
+	[NL80211_ATTR_STA_MON_RSSI_HYST] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON_RSSI_LEVEL] = { .type = NLA_S32 },
+};
+
 static int nl80211_set_cqm_txe(struct genl_info *info,
 			       u32 rate, u32 pkts, u32 intvl)
 {
@@ -9884,17 +9894,65 @@ static int nl80211_set_cqm_txe(struct genl_info *info,
 	return rdev_set_cqm_txe_config(rdev, dev, rate, pkts, intvl);
 }
 
+static int cfg80211_set_rssi_range(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev, const u8 *mac_addr,
+				   bool get_last_rssi)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	s32 low, high, last;
+	u32 hyst;
+	int i, n, err;
+
+	if (get_last_rssi && mac_addr) {
+		struct station_info sinfo = {};
+
+		err = rdev_get_station(rdev, dev, mac_addr, &sinfo);
+		if (err)
+			return err;
+
+		if (wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT) {
+			if (sinfo.filled & BIT(NL80211_STA_INFO_SIGNAL_AVG))
+				wdev->rssi_config->last_rssi_event_value =
+					(s8)sinfo.signal_avg;
+		} else {
+			if (sinfo.filled &
+			    BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG))
+				wdev->rssi_config->last_rssi_event_value =
+						(s8)sinfo.rx_beacon_signal_avg;
+		}
+	}
+
+	last = wdev->rssi_config->last_rssi_event_value;
+	hyst = wdev->rssi_config->rssi_hyst;
+	n = wdev->rssi_config->n_rssi_thresholds;
+
+	for (i = 0; i < n; i++) {
+		if (last < wdev->rssi_config->rssi_thresholds[i])
+			break;
+	}
+
+	low = i > 0 ?
+		(wdev->rssi_config->rssi_thresholds[i - 1] - hyst) : S32_MIN;
+	high = i < n ?
+		(wdev->rssi_config->rssi_thresholds[i] + hyst - 1) : S32_MAX;
+
+	if (wdev->iftype == NL80211_IFTYPE_STATION ||
+	    wdev->iftype == NL80211_IFTYPE_P2P_CLIENT)
+		return rdev_set_cqm_rssi_range_config(rdev, dev, low, high);
+
+	return rdev_set_sta_mon_rssi_range_config(rdev, dev, mac_addr,
+						  low, high);
+}
+
 static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
 				    struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	s32 last, low, high;
-	u32 hyst;
-	int i, n;
-	int err;
+	u8 *mac_addr = NULL;
 
 	/* RSSI reporting disabled? */
-	if (!wdev->cqm_config)
+	if (!wdev->rssi_config)
 		return rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
 
 	/*
@@ -9903,36 +9961,62 @@ static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
 	 * connection is established and enough beacons received to calculate
 	 * the average.
 	 */
-	if (!wdev->cqm_config->last_rssi_event_value && wdev->current_bss &&
-	    rdev->ops->get_station) {
-		struct station_info sinfo = {};
-		u8 *mac_addr;
-
+	if (!wdev->rssi_config->last_rssi_event_value && wdev->current_bss &&
+	    rdev->ops->get_station)
 		mac_addr = wdev->current_bss->pub.bssid;
 
-		err = rdev_get_station(rdev, dev, mac_addr, &sinfo);
-		if (err)
-			return err;
+	return cfg80211_set_rssi_range(rdev, dev, mac_addr,
+				!wdev->rssi_config->last_rssi_event_value);
+}
 
-		if (sinfo.filled & BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG))
-			wdev->cqm_config->last_rssi_event_value =
-				(s8) sinfo.rx_beacon_signal_avg;
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
 	}
 
-	last = wdev->cqm_config->last_rssi_event_value;
-	hyst = wdev->cqm_config->rssi_hyst;
-	n = wdev->cqm_config->n_rssi_thresholds;
+	return 0;
+}
 
-	for (i = 0; i < n; i++)
-		if (last < wdev->cqm_config->rssi_thresholds[i])
+static struct cfg80211_rssi_config *
+cfg80211_get_rssi_config(struct wireless_dev *wdev, const s32 *thresholds,
+			 int n_thresholds, u32 hysteresis, const u8 *peer)
+{
+	struct cfg80211_rssi_config *rssi_config;
+
+	if (!peer)
+		return NULL;
+
+	if (list_empty(&wdev->rssi_config_list))
+		goto new;
+
+	list_for_each_entry(rssi_config, &wdev->rssi_config_list, list) {
+		if (!memcmp(rssi_config->addr, peer, ETH_ALEN)) {
+			list_del(&rssi_config->list);
+			kfree(rssi_config);
 			break;
+		}
+	}
 
-	low = i > 0 ?
-		(wdev->cqm_config->rssi_thresholds[i - 1] - hyst) : S32_MIN;
-	high = i < n ?
-		(wdev->cqm_config->rssi_thresholds[i] + hyst - 1) : S32_MAX;
+new:
+	rssi_config = kzalloc(sizeof(struct cfg80211_rssi_config) +
+			      n_thresholds * sizeof(s32), GFP_KERNEL);
+	if (!rssi_config)
+		return NULL;
 
-	return rdev_set_cqm_rssi_range_config(rdev, dev, low, high);
+	rssi_config->rssi_hyst = hysteresis;
+	rssi_config->n_rssi_thresholds = n_thresholds;
+	memcpy(rssi_config->addr, peer, ETH_ALEN);
+	memcpy(rssi_config->rssi_thresholds, thresholds,
+	       n_thresholds * sizeof(s32));
+	return rssi_config;
 }
 
 static int nl80211_set_cqm_rssi(struct genl_info *info,
@@ -9942,23 +10026,19 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	int i, err;
-	s32 prev = S32_MIN;
+	int err;
 
-	/* Check all values negative and sorted */
-	for (i = 0; i < n_thresholds; i++) {
-		if (thresholds[i] > 0 || thresholds[i] <= prev)
-			return -EINVAL;
+	err = nl80211_validate_rssi_tholds(thresholds, n_thresholds);
 
-		prev = thresholds[i];
-	}
+	if (err)
+		return err;
 
 	if (wdev->iftype != NL80211_IFTYPE_STATION &&
 	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
 		return -EOPNOTSUPP;
 
 	wdev_lock(wdev);
-	cfg80211_cqm_config_free(wdev);
+	cfg80211_rssi_config_free(wdev);
 	wdev_unlock(wdev);
 
 	if (n_thresholds <= 1 && rdev->ops->set_cqm_rssi_config) {
@@ -9977,26 +10057,22 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 		n_thresholds = 0;
 
 	wdev_lock(wdev);
-	if (n_thresholds) {
-		struct cfg80211_cqm_config *cqm_config;
+	if (n_thresholds)
+		wdev->rssi_config = cfg80211_get_rssi_config(
+						wdev, thresholds,
+						n_thresholds, hysteresis,
+						wdev->current_bss->pub.bssid);
 
-		cqm_config = kzalloc(sizeof(struct cfg80211_cqm_config) +
-				     n_thresholds * sizeof(s32), GFP_KERNEL);
-		if (!cqm_config) {
-			err = -ENOMEM;
-			goto unlock;
-		}
-
-		cqm_config->rssi_hyst = hysteresis;
-		cqm_config->n_rssi_thresholds = n_thresholds;
-		memcpy(cqm_config->rssi_thresholds, thresholds,
-		       n_thresholds * sizeof(s32));
-
-		wdev->cqm_config = cqm_config;
+	if (!wdev->rssi_config) {
+		err = -ENOMEM;
+		goto unlock;
 	}
 
 	err = cfg80211_cqm_rssi_update(rdev, dev);
 
+	if (!err)
+		list_add(&wdev->rssi_config->list, &wdev->rssi_config_list);
+
 unlock:
 	wdev_unlock(wdev);
 
@@ -12642,6 +12718,103 @@ static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_set_sta_mon_rssi(struct genl_info *info,
+				    const u8 *peer, const s32 *thresholds,
+				    int n_thresholds, u32 hysteresis)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	if ((wdev->iftype != NL80211_IFTYPE_AP &&
+	     wdev->iftype != NL80211_IFTYPE_P2P_GO &&
+	     wdev->iftype != NL80211_IFTYPE_AP_VLAN) ||
+	    !wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG))
+		return -EOPNOTSUPP;
+
+	err = nl80211_validate_rssi_tholds(thresholds, n_thresholds);
+
+	if (err)
+		return err;
+
+	if (n_thresholds <= 1 && rdev->ops->set_sta_mon_rssi_config) {
+		if (n_thresholds == 0 || thresholds[0] == 0)
+			return rdev_set_sta_mon_rssi_config(rdev, dev,
+					peer, 0, 0);
+		return rdev_set_sta_mon_rssi_config(rdev, dev, peer,
+				thresholds[0], hysteresis);
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
+
+	if (!wdev->rssi_config) {
+		err = -ENOMEM;
+		goto unlock;
+	}
+
+	err = cfg80211_set_rssi_range(rdev, dev, peer,
+				!wdev->rssi_config->last_rssi_event_value);
+
+	if (!err)
+		list_add(&wdev->rssi_config->list, &wdev->rssi_config_list);
+unlock:
+	wdev_unlock(wdev);
+	return err;
+}
+
+static int nl80211_sta_mon(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *attrs[NL80211_ATTR_STA_MON_MAX + 1];
+	struct nlattr *sta_mon;
+	u8 *addr = NULL;
+	int err;
+
+	sta_mon = info->attrs[NL80211_ATTR_STA_MON];
+	if (!sta_mon || !(info->attrs[NL80211_ATTR_MAC]))
+		return -EINVAL;
+
+	err = nla_parse_nested(attrs, NL80211_ATTR_STA_MON_MAX,
+			       sta_mon, nl80211_attr_sta_mon_policy,
+			       info->extack);
+
+	if (err)
+		return err;
+
+	addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (attrs[NL80211_ATTR_STA_MON_RSSI_THOLD] &&
+	    attrs[NL80211_ATTR_STA_MON_RSSI_HYST]) {
+		const s32 *tholds =
+			nla_data(attrs[NL80211_ATTR_STA_MON_RSSI_THOLD]);
+		int len = nla_len(attrs[NL80211_ATTR_STA_MON_RSSI_THOLD]);
+		u32 hysteresis =
+			nla_get_u32(attrs[NL80211_ATTR_STA_MON_RSSI_HYST]);
+
+		if (len % 4)
+			return -EINVAL;
+
+		return nl80211_set_sta_mon_rssi(info, addr, tholds, len / 4,
+				hysteresis);
+	}
+
+	return -EINVAL;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -13553,6 +13726,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_STA_MON,
+		.doit = nl80211_sta_mon,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
@@ -14725,6 +14906,107 @@ bool cfg80211_rx_control_port(struct net_device *dev,
 }
 EXPORT_SYMBOL(cfg80211_rx_control_port);
 
+static struct sk_buff *cfg80211_prepare_sta_mon(struct net_device *dev,
+						const char *mac, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct sk_buff *msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	void **cb;
+
+	if (!msg)
+		return NULL;
+
+	cb = (void **)msg->cb;
+
+	cb[0] = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NOTIFY_STA_MON);
+	if (!cb[0]) {
+		nlmsg_free(msg);
+		return NULL;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex))
+		goto nla_put_failure;
+
+	if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac))
+		goto nla_put_failure;
+
+	cb[1] = nla_nest_start(msg, NL80211_ATTR_STA_MON);
+	if (!cb[1])
+		goto nla_put_failure;
+
+	cb[2] = rdev;
+
+	return msg;
+nla_put_failure:
+	nlmsg_free(msg);
+	return NULL;
+}
+
+static void cfg80211_send_sta_mon(struct sk_buff *msg, gfp_t gfp)
+{
+	void **cb = (void **)msg->cb;
+	struct cfg80211_registered_device *rdev = cb[2];
+
+	nla_nest_end(msg, cb[1]);
+	genlmsg_end(msg, cb[0]);
+
+	memset(msg->cb, 0, sizeof(msg->cb));
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, gfp);
+}
+
+void cfg80211_sta_mon_rssi_notify(struct net_device *dev, const u8 *peer,
+			  enum nl80211_sta_mon_rssi_threshold_event rssi_event,
+			  s32 rssi_level, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct cfg80211_rssi_config *rssi_config;
+
+	if (WARN_ON(!peer))
+		return;
+
+	if (WARN_ON(rssi_event != NL80211_STA_MON_RSSI_THRESHOLD_EVENT_LOW &&
+		    rssi_event != NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH))
+		return;
+
+	trace_cfg80211_sta_mon_rssi_notify(dev, peer, rssi_event, rssi_level);
+
+	list_for_each_entry(rssi_config, &wdev->rssi_config_list, list) {
+		if (!memcmp(rssi_config->addr, peer, ETH_ALEN)) {
+			wdev->rssi_config = rssi_config;
+			wdev->rssi_config->last_rssi_event_value = rssi_level;
+			cfg80211_set_rssi_range(rdev, dev, peer,
+				!wdev->rssi_config->last_rssi_event_value);
+			break;
+		}
+	}
+
+	msg = cfg80211_prepare_sta_mon(dev, peer, gfp);
+	if (!msg)
+		return;
+
+	if (nla_put_u32(msg, NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT,
+			rssi_event))
+		goto nla_put_failure;
+
+	if (rssi_level && nla_put_s32(msg, NL80211_ATTR_STA_MON_RSSI_LEVEL,
+				      rssi_level))
+		goto nla_put_failure;
+
+	cfg80211_send_sta_mon(msg, gfp);
+
+	return;
+
+ nla_put_failure:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_sta_mon_rssi_notify);
+
 static struct sk_buff *cfg80211_prepare_cqm(struct net_device *dev,
 					    const char *mac, gfp_t gfp)
 {
@@ -14791,13 +15073,13 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 		    rssi_event != NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH))
 		return;
 
-	if (wdev->cqm_config) {
-		wdev->cqm_config->last_rssi_event_value = rssi_level;
+	if (wdev->rssi_config) {
+		wdev->rssi_config->last_rssi_event_value = rssi_level;
 
 		cfg80211_cqm_rssi_update(rdev, dev);
 
 		if (rssi_level == 0)
-			rssi_level = wdev->cqm_config->last_rssi_event_value;
+			rssi_level = wdev->rssi_config->last_rssi_event_value;
 	}
 
 	msg = cfg80211_prepare_cqm(dev, NULL, gfp);
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 87479a5..47562b9 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1220,4 +1220,35 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_sta_mon_rssi_config(struct cfg80211_registered_device *rdev,
+			     struct net_device *dev, const u8 *peer,
+			     s32 rssi_tholds, u32 rssi_hyst)
+
+{
+	int ret;
+
+	trace_rdev_set_sta_mon_rssi_config(&rdev->wiphy, dev, peer,
+					   rssi_tholds, rssi_hyst);
+	ret = rdev->ops->set_sta_mon_rssi_config(&rdev->wiphy, dev, peer,
+						 rssi_tholds, rssi_hyst);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
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
index 55fb279..78ff0f2 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1340,6 +1340,56 @@
 		  __entry->rssi_low, __entry->rssi_high)
 );
 
+TRACE_EVENT(rdev_set_sta_mon_rssi_config,
+	TP_PROTO(struct wiphy *wiphy,
+		 struct net_device *netdev, const u8 *peer,
+		 s32 rssi_thold, u32 rssi_hyst),
+	TP_ARGS(wiphy, netdev, peer, rssi_thold, rssi_hyst),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(s32, rssi_thold)
+		__field(u32, rssi_hyst)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->rssi_thold = rssi_thold;
+		__entry->rssi_hyst = rssi_hyst;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT
+		  ", rssi_thold: %d, rssi_hyst: %u ",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer),
+		  __entry->rssi_thold, __entry->rssi_hyst)
+);
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
 TRACE_EVENT(rdev_set_cqm_txe_config,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u32 rate,
 		 u32 pkts, u32 intvl),
@@ -3243,6 +3293,30 @@
 		  WIPHY_PR_ARG, NETDEV_PR_ARG,
 		  BOOL_TO_STR(__entry->enabled))
 );
+
+TRACE_EVENT(cfg80211_sta_mon_rssi_notify,
+	TP_PROTO(struct net_device *netdev, const u8 *peer,
+		 enum nl80211_sta_mon_rssi_threshold_event rssi_event,
+		 s32 rssi_level),
+	TP_ARGS(netdev, peer, rssi_event, rssi_level),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(enum nl80211_sta_mon_rssi_threshold_event, rssi_event)
+		__field(s32, rssi_level)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->rssi_event = rssi_event;
+		__entry->rssi_level = rssi_level;
+	),
+	TP_printk(NETDEV_PR_FMT ", peer: " MAC_PR_FMT
+		  ", rssi event: %d, rssi : %d",
+		  NETDEV_PR_ARG, MAC_PR_ARG(peer),
+		  __entry->rssi_event, __entry->rssi_level)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.9.1
