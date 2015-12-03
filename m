Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33260 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbbLCXKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 18:10:41 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC] mac80211:  Support 65 tx-queues.
Date: Thu,  3 Dec 2015 15:10:29 -0800
Message-Id: <1449184229-6254-1-git-send-email-greearb@candelatech.com> (sfid-20151204_001045_045715_630369F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

ath10k wants to use one tx-queue per vdev, and I want to support
up to 64 vdevs.  One additional q is needed for off-channel work.

So, re-work mac80211 to allow 65 tx queues.  This should have small
run-time effect, but it will cause a fair bit more RAM usage in
certain structs.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/net/mac80211.h     |  8 +++--
 net/mac80211/driver-ops.h  | 13 ++++++--
 net/mac80211/ieee80211_i.h |  9 ++++--
 net/mac80211/tx.c          |  9 ++++--
 net/mac80211/util.c        | 77 +++++++++++++++++++++++++++++++++-------------
 5 files changed, 83 insertions(+), 33 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 970372d..01e31bb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -123,13 +123,15 @@ struct device;
  * enum ieee80211_max_queues - maximum number of queues
  *
  * @IEEE80211_MAX_QUEUES: Maximum number of regular device queues.
- * @IEEE80211_MAX_QUEUE_MAP: bitmap with maximum queues set
  */
 enum ieee80211_max_queues {
-	IEEE80211_MAX_QUEUES =		16,
-	IEEE80211_MAX_QUEUE_MAP =	BIT(IEEE80211_MAX_QUEUES) - 1,
+	IEEE80211_MAX_QUEUES =		65,
 };
 
+/* bitmap with maximum queues set */
+#define IEEE80211_MAX_QUEUE_MAP_CNT 3
+extern unsigned long IEEE80211_MAX_QUEUE_MAP[IEEE80211_MAX_QUEUE_MAP_CNT];
+
 #define IEEE80211_INVAL_HW_QUEUE	0xff
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 46342c1..da976e3 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -789,7 +789,7 @@ static inline void drv_rfkill_poll(struct ieee80211_local *local)
 
 static inline void drv_flush(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
-			     u32 queues, bool drop)
+			     unsigned long *queues, bool drop)
 {
 	struct ieee80211_vif *vif = sdata ? &sdata->vif : NULL;
 
@@ -798,9 +798,16 @@ static inline void drv_flush(struct ieee80211_local *local,
 	if (sdata && !check_sdata_in_driver(sdata))
 		return;
 
-	trace_drv_flush(local, queues, drop);
+	trace_drv_flush(local, queues[0], drop);
+	/* NOTE:  Only ath10k might want more queues than fits in 32-bits,
+	 * and currently it pays no attention to the queues argument.  So,
+	 * just passing first value here is safe.  If other drivers ever
+	 * do need to see the array, then can create a flushA member
+	 * and use it if it exists, falling back to old flush() for
+	 * other drivers.
+	 */
 	if (local->ops->flush)
-		local->ops->flush(&local->hw, vif, queues, drop);
+		local->ops->flush(&local->hw, vif, queues[0], drop);
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 132ee14..fb8fd85 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1910,9 +1910,12 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr, bool ack, u16 tx_time);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
-				     unsigned long queues,
+				     unsigned long *queues,
 				     enum queue_stop_reason reason,
 				     bool refcounted);
+void ieee80211_get_vif_queues(struct ieee80211_local *local,
+			      struct ieee80211_sub_if_data *sdata,
+			      unsigned long *queues);
 void ieee80211_stop_vif_queues(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata,
 			       enum queue_stop_reason reason);
@@ -1920,7 +1923,7 @@ void ieee80211_wake_vif_queues(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata,
 			       enum queue_stop_reason reason);
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
-				     unsigned long queues,
+				     unsigned long *queues,
 				     enum queue_stop_reason reason,
 				     bool refcounted);
 void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
@@ -1938,7 +1941,7 @@ void ieee80211_flush_queues(struct ieee80211_local *local,
 			    struct ieee80211_sub_if_data *sdata, bool drop);
 void __ieee80211_flush_queues(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata,
-			      unsigned int queues, bool drop);
+			      unsigned long *queues, bool drop);
 
 static inline bool ieee80211_can_run_worker(struct ieee80211_local *local)
 {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 39d4f63..35d5dc7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3819,7 +3819,10 @@ int ieee80211_reserve_tid(struct ieee80211_sta *pubsta, u8 tid)
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	int ret;
-	u32 queues;
+	unsigned long queues[IEEE80211_MAX_QUEUE_MAP_CNT] = { 0, 0, 0 };
+	int idx, bit;
+
+	ieee80211_get_vif_queues(local, sdata, queues);
 
 	lockdep_assert_held(&local->sta_mtx);
 
@@ -3860,7 +3863,9 @@ int ieee80211_reserve_tid(struct ieee80211_sta *pubsta, u8 tid)
 					       AGG_STOP_LOCAL_REQUEST);
 	}
 
-	queues = BIT(sdata->vif.hw_queue[ieee802_1d_to_ac[tid]]);
+	idx = sdata->vif.hw_queue[ieee802_1d_to_ac[tid]] / BITS_PER_LONG;
+	bit = sdata->vif.hw_queue[ieee802_1d_to_ac[tid]] - (idx * BITS_PER_LONG);
+	queues[idx] = 1L << bit;
 	__ieee80211_flush_queues(local, sdata, queues, false);
 
 	sta->reserved_tid = tid;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a9aa90e..bcd2851 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -47,6 +47,9 @@ struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(wiphy_to_ieee80211_hw);
 
