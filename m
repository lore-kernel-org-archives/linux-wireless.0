Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59664 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaF0JR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2014 05:17:26 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so2489926wib.11
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2014 02:17:25 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Denton Gentry <denton.gentry@gmail.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT 1/2] mac80211: add support for Rx reordering offloading
Date: Fri, 27 Jun 2014 11:06:54 +0200
Message-Id: <1403860015-31601-2-git-send-email-michal.kazior@tieto.com> (sfid-20140627_111730_127587_DA36C97E)
In-Reply-To: <1403860015-31601-1-git-send-email-michal.kazior@tieto.com>
References: <1403860015-31601-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers may be performing most of Tx/Rx
aggregation on their own (e.g. in firmware)
including AddBa/DelBa negotiations but may
otherwise require Rx reordering assistance.

The patch exports 2 new functions for establishing
Rx aggregation sessions in assumption device
driver has taken care of the necessary
negotiations.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h     |  40 +++++++++++++++++
 net/mac80211/agg-rx.c      | 108 +++++++++++++++++++++++++++++++++++----------
 net/mac80211/ieee80211_i.h |  16 +++++++
 net/mac80211/iface.c       |  25 +++++++++++
 4 files changed, 166 insertions(+), 23 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 421b6ec..e7362f0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4524,6 +4524,46 @@ void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
  */
 void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn);
 
+/**
+ * ieee80211_start_rx_ba_session_offl - start a Rx BA session
+ *
+ * Some device drivers may offload part of the Rx aggregation flow including
+ * AddBa/DelBa negotiation but may otherwise be incapable of full Rx
+ * reordering.
+ *
+ * Create structures responsible for reordering so device drivers may call here
+ * when they complete AddBa negotiation.
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback
+ * @addr: station mac address
+ * @dialog_token:
+ * @timeout: session timeout (in TU)
+ * @start_seq_num: starting frame sequence number
+ * @tid: the rx tid
+ * @buf_size: max number of frames in reorder buffer
+ */
+void ieee80211_start_rx_ba_session_offl(struct ieee80211_vif *vif,
+					const u8 *addr, u8 dialog_token,
+					u16 timeout, u16 start_seq_num,
+					u16 tid, u16 buf_size);
+
+/**
+ * ieee80211_stop_rx_ba_session_offl - stop a Rx BA session
+ *
+ * Some device drivers may offload part of the Rx aggregation flow including
+ * AddBa/DelBa negotiation but may otherwise be incapable of full Rx
+ * reordering.
+ *
+ * Destroy structures responsible for reordering so device drivers may call here
+ * when they complete DelBa negotiation.
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback
+ * @addr: station mac address
+ * @tid: the rx tid
+ */
+void ieee80211_stop_rx_ba_session_offl(struct ieee80211_vif *vif,
+				       const u8 *addr, u16 tid);
+
 /* Rate control API */
 
 /**
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 31bf258..dbf90f5 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -224,28 +224,15 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 	ieee80211_tx_skb(sdata, skb);
 }
 
-void ieee80211_process_addba_request(struct ieee80211_local *local,
-				     struct sta_info *sta,
-				     struct ieee80211_mgmt *mgmt,
-				     size_t len)
+void __ieee80211_start_rx_ba_session(struct sta_info *sta,
+				     u8 dialog_token, u16 timeout,
+				     u16 start_seq_num, u16 ba_policy, u16 tid,
+				     u16 buf_size, bool tx)
 {
+	struct ieee80211_local *local = sta->sdata->local;
 	struct tid_ampdu_rx *tid_agg_rx;
-	u16 capab, tid, timeout, ba_policy, buf_size, start_seq_num, status;
-	u8 dialog_token;
 	int ret = -EOPNOTSUPP;
-
-	/* extract session parameters from addba request frame */
-	dialog_token = mgmt->u.action.u.addba_req.dialog_token;
-	timeout = le16_to_cpu(mgmt->u.action.u.addba_req.timeout);
-	start_seq_num =
-		le16_to_cpu(mgmt->u.action.u.addba_req.start_seq_num) >> 4;
-
-	capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
-	ba_policy = (capab & IEEE80211_ADDBA_PARAM_POLICY_MASK) >> 1;
-	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
-	buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
-
-	status = WLAN_STATUS_REQUEST_DECLINED;
+	u16 status = WLAN_STATUS_REQUEST_DECLINED;
 
 	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA)) {
 		ht_dbg(sta->sdata,
@@ -264,7 +251,7 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 		status = WLAN_STATUS_INVALID_QOS_PARAM;
 		ht_dbg_ratelimited(sta->sdata,
 				   "AddBA Req with bad params from %pM on tid %u. policy %d, buffer size %d\n",
-				   mgmt->sa, tid, ba_policy, buf_size);
+				   sta->sta.addr, tid, ba_policy, buf_size);
 		goto end_no_lock;
 	}
 	/* determine default buffer size */
