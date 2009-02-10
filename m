Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbZBJUjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:39:23 -0500
Message-Id: <20090210202555.979247282@sipsolutions.net> (sfid-20090210_213926_073694_A0331F8E)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:54 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 18/27] mac80211: further cleanups to stopping BA sessions
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Essentially consisting of passing the sta_info pointer around,
instead of repeatedly doing hash lookups.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-rx.c      |    6 ++--
 net/mac80211/agg-tx.c      |   63 +++++++++++++++++++++++----------------------
 net/mac80211/ht.c          |    9 ++----
 net/mac80211/ieee80211_i.h |    5 +++
 4 files changed, 44 insertions(+), 39 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-02-10 20:59:35.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2009-02-10 20:59:35.000000000 +0100
@@ -17,8 +17,8 @@
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 
-static void __ieee80211_sta_stop_rx_ba_session(struct sta_info *sta, u16 tid,
-					       u16 initiator, u16 reason)
+void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
+				    u16 initiator, u16 reason)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_hw *hw = &local->hw;
@@ -96,7 +96,7 @@ void ieee80211_sta_stop_rx_ba_session(st
 		return;
 	}
 
-	__ieee80211_sta_stop_rx_ba_session(sta, tid, initiator, reason);
+	__ieee80211_stop_rx_ba_session(sta, tid, initiator, reason);
 
 	rcu_read_unlock();
 }
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-02-10 20:59:34.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-02-10 20:59:35.000000000 +0100
@@ -990,6 +990,8 @@ void ieee80211_send_delba(struct ieee802
 
 void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *da,
 				u16 tid, u16 initiator, u16 reason);
+void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
+				    u16 initiator, u16 reason);
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta);
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta,
@@ -1003,6 +1005,9 @@ void ieee80211_process_addba_request(str
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len);
 
+int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
+				   enum ieee80211_back_parties initiator);
+
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-02-10 20:59:34.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-02-10 20:59:35.000000000 +0100
@@ -123,10 +123,10 @@ void ieee80211_send_bar(struct ieee80211
 	ieee80211_tx_skb(sdata, skb, 0);
 }
 
-static int __ieee80211_stop_tx_ba_session(struct ieee80211_local *local,
-					  struct sta_info *sta, u16 tid,
-					  enum ieee80211_back_parties initiator)
+static int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
+					   enum ieee80211_back_parties initiator)
 {
+	struct ieee80211_local *local = sta->local;
 	int ret;
 	u8 *state;
 
@@ -165,7 +165,6 @@ static void sta_addba_resp_timer_expired
 	u16 tid = *(u8 *)data;
 	struct sta_info *sta = container_of((void *)data,
 		struct sta_info, timer_to_tid[tid]);
-	struct ieee80211_local *local = sta->local;
 	u8 *state;
 
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
@@ -186,7 +185,7 @@ static void sta_addba_resp_timer_expired
 	printk(KERN_DEBUG "addBA response timer expired on tid %d\n", tid);
 #endif
 
-	__ieee80211_stop_tx_ba_session(local, sta, tid, WLAN_BACK_INITIATOR);
+	___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR);
 	spin_unlock_bh(&sta->lock);
 }
 
@@ -427,6 +426,32 @@ void ieee80211_start_tx_ba_cb_irqsafe(st
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
 
+int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
+				   enum ieee80211_back_parties initiator)
+{
+	u8 *state;
+	int ret;
+
+	/* check if the TID is in aggregation */
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
+	spin_lock_bh(&sta->lock);
+
+	if (*state != HT_AGG_STATE_OPERATIONAL) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Tx BA session stop requested for %pM tid %u\n",
+	       sta->sta.addr, tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
+	ret = ___ieee80211_stop_tx_ba_session(sta, tid, initiator);
+
+ unlock:
+	spin_unlock_bh(&sta->lock);
+	return ret;
+}
 
 int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
 				 u8 *ra, u16 tid,
@@ -434,7 +459,6 @@ int ieee80211_stop_tx_ba_session(struct 
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct sta_info *sta;
-	u8 *state;
 	int ret = 0;
 
 	if (WARN_ON(!local->ops->ampdu_action))
@@ -450,27 +474,8 @@ int ieee80211_stop_tx_ba_session(struct 
 		return -ENOENT;
 	}
 
-	/* check if the TID is in aggregation */
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
-	spin_lock_bh(&sta->lock);
-
-	if (*state != HT_AGG_STATE_OPERATIONAL) {
-		ret = -ENOENT;
-		goto unlock;
-	}
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "Tx BA session stop requested for %pM tid %u\n",
-	       ra, tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-
-	ret = __ieee80211_stop_tx_ba_session(local, sta, tid, initiator);
-
- unlock:
-	spin_unlock_bh(&sta->lock);
-
+	ret = __ieee80211_stop_tx_ba_session(sta, tid, initiator);
 	rcu_read_unlock();
-
 	return ret;
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
@@ -623,11 +628,9 @@ void ieee80211_process_addba_resp(struct
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Resuming TX aggregation for tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		spin_unlock_bh(&sta->lock);
 	} else {
 		sta->ampdu_mlme.addba_req_num[tid]++;
-		__ieee80211_stop_tx_ba_session(local, sta, tid,
-					       WLAN_BACK_INITIATOR);
-		spin_unlock_bh(&sta->lock);
+		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR);
 	}
+	spin_unlock_bh(&sta->lock);
 }
--- wireless-testing.orig/net/mac80211/ht.c	2009-02-10 20:59:34.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2009-02-10 20:59:35.000000000 +0100
@@ -155,15 +155,12 @@ u32 ieee80211_enable_ht(struct ieee80211
 
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta)
 {
-	struct ieee80211_local *local = sta->local;
 	int i;
 
 	for (i = 0; i <  STA_TID_NUM; i++) {
-		ieee80211_stop_tx_ba_session(&local->hw, sta->sta.addr, i,
-					     WLAN_BACK_INITIATOR);
-		ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->sta.addr, i,
-						 WLAN_BACK_RECIPIENT,
-						 WLAN_REASON_QSTA_LEAVE_QBSS);
+		__ieee80211_stop_tx_ba_session(sta, i, WLAN_BACK_INITIATOR);
+		__ieee80211_stop_rx_ba_session(sta, i, WLAN_BACK_RECIPIENT,
+					       WLAN_REASON_QSTA_LEAVE_QBSS);
 	}
 }
 

-- 

