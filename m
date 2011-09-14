Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58742 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463Ab1INTYe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:24:34 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 03/12] ath9k: move ath_buf_set_rate to remove a forward declaration
Date: Wed, 14 Sep 2011 21:24:18 +0200
Message-Id: <1316028267-34187-3-git-send-email-nbd@openwrt.org> (sfid-20110914_212439_906470_E52CB29E)
In-Reply-To: <1316028267-34187-2-git-send-email-nbd@openwrt.org>
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
 <1316028267-34187-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |  283 ++++++++++++++++-----------------
 1 files changed, 141 insertions(+), 142 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 48ac9ff..485c0a3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -56,7 +56,6 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct ath_tx_status *ts, int txok, int sendbar);
 static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 			     struct list_head *head, bool internal);
-static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len);
 static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 			     struct ath_tx_status *ts, int nframes, int nbad,
 			     int txok, bool update_rc);
@@ -845,6 +844,147 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 #undef PADBYTES
 }
 
+/*
+ * rix - rate index
+ * pktlen - total bytes (delims + data + fcs + pads + pad delims)
+ * width  - 0 for 20 MHz, 1 for 40 MHz
+ * half_gi - to use 4us v/s 3.6 us for symbol time
+ */
+static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
+			    int width, int half_gi, bool shortPreamble)
+{
+	u32 nbits, nsymbits, duration, nsymbols;
+	int streams;
+
+	/* find number of symbols: PLCP + data */
+	streams = HT_RC_2_STREAMS(rix);
+	nbits = (pktlen << 3) + OFDM_PLCP_BITS;
+	nsymbits = bits_per_symbol[rix % 8][width] * streams;
+	nsymbols = (nbits + nsymbits - 1) / nsymbits;
+
+	if (!half_gi)
+		duration = SYMBOL_TIME(nsymbols);
+	else
+		duration = SYMBOL_TIME_HALFGI(nsymbols);
+
+	/* addup duration for legacy/ht training and signal fields */
+	duration += L_STF + L_LTF + L_SIG + HT_SIG + HT_STF + HT_LTF(streams);
+
+	return duration;
+}
+
+static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_11n_rate_series series[4];
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_tx_rate *rates;
+	const struct ieee80211_rate *rate;
+	struct ieee80211_hdr *hdr;
+	int i, flags = 0;
+	u8 rix = 0, ctsrate = 0;
+	bool is_pspoll;
+
+	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
+
+	skb = bf->bf_mpdu;
+	tx_info = IEEE80211_SKB_CB(skb);
+	rates = tx_info->control.rates;
+	hdr = (struct ieee80211_hdr *)skb->data;
+	is_pspoll = ieee80211_is_pspoll(hdr->frame_control);
+
+	/*
+	 * We check if Short Preamble is needed for the CTS rate by
+	 * checking the BSS's global flag.
+	 * But for the rate series, IEEE80211_TX_RC_USE_SHORT_PREAMBLE is used.
+	 */
+	rate = ieee80211_get_rts_cts_rate(sc->hw, tx_info);
+	ctsrate = rate->hw_value;
+	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
+		ctsrate |= rate->hw_value_short;
+
+	for (i = 0; i < 4; i++) {
+		bool is_40, is_sgi, is_sp;
+		int phy;
+
+		if (!rates[i].count || (rates[i].idx < 0))
+			continue;
+
+		rix = rates[i].idx;
+		series[i].Tries = rates[i].count;
+
+		    if (rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
+			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
+			flags |= ATH9K_TXDESC_RTSENA;
+		} else if (rates[i].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
+			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
+			flags |= ATH9K_TXDESC_CTSENA;
+		}
+
+		if (rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			series[i].RateFlags |= ATH9K_RATESERIES_2040;
+		if (rates[i].flags & IEEE80211_TX_RC_SHORT_GI)
+			series[i].RateFlags |= ATH9K_RATESERIES_HALFGI;
+
+		is_sgi = !!(rates[i].flags & IEEE80211_TX_RC_SHORT_GI);
+		is_40 = !!(rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH);
+		is_sp = !!(rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE);
+
+		if (rates[i].flags & IEEE80211_TX_RC_MCS) {
+			/* MCS rates */
+			series[i].Rate = rix | 0x80;
+			series[i].ChSel = ath_txchainmask_reduction(sc,
+					ah->txchainmask, series[i].Rate);
+			series[i].PktDuration = ath_pkt_duration(sc, rix, len,
+				 is_40, is_sgi, is_sp);
+			if (rix < 8 && (tx_info->flags & IEEE80211_TX_CTL_STBC))
+				series[i].RateFlags |= ATH9K_RATESERIES_STBC;
+			continue;
+		}
+
+		/* legacy rates */
+		if ((tx_info->band == IEEE80211_BAND_2GHZ) &&
+		    !(rate->flags & IEEE80211_RATE_ERP_G))
+			phy = WLAN_RC_PHY_CCK;
+		else
+			phy = WLAN_RC_PHY_OFDM;
+
+		rate = &sc->sbands[tx_info->band].bitrates[rates[i].idx];
+		series[i].Rate = rate->hw_value;
+		if (rate->hw_value_short) {
+			if (rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+				series[i].Rate |= rate->hw_value_short;
+		} else {
+			is_sp = false;
+		}
+
+		if (bf->bf_state.bfs_paprd)
+			series[i].ChSel = ah->txchainmask;
+		else
+			series[i].ChSel = ath_txchainmask_reduction(sc,
+					ah->txchainmask, series[i].Rate);
+
+		series[i].PktDuration = ath9k_hw_computetxtime(sc->sc_ah,
+			phy, rate->bitrate * 100, len, rix, is_sp);
+	}
+
+	/* For AR5416 - RTS cannot be followed by a frame larger than 8K */
+	if (bf_isaggr(bf) && (len > sc->sc_ah->caps.rts_aggr_limit))
+		flags &= ~ATH9K_TXDESC_RTSENA;
+
+	/* ATH9K_TXDESC_RTSENA and ATH9K_TXDESC_CTSENA are mutually exclusive. */
+	if (flags & ATH9K_TXDESC_RTSENA)
+		flags &= ~ATH9K_TXDESC_CTSENA;
+
+	/* set dur_update_en for l-sig computation except for PS-Poll frames */
+	ath9k_hw_set11n_ratescenario(sc->sc_ah, bf->bf_desc,
+				     bf->bf_lastbf->bf_desc,
+				     !is_pspoll, ctsrate,
+				     0, series, 4, flags);
+
+}
+
 static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf, int len)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -1613,35 +1753,6 @@ static int setup_tx_flags(struct sk_buff *skb)
 	return flags;
 }
 
