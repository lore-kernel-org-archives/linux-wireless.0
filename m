Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36550 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbcKFCIz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Nov 2016 22:08:55 -0400
Received: by mail-wm0-f68.google.com with SMTP id c17so10103126wmc.3
        for <linux-wireless@vger.kernel.org>; Sat, 05 Nov 2016 19:08:54 -0700 (PDT)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/3][RFC] nl80211/mac80211: Accept multiple RSSI thresholds for CQM
Date: Sun,  6 Nov 2016 03:08:33 +0100
Message-Id: <1478398113-14966-4-git-send-email-andrew.zaborowski@intel.com> (sfid-20161106_030859_314479_A7E21BAD)
In-Reply-To: <1478398113-14966-1-git-send-email-andrew.zaborowski@intel.com>
References: <1478398113-14966-1-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the SET CQM command RSSI threshold attribute semantic to accept
any number of thresholds as a sorted array.  The API should be backwards
compatible so that if one s32 threshold value is passed, the old
mechanism is enabled.  The netlink event generated is the same too.

cfg80211 handles an arbitrary number of RSSI thresholds but drivers have
to provide a method (set_cqm_rssi_range_config) that configures a range
set by a high and a low value.  Drivers have to call back when the RSSI
goes out of that range and there's no additional event every time the
range is reconfigured.  There's no reason that the whole mechanism with
more than 2 thresholds couldn't be offloaded if the was hardware
available.

