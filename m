Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53150 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752409AbeFZHR0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 03:17:26 -0400
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [PATCH] mac80211: add stop/start logic for software TXQs
Date: Tue, 26 Jun 2018 12:46:55 +0530
Message-Id: <1529997415-20551-1-git-send-email-mpubbise@codeaurora.org> (sfid-20180626_091731_603062_CC37BA6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes, it is required to stop the transmissions momentarily and
resume it later; stopping the txqs becomes very critical in scenarios where
the packet transmission has to be ceased completely. For example, during
the hardware restart, during off channel operations,
when initiating CSA(upon detecting a radar on the DFS channel), etc.

The TX queue stop/start logic in mac80211 works well in stopping the TX
when drivers make use of netdev queues, i.e, when Qdiscs in network layer
take care of traffic scheduling. Since the devices implementing
wake_tx_queue can run without Qdiscs, packets will be handed to mac80211
directly without queueing them in the netdev queues.

Also, mac80211 does not invoke any of the
netif_stop_*/netif_wake_* APIs if wake_tx_queue is implemented.
Since the queues are not stopped in this case, transmissions can continue
and this will impact negatively on the operation of the wireless device.

For example,
During hardware restart, we stop the netdev queues so that packets are
not sent to the driver. Since ath10k implements wake_tx_queue,
TX queues will not be stopped and packets might reach the hardware while
it is restarting; this can make hardware unresponsive and the only
possible option for recovery is to reboot the entire system.

There is another problem to this, it is observed that the packets
were sent on the DFS channel for a prolonged duration after radar
detection impacting the channel closing times.

We can still invoke netif stop/wake APIs when wake_tx_queue is implemented
but this could lead to packet drops in network layer; adding stop/start
logic for software TXQs in mac80211 instead makes more sense; the change
proposed adds the same in mac80211.

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
---
 net/mac80211/ieee80211_i.h |  6 +++++
 net/mac80211/sta_info.h    |  1 +
 net/mac80211/tx.c          | 13 +++++++++-
 net/mac80211/util.c        | 65 +++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 172aeae..500da15 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -818,6 +818,7 @@ enum txq_info_flags {
 	IEEE80211_TXQ_STOP,
 	IEEE80211_TXQ_AMPDU,
 	IEEE80211_TXQ_NO_AMSDU,
+	IEEE80211_TXQ_PAUSED,
 };
 
 /**
@@ -1139,6 +1140,11 @@ struct ieee80211_local {
 	/* also used to protect ampdu_ac_queue and amdpu_ac_stop_refcnt */
 	spinlock_t queue_stop_reason_lock;
 
+	/* pause/resume logic for intermediate software queues,
+	 * applicable when wake_tx_queue is defined.
+	 */
+	unsigned long txqs_stopped;
+
 	int open_count;
 	int monitors, cooked_mntrs;
 	/* number of interfaces with corresponding FIF_ flags */
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9a04327..82e5bbb 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -582,6 +582,7 @@ struct sta_info {
 	u8 reserved_tid;
 
 	struct cfg80211_chan_def tdls_chandef;
+	atomic_t txqs_paused;
 
 	/* keep last! */
 	struct ieee80211_sta sta;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5b93bde..9b30ee6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3467,12 +3467,23 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result r;
 	struct ieee80211_vif *vif;
+	struct sta_info *sta;
 
 	spin_lock_bh(&fq->lock);
 
-	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
+	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags) ||
+	    test_bit(IEEE80211_TXQ_PAUSED, &txqi->flags))
 		goto out;
 
+	if (local->txqs_stopped) {
+		set_bit(IEEE80211_TXQ_PAUSED, &txqi->flags);
+		if (txq->sta) {
+			sta = container_of(txq->sta, struct sta_info, sta);
+			atomic_set(&sta->txqs_paused, 1);
+		}
+		goto out;
+	}
+
 	/* Make sure fragments stay together. */
 	skb = __skb_dequeue(&txqi->frags);
 	if (skb)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c77c843..b9db417 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -273,6 +273,62 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 	}
 }
 
+static void ieee80211_wake_txqs(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+	struct txq_info *txqi;
+	int i;
+
+	if (!local->ops->wake_tx_queue)
+		return;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (!atomic_read(&sta->txqs_paused))
+			continue;
+
+		atomic_set(&sta->txqs_paused, 0);
+
+		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
+			txqi = to_txq_info(sta->sta.txq[i]);
+
+			if (!test_and_clear_bit(IEEE80211_TXQ_PAUSED,
+						&txqi->flags))
+				continue;
+
+			drv_wake_tx_queue(local, txqi);
+		}
+	}
+
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		struct ieee80211_vif *vif = &sdata->vif;
+		struct ps_data *ps = NULL;
+
+		/* Software interfaces like AP_VLAN, monitor do not have
+		 * vif specific queues.
+		 */
+		if (!sdata->dev || !vif->txq)
+			continue;
+
+		txqi = to_txq_info(vif->txq);
+
+		if (!test_and_clear_bit(IEEE80211_TXQ_PAUSED, &txqi->flags))
+			continue;
+
+		if (sdata->vif.type == NL80211_IFTYPE_AP)
+			ps = &sdata->bss->ps;
+
+		if (ps && atomic_read(&ps->num_sta_ps))
+			continue;
+
+		drv_wake_tx_queue(local, txqi);
+	}
+
+	rcu_read_unlock();
+}
+
 static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 				   enum queue_stop_reason reason,
 				   bool refcounted)
@@ -298,10 +354,15 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 	if (local->q_stop_reasons[queue][reason] == 0)
 		__clear_bit(reason, &local->queue_stop_reasons[queue]);
 
+	if (local->ops->wake_tx_queue)
+		__clear_bit(reason, &local->txqs_stopped);
+
 	if (local->queue_stop_reasons[queue] != 0)
 		/* someone still has this queue stopped */
 		return;
 
+	ieee80211_wake_txqs(local);
+
 	if (skb_queue_empty(&local->pending[queue])) {
 		rcu_read_lock();
 		ieee80211_propagate_queue_wake(local, queue);
@@ -351,8 +412,10 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 	if (__test_and_set_bit(reason, &local->queue_stop_reasons[queue]))
 		return;
 
-	if (local->ops->wake_tx_queue)
+	if (local->ops->wake_tx_queue) {
+		__set_bit(reason, &local->txqs_stopped);
 		return;
+	}
 
 	if (local->hw.queues < IEEE80211_NUM_ACS)
 		n_acs = 1;
-- 
2.7.4
