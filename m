Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:55426 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbYDBR7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 13:59:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Use SSB block-I/O to do PIO
Date: Wed, 2 Apr 2008 19:58:20 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200804021958.21080.mb@bu3sch.de> (sfid-20080402_185929_875809_C497C265)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes the b43-PIO code to use the new SSB block-I/O.
This reduces the overhead by removing lots of function calls, pointer
dereferencing, if-conditionals any byteswapping for each packet data word.

This also fixes a harmless sparse endianness warning.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply to 2.6.26


Index: wireless-testing/drivers/net/wireless/b43/pio.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/pio.c	2008-03-30 18:19:24.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/pio.c	2008-03-30 18:21:34.000000000 +0200
@@ -335,33 +335,34 @@ static struct b43_pio_txqueue * select_q
 	} else
 		q = dev->pio.tx_queue_AC_BE;
 
 	return q;
 }
 
-static inline void tx_write_2byte_queue(struct b43_pio_txqueue *q,
-					u16 *ctl,
-					const void *_data,
-					unsigned int data_len)
+static u16 tx_write_2byte_queue(struct b43_pio_txqueue *q,
+				u16 ctl,
+				const void *_data,
+				unsigned int data_len)
 {
+	struct b43_wldev *dev = q->dev;
 	const u8 *data = _data;
-	unsigned int i;
-	u16 value;
 
-	*ctl |= B43_PIO_TXCTL_WRITELO | B43_PIO_TXCTL_WRITEHI;
-	b43_piotx_write16(q, B43_PIO_TXCTL, *ctl);
-	for (i = 0; i < data_len; i += 2) {
-		value = data[i];
-		if (i + 1 < data_len) {
-			value |= (u16)(data[i + 1]) << 8;
-		} else {
-			*ctl &= ~B43_PIO_TXCTL_WRITEHI;
-			b43_piotx_write16(q, B43_PIO_TXCTL, *ctl);
-		}
-		b43_piotx_write16(q, B43_PIO_TXDATA, value);
+	ctl |= B43_PIO_TXCTL_WRITELO | B43_PIO_TXCTL_WRITEHI;
+	b43_piotx_write16(q, B43_PIO_TXCTL, ctl);
+
+	ssb_block_write(dev->dev, data, (data_len & ~1),
+			q->mmio_base + B43_PIO_TXDATA,
+			sizeof(u16));
+	if (data_len & 1) {
+		/* Write the last byte. */
+		ctl &= ~B43_PIO_TXCTL_WRITEHI;
+		b43_piotx_write16(q, B43_PIO_TXCTL, ctl);
+		b43_piotx_write16(q, B43_PIO_TXDATA, data[data_len - 1]);
 	}
+
+	return ctl;
 }
 
 static void pio_tx_frame_2byte_queue(struct b43_pio_txpacket *pack,
 				     const u8 *hdr, unsigned int hdrlen)
 {
 	struct b43_pio_txqueue *q = pack->queue;
@@ -371,57 +372,59 @@ static void pio_tx_frame_2byte_queue(str
 
 	ctl = b43_piotx_read16(q, B43_PIO_TXCTL);
 	ctl |= B43_PIO_TXCTL_FREADY;
 	ctl &= ~B43_PIO_TXCTL_EOF;
 
 	/* Transfer the header data. */
-	tx_write_2byte_queue(q, &ctl, hdr, hdrlen);
+	ctl = tx_write_2byte_queue(q, ctl, hdr, hdrlen);
 	/* Transfer the frame data. */
-	tx_write_2byte_queue(q, &ctl, frame, frame_len);
+	ctl = tx_write_2byte_queue(q, ctl, frame, frame_len);
 
 	ctl |= B43_PIO_TXCTL_EOF;
 	b43_piotx_write16(q, B43_PIO_TXCTL, ctl);
 }
 
-static inline void tx_write_4byte_queue(struct b43_pio_txqueue *q,
-					u32 *ctl,
-					const void *_data,
-					unsigned int data_len)
+static u32 tx_write_4byte_queue(struct b43_pio_txqueue *q,
+				u32 ctl,
+				const void *_data,
+				unsigned int data_len)
 {
+	struct b43_wldev *dev = q->dev;
 	const u8 *data = _data;
-	unsigned int i;
-	u32 value;
-	bool ctl_changed = 0;
-
-	*ctl |= B43_PIO8_TXCTL_0_7 | B43_PIO8_TXCTL_8_15 |
-		B43_PIO8_TXCTL_16_23 | B43_PIO8_TXCTL_24_31;
-	b43_piotx_write32(q, B43_PIO8_TXCTL, *ctl);
-	for (i = 0; i < data_len; i += 4) {
-		value = data[i];
-		if (i + 1 < data_len) {
-			value |= (u32)(data[i + 1]) << 8;
-		} else {
-			*ctl &= ~B43_PIO8_TXCTL_8_15;
-			ctl_changed = 1;
-		}
-		if (i + 2 < data_len) {
-			value |= (u32)(data[i + 2]) << 16;
-		} else {
-			*ctl &= ~B43_PIO8_TXCTL_16_23;
-			ctl_changed = 1;
-		}
-		if (i + 3 < data_len) {
-			value |= (u32)(data[i + 3]) << 24;
-		} else {
-			*ctl &= ~B43_PIO8_TXCTL_24_31;
-			ctl_changed = 1;
+
+	ctl |= B43_PIO8_TXCTL_0_7 | B43_PIO8_TXCTL_8_15 |
+	       B43_PIO8_TXCTL_16_23 | B43_PIO8_TXCTL_24_31;
+	b43_piotx_write32(q, B43_PIO8_TXCTL, ctl);
+
+	ssb_block_write(dev->dev, data, (data_len & ~3),
+			q->mmio_base + B43_PIO8_TXDATA,
+			sizeof(u32));
+	if (data_len & 3) {
+		u32 value = 0;
+
+		/* Write the last few bytes. */
+		ctl &= ~(B43_PIO8_TXCTL_8_15 | B43_PIO8_TXCTL_16_23 |
+			 B43_PIO8_TXCTL_24_31);
+		data = &(data[data_len - 1]);
+		switch (data_len & 3) {
+		case 3:
+			ctl |= B43_PIO8_TXCTL_16_23;
+			value |= (u32)(*data) << 16;
+			data--;
+		case 2:
+			ctl |= B43_PIO8_TXCTL_8_15;
+			value |= (u32)(*data) << 8;
+			data--;
+		case 1:
+			value |= (u32)(*data);
 		}
-		if (ctl_changed)
-			b43_piotx_write32(q, B43_PIO8_TXCTL, *ctl);
+		b43_piotx_write32(q, B43_PIO8_TXCTL, ctl);
 		b43_piotx_write32(q, B43_PIO8_TXDATA, value);
 	}
+
+	return ctl;
 }
 
 static void pio_tx_frame_4byte_queue(struct b43_pio_txpacket *pack,
 				     const u8 *hdr, unsigned int hdrlen)
 {
 	struct b43_pio_txqueue *q = pack->queue;
@@ -431,15 +434,15 @@ static void pio_tx_frame_4byte_queue(str
 
 	ctl = b43_piotx_read32(q, B43_PIO8_TXCTL);
 	ctl |= B43_PIO8_TXCTL_FREADY;
 	ctl &= ~B43_PIO8_TXCTL_EOF;
 
 	/* Transfer the header data. */
-	tx_write_4byte_queue(q, &ctl, hdr, hdrlen);
+	ctl = tx_write_4byte_queue(q, ctl, hdr, hdrlen);
 	/* Transfer the frame data. */
-	tx_write_4byte_queue(q, &ctl, frame, frame_len);
+	ctl = tx_write_4byte_queue(q, ctl, frame, frame_len);
 
 	ctl |= B43_PIO8_TXCTL_EOF;
 	b43_piotx_write32(q, B43_PIO_TXCTL, ctl);
 }
 
 static int pio_tx_frame(struct b43_pio_txqueue *q,
@@ -624,12 +627,13 @@ void b43_pio_get_tx_stats(struct b43_wld
 	}
 }
 
 /* Returns whether we should fetch another frame. */
 static bool pio_rx_frame(struct b43_pio_rxqueue *q)
 {
+	struct b43_wldev *dev = q->dev;
 	struct b43_rxhdr_fw4 rxhdr;
 	u16 len;
 	u32 macstat;
 	unsigned int i, padding;
 	struct sk_buff *skb;
 	const char *err_msg = NULL;
@@ -669,27 +673,19 @@ static bool pio_rx_frame(struct b43_pio_
 	b43dbg(q->dev->wl, "PIO RX timed out\n");
 	return 1;
 data_ready:
 
 	/* Get the preamble (RX header) */
 	if (q->rev >= 8) {
-		u32 *preamble = (u32 *)&rxhdr;
-		u32 value;
-
-		for (i = 0; i < sizeof(rxhdr); i += 4) {
-			value = b43_piorx_read32(q, B43_PIO8_RXDATA);
-			preamble[i / 4] = cpu_to_le32(value);
-		}
+		ssb_block_read(dev->dev, &rxhdr, sizeof(rxhdr),
+			       q->mmio_base + B43_PIO8_RXDATA,
+			       sizeof(u32));
 	} else {
-		u16 *preamble = (u16 *)&rxhdr;
-		u16 value;
-
-		for (i = 0; i < sizeof(rxhdr); i += 2) {
-			value = b43_piorx_read16(q, B43_PIO_RXDATA);
-			preamble[i / 2] = cpu_to_le16(value);
-		}
+		ssb_block_read(dev->dev, &rxhdr, sizeof(rxhdr),
+			       q->mmio_base + B43_PIO_RXDATA,
+			       sizeof(u16));
 	}
 	/* Sanity checks. */
 	len = le16_to_cpu(rxhdr.frame_len);
 	if (unlikely(len > 0x700)) {
 		err_msg = "len > 0x700";
 		goto rx_error;
@@ -717,32 +713,43 @@ data_ready:
 		err_msg = "Out of memory";
 		goto rx_error;
 	}
 	skb_reserve(skb, 2);
 	skb_put(skb, len + padding);
 	if (q->rev >= 8) {
-		u32 value;
+		ssb_block_read(dev->dev, skb->data + padding, (len & ~3),
+			       q->mmio_base + B43_PIO8_RXDATA,
+			       sizeof(u32));
+		if (len & 3) {
+			u32 value;
+			char *data;
 
-		for (i = padding; i < len + padding; i += 4) {
+			/* Read the last few bytes. */
 			value = b43_piorx_read32(q, B43_PIO8_RXDATA);
-			skb->data[i] = value;
-			if ((i + 1) < (len + padding))
-				skb->data[i + 1] = value >> 8;
-			if ((i + 2) < (len + padding))
-				skb->data[i + 2] = value >> 16;
-			if ((i + 3) < (len + padding))
-				skb->data[i + 3] = value >> 24;
+			data = &(skb->data[len + padding - 1]);
+			switch (len & 3) {
+			case 3:
+				*data = (value >> 16);
+				data--;
+			case 2:
+				*data = (value >> 8);
+				data--;
+			case 1:
+				*data = value;
+			}
 		}
 	} else {
-		u16 value;
+		ssb_block_read(dev->dev, skb->data + padding, (len & ~1),
+			       q->mmio_base + B43_PIO_RXDATA,
+			       sizeof(u16));
+		if (len & 1) {
+			u16 value;
 
-		for (i = padding; i < len + padding; i += 2) {
+			/* Read the last byte. */
 			value = b43_piorx_read16(q, B43_PIO_RXDATA);
-			skb->data[i] = value;
-			if ((i + 1) < (len + padding))
-				skb->data[i + 1] = value >> 8;
+			skb->data[len + padding - 1] = value;
 		}
 	}
 
 	b43_rx(q->dev, skb, &rxhdr);
 
 	return 1;
Index: wireless-testing/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Kconfig	2008-03-30 18:19:24.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/Kconfig	2008-03-30 18:21:34.000000000 +0200
@@ -64,12 +64,13 @@ config B43_PCMCIA
 
 # Data transfers to the device via PIO
 # This is only needed on PCMCIA devices. All others can do DMA properly.
 config B43_PIO
 	bool
 	depends on B43 && (B43_PCMCIA || B43_FORCE_PIO)
+	select SSB_BLOCKIO
 	default y
 
 config B43_NPHY
 	bool "Pre IEEE 802.11n support (BROKEN)"
 	depends on B43 && EXPERIMENTAL
 	---help---