I added only a mac80211 implementation of the set_cqm_rssi_range_config
method as an illustration and because I can't run-time test any other
driver.  In this patch there's also no API for mac80211-based drivers
that do beacon filtering to offload this but that would be the intended
use.
---
 include/net/cfg80211.h       |  12 ++++
 include/net/mac80211.h       |   6 ++
 include/uapi/linux/nl80211.h |   4 +-
 net/mac80211/cfg.c           |  28 +++++++++
 net/mac80211/mlme.c          |  24 ++++++++
 net/wireless/core.c          |  13 ++++
 net/wireless/core.h          |   9 +++
 net/wireless/nl80211.c       | 137 +++++++++++++++++++++++++++++++++++++++----
 net/wireless/rdev-ops.h      |  12 ++++
 net/wireless/trace.h         |  22 +++++++
 10 files changed, 255 insertions(+), 12 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 632dce1..0105e86 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2604,6 +2604,10 @@ struct cfg80211_nan_func {
  *	the current level is above/below the configured threshold; this may
  *	need some care when the configuration is changed (without first being
  *	disabled.)
+ * @set_cqm_rssi_range_config: Configure two RSSI thresholds in the
+ *	connection quality monitor.  Even if the driver implements both the
+ *	single threshold and low/high thresholds mechanisms, it should assume
+ *	only one is active at any time.
  * @set_cqm_txe_config: Configure connection quality monitor TX error
  *	thresholds.
  * @sched_scan_start: Tell the driver to start a scheduled scan.
@@ -2887,6 +2891,10 @@ struct cfg80211_ops {
 				       struct net_device *dev,
 				       s32 rssi_thold, u32 rssi_hyst);
 
+	int	(*set_cqm_rssi_range_config)(struct wiphy *wiphy,
+					     struct net_device *dev,
+					     s32 rssi_low, s32 rssi_high);
+
 	int	(*set_cqm_txe_config)(struct wiphy *wiphy,
 				      struct net_device *dev,
 				      u32 rate, u32 pkts, u32 intvl);
@@ -3709,6 +3717,7 @@ void wiphy_free(struct wiphy *wiphy);
 struct cfg80211_conn;
 struct cfg80211_internal_bss;
 struct cfg80211_cached_keys;
+struct cfg80211_cqm_config;
 
 /**
  * struct wireless_dev - wireless device state
@@ -3769,6 +3778,7 @@ struct cfg80211_cached_keys;
  * @event_list: (private) list for internal event processing
  * @event_lock: (private) lock for event list
  * @owner_nlportid: (private) owner socket port ID
+ * @cqm_config: (private) nl80211 RSSI monitor state
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -3833,6 +3843,8 @@ struct wireless_dev {
 		bool prev_bssid_valid;
 	} wext;
 #endif
+
+	struct cfg80211_cqm_config *cqm_config;
 };
 
 static inline u8 *wdev_address(struct wireless_dev *wdev)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 33026e1..7da1056 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -502,6 +502,10 @@ struct ieee80211_mu_group_data {
  *	implies disabled. As with the cfg80211 callback, a change here should
  *	cause an event to be sent indicating where the current value is in
  *	relation to the newly configured threshold.
+ * @cqm_rssi_low: Connection quality monitor RSSI lower threshold, a zero value
+ *	implies disabled.  This is an alternative mechanism to the single
+ *	threshold event and can't be enabled simultaneously.
+ * @cqm_rssi_low: Connection quality monitor RSSI upper threshold.
  * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
  * @arp_addr_list: List of IPv4 addresses for hardware ARP filtering. The
  *	may filter ARP queries targeted for other addresses than listed here.
@@ -554,6 +558,8 @@ struct ieee80211_bss_conf {
 	u16 ht_operation_mode;
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
+	s32 cqm_rssi_low;
+	s32 cqm_rssi_high;
 	struct cfg80211_chan_def chandef;
 	struct ieee80211_mu_group_data mu_group;
 	__be32 arp_addr_list[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 48108fd..d632c6a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3839,7 +3839,9 @@ enum nl80211_ps_state {
  * @__NL80211_ATTR_CQM_INVALID: invalid
  * @NL80211_ATTR_CQM_RSSI_THOLD: RSSI threshold in dBm. This value specifies
  *	the threshold for the RSSI level at which an event will be sent. Zero
- *	to disable.
+ *	to disable.  Alternatively multiple values can be supplied as a
+ *	low-to-high sorted array of thresholds in dBm.  Events will be sent
+ *	when the RSSI value crosses any of the thresholds.
  * @NL80211_ATTR_CQM_RSSI_HYST: RSSI hysteresis in dBm. This value specifies
  *	the minimum amount the RSSI level must change after an event before a
  *	new event may be issued (to reduce effects of RSSI oscillation).
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fd6541f..6ac0523 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2647,6 +2647,33 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 
 	bss_conf->cqm_rssi_thold = rssi_thold;
 	bss_conf->cqm_rssi_hyst = rssi_hyst;
+	bss_conf->cqm_rssi_low = 0;
+	bss_conf->cqm_rssi_high = 0;
+	sdata->u.mgd.last_cqm_event_signal = 0;
+
+	/* tell the driver upon association, unless already associated */
+	if (sdata->u.mgd.associated &&
+	    sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
+
+	return 0;
+}
+
+static int ieee80211_set_cqm_rssi_range_config(struct wiphy *wiphy,
+					       struct net_device *dev,
+					       s32 rssi_low, s32 rssi_high)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_vif *vif = &sdata->vif;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+
+	if (sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)
+		return -EOPNOTSUPP;
+
+	bss_conf->cqm_rssi_low = rssi_low;
+	bss_conf->cqm_rssi_high = rssi_high;
+	bss_conf->cqm_rssi_thold = 0;
+	bss_conf->cqm_rssi_hyst = 0;
 	sdata->u.mgd.last_cqm_event_signal = 0;
 
 	/* tell the driver upon association, unless already associated */
@@ -3645,6 +3672,7 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.mgmt_tx = ieee80211_mgmt_tx,
 	.mgmt_tx_cancel_wait = ieee80211_mgmt_tx_cancel_wait,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
+	.set_cqm_rssi_range_config = ieee80211_set_cqm_rssi_range_config,
 	.mgmt_frame_register = ieee80211_mgmt_frame_register,
 	.set_antenna = ieee80211_set_antenna,
 	.get_antenna = ieee80211_get_antenna,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6898ecb..7f99918 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3416,6 +3416,30 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	if (bss_conf->cqm_rssi_low &&
+	    ifmgd->count_beacon_signal >= IEEE80211_SIGNAL_AVE_MIN_COUNT) {
+		int sig = -ewma_beacon_signal_read(&ifmgd->ave_beacon_signal);
+		int last_event = ifmgd->last_cqm_event_signal;
+		int low = bss_conf->cqm_rssi_low;
+		int high = bss_conf->cqm_rssi_high;
+
+		if (sig < low &&
+		    (last_event == 0 || last_event >= low)) {
+			ifmgd->last_cqm_event_signal = sig;
+			ieee80211_cqm_rssi_notify(
+				&sdata->vif,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+				sig, GFP_KERNEL);
+		} else if (sig > high &&
+			   (last_event == 0 || last_event <= high)) {
+			ifmgd->last_cqm_event_signal = sig;
+			ieee80211_cqm_rssi_notify(
+				&sdata->vif,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+				sig, GFP_KERNEL);
+		}
+	}
+
 	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL) {
 		mlme_dbg_ratelimited(sdata,
 				     "cancelling AP probe due to a received beacon\n");
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8201e6d..f6c1bf2 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -928,6 +928,16 @@ void wiphy_rfkill_set_hw_state(struct wiphy *wiphy, bool blocked)
 }
 EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
 
+void cfg80211_cqm_config_free(struct wireless_dev *wdev)
+{
+	if (!wdev->cqm_config)
+		return;
+
+	kfree(wdev->cqm_config->rssi_thresholds);
+	kfree(wdev->cqm_config);
+	wdev->cqm_config = NULL;
+}
+
 void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -954,6 +964,8 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 		WARN_ON_ONCE(1);
 		break;
 	}
+
+	cfg80211_cqm_config_free(wdev);
 }
 EXPORT_SYMBOL(cfg80211_unregister_wdev);
 
