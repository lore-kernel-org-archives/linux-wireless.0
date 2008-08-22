Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:60435 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbYHVOcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2008 10:32:24 -0400
Date: Fri, 22 Aug 2008 17:31:33 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Use mac80211 for multicast power save buffering
Message-ID: <20080822143133.GA28638@jm.kir.nu> (sfid-20080822_163230_432762_233792F0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace the internal ath9k implementation of multicast/broadcast frame
power save buffering (AP mode) in ath9k with use of mac80211
ieee80211_get_buffered_bc() mechanism. This removes quite a bit of
duplicated functionality and simplifies the driver part.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/drivers/net/wireless/ath9k/beacon.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/beacon.c
+++ wireless-testing/drivers/net/wireless/ath9k/beacon.c
@@ -140,56 +140,6 @@ static void ath_beacon_setup(struct ath_
 		ctsrate, ctsduration, series, 4, 0);
 }
 
-/* Move everything from the vap's mcast queue to the hardware cab queue.
- * Caller must hold mcasq lock and cabq lock
- * XXX MORE_DATA bit?
- */
-static void empty_mcastq_into_cabq(struct ath_hal *ah,
-	struct ath_txq *mcastq, struct ath_txq *cabq)
-{
-	struct ath_buf *bfmcast;
-
-	BUG_ON(list_empty(&mcastq->axq_q));
-
-	bfmcast = list_first_entry(&mcastq->axq_q, struct ath_buf, list);
-
-	/* link the descriptors */
-	if (!cabq->axq_link)
-		ath9k_hw_puttxbuf(ah, cabq->axq_qnum, bfmcast->bf_daddr);
-	else
-		*cabq->axq_link = bfmcast->bf_daddr;
-
-	/* append the private vap mcast list to  the cabq */
-
-	cabq->axq_depth	+= mcastq->axq_depth;
-	cabq->axq_totalqueued += mcastq->axq_totalqueued;
-	cabq->axq_linkbuf = mcastq->axq_linkbuf;
-	cabq->axq_link = mcastq->axq_link;
-	list_splice_tail_init(&mcastq->axq_q, &cabq->axq_q);
-	mcastq->axq_depth = 0;
-	mcastq->axq_totalqueued = 0;
-	mcastq->axq_linkbuf = NULL;
-	mcastq->axq_link = NULL;
-}
-
-/* TODO: use ieee80211_get_buffered_bc() to fetch power saved mcast frames */
-/* This is only run at DTIM. We move everything from the vap's mcast queue
- * to the hardware cab queue. Caller must hold the mcastq lock. */
-static void trigger_mcastq(struct ath_hal *ah,
-	struct ath_txq *mcastq, struct ath_txq *cabq)
-{
-	spin_lock_bh(&cabq->axq_lock);
-
-	if (!list_empty(&mcastq->axq_q))
-		empty_mcastq_into_cabq(ah, mcastq, cabq);
-
-	/* cabq is gated by beacon so it is safe to start here */
-	if (!list_empty(&cabq->axq_q))
-		ath9k_hw_txstart(ah, cabq->axq_qnum);
-
-	spin_unlock_bh(&cabq->axq_lock);
-}
-
 /*
  *  Generate beacon frame and queue cab data for a vap.
  *
@@ -200,19 +150,14 @@ static void trigger_mcastq(struct ath_ha
 */
 static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 {
-	struct ath_hal *ah = sc->sc_ah;
 	struct ath_buf *bf;
 	struct ath_vap *avp;
 	struct sk_buff *skb;
 	int cabq_depth;
-	int mcastq_depth;
-	int is_beacon_dtim = 0;
 	struct ath_txq *cabq;
-	struct ath_txq *mcastq;
 	struct ieee80211_tx_info *info;
 	avp = sc->sc_vaps[if_id];
 
-	mcastq = &avp->av_mcastq;
 	cabq = sc->sc_cabq;
 
 	ASSERT(avp);
@@ -250,11 +195,7 @@ static struct ath_buf *ath_beacon_genera
 			       skb_end_pointer(skb) - skb->head,
 			       PCI_DMA_TODEVICE);
 
