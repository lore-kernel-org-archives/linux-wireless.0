Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61342 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab1KWCur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 21:50:47 -0500
Received: by mail-vw0-f46.google.com with SMTP id fc26so22487vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 18:50:47 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v2 1/3] mac80211: timeout tx agg sessions in way similar to rx agg sessions
Date: Tue, 22 Nov 2011 21:50:28 -0500
Message-Id: <1322016630-27332-2-git-send-email-mar.kolya@gmail.com> (sfid-20111123_035051_714413_5B53F21A)
In-Reply-To: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com>
References: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Currently tx aggregation is not being timed out even if timeout is
specified when aggregation is opened. Tx tid stays active until delba
arrives from recipient (i.e. recipient times out tid when it is
inactive).
  The problem with this approach is that delba can get lost in the air
and tx tid will stay perpetually opened on the originator while closed
on recipient thus all data sent via this tid will be lost.
  This patch implements tx tid timeouting in way very similar to rx tid
timeouting.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 net/mac80211/agg-tx.c   |   35 ++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h |    2 ++
 net/mac80211/tx.c       |    8 ++++++++
 3 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 39d72cc..a2d9654 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -180,6 +180,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
 
 	del_timer_sync(&tid_tx->addba_resp_timer);
+	del_timer_sync(&tid_tx->session_timer);
 
 	/*
 	 * After this packets are no longer handed right through
@@ -349,6 +350,28 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
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
+	ieee80211_stop_tx_ba_session(&sta->sta, *ptid);
+}
+
 int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 				  u16 timeout)
 {
@@ -418,11 +441,16 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 
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
@@ -778,6 +806,11 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 			ieee80211_agg_tx_operational(local, sta, tid);
 
 		sta->ampdu_mlme.addba_req_num[tid] = 0;
+
+		if (tid_tx->timeout)
+			mod_timer(&tid_tx->session_timer,
+				  TU_TO_EXP_TIME(tid_tx->timeout));
+
 	} else {
 		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR,
 						true);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 6280e8b..ccd34e9 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -88,6 +88,7 @@ enum ieee80211_sta_info_flags {
  * struct tid_ampdu_tx - TID aggregation information (Tx).
  *
  * @rcu_head: rcu head for freeing structure
+ * @session_timer: check if we keep Tx-ing on the TID (by timeout value)
  * @addba_resp_timer: timer for peer's response to addba request
  * @pending: pending frames queue -- use sta's spinlock to protect
  * @dialog_token: dialog token for aggregation session
@@ -110,6 +111,7 @@ enum ieee80211_sta_info_flags {
  */
 struct tid_ampdu_tx {
 	struct rcu_head rcu_head;
+	struct timer_list session_timer;
 	struct timer_list addba_resp_timer;
 	struct sk_buff_head pending;
 	unsigned long state;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8d31933..7b74f59 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1063,9 +1063,11 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 				  int tid)
 {
 	bool queued = false;
+	bool reset_agg_timer = false;
 
 	if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 		info->flags |= IEEE80211_TX_CTL_AMPDU;
+		reset_agg_timer = true;
 	} else if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/*
 		 * nothing -- this aggregation session is being started
@@ -1097,6 +1099,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 			/* do nothing, let packet pass through */
 		} else if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 			info->flags |= IEEE80211_TX_CTL_AMPDU;
+			reset_agg_timer = true;
 		} else {
 			queued = true;
 			info->control.vif = &tx->sdata->vif;
@@ -1106,6 +1109,11 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 		spin_unlock(&tx->sta->lock);
 	}
 
+	/* reset session timer */
+	if (reset_agg_timer && tid_tx->timeout)
+		mod_timer(&tid_tx->session_timer,
+			  TU_TO_EXP_TIME(tid_tx->timeout));
+
 	return queued;
 }
 
-- 
1.7.4.1

