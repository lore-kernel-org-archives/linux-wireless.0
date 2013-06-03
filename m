Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46580 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758133Ab3FCVkB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 17:40:01 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <moorray@wp.pl>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] rt2x00: rt2x00queue: initialize data_queue fields earlier
Date: Mon,  3 Jun 2013 23:39:53 +0200
Message-Id: <1370295593-18938-1-git-send-email-juhosg@openwrt.org> (sfid-20130603_234013_261037_92EF8513)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for rt2800 device is broken since my
'rt2x00: rt2x00dev: use rt2x00dev->tx->limit'
patch. The changelog of that commit says that the
TX data queue is initialized already when the
rt2x00lib_probe_hw() function is called.

However as Jakub noticed it, this statement is not
correct. The queue->limit field is initialized in
the rt2x00queue_alloc_entries routine and that is
not yet called when rt2x00lib_probe_hw() runs.
Because the value of tx->limit contains zero, the
driver tries to allocate a kernel fifo with zero
size and kfifo_alloc rejects that with -EINVAL.

  PCI: Enabling device 0000:01:00.0 (0000 -> 0002)
  ieee80211 phy1: rt2x00_set_rt: Info - RT chipset 3071, rev 021c detected
  ieee80211 phy1: rt2x00_set_rf: Info - RF chipset 0008 detected
  ieee80211 phy1: rt2x00lib_probe_dev: Error - Failed to initialize hw
  rt2800pci: probe of 0000:01:00.0 failed with error -22

Move the data_queue field initialization from
the rt2x00queue_alloc_entries routine into the
rt2x00queue_init function. The initialization
code is not strictly related to the allocation,
and the change ensures that the queue_data fields
can be used in the probe routines.

The patch also introduces a helper function in
order to be able to get the correct data_queue_desc
structure for a given queue. This helper is only
needed temporarily and it will be removed later.

Reported-by: Jakub Kicinski <moorray@wp.pl>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   44 +++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 2c12311..5efbbbd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -1170,12 +1170,6 @@ static int rt2x00queue_alloc_entries(struct data_queue *queue,
 
 	rt2x00queue_reset(queue);
 
-	queue->limit = qdesc->entry_num;
-	queue->threshold = DIV_ROUND_UP(qdesc->entry_num, 10);
-	queue->data_size = qdesc->data_size;
-	queue->desc_size = qdesc->desc_size;
-	queue->winfo_size = qdesc->winfo_size;
-
 	/*
 	 * Allocate all queue entries.
 	 */
@@ -1284,9 +1278,38 @@ void rt2x00queue_uninitialize(struct rt2x00_dev *rt2x00dev)
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
@@ -1297,6 +1320,15 @@ static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
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
 }
 
 int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
-- 
1.7.10

