Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47064 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbbHOTkn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 15:40:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 7/9] mac80211: allow to transmit A-MSDU within A-MPDU
Date: Sat, 15 Aug 2015 22:39:52 +0300
Message-Id: <1439667594-13632-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150815_214048_876351_13C272DA)
In-Reply-To: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Advertise the capability to send A-MSDU within A-MPDU
in the AddBA request sent by mac80211. Let the driver
know about the peer's capabilities.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/mac80211_hwsim.c       |  2 +-
 include/linux/ieee80211.h                   |  1 +
 include/net/mac80211.h                      |  5 ++++-
 net/mac80211/agg-rx.c                       |  4 ++--
 net/mac80211/agg-tx.c                       | 15 ++++++++++-----
 net/mac80211/driver-ops.h                   |  7 ++++---
 net/mac80211/sta_info.h                     |  2 ++
 net/mac80211/trace.h                        | 10 ++++++----
 10 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 7acaa26..26445a5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -719,7 +719,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   enum ieee80211_ampdu_mlme_action action,
 				   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				   u8 buf_size)
+				   u8 buf_size, bool amsdu)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int ret = -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index dfdab38..dc46919 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -815,7 +815,7 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    enum ieee80211_ampdu_mlme_action action,
 				    struct ieee80211_sta *sta, u16 tid,
-				    u16 *ssn, u8 buf_size)
+				    u16 *ssn, u8 buf_size, bool amsdu)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index dbb46ec..6d2a622 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1819,7 +1819,7 @@ static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       enum ieee80211_ampdu_mlme_action action,
 				       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				       u8 buf_size)
+				       u8 buf_size, bool amsdu)
 {
 	switch (action) {
 	case IEEE80211_AMPDU_TX_START:
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index cfa906f..19eb9ec 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1379,6 +1379,7 @@ struct ieee80211_ht_operation {
 
 
 /* block-ack parameters */
+#define IEEE80211_ADDBA_PARAM_AMSDU_MASK 0x0001
 #define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
 #define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
 #define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFC0
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 344424c..d37d6cd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3033,6 +3033,9 @@ enum ieee80211_reconfig_type {
  *	buffer size of 8. Correct ways to retransmit #1 would be:
  *	 - TX:       1 or 18 or 81
  *	Even "189" would be wrong since 1 could be lost again.
+ *	The @amsdu parameter is valid when the action is set to
+ *	%IEEE80211_AMPDU_TX_OPERATIONAL and indicates the peer's ability
+ *	to receive A-MSDU within A-MPDU.
  *
  *	Returns a negative error code on failure.
  *	The callback can sleep.
@@ -3370,7 +3373,7 @@ struct ieee80211_ops {
 			    struct ieee80211_vif *vif,
 			    enum ieee80211_ampdu_mlme_action action,
 			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			    u8 buf_size);
+			    u8 buf_size, bool amsdu);
 	int (*get_survey)(struct ieee80211_hw *hw, int idx,
 		struct survey_info *survey);
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 78de79b..10ad4ac 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -79,7 +79,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	       (int)reason);
 
 	if (drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_STOP,
-			     &sta->sta, tid, NULL, 0))
+			     &sta->sta, tid, NULL, 0, false))
 		sdata_info(sta->sdata,
 			   "HW problem - can not stop rx aggregation for %pM tid %d\n",
 			   sta->sta.addr, tid);
@@ -323,7 +323,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 		__skb_queue_head_init(&tid_agg_rx->reorder_buf[i]);
 
 	ret = drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_START,
-			       &sta->sta, tid, &start_seq_num, 0);
+			       &sta->sta, tid, &start_seq_num, 0, false);
 	ht_dbg(sta->sdata, "Rx A-MPDU request on %pM tid %d result %d\n",
 	       sta->sta.addr, tid, ret);
 	if (ret) {
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index c8ba2e7..a758eb84 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -97,7 +97,8 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.addba_req.action_code = WLAN_ACTION_ADDBA_REQ;
 
 	mgmt->u.action.u.addba_req.dialog_token = dialog_token;
-	capab = (u16)(1 << 1);		/* bit 1 aggregation policy */
+	capab = (u16)(1 << 0);		/* bit 0 A-MSDU support */
+	capab |= (u16)(1 << 1);		/* bit 1 aggregation policy */
 	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
 	capab |= (u16)(agg_size << 6);	/* bit 15:6 max size of aggergation */
 
@@ -331,7 +332,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 			return -EALREADY;
 		ret = drv_ampdu_action(local, sta->sdata,
 				       IEEE80211_AMPDU_TX_STOP_FLUSH_CONT,
-				       &sta->sta, tid, NULL, 0);
+				       &sta->sta, tid, NULL, 0, false);
 		WARN_ON_ONCE(ret);
 		return 0;
 	}
