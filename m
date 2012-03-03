Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40171 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab2CCORS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 09:17:18 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 4/5] ath9k: get rid of double queueing of rx frames on EDMA
Date: Sat,  3 Mar 2012 15:17:05 +0100
Message-Id: <1330784226-65563-4-git-send-email-nbd@openwrt.org> (sfid-20120303_151727_655157_67679B07)
In-Reply-To: <1330784226-65563-3-git-send-email-nbd@openwrt.org>
References: <1330784226-65563-1-git-send-email-nbd@openwrt.org>
 <1330784226-65563-2-git-send-email-nbd@openwrt.org>
 <1330784226-65563-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Process rx status directly instead of separating the completion test from
the actual rx status processing.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   18 +++-------
 drivers/net/wireless/ath/ath9k/ath9k.h      |    1 -
 drivers/net/wireless/ath/ath9k/recv.c       |   47 +++++++++++++--------------
 3 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 8d1bca0..acf2ca2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -440,20 +440,14 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 	struct ar9003_rxs *rxsp = (struct ar9003_rxs *) buf_addr;
 	unsigned int phyerr;
 
-	/* TODO: byte swap on big endian for ar9300_10 */
-
-	if (!rxs) {
-		if ((rxsp->status11 & AR_RxDone) == 0)
-			return -EINPROGRESS;
-
-		if (MS(rxsp->ds_info, AR_DescId) != 0x168c)
-			return -EINVAL;
+	if ((rxsp->status11 & AR_RxDone) == 0)
+		return -EINPROGRESS;
 
-		if ((rxsp->ds_info & (AR_TxRxDesc | AR_CtrlStat)) != 0)
-			return -EINPROGRESS;
+	if (MS(rxsp->ds_info, AR_DescId) != 0x168c)
+		return -EINVAL;
 
-		return 0;
-	}
+	if ((rxsp->ds_info & (AR_TxRxDesc | AR_CtrlStat)) != 0)
+		return -EINPROGRESS;
 
 	rxs->rs_status = 0;
 	rxs->rs_flags =  0;
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index c2ccba6..3d8e51c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -299,7 +299,6 @@ struct ath_tx {
 
 struct ath_rx_edma {
 	struct sk_buff_head rx_fifo;
-	struct sk_buff_head rx_buffers;
 	u32 rx_fifo_hwsize;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 7e1a91a..cdba79f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -232,7 +232,6 @@ static void ath_rx_edma_cleanup(struct ath_softc *sc)
 static void ath_rx_edma_init_queue(struct ath_rx_edma *rx_edma, int size)
 {
 	skb_queue_head_init(&rx_edma->rx_fifo);
-	skb_queue_head_init(&rx_edma->rx_buffers);
 	rx_edma->rx_fifo_hwsize = size;
 }
 
@@ -658,7 +657,9 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb, bool mybeacon)
 }
 
 static bool ath_edma_get_buffers(struct ath_softc *sc,
-				 enum ath9k_rx_qtype qtype)
+				 enum ath9k_rx_qtype qtype,
+				 struct ath_rx_status *rs,
+				 struct ath_buf **dest)
 {
 	struct ath_rx_edma *rx_edma = &sc->rx.rx_edma[qtype];
 	struct ath_hw *ah = sc->sc_ah;
@@ -677,7 +678,7 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
 	dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
 				common->rx_bufsize, DMA_FROM_DEVICE);
 
-	ret = ath9k_hw_process_rxdesc_edma(ah, NULL, skb->data);
+	ret = ath9k_hw_process_rxdesc_edma(ah, rs, skb->data);
 	if (ret == -EINPROGRESS) {
 		/*let device gain the buffer again*/
 		dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
@@ -690,20 +691,21 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
 		/* corrupt descriptor, skip this one and the following one */
 		list_add_tail(&bf->list, &sc->rx.rxbuf);
 		ath_rx_edma_buf_link(sc, qtype);
-		skb = skb_peek(&rx_edma->rx_fifo);
-		if (!skb)
-			return true;
 
-		bf = SKB_CB_ATHBUF(skb);
-		BUG_ON(!bf);
+		skb = skb_peek(&rx_edma->rx_fifo);
+		if (skb) {
+			bf = SKB_CB_ATHBUF(skb);
+			BUG_ON(!bf);
 
-		__skb_unlink(skb, &rx_edma->rx_fifo);
-		list_add_tail(&bf->list, &sc->rx.rxbuf);
-		ath_rx_edma_buf_link(sc, qtype);
-		return true;
+			__skb_unlink(skb, &rx_edma->rx_fifo);
+			list_add_tail(&bf->list, &sc->rx.rxbuf);
+			ath_rx_edma_buf_link(sc, qtype);
+		} else {
+			bf = NULL;
+		}
 	}
-	skb_queue_tail(&rx_edma->rx_buffers, skb);
 
+	*dest = bf;
 	return true;
 }
 
@@ -711,18 +713,15 @@ static struct ath_buf *ath_edma_get_next_rx_buf(struct ath_softc *sc,
 						struct ath_rx_status *rs,
 						enum ath9k_rx_qtype qtype)
 {
-	struct ath_rx_edma *rx_edma = &sc->rx.rx_edma[qtype];
-	struct sk_buff *skb;
-	struct ath_buf *bf;
+	struct ath_buf *bf = NULL;
 
-	while (ath_edma_get_buffers(sc, qtype));
-	skb = __skb_dequeue(&rx_edma->rx_buffers);
-	if (!skb)
-		return NULL;
+	while (ath_edma_get_buffers(sc, qtype, rs, &bf)) {
+		if (!bf)
+			continue;
 
-	bf = SKB_CB_ATHBUF(skb);
-	ath9k_hw_process_rxdesc_edma(sc->sc_ah, rs, skb->data);
-	return bf;
+		return bf;
+	}
+	return NULL;
 }
 
 static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
-- 
1.7.3.2

