Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35575 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab0FGLDV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 07:03:21 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OLa6y-0007DC-HP
	for linux-wireless@vger.kernel.org; Mon, 07 Jun 2010 13:03:20 +0200
Message-Id: <20100607110201.802245800@sipsolutions.net>
Date: Mon, 07 Jun 2010 13:01:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 15/21] mac80211: move BA session work
References: <20100607110133.472649120@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the block-ack session works into common
code, since it will be needed for RX agg too
in the next patches.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c      |   39 +++------------------------------------
 net/mac80211/ht.c          |   32 ++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    5 ++++-
 net/mac80211/sta_info.c    |    2 +-
 4 files changed, 40 insertions(+), 38 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-06-06 15:45:05.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-06-06 15:45:47.000000000 +0200
@@ -133,9 +133,8 @@ static void kfree_tid_tx(struct rcu_head
 	kfree(tid_tx);
 }
 
-static int ___ieee80211_stop_tx_ba_session(
-		struct sta_info *sta, u16 tid,
-		enum ieee80211_back_parties initiator)
+int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
+				    enum ieee80211_back_parties initiator)
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_tx *tid_tx = sta->ampdu_mlme.tid_tx[tid];
@@ -262,7 +261,7 @@ ieee80211_wake_queue_agg(struct ieee8021
 	__release(agg_queue);
 }
 
-static void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
+void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
 	struct tid_ampdu_tx *tid_tx = sta->ampdu_mlme.tid_tx[tid];
 	struct ieee80211_local *local = sta->local;
@@ -318,38 +317,6 @@ static void ieee80211_tx_ba_session_hand
 				     0x40, 5000);
 }
 
-void ieee80211_tx_ba_session_work(struct work_struct *work)
-{
-	struct sta_info *sta =
-		container_of(work, struct sta_info, ampdu_mlme.work);
-	struct tid_ampdu_tx *tid_tx;
-	int tid;
-
-	/*
-	 * When this flag is set, new sessions should be
-	 * blocked, and existing sessions will be torn
-	 * down by the code that set the flag, so this
-	 * need not run.
-	 */
-	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA))
-		return;
-
-	spin_lock_bh(&sta->lock);
-	for (tid = 0; tid < STA_TID_NUM; tid++) {
-		tid_tx = sta->ampdu_mlme.tid_tx[tid];
-		if (!tid_tx)
-			continue;
-
-		if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state))
-			ieee80211_tx_ba_session_handle_start(sta, tid);
-		else if (test_and_clear_bit(HT_AGG_STATE_WANT_STOP,
-					    &tid_tx->state))
-			___ieee80211_stop_tx_ba_session(sta, tid,
-							WLAN_BACK_INITIATOR);
-	}
-	spin_unlock_bh(&sta->lock);
-}
-
 int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
--- wireless-testing.orig/net/mac80211/ht.c	2010-06-06 15:45:05.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2010-06-06 15:45:47.000000000 +0200
@@ -114,6 +114,38 @@ void ieee80211_sta_tear_down_BA_sessions
 	}
 }
 
+void ieee80211_ba_session_work(struct work_struct *work)
+{
+	struct sta_info *sta =
+		container_of(work, struct sta_info, ampdu_mlme.work);
+	struct tid_ampdu_tx *tid_tx;
+	int tid;
+
+	/*
+	 * When this flag is set, new sessions should be
+	 * blocked, and existing sessions will be torn
+	 * down by the code that set the flag, so this
+	 * need not run.
+	 */
+	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA))
+		return;
+
+	spin_lock_bh(&sta->lock);
+	for (tid = 0; tid < STA_TID_NUM; tid++) {
+		tid_tx = sta->ampdu_mlme.tid_tx[tid];
+		if (!tid_tx)
+			continue;
+
+		if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state))
+			ieee80211_tx_ba_session_handle_start(sta, tid);
+		else if (test_and_clear_bit(HT_AGG_STATE_WANT_STOP,
+					    &tid_tx->state))
+			___ieee80211_stop_tx_ba_session(sta, tid,
+							WLAN_BACK_INITIATOR);
+	}
+	spin_unlock_bh(&sta->lock);
+}
+
 void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 			  const u8 *da, u16 tid,
 			  u16 initiator, u16 reason_code)
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-06-06 15:45:05.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-06-06 15:45:47.000000000 +0200
@@ -1118,9 +1118,12 @@ void ieee80211_process_addba_request(str
 
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				   enum ieee80211_back_parties initiator);
+int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
+				    enum ieee80211_back_parties initiator);
 void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid);
 void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
-void ieee80211_tx_ba_session_work(struct work_struct *work);
+void ieee80211_ba_session_work(struct work_struct *work);
+void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/sta_info.c	2010-06-06 15:45:05.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-06-06 15:45:47.000000000 +0200
@@ -235,7 +235,7 @@ struct sta_info *sta_info_alloc(struct i
 	spin_lock_init(&sta->lock);
 	spin_lock_init(&sta->flaglock);
 	INIT_WORK(&sta->drv_unblock_wk, sta_unblock);
-	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_tx_ba_session_work);
+	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
 
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;


