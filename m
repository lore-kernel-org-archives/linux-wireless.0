Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:53734 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbXLPAr6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2007 19:47:58 -0500
Date: Sun, 16 Dec 2007 02:47:55 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 1/9] ath5k: Minor fixes inside base.c
Message-ID: <20071216004755.GA5482@makis.domain.invalid> (sfid-20071216_004803_368443_008140AB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reorder some inline functions to silence compiler
* Stop passing 0xff.. for txpower during tx descriptor setup. Txpower is written in hw in 0.5dbm steps.

Changes-licensed-under: 3-clause-BSD
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index f288858..c874a5e 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1129,92 +1129,6 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 
 
 
-/*******************\
-* Descriptors setup *
-\*******************/
-
-static int
-ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
-{
-	struct ath5k_desc *ds;
-	struct ath5k_buf *bf;
-	dma_addr_t da;
-	unsigned int i;
-	int ret;
-
-	/* allocate descriptors */
-	sc->desc_len = sizeof(struct ath5k_desc) *
-			(ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
-	sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
-	if (sc->desc == NULL) {
-		ATH5K_ERR(sc, "can't allocate descriptors\n");
-		ret = -ENOMEM;
-		goto err;
-	}
-	ds = sc->desc;
-	da = sc->desc_daddr;
-	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "DMA map: %p (%zu) -> %llx\n",
-		ds, sc->desc_len, (unsigned long long)sc->desc_daddr);
-
-	bf = kcalloc(1 + ATH_TXBUF + ATH_RXBUF + ATH_BCBUF,
-			sizeof(struct ath5k_buf), GFP_KERNEL);
-	if (bf == NULL) {
-		ATH5K_ERR(sc, "can't allocate bufptr\n");
-		ret = -ENOMEM;
-		goto err_free;
-	}
-	sc->bufptr = bf;
-
-	INIT_LIST_HEAD(&sc->rxbuf);
-	for (i = 0; i < ATH_RXBUF; i++, bf++, ds++, da += sizeof(*ds)) {
-		bf->desc = ds;
-		bf->daddr = da;
-		list_add_tail(&bf->list, &sc->rxbuf);
-	}
-
-	INIT_LIST_HEAD(&sc->txbuf);
-	sc->txbuf_len = ATH_TXBUF;
-	for (i = 0; i < ATH_TXBUF; i++, bf++, ds++,
-			da += sizeof(*ds)) {
-		bf->desc = ds;
-		bf->daddr = da;
-		list_add_tail(&bf->list, &sc->txbuf);
-	}
-
-	/* beacon buffer */
-	bf->desc = ds;
-	bf->daddr = da;
-	sc->bbuf = bf;
-
-	return 0;
-err_free:
-	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
-err:
-	sc->desc = NULL;
-	return ret;
-}
-
-static void
-ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
-{
-	struct ath5k_buf *bf;
-
-	ath5k_txbuf_free(sc, sc->bbuf);
-	list_for_each_entry(bf, &sc->txbuf, list)
-		ath5k_txbuf_free(sc, bf);
-	list_for_each_entry(bf, &sc->rxbuf, list)
-		ath5k_txbuf_free(sc, bf);
-
-	/* Free memory associated with all descriptors */
-	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
-
-	kfree(sc->bufptr);
-	sc->bufptr = NULL;
-}
-
-
-
-
 /***************\
 * Buffers setup *
 \***************/
@@ -1316,7 +1230,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
-		0xffff, ctl->tx_rate, ctl->retry_limit, keyidx, 0, flags, 0, 0);
+		(ctl->power_level * 2), ctl->tx_rate, ctl->retry_limit, keyidx, 0, flags, 0, 0);
 	if (ret)
 		goto err_unmap;
 
@@ -1356,6 +1270,93 @@ ath5k_txbuf_free(struct ath5k_softc *sc, struct ath5k_buf *bf)
 
 
 