@@ -281,7 +268,7 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 	if (sta->ampdu_mlme.tid_rx[tid]) {
 		ht_dbg_ratelimited(sta->sdata,
 				   "unexpected AddBA Req from %pM on tid %u\n",
-				   mgmt->sa, tid);
+				   sta->sta.addr, tid);
 
 		/* delete existing Rx BA session on the same tid */
 		___ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
@@ -350,6 +337,81 @@ end:
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 
 end_no_lock:
-	ieee80211_send_addba_resp(sta->sdata, sta->sta.addr, tid,
-				  dialog_token, status, 1, buf_size, timeout);
+	if (tx)
+		ieee80211_send_addba_resp(sta->sdata, sta->sta.addr, tid,
+					  dialog_token, status, 1, buf_size,
+					  timeout);
+}
+
+void ieee80211_process_addba_request(struct ieee80211_local *local,
+				     struct sta_info *sta,
+				     struct ieee80211_mgmt *mgmt,
+				     size_t len)
+{
+	u16 capab, tid, timeout, ba_policy, buf_size, start_seq_num;
+	u8 dialog_token;
+
+	/* extract session parameters from addba request frame */
+	dialog_token = mgmt->u.action.u.addba_req.dialog_token;
+	timeout = le16_to_cpu(mgmt->u.action.u.addba_req.timeout);
+	start_seq_num =
+		le16_to_cpu(mgmt->u.action.u.addba_req.start_seq_num) >> 4;
+
+	capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
+	ba_policy = (capab & IEEE80211_ADDBA_PARAM_POLICY_MASK) >> 1;
+	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
+	buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
+
+	__ieee80211_start_rx_ba_session(sta, dialog_token, timeout,
+					start_seq_num, ba_policy, tid,
+					buf_size, true);
+}
+
+void ieee80211_start_rx_ba_session_offl(struct ieee80211_vif *vif,
+					const u8 *addr, u8 dialog_token,
+					u16 timeout, u16 start_seq_num,
+					u16 tid, u16 buf_size)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_rx_agg *rx_agg;
+	struct sk_buff *skb = dev_alloc_skb(0);
+
+	if (unlikely(!skb))
+		return;
+
+	rx_agg = (struct ieee80211_rx_agg *) &skb->cb;
+	memcpy(&rx_agg->addr, addr, ETH_ALEN);
+	rx_agg->dialog_token = dialog_token;
+	rx_agg->timeout = timeout;
+	rx_agg->start_seq_num = start_seq_num;
+	rx_agg->ba_policy = 1;
+	rx_agg->tid = tid;
+	rx_agg->buf_size = buf_size;
+
+	skb->pkt_type = IEEE80211_SDATA_QUEUE_RX_AGG_START;
+	skb_queue_tail(&sdata->skb_queue, skb);
+	ieee80211_queue_work(&local->hw, &sdata->work);
+}
+EXPORT_SYMBOL(ieee80211_start_rx_ba_session_offl);
+
+void ieee80211_stop_rx_ba_session_offl(struct ieee80211_vif *vif,
+				       const u8 *addr, u16 tid)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_rx_agg *rx_agg;
+	struct sk_buff *skb = dev_alloc_skb(0);
+
+	if (unlikely(!skb))
+		return;
+
+	rx_agg = (struct ieee80211_rx_agg *) &skb->cb;
+	memcpy(&rx_agg->addr, addr, ETH_ALEN);
+	rx_agg->tid = tid;
+
+	skb->pkt_type = IEEE80211_SDATA_QUEUE_RX_AGG_STOP;
+	skb_queue_tail(&sdata->skb_queue, skb);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
+EXPORT_SYMBOL(ieee80211_stop_rx_ba_session_offl);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ac9836e..ae35bf1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -892,10 +892,22 @@ ieee80211_vif_get_shift(struct ieee80211_vif *vif)
 	return shift;
 }
 
