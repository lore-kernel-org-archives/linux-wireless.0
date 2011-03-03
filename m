Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42982 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1CCSsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:48:17 -0500
Received: by wwb22 with SMTP id 22so1737707wwb.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:48:15 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 01/19] rt2x00: Optimize calls to rt2x00queue_get_queue
Date: Thu, 3 Mar 2011 19:38:55 +0100
Cc: users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201103031938.56423.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

In some cases (tx path for example) we don't need to check for non-tx
queues in rt2x00queue_get_queue. Hence, introduce a new method
rt2x00queue_get_tx_queue that is only valid for tx queues and use it in
places where only tx queues are valid.

Furthermore, this new method is quite short and as such can be inlined
to avoid the function call overhead.

This only converts the txdone functions of drivers that don't use an ATIM
queue and the generic tx path.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h    |   17 +++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00mac.c |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c   |    4 ++--
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 +-
 6 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index af9cef0..7dba354 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -751,7 +751,7 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 		if (pid >= QID_RX)
 			continue;
 
-		queue = rt2x00queue_get_queue(rt2x00dev, pid);
+		queue = rt2x00queue_get_tx_queue(rt2x00dev, pid);
 		if (unlikely(!queue))
 			continue;
 
@@ -3957,7 +3957,7 @@ int rt2800_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	if (queue_idx >= 4)
 		return 0;
 
-	queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
+	queue = rt2x00queue_get_tx_queue(rt2x00dev, queue_idx);
 
 	/* Update WMM TXOP register */
 	offset = WMM_TXOP0_CFG + (sizeof(u32) * (!!(queue_idx & 2)));
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index cc7c90c..a768deb 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -736,7 +736,7 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 			break;
 		}
 
-		queue = rt2x00queue_get_queue(rt2x00dev, qid);
+		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
 		if (unlikely(queue == NULL)) {
 			/*
 			 * The queue is NULL, this shouldn't happen. Stop
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 1df432c..391669b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1063,6 +1063,23 @@ void rt2x00queue_map_txskb(struct queue_entry *entry);
 void rt2x00queue_unmap_skb(struct queue_entry *entry);
 
 /**
+ * rt2x00queue_get_tx_queue - Convert tx queue index to queue pointer
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @queue: rt2x00 queue index (see &enum data_queue_qid).
+ *
+ * Returns NULL for non tx queues.
+ */
+static inline struct data_queue *
+rt2x00queue_get_tx_queue(struct rt2x00_dev *rt2x00dev,
+			 const enum data_queue_qid queue)
+{
+	if (queue < rt2x00dev->ops->tx_queues && rt2x00dev->tx)
+		return &rt2x00dev->tx[queue];
+
+	return NULL;
+}
+
+/**
  * rt2x00queue_get_queue - Convert queue index to queue pointer
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @queue: rt2x00 queue index (see &enum data_queue_qid).
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 1b3edef..6715b77 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -122,7 +122,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	    test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags))
 		queue = rt2x00queue_get_queue(rt2x00dev, QID_ATIM);
 	else
-		queue = rt2x00queue_get_queue(rt2x00dev, qid);
+		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
 	if (unlikely(!queue)) {
 		ERROR(rt2x00dev,
 		      "Attempt to send packet over invalid queue %d.\n"
@@ -693,7 +693,7 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct data_queue *queue;
 
-	queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
+	queue = rt2x00queue_get_tx_queue(rt2x00dev, queue_idx);
 	if (unlikely(!queue))
 		return -EINVAL;
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index dd2164d..674239e 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2182,7 +2182,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 		 * queue identication number.
 		 */
 		type = rt2x00_get_field32(reg, STA_CSR4_PID_TYPE);
-		queue = rt2x00queue_get_queue(rt2x00dev, type);
+		queue = rt2x00queue_get_tx_queue(rt2x00dev, type);
 		if (unlikely(!queue))
 			continue;
 
@@ -2909,7 +2909,7 @@ static int rt61pci_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	if (queue_idx >= 4)
 		return 0;
 
-	queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
+	queue = rt2x00queue_get_tx_queue(rt2x00dev, queue_idx);
 
 	/* Update WMM TXOP register */
 	offset = AC_TXOP_CSR0 + (sizeof(u32) * (!!(queue_idx & 2)));
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 5ff72de..61c964d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2239,7 +2239,7 @@ static int rt73usb_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	if (queue_idx >= 4)
 		return 0;
 
-	queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
+	queue = rt2x00queue_get_tx_queue(rt2x00dev, queue_idx);
 
 	/* Update WMM TXOP register */
 	offset = AC_TXOP_CSR0 + (sizeof(u32) * (!!(queue_idx & 2)));
-- 
1.7.2.3

