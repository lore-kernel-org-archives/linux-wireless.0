Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59600 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524AbZCWQcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 12:32:35 -0400
Message-Id: <20090323163052.823346545@sipsolutions.net> (sfid-20090323_173236_879466_D1363235)
References: <20090323162834.154525349@sipsolutions.net>
Date: Mon, 23 Mar 2009 17:28:39 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/8] mac80211: unify and fix TX aggregation start
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When TX aggregation becomes operational, we do a number of steps:
 1) print a debug message
 2) wake the virtual queue
 3) notify the driver

Unfortunately, 1) and 3) are only done if the driver is first to
reply to the aggregation request, it is, however, possible that the
remote station replies before the driver! Thus, unify the code for
this and call the new function ieee80211_agg_tx_operational in both
places where TX aggregation can become operational.

Additionally, rename the driver notification from
IEEE80211_AMPDU_TX_RESUME to IEEE80211_AMPDU_TX_OPERATIONAL.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath9k/main.c |    2 -
 include/net/mac80211.h            |    4 +-
 net/mac80211/agg-tx.c             |   63 ++++++++++++++++----------------------
 3 files changed, 30 insertions(+), 39 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-03-23 13:59:19.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-03-23 14:03:46.000000000 +0100
@@ -404,6 +404,27 @@ int ieee80211_start_tx_ba_session(struct
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
 
+static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
+					 struct sta_info *sta, u16 tid)
+{
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Aggregation is on for tid %d \n", tid);
+#endif
+
+	if (local->hw.ampdu_queues) {
+		/*
+		 * Wake up the A-MPDU queue, we stopped it earlier,
+		 * this will in turn wake the entire AC.
+		 */
+		ieee80211_wake_queue_by_reason(&local->hw,
+			local->hw.queues + sta->tid_to_tx_q[tid],
+			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+	}
+
+	local->ops->ampdu_action(&local->hw, IEEE80211_AMPDU_TX_OPERATIONAL,
+				 &sta->sta, tid, NULL);
+}
+
 void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -446,20 +467,8 @@ void ieee80211_start_tx_ba_cb(struct iee
 
 	*state |= HT_ADDBA_DRV_READY_MSK;
 
-	if (*state == HT_AGG_STATE_OPERATIONAL) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Aggregation is on for tid %d \n", tid);
-#endif
-		if (hw->ampdu_queues) {
-			/*
-			 * Wake up this queue, we stopped it earlier,
-			 * this will in turn wake the entire AC.
-			 */
-			ieee80211_wake_queue_by_reason(hw,
-				hw->queues + sta->tid_to_tx_q[tid],
-				IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
-		}
-	}
+	if (*state == HT_AGG_STATE_OPERATIONAL)
+		ieee80211_agg_tx_operational(local, sta, tid);
 
  out:
 	spin_unlock_bh(&sta->lock);
@@ -646,9 +655,7 @@ void ieee80211_process_addba_resp(struct
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len)
 {
-	struct ieee80211_hw *hw = &local->hw;
-	u16 capab;
-	u16 tid, start_seq_num;
+	u16 capab, tid;
 	u8 *state;
 
 	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
@@ -682,26 +689,10 @@ void ieee80211_process_addba_resp(struct
 
 		*state |= HT_ADDBA_RECEIVED_MSK;
 
-		if (hw->ampdu_queues && *state != curstate &&
-		    *state == HT_AGG_STATE_OPERATIONAL) {
-			/*
-			 * Wake up this queue, we stopped it earlier,
-			 * this will in turn wake the entire AC.
-			 */
-			ieee80211_wake_queue_by_reason(hw,
-				hw->queues + sta->tid_to_tx_q[tid],
-				IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
-		}
-		sta->ampdu_mlme.addba_req_num[tid] = 0;
+		if (*state != curstate && *state == HT_AGG_STATE_OPERATIONAL)
+			ieee80211_agg_tx_operational(local, sta, tid);
 
-		if (local->ops->ampdu_action) {
-			(void)local->ops->ampdu_action(hw,
-					       IEEE80211_AMPDU_TX_RESUME,
-					       &sta->sta, tid, &start_seq_num);
-		}
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Resuming TX aggregation for tid %d\n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
+		sta->ampdu_mlme.addba_req_num[tid] = 0;
 	} else {
 		sta->ampdu_mlme.addba_req_num[tid]++;
 		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR);
--- wireless-testing.orig/include/net/mac80211.h	2009-03-23 14:00:12.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-03-23 14:03:46.000000000 +0100
@@ -1213,14 +1213,14 @@ enum ieee80211_filter_flags {
  * @IEEE80211_AMPDU_RX_STOP: stop Rx aggregation
  * @IEEE80211_AMPDU_TX_START: start Tx aggregation
  * @IEEE80211_AMPDU_TX_STOP: stop Tx aggregation
- * @IEEE80211_AMPDU_TX_RESUME: resume TX aggregation
+ * @IEEE80211_AMPDU_TX_OPERATIONAL: TX aggregation has become operational
  */
 enum ieee80211_ampdu_mlme_action {
 	IEEE80211_AMPDU_RX_START,
 	IEEE80211_AMPDU_RX_STOP,
 	IEEE80211_AMPDU_TX_START,
 	IEEE80211_AMPDU_TX_STOP,
-	IEEE80211_AMPDU_TX_RESUME,
+	IEEE80211_AMPDU_TX_OPERATIONAL,
 };
 
 /**
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-23 13:59:19.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-23 14:03:46.000000000 +0100
@@ -2730,7 +2730,7 @@ static int ath9k_ampdu_action(struct iee
 
 		ieee80211_stop_tx_ba_cb_irqsafe(hw, sta->addr, tid);
 		break;
-	case IEEE80211_AMPDU_TX_RESUME:
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		ath_tx_aggr_resume(sc, sta, tid);
 		break;
 	default:

-- 

