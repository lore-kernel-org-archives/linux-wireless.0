Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46265 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867Ab3EBMaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 08:30:10 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 02/14] rt2x00: rt2x00queue: move data_queue field initialization to rt2x00queue_init
Date: Thu,  2 May 2013 14:30:17 +0200
Message-Id: <1367497829-7672-3-git-send-email-juhosg@openwrt.org> (sfid-20130502_143022_434370_8C756495)
In-Reply-To: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
References: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some fileds of the data queues are initialized
in the rt2x00queue_alloc_entries routine before
the queue entries are allocated, however the
initialization code is not strictly related to
the allocation.

Move the code into the rt2x00queu_init function.
It is a more logical place and the change ensures
that the queue_data fields can be used in device
probe routines.

The patch also introduces a helper function in
order to be able to get the correct data_queue_desc
structure for a given queue. This helper is only
needed temporarily and it will be removed later.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   46 ++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 15714a2..7f938a5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -1170,13 +1170,6 @@ static int rt2x00queue_alloc_entries(struct data_queue *queue,
 
 	rt2x00queue_reset(queue);
 
-	queue->limit = qdesc->entry_num;
-	queue->threshold = DIV_ROUND_UP(qdesc->entry_num, 10);
-	queue->data_size = qdesc->data_size;
-	queue->desc_size = qdesc->desc_size;
-	queue->winfo_size = qdesc->winfo_size;
-	queue->priv_size = qdesc->priv_size;
-
 	/*
 	 * Allocate all queue entries.
 	 */
@@ -1285,9 +1278,38 @@ void rt2x00queue_uninitialize(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
+static const struct data_queue_desc *
+rt2x00queue_get_qdesc_by_qid(struct rt2x00_dev *rt2x00dev,
+			     enum data_queue_qid qid)
+{
+	switch (qid) {
+	case QID_RX:
+		return rt2x00dev->ops->rx;
+
+	case QID_AC_BE:
+	case QID_AC_BK:
+	case QID_AC_VO:
+	case QID_AC_VI:
+		return rt2x00dev->ops->tx;
+
+	case QID_BEACON:
+		return rt2x00dev->ops->bcn;
+
+	case QID_ATIM:
+		return rt2x00dev->ops->atim;
+
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
 static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
 			     struct data_queue *queue, enum data_queue_qid qid)
 {
+	const struct data_queue_desc *qdesc;
+
 	mutex_init(&queue->status_lock);
 	spin_lock_init(&queue->tx_lock);
 	spin_lock_init(&queue->index_lock);
@@ -1298,6 +1320,16 @@ static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
 	queue->aifs = 2;
 	queue->cw_min = 5;
 	queue->cw_max = 10;
+
+	qdesc = rt2x00queue_get_qdesc_by_qid(rt2x00dev, qid);
+	BUG_ON(!qdesc);
+
+	queue->limit = qdesc->entry_num;
+	queue->threshold = DIV_ROUND_UP(qdesc->entry_num, 10);
+	queue->data_size = qdesc->data_size;
+	queue->desc_size = qdesc->desc_size;
+	queue->winfo_size = qdesc->winfo_size;
+	queue->priv_size = qdesc->priv_size;
 }
 
 int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
-- 
1.7.10

