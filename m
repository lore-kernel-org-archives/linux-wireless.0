Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:39676 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbYHKLDa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 07:03:30 -0400
Message-Id: <20080811110244.093814786@localhost> (sfid-20080811_130332_401909_D806991B)
References: <20080811110146.877112595@localhost>
Date: Mon, 11 Aug 2008 14:01:48 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] ath9k: Updated Beacon generation to use mac80211-style
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change moves ath9k to use mac80211-generated Beacon frames instead
of trying to allocate a single Beacon frame and then update it. In
addition, the remaining ath_skb_{map,unmap}_single() wrapper calls are
replaced with direct pci_{map,unmap}_single() calls in beacon.c. Power
save buffering for multicast/broadcast frames is not yet converted to
use mac80211-style (frames to be buffered inside mac80211, not in
driver).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/drivers/net/wireless/ath9k/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c
+++ wireless-testing/drivers/net/wireless/ath9k/main.c
@@ -624,6 +624,18 @@ static int ath9k_config_interface(struct
 		ath_beacon_sync(sc, 0);
 	}
 
+	if ((conf->changed & IEEE80211_IFCC_BEACON) &&
+	    (vif->type == IEEE80211_IF_TYPE_AP)) {
+		ath9k_hw_stoptxdma(sc->sc_ah, sc->sc_bhalq);
+
+		error = ath_beacon_alloc(sc, 0);
+		if (error != 0)
+			return error;
+
+		ath_beacon_config(sc, 0);
+		sc->sc_flags |= SC_OP_BEACONS;
+	}
+
 	/* Check for WLAN_CAPABILITY_PRIVACY ? */
 	if ((avp->av_opmode != IEEE80211_IF_TYPE_STA)) {
 		for (i = 0; i < IEEE80211_WEP_NKID; i++)
@@ -1052,15 +1064,6 @@ void ath_get_beaconconfig(struct ath_sof
 	conf->bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf->listen_interval;
 }
 
-int ath_update_beacon(struct ath_softc *sc,
-		      int if_id,
-		      struct ath_beacon_offset *bo,
-		      struct sk_buff *skb,
-		      int mcast)
-{
-	return 0;
-}
-
 void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		     struct ath_xmit_status *tx_status, struct ath_node *an)
 {
Index: wireless-testing/drivers/net/wireless/ath9k/beacon.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/beacon.c
+++ wireless-testing/drivers/net/wireless/ath9k/beacon.c
@@ -172,6 +172,7 @@ static void empty_mcastq_into_cabq(struc
 	mcastq->axq_link = NULL;
 }
 
+/* TODO: use ieee80211_get_buffered_bc() to fetch power saved mcast frames */
 /* This is only run at DTIM. We move everything from the vap's mcast queue
  * to the hardware cab queue. Caller must hold the mcastq lock. */
 static void trigger_mcastq(struct ath_hal *ah,
@@ -206,7 +207,6 @@ static struct ath_buf *ath_beacon_genera
 	int cabq_depth;
 	int mcastq_depth;
 	int is_beacon_dtim = 0;
-	unsigned int curlen;
 	struct ath_txq *cabq;
 	struct ath_txq *mcastq;
 	avp = sc->sc_vaps[if_id];
@@ -223,33 +223,27 @@ static struct ath_buf *ath_beacon_genera
 	}
 	bf = avp->av_bcbuf;
 	skb = (struct sk_buff *) bf->bf_mpdu;
+	if (skb) {
+		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
+				 skb_end_pointer(skb) - skb->head,
+				 PCI_DMA_TODEVICE);
+	}
 
-	/*
-	 * Update dynamic beacon contents.  If this returns
-	 * non-zero then we need to remap the memory because
-	 * the beacon frame changed size (probably because
-	 * of the TIM bitmap).
-	 */
-	curlen = skb->len;
+	skb = ieee80211_beacon_get(sc->hw, avp->av_if_data);
+	bf->bf_mpdu = skb;
+	if (skb == NULL)
+		return NULL;
+	bf->bf_buf_addr = bf->bf_dmacontext =
+		pci_map_single(sc->pdev, skb->data,
+			       skb_end_pointer(skb) - skb->head,
+			       PCI_DMA_TODEVICE);
 
+	/* TODO: convert to use ieee80211_get_buffered_bc() */
 	/* XXX: spin_lock_bh should not be used here, but sparse bitches
 	 * otherwise. We should fix sparse :) */
 	spin_lock_bh(&mcastq->axq_lock);
 	mcastq_depth = avp->av_mcastq.axq_depth;
 
