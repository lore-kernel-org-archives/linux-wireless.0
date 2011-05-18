Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33255 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455Ab1ERS0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 14:26:49 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so526998ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 11:26:49 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/7] rt2x00: Queue index locks don't have to disable IRQs.
Date: Wed, 18 May 2011 20:25:56 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201105182022.20341.IvDoorn@gmail.com> <201105182023.25912.IvDoorn@gmail.com> <201105182023.47984.IvDoorn@gmail.com>
In-Reply-To: <201105182023.47984.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <201105182025.56724.IvDoorn@gmail.com> (sfid-20110518_202653_764899_DDC04BA4)
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

The queue index locks are no longer used in interrupt context due to the
introduction of tasklets and workqueues. Therefore we can use a lighter
variant of the spinlocks.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |    5 ++---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   20 ++++++++------------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 78787fc..8e417de 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -327,7 +327,6 @@ static ssize_t rt2x00debug_read_queue_stats(struct file *file,
 {
 	struct rt2x00debug_intf *intf = file->private_data;
 	struct data_queue *queue;
-	unsigned long irqflags;
 	unsigned int lines = 1 + intf->rt2x00dev->data_queues;
 	size_t size;
 	char *data;
@@ -344,7 +343,7 @@ static ssize_t rt2x00debug_read_queue_stats(struct file *file,
 	    sprintf(data, "qid\tflags\t\tcount\tlimit\tlength\tindex\tdma done\tdone\n");
 
 	queue_for_each(intf->rt2x00dev, queue) {
-		spin_lock_irqsave(&queue->index_lock, irqflags);
+		spin_lock_bh(&queue->index_lock);
 
 		temp += sprintf(temp, "%d\t0x%.8x\t%d\t%d\t%d\t%d\t%d\t\t%d\n",
 				queue->qid, (unsigned int)queue->flags,
@@ -353,7 +352,7 @@ static ssize_t rt2x00debug_read_queue_stats(struct file *file,
 				queue->index[Q_INDEX_DMA_DONE],
 				queue->index[Q_INDEX_DONE]);
 
-		spin_unlock_irqrestore(&queue->index_lock, irqflags);
+		spin_unlock_bh(&queue->index_lock);
 	}
 
 	size = strlen(data);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index f1e1381..e2e1bf6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -735,7 +735,6 @@ bool rt2x00queue_for_each_entry(struct data_queue *queue,
 				bool (*fn)(struct queue_entry *entry,
 					   void *data))
 {
-	unsigned long irqflags;
 	unsigned int index_start;
 	unsigned int index_end;
 	unsigned int i;
@@ -753,10 +752,10 @@ bool rt2x00queue_for_each_entry(struct data_queue *queue,
 	 * it should not be kicked during this run, since it
 	 * is part of another TX operation.
 	 */
-	spin_lock_irqsave(&queue->index_lock, irqflags);
+	spin_lock_bh(&queue->index_lock);
 	index_start = queue->index[start];
 	index_end = queue->index[end];
-	spin_unlock_irqrestore(&queue->index_lock, irqflags);
+	spin_unlock_bh(&queue->index_lock);
 
 	/*
 	 * Start from the TX done pointer, this guarentees that we will
@@ -787,7 +786,6 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 					  enum queue_index index)
 {
 	struct queue_entry *entry;
-	unsigned long irqflags;
 
 	if (unlikely(index >= Q_INDEX_MAX)) {
 		ERROR(queue->rt2x00dev,
@@ -795,11 +793,11 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 		return NULL;
 	}
 
-	spin_lock_irqsave(&queue->index_lock, irqflags);
+	spin_lock_bh(&queue->index_lock);
 
 	entry = &queue->entries[queue->index[index]];
 
-	spin_unlock_irqrestore(&queue->index_lock, irqflags);
+	spin_unlock_bh(&queue->index_lock);
 
 	return entry;
 }
@@ -808,7 +806,6 @@ EXPORT_SYMBOL_GPL(rt2x00queue_get_entry);
 void rt2x00queue_index_inc(struct queue_entry *entry, enum queue_index index)
 {
 	struct data_queue *queue = entry->queue;
-	unsigned long irqflags;
 
 	if (unlikely(index >= Q_INDEX_MAX)) {
 		ERROR(queue->rt2x00dev,
@@ -816,7 +813,7 @@ void rt2x00queue_index_inc(struct queue_entry *entry, enum queue_index index)
 		return;
 	}
 
-	spin_lock_irqsave(&queue->index_lock, irqflags);
+	spin_lock_bh(&queue->index_lock);
 
 	queue->index[index]++;
 	if (queue->index[index] >= queue->limit)
@@ -831,7 +828,7 @@ void rt2x00queue_index_inc(struct queue_entry *entry, enum queue_index index)
 		queue->count++;
 	}
 
-	spin_unlock_irqrestore(&queue->index_lock, irqflags);
+	spin_unlock_bh(&queue->index_lock);
 }
 
 void rt2x00queue_pause_queue(struct data_queue *queue)
@@ -1031,10 +1028,9 @@ EXPORT_SYMBOL_GPL(rt2x00queue_flush_queues);
 
 static void rt2x00queue_reset(struct data_queue *queue)
 {
-	unsigned long irqflags;
 	unsigned int i;
 
-	spin_lock_irqsave(&queue->index_lock, irqflags);
+	spin_lock_bh(&queue->index_lock);
 
 	queue->count = 0;
 	queue->length = 0;
@@ -1042,7 +1038,7 @@ static void rt2x00queue_reset(struct data_queue *queue)
 	for (i = 0; i < Q_INDEX_MAX; i++)
 		queue->index[i] = 0;
 
-	spin_unlock_irqrestore(&queue->index_lock, irqflags);
+	spin_unlock_bh(&queue->index_lock);
 }
 
 void rt2x00queue_init_queues(struct rt2x00_dev *rt2x00dev)
-- 
1.7.2.3

