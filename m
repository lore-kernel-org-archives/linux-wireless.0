Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab0DOVjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:44 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v3 43/97] ath9k: Add Rx EDMA support
Date: Thu, 15 Apr 2010 17:38:48 -0400
Message-Id: <1271367582-992-44-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    3 +
 drivers/net/wireless/ath/ath9k/ath9k.h      |   10 +-
 drivers/net/wireless/ath/ath9k/hw.h         |    2 +
 drivers/net/wireless/ath/ath9k/main.c       |   40 ++-
 drivers/net/wireless/ath/ath9k/recv.c       |  517 +++++++++++++++++++++------
 5 files changed, 459 insertions(+), 113 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index f28adb2..b229597 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -72,6 +72,9 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 	if ((rxsp->ds_info & (AR_TxRxDesc | AR_CtrlStat)) != 0)
 		return -EINPROGRESS;
 
+	if (!rxs)
+		return 0;
+
 	rxs->rs_status = 0;
 	rxs->rs_flags =  0;
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index bdcd257..a11d830 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -223,6 +223,12 @@ struct ath_tx {
 	struct ath_descdma txdma;
 };
 
+struct ath_rx_edma {
+	struct sk_buff_head rx_fifo;
+	struct sk_buff_head rx_buffers;
+	u32 rx_fifo_hwsize;
+};
+
 struct ath_rx {
 	u8 defant;
 	u8 rxotherant;
@@ -232,6 +238,8 @@ struct ath_rx {
 	spinlock_t rxbuflock;
 	struct list_head rxbuf;
 	struct ath_descdma rxdma;
+	struct ath_buf *rx_bufptr;
+	struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
 };
 
 int ath_startrecv(struct ath_softc *sc);
@@ -240,7 +248,7 @@ void ath_flushrecv(struct ath_softc *sc);
 u32 ath_calcrxfilter(struct ath_softc *sc);
 int ath_rx_init(struct ath_softc *sc, int nbufs);
 void ath_rx_cleanup(struct ath_softc *sc);
-int ath_rx_tasklet(struct ath_softc *sc, int flush);
+int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp);
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype);
 void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_setup(struct ath_softc *sc, int haltype);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c02f46e..1eceda2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -246,6 +246,8 @@ struct ath9k_ops_config {
 enum ath9k_int {
 	ATH9K_INT_RX = 0x00000001,
 	ATH9K_INT_RXDESC = 0x00000002,
+	ATH9K_INT_RXHP = 0x00000001,
+	ATH9K_INT_RXLP = 0x00000002,
 	ATH9K_INT_RXNOFRM = 0x00000008,
 	ATH9K_INT_RXEOL = 0x00000010,
 	ATH9K_INT_RXORN = 0x00000020,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 494456c..92f6fdc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -401,6 +401,7 @@ void ath9k_tasklet(unsigned long data)
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	u32 status = sc->intrstatus;
+	u32 rxmask;
 
 	ath9k_ps_wakeup(sc);
 
@@ -410,9 +411,21 @@ void ath9k_tasklet(unsigned long data)
 		return;
 	}
 
-	if (status & (ATH9K_INT_RX | ATH9K_INT_RXEOL | ATH9K_INT_RXORN)) {
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+		rxmask = (ATH9K_INT_RXHP | ATH9K_INT_RXLP | ATH9K_INT_RXEOL |
+			  ATH9K_INT_RXORN);
+	else
+		rxmask = (ATH9K_INT_RX | ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
+
+	if (status & rxmask) {
 		spin_lock_bh(&sc->rx.rxflushlock);
-		ath_rx_tasklet(sc, 0);
+
+		/* Check for high priority Rx first */
+		if ((ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
+		    (status & ATH9K_INT_RXHP))
+			ath_rx_tasklet(sc, 0, true);
+
+		ath_rx_tasklet(sc, 0, false);
 		spin_unlock_bh(&sc->rx.rxflushlock);
 	}
 
@@ -445,6 +458,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 		ATH9K_INT_RXORN |		\
 		ATH9K_INT_RXEOL |		\
 		ATH9K_INT_RX |			\
+		ATH9K_INT_RXLP |		\
+		ATH9K_INT_RXHP |		\
 		ATH9K_INT_TX |			\
 		ATH9K_INT_BMISS |		\
 		ATH9K_INT_CST |			\
@@ -496,7 +511,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 	 * If a FATAL or RXORN interrupt is received, we have to reset the
 	 * chip immediately.
 	 */
-	if (status & (ATH9K_INT_FATAL | ATH9K_INT_RXORN))
+	if ((status & ATH9K_INT_FATAL) || ((status & ATH9K_INT_RXORN) &&
+	    !(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)))
 		goto chip_reset;
 
 	if (status & ATH9K_INT_SWBA)
@@ -505,6 +521,13 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (status & ATH9K_INT_TXURN)
 		ath9k_hw_updatetxtriglevel(ah, true);
 
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		if (status & ATH9K_INT_RXEOL) {
+			ah->imask &= ~(ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
+			ath9k_hw_set_interrupts(ah, ah->imask);
+		}
+	}
+
 	if (status & ATH9K_INT_MIB) {
 		/*
 		 * Disable interrupts until we service the MIB
@@ -1162,9 +1185,14 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	}
 
 	/* Setup our intr mask. */
-	ah->imask = ATH9K_INT_RX | ATH9K_INT_TX
-		| ATH9K_INT_RXEOL | ATH9K_INT_RXORN
-		| ATH9K_INT_FATAL | ATH9K_INT_GLOBAL;
+	ah->imask = ATH9K_INT_TX | ATH9K_INT_RXEOL |
+		    ATH9K_INT_RXORN | ATH9K_INT_FATAL |
+		    ATH9K_INT_GLOBAL;
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+		ah->imask |= ATH9K_INT_RXHP | ATH9K_INT_RXLP;
+	else
+		ah->imask |= ATH9K_INT_RX;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_GTT)
 		ah->imask |= ATH9K_INT_GTT;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 94560e2..ffb599c 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -16,6 +16,8 @@
 
 #include "ath9k.h"
 
+#define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
+
 static struct ieee80211_hw * ath_get_virt_hw(struct ath_softc *sc,
 					     struct ieee80211_hdr *hdr)
 {
@@ -115,56 +117,246 @@ static void ath_opmode_init(struct ath_softc *sc)
 	ath9k_hw_setmcastfilter(ah, mfilt[0], mfilt[1]);
 }
 
-int ath_rx_init(struct ath_softc *sc, int nbufs)
+static bool ath_rx_edma_buf_link(struct ath_softc *sc,
+				 enum ath9k_rx_qtype qtype)
 {
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_rx_edma *rx_edma;
 	struct sk_buff *skb;
 	struct ath_buf *bf;
-	int error = 0;
 
-	spin_lock_init(&sc->rx.rxflushlock);
-	sc->sc_flags &= ~SC_OP_RXFLUSH;
-	spin_lock_init(&sc->rx.rxbuflock);
+	rx_edma = &sc->rx.rx_edma[qtype];
+	if (skb_queue_len(&rx_edma->rx_fifo) >= rx_edma->rx_fifo_hwsize)
+		return false;
 
-	common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
-				     min(common->cachelsz, (u16)64));
+	bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
+	list_del_init(&bf->list);
 
-	ath_print(common, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
-		  common->cachelsz, common->rx_bufsize);
+	skb = bf->bf_mpdu;
+
+	ATH_RXBUF_RESET(bf);
+	memset(skb->data, 0, ah->caps.rx_status_len);
+	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+				ah->caps.rx_status_len, DMA_TO_DEVICE);
 
-	/* Initialize rx descriptors */
+	SKB_CB_ATHBUF(skb) = bf;
+	ath9k_hw_addrxbuf_edma(ah, bf->bf_buf_addr, qtype);
+	skb_queue_tail(&rx_edma->rx_fifo, skb);
 
-	error = ath_descdma_setup(sc, &sc->rx.rxdma, &sc->rx.rxbuf,
-				  "rx", nbufs, 1);
-	if (error != 0) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "failed to allocate rx descriptors: %d\n", error);
-		goto err;
+	return true;
+}
+
+static void ath_rx_addbuffer_edma(struct ath_softc *sc,
+				  enum ath9k_rx_qtype qtype, int size)
+{
+	struct ath_rx_edma *rx_edma;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	u32 nbuf = 0;
+
+	rx_edma = &sc->rx.rx_edma[qtype];
+	if (list_empty(&sc->rx.rxbuf)) {
+		ath_print(common, ATH_DBG_QUEUE, "No free rx buf available\n");
+		return;
 	}
 
+	while (!list_empty(&sc->rx.rxbuf)) {
+		nbuf++;
+
+		if (!ath_rx_edma_buf_link(sc, qtype))
+			break;
+
+		if (nbuf >= size)
+			break;
+	}
+}
+
+static void ath_rx_remove_buffer(struct ath_softc *sc,
+				 enum ath9k_rx_qtype qtype)
+{
+	struct ath_buf *bf;
+	struct ath_rx_edma *rx_edma;
+	struct sk_buff *skb;
+
+	rx_edma = &sc->rx.rx_edma[qtype];
+
+	while ((skb = skb_dequeue(&rx_edma->rx_fifo)) != NULL) {
+		bf = SKB_CB_ATHBUF(skb);
+		BUG_ON(!bf);
+		list_add_tail(&bf->list, &sc->rx.rxbuf);
+	}
+}
+
+static void ath_rx_edma_cleanup(struct ath_softc *sc)
+{
+	struct ath_buf *bf;
+
+	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_LP);
+	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_HP);
+
 	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