+/*******************\
+* Descriptors setup *
+\*******************/
+
+static int
+ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
+{
+	struct ath5k_desc *ds;
+	struct ath5k_buf *bf;
+	dma_addr_t da;
+	unsigned int i;
+	int ret;
+
+	/* allocate descriptors */
+	sc->desc_len = sizeof(struct ath5k_desc) *
+			(ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
+	sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
+	if (sc->desc == NULL) {
+		ATH5K_ERR(sc, "can't allocate descriptors\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+	ds = sc->desc;
+	da = sc->desc_daddr;
+	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "DMA map: %p (%zu) -> %llx\n",
+		ds, sc->desc_len, (unsigned long long)sc->desc_daddr);
+
+	bf = kcalloc(1 + ATH_TXBUF + ATH_RXBUF + ATH_BCBUF,
+			sizeof(struct ath5k_buf), GFP_KERNEL);
+	if (bf == NULL) {
+		ATH5K_ERR(sc, "can't allocate bufptr\n");
+		ret = -ENOMEM;
+		goto err_free;
+	}
+	sc->bufptr = bf;
+
+	INIT_LIST_HEAD(&sc->rxbuf);
+	for (i = 0; i < ATH_RXBUF; i++, bf++, ds++, da += sizeof(*ds)) {
+		bf->desc = ds;
+		bf->daddr = da;
+		list_add_tail(&bf->list, &sc->rxbuf);
+	}
+
+	INIT_LIST_HEAD(&sc->txbuf);
+	sc->txbuf_len = ATH_TXBUF;
+	for (i = 0; i < ATH_TXBUF; i++, bf++, ds++,
+			da += sizeof(*ds)) {
+		bf->desc = ds;
+		bf->daddr = da;
+		list_add_tail(&bf->list, &sc->txbuf);
+	}
+
+	/* beacon buffer */
+	bf->desc = ds;
+	bf->daddr = da;
+	sc->bbuf = bf;
+
+	return 0;
+err_free:
+	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
+err:
+	sc->desc = NULL;
+	return ret;
+}
+
+static void
+ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
+{
+	struct ath5k_buf *bf;
+
+	ath5k_txbuf_free(sc, sc->bbuf);
+	list_for_each_entry(bf, &sc->txbuf, list)
+		ath5k_txbuf_free(sc, bf);
+	list_for_each_entry(bf, &sc->rxbuf, list)
+		ath5k_txbuf_free(sc, bf);
+
+	/* Free memory associated with all descriptors */
+	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
+
+	kfree(sc->bufptr);
+	sc->bufptr = NULL;
+}
+
+
+
+
+
 /**************\
 * Queues setup *
 \**************/
@@ -1619,6 +1620,17 @@ ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
 	return 0;
 }
 
+static inline
+u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
+{
+	u64 tsf = ath5k_hw_get_tsf64(ah);
+
+	if ((tsf & 0x7fff) < rstamp)
+		tsf -= 0x8000;
+
+	return (tsf & ~0x7fff) | rstamp;
+}
+
 static void
 ath5k_tasklet_rx(unsigned long data)
 {
@@ -1884,7 +1896,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	ds->ds_data = bf->skbaddr;
 	ret = ah->ah_setup_tx_desc(ah, ds, skb->len + FCS_LEN,
 			ieee80211_get_hdrlen_from_skb(skb),
-			AR5K_PKT_TYPE_BEACON, 0xffff, ctl->tx_rate, 1,
+			AR5K_PKT_TYPE_BEACON, (ctl->power_level * 2), ctl->tx_rate, 1,
 			AR5K_TXKEYIX_INVALID, antenna, flags, 0, 0);
 	if (ret)
 		goto err_unmap;
@@ -2046,16 +2058,6 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 #undef TSF_TO_TU
 }
 
-static inline
-u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
-{
-	u64 tsf = ath5k_hw_get_tsf64(ah);
-
-	if ((tsf & 0x7fff) < rstamp)
-		tsf -= 0x8000;
-
-	return (tsf & ~0x7fff) | rstamp;
-}
 
 
 


