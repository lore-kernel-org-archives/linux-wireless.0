Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41614 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933214AbZJISeW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 14:34:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Optimize PIO scratchbuffer usage
Date: Fri, 9 Oct 2009 20:33:32 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910092033.32585.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This optimizes the PIO scratchbuffer usage.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-10-09 19:50:15.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-10-09 20:15:41.000000000 +0200
@@ -749,12 +749,6 @@ struct b43_wldev {
 #endif
 };
 
-/*
- * Include goes here to avoid a dependency problem.
- * A better fix would be to integrate xmit.h into b43.h.
- */
-#include "xmit.h"
-
 /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
 struct b43_wl {
 	/* Pointer to the active wireless device on this chip */
@@ -830,13 +824,9 @@ struct b43_wl {
 	struct b43_leds leds;
 
 #ifdef CONFIG_B43_PIO
-	/*
-	 * RX/TX header/tail buffers used by the frame transmit functions.
-	 */
-	struct b43_rxhdr_fw4 rxhdr;
-	struct b43_txhdr txhdr;
-	u8 rx_tail[4];
-	u8 tx_tail[4];
+	/* Kmalloc'ed scratch space for PIO TX/RX. Protected by wl->mutex. */
+	u8 pio_scratchspace[110] __attribute__((__aligned__(8)));
+	u8 pio_tailspace[4] __attribute__((__aligned__(8)));
 #endif /* CONFIG_B43_PIO */
 };
 
Index: wireless-testing/drivers/net/wireless/b43/pio.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/pio.c	2009-10-09 19:50:15.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/pio.c	2009-10-09 20:15:41.000000000 +0200
@@ -341,12 +341,15 @@ static u16 tx_write_2byte_queue(struct b
 			q->mmio_base + B43_PIO_TXDATA,
 			sizeof(u16));
 	if (data_len & 1) {
+		u8 *tail = wl->pio_tailspace;
+		BUILD_BUG_ON(sizeof(wl->pio_tailspace) < 2);
+
 		/* Write the last byte. */
 		ctl &= ~B43_PIO_TXCTL_WRITEHI;
 		b43_piotx_write16(q, B43_PIO_TXCTL, ctl);
-		wl->tx_tail[0] = data[data_len - 1];
-		wl->tx_tail[1] = 0;
-		ssb_block_write(dev->dev, wl->tx_tail, 2,
+		tail[0] = data[data_len - 1];
+		tail[1] = 0;
+		ssb_block_write(dev->dev, tail, 2,
 				q->mmio_base + B43_PIO_TXDATA,
 				sizeof(u16));
 	}
@@ -392,27 +395,27 @@ static u32 tx_write_4byte_queue(struct b
 			q->mmio_base + B43_PIO8_TXDATA,
 			sizeof(u32));
 	if (data_len & 3) {
-		wl->tx_tail[3] = 0;
+		u8 *tail = wl->pio_tailspace;
+		BUILD_BUG_ON(sizeof(wl->pio_tailspace) < 4);
+
+		memset(tail, 0, 4);
 		/* Write the last few bytes. */
 		ctl &= ~(B43_PIO8_TXCTL_8_15 | B43_PIO8_TXCTL_16_23 |
 			 B43_PIO8_TXCTL_24_31);
 		switch (data_len & 3) {
 		case 3:
 			ctl |= B43_PIO8_TXCTL_16_23 | B43_PIO8_TXCTL_8_15;
-			wl->tx_tail[0] = data[data_len - 3];
-			wl->tx_tail[1] = data[data_len - 2];
-			wl->tx_tail[2] = data[data_len - 1];
+			tail[0] = data[data_len - 3];
+			tail[1] = data[data_len - 2];
+			tail[2] = data[data_len - 1];
 			break;
 		case 2:
 			ctl |= B43_PIO8_TXCTL_8_15;
-			wl->tx_tail[0] = data[data_len - 2];
-			wl->tx_tail[1] = data[data_len - 1];
-			wl->tx_tail[2] = 0;
+			tail[0] = data[data_len - 2];
+			tail[1] = data[data_len - 1];
 			break;
 		case 1:
-			wl->tx_tail[0] = data[data_len - 1];
-			wl->tx_tail[1] = 0;
-			wl->tx_tail[2] = 0;
+			tail[0] = data[data_len - 1];
 			break;
 		}
 		b43_piotx_write32(q, B43_PIO8_TXCTL, ctl);
@@ -455,6 +458,7 @@ static int pio_tx_frame(struct b43_pio_t
 	int err;
 	unsigned int hdrlen;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct b43_txhdr *txhdr = (struct b43_txhdr *)wl->pio_scratchspace;
 
 	B43_WARN_ON(list_empty(&q->packets_list));
 	pack = list_entry(q->packets_list.next,
@@ -462,7 +466,9 @@ static int pio_tx_frame(struct b43_pio_t
 
 	cookie = generate_cookie(q, pack);
 	hdrlen = b43_txhdr_size(dev);
-	err = b43_generate_txhdr(dev, (u8 *)&wl->txhdr, skb,
+	BUILD_BUG_ON(sizeof(wl->pio_scratchspace) < sizeof(struct b43_txhdr));
+	B43_WARN_ON(sizeof(wl->pio_scratchspace) < hdrlen);
+	err = b43_generate_txhdr(dev, (u8 *)txhdr, skb,
 				 info, cookie);
 	if (err)
 		return err;
@@ -476,9 +482,9 @@ static int pio_tx_frame(struct b43_pio_t
 
 	pack->skb = skb;
 	if (q->rev >= 8)
-		pio_tx_frame_4byte_queue(pack, (const u8 *)&wl->txhdr, hdrlen);
+		pio_tx_frame_4byte_queue(pack, (const u8 *)txhdr, hdrlen);
 	else
-		pio_tx_frame_2byte_queue(pack, (const u8 *)&wl->txhdr, hdrlen);
+		pio_tx_frame_2byte_queue(pack, (const u8 *)txhdr, hdrlen);
 
 	/* Remove it from the list of available packet slots.
 	 * It will be put back when we receive the status report. */
@@ -624,8 +630,10 @@ static bool pio_rx_frame(struct b43_pio_
 	unsigned int i, padding;
 	struct sk_buff *skb;
 	const char *err_msg = NULL;
+	struct b43_rxhdr *rxhdr = (struct b43_rxhdr *)wl->pio_scratchspace;
 
-	memset(&wl->rxhdr, 0, sizeof(wl->rxhdr));
+	BUILD_BUG_ON(sizeof(wl->pio_scratchspace) < sizeof(*rxhdr));
+	memset(rxhdr, 0, sizeof(*rxhdr));
 
 	/* Check if we have data and wait for it to get ready. */
 	if (q->rev >= 8) {
@@ -663,16 +671,16 @@ data_ready:
 
 	/* Get the preamble (RX header) */
 	if (q->rev >= 8) {
-		ssb_block_read(dev->dev, &wl->rxhdr, sizeof(wl->rxhdr),
+		ssb_block_read(dev->dev, rxhdr, sizeof(*rxhdr),
 			       q->mmio_base + B43_PIO8_RXDATA,
 			       sizeof(u32));
 	} else {
-		ssb_block_read(dev->dev, &wl->rxhdr, sizeof(wl->rxhdr),
+		ssb_block_read(dev->dev, rxhdr, sizeof(*rxhdr),
 			       q->mmio_base + B43_PIO_RXDATA,
 			       sizeof(u16));
 	}
 	/* Sanity checks. */
-	len = le16_to_cpu(wl->rxhdr.frame_len);
+	len = le16_to_cpu(rxhdr->frame_len);
 	if (unlikely(len > 0x700)) {
 		err_msg = "len > 0x700";
 		goto rx_error;
@@ -682,7 +690,7 @@ data_ready:
 		goto rx_error;
 	}
 
-	macstat = le32_to_cpu(wl->rxhdr.mac_status);
+	macstat = le32_to_cpu(rxhdr->mac_status);
 	if (macstat & B43_RX_MAC_FCSERR) {
 		if (!(q->dev->wl->filter_flags & FIF_FCSFAIL)) {
 			/* Drop frames with failed FCS. */
@@ -707,22 +715,25 @@ data_ready:
 			       q->mmio_base + B43_PIO8_RXDATA,
 			       sizeof(u32));
 		if (len & 3) {
+			u8 *tail = wl->pio_tailspace;
+			BUILD_BUG_ON(sizeof(wl->pio_tailspace) < 4);
+
 			/* Read the last few bytes. */
-			ssb_block_read(dev->dev, wl->rx_tail, 4,
+			ssb_block_read(dev->dev, tail, 4,
 				       q->mmio_base + B43_PIO8_RXDATA,
 				       sizeof(u32));
 			switch (len & 3) {
 			case 3:
-				skb->data[len + padding - 3] = wl->rx_tail[0];
-				skb->data[len + padding - 2] = wl->rx_tail[1];
-				skb->data[len + padding - 1] = wl->rx_tail[2];
+				skb->data[len + padding - 3] = tail[0];
+				skb->data[len + padding - 2] = tail[1];
+				skb->data[len + padding - 1] = tail[2];
 				break;
 			case 2:
-				skb->data[len + padding - 2] = wl->rx_tail[0];
-				skb->data[len + padding - 1] = wl->rx_tail[1];
+				skb->data[len + padding - 2] = tail[0];
+				skb->data[len + padding - 1] = tail[1];
 				break;
 			case 1:
-				skb->data[len + padding - 1] = wl->rx_tail[0];
+				skb->data[len + padding - 1] = tail[0];
 				break;
 			}
 		}
@@ -731,15 +742,18 @@ data_ready:
 			       q->mmio_base + B43_PIO_RXDATA,
 			       sizeof(u16));
 		if (len & 1) {
+			u8 *tail = wl->pio_tailspace;
+			BUILD_BUG_ON(sizeof(wl->pio_tailspace) < 2);
+
 			/* Read the last byte. */
-			ssb_block_read(dev->dev, wl->rx_tail, 2,
+			ssb_block_read(dev->dev, tail, 2,
 				       q->mmio_base + B43_PIO_RXDATA,
 				       sizeof(u16));
-			skb->data[len + padding - 1] = wl->rx_tail[0];
+			skb->data[len + padding - 1] = tail[0];
 		}
 	}
 
-	b43_rx(q->dev, skb, &wl->rxhdr);
+	b43_rx(q->dev, skb, rxhdr);
 
 	return 1;
 
Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2009-10-09 19:50:15.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2009-10-09 20:15:41.000000000 +0200
@@ -27,7 +27,7 @@
 
 */
 
-#include "b43.h"
+#include "xmit.h"
 #include "phy_common.h"
 #include "dma.h"
 #include "pio.h"

-- 
Greetings, Michael.