+		if (bf->bf_mpdu)
+			dev_kfree_skb_any(bf->bf_mpdu);
+	}
+
+	INIT_LIST_HEAD(&sc->rx.rxbuf);
+
+	kfree(sc->rx.rx_bufptr);
+	sc->rx.rx_bufptr = NULL;
+}
+
+static void ath_rx_edma_init_queue(struct ath_rx_edma *rx_edma, int size)
+{
+	skb_queue_head_init(&rx_edma->rx_fifo);
+	skb_queue_head_init(&rx_edma->rx_buffers);
+	rx_edma->rx_fifo_hwsize = size;
+}
+
+static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
+	struct sk_buff *skb;
+	struct ath_buf *bf;
+	int error = 0, i;
+	u32 size;
+
+
+	common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN +
+				     ah->caps.rx_status_len,
+				     min(common->cachelsz, (u16)64));
+
+	ath9k_hw_set_rx_bufsize(ah, common->rx_bufsize -
+				    ah->caps.rx_status_len);
+
+	ath_rx_edma_init_queue(&sc->rx.rx_edma[ATH9K_RX_QUEUE_LP],
+			       ah->caps.rx_lp_qdepth);
+	ath_rx_edma_init_queue(&sc->rx.rx_edma[ATH9K_RX_QUEUE_HP],
+			       ah->caps.rx_hp_qdepth);
+
+	size = sizeof(struct ath_buf) * nbufs;
+	bf = kzalloc(size, GFP_KERNEL);
+	if (!bf)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&sc->rx.rxbuf);
+	sc->rx.rx_bufptr = bf;
+
+	for (i = 0; i < nbufs; i++, bf++) {
 		skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_KERNEL);
