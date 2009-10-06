Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp122.mail.ukl.yahoo.com ([77.238.184.53]:40498 "HELO
	smtp122.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755993AbZJFQVa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 12:21:30 -0400
From: Albert Herranz <albert_herranz@yahoo.es>
To: bcm43xx-dev@lists.berlios.de, mb@bu3sch.de
Cc: linux-wireless@vger.kernel.org,
	Albert Herranz <albert_herranz@yahoo.es>
Subject: [PATCH] b43: do not stack-allocate pio rx/tx header buffers
Date: Tue,  6 Oct 2009 18:20:43 +0200
Message-Id: <1254846043-7121-1-git-send-email-albert_herranz@yahoo.es>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DMA-API debugging facility complains about b43 mapping memory from
stack for SDIO-based cards, as can be seen in the following two
stack traces.

  Call Trace:
  [d2ef7c60] [c01c55f0] check_for_stack+0xf4/0x10c (unreliable)
  [d2ef7c80] [c01c6d10] debug_dma_map_sg+0xc4/0x134
  [d2ef7cb0] [c0281e10] sdhci_prepare_data+0x200/0x590
  [d2ef7ce0] [c0282288] sdhci_send_command+0xe8/0x320
  [d2ef7d00] [c02825e0] sdhci_request+0x120/0x1b4
  [d2ef7d20] [c0277ad4] mmc_wait_for_req+0x124/0x140
  [d2ef7d50] [c027c2f0] mmc_io_rw_extended+0x188/0x214
  [d2ef7e10] [c027d7c4] sdio_io_rw_ext_helper+0x104/0x224
  [d2ef7e40] [c0296000] ssb_sdio_block_read+0xac/0x110
  [d2ef7e60] [c0237f98] pio_rx_frame+0x1d0/0x43c
  [d2ef7eb0] [c0238244] b43_pio_rx+0x40/0x90
  [d2ef7ed0] [c0226124] b43_do_interrupt_thread+0x108/0x444
  [d2ef7f30] [c0226504] b43_sdio_interrupt_handler+0x58/0x74
  [d2ef7f40] [c0239110] b43_sdio_interrupt_dispatcher+0x4c/0x68
  [d2ef7f60] [c027e1ac] sdio_irq_thread+0xf8/0x284
  [d2ef7fb0] [c0054538] kthread+0x78/0x7c
  [d2ef7ff0] [c00124ec] kernel_thread+0x4c/0x68

  Call Trace:
  [d3335c20] [c01c55f0] check_for_stack+0xf4/0x10c (unreliable)
  [d3335c40] [c01c6d10] debug_dma_map_sg+0xc4/0x134
  [d3335c70] [c0281e14] sdhci_prepare_data+0x200/0x590
  [d3335ca0] [c028228c] sdhci_send_command+0xe8/0x320
  [d3335cc0] [c02825e4] sdhci_request+0x120/0x1b4
  [d3335ce0] [c0277ad8] mmc_wait_for_req+0x124/0x140
  [d3335d10] [c027c2f4] mmc_io_rw_extended+0x188/0x214
  [d3335dd0] [c027d86c] sdio_io_rw_ext_helper+0x1a8/0x224
  [d3335e00] [c0295ef4] ssb_sdio_block_write+0xac/0x110
  [d3335e20] [c0237a18] tx_write_4byte_queue+0x6c/0x138
  [d3335e40] [c0238610] pio_tx_frame+0x1c4/0x224
  [d3335ee0] [c0238718] b43_pio_tx+0xa8/0x1f4
  [d3335f00] [c0220380] b43_tx_work+0x4c/0xe0
  [d3335f20] [c004fa74] run_workqueue+0x120/0x1a4
  [d3335f70] [c004fb44] worker_thread+0x4c/0xb0
  [d3335fb0] [c0054538] kthread+0x78/0x7c
  [d3335ff0] [c00124ec] kernel_thread+0x4c/0x68

Indeed, b43 currently allocates the PIO RX and TX header buffers
from stack. The solution here is to use heap-allocated buffers instead.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
---
 drivers/net/wireless/b43/b43.h |    9 ++++++++
 drivers/net/wireless/b43/pio.c |   42 +++++++++++++++++++++++++++------------
 2 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index fa1549a..b09dda1 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -550,6 +550,9 @@ struct b43_dma {
 struct b43_pio_txqueue;
 struct b43_pio_rxqueue;
 
+struct b43_rxhdr_fw4;
+struct b43_txhdr;
+
 /* Data structures for PIO transmission, per 80211 core. */
 struct b43_pio {
 	struct b43_pio_txqueue *tx_queue_AC_BK; /* Background */
@@ -559,6 +562,12 @@ struct b43_pio {
 	struct b43_pio_txqueue *tx_queue_mcast; /* Multicast */
 
 	struct b43_pio_rxqueue *rx_queue;
+
+	/*
+	 * RX/TX header buffers used by the frame transmit functions.
+	 */
+	struct b43_rxhdr_fw4 *rxhdr;
+	struct b43_txhdr *txhdr;
 };
 
 /* Context information for a noise calculation (Link Quality). */
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index e96091b..45aa6e2 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -241,6 +241,9 @@ void b43_pio_free(struct b43_wldev *dev)
 	destroy_queue_tx(pio, tx_queue_AC_VI);
 	destroy_queue_tx(pio, tx_queue_AC_BE);
 	destroy_queue_tx(pio, tx_queue_AC_BK);
+
+	kfree(pio->rxhdr);
+	kfree(pio->txhdr);
 }
 
 int b43_pio_init(struct b43_wldev *dev)
@@ -276,11 +279,23 @@ int b43_pio_init(struct b43_wldev *dev)
 	if (!pio->rx_queue)
 		goto err_destroy_mcast;
 
+	pio->rxhdr = kzalloc(sizeof(*pio->rxhdr), GFP_KERNEL);
+	if (!pio->rxhdr)
+		goto err_destroy_rx;
+
+	pio->txhdr = kzalloc(sizeof(*pio->txhdr), GFP_KERNEL);
+	if (!pio->txhdr)
+		goto err_destroy_rxhdr;
+
 	b43dbg(dev->wl, "PIO initialized\n");
 	err = 0;
 out:
 	return err;
 
+err_destroy_rxhdr:
+	kfree(pio->rxhdr);
+err_destroy_rx:
+	destroy_queue_rx(pio, rx_queue);
 err_destroy_mcast:
 	destroy_queue_tx(pio, tx_queue_mcast);
 err_destroy_vo:
@@ -435,8 +450,9 @@ static void pio_tx_frame_4byte_queue(struct b43_pio_txpacket *pack,
 static int pio_tx_frame(struct b43_pio_txqueue *q,
 			struct sk_buff *skb)
 {
+	struct b43_wldev *dev = q->dev;
+	struct b43_pio *pio = &dev->pio;
 	struct b43_pio_txpacket *pack;
-	struct b43_txhdr txhdr;
 	u16 cookie;
 	int err;
 	unsigned int hdrlen;
@@ -447,8 +463,8 @@ static int pio_tx_frame(struct b43_pio_txqueue *q,
 			  struct b43_pio_txpacket, list);
 
 	cookie = generate_cookie(q, pack);
-	hdrlen = b43_txhdr_size(q->dev);
-	err = b43_generate_txhdr(q->dev, (u8 *)&txhdr, skb,
+	hdrlen = b43_txhdr_size(dev);
+	err = b43_generate_txhdr(dev, (u8 *)pio->txhdr, skb,
 				 info, cookie);
 	if (err)
 		return err;
@@ -456,15 +472,15 @@ static int pio_tx_frame(struct b43_pio_txqueue *q,
 	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
 		/* Tell the firmware about the cookie of the last
 		 * mcast frame, so it can clear the more-data bit in it. */
-		b43_shm_write16(q->dev, B43_SHM_SHARED,
+		b43_shm_write16(dev, B43_SHM_SHARED,
 				B43_SHM_SH_MCASTCOOKIE, cookie);
 	}
 
 	pack->skb = skb;
 	if (q->rev >= 8)
-		pio_tx_frame_4byte_queue(pack, (const u8 *)&txhdr, hdrlen);
+		pio_tx_frame_4byte_queue(pack, (const u8 *)pio->txhdr, hdrlen);
 	else
-		pio_tx_frame_2byte_queue(pack, (const u8 *)&txhdr, hdrlen);
+		pio_tx_frame_2byte_queue(pack, (const u8 *)pio->txhdr, hdrlen);
 
 	/* Remove it from the list of available packet slots.
 	 * It will be put back when we receive the status report. */
@@ -604,14 +620,14 @@ void b43_pio_get_tx_stats(struct b43_wldev *dev,
 static bool pio_rx_frame(struct b43_pio_rxqueue *q)
 {
 	struct b43_wldev *dev = q->dev;
-	struct b43_rxhdr_fw4 rxhdr;
+	struct b43_pio *pio = &dev->pio;
 	u16 len;
 	u32 macstat;
 	unsigned int i, padding;
 	struct sk_buff *skb;
 	const char *err_msg = NULL;
 
-	memset(&rxhdr, 0, sizeof(rxhdr));
+	memset(pio->rxhdr, 0, sizeof(*pio->rxhdr));
 
 	/* Check if we have data and wait for it to get ready. */
 	if (q->rev >= 8) {
@@ -649,16 +665,16 @@ data_ready:
 
 	/* Get the preamble (RX header) */
 	if (q->rev >= 8) {
-		ssb_block_read(dev->dev, &rxhdr, sizeof(rxhdr),
+		ssb_block_read(dev->dev, pio->rxhdr, sizeof(*pio->rxhdr),
 			       q->mmio_base + B43_PIO8_RXDATA,
 			       sizeof(u32));
 	} else {
-		ssb_block_read(dev->dev, &rxhdr, sizeof(rxhdr),
+		ssb_block_read(dev->dev, pio->rxhdr, sizeof(*pio->rxhdr),
 			       q->mmio_base + B43_PIO_RXDATA,
 			       sizeof(u16));
 	}
 	/* Sanity checks. */
-	len = le16_to_cpu(rxhdr.frame_len);
+	len = le16_to_cpu(pio->rxhdr->frame_len);
 	if (unlikely(len > 0x700)) {
 		err_msg = "len > 0x700";
 		goto rx_error;
@@ -668,7 +684,7 @@ data_ready:
 		goto rx_error;
 	}
 
-	macstat = le32_to_cpu(rxhdr.mac_status);
+	macstat = le32_to_cpu(pio->rxhdr->mac_status);
 	if (macstat & B43_RX_MAC_FCSERR) {
 		if (!(q->dev->wl->filter_flags & FIF_FCSFAIL)) {
 			/* Drop frames with failed FCS. */
@@ -723,7 +739,7 @@ data_ready:
 		}
 	}
 
-	b43_rx(q->dev, skb, &rxhdr);
+	b43_rx(q->dev, skb, pio->rxhdr);
 
 	return 1;
 
-- 
1.6.0.4

