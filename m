Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761355Ab3DCMZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 08:25:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: destroy virtual monitor interface across suspend
Date: Wed,  3 Apr 2013 14:25:19 +0200
Message-Id: <1364991920-11712-3-git-send-email-johannes@sipsolutions.net> (sfid-20130403_142533_709799_CB9A359A)
In-Reply-To: <1364991920-11712-1-git-send-email-johannes@sipsolutions.net>
References: <1364423602-18821-1-git-send-email-johannes@sipsolutions.net>
 <1364991920-11712-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It has to be removed from the driver, but completely
destroying it helps handle unplug of a device during
suspend since then the channel context handling etc.
doesn't have to happen later when it's removed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 2 ++
 net/mac80211/iface.c       | 4 ++--
 net/mac80211/pm.c          | 6 ++----
 net/mac80211/util.c        | 5 +++++
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 693c181..55fb382 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1336,6 +1336,8 @@ void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
 				    const int offset);
 int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up);
 void ieee80211_sdata_stop(struct ieee80211_sub_if_data *sdata);
+int ieee80211_add_virtual_monitor(struct ieee80211_local *local);
+void ieee80211_del_virtual_monitor(struct ieee80211_local *local);
 
 bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index aadb471..5ec9c02 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -346,7 +346,7 @@ static void ieee80211_set_default_queues(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
 }
 
-static int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
+int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 	int ret = 0;
@@ -400,7 +400,7 @@ static int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 	return ret;
 }
 
-static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
+void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index b98d927..d1c021b 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -21,6 +21,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	ieee80211_roc_purge(local, NULL);
 
+	ieee80211_del_virtual_monitor(local);
+
 	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
 		mutex_lock(&local->sta_mtx);
 		list_for_each_entry(sta, &local->sta_list, list) {
@@ -103,10 +105,6 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		drv_remove_interface(local, sdata);
 	}
 
-	sdata = rtnl_dereference(local->monitor_sdata);
-	if (sdata)
-		drv_remove_interface(local, sdata);
-
 	/*
 	 * We disconnected on all interfaces before suspend, all channel
 	 * contexts should be released.
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f9581c6..43465b6 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1461,6 +1461,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	/* add interfaces */
 	sdata = rtnl_dereference(local->monitor_sdata);
 	if (sdata) {
+		/* in HW restart it exists already */
+		WARN_ON(local->resuming);
 		res = drv_add_interface(local, sdata);
 		if (WARN_ON(res)) {
 			rcu_assign_pointer(local->monitor_sdata, NULL);
@@ -1650,6 +1652,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	local->in_reconfig = false;
 	barrier();
 
+	if (local->monitors == local->open_count && local->monitors > 0)
+		ieee80211_add_virtual_monitor(local);
+
 	/*
 	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
 	 * sessions can be established after a resume.
-- 
1.8.0