-		if (skb == NULL) {
+		if (!skb) {
 			error = -ENOMEM;
-			goto err;
+			goto rx_init_fail;
 		}
 
+		memset(skb->data, 0, common->rx_bufsize);
 		bf->bf_mpdu = skb;
+
 		bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
 						 common->rx_bufsize,
-						 DMA_FROM_DEVICE);
+						 DMA_BIDIRECTIONAL);
 		if (unlikely(dma_mapping_error(sc->dev,
-					       bf->bf_buf_addr))) {
-			dev_kfree_skb_any(skb);
-			bf->bf_mpdu = NULL;
+						bf->bf_buf_addr))) {
+				dev_kfree_skb_any(skb);
+				bf->bf_mpdu = NULL;
+				ath_print(common, ATH_DBG_FATAL,
+					"dma_mapping_error() on RX init\n");
+				error = -ENOMEM;
+				goto rx_init_fail;
+		}
+
+		list_add_tail(&bf->list, &sc->rx.rxbuf);
+	}
+
+	return 0;
+
+rx_init_fail:
+	ath_rx_edma_cleanup(sc);
+	return error;
+}
+
+static void ath_edma_start_recv(struct ath_softc *sc)
+{
+	spin_lock_bh(&sc->rx.rxbuflock);
+
+	ath9k_hw_rxena(sc->sc_ah);
+
+	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_HP,
+			      sc->rx.rx_edma[ATH9K_RX_QUEUE_HP].rx_fifo_hwsize);
+
+	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_LP,
+			      sc->rx.rx_edma[ATH9K_RX_QUEUE_LP].rx_fifo_hwsize);
+
+	spin_unlock_bh(&sc->rx.rxbuflock);
+
+	ath_opmode_init(sc);
+
+	ath9k_hw_startpcureceive(sc->sc_ah);
+}
+
+static void ath_edma_stop_recv(struct ath_softc *sc)
+{
+	spin_lock_bh(&sc->rx.rxbuflock);
+	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_HP);
+	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_LP);
+	spin_unlock_bh(&sc->rx.rxbuflock);
+}
+
+int ath_rx_init(struct ath_softc *sc, int nbufs)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct sk_buff *skb;
+	struct ath_buf *bf;
+	int error = 0;
+
+	spin_lock_init(&sc->rx.rxflushlock);
+	sc->sc_flags &= ~SC_OP_RXFLUSH;
+	spin_lock_init(&sc->rx.rxbuflock);
+
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		return ath_rx_edma_init(sc, nbufs);
+	} else {
+		common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
+				min(common->cachelsz, (u16)64));
+
+		ath_print(common, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
+				common->cachelsz, common->rx_bufsize);
+
+		/* Initialize rx descriptors */
+
+		error = ath_descdma_setup(sc, &sc->rx.rxdma, &sc->rx.rxbuf,
+				"rx", nbufs, 1);
+		if (error != 0) {
 			ath_print(common, ATH_DBG_FATAL,
-				  "dma_mapping_error() on RX init\n");
-			error = -ENOMEM;
+				  "failed to allocate rx descriptors: %d\n",
+				  error);
 			goto err;
 		}
