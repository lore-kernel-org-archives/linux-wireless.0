Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44698 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYJ2ErF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:47:05 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:47:05 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.59946.119904.424988@gargle.gargle.HOWL> (sfid-20081029_054711_411997_8E05E643)
Date: Wed, 29 Oct 2008 10:14:26 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 03/16] ath9k: Revamp transmit control block
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the ath_buf instance associated with each tx frame
directly and remove all redundant information in ath_tx_control.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |    2 +-
 drivers/net/wireless/ath9k/core.h   |   30 +--
 drivers/net/wireless/ath9k/main.c   |   23 +-
 drivers/net/wireless/ath9k/xmit.c   |  611 +++++++++++++++++------------------
 4 files changed, 324 insertions(+), 342 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 9e15c30..b36d3fb 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -114,7 +114,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	ath9k_hw_set11n_txdesc(ah, ds,
 			       skb->len + FCS_LEN,     /* frame length */
 			       ATH9K_PKT_TYPE_BEACON,  /* Atheros packet type */
-			       avp->av_btxctl.txpower, /* txpower XXX */
+			       MAX_RATE_POWER,         /* FIXME */
 			       ATH9K_TXKEYIX_INVALID,  /* no encryption */
 			       ATH9K_KEY_TYPE_CLEAR,   /* no encryption */
 			       flags                   /* no ack,
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index d8aafff..21b572b 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -84,9 +84,6 @@ struct ath_node;
 #define TSF_TO_TU(_h,_l) \
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 
-#define ATH9K_BH_STATUS_INTACT		0
-#define ATH9K_BH_STATUS_CHANGE		1
-
 #define	ATH_TXQ_SETUP(sc, i)        ((sc)->sc_txqsetup & (1<<i))
 
 static inline unsigned long get_timestamp(void)
@@ -209,6 +206,7 @@ struct ath_buf_state {
 	struct ath_rc_series bfs_rcs[4];	/* rate series */
 	u32 bf_type;				/* BUF_* (enum buffer_type) */
 	/* key type use to encrypt this frame */
+	u32 bfs_keyix;
 	enum ath9k_key_type bfs_keytype;
 };
 
@@ -219,6 +217,7 @@ struct ath_buf_state {
 #define bf_seqno        	bf_state.bfs_seqno
 #define bf_tidno        	bf_state.bfs_tidno
 #define bf_rcs          	bf_state.bfs_rcs
+#define bf_keyix                bf_state.bfs_keyix
 #define bf_keytype      	bf_state.bfs_keytype
 #define bf_isdata(bf)		(bf->bf_state.bf_type & BUF_DATA)
 #define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
@@ -244,7 +243,6 @@ struct ath_buf {
 	struct ath_buf *bf_next;	/* next subframe in the aggregate */
 	struct ath_buf *bf_rifslast;	/* last buf for RIFS burst */
 	void *bf_mpdu;			/* enclosing frame structure */
-	void *bf_node;			/* pointer to the node */
 	struct ath_desc *bf_desc;	/* virtual addr of desc */
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
@@ -493,24 +491,8 @@ struct ath_atx {
 
 /* per-frame tx control block */
 struct ath_tx_control {
-	struct ath_node *an;
+	struct ath_txq *txq;
 	int if_id;
-	int qnum;
-	u32 ht:1;
-	u32 ps:1;
-	u32 use_minrate:1;
-	enum ath9k_pkt_type atype;
-	enum ath9k_key_type keytype;
-	u32 flags;
-	u16 seqno;
-	u16 tidno;
-	u16 txpower;
-	u16 frmlen;
-	u32 keyix;
-	int min_rate;
-	int mcast_rate;
-	struct ath_softc *dev;
-	dma_addr_t dmacontext;
 };
 
 /* per frame tx status block */
@@ -551,15 +533,17 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
 int ath_tx_cleanup(struct ath_softc *sc);
 int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype);
+struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb);
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *q);
-int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb);
+int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
+		 struct ath_tx_control *txctl);
 void ath_tx_tasklet(struct ath_softc *sc);
 u32 ath_txq_depth(struct ath_softc *sc, int qnum);
 u32 ath_txq_aggr_depth(struct ath_softc *sc, int qnum);
 void ath_notify_txq_status(struct ath_softc *sc, u16 queue_depth);
 void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
-		     struct ath_xmit_status *tx_status, struct ath_node *an);
+		     struct ath_xmit_status *tx_status);
 void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb);
 
 /**********************/
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index d008f0d..eca39ed 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -413,7 +413,7 @@ void ath_get_beaconconfig(struct ath_softc *sc,
 }
 
 void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
-		     struct ath_xmit_status *tx_status, struct ath_node *an)
+		     struct ath_xmit_status *tx_status)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -907,6 +907,7 @@ static int ath_attach(u16 devid,
 	}
 
 	hw->queues = 4;
+	hw->sta_data_size = sizeof(struct ath_node);
 
 	/* Register rate control */
 	hw->rate_control_algorithm = "ath9k_rate_control";
