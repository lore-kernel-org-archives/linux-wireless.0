Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35605 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab1CCStQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:49:16 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1356532wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:49:15 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/19] rt2x00: Include ATIM queue support in rt2x00queue_get_tx_queue.
Date: Thu, 3 Mar 2011 19:46:29 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031945.40473.IvDoorn@gmail.com> <201103031946.09972.IvDoorn@gmail.com>
In-Reply-To: <201103031946.09972.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031946.30487.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

The ATIM queue is considered to be a TX queue by the drivers that support
the queue. Therefore include support for the ATIM queue to the
rt2x00queue_get_tx_queue function so that the drivers that support the ATIM
queue can also use that function.

Add the support in such a way that drivers that do not support the ATIM
queue are not penalized in their efficiency.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h    |    3 +++
 drivers/net/wireless/rt2x00/rt2x00mac.c |    8 ++++----
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index d78d39e..329f328 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1278,7 +1278,7 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 			     const enum data_queue_qid queue_idx)
 {
-	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
+	struct data_queue *queue = rt2x00queue_get_tx_queue(rt2x00dev, queue_idx);
 	struct queue_entry_priv_pci *entry_priv;
 	struct queue_entry *entry;
 	struct txdone_entry_desc txdesc;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 3fb0915..5cd6575 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1410,7 +1410,7 @@ static void rt2500pci_fill_rxdone(struct queue_entry *entry,
 static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 			     const enum data_queue_qid queue_idx)
 {
-	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
+	struct data_queue *queue = rt2x00queue_get_tx_queue(rt2x00dev, queue_idx);
 	struct queue_entry_priv_pci *entry_priv;
 	struct queue_entry *entry;
 	struct txdone_entry_desc txdesc;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 89a0b45..72f8ebf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1076,6 +1076,9 @@ rt2x00queue_get_tx_queue(struct rt2x00_dev *rt2x00dev,
 	if (queue < rt2x00dev->ops->tx_queues && rt2x00dev->tx)
 		return &rt2x00dev->tx[queue];
 
+	if (queue == QID_ATIM)
+		return rt2x00dev->atim;
+
 	return NULL;
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 67c99c3..7f58767 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -116,13 +116,13 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		goto exit_fail;
 
 	/*
-	 * Determine which queue to put packet on.
+	 * Use the ATIM queue if appropriate and present.
 	 */
 	if (tx_info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM &&
 	    test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags))
-		queue = rt2x00queue_get_queue(rt2x00dev, QID_ATIM);
-	else
-		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
+		qid = QID_ATIM;
+
+	queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
 	if (unlikely(!queue)) {
 		ERROR(rt2x00dev,
 		      "Attempt to send packet over invalid queue %d.\n"
-- 
1.7.2.3

