Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47123 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab0DFJWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:22:44 -0400
Message-Id: <20100406092141.614607745@sipsolutions.net>
Date: Tue, 06 Apr 2010 11:18:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/7] mac80211: remove ieee80211_sta_stop_rx_ba_session
References: <20100406091841.549805267@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All callers of ieee80211_sta_stop_rx_ba_session can
just call __ieee80211_stop_rx_ba_session instead
because they already have the station struct, so do
that and remove ieee80211_sta_stop_rx_ba_session.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-rx.c      |   24 ++----------------------
 net/mac80211/ht.c          |    3 +--
 net/mac80211/ieee80211_i.h |    2 --
 net/mac80211/rx.c          |    4 ++--
 4 files changed, 5 insertions(+), 28 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-04-06 09:09:20.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-04-06 09:09:33.000000000 +0200
@@ -79,28 +79,9 @@ void __ieee80211_stop_rx_ba_session(stru
 	spin_unlock_bh(&sta->lock);
 }
 
-void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid,
-					u16 initiator, u16 reason)
-{
-	struct sta_info *sta;
-
-	rcu_read_lock();
-
-	sta = sta_info_get(sdata, ra);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-
-	__ieee80211_stop_rx_ba_session(sta, tid, initiator, reason);
-
-	rcu_read_unlock();
-}
-
 /*
  * After accepting the AddBA Request we activated a timer,
  * resetting it after each frame that arrives from the originator.
- * if this timer expires ieee80211_sta_stop_rx_ba_session will be executed.
  */
 static void sta_rx_agg_session_timer_expired(unsigned long data)
 {
@@ -116,9 +97,8 @@ static void sta_rx_agg_session_timer_exp
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
 #endif
-	ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->sta.addr,
-					 (u16)*ptid, WLAN_BACK_TIMER,
-					 WLAN_REASON_QSTA_TIMEOUT);
+	__ieee80211_stop_rx_ba_session(sta, *ptid, WLAN_BACK_RECIPIENT,
+				       WLAN_REASON_QSTA_TIMEOUT);
 }
 
 static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-04-06 09:09:20.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-04-06 09:09:33.000000000 +0200
@@ -1098,8 +1098,6 @@ int ieee80211_send_smps_action(struct ie
 			       enum ieee80211_smps_mode smps, const u8 *da,
 			       const u8 *bssid);
 
-void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *da,
-				u16 tid, u16 initiator, u16 reason);
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				    u16 initiator, u16 reason);
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta);
--- wireless-testing.orig/net/mac80211/rx.c	2010-04-06 09:09:32.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-04-06 09:09:33.000000000 +0200
@@ -739,8 +739,8 @@ static void ieee80211_rx_reorder_ampdu(s
 	/* if this mpdu is fragmented - terminate rx aggregation session */
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	if (sc & IEEE80211_SCTL_FRAG) {
-		ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->sta.addr,
-			tid, 0, WLAN_REASON_QSTA_REQUIRE_SETUP);
+		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
+					       WLAN_REASON_QSTA_REQUIRE_SETUP);
 		dev_kfree_skb(skb);
 		return;
 	}
--- wireless-testing.orig/net/mac80211/ht.c	2010-04-06 09:09:20.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2010-04-06 09:09:33.000000000 +0200
@@ -175,8 +175,7 @@ void ieee80211_process_delba(struct ieee
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	if (initiator == WLAN_BACK_INITIATOR)
-		ieee80211_sta_stop_rx_ba_session(sdata, sta->sta.addr, tid,
-						 WLAN_BACK_INITIATOR, 0);
+		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_INITIATOR, 0);
 	else { /* WLAN_BACK_RECIPIENT */
 		spin_lock_bh(&sta->lock);
 		if (sta->ampdu_mlme.tid_state_tx[tid] & HT_ADDBA_REQUESTED_MSK)


