Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48057 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbZA3JDB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 04:03:01 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 01:03:01 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18818.49520.319140.790679@gargle.gargle.HOWL> (sfid-20090130_100309_805054_1A77FAA9)
Date: Fri, 30 Jan 2009 14:29:28 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/3] ath9k: Handle mac80211's RC flags for MCS rates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 notifies the RC algorithm if RTS/CTS and short preamble
are needed. The RC flags for MCS rates are currently not handled
by mac80211, and ath9k's RC doesn't set the flags either. Fix this.

Also, set the rts_cts_rate_idx inside the RC algorithm.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    8 --
 drivers/net/wireless/ath9k/mac.c  |    3 -
 drivers/net/wireless/ath9k/rc.c   |   82 +++++++++++++++++++---
 drivers/net/wireless/ath9k/xmit.c |  135 +++++++++++--------------------------
 4 files changed, 111 insertions(+), 117 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 29251f8..b006d46 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -233,7 +233,6 @@ struct ath_buf_state {
 #define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
 #define bf_isretried(bf)	(bf->bf_state.bf_type & BUF_RETRY)
 #define bf_isxretried(bf)	(bf->bf_state.bf_type & BUF_XRETRY)
-#define bf_isshpreamble(bf)	(bf->bf_state.bf_type & BUF_SHORT_PREAMBLE)
 #define bf_isbar(bf)		(bf->bf_state.bf_type & BUF_BAR)
 #define bf_ispspoll(bf) 	(bf->bf_state.bf_type & BUF_PSPOLL)
 #define bf_isaggrburst(bf)	(bf->bf_state.bf_type & BUF_AGGR_BURST)
@@ -656,12 +655,6 @@ struct ath_rfkill {
 #define ATH_RSSI_DUMMY_MARKER   0x127
 #define ATH_RATE_DUMMY_MARKER   0
 
-enum PROT_MODE {
-	PROT_M_NONE = 0,
-	PROT_M_RTSCTS,
-	PROT_M_CTSONLY
-};
-
 #define SC_OP_INVALID		BIT(0)
 #define SC_OP_BEACONS		BIT(1)
 #define SC_OP_RXAGGR		BIT(2)
@@ -712,7 +705,6 @@ struct ath_softc {
 	u8 sc_splitmic;
 	atomic_t ps_usecount;
 	enum ath9k_int sc_imask;
-	enum PROT_MODE sc_protmode;
 	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
 	enum ath9k_ht_macmode tx_chan_width;
 
diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index ef832a5..2427c44 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -344,9 +344,6 @@ void ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
 	struct ar5416_desc *last_ads = AR5416DESC(lastds);
 	u32 ds_ctl0;
 
-	(void) nseries;
-	(void) rtsctsDuration;
-
 	if (flags & (ATH9K_TXDESC_RTSENA | ATH9K_TXDESC_CTSENA)) {
 		ds_ctl0 = ads->ds_ctl0;
 
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index dc0438c..8a278f7 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -747,14 +747,17 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	return rate;
 }
 
-static void ath_rc_rate_set_series(struct ath_rate_table *rate_table ,
+static void ath_rc_rate_set_series(struct ath_rate_table *rate_table,
 				   struct ieee80211_tx_rate *rate,
+				   struct ieee80211_tx_rate_control *txrc,
 				   u8 tries, u8 rix, int rtsctsenable)
 {
 	rate->count = tries;
 	rate->idx = rix;
 
-	if (rtsctsenable)
+	if (txrc->short_preamble)
+		rate->flags |= IEEE80211_TX_RC_USE_SHORT_PREAMBLE;
+	if (txrc->rts || rtsctsenable)
 		rate->flags |= IEEE80211_TX_RC_USE_RTS_CTS;
 	if (WLAN_RC_PHY_40(rate_table->info[rix].phy))
 		rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
@@ -764,6 +767,43 @@ static void ath_rc_rate_set_series(struct ath_rate_table *rate_table ,
 		rate->flags |= IEEE80211_TX_RC_MCS;
 }
 
+static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
+				   struct ath_rate_table *rate_table,
+				   struct ieee80211_tx_info *tx_info)
+{
+	struct ieee80211_tx_rate *rates = tx_info->control.rates;
+	int i = 0, rix = 0, cix, enable_g_protection = 0;
+
+	/* get the cix for the lowest valid rix */
+	for (i = 3; i >= 0; i--) {
+		if (rates[i].count && (rates[i].idx >= 0)) {
+			rix = rates[i].idx;
+			break;
+		}
+	}
+	cix = rate_table->info[rix].ctrl_rate;
+
+	/* All protection frames are transmited at 2Mb/s for 802.11g,
+	 * otherwise we transmit them at 1Mb/s */
+	if (sc->hw->conf.channel->band == IEEE80211_BAND_2GHZ &&
+	    !conf_is_ht(&sc->hw->conf))
+		enable_g_protection = 1;
+
+	/*
+	 * If 802.11g protection is enabled, determine whether to use RTS/CTS or
+	 * just CTS.  Note that this is only done for OFDM/HT unicast frames.
+	 */
+	if ((sc->sc_flags & SC_OP_PROTECT_ENABLE) &&
+	    !(tx_info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+	    (rate_table->info[rix].phy == WLAN_RC_PHY_OFDM ||
+	     WLAN_RC_PHY_HT(rate_table->info[rix].phy))) {
+		rates[0].flags |= IEEE80211_TX_RC_USE_CTS_PROTECT;
+		cix = rate_table->info[enable_g_protection].ctrl_rate;
+	}
+
+	tx_info->control.rts_cts_rate_idx = cix;
+}
+
 static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 			     struct ath_rate_priv *ath_rc_priv,
 			     struct ath_rate_table *rate_table,
@@ -801,6 +841,8 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rates = tx_info->control.rates;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	__le16 fc = hdr->frame_control;
 	u8 try_per_rate = 0, i = 0, rix, nrix;
 	int is_probe = 0;
 
@@ -811,7 +853,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	if (is_probe) {
 		/* set one try for probe rates. For the
 		 * probes don't enable rts */
-		ath_rc_rate_set_series(rate_table, &rates[i++],
+		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
 				       1, nrix, 0);
 
 		try_per_rate = (ATH_11N_TXMAXTRY/4);
@@ -820,12 +862,12 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		 */
 		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
 					  rate_table, nrix, 1, 0);
-		ath_rc_rate_set_series(rate_table, &rates[i++],
+		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
 				       try_per_rate, nrix, 0);
 	} else {
 		try_per_rate = (ATH_11N_TXMAXTRY/4);
 		/* Set the choosen rate. No RTS for first series entry. */
-		ath_rc_rate_set_series(rate_table, &rates[i++],
+		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
 				       try_per_rate, nrix, 0);
 	}
 
@@ -841,7 +883,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
 					  rate_table, nrix, 1, min_rate);
 		/* All other rates in the series have RTS enabled */
-		ath_rc_rate_set_series(rate_table, &rates[i],
+		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
 				       try_num, nrix, 1);
 	}
 
@@ -871,6 +913,24 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 			rates[3].flags = rates[2].flags;
 		}
 	}
