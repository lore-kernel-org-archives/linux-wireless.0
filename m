Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:2462 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559Ab0EITY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 15:24:28 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 6/9 v2] rt2x00: Clean up generic procedures on descriptor writing.
Date: Sun,  9 May 2010 21:24:22 +0200
Message-Id: <1273433062-12982-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With a little bit of restructuring it isn't necessary to have special
cases in rt2x00queue_write_tx_descriptor for writing the descriptor
for beacons.
Simply split off the kicking of the TX queue to a separate function
with is only called for non-beacons.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---

v2: Fix up editorial in comment as reported by Adam Baker.

---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 59d9459..8768c6f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -428,20 +428,23 @@ static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 	 * it is now ready to be dumped to userspace through debugfs.
 	 */
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TX, entry->skb);
+}
+
+static void rt2x00queue_kick_tx_queue(struct queue_entry *entry,
+				      struct txentry_desc *txdesc)
+{
+	struct data_queue *queue = entry->queue;
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 
 	/*
 	 * Check if we need to kick the queue, there are however a few rules
-	 *	1) Don't kick beacon queue
-	 *	2) Don't kick unless this is the last in frame in a burst.
+	 *	1) Don't kick unless this is the last in frame in a burst.
 	 *	   When the burst flag is set, this frame is always followed
 	 *	   by another frame which in some way are related to eachother.
 	 *	   This is true for fragments, RTS or CTS-to-self frames.
-	 *	3) Rule 2 can be broken when the available entries
+	 *	2) Rule 1 can be broken when the available entries
 	 *	   in the queue are less then a certain threshold.
 	 */
-	if (entry->queue->qid == QID_BEACON)
-		return;
-
 	if (rt2x00queue_threshold(queue) ||
 	    !test_bit(ENTRY_TXD_BURST, &txdesc->flags))
 		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, queue->qid);
@@ -537,6 +540,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 
 	rt2x00queue_index_inc(queue, Q_INDEX);
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
+	rt2x00queue_kick_tx_queue(entry, &txdesc);
 
 	return 0;
 }
-- 
1.7.1

