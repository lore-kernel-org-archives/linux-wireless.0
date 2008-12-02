Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:31652 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYLBUEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:04:34 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx06.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mB2K4LMv018832
	for <linux-wireless@vger.kernel.org>; Tue, 2 Dec 2008 22:04:31 +0200
Received: from [127.0.1.1] (essapo-nirac253161.europe.nokia.com [10.162.253.161])
	by mgw-int02.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mB2K4Rc7016402
	for <linux-wireless@vger.kernel.org>; Tue, 2 Dec 2008 22:04:27 +0200
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [RFC PATCH v4 5/5] mac80211: track master queue status
To: linux-wireless@vger.kernel.org
Date: Tue, 02 Dec 2008 22:04:26 +0200
Message-ID: <20081202200426.5507.44042.stgit@tikku> (sfid-20081202_210437_005505_E84F6109)
In-Reply-To: <20081202200219.5507.83250.stgit@tikku>
References: <20081202200219.5507.83250.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are now two paths to stop the master queues and we need to track this
properly to avoid starting queue in the wrong time. Implement this by adding
an array for each queue.

The original idea and design is from Johannes Berg, I just did
the implementation based on his notes. All the bugs are mine, of course.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/ieee80211_i.h |   13 +++++++++-
 net/mac80211/main.c        |    2 +
 net/mac80211/mlme.c        |    2 +
 net/mac80211/tx.c          |    3 +-
 net/mac80211/util.c        |   60 ++++++++++++++++++++++++++++++++++++++++----
 5 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f03261b..c2900ee 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -539,6 +539,11 @@ enum {
 	IEEE80211_ADDBA_MSG	= 4,
 };
 
+enum queue_stop_reason {
+	IEEE80211_QUEUE_STOP_REASON_PS,
+	IEEE80211_QUEUE_STOP_REASON_DRIVER,
+};
+
 /* maximum number of hardware queues we support. */
 #define QD_MAX_QUEUES (IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_QUEUES)
 
@@ -555,7 +560,8 @@ struct ieee80211_local {
 	const struct ieee80211_ops *ops;
 
 	unsigned long queue_pool[BITS_TO_LONGS(QD_MAX_QUEUES)];
-
+	unsigned long queue_stop_reasons[IEEE80211_MAX_QUEUES];
+	spinlock_t queue_stop_reason_lock;
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
 	int open_count;
 	int monitors, cooked_mntrs;
@@ -981,6 +987,11 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_timer(unsigned long data);
 
+void __ieee80211_stop_queues(struct ieee80211_hw *hw,
+			     enum queue_stop_reason reason);
+void __ieee80211_wake_queues(struct ieee80211_hw *hw,
+			     enum queue_stop_reason reason);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index bebdd48..db8882b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -699,6 +699,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	spin_lock_init(&local->key_lock);
 
+	spin_lock_init(&local->queue_stop_reason_lock);
+
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 
 	INIT_WORK(&local->dynamic_ps_enable_work,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index add3553..0e2db93 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2630,7 +2630,7 @@ void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 	}
 
 	/* always wake queues to avoid having them stopped forever */
-	netif_tx_wake_all_queues(local->mdev);
+	__ieee80211_wake_queues(&local->hw, IEEE80211_QUEUE_STOP_REASON_PS);
 }
 
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index de3283b..809c4f7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1479,7 +1479,8 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	if ((local->hw.flags & IEEE80211_HW_NO_DYNAMIC_PS) &&
 	    local->hw.conf.dynamic_ps_timeout > 0) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-			netif_tx_stop_all_queues(local->mdev);
+			__ieee80211_stop_queues(&local->hw,
+						IEEE80211_QUEUE_STOP_REASON_PS);
 			queue_work(local->hw.workqueue,
 				   &local->dynamic_ps_disable_work);
 		}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0f84131..1224dc0 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -330,9 +330,22 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_ctstoself_duration);
 
-void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
+static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
+				   enum queue_stop_reason reason)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	unsigned long flags;
+
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+
+	/* we don't need to track ampdu queues */
+	if (queue < ieee80211_num_regular_queues(hw)) {
+		__clear_bit(reason, &local->queue_stop_reasons[queue]);
+
+		if (local->queue_stop_reasons[queue] != 0)
+			/* someone still has this queue stopped */
+			goto out;
+	}
 
 	if (test_bit(queue, local->queues_pending)) {
 		set_bit(queue, local->queues_pending_run);
@@ -340,23 +353,52 @@ void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
 	} else {
 		netif_wake_subqueue(local->mdev, queue);
 	}
+
+out:
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+}
+
+void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
+{
+	__ieee80211_wake_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_wake_queue);
 
-void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
+static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
+				   enum queue_stop_reason reason)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	unsigned long flags;
+
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+
+	/* we don't need to track ampdu queues */
+	if (queue < ieee80211_num_regular_queues(hw))
+		__set_bit(reason, &local->queue_stop_reasons[queue]);
 
 	netif_stop_subqueue(local->mdev, queue);
+
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+}
+
+void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
+{
+	__ieee80211_stop_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_stop_queue);
 
-void ieee80211_stop_queues(struct ieee80211_hw *hw)
+void __ieee80211_stop_queues(struct ieee80211_hw *hw,
+			     enum queue_stop_reason reason)
 {
 	int i;
 
 	for (i = 0; i < ieee80211_num_queues(hw); i++)
-		ieee80211_stop_queue(hw, i);
+		__ieee80211_stop_queue(hw, i, reason);
+}
+
+void ieee80211_stop_queues(struct ieee80211_hw *hw)
+{
+	__ieee80211_stop_queues(hw, IEEE80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
 
@@ -367,12 +409,18 @@ int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
 }
 EXPORT_SYMBOL(ieee80211_queue_stopped);
 
-void ieee80211_wake_queues(struct ieee80211_hw *hw)
+void __ieee80211_wake_queues(struct ieee80211_hw *hw,
+			     enum queue_stop_reason reason)
 {
 	int i;
 
 	for (i = 0; i < hw->queues + hw->ampdu_queues; i++)
-		ieee80211_wake_queue(hw, i);
+		__ieee80211_wake_queue(hw, i, reason);
+}
+
+void ieee80211_wake_queues(struct ieee80211_hw *hw)
+{
+	__ieee80211_wake_queues(hw, IEEE80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 