+
+	/*
+	 * Force hardware to use computed duration for next
+	 * fragment by disabling multi-rate retry, which
+	 * updates duration based on the multi-rate duration table.
+	 *
+	 * FIXME: Fix duration
+	 */
+	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+	    (ieee80211_has_morefrags(fc) ||
+	     (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG))) {
+		rates[1].count = rates[2].count = rates[3].count = 0;
+		rates[1].idx = rates[2].idx = rates[3].idx = 0;
+		rates[0].count = ATH_TXMAXTRY;
+	}
+
+	/* Setup RTS/CTS */
+	ath_rc_rate_set_rtscts(sc, rate_table, tx_info);
 }
 
 static bool ath_rc_update_per(struct ath_softc *sc,
@@ -1385,16 +1445,16 @@ static void ath_rc_init(struct ath_softc *sc,
 	if (!rateset->rs_nrates) {
 		/* No working rate, just initialize valid rates */
 		hi = ath_rc_init_validrates(ath_rc_priv, rate_table,
-						ath_rc_priv->ht_cap);
+					    ath_rc_priv->ht_cap);
 	} else {
 		/* Use intersection of working rates and valid rates */
 		hi = ath_rc_setvalid_rates(ath_rc_priv, rate_table,
-					       rateset, ath_rc_priv->ht_cap);
+					   rateset, ath_rc_priv->ht_cap);
 		if (ath_rc_priv->ht_cap & WLAN_RC_HT_FLAG) {
 			hthi = ath_rc_setvalid_htrates(ath_rc_priv,
-							   rate_table,
-							   ht_mcs,
-							   ath_rc_priv->ht_cap);
+						       rate_table,
+						       ht_mcs,
+						       ath_rc_priv->ht_cap);
 		}
 		hi = A_MAX(hi, hthi);
 	}
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 007ca91..52011e9 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1385,8 +1385,6 @@ static int setup_tx_flags(struct ath_softc *sc, struct sk_buff *skb,
 
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
 		flags |= ATH9K_TXDESC_NOACK;
-	if (tx_info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
-		flags |= ATH9K_TXDESC_RTSENA;
 
 	return flags;
 }
@@ -1432,137 +1430,86 @@ static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
 
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 {
-	struct ath_hal *ah = sc->sc_ah;
-	struct ath_rate_table *rt;
-	struct ath_desc *ds = bf->bf_desc;
-	struct ath_desc *lastds = bf->bf_lastbf->bf_desc;
+	struct ath_rate_table *rt = sc->cur_rate_table;
 	struct ath9k_11n_rate_series series[4];
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
-	struct ieee80211_hdr *hdr;
-	struct ieee80211_hw *hw = sc->hw;
-	int i, flags, rtsctsena = 0, enable_g_protection = 0;
-	u32 ctsduration = 0;
-	u8 rix = 0, cix, ctsrate = 0;
-	__le16 fc;
+	int i, flags = 0;
+	u8 rix = 0, ctsrate = 0;
 
 	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 
 	skb = (struct sk_buff *)bf->bf_mpdu;
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
 	tx_info = IEEE80211_SKB_CB(skb);
 	rates = tx_info->control.rates;
 
-	if (ieee80211_has_morefrags(fc) ||
-	    (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
-		rates[1].count = rates[2].count = rates[3].count = 0;
-		rates[1].idx = rates[2].idx = rates[3].idx = 0;
-		rates[0].count = ATH_TXMAXTRY;
-	}
-
-	/* get the cix for the lowest valid rix */
-	rt = sc->cur_rate_table;
-	for (i = 3; i >= 0; i--) {
-		if (rates[i].count && (rates[i].idx >= 0)) {
-			rix = rates[i].idx;
-			break;
-		}
-	}
-
-	flags = (bf->bf_flags & (ATH9K_TXDESC_RTSENA | ATH9K_TXDESC_CTSENA));
-	cix = rt->info[rix].ctrl_rate;
-
-	/* All protection frames are transmited at 2Mb/s for 802.11g,
-	 * otherwise we transmit them at 1Mb/s */
-	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ &&
-	  !conf_is_ht(&hw->conf))
-		enable_g_protection = 1;
-
 	/*
-	 * If 802.11g protection is enabled, determine whether to use RTS/CTS or
-	 * just CTS.  Note that this is only done for OFDM/HT unicast frames.
+	 * We check if Short Preamble is needed for the CTS rate by
+	 * checking the BSS's global flag.
+	 * But for the rate series, IEEE80211_TX_RC_USE_SHORT_PREAMBLE is used.
 	 */
-	if (sc->sc_protmode != PROT_M_NONE && !(bf->bf_flags & ATH9K_TXDESC_NOACK)
-	    && (rt->info[rix].phy == WLAN_RC_PHY_OFDM ||
-		WLAN_RC_PHY_HT(rt->info[rix].phy))) {
-		if (sc->sc_protmode == PROT_M_RTSCTS)
-			flags = ATH9K_TXDESC_RTSENA;
-		else if (sc->sc_protmode == PROT_M_CTSONLY)
-			flags = ATH9K_TXDESC_CTSENA;
-
-		cix = rt->info[enable_g_protection].ctrl_rate;
-		rtsctsena = 1;
-	}
+	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
+		ctsrate = rt->info[tx_info->control.rts_cts_rate_idx].ratecode |
+			rt->info[tx_info->control.rts_cts_rate_idx].short_preamble;
+	else
+		ctsrate = rt->info[tx_info->control.rts_cts_rate_idx].ratecode;
 
-	/* For 11n, the default behavior is to enable RTS for hw retried frames.
-	 * We enable the global flag here and let rate series flags determine
-	 * which rates will actually use RTS.
+	/*
+	 * ATH9K_TXDESC_RTSENA and ATH9K_TXDESC_CTSENA are mutually exclusive.
+	 * Check the first rate in the series to decide whether RTS/CTS
+	 * or CTS-to-self has to be used.
 	 */
-	if ((ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) && bf_isdata(bf)) {
-		/* 802.11g protection not needed, use our default behavior */
-		if (!rtsctsena)
-			flags = ATH9K_TXDESC_RTSENA;
-	}
+	if (rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
+		flags = ATH9K_TXDESC_CTSENA;
+	else if (rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
+		flags = ATH9K_TXDESC_RTSENA;
 
-	/* Set protection if aggregate protection on */
+	/* FIXME: Handle aggregation protection */
 	if (sc->sc_config.ath_aggr_prot &&
 	    (!bf_isaggr(bf) || (bf_isaggr(bf) && bf->bf_al < 8192))) {
 		flags = ATH9K_TXDESC_RTSENA;
-		cix = rt->info[enable_g_protection].ctrl_rate;
-		rtsctsena = 1;
 	}
 
 	/* For AR5416 - RTS cannot be followed by a frame larger than 8K */
-	if (bf_isaggr(bf) && (bf->bf_al > ah->ah_caps.rts_aggr_limit))
+	if (bf_isaggr(bf) && (bf->bf_al > sc->sc_ah->ah_caps.rts_aggr_limit))
 		flags &= ~(ATH9K_TXDESC_RTSENA);
 
-	/*
-	 * CTS transmit rate is derived from the transmit rate by looking in the
-	 * h/w rate table.  We must also factor in whether or not a short
-	 * preamble is to be used. NB: cix is set above where RTS/CTS is enabled
-	 */
-	ctsrate = rt->info[cix].ratecode |
-		(bf_isshpreamble(bf) ? rt->info[cix].short_preamble : 0);
-
 	for (i = 0; i < 4; i++) {
 		if (!rates[i].count || (rates[i].idx < 0))
 			continue;
 
 		rix = rates[i].idx;
-
-		series[i].Rate = rt->info[rix].ratecode |
-			(bf_isshpreamble(bf) ? rt->info[rix].short_preamble : 0);
-
 		series[i].Tries = rates[i].count;
+		series[i].ChSel = sc->sc_tx_chainmask;
 
-		series[i].RateFlags = (
-			(rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS) ?
-				ATH9K_RATESERIES_RTS_CTS : 0) |
-			((rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ?
-				ATH9K_RATESERIES_2040 : 0) |
-			((rates[i].flags & IEEE80211_TX_RC_SHORT_GI) ?
-				ATH9K_RATESERIES_HALFGI : 0);
+		if (rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+			series[i].Rate = rt->info[rix].ratecode |
+				rt->info[rix].short_preamble;
+		else
+			series[i].Rate = rt->info[rix].ratecode;
+
+		if (rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS)
+			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
+		if (rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			series[i].RateFlags |= ATH9K_RATESERIES_2040;
+		if (rates[i].flags & IEEE80211_TX_RC_SHORT_GI)
+			series[i].RateFlags |= ATH9K_RATESERIES_HALFGI;
 
 		series[i].PktDuration = ath_pkt_duration(sc, rix, bf,
 			 (rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH) != 0,
 			 (rates[i].flags & IEEE80211_TX_RC_SHORT_GI),
-			 bf_isshpreamble(bf));
-
-		series[i].ChSel = sc->sc_tx_chainmask;
-
-		if (rtsctsena)
-			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
+			 (rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE));
 	}
 
 	/* set dur_update_en for l-sig computation except for PS-Poll frames */
-	ath9k_hw_set11n_ratescenario(ah, ds, lastds, !bf_ispspoll(bf),
-				     ctsrate, ctsduration,
-				     series, 4, flags);
+	ath9k_hw_set11n_ratescenario(sc->sc_ah, bf->bf_desc,
+				     bf->bf_lastbf->bf_desc,
+				     !bf_ispspoll(bf), ctsrate,
+				     0, series, 4, flags);
 
 	if (sc->sc_config.ath_aggr_prot && flags)
-		ath9k_hw_set11n_burstduration(ah, ds, 8192);
+		ath9k_hw_set11n_burstduration(sc->sc_ah, bf->bf_desc, 8192);
 }
 
 static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
@@ -1592,8 +1539,6 @@ static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 		bf->bf_state.bf_type |= BUF_BAR;
 	if (ieee80211_is_pspoll(fc))
 		bf->bf_state.bf_type |= BUF_PSPOLL;
-	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
-		bf->bf_state.bf_type |= BUF_SHORT_PREAMBLE;
 	if ((conf_is_ht(&sc->hw->conf) && !is_pae(skb) &&
 	     (tx_info->flags & IEEE80211_TX_CTL_AMPDU)))
 		bf->bf_state.bf_type |= BUF_HT;
-- 
1.6.1

