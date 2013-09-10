Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58065 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3IJOxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 10:53:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add explicit IBSS driver operations
Date: Tue, 10 Sep 2013 16:53:14 +0200
Message-Id: <1378824794-16689-1-git-send-email-johannes@sipsolutions.net> (sfid-20130910_165323_465723_DECA41F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This can be useful for drivers if they have any failure cases
when joining an IBSS. Also move setting the queue parameters
to before this new call, in case the new driver op needs them
already.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |  7 +++++++
 net/mac80211/driver-ops.h | 27 +++++++++++++++++++++++++++
 net/mac80211/ibss.c       | 22 ++++++++++++++++++++--
 net/mac80211/trace.h      | 35 +++++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9bf07ef..2e8e817 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2671,6 +2671,10 @@ enum ieee80211_roc_type {
  *	zero using ieee80211_csa_is_complete() after the beacon has been
  *	transmitted and then call ieee80211_csa_finish().
  *
+ * @join_ibss: Join an IBSS (on an IBSS interface); this is called after all
+ *	information in bss_conf is set up and the beacon can be retrieved. A
+ *	channel context is bound before this is called.
+ * @leave_ibss: Leave the IBSS again.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2862,6 +2866,9 @@ struct ieee80211_ops {
 	void (*channel_switch_beacon)(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
 				      struct cfg80211_chan_def *chandef);
+
+	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
+	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index b3ea11f..5d03c47 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1085,4 +1085,31 @@ drv_channel_switch_beacon(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+static inline int drv_join_ibss(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata)
+{
+	int ret = 0;
+
+	might_sleep();
+	check_sdata_in_driver(sdata);
+
+	trace_drv_join_ibss(local, sdata, &sdata->vif.bss_conf);
+	if (local->ops->join_ibss)
+		ret = local->ops->join_ibss(&local->hw, &sdata->vif);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
+static inline void drv_leave_ibss(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *sdata)
+{
+	might_sleep();
+	check_sdata_in_driver(sdata);
+
+	trace_drv_leave_ibss(local, sdata);
+	if (local->ops->leave_ibss)
+		local->ops->leave_ibss(&local->hw, &sdata->vif);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5ea9b3a..21a0b88 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -229,6 +229,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *presp;
 	enum nl80211_bss_scan_width scan_width;
 	bool have_higher_than_11mbit;
+	int err;
 
 	sdata_assert_lock(sdata);
 
@@ -247,6 +248,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		ieee80211_bss_info_change_notify(sdata,
 						 BSS_CHANGED_IBSS |
 						 BSS_CHANGED_BEACON_ENABLED);
+		drv_leave_ibss(local, sdata);
 	}
 
 	presp = rcu_dereference_protected(ifibss->presp,
@@ -329,11 +331,26 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
+	ieee80211_set_wmm_default(sdata, true);
+
 	sdata->vif.bss_conf.ibss_joined = true;
 	sdata->vif.bss_conf.ibss_creator = creator;
-	ieee80211_bss_info_change_notify(sdata, bss_change);
 
-	ieee80211_set_wmm_default(sdata, true);
+	err = drv_join_ibss(local, sdata);
+	if (err) {
+		sdata->vif.bss_conf.ibss_joined = false;
+		sdata->vif.bss_conf.ibss_creator = false;
+		sdata->vif.bss_conf.enable_beacon = false;
+		sdata->vif.bss_conf.ssid_len = 0;
+		RCU_INIT_POINTER(ifibss->presp, NULL);
+		kfree_rcu(presp, rcu_head);
+		ieee80211_vif_release_channel(sdata);
+		sdata_info(sdata, "Failed to join IBSS, driver failure: %d\n",
+			   err);
+		return;
+	}
+
+	ieee80211_bss_info_change_notify(sdata, bss_change);
 
 	ifibss->state = IEEE80211_IBSS_MLME_JOINED;
 	mod_timer(&ifibss->timer,
@@ -761,6 +778,7 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_IBSS);
+	drv_leave_ibss(local, sdata);
 	ieee80211_vif_release_channel(sdata);
 }
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 1aba645..5d62c58 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1475,6 +1475,41 @@ DEFINE_EVENT(local_sdata_evt, drv_ipv6_addr_change,
 );
 #endif
 
+TRACE_EVENT(drv_join_ibss,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_bss_conf *info),
+
+	TP_ARGS(local, sdata, info),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u8, dtimper)
+		__field(u16, bcnint)
+		__dynamic_array(u8, ssid, info->ssid_len);
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->dtimper = info->dtim_period;
+		__entry->bcnint = info->beacon_int;
+		memcpy(__get_dynamic_array(ssid), info->ssid, info->ssid_len);
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG
+	)
+);
+
+DEFINE_EVENT(local_sdata_evt, drv_leave_ibss,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
1.8.4.rc3

