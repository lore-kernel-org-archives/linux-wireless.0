Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44208 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0KFOt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:49:57 -0400
Received: by mail-ew0-f46.google.com with SMTP id 7so2253925ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:49:57 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/18] rt2x00: Rename queue->lock to queue->index_lock
Date: Sat, 6 Nov 2010 15:48:05 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com> <201011061547.26776.IvDoorn@gmail.com> <201011061547.46948.IvDoorn@gmail.com>
In-Reply-To: <201011061547.46948.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061548.06660.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

The queue->lock is only used to protect the index
numbers. Rename the lock accordingly.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00queue.c |   18 +++++++++---------
 drivers/net/wireless/rt2x00/rt2x00queue.h |    4 ++--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 8296a9d..64dfb1f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -342,7 +342,7 @@ static ssize_t rt2x00debug_read_queue_stats(struct file *file,
 	    sprintf(data, "qid\tcount\tlimit\tlength\tindex\tdma done\tdone\n");
 
 	queue_for_each(intf->rt2x00dev, queue) {
-		spin_lock_irqsave(&queue->lock, irqflags);
+		spin_lock_irqsave(&queue->index_lock, irqflags);
 
 		temp += sprintf(temp, "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", queue->qid,
 				queue->count, queue->limit, queue->length,
@@ -350,7 +350,7 @@ static ssize_t rt2x00debug_read_queue_stats(struct file *file,
 				queue->index[Q_INDEX_DMA_DONE],
 				queue->index[Q_INDEX_DONE]);
 
-		spin_unlock_irqrestore(&queue->lock, irqflags);
+		spin_unlock_irqrestore(&queue->index_lock, irqflags);
 	}
 
 	size = strlen(data);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 32d6a17..aa4c8f2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -641,10 +641,10 @@ void rt2x00queue_for_each_entry(struct data_queue *queue,
 	 * it should not be kicked during this run, since it
 	 * is part of another TX operation.
 	 */
-	spin_lock_irqsave(&queue->lock, irqflags);
+	spin_lock_irqsave(&queue->index_lock, irqflags);
 	index_start = queue->index[start];
 	index_end = queue->index[end];
-	spin_unlock_irqrestore(&queue->lock, irqflags);
+	spin_unlock_irqrestore(&queue->index_lock, irqflags);
 
 	/*
 	 * Start from the TX done pointer, this guarentees that we will
@@ -698,11 +698,11 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 		return NULL;
 	}
 
-	spin_lock_irqsave(&queue->lock, irqflags);
+	spin_lock_irqsave(&queue->index_lock, irqflags);
 
 	entry = &queue->entries[queue->index[index]];
 
-	spin_unlock_irqrestore(&queue->lock, irqflags);
+	spin_unlock_irqrestore(&queue->index_lock, irqflags);
 
 	return entry;
 }
@@ -718,7 +718,7 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 		return;
 	}
 
-	spin_lock_irqsave(&queue->lock, irqflags);
+	spin_lock_irqsave(&queue->index_lock, irqflags);
 
 	queue->index[index]++;
 	if (queue->index[index] >= queue->limit)
@@ -733,7 +733,7 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 		queue->count++;
 	}
 
-	spin_unlock_irqrestore(&queue->lock, irqflags);
+	spin_unlock_irqrestore(&queue->index_lock, irqflags);
 }
 
 static void rt2x00queue_reset(struct data_queue *queue)
@@ -741,7 +741,7 @@ static void rt2x00queue_reset(struct data_queue *queue)
 	unsigned long irqflags;
 	unsigned int i;
 
-	spin_lock_irqsave(&queue->lock, irqflags);
+	spin_lock_irqsave(&queue->index_lock, irqflags);
 
 	queue->count = 0;
 	queue->length = 0;
@@ -751,7 +751,7 @@ static void rt2x00queue_reset(struct data_queue *queue)
 		queue->last_action[i] = jiffies;
 	}
 
-	spin_unlock_irqrestore(&queue->lock, irqflags);
+	spin_unlock_irqrestore(&queue->index_lock, irqflags);
 }
 
 void rt2x00queue_stop_queues(struct rt2x00_dev *rt2x00dev)
@@ -903,7 +903,7 @@ void rt2x00queue_uninitialize(struct rt2x00_dev *rt2x00dev)
 static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
 			     struct data_queue *queue, enum data_queue_qid qid)
 {
-	spin_lock_init(&queue->lock);
+	spin_lock_init(&queue->index_lock);
 
 	queue->rt2x00dev = rt2x00dev;
 	queue->qid = qid;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 64c00e2..29b051a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -398,7 +398,7 @@ enum queue_index {
  * @entries: Base address of the &struct queue_entry which are
  *	part of this queue.
  * @qid: The queue identification, see &enum data_queue_qid.
- * @lock: Spinlock to protect index handling. Whenever @index, @index_done or
+ * @index_lock: Spinlock to protect index handling. Whenever @index, @index_done or
  *	@index_crypt needs to be changed this lock should be grabbed to prevent
  *	index corruption due to concurrency.
  * @count: Number of frames handled in the queue.
@@ -422,7 +422,7 @@ struct data_queue {
 
 	enum data_queue_qid qid;
 
-	spinlock_t lock;
+	spinlock_t index_lock;
 	unsigned int count;
 	unsigned short limit;
 	unsigned short threshold;
-- 
1.7.2.3

