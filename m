Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51758 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3LEMgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 07:36:05 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/8] mac80211: add pre-RCU-sync sta removal driver operation
Date: Thu,  5 Dec 2013 13:35:49 +0100
Message-Id: <1386246956-14257-2-git-send-email-johannes@sipsolutions.net> (sfid-20131205_133623_283955_B3137ED2)
In-Reply-To: <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
 <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, mac80211 allows drivers to keep RCU-protected station
references that are cleared when the station is removed from the
driver and consequently needs to synchronize twice, once before
removing the station from the driver (so it can guarantee that
the station is no longer used in TX towards the driver) and once
after the station is removed from the driver.

Add a new pre-RCU-synchronisation station removal operation to
the API to allow drivers to clear/invalidate their RCU-protected
station pointers before the RCU synchronisation.

This will allow removing the second synchronisation by changing
the driver API so that the driver may no longer assume a valid
RCU-protected pointer after sta_remove/sta_state returns.

The alternative to this would be to synchronize_rcu() in all the
drivers that currently rely on this behaviour (only iwlmvm) but
that would defeat the purpose.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    | 21 +++++++++++++++++++--
 net/mac80211/driver-ops.h | 16 ++++++++++++++++
 net/mac80211/sta_info.c   |  2 ++
 net/mac80211/trace.h      | 34 +++++++++++++++-------------------
 4 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c014acc..22b6dd9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2495,7 +2495,11 @@ enum ieee80211_roc_type {
  *	AP, IBSS/WDS/mesh peer etc. This callback can sleep.
  *
  * @sta_remove: Notifies low level driver about removal of an associated
- *	station, AP, IBSS/WDS/mesh peer etc. This callback can sleep.
+ *	station, AP, IBSS/WDS/mesh peer etc. Note that after the callback
+ *	returns it isn't safe to use the pointer, not even RCU protected;
+ *	no RCU grace period is guaranteed between returning here and freeing
+ *	the station. See @sta_pre_rcu_remove if needed.
+ *	This callback can sleep.
  *
  * @sta_add_debugfs: Drivers can use this callback to add debugfs files
  *	when a station is added to mac80211's station list. This callback
@@ -2514,7 +2518,17 @@ enum ieee80211_roc_type {
  *	station (which can be the AP, a client, IBSS/WDS/mesh peer etc.)
  *	This callback is mutually exclusive with @sta_add/@sta_remove.
  *	It must not fail for down transitions but may fail for transitions
- *	up the list of states.
+ *	up the list of states. Also note that after the callback returns it
+ *	isn't safe to use the pointer, not even RCU protected - no RCU grace
+ *	period is guaranteed between returning here and freeing the station.
+ *	See @sta_pre_rcu_remove if needed.
+ *	The callback can sleep.
+ *
+ * @sta_pre_rcu_remove: Notify driver about station removal before RCU
+ *	synchronisation. This is useful if a driver needs to have station
+ *	pointers protected using RCU, it can then use this call to clear
+ *	the pointers instead of waiting for an RCU grace period to elapse
+ *	in @sta_state.
  *	The callback can sleep.
  *
  * @sta_rc_update: Notifies the driver of changes to the bitrates that can be
@@ -2827,6 +2841,9 @@ struct ieee80211_ops {
 			 struct ieee80211_sta *sta,
 			 enum ieee80211_sta_state old_state,
 			 enum ieee80211_sta_state new_state);
+	void (*sta_pre_rcu_remove)(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_sta *sta);
 	void (*sta_rc_update)(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f98059a..ef8b385 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -534,6 +534,22 @@ static inline void drv_sta_remove_debugfs(struct ieee80211_local *local,
 }
 #endif
 
+static inline void drv_sta_pre_rcu_remove(struct ieee80211_local *local,
+					  struct ieee80211_sub_if_data *sdata,
+					  struct sta_info *sta)
+{
+	might_sleep();
+
+	sdata = get_bss_sdata(sdata);
+	check_sdata_in_driver(sdata);
+
+	trace_drv_sta_pre_rcu_remove(local, sdata, &sta->sta);
+	if (local->ops->sta_pre_rcu_remove)
+		local->ops->sta_pre_rcu_remove(&local->hw, &sdata->vif,
+					       &sta->sta);
+	trace_drv_return_void(local);
+}
+
 static inline __must_check
 int drv_sta_state(struct ieee80211_local *local,
 		  struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8ae37f6..1e14774 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -873,6 +873,8 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 
 	list_del_rcu(&sta->list);
 
+	drv_sta_pre_rcu_remove(local, sta->sdata, sta);
+
 	/* this always calls synchronize_net() */
 	ieee80211_free_sta_keys(local, sta);
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 9d213e8..dc7d745 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -766,7 +766,7 @@ TRACE_EVENT(drv_sta_rc_update,
 	)
 );
 
-TRACE_EVENT(drv_sta_add,
+DECLARE_EVENT_CLASS(sta_event,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_sta *sta),
@@ -791,29 +791,25 @@ TRACE_EVENT(drv_sta_add,
 	)
 );
 
-TRACE_EVENT(drv_sta_remove,
+DEFINE_EVENT(sta_event, drv_sta_add,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_sta *sta),
+	TP_ARGS(local, sdata, sta)
+);
 
-	TP_ARGS(local, sdata, sta),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-		VIF_ENTRY
-		STA_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-		VIF_ASSIGN;
-		STA_ASSIGN;
-	),
+DEFINE_EVENT(sta_event, drv_sta_remove,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+	TP_ARGS(local, sdata, sta)
+);
 
-	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT,
-		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG
-	)
+DEFINE_EVENT(sta_event, drv_sta_pre_rcu_remove,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+	TP_ARGS(local, sdata, sta)
 );
 
 TRACE_EVENT(drv_conf_tx,
-- 
1.8.4.rc3