@@ -1205,6 +1217,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 #ifdef CONFIG_CFG80211_WEXT
 			kzfree(wdev->wext.keys);
 #endif
+			cfg80211_cqm_config_free(wdev);
 		}
 		/*
 		 * synchronise (so that we won't find this netdev
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 08d2e94..75fc334 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -270,6 +270,13 @@ struct cfg80211_iface_destroy {
 	u32 nlportid;
 };
 
+struct cfg80211_cqm_config {
+	s32 *rssi_thresholds;
+	int n_rssi_thresholds;
+	u32 rssi_hyst;
+	s32 last_rssi_event_value;
+};
+
 void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev);
 
 /* free object */
@@ -504,4 +511,6 @@ void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 #define CFG80211_DEV_WARN_ON(cond)	({bool __r = (cond); __r; })
 #endif
 
+void cfg80211_cqm_config_free(struct wireless_dev *wdev);
+
 #endif /* __NET_WIRELESS_CORE_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5d10774..907bd2a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9272,7 +9272,7 @@ static int nl80211_get_power_save(struct sk_buff *skb, struct genl_info *info)
 
 static const struct nla_policy
 nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1] = {
-	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_BINARY },
 	[NL80211_ATTR_CQM_RSSI_HYST] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_TXE_RATE] = { .type = NLA_U32 },
@@ -9301,28 +9301,127 @@ static int nl80211_set_cqm_txe(struct genl_info *info,
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
+	if (!wdev->cqm_config->last_rssi_event_value && wdev->current_bss) {
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
+	if (low > (s32) (last - hyst))
+		low = last - hyst;
+	if (high < (s32) (last + hyst))
+		high = last + hyst;
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
+	/* Check all values negative and sorted */
+	for (i = 0; i < n_thresholds; i++) {
+		if (thresholds[i] > 0 || thresholds[i] <= prev)
+			return -EINVAL;
+
+		prev = thresholds[i];
+	}
+
+	if (n_thresholds == 1 && thresholds[0] == 0)
+		n_thresholds = 0;
 
 	/* disabling - hysteresis should also be zero then */
-	if (threshold == 0)
+	if (n_thresholds == 0)
 		hysteresis = 0;
 
-	if (!rdev->ops->set_cqm_rssi_config)
-		return -EOPNOTSUPP;
-
 	if (wdev->iftype != NL80211_IFTYPE_STATION &&
 	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
 		return -EOPNOTSUPP;
 
-	return rdev_set_cqm_rssi_config(rdev, dev, threshold, hysteresis);
+	wdev_lock(wdev);
+	cfg80211_cqm_config_free(wdev);
+	wdev_unlock(wdev);
+
+	if (n_thresholds <= 1 && rdev->ops->set_cqm_rssi_config) {
+		const s32 disable = 0;
+
+		if (n_thresholds == 0) {
+			n_thresholds = 1;
+			thresholds = &disable;
+		}
+
+		return rdev_set_cqm_rssi_config(rdev, dev,
+						thresholds[0], hysteresis);
+	}
+
+	if (!rdev->ops->set_cqm_rssi_range_config || !rdev->ops->get_station)
+		return -EOPNOTSUPP;
+
+	wdev_lock(wdev);
+	if (n_thresholds) {
+		struct cfg80211_cqm_config *cqm_config;
+
+		cqm_config = kzalloc(sizeof(struct cfg80211_cqm_config),
+					   GFP_KERNEL);
+		cqm_config->rssi_thresholds =
+			kmemdup(thresholds, n_thresholds * sizeof(s32),
+				GFP_KERNEL);
+		cqm_config->n_rssi_thresholds = n_thresholds;
+		cqm_config->rssi_hyst = hysteresis;
+
+		wdev->cqm_config = cqm_config;
+	}
+
+	err = cfg80211_cqm_rssi_update(rdev, dev);
+
+	wdev_unlock(wdev);
+
+	return err;
 }
 
 static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
@@ -9342,10 +9441,15 @@ static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
 
 	if (attrs[NL80211_ATTR_CQM_RSSI_THOLD] &&
 	    attrs[NL80211_ATTR_CQM_RSSI_HYST]) {
-		s32 threshold = nla_get_s32(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
+		s32 *thresholds = nla_data(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
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
@@ -13741,6 +13845,8 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      s32 rssi_level, gfp_t gfp)
 {
 	struct sk_buff *msg;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
 	trace_cfg80211_cqm_rssi_notify(dev, rssi_event, rssi_level);
 
@@ -13748,6 +13854,15 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
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
index 11cf83c..ae180f3 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -726,6 +726,18 @@ rdev_set_cqm_rssi_config(struct cfg80211_registered_device *rdev,
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
index 6ac46a0..993f661 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1304,6 +1304,28 @@ TRACE_EVENT(rdev_set_cqm_rssi_config,
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
2.7.4
