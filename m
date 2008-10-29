Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10950 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbYJ2Erx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:47:53 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:47:53 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.59996.255767.892114@gargle.gargle.HOWL> (sfid-20081029_054756_885409_E46F99E8)
Date: Wed, 29 Oct 2008 10:15:16 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 05/16] ath9k: Ensure ath_node is not NULL when updating tx chainmask
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, random indentation and whitespace cleanup.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    3 +-
 drivers/net/wireless/ath9k/rc.c   |    2 +-
 drivers/net/wireless/ath9k/recv.c |    6 ++--
 drivers/net/wireless/ath9k/xmit.c |   57 +++++++++++++++----------------------
 4 files changed, 28 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index eca39ed..831dc75 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -490,8 +490,7 @@ int _ath_rx_indicate(struct ath_softc *sc,
 	return 0;
 }
 
-int ath_rx_subframe(struct ath_node *an,
-		    struct sk_buff *skb,
+int ath_rx_subframe(struct ath_node *an, struct sk_buff *skb,
 		    struct ath_recv_status *status)
 {
 	struct ath_softc *sc = an->an_sc;
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index e254606..d55232a 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -816,7 +816,7 @@ void ath_rate_detach(struct ath_rate_softc *asc)
 }
 
 u8 ath_rate_findrateix(struct ath_softc *sc,
-			     u8 dot11rate)
+		       u8 dot11rate)
 {
 	const struct ath_rate_table *ratetable;
 	struct ath_rate_softc *rsc = sc->sc_rc;
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 27d6a98..80f26b4 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -356,8 +356,8 @@ static void ath_rx_timer(unsigned long data)
 
 /* Free all pending sub-frames in the re-ordering buffer */
 
-static void ath_rx_flush_tid(struct ath_softc *sc,
-	struct ath_arx_tid *rxtid, int drop)
+static void ath_rx_flush_tid(struct ath_softc *sc, struct ath_arx_tid *rxtid,
+			     int drop)
 {
 	struct ath_rxbuf *rxbuf;
 	unsigned long flag;
@@ -1218,7 +1218,7 @@ void ath_rx_node_init(struct ath_softc *sc, struct ath_node *an)
 		 * (needs to be allocated when addba is received)
 		 */
 
-		rxtid->rxbuf     = NULL;
+		rxtid->rxbuf = NULL;
 		setup_timer(&rxtid->timer, ath_rx_timer,
 			    (unsigned long)rxtid);
 		spin_lock_init(&rxtid->tidlock);
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index b3ba47d..8446ede 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -65,11 +65,12 @@ static u32 bits_per_symbol[][2] = {
  * NB: must be called with txq lock held
  */
 
-static void ath_tx_txqaddbuf(struct ath_softc *sc,
-		struct ath_txq *txq, struct list_head *head)
+static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
+			     struct list_head *head)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_buf *bf;
+
 	/*
 	 * Insert the frame on the outbound list and
 	 * pass it on to the hardware.
@@ -360,6 +361,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc,
 		if (bf_isxretried(bf))
 			tx_status.flags |= ATH_TX_XRETRY;
 	}
+
 	/* Unmap this frame */
 	pci_unmap_single(sc->pdev,
 			 bf->bf_dmacontext,
@@ -497,8 +499,8 @@ static void ath_tx_set_retry(struct ath_softc *sc, struct ath_buf *bf)
 
 /* Update block ack window */
 
-static void ath_tx_update_baw(struct ath_softc *sc,
-	struct ath_atx_tid *tid, int seqno)
+static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
+			      int seqno)
 {
 	int index, cindex;
 
@@ -522,12 +524,8 @@ static void ath_tx_update_baw(struct ath_softc *sc,
  * half_gi - to use 4us v/s 3.6 us for symbol time
  */
 
-static u32 ath_pkt_duration(struct ath_softc *sc,
-				  u8 rix,
-				  struct ath_buf *bf,
-				  int width,
-				  int half_gi,
-				  bool shortPreamble)
+static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
+			    int width, int half_gi, bool shortPreamble)
 {
 	const struct ath9k_rate_table *rt = sc->sc_currates;
 	u32 nbits, nsymbits, duration, nsymbols;
@@ -541,11 +539,8 @@ static u32 ath_pkt_duration(struct ath_softc *sc,
 	 * for legacy rates, use old function to compute packet duration
 	 */
 	if (!IS_HT_RATE(rc))
-		return ath9k_hw_computetxtime(sc->sc_ah,
-					     rt,
-					     pktlen,
-					     rix,
-					     shortPreamble);
+		return ath9k_hw_computetxtime(sc->sc_ah, rt, pktlen, rix,
+					      shortPreamble);
 	/*
 	 * find number of symbols: PLCP + data
 	 */
@@ -563,6 +558,7 @@ static u32 ath_pkt_duration(struct ath_softc *sc,
 	 */
 	streams = HT_RC_2_STREAMS(rc);
 	duration += L_STF + L_LTF + L_SIG + HT_SIG + HT_STF + HT_LTF(streams);
+
 	return duration;
 }
 
@@ -578,7 +574,6 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	int i, flags, rtsctsena = 0;
 	u32 ctsduration = 0;
 	u8 rix = 0, cix, ctsrate = 0;
-	u32 aggr_limit_with_rts = ah->ah_caps.rts_aggr_limit;
 	struct ath_node *an = NULL;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
@@ -646,7 +641,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	/*
 	 *  For AR5416 - RTS cannot be followed by a frame larger than 8K.
 	 */
-	if (bf_isaggr(bf) && (bf->bf_al > aggr_limit_with_rts)) {
+	if (bf_isaggr(bf) && (bf->bf_al > ah->ah_caps.rts_aggr_limit)) {
 		/*
 		 * Ensure that in the case of SM Dynamic power save
 		 * while we are bursting the second aggregate the
@@ -659,8 +654,8 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	 * CTS transmit rate is derived from the transmit rate
 	 * by looking in the h/w rate table.  We must also factor
 	 * in whether or not a short preamble is to be used.
+	 * NB: cix is set above where RTS/CTS is enabled
 	 */
-	/* NB: cix is set above where RTS/CTS is enabled */
 	BUG_ON(cix == 0xff);
 	ctsrate = rt->info[cix].rateCode |
 		(bf_isshpreamble(bf) ? rt->info[cix].shortPreamble : 0);
@@ -689,15 +684,13 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 			((bf->bf_rcs[i].flags & ATH_RC_SGI_FLAG) ?
 				ATH9K_RATESERIES_HALFGI : 0);
 
-		series[i].PktDuration = ath_pkt_duration(
-			sc, rix, bf,
-			(bf->bf_rcs[i].flags & ATH_RC_CW40_FLAG) != 0,
-			(bf->bf_rcs[i].flags & ATH_RC_SGI_FLAG),
-			bf_isshpreamble(bf));
+		series[i].PktDuration = ath_pkt_duration(sc, rix, bf,
+			 (bf->bf_rcs[i].flags & ATH_RC_CW40_FLAG) != 0,
+			 (bf->bf_rcs[i].flags & ATH_RC_SGI_FLAG),
+			 bf_isshpreamble(bf));
 
-		if (bf_isht(bf))
-			series[i].ChSel =
-				ath_chainmask_sel_logic(sc, an);
+		if (bf_isht(bf) && an)
+			series[i].ChSel = ath_chainmask_sel_logic(sc, an);
 		else
 			series[i].ChSel = sc->sc_tx_chainmask;
 
@@ -748,6 +741,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 				     ctsrate,
 				     ctsduration,
 				     series, 4, flags);
+
 	if (sc->sc_config.ath_aggr_prot && flags)
 		ath9k_hw_set11n_burstduration(ah, ds, 8192);
 }
@@ -1238,26 +1232,21 @@ static void ath_tx_stopdma(struct ath_softc *sc, struct ath_txq *txq)
 static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	int i;
-	int npend = 0;
+	int i, status, npend = 0;
 
-	/* XXX return value */
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 			if (ATH_TXQ_SETUP(sc, i)) {
 				ath_tx_stopdma(sc, &sc->sc_txq[i]);
-
 				/* The TxDMA may not really be stopped.
 				 * Double check the hal tx pending count */
 				npend += ath9k_hw_numtxpending(ah,
-					sc->sc_txq[i].axq_qnum);
+						       sc->sc_txq[i].axq_qnum);
 			}
 		}
 	}
 
 	if (npend) {
-		int status;
-
 		/* TxDMA not stopped, reset the hal */
 		DPRINTF(sc, ATH_DBG_XMIT,
 			"%s: Unable to stop TxDMA. Reset HAL!\n", __func__);
@@ -1360,6 +1349,7 @@ static int ath_tx_send_ampdu(struct ath_softc *sc,
 	bf->bf_lastbf = bf->bf_lastfrm; /* one single frame */
 	ath_buf_set_rate(sc, bf);
 	ath_tx_txqaddbuf(sc, txctl->txq, bf_head);
+
 	return 0;
 }
 
@@ -1380,7 +1370,6 @@ static u32 ath_lookup_rate(struct ath_softc *sc,
 	u16 aggr_limit, legacy = 0, maxampdu;
 	int i;
 
-
 	skb = (struct sk_buff *)bf->bf_mpdu;
 	tx_info = IEEE80211_SKB_CB(skb);
 	tx_info_priv = (struct ath_tx_info_priv *)
-- 
1.6.0.3