-		bf->bf_dmacontext = bf->bf_buf_addr;
+
+		list_for_each_entry(bf, &sc->rx.rxbuf, list) {
+			skb = ath_rxbuf_alloc(common, common->rx_bufsize,
+					      GFP_KERNEL);
+			if (skb == NULL) {
+				error = -ENOMEM;
+				goto err;
+			}
+
+			bf->bf_mpdu = skb;
+			bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
+					common->rx_bufsize,
+					DMA_FROM_DEVICE);
+			if (unlikely(dma_mapping_error(sc->dev,
+							bf->bf_buf_addr))) {
+				dev_kfree_skb_any(skb);
+				bf->bf_mpdu = NULL;
+				ath_print(common, ATH_DBG_FATAL,
+					  "dma_mapping_error() on RX init\n");
+				error = -ENOMEM;
+				goto err;
+			}
+			bf->bf_dmacontext = bf->bf_buf_addr;
+		}
+		sc->rx.rxlink = NULL;
 	}
-	sc->rx.rxlink = NULL;
 
 err:
 	if (error)
@@ -180,17 +372,23 @@ void ath_rx_cleanup(struct ath_softc *sc)
 	struct sk_buff *skb;
 	struct ath_buf *bf;
 
-	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-		skb = bf->bf_mpdu;
-		if (skb) {
-			dma_unmap_single(sc->dev, bf->bf_buf_addr,
-					 common->rx_bufsize, DMA_FROM_DEVICE);
-			dev_kfree_skb(skb);
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		ath_rx_edma_cleanup(sc);
+		return;
+	} else {
+		list_for_each_entry(bf, &sc->rx.rxbuf, list) {
+			skb = bf->bf_mpdu;
+			if (skb) {
+				dma_unmap_single(sc->dev, bf->bf_buf_addr,
+						common->rx_bufsize,
+						DMA_FROM_DEVICE);
+				dev_kfree_skb(skb);
+			}
 		}
-	}
 
