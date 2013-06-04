Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38409 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab3FDLlP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 07:41:15 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 13/13] rt2x00: remove data_queue_desc struct
Date: Tue,  4 Jun 2013 13:40:50 +0200
Message-Id: <1370346050-7047-14-git-send-email-juhosg@openwrt.org> (sfid-20130604_135936_511544_16A9BEA7)
In-Reply-To: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
References: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the queue_init callback is implemented
by a driver it gets used instead of the
data_queue_desc based initialization.

The queue_init callback is implemented for
each drivers now, so the old initialization
method is not used anymore. Remove the unused
data_queue_desc structure and all of the
related code.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    4 ---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   42 +----------------------------
 drivers/net/wireless/rt2x00/rt2x00queue.h |   19 -------------
 3 files changed, 1 insertion(+), 64 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 2d2db64..2a17f7e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -649,10 +649,6 @@ struct rt2x00_ops {
 	const unsigned int rf_size;
 	const unsigned int tx_queues;
 	const unsigned int extra_tx_headroom;
-	const struct data_queue_desc *rx;
-	const struct data_queue_desc *tx;
-	const struct data_queue_desc *bcn;
-	const struct data_queue_desc *atim;
 	void (*queue_init)(struct data_queue *queue);
 	const struct rt2x00lib_ops *lib;
 	const void *drv;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 2a99ff1..c4f1e2b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -1276,33 +1276,6 @@ void rt2x00queue_uninitialize(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-static const struct data_queue_desc *
-rt2x00queue_get_qdesc_by_qid(struct rt2x00_dev *rt2x00dev,
-			     enum data_queue_qid qid)
-{
-	switch (qid) {
-	case QID_RX:
-		return rt2x00dev->ops->rx;
-
-	case QID_AC_BE:
-	case QID_AC_BK:
-	case QID_AC_VO:
-	case QID_AC_VI:
-		return rt2x00dev->ops->tx;
-
-	case QID_BEACON:
-		return rt2x00dev->ops->bcn;
-
-	case QID_ATIM:
-		return rt2x00dev->ops->atim;
-
-	default:
-		break;
-	}
-
-	return NULL;
-}
-
 static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
 			     struct data_queue *queue, enum data_queue_qid qid)
 {
@@ -1317,20 +1290,7 @@ static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
 	queue->cw_min = 5;
 	queue->cw_max = 10;
 
-	if (rt2x00dev->ops->queue_init) {
-		rt2x00dev->ops->queue_init(queue);
-	} else {
-		const struct data_queue_desc *qdesc;
-
-		qdesc = rt2x00queue_get_qdesc_by_qid(rt2x00dev, qid);
-		BUG_ON(!qdesc);
-
-		queue->limit = qdesc->entry_num;
-		queue->data_size = qdesc->data_size;
-		queue->desc_size = qdesc->desc_size;
-		queue->winfo_size = qdesc->winfo_size;
-		queue->priv_size = qdesc->priv_size;
-	}
+	rt2x00dev->ops->queue_init(queue);
 
 	queue->threshold = DIV_ROUND_UP(queue->limit, 10);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 2cf4903..ebe1172 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -489,25 +489,6 @@ struct data_queue {
 };
 
 /**
- * struct data_queue_desc: Data queue description
- *
- * The information in this structure is used by drivers
- * to inform rt2x00lib about the creation of the data queue.
- *
- * @entry_num: Maximum number of entries for a queue.
- * @data_size: Maximum data size for the frames in this queue.
- * @desc_size: Hardware descriptor size for the data in this queue.
- * @priv_size: Size of per-queue_entry private data.
- */
-struct data_queue_desc {
-	unsigned short entry_num;
-	unsigned short data_size;
-	unsigned char  desc_size;
-	unsigned char  winfo_size;
-	unsigned short priv_size;
-};
-
-/**
  * queue_end - Return pointer to the last queue (HELPER MACRO).
  * @__dev: Pointer to &struct rt2x00_dev
  *
-- 
1.7.10