-	if (ath_update_beacon(sc, if_id, &avp->av_boff, skb, mcastq_depth) ==
-	    1) {
-		ath_skb_unmap_single(sc, skb, PCI_DMA_TODEVICE,
-				     get_dma_mem_context(bf, bf_dmacontext));
-		bf->bf_buf_addr = ath_skb_map_single(sc, skb, PCI_DMA_TODEVICE,
-			get_dma_mem_context(bf, bf_dmacontext));
-	} else {
-		pci_dma_sync_single_for_cpu(sc->pdev,
-					    bf->bf_buf_addr,
-					    skb_tailroom(skb),
-					    PCI_DMA_TODEVICE);
-	}
-
 	/*
 	 * if the CABQ traffic from previous DTIM is pending and the current
 	 *  beacon is also a DTIM.
@@ -262,7 +256,8 @@ static struct ath_buf *ath_beacon_genera
 	cabq_depth = cabq->axq_depth;
 	spin_unlock_bh(&cabq->axq_lock);
 
-	is_beacon_dtim = avp->av_boff.bo_tim[4] & 1;
+	if (avp->av_boff.bo_tim)
+		is_beacon_dtim = avp->av_boff.bo_tim[4] & 1;
 
 	if (mcastq_depth && is_beacon_dtim && cabq_depth) {
 		/*
@@ -408,8 +403,9 @@ int ath_beacon_alloc(struct ath_softc *s
 	bf = avp->av_bcbuf;
 	if (bf->bf_mpdu != NULL) {
 		skb = (struct sk_buff *)bf->bf_mpdu;
-		ath_skb_unmap_single(sc, skb, PCI_DMA_TODEVICE,
-				     get_dma_mem_context(bf, bf_dmacontext));
+		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
+				 skb_end_pointer(skb) - skb->head,
+				 PCI_DMA_TODEVICE);
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
 	}
@@ -439,9 +435,8 @@ int ath_beacon_alloc(struct ath_softc *s
 		__le64 val;
 		int intval;
 
-		/* FIXME: Use default value for now: Sujith */
-
-		intval = ATH_DEFAULT_BINTVAL;
+		intval = sc->hw->conf.beacon_int ?
+			sc->hw->conf.beacon_int : ATH_DEFAULT_BINTVAL;
 
 		/*
 		 * The beacon interval is in TU's; the TSF in usecs.
@@ -466,8 +461,10 @@ int ath_beacon_alloc(struct ath_softc *s
 		memcpy(&wh[1], &val, sizeof(val));
 	}
 
-	bf->bf_buf_addr = ath_skb_map_single(sc, skb, PCI_DMA_TODEVICE,
-		get_dma_mem_context(bf, bf_dmacontext));
+	bf->bf_buf_addr = bf->bf_dmacontext =
+		pci_map_single(sc->pdev, skb->data,
+			       skb_end_pointer(skb) - skb->head,
+			       PCI_DMA_TODEVICE);
 	bf->bf_mpdu = skb;
 
 	return 0;
@@ -493,8 +490,9 @@ void ath_beacon_return(struct ath_softc 
 		bf = avp->av_bcbuf;
 		if (bf->bf_mpdu != NULL) {
 			struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
-			ath_skb_unmap_single(sc, skb, PCI_DMA_TODEVICE,
-				get_dma_mem_context(bf, bf_dmacontext));
+			pci_unmap_single(sc->pdev, bf->bf_dmacontext,
+					 skb_end_pointer(skb) - skb->head,
+					 PCI_DMA_TODEVICE);
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
 		}
@@ -520,8 +518,9 @@ void ath_beacon_free(struct ath_softc *s
 	list_for_each_entry(bf, &sc->sc_bbuf, list) {
 		if (bf->bf_mpdu != NULL) {
 			struct sk_buff *skb = (struct sk_buff *) bf->bf_mpdu;
-			ath_skb_unmap_single(sc, skb, PCI_DMA_TODEVICE,
-				get_dma_mem_context(bf, bf_dmacontext));
+			pci_unmap_single(sc->pdev, bf->bf_dmacontext,
+					 skb_end_pointer(skb) - skb->head,
+					 PCI_DMA_TODEVICE);
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
 		}
@@ -643,8 +642,8 @@ void ath9k_beacon_tasklet(unsigned long 
 	 * on the tsf to safeguard against missing an swba.
 	 */
 
-	/* FIXME: Use default value for now - Sujith */
-	intval = ATH_DEFAULT_BINTVAL;
+	intval = sc->hw->conf.beacon_int ?
+		sc->hw->conf.beacon_int : ATH_DEFAULT_BINTVAL;
 
 	tsf = ath9k_hw_gettsf64(ah);
 	tsftu = TSF_TO_TU(tsf>>32, tsf);
@@ -760,7 +759,8 @@ void ath_beacon_config(struct ath_softc 
 	 * Protocol stack doesn't support dynamic beacon configuration,
 	 * use default configurations.
 	 */
-	conf.beacon_interval = ATH_DEFAULT_BINTVAL;
+	conf.beacon_interval = sc->hw->conf.beacon_int ?
+		sc->hw->conf.beacon_int : ATH_DEFAULT_BINTVAL;
 	conf.listen_interval = 1;
 	conf.dtim_period = conf.beacon_interval;
 	conf.dtim_count = 1;
Index: wireless-testing/drivers/net/wireless/ath9k/core.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/core.h
+++ wireless-testing/drivers/net/wireless/ath9k/core.h
@@ -729,11 +729,6 @@ void ath_beacon_sync(struct ath_softc *s
 void ath_get_beaconconfig(struct ath_softc *sc,
 			  int if_id,
 			  struct ath_beacon_config *conf);
-int ath_update_beacon(struct ath_softc *sc,
-		      int if_id,
-		      struct ath_beacon_offset *bo,
-		      struct sk_buff *skb,
-		      int mcast);
 /********/
 /* VAPs */
 /********/

--

-- 
Jouni Malinen                                            PGP id EFC895FA
