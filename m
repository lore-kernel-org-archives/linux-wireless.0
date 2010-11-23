Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33765 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab0KWTMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:12:55 -0500
Received: by ewy5 with SMTP id 5so2659577ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:12:54 -0800 (PST)
Date: Tue, 23 Nov 2010 21:12:23 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 15/30] ath5k: Extend rate_duration
Message-ID: <20101123191144.GO4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Extend ieee80211_generic_frame_duration to support the various
 bwmodes.

 * Better document what's going on with ack bitrates and update
 write_rate_duration to support the standard ack bitrates (when
 we don't set the high bit).

 * Get rid of set_ack_bitrate_high and introduce a flag on ath5k_hw
 for this (we only called the function on init anyway so there is no
 difference).

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   12 ++-
 drivers/net/wireless/ath/ath5k/base.c  |    4 +-
 drivers/net/wireless/ath/ath5k/pcu.c   |  159 +++++++++++++++++++++++---------
 3 files changed, 129 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index e11fc8f..7df5b46 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -267,6 +267,15 @@
 #define	AR5K_INIT_SIFS_HALF_RATE		32
 #define AR5K_INIT_SIFS_QUARTER_RATE		64
 
+/* Used to calculate tx time for non 5/10/40MHz
+ * operation */
+/* It's preamble time + signal time (16 + 4) */
+#define	AR5K_INIT_OFDM_PREAMPLE_TIME		20
+/* Preamble time for 40MHz (turbo) operation (min ?) */
+#define	AR5K_INIT_OFDM_PREAMBLE_TIME_MIN	14
+#define	AR5K_INIT_OFDM_SYMBOL_TIME		4
+#define	AR5K_INIT_OFDM_PLCP_BITS		22
+
 /* Rx latency for 5 and 10MHz operation (max ?) */
 #define AR5K_INIT_RX_LAT_MAX			63
 /* Tx latencies from initvals (5212 only but no problem
@@ -1083,6 +1092,7 @@ struct ath5k_hw {
 
 	u32			ah_limit_tx_retries;
 	u8			ah_coverage_class;
+	bool			ah_ack_bitrate_high;
 	u8			ah_bwmode;
 
 	/* Antenna Control */
@@ -1248,8 +1258,6 @@ void ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64);
 void ath5k_hw_reset_tsf(struct ath5k_hw *ah);
 void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval);
 bool ath5k_hw_check_beacon_timers(struct ath5k_hw *ah, int intval);
-/* ACK bit rate */
-void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high);
 /* Init function */
 void ath5k_hw_pcu_init(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 								u8 mode);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9af7e46..526d8bc 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2420,7 +2420,9 @@ ath5k_init(struct ath5k_softc *sc)
 	for (i = 0; i < common->keymax; i++)
 		ath_hw_keyreset(common, (u16) i);
 
-	ath5k_hw_set_ack_bitrate_high(ah, true);
+	/* Use higher rates for acks instead of base
+	 * rate */
+	ah->ah_ack_bitrate_high = true;
 
 	for (i = 0; i < ARRAY_SIZE(sc->bslot); i++)
 		sc->bslot[i] = NULL;
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index cb6e277..e691378 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -31,11 +31,100 @@
 #include "debug.h"
 #include "base.h"
 
