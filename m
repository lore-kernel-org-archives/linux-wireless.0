Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54052 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab1GFVAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 17:00:43 -0400
Received: by ewy4 with SMTP id 4so108843ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 14:00:42 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/6] rt2x00: Serialize TX operations on a queue.
Date: Wed, 6 Jul 2011 22:56:24 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201107062256.25555.IvDoorn@gmail.com> (sfid-20110706_230047_079953_1FAC0B89)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

The rt2x00 driver gets frequent occurrences of the following error message
when operating under load:
phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the
non-full queue 2.

This is caused by simultaneous attempts from mac80211 to send a frame via
rt2x00, which are not properly serialized inside rt2x00queue_write_tx_frame,
causing the second frame to fail sending with the above mentioned error
message.

Fix this by introducing a per-queue spinlock to serialize the TX operations
on that queue.

Reported-by: Andreas Hartmann <andihartmann@01019freenet.de>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   21 ++++++++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 ++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index c7fc9de..551cee1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -555,15 +555,21 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 			       bool local)
 {
 	struct ieee80211_tx_info *tx_info;
-	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
+	struct queue_entry *entry;
 	struct txentry_desc txdesc;
 	struct skb_frame_desc *skbdesc;
 	u8 rate_idx, rate_flags;
+	int ret = 0;
+
+	spin_lock(&queue->tx_lock);
+
+	entry = rt2x00queue_get_entry(queue, Q_INDEX);
 
 	if (unlikely(rt2x00queue_full(queue))) {
 		ERROR(queue->rt2x00dev,
 		      "Dropping frame due to full tx queue %d.\n", queue->qid);
-		return -ENOBUFS;
+		ret = -ENOBUFS;
+		goto out;
 	}
 
 	if (unlikely(test_and_set_bit(ENTRY_OWNER_DEVICE_DATA,
@@ -572,7 +578,8 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 		      "Arrived at non-free entry in the non-full queue %d.\n"
 		      "Please file bug report to %s.\n",
 		      queue->qid, DRV_PROJECT);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/*
@@ -634,7 +641,8 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	if (unlikely(rt2x00queue_write_tx_data(entry, &txdesc))) {
 		clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 		entry->skb = NULL;
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	set_bit(ENTRY_DATA_PENDING, &entry->flags);
@@ -643,7 +651,9 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
 	rt2x00queue_kick_tx_queue(queue, &txdesc);
 
-	return 0;
+out:
+	spin_unlock(&queue->tx_lock);
+	return ret;
 }
 
 int rt2x00queue_clear_beacon(struct rt2x00_dev *rt2x00dev,
@@ -1184,6 +1194,7 @@ static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
 			     struct data_queue *queue, enum data_queue_qid qid)
 {
 	mutex_init(&queue->status_lock);
+	spin_lock_init(&queue->tx_lock);
 	spin_lock_init(&queue->index_lock);
 
 	queue->rt2x00dev = rt2x00dev;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 5900474..f2100f4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -432,6 +432,7 @@ enum data_queue_flags {
  * @flags: Entry flags, see &enum queue_entry_flags.
  * @status_lock: The mutex for protecting the start/stop/flush
  *	handling on this queue.
+ * @tx_lock: Spinlock to serialize tx operations on this queue.
  * @index_lock: Spinlock to protect index handling. Whenever @index, @index_done or
  *	@index_crypt needs to be changed this lock should be grabbed to prevent
  *	index corruption due to concurrency.
@@ -458,6 +459,7 @@ struct data_queue {
 	unsigned long flags;
 
 	struct mutex status_lock;
+	spinlock_t tx_lock;
 	spinlock_t index_lock;
 
 	unsigned int count;
-- 
1.7.2.3

