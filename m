Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23296 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbYLGQQq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 11:16:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 08:16:46 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18747.63024.371660.2540@gargle.gargle.HOWL> (sfid-20081207_171649_864202_65D40F06)
Date: Sun, 7 Dec 2008 21:43:36 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 5/6] ath9k: Merge structures ath_atx, ath_node_aggr with ath_node
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |  160 ++++++++++++++++---------------------
 drivers/net/wireless/ath9k/xmit.c |    6 +-
 2 files changed, 72 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 0e3c225..41a87b9 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -290,18 +290,9 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 /* RX / TX */
 /***********/
 
-#define ATH_MAX_ANTENNA          3
-#define ATH_RXBUF                512
-#define WME_NUM_TID              16
-
-int ath_startrecv(struct ath_softc *sc);
-bool ath_stoprecv(struct ath_softc *sc);
-void ath_flushrecv(struct ath_softc *sc);
-u32 ath_calcrxfilter(struct ath_softc *sc);
-int ath_rx_init(struct ath_softc *sc, int nbufs);
-void ath_rx_cleanup(struct ath_softc *sc);
-int ath_rx_tasklet(struct ath_softc *sc, int flush);
-
+#define ATH_MAX_ANTENNA         3
+#define ATH_RXBUF               512
+#define WME_NUM_TID             16
 #define ATH_TXBUF               512
 #define ATH_TXMAXTRY            13
 #define ATH_11N_TXMAXTRY        10
@@ -309,19 +300,61 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush);
 #define WME_BA_BMP_SIZE         64
 #define WME_MAX_BA              WME_BA_BMP_SIZE
 #define ATH_TID_MAX_BUFS        (2 * WME_MAX_BA)
