Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:31683 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab3G1LOS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Jul 2013 07:14:18 -0400
Received: from ip-78-102-117-165.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[78.102.117.165])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 28 Jul 2013 13:14:15 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 3.11] rt2x00: fix stop queue
Date: Sun, 28 Jul 2013 13:17:22 +0200
Message-Id: <1375010242-15555-1-git-send-email-stf_xl@wp.pl> (sfid-20130728_131421_407598_C392A561)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Since we clear QUEUE_STARTED in rt2x00queue_stop_queue(), following
call to rt2x00queue_pause_queue() reduce to noop, i.e we do not
stop queue in mac80211.

To fix that introduce rt2x00queue_pause_queue_nocheck() function,
which will stop queue in mac80211 directly.

Note that rt2x00_start_queue() explicitly set QUEUE_PAUSED bit.

Note also that reordering operations i.e. first call to
rt2x00queue_pause_queue() and then clear QUEUE_STARTED bit, will race
with rt2x00queue_unpause_queue(), so calling ieee80211_stop_queue()
directly is the only available solution to fix the problem without
major rework.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index e571298..8c1de0f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -936,13 +936,8 @@ void rt2x00queue_index_inc(struct queue_entry *entry, enum queue_index index)
 	spin_unlock_irqrestore(&queue->index_lock, irqflags);
 }
 
-void rt2x00queue_pause_queue(struct data_queue *queue)
+void rt2x00queue_pause_queue_nocheck(struct data_queue *queue)
 {
-	if (!test_bit(DEVICE_STATE_PRESENT, &queue->rt2x00dev->flags) ||
-	    !test_bit(QUEUE_STARTED, &queue->flags) ||
-	    test_and_set_bit(QUEUE_PAUSED, &queue->flags))
-		return;
-
 	switch (queue->qid) {
 	case QID_AC_VO:
 	case QID_AC_VI:
@@ -958,6 +953,15 @@ void rt2x00queue_pause_queue(struct data_queue *queue)
 		break;
 	}
 }
+void rt2x00queue_pause_queue(struct data_queue *queue)
+{
+	if (!test_bit(DEVICE_STATE_PRESENT, &queue->rt2x00dev->flags) ||
+	    !test_bit(QUEUE_STARTED, &queue->flags) ||
+	    test_and_set_bit(QUEUE_PAUSED, &queue->flags))
+		return;
+
+	rt2x00queue_pause_queue_nocheck(queue);
+}
 EXPORT_SYMBOL_GPL(rt2x00queue_pause_queue);
 
 void rt2x00queue_unpause_queue(struct data_queue *queue)
@@ -1019,7 +1023,7 @@ void rt2x00queue_stop_queue(struct data_queue *queue)
 		return;
 	}
 
-	rt2x00queue_pause_queue(queue);
+	rt2x00queue_pause_queue_nocheck(queue);
 
 	queue->rt2x00dev->ops->lib->stop_queue(queue);
 
-- 
1.7.4.4