-/*
- * rix - rate index
- * pktlen - total bytes (delims + data + fcs + pads + pad delims)
- * width  - 0 for 20 MHz, 1 for 40 MHz
- * half_gi - to use 4us v/s 3.6 us for symbol time
- */
-static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
-			    int width, int half_gi, bool shortPreamble)
-{
-	u32 nbits, nsymbits, duration, nsymbols;
-	int streams;
-
-	/* find number of symbols: PLCP + data */
-	streams = HT_RC_2_STREAMS(rix);
-	nbits = (pktlen << 3) + OFDM_PLCP_BITS;
-	nsymbits = bits_per_symbol[rix % 8][width] * streams;
-	nsymbols = (nbits + nsymbits - 1) / nsymbits;
-
-	if (!half_gi)
-		duration = SYMBOL_TIME(nsymbols);
-	else
-		duration = SYMBOL_TIME_HALFGI(nsymbols);
-
-	/* addup duration for legacy/ht training and signal fields */
-	duration += L_STF + L_LTF + L_SIG + HT_SIG + HT_STF + HT_LTF(streams);
-
-	return duration;
-}
-
 u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -1654,118 +1765,6 @@ u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
 		return chainmask;
 }
 
-static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath9k_11n_rate_series series[4];
-	struct sk_buff *skb;
-	struct ieee80211_tx_info *tx_info;
-	struct ieee80211_tx_rate *rates;
-	const struct ieee80211_rate *rate;
-	struct ieee80211_hdr *hdr;
-	int i, flags = 0;
-	u8 rix = 0, ctsrate = 0;
-	bool is_pspoll;
-
-	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
-
-	skb = bf->bf_mpdu;
-	tx_info = IEEE80211_SKB_CB(skb);
-	rates = tx_info->control.rates;
-	hdr = (struct ieee80211_hdr *)skb->data;
-	is_pspoll = ieee80211_is_pspoll(hdr->frame_control);
-
-	/*
-	 * We check if Short Preamble is needed for the CTS rate by
-	 * checking the BSS's global flag.
-	 * But for the rate series, IEEE80211_TX_RC_USE_SHORT_PREAMBLE is used.
-	 */
-	rate = ieee80211_get_rts_cts_rate(sc->hw, tx_info);
-	ctsrate = rate->hw_value;
-	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
-		ctsrate |= rate->hw_value_short;
-
-	for (i = 0; i < 4; i++) {
-		bool is_40, is_sgi, is_sp;
-		int phy;
-
-		if (!rates[i].count || (rates[i].idx < 0))
-			continue;
-
-		rix = rates[i].idx;
-		series[i].Tries = rates[i].count;
-
-		    if (rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
-			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
-			flags |= ATH9K_TXDESC_RTSENA;
-		} else if (rates[i].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
-			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
-			flags |= ATH9K_TXDESC_CTSENA;
-		}
-
-		if (rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-			series[i].RateFlags |= ATH9K_RATESERIES_2040;
-		if (rates[i].flags & IEEE80211_TX_RC_SHORT_GI)
-			series[i].RateFlags |= ATH9K_RATESERIES_HALFGI;
-
-		is_sgi = !!(rates[i].flags & IEEE80211_TX_RC_SHORT_GI);
-		is_40 = !!(rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH);
-		is_sp = !!(rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE);
-
-		if (rates[i].flags & IEEE80211_TX_RC_MCS) {
-			/* MCS rates */
-			series[i].Rate = rix | 0x80;
-			series[i].ChSel = ath_txchainmask_reduction(sc,
-					ah->txchainmask, series[i].Rate);
-			series[i].PktDuration = ath_pkt_duration(sc, rix, len,
-				 is_40, is_sgi, is_sp);
-			if (rix < 8 && (tx_info->flags & IEEE80211_TX_CTL_STBC))
-				series[i].RateFlags |= ATH9K_RATESERIES_STBC;
-			continue;
-		}
-
-		/* legacy rates */
-		if ((tx_info->band == IEEE80211_BAND_2GHZ) &&
-		    !(rate->flags & IEEE80211_RATE_ERP_G))
-			phy = WLAN_RC_PHY_CCK;
-		else
-			phy = WLAN_RC_PHY_OFDM;
-
-		rate = &sc->sbands[tx_info->band].bitrates[rates[i].idx];
-		series[i].Rate = rate->hw_value;
-		if (rate->hw_value_short) {
-			if (rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
-				series[i].Rate |= rate->hw_value_short;
-		} else {
-			is_sp = false;
-		}
-
-		if (bf->bf_state.bfs_paprd)
-			series[i].ChSel = ah->txchainmask;
-		else
-			series[i].ChSel = ath_txchainmask_reduction(sc,
-					ah->txchainmask, series[i].Rate);
-
-		series[i].PktDuration = ath9k_hw_computetxtime(sc->sc_ah,
-			phy, rate->bitrate * 100, len, rix, is_sp);
-	}
-
-	/* For AR5416 - RTS cannot be followed by a frame larger than 8K */
-	if (bf_isaggr(bf) && (len > sc->sc_ah->caps.rts_aggr_limit))
-		flags &= ~ATH9K_TXDESC_RTSENA;
-
-	/* ATH9K_TXDESC_RTSENA and ATH9K_TXDESC_CTSENA are mutually exclusive. */
-	if (flags & ATH9K_TXDESC_RTSENA)
-		flags &= ~ATH9K_TXDESC_CTSENA;
-
-	/* set dur_update_en for l-sig computation except for PS-Poll frames */
-	ath9k_hw_set11n_ratescenario(sc->sc_ah, bf->bf_desc,
-				     bf->bf_lastbf->bf_desc,
-				     !is_pspoll, ctsrate,
-				     0, series, 4, flags);
-
-}
-
 /*
  * Assign a descriptor (and sequence number if necessary,
  * and map buffer for DMA. Frees skb on error
-- 
1.7.3.2

