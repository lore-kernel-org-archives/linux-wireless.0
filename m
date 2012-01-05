Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab2AEPda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 10:33:30 -0500
Message-Id: <20120105153228.497095902@sipsolutions.net> (sfid-20120105_163334_529782_82FE1906)
Date: Thu, 05 Jan 2012 16:30:45 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/8] mac80211: simplify AP_VLAN handling
References: <20120105153043.568616380@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Setting keys and updating TKIP keys must use the
BSS sdata (not AP_VLAN), so we translate. Move
the translation into driver-ops wrappers instead
of having it inline in the code to simplify the
normal code flow.

The same can be done for sta_add/remove which
already does the translation in the wrapper.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/driver-ops.h |    2 ++
 net/mac80211/key.c        |    8 --------
 net/mac80211/pm.c         |   11 ++---------
 net/mac80211/sta_info.c   |    8 +-------
 net/mac80211/util.c       |   11 ++---------
 5 files changed, 7 insertions(+), 33 deletions(-)

--- a/net/mac80211/driver-ops.h	2012-01-04 14:20:03.000000000 +0100
+++ b/net/mac80211/driver-ops.h	2012-01-04 14:20:09.000000000 +0100
@@ -253,6 +253,7 @@ static inline int drv_set_key(struct iee
 
 	might_sleep();
 
+	sdata = get_bss_sdata(sdata);
 	check_sdata_in_driver(sdata);
 
 	trace_drv_set_key(local, cmd, sdata, sta, key);
@@ -272,6 +273,7 @@ static inline void drv_update_tkip_key(s
 	if (sta)
 		ista = &sta->sta;
 
+	sdata = get_bss_sdata(sdata);
 	check_sdata_in_driver(sdata);
 
 	trace_drv_update_tkip_key(local, sdata, conf, ista, iv32);
--- a/net/mac80211/key.c	2012-01-04 14:20:03.000000000 +0100
+++ b/net/mac80211/key.c	2012-01-04 14:20:09.000000000 +0100
@@ -123,9 +123,6 @@ static int ieee80211_key_enable_hw_accel
 		 */
 		if (!(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE))
 			goto out_unsupported;
-		sdata = container_of(sdata->bss,
-				     struct ieee80211_sub_if_data,
-				     u.ap);
 	}
 
 	ret = drv_set_key(key->local, SET_KEY, sdata, sta, &key->conf);
@@ -187,11 +184,6 @@ static void ieee80211_key_disable_hw_acc
 	      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
 		increment_tailroom_need_count(sdata);
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		sdata = container_of(sdata->bss,
-				     struct ieee80211_sub_if_data,
-				     u.ap);
-
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
 			  sta, &key->conf);
 
--- a/net/mac80211/pm.c	2012-01-04 14:20:03.000000000 +0100
+++ b/net/mac80211/pm.c	2012-01-04 14:20:09.000000000 +0100
@@ -97,15 +97,8 @@ int __ieee80211_suspend(struct ieee80211
 	/* tear down aggregation sessions and remove STAs */
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
-		if (sta->uploaded) {
-			sdata = sta->sdata;
-			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-				sdata = container_of(sdata->bss,
-					     struct ieee80211_sub_if_data,
-					     u.ap);
-
-			drv_sta_remove(local, sdata, &sta->sta);
-		}
+		if (sta->uploaded)
+			drv_sta_remove(local, sta->sdata, &sta->sta);
 
 		mesh_plink_quiesce(sta);
 	}
--- a/net/mac80211/sta_info.c	2012-01-04 14:20:03.000000000 +0100
+++ b/net/mac80211/sta_info.c	2012-01-04 14:20:09.000000000 +0100
@@ -774,14 +774,8 @@ int __must_check __sta_info_destroy(stru
 		WARN_ON_ONCE(err != 0);
 	}
 
-	if (sta->uploaded) {
-		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-			sdata = container_of(sdata->bss,
-					     struct ieee80211_sub_if_data,
-					     u.ap);
+	if (sta->uploaded)
 		drv_sta_remove(local, sdata, &sta->sta);
-		sdata = sta->sdata;
-	}
 
 	/*
 	 * At this point, after we wait for an RCU grace period,
--- a/net/mac80211/util.c	2012-01-04 14:20:03.000000000 +0100
+++ b/net/mac80211/util.c	2012-01-04 14:20:09.000000000 +0100
@@ -1185,15 +1185,8 @@ int ieee80211_reconfig(struct ieee80211_
 	/* add STAs back */
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
-		if (sta->uploaded) {
-			sdata = sta->sdata;
-			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-				sdata = container_of(sdata->bss,
-					     struct ieee80211_sub_if_data,
-					     u.ap);
-
-			WARN_ON(drv_sta_add(local, sdata, &sta->sta));
-		}
+		if (sta->uploaded)
+			WARN_ON(drv_sta_add(local, sta->sdata, &sta->sta));
 	}
 	mutex_unlock(&local->sta_mtx);
 


