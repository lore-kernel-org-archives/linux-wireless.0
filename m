Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:40345 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbYLRVgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 16:36:54 -0500
Received: from esebh107.NOE.Nokia.com (esebh107.ntc.nokia.com [172.21.143.143])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mBILabQD014382
	for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 15:36:52 -0600
Received: from [127.0.1.1] (essapo-nirac25252.europe.nokia.com [10.162.252.52])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mBILZKY6028747
	for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 23:35:20 +0200
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH v6 2/3] mac80211: track master queue status
To: linux-wireless@vger.kernel.org
Date: Thu, 18 Dec 2008 23:35:20 +0200
Message-ID: <20081218213520.7248.6457.stgit@tikku> (sfid-20081218_223717_300489_BF6F3953)
In-Reply-To: <20081218213306.7248.64398.stgit@tikku>
References: <20081218213306.7248.64398.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a preparation for the dynamic power save support. In future there are
two paths to stop the master queues and we need to track this properly to
avoid starting queues incorrectly. Implement this by adding a status
array for each queue.

The original idea and design is from Johannes Berg, I just did
the implementation based on his notes. All the bugs are mine, of course.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/ieee80211_i.h |   12 ++++++
 net/mac80211/main.c        |    2 +
 net/mac80211/util.c        |   86 +++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 18b9160..a74d673 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -538,6 +538,10 @@ enum {
 	IEEE80211_ADDBA_MSG	= 4,
 };
 
+enum queue_stop_reason {
+	IEEE80211_QUEUE_STOP_REASON_DRIVER,
+};
+
 /* maximum number of hardware queues we support. */
 #define QD_MAX_QUEUES (IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_QUEUES)
 
@@ -554,7 +558,8 @@ struct ieee80211_local {
 	const struct ieee80211_ops *ops;
 
 	unsigned long queue_pool[BITS_TO_LONGS(QD_MAX_QUEUES)];
-
+	unsigned long queue_stop_reasons[IEEE80211_MAX_QUEUES];
+	spinlock_t queue_stop_reason_lock;
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
 	int open_count;
 	int monitors, cooked_mntrs;
@@ -972,6 +977,11 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
 u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
 			      enum ieee80211_band band);
 
+void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
+				     enum queue_stop_reason reason);
+void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
+				     enum queue_stop_reason reason);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a0371ca..7c6e90a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -724,6 +724,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	spin_lock_init(&local->key_lock);
 
+	spin_lock_init(&local->queue_stop_reason_lock);
+
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 
 	sta_info_init(local);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 71a8391..fb89e1d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -330,10 +330,20 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_ctstoself_duration);
 
-void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
+static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
+				   enum queue_stop_reason reason)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
+	/* we don't need to track ampdu queues */
+	if (queue < ieee80211_num_regular_queues(hw)) {
+		__clear_bit(reason, &local->queue_stop_reasons[queue]);
+
+		if (local->queue_stop_reasons[queue] != 0)
+			/* someone still has this queue stopped */
+			return;
+	}
+
 	if (test_bit(queue, local->queues_pending)) {
 		set_bit(queue, local->queues_pending_run);
 		tasklet_schedule(&local->tx_pending_tasklet);
@@ -341,22 +351,74 @@ void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
 		netif_wake_subqueue(local->mdev, queue);
 	}
 }
+
+void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
+				    enum queue_stop_reason reason)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	unsigned long flags;
+
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+	__ieee80211_wake_queue(hw, queue, reason);
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+}
+
+void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
+{
+	ieee80211_wake_queue_by_reason(hw, queue,
+				       IEEE80211_QUEUE_STOP_REASON_DRIVER);
+}
 EXPORT_SYMBOL(ieee80211_wake_queue);
 
-void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
+static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
+				   enum queue_stop_reason reason)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
+	/* we don't need to track ampdu queues */
+	if (queue < ieee80211_num_regular_queues(hw))
+		__set_bit(reason, &local->queue_stop_reasons[queue]);
+
 	netif_stop_subqueue(local->mdev, queue);
 }
+
+void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
+				    enum queue_stop_reason reason)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	unsigned long flags;
+
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+	__ieee80211_stop_queue(hw, queue, reason);
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+}
+
+void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
+{
+	ieee80211_stop_queue_by_reason(hw, queue,
+				       IEEE80211_QUEUE_STOP_REASON_DRIVER);
+}
 EXPORT_SYMBOL(ieee80211_stop_queue);
 
-void ieee80211_stop_queues(struct ieee80211_hw *hw)
+void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
+				    enum queue_stop_reason reason)
 {
+	struct ieee80211_local *local = hw_to_local(hw);
+	unsigned long flags;
 	int i;
 
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+
 	for (i = 0; i < ieee80211_num_queues(hw); i++)
-		ieee80211_stop_queue(hw, i);
+		__ieee80211_stop_queue(hw, i, reason);
+
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+}
+
+void ieee80211_stop_queues(struct ieee80211_hw *hw)
+{
+	ieee80211_stop_queues_by_reason(hw,
+					IEEE80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
 
@@ -367,12 +429,24 @@ int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
 }
 EXPORT_SYMBOL(ieee80211_queue_stopped);
 
-void ieee80211_wake_queues(struct ieee80211_hw *hw)
+void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
+				     enum queue_stop_reason reason)
 {
+	struct ieee80211_local *local = hw_to_local(hw);
+	unsigned long flags;
 	int i;
 
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+
 	for (i = 0; i < hw->queues + hw->ampdu_queues; i++)
-		ieee80211_wake_queue(hw, i);
+		__ieee80211_wake_queue(hw, i, reason);
+
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+}
+
+void ieee80211_wake_queues(struct ieee80211_hw *hw)
+{
+	ieee80211_wake_queues_by_reason(hw, IEEE80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 

