Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46283 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab3EBMaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 08:30:12 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 06/14] rt2x00: add queue_init callback to rt2x00_ops
Date: Thu,  2 May 2013 14:30:21 +0200
Message-Id: <1367497829-7672-7-git-send-email-juhosg@openwrt.org> (sfid-20130502_143103_493366_E7EACFAB)
In-Reply-To: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
References: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver uses static data structures for initializing
specific fields of a given data queue. These static
queue data descriptor structures are containing values
which related to a given chipset.

Even though the values are chip specific, the actual
selection of the used structure is based on device
specific vendor/product identifiers. This approach works,
but it is not always reliable. Sometimes the vendor and/or
device IDs of the PCI and USB devices contains improper
values which makes it impossible to select the correct
structure for such devices.

The patch adds a new callback to tr2x00_ops which
is called after the chipset detection is finished.
This allows the drivers to do dynamic initialization
of the data_queue structure for a given queue based
on the actual chipset.

After each driver implements the queue_init callback,
the data_queue_desc structure will be removed.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    1 +
 drivers/net/wireless/rt2x00/rt2x00queue.c |   22 +++++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 7510723..2d2db64 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -653,6 +653,7 @@ struct rt2x00_ops {
 	const struct data_queue_desc *tx;
 	const struct data_queue_desc *bcn;
 	const struct data_queue_desc *atim;
+	void (*queue_init)(struct data_queue *queue);
 	const struct rt2x00lib_ops *lib;
 	const void *drv;
 	const struct ieee80211_ops *hw;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 3ae2264..2a99ff1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -1306,8 +1306,6 @@ rt2x00queue_get_qdesc_by_qid(struct rt2x00_dev *rt2x00dev,
 static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
 			     struct data_queue *queue, enum data_queue_qid qid)
 {
-	const struct data_queue_desc *qdesc;
-
 	mutex_init(&queue->status_lock);
 	spin_lock_init(&queue->tx_lock);
 	spin_lock_init(&queue->index_lock);
@@ -1319,14 +1317,20 @@ static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
 	queue->cw_min = 5;
 	queue->cw_max = 10;
 
-	qdesc = rt2x00queue_get_qdesc_by_qid(rt2x00dev, qid);
-	BUG_ON(!qdesc);
+	if (rt2x00dev->ops->queue_init) {
+		rt2x00dev->ops->queue_init(queue);
+	} else {
+		const struct data_queue_desc *qdesc;
+
+		qdesc = rt2x00queue_get_qdesc_by_qid(rt2x00dev, qid);
+		BUG_ON(!qdesc);
 
-	queue->limit = qdesc->entry_num;
-	queue->data_size = qdesc->data_size;
-	queue->desc_size = qdesc->desc_size;
-	queue->winfo_size = qdesc->winfo_size;
-	queue->priv_size = qdesc->priv_size;
+		queue->limit = qdesc->entry_num;
+		queue->data_size = qdesc->data_size;
+		queue->desc_size = qdesc->desc_size;
+		queue->winfo_size = qdesc->winfo_size;
+		queue->priv_size = qdesc->priv_size;
+	}
 
 	queue->threshold = DIV_ROUND_UP(queue->limit, 10);
 }
-- 
1.7.10

