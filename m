Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:60164 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbcALJCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 04:02:31 -0500
From: Sachin Kulkarni <Sachin.Kulkarni@imgtec.com>
To: <linux-wireless@vger.kernel.org>
CC: Sachin Kulkarni <Sachin.Kulkarni@imgtec.com>,
	<johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Requeue work after scan complete for all VIF types.
Date: Tue, 12 Jan 2016 14:30:19 +0530
Message-ID: <1452589219-29164-1-git-send-email-Sachin.Kulkarni@imgtec.com> (sfid-20160112_100237_679355_E009B7A5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sachin Kulkarni <Sachin.Kulkarni@imgtec.com>

During a sw scan ieee80211_iface_work ignores work items for all vifs. 
However after the scan complete work is requeued only for STA, ADHOC 
and MESH iftypes.

This occasionally results in event processing getting delayed/not 
processed for iftype AP when it coexists with a STA. This can result 
in data halt and eventually disconnection on the AP interface.

Signed-off-by: Sachin Kulkarni <Sachin.Kulkarni@imgtec.com>
Cc: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
---
Johannes,

This should be marked for CC:Stable as well, but in the commits before (fc58c47)
this fix is applicable for both HW and SW scans.
---
---
 net/mac80211/ibss.c |  1 -
 net/mac80211/mesh.c | 11 -----------
 net/mac80211/mesh.h |  4 ----
 net/mac80211/mlme.c |  2 --
 net/mac80211/scan.c | 11 ++++++++++-
 5 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e5e8a31..59e610e 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1731,7 +1731,6 @@ void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local)
 		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			continue;
 		sdata->u.ibss.last_scan_completed = jiffies;
-		ieee80211_queue_work(&local->hw, &sdata->work);
 	}
 	mutex_unlock(&local->iflist_mtx);
 }
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 9a8e7b5..d32cefc 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1369,17 +1369,6 @@ out:
 	sdata_unlock(sdata);
 }
 
-void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-		if (ieee80211_vif_is_mesh(&sdata->vif) &&
-		    ieee80211_sdata_running(sdata))
-			ieee80211_queue_work(&local->hw, &sdata->work);
-	rcu_read_unlock();
-}
 
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index a159634..4a8019f 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -362,14 +362,10 @@ static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 	return sdata->u.mesh.mesh_pp_id == IEEE80211_PATH_PROTOCOL_HWMP;
 }
 
-void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
-
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
 void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_stop(void);
 #else
-static inline void
-ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local) {}
 static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 { return false; }
 static inline void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9c7db20..c711418 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3973,8 +3973,6 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 		if (!ieee80211_hw_check(&sdata->local->hw, CONNECTION_MONITOR))
 			ieee80211_queue_work(&sdata->local->hw,
 					     &sdata->u.mgd.monitor_work);
-		/* and do all the other regular work too */
-		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 	}
 }
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8eb68ef..c94a49b 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -314,6 +314,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	bool was_scanning = local->scanning;
 	struct cfg80211_scan_request *scan_req;
 	struct ieee80211_sub_if_data *scan_sdata;
+	struct ieee80211_sub_if_data *sdata;
 
 	lockdep_assert_held(&local->mtx);
 
@@ -373,7 +374,15 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_ibss_notify_scan_completed(local);
-	ieee80211_mesh_notify_scan_completed(local);
+
+	/* Requeue all the work that might have been ignored while
+	 * the scan was in progress
+	 */
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (ieee80211_sdata_running(sdata))
+			ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	}
+
 	if (was_scanning)
 		ieee80211_start_next_roc(local);
 }
-- 
1.9.1