-	if (sc->rx.rxdma.dd_desc_len != 0)
-		ath_descdma_cleanup(sc, &sc->rx.rxdma, &sc->rx.rxbuf);
+		if (sc->rx.rxdma.dd_desc_len != 0)
+			ath_descdma_cleanup(sc, &sc->rx.rxdma, &sc->rx.rxbuf);
+	}
 }
 
 /*
@@ -273,6 +471,11 @@ int ath_startrecv(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf, *tbf;
 
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		ath_edma_start_recv(sc);
+		return 0;
+	}
+
 	spin_lock_bh(&sc->rx.rxbuflock);
 	if (list_empty(&sc->rx.rxbuf))
 		goto start_recv;
@@ -306,7 +509,11 @@ bool ath_stoprecv(struct ath_softc *sc)
 	ath9k_hw_stoppcurecv(ah);
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah);
-	sc->rx.rxlink = NULL;
+
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+		ath_edma_stop_recv(sc);
+	else
+		sc->rx.rxlink = NULL;
 
 	return stopped;
 }
@@ -315,7 +522,9 @@ void ath_flushrecv(struct ath_softc *sc)
 {
 	spin_lock_bh(&sc->rx.rxflushlock);
 	sc->sc_flags |= SC_OP_RXFLUSH;
-	ath_rx_tasklet(sc, 1);
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+		ath_rx_tasklet(sc, 1, true);
+	ath_rx_tasklet(sc, 1, false);
 	sc->sc_flags &= ~SC_OP_RXFLUSH;
 	spin_unlock_bh(&sc->rx.rxflushlock);
 }
@@ -469,14 +678,147 @@ static void ath_rx_send_to_mac80211(struct ieee80211_hw *hw,
 		ieee80211_rx(hw, skb);
 }
 
-int ath_rx_tasklet(struct ath_softc *sc, int flush)
+static bool ath_edma_get_buffers(struct ath_softc *sc,
+				 enum ath9k_rx_qtype qtype)
 {
-#define PA2DESC(_sc, _pa)                                               \
-	((struct ath_desc *)((caddr_t)(_sc)->rx.rxdma.dd_desc +		\
-			     ((_pa) - (_sc)->rx.rxdma.dd_desc_paddr)))
+	struct ath_rx_edma *rx_edma = &sc->rx.rx_edma[qtype];
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct sk_buff *skb;
+	struct ath_buf *bf;
+	int ret;
+
+	skb = skb_peek(&rx_edma->rx_fifo);
+	if (!skb)
+		return false;
+
+	bf = SKB_CB_ATHBUF(skb);
+	BUG_ON(!bf);
+
+	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+				common->rx_bufsize, DMA_FROM_DEVICE);
+
+	ret = ath9k_hw_process_rxdesc_edma(ah, NULL, skb->data);
+	if (ret == -EINPROGRESS)
+		return false;
+
+	__skb_unlink(skb, &rx_edma->rx_fifo);
+	if (ret == -EINVAL) {
+		/* corrupt descriptor, skip this one and the following one */
+		list_add_tail(&bf->list, &sc->rx.rxbuf);
+		ath_rx_edma_buf_link(sc, qtype);
+		skb = skb_peek(&rx_edma->rx_fifo);
+		if (!skb)
+			return true;
+
+		bf = SKB_CB_ATHBUF(skb);
+		BUG_ON(!bf);
+
+		__skb_unlink(skb, &rx_edma->rx_fifo);
+		list_add_tail(&bf->list, &sc->rx.rxbuf);
+		ath_rx_edma_buf_link(sc, qtype);
+	}
+	skb_queue_tail(&rx_edma->rx_buffers, skb);
+
+	return true;
+}
 
