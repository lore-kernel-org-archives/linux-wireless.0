Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27946 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbYKRDkr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:40:47 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:40:47 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14481.753180.254920@gargle.gargle.HOWL> (sfid-20081118_044110_476414_37F5C355)
Date: Tue, 18 Nov 2008 09:07:53 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 12/18] ath9k: Remove ath9k_rate_table
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maintaining two sets of rate tables is redundant, remove one
and use struct ath_rate_table exclusively.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |   26 +----
 drivers/net/wireless/ath9k/beacon.c |    8 +-
 drivers/net/wireless/ath9k/core.c   |   52 ++--------
 drivers/net/wireless/ath9k/core.h   |    5 -
 drivers/net/wireless/ath9k/hw.c     |  190 +----------------------------------
 drivers/net/wireless/ath9k/main.c   |    2 +
 drivers/net/wireless/ath9k/rc.c     |   51 ++++++++-
 drivers/net/wireless/ath9k/rc.h     |    3 +
 drivers/net/wireless/ath9k/recv.c   |    6 +-
 drivers/net/wireless/ath9k/xmit.c   |  163 +++++++++++-------------------
 10 files changed, 132 insertions(+), 374 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 6be2b94..c4012c8 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -401,22 +401,6 @@ enum ath9k_int {
 	ATH9K_INT_NOCARD = 0xffffffff
 };
 
-struct ath9k_rate_table {
-	int rateCount;
-	u8 rateCodeToIndex[256];
-	struct {
-		u8 valid;
-		u8 phy;
-		u32 rateKbps;
-		u8 rateCode;
-		u8 shortPreamble;
-		u8 dot11Rate;
-		u8 controlRate;
-		u16 lpAckDuration;
-		u16 spAckDuration;
-	} info[32];
-};
-
 #define ATH9K_RATESERIES_RTS_CTS  0x0001
 #define ATH9K_RATESERIES_2040     0x0002
 #define ATH9K_RATESERIES_HALFGI   0x0004
@@ -828,6 +812,8 @@ struct chan_centers {
 	u16 ext_center;
 };
 
+struct ath_rate_table;
+
 /* Helpers */
 
 enum wireless_mode ath9k_hw_chan2wmode(struct ath_hal *ah,
@@ -838,7 +824,7 @@ bool ath9k_get_channel_edges(struct ath_hal *ah,
 			     u16 flags, u16 *low,
 			     u16 *high);
 u16 ath9k_hw_computetxtime(struct ath_hal *ah,
-			   const struct ath9k_rate_table *rates,
+			   struct ath_rate_table *rates,
 			   u32 frameLen, u16 rateix,
 			   bool shortPreamble);
 u32 ath9k_hw_mhz2ieee(struct ath_hal *ah, u32 freq, u32 flags);
@@ -883,12 +869,6 @@ void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore);
 void ath9k_hw_beaconinit(struct ath_hal *ah, u32 next_beacon, u32 beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 				    const struct ath9k_beacon_state *bs);
-
-/* Rate table */
-
-const struct ath9k_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
-						     u32 mode);
-
 /* HW Capabilities */
 
 bool ath9k_hw_fill_cap_info(struct ath_hal *ah);
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index d186cd4..dcf2383 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -68,7 +68,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_desc *ds;
 	struct ath9k_11n_rate_series series[4];
-	const struct ath9k_rate_table *rt;
+	struct ath_rate_table *rt;
 	int flags, antenna;
 	u8 rix, rate;
 	int ctsrate = 0;
@@ -106,10 +106,10 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	 * XXX everything at min xmit rate
 	 */
 	rix = 0;
-	rt = sc->sc_currates;
-	rate = rt->info[rix].rateCode;
+	rt = sc->hw_rate_table[sc->sc_curmode];
+	rate = rt->info[rix].ratecode;
 	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
