Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19332 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbZBDCny (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 21:43:54 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 18:43:54 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18825.19.693215.39617@gargle.gargle.HOWL> (sfid-20090204_034413_910593_255DADC2)
Date: Wed, 4 Feb 2009 08:10:19 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/4] ath9k: Remove all the redundant internal buffer types
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use mac80211's primitives for identifying the frame type,
and cleanup the driver-specific macros.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |   36 ++++++++++++++++--------------------
 drivers/net/wireless/ath9k/main.c |    1 -
 drivers/net/wireless/ath9k/xmit.c |   15 +++++++--------
 3 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 791f1ac..63d3eb6 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -192,7 +192,6 @@ static inline void ath_debug_stat_rc(struct ath_softc *sc,
 struct ath_config {
 	u32 ath_aggr_prot;
 	u16 txpowlimit;
-	u16 txpowlimit_override;
 	u8 cabqReadytime;
 	u8 swBeaconProcess;
 };
@@ -206,21 +205,25 @@ struct ath_config {
 		(_bf)->bf_lastbf = NULL;			\
 		(_bf)->bf_next = NULL;				\
 		memset(&((_bf)->bf_state), 0,			\
-			    sizeof(struct ath_buf_state));	\
+		       sizeof(struct ath_buf_state));		\
 	} while (0)
 
+/**
+ * enum buffer_type - Buffer type flags
+ *
+ * @BUF_HT: Send this buffer using HT capabilities
+ * @BUF_AMPDU: This buffer is an ampdu, as part of an aggregate (during TX)
+ * @BUF_AGGR: Indicates whether the buffer can be aggregated
+ *	(used in aggregation scheduling)
+ * @BUF_RETRY: Indicates whether the buffer is retried
+ * @BUF_XRETRY: To denote excessive retries of the buffer
+ */
 enum buffer_type {
-	BUF_DATA		= BIT(0),
-	BUF_AGGR		= BIT(1),
+	BUF_HT			= BIT(1),
 	BUF_AMPDU		= BIT(2),
-	BUF_HT			= BIT(3),
+	BUF_AGGR		= BIT(3),
 	BUF_RETRY		= BIT(4),
 	BUF_XRETRY		= BIT(5),
-	BUF_SHORT_PREAMBLE	= BIT(6),
-	BUF_BAR			= BIT(7),
-	BUF_PSPOLL		= BIT(8),
-	BUF_AGGR_BURST		= BIT(9),
-	BUF_CALC_AIRTIME	= BIT(10),
 };
 
 struct ath_buf_state {
@@ -241,18 +244,13 @@ struct ath_buf_state {
 #define bf_retries      	bf_state.bfs_retries
 #define bf_seqno        	bf_state.bfs_seqno
 #define bf_tidno        	bf_state.bfs_tidno
-#define bf_rcs          	bf_state.bfs_rcs
 #define bf_keyix                bf_state.bfs_keyix
 #define bf_keytype      	bf_state.bfs_keytype
-#define bf_isdata(bf)		(bf->bf_state.bf_type & BUF_DATA)
-#define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
-#define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
 #define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
+#define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
+#define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
 #define bf_isretried(bf)	(bf->bf_state.bf_type & BUF_RETRY)
 #define bf_isxretried(bf)	(bf->bf_state.bf_type & BUF_XRETRY)
-#define bf_isbar(bf)		(bf->bf_state.bf_type & BUF_BAR)
-#define bf_ispspoll(bf) 	(bf->bf_state.bf_type & BUF_PSPOLL)
-#define bf_isaggrburst(bf)	(bf->bf_state.bf_type & BUF_AGGR_BURST)
 
 /*
  * Abstraction of a contiguous buffer to transmit/receive.  There is only
@@ -358,8 +356,6 @@ enum ATH_AGGR_STATUS {
 	ATH_AGGR_DONE,
 	ATH_AGGR_BAW_CLOSED,
 	ATH_AGGR_LIMITED,
-	ATH_AGGR_SHORTPKT,
-	ATH_AGGR_8K_LIMITED,
 };
 
 struct ath_txq {
@@ -658,7 +654,7 @@ struct ath_rfkill {
 #define ATH_MAX_SW_RETRIES      10
 #define ATH_CHAN_MAX            255
 #define IEEE80211_WEP_NKID      4       /* number of key ids */
-#define IEEE80211_RATE_VAL      0x7f
+
 /*
  * The key cache is used for h/w cipher state and also for
  * tracking station state such as the current tx antenna.
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 9b040ba..4095fec 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1503,7 +1503,6 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 					     1, NULL);
 
 	sc->sc_config.txpowlimit = ATH_TXPOWER_MAX;
-	sc->sc_config.txpowlimit_override = 0;
 
 	/* 11n Capabilities */
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index e14bcea..d5f15e7 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1436,14 +1436,18 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
+	struct ieee80211_hdr *hdr;
 	int i, flags = 0;
 	u8 rix = 0, ctsrate = 0;
+	bool is_pspoll;
 
 	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 
 	skb = (struct sk_buff *)bf->bf_mpdu;
 	tx_info = IEEE80211_SKB_CB(skb);
 	rates = tx_info->control.rates;
+	hdr = (struct ieee80211_hdr *)skb->data;
+	is_pspoll = ieee80211_is_pspoll(hdr->frame_control);
 
 	/*
 	 * We check if Short Preamble is needed for the CTS rate by
@@ -1506,7 +1510,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	/* set dur_update_en for l-sig computation except for PS-Poll frames */
 	ath9k_hw_set11n_ratescenario(sc->sc_ah, bf->bf_desc,
 				     bf->bf_lastbf->bf_desc,
-				     !bf_ispspoll(bf), ctsrate,
+				     !is_pspoll, ctsrate,
 				     0, series, 4, flags);
 
 	if (sc->sc_config.ath_aggr_prot && flags)
@@ -1534,12 +1538,6 @@ static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 
 	bf->bf_frmlen = skb->len + FCS_LEN - (hdrlen & 3);
 
-	if (ieee80211_is_data(fc))
-		bf->bf_state.bf_type |= BUF_DATA;
-	if (ieee80211_is_back_req(fc))
-		bf->bf_state.bf_type |= BUF_BAR;
-	if (ieee80211_is_pspoll(fc))
-		bf->bf_state.bf_type |= BUF_PSPOLL;
 	if ((conf_is_ht(&sc->hw->conf) && !is_pae(skb) &&
 	     (tx_info->flags & IEEE80211_TX_CTL_AMPDU)))
 		bf->bf_state.bf_type |= BUF_HT;
@@ -1843,6 +1841,7 @@ static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
 static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds, int nbad)
 {
 	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
 
@@ -1852,7 +1851,7 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds, int nbad)
 
 	if ((ds->ds_txstat.ts_status & ATH9K_TXERR_FILT) == 0 &&
 	    (bf->bf_flags & ATH9K_TXDESC_NOACK) == 0) {
-		if (bf_isdata(bf)) {
+		if (ieee80211_is_data(hdr->frame_control)) {
 			memcpy(&tx_info_priv->tx, &ds->ds_txstat,
 			       sizeof(tx_info_priv->tx));
 			tx_info_priv->n_frames = bf->bf_nframes;
-- 
1.6.1

