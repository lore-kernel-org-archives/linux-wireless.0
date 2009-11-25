Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38819 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758838AbZKYTay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 14:30:54 -0500
Subject: [PATCH] mac80211: trace interface name
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 20:30:31 +0100
Message-ID: <1259177431.32372.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not all that useful to have the vif/sdata pointer,
we'd rather refer to the interfaces by their name.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-rx.c       |    6 ++----
 net/mac80211/agg-tx.c       |    7 +++----
 net/mac80211/driver-ops.h   |   29 +++++++++++++++--------------
 net/mac80211/driver-trace.h |   38 ++++++++++++++++++++------------------
 net/mac80211/key.c          |    4 ++--
 net/mac80211/main.c         |    3 +--
 net/mac80211/pm.c           |    2 +-
 net/mac80211/rx.c           |    2 +-
 net/mac80211/sta_info.c     |    6 +++---
 net/mac80211/util.c         |    2 +-
 10 files changed, 49 insertions(+), 50 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-11-25 20:29:21.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2009-11-25 20:29:24.000000000 +0100
@@ -41,8 +41,7 @@ void __ieee80211_stop_rx_ba_session(stru
 	       sta->sta.addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	if (drv_ampdu_action(local, &sta->sdata->vif,
-			     IEEE80211_AMPDU_RX_STOP,
+	if (drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_STOP,
 			     &sta->sta, tid, NULL))
 		printk(KERN_DEBUG "HW problem - can not stop rx "
 				"aggregation for tid %d\n", tid);
@@ -284,8 +283,7 @@ void ieee80211_process_addba_request(str
 		goto end;
 	}
 
-	ret = drv_ampdu_action(local, &sta->sdata->vif,
-			       IEEE80211_AMPDU_RX_START,
+	ret = drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_START,
 			       &sta->sta, tid, &start_seq_num);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Rx A-MPDU request on tid %d result %d\n", tid, ret);
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-11-25 20:29:21.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-11-25 20:29:24.000000000 +0100
@@ -139,7 +139,7 @@ static int ___ieee80211_stop_tx_ba_sessi
 	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
 		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
 
-	ret = drv_ampdu_action(local, &sta->sdata->vif,
+	ret = drv_ampdu_action(local, sta->sdata,
 			       IEEE80211_AMPDU_TX_STOP,
 			       &sta->sta, tid, NULL);
 
@@ -299,8 +299,7 @@ int ieee80211_start_tx_ba_session(struct
 
 	start_seq_num = sta->tid_seq[tid];
 
-	ret = drv_ampdu_action(local, &sdata->vif,
-			       IEEE80211_AMPDU_TX_START,
+	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
 			       pubsta, tid, &start_seq_num);
 
 	if (ret) {
@@ -416,7 +415,7 @@ static void ieee80211_agg_tx_operational
 	ieee80211_agg_splice_finish(local, sta, tid);
 	spin_unlock(&local->ampdu_lock);
 
-	drv_ampdu_action(local, &sta->sdata->vif,
+	drv_ampdu_action(local, sta->sdata,
 			 IEEE80211_AMPDU_TX_OPERATIONAL,
 			 &sta->sta, tid, NULL);
 }
--- wireless-testing.orig/net/mac80211/driver-ops.h	2009-11-25 20:29:21.000000000 +0100
+++ wireless-testing/net/mac80211/driver-ops.h	2009-11-25 20:29:24.000000000 +0100
@@ -39,7 +39,7 @@ static inline int drv_add_interface(stru
 				    struct ieee80211_if_init_conf *conf)
 {
 	int ret = local->ops->add_interface(&local->hw, conf);
-	trace_drv_add_interface(local, conf->vif, ret);
+	trace_drv_add_interface(local, vif_to_sdata(conf->vif), ret);
 	return ret;
 }
 
@@ -47,7 +47,7 @@ static inline void drv_remove_interface(
 					struct ieee80211_if_init_conf *conf)
 {
 	local->ops->remove_interface(&local->hw, conf);
-	trace_drv_remove_interface(local, conf->vif);
+	trace_drv_remove_interface(local, vif_to_sdata(conf->vif));
 }
 
 static inline int drv_config(struct ieee80211_local *local, u32 changed)
@@ -58,13 +58,13 @@ static inline int drv_config(struct ieee
 }
 
 static inline void drv_bss_info_changed(struct ieee80211_local *local,
-					struct ieee80211_vif *vif,
+					struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_bss_conf *info,
 					u32 changed)
 {
 	if (local->ops->bss_info_changed)
-		local->ops->bss_info_changed(&local->hw, vif, info, changed);
-	trace_drv_bss_info_changed(local, vif, info, changed);
+		local->ops->bss_info_changed(&local->hw, &sdata->vif, info, changed);
+	trace_drv_bss_info_changed(local, sdata, info, changed);
 }
 
 static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
@@ -106,12 +106,13 @@ static inline int drv_set_tim(struct iee
 }
 
 static inline int drv_set_key(struct ieee80211_local *local,
-			      enum set_key_cmd cmd, struct ieee80211_vif *vif,
+			      enum set_key_cmd cmd,
+			      struct ieee80211_sub_if_data *sdata,
 			      struct ieee80211_sta *sta,
 			      struct ieee80211_key_conf *key)
 {
-	int ret = local->ops->set_key(&local->hw, cmd, vif, sta, key);
-	trace_drv_set_key(local, cmd, vif, sta, key, ret);
+	int ret = local->ops->set_key(&local->hw, cmd, &sdata->vif, sta, key);
+	trace_drv_set_key(local, cmd, sdata, sta, key, ret);
 	return ret;
 }
 
@@ -179,13 +180,13 @@ static inline int drv_set_rts_threshold(
 }
 
 static inline void drv_sta_notify(struct ieee80211_local *local,
-				  struct ieee80211_vif *vif,
+				  struct ieee80211_sub_if_data *sdata,
 				  enum sta_notify_cmd cmd,
 				  struct ieee80211_sta *sta)
 {
 	if (local->ops->sta_notify)
-		local->ops->sta_notify(&local->hw, vif, cmd, sta);
-	trace_drv_sta_notify(local, vif, cmd, sta);
+		local->ops->sta_notify(&local->hw, &sdata->vif, cmd, sta);
+	trace_drv_sta_notify(local, sdata, cmd, sta);
 }
 
 static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
@@ -239,16 +240,16 @@ static inline int drv_tx_last_beacon(str
 }
 
 static inline int drv_ampdu_action(struct ieee80211_local *local,
-				   struct ieee80211_vif *vif,
+				   struct ieee80211_sub_if_data *sdata,
 				   enum ieee80211_ampdu_mlme_action action,
 				   struct ieee80211_sta *sta, u16 tid,
 				   u16 *ssn)
 {
 	int ret = -EOPNOTSUPP;
 	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(&local->hw, vif, action,
+		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
 					       sta, tid, ssn);
-	trace_drv_ampdu_action(local, vif, action, sta, tid, ssn, ret);
+	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn, ret);
 	return ret;
 }
 
--- wireless-testing.orig/net/mac80211/driver-trace.h	2009-11-25 20:29:23.000000000 +0100
+++ wireless-testing/net/mac80211/driver-trace.h	2009-11-25 20:29:24.000000000 +0100
@@ -25,10 +25,12 @@ static inline void trace_ ## name(proto)
 #define STA_PR_FMT	" sta:%pM"
 #define STA_PR_ARG	__entry->sta_addr
 
-#define VIF_ENTRY	__field(enum nl80211_iftype, vif_type) __field(void *, vif)
-#define VIF_ASSIGN	__entry->vif_type = vif ? vif->type : 0; __entry->vif = vif
-#define VIF_PR_FMT	" vif:%p(%d)"
-#define VIF_PR_ARG	__entry->vif, __entry->vif_type
+#define VIF_ENTRY	__field(enum nl80211_iftype, vif_type) __field(void *, sdata) \
+			__string(vif_name, sdata->dev ? sdata->dev->name : "<nodev>")
+#define VIF_ASSIGN	__entry->vif_type = sdata->vif.type; __entry->sdata = sdata; \
+			__assign_str(vif_name, sdata->dev ? sdata->dev->name : "<nodev>")
+#define VIF_PR_FMT	" vif:%s(%d)"
+#define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type
 
 TRACE_EVENT(drv_start,
 	TP_PROTO(struct ieee80211_local *local, int ret),
@@ -70,10 +72,10 @@ TRACE_EVENT(drv_stop,
 
 TRACE_EVENT(drv_add_interface,
 	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_vif *vif,
+		 struct ieee80211_sub_if_data *sdata,
 		 int ret),
 
-	TP_ARGS(local, vif, ret),
+	TP_ARGS(local, sdata, ret),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -85,7 +87,7 @@ TRACE_EVENT(drv_add_interface,
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
-		memcpy(__entry->addr, vif->addr, 6);
+		memcpy(__entry->addr, sdata->vif.addr, 6);
 		__entry->ret = ret;
 	),
 
@@ -96,9 +98,9 @@ TRACE_EVENT(drv_add_interface,
 );
 
 TRACE_EVENT(drv_remove_interface,
-	TP_PROTO(struct ieee80211_local *local, struct ieee80211_vif *vif),
+	TP_PROTO(struct ieee80211_local *local, struct ieee80211_sub_if_data *sdata),
 
-	TP_ARGS(local, vif),
+	TP_ARGS(local, sdata),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -109,7 +111,7 @@ TRACE_EVENT(drv_remove_interface,
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
-		memcpy(__entry->addr, vif->addr, 6);
+		memcpy(__entry->addr, sdata->vif.addr, 6);
 	),
 
 	TP_printk(
@@ -163,11 +165,11 @@ TRACE_EVENT(drv_config,
 
 TRACE_EVENT(drv_bss_info_changed,
 	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_vif *vif,
+		 struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_bss_conf *info,
 		 u32 changed),
 
-	TP_ARGS(local, vif, info, changed),
+	TP_ARGS(local, sdata, info, changed),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -291,11 +293,11 @@ TRACE_EVENT(drv_set_tim,
 
 TRACE_EVENT(drv_set_key,
 	TP_PROTO(struct ieee80211_local *local,
-		 enum set_key_cmd cmd, struct ieee80211_vif *vif,
+		 enum set_key_cmd cmd, struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_sta *sta,
 		 struct ieee80211_key_conf *key, int ret),
 
-	TP_ARGS(local, cmd, vif, sta, key, ret),
+	TP_ARGS(local, cmd, sdata, sta, key, ret),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -489,11 +491,11 @@ TRACE_EVENT(drv_set_rts_threshold,
 
 TRACE_EVENT(drv_sta_notify,
 	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_vif *vif,
+		 struct ieee80211_sub_if_data *sdata,
 		 enum sta_notify_cmd cmd,
 		 struct ieee80211_sta *sta),
 
-	TP_ARGS(local, vif, cmd, sta),
+	TP_ARGS(local, sdata, cmd, sta),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -654,12 +656,12 @@ TRACE_EVENT(drv_tx_last_beacon,
 
 TRACE_EVENT(drv_ampdu_action,
 	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_vif *vif,
+		 struct ieee80211_sub_if_data *sdata,
 		 enum ieee80211_ampdu_mlme_action action,
 		 struct ieee80211_sta *sta, u16 tid,
 		 u16 *ssn, int ret),
 
-	TP_ARGS(local, vif, action, sta, tid, ssn, ret),
+	TP_ARGS(local, sdata, action, sta, tid, ssn, ret),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
--- wireless-testing.orig/net/mac80211/key.c	2009-11-25 20:29:23.000000000 +0100
+++ wireless-testing/net/mac80211/key.c	2009-11-25 20:29:24.000000000 +0100
@@ -139,7 +139,7 @@ static void ieee80211_key_enable_hw_acce
 				     struct ieee80211_sub_if_data,
 				     u.ap);
 
-	ret = drv_set_key(key->local, SET_KEY, &sdata->vif, sta, &key->conf);
+	ret = drv_set_key(key->local, SET_KEY, sdata, sta, &key->conf);
 
 	if (!ret) {
 		spin_lock_bh(&todo_lock);
@@ -181,7 +181,7 @@ static void ieee80211_key_disable_hw_acc
 				     struct ieee80211_sub_if_data,
 				     u.ap);
 
-	ret = drv_set_key(key->local, DISABLE_KEY, &sdata->vif,
+	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
 			  sta, &key->conf);
 
 	if (ret)
--- wireless-testing.orig/net/mac80211/main.c	2009-11-25 20:29:23.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-11-25 20:29:24.000000000 +0100
@@ -222,8 +222,7 @@ void ieee80211_bss_info_change_notify(st
 		}
 	}
 
-	drv_bss_info_changed(local, &sdata->vif,
-			     &sdata->vif.bss_conf, changed);
+	drv_bss_info_changed(local, sdata, &sdata->vif.bss_conf, changed);
 }
 
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
--- wireless-testing.orig/net/mac80211/pm.c	2009-11-25 20:29:23.000000000 +0100
+++ wireless-testing/net/mac80211/pm.c	2009-11-25 20:29:24.000000000 +0100
@@ -65,7 +65,7 @@ int __ieee80211_suspend(struct ieee80211
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
-			drv_sta_notify(local, &sdata->vif, STA_NOTIFY_REMOVE,
+			drv_sta_notify(local, sdata, STA_NOTIFY_REMOVE,
 				       &sta->sta);
 		}
 
--- wireless-testing.orig/net/mac80211/rx.c	2009-11-25 20:29:23.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-25 20:29:24.000000000 +0100
@@ -1021,7 +1021,7 @@ static void ap_sta_ps_start(struct sta_i
 
 	atomic_inc(&sdata->bss->num_sta_ps);
 	set_sta_flags(sta, WLAN_STA_PS_STA);
-	drv_sta_notify(local, &sdata->vif, STA_NOTIFY_SLEEP, &sta->sta);
+	drv_sta_notify(local, sdata, STA_NOTIFY_SLEEP, &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d enters power save mode\n",
 	       sdata->name, sta->sta.addr, sta->sta.aid);
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-11-25 20:29:23.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-11-25 20:29:24.000000000 +0100
@@ -397,7 +397,7 @@ int sta_info_insert(struct sta_info *sta
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
-		drv_sta_notify(local, &sdata->vif, STA_NOTIFY_ADD, &sta->sta);
+		drv_sta_notify(local, sdata, STA_NOTIFY_ADD, &sta->sta);
 		sdata = sta->sdata;
 	}
 
@@ -537,7 +537,7 @@ static void __sta_info_unlink(struct sta
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
-		drv_sta_notify(local, &sdata->vif, STA_NOTIFY_REMOVE,
+		drv_sta_notify(local, sdata, STA_NOTIFY_REMOVE,
 			       &(*sta)->sta);
 		sdata = (*sta)->sdata;
 	}
@@ -876,7 +876,7 @@ void ieee80211_sta_ps_deliver_wakeup(str
 	struct ieee80211_local *local = sdata->local;
 	int sent, buffered;
 
-	drv_sta_notify(local, &sdata->vif, STA_NOTIFY_AWAKE, &sta->sta);
+	drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
 	if (!skb_queue_empty(&sta->ps_tx_buf))
 		sta_info_clear_tim_bit(sta);
--- wireless-testing.orig/net/mac80211/util.c	2009-11-25 20:29:23.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-11-25 20:29:24.000000000 +0100
@@ -1066,7 +1066,7 @@ int ieee80211_reconfig(struct ieee80211_
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
-			drv_sta_notify(local, &sdata->vif, STA_NOTIFY_ADD,
+			drv_sta_notify(local, sdata, STA_NOTIFY_ADD,
 				       &sta->sta);
 		}
 		spin_unlock_irqrestore(&local->sta_lock, flags);


