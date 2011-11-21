Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52228 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab1KUCXK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 21:23:10 -0500
Received: by mail-gy0-f174.google.com with SMTP id z2so2300796ghb.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 18:23:09 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kolya <mar.kolya@gmail.com>
Subject: [PATCH 1/3] mac80211: add tx agg session timer to timeout inactive tids in way similar to rx agg sessions are being timed out
Date: Sun, 20 Nov 2011 21:22:50 -0500
Message-Id: <1321842172-6732-2-git-send-email-mar.kolya@gmail.com> (sfid-20111121_032314_633142_7ED628C5)
In-Reply-To: <1321842172-6732-1-git-send-email-mar.kolya@gmail.com>
References: <1321842172-6732-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: kolya <mar.kolya@gmail.com>

---
 net/mac80211/agg-tx.c   |   35 ++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h |    2 ++
 net/mac80211/tx.c       |    9 +++++++++
 3 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 39d72cc..915f3ff 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -349,6 +349,28 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 				     tid_tx->timeout);
 }
 
+/*
+ * After accepting the AddBA Response we activated a timer,
+ * resetting it after each frame that we send.
+ */
+static void sta_tx_agg_session_timer_expired(unsigned long data)
+{
+	/* not an elegant detour, but there is no choice as the timer passes
+	 * only one argument, and various sta_info are needed here, so init
+	 * flow in sta_info_create gives the TID as data, while the timer_to_id
+	 * array gives the sta through container_of */
+	u8 *ptid = (u8 *)data;
+	u8 *timer_to_id = ptid - *ptid;
+	struct sta_info *sta = container_of(timer_to_id, struct sta_info,
+					 timer_to_tid[0]);
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "tx session timer expired on tid %d\n", (u16)*ptid);
+#endif
+
+        ieee80211_stop_tx_ba_session(&sta->sta, *ptid);
+}
+
 int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 				  u16 timeout)
 {
@@ -418,11 +440,16 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 
 	tid_tx->timeout = timeout;
 
-	/* Tx timer */
+	/* response timer */
 	tid_tx->addba_resp_timer.function = sta_addba_resp_timer_expired;
 	tid_tx->addba_resp_timer.data = (unsigned long)&sta->timer_to_tid[tid];
 	init_timer(&tid_tx->addba_resp_timer);
 
+	/* tx timer */
+	tid_tx->session_timer.function = sta_tx_agg_session_timer_expired;
+	tid_tx->session_timer.data = (unsigned long)&sta->timer_to_tid[tid];
+	init_timer(&tid_tx->session_timer);
+
 	/* assign a dialog token */
 	sta->ampdu_mlme.dialog_token_allocator++;
 	tid_tx->dialog_token = sta->ampdu_mlme.dialog_token_allocator;
@@ -689,6 +716,8 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 	 * more.
 	 */
 
+	del_timer_sync(&tid_tx->session_timer);
+
 	ieee80211_agg_splice_packets(local, tid_tx, tid);
 
 	/* future packets must not find the tid_tx struct any more */
@@ -778,6 +807,10 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 			ieee80211_agg_tx_operational(local, sta, tid);
 
 		sta->ampdu_mlme.addba_req_num[tid] = 0;
+
+                if (tid_tx->timeout)
+                        mod_timer(&tid_tx->session_timer, TU_TO_EXP_TIME(tid_tx->timeout));
+
 	} else {
 		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR,
 						true);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c5923ab..6027a53 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -90,6 +90,7 @@ enum ieee80211_sta_info_flags {
  * struct tid_ampdu_tx - TID aggregation information (Tx).
  *
  * @rcu_head: rcu head for freeing structure
+ * @session_timer: check if we keep Tx-ing on the TID (by timeout value)
  * @addba_resp_timer: timer for peer's response to addba request
  * @pending: pending frames queue -- use sta's spinlock to protect
  * @dialog_token: dialog token for aggregation session
@@ -112,6 +113,7 @@ enum ieee80211_sta_info_flags {
  */
 struct tid_ampdu_tx {
 	struct rcu_head rcu_head;
+	struct timer_list session_timer;
 	struct timer_list addba_resp_timer;
 	struct sk_buff_head pending;
 	unsigned long state;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 30d212a..a6d46ca 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1044,6 +1044,10 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 
 	if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 		info->flags |= IEEE80211_TX_CTL_AMPDU;
+                /* reset session timer */
+                if (tid_tx->timeout)
+                        mod_timer(&tid_tx->session_timer,
+                                  TU_TO_EXP_TIME(tid_tx->timeout));
 	} else if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/*
 		 * nothing -- this aggregation session is being started
@@ -1075,6 +1079,11 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 			/* do nothing, let packet pass through */
 		} else if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 			info->flags |= IEEE80211_TX_CTL_AMPDU;
+
+                        /* reset session timer */
+                        if (tid_tx->timeout)
+                                mod_timer(&tid_tx->session_timer,
+                                          TU_TO_EXP_TIME(tid_tx->timeout));
 		} else {
 			queued = true;
 			info->control.vif = &tx->sdata->vif;
-- 
1.7.4.1