-	/* TODO: convert to use ieee80211_get_buffered_bc() */
-	/* XXX: spin_lock_bh should not be used here, but sparse bitches
-	 * otherwise. We should fix sparse :) */
-	spin_lock_bh(&mcastq->axq_lock);
-	mcastq_depth = avp->av_mcastq.axq_depth;
+	skb = ieee80211_get_buffered_bc(sc->hw, avp->av_if_data);
 
 	/*
 	 * if the CABQ traffic from previous DTIM is pending and the current
@@ -268,10 +209,7 @@ static struct ath_buf *ath_beacon_genera
 	cabq_depth = cabq->axq_depth;
 	spin_unlock_bh(&cabq->axq_lock);
 
-	if (avp->av_boff.bo_tim)
-		is_beacon_dtim = avp->av_boff.bo_tim[4] & 1;
-
-	if (mcastq_depth && is_beacon_dtim && cabq_depth) {
+	if (skb && cabq_depth) {
 		/*
 		 * Unlock the cabq lock as ath_tx_draintxq acquires
 		 * the lock again which is a common function and that
@@ -291,10 +229,11 @@ static struct ath_buf *ath_beacon_genera
 	 * Enable the CAB queue before the beacon queue to
 	 * insure cab frames are triggered by this beacon.
 	 */
-	if (is_beacon_dtim)
-		trigger_mcastq(ah, mcastq, cabq);
+	while (skb) {
+		ath_tx_cabq(sc, skb);
+		skb = ieee80211_get_buffered_bc(sc->hw, avp->av_if_data);
+	}
 
-	spin_unlock_bh(&mcastq->axq_lock);
 	return bf;
 }
 
@@ -426,7 +365,7 @@ int ath_beacon_alloc(struct ath_softc *s
 	 * NB: the beacon data buffer must be 32-bit aligned;
 	 * we assume the wbuf routines will return us something
 	 * with this alignment (perhaps should assert).
-	 * FIXME: Fill avp->av_boff.bo_tim,avp->av_btxctl.txpower and
+	 * FIXME: Fill avp->av_btxctl.txpower and
 	 * avp->av_btxctl.shortPreamble
 	 */
 	skb = ieee80211_beacon_get(sc->hw, avp->av_if_data);
Index: wireless-testing/drivers/net/wireless/ath9k/core.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/core.h
+++ wireless-testing/drivers/net/wireless/ath9k/core.h
@@ -568,6 +568,7 @@ u32 ath_txq_aggr_depth(struct ath_softc 
 void ath_notify_txq_status(struct ath_softc *sc, u16 queue_depth);
 void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		     struct ath_xmit_status *tx_status, struct ath_node *an);
+void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb);
 
 /**********************/
 /* Node / Aggregation */
@@ -713,12 +714,6 @@ struct ath_beacon_config {
 	} u; /* last received beacon/probe response timestamp of this BSS. */
 };
 
-/* offsets in a beacon frame for
- * quick acess of beacon content by low-level driver */
-struct ath_beacon_offset {
-	u8 *bo_tim;	/* start of atim/dtim */
-};
-
 void ath9k_beacon_tasklet(unsigned long data);
 void ath_beacon_config(struct ath_softc *sc, int if_id);
 int ath_beaconq_setup(struct ath_hal *ah);
@@ -755,10 +750,8 @@ struct ath_vap {
 	struct ieee80211_vif *av_if_data;
 	enum ath9k_opmode av_opmode;	/* VAP operational mode */
 	struct ath_buf *av_bcbuf;	/* beacon buffer */
-	struct ath_beacon_offset av_boff; /* dynamic update state */
 	struct ath_tx_control av_btxctl;  /* txctl information for beacon */
 	int av_bslot;			/* beacon slot index */
-	struct ath_txq av_mcastq;	/* multicast transmit queue */
 	struct ath_vap_config av_config;/* vap configuration parameters*/
 	struct ath_rate_node *rc_node;
 };
