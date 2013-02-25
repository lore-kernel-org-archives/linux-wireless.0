Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759110Ab3BYLuV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 06:50:21 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/6] mac80211: cleanup generic suspend/resume procedures
Date: Mon, 25 Feb 2013 12:50:05 +0100
Message-Id: <1361793008-2857-3-git-send-email-sgruszka@redhat.com> (sfid-20130225_125026_692207_CA76783B)
In-Reply-To: <1361793008-2857-1-git-send-email-sgruszka@redhat.com>
References: <1361793008-2857-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since now we disconnect before suspend, various code which save
connection state can now be removed from suspend and resume
procedure. Cleanup on resume side is smaller as ieee80211_reconfig()
is also used for H/W restart.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/ieee80211_i.h |  4 ---
 net/mac80211/key.c         | 14 ----------
 net/mac80211/key.h         |  1 -
 net/mac80211/pm.c          | 68 ----------------------------------------------
 net/mac80211/util.c        | 26 ------------------
 5 files changed, 113 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 388580a..cc917a7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -765,10 +765,6 @@ struct ieee80211_sub_if_data {
 	} debugfs;
 #endif
 
-#ifdef CONFIG_PM
-	struct ieee80211_bss_conf suspend_bss_conf;
-#endif
-
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
 };
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ef252eb..df81b17 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -566,20 +566,6 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_iter_keys);
 
-void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_key *key;
-
-	ASSERT_RTNL();
-
-	mutex_lock(&sdata->local->key_mtx);
-
-	list_for_each_entry(key, &sdata->key_list, list)
-		ieee80211_key_disable_hw_accel(key);
-
-	mutex_unlock(&sdata->local->key_mtx);
-}
-
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key, *tmp;
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 382dc44..8b03730 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -143,7 +143,6 @@ void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
 				    int idx);
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata);
 void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata);
-void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata);
 
 #define key_mtx_dereference(local, ref) \
 	rcu_dereference_protected(ref, lockdep_is_held(&((local)->key_mtx)))
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index d0275f3..58f4297 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -6,26 +6,6 @@
 #include "driver-ops.h"
 #include "led.h"
 
-/* return value indicates whether the driver should be further notified */
-static void ieee80211_quiesce(struct ieee80211_sub_if_data *sdata)
-{
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_STATION:
-		ieee80211_sta_quiesce(sdata);
-		break;
-	case NL80211_IFTYPE_ADHOC:
-		ieee80211_ibss_quiesce(sdata);
-		break;
-	case NL80211_IFTYPE_MESH_POINT:
-		ieee80211_mesh_quiesce(sdata);
-		break;
-	default:
-		break;
-	}
-
-	cancel_work_sync(&sdata->work);
-}
-
 int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -95,17 +75,10 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			WARN_ON(err != 1);
 			local->wowlan = false;
 		} else {
-			list_for_each_entry(sdata, &local->interfaces, list)
-				if (ieee80211_sdata_running(sdata))
-					ieee80211_quiesce(sdata);
 			goto suspend;
 		}
 	}
 
-	/* disable keys */
-	list_for_each_entry(sdata, &local->interfaces, list)
-		ieee80211_disable_keys(sdata);
-
 	/* tear down aggregation sessions and remove STAs */
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
@@ -117,55 +90,14 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 				WARN_ON(drv_sta_state(local, sta->sdata, sta,
 						      state, state - 1));
 		}
-
-		mesh_plink_quiesce(sta);
 	}
 	mutex_unlock(&local->sta_mtx);
 
 	/* remove all interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		static u8 zero_addr[ETH_ALEN] = {};
-		u32 changed = 0;
-
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
-		switch (sdata->vif.type) {
-		case NL80211_IFTYPE_AP_VLAN:
-		case NL80211_IFTYPE_MONITOR:
-			/* skip these */
-			continue;
-		case NL80211_IFTYPE_STATION:
-			if (sdata->vif.bss_conf.assoc)
-				changed = BSS_CHANGED_ASSOC |
-					  BSS_CHANGED_BSSID |
-					  BSS_CHANGED_IDLE;
-			break;
-		case NL80211_IFTYPE_AP:
-		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_MESH_POINT:
-			if (sdata->vif.bss_conf.enable_beacon)
-				changed = BSS_CHANGED_BEACON_ENABLED;
-			break;
-		default:
-			break;
-		}
-
-		ieee80211_quiesce(sdata);
-
-		sdata->suspend_bss_conf = sdata->vif.bss_conf;
-		memset(&sdata->vif.bss_conf, 0, sizeof(sdata->vif.bss_conf));
-		sdata->vif.bss_conf.idle = true;
-		if (sdata->suspend_bss_conf.bssid)
-			sdata->vif.bss_conf.bssid = zero_addr;
-
-		/* disable beaconing or remove association */
-		ieee80211_bss_info_change_notify(sdata, changed);
-
-		if (sdata->vif.type == NL80211_IFTYPE_AP &&
-		    rcu_access_pointer(sdata->u.ap.beacon))
-			drv_stop_ap(local, sdata);
-
 		if (local->use_chanctx) {
 			struct ieee80211_chanctx_conf *conf;
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0f38f43..f5d4e32 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1534,11 +1534,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			  BSS_CHANGED_IDLE |
 			  BSS_CHANGED_TXPOWER;
 
-#ifdef CONFIG_PM
-		if (local->resuming && !reconfig_due_to_wowlan)
-			sdata->vif.bss_conf = sdata->suspend_bss_conf;
-#endif
-
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			changed |= BSS_CHANGED_ASSOC |
@@ -1678,28 +1673,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	mb();
 	local->resuming = false;
 
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		switch(sdata->vif.type) {
-		case NL80211_IFTYPE_STATION:
-			ieee80211_sta_restart(sdata);
-			break;
-		case NL80211_IFTYPE_ADHOC:
-			ieee80211_ibss_restart(sdata);
-			break;
-		case NL80211_IFTYPE_MESH_POINT:
-			ieee80211_mesh_restart(sdata);
-			break;
-		default:
-			break;
-		}
-	}
-
 	mod_timer(&local->sta_cleanup, jiffies + 1);
-
-	mutex_lock(&local->sta_mtx);
-	list_for_each_entry(sta, &local->sta_list, list)
-		mesh_plink_restart(sta);
-	mutex_unlock(&local->sta_mtx);
 #else
 	WARN_ON(1);
 #endif
-- 
1.7.11.7

