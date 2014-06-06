Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:55444 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752100AbaFFSqY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 14:46:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, michal.kazior@tieto.com
Cc: linux-wireless@vger.kernel.org
Date: Fri,  6 Jun 2014 21:46:05 +0300
Message-Id: <1402080365-15462-1-git-send-email-luca@coelho.fi> (sfid-20140606_204630_343651_DEAA55BF)
In-Reply-To: <1402068423-23359-1-git-send-email-luca@coelho.fi>
References: <1402068423-23359-1-git-send-email-luca@coelho.fi>
Subject: [RFC option 2] mac80211: introduce refcount for queue_stop_reasons
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Sometimes different vifs may be stopping the queues for the same
reason (e.g. when several interfaces are performing a channel switch).
Instead of using a bitmask for the reasons, use an integer that holds
a refcount instead.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---

This looks much simpler now.  The only thing is that we need to make
sure the bitmask never gets out of sync with the refcounts, which
shouldn't be too difficult, as long as we keep the refcounts usage
restricted to the queues start/stopping functions.

 net/mac80211/debugfs.c     | 13 ++++++++-----
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/util.c        |  7 ++++---
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 0e963bc1..3ca4d78 100644
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
+		for (r = 0; r < IEEE80211_QUEUE_STOP_REASONS; r++)
+			res += sprintf(buf + res,
+				       "%02d: reason[%02d] = %d/%d\n", q, r,
+				       local->q_stop_reasons[q][r],
+				       skb_queue_len(&local->pending[q]));
+	}
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 677e9c8..fd17a5b 100644
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
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 04e5f5c..4db4f35 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -326,10 +326,11 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 	if (WARN_ON(queue >= hw->queues))
 		return;
 
-	if (!test_bit(reason, &local->queue_stop_reasons[queue]))
+	if (local->q_stop_reasons[queue][reason] == 0)
 		return;
 
-	__clear_bit(reason, &local->queue_stop_reasons[queue]);
+	if (--local->q_stop_reasons[queue][reason] == 0)
+		__clear_bit(reason, &local->queue_stop_reasons[queue]);
 
 	if (local->queue_stop_reasons[queue] != 0)
 		/* someone still has this queue stopped */
@@ -373,7 +374,7 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 	if (WARN_ON(queue >= hw->queues))
 		return;
 
-	if (test_bit(reason, &local->queue_stop_reasons[queue]))
+	if (local->q_stop_reasons[queue][reason]++)
 		return;
 
 	__set_bit(reason, &local->queue_stop_reasons[queue]);
-- 
2.0.0.rc2

