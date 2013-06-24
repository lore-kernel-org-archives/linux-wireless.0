Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3FXNs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:48:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add rate control table update driver method
Date: Mon, 24 Jun 2013 15:48:53 +0200
Message-Id: <1372081733-31671-1-git-send-email-johannes@sipsolutions.net> (sfid-20130624_154900_678351_B192FD1F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add an update method that to the driver for those drivers
that want to use the rate table directly, rather than doing
per packet lookups in it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |  6 ++++++
 net/mac80211/driver-ops.h | 14 ++++++++++++++
 net/mac80211/rate.c       |  3 +++
 net/mac80211/trace.h      | 35 ++++++++++++++++-------------------
 4 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5b7a3da..168e50e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2431,6 +2431,9 @@ enum ieee80211_roc_type {
  *	uses hardware rate control (%IEEE80211_HW_HAS_RATE_CONTROL) since
  *	otherwise the rate control algorithm is notified directly.
  *	Must be atomic.
+ * @sta_rate_tbl_update: Notifies the driver that the rate table changed. This
+ *	is only used if the configured rate control algorithm actually uses
+ *	the new rate table API, and is therefore optional. Must be atomic.
  *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
@@ -2728,6 +2731,9 @@ struct ieee80211_ops {
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta,
 			      u32 changed);
+	void (*sta_rate_tbl_update)(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_sta *sta);
 	int (*conf_tx)(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif, u16 ac,
 		       const struct ieee80211_tx_queue_params *params);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index b931c96..6f395d1 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -600,6 +600,20 @@ static inline void drv_sta_rc_update(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void drv_sta_rate_tbl_update(struct ieee80211_local *local,
+					   struct ieee80211_sub_if_data *sdata,
+					   struct ieee80211_sta *sta)
+{
+	sdata = get_bss_sdata(sdata);
+	check_sdata_in_driver(sdata);
+
+	trace_drv_sta_rate_tbl_update(local, sdata, sta);
+	if (local->ops->sta_rate_tbl_update)
+		local->ops->sta_rate_tbl_update(&local->hw, &sdata->vif, sta);
+
+	trace_drv_return_void(local);
+}
+
 static inline int drv_conf_tx(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata, u16 ac,
 			      const struct ieee80211_tx_queue_params *params)
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 30d58d2..d93c857 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -694,6 +694,7 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
 			   struct ieee80211_sta *pubsta,
 			   struct ieee80211_sta_rates *rates)
 {
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	struct ieee80211_sta_rates *old;
 
 	/*
@@ -707,6 +708,8 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
 	if (old)
 		kfree_rcu(old, rcu_head);
 
+	drv_sta_rate_tbl_update(hw_to_local(hw), sta->sdata, pubsta);
+
 	return 0;
 }
 EXPORT_SYMBOL(rate_control_set_rates);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index c215fafd7..306c645 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -773,7 +773,7 @@ TRACE_EVENT(drv_sta_rc_update,
 	)
 );
 
-TRACE_EVENT(drv_sta_add,
+DECLARE_EVENT_CLASS(local_sdata_sta_evt,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_sta *sta),
@@ -798,29 +798,26 @@ TRACE_EVENT(drv_sta_add,
 	)
 );
 
-TRACE_EVENT(drv_sta_remove,
+
+DEFINE_EVENT(local_sdata_sta_evt, drv_sta_add,
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
+DEFINE_EVENT(local_sdata_sta_evt, drv_sta_remove,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+	TP_ARGS(local, sdata, sta)
+);
 
-	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT,
-		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG
-	)
+DEFINE_EVENT(local_sdata_sta_evt, drv_sta_rate_tbl_update,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+	TP_ARGS(local, sdata, sta)
 );
 
 TRACE_EVENT(drv_conf_tx,
-- 
1.8.0

