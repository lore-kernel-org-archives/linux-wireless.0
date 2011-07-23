Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60606 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab1GWN3L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 09:29:11 -0400
Subject: [PATCH 2 3/3] ath5k: eliminate CHANNEL_* macros,
 use AR5K_MODE_* in channel->hw_value
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Sat, 23 Jul 2011 09:29:09 -0400
Message-ID: <20110723132909.10739.9568.stgit@mj.roinet.com> (sfid-20110723_152916_214965_C0D9A958)
In-Reply-To: <20110723132856.10739.42301.stgit@mj.roinet.com>
References: <20110723132856.10739.42301.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When checking for the band, use channel->band.

Change ath5k_hw_nic_wakeup() and ath5k_channel_ok() to take
ieee80211_channel.  Change ath5k_hw_radio_revision() to take
ieee80211_band.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |   32 +----------
 drivers/net/wireless/ath/ath5k/attach.c |   10 ++--
 drivers/net/wireless/ath/ath5k/base.c   |   23 ++------
 drivers/net/wireless/ath/ath5k/eeprom.c |    8 +--
 drivers/net/wireless/ath/ath5k/pcu.c    |    4 +
 drivers/net/wireless/ath/ath5k/phy.c    |   87 +++++++++++++++++--------------
 drivers/net/wireless/ath/ath5k/qcu.c    |    2 -
 drivers/net/wireless/ath/ath5k/reset.c  |   70 +++++++++++--------------
 8 files changed, 102 insertions(+), 134 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index a8a7db4..0d413be 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -685,30 +685,6 @@ struct ath5k_gain {
 #define AR5K_SLOT_TIME_20	880
 #define AR5K_SLOT_TIME_MAX	0xffff
 
-/* channel_flags */
-#define	CHANNEL_CW_INT	0x0008	/* Contention Window interference detected */
-#define	CHANNEL_CCK	0x0020	/* CCK channel */
-#define	CHANNEL_OFDM	0x0040	/* OFDM channel */
-#define	CHANNEL_2GHZ	0x0080	/* 2GHz channel. */
-#define	CHANNEL_5GHZ	0x0100	/* 5GHz channel */
-#define	CHANNEL_PASSIVE	0x0200	/* Only passive scan allowed */
-#define	CHANNEL_DYN	0x0400	/* Dynamic CCK-OFDM channel (for g operation) */
-
-#define	CHANNEL_A	(CHANNEL_5GHZ | CHANNEL_OFDM)
-#define	CHANNEL_B	(CHANNEL_2GHZ | CHANNEL_CCK)
-#define	CHANNEL_G	(CHANNEL_2GHZ | CHANNEL_OFDM)
-
-#define	CHANNEL_ALL	(CHANNEL_OFDM | CHANNEL_CCK | \
-			 CHANNEL_2GHZ | CHANNEL_5GHZ)
-
-#define CHANNEL_MODES		CHANNEL_ALL
-
-/*
- * Used internally for ath5k_hw_reset_tx_queue().
- * Also see struct struct ieee80211_channel.
- */
-#define IS_CHAN_B(_c)	((_c->hw_value & CHANNEL_B) != 0)
-
 /*
  * The following structure is used to map 2GHz channels to
  * 5GHz Atheros channels.
@@ -965,7 +941,7 @@ enum ath5k_power_mode {
 struct ath5k_capabilities {
 	/*
 	 * Supported PHY modes
-	 * (ie. CHANNEL_A, CHANNEL_B, ...)
+	 * (ie. AR5K_MODE_11A, AR5K_MODE_11B, ...)
 	 */
 	DECLARE_BITMAP(cap_mode, AR5K_MODE_MAX);
 
@@ -1335,7 +1311,7 @@ void ath5k_unregister_leds(struct ath5k_hw *ah);
 
 
 /* Reset Functions */
-int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial);
+int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel);
 int ath5k_hw_on_hold(struct ath5k_hw *ah);
 int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	   struct ieee80211_channel *channel, bool fast, bool skip_pcu);
@@ -1455,13 +1431,13 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel);
 
 /* PHY functions */
 /* Misc PHY functions */
