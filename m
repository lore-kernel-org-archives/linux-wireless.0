Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1LGICb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 03:02:31 -0500
Subject: [PATCH] mac80211: fix another race in aggregation start
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 09:02:21 +0100
Message-ID: <1323244941.3404.0.camel@jlt3.sipsolutions.net> (sfid-20111207_090237_552574_1F6FB2B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Emmanuel noticed that when mac80211 stops the queues
for aggregation that can leave a packet pending. This
packet will be given to the driver after the AMPDU
callback, but as a non-aggregated packet which messes
up the sequence number etc.

I also noticed by looking at the code that if packets
are being processed while we clear the WANT_START bit,
they might see it cleared already and queue up on
tid_tx->pending. If the driver then rejects the new
aggregation session we leak the packet.

Fix both of these issues by changing this code to not
stop the queues at all. Instead, let packets queue up
on the tid_tx->pending queue instead of letting them
get to the driver, and add code to recover properly
in case the driver rejects the session.

(The patch looks large because it has to move two
functions to before their new use.)

Cc: stable@vger.kernel.org
Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c |   86 +++++++++++++++++++++++---------------------------
 1 file changed, 41 insertions(+), 45 deletions(-)

--- a/net/mac80211/agg-tx.c	2011-11-29 19:28:50.000000000 +0100
+++ b/net/mac80211/agg-tx.c	2011-11-29 19:29:18.000000000 +0100
@@ -305,6 +305,38 @@ ieee80211_wake_queue_agg(struct ieee8021
 	__release(agg_queue);
 }
 
+/*
+ * splice packets from the STA's pending to the local pending,
+ * requires a call to ieee80211_agg_splice_finish later
+ */
+static void __acquires(agg_queue)
+ieee80211_agg_splice_packets(struct ieee80211_local *local,
+			     struct tid_ampdu_tx *tid_tx, u16 tid)
+{
+	int queue = ieee80211_ac_from_tid(tid);
+	unsigned long flags;
+
+	ieee80211_stop_queue_agg(local, tid);
+
+	if (WARN(!tid_tx, "TID %d gone but expected when splicing aggregates"
+			  " from the pending queue\n", tid))
+		return;
+
+	if (!skb_queue_empty(&tid_tx->pending)) {
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+		/* copy over remaining packets */
+		skb_queue_splice_tail_init(&tid_tx->pending,
+					   &local->pending[queue]);
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+	}
+}
+
+static void __releases(agg_queue)
+ieee80211_agg_splice_finish(struct ieee80211_local *local, u16 tid)
+{
+	ieee80211_wake_queue_agg(local, tid);
+}
+
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
 	struct tid_ampdu_tx *tid_tx;
@@ -316,19 +348,17 @@ void ieee80211_tx_ba_session_handle_star
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
 	/*
-	 * While we're asking the driver about the aggregation,
-	 * stop the AC queue so that we don't have to worry
-	 * about frames that came in while we were doing that,
-	 * which would require us to put them to the AC pending
-	 * afterwards which just makes the code more complex.
+	 * Start queuing up packets for this aggregation session.
+	 * We're going to release them once the driver is OK with
+	 * that.
 	 */
-	ieee80211_stop_queue_agg(local, tid);
-
 	clear_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
 
 	/*
-	 * make sure no packets are being processed to get
-	 * valid starting sequence number
+	 * Make sure no packets are being processed. This ensures that
+	 * we have a valid starting sequence number and that in-flight
+	 * packets have been flushed out and no packets for this TID
+	 * will go into the driver during the ampdu_action call.
 	 */
 	synchronize_net();
 
@@ -342,17 +372,15 @@ void ieee80211_tx_ba_session_handle_star
 					" tid %d\n", tid);
 #endif
 		spin_lock_bh(&sta->lock);
+		ieee80211_agg_splice_packets(local, tid_tx, tid);
 		ieee80211_assign_tid_tx(sta, tid, NULL);
+		ieee80211_agg_splice_finish(local, tid);
 		spin_unlock_bh(&sta->lock);
 
-		ieee80211_wake_queue_agg(local, tid);
 		kfree_rcu(tid_tx, rcu_head);
 		return;
 	}
 
-	/* we can take packets again now */
-	ieee80211_wake_queue_agg(local, tid);
-
 	/* activate the timer for the recipient's addBA response */
 	mod_timer(&tid_tx->addba_resp_timer, jiffies + ADDBA_RESP_INTERVAL);
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -490,38 +518,6 @@ int ieee80211_start_tx_ba_session(struct
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
 
-/*
- * splice packets from the STA's pending to the local pending,
- * requires a call to ieee80211_agg_splice_finish later
- */
-static void __acquires(agg_queue)
-ieee80211_agg_splice_packets(struct ieee80211_local *local,
-			     struct tid_ampdu_tx *tid_tx, u16 tid)
-{
-	int queue = ieee80211_ac_from_tid(tid);
-	unsigned long flags;
-
-	ieee80211_stop_queue_agg(local, tid);
-
-	if (WARN(!tid_tx, "TID %d gone but expected when splicing aggregates"
-			  " from the pending queue\n", tid))
-		return;
-
-	if (!skb_queue_empty(&tid_tx->pending)) {
-		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-		/* copy over remaining packets */
-		skb_queue_splice_tail_init(&tid_tx->pending,
-					   &local->pending[queue]);
-		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
-	}
-}
-
-static void __releases(agg_queue)
-ieee80211_agg_splice_finish(struct ieee80211_local *local, u16 tid)
-{
-	ieee80211_wake_queue_agg(local, tid);
-}
-
 static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 					 struct sta_info *sta, u16 tid)
 {


