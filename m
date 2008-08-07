Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54275 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbYHGFgr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 01:36:47 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 22:36:47 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18586.34601.217645.961809@localhost.localdomain> (sfid-20080807_073651_442903_DFE011F0)
Date: Thu, 7 Aug 2008 10:54:57 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 6/6] ath9k: Revamp wireless mode usage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Use a single enum for managing modes, store supported modes by
the HW in a bitmask.
Register legacy rates with mac80211 only at init.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h       |   48 +++-------
 drivers/net/wireless/ath9k/beacon.c      |    2 +-
 drivers/net/wireless/ath9k/core.c        |  150 +++++++++++-------------------
 drivers/net/wireless/ath9k/core.h        |    2 -
 drivers/net/wireless/ath9k/hw.c          |   79 +++++++++-------
 drivers/net/wireless/ath9k/main.c        |   79 ++--------------
 drivers/net/wireless/ath9k/rc.c          |   30 +++---
 drivers/net/wireless/ath9k/rc.h          |    2 +-
 drivers/net/wireless/ath9k/regd.c        |  107 ++++++++++-----------
 drivers/net/wireless/ath9k/regd.h        |   10 +-
 drivers/net/wireless/ath9k/regd_common.h |   18 ++--
 drivers/net/wireless/ath9k/xmit.c        |    2 +-
 12 files changed, 205 insertions(+), 324 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 82e71f9..d1b0fba 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -147,6 +147,19 @@ struct ath_desc {
 
 #define ATH9K_RXDESC_INTREQ		0x0020
 
+enum wireless_mode {
+	ATH9K_MODE_11A = 0,
+	ATH9K_MODE_11B = 2,
+	ATH9K_MODE_11G = 3,
+	ATH9K_MODE_11NA_HT20 = 6,
+	ATH9K_MODE_11NG_HT20 = 7,
+	ATH9K_MODE_11NA_HT40PLUS = 8,
+	ATH9K_MODE_11NA_HT40MINUS = 9,
+	ATH9K_MODE_11NG_HT40PLUS = 10,
+	ATH9K_MODE_11NG_HT40MINUS = 11,
+	ATH9K_MODE_MAX
+};
+
 enum ath9k_hw_caps {
 	ATH9K_HW_CAP_CHAN_SPREAD		= BIT(0),
 	ATH9K_HW_CAP_MIC_AESCCM                 = BIT(1),
@@ -190,7 +203,7 @@ enum ath9k_capability_type {
 
 struct ath9k_hw_capabilities {
 	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
-	u32 wireless_modes;
+	DECLARE_BITMAP(wireless_modes, ATH9K_MODE_MAX); /* ATH9K_MODE_* */
 	u16 total_queues;
 	u16 keycache_size;
 	u16 low_5ghz_chan, high_5ghz_chan;
@@ -813,37 +826,6 @@ struct ath_hal {
 #endif
 };
 
-enum wireless_mode {
-	WIRELESS_MODE_11a = 0,
-	WIRELESS_MODE_11b = 2,
-	WIRELESS_MODE_11g = 3,
-	WIRELESS_MODE_11NA_HT20 = 6,
-	WIRELESS_MODE_11NG_HT20 = 7,
-	WIRELESS_MODE_11NA_HT40PLUS = 8,
-	WIRELESS_MODE_11NA_HT40MINUS = 9,
-	WIRELESS_MODE_11NG_HT40PLUS = 10,
-	WIRELESS_MODE_11NG_HT40MINUS = 11,
-	WIRELESS_MODE_MAX
-};
-
-enum {
-	ATH9K_MODE_SEL_11A = 0x00001,
-	ATH9K_MODE_SEL_11B = 0x00002,
-	ATH9K_MODE_SEL_11G = 0x00004,
-	ATH9K_MODE_SEL_11NG_HT20 = 0x00008,
-	ATH9K_MODE_SEL_11NA_HT20 = 0x00010,
-	ATH9K_MODE_SEL_11NG_HT40PLUS = 0x00020,
-	ATH9K_MODE_SEL_11NG_HT40MINUS = 0x00040,
-	ATH9K_MODE_SEL_11NA_HT40PLUS = 0x00080,
-	ATH9K_MODE_SEL_11NA_HT40MINUS = 0x00100,
-	ATH9K_MODE_SEL_2GHZ = (ATH9K_MODE_SEL_11B |
-			       ATH9K_MODE_SEL_11G |
-			       ATH9K_MODE_SEL_11NG_HT20),
-	ATH9K_MODE_SEL_5GHZ = (ATH9K_MODE_SEL_11A |
-			       ATH9K_MODE_SEL_11NA_HT20),
-	ATH9K_MODE_SEL_ALL = 0xffffffff
-};
-
 struct chan_centers {
 	u16 synth_center;
 	u16 ctl_center;
@@ -865,7 +847,7 @@ bool ath9k_regd_init_channels(struct ath_hal *ah,
 			      u32 maxchans, u32 *nchans,
 			      u8 *regclassids,
 			      u32 maxregids, u32 *nregids,
-			      u16 cc, u32 modeSelect,
+			      u16 cc,
 			      bool enableOutdoor,
 			      bool enableExtendedChannels);
 u32 ath9k_hw_mhz2ieee(struct ath_hal *ah, u32 freq, u32 flags);
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 6e6538b..caf5694 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -108,7 +108,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	 * Calculate rate code.
 	 * XXX everything at min xmit rate
 	 */
-	rix = sc->sc_minrateix;
+	rix = 0;
 	rt = sc->sc_currates;
 	rate = rt->info[rix].rateCode;
 	if (sc->sc_flags & ATH_PREAMBLE_SHORT)
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index f7bf078..f6c4528 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -64,7 +64,7 @@ static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
 	int i;
 
 	memset(sc->sc_rixmap, 0xff, sizeof(sc->sc_rixmap));
-	rt = sc->sc_rates[mode];
+	rt = ath9k_hw_getratetable(sc->sc_ah, mode);
 	BUG_ON(!rt);
 
 	for (i = 0; i < rt->rateCount; i++)
@@ -96,76 +96,52 @@ static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
 	 * 11g, otherwise at 1Mb/s.
 	 * XXX select protection rate index from rate table.
 	 */
-	sc->sc_protrix = (mode == WIRELESS_MODE_11g ? 1 : 0);
-	/* rate index used to send mgt frames */
-	sc->sc_minrateix = 0;
+	sc->sc_protrix = (mode == ATH9K_MODE_11G ? 1 : 0);
 }
 
 /*
- *  Select Rate Table
- *
- *  Based on the wireless mode passed in, the rate table in the ATH object
- *  is set to the mode specific rate table.  This also calls the callback
- *  function to set the rate in the protocol layer object.
-*/
-
-static int ath_rate_setup(struct ath_softc *sc, enum wireless_mode mode)
+ * Set up rate table (legacy rates)
+ */
+static void ath_setup_rates(struct ath_softc *sc, enum ieee80211_band band)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	const struct ath9k_rate_table *rt;
-
-	switch (mode) {
-	case WIRELESS_MODE_11a:
-		sc->sc_rates[mode] =
-			ath9k_hw_getratetable(ah, ATH9K_MODE_SEL_11A);
-		break;
-	case WIRELESS_MODE_11b:
-		sc->sc_rates[mode] =
-			ath9k_hw_getratetable(ah, ATH9K_MODE_SEL_11B);
+	const struct ath9k_rate_table *rt = NULL;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *rate;
+	int i, maxrates;
+
+	switch (band) {
+	case IEEE80211_BAND_2GHZ:
+		rt = ath9k_hw_getratetable(ah, ATH9K_MODE_11G);
 		break;
-	case WIRELESS_MODE_11g:
-		sc->sc_rates[mode] =
-			ath9k_hw_getratetable(ah, ATH9K_MODE_SEL_11G);
-		break;
-	case WIRELESS_MODE_11NA_HT20:
-		sc->sc_rates[mode] =
-			ath9k_hw_getratetable(ah, ATH9K_MODE_SEL_11NA_HT20);
-		break;
-	case WIRELESS_MODE_11NG_HT20:
-		sc->sc_rates[mode] =
-			ath9k_hw_getratetable(ah, ATH9K_MODE_SEL_11NG_HT20);
-		break;
-	case WIRELESS_MODE_11NA_HT40PLUS:
-		sc->sc_rates[mode] =
-			ath9k_hw_getratetable(ah, ATH9K_MODE_SEL_11NA_HT40PLUS);
-		break;
-	case WIRELESS_MODE_11NA_HT40MINUS:
-		sc->sc_rates[mode] =
-			ath9k_hw_getratetable(ah,
-				ATH9K_MODE_SEL_11NA_HT40MINUS);
-		break;
-	case WIRELESS_MODE_11NG_HT40PLUS:
-		sc->sc_rates[mode] =
-			ath9k_hw_getratetable(ah, ATH9K_MODE_SEL_11NG_HT40PLUS);
-		break;
-	case WIRELESS_MODE_11NG_HT40MINUS:
-		sc->sc_rates[mode] =
-			ath9k_hw_getratetable(ah,
-				ATH9K_MODE_SEL_11NG_HT40MINUS);
+	case IEEE80211_BAND_5GHZ:
+		rt = ath9k_hw_getratetable(ah, ATH9K_MODE_11A);
 		break;
 	default:
-		DPRINTF(sc, ATH_DBG_FATAL, "%s: invalid mode %u\n",
-			__func__, mode);
-		return 0;
+		break;
 	}
-	rt = sc->sc_rates[mode];
-	if (rt == NULL)
-		return 0;
 
-	/* setup rate set in 802.11 protocol layer */
-	ath_setup_rate(sc, mode, NORMAL_RATE, rt);
+	if (rt == NULL)
+		return;
 
-	return 1;
+	sband = &sc->sbands[band];
+	rate = sc->rates[band];
+
+	if (rt->rateCount > ATH_RATE_MAX)
+		maxrates = ATH_RATE_MAX;
+	else
+		maxrates = rt->rateCount;
+
+	for (i = 0; i < maxrates; i++) {
+		rate[i].bitrate = rt->info[i].rateKbps / 100;
+		rate[i].hw_value = rt->info[i].rateCode;
+		sband->n_bitrates++;
+		DPRINTF(sc, ATH_DBG_CONFIG,
+			"%s: Rate: %2dMbps, ratecode: %2d\n",
+			__func__,
+			rate[i].bitrate / 10,
+			rate[i].hw_value);
+	}
 }
 
 /*
@@ -191,7 +167,6 @@ static int ath_setup_channels(struct ath_softc *sc)
 				      ATH_REGCLASSIDS_MAX,
 				      &nregclass,
 				      CTRY_DEFAULT,
-				      ATH9K_MODE_SEL_ALL,
 				      false,
 				      1)) {
 		u32 rd = ah->ah_currentRD;
@@ -267,43 +242,26 @@ static int ath_setup_channels(struct ath_softc *sc)
 static enum wireless_mode ath_chan2mode(struct ath9k_channel *chan)
 {
 	if (chan->chanmode == CHANNEL_A)
-		return WIRELESS_MODE_11a;
+		return ATH9K_MODE_11A;
 	else if (chan->chanmode == CHANNEL_G)
-		return WIRELESS_MODE_11g;
+		return ATH9K_MODE_11G;
 	else if (chan->chanmode == CHANNEL_B)
-		return WIRELESS_MODE_11b;
+		return ATH9K_MODE_11B;
 	else if (chan->chanmode == CHANNEL_A_HT20)
-		return WIRELESS_MODE_11NA_HT20;
+		return ATH9K_MODE_11NA_HT20;
 	else if (chan->chanmode == CHANNEL_G_HT20)
-		return WIRELESS_MODE_11NG_HT20;
+		return ATH9K_MODE_11NG_HT20;
 	else if (chan->chanmode == CHANNEL_A_HT40PLUS)
-		return WIRELESS_MODE_11NA_HT40PLUS;
+		return ATH9K_MODE_11NA_HT40PLUS;
 	else if (chan->chanmode == CHANNEL_A_HT40MINUS)
-		return WIRELESS_MODE_11NA_HT40MINUS;
+		return ATH9K_MODE_11NA_HT40MINUS;
 	else if (chan->chanmode == CHANNEL_G_HT40PLUS)
-		return WIRELESS_MODE_11NG_HT40PLUS;
+		return ATH9K_MODE_11NG_HT40PLUS;
 	else if (chan->chanmode == CHANNEL_G_HT40MINUS)
-		return WIRELESS_MODE_11NG_HT40MINUS;
+		return ATH9K_MODE_11NG_HT40MINUS;
 
 	/* NB: should not get here */
-	return WIRELESS_MODE_11b;
-}
-
-/*
- *  Change Channels
- *
- *  Performs the actions to change the channel in the hardware, and set up
- *  the current operating mode for the new channel.
-*/
-
-static void ath_chan_change(struct ath_softc *sc, struct ath9k_channel *chan)
-{
-	enum wireless_mode mode;
-
-	mode = ath_chan2mode(chan);
-
-	ath_rate_setup(sc, mode);
-	ath_setcurmode(sc, mode);
+	return ATH9K_MODE_11B;
 }
 
 /*
@@ -480,7 +438,8 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 		 * Change channels and update the h/w rate map
 		 * if we're switching; e.g. 11a to 11b/g.
 		 */
-		ath_chan_change(sc, hchan);
+		ath_setcurmode(sc, ath_chan2mode(hchan));
+
 		ath_update_txpow(sc);	/* update tx power state */
 		/*
 		 * Re-enable interrupts.
@@ -860,7 +819,7 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	 *  vap and node data structures, which will be needed as soon
 	 *  as we start receiving.
 	 */
-	ath_chan_change(sc, initial_chan);
+	ath_setcurmode(sc, ath_chan2mode(initial_chan));
 
 	/* XXX: we must make sure h/w is ready and clear invalid flag
 	 * before turning on interrupt. */
@@ -902,7 +861,7 @@ static int ath_reset_end(struct ath_softc *sc, u32 flag)
 	 * that changes the channel so update any state that
 	 * might change as a result.
 	 */
-	ath_chan_change(sc, &sc->sc_curchan);
+	ath_setcurmode(sc, ath_chan2mode(&sc->sc_curchan));
 
 	ath_update_txpow(sc);	/* update tx power state */
 
@@ -1212,14 +1171,13 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	/* default to STA mode */
 	sc->sc_opmode = ATH9K_M_MONITOR;
 
-	/* Setup rate tables for all potential media types. */
-	/* 11g encompasses b,g */
+	/* Setup rate tables */
 
-	ath_rate_setup(sc, WIRELESS_MODE_11a);
-	ath_rate_setup(sc, WIRELESS_MODE_11g);
+	ath_setup_rates(sc, IEEE80211_BAND_2GHZ);
+	ath_setup_rates(sc, IEEE80211_BAND_5GHZ);
 
 	/* NB: setup here so ath_rate_update is happy */
-	ath_setcurmode(sc, WIRELESS_MODE_11a);
+	ath_setcurmode(sc, ATH9K_MODE_11A);
 
 	/*
 	 * Allocate hardware transmit queues: one queue for
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index e294c1b..673b3d8 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -1004,10 +1004,8 @@ struct ath_softc {
 
 	/* Rate */
 	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
-	const struct ath9k_rate_table *sc_rates[WIRELESS_MODE_MAX];
 	const struct ath9k_rate_table *sc_currates;
 	u8 sc_rixmap[256];	/* IEEE to h/w rate table ix */
-	u8 sc_minrateix;	/* min h/w rate index */
 	u8 sc_protrix;		/* protection rate index */
 	struct {
 		u32 rateKbps;	/* transfer rate in kbs */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 8c6165c..0c19743 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -225,10 +225,10 @@ static enum wireless_mode ath9k_hw_chan2wmode(struct ath_hal *ah,
 				       const struct ath9k_channel *chan)
 {
 	if (IS_CHAN_CCK(chan))
-		return WIRELESS_MODE_11b;
+		return ATH9K_MODE_11A;
 	if (IS_CHAN_G(chan))
-		return WIRELESS_MODE_11g;
-	return WIRELESS_MODE_11a;
+		return ATH9K_MODE_11G;
+	return ATH9K_MODE_11A;
 }
 
 static bool ath9k_hw_wait(struct ath_hal *ah,
@@ -2416,7 +2416,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 		return;
 	} else {
 		mode = ath9k_hw_chan2wmode(ah, chan);
-		if (mode == WIRELESS_MODE_11g || mode == WIRELESS_MODE_11b) {
+		if (mode == ATH9K_MODE_11G || mode == ATH9K_MODE_11B) {
 			if (!aniState->ofdmWeakSigDetectOff)
 				ath9k_hw_ani_control(ah,
 				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
@@ -2462,7 +2462,7 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 					     aniState->firstepLevel + 1);
 	} else {
 		mode = ath9k_hw_chan2wmode(ah, chan);
-		if (mode == WIRELESS_MODE_11g || mode == WIRELESS_MODE_11b) {
+		if (mode == ATH9K_MODE_11G || mode == ATH9K_MODE_11B) {
 			if (aniState->firstepLevel > 0)
 				ath9k_hw_ani_control(ah,
 						     ATH9K_ANI_FIRSTEP_LEVEL,
@@ -2970,29 +2970,40 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 			 ah->ah_currentRD);
 	}
 
-	pCap->wireless_modes = 0;
 	eeval = ath9k_hw_get_eeprom(ahp, EEP_OP_MODE);
+	bitmap_zero(pCap->wireless_modes, ATH9K_MODE_MAX);
 
 	if (eeval & AR5416_OPFLAGS_11A) {
-		pCap->wireless_modes |= ATH9K_MODE_SEL_11A |
-			((!ah->ah_config.ht_enable
-			  || (eeval & AR5416_OPFLAGS_N_5G_HT20)) ? 0
-			 : (ATH9K_MODE_SEL_11NA_HT20 |
-			    ((eeval & AR5416_OPFLAGS_N_5G_HT40) ? 0
-			     : (ATH9K_MODE_SEL_11NA_HT40PLUS |
-				ATH9K_MODE_SEL_11NA_HT40MINUS))));
+		set_bit(ATH9K_MODE_11A, pCap->wireless_modes);
+		if (ah->ah_config.ht_enable) {
+			if (!(eeval & AR5416_OPFLAGS_N_5G_HT20))
+				set_bit(ATH9K_MODE_11NA_HT20,
+					pCap->wireless_modes);
+			if (!(eeval & AR5416_OPFLAGS_N_5G_HT40)) {
+				set_bit(ATH9K_MODE_11NA_HT40PLUS,
+					pCap->wireless_modes);
+				set_bit(ATH9K_MODE_11NA_HT40MINUS,
+					pCap->wireless_modes);
+			}
+		}
 	}
-	if (eeval & AR5416_OPFLAGS_11G) {
-		pCap->wireless_modes |=
-			ATH9K_MODE_SEL_11B | ATH9K_MODE_SEL_11G |
-			((!ah->ah_config.ht_enable
-			  || (eeval & AR5416_OPFLAGS_N_2G_HT20)) ? 0
-			 : (ATH9K_MODE_SEL_11NG_HT20 |
-			    ((eeval & AR5416_OPFLAGS_N_2G_HT40) ? 0
-			     : (ATH9K_MODE_SEL_11NG_HT40PLUS |
-				ATH9K_MODE_SEL_11NG_HT40MINUS))));
 
+	if (eeval & AR5416_OPFLAGS_11G) {
+		set_bit(ATH9K_MODE_11B, pCap->wireless_modes);
+		set_bit(ATH9K_MODE_11G, pCap->wireless_modes);
+		if (ah->ah_config.ht_enable) {
+			if (!(eeval & AR5416_OPFLAGS_N_2G_HT20))
+				set_bit(ATH9K_MODE_11NG_HT20,
+					pCap->wireless_modes);
+			if (!(eeval & AR5416_OPFLAGS_N_2G_HT40)) {
+				set_bit(ATH9K_MODE_11NG_HT40PLUS,
+					pCap->wireless_modes);
+				set_bit(ATH9K_MODE_11NG_HT40MINUS,
+					pCap->wireless_modes);
+			}
+		}
 	}
+
 	pCap->tx_chainmask = ath9k_hw_get_eeprom(ahp, EEP_TX_MASK);
 	if ((ah->ah_isPciExpress)
 	    || (eeval & AR5416_OPFLAGS_11A)) {
@@ -5209,7 +5220,7 @@ static u32 ath9k_hw_mac_usec(struct ath_hal *ah, u32 clks)
 		return clks /
 		CLOCK_RATE[ath9k_hw_chan2wmode(ah, ah->ah_curchan)];
 	else
-		return clks / CLOCK_RATE[WIRELESS_MODE_11b];
+		return clks / CLOCK_RATE[ATH9K_MODE_11B];
 }
 
 static u32 ath9k_hw_mac_to_usec(struct ath_hal *ah, u32 clks)
@@ -5228,7 +5239,7 @@ static u32 ath9k_hw_mac_clks(struct ath_hal *ah, u32 usecs)
 		return usecs * CLOCK_RATE[ath9k_hw_chan2wmode(ah,
 			ah->ah_curchan)];
 	else
-		return usecs * CLOCK_RATE[WIRELESS_MODE_11b];
+		return usecs * CLOCK_RATE[ATH9K_MODE_11B];
 }
 
 static u32 ath9k_hw_mac_to_clks(struct ath_hal *ah, u32 usecs)
@@ -5920,7 +5931,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
 			    AR_GPIO_JTAG_DISABLE);
 
-		if (ah->ah_caps.wireless_modes & ATH9K_MODE_SEL_11A) {
+		if (test_bit(ATH9K_MODE_11A, ah->ah_caps.wireless_modes)) {
 			if (IS_CHAN_5GHZ(chan))
 				ath9k_hw_set_gpio(ah, 9, 0);
 			else
@@ -8234,23 +8245,23 @@ const struct ath9k_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
 {
 	struct ath9k_rate_table *rt;
 	switch (mode) {
-	case ATH9K_MODE_SEL_11A:
+	case ATH9K_MODE_11A:
 		rt = &ar5416_11a_table;
 		break;
-	case ATH9K_MODE_SEL_11B:
+	case ATH9K_MODE_11B:
 		rt = &ar5416_11b_table;
 		break;
-	case ATH9K_MODE_SEL_11G:
+	case ATH9K_MODE_11G:
 		rt = &ar5416_11g_table;
 		break;
-	case ATH9K_MODE_SEL_11NG_HT20:
-	case ATH9K_MODE_SEL_11NG_HT40PLUS:
-	case ATH9K_MODE_SEL_11NG_HT40MINUS:
+	case ATH9K_MODE_11NG_HT20:
+	case ATH9K_MODE_11NG_HT40PLUS:
+	case ATH9K_MODE_11NG_HT40MINUS:
 		rt = &ar5416_11ng_table;
 		break;
-	case ATH9K_MODE_SEL_11NA_HT20:
-	case ATH9K_MODE_SEL_11NA_HT40PLUS:
-	case ATH9K_MODE_SEL_11NA_HT40MINUS:
+	case ATH9K_MODE_11NA_HT20:
+	case ATH9K_MODE_11NA_HT40PLUS:
+	case ATH9K_MODE_11NA_HT40MINUS:
 		rt = &ar5416_11na_table;
 		break;
 	default:
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 4cf0d26..2888778 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -507,7 +507,13 @@ static int ath9k_config(struct ieee80211_hw *hw,
 	}
 
 	sc->sc_ah->ah_channels[pos].chanmode =
-		(curchan->band == IEEE80211_BAND_2GHZ) ? CHANNEL_G : CHANNEL_A;
+		(curchan->band == IEEE80211_BAND_2GHZ) ?
+		CHANNEL_G : CHANNEL_A;
+
+	if (sc->sc_curaid && hw->conf.ht_conf.ht_supported)
+		sc->sc_ah->ah_channels[pos].chanmode =
+			ath_get_extchanmode(sc, curchan);
+
 	sc->sc_config.txpowlimit = 2 * conf->power_level;
 
 	/* set h/w channel */
@@ -1145,75 +1151,6 @@ enum ath9k_ht_macmode ath_cwm_macmode(struct ath_softc *sc)
 	return sc->sc_ht_info.tx_chan_width;
 }
 
-void ath_setup_rate(struct ath_softc *sc,
-		    enum wireless_mode wMode,
-		    enum RATE_TYPE type,
-		    const struct ath9k_rate_table *rt)
-{
-	int i, maxrates, a = 0, b = 0;
-	struct ieee80211_supported_band *band_2ghz;
-	struct ieee80211_supported_band *band_5ghz;
-	struct ieee80211_rate *rates_2ghz;
-	struct ieee80211_rate *rates_5ghz;
-
-	if ((wMode >= WIRELESS_MODE_MAX) || (type != NORMAL_RATE))
-		return;
-
-	band_2ghz = &sc->sbands[IEEE80211_BAND_2GHZ];
-	band_5ghz = &sc->sbands[IEEE80211_BAND_5GHZ];
-	rates_2ghz = sc->rates[IEEE80211_BAND_2GHZ];
-	rates_5ghz = sc->rates[IEEE80211_BAND_5GHZ];
-
-	if (rt->rateCount > ATH_RATE_MAX)
-		maxrates = ATH_RATE_MAX;
-	else
-		maxrates = rt->rateCount;
-
-	if ((band_2ghz->n_bitrates != 0) && (band_5ghz->n_bitrates != 0)) {
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"%s: Rates already setup\n", __func__);
-		return;
-	}
-
-	for (i = 0; i < maxrates; i++) {
-		switch (wMode) {
-		case WIRELESS_MODE_11b:
-		case WIRELESS_MODE_11g:
-			rates_2ghz[a].bitrate = rt->info[i].rateKbps / 100;
-			rates_2ghz[a].hw_value = rt->info[i].rateCode;
-			a++;
-			band_2ghz->n_bitrates = a;
-			break;
-		case WIRELESS_MODE_11a:
-			rates_5ghz[b].bitrate = rt->info[i].rateKbps / 100;
-			rates_5ghz[b].hw_value = rt->info[i].rateCode;
-			b++;
-			band_5ghz->n_bitrates = b;
-			break;
-		default:
-			break;
-		}
-	}
-
-	if (band_2ghz->n_bitrates) {
-		for (i = 0; i < band_2ghz->n_bitrates; i++) {
-			DPRINTF(sc, ATH_DBG_CONFIG,
-				"%s: 2GHz Rate: %2dMbps, ratecode: %2d\n",
-				__func__,
-				rates_2ghz[i].bitrate / 10,
-				rates_2ghz[i].hw_value);
-		}
-	} else if (band_5ghz->n_bitrates) {
-		for (i = 0; i < band_5ghz->n_bitrates; i++) {
-			DPRINTF(sc, ATH_DBG_CONFIG,
-				"%s: 5Ghz Rate: %2dMbps, ratecode: %2d\n",
-				__func__,
-				rates_5ghz[i].bitrate / 10,
-				rates_5ghz[i].hw_value);
-		}
-	}
-}
-
 static int ath_detach(struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
@@ -1275,7 +1212,7 @@ static int ath_attach(u16 devid,
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 		&sc->sbands[IEEE80211_BAND_2GHZ];
 
-	if (sc->sc_ah->ah_caps.wireless_modes & ATH9K_MODE_SEL_11A) {
+	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes)) {
 		sc->sbands[IEEE80211_BAND_5GHZ].channels =
 			sc->channels[IEEE80211_BAND_5GHZ];
 		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index d313200..73c460a 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -484,37 +484,37 @@ static void ar5416_attach_ratetables(struct ath_rate_softc *sc)
 	/*
 	 * Attach rate tables.
 	 */
-	sc->hw_rate_table[WIRELESS_MODE_11b] = &ar5416_11b_ratetable;
-	sc->hw_rate_table[WIRELESS_MODE_11a] = &ar5416_11a_ratetable;
-	sc->hw_rate_table[WIRELESS_MODE_11g] = &ar5416_11g_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11B] = &ar5416_11b_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11A] = &ar5416_11a_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11G] = &ar5416_11g_ratetable;
 
-	sc->hw_rate_table[WIRELESS_MODE_11NA_HT20] = &ar5416_11na_ratetable;
-	sc->hw_rate_table[WIRELESS_MODE_11NG_HT20] = &ar5416_11ng_ratetable;
-	sc->hw_rate_table[WIRELESS_MODE_11NA_HT40PLUS] =
+	sc->hw_rate_table[ATH9K_MODE_11NA_HT20] = &ar5416_11na_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11NG_HT20] = &ar5416_11ng_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11NA_HT40PLUS] =
 		&ar5416_11na_ratetable;
-	sc->hw_rate_table[WIRELESS_MODE_11NA_HT40MINUS] =
+	sc->hw_rate_table[ATH9K_MODE_11NA_HT40MINUS] =
 		&ar5416_11na_ratetable;
-	sc->hw_rate_table[WIRELESS_MODE_11NG_HT40PLUS] =
+	sc->hw_rate_table[ATH9K_MODE_11NG_HT40PLUS] =
 		&ar5416_11ng_ratetable;
-	sc->hw_rate_table[WIRELESS_MODE_11NG_HT40MINUS] =
+	sc->hw_rate_table[ATH9K_MODE_11NG_HT40MINUS] =
 		&ar5416_11ng_ratetable;
 }
 
 static void ar5416_setquarter_ratetable(struct ath_rate_softc *sc)
 {
-	sc->hw_rate_table[WIRELESS_MODE_11a] = &ar5416_11a_ratetable_Quarter;
+	sc->hw_rate_table[ATH9K_MODE_11A] = &ar5416_11a_ratetable_Quarter;
 	return;
 }
 
 static void ar5416_sethalf_ratetable(struct ath_rate_softc *sc)
 {
-	sc->hw_rate_table[WIRELESS_MODE_11a] = &ar5416_11a_ratetable_Half;
+	sc->hw_rate_table[ATH9K_MODE_11A] = &ar5416_11a_ratetable_Half;
 	return;
 }
 
 static void ar5416_setfull_ratetable(struct ath_rate_softc *sc)
 {
-	sc->hw_rate_table[WIRELESS_MODE_11a]   = &ar5416_11a_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11A] = &ar5416_11a_ratetable;
 	return;
 }
 
@@ -1123,9 +1123,9 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	 * So, set fourth rate in series to be same as third one for
 	 * above conditions.
 	 */
-	if ((sc->sc_curmode == WIRELESS_MODE_11NG_HT20) ||
-			(sc->sc_curmode == WIRELESS_MODE_11NG_HT40PLUS) ||
-			(sc->sc_curmode == WIRELESS_MODE_11NG_HT40MINUS)) {
+	if ((sc->sc_curmode == ATH9K_MODE_11NG_HT20) ||
+			(sc->sc_curmode == ATH9K_MODE_11NG_HT40PLUS) ||
+			(sc->sc_curmode == ATH9K_MODE_11NG_HT40MINUS)) {
 		u8  dot11rate = rate_table->info[rix].dot11rate;
 		u8 phy = rate_table->info[rix].phy;
 		if (i == 4 &&
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 8f6c28e..71aef9c 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -247,7 +247,7 @@ struct ath_rateset {
 /* per-device state */
 struct ath_rate_softc {
 	/* phy tables that contain rate control data */
-	const void *hw_rate_table[WIRELESS_MODE_MAX];
+	const void *hw_rate_table[ATH9K_MODE_MAX];
 	int fixedrix;	/* -1 or index of fixed rate */
 };
 
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 05e10c4..62e2888 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -131,46 +131,45 @@ static bool ath9k_regd_is_ccode_valid(struct ath_hal *ah,
 	return false;
 }
 
-static u32
+static void
 ath9k_regd_get_wmodes_nreg(struct ath_hal *ah,
 			   struct country_code_to_enum_rd *country,
-			   struct regDomain *rd5GHz)
+			   struct regDomain *rd5GHz,
+			   unsigned long *modes_allowed)
 {
-	u32 modesAvail;
+	bitmap_copy(modes_allowed, ah->ah_caps.wireless_modes, ATH9K_MODE_MAX);
 
-	modesAvail = ah->ah_caps.wireless_modes;
+	if (test_bit(ATH9K_MODE_11G, ah->ah_caps.wireless_modes) &&
+	    (!country->allow11g))
+		clear_bit(ATH9K_MODE_11G, modes_allowed);
 
-	if ((modesAvail & ATH9K_MODE_SEL_11G) && (!country->allow11g))
-		modesAvail &= ~ATH9K_MODE_SEL_11G;
-	if ((modesAvail & ATH9K_MODE_SEL_11A) &&
+	if (test_bit(ATH9K_MODE_11A, ah->ah_caps.wireless_modes) &&
 	    (ath9k_regd_is_chan_bm_zero(rd5GHz->chan11a)))
-		modesAvail &= ~ATH9K_MODE_SEL_11A;
+		clear_bit(ATH9K_MODE_11A, modes_allowed);
 
-	if ((modesAvail & ATH9K_MODE_SEL_11NG_HT20)
+	if (test_bit(ATH9K_MODE_11NG_HT20, ah->ah_caps.wireless_modes)
 	    && (!country->allow11ng20))
-		modesAvail &= ~ATH9K_MODE_SEL_11NG_HT20;
+		clear_bit(ATH9K_MODE_11NG_HT20, modes_allowed);
 
-	if ((modesAvail & ATH9K_MODE_SEL_11NA_HT20)
+	if (test_bit(ATH9K_MODE_11NA_HT20, ah->ah_caps.wireless_modes)
 	    && (!country->allow11na20))
-		modesAvail &= ~ATH9K_MODE_SEL_11NA_HT20;
+		clear_bit(ATH9K_MODE_11NA_HT20, modes_allowed);
 
-	if ((modesAvail & ATH9K_MODE_SEL_11NG_HT40PLUS) &&
+	if (test_bit(ATH9K_MODE_11NG_HT40PLUS, ah->ah_caps.wireless_modes) &&
 	    (!country->allow11ng40))
-		modesAvail &= ~ATH9K_MODE_SEL_11NG_HT40PLUS;
+		clear_bit(ATH9K_MODE_11NG_HT40PLUS, modes_allowed);
 
-	if ((modesAvail & ATH9K_MODE_SEL_11NG_HT40MINUS) &&
+	if (test_bit(ATH9K_MODE_11NG_HT40MINUS, ah->ah_caps.wireless_modes) &&
 	    (!country->allow11ng40))
-		modesAvail &= ~ATH9K_MODE_SEL_11NG_HT40MINUS;
+		clear_bit(ATH9K_MODE_11NG_HT40MINUS, modes_allowed);
 
-	if ((modesAvail & ATH9K_MODE_SEL_11NA_HT40PLUS) &&
+	if (test_bit(ATH9K_MODE_11NA_HT40PLUS, ah->ah_caps.wireless_modes) &&
 	    (!country->allow11na40))
-		modesAvail &= ~ATH9K_MODE_SEL_11NA_HT40PLUS;
+		clear_bit(ATH9K_MODE_11NA_HT40PLUS, modes_allowed);
 
-	if ((modesAvail & ATH9K_MODE_SEL_11NA_HT40MINUS) &&
+	if (test_bit(ATH9K_MODE_11NA_HT40MINUS, ah->ah_caps.wireless_modes) &&
 	    (!country->allow11na40))
-		modesAvail &= ~ATH9K_MODE_SEL_11NA_HT40MINUS;
-
-	return modesAvail;
+		clear_bit(ATH9K_MODE_11NA_HT40MINUS, modes_allowed);
 }
 
 bool ath9k_regd_is_public_safety_sku(struct ath_hal *ah)
@@ -545,10 +544,10 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 		}
 	}
 
-	if (cm->mode & (ATH9K_MODE_SEL_11A |
-			ATH9K_MODE_SEL_11NA_HT20 |
-			ATH9K_MODE_SEL_11NA_HT40PLUS |
-			ATH9K_MODE_SEL_11NA_HT40MINUS)) {
+	if ((cm->mode == ATH9K_MODE_11A) ||
+	    (cm->mode == ATH9K_MODE_11NA_HT20) ||
+	    (cm->mode == ATH9K_MODE_11NA_HT40PLUS) ||
+	    (cm->mode == ATH9K_MODE_11NA_HT40MINUS)) {
 		if (rd->flags & (ADHOC_NO_11A | DISALLOW_ADHOC_11A))
 			privFlags |= CHANNEL_DISALLOW_ADHOC;
 	}
@@ -618,10 +617,9 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 			 u32 maxchans,
 			 u32 *nchans, u8 *regclassids,
 			 u32 maxregids, u32 *nregids, u16 cc,
-			 u32 modeSelect, bool enableOutdoor,
+			 bool enableOutdoor,
 			 bool enableExtendedChannels)
 {
-	u32 modesAvail;
 	u16 maxChan = 7000;
 	struct country_code_to_enum_rd *country = NULL;
 	struct regDomain rd5GHz, rd2GHz;
@@ -631,11 +629,13 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 	u8 ctl;
 	int regdmn;
 	u16 chanSep;
+	unsigned long *modes_avail;
+	DECLARE_BITMAP(modes_allowed, ATH9K_MODE_MAX);
 
-	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "%s: cc %u mode 0x%x%s%s\n",
-		 __func__, cc, modeSelect,
-		 enableOutdoor ? " Enable outdoor" : " ",
-		 enableExtendedChannels ? " Enable ecm" : "");
+	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "%s: cc %u %s %s\n",
+		 __func__, cc,
+		 enableOutdoor ? "Enable outdoor" : "",
+		 enableExtendedChannels ? "Enable ecm" : "");
 
 	if (!ath9k_regd_is_ccode_valid(ah, cc)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
@@ -726,9 +726,11 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 	}
 
 	if (country == NULL) {
-		modesAvail = ah->ah_caps.wireless_modes;
+		modes_avail = ah->ah_caps.wireless_modes;
 	} else {
-		modesAvail = ath9k_regd_get_wmodes_nreg(ah, country, &rd5GHz);
+		ath9k_regd_get_wmodes_nreg(ah, country, &rd5GHz, modes_allowed);
+		modes_avail = modes_allowed;
+
 		if (!enableOutdoor)
 			maxChan = country->outdoorChanStart;
 	}
@@ -745,19 +747,12 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 		struct RegDmnFreqBand *fband = NULL, *freqs;
 		int8_t low_adj = 0, hi_adj = 0;
 
-		if ((cm->mode & modeSelect) == 0) {
+		if (!test_bit(cm->mode, modes_avail)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				"%s: skip mode 0x%x flags 0x%x\n",
+				"%s: !avail mode %d flags 0x%x\n",
 				__func__, cm->mode, cm->flags);
 			continue;
 		}
-		if ((cm->mode & modesAvail) == 0) {
-			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				"%s: !avail mode 0x%x (0x%x) flags 0x%x\n",
-				__func__, modesAvail, cm->mode,
-				cm->flags);
-			continue;
-		}
 		if (!ath9k_get_channel_edges(ah, cm->flags, &c_lo, &c_hi)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 				"%s: channels 0x%x not supported "
@@ -767,25 +762,25 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 		}
 
 		switch (cm->mode) {
-		case ATH9K_MODE_SEL_11A:
-		case ATH9K_MODE_SEL_11NA_HT20:
-		case ATH9K_MODE_SEL_11NA_HT40PLUS:
-		case ATH9K_MODE_SEL_11NA_HT40MINUS:
+		case ATH9K_MODE_11A:
+		case ATH9K_MODE_11NA_HT20:
+		case ATH9K_MODE_11NA_HT40PLUS:
+		case ATH9K_MODE_11NA_HT40MINUS:
 			rd = &rd5GHz;
 			channelBM = rd->chan11a;
 			freqs = &regDmn5GhzFreq[0];
 			ctl = rd->conformanceTestLimit;
 			break;
-		case ATH9K_MODE_SEL_11B:
+		case ATH9K_MODE_11B:
 			rd = &rd2GHz;
 			channelBM = rd->chan11b;
 			freqs = &regDmn2GhzFreq[0];
 			ctl = rd->conformanceTestLimit | CTL_11B;
 			break;
-		case ATH9K_MODE_SEL_11G:
-		case ATH9K_MODE_SEL_11NG_HT20:
-		case ATH9K_MODE_SEL_11NG_HT40PLUS:
-		case ATH9K_MODE_SEL_11NG_HT40MINUS:
+		case ATH9K_MODE_11G:
+		case ATH9K_MODE_11NG_HT20:
+		case ATH9K_MODE_11NG_HT40PLUS:
+		case ATH9K_MODE_11NG_HT40MINUS:
 			rd = &rd2GHz;
 			channelBM = rd->chan11g;
 			freqs = &regDmn2Ghz11gFreq[0];
@@ -801,13 +796,13 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 		if (ath9k_regd_is_chan_bm_zero(channelBM))
 			continue;
 
-		if ((cm->mode == ATH9K_MODE_SEL_11NA_HT40PLUS) ||
-		    (cm->mode == ATH9K_MODE_SEL_11NG_HT40PLUS)) {
+		if ((cm->mode == ATH9K_MODE_11NA_HT40PLUS) ||
+		    (cm->mode == ATH9K_MODE_11NG_HT40PLUS)) {
 			hi_adj = -20;
 		}
 
-		if ((cm->mode == ATH9K_MODE_SEL_11NA_HT40MINUS) ||
-		    (cm->mode == ATH9K_MODE_SEL_11NG_HT40MINUS)) {
+		if ((cm->mode == ATH9K_MODE_11NA_HT40MINUS) ||
+		    (cm->mode == ATH9K_MODE_11NG_HT40MINUS)) {
 			low_adj = 20;
 		}
 
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index ae77496..0ecd344 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -117,11 +117,11 @@
 #define isUNII1OddChan(ch) \
 	((ch == 5170) || (ch == 5190) || (ch == 5210) || (ch == 5230))
 
-#define IS_HT40_MODE(_mode)      \
-	(((_mode == ATH9K_MODE_SEL_11NA_HT40PLUS  || \
-	_mode == ATH9K_MODE_SEL_11NG_HT40PLUS    || \
-	_mode == ATH9K_MODE_SEL_11NA_HT40MINUS   || \
-	_mode == ATH9K_MODE_SEL_11NG_HT40MINUS) ? true : false))
+#define IS_HT40_MODE(_mode)					\
+	(((_mode == ATH9K_MODE_11NA_HT40PLUS  ||		\
+	   _mode == ATH9K_MODE_11NG_HT40PLUS    ||		\
+	   _mode == ATH9K_MODE_11NA_HT40MINUS   ||		\
+	   _mode == ATH9K_MODE_11NG_HT40MINUS) ? true : false))
 
 #define CHAN_FLAGS      (CHANNEL_ALL|CHANNEL_HALF|CHANNEL_QUARTER)
 
diff --git a/drivers/net/wireless/ath9k/regd_common.h b/drivers/net/wireless/ath9k/regd_common.h
index b3bfae4..9112c03 100644
--- a/drivers/net/wireless/ath9k/regd_common.h
+++ b/drivers/net/wireless/ath9k/regd_common.h
@@ -1893,15 +1893,15 @@ static struct regDomain regDomains[] = {
 };
 
 static const struct cmode modes[] = {
-	{ATH9K_MODE_SEL_11A, CHANNEL_A},
-	{ATH9K_MODE_SEL_11B, CHANNEL_B},
-	{ATH9K_MODE_SEL_11G, CHANNEL_G},
-	{ATH9K_MODE_SEL_11NG_HT20, CHANNEL_G_HT20},
-	{ATH9K_MODE_SEL_11NG_HT40PLUS, CHANNEL_G_HT40PLUS},
-	{ATH9K_MODE_SEL_11NG_HT40MINUS, CHANNEL_G_HT40MINUS},
-	{ATH9K_MODE_SEL_11NA_HT20, CHANNEL_A_HT20},
-	{ATH9K_MODE_SEL_11NA_HT40PLUS, CHANNEL_A_HT40PLUS},
-	{ATH9K_MODE_SEL_11NA_HT40MINUS, CHANNEL_A_HT40MINUS},
+	{ATH9K_MODE_11A, CHANNEL_A},
+	{ATH9K_MODE_11B, CHANNEL_B},
+	{ATH9K_MODE_11G, CHANNEL_G},
+	{ATH9K_MODE_11NG_HT20, CHANNEL_G_HT20},
+	{ATH9K_MODE_11NG_HT40PLUS, CHANNEL_G_HT40PLUS},
+	{ATH9K_MODE_11NG_HT40MINUS, CHANNEL_G_HT40MINUS},
+	{ATH9K_MODE_11NA_HT20, CHANNEL_A_HT20},
+	{ATH9K_MODE_11NA_HT40PLUS, CHANNEL_A_HT40PLUS},
+	{ATH9K_MODE_11NA_HT40MINUS, CHANNEL_A_HT40MINUS},
 };
 
 static struct japan_bandcheck j_bandcheck[] = {
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index debd7f4..157f830 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -408,7 +408,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 		if (txctl->min_rate)
 			rcs[0].rix = ath_rate_findrateix(sc, txctl->min_rate);
 		else
-			rcs[0].rix = sc->sc_minrateix;
+			rcs[0].rix = 0;
 		rcs[0].tries = ATH_MGT_TXMAXTRY;
 	}
 	rix = rcs[0].rix;
-- 
1.5.6.5

