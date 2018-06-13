Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47482 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933498AbeFMKqN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 06:46:13 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 1/7] wireless: Change single cqm_config to rssi config list
Date: Wed, 13 Jun 2018 16:15:41 +0530
Message-Id: <1528886747-26342-2-git-send-email-tamizhr@codeaurora.org> (sfid-20180613_124622_685891_F302CEF7)
In-Reply-To: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes single cqm_config into mac address based
rssi config list. This way the same structure can be
utilized by AP mode as well.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h |    8 ++++--
 net/wireless/core.c    |   29 +++++++++++++++----
 net/wireless/core.h    |    6 ++--
 net/wireless/nl80211.c |   74 ++++++++++++++++++++++++++++++++----------------
 4 files changed, 82 insertions(+), 35 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5fbfe61..3e123a3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4139,7 +4139,7 @@ static inline struct wiphy *wiphy_new(const struct cfg80211_ops *ops,
 struct cfg80211_conn;
 struct cfg80211_internal_bss;
 struct cfg80211_cached_keys;
-struct cfg80211_cqm_config;
+struct cfg80211_rssi_config;
 
 /**
  * struct wireless_dev - wireless device state
@@ -4204,7 +4204,8 @@ static inline struct wiphy *wiphy_new(const struct cfg80211_ops *ops,
  * @event_lock: (private) lock for event list
  * @owner_nlportid: (private) owner socket port ID
  * @nl_owner_dead: (private) owner socket went away
- * @cqm_config: (private) nl80211 RSSI monitor state
+ * @rssi_config: (private) nl80211 RSSI monitor state
+ * @rssi_config_list: (private) peer based list for rssi config
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -4275,7 +4276,8 @@ struct wireless_dev {
 	} wext;
 #endif
 
-	struct cfg80211_cqm_config *cqm_config;
+	struct cfg80211_rssi_config *rssi_config;
+	struct list_head rssi_config_list;
 };
 
 static inline u8 *wdev_address(struct wireless_dev *wdev)
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5fe35aa..62e496e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -994,10 +994,28 @@ void wiphy_rfkill_set_hw_state(struct wiphy *wiphy, bool blocked)
 }
 EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
 
-void cfg80211_cqm_config_free(struct wireless_dev *wdev)
+void cfg80211_rssi_config_free(struct wireless_dev *wdev, const u8 *peer)
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
+		if (peer && memcmp(rssi_config->addr, peer, ETH_ALEN))
+			continue;
+
+		list_del(&rssi_config->list);
+		kfree(rssi_config);
+		if (list_empty(&wdev->rssi_config_list) || peer)
+			goto out;
+	}
+
+free:
+	kfree(wdev->rssi_config);
+out:
+	wdev->rssi_config = NULL;
 }
 
 void cfg80211_unregister_wdev(struct wireless_dev *wdev)
@@ -1027,7 +1045,7 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 		break;
 	}
 
-	cfg80211_cqm_config_free(wdev);
+	cfg80211_rssi_config_free(wdev, NULL);
 }
 EXPORT_SYMBOL(cfg80211_unregister_wdev);
 
@@ -1163,6 +1181,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		spin_lock_init(&wdev->event_lock);
 		INIT_LIST_HEAD(&wdev->mgmt_registrations);
 		spin_lock_init(&wdev->mgmt_registrations_lock);
+		INIT_LIST_HEAD(&wdev->rssi_config_list);
 
 		/*
 		 * We get here also when the interface changes network namespaces,
@@ -1292,7 +1311,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			kzfree(wdev->wext.keys);
 #endif
 			flush_work(&wdev->disconnect_wk);
-			cfg80211_cqm_config_free(wdev);
+			cfg80211_rssi_config_free(wdev, NULL);
 		}
 		/*
 		 * synchronise (so that we won't find this netdev
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 63eb1b5..170a31b 100644
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
+void cfg80211_rssi_config_free(struct wireless_dev *wdev, const u8 *peer);
 
 #endif /* __NET_WIRELESS_CORE_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 07514ca..2fb2e97 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3200,6 +3200,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		spin_lock_init(&wdev->event_lock);
 		INIT_LIST_HEAD(&wdev->mgmt_registrations);
 		spin_lock_init(&wdev->mgmt_registrations_lock);
+		INIT_LIST_HEAD(&wdev->rssi_config_list);
 
 		wdev->identifier = ++rdev->wdev_id;
 		list_add_rcu(&wdev->list, &rdev->wiphy.wdev_list);
@@ -10140,7 +10141,7 @@ static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
 	int err;
 
 	/* RSSI reporting disabled? */
-	if (!wdev->cqm_config)
+	if (!wdev->rssi_config)
 		return rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
 
 	/*
@@ -10149,7 +10150,7 @@ static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
 	 * connection is established and enough beacons received to calculate
 	 * the average.
 	 */
-	if (!wdev->cqm_config->last_rssi_event_value && wdev->current_bss &&
+	if (!wdev->rssi_config->last_rssi_event_value && wdev->current_bss &&
 	    rdev->ops->get_station) {
 		struct station_info sinfo = {};
 		u8 *mac_addr;
@@ -10161,26 +10162,56 @@ static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
 			return err;
 
 		if (sinfo.filled & BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG))
-			wdev->cqm_config->last_rssi_event_value =
+			wdev->rssi_config->last_rssi_event_value =
 				(s8) sinfo.rx_beacon_signal_avg;
 	}
 
-	last = wdev->cqm_config->last_rssi_event_value;
-	hyst = wdev->cqm_config->rssi_hyst;
-	n = wdev->cqm_config->n_rssi_thresholds;
+	last = wdev->rssi_config->last_rssi_event_value;
+	hyst = wdev->rssi_config->rssi_hyst;
+	n = wdev->rssi_config->n_rssi_thresholds;
 
 	for (i = 0; i < n; i++)
-		if (last < wdev->cqm_config->rssi_thresholds[i])
+		if (last < wdev->rssi_config->rssi_thresholds[i])
 			break;
 
 	low = i > 0 ?
-		(wdev->cqm_config->rssi_thresholds[i - 1] - hyst) : S32_MIN;
+		(wdev->rssi_config->rssi_thresholds[i - 1] - hyst) : S32_MIN;
 	high = i < n ?
-		(wdev->cqm_config->rssi_thresholds[i] + hyst - 1) : S32_MAX;
+		(wdev->rssi_config->rssi_thresholds[i] + hyst - 1) : S32_MAX;
 
 	return rdev_set_cqm_rssi_range_config(rdev, dev, low, high);
 }
 
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
+		if (!memcmp(rssi_config->addr, peer, ETH_ALEN))
+			goto found;
+	}
+
+new:
+	rssi_config = kzalloc(sizeof(struct cfg80211_rssi_config) +
+			      n_thresholds * sizeof(s32), GFP_KERNEL);
+	list_add(&rssi_config->list, &wdev->rssi_config_list);
+found:
+	rssi_config->rssi_hyst = hysteresis;
+	rssi_config->n_rssi_thresholds = n_thresholds;
+	memcpy(rssi_config->addr, peer, ETH_ALEN);
+	memcpy(rssi_config->rssi_thresholds, thresholds,
+	       n_thresholds * sizeof(s32));
+	return rssi_config;
+}
+
 static int nl80211_set_cqm_rssi(struct genl_info *info,
 				const s32 *thresholds, int n_thresholds,
 				u32 hysteresis)
@@ -10204,7 +10235,7 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 		return -EOPNOTSUPP;
 
 	wdev_lock(wdev);
-	cfg80211_cqm_config_free(wdev);
+	cfg80211_rssi_config_free(wdev, NULL);
 	wdev_unlock(wdev);
 
 	if (n_thresholds <= 1 && rdev->ops->set_cqm_rssi_config) {
@@ -10224,21 +10255,14 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 
 	wdev_lock(wdev);
 	if (n_thresholds) {
-		struct cfg80211_cqm_config *cqm_config;
-
-		cqm_config = kzalloc(sizeof(struct cfg80211_cqm_config) +
-				     n_thresholds * sizeof(s32), GFP_KERNEL);
-		if (!cqm_config) {
+		wdev->rssi_config = cfg80211_get_rssi_config(
+						wdev, thresholds,
+						n_thresholds, hysteresis,
+						wdev->current_bss->pub.bssid);
+		if (!wdev->rssi_config) {
 			err = -ENOMEM;
 			goto unlock;
 		}
-
-		cqm_config->rssi_hyst = hysteresis;
-		cqm_config->n_rssi_thresholds = n_thresholds;
-		memcpy(cqm_config->rssi_thresholds, thresholds,
-		       n_thresholds * sizeof(s32));
-
-		wdev->cqm_config = cqm_config;
 	}
 
 	err = cfg80211_cqm_rssi_update(rdev, dev);
@@ -15053,13 +15077,13 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
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
-- 
1.7.9.5