-u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan);
+u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, enum ieee80211_band band);
 int ath5k_hw_phy_disable(struct ath5k_hw *ah);
 /* Gain_F optimization */
 enum ath5k_rfgain ath5k_hw_gainf_calibrate(struct ath5k_hw *ah);
 int ath5k_hw_rfgain_opt_init(struct ath5k_hw *ah);
 /* PHY/RF channel functions */
-bool ath5k_channel_ok(struct ath5k_hw *ah, u16 freq, unsigned int flags);
+bool ath5k_channel_ok(struct ath5k_hw *ah, struct ieee80211_channel *channel);
 /* PHY calibration */
 void ath5k_hw_init_nfcal_hist(struct ath5k_hw *ah);
 int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index b0df2f6..5606259 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -145,7 +145,7 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 		goto err;
 
 	/* Bring device out of sleep and reset its units */
-	ret = ath5k_hw_nic_wakeup(ah, 0, true);
+	ret = ath5k_hw_nic_wakeup(ah, NULL);
 	if (ret)
 		goto err;
 
@@ -153,7 +153,7 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 	ah->ah_phy_revision = ath5k_hw_reg_read(ah, AR5K_PHY_CHIP_ID) &
 			0xffffffff;
 	ah->ah_radio_5ghz_revision = ath5k_hw_radio_revision(ah,
-			CHANNEL_5GHZ);
+			IEEE80211_BAND_5GHZ);
 
 	/* Try to identify radio chip based on its srev */
 	switch (ah->ah_radio_5ghz_revision & 0xf0) {
@@ -161,14 +161,14 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 		ah->ah_radio = AR5K_RF5111;
 		ah->ah_single_chip = false;
 		ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
-							CHANNEL_2GHZ);
+							IEEE80211_BAND_2GHZ);
 		break;
 	case AR5K_SREV_RAD_5112:
 	case AR5K_SREV_RAD_2112:
 		ah->ah_radio = AR5K_RF5112;
 		ah->ah_single_chip = false;
 		ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
-							CHANNEL_2GHZ);
+							IEEE80211_BAND_2GHZ);
 		break;
 	case AR5K_SREV_RAD_2413:
 		ah->ah_radio = AR5K_RF2413;
@@ -205,7 +205,7 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 			ah->ah_radio = AR5K_RF5111;
 			ah->ah_single_chip = false;
 			ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
