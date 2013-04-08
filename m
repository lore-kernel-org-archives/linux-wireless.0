Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:55628 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934675Ab3DHSH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:07:56 -0400
Received: by mail-da0-f45.google.com with SMTP id v40so2711272dad.18
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 11:07:55 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 3/6] mac80211: ieee80211_queue_stopped returns reasons
Date: Mon,  8 Apr 2013 11:06:14 -0700
Message-Id: <1365444377-9959-3-git-send-email-thomas@cozybit.com> (sfid-20130408_200800_818110_40CED9B8)
In-Reply-To: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have ieee80211_queue_stopped() return a bitmap of enum
queue_stop_reasons while checking queue status. This is
handy when we care about the queue stop reason codes.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/net/mac80211.h |   10 +++++++---
 net/mac80211/util.c    |    8 ++++----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 64faf01..8bbe799 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3589,15 +3589,19 @@ void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue);
 
 /**
  * ieee80211_queue_stopped - test status of the queue
+ *
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  * @queue: queue number (counted from zero).
  *
  * Drivers should use this function instead of netif_stop_queue.
  *
- * Return: %true if the queue is stopped. %false otherwise.
+ * Return 0 if queue not stopped, or else a bitmap of
+ * queue_stop_reasons.
+ *
+ * If @queue doesn't exist, return -1UL.
+ *
  */
-
-int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue);
+unsigned long ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue);
 
 /**
  * ieee80211_stop_queues - stop all queues
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 447e665..739cddb 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -475,17 +475,17 @@ void ieee80211_stop_queues(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
 
-int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
+unsigned long ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	unsigned long flags;
-	int ret;
+	unsigned long ret;
 
 	if (WARN_ON(queue >= hw->queues))
-		return true;
+		return -1UL;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	ret = !!local->queue_stop_reasons[queue];
+	ret = local->queue_stop_reasons[queue];
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 	return ret;
 }
-- 
1.7.10.4

