Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:60195 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752455AbaFMNaY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 09:30:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, michal.kazior@tieto.com
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Fri, 13 Jun 2014 16:30:05 +0300
Message-Id: <1402666207-2257-3-git-send-email-luca@coelho.fi> (sfid-20140613_153048_801898_7951F51F)
In-Reply-To: <1402666207-2257-1-git-send-email-luca@coelho.fi>
References: <1402666207-2257-1-git-send-email-luca@coelho.fi>
Subject: [PATCH v2 2/4] mac80211: introduce refcount for queue_stop_reasons
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Sometimes different vifs may be stopping the queues for the same
reason (e.g. when several interfaces are performing a channel switch).
Instead of using a bitmask for the reasons, use an integer that holds
a refcount instead.  In order to keep it backwards compatible,
introduce a boolean in some functions that tell us whether the queue
stopping should be refcounted or not.  For now, use not refcounted for
all calls to keep it functionally the same as before.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
Comparing to RFC option 2 v2:

  * don't change debugfs, since we now have the reason mask anyway
---
 net/mac80211/agg-tx.c      |  8 +++--
 net/mac80211/cfg.c         |  9 ++++--
 net/mac80211/ieee80211_i.h | 15 ++++++---
 net/mac80211/iface.c       |  3 +-
 net/mac80211/main.c        |  3 +-
 net/mac80211/mlme.c        | 15 ++++++---
 net/mac80211/offchannel.c  |  6 ++--
 net/mac80211/pm.c          |  6 ++--
 net/mac80211/tx.c          |  3 +-
 net/mac80211/util.c        | 76 +++++++++++++++++++++++++++++++---------------
 10 files changed, 98 insertions(+), 46 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index ce9633a..d6986f3 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -170,10 +170,13 @@ ieee80211_stop_queue_agg(struct ieee80211_sub_if_data *sdata, int tid)
 {
 	int queue = sdata->vif.hw_queue[ieee80211_ac_from_tid(tid)];
 
+	/* we do refcounting here, so don't use the queue reason refcounting */
+
 	if (atomic_inc_return(&sdata->local->agg_queue_stop[queue]) == 1)
 		ieee80211_stop_queue_by_reason(
 			&sdata->local->hw, queue,
-			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+			IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
+			false);
 	__acquire(agg_queue);
 }
 
@@ -185,7 +188,8 @@ ieee80211_wake_queue_agg(struct ieee80211_sub_if_data *sdata, int tid)
 	if (atomic_dec_return(&sdata->local->agg_queue_stop[queue]) == 0)
 		ieee80211_wake_queue_by_reason(
 			&sdata->local->hw, queue,
-			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+			IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
+			false);
 	__release(agg_queue);
 }
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index af3eac4..e920d48 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -837,7 +837,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	if (!ieee80211_csa_needs_block_tx(local))
 		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+					IEEE80211_QUEUE_STOP_REASON_CSA,
+					false);
 	mutex_unlock(&local->mtx);
 
 	kfree(sdata->u.ap.next_beacon);
@@ -2828,7 +2829,8 @@ static int __ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	if (!ieee80211_csa_needs_block_tx(local))
 		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+					IEEE80211_QUEUE_STOP_REASON_CSA,
+					false);
 
 	return 0;
 }
@@ -3060,7 +3062,8 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	if (sdata->csa_block_tx)
 		ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+					IEEE80211_QUEUE_STOP_REASON_CSA,
+					false);
 
 	if (changed) {
 		ieee80211_bss_info_change_notify(sdata, changed);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 677e9c8..f2b59c6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -921,6 +921,8 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 	IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
 	IEEE80211_QUEUE_STOP_REASON_FLUSH,
+
+	IEEE80211_QUEUE_STOP_REASONS,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
@@ -1017,6 +1019,7 @@ struct ieee80211_local {
 	struct workqueue_struct *workqueue;
 
 	unsigned long queue_stop_reasons[IEEE80211_MAX_QUEUES];
+	int q_stop_reasons[IEEE80211_MAX_QUEUES][IEEE80211_QUEUE_STOP_REASONS];
 	/* also used to protect ampdu_ac_queue and amdpu_ac_stop_refcnt */
 	spinlock_t queue_stop_reason_lock;
 
@@ -1714,14 +1717,18 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     unsigned long queues,
-				     enum queue_stop_reason reason);
+				     enum queue_stop_reason reason,
+				     bool refcounted);
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 				     unsigned long queues,
-				     enum queue_stop_reason reason);
+				     enum queue_stop_reason reason,
+				     bool refcounted);
 void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
-				    enum queue_stop_reason reason);
+				    enum queue_stop_reason reason,
+				    bool refcounted);
 void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