-								CHANNEL_2GHZ);
+							IEEE80211_BAND_2GHZ);
 		} else if (ah->ah_mac_version == (AR5K_SREV_AR2425 >> 4) ||
 			   ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4) ||
 			   ah->ah_phy_revision == AR5K_SREV_PHY_2425) {
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index ee06e34..dfbbd16 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -271,20 +271,18 @@ static unsigned int
 ath5k_setup_channels(struct ath5k_hw *ah, struct ieee80211_channel *channels,
 		unsigned int mode, unsigned int max)
 {
-	unsigned int count, size, chfreq, freq, ch;
+	unsigned int count, size, freq, ch;
 	enum ieee80211_band band;
 
 	switch (mode) {
 	case AR5K_MODE_11A:
 		/* 1..220, but 2GHz frequencies are filtered by check_channel */
 		size = 220;
-		chfreq = CHANNEL_5GHZ;
 		band = IEEE80211_BAND_5GHZ;
 		break;
 	case AR5K_MODE_11B:
 	case AR5K_MODE_11G:
 		size = 26;
-		chfreq = CHANNEL_2GHZ;
 		band = IEEE80211_BAND_2GHZ;
 		break;
 	default:
@@ -299,26 +297,19 @@ ath5k_setup_channels(struct ath5k_hw *ah, struct ieee80211_channel *channels,
 		if (freq == 0) /* mapping failed - not a standard channel */
 			continue;
 
+		/* Write channel info, needed for ath5k_channel_ok() */
+		channels[count].center_freq = freq;
+		channels[count].band = band;
+		channels[count].hw_value = mode;
+
 		/* Check if channel is supported by the chipset */
-		if (!ath5k_channel_ok(ah, freq, chfreq))
+		if (!ath5k_channel_ok(ah, &channels[count]))
 			continue;
 
 		if (!modparam_all_channels &&
 		    !ath5k_is_standard_channel(ch, band))
 			continue;
 
-		/* Write channel info and increment counter */
-		channels[count].center_freq = freq;
-		channels[count].band = band;
-		switch (mode) {
-		case AR5K_MODE_11A:
-		case AR5K_MODE_11G:
-			channels[count].hw_value = chfreq | CHANNEL_OFDM;
-			break;
-		case AR5K_MODE_11B:
-			channels[count].hw_value = CHANNEL_B;
-		}
-
 		count++;
 	}
 
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 56cb9d4..7c9c2ab 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1780,12 +1780,12 @@ ath5k_eeprom_detach(struct ath5k_hw *ah)
 int
 ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel)
 {
-	switch (channel->hw_value & CHANNEL_MODES) {
-	case CHANNEL_A:
+	switch (channel->hw_value) {
+	case AR5K_MODE_11A:
 		return AR5K_EEPROM_MODE_11A;
-	case CHANNEL_G:
+	case AR5K_MODE_11G:
 		return AR5K_EEPROM_MODE_11G;
-	case CHANNEL_B:
+	case AR5K_MODE_11B:
 		return AR5K_EEPROM_MODE_11B;
 	default:
 		return -1;
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 0673138..733d46c 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -152,7 +152,7 @@ unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
 	case AR5K_BWMODE_DEFAULT:
 	default:
 		slot_time = AR5K_INIT_SLOT_TIME_DEFAULT;
-		if ((channel->hw_value & CHANNEL_CCK) && !ah->ah_short_slot)
+		if ((channel->hw_value == AR5K_MODE_11B) && !ah->ah_short_slot)
 			slot_time = AR5K_INIT_SLOT_TIME_B;
 		break;
 	}
@@ -183,7 +183,7 @@ unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
 	case AR5K_BWMODE_DEFAULT:
 		sifs = AR5K_INIT_SIFS_DEFAULT_BG;
 	default:
-		if (channel->hw_value & CHANNEL_5GHZ)
+		if (channel->band == IEEE80211_BAND_5GHZ)
 			sifs = AR5K_INIT_SIFS_DEFAULT_A;
 		break;
 	}
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index b9ada88..227c914 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -38,7 +38,7 @@
 /*
  * Get the PHY Chip revision
  */
-u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan)
+u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, enum ieee80211_band band)
 {
 	unsigned int i;
 	u32 srev;
@@ -47,11 +47,11 @@ u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan)
 	/*
 	 * Set the radio chip access register
 	 */
-	switch (chan) {
-	case CHANNEL_2GHZ:
+	switch (band) {
+	case IEEE80211_BAND_2GHZ:
 		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_2GHZ, AR5K_PHY(0));
 		break;
-	case CHANNEL_5GHZ:
+	case IEEE80211_BAND_5GHZ:
 		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
 		break;
 	default:
@@ -84,14 +84,16 @@ u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan)
 /*
  * Check if a channel is supported
  */
-bool ath5k_channel_ok(struct ath5k_hw *ah, u16 freq, unsigned int flags)
+bool ath5k_channel_ok(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 {
+	u16 freq = channel->center_freq;
+
 	/* Check if the channel is in our supported range */
-	if (flags & CHANNEL_2GHZ) {
+	if (channel->band == IEEE80211_BAND_2GHZ) {
 		if ((freq >= ah->ah_capabilities.cap_range.range_2ghz_min) &&
 		    (freq <= ah->ah_capabilities.cap_range.range_2ghz_max))
 			return true;
-	} else if (flags & CHANNEL_5GHZ)
+	} else if (channel->band == IEEE80211_BAND_5GHZ)
 		if ((freq >= ah->ah_capabilities.cap_range.range_5ghz_min) &&
 		    (freq <= ah->ah_capabilities.cap_range.range_5ghz_max))
 			return true;
@@ -224,7 +226,7 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
 		ds_coef_exp, ds_coef_man, clock;
 
 	BUG_ON(!(ah->ah_version == AR5K_AR5212) ||
-		!(channel->hw_value & CHANNEL_OFDM));
+		(channel->hw_value == AR5K_MODE_11B));
 
 	/* Get coefficient
 	 * ALGO: coef = (5 * clock / carrier_freq) / 2
@@ -298,7 +300,7 @@ static void ath5k_hw_wait_for_synth(struct ath5k_hw *ah,
 		u32 delay;
 		delay = ath5k_hw_reg_read(ah, AR5K_PHY_RX_DELAY) &
 			AR5K_PHY_RX_DELAY_M;
-		delay = (channel->hw_value & CHANNEL_CCK) ?
+		delay = (channel->hw_value == AR5K_MODE_11B) ?
 			((delay << 2) / 22) : (delay / 10);
 		if (ah->ah_bwmode == AR5K_BWMODE_10MHZ)
 			delay = delay << 1;
@@ -798,9 +800,9 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 	}
 
 	/* Set Output and Driver bias current (OB/DB) */
-	if (channel->hw_value & CHANNEL_2GHZ) {
+	if (channel->band == IEEE80211_BAND_2GHZ) {
 
-		if (channel->hw_value & CHANNEL_CCK)
+		if (channel->hw_value == AR5K_MODE_11B)
 			ee_mode = AR5K_EEPROM_MODE_11B;
 		else
 			ee_mode = AR5K_EEPROM_MODE_11G;
@@ -825,7 +827,7 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 						AR5K_RF_DB_2GHZ, true);
 
 	/* RF5111 always needs OB/DB for 5GHz, even if we use 2GHz */
-	} else if ((channel->hw_value & CHANNEL_5GHZ) ||
+	} else if ((channel->band == IEEE80211_BAND_5GHZ) ||
 			(ah->ah_radio == AR5K_RF5111)) {
 
 		/* For 11a, Turbo and XR we need to choose
@@ -857,7 +859,7 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 	if (ah->ah_radio == AR5K_RF5111) {
 
 		/* Set gain_F settings according to current step */
-		if (channel->hw_value & CHANNEL_OFDM) {
+		if (channel->hw_value != AR5K_MODE_11B) {
 
 			AR5K_REG_WRITE_BITS(ah, AR5K_PHY_FRAME_CTL,
 					AR5K_PHY_FRAME_CTL_TX_CLIP,
@@ -914,7 +916,7 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 	if (ah->ah_radio == AR5K_RF5112) {
 
 		/* Set gain_F settings according to current step */
-		if (channel->hw_value & CHANNEL_OFDM) {
+		if (channel->hw_value != AR5K_MODE_11B) {
 
 			ath5k_hw_rfb_op(ah, rf_regs, g_step->gos_param[0],
 						AR5K_RF_MIXGAIN_OVR, true);
@@ -1026,7 +1028,7 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 	}
 
 	if (ah->ah_radio == AR5K_RF5413 &&
-	channel->hw_value & CHANNEL_2GHZ) {
+	channel->band == IEEE80211_BAND_2GHZ) {
 
 		ath5k_hw_rfb_op(ah, rf_regs, 1, AR5K_RF_DERBY_CHAN_SEL_MODE,
 									true);
@@ -1138,7 +1140,7 @@ static int ath5k_hw_rf5111_channel(struct ath5k_hw *ah,
 	 */
 	data0 = data1 = 0;
 
-	if (channel->hw_value & CHANNEL_2GHZ) {
+	if (channel->band == IEEE80211_BAND_2GHZ) {
 		/* Map 2GHz channel to 5GHz Atheros channel ID */
 		ret = ath5k_hw_rf5111_chan2athchan(
 			ieee80211_frequency_to_channel(channel->center_freq),
@@ -1265,10 +1267,9 @@ static int ath5k_hw_channel(struct ath5k_hw *ah,
 	int ret;
 	/*
 	 * Check bounds supported by the PHY (we don't care about regulatory
-	 * restrictions at this point). Note: hw_value already has the band
-	 * (CHANNEL_2GHZ, or CHANNEL_5GHZ) so we inform ath5k_channel_ok()
-	 * of the band by that */
-	if (!ath5k_channel_ok(ah, channel->center_freq, channel->hw_value)) {
+	 * restrictions at this point).
+	 */
+	if (!ath5k_channel_ok(ah, channel)) {
 		ATH5K_ERR(ah,
 			"channel frequency (%u MHz) out of supported "
 			"band range\n",
@@ -1614,7 +1615,7 @@ int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 	ret = ath5k_hw_rf511x_iq_calibrate(ah);
 
 	if ((ah->ah_radio == AR5K_RF5111 || ah->ah_radio == AR5K_RF5112) &&
-	    (channel->hw_value & CHANNEL_OFDM))
+	    (channel->hw_value != AR5K_MODE_11B))
 		ath5k_hw_request_rfgain_probe(ah);
 
 	return ret;
@@ -1641,7 +1642,7 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 	/* Convert current frequency to fbin value (the same way channels
 	 * are stored on EEPROM, check out ath5k_eeprom_bin2freq) and scale
 	 * up by 2 so we can compare it later */
-	if (channel->hw_value & CHANNEL_2GHZ) {
+	if (channel->band == IEEE80211_BAND_2GHZ) {
 		chan_fbin = (channel->center_freq - 2300) * 10;
 		freq_band = AR5K_EEPROM_BAND_2GHZ;
 	} else {
@@ -1703,7 +1704,7 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 			spur_freq_sigma_delta = (spur_delta_phase >> 10);
 			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz / 4;
 		default:
-			if (channel->hw_value == CHANNEL_A) {
+			if (channel->band == IEEE80211_BAND_5GHZ) {
 				/* Both sample_freq and chip_freq are 40MHz */
 				spur_delta_phase = (spur_offset << 17) / 25;
 				spur_freq_sigma_delta =
@@ -2226,15 +2227,20 @@ ath5k_get_chan_pcal_surrounding_piers(struct ath5k_hw *ah,
 	idx_l = 0;
 	idx_r = 0;
 
-	if (!(channel->hw_value & CHANNEL_OFDM)) {
+	switch (channel->hw_value) {
+	case AR5K_EEPROM_MODE_11A:
+		pcinfo = ee->ee_pwr_cal_a;
+		mode = AR5K_EEPROM_MODE_11A;
+		break;
+	case AR5K_EEPROM_MODE_11B:
 		pcinfo = ee->ee_pwr_cal_b;
 		mode = AR5K_EEPROM_MODE_11B;
-	} else if (channel->hw_value & CHANNEL_2GHZ) {
+		break;
+	case AR5K_EEPROM_MODE_11G:
+	default:
 		pcinfo = ee->ee_pwr_cal_g;
 		mode = AR5K_EEPROM_MODE_11G;
-	} else {
-		pcinfo = ee->ee_pwr_cal_a;
-		mode = AR5K_EEPROM_MODE_11A;
+		break;
 	}
 	max = ee->ee_n_piers[mode] - 1;
 
@@ -2303,15 +2309,20 @@ ath5k_get_rate_pcal_data(struct ath5k_hw *ah,
 	idx_l = 0;
 	idx_r = 0;
 
-	if (!(channel->hw_value & CHANNEL_OFDM)) {
+	switch (channel->hw_value) {
+	case AR5K_MODE_11A:
+		rpinfo = ee->ee_rate_tpwr_a;
+		mode = AR5K_EEPROM_MODE_11A;
+		break;
+	case AR5K_MODE_11B:
 		rpinfo = ee->ee_rate_tpwr_b;
 		mode = AR5K_EEPROM_MODE_11B;
-	} else if (channel->hw_value & CHANNEL_2GHZ) {
+		break;
+	case AR5K_MODE_11G:
+	default:
 		rpinfo = ee->ee_rate_tpwr_g;
 		mode = AR5K_EEPROM_MODE_11G;
-	} else {
-		rpinfo = ee->ee_rate_tpwr_a;
-		mode = AR5K_EEPROM_MODE_11A;
+		break;
 	}
 	max = ee->ee_rate_target_pwr_num[mode] - 1;
 
@@ -2392,20 +2403,20 @@ ath5k_get_max_ctl_power(struct ath5k_hw *ah,
 
 	ctl_mode = ath_regd_get_band_ctl(regulatory, channel->band);
 
-	switch (channel->hw_value & CHANNEL_MODES) {
-	case CHANNEL_A:
+	switch (channel->hw_value) {
+	case AR5K_MODE_11A:
 		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ)
 			ctl_mode |= AR5K_CTL_TURBO;
 		else
 			ctl_mode |= AR5K_CTL_11A;
 		break;
-	case CHANNEL_G:
+	case AR5K_MODE_11G:
 		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ)
 			ctl_mode |= AR5K_CTL_TURBOG;
 		else
 			ctl_mode |= AR5K_CTL_11G;
 		break;
-	case CHANNEL_B:
+	case AR5K_MODE_11B:
 		ctl_mode |= AR5K_CTL_11B;
 		break;
 	default:
@@ -3290,7 +3301,7 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 
 	/* Write OFDM timings on 5212*/
 	if (ah->ah_version == AR5K_AR5212 &&
-		channel->hw_value & CHANNEL_OFDM) {
+		channel->hw_value != AR5K_MODE_11B) {
 
 		ret = ath5k_hw_write_ofdm_timings(ah, channel);
 		if (ret)
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 1d37675..a8b8ffa 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -537,7 +537,7 @@ int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 	 *
 	 * Also we have different lowest rate for 802.11a
 	 */
-	if (channel->hw_value & CHANNEL_5GHZ)
+	if (channel->band == IEEE80211_BAND_5GHZ)
 		rate = &ah->sbands[IEEE80211_BAND_5GHZ].bitrates[0];
 	else
 		rate = &ah->sbands[IEEE80211_BAND_2GHZ].bitrates[0];
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 5d6d3bd..8bc57e4 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -102,12 +102,18 @@ static void ath5k_hw_init_core_clock(struct ath5k_hw *ah)
 	/*
 	 * Set core clock frequency
 	 */
-	if (channel->hw_value & CHANNEL_5GHZ)
-		clock = 40; /* 802.11a */
-	else if (channel->hw_value & CHANNEL_CCK)
-		clock = 22; /* 802.11b */
-	else
-		clock = 44; /* 802.11g */
+	switch (channel->hw_value) {
+	case AR5K_MODE_11A:
+		clock = 40;
+		break;
+	case AR5K_MODE_11B:
+		clock = 22;
+		break;
+	case AR5K_MODE_11G:
+	default:
+		clock = 44;
+		break;
+	}
 
 	/* Use clock multiplier for non-default
 	 * bwmode */
@@ -581,8 +587,9 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 
 /*
  * Bring up MAC + PHY Chips and program PLL
+ * Channel is NULL for the initial wakeup.
  */
-int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
+int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 {
 	struct pci_dev *pdev = ah->pdev;
 	u32 turbo, mode, clock, bus_flags;
@@ -592,7 +599,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	mode = 0;
 	clock = 0;
 
-	if ((ath5k_get_bus_type(ah) != ATH_AHB) || !initial) {
+	if ((ath5k_get_bus_type(ah) != ATH_AHB) || channel) {
 		/* Wakeup the device */
 		ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 		if (ret) {
@@ -652,7 +659,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 
 	/* On initialization skip PLL programming since we don't have
 	 * a channel / mode set yet */
-	if (initial)
+	if (!channel)
 		return 0;
 
 	if (ah->ah_version != AR5K_AR5210) {
@@ -668,13 +675,13 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 			clock = AR5K_PHY_PLL_RF5111;		/*Zero*/
 		}
 
-		if (flags & CHANNEL_2GHZ) {
+		if (channel->band == IEEE80211_BAND_2GHZ) {
 			mode |= AR5K_PHY_MODE_FREQ_2GHZ;
 			clock |= AR5K_PHY_PLL_44MHZ;
 
-			if (flags & CHANNEL_CCK) {
+			if (channel->hw_value == AR5K_MODE_11B) {
 				mode |= AR5K_PHY_MODE_MOD_CCK;
-			} else if (flags & CHANNEL_OFDM) {
+			} else {
 				/* XXX Dynamic OFDM/CCK is not supported by the
 				 * AR5211 so we set MOD_OFDM for plain g (no
 				 * CCK headers) operation. We need to test
@@ -686,27 +693,16 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 					mode |= AR5K_PHY_MODE_MOD_OFDM;
 				else
 					mode |= AR5K_PHY_MODE_MOD_DYN;
-			} else {
-				ATH5K_ERR(ah,
-					"invalid radio modulation mode\n");
-				return -EINVAL;
 			}
-		} else if (flags & CHANNEL_5GHZ) {
-			mode |= AR5K_PHY_MODE_FREQ_5GHZ;
+		} else if (channel->band == IEEE80211_BAND_5GHZ) {
+			mode |= (AR5K_PHY_MODE_FREQ_5GHZ |
+				 AR5K_PHY_MODE_MOD_OFDM);
 
 			/* Different PLL setting for 5413 */
 			if (ah->ah_radio == AR5K_RF5413)
 				clock = AR5K_PHY_PLL_40MHZ_5413;
 			else
 				clock |= AR5K_PHY_PLL_40MHZ;
-
-			if (flags & CHANNEL_OFDM)
-				mode |= AR5K_PHY_MODE_MOD_OFDM;
-			else {
-				ATH5K_ERR(ah,
-					"invalid radio modulation mode\n");
-				return -EINVAL;
-			}
 		} else {
 			ATH5K_ERR(ah, "invalid radio frequency mode\n");
 			return -EINVAL;
@@ -822,7 +818,7 @@ static void ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
 		u32 data;
 		ath5k_hw_reg_write(ah, AR5K_PHY_CCKTXCTL_WORLD,
 				AR5K_PHY_CCKTXCTL);
-		if (channel->hw_value & CHANNEL_5GHZ)
+		if (channel->band == IEEE80211_BAND_5GHZ)
 			data = 0xffb81020;
 		else
 			data = 0xffb80d20;
@@ -905,7 +901,7 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 	/* Set CCK to OFDM power delta on tx power
 	 * adjustment register */
 	if (ah->ah_phy_revision >= AR5K_SREV_PHY_5212A) {
-		if (channel->hw_value == CHANNEL_G)
+		if (channel->hw_value == AR5K_MODE_11G)
 			ath5k_hw_reg_write(ah,
 			AR5K_REG_SM((ee->ee_cck_ofdm_gain_delta * -1),
 				AR5K_PHY_TX_PWR_ADJ_CCK_GAIN_DELTA) |
@@ -1084,29 +1080,23 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		ret = 0;
 	}
 
-	switch (channel->hw_value & CHANNEL_MODES) {
-	case CHANNEL_A:
-		mode = AR5K_MODE_11A;
+	mode = channel->hw_value;
+	switch (mode) {
+	case AR5K_MODE_11A:
 		break;
-	case CHANNEL_G:
-
+	case AR5K_MODE_11G:
 		if (ah->ah_version <= AR5K_AR5211) {
 			ATH5K_ERR(ah,
 				"G mode not available on 5210/5211");
 			return -EINVAL;
 		}
-
-		mode = AR5K_MODE_11G;
 		break;
-	case CHANNEL_B:
-
+	case AR5K_MODE_11B:
 		if (ah->ah_version < AR5K_AR5211) {
 			ATH5K_ERR(ah,
 				"B mode not available on 5210");
 			return -EINVAL;
 		}
-
-		mode = AR5K_MODE_11B;
 		break;
 	default:
 		ATH5K_ERR(ah,
@@ -1192,7 +1182,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	}
 
 	/* Wakeup the device */
-	ret = ath5k_hw_nic_wakeup(ah, channel->hw_value, false);
+	ret = ath5k_hw_nic_wakeup(ah, channel);
 	if (ret)
 		return ret;
 