+static struct ath_buf *ath_edma_get_next_rx_buf(struct ath_softc *sc,
+						struct ath_rx_status *rs,
+						enum ath9k_rx_qtype qtype)
+{
+	struct ath_rx_edma *rx_edma = &sc->rx.rx_edma[qtype];
+	struct sk_buff *skb;
 	struct ath_buf *bf;
+
+	while (ath_edma_get_buffers(sc, qtype));
+	skb = __skb_dequeue(&rx_edma->rx_buffers);
+	if (!skb)
+		return NULL;
+
+	bf = SKB_CB_ATHBUF(skb);
+	ath9k_hw_process_rxdesc_edma(sc->sc_ah, rs, skb->data);
+	return bf;
+}
+
+static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
+					   struct ath_rx_status *rs)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_desc *ds;
+	struct ath_buf *bf;
+	int ret;
+
+	if (list_empty(&sc->rx.rxbuf)) {
+		sc->rx.rxlink = NULL;
+		return NULL;
+	}
+
+	bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
+	ds = bf->bf_desc;
+
+	/*
+	 * Must provide the virtual address of the current
+	 * descriptor, the physical address, and the virtual
+	 * address of the next descriptor in the h/w chain.
+	 * This allows the HAL to look ahead to see if the
+	 * hardware is done with a descriptor by checking the
+	 * done bit in the following descriptor and the address
+	 * of the current descriptor the DMA engine is working
+	 * on.  All this is necessary because of our use of
+	 * a self-linked list to avoid rx overruns.
+	 */
+	ret = ath9k_hw_rxprocdesc(ah, ds, rs, 0);
+	if (ret == -EINPROGRESS) {
+		struct ath_rx_status trs;
+		struct ath_buf *tbf;
+		struct ath_desc *tds;
+
+		memset(&trs, 0, sizeof(trs));
+		if (list_is_last(&bf->list, &sc->rx.rxbuf)) {
+			sc->rx.rxlink = NULL;
+			return NULL;
+		}
+
+		tbf = list_entry(bf->list.next, struct ath_buf, list);
+
+		/*
+		 * On some hardware the descriptor status words could
+		 * get corrupted, including the done bit. Because of
+		 * this, check if the next descriptor's done bit is
+		 * set or not.
+		 *
+		 * If the next descriptor's done bit is set, the current
+		 * descriptor has been corrupted. Force s/w to discard
+		 * this descriptor and continue...
+		 */
+
+		tds = tbf->bf_desc;
+		ret = ath9k_hw_rxprocdesc(ah, tds, &trs, 0);
+		if (ret == -EINPROGRESS)
+			return NULL;
+	}
+
+	if (!bf->bf_mpdu)
+		return bf;
+
+	/*
+	 * Synchronize the DMA transfer with CPU before
+	 * 1. accessing the frame
+	 * 2. requeueing the same buffer to h/w
+	 */
+	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+			common->rx_bufsize,
+			DMA_FROM_DEVICE);
+
+	return bf;
+}
+
+
+int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
+{
+	struct ath_buf *bf;
 	struct sk_buff *skb = NULL, *requeue_skb;
 	struct ieee80211_rx_status *rxs;
 	struct ath_hw *ah = sc->sc_ah;
@@ -491,7 +833,16 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	int retval;
 	bool decrypt_error = false;
 	struct ath_rx_status rs;
+	enum ath9k_rx_qtype qtype;
+	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
+	int dma_type;
 
+	if (edma)
+		dma_type = DMA_FROM_DEVICE;
+	else
+		dma_type = DMA_BIDIRECTIONAL;
+
+	qtype = hp ? ATH9K_RX_QUEUE_HP : ATH9K_RX_QUEUE_LP;
 	spin_lock_bh(&sc->rx.rxbuflock);
 
 	do {
@@ -499,71 +850,19 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		if ((sc->sc_flags & SC_OP_RXFLUSH) && (flush == 0))
 			break;
 
-		if (list_empty(&sc->rx.rxbuf)) {
-			sc->rx.rxlink = NULL;
-			break;
-		}
-
-		bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
-		ds = bf->bf_desc;
-
-		/*
-		 * Must provide the virtual address of the current
-		 * descriptor, the physical address, and the virtual
-		 * address of the next descriptor in the h/w chain.
-		 * This allows the HAL to look ahead to see if the
-		 * hardware is done with a descriptor by checking the
-		 * done bit in the following descriptor and the address
-		 * of the current descriptor the DMA engine is working
-		 * on.  All this is necessary because of our use of
-		 * a self-linked list to avoid rx overruns.
-		 */
 		memset(&rs, 0, sizeof(rs));
-		retval = ath9k_hw_rxprocdesc(ah, ds, &rs, 0);
-		if (retval == -EINPROGRESS) {
-			struct ath_rx_status trs;
-			struct ath_buf *tbf;
-			struct ath_desc *tds;
-
-			memset(&trs, 0, sizeof(trs));
-			if (list_is_last(&bf->list, &sc->rx.rxbuf)) {
-				sc->rx.rxlink = NULL;
-				break;
-			}
+		if (edma)
+			bf = ath_edma_get_next_rx_buf(sc, &rs, qtype);
+		else
+			bf = ath_get_next_rx_buf(sc, &rs);
 
-			tbf = list_entry(bf->list.next, struct ath_buf, list);
-
-			/*
-			 * On some hardware the descriptor status words could
-			 * get corrupted, including the done bit. Because of
-			 * this, check if the next descriptor's done bit is
-			 * set or not.
-			 *
-			 * If the next descriptor's done bit is set, the current
-			 * descriptor has been corrupted. Force s/w to discard
-			 * this descriptor and continue...
-			 */
-
-			tds = tbf->bf_desc;
-			retval = ath9k_hw_rxprocdesc(ah, tds, &trs, 0);
-			if (retval == -EINPROGRESS) {
-				break;
-			}
-		}
+		if (!bf)
+			break;
 
 		skb = bf->bf_mpdu;
 		if (!skb)
 			continue;
 
-		/*
-		 * Synchronize the DMA transfer with CPU before
-		 * 1. accessing the frame
-		 * 2. requeueing the same buffer to h/w
-		 */
-		dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
-				common->rx_bufsize,
-				DMA_FROM_DEVICE);
-
 		hdr = (struct ieee80211_hdr *) skb->data;
 		rxs =  IEEE80211_SKB_RXCB(skb);
 
@@ -597,9 +896,11 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		/* Unmap the frame */
 		dma_unmap_single(sc->dev, bf->bf_buf_addr,
 				 common->rx_bufsize,
-				 DMA_FROM_DEVICE);
+				 dma_type);
 