+struct ieee80211_rx_agg {
+	u8 addr[ETH_ALEN];
+	u8 dialog_token;
+	u16 timeout;
+	u16 start_seq_num;
+	u16 ba_policy;
+	u16 tid;
+	u16 buf_size;
+};
+
 enum sdata_queue_type {
 	IEEE80211_SDATA_QUEUE_TYPE_FRAME	= 0,
 	IEEE80211_SDATA_QUEUE_AGG_START		= 1,
 	IEEE80211_SDATA_QUEUE_AGG_STOP		= 2,
+	IEEE80211_SDATA_QUEUE_RX_AGG_START	= 3,
+	IEEE80211_SDATA_QUEUE_RX_AGG_STOP	= 4,
 };
 
 enum {
@@ -1540,6 +1552,10 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     u16 initiator, u16 reason, bool stop);
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				    u16 initiator, u16 reason, bool stop);
+void __ieee80211_start_rx_ba_session(struct sta_info *sta,
+				     u8 dialog_token, u16 timeout,
+				     u16 start_seq_num, u16 ba_policy, u16 tid,
+				     u16 buf_size, bool tx);
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 					 enum ieee80211_agg_stop_reason reason);
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 388b863..3d9b135 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1139,6 +1139,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 	struct sk_buff *skb;
 	struct sta_info *sta;
 	struct ieee80211_ra_tid *ra_tid;
+	struct ieee80211_rx_agg *rx_agg;
 
 	if (!ieee80211_sdata_running(sdata))
 		return;
@@ -1166,6 +1167,30 @@ static void ieee80211_iface_work(struct work_struct *work)
 			ra_tid = (void *)&skb->cb;
 			ieee80211_stop_tx_ba_cb(&sdata->vif, ra_tid->ra,
 						ra_tid->tid);
+		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_RX_AGG_START) {
+			rx_agg = (void *)&skb->cb;
+			mutex_lock(&local->sta_mtx);
+			sta = sta_info_get_bss(sdata, rx_agg->addr);
+			if (sta)
+				__ieee80211_start_rx_ba_session(sta,
+							rx_agg->dialog_token,
+							rx_agg->timeout,
+							rx_agg->start_seq_num,
+							rx_agg->ba_policy,
+							rx_agg->tid,
+							rx_agg->buf_size,
+							false);
+			mutex_unlock(&local->sta_mtx);
+		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_RX_AGG_STOP) {
+			rx_agg = (void *)&skb->cb;
+			mutex_lock(&local->sta_mtx);
+			sta = sta_info_get_bss(sdata, rx_agg->addr);
+			if (sta)
+				__ieee80211_stop_rx_ba_session(sta,
+							rx_agg->tid,
+							WLAN_BACK_RECIPIENT, 0,
+							false);
+			mutex_unlock(&local->sta_mtx);
 		} else if (ieee80211_is_action(mgmt->frame_control) &&
 			   mgmt->u.action.category == WLAN_CATEGORY_BACK) {
 			int len = skb->len;
-- 
1.8.5.3