+/*
+ * AR5212+ can use higher rates for ack transmition
+ * based on current tx rate instead of the base rate.
+ * It does this to better utilize channel usage.
+ * This is a mapping between G rates (that cover both
+ * CCK and OFDM) and ack rates that we use when setting
+ * rate -> duration table. This mapping is hw-based so
+ * don't change anything.
+ *
+ * To enable this functionality we must set
+ * ah->ah_ack_bitrate_high to true else base rate is
+ * used (1Mb for CCK, 6Mb for OFDM).
+ */
+static const unsigned int ack_rates_high[] =
+/* Tx	-> ACK	*/
+/* 1Mb	-> 1Mb	*/	{ 0,
+/* 2MB	-> 2Mb	*/	1,
+/* 5.5Mb -> 2Mb	*/	1,
+/* 11Mb	-> 2Mb	*/	1,
+/* 6Mb	-> 6Mb	*/	4,
+/* 9Mb	-> 6Mb	*/	4,
+/* 12Mb	-> 12Mb	*/	6,
+/* 18Mb	-> 12Mb	*/	6,
+/* 24Mb	-> 24Mb	*/	8,
+/* 36Mb	-> 24Mb	*/	8,
+/* 48Mb	-> 24Mb	*/	8,
+/* 54Mb	-> 24Mb	*/	8 };
+
 /*******************\
 * Helper functions *
 \*******************/
 
 /**
+ * ath5k_hw_get_frame_duration - Get tx time of a frame
+ *
+ * @ah: The &struct ath5k_hw
+ * @len: Frame's length in bytes
+ * @rate: The @struct ieee80211_rate
+ *
+ * Calculate tx duration of a frame given it's rate and length
+ * It extends ieee80211_generic_frame_duration for non standard
+ * bwmodes.
+ */
+int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
+		int len, struct ieee80211_rate *rate)
+{
+	struct ath5k_softc *sc = ah->ah_sc;
+	int sifs, preamble, plcp_bits, sym_time;
+	int bitrate, bits, symbols, symbol_bits;
+	int dur;
+
+	/* Fallback */
+	if (!ah->ah_bwmode) {
+		dur = ieee80211_generic_frame_duration(sc->hw,
+						NULL, len, rate);
+		return dur;
+	}
+
+	bitrate = rate->bitrate;
+	preamble = AR5K_INIT_OFDM_PREAMPLE_TIME;
+	plcp_bits = AR5K_INIT_OFDM_PLCP_BITS;
+	sym_time = AR5K_INIT_OFDM_SYMBOL_TIME;
+
+	switch (ah->ah_bwmode) {
+	case AR5K_BWMODE_40MHZ:
+		sifs = AR5K_INIT_SIFS_TURBO;
+		preamble = AR5K_INIT_OFDM_PREAMBLE_TIME_MIN;
+		break;
+	case AR5K_BWMODE_10MHZ:
+		sifs = AR5K_INIT_SIFS_HALF_RATE;
+		preamble *= 2;
+		sym_time *= 2;
+		break;
+	case AR5K_BWMODE_5MHZ:
+		sifs = AR5K_INIT_SIFS_QUARTER_RATE;
+		preamble *= 4;
+		sym_time *= 4;
+		break;
+	default:
+		sifs = AR5K_INIT_SIFS_DEFAULT_BG;
+		break;
+	}
+
+	bits = plcp_bits + (len << 3);
+	/* Bit rate is in 100Kbits */
+	symbol_bits = bitrate * sym_time;
+	symbols = DIV_ROUND_UP(bits * 10, symbol_bits);
+
+	dur = sifs + preamble + (sym_time * symbols);
+
+	return dur;
+}
+
+/**
  * ath5k_hw_get_default_slottime - Get the default slot time for current mode
  *
  * @ah: The &struct ath5k_hw
@@ -120,43 +209,11 @@ void ath5k_hw_update_mib_counters(struct ath5k_hw *ah)
 	stats->beacons += ath5k_hw_reg_read(ah, AR5K_BEACON_CNT);
 }
 
-/**
- * ath5k_hw_set_ack_bitrate - set bitrate for ACKs
- *
- * @ah: The &struct ath5k_hw
- * @high: Flag to determine if we want to use high transmission rate
- * for ACKs or not
- *
- * If high flag is set, we tell hw to use a set of control rates based on
- * the current transmission rate (check out control_rates array inside reset.c).
- * If not hw just uses the lowest rate available for the current modulation
- * scheme being used (1Mbit for CCK and 6Mbits for OFDM).
- */
-void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high)
-{
-	if (ah->ah_version != AR5K_AR5212)
-		return;
-	else {
-		u32 val = AR5K_STA_ID1_BASE_RATE_11B | AR5K_STA_ID1_ACKCTS_6MB;
-		if (high)
-			AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1, val);
-		else
-			AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1, val);
-	}
-}
-
 
 /******************\
 * ACK/CTS Timeouts *
 \******************/
 
