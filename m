Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:51869 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbYBDCvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 21:51:54 -0500
Date: Sun, 3 Feb 2008 21:51:49 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, bruno@thinktube.com,
	johannes@sipsolutions.net
Subject: [PATCH 2/7] ath5k: Cleanup after API changes
Message-ID: <314a7c931682fd438157fd5d1c4414b690105edd.1202092325.git.mcgrof@winlab.rutgers.edu> (sfid-20080204_025157_182333_8FA789AD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <67abed819770e9d38c69f0e015e153427b3522be.1202092325.git.mcgrof@winlab.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup after API changes patch (checkpatch.pl stuff) and on
ath5k_hw_channel() make use of the existing ath5k_channel_ok()
instead of re-implementing the checks again. This was necessary
to make the code cleaner and fit the 80-chars wide limit so
sending it within the same patch.

Finally make a note that we *may* eventually move cap_range stuff
to struct wiphy (band frequency range capabilities). This
information can later be exported to userspace, for example,
and giving it access to mac80211 and drivers in general can come
in handy.

Changes to initvals.c, phy.c
Changes-licensed-under: ISC

Changes to ath5k.h, base.c
Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/ath5k/ath5k.h    |    8 ++-
 drivers/net/wireless/ath5k/base.c     |  129 +++++++++++++++++++--------------
 drivers/net/wireless/ath5k/initvals.c |    6 +-
 drivers/net/wireless/ath5k/phy.c      |   35 +++++-----
 4 files changed, 103 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 3b03600..aa250bc 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -263,8 +263,10 @@ enum ath5k_driver_mode {
 /* adding this flag to rate_code enables short preamble, see ar5212_reg.h */
 #define AR5K_SET_SHORT_PREAMBLE 0x04
 
-#define HAS_SHPREAMBLE(_ix) (rt->rates[_ix].modulation == IEEE80211_RATE_SHORT_PREAMBLE)
-#define SHPREAMBLE_FLAG(_ix) (HAS_SHPREAMBLE(_ix) ? AR5K_SET_SHORT_PREAMBLE : 0)
+#define HAS_SHPREAMBLE(_ix) \
+	(rt->rates[_ix].modulation == IEEE80211_RATE_SHORT_PREAMBLE)
+#define SHPREAMBLE_FLAG(_ix) \
+	(HAS_SHPREAMBLE(_ix) ? AR5K_SET_SHORT_PREAMBLE : 0)
 
 /****************\
   TX DEFINITIONS
@@ -892,6 +894,8 @@ enum ath5k_capability_type {
 	AR5K_CAP_RFSILENT		= 20,	/* Supports RFsilent */
 };
 
+
+/* XXX: we *may* move cap_range stuff to struct wiphy */
 struct ath5k_capabilities {
 	/*
 	 * Supported PHY modes
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index d94bace..d08fd65 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -80,7 +80,7 @@ MODULE_AUTHOR("Nick Kossifidis");
 MODULE_DESCRIPTION("Support for 5xxx series of Atheros 802.11 wireless LAN cards.");
 MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION("0.1.1 (EXPERIMENTAL)");
+MODULE_VERSION("0.5.0 (EXPERIMENTAL)");
 
 
 /* Known PCI ids */
@@ -513,35 +513,46 @@ ath5k_pci_probe(struct pci_dev *pdev,
 					sc->ah->ah_mac_srev,
 					sc->ah->ah_phy_revision);
 
-	if(!sc->ah->ah_single_chip){
+	if (!sc->ah->ah_single_chip) {
 		/* Single chip radio (!RF5111) */
-		if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision) {
+		if (sc->ah->ah_radio_5ghz_revision &&
+			!sc->ah->ah_radio_2ghz_revision) {
 			/* No 5GHz support -> report 2GHz radio */
-			if(!test_bit(AR5K_MODE_11A, sc->ah->ah_capabilities.cap_mode)){
+			if (!test_bit(AR5K_MODE_11A,
+				sc->ah->ah_capabilities.cap_mode)) {
 				ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
-					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
-							sc->ah->ah_radio_5ghz_revision);
-			/* No 2GHz support (5110 and some 5Ghz only cards) -> report 5Ghz radio */
-			} else if(!test_bit(AR5K_MODE_11B, sc->ah->ah_capabilities.cap_mode)){
+					ath5k_chip_name(AR5K_VERSION_RAD,
+						sc->ah->ah_radio_5ghz_revision),
+						sc->ah->ah_radio_5ghz_revision);
+			/* No 2GHz support (5110 and some
+			 * 5Ghz only cards) -> report 5Ghz radio */
+			} else if (!test_bit(AR5K_MODE_11B,
+				sc->ah->ah_capabilities.cap_mode)) {
 				ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
-					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
-							sc->ah->ah_radio_5ghz_revision);
+					ath5k_chip_name(AR5K_VERSION_RAD,
+						sc->ah->ah_radio_5ghz_revision),
+						sc->ah->ah_radio_5ghz_revision);
 			/* Multiband radio */
 			} else {
 				ATH5K_INFO(sc, "RF%s multiband radio found"
 					" (0x%x)\n",
-					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
-							sc->ah->ah_radio_5ghz_revision);
+					ath5k_chip_name(AR5K_VERSION_RAD,
+						sc->ah->ah_radio_5ghz_revision),
+						sc->ah->ah_radio_5ghz_revision);
 			}
 		}