+
 #define TID_TO_WME_AC(_tid)				\
 	((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE :	\
 	 (((_tid) == 1) || ((_tid) == 2)) ? WME_AC_BK :	\
 	 (((_tid) == 4) || ((_tid) == 5)) ? WME_AC_VI :	\
 	 WME_AC_VO)
 
-
 #define WME_AC_BE   0
 #define WME_AC_BK   1
 #define WME_AC_VI   2
 #define WME_AC_VO   3
 #define WME_NUM_AC  4
 
+#define ADDBA_EXCHANGE_ATTEMPTS    10
+#define ATH_AGGR_DELIM_SZ          4
+#define ATH_AGGR_MINPLEN           256 /* in bytes, minimum packet length */
+/* number of delimiters for encryption padding */
+#define ATH_AGGR_ENCRYPTDELIM      10
+/* minimum h/w qdepth to be sustained to maximize aggregation */
+#define ATH_AGGR_MIN_QDEPTH        2
+#define ATH_AMPDU_SUBFRAME_DEFAULT 32
+#define IEEE80211_SEQ_SEQ_SHIFT    4
+#define IEEE80211_SEQ_MAX          4096
+#define IEEE80211_MIN_AMPDU_BUF    0x8
+#define IEEE80211_HTCAP_MAXRXAMPDU_FACTOR 13
+
+/* return whether a bit at index _n in bitmap _bm is set
+ * _sz is the size of the bitmap  */
+#define ATH_BA_ISSET(_bm, _n)  (((_n) < (WME_BA_BMP_SIZE)) &&		\
+				((_bm)[(_n) >> 5] & (1 << ((_n) & 31))))
+
+/* return block-ack bitmap index given sequence and starting sequence */
+#define ATH_BA_INDEX(_st, _seq) (((_seq) - (_st)) & (IEEE80211_SEQ_MAX - 1))
+
+/* returns delimiter padding required given the packet length */
+#define ATH_AGGR_GET_NDELIM(_len)					\
+	(((((_len) + ATH_AGGR_DELIM_SZ) < ATH_AGGR_MINPLEN) ?           \
+	  (ATH_AGGR_MINPLEN - (_len) - ATH_AGGR_DELIM_SZ) : 0) >> 2)
+
+#define BAW_WITHIN(_start, _bawsz, _seqno) \
+	((((_seqno) - (_start)) & 4095) < (_bawsz))
+
+#define ATH_DS_BA_SEQ(_ds)         ((_ds)->ds_us.tx.ts_seqnum)
+#define ATH_DS_BA_BITMAP(_ds)      (&(_ds)->ds_us.tx.ba_low)
+#define ATH_DS_TX_BA(_ds)          ((_ds)->ds_us.tx.ts_flags & ATH9K_TX_BA)
+#define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
+
+enum ATH_AGGR_STATUS {
+	ATH_AGGR_DONE,
+	ATH_AGGR_BAW_CLOSED,
+	ATH_AGGR_LIMITED,
+	ATH_AGGR_SHORTPKT,
+	ATH_AGGR_8K_LIMITED,
+};
+
 struct ath_txq {
 	u32 axq_qnum;			/* hardware q number */
 	u32 *axq_link;			/* link ptr in last TX desc */
@@ -331,7 +364,6 @@ struct ath_txq {
 	u32 axq_depth;			/* queue depth */
 	u8 axq_aggr_depth;		/* aggregates queued */
 	u32 axq_totalqueued;		/* total ever queued */
-
 	bool stopped;			/* Is mac80211 queue stopped ? */
 	struct ath_buf *axq_linkbuf;	/* virtual addr of last buffer*/
 
@@ -377,12 +409,6 @@ struct ath_atx_ac {
 	struct list_head tid_q;		/* queue of TIDs with buffers */
 };
 
-/* per dest tx state */
-struct ath_atx {
-	struct ath_atx_tid tid[WME_NUM_TID];
-	struct ath_atx_ac ac[WME_NUM_AC];
-};
-
 /* per-frame tx control block */
 struct ath_tx_control {
 	struct ath_txq *txq;
@@ -408,13 +434,32 @@ struct ath_tx_stat {
 	int rateKbps;
 	int ratecode;
 	int flags;
-/* if any of ctl,extn chain rssis are valid */
-#define ATH_TX_CHAIN_RSSI_VALID 0x01
-/* if extn chain rssis are valid */
-#define ATH_TX_RSSI_EXTN_VALID  0x02
 	u32 airtime;	/* time on air per final tx rate */
 };
 
+struct aggr_rifs_param {
+	int param_max_frames;
+	int param_max_len;
+	int param_rl;
+	int param_al;
+	struct ath_rc_series *param_rcs;
+};
+
+struct ath_node {
+	struct ath_softc *an_sc;
+	struct ath_atx_tid tid[WME_NUM_TID];
+	struct ath_atx_ac ac[WME_NUM_AC];
+	u16 maxampdu;
+	u8 mpdudensity;
+};
+
+int ath_startrecv(struct ath_softc *sc);
+bool ath_stoprecv(struct ath_softc *sc);
+void ath_flushrecv(struct ath_softc *sc);
+u32 ath_calcrxfilter(struct ath_softc *sc);
+int ath_rx_init(struct ath_softc *sc, int nbufs);
+void ath_rx_cleanup(struct ath_softc *sc);
+int ath_rx_tasklet(struct ath_softc *sc, int flush);
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype);
 void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_setup(struct ath_softc *sc, int haltype);
@@ -437,73 +482,6 @@ void ath_tx_tasklet(struct ath_softc *sc);
 u32 ath_txq_depth(struct ath_softc *sc, int qnum);
 u32 ath_txq_aggr_depth(struct ath_softc *sc, int qnum);
 void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb);
-
-/**********************/
-/* Node / Aggregation */
-/**********************/
-
-#define ADDBA_EXCHANGE_ATTEMPTS    10
-#define ATH_AGGR_DELIM_SZ          4
-#define ATH_AGGR_MINPLEN           256 /* in bytes, minimum packet length */
-/* number of delimiters for encryption padding */
-#define ATH_AGGR_ENCRYPTDELIM      10
-/* minimum h/w qdepth to be sustained to maximize aggregation */
-#define ATH_AGGR_MIN_QDEPTH        2
-#define ATH_AMPDU_SUBFRAME_DEFAULT 32
-#define IEEE80211_SEQ_SEQ_SHIFT    4
-#define IEEE80211_SEQ_MAX          4096
-#define IEEE80211_MIN_AMPDU_BUF    0x8
-#define IEEE80211_HTCAP_MAXRXAMPDU_FACTOR 13
-
-/* return whether a bit at index _n in bitmap _bm is set
- * _sz is the size of the bitmap  */
-#define ATH_BA_ISSET(_bm, _n)  (((_n) < (WME_BA_BMP_SIZE)) &&		\
-				((_bm)[(_n) >> 5] & (1 << ((_n) & 31))))
-
-/* return block-ack bitmap index given sequence and starting sequence */
-#define ATH_BA_INDEX(_st, _seq) (((_seq) - (_st)) & (IEEE80211_SEQ_MAX - 1))
-
-/* returns delimiter padding required given the packet length */
-#define ATH_AGGR_GET_NDELIM(_len)					\
-	(((((_len) + ATH_AGGR_DELIM_SZ) < ATH_AGGR_MINPLEN) ?           \
-	  (ATH_AGGR_MINPLEN - (_len) - ATH_AGGR_DELIM_SZ) : 0) >> 2)
-
-#define BAW_WITHIN(_start, _bawsz, _seqno) \
-	((((_seqno) - (_start)) & 4095) < (_bawsz))
-
-#define ATH_DS_BA_SEQ(_ds)               ((_ds)->ds_us.tx.ts_seqnum)
-#define ATH_DS_BA_BITMAP(_ds)            (&(_ds)->ds_us.tx.ba_low)
-#define ATH_DS_TX_BA(_ds)	((_ds)->ds_us.tx.ts_flags & ATH9K_TX_BA)
-#define ATH_AN_2_TID(_an, _tidno)        (&(_an)->an_aggr.tx.tid[(_tidno)])
-
-enum ATH_AGGR_STATUS {
-	ATH_AGGR_DONE,
-	ATH_AGGR_BAW_CLOSED,
-	ATH_AGGR_LIMITED,
-	ATH_AGGR_SHORTPKT,
-	ATH_AGGR_8K_LIMITED,
-};
-
-struct aggr_rifs_param {
-	int param_max_frames;
-	int param_max_len;
-	int param_rl;
-	int param_al;
-	struct ath_rc_series *param_rcs;
-};
-
-/* Per-node aggregation state */
-struct ath_node_aggr {
-	struct ath_atx tx;
-};
-
-struct ath_node {
-	struct ath_softc *an_sc;
-	struct ath_node_aggr an_aggr;
-	u16 maxampdu;
-	u8 mpdudensity;
-};
-
 void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid);
 bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
 void ath_tx_aggr_teardown(struct ath_softc *sc,	struct ath_node *an, u8 tidno);
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 353b7ed..ec359c6 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -2405,7 +2405,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	/*
 	 * Init per tid tx state
 	 */
-	for (tidno = 0, tid = &an->an_aggr.tx.tid[tidno];
+	for (tidno = 0, tid = &an->tid[tidno];
 	     tidno < WME_NUM_TID;
 	     tidno++, tid++) {
 		tid->an        = an;
@@ -2419,7 +2419,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		INIT_LIST_HEAD(&tid->buf_q);
 
 		acno = TID_TO_WME_AC(tidno);
-		tid->ac = &an->an_aggr.tx.ac[acno];
+		tid->ac = &an->ac[acno];
 
 		/* ADDBA state */
 		tid->state &= ~AGGR_ADDBA_COMPLETE;
@@ -2430,7 +2430,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	/*
 	 * Init per ac tx state
 	 */
-	for (acno = 0, ac = &an->an_aggr.tx.ac[acno];
+	for (acno = 0, ac = &an->ac[acno];
 	     acno < WME_NUM_AC; acno++, ac++) {
 		ac->sched    = false;
 		INIT_LIST_HEAD(&ac->tid_q);
-- 
1.6.0.3

