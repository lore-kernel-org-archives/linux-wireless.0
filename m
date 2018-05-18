Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45922 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbeERTgx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 15:36:53 -0400
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [RFC] mac80211: add stop/start logic for software TXQs
Date: Sat, 19 May 2018 01:06:32 +0530
Message-Id: <1526672192-3873-1-git-send-email-mpubbise@codeaurora.org> (sfid-20180518_213658_080078_E383CE25)
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
wake_tx_queue run without Qdiscs, packets will be handed to mac80211
directly without queueing them in the netdev queues. Also, mac80211
does not invoke any of the netif_stop_*/netif_wake_* APIs to stop the
transmissions and this might very well lead to undesirabled things.

For example,
During hardware restart, we stop the netdev queues so that packets are
not sent to the driver. Since ath10k implements wake_tx_queue,
TX queues will not be stopped and packets might reach the hardware while
it is restarting; this can make hardware unresponsive and can be
recovered only by rebooting the system.

There is another problem to this, it is observed that the packets
were sent on the DFS channel for a prolonged duration after radar detection
impacting the channel closing times.

We can still invoke netif stop/wake APIs when wake_tx_queue is implemented
but this could lead to packet drops in network layer; adding stop/start
logic for software TXQs in mac80211 instead makes more sense; the change
proposed adds the same in mac80211.

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
---
 net/mac80211/agg-tx.c      | 4 ++++
 net/mac80211/ieee80211_i.h | 5 +++++
 net/mac80211/sta_info.c    | 3 +++
 net/mac80211/tx.c          | 3 +++
 net/mac80211/util.c        | 7 ++++++-
 5 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 595c662..7cfec25 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -213,11 +213,15 @@ static void
 ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
 {
 	struct ieee80211_txq *txq = sta->sta.txq[tid];
+	struct ieee80211_local *local = sta->local;
 	struct txq_info *txqi;
 
 	if (!txq)
 		return;
 
+	if (local->txqs_stopped)
+		return;
+
 	txqi = to_txq_info(txq);
 
 	if (enable)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d1978aa..dd64e8c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1137,6 +1137,11 @@ struct ieee80211_local {
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
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6428f1a..03ea152 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1244,6 +1244,9 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 			if (!txq_has_queue(sta->sta.txq[i]))
 				continue;
 
+			if (local->txqs_stopped)
+				continue;
+
 			drv_wake_tx_queue(local, to_txq_info(sta->sta.txq[i]));
 		}
 	}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8275a58..67156cb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1559,6 +1559,9 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
 	    sdata->vif.type == NL80211_IFTYPE_MONITOR)
 		return false;
 
+	if (local->txqs_stopped)
+		return false;
+
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		sdata = container_of(sdata->bss,
 				     struct ieee80211_sub_if_data, u.ap);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2d82c88..da7ae8b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -298,6 +298,9 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 	if (local->q_stop_reasons[queue][reason] == 0)
 		__clear_bit(reason, &local->queue_stop_reasons[queue]);
 
+	if (local->ops->wake_tx_queue)
+		__clear_bit(reason, &local->txqs_stopped);
+
 	if (local->queue_stop_reasons[queue] != 0)
 		/* someone still has this queue stopped */
 		return;
@@ -351,8 +354,10 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
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