-				    enum queue_stop_reason reason);
+				    enum queue_stop_reason reason,
+				    bool refcounted);
 void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue);
 void ieee80211_add_pending_skb(struct ieee80211_local *local,
 			       struct sk_buff *skb);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 00762a1..5e7b371 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -844,7 +844,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	if (!ieee80211_csa_needs_block_tx(local))
 		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+					IEEE80211_QUEUE_STOP_REASON_CSA,
+					false);
 	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 54e632b..89170c8 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -270,7 +270,8 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
 
 	/* use this reason, ieee80211_reconfig will unblock it */
 	ieee80211_stop_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+					IEEE80211_QUEUE_STOP_REASON_SUSPEND,
+					false);
 
 	/*
 	 * Stop all Rx during the reconfig. We don't want state changes
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7f073ef..8b73476 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -983,7 +983,8 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ieee80211_csa_needs_block_tx(local))
 		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+					IEEE80211_QUEUE_STOP_REASON_CSA,
+					false);
 	mutex_unlock(&local->mtx);
 
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
@@ -1115,7 +1116,8 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (sdata->csa_block_tx)
 		ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+					IEEE80211_QUEUE_STOP_REASON_CSA,
+					false);
 	mutex_unlock(&local->mtx);
 
 	if (local->ops->channel_switch) {
@@ -1385,7 +1387,8 @@ void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 
 	ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_PS);
+					IEEE80211_QUEUE_STOP_REASON_PS,
+					false);
 }
 
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
@@ -1833,7 +1836,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	if (!ieee80211_csa_needs_block_tx(local))
 		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+					IEEE80211_QUEUE_STOP_REASON_CSA,
+					false);
 	mutex_unlock(&local->mtx);
 
 	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
@@ -2082,7 +2086,8 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 	if (!ieee80211_csa_needs_block_tx(local))
 		ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+					IEEE80211_QUEUE_STOP_REASON_CSA,
+					false);
 	mutex_unlock(&local->mtx);
 
 	cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 0c2a294..1a523e0 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -119,7 +119,8 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 	 * before sending nullfunc to enable powersave at the AP.
 	 */
 	ieee80211_stop_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL);
+					IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
+					false);
 	ieee80211_flush_queues(local, NULL);
 
 	mutex_lock(&local->iflist_mtx);
@@ -182,7 +183,8 @@ void ieee80211_offchannel_return(struct ieee80211_local *local)
 	mutex_unlock(&local->iflist_mtx);
 
 	ieee80211_wake_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL);
+					IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
+					false);
 }
 
 void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc)
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index d478b88..4c5192e 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -35,7 +35,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	ieee80211_stop_queues_by_reason(hw,
 					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+					IEEE80211_QUEUE_STOP_REASON_SUSPEND,
+					false);
 
 	/* flush out all packets */
 	synchronize_net();
@@ -74,7 +75,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			}
 			ieee80211_wake_queues_by_reason(hw,
 					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+					IEEE80211_QUEUE_STOP_REASON_SUSPEND,
+					false);
 			return err;
 		} else if (err > 0) {
 			WARN_ON(err != 1);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0a519a5..662a984 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -250,7 +250,8 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		ieee80211_stop_queues_by_reason(&local->hw,
 						IEEE80211_MAX_QUEUE_MAP,
-						IEEE80211_QUEUE_STOP_REASON_PS);
+						IEEE80211_QUEUE_STOP_REASON_PS,
+						false);
 		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
 		ieee80211_queue_work(&local->hw,
 				     &local->dynamic_ps_disable_work);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 04e5f5c..8552fe4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -317,7 +317,8 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 }
 
 static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
-				   enum queue_stop_reason reason)
+				   enum queue_stop_reason reason,
+				   bool refcounted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
@@ -329,7 +330,13 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 	if (!test_bit(reason, &local->queue_stop_reasons[queue]))
 		return;
 
-	__clear_bit(reason, &local->queue_stop_reasons[queue]);
+	if (!refcounted)
+		local->q_stop_reasons[queue][reason] = 0;
+	else
+		local->q_stop_reasons[queue][reason]--;
+
+	if (local->q_stop_reasons[queue][reason] == 0)
+		__clear_bit(reason, &local->queue_stop_reasons[queue]);
 
 	if (local->queue_stop_reasons[queue] != 0)
 		/* someone still has this queue stopped */
@@ -344,25 +351,28 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 }
 
 void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
-				    enum queue_stop_reason reason)
+				    enum queue_stop_reason reason,
+				    bool refcounted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	__ieee80211_wake_queue(hw, queue, reason);
+	__ieee80211_wake_queue(hw, queue, reason, refcounted);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
 void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
 {
 	ieee80211_wake_queue_by_reason(hw, queue,
-				       IEEE80211_QUEUE_STOP_REASON_DRIVER);
+				       IEEE80211_QUEUE_STOP_REASON_DRIVER,
+				       false);
 }
 EXPORT_SYMBOL(ieee80211_wake_queue);
 
 static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
