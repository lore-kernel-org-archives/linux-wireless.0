Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59708 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab3DWGye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 02:54:34 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] ath9k: Reduce deep indentation
Date: Tue, 23 Apr 2013 12:22:17 +0530
Message-Id: <1366699939-14076-2-git-send-email-sujith@msujith.org> (sfid-20130423_085438_574452_84199BD8)
In-Reply-To: <1366699939-14076-1-git-send-email-sujith@msujith.org>
References: <1366699939-14076-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The EDMA case is handled first, so the else condition
can be removed.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 90 +++++++++++++++++------------------
 1 file changed, 44 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d13faa4..c8265a7 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -274,49 +274,47 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	common->rx_bufsize = IEEE80211_MAX_MPDU_LEN / 2 +
 			     sc->sc_ah->caps.rx_status_len;
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 		return ath_rx_edma_init(sc, nbufs);
-	} else {
-		ath_dbg(common, CONFIG, "cachelsz %u rxbufsize %u\n",
-			common->cachelsz, common->rx_bufsize);
 
-		/* Initialize rx descriptors */
+	ath_dbg(common, CONFIG, "cachelsz %u rxbufsize %u\n",
+		common->cachelsz, common->rx_bufsize);
 
-		error = ath_descdma_setup(sc, &sc->rx.rxdma, &sc->rx.rxbuf,
-				"rx", nbufs, 1, 0);
-		if (error != 0) {
-			ath_err(common,
-				"failed to allocate rx descriptors: %d\n",
-				error);
+	/* Initialize rx descriptors */
+
+	error = ath_descdma_setup(sc, &sc->rx.rxdma, &sc->rx.rxbuf,
+				  "rx", nbufs, 1, 0);
+	if (error != 0) {
+		ath_err(common,
+			"failed to allocate rx descriptors: %d\n",
+			error);
+		goto err;
+	}
+
+	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
+		skb = ath_rxbuf_alloc(common, common->rx_bufsize,
+				      GFP_KERNEL);
+		if (skb == NULL) {
+			error = -ENOMEM;
 			goto err;
 		}
 
-		list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-			skb = ath_rxbuf_alloc(common, common->rx_bufsize,
-					      GFP_KERNEL);
-			if (skb == NULL) {
-				error = -ENOMEM;
-				goto err;
-			}
-
-			bf->bf_mpdu = skb;
-			bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
-					common->rx_bufsize,
-					DMA_FROM_DEVICE);
-			if (unlikely(dma_mapping_error(sc->dev,
-							bf->bf_buf_addr))) {
-				dev_kfree_skb_any(skb);
-				bf->bf_mpdu = NULL;
-				bf->bf_buf_addr = 0;
-				ath_err(common,
-					"dma_mapping_error() on RX init\n");
-				error = -ENOMEM;
-				goto err;
-			}
+		bf->bf_mpdu = skb;
+		bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
+						 common->rx_bufsize,
+						 DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(sc->dev,
+					       bf->bf_buf_addr))) {
+			dev_kfree_skb_any(skb);
+			bf->bf_mpdu = NULL;
+			bf->bf_buf_addr = 0;
+			ath_err(common,
+				"dma_mapping_error() on RX init\n");
+			error = -ENOMEM;
+			goto err;
 		}
-		sc->rx.rxlink = NULL;
 	}
-
+	sc->rx.rxlink = NULL;
 err:
 	if (error)
 		ath_rx_cleanup(sc);
@@ -334,17 +332,17 @@ void ath_rx_cleanup(struct ath_softc *sc)
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		ath_rx_edma_cleanup(sc);
 		return;
-	} else {
-		list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-			skb = bf->bf_mpdu;
-			if (skb) {
-				dma_unmap_single(sc->dev, bf->bf_buf_addr,
-						common->rx_bufsize,
-						DMA_FROM_DEVICE);
-				dev_kfree_skb(skb);
-				bf->bf_buf_addr = 0;
-				bf->bf_mpdu = NULL;
-			}
+	}
+
+	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
+		skb = bf->bf_mpdu;
+		if (skb) {
+			dma_unmap_single(sc->dev, bf->bf_buf_addr,
+					 common->rx_bufsize,
+					 DMA_FROM_DEVICE);
+			dev_kfree_skb(skb);
+			bf->bf_buf_addr = 0;
+			bf->bf_mpdu = NULL;
 		}
 	}
 }
-- 
1.8.2.1

