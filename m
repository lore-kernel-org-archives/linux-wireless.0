Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:55282 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751909AbaFFP1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 11:27:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, michal.kazior@tieto.com
Cc: linux-wireless@vger.kernel.org
Date: Fri,  6 Jun 2014 18:27:03 +0300
Message-Id: <1402068423-23359-1-git-send-email-luca@coelho.fi> (sfid-20140606_172722_955902_9839F53E)
Subject: [RFC] mac80211: introduce refcount for queue_stop_reasons
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Sometimes different vifs may be stopping the queues for the same
reason (e.g. when several interfaces are performing a channel switch).
Instead of using a bitmask for the reasons, use an integer that holds
a refcount instead.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---

As discussed on IRC, I'm trying to convert the queue stop reasons to
have a refcount instead of a single boolean for each reason.

This is the first option, accessing the entire array of reasons when
checking if the queue is stopped by any reason.  This introduces some
extra for loops in the TX path...

The other option would be to "cache" the stop state of each queue, so
when checking if the queue is stopped by any reason, we could test a
single bit.  This should be simple to do as well, I just keep the old
bitmask and set/unset the reason bit when ref'ing/unref'ing.

Please let me know what you think!


 net/mac80211/debugfs.c     | 13 ++++++++-----
 net/mac80211/ieee80211_i.h |  6 +++++-
 net/mac80211/iface.c       |  6 ++++--
 net/mac80211/mlme.c        |  2 +-
 net/mac80211/tx.c          |  6 +++---
 net/mac80211/util.c        | 34 ++++++++++++++++++++++------------
 6 files changed, 43 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 0e963bc1..81f110b 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -332,13 +332,16 @@ static ssize_t queues_read(struct file *file, char __user *user_buf,
 	struct ieee80211_local *local = file->private_data;
 	unsigned long flags;
 	char buf[IEEE80211_MAX_QUEUES * 20];
-	int q, res = 0;
+	int q, r, res = 0;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	for (q = 0; q < local->hw.queues; q++)
-		res += sprintf(buf + res, "%02d: %#.8lx/%d\n", q,
-				local->queue_stop_reasons[q],
-				skb_queue_len(&local->pending[q]));
+	for (q = 0; q < local->hw.queues; q++) {
+		for (r = 0; r < IEEE80211_QSTOP_REASONS; r++)
+			res += sprintf(buf + res,
+				       "%02d: reason[%02d] = %d/%d\n", q, r,
+				       local->queue_stop_reasons[q][r],
+				       skb_queue_len(&local->pending[q]));
+	}
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 677e9c8..e9f7ab2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -921,6 +921,8 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 	IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
 	IEEE80211_QUEUE_STOP_REASON_FLUSH,
+
+	IEEE80211_QSTOP_REASONS,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
@@ -1016,7 +1018,7 @@ struct ieee80211_local {
 	 */
 	struct workqueue_struct *workqueue;
 
-	unsigned long queue_stop_reasons[IEEE80211_MAX_QUEUES];
+	int queue_stop_reasons[IEEE80211_MAX_QUEUES][IEEE80211_QSTOP_REASONS];
 	/* also used to protect ampdu_ac_queue and amdpu_ac_stop_refcnt */
 	spinlock_t queue_stop_reason_lock;
 
@@ -1722,6 +1724,8 @@ void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
 				    enum queue_stop_reason reason);
 void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
 				    enum queue_stop_reason reason);
