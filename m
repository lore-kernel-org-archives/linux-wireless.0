Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:54490 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab0F2Tu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:50:58 -0400
Received: by ey-out-2122.google.com with SMTP id 25so288411eya.5
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:50:56 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/21] rt2x00: Move filling of TX URB to rt2x00usb_kick_tx_entry function.
Date: Tue, 29 Jun 2010 21:40:34 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292139.30199.IvDoorn@gmail.com> <201006292140.03875.IvDoorn@gmail.com>
In-Reply-To: <201006292140.03875.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292140.35163.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

There is no need to fill the TX URB this early, and moving it to the
rt2x00usb_kick_tx_entry function allows us to merge the PCI and USB
variants of the write_tx_data function.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   33 ++++++++++++++++---------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 9759754..1c91812 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -211,9 +211,6 @@ int rt2x00usb_write_tx_data(struct queue_entry *entry,
 			    struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
-	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
-	u32 length;
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -222,18 +219,6 @@ int rt2x00usb_write_tx_data(struct queue_entry *entry,
 	memset(entry->skb->data, 0, entry->queue->desc_size);
 
 	/*
-	 * USB devices cannot blindly pass the skb->len as the
-	 * length of the data to usb_fill_bulk_urb. Pass the skb
-	 * to the driver to determine what the length should be.
-	 */
-	length = rt2x00dev->ops->lib->get_tx_data_len(entry);
-
-	usb_fill_bulk_urb(entry_priv->urb, usb_dev,
-			  usb_sndbulkpipe(usb_dev, entry->queue->usb_endpoint),
-			  entry->skb->data, length,
-			  rt2x00usb_interrupt_txdone, entry);
-
-	/*
 	 * Call the driver's write_tx_datadesc function, if it exists.
 	 */
 	if (rt2x00dev->ops->lib->write_tx_datadesc)
@@ -245,10 +230,26 @@ EXPORT_SYMBOL_GPL(rt2x00usb_write_tx_data);
 
 static inline void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 {
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
+	u32 length;
+
+	if (test_and_clear_bit(ENTRY_DATA_PENDING, &entry->flags)) {
+		/*
+		 * USB devices cannot blindly pass the skb->len as the
+		 * length of the data to usb_fill_bulk_urb. Pass the skb
+		 * to the driver to determine what the length should be.
+		 */
+		length = rt2x00dev->ops->lib->get_tx_data_len(entry);
+
+		usb_fill_bulk_urb(entry_priv->urb, usb_dev,
+				  usb_sndbulkpipe(usb_dev, entry->queue->usb_endpoint),
+				  entry->skb->data, length,
+				  rt2x00usb_interrupt_txdone, entry);
 
-	if (test_and_clear_bit(ENTRY_DATA_PENDING, &entry->flags))
 		usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
+	}
 }
 
 void rt2x00usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-- 
1.6.6.1

