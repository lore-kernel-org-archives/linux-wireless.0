Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:40761 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237Ab0GONTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jul 2010 09:19:45 -0400
Message-ID: <4C3F0AA3.4050706@marvell.com>
Date: Thu, 15 Jul 2010 18:48:27 +0530
From: yogeshp <yogeshp@marvell.com>
MIME-Version: 1.0
To: linville@tuxdriver.com
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: indicate BA window size with IEEE80211_AMPDU_TX_OPERATIONAL
 drv_ampud_action
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BA window size for a successful BA setup is not made available to the driver by
mac80211. The patch below gets the BA window size from addba response and
indicates it to driver through IEEE80211_AMPDU_TX_OPERATIONAL drv_ampdu_action.

Signed-off-by: yogeshp@marvell.com
Signed-off-by: nishants@marvell.com
---
 include/net/mac80211.h      |    3 ++-
 net/mac80211/agg-rx.c       |    4 ++--
 net/mac80211/agg-tx.c       |   17 ++++++++++-------
 net/mac80211/driver-ops.h   |    6 +++---
 net/mac80211/driver-trace.h |    2 +-
 net/mac80211/sta_info.h     |    1 +
 6 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7f256e2..29ff874 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1734,7 +1734,8 @@ struct ieee80211_ops {
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
+				struct ieee80211_sta *sta, u16 tid,
+				u16 buf_size, u16 *ssn);
 	int (*get_survey)(struct ieee80211_hw *hw, int idx,
 		struct survey_info *survey);
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 965b272..8a2522f 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -76,7 +76,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	if (drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_STOP,
-			     &sta->sta, tid, NULL))
+			     &sta->sta, tid, 0, NULL))
 		printk(KERN_DEBUG "HW problem - can not stop rx "
 				"aggregation for tid %d\n", tid);
 
@@ -274,7 +274,7 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 	}
 
 	ret = drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_START,
-			       &sta->sta, tid, &start_seq_num);
+			       &sta->sta, tid, 0, &start_seq_num);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Rx A-MPDU request on tid %d result %d\n", tid, ret);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index c893f23..4332ca8 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -186,7 +186,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 
 	ret = drv_ampdu_action(local, sta->sdata,
 			       IEEE80211_AMPDU_TX_STOP,
-			       &sta->sta, tid, NULL);
+			       &sta->sta, tid, 0, NULL);
 
 	/* HW shall not deny going back to legacy */
 	if (WARN_ON(ret)) {
@@ -307,7 +307,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	start_seq_num = sta->tid_seq[tid] >> 4;
 
 	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
-			       &sta->sta, tid, &start_seq_num);
+			       &sta->sta, tid, 0, &start_seq_num);
 	if (ret) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA request denied - HW unavailable for"
@@ -470,7 +470,7 @@ ieee80211_agg_splice_finish(struct ieee80211_local *local, u16 tid)
 }
 
 static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
-					 struct sta_info *sta, u16 tid)
+		struct sta_info *sta, u16 tid, u16 buf_size)
 {
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
@@ -480,7 +480,7 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 
 	drv_ampdu_action(local, sta->sdata,
 			 IEEE80211_AMPDU_TX_OPERATIONAL,
-			 &sta->sta, tid, NULL);
+			 &sta->sta, tid, buf_size, NULL);
 
 	/*
 	 * synchronize with TX path, while splicing the TX path
@@ -541,7 +541,7 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
 		goto unlock;
 
 	if (test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state))
-		ieee80211_agg_tx_operational(local, sta, tid);
+		ieee80211_agg_tx_operational(local, sta, tid, tid_tx->buf_size);
 
  unlock:
 	mutex_unlock(&sta->ampdu_mlme.mtx);
@@ -733,10 +733,11 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 				  size_t len)
 {
 	struct tid_ampdu_tx *tid_tx;
-	u16 capab, tid;
+	u16 capab, tid, buf_size;
 
 	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
 	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
+    buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
 
@@ -753,6 +754,8 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 
 	del_timer(&tid_tx->addba_resp_timer);
 
+    tid_tx->buf_size = buf_size;
+
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "switched off addBA timer for tid %d\n", tid);
 #endif
@@ -766,7 +769,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 		}
 
 		if (test_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state))
-			ieee80211_agg_tx_operational(local, sta, tid);
+			ieee80211_agg_tx_operational(local, sta, tid, buf_size);
 
 		sta->ampdu_mlme.addba_req_num[tid] = 0;
 	} else {
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 14123dc..383eee7 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -354,17 +354,17 @@ static inline int drv_ampdu_action(struct ieee80211_local *local,
 				   struct ieee80211_sub_if_data *sdata,
 				   enum ieee80211_ampdu_mlme_action action,
 				   struct ieee80211_sta *sta, u16 tid,
-				   u16 *ssn)
+				   u16 buf_size, u16 *ssn)
 {
 	int ret = -EOPNOTSUPP;
 
 	might_sleep();
 
-	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn);
+	trace_drv_ampdu_action(local, sdata, action, sta, tid, buf_size, ssn);
 
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
-					       sta, tid, ssn);
+					       sta, tid, buf_size, ssn);
 
 	trace_drv_return_int(local, ret);
 
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 5d5d2a9..c98bce0 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -733,7 +733,7 @@ TRACE_EVENT(drv_ampdu_action,
 		 struct ieee80211_sub_if_data *sdata,
 		 enum ieee80211_ampdu_mlme_action action,
 		 struct ieee80211_sta *sta, u16 tid,
-		 u16 *ssn),
+		 u16 buf_size, u16 *ssn),
 
 	TP_ARGS(local, sdata, action, sta, tid, ssn),
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 54262e7..6685d4d 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -95,6 +95,7 @@ struct tid_ampdu_tx {
 	unsigned long state;
 	u8 dialog_token;
 	u8 stop_initiator;
+    u16 buf_size;
 };
 
 /**
-- 
1.5.4.1