-		/* Multi chip radio (RF5111 - RF2111) -> report both 2GHz/5GHz radios */
-		else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
+		/* Multi chip radio (RF5111 - RF2111) ->
+		 * report both 2GHz/5GHz radios */
+		else if (sc->ah->ah_radio_5ghz_revision &&
+				sc->ah->ah_radio_2ghz_revision){
 			ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
-				ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
-						sc->ah->ah_radio_5ghz_revision);
+				ath5k_chip_name(AR5K_VERSION_RAD,
+					sc->ah->ah_radio_5ghz_revision),
+					sc->ah->ah_radio_5ghz_revision);
 			ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
-				ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
-						sc->ah->ah_radio_2ghz_revision);
+				ath5k_chip_name(AR5K_VERSION_RAD,
+					sc->ah->ah_radio_2ghz_revision),
+					sc->ah->ah_radio_2ghz_revision);
 		}
 	}
 
@@ -888,14 +899,17 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 
 		/* Write channel info and increment counter */
 		channels[count].center_freq = freq;
-
-		if((mode == AR5K_MODE_11A) ||
-		(mode == AR5K_MODE_11G)){
-			channels[count].hw_value = chfreq|CHANNEL_OFDM;
-		} else if((mode == AR5K_MODE_11A_TURBO) ||
-		(mode == AR5K_MODE_11G_TURBO)){
-			channels[count].hw_value = chfreq|CHANNEL_OFDM|CHANNEL_TURBO;
-		}if(mode == AR5K_MODE_11B) {
+		switch (mode) {
+		case AR5K_MODE_11A:
+		case AR5K_MODE_11G:
+			channels[count].hw_value = chfreq | CHANNEL_OFDM;
+			break;
+		case AR5K_MODE_11A_TURBO:
+		case AR5K_MODE_11G_TURBO:
+			channels[count].hw_value = chfreq |
+				CHANNEL_OFDM | CHANNEL_TURBO;
+			break;
+		case AR5K_MODE_11B:
 			channels[count].hw_value = CHANNEL_B;
 		}
 
@@ -923,15 +937,16 @@ ath5k_getchannels(struct ieee80211_hw *hw)
 	count_r = count_c = 0;
 
 	/* 2GHz band */
-	if(!test_bit(AR5K_MODE_11G, sc->ah->ah_capabilities.cap_mode)){
+	if (!test_bit(AR5K_MODE_11G, sc->ah->ah_capabilities.cap_mode)) {
 		mode2g = AR5K_MODE_11B;
-		if(!test_bit(AR5K_MODE_11B, sc->ah->ah_capabilities.cap_mode)){
+		if (!test_bit(AR5K_MODE_11B,
+			sc->ah->ah_capabilities.cap_mode))
 			mode2g = -1;
-		}
 	}
 
-	if(mode2g > 0){
-		struct ieee80211_supported_band *sband = &sbands[IEEE80211_BAND_2GHZ];
+	if (mode2g > 0) {
+		struct ieee80211_supported_band *sband =
+			&sbands[IEEE80211_BAND_2GHZ];
 
 		sband->bitrates = sc->rates;
 		sband->channels = sc->channels;
@@ -942,7 +957,7 @@ ath5k_getchannels(struct ieee80211_hw *hw)
 
 		hw_rates = ath5k_hw_get_rate_table(ah, mode2g);
 		sband->n_bitrates = ath5k_copy_rates(sband->bitrates,
-					hw_rates,max_r);
+					hw_rates, max_r);
 
 		count_c = sband->n_channels;
 		count_r = sband->n_bitrates;
@@ -956,8 +971,9 @@ ath5k_getchannels(struct ieee80211_hw *hw)
 
 	/* 5GHz band */
 
-	if(test_bit(AR5K_MODE_11A, sc->ah->ah_capabilities.cap_mode)){
-		struct ieee80211_supported_band *sband = &sbands[IEEE80211_BAND_5GHZ];
+	if (test_bit(AR5K_MODE_11A, sc->ah->ah_capabilities.cap_mode)) {
+		struct ieee80211_supported_band *sband =
+			&sbands[IEEE80211_BAND_5GHZ];
 
 		sband->bitrates = &sc->rates[count_r];
 		sband->channels = &sc->channels[count_c];
@@ -968,7 +984,7 @@ ath5k_getchannels(struct ieee80211_hw *hw)
 
 		hw_rates = ath5k_hw_get_rate_table(ah, AR5K_MODE_11A);
 		sband->n_bitrates = ath5k_copy_rates(sband->bitrates,
-					hw_rates,max_r);
+					hw_rates, max_r);
 
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
 	}
@@ -1106,7 +1122,7 @@ ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
 
 	sc->curmode = mode;
 
-	if(mode == AR5K_MODE_11A){
+	if (mode == AR5K_MODE_11A) {
 		sc->curband = &sc->sbands[IEEE80211_BAND_5GHZ];
 	} else {
 		sc->curband = &sc->sbands[IEEE80211_BAND_2GHZ];
@@ -1158,43 +1174,43 @@ ath5k_mode_setup(struct ath5k_softc *sc)
  * When hw returns eg. 27 it points to the last 802.11g rate (54Mbits) etc
  */
 static void
-ath5k_set_total_hw_rates(struct ath5k_softc *sc){
+ath5k_set_total_hw_rates(struct ath5k_softc *sc) {
 
 	struct ath5k_hw *ah = sc->ah;
 
-	if(test_bit(AR5K_MODE_11A, ah->ah_modes))
+	if (test_bit(AR5K_MODE_11A, ah->ah_modes))
 		sc->a_rates = 8;
 
-	if(test_bit(AR5K_MODE_11B, ah->ah_modes))
+	if (test_bit(AR5K_MODE_11B, ah->ah_modes))
 		sc->b_rates = 4;
 
-	if(test_bit(AR5K_MODE_11G, ah->ah_modes))
+	if (test_bit(AR5K_MODE_11G, ah->ah_modes))
 		sc->g_rates = 12;
-	
+
 	/* XXX: Need to see what what happens when
 		xr disable bits in eeprom are set */
-	if(ah->ah_version >= AR5K_AR5212)
+	if (ah->ah_version >= AR5K_AR5212)
 		sc->xr_rates = 4;
 
 }
 
 static inline int
-ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix){
+ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix) {
 
 	int mac80211_rix;
 
-	if(sc->curband->band == IEEE80211_BAND_2GHZ){
+	if (sc->curband->band == IEEE80211_BAND_2GHZ) {
 		/* We setup a g ratetable for both b/g modes */
-		mac80211_rix = hw_rix - sc->b_rates - sc->a_rates - sc->xr_rates;
+		mac80211_rix =
+			hw_rix - sc->b_rates - sc->a_rates - sc->xr_rates;
 	} else {
 		mac80211_rix = hw_rix - sc->xr_rates;
 	}
 
 	/* Something went wrong, fallback to basic rate for this band */
-	if((mac80211_rix >= sc->curband->n_bitrates) || 
-	(mac80211_rix <= 0 )){
+	if ((mac80211_rix >= sc->curband->n_bitrates) ||
+		(mac80211_rix <= 0))
 		mac80211_rix = 1;
-	}
 
 	return mac80211_rix;
 }
@@ -1303,7 +1319,8 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
-		(sc->power_level * 2), ctl->tx_rate->hw_value, ctl->retry_limit, keyidx, 0, flags, 0, 0);
+		(sc->power_level * 2), ctl->tx_rate->hw_value,
+		ctl->retry_limit, keyidx, 0, flags, 0, 0);
 	if (ret)
 		goto err_unmap;
 
@@ -1844,7 +1861,8 @@ accept:
 		rxs.signal = ds->ds_rxstat.rs_rssi * 100 / 64;
 
 		rxs.antenna = ds->ds_rxstat.rs_antenna;
-		rxs.rate_idx = ath5k_hw_to_driver_rix(sc,ds->ds_rxstat.rs_rate);
+		rxs.rate_idx = ath5k_hw_to_driver_rix(sc,
+			ds->ds_rxstat.rs_rate);
 		rxs.flag |= ath5k_rx_decrypted(sc, ds, skb);
 
 		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
@@ -1991,8 +2009,9 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	ds->ds_data = bf->skbaddr;
 	ret = ah->ah_setup_tx_desc(ah, ds, skb->len + FCS_LEN,
 			ieee80211_get_hdrlen_from_skb(skb),
-			AR5K_PKT_TYPE_BEACON, (sc->power_level * 2), ctl->tx_rate->hw_value, 1,
-			AR5K_TXKEYIX_INVALID, antenna, flags, 0, 0);
+			AR5K_PKT_TYPE_BEACON, (sc->power_level * 2),
+			ctl->tx_rate->hw_value, 1, AR5K_TXKEYIX_INVALID,
+			antenna, flags, 0, 0);
 	if (ret)
 		goto err_unmap;
 
@@ -2480,7 +2499,8 @@ ath5k_calibrate(unsigned long data)
 	struct ath5k_hw *ah = sc->ah;
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_CALIBRATE, "channel %u/%x\n",
-		ieee80211_frequency_to_channel(sc->curchan->center_freq), sc->curchan->hw_value);
+		ieee80211_frequency_to_channel(sc->curchan->center_freq),
+		sc->curchan->hw_value);
 
 	if (ath5k_hw_get_rf_gain(ah) == AR5K_RFGAIN_NEED_CHANGE) {
 		/*
@@ -2492,7 +2512,8 @@ ath5k_calibrate(unsigned long data)
 	}
 	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
 		ATH5K_ERR(sc, "calibration of channel %u failed\n",
-				ieee80211_frequency_to_channel(sc->curchan->center_freq));
+			ieee80211_frequency_to_channel(
+				sc->curchan->center_freq));
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
 			msecs_to_jiffies(ath5k_calinterval * 1000)));
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index a255d8b..cfcb1fe 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -1317,8 +1317,10 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 	/* For AR5211 */
 	} else if (ah->ah_version == AR5K_AR5211) {
 
-		if(mode > 2){ /* AR5K_MODE_11B */
-			ATH5K_ERR(ah->ah_sc,"unsupported channel mode: %d\n", mode);
+		/* AR5K_MODE_11B */
+		if (mode > 2) {
+			ATH5K_ERR(ah->ah_sc,
+				"unsupported channel mode: %d\n", mode);
 			return -EINVAL;
 		}
 
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 8b576b3..248c0f5 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1124,7 +1124,7 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 	rf = ah->ah_rf_banks;
 
 	if (ah->ah_radio_5ghz_revision >= AR5K_SREV_RAD_2112A
-		&& !test_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode)){
+		&& !test_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode)) {
 		rf_ini = rfregs_2112a;
 		rf_size = ARRAY_SIZE(rfregs_5112a);
 		if (mode < 2) {
@@ -1445,9 +1445,10 @@ static u32 ath5k_hw_rf5110_chan2athchan(struct ieee80211_channel *channel)
 	 * newer chipsets like the AR5212A who have a completely
 	 * different RF/PHY part.
 	 */
-	athchan = (ath5k_hw_bitswap((ieee80211_frequency_to_channel(channel->center_freq) - 24) / 2, 5) << 1) |
-		(1 << 6) | 0x1;
-
+	athchan = (ath5k_hw_bitswap(
+			(ieee80211_frequency_to_channel(
+				channel->center_freq) - 24) / 2, 5)
+				<< 1) | (1 << 6) | 0x1;
 	return athchan;
 }
 
@@ -1506,7 +1507,8 @@ static int ath5k_hw_rf5111_channel(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	struct ath5k_athchan_2ghz ath5k_channel_2ghz;
-	unsigned int ath5k_channel = ieee80211_frequency_to_channel(channel->center_freq);
+	unsigned int ath5k_channel =
+		ieee80211_frequency_to_channel(channel->center_freq);
 	u32 data0, data1, clock;
 	int ret;
 
@@ -1517,8 +1519,9 @@ static int ath5k_hw_rf5111_channel(struct ath5k_hw *ah,
 
 	if (channel->hw_value & CHANNEL_2GHZ) {
 		/* Map 2GHz channel to 5GHz Atheros channel ID */
-		ret = ath5k_hw_rf5111_chan2athchan(ieee80211_frequency_to_channel(channel->center_freq),
-				&ath5k_channel_2ghz);
+		ret = ath5k_hw_rf5111_chan2athchan(
+			ieee80211_frequency_to_channel(channel->center_freq),
+			&ath5k_channel_2ghz);
 		if (ret)
 			return ret;
 
@@ -1599,19 +1602,17 @@ static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
 int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 {
 	int ret;
-
 	/*
-	 * Check bounds supported by the PHY
-	 * (don't care about regulation restrictions at this point)
-	 */
-	if ((channel->center_freq < ah->ah_capabilities.cap_range.range_2ghz_min ||
-	    channel->center_freq > ah->ah_capabilities.cap_range.range_2ghz_max) &&
-	    (channel->center_freq < ah->ah_capabilities.cap_range.range_5ghz_min ||
-	    channel->center_freq > ah->ah_capabilities.cap_range.range_5ghz_max)) {
+	 * Check bounds supported by the PHY (we don't care about regultory
+	 * restrictions at this point). Note: hw_value already has the band
+	 * (CHANNEL_2GHZ, or CHANNEL_5GHZ) so we inform ath5k_channel_ok()
+	 * of the band by that */
+	if (!ath5k_channel_ok(ah, channel->center_freq, channel->hw_value)) {
 		ATH5K_ERR(ah->ah_sc,
-			"channel out of supported range (%u MHz)\n",
+			"channel frequency (%u MHz) out of supported "
+			"band range\n",
 			channel->center_freq);
-		return -EINVAL;
+			return -EINVAL;
 	}
 
 	/*
-- 
1.5.3.7

