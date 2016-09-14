Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42784 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759949AbcINIMD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 04:12:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/5] mac80211: remove sta_remove_debugfs driver callback
Date: Wed, 14 Sep 2016 10:11:58 +0200
Message-Id: <1473840718-5605-5-git-send-email-johannes@sipsolutions.net> (sfid-20160914_101216_814312_41073FAA)
In-Reply-To: <1473840718-5605-1-git-send-email-johannes@sipsolutions.net>
References: <1473840718-5605-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

No drivers implement this, relying either on the recursive
directory removal to remove their debugfs, or not having any
to start with. Remove the dead driver callback.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     | 11 ++---------
 net/mac80211/debugfs_sta.c |  4 ----
 net/mac80211/driver-ops.h  | 15 ---------------
 3 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 08bac23c8de1..d9c8ccd6b4e6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3101,11 +3101,8 @@ enum ieee80211_reconfig_type {
  *
  * @sta_add_debugfs: Drivers can use this callback to add debugfs files
  *	when a station is added to mac80211's station list. This callback
- *	and @sta_remove_debugfs should be within a CONFIG_MAC80211_DEBUGFS
- *	conditional. This callback can sleep.
- *
- * @sta_remove_debugfs: Remove the debugfs files which were added using
- *	@sta_add_debugfs. This callback can sleep.
+ *	should be within a CONFIG_MAC80211_DEBUGFS conditional. This
+ *	callback can sleep.
  *
  * @sta_notify: Notifies low level driver about power state transition of an
  *	associated station, AP,  IBSS/WDS/mesh peer etc. For a VIF operating
@@ -3501,10 +3498,6 @@ struct ieee80211_ops {
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta,
 				struct dentry *dir);
-	void (*sta_remove_debugfs)(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif,
-				   struct ieee80211_sta *sta,
-				   struct dentry *dir);
 #endif
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index fb2693582e40..a2fcdb47a0e6 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -544,10 +544,6 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 
 void ieee80211_sta_debugfs_remove(struct sta_info *sta)
 {
-	struct ieee80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-
-	drv_sta_remove_debugfs(local, sdata, &sta->sta, sta->debugfs_dir);
 	debugfs_remove_recursive(sta->debugfs_dir);
 	sta->debugfs_dir = NULL;
 }
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index c39f93b48791..fe35a1c0dc86 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -499,21 +499,6 @@ static inline void drv_sta_add_debugfs(struct ieee80211_local *local,
 		local->ops->sta_add_debugfs(&local->hw, &sdata->vif,
 					    sta, dir);
 }
-
-static inline void drv_sta_remove_debugfs(struct ieee80211_local *local,
-					  struct ieee80211_sub_if_data *sdata,
-					  struct ieee80211_sta *sta,
-					  struct dentry *dir)
-{
-	might_sleep();
-
-	sdata = get_bss_sdata(sdata);
-	check_sdata_in_driver(sdata);
-
-	if (local->ops->sta_remove_debugfs)
-		local->ops->sta_remove_debugfs(&local->hw, &sdata->vif,
-					       sta, dir);
-}
 #endif
 
 static inline void drv_sta_pre_rcu_remove(struct ieee80211_local *local,
-- 
2.8.1
