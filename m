Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab2LNNqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 08:46:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] mac80211: track enable_beacon explicitly
Date: Fri, 14 Dec 2012 14:46:43 +0100
Message-Id: <1355492806-31673-2-git-send-email-johannes@sipsolutions.net> (sfid-20121214_144633_635337_BEB314DE)
In-Reply-To: <1355492806-31673-1-git-send-email-johannes@sipsolutions.net>
References: <1355492806-31673-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of calculating in ieee80211_bss_info_change_notify()
whether beaconing should be enabled or not, set it in the
correct places in the callers. This simplifies the logic in
this function at the expense of offchannel, but is also more
robust.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  4 ++++
 net/mac80211/ibss.c        |  3 +++
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/main.c        | 32 --------------------------------
 net/mac80211/mesh.c        |  3 +++
 net/mac80211/offchannel.c  | 15 +++++++++------
 6 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index af2804c..8576723 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -933,6 +933,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 	sdata->vif.bss_conf.dtim_period = params->dtim_period;
+	sdata->vif.bss_conf.enable_beacon = true;
 
 	sdata->vif.bss_conf.ssid_len = params->ssid_len;
 	if (params->ssid_len)
@@ -1015,6 +1016,9 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		sta_info_flush(vlan);
 	sta_info_flush(sdata);
+
+	sdata->vif.bss_conf.enable_beacon = false;
+	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
 	drv_stop_ap(sdata->local, sdata);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 4521459..acdab28 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -191,6 +191,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	rcu_assign_pointer(ifibss->presp, skb);
 
+	sdata->vif.bss_conf.enable_beacon = true;
 	sdata->vif.bss_conf.beacon_int = beacon_int;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
 	bss_change = BSS_CHANGED_BEACON_INT;
@@ -1189,6 +1190,8 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
 	sdata->vif.bss_conf.ibss_joined = false;
 	sdata->vif.bss_conf.ibss_creator = false;
+	sdata->vif.bss_conf.enable_beacon = false;
+	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_IBSS);
 	synchronize_rcu();
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2bb0c98..d4114e9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -661,10 +661,13 @@ enum ieee80211_sub_if_data_flags {
  *	change handling while the interface is up
  * @SDATA_STATE_OFFCHANNEL: This interface is currently in offchannel
  *	mode, so queues are stopped
+ * @SDATA_STATE_OFFCHANNEL_BEACON_STOPPED: Beaconing was stopped due
+ *	to offchannel, reset when offchannel returns
  */
 enum ieee80211_sdata_state_bits {
 	SDATA_STATE_RUNNING,
 	SDATA_STATE_OFFCHANNEL,
+	SDATA_STATE_OFFCHANNEL_BEACON_STOPPED,
 };
 
 /**
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e35d13e..e991d30 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -245,38 +245,6 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 		break;
 	}
 
-	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		if (local->quiescing || !ieee80211_sdata_running(sdata) ||
-		    test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state)) {
-			sdata->vif.bss_conf.enable_beacon = false;
-		} else {
-			/*
-			 * Beacon should be enabled, but AP mode must
-			 * check whether there is a beacon configured.
-			 */
-			switch (sdata->vif.type) {
-			case NL80211_IFTYPE_AP:
-				sdata->vif.bss_conf.enable_beacon =
-					!!sdata->u.ap.beacon;
-				break;
-			case NL80211_IFTYPE_ADHOC:
-				sdata->vif.bss_conf.enable_beacon =
-					!!sdata->u.ibss.presp;
-				break;
-#ifdef CONFIG_MAC80211_MESH
-			case NL80211_IFTYPE_MESH_POINT:
-				sdata->vif.bss_conf.enable_beacon =
-					!!sdata->u.mesh.mesh_id_len;
-				break;
-#endif
-			default:
-				/* not reached */
-				WARN_ON(1);
-				break;
-			}
-		}
-	}
-
 	drv_bss_info_changed(local, sdata, &sdata->vif.bss_conf, changed);
 }
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f5f01e0..df2e36b 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -631,6 +631,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.ht_operation_mode =
 				ifmsh->mshcfg.ht_opmode;
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
+	sdata->vif.bss_conf.enable_beacon = true;
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(local, band);
 
@@ -653,6 +654,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	/* stop the beacon */
 	ifmsh->mesh_id_len = 0;
+	sdata->vif.bss_conf.enable_beacon = false;
+	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
 	/* flush STAs and mpaths on this iface */
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 5abddfe..3d18769 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -126,11 +126,13 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
 
 		/* Check to see if we should disable beaconing. */
-		if (sdata->vif.type == NL80211_IFTYPE_AP ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+		if (sdata->vif.bss_conf.enable_beacon) {
+			set_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED,
+				&sdata->state);
+			sdata->vif.bss_conf.enable_beacon = false;
 			ieee80211_bss_info_change_notify(
 				sdata, BSS_CHANGED_BEACON_ENABLED);
+		}
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
 			netif_tx_stop_all_queues(sdata->dev);
@@ -183,11 +185,12 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 			netif_tx_wake_all_queues(sdata->dev);
 		}
 
-		if (sdata->vif.type == NL80211_IFTYPE_AP ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+		if (test_and_clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED,
+				       &sdata->state)) {
+			sdata->vif.bss_conf.enable_beacon = true;
 			ieee80211_bss_info_change_notify(
 				sdata, BSS_CHANGED_BEACON_ENABLED);
+		}
 	}
 	mutex_unlock(&local->iflist_mtx);
 }
-- 
1.8.0

