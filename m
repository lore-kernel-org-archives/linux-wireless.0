Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42358 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbZAWQfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:35:13 -0500
Subject: [PATCH] mac80211: Add capability to enable/disable beaconing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 18:07:31 +0100
Message-Id: <1232644051.5819.9.camel@johannes.local> (sfid-20090123_173518_515253_0553C073)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a flag to notify drivers to start and stop
beaconing when needed, for example, during a scan run. Based
on Sujith's first patch to do the same, but now disables
beaconing for all virtual interfaces while scanning, has a
separate change flag and tracks user-space requests.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    9 +++++++--
 net/mac80211/cfg.c     |    5 +++--
 net/mac80211/main.c    |   42 +++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/mesh.c    |    3 ++-
 net/mac80211/mlme.c    |    3 ++-
 net/mac80211/scan.c    |   18 +++++++++++-------
 6 files changed, 66 insertions(+), 14 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-01-21 12:48:21.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-01-21 12:48:21.000000000 +0100
@@ -626,10 +626,12 @@ struct ieee80211_if_init_conf {
  * @IEEE80211_IFCC_BSSID: The BSSID changed.
  * @IEEE80211_IFCC_BEACON: The beacon for this interface changed
  *	(currently AP and MESH only), use ieee80211_beacon_get().
+ * @IEEE80211_IFCC_BEACON_ENABLED: The enable_beacon value changed.
  */
 enum ieee80211_if_conf_change {
-	IEEE80211_IFCC_BSSID	= BIT(0),
-	IEEE80211_IFCC_BEACON	= BIT(1),
+	IEEE80211_IFCC_BSSID		= BIT(0),
+	IEEE80211_IFCC_BEACON		= BIT(1),
+	IEEE80211_IFCC_BEACON_ENABLED	= BIT(2),
 };
 
 /**
@@ -637,6 +639,8 @@ enum ieee80211_if_conf_change {
  *
  * @changed: parameters that have changed, see &enum ieee80211_if_conf_change.
  * @bssid: BSSID of the network we are associated to/creating.
+ * @enable_beacon: Indicates whether beacons can be sent.
+ *	This is valid only for AP/IBSS/MESH modes.
  *
  * This structure is passed to the config_interface() callback of
  * &struct ieee80211_hw.
@@ -644,6 +648,7 @@ enum ieee80211_if_conf_change {
 struct ieee80211_if_conf {
 	u32 changed;
 	const u8 *bssid;
+	bool enable_beacon;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/main.c	2009-01-21 12:48:21.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-01-21 12:48:21.000000000 +0100
@@ -168,7 +168,6 @@ int ieee80211_if_config(struct ieee80211
 		return 0;
 
 	memset(&conf, 0, sizeof(conf));
-	conf.changed = changed;
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
 	    sdata->vif.type == NL80211_IFTYPE_ADHOC)
@@ -183,9 +182,50 @@ int ieee80211_if_config(struct ieee80211
 		return -EINVAL;
 	}
 
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+		break;
+	default:
+		/* do not warn to simplify caller in scan.c */
+		changed &= ~IEEE80211_IFCC_BEACON_ENABLED;
+		if (WARN_ON(changed & IEEE80211_IFCC_BEACON))
+			return -EINVAL;
+		changed &= ~IEEE80211_IFCC_BEACON;
+		break;
+	}
+
+	if (changed & IEEE80211_IFCC_BEACON_ENABLED) {
+		if (local->sw_scanning) {
+			conf.enable_beacon = false;
+		} else {
+			/*
+			 * Beacon should be enabled, but AP mode must
+			 * check whether there is a beacon configured.
+			 */
+			switch (sdata->vif.type) {
+			case NL80211_IFTYPE_AP:
+				conf.enable_beacon =
+					!!rcu_dereference(sdata->u.ap.beacon);
+				break;
+			case NL80211_IFTYPE_ADHOC:
+			case NL80211_IFTYPE_MESH_POINT:
+				conf.enable_beacon = true;
+				break;
+			default:
+				/* not reached */
+				WARN_ON(1);
+				break;
+			}
+		}
+	}
+
 	if (WARN_ON(!conf.bssid && (changed & IEEE80211_IFCC_BSSID)))
 		return -EINVAL;
 
+	conf.changed = changed;
+
 	return local->ops->config_interface(local_to_hw(local),
 					    &sdata->vif, &conf);
 }
--- wireless-testing.orig/net/mac80211/scan.c	2009-01-21 12:48:12.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-01-21 12:48:21.000000000 +0100
@@ -20,6 +20,7 @@
 
 #include <linux/wireless.h>
 #include <linux/if_arp.h>
+#include <linux/rtnetlink.h>
 #include <net/mac80211.h>
 #include <net/iw_handler.h>
 
@@ -472,8 +473,8 @@ void ieee80211_scan_completed(struct iee
 	netif_addr_unlock(local->mdev);
 	netif_tx_unlock_bh(local->mdev);
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
 		/* Tell AP we're back */
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
@@ -482,8 +483,10 @@ void ieee80211_scan_completed(struct iee
 			}
 		} else
 			netif_tx_wake_all_queues(sdata->dev);
+
+		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);
 	}
-	rcu_read_unlock();
+	mutex_unlock(&local->iflist_mtx);
 
  done:
 	ieee80211_mlme_notify_scan_completed(local);
@@ -491,7 +494,6 @@ void ieee80211_scan_completed(struct iee
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
 
-
 void ieee80211_scan_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =
@@ -633,8 +635,10 @@ int ieee80211_start_scan(struct ieee8021
 
 	local->sw_scanning = true;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);
+
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
 				netif_tx_stop_all_queues(sdata->dev);
@@ -643,7 +647,7 @@ int ieee80211_start_scan(struct ieee8021
 		} else
 			netif_tx_stop_all_queues(sdata->dev);
 	}
-	rcu_read_unlock();
+	mutex_unlock(&local->iflist_mtx);
 
 	if (ssid) {
 		local->scan_ssid_len = ssid_len;
--- wireless-testing.orig/net/mac80211/mesh.c	2009-01-21 12:48:12.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.c	2009-01-21 12:48:21.000000000 +0100
@@ -442,7 +442,8 @@ void ieee80211_start_mesh(struct ieee802
 
 	ifmsh->housekeeping = true;
 	queue_work(local->hw.workqueue, &ifmsh->work);
-	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
+				   IEEE80211_IFCC_BEACON_ENABLED);
 }
 
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
--- wireless-testing.orig/net/mac80211/mlme.c	2009-01-21 12:48:12.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-01-21 12:48:21.000000000 +0100
@@ -1598,7 +1598,8 @@ static int ieee80211_sta_join_ibss(struc
 
 	ifsta->probe_resp = skb;
 
-	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
+				   IEEE80211_IFCC_BEACON_ENABLED);
 
 
 	rates = 0;
--- wireless-testing.orig/net/mac80211/cfg.c	2009-01-21 12:48:12.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-01-21 12:48:21.000000000 +0100
@@ -523,7 +523,8 @@ static int ieee80211_config_beacon(struc
 
 	kfree(old);
 
-	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
+					  IEEE80211_IFCC_BEACON_ENABLED);
 }
 
 static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
@@ -583,7 +584,7 @@ static int ieee80211_del_beacon(struct w
 	synchronize_rcu();
 	kfree(old);
 
-	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);
 }
 
 /* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */


