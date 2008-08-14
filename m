Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14034 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbYHNIII (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 04:08:08 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 01:08:08 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18595.58674.928230.24611@localhost.localdomain> (sfid-20080814_100812_158655_A050DC42)
Date: Thu, 14 Aug 2008 13:26:34 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/6] ath9k: Remove remaining occurences of ath_skb_map functions
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use direct pci functions instead.
Also, use sc_ht_info.tx_chan_width directly and remove ath_cwm_macmode.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |   27 +++++++++++-------------
 drivers/net/wireless/ath9k/core.h |    9 --------
 drivers/net/wireless/ath9k/recv.c |   40 +++++++-----------------------------
 drivers/net/wireless/ath9k/xmit.c |    8 +++---
 4 files changed, 24 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 9737775..a9e8ad0 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -314,7 +314,6 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	bool fastcc = true, stopped;
-	enum ath9k_ht_macmode ht_macmode;
 
 	if (sc->sc_flags & SC_OP_INVALID) /* the device is invalid or removed */
 		return -EIO;
@@ -328,8 +327,6 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 		ath9k_hw_mhz2ieee(ah, hchan->channel, hchan->channelFlags),
 		hchan->channel, hchan->channelFlags);
 
-	ht_macmode = ath_cwm_macmode(sc);
-
 	if (hchan->channel != sc->sc_ah->ah_curchan->channel ||
 	    hchan->channelFlags != sc->sc_ah->ah_curchan->channelFlags ||
 	    (sc->sc_flags & SC_OP_CHAINMASK_UPDATE) ||
@@ -357,10 +354,11 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 
 		spin_lock_bh(&sc->sc_resetlock);
 		if (!ath9k_hw_reset(ah, hchan,
-					ht_macmode, sc->sc_tx_chainmask,
-					sc->sc_rx_chainmask,
-					sc->sc_ht_extprotspacing,
-					fastcc, &status)) {
+				    sc->sc_ht_info.tx_chan_width,
+				    sc->sc_tx_chainmask,
+				    sc->sc_rx_chainmask,
+				    sc->sc_ht_extprotspacing,
+				    fastcc, &status)) {
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: unable to reset channel %u (%uMhz) "
 				"flags 0x%x hal status %u\n", __func__,
@@ -682,7 +680,6 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	struct ath_hal *ah = sc->sc_ah;
 	int status;
 	int error = 0;
-	enum ath9k_ht_macmode ht_macmode = ath_cwm_macmode(sc);
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: mode %d\n",
 		__func__, sc->sc_ah->ah_opmode);
