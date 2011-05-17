Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45765 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1EQLWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 07:22:11 -0400
Received: by ewy4 with SMTP id 4so103002ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 04:22:10 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: add helpers for block R/W ops
Date: Tue, 17 May 2011 14:00:00 +0200
Message-Id: <1305633602-4590-1-git-send-email-zajec5@gmail.com> (sfid-20110517_132213_745010_FB632D15)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h |   12 ++++++++++++
 drivers/net/wireless/b43/pio.c |   20 ++++++++++----------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 1be9420..caba5c5 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -897,6 +897,18 @@ static inline void b43_write32(struct b43_wldev *dev, u16 offset, u32 value)
 	ssb_write32(dev->sdev, offset, value);
 }
 
+static inline void b43_block_read(struct b43_wldev *dev, void *buffer,
+				 size_t count, u16 offset, u8 reg_width)
+{
+	ssb_block_read(dev->sdev, buffer, count, offset, reg_width);
+}
+
+static inline void b43_block_write(struct b43_wldev *dev, const void *buffer,
+				   size_t count, u16 offset, u8 reg_width)
+{
+	ssb_block_write(dev->sdev, buffer, count, offset, reg_width);
+}
+
 static inline bool b43_using_pio_transfers(struct b43_wldev *dev)
 {
 	return dev->__using_pio_transfers;
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index af0596d..72ab94d 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -339,7 +339,7 @@ static u16 tx_write_2byte_queue(struct b43_pio_txqueue *q,
 	ctl |= B43_PIO_TXCTL_WRITELO | B43_PIO_TXCTL_WRITEHI;
 	b43_piotx_write16(q, B43_PIO_TXCTL, ctl);
 
-	ssb_block_write(dev->sdev, data, (data_len & ~1),
+	b43_block_write(dev, data, (data_len & ~1),
 			q->mmio_base + B43_PIO_TXDATA,
 			sizeof(u16));
 	if (data_len & 1) {
@@ -351,7 +351,7 @@ static u16 tx_write_2byte_queue(struct b43_pio_txqueue *q,
 		b43_piotx_write16(q, B43_PIO_TXCTL, ctl);
 		tail[0] = data[data_len - 1];
 		tail[1] = 0;
-		ssb_block_write(dev->sdev, tail, 2,
+		b43_block_write(dev, tail, 2,
 				q->mmio_base + B43_PIO_TXDATA,
 				sizeof(u16));
 	}
@@ -393,7 +393,7 @@ static u32 tx_write_4byte_queue(struct b43_pio_txqueue *q,
 	       B43_PIO8_TXCTL_16_23 | B43_PIO8_TXCTL_24_31;
 	b43_piotx_write32(q, B43_PIO8_TXCTL, ctl);
 
-	ssb_block_write(dev->sdev, data, (data_len & ~3),
+	b43_block_write(dev, data, (data_len & ~3),
 			q->mmio_base + B43_PIO8_TXDATA,
 			sizeof(u32));
 	if (data_len & 3) {
@@ -421,7 +421,7 @@ static u32 tx_write_4byte_queue(struct b43_pio_txqueue *q,
 			break;
 		}
 		b43_piotx_write32(q, B43_PIO8_TXCTL, ctl);
-		ssb_block_write(dev->sdev, tail, 4,
+		b43_block_write(dev, tail, 4,
 				q->mmio_base + B43_PIO8_TXDATA,
 				sizeof(u32));
 	}
@@ -657,11 +657,11 @@ data_ready:
 
 	/* Get the preamble (RX header) */
 	if (q->rev >= 8) {
-		ssb_block_read(dev->sdev, rxhdr, sizeof(*rxhdr),
+		b43_block_read(dev, rxhdr, sizeof(*rxhdr),
 			       q->mmio_base + B43_PIO8_RXDATA,
 			       sizeof(u32));
 	} else {
-		ssb_block_read(dev->sdev, rxhdr, sizeof(*rxhdr),
+		b43_block_read(dev, rxhdr, sizeof(*rxhdr),
 			       q->mmio_base + B43_PIO_RXDATA,
 			       sizeof(u16));
 	}
@@ -697,7 +697,7 @@ data_ready:
 	skb_reserve(skb, 2);
 	skb_put(skb, len + padding);
 	if (q->rev >= 8) {
-		ssb_block_read(dev->sdev, skb->data + padding, (len & ~3),
+		b43_block_read(dev, skb->data + padding, (len & ~3),
 			       q->mmio_base + B43_PIO8_RXDATA,
 			       sizeof(u32));
 		if (len & 3) {
@@ -705,7 +705,7 @@ data_ready:
 			BUILD_BUG_ON(sizeof(wl->pio_tailspace) < 4);
 
 			/* Read the last few bytes. */
-			ssb_block_read(dev->sdev, tail, 4,
+			b43_block_read(dev, tail, 4,
 				       q->mmio_base + B43_PIO8_RXDATA,
 				       sizeof(u32));
 			switch (len & 3) {
@@ -724,7 +724,7 @@ data_ready:
 			}
 		}
 	} else {
-		ssb_block_read(dev->sdev, skb->data + padding, (len & ~1),
+		b43_block_read(dev, skb->data + padding, (len & ~1),
 			       q->mmio_base + B43_PIO_RXDATA,
 			       sizeof(u16));
 		if (len & 1) {
@@ -732,7 +732,7 @@ data_ready:
 			BUILD_BUG_ON(sizeof(wl->pio_tailspace) < 2);
 
 			/* Read the last byte. */
-			ssb_block_read(dev->sdev, tail, 2,
+			b43_block_read(dev, tail, 2,
 				       q->mmio_base + B43_PIO_RXDATA,
 				       sizeof(u16));
 			skb->data[len + padding - 1] = tail[0];
-- 
1.7.3.4