-				   enum queue_stop_reason reason)
+				   enum queue_stop_reason reason,
+				   bool refcounted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -373,10 +383,13 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 	if (WARN_ON(queue >= hw->queues))
 		return;
 
-	if (test_bit(reason, &local->queue_stop_reasons[queue]))
-		return;
+	if (!refcounted)
+		local->q_stop_reasons[queue][reason] = 1;
+	else
+		local->q_stop_reasons[queue][reason]++;
 
-	__set_bit(reason, &local->queue_stop_reasons[queue]);
+	if (__test_and_set_bit(reason, &local->queue_stop_reasons[queue]))
+		return;
 
 	if (local->hw.queues < IEEE80211_NUM_ACS)
 		n_acs = 1;
@@ -398,20 +411,22 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 }
 
 void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
-				    enum queue_stop_reason reason)
+				    enum queue_stop_reason reason,
+				    bool refcounted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	__ieee80211_stop_queue(hw, queue, reason);
+	__ieee80211_stop_queue(hw, queue, reason, refcounted);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
 void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
 {
 	ieee80211_stop_queue_by_reason(hw, queue,
-				       IEEE80211_QUEUE_STOP_REASON_DRIVER);
+				       IEEE80211_QUEUE_STOP_REASON_DRIVER,
+				       false);
 }
 EXPORT_SYMBOL(ieee80211_stop_queue);
 
@@ -429,9 +444,11 @@ void ieee80211_add_pending_skb(struct ieee80211_local *local,
 	}
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	__ieee80211_stop_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+	__ieee80211_stop_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+			       false);
 	__skb_queue_tail(&local->pending[queue], skb);
-	__ieee80211_wake_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+	__ieee80211_wake_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+			       false);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
@@ -455,20 +472,23 @@ void ieee80211_add_pending_skbs(struct ieee80211_local *local,
 		queue = info->hw_queue;
 
 		__ieee80211_stop_queue(hw, queue,
-				IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+				IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+				false);
 
 		__skb_queue_tail(&local->pending[queue], skb);
 	}
 
 	for (i = 0; i < hw->queues; i++)
 		__ieee80211_wake_queue(hw, i,
-			IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+			IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+			false);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 				     unsigned long queues,
-				     enum queue_stop_reason reason)
+				     enum queue_stop_reason reason,
+				     bool refcounted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	unsigned long flags;
@@ -477,7 +497,7 @@ void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
 	for_each_set_bit(i, &queues, hw->queues)
-		__ieee80211_stop_queue(hw, i, reason);
+		__ieee80211_stop_queue(hw, i, reason, refcounted);
 
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
@@ -485,7 +505,8 @@ void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 void ieee80211_stop_queues(struct ieee80211_hw *hw)
 {
 	ieee80211_stop_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_DRIVER);
+					IEEE80211_QUEUE_STOP_REASON_DRIVER,
+					false);
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
 
@@ -508,7 +529,8 @@ EXPORT_SYMBOL(ieee80211_queue_stopped);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     unsigned long queues,
-				     enum queue_stop_reason reason)
+				     enum queue_stop_reason reason,
+				     bool refcounted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	unsigned long flags;
@@ -517,7 +539,7 @@ void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
 	for_each_set_bit(i, &queues, hw->queues)
-		__ieee80211_wake_queue(hw, i, reason);
+		__ieee80211_wake_queue(hw, i, reason, refcounted);
 
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
@@ -525,7 +547,8 @@ void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 void ieee80211_wake_queues(struct ieee80211_hw *hw)
 {
 	ieee80211_wake_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_DRIVER);
+					IEEE80211_QUEUE_STOP_REASON_DRIVER,
+					false);
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
@@ -552,12 +575,14 @@ void ieee80211_flush_queues(struct ieee80211_local *local,
 	}
 
 	ieee80211_stop_queues_by_reason(&local->hw, queues,
-					IEEE80211_QUEUE_STOP_REASON_FLUSH);
+					IEEE80211_QUEUE_STOP_REASON_FLUSH,
+					false);
 
 	drv_flush(local, sdata, queues, false);
 
 	ieee80211_wake_queues_by_reason(&local->hw, queues,
-					IEEE80211_QUEUE_STOP_REASON_FLUSH);
+					IEEE80211_QUEUE_STOP_REASON_FLUSH,
+					false);
 }
 
 static void __iterate_active_interfaces(struct ieee80211_local *local,
@@ -1797,7 +1822,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	}
 
 	ieee80211_wake_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+					IEEE80211_QUEUE_STOP_REASON_SUSPEND,
+					false);
 
 	/*
 	 * Reconfigure sched scan if it was interrupted by FW restart or
-- 
2.0.0.rc2

