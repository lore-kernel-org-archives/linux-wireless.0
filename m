Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:54756 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0DOHNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 03:13:24 -0400
Received: by bwz25 with SMTP id 25so1091871bwz.28
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 00:13:23 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/2] rt2x00: add txdesc parameter to write_tx_data
Date: Thu, 15 Apr 2010 09:13:13 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201004150913.13636.helmut.schaa@googlemail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend the write_tx_data callback with a txdesc parameter to allow
access to the tx desciptor while preparing the tx data.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00pci.h   |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00usb.h   |    3 ++-
 6 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 4de505b..4f9b666 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -549,7 +549,8 @@ struct rt2x00lib_ops {
 	void (*write_tx_desc) (struct rt2x00_dev *rt2x00dev,
 			       struct sk_buff *skb,
 			       struct txentry_desc *txdesc);
-	int (*write_tx_data) (struct queue_entry *entry);
+	int (*write_tx_data) (struct queue_entry *entry,
+			      struct txentry_desc *txdesc);
 	void (*write_beacon) (struct queue_entry *entry);
 	int (*get_tx_data_len) (struct queue_entry *entry);
 	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 047123b..2fe9f29 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -62,7 +62,8 @@ EXPORT_SYMBOL_GPL(rt2x00pci_regbusy_read);
 /*
  * TX data handlers.
  */
-int rt2x00pci_write_tx_data(struct queue_entry *entry)
+int rt2x00pci_write_tx_data(struct queue_entry *entry,
+			    struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 8149ff6..51bcef3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -92,7 +92,8 @@ int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
  * This function will initialize the DMA and skb descriptor
  * to prepare the entry for the actual TX operation.
  */
-int rt2x00pci_write_tx_data(struct queue_entry *entry);
+int rt2x00pci_write_tx_data(struct queue_entry *entry,
+			    struct txentry_desc *txdesc);
 
 /**
  * struct queue_entry_priv_pci: Per entry PCI specific information
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 5b6b789..72e4b04 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -525,7 +525,8 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	 * call failed. Since we always return NETDEV_TX_OK to mac80211,
 	 * this frame will simply be dropped.
 	 */
-	if (unlikely(queue->rt2x00dev->ops->lib->write_tx_data(entry))) {
+	if (unlikely(queue->rt2x00dev->ops->lib->write_tx_data(entry,
+							       &txdesc))) {
 		clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 		entry->skb = NULL;
 		return -EIO;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 0a751e7..acf3282 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -215,7 +215,8 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	rt2x00lib_txdone(entry, &txdesc);
 }
 
-int rt2x00usb_write_tx_data(struct queue_entry *entry)
+int rt2x00usb_write_tx_data(struct queue_entry *entry,
+			    struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 3da6841..621d0f8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -376,7 +376,8 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev);
  * This function will initialize the URB and skb descriptor
  * to prepare the entry for the actual TX operation.
  */
-int rt2x00usb_write_tx_data(struct queue_entry *entry);
+int rt2x00usb_write_tx_data(struct queue_entry *entry,
+			    struct txentry_desc *txdesc);
 
 /**
  * struct queue_entry_priv_usb: Per entry USB specific information
-- 
1.6.4.2

