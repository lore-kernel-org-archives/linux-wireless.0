Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34145 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab0HWR5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 13:57:20 -0400
Received: by fxm13 with SMTP id 13so3164360fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 10:57:19 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/8] rt2x00: Reduce indenting
Date: Mon, 23 Aug 2010 19:54:02 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008231953.40629.IvDoorn@gmail.com>
In-Reply-To: <201008231953.40629.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008231954.03752.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cosmetic change, reduce indenting.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 52ed3f4..1d2eb46 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -232,21 +232,22 @@ static inline void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	u32 length;
 
-	if (test_and_clear_bit(ENTRY_DATA_PENDING, &entry->flags)) {
-		/*
-		 * USB devices cannot blindly pass the skb->len as the
-		 * length of the data to usb_fill_bulk_urb. Pass the skb
-		 * to the driver to determine what the length should be.
-		 */
-		length = rt2x00dev->ops->lib->get_tx_data_len(entry);
+	if (!test_and_clear_bit(ENTRY_DATA_PENDING, &entry->flags))
+		return;
+
+	/*
+	 * USB devices cannot blindly pass the skb->len as the
+	 * length of the data to usb_fill_bulk_urb. Pass the skb
+	 * to the driver to determine what the length should be.
+	 */
+	length = rt2x00dev->ops->lib->get_tx_data_len(entry);
 
-		usb_fill_bulk_urb(entry_priv->urb, usb_dev,
-				  usb_sndbulkpipe(usb_dev, entry->queue->usb_endpoint),
-				  entry->skb->data, length,
-				  rt2x00usb_interrupt_txdone, entry);
+	usb_fill_bulk_urb(entry_priv->urb, usb_dev,
+			  usb_sndbulkpipe(usb_dev, entry->queue->usb_endpoint),
+			  entry->skb->data, length,
+			  rt2x00usb_interrupt_txdone, entry);
 
-		usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
-	}
+	usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 }
 
 void rt2x00usb_kick_tx_queue(struct data_queue *queue)
-- 
1.7.2.1

