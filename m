Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:60891 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaIBMPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 08:15:07 -0400
Received: by mail-la0-f43.google.com with SMTP id ty20so7727428lab.30
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2014 05:15:04 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] mac80211: fix offloaded BA session traffic after hw restart
Date: Tue,  2 Sep 2014 14:05:10 +0200
Message-Id: <1409659510-13624-1-git-send-email-michal.kazior@tieto.com> (sfid-20140902_141512_830042_4DD67FD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When starting an offloaded BA session it is
unknown what starting sequence number should be
used. Using last_seq worked in most cases except
after hw restart.

When hw restart is requested last_seq is
(rightfully so) kept unmodified. This ended up
with BA sessions being restarted with an aribtrary
BA window values resulting in dropped frames until
sequence numbers caught up.

Instead of last_seq pick seqno of a first Rxed
frame of a given BA session.

This fixes stalled traffic after hw restart with
offloaded BA sessions (currently only ath10k).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * use unlikely()

 net/mac80211/agg-rx.c      |  5 +++--
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/iface.c       | 14 +++-----------
 net/mac80211/rx.c          | 10 ++++++++++
 net/mac80211/sta_info.h    |  3 +++
 5 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index f0e84bc..a48bad4 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -227,7 +227,7 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 				     u8 dialog_token, u16 timeout,
 				     u16 start_seq_num, u16 ba_policy, u16 tid,
-				     u16 buf_size, bool tx)
+				     u16 buf_size, bool tx, bool auto_seq)
 {
 	struct ieee80211_local *local = sta->sdata->local;
 	struct tid_ampdu_rx *tid_agg_rx;
@@ -326,6 +326,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	tid_agg_rx->buf_size = buf_size;
 	tid_agg_rx->timeout = timeout;
 	tid_agg_rx->stored_mpdu_num = 0;
+	tid_agg_rx->auto_seq = auto_seq;
 	status = WLAN_STATUS_SUCCESS;
 
 	/* activate it for RX */
@@ -367,7 +368,7 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 
 	__ieee80211_start_rx_ba_session(sta, dialog_token, timeout,
 					start_seq_num, ba_policy, tid,
-					buf_size, true);
+					buf_size, true, false);
 }
 
 void ieee80211_start_rx_ba_session_offl(struct ieee80211_vif *vif,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ffb20e5..8fe5433 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1587,7 +1587,7 @@ void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 				     u8 dialog_token, u16 timeout,
 				     u16 start_seq_num, u16 ba_policy, u16 tid,
-				     u16 buf_size, bool tx);
+				     u16 buf_size, bool tx, bool auto_seq);
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 					 enum ieee80211_agg_stop_reason reason);
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 01eede7..bb7288e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1172,19 +1172,11 @@ static void ieee80211_iface_work(struct work_struct *work)
 			rx_agg = (void *)&skb->cb;
 			mutex_lock(&local->sta_mtx);
 			sta = sta_info_get_bss(sdata, rx_agg->addr);
-			if (sta) {
-				u16 last_seq;
-
-				last_seq = le16_to_cpu(
-					sta->last_seq_ctrl[rx_agg->tid]);
-
+			if (sta)
 				__ieee80211_start_rx_ba_session(sta,
-						0, 0,
-						ieee80211_sn_inc(last_seq),
-						1, rx_agg->tid,
+						0, 0, 0, 1, rx_agg->tid,
 						IEEE80211_MAX_AMPDU_BUF,
-						false);
-			}
+						false, true);
 			mutex_unlock(&local->sta_mtx);
 		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_RX_AGG_STOP) {
 			rx_agg = (void *)&skb->cb;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a8d862f..41eb12c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -835,6 +835,16 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata
 
 	spin_lock(&tid_agg_rx->reorder_lock);
 
+	/*
+	 * Offloaded BA sessions have no known starting sequence number so pick
+	 * one from first Rxed frame for this tid after BA was started.
+	 */
+	if (unlikely(tid_agg_rx->auto_seq)) {
+		tid_agg_rx->auto_seq = false;
+		tid_agg_rx->ssn = mpdu_seq_num;
+		tid_agg_rx->head_seq_num = mpdu_seq_num;
+	}
+
 	buf_size = tid_agg_rx->buf_size;
 	head_seq_num = tid_agg_rx->head_seq_num;
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 89c40d5..16dc1d4 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -167,6 +167,8 @@ struct tid_ampdu_tx {
  * @dialog_token: dialog token for aggregation session
  * @rcu_head: RCU head used for freeing this struct
  * @reorder_lock: serializes access to reorder buffer, see below.
+ * @auto_seq: used for offloaded BA sessions to automatically pick head_seq_and
+ *	and ssn.
  *
  * This structure's lifetime is managed by RCU, assignments to
  * the array holding it must hold the aggregation mutex.
@@ -190,6 +192,7 @@ struct tid_ampdu_rx {
 	u16 buf_size;
 	u16 timeout;
 	u8 dialog_token;
+	bool auto_seq;
 };
 
 /**
-- 
1.8.5.3

