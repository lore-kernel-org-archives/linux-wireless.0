Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27729 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbYLCDP1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 22:15:27 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 19:15:27 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 1/2] ath9k: Check for pci_map_single() errors
Date: Tue, 2 Dec 2008 19:15:23 -0800
Message-ID: <1228274124-25140-2-git-send-email-lrodriguez@atheros.com> (sfid-20081203_041530_551474_453CF652)
In-Reply-To: <1228274124-25140-1-git-send-email-lrodriguez@atheros.com>
References: <1228274124-25140-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pci_map_single() can fail so detect those errors with
pci_dma_mapping_error() and deal with them accordingly.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |   16 +++++++++++++++-
 drivers/net/wireless/ath9k/recv.c   |   17 +++++++++++++++++
 drivers/net/wireless/ath9k/xmit.c   |   23 +++++++++++++++++++++--
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index e80d9b9..bc75f64 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -192,6 +192,13 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 		pci_map_single(sc->pdev, skb->data,
 			       skb->len,
 			       PCI_DMA_TODEVICE);
+	if (unlikely(pci_dma_mapping_error(sc->pdev, bf->bf_buf_addr))) {
+		dev_kfree_skb_any(skb);
+		bf->bf_mpdu = NULL;
+		DPRINTF(sc, ATH_DBG_CONFIG,
+			"pci_dma_mapping_error() on beaconing\n");
+		return NULL;
+	}
 
 	skb = ieee80211_get_buffered_bc(sc->hw, vif);
 
@@ -396,11 +403,18 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 		memcpy(&hdr[1], &val, sizeof(val));
 	}
 
+	bf->bf_mpdu = skb;
 	bf->bf_buf_addr = bf->bf_dmacontext =
 		pci_map_single(sc->pdev, skb->data,
 			       skb->len,
 			       PCI_DMA_TODEVICE);
-	bf->bf_mpdu = skb;
+	if (unlikely(pci_dma_mapping_error(sc->pdev, bf->bf_buf_addr))) {
+		dev_kfree_skb_any(skb);
+		bf->bf_mpdu = NULL;
+		DPRINTF(sc, ATH_DBG_CONFIG,
+			"pci_dma_mapping_error() on beacon alloc\n");
+		return -ENOMEM;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index ba6194a..35ab3bb 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -309,6 +309,15 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 			bf->bf_buf_addr = pci_map_single(sc->pdev, skb->data,
 					 sc->sc_rxbufsize,
 					 PCI_DMA_FROMDEVICE);
+			if (unlikely(pci_dma_mapping_error(sc->pdev,
+				  bf->bf_buf_addr))) {
+				dev_kfree_skb_any(skb);
+				bf->bf_mpdu = NULL;
+				DPRINTF(sc, ATH_DBG_CONFIG,
+					"pci_dma_mapping_error() on RX init\n");
+				error = -ENOMEM;
+				break;
+			}
 			bf->bf_dmacontext = bf->bf_buf_addr;
 		}
 		sc->sc_rxlink = NULL;
@@ -594,6 +603,14 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		bf->bf_buf_addr = pci_map_single(sc->pdev, requeue_skb->data,
 					 sc->sc_rxbufsize,
 					 PCI_DMA_FROMDEVICE);
+		if (unlikely(pci_dma_mapping_error(sc->pdev,
+			  bf->bf_buf_addr))) {
+			dev_kfree_skb_any(requeue_skb);
+			bf->bf_mpdu = NULL;
+			DPRINTF(sc, ATH_DBG_CONFIG,
+				"pci_dma_mapping_error() on RX\n");
+			break;
+		}
 		bf->bf_dmacontext = bf->bf_buf_addr;
 
 		/*
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 413fbdd..ef209b5 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1653,7 +1653,7 @@ static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 	}
 }
 
-static void ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
+static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 				struct sk_buff *skb,
 				struct ath_tx_control *txctl)
 {
@@ -1712,9 +1712,18 @@ static void ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 	/* DMA setup */
 
 	bf->bf_mpdu = skb;
+
 	bf->bf_dmacontext = pci_map_single(sc->pdev, skb->data,
 					   skb->len, PCI_DMA_TODEVICE);
+	if (unlikely(pci_dma_mapping_error(sc->pdev, bf->bf_dmacontext))) {
+		bf->bf_mpdu = NULL;
+		DPRINTF(sc, ATH_DBG_CONFIG,
+			"pci_dma_mapping_error() on TX\n");
+		return -ENOMEM;
+	}
+
 	bf->bf_buf_addr = bf->bf_dmacontext;
+	return 0;
 }
 
 /* FIXME: tx power */
@@ -1786,10 +1795,12 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	spin_unlock_bh(&txctl->txq->axq_lock);
 }
 
+/* Upon failure caller should free skb */
 int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
 		 struct ath_tx_control *txctl)
 {
 	struct ath_buf *bf;
+	int r;
 
 	/* Check if a tx buffer is available */
 
@@ -1800,7 +1811,15 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
 		return -1;
 	}
 
-	ath_tx_setup_buffer(sc, bf, skb, txctl);
+	r = ath_tx_setup_buffer(sc, bf, skb, txctl);
+	if (r) {
+		spin_lock_bh(&sc->sc_txbuflock);
+		DPRINTF(sc, ATH_DBG_FATAL, "TX mem alloc failure\n");
+		list_add_tail(&bf->list, &sc->sc_txbuf);
+		spin_unlock_bh(&sc->sc_txbuflock);
+		return r;
+	}
+
 	ath_tx_start_dma(sc, bf, txctl);
 
 	return 0;
-- 
1.5.6.rc2.15.g457bb.dirty