@@ -381,7 +382,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	tid_tx->tx_stop = reason == AGG_STOP_LOCAL_REQUEST;
 
 	ret = drv_ampdu_action(local, sta->sdata, action,
-			       &sta->sta, tid, NULL, 0);
+			       &sta->sta, tid, NULL, 0, false);
 
 	/* HW shall not deny going back to legacy */
 	if (WARN_ON(ret)) {
@@ -469,7 +470,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	start_seq_num = sta->tid_seq[tid] >> 4;
 
 	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
-			       &sta->sta, tid, &start_seq_num, 0);
+			       &sta->sta, tid, &start_seq_num, 0, false);
 	if (ret) {
 		ht_dbg(sdata,
 		       "BA request denied - HW unavailable for %pM tid %d\n",
@@ -693,7 +694,8 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 
 	drv_ampdu_action(local, sta->sdata,
 			 IEEE80211_AMPDU_TX_OPERATIONAL,
-			 &sta->sta, tid, NULL, tid_tx->buf_size);
+			 &sta->sta, tid, NULL, tid_tx->buf_size,
+			 tid_tx->amsdu);
 
 	/*
 	 * synchronize with TX path, while splicing the TX path
@@ -918,8 +920,10 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 	struct tid_ampdu_tx *tid_tx;
 	u16 capab, tid;
 	u8 buf_size;
+	bool amsdu;
 
 	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
+	amsdu = capab & IEEE80211_ADDBA_PARAM_AMSDU_MASK;
 	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
 	buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
 
@@ -968,6 +972,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 		}
 
 		tid_tx->buf_size = buf_size;
+		tid_tx->amsdu = amsdu;
 
 		if (test_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state))
 			ieee80211_agg_tx_operational(local, sta, tid);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 157b20b..31482e2 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -734,7 +734,7 @@ static inline int drv_ampdu_action(struct ieee80211_local *local,
 				   struct ieee80211_sub_if_data *sdata,
 				   enum ieee80211_ampdu_mlme_action action,
 				   struct ieee80211_sta *sta, u16 tid,
-				   u16 *ssn, u8 buf_size)
+				   u16 *ssn, u8 buf_size, bool amsdu)
 {
 	int ret = -EOPNOTSUPP;
 
@@ -744,11 +744,12 @@ static inline int drv_ampdu_action(struct ieee80211_local *local,
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
 
-	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn, buf_size);
+	trace_drv_ampdu_action(local, sdata, action, sta, tid,
+			       ssn, buf_size, amsdu);
 
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
-					       sta, tid, ssn, buf_size);
+					       sta, tid, ssn, buf_size, amsdu);
 
 	trace_drv_return_int(local, ret);
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index b087c71..d5ded87 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -133,6 +133,7 @@ enum ieee80211_agg_stop_reason {
  * @buf_size: reorder buffer size at receiver
  * @failed_bar_ssn: ssn of the last failed BAR tx attempt
  * @bar_pending: BAR needs to be re-sent
+ * @amsdu: support A-MSDU withing A-MDPU
  *
  * This structure's lifetime is managed by RCU, assignments to
  * the array holding it must hold the aggregation mutex.
@@ -158,6 +159,7 @@ struct tid_ampdu_tx {
 
 	u16 failed_bar_ssn;
 	bool bar_pending;
+	bool amsdu;
 };
 
 /**
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index b5960b9..314e3bd 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -974,9 +974,9 @@ TRACE_EVENT(drv_ampdu_action,
 		 struct ieee80211_sub_if_data *sdata,
 		 enum ieee80211_ampdu_mlme_action action,
 		 struct ieee80211_sta *sta, u16 tid,
-		 u16 *ssn, u8 buf_size),
+		 u16 *ssn, u8 buf_size, bool amsdu),
 
-	TP_ARGS(local, sdata, action, sta, tid, ssn, buf_size),
+	TP_ARGS(local, sdata, action, sta, tid, ssn, buf_size, amsdu),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -985,6 +985,7 @@ TRACE_EVENT(drv_ampdu_action,
 		__field(u16, tid)
 		__field(u16, ssn)
 		__field(u8, buf_size)
+		__field(bool, amsdu)
 		VIF_ENTRY
 	),
 
@@ -996,12 +997,13 @@ TRACE_EVENT(drv_ampdu_action,
 		__entry->tid = tid;
 		__entry->ssn = ssn ? *ssn : 0;
 		__entry->buf_size = buf_size;
+		__entry->amsdu = amsdu;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " action:%d tid:%d buf:%d",
+		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " action:%d tid:%d buf:%d amsdu:%d",
 		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->action,
-		__entry->tid, __entry->buf_size
+		__entry->tid, __entry->buf_size, __entry->amsdu
 	)
 );
 
-- 
2.1.4

