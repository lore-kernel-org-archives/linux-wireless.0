Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15488 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbbLHRJN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 12:09:13 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] mac80211: pass block ack session timeout to to driver
Date: Tue,  8 Dec 2015 19:09:04 +0200
Message-Id: <1449594545-31028-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151208_180926_958575_67AD6681)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently mac80211 does not inform the driver of the session
block ack timeout when starting a rx aggregation session.
Drivers that manage the reorder buffer need to know this
parameter.
Seeing that there are now too many arguments for the
drv_ampdu_action() function, wrap them inside a structure.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  9 +++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 10 ++++--
 drivers/net/wireless/mac80211_hwsim.c       |  8 +++--
 include/net/mac80211.h                      | 44 ++++++++++++++++--------
 net/mac80211/agg-rx.c                       | 25 +++++++++++---
 net/mac80211/agg-tx.c                       | 53 +++++++++++++++++++----------
 net/mac80211/driver-ops.c                   | 10 ++----
 net/mac80211/driver-ops.h                   |  4 +--
 net/mac80211/trace.h                        | 41 +++++++++++-----------
 9 files changed, 129 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index b3ad34e..1eb1a82 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -729,12 +729,15 @@ static inline bool iwl_enable_tx_ampdu(const struct iwl_cfg *cfg)
 
 static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
-				   enum ieee80211_ampdu_mlme_action action,
-				   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				   u8 buf_size, bool amsdu)
+				   struct ieee80211_ampdu_params *params)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int ret = -EINVAL;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+	u8 buf_size = params->buf_size;
 	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
 
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 1fb6846..3b124cf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -826,13 +826,17 @@ iwl_mvm_ampdu_check_trigger(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
-				    enum ieee80211_ampdu_mlme_action action,
-				    struct ieee80211_sta *sta, u16 tid,
-				    u16 *ssn, u8 buf_size, bool amsdu)
+				    struct ieee80211_ampdu_params *params)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
 	bool tx_agg_ref = false;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+	u8 buf_size = params->buf_size;
