Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab0FJI0T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:26:19 -0400
Message-Id: <20100610082231.709041799@sipsolutions.net>
Date: Thu, 10 Jun 2010 10:21:44 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/23] mac80211: defer RX agg session teardown to work
References: <20100610082128.641664439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we want the code to be able to sleep
in the future, it must not be called from
the timer directly. To prepare, move it out
into the aggregation work.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c      |   24 ++++++++++--------------
 net/mac80211/ht.c          |    5 +++++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/sta_info.h    |    3 +++
 4 files changed, 20 insertions(+), 14 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-06-09 17:21:11.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-06-09 17:21:15.000000000 +0200
@@ -32,21 +32,18 @@ static void ieee80211_free_tid_rx(struct
 	kfree(tid_rx);
 }
 
-static void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
-					    u16 initiator, u16 reason,
-					    bool from_timer)
+void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
+				     u16 initiator, u16 reason)
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_rx *tid_rx;
 
-	spin_lock_bh(&sta->lock);
+	lockdep_assert_held(&sta->lock);
 
 	tid_rx = sta->ampdu_mlme.tid_rx[tid];
 
-	if (!tid_rx) {
-		spin_unlock_bh(&sta->lock);
+	if (!tid_rx)
 		return;
-	}
 
 	rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], NULL);
 
@@ -65,10 +62,7 @@ static void ___ieee80211_stop_rx_ba_sess
 		ieee80211_send_delba(sta->sdata, sta->sta.addr,
 				     tid, 0, reason);
 
-	spin_unlock_bh(&sta->lock);
-
-	if (!from_timer)
-		del_timer_sync(&tid_rx->session_timer);
+	del_timer_sync(&tid_rx->session_timer);
 
 	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
 }
@@ -76,7 +70,9 @@ static void ___ieee80211_stop_rx_ba_sess
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				    u16 initiator, u16 reason)
 {
-	___ieee80211_stop_rx_ba_session(sta, tid, initiator, reason, false);
+	spin_lock_bh(&sta->lock);
+	___ieee80211_stop_rx_ba_session(sta, tid, initiator, reason);
+	spin_unlock_bh(&sta->lock);
 }
 
 /*
@@ -97,8 +93,8 @@ static void sta_rx_agg_session_timer_exp
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
 #endif
-	___ieee80211_stop_rx_ba_session(sta, *ptid, WLAN_BACK_RECIPIENT,
-					WLAN_REASON_QSTA_TIMEOUT, true);
+	set_bit(*ptid, sta->ampdu_mlme.tid_rx_timer_expired);
+	ieee80211_queue_work(&sta->local->hw, &sta->ampdu_mlme.work);
 }
 
 static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
--- wireless-testing.orig/net/mac80211/ht.c	2010-06-09 17:21:14.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2010-06-09 17:21:15.000000000 +0200
@@ -132,6 +132,11 @@ void ieee80211_ba_session_work(struct wo
 
 	spin_lock_bh(&sta->lock);
 	for (tid = 0; tid < STA_TID_NUM; tid++) {
+		if (test_and_clear_bit(tid, sta->ampdu_mlme.tid_rx_timer_expired))
+			___ieee80211_stop_rx_ba_session(
+				sta, tid, WLAN_BACK_RECIPIENT,
+				WLAN_REASON_QSTA_TIMEOUT);
+
 		tid_tx = sta->ampdu_mlme.tid_tx[tid];
 		if (!tid_tx)
 			continue;
--- wireless-testing.orig/net/mac80211/sta_info.h	2010-06-09 17:21:13.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2010-06-09 17:21:15.000000000 +0200
@@ -140,10 +140,13 @@ struct tid_ampdu_rx {
  * @addba_req_num: number of times addBA request has been sent.
  * @dialog_token_allocator: dialog token enumerator for each new session;
  * @work: work struct for starting/stopping aggregation
+ * @tid_rx_timer_expired: bitmap indicating on which TIDs the
+ *	RX timer expired until the work for it runs
  */
 struct sta_ampdu_mlme {
 	/* rx */
 	struct tid_ampdu_rx *tid_rx[STA_TID_NUM];
+	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(STA_TID_NUM)];
 	/* tx */
 	struct work_struct work;
 	struct tid_ampdu_tx *tid_tx[STA_TID_NUM];
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-06-09 17:21:14.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-06-09 17:21:15.000000000 +0200
@@ -1096,6 +1096,8 @@ int ieee80211_send_smps_action(struct ie
 			       enum ieee80211_smps_mode smps, const u8 *da,
 			       const u8 *bssid);
 
+void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
+				     u16 initiator, u16 reason);
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				    u16 initiator, u16 reason);
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta);