+unsigned long IEEE80211_MAX_QUEUE_MAP[3] = { -1L, -1L, -1L };
+EXPORT_SYMBOL(IEEE80211_MAX_QUEUE_MAP);
+
 /**
  * ieee80211_check_disabled_rates: Calculate which rate-sets are disabled
  *    in all bands.
@@ -396,8 +399,11 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 
 	trace_wake_queue(local, queue, reason);
 
-	if (WARN_ON(queue >= hw->queues))
+	if (WARN_ON(queue >= hw->queues)) {
+		pr_err("wake-queue, queue: %d > hw->queues: %d\n",
+		       queue, hw->queues);
 		return;
+	}
 
 	if (!test_bit(reason, &local->queue_stop_reasons[queue]))
 		return;
@@ -558,7 +564,7 @@ void ieee80211_add_pending_skbs(struct ieee80211_local *local,
 }
 
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
-				     unsigned long queues,
+				     unsigned long *queues,
 				     enum queue_stop_reason reason,
 				     bool refcounted)
 {
@@ -568,7 +574,7 @@ void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
-	for_each_set_bit(i, &queues, hw->queues)
+	for_each_set_bit(i, queues, hw->queues)
 		__ieee80211_stop_queue(hw, i, reason, refcounted);
 
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
@@ -600,7 +606,7 @@ int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
 EXPORT_SYMBOL(ieee80211_queue_stopped);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
-				     unsigned long queues,
+				     unsigned long *queues,
 				     enum queue_stop_reason reason,
 				     bool refcounted)
 {
@@ -610,7 +616,7 @@ void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
-	for_each_set_bit(i, &queues, hw->queues)
+	for_each_set_bit(i, queues, hw->queues)
 		__ieee80211_wake_queue(hw, i, reason, refcounted);
 
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
@@ -624,42 +630,63 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
-static unsigned int
+void
 ieee80211_get_vif_queues(struct ieee80211_local *local,
-			 struct ieee80211_sub_if_data *sdata)
+			 struct ieee80211_sub_if_data *sdata,
+			 unsigned long *queues)
 {
-	unsigned int queues;
+	int idx;
 
+	memset(queues, 0, sizeof(IEEE80211_MAX_QUEUE_MAP));
 	if (sdata && ieee80211_hw_check(&local->hw, QUEUE_CONTROL)) {
 		int ac;
 
-		queues = 0;
-
-		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			queues |= BIT(sdata->vif.hw_queue[ac]);
-		if (sdata->vif.cab_queue != IEEE80211_INVAL_HW_QUEUE)
-			queues |= BIT(sdata->vif.cab_queue);
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+			idx = sdata->vif.hw_queue[ac] / BITS_PER_LONG;
+			queues[idx] |= (1L << (sdata->vif.hw_queue[ac] - idx * BITS_PER_LONG));
+		}
+		if (sdata->vif.cab_queue != IEEE80211_INVAL_HW_QUEUE) {
+			idx = sdata->vif.cab_queue / BITS_PER_LONG;
+			queues[idx] |= (1L << (sdata->vif.cab_queue - idx * BITS_PER_LONG));
+		}
 	} else {
 		/* all queues */
-		queues = BIT(local->hw.queues) - 1;
-	}
+		int i;
 
-	return queues;
+		for (i = 0; i<local->hw.queues; i++) {
+			idx = i / BITS_PER_LONG;
+			queues[idx] |= (1L << (i - idx * BITS_PER_LONG));
+		}
+	}
 }
 
 void __ieee80211_flush_queues(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata,
-			      unsigned int queues, bool drop)
+			      unsigned long *_queues, bool drop)
 {
+	unsigned long queues[IEEE80211_MAX_QUEUE_MAP_CNT] = { 0, 0, 0 };
+	bool empty = true;
+	int i;
+
 	if (!local->ops->flush)
 		return;
 
+	if (_queues)
+		memcpy(queues, _queues, sizeof(queues));
+
+	for (i = 0; i<IEEE80211_MAX_QUEUE_MAP_CNT; i++) {
+		if (queues[i]) {
+			empty = false;
+			break;
+		}
+	}
+
 	/*
 	 * If no queue was set, or if the HW doesn't support
 	 * IEEE80211_HW_QUEUE_CONTROL - flush all queues
 	 */
-	if (!queues || !ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
-		queues = ieee80211_get_vif_queues(local, sdata);
+	if (empty || !ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
+		ieee80211_get_vif_queues(local, sdata, queues);
 
 	ieee80211_stop_queues_by_reason(&local->hw, queues,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH,
@@ -682,8 +709,11 @@ void ieee80211_stop_vif_queues(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata,
 			       enum queue_stop_reason reason)
 {
+	unsigned long queues[IEEE80211_MAX_QUEUE_MAP_CNT];
+
+	ieee80211_get_vif_queues(local, sdata, queues);
 	ieee80211_stop_queues_by_reason(&local->hw,
-					ieee80211_get_vif_queues(local, sdata),
+					queues,
 					reason, true);
 }
 
@@ -691,8 +721,11 @@ void ieee80211_wake_vif_queues(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata,
 			       enum queue_stop_reason reason)
 {
+	unsigned long queues[IEEE80211_MAX_QUEUE_MAP_CNT];
+
+	ieee80211_get_vif_queues(local, sdata, queues);
 	ieee80211_wake_queues_by_reason(&local->hw,
-					ieee80211_get_vif_queues(local, sdata),
+					queues,
 					reason, true);
 }
 
-- 
2.4.3

