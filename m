Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([89.167.52.164]:43666 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab1GKAwu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2011 20:52:50 -0400
Message-Id: <280ad9176e6532f231e054b38b952b20580874c5.1310339688.git.mirq-linux@rere.qmqm.pl> (sfid-20110711_025337_538538_0B4762C2)
In-Reply-To: <cover.1310339688.git.mirq-linux@rere.qmqm.pl>
References: <cover.1310339688.git.mirq-linux@rere.qmqm.pl>
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH v2 07/46] net/wireless: ath9k: fix DMA API usage
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netdev@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Date: Mon, 11 Jul 2011 02:52:47 +0200 (CEST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also constify buf_addr for ath9k_hw_process_rxdesc_edma() to verify
assumptions --- dma_sync_single_for_device() call can be removed.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    4 ++--
 drivers/net/wireless/ath/ath9k/ar9003_mac.h |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c       |   10 +++-------
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 575e185..2d211b6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -524,9 +524,9 @@ void ath9k_hw_addrxbuf_edma(struct ath_hw *ah, u32 rxdp,
 EXPORT_SYMBOL(ath9k_hw_addrxbuf_edma);
 
 int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
-				 void *buf_addr)
+				 const void *buf_addr)
 {
-	struct ar9003_rxs *rxsp = (struct ar9003_rxs *) buf_addr;
+	const struct ar9003_rxs *rxsp = buf_addr;
 	unsigned int phyerr;
 
 	/* TODO: byte swap on big endian for ar9300_10 */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
index c504493..c310edc 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -114,7 +114,7 @@ void ath9k_hw_addrxbuf_edma(struct ath_hw *ah, u32 rxdp,
 
 int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah,
 				 struct ath_rx_status *rxs,
-				 void *buf_addr);
+				 const void *buf_addr);
 void ath9k_hw_reset_txstatus_ring(struct ath_hw *ah);
 void ath9k_hw_setup_statusring(struct ath_hw *ah, void *ts_start,
 			       u32 ts_paddr_start,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 70dc8ec..c5f46d5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -156,7 +156,7 @@ static bool ath_rx_edma_buf_link(struct ath_softc *sc,
 	ATH_RXBUF_RESET(bf);
 	memset(skb->data, 0, ah->caps.rx_status_len);
 	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
-				ah->caps.rx_status_len, DMA_TO_DEVICE);
+				ah->caps.rx_status_len, DMA_BIDIRECTIONAL);
 
 	SKB_CB_ATHBUF(skb) = bf;
 	ath9k_hw_addrxbuf_edma(ah, bf->bf_buf_addr, qtype);
@@ -684,15 +684,11 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
 	BUG_ON(!bf);
 
 	dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
-				common->rx_bufsize, DMA_FROM_DEVICE);
+				common->rx_bufsize, DMA_BIDIRECTIONAL);
 
 	ret = ath9k_hw_process_rxdesc_edma(ah, NULL, skb->data);
-	if (ret == -EINPROGRESS) {
-		/*let device gain the buffer again*/
-		dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
-				common->rx_bufsize, DMA_FROM_DEVICE);
+	if (ret == -EINPROGRESS)
 		return false;
-	}
 
 	__skb_unlink(skb, &rx_edma->rx_fifo);
 	if (ret == -EINVAL) {
-- 
1.7.5.4

