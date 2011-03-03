Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45862 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab1CCStW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:49:22 -0500
Received: by mail-ww0-f44.google.com with SMTP id 22so1738699wwb.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:49:22 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 19/19] rt2x00: Remove unused rt2x00queue_get_queue function.
Date: Thu, 3 Mar 2011 19:47:21 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031946.30487.IvDoorn@gmail.com> <201103031946.56905.IvDoorn@gmail.com>
In-Reply-To: <201103031946.56905.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031947.21936.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Now that all accesses to the data_queue structures is done via the specialized
rt2x00queue_get_tx_queue function or via direct accesses, there is no
need for the rt2x00queue_get_queue function anymore, so remove it.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    8 --------
 drivers/net/wireless/rt2x00/rt2x00queue.c |   19 -------------------
 2 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 72f8ebf..5217caf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1083,14 +1083,6 @@ rt2x00queue_get_tx_queue(struct rt2x00_dev *rt2x00dev,
 }
 
 /**
- * rt2x00queue_get_queue - Convert queue index to queue pointer
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @queue: rt2x00 queue index (see &enum data_queue_qid).
- */
-struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
-					 const enum data_queue_qid queue);
-
-/**
  * rt2x00queue_get_entry - Get queue entry where the given index points to.
  * @queue: Pointer to &struct data_queue from where we obtain the entry.
  * @index: Index identifier for obtaining the correct index.
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index fcaacc6..4b3c70e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -705,25 +705,6 @@ void rt2x00queue_for_each_entry(struct data_queue *queue,
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_for_each_entry);
 
-struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
-					 const enum data_queue_qid queue)
-{
-	if (queue == QID_RX)
-		return rt2x00dev->rx;
-
-	if (queue < rt2x00dev->ops->tx_queues && rt2x00dev->tx)
-		return &rt2x00dev->tx[queue];
-
-	if (queue == QID_BEACON)
-		return rt2x00dev->bcn;
-
-	if (queue == QID_ATIM)
-		return rt2x00dev->atim;
-
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(rt2x00queue_get_queue);
-
 struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 					  enum queue_index index)
 {
-- 
1.7.2.3