+	bool amsdu = params->amsdu;
 
 	IWL_DEBUG_HT(mvm, "A-MPDU action on addr %pM tid %d: action %d\n",
 		     sta->addr, tid, action);
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c32889a..e31a94f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1845,10 +1845,12 @@ static int mac80211_hwsim_testmode_cmd(struct ieee80211_hw *hw,
 
 static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
-				       enum ieee80211_ampdu_mlme_action action,
-				       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				       u8 buf_size, bool amsdu)
+				       struct ieee80211_ampdu_params *params)
 {
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+
 	switch (action) {
 	case IEEE80211_AMPDU_TX_START:
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 54af948..0fad29c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2717,6 +2717,33 @@ enum ieee80211_ampdu_mlme_action {
 };
 
 /**
+ * struct ieee80211_ampdu_params - AMPDU action parameters
+ *
+ * @action: the ampdu action, value from %ieee80211_ampdu_mlme_action.
+ * @sta: peer of this AMPDU session
+ * @tid: tid of the BA session
+ * @ssn: start sequence number of the session. TX/RX_STOP can pass 0. When
+ *	action is set to %IEEE80211_AMPDU_RX_START the driver passes back the
+ *	actual ssn value used to start the session and writes the value here.
+ * @buf_size: reorder buffer size  (number of subframes). Valid only when the
+ *	action is set to %IEEE80211_AMPDU_RX_START or
+ *	%IEEE80211_AMPDU_TX_OPERATIONAL
+ * @amsdu: indicates the peer's ability to receive A-MSDU within A-MPDU.
+ *	valid when the action is set to %IEEE80211_AMPDU_TX_OPERATIONAL
+ * @timeout: BA session timeout. Valid only when the action is set to
+ *	%IEEE80211_AMPDU_RX_START
+ */
+struct ieee80211_ampdu_params {
+	enum ieee80211_ampdu_mlme_action action;
+	struct ieee80211_sta *sta;
+	u16 tid;
+	u16 ssn;
+	u8 buf_size;
+	bool amsdu;
+	u16 timeout;
+};
+
+/**
  * enum ieee80211_frame_release_type - frame release reason
  * @IEEE80211_FRAME_RELEASE_PSPOLL: frame released for PS-Poll
  * @IEEE80211_FRAME_RELEASE_UAPSD: frame(s) released due to
@@ -3060,15 +3087,9 @@ enum ieee80211_reconfig_type {
  * @ampdu_action: Perform a certain A-MPDU action
  * 	The RA/TID combination determines the destination and TID we want
  * 	the ampdu action to be performed for. The action is defined through
- * 	ieee80211_ampdu_mlme_action. Starting sequence number (@ssn)
- * 	is the first frame we expect to perform the action on. Notice
- * 	that TX/RX_STOP can pass NULL for this parameter.
- *	The @buf_size parameter is valid only when the action is set to
- *	%IEEE80211_AMPDU_RX_START or %IEEE80211_AMPDU_TX_OPERATIONAL and
- *	indicates the reorder buffer size (number of subframes) for this
- *	session.
+ *	ieee80211_ampdu_mlme_action.
  *	When the action is set to %IEEE80211_AMPDU_TX_OPERATIONAL the driver
- *	may neither send aggregates containing more subframes than this
+ *	may neither send aggregates containing more subframes than @buf_size
  *	nor send aggregates in a way that lost frames would exceed the
  *	buffer size. If just limiting the aggregate size, this would be
  *	possible with a buf_size of 8:
@@ -3079,9 +3100,6 @@ enum ieee80211_reconfig_type {
  *	buffer size of 8. Correct ways to retransmit #1 would be:
  *	 - TX:       1 or 18 or 81
  *	Even "189" would be wrong since 1 could be lost again.
- *	The @amsdu parameter is valid when the action is set to
- *	%IEEE80211_AMPDU_TX_OPERATIONAL and indicates the peer's ability
- *	to receive A-MSDU within A-MPDU.
  *
  *	Returns a negative error code on failure.
  *	The callback can sleep.
@@ -3423,9 +3441,7 @@ struct ieee80211_ops {
 	int (*tx_last_beacon)(struct ieee80211_hw *hw);
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
-			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			    u8 buf_size, bool amsdu);
+			    struct ieee80211_ampdu_params *params);
 	int (*get_survey)(struct ieee80211_hw *hw, int idx,
 		struct survey_info *survey);
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 7867273..ec80db7 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -7,6 +7,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -61,6 +62,14 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_rx *tid_rx;
+	struct ieee80211_ampdu_params params = {
+		.sta = &sta->sta,
+		.action = IEEE80211_AMPDU_RX_STOP,
+		.tid = tid,
+		.amsdu = false,
+		.timeout = 0,
+		.ssn = 0,
+	};
 
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
@@ -78,8 +87,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "inititator",
 	       (int)reason);
 
-	if (drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_STOP,
-			     &sta->sta, tid, NULL, 0, false))
+	if (drv_ampdu_action(local, sta->sdata, &params))
 		sdata_info(sta->sdata,
 			   "HW problem - can not stop rx aggregation for %pM tid %d\n",
 			   sta->sta.addr, tid);
@@ -237,6 +245,15 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 {
 	struct ieee80211_local *local = sta->sdata->local;
 	struct tid_ampdu_rx *tid_agg_rx;
+	struct ieee80211_ampdu_params params = {
+		.sta = &sta->sta,
+		.action = IEEE80211_AMPDU_RX_START,
+		.tid = tid,
+		.amsdu = false,
+		.timeout = timeout,
+		.ssn = start_seq_num,
+	};
+
 	int i, ret = -EOPNOTSUPP;
 	u16 status = WLAN_STATUS_REQUEST_DECLINED;
 
@@ -275,6 +292,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	/* make sure the size doesn't exceed the maximum supported by the hw */
 	if (buf_size > local->hw.max_rx_aggregation_subframes)
 		buf_size = local->hw.max_rx_aggregation_subframes;
+	params.buf_size = buf_size;
 
 	/* examine state machine */
 	mutex_lock(&sta->ampdu_mlme.mtx);
@@ -322,8 +340,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	for (i = 0; i < buf_size; i++)
 		__skb_queue_head_init(&tid_agg_rx->reorder_buf[i]);
 
-	ret = drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_START,
-			       &sta->sta, tid, &start_seq_num, buf_size, false);
+	ret = drv_ampdu_action(local, sta->sdata, &params);
 	ht_dbg(sta->sdata, "Rx A-MPDU request on %pM tid %d result %d\n",
 	       sta->sta.addr, tid, ret);
 	if (ret) {
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index ff75718..4932e9f 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -7,6 +7,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -295,7 +296,14 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_tx *tid_tx;
-	enum ieee80211_ampdu_mlme_action action;
+	struct ieee80211_ampdu_params params = {
+		.sta = &sta->sta,
+		.tid = tid,
+		.buf_size = 0,
+		.amsdu = false,
+		.timeout = 0,
+		.ssn = 0,
+	};
 	int ret;
 
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
@@ -304,10 +312,10 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	case AGG_STOP_DECLINED:
 	case AGG_STOP_LOCAL_REQUEST:
 	case AGG_STOP_PEER_REQUEST:
-		action = IEEE80211_AMPDU_TX_STOP_CONT;
+		params.action = IEEE80211_AMPDU_TX_STOP_CONT;
 		break;
 	case AGG_STOP_DESTROY_STA:
-		action = IEEE80211_AMPDU_TX_STOP_FLUSH;
+		params.action = IEEE80211_AMPDU_TX_STOP_FLUSH;
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -330,9 +338,8 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 		spin_unlock_bh(&sta->lock);
 		if (reason != AGG_STOP_DESTROY_STA)
 			return -EALREADY;
-		ret = drv_ampdu_action(local, sta->sdata,
-				       IEEE80211_AMPDU_TX_STOP_FLUSH_CONT,
-				       &sta->sta, tid, NULL, 0, false);
+		params.action = IEEE80211_AMPDU_TX_STOP_FLUSH_CONT;
+		ret = drv_ampdu_action(local, sta->sdata, &params);
 		WARN_ON_ONCE(ret);
 		return 0;
 	}
@@ -381,8 +388,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 					WLAN_BACK_INITIATOR;
 	tid_tx->tx_stop = reason == AGG_STOP_LOCAL_REQUEST;
 
-	ret = drv_ampdu_action(local, sta->sdata, action,
-			       &sta->sta, tid, NULL, 0, false);
+	ret = drv_ampdu_action(local, sta->sdata, &params);
 
 	/* HW shall not deny going back to legacy */
 	if (WARN_ON(ret)) {
@@ -445,7 +451,14 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	u16 start_seq_num;
+	struct ieee80211_ampdu_params params = {
+		.sta = &sta->sta,
+		.action = IEEE80211_AMPDU_TX_START,
+		.tid = tid,
+		.buf_size = 0,
+		.amsdu = false,
+		.timeout = 0,
+	};
 	int ret;
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
@@ -467,10 +480,8 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	 */
 	synchronize_net();
 
-	start_seq_num = sta->tid_seq[tid] >> 4;
-
-	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
-			       &sta->sta, tid, &start_seq_num, 0, false);
+	params.ssn = sta->tid_seq[tid] >> 4;
+	ret = drv_ampdu_action(local, sdata, &params);
 	if (ret) {
 		ht_dbg(sdata,
 		       "BA request denied - HW unavailable for %pM tid %d\n",
@@ -499,7 +510,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 
 	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
-				     tid_tx->dialog_token, start_seq_num,
+				     tid_tx->dialog_token, params.ssn,
 				     IEEE80211_MAX_AMPDU_BUF,
 				     tid_tx->timeout);
 }
@@ -684,18 +695,24 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 					 struct sta_info *sta, u16 tid)
 {
 	struct tid_ampdu_tx *tid_tx;
+	struct ieee80211_ampdu_params params = {
+		.sta = &sta->sta,
+		.action = IEEE80211_AMPDU_TX_OPERATIONAL,
+		.tid = tid,
+		.timeout = 0,
+		.ssn = 0,
+	};
 
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+	params.buf_size = tid_tx->buf_size;
+	params.amsdu = tid_tx->amsdu;
 
 	ht_dbg(sta->sdata, "Aggregation is on for %pM tid %d\n",
 	       sta->sta.addr, tid);
 
-	drv_ampdu_action(local, sta->sdata,
-			 IEEE80211_AMPDU_TX_OPERATIONAL,
-			 &sta->sta, tid, NULL, tid_tx->buf_size,
-			 tid_tx->amsdu);
+	drv_ampdu_action(local, sta->sdata, &params);
 
 	/*
 	 * synchronize with TX path, while splicing the TX path
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index ca1fe55..c258f10 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -284,9 +284,7 @@ int drv_switch_vif_chanctx(struct ieee80211_local *local,
 
 int drv_ampdu_action(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
-		     enum ieee80211_ampdu_mlme_action action,
-		     struct ieee80211_sta *sta, u16 tid,
-		     u16 *ssn, u8 buf_size, bool amsdu)
+		     struct ieee80211_ampdu_params *params)
 {
 	int ret = -EOPNOTSUPP;
 
@@ -296,12 +294,10 @@ int drv_ampdu_action(struct ieee80211_local *local,
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
 
-	trace_drv_ampdu_action(local, sdata, action, sta, tid,
-			       ssn, buf_size, amsdu);
+	trace_drv_ampdu_action(local, sdata, params);
 
 	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
-					       sta, tid, ssn, buf_size, amsdu);
+		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, params);
 
 	trace_drv_return_int(local, ret);
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 154ce4b..18b0d65 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -585,9 +585,7 @@ static inline int drv_tx_last_beacon(struct ieee80211_local *local)
 
 int drv_ampdu_action(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
-		     enum ieee80211_ampdu_mlme_action action,
-		     struct ieee80211_sta *sta, u16 tid,
-		     u16 *ssn, u8 buf_size, bool amsdu);
+		     struct ieee80211_ampdu_params *params);
 
 static inline int drv_get_survey(struct ieee80211_local *local, int idx,
 				struct survey_info *survey)
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a6b4442..5a29bb0 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -80,7 +80,21 @@
 #define KEY_PR_FMT	" cipher:0x%x, flags=%#x, keyidx=%d, hw_key_idx=%d"
 #define KEY_PR_ARG	__entry->cipher, __entry->flags, __entry->keyidx, __entry->hw_key_idx
 
-
+#define AMPDU_ACTION_ENTRY	__field(enum ieee80211_ampdu_mlme_action, ieee80211_ampdu_mlme_action)	\
+				STA_ENTRY								\
+				__field(u16, tid)							\
+				__field(u16, ssn)							\
+				__field(u8, buf_size)							\
+				__field(bool, amsdu)							\
+				__field(u16, timeout)
+#define AMPDU_ACTION_ASSIGN	STA_NAMED_ASSIGN(params->sta);						\
+				__entry->tid = params->tid;						\
+				__entry->ssn = params->ssn;						\
+				__entry->buf_size = params->buf_size;					\
+				__entry->amsdu = params->amsdu;						\
+				__entry->timeout = params->timeout;
+#define AMPDU_ACTION_PR_FMT	STA_PR_FMT " tid %d, ssn %d, buf_size %u, amsdu %d, timeout %d"
+#define AMPDU_ACTION_PR_ARG	STA_PR_ARG, __entry->tid, __entry->ssn, __entry->buf_size, __entry->amsdu, __entry->timeout
 
 /*
  * Tracing for driver callbacks.
@@ -970,38 +984,25 @@ DEFINE_EVENT(local_only_evt, drv_tx_last_beacon,
 TRACE_EVENT(drv_ampdu_action,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-		 enum ieee80211_ampdu_mlme_action action,
-		 struct ieee80211_sta *sta, u16 tid,
-		 u16 *ssn, u8 buf_size, bool amsdu),
+		 struct ieee80211_ampdu_params *params),
 
-	TP_ARGS(local, sdata, action, sta, tid, ssn, buf_size, amsdu),
+	TP_ARGS(local, sdata, params),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
-		STA_ENTRY
-		__field(u32, action)
-		__field(u16, tid)
-		__field(u16, ssn)
-		__field(u8, buf_size)
-		__field(bool, amsdu)
 		VIF_ENTRY
+		AMPDU_ACTION_ENTRY
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
-		STA_ASSIGN;
-		__entry->action = action;
-		__entry->tid = tid;
-		__entry->ssn = ssn ? *ssn : 0;
-		__entry->buf_size = buf_size;
-		__entry->amsdu = amsdu;
+		AMPDU_ACTION_ASSIGN;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " action:%d tid:%d buf:%d amsdu:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->action,
-		__entry->tid, __entry->buf_size, __entry->amsdu
+		LOCAL_PR_FMT VIF_PR_FMT AMPDU_ACTION_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG, AMPDU_ACTION_PR_ARG
 	)
 );
 
-- 
2.5.0