@@ -709,9 +706,10 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	 */
 
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, initial_chan, ht_macmode,
-			   sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			   sc->sc_ht_extprotspacing, false, &status)) {
+	if (!ath9k_hw_reset(ah, initial_chan,
+			    sc->sc_ht_info.tx_chan_width,
+			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
+			    sc->sc_ht_extprotspacing, false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to reset hardware; hal status %u "
 			"(freq %u flags 0x%x)\n", __func__, status,
@@ -788,7 +786,6 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	struct ath_hal *ah = sc->sc_ah;
 	int status;
 	int error = 0;
-	enum ath9k_ht_macmode ht_macmode = ath_cwm_macmode(sc);
 
 	ath9k_hw_set_interrupts(ah, 0);	/* disable interrupts */
 	ath_draintxq(sc, retry_tx);	/* stop xmit */
@@ -798,9 +795,9 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	/* Reset chip */
 	spin_lock_bh(&sc->sc_resetlock);
 	if (!ath9k_hw_reset(ah, sc->sc_ah->ah_curchan,
-			   ht_macmode,
-			   sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			   sc->sc_ht_extprotspacing, false, &status)) {
+			    sc->sc_ht_info.tx_chan_width,
+			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
+			    sc->sc_ht_extprotspacing, false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: unable to reset hardware; hal status %u\n",
 			__func__, status);
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index c242942..51bf528 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -1023,14 +1023,5 @@ int ath_cabq_update(struct ath_softc *);
 void ath_get_currentCountry(struct ath_softc *sc,
 	struct ath9k_country_entry *ctry);
 u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp);
-dma_addr_t ath_skb_map_single(struct ath_softc *sc,
-			      struct sk_buff *skb,
-			      int direction,
-			      dma_addr_t *pa);
-void ath_skb_unmap_single(struct ath_softc *sc,
-			  struct sk_buff *skb,
-			  int direction,
-			  dma_addr_t *pa);
-enum ath9k_ht_macmode ath_cwm_macmode(struct ath_softc *sc);
 
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index af2011f..91f6354 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -454,11 +454,10 @@ static int ath_rx_indicate(struct ath_softc *sc,
 	nskb = ath_rxbuf_alloc(sc, sc->sc_rxbufsize);
 	if (nskb != NULL) {
 		bf->bf_mpdu = nskb;
-		bf->bf_buf_addr = ath_skb_map_single(sc,
-			nskb,
-			PCI_DMA_FROMDEVICE,
-			/* XXX: Remove get_dma_mem_context() */
-			get_dma_mem_context(bf, bf_dmacontext));
+		bf->bf_buf_addr = pci_map_single(sc->pdev, nskb->data,
+					 skb_end_pointer(nskb) - nskb->head,
+					 PCI_DMA_FROMDEVICE);
+		bf->bf_dmacontext = bf->bf_buf_addr;
 		ATH_RX_CONTEXT(nskb)->ctx_rxbuf = bf;
 
 		/* queue the new wbuf to H/W */
@@ -541,9 +540,10 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 			}
 
 			bf->bf_mpdu = skb;
-			bf->bf_buf_addr =
-				ath_skb_map_single(sc, skb, PCI_DMA_FROMDEVICE,
-				       get_dma_mem_context(bf, bf_dmacontext));
+			bf->bf_buf_addr = pci_map_single(sc->pdev, skb->data,
+					 skb_end_pointer(skb) - skb->head,
+					 PCI_DMA_FROMDEVICE);
+			bf->bf_dmacontext = bf->bf_buf_addr;
 			ATH_RX_CONTEXT(skb)->ctx_rxbuf = bf;
 		}
 		sc->sc_rxlink = NULL;
@@ -1297,27 +1297,3 @@ void ath_rx_node_free(struct ath_softc *sc, struct ath_node *an)
 {
 	ath_rx_node_cleanup(sc, an);
 }
-
-dma_addr_t ath_skb_map_single(struct ath_softc *sc,
-			      struct sk_buff *skb,
-			      int direction,
-			      dma_addr_t *pa)
-{
-	/*
-	 * NB: do NOT use skb->len, which is 0 on initialization.
-	 * Use skb's entire data area instead.
-	 */
-	*pa = pci_map_single(sc->pdev, skb->data,
-		skb_end_pointer(skb) - skb->head, direction);
-	return *pa;
-}
-
-void ath_skb_unmap_single(struct ath_softc *sc,
-			  struct sk_buff *skb,
-			  int direction,
-			  dma_addr_t *pa)
-{
-	/* Unmap skb's entire data area */
-	pci_unmap_single(sc->pdev, *pa,
-		skb_end_pointer(skb) - skb->head, direction);
-}
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 55f3c8e..8d31ad7 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1427,7 +1427,6 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 	struct ath_hal *ah = sc->sc_ah;
 	int i;
 	int npend = 0;
-	enum ath9k_ht_macmode ht_macmode = ath_cwm_macmode(sc);
 
 	/* XXX return value */
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
@@ -1452,9 +1451,10 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 
 		spin_lock_bh(&sc->sc_resetlock);
 		if (!ath9k_hw_reset(ah,
-			sc->sc_ah->ah_curchan, ht_macmode,
-			sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			sc->sc_ht_extprotspacing, true, &status)) {
+				    sc->sc_ah->ah_curchan,
+				    sc->sc_ht_info.tx_chan_width,
+				    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
+				    sc->sc_ht_extprotspacing, true, &status)) {
 
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: unable to reset hardware; hal status %u\n",
-- 
1.5.6.5