+unsigned long ieee80211_queue_stop_reasons(struct ieee80211_local *local,
+					   unsigned int queue);
 void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue);
 void ieee80211_add_pending_skb(struct ieee80211_local *local,
 			       struct sk_buff *skb);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 00762a1..0899040 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -708,12 +708,14 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		if (sdata->vif.cab_queue == IEEE80211_INVAL_HW_QUEUE ||
-		    (local->queue_stop_reasons[sdata->vif.cab_queue] == 0 &&
+		    (!ieee80211_queue_stop_reasons(local,
+						   sdata->vif.cab_queue) &&
 		     skb_queue_empty(&local->pending[sdata->vif.cab_queue]))) {
 			for (ac = 0; ac < n_acs; ac++) {
 				int ac_queue = sdata->vif.hw_queue[ac];
 
-				if (local->queue_stop_reasons[ac_queue] == 0 &&
+				if (!ieee80211_queue_stop_reasons(local,
+								  ac_queue) &&
 				    skb_queue_empty(&local->pending[ac_queue]))
 					netif_start_subqueue(dev, ac);
 			}
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7f073ef..1b7c736 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1423,7 +1423,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		 */
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		for (q = 0; q < local->hw.queues; q++) {
-			if (local->queue_stop_reasons[q]) {
+			if (ieee80211_queue_stop_reasons(local, q)) {
 				spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 						       flags);
 				mod_timer(&local->dynamic_ps_timer, jiffies +
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0a519a5..0cf3b56 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1216,11 +1216,11 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 #endif
 
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-		if (local->queue_stop_reasons[q] ||
+		if (ieee80211_queue_stop_reasons(local, q) ||
 		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
 			if (unlikely(info->flags &
 				     IEEE80211_TX_INTFL_OFFCHAN_TX_OK)) {
-				if (local->queue_stop_reasons[q] &
+				if (ieee80211_queue_stop_reasons(local, q) &
 				    ~BIT(IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL)) {
 					/*
 					 * Drop off-channel frames if queues
@@ -2297,7 +2297,7 @@ void ieee80211_tx_pending(unsigned long data)
 		 * If queue is stopped by something other than due to pending
 		 * frames, or we have no pending frames, proceed to next queue.
 		 */
-		if (local->queue_stop_reasons[i] ||
+		if (ieee80211_queue_stop_reasons(local, i) ||
 		    skb_queue_empty(&local->pending[i]))
 			continue;
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 04e5f5c..91226ab 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -286,6 +286,19 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_ctstoself_duration);
 
+unsigned long ieee80211_queue_stop_reasons(struct ieee80211_local *local,
+					   unsigned int queue)
+{
+	int i;
+	unsigned long reasons = 0;
+
+	for (i = 0; i < IEEE80211_QSTOP_REASONS; i++)
+		if (local->queue_stop_reasons[queue][i])
+			reasons |= BIT(i);
+
+	return reasons;
+}
+
 void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -301,7 +314,7 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 			continue;
 
 		if (sdata->vif.cab_queue != IEEE80211_INVAL_HW_QUEUE &&
-		    local->queue_stop_reasons[sdata->vif.cab_queue] != 0)
+		    ieee80211_queue_stop_reasons(local, sdata->vif.cab_queue))
 			continue;
 
 		for (ac = 0; ac < n_acs; ac++) {
@@ -309,7 +322,7 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 
 			if (ac_queue == queue ||
 			    (sdata->vif.cab_queue == queue &&
-			     local->queue_stop_reasons[ac_queue] == 0 &&
+			     !ieee80211_queue_stop_reasons(local, ac_queue) &&
 			     skb_queue_empty(&local->pending[ac_queue])))
 				netif_wake_subqueue(sdata->dev, ac);
 		}
@@ -326,12 +339,12 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 	if (WARN_ON(queue >= hw->queues))
 		return;
 
-	if (!test_bit(reason, &local->queue_stop_reasons[queue]))
+	if (local->queue_stop_reasons[queue][reason] == 0)
 		return;
 
-	__clear_bit(reason, &local->queue_stop_reasons[queue]);
+	local->queue_stop_reasons[queue][reason]--;
 
-	if (local->queue_stop_reasons[queue] != 0)
+	if (ieee80211_queue_stop_reasons(local, queue))
 		/* someone still has this queue stopped */
 		return;
 
@@ -373,11 +386,9 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 	if (WARN_ON(queue >= hw->queues))
 		return;
 
-	if (test_bit(reason, &local->queue_stop_reasons[queue]))
+	if (local->queue_stop_reasons[queue][reason]++)
 		return;
 
-	__set_bit(reason, &local->queue_stop_reasons[queue]);
-
 	if (local->hw.queues < IEEE80211_NUM_ACS)
 		n_acs = 1;
 
@@ -489,18 +500,17 @@ void ieee80211_stop_queues(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
 
-int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
+int ieee80211_queue_stopped(struct ieee80211_hw *hw, int q)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	unsigned long flags;
 	int ret;
 
-	if (WARN_ON(queue >= hw->queues))
+	if (WARN_ON(q >= hw->queues))
 		return true;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	ret = test_bit(IEEE80211_QUEUE_STOP_REASON_DRIVER,
-		       &local->queue_stop_reasons[queue]);
+	ret = local->queue_stop_reasons[q][IEEE80211_QUEUE_STOP_REASON_DRIVER];
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 	return ret;
 }
-- 
2.0.0.rc2

