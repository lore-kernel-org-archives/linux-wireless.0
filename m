Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:61799 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbYH2TIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 15:08:05 -0400
Received: by ey-out-2122.google.com with SMTP id 6so320107eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 12:08:04 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 6/7] rt2x00: skb->data pointer should not include TX descriptor
Date: Fri, 29 Aug 2008 21:07:20 +0200
Cc: "rt2400-devel" <rt2400-devel@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <200808292103.53179.IvDoorn@gmail.com> <200808292105.45380.IvDoorn@gmail.com> <200808292106.01403.IvDoorn@gmail.com>
In-Reply-To: <200808292106.01403.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200808292107.20211.IvDoorn@gmail.com> (sfid-20080829_210811_294154_331A577D)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

Make sure the skb->data pointer points to the frame data, not the TX
descriptor. The frame dumping code relies on that.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    3 +--
 drivers/net/wireless/rt2x00/rt2x00usb.c |   11 ++++++-----
 drivers/net/wireless/rt2x00/rt73usb.c   |    3 +--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c5f49e3..0e008b6 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1114,8 +1114,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_NEW_SEQ,
 			   test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT,
-			   skb->len - skbdesc->desc_len);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skb->len);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 2dd7c83..b73a7e0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -168,11 +168,6 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 		return;
 
 	/*
-	 * Remove the descriptor data from the buffer.
-	 */
-	skb_pull(entry->skb, entry->queue->desc_size);
-
-	/*
 	 * Obtain the status about this packet.
 	 * Note that when the status is 0 it does not mean the
 	 * frame was send out correctly. It only means the frame
@@ -224,6 +219,12 @@ int rt2x00usb_write_tx_data(struct queue_entry *entry)
 			  entry->skb->data, length,
 			  rt2x00usb_interrupt_txdone, entry);
 
+	/*
+	 * Make sure the skb->data pointer points to the frame, not the
+	 * descriptor.
+	 */
+	skb_pull(entry->skb, entry->queue->desc_size);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_write_tx_data);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index cf236ec..e698ae0 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1556,8 +1556,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_KEY_TABLE,
 			   test_bit(ENTRY_TXD_ENCRYPT_PAIRWISE, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_KEY_INDEX, txdesc->key_idx);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT,
-			   skb->len - skbdesc->desc_len);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skb->len);
 	rt2x00_set_field32(&word, TXD_W0_BURST2,
 			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, txdesc->cipher);
-- 
1.5.6.1