-/*
- * index into rates for control rates, we can set it up like this because
- * this is only used for AR5212 and we know it supports G mode
- */
-static const unsigned int control_rates[] =
-	{ 0, 1, 1, 1, 4, 4, 6, 6, 8, 8, 8, 8 };
-
 /**
  * ath5k_hw_write_rate_duration - fill rate code to duration table
  *
@@ -164,7 +221,7 @@ static const unsigned int control_rates[] =
  * @mode: one of enum ath5k_driver_mode
  *
  * Write the rate code to duration table upon hw reset. This is a helper for
- * ath5k_hw_reset(). It seems all this is doing is setting an ACK timeout on
+ * ath5k_hw_pcu_init(). It seems all this is doing is setting an ACK timeout on
  * the hardware, based on current mode, for each rate. The rates which are
  * capable of short preamble (802.11b rates 2Mbps, 5.5Mbps, and 11Mbps) have
  * different rate code so we write their value twice (one for long preample
@@ -172,23 +229,30 @@ static const unsigned int control_rates[] =
  *
  * Note: Band doesn't matter here, if we set the values for OFDM it works
  * on both a and g modes. So all we have to do is set values for all g rates
- * that include all OFDM and CCK rates. If we operate in turbo or xr/half/
- * quarter rate mode, we need to use another set of bitrates (that's why we
- * need the mode parameter) but we don't handle these proprietary modes yet.
+ * that include all OFDM and CCK rates.
+ *
  */
-static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
-						unsigned int mode)
+static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
 {
 	struct ath5k_softc *sc = ah->ah_sc;
 	struct ieee80211_rate *rate;
 	unsigned int i;
+	/* 802.11g covers both OFDM and CCK */
+	u8 band = IEEE80211_BAND_2GHZ;
 
 	/* Write rate duration table */
-	for (i = 0; i < sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates; i++) {
+	for (i = 0; i < sc->sbands[band].n_bitrates; i++) {
 		u32 reg;
 		u16 tx_time;
 
-		rate = &sc->sbands[IEEE80211_BAND_2GHZ].bitrates[control_rates[i]];
+		if (ah->ah_ack_bitrate_high)
+			rate = &sc->sbands[band].bitrates[ack_rates_high[i]];
+		/* CCK -> 1Mb */
+		else if (i < 4)
+			rate = &sc->sbands[band].bitrates[0];
+		/* OFDM -> 6Mb */
+		else
+			rate = &sc->sbands[band].bitrates[4];
 
 		/* Set ACK timeout */
 		reg = AR5K_RATE_DUR(rate->hw_value);
@@ -199,8 +263,9 @@ static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
 		 * actual rate for this rate. See mac80211 tx.c
 		 * ieee80211_duration() for a brief description of
 		 * what rate we should choose to TX ACKs. */
-		tx_time = le16_to_cpu(ieee80211_generic_frame_duration(sc->hw,
-							NULL, 10, rate));
+		tx_time = ath5k_hw_get_frame_duration(ah, 10, rate);
+
+		tx_time = le16_to_cpu(tx_time);
 
 		ath5k_hw_reg_write(ah, tx_time, reg);
 
@@ -835,7 +900,7 @@ void ath5k_hw_pcu_init(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 * mac80211 are integrated */
 	if (ah->ah_version == AR5K_AR5212 &&
 		ah->ah_sc->nvifs)
-		ath5k_hw_write_rate_duration(ah, mode);
+		ath5k_hw_write_rate_duration(ah);
 
 	/* Set RSSI/BRSSI thresholds
 	 *
@@ -869,5 +934,13 @@ void ath5k_hw_pcu_init(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	if (ah->ah_coverage_class > 0)
 		ath5k_hw_set_coverage_class(ah, ah->ah_coverage_class);
 
+	/* Set ACK bitrate mode (see ack_rates_high) */
+	if (ah->ah_version == AR5K_AR5212) {
+		u32 val = AR5K_STA_ID1_BASE_RATE_11B | AR5K_STA_ID1_ACKCTS_6MB;
+		if (ah->ah_ack_bitrate_high)
+			AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1, val);
+		else
+			AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1, val);
+	}
 	return;
 }