-		skb_put(skb, rs.rs_datalen);
+		skb_put(skb, rs.rs_datalen + ah->caps.rx_status_len);
+		if (ah->caps.rx_status_len)
+			skb_pull(skb, ah->caps.rx_status_len);
 
 		ath9k_cmn_rx_skb_postprocess(common, skb, &rs,
 					     rxs, decrypt_error);
@@ -608,7 +909,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		bf->bf_mpdu = requeue_skb;
 		bf->bf_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
 						 common->rx_bufsize,
-						 DMA_FROM_DEVICE);
+						 dma_type);
 		if (unlikely(dma_mapping_error(sc->dev,
 			  bf->bf_buf_addr))) {
 			dev_kfree_skb_any(requeue_skb);
@@ -639,12 +940,16 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		ath_rx_send_to_mac80211(hw, sc, skb, rxs);
 
 requeue:
-		list_move_tail(&bf->list, &sc->rx.rxbuf);
-		ath_rx_buf_link(sc, bf);
+		if (edma) {
+			list_add_tail(&bf->list, &sc->rx.rxbuf);
+			ath_rx_edma_buf_link(sc, qtype);
+		} else {
+			list_move_tail(&bf->list, &sc->rx.rxbuf);
+			ath_rx_buf_link(sc, bf);
+		}
 	} while (1);
 
 	spin_unlock_bh(&sc->rx.rxbuflock);
 
 	return 0;
-#undef PA2DESC
 }
-- 
1.6.3.3