@@ -1017,9 +1018,12 @@ static int ath9k_start(struct ieee80211_hw *hw)
 static int ath9k_tx(struct ieee80211_hw *hw,
 		    struct sk_buff *skb)
 {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath_softc *sc = hw->priv;
+	struct ath_tx_control txctl;
 	int hdrlen, padsize;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	memset(&txctl, 0, sizeof(struct ath_tx_control));
 
 	/*
 	 * As a temporary workaround, assign seq# here; this will likely need
@@ -1044,18 +1048,25 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 		memmove(skb->data, skb->data + padsize, hdrlen);
 	}
 
+	/* Check if a tx queue is available */
+
+	txctl.txq = ath_test_get_txq(sc, skb);
+	if (!txctl.txq)
+		goto exit;
+
 	DPRINTF(sc, ATH_DBG_XMIT, "%s: transmitting packet, skb: %p\n",
 		__func__,
 		skb);
 
-	if (ath_tx_start(sc, skb) != 0) {
+	if (ath_tx_start(sc, skb, &txctl) != 0) {
 		DPRINTF(sc, ATH_DBG_XMIT, "%s: TX failed\n", __func__);
-		dev_kfree_skb_any(skb);
-		/* FIXME: Check for proper return value from ATH_DEV */
-		return 0;
+		goto exit;
 	}
 
 	return 0;
+exit:
+	dev_kfree_skb_any(skb);
+	return 0;
 }
 
 static void ath9k_stop(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index bea03db..defd699 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -136,15 +136,17 @@ static int ath_aggr_query(struct ath_softc *sc,
 		return 0;
 }
 
-static enum ath9k_pkt_type get_hal_packet_type(struct ieee80211_hdr *hdr)
+/* Calculate Atheros packet type from IEEE80211 packet header */
+
+static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
 {
+	struct ieee80211_hdr *hdr;
 	enum ath9k_pkt_type htype;
 	__le16 fc;
 
+	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
 
-	/* Calculate Atheros packet type from IEEE80211 packet header */
-
 	if (ieee80211_is_beacon(fc))
 		htype = ATH9K_PKT_TYPE_BEACON;
 	else if (ieee80211_is_probe_resp(fc))
@@ -159,214 +161,176 @@ static enum ath9k_pkt_type get_hal_packet_type(struct ieee80211_hdr *hdr)
 	return htype;
 }
 
-static void fill_min_rates(struct sk_buff *skb, struct ath_tx_control *txctl)
+static bool check_min_rate(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ath_tx_info_priv *tx_info_priv;
+	bool use_minrate = false;
 	__le16 fc;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
 
-	/* XXX: HACK! */
-	tx_info_priv = (struct ath_tx_info_priv *)tx_info->control.vif;
-
 	if (ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc)) {
-		txctl->use_minrate = 1;
-		txctl->min_rate = tx_info_priv->min_rate;
+		use_minrate = true;
 	} else if (ieee80211_is_data(fc)) {
 		if (ieee80211_is_nullfunc(fc) ||
-				/* Port Access Entity (IEEE 802.1X) */
-				(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
-			txctl->use_minrate = 1;
-			txctl->min_rate = tx_info_priv->min_rate;
+		    /* Port Access Entity (IEEE 802.1X) */
+		    (skb->protocol == cpu_to_be16(ETH_P_PAE))) {
+			use_minrate = true;
 		}
-		if (is_multicast_ether_addr(hdr->addr1))
-			txctl->mcast_rate = tx_info_priv->min_rate;
 	}
 
+	return use_minrate;
 }
 
-/* This function will setup additional txctl information, mostly rate stuff */
-/* FIXME: seqno, ps */
-static int ath_tx_prepare(struct ath_softc *sc,
-			  struct sk_buff *skb,
-			  struct ath_tx_control *txctl)
+static int get_hw_crypto_keytype(struct sk_buff *skb)
 {
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_hdr *hdr;
-	struct ath_rc_series *rcs;
-	struct ath_txq *txq = NULL;
-	const struct ath9k_rate_table *rt;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ath_tx_info_priv *tx_info_priv;
-	int hdrlen;
-	u8 rix, antenna;
-	__le16 fc;
-	u8 *qc;
-
-	txctl->dev = sc;
-	hdr = (struct ieee80211_hdr *)skb->data;
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	fc = hdr->frame_control;
-
-	rt = sc->sc_currates;
-	BUG_ON(!rt);
-
-	if (ieee80211_is_data_qos(fc)) {
-		qc = ieee80211_get_qos_ctl(hdr);
-		txctl->tidno = qc[0] & 0xf;
-	}
-
-	txctl->if_id = 0;
-	txctl->frmlen = skb->len + FCS_LEN - (hdrlen & 3);
-
-	/* Always try at highest power possible unless the the device
-	 * was configured by the user to use another power. */
-	if (likely(sc->sc_config.txpowlimit == ATH_TXPOWER_MAX))
-		txctl->txpower = ATH_TXPOWER_MAX;
-	else
-		txctl->txpower = sc->sc_config.txpowlimit;
-
-	/* Fill Key related fields */
-
-	txctl->keytype = ATH9K_KEY_TYPE_CLEAR;
-	txctl->keyix = ATH9K_TXKEYIX_INVALID;
 
 	if (tx_info->control.hw_key) {
-		txctl->keyix = tx_info->control.hw_key->hw_key_idx;
-		txctl->frmlen += tx_info->control.hw_key->icv_len;
-
 		if (tx_info->control.hw_key->alg == ALG_WEP)
-			txctl->keytype = ATH9K_KEY_TYPE_WEP;
+			return ATH9K_KEY_TYPE_WEP;
 		else if (tx_info->control.hw_key->alg == ALG_TKIP)
-			txctl->keytype = ATH9K_KEY_TYPE_TKIP;
+			return ATH9K_KEY_TYPE_TKIP;
 		else if (tx_info->control.hw_key->alg == ALG_CCMP)
-			txctl->keytype = ATH9K_KEY_TYPE_AES;
+			return ATH9K_KEY_TYPE_AES;
 	}
 
-	/* Fill packet type */
-
-	txctl->atype = get_hal_packet_type(hdr);
-
-	/* Fill qnum */
+	return ATH9K_KEY_TYPE_CLEAR;
+}
 
-	if (unlikely(txctl->flags & ATH9K_TXDESC_CAB)) {
-		txctl->qnum = 0;
-		txq = sc->sc_cabq;
-	} else {
-		txctl->qnum = ath_get_hal_qnum(skb_get_queue_mapping(skb), sc);
-		txq = &sc->sc_txq[txctl->qnum];
-	}
-	spin_lock_bh(&txq->axq_lock);
+static void setup_rate_retries(struct ath_softc *sc, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ath_tx_info_priv *tx_info_priv;
+	struct ath_rc_series *rcs;
+	struct ieee80211_hdr *hdr;
+	const struct ath9k_rate_table *rt;
+	bool use_minrate;
+	__le16 fc;
+	u8 rix;
 
-	/* Try to avoid running out of descriptors */
-	if (txq->axq_depth >= (ATH_TXBUF - 20) &&
-	    !(txctl->flags & ATH9K_TXDESC_CAB)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: TX queue: %d is full, depth: %d\n",
-			__func__,
-			txctl->qnum,
-			txq->axq_depth);
-		ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
-		txq->stopped = 1;
-		spin_unlock_bh(&txq->axq_lock);
-		return -1;
-	}
+	rt = sc->sc_currates;
+	BUG_ON(!rt);
 
-	spin_unlock_bh(&txq->axq_lock);
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+	tx_info_priv = (struct ath_tx_info_priv *)tx_info->control.vif; /* HACK */
+	rcs = tx_info_priv->rcs;
 
-	/* Fill rate */
+	/* Check if min rates have to be used */
+	use_minrate = check_min_rate(skb);
 
-	fill_min_rates(skb, txctl);
+	if (ieee80211_is_data(fc) && !use_minrate) {
+		if (is_multicast_ether_addr(hdr->addr1)) {
+			rcs[0].rix =
+				ath_tx_findindex(rt, tx_info_priv->min_rate);
+			/* mcast packets are not re-tried */
+			rcs[0].tries = 1;
+		}
+	} else {
+		/* for management and control frames,
+		   or for NULL and EAPOL frames */
+		if (use_minrate)
+			rcs[0].rix = ath_rate_findrateix(sc, tx_info_priv->min_rate);
+		else
+			rcs[0].rix = 0;
+		rcs[0].tries = ATH_MGT_TXMAXTRY;
+	}
 
-	/* Fill flags */
+	rix = rcs[0].rix;
 
-	txctl->flags |= ATH9K_TXDESC_CLRDMASK /* needed for crypto errors */
-		| ATH9K_TXDESC_INTREQ; /* Generate an interrupt */
+	if (ieee80211_has_morefrags(fc) ||
+	    (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
+		rcs[1].tries = rcs[2].tries = rcs[3].tries = 0;
+		rcs[1].rix = rcs[2].rix = rcs[3].rix = 0;
+		/* reset tries but keep rate index */
+		rcs[0].tries = ATH_TXMAXTRY;
+	}
+}
 
-	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
-		txctl->flags |= ATH9K_TXDESC_NOACK;
+/* Called only when tx aggregation is enabled and HT is supported */
 
-	if (tx_info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
-		txctl->flags |= ATH9K_TXDESC_RTSENA;
+static void assign_aggr_tid_seqno(struct sk_buff *skb,
+				  struct ath_buf *bf)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr;
+	struct ath_node *an;
+	struct ath_atx_tid *tid;
+	__le16 fc;
+	u8 *qc;
 
-	/*
-	 * Setup for rate calculations.
-	 */
+	if (!tx_info->control.sta)
+		return;
 
-	/* XXX: HACK! */
-	tx_info_priv = (struct ath_tx_info_priv *)tx_info->control.vif;
-	rcs = tx_info_priv->rcs;
+	an = (struct ath_node *)tx_info->control.sta->drv_priv;
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
 
-	if (ieee80211_is_data(fc) && !txctl->use_minrate) {
+	/* Get tidno */
 
-		/* Enable HT only for DATA frames and not for EAPOL */
-		/* XXX why AMPDU only?? */
-		txctl->ht = (hw->conf.ht.enabled &&
-			    (tx_info->flags & IEEE80211_TX_CTL_AMPDU));
+	if (ieee80211_is_data_qos(fc)) {
+		qc = ieee80211_get_qos_ctl(hdr);
+		bf->bf_tidno = qc[0] & 0xf;
+	}
 
-		if (is_multicast_ether_addr(hdr->addr1)) {
-			rcs[0].rix = (u8)
-				ath_tx_findindex(rt, txctl->mcast_rate);
+	/* Get seqno */
 
-			/*
-			 * mcast packets are not re-tried.
-			 */
-			rcs[0].tries = 1;
-		}
+	if (ieee80211_is_data(fc) && !check_min_rate(skb)) {
 		/* For HT capable stations, we save tidno for later use.
 		 * We also override seqno set by upper layer with the one
 		 * in tx aggregation state.
 		 *
-		 * First, the fragmentation stat is determined.
 		 * If fragmentation is on, the sequence number is
 		 * not overridden, since it has been
 		 * incremented by the fragmentation routine.
+		 *
+		 * FIXME: check if the fragmentation threshold exceeds
+		 * IEEE80211 max.
 		 */
-		if (likely(!(txctl->flags & ATH9K_TXDESC_FRAG_IS_ON)) &&
-		    txctl->ht && (sc->sc_flags & SC_OP_TXAGGR)) {
-			struct ath_atx_tid *tid;
+		tid = ATH_AN_2_TID(an, bf->bf_tidno);
+		hdr->seq_ctrl = cpu_to_le16(tid->seq_next <<
+					    IEEE80211_SEQ_SEQ_SHIFT);
+		bf->bf_seqno = tid->seq_next;
+		INCR(tid->seq_next, IEEE80211_SEQ_MAX);
+	}
+}
 
-			tid = ATH_AN_2_TID(txctl->an, txctl->tidno);
+static int setup_tx_flags(struct ath_softc *sc, struct sk_buff *skb,
+			  struct ath_txq *txq)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	int flags = 0;
 
-			hdr->seq_ctrl = cpu_to_le16(tid->seq_next <<
-				IEEE80211_SEQ_SEQ_SHIFT);
-			txctl->seqno = tid->seq_next;
-			INCR(tid->seq_next, IEEE80211_SEQ_MAX);
-		}
-	} else {
-		/* for management and control frames,
-		 * or for NULL and EAPOL frames */
-		if (txctl->min_rate)
-			rcs[0].rix = ath_rate_findrateix(sc, txctl->min_rate);
-		else
-			rcs[0].rix = 0;
-		rcs[0].tries = ATH_MGT_TXMAXTRY;
-	}
-	rix = rcs[0].rix;
+	flags |= ATH9K_TXDESC_CLRDMASK; /* needed for crypto errors */
+	flags |= ATH9K_TXDESC_INTREQ;
 
-	if (ieee80211_has_morefrags(fc) ||
-	    (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
-		/*
-		**  Force hardware to use computed duration for next
-		**  fragment by disabling multi-rate retry, which
-		**  updates duration based on the multi-rate
-		**  duration table.
-		*/
-		rcs[1].tries = rcs[2].tries = rcs[3].tries = 0;
-		rcs[1].rix = rcs[2].rix = rcs[3].rix = 0;
-		/* reset tries but keep rate index */
-		rcs[0].tries = ATH_TXMAXTRY;
-	}
+	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
+		flags |= ATH9K_TXDESC_NOACK;
+	if (tx_info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
+		flags |= ATH9K_TXDESC_RTSENA;
+
+	return flags;
+}
 
-	if (is_multicast_ether_addr(hdr->addr1)) {
-		antenna = sc->sc_mcastantenna + 1;
-		sc->sc_mcastantenna = (sc->sc_mcastantenna + 1) & 0x1;
+static struct ath_buf *ath_tx_get_buffer(struct ath_softc *sc)
+{
+	struct ath_buf *bf = NULL;
+
+	spin_lock_bh(&sc->sc_txbuflock);
+
+	if (unlikely(list_empty(&sc->sc_txbuf))) {
+		spin_unlock_bh(&sc->sc_txbuflock);
+		return NULL;
 	}
 
-	return 0;
+	bf = list_first_entry(&sc->sc_txbuf, struct ath_buf, list);
+	list_del(&bf->list);
+
+	spin_unlock_bh(&sc->sc_txbuflock);
+
+	return bf;
 }
 
 /* To complete a chain of buffers associated a frame */
@@ -402,7 +366,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc,
 			 skb->len,
 			 PCI_DMA_TODEVICE);
 	/* complete this frame */
-	ath_tx_complete(sc, skb, &tx_status, bf->bf_node);
+	ath_tx_complete(sc, skb, &tx_status);
 
 	/*
 	 * Return the list of ath_buf of this mpdu to free queue
@@ -615,7 +579,15 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	u32 ctsduration = 0;
 	u8 rix = 0, cix, ctsrate = 0;
 	u32 aggr_limit_with_rts = ah->ah_caps.rts_aggr_limit;
-	struct ath_node *an = (struct ath_node *) bf->bf_node;
+	struct ath_node *an = NULL;
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *tx_info;
+
+	skb = (struct sk_buff *)bf->bf_mpdu;
+	tx_info = IEEE80211_SKB_CB(skb);
+
+	if (tx_info->control.sta)
+		an = (struct ath_node *)tx_info->control.sta->drv_priv;
 
 	/*
 	 * get the cix for the lowest valid rix.
@@ -654,7 +626,6 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	 * use RTS.
 	 */
 	if ((ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) && bf_isdata(bf)) {
-		BUG_ON(!an);
 		/*
 		 * 802.11g protection not needed, use our default behavior
 		 */
@@ -664,7 +635,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		 * For dynamic MIMO PS, RTS needs to precede the first aggregate
 		 * and the second aggregate should have any protection at all.
 		 */
-		if (an->an_smmode == ATH_SM_PWRSAV_DYNAMIC) {
+		if (an && an->an_smmode == ATH_SM_PWRSAV_DYNAMIC) {
 			if (!bf_isaggrburst(bf)) {
 				flags = ATH9K_TXDESC_RTSENA;
 				dynamic_mimops = 1;
@@ -736,7 +707,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 			(bf->bf_rcs[i].flags & ATH_RC_SGI_FLAG),
 			bf_isshpreamble(bf));
 
-		if ((an->an_smmode == ATH_SM_PWRSAV_STATIC) &&
+		if (an && (an->an_smmode == ATH_SM_PWRSAV_STATIC) &&
 		    (bf->bf_rcs[i].flags & ATH_RC_DS_FLAG) == 0) {
 			/*
 			 * When sending to an HT node that has enabled static
@@ -888,8 +859,10 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 				      struct list_head *bf_q,
 				      int txok)
 {
-	struct ath_node *an = bf->bf_node;
-	struct ath_atx_tid *tid = ATH_AN_2_TID(an, bf->bf_tidno);
+	struct ath_node *an = NULL;
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *tx_info;
+	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf_last = bf->bf_lastbf;
 	struct ath_desc *ds = bf_last->bf_desc;
 	struct ath_buf *bf_next, *bf_lastq = NULL;
@@ -898,6 +871,14 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0;
 
+	skb = (struct sk_buff *)bf->bf_mpdu;
+	tx_info = IEEE80211_SKB_CB(skb);
+
+	if (tx_info->control.sta) {
+		an = (struct ath_node *)tx_info->control.sta->drv_priv;
+		tid = ATH_AN_2_TID(an, bf->bf_tidno);
+	}
+
 	isaggr = bf_isaggr(bf);
 	if (isaggr) {
 		if (txok) {
@@ -1030,7 +1011,6 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 
 				/* copy descriptor content */
 				tbf->bf_mpdu = bf_last->bf_mpdu;
-				tbf->bf_node = bf_last->bf_node;
 				tbf->bf_buf_addr = bf_last->bf_buf_addr;
 				*(tbf->bf_desc) = *(bf_last->bf_desc);
 
@@ -1364,7 +1344,6 @@ static void ath_tx_addto_baw(struct ath_softc *sc,
  */
 
 static int ath_tx_send_ampdu(struct ath_softc *sc,
-			     struct ath_txq *txq,
 			     struct ath_atx_tid *tid,
 			     struct list_head *bf_head,
 			     struct ath_tx_control *txctl)
@@ -1378,8 +1357,6 @@ static int ath_tx_send_ampdu(struct ath_softc *sc,
 
 	bf = list_first_entry(bf_head, struct ath_buf, list);
 	bf->bf_state.bf_type |= BUF_AMPDU;
-	bf->bf_seqno = txctl->seqno; /* save seqno and tidno in buffer */
-	bf->bf_tidno = txctl->tidno;
 
 	/*
 	 * Do not queue to h/w when any of the following conditions is true:
@@ -1390,13 +1367,13 @@ static int ath_tx_send_ampdu(struct ath_softc *sc,
 	 */
 	if (!list_empty(&tid->buf_q) || tid->paused ||
 	    !BAW_WITHIN(tid->seq_start, tid->baw_size, bf->bf_seqno) ||
-	    txq->axq_depth >= ATH_AGGR_MIN_QDEPTH) {
+	    txctl->txq->axq_depth >= ATH_AGGR_MIN_QDEPTH) {
 		/*
 		 * Add this frame to software queue for scheduling later
 		 * for aggregation.
 		 */
 		list_splice_tail_init(bf_head, &tid->buf_q);
-		ath_tx_queue_tid(txq, tid);
+		ath_tx_queue_tid(txctl->txq, tid);
 		return 0;
 	}
 
@@ -1413,7 +1390,7 @@ static int ath_tx_send_ampdu(struct ath_softc *sc,
 	bf->bf_nframes = 1;
 	bf->bf_lastbf = bf->bf_lastfrm; /* one single frame */
 	ath_buf_set_rate(sc, bf);
-	ath_tx_txqaddbuf(sc, txq, bf_head);
+	ath_tx_txqaddbuf(sc, txctl->txq, bf_head);
 	return 0;
 }
 
@@ -1836,46 +1813,27 @@ static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 	}
 }
 
-static int ath_tx_start_dma(struct ath_softc *sc,
-			    struct sk_buff *skb,
-			    struct scatterlist *sg,
-			    u32 n_sg,
-			    struct ath_tx_control *txctl)
+static void ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
+				struct sk_buff *skb, struct scatterlist *sg,
+				struct ath_tx_control *txctl)
 {
-	struct ath_node *an = txctl->an;
-	struct ath_buf *bf = NULL;
-	struct list_head bf_head;
-	struct ath_desc *ds;
-	struct ath_hal *ah = sc->sc_ah;
-	struct ath_txq *txq;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath_tx_info_priv *tx_info_priv;
 	struct ath_rc_series *rcs;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_tx_info *tx_info =  IEEE80211_SKB_CB(skb);
-	__le16 fc = hdr->frame_control;
-
-	if (unlikely(txctl->flags & ATH9K_TXDESC_CAB))
-		txq = sc->sc_cabq;
-	else
-		txq = &sc->sc_txq[txctl->qnum];
+	int hdrlen;
+	__le16 fc;
 
-	/* For each sglist entry, allocate an ath_buf for DMA */
-	INIT_LIST_HEAD(&bf_head);
-	spin_lock_bh(&sc->sc_txbuflock);
-	if (unlikely(list_empty(&sc->sc_txbuf))) {
-		spin_unlock_bh(&sc->sc_txbuflock);
-		return -ENOMEM;
-	}
+	tx_info_priv = (struct ath_tx_info_priv *)tx_info->control.vif;
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	fc = hdr->frame_control;
+	rcs = tx_info_priv->rcs;
 
-	bf = list_first_entry(&sc->sc_txbuf, struct ath_buf, list);
-	list_del(&bf->list);
-	spin_unlock_bh(&sc->sc_txbuflock);
+	ATH_TXBUF_RESET(bf);
 
-	list_add_tail(&bf->list, &bf_head);
+	/* Frame type */
 
-	/* set up this buffer */
-	ATH_TXBUF_RESET(bf);
-	bf->bf_frmlen = txctl->frmlen;
+	bf->bf_frmlen = skb->len + FCS_LEN - (hdrlen & 3);
 
 	ieee80211_is_data(fc) ?
 		(bf->bf_state.bf_type |= BUF_DATA) :
@@ -1889,121 +1847,143 @@ static int ath_tx_start_dma(struct ath_softc *sc,
 	(sc->sc_flags & SC_OP_PREAMBLE_SHORT) ?
 		(bf->bf_state.bf_type |= BUF_SHORT_PREAMBLE) :
 		(bf->bf_state.bf_type &= ~BUF_SHORT_PREAMBLE);
+	(sc->hw->conf.ht.enabled &&
+	 (tx_info->flags & IEEE80211_TX_CTL_AMPDU)) ?
+		(bf->bf_state.bf_type |= BUF_HT) :
+		(bf->bf_state.bf_type &= ~BUF_HT);
+
+	bf->bf_flags = setup_tx_flags(sc, skb, txctl->txq);
+
+	/* Crypto */
+
+	bf->bf_keytype = get_hw_crypto_keytype(skb);
+
+	if (bf->bf_keytype != ATH9K_KEY_TYPE_CLEAR) {
+		bf->bf_frmlen += tx_info->control.hw_key->icv_len;
+		bf->bf_keyix = tx_info->control.hw_key->hw_key_idx;
+	} else {
+		bf->bf_keyix = ATH9K_TXKEYIX_INVALID;
+	}
+
+	/* Rate series */
+
+	setup_rate_retries(sc, skb);
 
-	bf->bf_flags = txctl->flags;
-	bf->bf_keytype = txctl->keytype;
-	/* XXX: HACK! */
-	tx_info_priv = (struct ath_tx_info_priv *)tx_info->control.vif;
-	rcs = tx_info_priv->rcs;
 	bf->bf_rcs[0] = rcs[0];
 	bf->bf_rcs[1] = rcs[1];
 	bf->bf_rcs[2] = rcs[2];
 	bf->bf_rcs[3] = rcs[3];
-	bf->bf_node = an;
+
+	/* Assign seqno, tidno */
+
+	if (bf_isht(bf) && (sc->sc_flags & SC_OP_TXAGGR))
+		assign_aggr_tid_seqno(skb, bf);
+
+	/* DMA setup */
+
 	bf->bf_mpdu = skb;
-	bf->bf_buf_addr = sg_dma_address(sg);
+	bf->bf_dmacontext = pci_map_single(sc->pdev, skb->data,
+					   skb->len, PCI_DMA_TODEVICE);
+	bf->bf_buf_addr = bf->bf_dmacontext;
+}
+
+/* FIXME: tx power */
+static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
+			     struct scatterlist *sg, u32 n_sg,
+			     struct ath_tx_control *txctl)
+{
+	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
+	struct ieee80211_tx_info *tx_info =  IEEE80211_SKB_CB(skb);
+	struct ath_node *an = NULL;
+	struct list_head bf_head;
+	struct ath_desc *ds;
+	struct ath_atx_tid *tid;
+	struct ath_hal *ah = sc->sc_ah;
+	int frm_type;
+
+	if (tx_info->control.sta) {
+		an = (struct ath_node *)tx_info->control.sta->drv_priv;
+		tid = ATH_AN_2_TID(an, bf->bf_tidno);
+	}
+
+	frm_type = get_hw_packet_type(skb);
+
+	INIT_LIST_HEAD(&bf_head);
+	list_add_tail(&bf->list, &bf_head);
 
 	/* setup descriptor */
+
 	ds = bf->bf_desc;
 	ds->ds_link = 0;
 	ds->ds_data = bf->bf_buf_addr;
 
-	/*
-	 * Save the DMA context in the first ath_buf
-	 */
-	bf->bf_dmacontext = txctl->dmacontext;
+	/* Formulate first tx descriptor with tx controls */
 
-	/*
-	 * Formulate first tx descriptor with tx controls.
-	 */
-	ath9k_hw_set11n_txdesc(ah,
-			       ds,
-			       bf->bf_frmlen, /* frame length */
-			       txctl->atype, /* Atheros packet type */
-			       min(txctl->txpower, (u16)60), /* txpower */
-			       txctl->keyix,            /* key cache index */
-			       txctl->keytype,          /* key type */
-			       txctl->flags);           /* flags */
-	ath9k_hw_filltxdesc(ah,
-			    ds,
-			    sg_dma_len(sg),     /* segment length */
-			    true,            /* first segment */
-			    (n_sg == 1) ? true : false, /* last segment */
-			    ds);                /* first descriptor */
+	ath9k_hw_set11n_txdesc(ah, ds, bf->bf_frmlen, frm_type, MAX_RATE_POWER,
+			       bf->bf_keyix, bf->bf_keytype, bf->bf_flags);
+
+	ath9k_hw_filltxdesc(ah, ds,
+			    sg_dma_len(sg),		/* segment length */
+			    true,			/* first segment */
+			    (n_sg == 1) ? true : false,	/* last segment */
+			    ds);			/* first descriptor */
 
 	bf->bf_lastfrm = bf;
-	(txctl->ht) ?
-		(bf->bf_state.bf_type |= BUF_HT) :
-		(bf->bf_state.bf_type &= ~BUF_HT);
 
-	spin_lock_bh(&txq->axq_lock);
+	spin_lock_bh(&txctl->txq->axq_lock);
 
-	if (txctl->ht && (sc->sc_flags & SC_OP_TXAGGR)) {
-		struct ath_atx_tid *tid = ATH_AN_2_TID(an, txctl->tidno);
-		if (ath_aggr_query(sc, an, txctl->tidno)) {
+	if (bf_isht(bf) && (sc->sc_flags & SC_OP_TXAGGR)) {
+		if (ath_aggr_query(sc, an, bf->bf_tidno)) {
 			/*
 			 * Try aggregation if it's a unicast data frame
 			 * and the destination is HT capable.
 			 */
-			ath_tx_send_ampdu(sc, txq, tid, &bf_head, txctl);
+			ath_tx_send_ampdu(sc, tid, &bf_head, txctl);
 		} else {
 			/*
-			 * Send this frame as regular when ADDBA exchange
-			 * is neither complete nor pending.
+			 * Send this frame as regular when ADDBA
+			 * exchange is neither complete nor pending.
 			 */
-			ath_tx_send_normal(sc, txq, tid, &bf_head);
+			ath_tx_send_normal(sc, txctl->txq,
+					   tid, &bf_head);
 		}
 	} else {
 		bf->bf_lastbf = bf;
 		bf->bf_nframes = 1;
-		ath_buf_set_rate(sc, bf);
-
-		if (ieee80211_is_back_req(fc)) {
-			/* This is required for resuming tid
-			 * during BAR completion */
-			bf->bf_tidno = txctl->tidno;
-		}
 
-		ath_tx_txqaddbuf(sc, txq, &bf_head);
+		ath_buf_set_rate(sc, bf);
+		ath_tx_txqaddbuf(sc, txctl->txq, &bf_head);
 	}
-	spin_unlock_bh(&txq->axq_lock);
-	return 0;
+
+	spin_unlock_bh(&txctl->txq->axq_lock);
 }
 
-static void xmit_map_sg(struct ath_softc *sc,
-			struct sk_buff *skb,
-			struct ath_tx_control *txctl)
+int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
+		 struct ath_tx_control *txctl)
 {
-	struct ath_xmit_status tx_status;
-	struct ath_atx_tid *tid;
+	struct ath_buf *bf;
 	struct scatterlist sg;
 
-	txctl->dmacontext = pci_map_single(sc->pdev, skb->data,
-					   skb->len, PCI_DMA_TODEVICE);
+	/* Check if a tx buffer is available */
+
+	bf = ath_tx_get_buffer(sc);
+	if (!bf) {
+		DPRINTF(sc, ATH_DBG_XMIT, "%s: TX buffers are full\n",
+			__func__);
+		return -1;
+	}
+
+	ath_tx_setup_buffer(sc, bf, skb, &sg, txctl);
+
+	/* Setup S/G */
 
-	/* setup S/G list */
 	memset(&sg, 0, sizeof(struct scatterlist));
-	sg_dma_address(&sg) = txctl->dmacontext;
+	sg_dma_address(&sg) = bf->bf_dmacontext;
 	sg_dma_len(&sg) = skb->len;
 
-	if (ath_tx_start_dma(sc, skb, &sg, 1, txctl) != 0) {
-		/*
-		 *  We have to do drop frame here.
-		 */
-		pci_unmap_single(sc->pdev, txctl->dmacontext,
-				 skb->len, PCI_DMA_TODEVICE);
-
-		tx_status.retries = 0;
-		tx_status.flags = ATH_TX_ERROR;
+	ath_tx_start_dma(sc, bf, &sg, 1, txctl);
 
-		if (txctl->ht && (sc->sc_flags & SC_OP_TXAGGR)) {
-			/* Reclaim the seqno. */
-			tid = ATH_AN_2_TID((struct ath_node *)
-				txctl->an, txctl->tidno);
-			DECR(tid->seq_next, IEEE80211_SEQ_MAX);
-		}
-		ath_tx_complete(sc, skb, &tx_status, txctl->an);
-	}
+	return 0;
 }
 
 /* Initialize TX queue and h/w */
@@ -2189,6 +2169,34 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 	return qnum;
 }
 
+/* Get a transmit queue, if available */
+
+struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb)
+{
+	struct ath_txq *txq = NULL;
+	int qnum;
+
+	qnum = ath_get_hal_qnum(skb_get_queue_mapping(skb), sc);
+	txq = &sc->sc_txq[qnum];
+
+	spin_lock_bh(&txq->axq_lock);
+
+	/* Try to avoid running out of descriptors */
+	if (txq->axq_depth >= (ATH_TXBUF - 20)) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: TX queue: %d is full, depth: %d\n",
+			__func__, qnum, txq->axq_depth);
+		ieee80211_stop_queue(sc->hw, skb_get_queue_mapping(skb));
+		txq->stopped = 1;
+		spin_unlock_bh(&txq->axq_lock);
+		return NULL;
+	}
+
+	spin_unlock_bh(&txq->axq_lock);
+
+	return txq;
+}
+
 /* Update parameters for a transmit queue */
 
 int ath_txq_update(struct ath_softc *sc, int qnum,
@@ -2252,25 +2260,6 @@ int ath_cabq_update(struct ath_softc *sc)
 	return 0;
 }
 
-int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb)
-{
-	struct ath_tx_control txctl;
-	int error = 0;
-
-	memset(&txctl, 0, sizeof(struct ath_tx_control));
-	error = ath_tx_prepare(sc, skb, &txctl);
-	if (error == 0)
-		/*
-		 * Start DMA mapping.
-		 * ath_tx_start_dma() will be called either synchronously
-		 * or asynchrounsly once DMA is complete.
-		 */
-		xmit_map_sg(sc, skb, &txctl);
-
-	/* failed packets will be dropped by the caller */
-	return error;
-}
-
 /* Deferred processing of transmit interrupt */
 
 void ath_tx_tasklet(struct ath_softc *sc)
@@ -2669,6 +2658,8 @@ void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_control txctl;
 
+	memset(&txctl, 0, sizeof(struct ath_tx_control));
+
 	/*
 	 * As a temporary workaround, assign seq# here; this will likely need
 	 * to be cleaned up to work better with Beacon transmission and virtual
@@ -2696,22 +2687,18 @@ void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb)
 		memmove(skb->data, skb->data + padsize, hdrlen);
 	}
 
+	txctl.txq = sc->sc_cabq;
+
 	DPRINTF(sc, ATH_DBG_XMIT, "%s: transmitting CABQ packet, skb: %p\n",
 		__func__,
 		skb);
 
-	memset(&txctl, 0, sizeof(struct ath_tx_control));
-	txctl.flags = ATH9K_TXDESC_CAB;
-	if (ath_tx_prepare(sc, skb, &txctl) == 0) {
-		/*
-		 * Start DMA mapping.
-		 * ath_tx_start_dma() will be called either synchronously
-		 * or asynchrounsly once DMA is complete.
-		 */
-		xmit_map_sg(sc, skb, &txctl);
-	} else {
-		DPRINTF(sc, ATH_DBG_XMIT, "%s: TX CABQ failed\n", __func__);
-		dev_kfree_skb_any(skb);
+	if (ath_tx_start(sc, skb, &txctl) != 0) {
+		DPRINTF(sc, ATH_DBG_XMIT, "%s: TX failed\n", __func__);
+		goto exit;
 	}
-}
 
+	return;
+exit:
+	dev_kfree_skb_any(skb);
+}
-- 
1.6.0.3

