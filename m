Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbZBJUiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:38:51 -0500
Message-Id: <20090210202555.796660072@sipsolutions.net> (sfid-20090210_213853_904669_83955A95)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:53 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 17/27] mac80211: RX aggregation: clean up stop session
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up the locking by splitting it into two functions,
this will also enable further cleanups of stopping all
sessions.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-rx.c |   57 ++++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-02-10 20:59:34.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2009-02-10 20:59:35.000000000 +0100
@@ -17,47 +17,32 @@
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 
-void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid,
-					u16 initiator, u16 reason)
+static void __ieee80211_sta_stop_rx_ba_session(struct sta_info *sta, u16 tid,
+					       u16 initiator, u16 reason)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_local *local = sta->local;
 	struct ieee80211_hw *hw = &local->hw;
-	struct sta_info *sta;
-	int ret, i;
-
-	rcu_read_lock();
-
-	sta = sta_info_get(local, ra);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
+	int i;
 
 	/* check if TID is in operational state */
 	spin_lock_bh(&sta->lock);
-	if (sta->ampdu_mlme.tid_state_rx[tid]
-				!= HT_AGG_STATE_OPERATIONAL) {
+	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_OPERATIONAL) {
 		spin_unlock_bh(&sta->lock);
-		rcu_read_unlock();
 		return;
 	}
+
 	sta->ampdu_mlme.tid_state_rx[tid] =
 		HT_AGG_STATE_REQ_STOP_BA_MSK |
 		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
 	spin_unlock_bh(&sta->lock);
 
-	/* stop HW Rx aggregation. ampdu_action existence
-	 * already verified in session init so we add the BUG_ON */
-	BUG_ON(!local->ops->ampdu_action);
-
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Rx BA session stop requested for %pM tid %u\n",
-	       ra, tid);
+	       sta->sta.addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
-				       &sta->sta, tid, NULL);
-	if (ret)
+	if (local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
+				     &sta->sta, tid, NULL))
 		printk(KERN_DEBUG "HW problem - can not stop rx "
 				"aggregation for tid %d\n", tid);
 
@@ -67,7 +52,8 @@ void ieee80211_sta_stop_rx_ba_session(st
 
 	/* check if this is a self generated aggregation halt */
 	if (initiator == WLAN_BACK_RECIPIENT || initiator == WLAN_BACK_TIMER)
-		ieee80211_send_delba(sdata, ra, tid, 0, reason);
+		ieee80211_send_delba(sta->sdata, sta->sta.addr,
+				     tid, 0, reason);
 
 	/* free the reordering buffer */
 	for (i = 0; i < sta->ampdu_mlme.tid_rx[tid]->buf_size; i++) {
@@ -90,6 +76,27 @@ void ieee80211_sta_stop_rx_ba_session(st
 
 	sta->ampdu_mlme.tid_state_rx[tid] = HT_AGG_STATE_IDLE;
 	spin_unlock_bh(&sta->lock);
+}
+
+void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid,
+					u16 initiator, u16 reason)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	/* stop HW Rx aggregation. ampdu_action existence
+	 * already verified in session init so we add the BUG_ON */
+	BUG_ON(!local->ops->ampdu_action);
+
+	rcu_read_lock();
+
+	sta = sta_info_get(local, ra);
+	if (!sta) {
+		rcu_read_unlock();
+		return;
+	}
+
+	__ieee80211_sta_stop_rx_ba_session(sta, tid, initiator, reason);
 
 	rcu_read_unlock();
 }

-- 

