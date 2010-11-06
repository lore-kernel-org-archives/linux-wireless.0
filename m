Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33441 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab0KFOt7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:49:59 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so2216256eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:49:58 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/18] rt2x00: Fix rt2x00queue_kick_tx_queue arguments
Date: Sat, 6 Nov 2010 15:48:23 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com> <201011061547.46948.IvDoorn@gmail.com> <201011061548.06660.IvDoorn@gmail.com>
In-Reply-To: <201011061548.06660.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061548.24450.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

The queue_entry argument to rt2x00queue_kick_tx_queue,
doesn't make sense due to the function name (it is called
kick QUEUE)... But neither do we need the queue_entry, since
we need the data_queue.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index aa4c8f2..dc54317 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -452,12 +452,9 @@ static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 	rt2x00debug_dump_frame(queue->rt2x00dev, DUMP_FRAME_TX, entry->skb);
 }
 
-static void rt2x00queue_kick_tx_queue(struct queue_entry *entry,
+static void rt2x00queue_kick_tx_queue(struct data_queue *queue,
 				      struct txentry_desc *txdesc)
 {
-	struct data_queue *queue = entry->queue;
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-
 	/*
 	 * Check if we need to kick the queue, there are however a few rules
 	 *	1) Don't kick unless this is the last in frame in a burst.
@@ -469,7 +466,7 @@ static void rt2x00queue_kick_tx_queue(struct queue_entry *entry,
 	 */
 	if (rt2x00queue_threshold(queue) ||
 	    !test_bit(ENTRY_TXD_BURST, &txdesc->flags))
-		rt2x00dev->ops->lib->kick_tx_queue(queue);
+		queue->rt2x00dev->ops->lib->kick_tx_queue(queue);
 }
 
 int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
@@ -559,7 +556,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 
 	rt2x00queue_index_inc(queue, Q_INDEX);
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
-	rt2x00queue_kick_tx_queue(entry, &txdesc);
+	rt2x00queue_kick_tx_queue(queue, &txdesc);
 
 	return 0;
 }
-- 
1.7.2.3