Index: wireless-testing/drivers/net/wireless/ath9k/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c
+++ wireless-testing/drivers/net/wireless/ath9k/main.c
@@ -1362,6 +1362,7 @@ static int ath_pci_probe(struct pci_dev 
 	}
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_NOISE_DBM;
 
Index: wireless-testing/drivers/net/wireless/ath9k/core.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/core.c
+++ wireless-testing/drivers/net/wireless/ath9k/core.c
@@ -533,9 +533,6 @@ int ath_vap_attach(struct ath_softc *sc,
 	/* Set the VAP opmode */
 	avp->av_opmode = opmode;
 	avp->av_bslot = -1;
-	INIT_LIST_HEAD(&avp->av_mcastq.axq_q);
-	INIT_LIST_HEAD(&avp->av_mcastq.axq_acq);
-	spin_lock_init(&avp->av_mcastq.axq_lock);
 
 	ath9k_hw_set_tsfadjust(sc->sc_ah, 1);
 
@@ -575,9 +572,6 @@ int ath_vap_detach(struct ath_softc *sc,
 	ath_stoprecv(sc);	/* stop recv side */
 	ath_flushrecv(sc);	/* flush recv queue */
 
-	/* Reclaim any pending mcast bufs on the vap. */
-	ath_tx_draintxq(sc, &avp->av_mcastq, false);
-
 	kfree(avp);
 	sc->sc_vaps[if_id] = NULL;
 	sc->sc_nvaps--;
Index: wireless-testing/drivers/net/wireless/ath9k/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/xmit.c
+++ wireless-testing/drivers/net/wireless/ath9k/xmit.c
@@ -60,79 +60,6 @@ static u32 bits_per_symbol[][2] = {
 #define IS_HT_RATE(_rate)     ((_rate) & 0x80)
 
 /*
- * Insert a chain of ath_buf (descriptors) on a multicast txq
- * but do NOT start tx DMA on this queue.
- * NB: must be called with txq lock held
- */
-
-static void ath_tx_mcastqaddbuf(struct ath_softc *sc,
-				struct ath_txq *txq,
-				struct list_head *head)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	struct ath_buf *bf;
-
-	if (list_empty(head))
-		return;
-
-	/*
-	 * Insert the frame on the outbound list and
-	 * pass it on to the hardware.
-	 */
-	bf = list_first_entry(head, struct ath_buf, list);
-
-	/*
-	 * The CAB queue is started from the SWBA handler since
-	 * frames only go out on DTIM and to avoid possible races.
-	 */
-	ath9k_hw_set_interrupts(ah, 0);
-
-	/*
-	 * If there is anything in the mcastq, we want to set
-	 * the "more data" bit in the last item in the queue to
-	 * indicate that there is "more data". It makes sense to add
-	 * it here since you are *always* going to have
-	 * more data when adding to this queue, no matter where
-	 * you call from.
-	 */
-
-	if (txq->axq_depth) {
-		struct ath_buf *lbf;
-		struct ieee80211_hdr *hdr;
-
-		/*
-		 * Add the "more data flag" to the last frame
-		 */
-
-		lbf = list_entry(txq->axq_q.prev, struct ath_buf, list);
-		hdr = (struct ieee80211_hdr *)
-			((struct sk_buff *)(lbf->bf_mpdu))->data;
-		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
-	}
-
-	/*
-	 * Now, concat the frame onto the queue
-	 */
-	list_splice_tail_init(head, &txq->axq_q);
-	txq->axq_depth++;
-	txq->axq_totalqueued++;
-	txq->axq_linkbuf = list_entry(txq->axq_q.prev, struct ath_buf, list);
-
-	DPRINTF(sc, ATH_DBG_QUEUE,
-		"%s: txq depth = %d\n", __func__, txq->axq_depth);
-	if (txq->axq_link != NULL) {
-		*txq->axq_link = bf->bf_daddr;
-		DPRINTF(sc, ATH_DBG_XMIT,
-			"%s: link[%u](%p)=%llx (%p)\n",
-			__func__,
-			txq->axq_qnum, txq->axq_link,
-			ito64(bf->bf_daddr), bf->bf_desc);
-	}
-	txq->axq_link = &(bf->bf_lastbf->bf_desc->ds_link);
-	ath9k_hw_set_interrupts(ah, sc->sc_imask);
-}
-
-/*
  * Insert a chain of ath_buf (descriptors) on a txq and
  * assume the descriptors are already chained together by caller.
  * NB: must be called with txq lock held
@@ -277,8 +204,6 @@ static int ath_tx_prepare(struct ath_sof
 	__le16 fc;
 	u8 *qc;
 
-	memset(txctl, 0, sizeof(struct ath_tx_control));
-
 	txctl->dev = sc;
 	hdr = (struct ieee80211_hdr *)skb->data;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
@@ -329,12 +254,18 @@ static int ath_tx_prepare(struct ath_sof
 
 	/* Fill qnum */
 
-	txctl->qnum = ath_get_hal_qnum(skb_get_queue_mapping(skb), sc);
-	txq = &sc->sc_txq[txctl->qnum];
+	if (unlikely(txctl->flags & ATH9K_TXDESC_CAB)) {
+		txctl->qnum = 0;
+		txq = sc->sc_cabq;
+	} else {
+		txctl->qnum = ath_get_hal_qnum(skb_get_queue_mapping(skb), sc);
+		txq = &sc->sc_txq[txctl->qnum];
+	}
 	spin_lock_bh(&txq->axq_lock);
 
 	/* Try to avoid running out of descriptors */
-	if (txq->axq_depth >= (ATH_TXBUF - 20)) {
+	if (txq->axq_depth >= (ATH_TXBUF - 20) &&
+	    !(txctl->flags & ATH9K_TXDESC_CAB)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"%s: TX queue: %d is full, depth: %d\n",
 			__func__,
@@ -354,7 +285,7 @@ static int ath_tx_prepare(struct ath_sof
 
 	/* Fill flags */
 
-	txctl->flags = ATH9K_TXDESC_CLRDMASK;    /* needed for crypto errors */
+	txctl->flags |= ATH9K_TXDESC_CLRDMASK; /* needed for crypto errors */
 
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
 		txctl->flags |= ATH9K_TXDESC_NOACK;
@@ -1982,13 +1913,18 @@ static int ath_tx_start_dma(struct ath_s
 	struct list_head bf_head;
 	struct ath_desc *ds;
 	struct ath_hal *ah = sc->sc_ah;
-	struct ath_txq *txq = &sc->sc_txq[txctl->qnum];
+	struct ath_txq *txq;
 	struct ath_tx_info_priv *tx_info_priv;
 	struct ath_rc_series *rcs;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *tx_info =  IEEE80211_SKB_CB(skb);
 	__le16 fc = hdr->frame_control;
 
+	if (unlikely(txctl->flags & ATH9K_TXDESC_CAB))
+		txq = sc->sc_cabq;
+	else
+		txq = &sc->sc_txq[txctl->qnum];
+
 	/* For each sglist entry, allocate an ath_buf for DMA */
 	INIT_LIST_HEAD(&bf_head);
 	spin_lock_bh(&sc->sc_txbuflock);
@@ -2093,27 +2029,7 @@ static int ath_tx_start_dma(struct ath_s
 			bf->bf_tidno = txctl->tidno;
 		}
 
-		if (is_multicast_ether_addr(hdr->addr1)) {
-			struct ath_vap *avp = sc->sc_vaps[txctl->if_id];
-
-			/*
-			 * When servicing one or more stations in power-save
-			 * mode (or) if there is some mcast data waiting on
-			 * mcast queue (to prevent out of order delivery of
-			 * mcast,bcast packets) multicast frames must be
-			 * buffered until after the beacon. We use the private
-			 * mcast queue for that.
-			 */
-			/* XXX? more bit in 802.11 frame header */
-			spin_lock_bh(&avp->av_mcastq.axq_lock);
-			if (txctl->ps || avp->av_mcastq.axq_depth)
-				ath_tx_mcastqaddbuf(sc,
-					&avp->av_mcastq, &bf_head);
-			else
-				ath_tx_txqaddbuf(sc, txq, &bf_head);
-			spin_unlock_bh(&avp->av_mcastq.axq_lock);
-		} else
-			ath_tx_txqaddbuf(sc, txq, &bf_head);
+		ath_tx_txqaddbuf(sc, txq, &bf_head);
 	}
 	spin_unlock_bh(&txq->axq_lock);
 	return 0;
@@ -2407,6 +2323,7 @@ int ath_tx_start(struct ath_softc *sc, s
 	struct ath_tx_control txctl;
 	int error = 0;
 
+	memset(&txctl, 0, sizeof(struct ath_tx_control));
 	error = ath_tx_prepare(sc, skb, &txctl);
 	if (error == 0)
 		/*
@@ -2871,3 +2788,57 @@ void ath_tx_node_free(struct ath_softc *
 		}
 	}
 }
+
+void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb)
+{
+	int hdrlen, padsize;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ath_tx_control txctl;
+
+	/*
+	 * As a temporary workaround, assign seq# here; this will likely need
+	 * to be cleaned up to work better with Beacon transmission and virtual
+	 * BSSes.
+	 */
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+			sc->seq_no += 0x10;
+		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(sc->seq_no);
+	}
+
+	/* Add the padding after the header if this is not already done */
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	if (hdrlen & 3) {
+		padsize = hdrlen % 4;
+		if (skb_headroom(skb) < padsize) {
+			DPRINTF(sc, ATH_DBG_XMIT, "%s: TX CABQ padding "
+				"failed\n", __func__);
+			dev_kfree_skb_any(skb);
+			return;
+		}
+		skb_push(skb, padsize);
+		memmove(skb->data, skb->data + padsize, hdrlen);
+	}
+
+	DPRINTF(sc, ATH_DBG_XMIT, "%s: transmitting CABQ packet, skb: %p\n",
+		__func__,
+		skb);
+
+	memset(&txctl, 0, sizeof(struct ath_tx_control));
+	txctl.flags = ATH9K_TXDESC_CAB;
+	if (ath_tx_prepare(sc, skb, &txctl) == 0) {
+		/*
+		 * Start DMA mapping.
+		 * ath_tx_start_dma() will be called either synchronously
+		 * or asynchrounsly once DMA is complete.
+		 */
+		xmit_map_sg(sc, skb, &txctl);
+	} else {
+		ath_node_put(sc, txctl.an, ATH9K_BH_STATUS_CHANGE);
+		DPRINTF(sc, ATH_DBG_XMIT, "%s: TX CABQ failed\n", __func__);
+		dev_kfree_skb_any(skb);
+	}
+}
+
Index: wireless-testing/drivers/net/wireless/ath9k/ath9k.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h
@@ -144,6 +144,7 @@ struct ath_desc {
 #define ATH9K_TXDESC_EXT_AND_CTL	0x0080
 #define ATH9K_TXDESC_VMF		0x0100
 #define ATH9K_TXDESC_FRAG_IS_ON 	0x0200
+#define ATH9K_TXDESC_CAB		0x0400
 
 #define ATH9K_RXDESC_INTREQ		0x0020
 

-- 
Jouni Malinen                                            PGP id EFC895FA
