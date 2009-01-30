Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46273 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643AbZA3Agx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 19:36:53 -0500
Message-ID: <49824BA0.8060505@openwrt.org> (sfid-20090130_013657_640657_FC3CA93E)
Date: Fri, 30 Jan 2009 01:36:48 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH] ath5k: properly free rx dma descriptors
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When freeing rx dma descriptors, use the right buffer size.
Fixes kernel oopses on module unload on ixp4xx and most likely
other platforms as well.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>

--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -308,6 +308,19 @@ static inline void ath5k_txbuf_free(stru
 	bf->skb = NULL;
 }
 
+static inline void ath5k_rxbuf_free(struct ath5k_softc *sc,
+				struct ath5k_buf *bf)
+{
+	BUG_ON(!bf);
+	if (!bf->skb)
+		return;
+	pci_unmap_single(sc->pdev, bf->skbaddr, sc->rxbufsize,
+			PCI_DMA_FROMDEVICE);
+	dev_kfree_skb_any(bf->skb);
+	bf->skb = NULL;
+}
+
+
 /* Queues setup */
 static struct 	ath5k_txq *ath5k_txq_setup(struct ath5k_softc *sc,
 				int qtype, int subtype);
@@ -1341,7 +1354,7 @@ ath5k_desc_free(struct ath5k_softc *sc, 
 	list_for_each_entry(bf, &sc->txbuf, list)
 		ath5k_txbuf_free(sc, bf);
 	list_for_each_entry(bf, &sc->rxbuf, list)
-		ath5k_txbuf_free(sc, bf);
+		ath5k_rxbuf_free(sc, bf);
 
 	/* Free memory associated with all descriptors */
 	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
