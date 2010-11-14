Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48043 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755615Ab0KNOUU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:20 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 06/13] ath9k: remove bfs_al from struct ath_buf_state
Date: Sun, 14 Nov 2010 15:20:06 +0100
Message-Id: <1289744413-20789-6-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289744413-20789-5-git-send-email-nbd@openwrt.org>
References: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
 <1289744413-20789-2-git-send-email-nbd@openwrt.org>
 <1289744413-20789-3-git-send-email-nbd@openwrt.org>
 <1289744413-20789-4-git-send-email-nbd@openwrt.org>
 <1289744413-20789-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 +--
 drivers/net/wireless/ath/ath9k/xmit.c  |   34 ++++++++++++++++----------------
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 30c18e8..d1c714a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -102,7 +102,6 @@ enum buffer_type {
 };
 
 #define bf_nframes      	bf_state.bfs_nframes
-#define bf_al           	bf_state.bfs_al
 #define bf_frmlen       	bf_state.bfs_frmlen
 #define bf_retries      	bf_state.bfs_retries
 #define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
@@ -215,11 +214,10 @@ struct ath_atx_ac {
 
 struct ath_buf_state {
 	int bfs_nframes;
-	u16 bfs_al;
-	u16 bfs_frmlen;
 	int bfs_retries;
 	u8 bf_type;
 	u8 bfs_paprd;
+	u16 bfs_frmlen;
 	enum ath9k_internal_frame_type bfs_ftype;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 176d88c..88efcc1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -56,7 +56,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct ath_tx_status *ts, int txok, int sendbar);
 static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 			     struct list_head *head);
-static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf);
+static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len);
 static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
 			      struct ath_tx_status *ts, int txok);
 static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
@@ -674,7 +674,8 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 					     struct ath_txq *txq,
 					     struct ath_atx_tid *tid,
-					     struct list_head *bf_q)
+					     struct list_head *bf_q,
+					     int *aggr_len)
 {
 #define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
 	struct ath_buf *bf, *bf_first, *bf_prev = NULL;
@@ -750,7 +751,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 
 	} while (!list_empty(&tid->buf_q));
 
-	bf_first->bf_al = al;
+	*aggr_len = al;
 	bf_first->bf_nframes = nframes;
 
 	return status;
@@ -763,6 +764,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	struct ath_buf *bf;
 	enum ATH_AGGR_STATUS status;
 	struct list_head bf_q;
+	int aggr_len;
 
 	do {
 		if (list_empty(&tid->buf_q))
@@ -770,7 +772,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 		INIT_LIST_HEAD(&bf_q);
 
-		status = ath_tx_form_aggr(sc, txq, tid, &bf_q);
+		status = ath_tx_form_aggr(sc, txq, tid, &bf_q, &aggr_len);
 
 		/*
 		 * no frames picked up to be aggregated;
@@ -786,15 +788,15 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		if (bf->bf_nframes == 1) {
 			bf->bf_state.bf_type &= ~BUF_AGGR;
 			ath9k_hw_clr11n_aggr(sc->sc_ah, bf->bf_desc);
-			ath_buf_set_rate(sc, bf);
+			ath_buf_set_rate(sc, bf, bf->bf_frmlen);
 			ath_tx_txqaddbuf(sc, txq, &bf_q);
 			continue;
 		}
 
 		/* setup first desc of aggregate */
 		bf->bf_state.bf_type |= BUF_AGGR;
-		ath_buf_set_rate(sc, bf);
-		ath9k_hw_set11n_aggr_first(sc->sc_ah, bf->bf_desc, bf->bf_al);
+		ath_buf_set_rate(sc, bf, aggr_len);
+		ath9k_hw_set11n_aggr_first(sc->sc_ah, bf->bf_desc, aggr_len);
 
 		/* anchor last desc of aggregate */
 		ath9k_hw_set11n_aggr_last(sc->sc_ah, bf->bf_lastbf->bf_desc);
@@ -1333,7 +1335,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	/* Queue to h/w without aggregation */
 	bf->bf_nframes = 1;
 	bf->bf_lastbf = bf;
-	ath_buf_set_rate(sc, bf);
+	ath_buf_set_rate(sc, bf, bf->bf_frmlen);
 	ath_tx_txqaddbuf(sc, txctl->txq, bf_head);
 }
 
@@ -1352,7 +1354,7 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 
 	bf->bf_nframes = 1;
 	bf->bf_lastbf = bf;
-	ath_buf_set_rate(sc, bf);
+	ath_buf_set_rate(sc, bf, bf->bf_frmlen);
 	ath_tx_txqaddbuf(sc, txq, bf_head);
 	TX_STAT_INC(txq->axq_qnum, queued);
 }
@@ -1430,13 +1432,11 @@ static int setup_tx_flags(struct sk_buff *skb)
  * width  - 0 for 20 MHz, 1 for 40 MHz
  * half_gi - to use 4us v/s 3.6 us for symbol time
  */
-static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
+static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
 			    int width, int half_gi, bool shortPreamble)
 {
 	u32 nbits, nsymbits, duration, nsymbols;
-	int streams, pktlen;
-
-	pktlen = bf_isaggr(bf) ? bf->bf_al : bf->bf_frmlen;
+	int streams;
 
 	/* find number of symbols: PLCP + data */
 	streams = HT_RC_2_STREAMS(rix);
@@ -1455,7 +1455,7 @@ static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
 	return duration;
 }
 
-static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
+static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath9k_11n_rate_series series[4];
@@ -1518,7 +1518,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		if (rates[i].flags & IEEE80211_TX_RC_MCS) {
 			/* MCS rates */
 			series[i].Rate = rix | 0x80;
-			series[i].PktDuration = ath_pkt_duration(sc, rix, bf,
+			series[i].PktDuration = ath_pkt_duration(sc, rix, len,
 				 is_40, is_sgi, is_sp);
 			if (rix < 8 && (tx_info->flags & IEEE80211_TX_CTL_STBC))
 				series[i].RateFlags |= ATH9K_RATESERIES_STBC;
@@ -1542,11 +1542,11 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		}
 
 		series[i].PktDuration = ath9k_hw_computetxtime(sc->sc_ah,
-			phy, rate->bitrate * 100, bf->bf_frmlen, rix, is_sp);
+			phy, rate->bitrate * 100, len, rix, is_sp);
 	}
 
 	/* For AR5416 - RTS cannot be followed by a frame larger than 8K */
-	if (bf_isaggr(bf) && (bf->bf_al > sc->sc_ah->caps.rts_aggr_limit))
+	if (bf_isaggr(bf) && (len > sc->sc_ah->caps.rts_aggr_limit))
 		flags &= ~ATH9K_TXDESC_RTSENA;
 
 	/* ATH9K_TXDESC_RTSENA and ATH9K_TXDESC_CTSENA are mutually exclusive. */
-- 
1.7.3.2

