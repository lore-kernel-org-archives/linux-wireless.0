Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43974 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab1GFVAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 17:00:54 -0400
Received: by eyx24 with SMTP id 24so105827eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 14:00:52 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/6] rt2x00: Reduce window of a queue's tx lock.
Date: Wed, 6 Jul 2011 22:57:37 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201107062256.25555.IvDoorn@gmail.com> <201107062257.01333.IvDoorn@gmail.com>
In-Reply-To: <201107062257.01333.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107062257.38435.IvDoorn@gmail.com> (sfid-20110706_230057_124146_7E1C5CC8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Currently a lot of actions that can be done without the queue's tx lock
being held are done inside the locked area.
Move them out to have a leaner and meaner code that operates while the
tx lock is being held.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   51 +++++++++++++++--------------
 1 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index a70e700..29edb9f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -565,33 +565,11 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	u8 rate_idx, rate_flags;
 	int ret = 0;
 
-	spin_lock(&queue->tx_lock);
-
-	entry = rt2x00queue_get_entry(queue, Q_INDEX);
-
-	if (unlikely(rt2x00queue_full(queue))) {
-		ERROR(queue->rt2x00dev,
-		      "Dropping frame due to full tx queue %d.\n", queue->qid);
-		ret = -ENOBUFS;
-		goto out;
-	}
-
-	if (unlikely(test_and_set_bit(ENTRY_OWNER_DEVICE_DATA,
-				      &entry->flags))) {
-		ERROR(queue->rt2x00dev,
-		      "Arrived at non-free entry in the non-full queue %d.\n"
-		      "Please file bug report to %s.\n",
-		      queue->qid, DRV_PROJECT);
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/*
 	 * Copy all TX descriptor information into txdesc,
 	 * after that we are free to use the skb->cb array
 	 * for our information.
 	 */
-	entry->skb = skb;
 	rt2x00queue_create_tx_descriptor(queue->rt2x00dev, skb, &txdesc);
 
 	/*
@@ -604,7 +582,6 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	rate_flags = tx_info->control.rates[0].flags;
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->entry = entry;
 	skbdesc->tx_rate_idx = rate_idx;
 	skbdesc->tx_rate_flags = rate_flags;
 
@@ -633,9 +610,33 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	 * for PCI devices.
 	 */
 	if (test_bit(REQUIRE_L2PAD, &queue->rt2x00dev->cap_flags))
-		rt2x00queue_insert_l2pad(entry->skb, txdesc.header_length);
+		rt2x00queue_insert_l2pad(skb, txdesc.header_length);
 	else if (test_bit(REQUIRE_DMA, &queue->rt2x00dev->cap_flags))
-		rt2x00queue_align_frame(entry->skb);
+		rt2x00queue_align_frame(skb);
+
+	spin_lock(&queue->tx_lock);
+
+	if (unlikely(rt2x00queue_full(queue))) {
+		ERROR(queue->rt2x00dev,
+		      "Dropping frame due to full tx queue %d.\n", queue->qid);
+		ret = -ENOBUFS;
+		goto out;
+	}
+
+	entry = rt2x00queue_get_entry(queue, Q_INDEX);
+
+	if (unlikely(test_and_set_bit(ENTRY_OWNER_DEVICE_DATA,
+				      &entry->flags))) {
+		ERROR(queue->rt2x00dev,
+		      "Arrived at non-free entry in the non-full queue %d.\n"
+		      "Please file bug report to %s.\n",
+		      queue->qid, DRV_PROJECT);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	skbdesc->entry = entry;
+	entry->skb = skb;
 
 	/*
 	 * It could be possible that the queue was corrupted and this
-- 
1.7.2.3