-		rate |= rt->info[rix].shortPreamble;
+		rate |= rt->info[rix].short_preamble;
 
 	ath9k_hw_set11n_txdesc(ah, ds,
 			       skb->len + FCS_LEN,     /* frame length */
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 6c872e7..fb6a013 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -80,38 +80,9 @@ static u8 parse_mpdudensity(u8 mpdudensity)
 
 /*
  *  Set current operating mode
- *
- *  This function initializes and fills the rate table in the ATH object based
- *  on the operating mode.
 */
 static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
 {
-	const struct ath9k_rate_table *rt;
-	int i;
-
-	rt = ath9k_hw_getratetable(sc->sc_ah, mode);
-	BUG_ON(!rt);
-
-	memset(sc->sc_hwmap, 0, sizeof(sc->sc_hwmap));
-	for (i = 0; i < 256; i++) {
-		u8 ix = rt->rateCodeToIndex[i];
-
-		if (ix == 0xff)
-			continue;
-
-		sc->sc_hwmap[i].ieeerate =
-		    rt->info[ix].dot11Rate & IEEE80211_RATE_VAL;
-		sc->sc_hwmap[i].rateKbps = rt->info[ix].rateKbps;
-
-		if (rt->info[ix].shortPreamble ||
-		    rt->info[ix].phy == PHY_OFDM) {
-			/* XXX: Handle this */
-		}
-
-		/* NB: this uses the last entry if the rate isn't found */
-		/* XXX beware of overlow */
-	}
-	sc->sc_currates = rt;
 	sc->sc_curmode = mode;
 	/*
 	 * All protection frames are transmited at 2Mb/s for
@@ -126,37 +97,36 @@ static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
  */
 static void ath_setup_rates(struct ath_softc *sc, enum ieee80211_band band)
 {
-	struct ath_hal *ah = sc->sc_ah;
-	const struct ath9k_rate_table *rt = NULL;
+	struct ath_rate_table *rate_table = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *rate;
 	int i, maxrates;
 
 	switch (band) {
 	case IEEE80211_BAND_2GHZ:
-		rt = ath9k_hw_getratetable(ah, ATH9K_MODE_11G);
+		rate_table = sc->hw_rate_table[ATH9K_MODE_11G];
 		break;
 	case IEEE80211_BAND_5GHZ:
-		rt = ath9k_hw_getratetable(ah, ATH9K_MODE_11A);
+		rate_table = sc->hw_rate_table[ATH9K_MODE_11A];
 		break;
 	default:
 		break;
 	}
 
-	if (rt == NULL)
+	if (rate_table == NULL)
 		return;
 
 	sband = &sc->sbands[band];
 	rate = sc->rates[band];
 
-	if (rt->rateCount > ATH_RATE_MAX)
+	if (rate_table->rate_cnt > ATH_RATE_MAX)
 		maxrates = ATH_RATE_MAX;
 	else
-		maxrates = rt->rateCount;
+		maxrates = rate_table->rate_cnt;
 
 	for (i = 0; i < maxrates; i++) {
-		rate[i].bitrate = rt->info[i].rateKbps / 100;
-		rate[i].hw_value = rt->info[i].rateCode;
+		rate[i].bitrate = rate_table->info[i].ratekbps / 100;
+		rate[i].hw_value = rate_table->info[i].ratecode;
 		sband->n_bitrates++;
 		DPRINTF(sc, ATH_DBG_CONFIG,
 			"%s: Rate: %2dMbps, ratecode: %2d\n",
@@ -1000,12 +970,10 @@ int ath_init(u16 devid, struct ath_softc *sc)
 
 	/* Setup rate tables */
 
+	ath_rate_attach(sc);
 	ath_setup_rates(sc, IEEE80211_BAND_2GHZ);
 	ath_setup_rates(sc, IEEE80211_BAND_5GHZ);
 
-	/* NB: setup here so ath_rate_update is happy */
-	ath_setcurmode(sc, ATH9K_MODE_11A);
-
 	/*
 	 * Allocate hardware transmit queues: one queue for
 	 * beacon frames and one data queue for each QoS
@@ -1071,8 +1039,6 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sc_ani.sc_noise_floor = ATH_DEFAULT_NOISE_FLOOR;
 	setup_timer(&sc->sc_ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
-	ath_rate_attach(sc);
-
 	if (ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
 				   ATH9K_CIPHER_TKIP, NULL)) {
 		/*
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 255f860..0c34820 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -858,12 +858,7 @@ struct ath_softc {
 	/* Rate */
 	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
 	struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
-	const struct ath9k_rate_table *sc_currates;
 	u8 sc_protrix;		/* protection rate index */
-	struct {
-		u32 rateKbps;	/* transfer rate in kbs */
-		u8 ieeerate;	/* IEEE rate */
-	} sc_hwmap[256];	/* h/w rate ix mappings */
 
 	/* Channel, Band */
 	struct ieee80211_channel channels[IEEE80211_NUM_BANDS][ATH_CHAN_MAX];
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index dc30703..7964639 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -142,14 +142,14 @@ bool ath9k_get_channel_edges(struct ath_hal *ah,
 }
 
 u16 ath9k_hw_computetxtime(struct ath_hal *ah,
-			   const struct ath9k_rate_table *rates,
+			   struct ath_rate_table *rates,
 			   u32 frameLen, u16 rateix,
 			   bool shortPreamble)
 {
 	u32 bitsPerSymbol, numBits, numSymbols, phyTime, txTime;
 	u32 kbps;
 
-	kbps = rates->info[rateix].rateKbps;
+	kbps = rates->info[rateix].ratekbps;
 
 	if (kbps == 0)
 		return 0;
@@ -157,7 +157,7 @@ u16 ath9k_hw_computetxtime(struct ath_hal *ah,
 	switch (rates->info[rateix].phy) {
 	case PHY_CCK:
 		phyTime = CCK_PREAMBLE_BITS + CCK_PLCP_BITS;
-		if (shortPreamble && rates->info[rateix].shortPreamble)
+		if (shortPreamble && rates->info[rateix].short_preamble)
 			phyTime >>= 1;
 		numBits = frameLen << 3;
 		txTime = CCK_SIFS_TIME + phyTime + ((numBits * 1000) / kbps);
@@ -3191,190 +3191,6 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 
 }
 
-/***************/
-/* Rate tables */
-/***************/
-
-static struct ath9k_rate_table ar5416_11a_table = {
-	8,
-	{0},
-	{
-		{true, PHY_OFDM, 6000, 0x0b, 0x00, (0x80 | 12), 0},
-		{true, PHY_OFDM, 9000, 0x0f, 0x00, 18, 0},
-		{true, PHY_OFDM, 12000, 0x0a, 0x00, (0x80 | 24), 2},
-		{true, PHY_OFDM, 18000, 0x0e, 0x00, 36, 2},
-		{true, PHY_OFDM, 24000, 0x09, 0x00, (0x80 | 48), 4},
-		{true, PHY_OFDM, 36000, 0x0d, 0x00, 72, 4},
-		{true, PHY_OFDM, 48000, 0x08, 0x00, 96, 4},
-		{true, PHY_OFDM, 54000, 0x0c, 0x00, 108, 4}
-	},
-};
-
-static struct ath9k_rate_table ar5416_11b_table = {
-	4,
-	{0},
-	{
-		{true, PHY_CCK, 1000, 0x1b, 0x00, (0x80 | 2), 0},
-		{true, PHY_CCK, 2000, 0x1a, 0x04, (0x80 | 4), 1},
-		{true, PHY_CCK, 5500, 0x19, 0x04, (0x80 | 11), 1},
-		{true, PHY_CCK, 11000, 0x18, 0x04, (0x80 | 22), 1}
-	},
-};
-
-static struct ath9k_rate_table ar5416_11g_table = {
-	12,
-	{0},
-	{
-		{true, PHY_CCK, 1000, 0x1b, 0x00, (0x80 | 2), 0},
-		{true, PHY_CCK, 2000, 0x1a, 0x04, (0x80 | 4), 1},
-		{true, PHY_CCK, 5500, 0x19, 0x04, (0x80 | 11), 2},
-		{true, PHY_CCK, 11000, 0x18, 0x04, (0x80 | 22), 3},
-
-		{false, PHY_OFDM, 6000, 0x0b, 0x00, 12, 4},
-		{false, PHY_OFDM, 9000, 0x0f, 0x00, 18, 4},
-		{true, PHY_OFDM, 12000, 0x0a, 0x00, 24, 6},
-		{true, PHY_OFDM, 18000, 0x0e, 0x00, 36, 6},
-		{true, PHY_OFDM, 24000, 0x09, 0x00, 48, 8},
-		{true, PHY_OFDM, 36000, 0x0d, 0x00, 72, 8},
-		{true, PHY_OFDM, 48000, 0x08, 0x00, 96, 8},
-		{true, PHY_OFDM, 54000, 0x0c, 0x00, 108, 8}
-	},
-};
-
-static struct ath9k_rate_table ar5416_11ng_table = {
-	28,
-	{0},
-	{
-		{true, PHY_CCK, 1000, 0x1b, 0x00, (0x80 | 2), 0},
-		{true, PHY_CCK, 2000, 0x1a, 0x04, (0x80 | 4), 1},
-		{true, PHY_CCK, 5500, 0x19, 0x04, (0x80 | 11), 2},
-		{true, PHY_CCK, 11000, 0x18, 0x04, (0x80 | 22), 3},
-
-		{false, PHY_OFDM, 6000, 0x0b, 0x00, 12, 4},
-		{false, PHY_OFDM, 9000, 0x0f, 0x00, 18, 4},
-		{true, PHY_OFDM, 12000, 0x0a, 0x00, 24, 6},
-		{true, PHY_OFDM, 18000, 0x0e, 0x00, 36, 6},
-		{true, PHY_OFDM, 24000, 0x09, 0x00, 48, 8},
-		{true, PHY_OFDM, 36000, 0x0d, 0x00, 72, 8},
-		{true, PHY_OFDM, 48000, 0x08, 0x00, 96, 8},
-		{true, PHY_OFDM, 54000, 0x0c, 0x00, 108, 8},
-		{true, PHY_HT, 6500, 0x80, 0x00, 0, 4},
-		{true, PHY_HT, 13000, 0x81, 0x00, 1, 6},
-		{true, PHY_HT, 19500, 0x82, 0x00, 2, 6},
-		{true, PHY_HT, 26000, 0x83, 0x00, 3, 8},
-		{true, PHY_HT, 39000, 0x84, 0x00, 4, 8},
-		{true, PHY_HT, 52000, 0x85, 0x00, 5, 8},
-		{true, PHY_HT, 58500, 0x86, 0x00, 6, 8},
-		{true, PHY_HT, 65000, 0x87, 0x00, 7, 8},
-		{true, PHY_HT, 13000, 0x88, 0x00, 8, 4},
-		{true, PHY_HT, 26000, 0x89, 0x00, 9, 6},
-		{true, PHY_HT, 39000, 0x8a, 0x00, 10, 6},
-		{true, PHY_HT, 52000, 0x8b, 0x00, 11, 8},
-		{true, PHY_HT, 78000, 0x8c, 0x00, 12, 8},
-		{true, PHY_HT, 104000, 0x8d, 0x00, 13, 8},
-		{true, PHY_HT, 117000, 0x8e, 0x00, 14, 8},
-		{true, PHY_HT, 130000, 0x8f, 0x00, 15, 8},
-	},
-};
-
-static struct ath9k_rate_table ar5416_11na_table = {
-	24,
-	{0},
-	{
-		{true, PHY_OFDM, 6000, 0x0b, 0x00, (0x80 | 12), 0},
-		{true, PHY_OFDM, 9000, 0x0f, 0x00, 18, 0},
-		{true, PHY_OFDM, 12000, 0x0a, 0x00, (0x80 | 24), 2},
-		{true, PHY_OFDM, 18000, 0x0e, 0x00, 36, 2},
-		{true, PHY_OFDM, 24000, 0x09, 0x00, (0x80 | 48), 4},
-		{true, PHY_OFDM, 36000, 0x0d, 0x00, 72, 4},
-		{true, PHY_OFDM, 48000, 0x08, 0x00, 96, 4},
-		{true, PHY_OFDM, 54000, 0x0c, 0x00, 108, 4},
-		{true, PHY_HT, 6500, 0x80, 0x00, 0, 0},
-		{true, PHY_HT, 13000, 0x81, 0x00, 1, 2},
-		{true, PHY_HT, 19500, 0x82, 0x00, 2, 2},
-		{true, PHY_HT, 26000, 0x83, 0x00, 3, 4},
-		{true, PHY_HT, 39000, 0x84, 0x00, 4, 4},
-		{true, PHY_HT, 52000, 0x85, 0x00, 5, 4},
-		{true, PHY_HT, 58500, 0x86, 0x00, 6, 4},
-		{true, PHY_HT, 65000, 0x87, 0x00, 7, 4},
-		{true, PHY_HT, 13000, 0x88, 0x00, 8, 0},
-		{true, PHY_HT, 26000, 0x89, 0x00, 9, 2},
-		{true, PHY_HT, 39000, 0x8a, 0x00, 10, 2},
-		{true, PHY_HT, 52000, 0x8b, 0x00, 11, 4},
-		{true, PHY_HT, 78000, 0x8c, 0x00, 12, 4},
-		{true, PHY_HT, 104000, 0x8d, 0x00, 13, 4},
-		{true, PHY_HT, 117000, 0x8e, 0x00, 14, 4},
-		{true, PHY_HT, 130000, 0x8f, 0x00, 15, 4},
-	},
-};
-
-static void ath9k_hw_setup_rate_table(struct ath_hal *ah,
-				      struct ath9k_rate_table *rt)
-{
-	int i;
-
-	if (rt->rateCodeToIndex[0] != 0)
-		return;
-
-	for (i = 0; i < 256; i++)
-		rt->rateCodeToIndex[i] = (u8) -1;
-
-	for (i = 0; i < rt->rateCount; i++) {
-		u8 code = rt->info[i].rateCode;
-		u8 cix = rt->info[i].controlRate;
-
-		rt->rateCodeToIndex[code] = i;
-		rt->rateCodeToIndex[code | rt->info[i].shortPreamble] = i;
-
-		rt->info[i].lpAckDuration =
-			ath9k_hw_computetxtime(ah, rt,
-					       WLAN_CTRL_FRAME_SIZE,
-					       cix,
-					       false);
-		rt->info[i].spAckDuration =
-			ath9k_hw_computetxtime(ah, rt,
-					       WLAN_CTRL_FRAME_SIZE,
-					       cix,
-					       true);
-	}
-}
-
-const struct ath9k_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
-						     u32 mode)
-{
-	struct ath9k_rate_table *rt;
-
-	switch (mode) {
-	case ATH9K_MODE_11A:
-		rt = &ar5416_11a_table;
-		break;
-	case ATH9K_MODE_11B:
-		rt = &ar5416_11b_table;
-		break;
-	case ATH9K_MODE_11G:
-		rt = &ar5416_11g_table;
-		break;
-	case ATH9K_MODE_11NG_HT20:
-	case ATH9K_MODE_11NG_HT40PLUS:
-	case ATH9K_MODE_11NG_HT40MINUS:
-		rt = &ar5416_11ng_table;
-		break;
-	case ATH9K_MODE_11NA_HT20:
-	case ATH9K_MODE_11NA_HT40PLUS:
-	case ATH9K_MODE_11NA_HT40MINUS:
-		rt = &ar5416_11na_table;
-		break;
-	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL, "%s: invalid mode 0x%x\n",
-			__func__, mode);
-		return NULL;
-	}
-
-	ath9k_hw_setup_rate_table(ah, rt);
-
-	return rt;
-}
-
 /*******************/
 /* HW Capabilities */
 /*******************/
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 7ddb932..cbe53bd 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -781,6 +781,8 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
 		BIT(NL80211_IFTYPE_ADHOC);
 
 	hw->queues = 4;
+	hw->max_rates = 4;
+	hw->max_rate_tries = ATH_11N_TXMAXTRY;
 	hw->sta_data_size = sizeof(struct ath_node);
 	hw->vif_data_size = sizeof(struct ath_vap);
 
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 156b245..bf637aa 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -25,6 +25,7 @@
 
 static struct ath_rate_table ar5416_11na_ratetable = {
 	42,
+	{0},
 	{
 		{ TRUE, TRUE, WLAN_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, 12,
@@ -168,6 +169,7 @@ static struct ath_rate_table ar5416_11na_ratetable = {
 
 static struct ath_rate_table ar5416_11ng_ratetable = {
 	46,
+	{0},
 	{
 		{ TRUE_ALL, TRUE_ALL, WLAN_PHY_CCK, 1000, /* 1 Mb */
 			900, 0x1b, 0x00, 2,
@@ -315,6 +317,7 @@ static struct ath_rate_table ar5416_11ng_ratetable = {
 
 static struct ath_rate_table ar5416_11a_ratetable = {
 	8,
+	{0},
 	{
 		{ TRUE, TRUE, WLAN_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, (0x80|12),
@@ -348,6 +351,7 @@ static struct ath_rate_table ar5416_11a_ratetable = {
 
 static struct ath_rate_table ar5416_11g_ratetable = {
 	12,
+	{0},
 	{
 		{ TRUE, TRUE, WLAN_PHY_CCK, 1000, /* 1 Mb */
 			900, 0x1b, 0x00, 2,
@@ -393,6 +397,7 @@ static struct ath_rate_table ar5416_11g_ratetable = {
 
 static struct ath_rate_table ar5416_11b_ratetable = {
 	4,
+	{0},
 	{
 		{ TRUE, TRUE, WLAN_PHY_CCK, 1000, /* 1 Mb */
 			900, 0x1b,  0x00, (0x80|2),
@@ -1302,14 +1307,14 @@ static void ath_rc_update(struct ath_softc *sc,
 	if (final_ts_idx != 0) {
 		/* Process intermediate rates that failed.*/
 		for (series = 0; series < final_ts_idx ; series++) {
-			if (rates[series].count != 0) {
+			if (rates[series].count != 0 && (rates[series].idx >= 0)) {
 				flags = rates[series].flags;
 				/* If HT40 and we have switched mode from
 				 * 40 to 20 => don't update */
 				if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
-					(ath_rc_priv->rc_phy_mode !=
-					(flags & IEEE80211_TX_RC_40_MHZ_WIDTH)))
+				    (ath_rc_priv->rc_phy_mode != WLAN_RC_40_FLAG))
 					return;
+
 				if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
 					(flags & IEEE80211_TX_RC_SHORT_GI))
 					rix = rate_table->info[
@@ -1343,8 +1348,9 @@ static void ath_rc_update(struct ath_softc *sc,
 	flags = rates[series].flags;
 	/* If HT40 and we have switched mode from 40 to 20 => don't update */
 	if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
-		(ath_rc_priv->rc_phy_mode != (flags & IEEE80211_TX_RC_40_MHZ_WIDTH)))
+	    (ath_rc_priv->rc_phy_mode != WLAN_RC_40_FLAG)) {
 		return;
+	}
 
 	if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) && (flags & IEEE80211_TX_RC_SHORT_GI))
 		rix = rate_table->info[rates[series].idx].ht_index;
@@ -1628,7 +1634,6 @@ static void ath_rate_free_sta(void *priv, struct ieee80211_sta *sta,
 			      void *priv_sta)
 {
 	struct ath_rate_node *rate_priv = priv_sta;
-
 	kfree(rate_priv);
 }
 
@@ -1644,6 +1649,35 @@ static struct rate_control_ops ath_rate_ops = {
 	.free_sta = ath_rate_free_sta,
 };
 
+static void ath_setup_rate_table(struct ath_softc *sc,
+				 struct ath_rate_table *rate_table)
+{
+	int i;
+
+	for (i = 0; i < 256; i++)
+		rate_table->rateCodeToIndex[i] = (u8)-1;
+
+	for (i = 0; i < rate_table->rate_cnt; i++) {
+		u8 code = rate_table->info[i].ratecode;
+		u8 cix = rate_table->info[i].ctrl_rate;
+		u8 sh = rate_table->info[i].short_preamble;
+
+		rate_table->rateCodeToIndex[code] = i;
+		rate_table->rateCodeToIndex[code | sh] = i;
+
+		rate_table->info[i].lpAckDuration =
+			ath9k_hw_computetxtime(sc->sc_ah, rate_table,
+					       WLAN_CTRL_FRAME_SIZE,
+					       cix,
+					       false);
+		rate_table->info[i].spAckDuration =
+			ath9k_hw_computetxtime(sc->sc_ah, rate_table,
+					       WLAN_CTRL_FRAME_SIZE,
+					       cix,
+					       true);
+	}
+}
+
 void ath_rate_attach(struct ath_softc *sc)
 {
 	sc->hw_rate_table[ATH9K_MODE_11B] =
@@ -1664,6 +1698,12 @@ void ath_rate_attach(struct ath_softc *sc)
 		&ar5416_11ng_ratetable;
 	sc->hw_rate_table[ATH9K_MODE_11NG_HT40MINUS] =
 		&ar5416_11ng_ratetable;
+
+	ath_setup_rate_table(sc, &ar5416_11b_ratetable);
+	ath_setup_rate_table(sc, &ar5416_11a_ratetable);
+	ath_setup_rate_table(sc, &ar5416_11g_ratetable);
+	ath_setup_rate_table(sc, &ar5416_11na_ratetable);
+	ath_setup_rate_table(sc, &ar5416_11ng_ratetable);
 }
 
 int ath_rate_control_register(void)
@@ -1675,4 +1715,3 @@ void ath_rate_control_unregister(void)
 {
 	ieee80211_rate_control_unregister(&ath_rate_ops);
 }
-
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 3324bed..c1e370c 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -143,6 +143,7 @@ enum {
  */
 struct ath_rate_table {
 	int rate_cnt;
+	u8 rateCodeToIndex[256];
 	struct {
 		int valid;
 		int valid_single_stream;
@@ -160,6 +161,8 @@ struct ath_rate_table {
 		u8 sgi_index;
 		u8 ht_index;
 		u32 max_4ms_framelen;
+		u16 lpAckDuration;
+		u16 spAckDuration;
 	} info[RATE_TABLE_SIZE];
 	u32 probe_interval;
 	u32 rssi_reduce_interval;
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 000e189..20f8377 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -140,8 +140,9 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 			  struct ieee80211_rx_status *rx_status, bool *decrypt_error,
 			  struct ath_softc *sc)
 {
+	struct ath_rate_table *rate_table = sc->hw_rate_table[sc->sc_curmode];
 	struct ieee80211_hdr *hdr;
-	int ratekbps;
+	int ratekbps, rix;
 	u8 ratecode;
 	__le16 fc;
 
@@ -196,7 +197,8 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 	}
 
 	ratecode = ds->ds_rxstat.rs_rate;
-	ratekbps = sc->sc_hwmap[ratecode].rateKbps;
+	rix = rate_table->rateCodeToIndex[ratecode];
+	ratekbps = rate_table->info[rix].ratekbps;
 
 	/* HT rate */
 	if (ratecode & 0x80) {
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index baf5cb9..b2d0cca 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -176,25 +176,6 @@ static int get_hw_crypto_keytype(struct sk_buff *skb)
 	return ATH9K_KEY_TYPE_CLEAR;
 }
 
-static void setup_rate_retries(struct ath_softc *sc, struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_tx_rate *rates = tx_info->control.rates;
-	struct ieee80211_hdr *hdr;
-	__le16 fc;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-
-	if (ieee80211_has_morefrags(fc) ||
-	    (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
-		rates[1].count = rates[2].count = rates[3].count = 0;
-		rates[1].idx = rates[2].idx = rates[3].idx = 0;
-		/* reset tries but keep rate index */
-		rates[0].count = ATH_TXMAXTRY;
-	}
-}
-
 /* Called only when tx aggregation is enabled and HT is supported */
 
 static void assign_aggr_tid_seqno(struct sk_buff *skb,
@@ -468,27 +449,23 @@ static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
  * width  - 0 for 20 MHz, 1 for 40 MHz
  * half_gi - to use 4us v/s 3.6 us for symbol time
  */
-
 static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
 			    int width, int half_gi, bool shortPreamble)
 {
-	const struct ath9k_rate_table *rt = sc->sc_currates;
+	struct ath_rate_table *rate_table = sc->hw_rate_table[sc->sc_curmode];
 	u32 nbits, nsymbits, duration, nsymbols;
 	u8 rc;
 	int streams, pktlen;
 
 	pktlen = bf_isaggr(bf) ? bf->bf_al : bf->bf_frmlen;
-	rc = rt->info[rix].rateCode;
+	rc = rate_table->info[rix].ratecode;
 
-	/*
-	 * for legacy rates, use old function to compute packet duration
-	 */
+	/* for legacy rates, use old function to compute packet duration */
 	if (!IS_HT_RATE(rc))
-		return ath9k_hw_computetxtime(sc->sc_ah, rt, pktlen, rix,
-					      shortPreamble);
-	/*
-	 * find number of symbols: PLCP + data
-	 */
+		return ath9k_hw_computetxtime(sc->sc_ah, rate_table, pktlen,
+					      rix, shortPreamble);
+
+	/* find number of symbols: PLCP + data */
 	nbits = (pktlen << 3) + OFDM_PLCP_BITS;
 	nsymbits = bits_per_symbol[HT_RC_2_MCS(rc)][width];
 	nsymbols = (nbits + nsymbits - 1) / nsymbits;
@@ -498,9 +475,7 @@ static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
 	else
 		duration = SYMBOL_TIME_HALFGI(nsymbols);
 
-	/*
-	 * addup duration for legacy/ht training and signal fields
-	 */
+	/* addup duration for legacy/ht training and signal fields */
 	streams = HT_RC_2_STREAMS(rc);
 	duration += L_STF + L_LTF + L_SIG + HT_SIG + HT_STF + HT_LTF(streams);
 
@@ -512,114 +487,104 @@ static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	const struct ath9k_rate_table *rt;
+	struct ath_rate_table *rt;
 	struct ath_desc *ds = bf->bf_desc;
 	struct ath_desc *lastds = bf->bf_lastbf->bf_desc;
 	struct ath9k_11n_rate_series series[4];
-	int i, flags, rtsctsena = 0;
-	u32 ctsduration = 0;
-	u8 rix = 0, cix, ctsrate = 0;
 	struct ath_node *an = NULL;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
+	struct ieee80211_hdr *hdr;
+	int i, flags, rtsctsena = 0;
+	u32 ctsduration = 0;
+	u8 rix = 0, cix, ctsrate = 0;
+	__le16 fc;
+
+	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 
 	skb = (struct sk_buff *)bf->bf_mpdu;
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
 	tx_info = IEEE80211_SKB_CB(skb);
-	rates = tx_info->rate_driver_data[0];
+	rates = tx_info->control.rates;
 
 	if (tx_info->control.sta)
 		an = (struct ath_node *)tx_info->control.sta->drv_priv;
 
-	/*
-	 * get the cix for the lowest valid rix.
-	 */
-	rt = sc->sc_currates;
+	if (ieee80211_has_morefrags(fc) ||
+	    (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
+		rates[1].count = rates[2].count = rates[3].count = 0;
+		rates[1].idx = rates[2].idx = rates[3].idx = 0;
+		rates[0].count = ATH_TXMAXTRY;
+	}
+
+	/* get the cix for the lowest valid rix */
+	rt = sc->hw_rate_table[sc->sc_curmode];
 	for (i = 3; i >= 0; i--) {
-		if (rates[i].count) {
+		if (rates[i].count && (rates[i].idx >= 0)) {
 			rix = rates[i].idx;
 			break;
 		}
 	}
+
 	flags = (bf->bf_flags & (ATH9K_TXDESC_RTSENA | ATH9K_TXDESC_CTSENA));
-	cix = rt->info[rix].controlRate;
+	cix = rt->info[rix].ctrl_rate;
 
 	/*
-	 * If 802.11g protection is enabled, determine whether
-	 * to use RTS/CTS or just CTS.  Note that this is only
-	 * done for OFDM/HT unicast frames.
+	 * If 802.11g protection is enabled, determine whether to use RTS/CTS or
+	 * just CTS.  Note that this is only done for OFDM/HT unicast frames.
 	 */
-	if (sc->sc_protmode != PROT_M_NONE &&
-	    (rt->info[rix].phy == PHY_OFDM ||
-	     rt->info[rix].phy == PHY_HT) &&
-	    (bf->bf_flags & ATH9K_TXDESC_NOACK) == 0) {
+	if (sc->sc_protmode != PROT_M_NONE && !(bf->bf_flags & ATH9K_TXDESC_NOACK)
+	    && (rt->info[rix].phy == WLAN_PHY_OFDM ||
+		WLAN_RC_PHY_HT(rt->info[rix].phy))) {
 		if (sc->sc_protmode == PROT_M_RTSCTS)
 			flags = ATH9K_TXDESC_RTSENA;
 		else if (sc->sc_protmode == PROT_M_CTSONLY)
 			flags = ATH9K_TXDESC_CTSENA;
 
-		cix = rt->info[sc->sc_protrix].controlRate;
+		cix = rt->info[sc->sc_protrix].ctrl_rate;
 		rtsctsena = 1;
 	}
 
-	/* For 11n, the default behavior is to enable RTS for
-	 * hw retried frames. We enable the global flag here and
-	 * let rate series flags determine which rates will actually
-	 * use RTS.
+	/* For 11n, the default behavior is to enable RTS for hw retried frames.
+	 * We enable the global flag here and let rate series flags determine
+	 * which rates will actually use RTS.
 	 */
 	if ((ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) && bf_isdata(bf)) {
-		/*
-		 * 802.11g protection not needed, use our default behavior
-		 */
+		/* 802.11g protection not needed, use our default behavior */
 		if (!rtsctsena)
 			flags = ATH9K_TXDESC_RTSENA;
 	}
 
-	/*
-	 * Set protection if aggregate protection on
-	 */
+	/* Set protection if aggregate protection on */
 	if (sc->sc_config.ath_aggr_prot &&
 	    (!bf_isaggr(bf) || (bf_isaggr(bf) && bf->bf_al < 8192))) {
 		flags = ATH9K_TXDESC_RTSENA;
-		cix = rt->info[sc->sc_protrix].controlRate;
+		cix = rt->info[sc->sc_protrix].ctrl_rate;
 		rtsctsena = 1;
 	}
 
-	/*
-	 *  For AR5416 - RTS cannot be followed by a frame larger than 8K.
-	 */
-	if (bf_isaggr(bf) && (bf->bf_al > ah->ah_caps.rts_aggr_limit)) {
-		/*
-		 * Ensure that in the case of SM Dynamic power save
-		 * while we are bursting the second aggregate the
-		 * RTS is cleared.
-		 */
+	/* For AR5416 - RTS cannot be followed by a frame larger than 8K */
+	if (bf_isaggr(bf) && (bf->bf_al > ah->ah_caps.rts_aggr_limit))
 		flags &= ~(ATH9K_TXDESC_RTSENA);
-	}
-
-	/*
-	 * CTS transmit rate is derived from the transmit rate
-	 * by looking in the h/w rate table.  We must also factor
-	 * in whether or not a short preamble is to be used.
-	 * NB: cix is set above where RTS/CTS is enabled
-	 */
-	BUG_ON(cix == 0xff);
-	ctsrate = rt->info[cix].rateCode |
-		(bf_isshpreamble(bf) ? rt->info[cix].shortPreamble : 0);
 
 	/*
-	 * Setup HAL rate series
+	 * CTS transmit rate is derived from the transmit rate by looking in the
+	 * h/w rate table.  We must also factor in whether or not a short
+	 * preamble is to be used. NB: cix is set above where RTS/CTS is enabled
 	 */
-	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
+	ctsrate = rt->info[cix].ratecode |
+		(bf_isshpreamble(bf) ? rt->info[cix].short_preamble : 0);
 
 	for (i = 0; i < 4; i++) {
-		if (!rates[i].count)
+		if (!rates[i].count || (rates[i].idx < 0))
 			continue;
 
 		rix = rates[i].idx;
 
-		series[i].Rate = rt->info[rix].rateCode |
-			(bf_isshpreamble(bf) ? rt->info[rix].shortPreamble : 0);
+		series[i].Rate = rt->info[rix].ratecode |
+			(bf_isshpreamble(bf) ? rt->info[rix].short_preamble : 0);
 
 		series[i].Tries = rates[i].count;
 
@@ -645,13 +610,9 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
 	}
 
-	/*
-	 * set dur_update_en for l-sig computation except for PS-Poll frames
-	 */
-	ath9k_hw_set11n_ratescenario(ah, ds, lastds,
-				     !bf_ispspoll(bf),
-				     ctsrate,
-				     ctsduration,
+	/* set dur_update_en for l-sig computation except for PS-Poll frames */
+	ath9k_hw_set11n_ratescenario(ah, ds, lastds, !bf_ispspoll(bf),
+				     ctsrate, ctsduration,
 				     series, 4, flags);
 
 	if (sc->sc_config.ath_aggr_prot && flags)
@@ -662,7 +623,6 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
  * Function to send a normal HT (non-AMPDU) frame
  * NB: must be called with txq lock held
  */
-
 static int ath_tx_send_normal(struct ath_softc *sc,
 			      struct ath_txq *txq,
 			      struct ath_atx_tid *tid,
@@ -1256,7 +1216,6 @@ static u32 ath_lookup_rate(struct ath_softc *sc,
 			   struct ath_atx_tid *tid)
 {
 	struct ath_rate_table *rate_table = sc->hw_rate_table[sc->sc_curmode];
-	const struct ath9k_rate_table *rt = sc->sc_currates;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
@@ -1280,7 +1239,7 @@ static u32 ath_lookup_rate(struct ath_softc *sc,
 
 	for (i = 0; i < 4; i++) {
 		if (rates[i].count) {
-			if (rt->info[rates[i].idx].phy != PHY_HT) {
+			if (!WLAN_RC_PHY_HT(rate_table->info[rates[i].idx].phy)) {
 				legacy = 1;
 				break;
 			}
@@ -1325,7 +1284,7 @@ static int ath_compute_num_delims(struct ath_softc *sc,
 				  struct ath_buf *bf,
 				  u16 frmlen)
 {
-	const struct ath9k_rate_table *rt = sc->sc_currates;
+	struct ath_rate_table *rt = sc->hw_rate_table[sc->sc_curmode];
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	u32 nsymbits, nsymbols, mpdudensity;
@@ -1362,7 +1321,7 @@ static int ath_compute_num_delims(struct ath_softc *sc,
 
 	rix = tx_info->control.rates[0].idx;
 	flags = tx_info->control.rates[0].flags;
-	rc = rt->info[rix].rateCode;
+	rc = rt->info[rix].ratecode;
 	width = (flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ? 1 : 0;
 	half_gi = (flags & IEEE80211_TX_RC_SHORT_GI) ? 1 : 0;
 
@@ -1713,10 +1672,6 @@ static void ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 		bf->bf_keyix = ATH9K_TXKEYIX_INVALID;
 	}
 
-	/* Rate series */
-
-	setup_rate_retries(sc, skb);
-
 	/* Assign seqno, tidno */
 
 	if (bf_isht(bf) && (sc->sc_flags & SC_OP_TXAGGR))
-- 
1.6.0.3

