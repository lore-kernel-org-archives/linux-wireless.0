Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57476 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbYKTOSA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 09:18:00 -0500
Message-ID: <49257136.2050902@openwrt.org> (sfid-20081120_151808_739319_B981A4C8)
Date: Thu, 20 Nov 2008 15:16:22 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH] ath5k: Clean up eeprom parsing and add missing calibration
 data
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch brings the ath5k eeprom parsing code in sync with the work
done on ath_info by Nick Kossifidis and integrates the missing parts
based on the code of the Atheros Legacy HAL release.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>

--- a/drivers/net/wireless/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath5k/eeprom.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2004-2008 Reyk Floeter <reyk@openbsd.org>
  * Copyright (c) 2006-2008 Nick Kossifidis <mickflemm@gmail.com>
+ * Copyright (c) 2008 Felix Fietkau <nbd@openwrt.org>
  *
  * Permission to use, copy, modify, and distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -63,8 +64,8 @@ static int ath5k_hw_eeprom_read(struct a
 /*
  * Translate binary channel representation in EEPROM to frequency
  */
-static u16 ath5k_eeprom_bin2freq(struct ath5k_hw *ah, u16 bin,
-				unsigned int mode)
+static u16 ath5k_eeprom_bin2freq(struct ath5k_eeprom_info *ee, u16 bin,
+                                 unsigned int mode)
 {
 	u16 val;
 
@@ -72,13 +73,13 @@ static u16 ath5k_eeprom_bin2freq(struct 
 		return bin;
 
 	if (mode == AR5K_EEPROM_MODE_11A) {
-		if (ah->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
+		if (ee->ee_version > AR5K_EEPROM_VERSION_3_2)
 			val = (5 * bin) + 4800;
 		else
 			val = bin > 62 ? (10 * 62) + (5 * (bin - 62)) + 5100 :
 				(bin * 10) + 5100;
 	} else {
-		if (ah->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
+		if (ee->ee_version > AR5K_EEPROM_VERSION_3_2)
 			val = bin + 2300;
 		else
 			val = bin + 2400;
@@ -88,6 +89,71 @@ static u16 ath5k_eeprom_bin2freq(struct 
 }
 
 /*
+ * Initialize eeprom & capabilities structs
+ */
+static int
+ath5k_eeprom_init_header(struct ath5k_hw *ah)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	int ret;
+	u16 val;
+
+	/* Initial TX thermal adjustment values */
+	ee->ee_tx_clip = 4;
+	ee->ee_pwd_84 = ee->ee_pwd_90 = 1;
+	ee->ee_gain_select = 1;
+
+	/*
+	 * Read values from EEPROM and store them in the capability structure
+	 */
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MAGIC, ee_magic);
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_PROTECT, ee_protect);
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_REG_DOMAIN, ee_regdomain);
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_VERSION, ee_version);
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_HDR, ee_header);
+
+	/* Return if we have an old EEPROM */
+	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_0)
+		return 0;
+
+#ifdef notyet
+	/*
+	 * Validate the checksum of the EEPROM date. There are some
+	 * devices with invalid EEPROMs.
+	 */
+	for (cksum = 0, offset = 0; offset < AR5K_EEPROM_INFO_MAX; offset++) {
+		AR5K_EEPROM_READ(AR5K_EEPROM_INFO(offset), val);
+		cksum ^= val;
+	}
+	if (cksum != AR5K_EEPROM_INFO_CKSUM) {
+		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM checksum 0x%04x\n", cksum);
+		return -EIO;
+	}
+#endif
+
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_ANT_GAIN(ah->ah_ee_version),
+	    ee_ant_gain);
+
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
+		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC0, ee_misc0);
+		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC1, ee_misc1);
+	}
+
+	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_3) {
+		AR5K_EEPROM_READ(AR5K_EEPROM_OBDB0_2GHZ, val);
+		ee->ee_ob[AR5K_EEPROM_MODE_11B][0] = val & 0x7;
+		ee->ee_db[AR5K_EEPROM_MODE_11B][0] = (val >> 3) & 0x7;
+
+		AR5K_EEPROM_READ(AR5K_EEPROM_OBDB1_2GHZ, val);
+		ee->ee_ob[AR5K_EEPROM_MODE_11G][0] = val & 0x7;
+		ee->ee_db[AR5K_EEPROM_MODE_11G][0] = (val >> 3) & 0x7;
+	}
+
+	return 0;
+}
+
+
+/*
  * Read antenna infos from eeprom
  */
 static int ath5k_eeprom_read_ants(struct ath5k_hw *ah, u32 *offset,
@@ -100,7 +166,7 @@ static int ath5k_eeprom_read_ants(struct
 
 	AR5K_EEPROM_READ(o++, val);
 	ee->ee_switch_settling[mode]	= (val >> 8) & 0x7f;
-	ee->ee_ant_tx_rx[mode]		= (val >> 2) & 0x3f;
+	ee->ee_atn_tx_rx[mode]		= (val >> 2) & 0x3f;
 	ee->ee_ant_control[mode][i]	= (val << 4) & 0x3f;
 
 	AR5K_EEPROM_READ(o++, val);
@@ -157,6 +223,30 @@ static int ath5k_eeprom_read_modes(struc
 	u16 val;
 	int ret;
 
+	ee->ee_n_piers[mode] = 0;
+	AR5K_EEPROM_READ(o++, val);
+	ee->ee_adc_desired_size[mode]	= (s8)((val >> 8) & 0xff);
+	switch(mode) {
+	case AR5K_EEPROM_MODE_11A:
+		ee->ee_ob[mode][3]		= (val >> 5) & 0x7;
+		ee->ee_db[mode][3]		= (val >> 2) & 0x7;
+		ee->ee_ob[mode][2]		= (val << 1) & 0x7;
+
+		AR5K_EEPROM_READ(o++, val);
+		ee->ee_ob[mode][2]		|= (val >> 15) & 0x1;
+		ee->ee_db[mode][2]		= (val >> 12) & 0x7;
+		ee->ee_ob[mode][1]		= (val >> 9) & 0x7;
+		ee->ee_db[mode][1]		= (val >> 6) & 0x7;
+		ee->ee_ob[mode][0]		= (val >> 3) & 0x7;
+		ee->ee_db[mode][0]		= val & 0x7;
+		break;
+	case AR5K_EEPROM_MODE_11G:
+	case AR5K_EEPROM_MODE_11B:
+		ee->ee_ob[mode][1]		= (val >> 4) & 0x7;
+		ee->ee_db[mode][1]		= val & 0x7;
+		break;
+	}
+
 	AR5K_EEPROM_READ(o++, val);
 	ee->ee_tx_end2xlna_enable[mode]	= (val >> 8) & 0xff;
 	ee->ee_thr_62[mode]		= val & 0xff;
@@ -209,8 +299,11 @@ static int ath5k_eeprom_read_modes(struc
 		AR5K_EEPROM_READ(o++, val);
 		ee->ee_i_gain[mode] |= (val << 3) & 0x38;
 
-		if (mode == AR5K_EEPROM_MODE_11G)
+		if (mode == AR5K_EEPROM_MODE_11G) {
 			ee->ee_cck_ofdm_power_delta = (val >> 3) & 0xff;
+			if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_6)
+				ee->ee_scaled_cck_delta = (val >> 11) & 0x1f;
+		}
 	}
 
 	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0 &&
@@ -219,10 +312,77 @@ static int ath5k_eeprom_read_modes(struc
 		ee->ee_q_cal[mode] = (val >> 3) & 0x1f;
 	}
 
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_6 &&
-	    mode == AR5K_EEPROM_MODE_11G)
-		ee->ee_scaled_cck_delta = (val >> 11) & 0x1f;
+	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_4_0)
+		goto done;
+
+	switch(mode) {
+	case AR5K_EEPROM_MODE_11A:
+		if (ah->ah_ee_version < AR5K_EEPROM_VERSION_4_1)
+			break;
+
+		AR5K_EEPROM_READ(o++, val);
+		ee->ee_margin_tx_rx[mode] = val & 0x3f;
+		break;
+	case AR5K_EEPROM_MODE_11B:
+		AR5K_EEPROM_READ(o++, val);
+
+		ee->ee_pwr_cal_b[0].freq =
+			ath5k_eeprom_bin2freq(ee, val & 0xff, mode);
+		if (ee->ee_pwr_cal_b[0].freq != AR5K_EEPROM_CHANNEL_DIS)
+			ee->ee_n_piers[mode]++;
+
+		ee->ee_pwr_cal_b[1].freq =
+			ath5k_eeprom_bin2freq(ee, (val >> 8) & 0xff, mode);
+		if (ee->ee_pwr_cal_b[1].freq != AR5K_EEPROM_CHANNEL_DIS)
+			ee->ee_n_piers[mode]++;
+
+		AR5K_EEPROM_READ(o++, val);
+		ee->ee_pwr_cal_b[2].freq =
+			ath5k_eeprom_bin2freq(ee, val & 0xff, mode);
+		if (ee->ee_pwr_cal_b[2].freq != AR5K_EEPROM_CHANNEL_DIS)
+			ee->ee_n_piers[mode]++;
+
+		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
+			ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
+		break;
+	case AR5K_EEPROM_MODE_11G:
+		AR5K_EEPROM_READ(o++, val);
+
+		ee->ee_pwr_cal_g[0].freq =
+			ath5k_eeprom_bin2freq(ee, val & 0xff, mode);
+		if (ee->ee_pwr_cal_g[0].freq != AR5K_EEPROM_CHANNEL_DIS)
+			ee->ee_n_piers[mode]++;
+
+		ee->ee_pwr_cal_g[1].freq =
+			ath5k_eeprom_bin2freq(ee, (val >> 8) & 0xff, mode);
+		if (ee->ee_pwr_cal_g[1].freq != AR5K_EEPROM_CHANNEL_DIS)
+			ee->ee_n_piers[mode]++;
 
+		AR5K_EEPROM_READ(o++, val);
+		ee->ee_turbo_max_power[mode] = val & 0x7f;
+		ee->ee_xr_power[mode] = (val >> 7) & 0x3f;
+
+		AR5K_EEPROM_READ(o++, val);
+		ee->ee_pwr_cal_g[2].freq =
+			ath5k_eeprom_bin2freq(ee, val & 0xff, mode);
+		if (ee->ee_pwr_cal_g[2].freq != AR5K_EEPROM_CHANNEL_DIS)
+			ee->ee_n_piers[mode]++;
+
+		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
+			ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
+
+		AR5K_EEPROM_READ(o++, val);
+		ee->ee_i_cal[mode] = (val >> 8) & 0x3f;
+		ee->ee_q_cal[mode] = (val >> 3) & 0x1f;
+
+		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_2) {
+			AR5K_EEPROM_READ(o++, val);
+			ee->ee_cck_ofdm_gain_delta = val & 0xff;
+		}
+		break;
+	}
+
+done:
 	/* return new offset */
 	*offset = o;
 
@@ -230,204 +390,944 @@ static int ath5k_eeprom_read_modes(struc
 }
 
 /*
- * Initialize eeprom & capabilities structs
+ * Read turbo mode information on newer EEPROM versions
  */
-int ath5k_eeprom_init(struct ath5k_hw *ah)
+static int
+ath5k_eeprom_read_turbo_modes(struct ath5k_hw *ah,
+			      u32 *offset, unsigned int mode)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	unsigned int mode, i;
-	int ret;
-	u32 offset;
+	u32 o = *offset;
 	u16 val;
+	int ret;
 
-	/* Initial TX thermal adjustment values */
-	ee->ee_tx_clip = 4;
-	ee->ee_pwd_84 = ee->ee_pwd_90 = 1;
-	ee->ee_gain_select = 1;
+	if (ee->ee_version < AR5K_EEPROM_VERSION_5_0)
+		return 0;
 
-	/*
-	 * Read values from EEPROM and store them in the capability structure
-	 */
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MAGIC, ee_magic);
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_PROTECT, ee_protect);
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_REG_DOMAIN, ee_regdomain);
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_VERSION, ee_version);
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_HDR, ee_header);
+	switch (mode){
+	case AR5K_EEPROM_MODE_11A:
+		ee->ee_switch_settling_turbo[mode] = (val >> 6) & 0x7f;
 
-	/* Return if we have an old EEPROM */
-	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_0)
-		return 0;
+		ee->ee_atn_tx_rx_turbo[mode] = (val >> 13) & 0x7;
+		AR5K_EEPROM_READ(o++, val);
+		ee->ee_atn_tx_rx_turbo[mode] |= (val & 0x7) << 3;
+		ee->ee_margin_tx_rx_turbo[mode] = (val >> 3) & 0x3f;
+
+		ee->ee_adc_desired_size_turbo[mode] = (val >> 9) & 0x7f;
+		AR5K_EEPROM_READ(o++, val);
+		ee->ee_adc_desired_size_turbo[mode] |= (val & 0x1) << 7;
+		ee->ee_pga_desired_size_turbo[mode] = (val >> 1) & 0xff;
+
+		if (AR5K_EEPROM_EEMAP(ee->ee_misc0) >=2)
+			ee->ee_pd_gain_overlap = (val >> 9) & 0xf;
+		break;
+	case AR5K_EEPROM_MODE_11G:
+		ee->ee_switch_settling_turbo[mode] = (val >> 8) & 0x7f;
+
+		ee->ee_atn_tx_rx_turbo[mode] = (val >> 15) & 0x7;
+		AR5K_EEPROM_READ(o++, val);
+		ee->ee_atn_tx_rx_turbo[mode] |= (val & 0x1f) << 1;
+		ee->ee_margin_tx_rx_turbo[mode] = (val >> 5) & 0x3f;
+
+		ee->ee_adc_desired_size_turbo[mode] = (val >> 11) & 0x7f;
+		AR5K_EEPROM_READ(o++, val);
+		ee->ee_adc_desired_size_turbo[mode] |= (val & 0x7) << 5;
+		ee->ee_pga_desired_size_turbo[mode] = (val >> 3) & 0xff;
+		break;
+	}
+
+	/* return new offset */
+	*offset = o;
+
+	return 0;
+}
+
+
+static int
+ath5k_eeprom_init_modes(struct ath5k_hw *ah)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	u32 mode_offset[3];
+	unsigned int mode;
+	u32 offset;
+	int ret;
 
-#ifdef notyet
 	/*
-	 * Validate the checksum of the EEPROM date. There are some
-	 * devices with invalid EEPROMs.
+	 * Get values for all modes
 	 */
-	for (cksum = 0, offset = 0; offset < AR5K_EEPROM_INFO_MAX; offset++) {
-		AR5K_EEPROM_READ(AR5K_EEPROM_INFO(offset), val);
-		cksum ^= val;
+	mode_offset[AR5K_EEPROM_MODE_11A] = AR5K_EEPROM_MODES_11A(ah->ah_ee_version);
+	mode_offset[AR5K_EEPROM_MODE_11B] = AR5K_EEPROM_MODES_11B(ah->ah_ee_version);
+	mode_offset[AR5K_EEPROM_MODE_11G] = AR5K_EEPROM_MODES_11G(ah->ah_ee_version);
+
+	ee->ee_turbo_max_power[AR5K_EEPROM_MODE_11A] =
+		AR5K_EEPROM_HDR_T_5GHZ_DBM(ee->ee_header);
+
+	for (mode = AR5K_EEPROM_MODE_11A; mode <= AR5K_EEPROM_MODE_11G; mode++) {
+		offset = mode_offset[mode];
+
+		ret = ath5k_eeprom_read_ants(ah, &offset, mode);
+		if (ret)
+			return ret;
+
+		ret = ath5k_eeprom_read_modes(ah, &offset, mode);
+		if (ret)
+			return ret;
+
+		ret = ath5k_eeprom_read_turbo_modes(ah, &offset, mode);
+		if (ret)
+			return ret;
 	}
-	if (cksum != AR5K_EEPROM_INFO_CKSUM) {
-		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM checksum 0x%04x\n", cksum);
-		return -EIO;
+
+	/* override for older eeprom versions for better performance */
+	if (ah->ah_ee_version <= AR5K_EEPROM_VERSION_3_2) {
+		ee->ee_thr_62[AR5K_EEPROM_MODE_11A] = 15;
+		ee->ee_thr_62[AR5K_EEPROM_MODE_11B] = 28;
+		ee->ee_thr_62[AR5K_EEPROM_MODE_11G] = 28;
 	}
-#endif
 
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_ANT_GAIN(ah->ah_ee_version),
-	    ee_ant_gain);
+	return 0;
+}
 
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
-		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC0, ee_misc0);
-		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC1, ee_misc1);
-	}
+static inline void
+ath5k_get_pcdac_intercepts(struct ath5k_hw *ah, u8 min, u8 max, u8 *vp)
+{
+	const static u16 intercepts3[] =
+		{ 0, 5, 10, 20, 30, 50, 70, 85, 90, 95, 100 };
+	const static u16 intercepts3_2[] =
+		{ 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 };
+	const u16 *ip;
+	int i;
 
-	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_3) {
-		AR5K_EEPROM_READ(AR5K_EEPROM_OBDB0_2GHZ, val);
-		ee->ee_ob[AR5K_EEPROM_MODE_11B][0] = val & 0x7;
-		ee->ee_db[AR5K_EEPROM_MODE_11B][0] = (val >> 3) & 0x7;
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_3_2)
+		ip = intercepts3_2;
+	else
+		ip = intercepts3;
 
-		AR5K_EEPROM_READ(AR5K_EEPROM_OBDB1_2GHZ, val);
-		ee->ee_ob[AR5K_EEPROM_MODE_11G][0] = val & 0x7;
-		ee->ee_db[AR5K_EEPROM_MODE_11G][0] = (val >> 3) & 0x7;
+	for (i = 0; i < ARRAY_SIZE(intercepts3); i++)
+		*vp++ = (ip[i] * max + (100 - ip[i]) * min) / 100;
+}
+
+static inline int
+ath5k_eeprom_read_freq_list(struct ath5k_hw *ah, int *offset, int max,
+                            struct ath5k_chan_pcal_info *pc, u8 *count)
+{
+	int o = *offset;
+	int i = 0;
+	u8 f1, f2;
+	int ret;
+	u16 val;
+
+	while(i < max) {
+		AR5K_EEPROM_READ(o++, val);
+
+		f1 = (val >> 8) & 0xff;
+		f2 = val & 0xff;
+
+		if (f1)
+			pc[i++].freq = f1;
+
+		if (f2)
+			pc[i++].freq = f2;
+
+		if (!f1 || !f2)
+			break;
 	}
+	*offset = o;
+	*count = i;
 
-	/*
-	 * Get conformance test limit values
-	 */
-	offset = AR5K_EEPROM_CTL(ah->ah_ee_version);
-	ee->ee_ctls = AR5K_EEPROM_N_CTLS(ah->ah_ee_version);
+	return 0;
+}
+
+static int
+ath5k_eeprom_init_11a_pcal_freq(struct ath5k_hw *ah, int offset)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	struct ath5k_chan_pcal_info *pcal = ee->ee_pwr_cal_a;
+	int i, ret;
+	u16 val;
+	u8 mask;
+
+	if (ee->ee_version >= AR5K_EEPROM_VERSION_3_3) {
+		ath5k_eeprom_read_freq_list(ah, &offset,
+			AR5K_EEPROM_N_5GHZ_CHAN, pcal,
+			&ee->ee_n_piers[AR5K_EEPROM_MODE_11A]);
+	} else {
+		mask = AR5K_EEPROM_FREQ_M(ah->ah_ee_version);
 
-	for (i = 0; i < ee->ee_ctls; i++) {
 		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_ctl[i] = (val >> 8) & 0xff;
-		ee->ee_ctl[i + 1] = val & 0xff;
+		pcal[0].freq  = (val >> 9) & mask;
+		pcal[1].freq  = (val >> 2) & mask;
+		pcal[2].freq  = (val << 5) & mask;
+
+		AR5K_EEPROM_READ(offset++, val);
+		pcal[2].freq |= (val >> 11) & 0x1f;
+		pcal[3].freq  = (val >> 4) & mask;
+		pcal[4].freq  = (val << 3) & mask;
+
+		AR5K_EEPROM_READ(offset++, val);
+		pcal[4].freq |= (val >> 13) & 0x7;
+		pcal[5].freq  = (val >> 6) & mask;
+		pcal[6].freq  = (val << 1) & mask;
+
+		AR5K_EEPROM_READ(offset++, val);
+		pcal[6].freq |= (val >> 15) & 0x1;
+		pcal[7].freq  = (val >> 8) & mask;
+		pcal[8].freq  = (val >> 1) & mask;
+		pcal[9].freq  = (val << 6) & mask;
+
+		AR5K_EEPROM_READ(offset++, val);
+		pcal[9].freq |= (val >> 10) & 0x3f;
+		ee->ee_n_piers[AR5K_EEPROM_MODE_11A] = 10;
 	}
 
-	/*
-	 * Get values for 802.11a (5GHz)
-	 */
-	mode = AR5K_EEPROM_MODE_11A;
+	for(i = 0; i < AR5K_EEPROM_N_5GHZ_CHAN; i += 1) {
+		pcal[i].freq = ath5k_eeprom_bin2freq(ee,
+				pcal[i].freq, AR5K_EEPROM_MODE_11A);
+	}
+
+	return 0;
+}
 
-	ee->ee_turbo_max_power[mode] =
-			AR5K_EEPROM_HDR_T_5GHZ_DBM(ee->ee_header);
+static inline int
+ath5k_eeprom_init_11bg_2413(struct ath5k_hw *ah, unsigned int mode, int offset)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	struct ath5k_chan_pcal_info *pcal;
+	int i;
 
-	offset = AR5K_EEPROM_MODES_11A(ah->ah_ee_version);
+	switch(mode) {
+	case AR5K_EEPROM_MODE_11B:
+		pcal = ee->ee_pwr_cal_b;
+		break;
+	case AR5K_EEPROM_MODE_11G:
+		pcal = ee->ee_pwr_cal_g;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	ret = ath5k_eeprom_read_ants(ah, &offset, mode);
-	if (ret)
-		return ret;
+	ath5k_eeprom_read_freq_list(ah, &offset,
+		AR5K_EEPROM_N_2GHZ_CHAN_2413, pcal,
+		&ee->ee_n_piers[mode]);
+	for(i = 0; i < AR5K_EEPROM_N_2GHZ_CHAN_2413; i += 1) {
+		pcal[i].freq = ath5k_eeprom_bin2freq(ee,
+				pcal[i].freq, mode);
+	}
 
-	AR5K_EEPROM_READ(offset++, val);
-	ee->ee_adc_desired_size[mode]	= (s8)((val >> 8) & 0xff);
-	ee->ee_ob[mode][3]		= (val >> 5) & 0x7;
-	ee->ee_db[mode][3]		= (val >> 2) & 0x7;
-	ee->ee_ob[mode][2]		= (val << 1) & 0x7;
-
-	AR5K_EEPROM_READ(offset++, val);
-	ee->ee_ob[mode][2]		|= (val >> 15) & 0x1;
-	ee->ee_db[mode][2]		= (val >> 12) & 0x7;
-	ee->ee_ob[mode][1]		= (val >> 9) & 0x7;
-	ee->ee_db[mode][1]		= (val >> 6) & 0x7;
-	ee->ee_ob[mode][0]		= (val >> 3) & 0x7;
-	ee->ee_db[mode][0]		= val & 0x7;
+	return 0;
+}
 
-	ret = ath5k_eeprom_read_modes(ah, &offset, mode);
-	if (ret)
-		return ret;
 
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1) {
-		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_margin_tx_rx[mode] = val & 0x3f;
+static int
+ath5k_eeprom_read_pcal_info_5111(struct ath5k_hw *ah, int mode)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	struct ath5k_chan_pcal_info *pcal;
+	int offset, ret;
+	int i, j;
+	u16 val;
+
+	offset = AR5K_EEPROM_GROUPS_START(ee->ee_version);
+	switch(mode) {
+	case AR5K_EEPROM_MODE_11A:
+		if (!AR5K_EEPROM_HDR_11A(ee->ee_header))
+			return 0;
+
+		ret = ath5k_eeprom_init_11a_pcal_freq(ah,
+			offset + AR5K_EEPROM_GROUP1_OFFSET);
+		if (ret < 0)
+			return ret;
+
+		offset += AR5K_EEPROM_GROUP2_OFFSET;
+		pcal = ee->ee_pwr_cal_a;
+		break;
+	case AR5K_EEPROM_MODE_11B:
+		if (!AR5K_EEPROM_HDR_11B(ee->ee_header) &&
+		    !AR5K_EEPROM_HDR_11G(ee->ee_header))
+			return 0;
+
+		pcal = ee->ee_pwr_cal_b;
+		offset += AR5K_EEPROM_GROUP3_OFFSET;
+
+		/* fixed piers */
+		pcal[0].freq = 2412;
+		pcal[1].freq = 2447;
+		pcal[2].freq = 2484;
+		ee->ee_n_piers[mode] = 3;
+		break;
+	case AR5K_EEPROM_MODE_11G:
+		if (!AR5K_EEPROM_HDR_11G(ee->ee_header))
+			return 0;
+
+		pcal = ee->ee_pwr_cal_g;
+		offset += AR5K_EEPROM_GROUP4_OFFSET;
+
+		/* fixed piers */
+		pcal[0].freq = 2312;
+		pcal[1].freq = 2412;
+		pcal[2].freq = 2484;
+		ee->ee_n_piers[mode] = 3;
+		break;
+	default:
+		return -EINVAL;
 	}
 
-	/*
-	 * Get values for 802.11b (2.4GHz)
-	 */
-	mode = AR5K_EEPROM_MODE_11B;
-	offset = AR5K_EEPROM_MODES_11B(ah->ah_ee_version);
+	for (i = 0; i < ee->ee_n_piers[mode]; i++) {
+		struct ath5k_chan_pcal_info_rf5111 *cdata =
+			&pcal[i].rf5111_info;
 
-	ret = ath5k_eeprom_read_ants(ah, &offset, mode);
-	if (ret)
-		return ret;
+		AR5K_EEPROM_READ(offset++, val);
+		cdata->pcdac_max = ((val >> 10) & AR5K_EEPROM_PCDAC_M);
+		cdata->pcdac_min = ((val >> 4) & AR5K_EEPROM_PCDAC_M);
+		cdata->pwr[0] = ((val << 2) & AR5K_EEPROM_POWER_M);
 
-	AR5K_EEPROM_READ(offset++, val);
-	ee->ee_adc_desired_size[mode]	= (s8)((val >> 8) & 0xff);
-	ee->ee_ob[mode][1]		= (val >> 4) & 0x7;
-	ee->ee_db[mode][1]		= val & 0x7;
+		AR5K_EEPROM_READ(offset++, val);
+		cdata->pwr[0] |= ((val >> 14) & 0x3);
+		cdata->pwr[1] = ((val >> 8) & AR5K_EEPROM_POWER_M);
+		cdata->pwr[2] = ((val >> 2) & AR5K_EEPROM_POWER_M);
+		cdata->pwr[3] = ((val << 4) & AR5K_EEPROM_POWER_M);
 
-	ret = ath5k_eeprom_read_modes(ah, &offset, mode);
-	if (ret)
-		return ret;
+		AR5K_EEPROM_READ(offset++, val);
+		cdata->pwr[3] |= ((val >> 12) & 0xf);
+		cdata->pwr[4] = ((val >> 6) & AR5K_EEPROM_POWER_M);
+		cdata->pwr[5] = (val  & AR5K_EEPROM_POWER_M);
 
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
 		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_cal_pier[mode][0] =
-			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
-		ee->ee_cal_pier[mode][1] =
-			ath5k_eeprom_bin2freq(ah, (val >> 8) & 0xff, mode);
+		cdata->pwr[6] = ((val >> 10) & AR5K_EEPROM_POWER_M);
+		cdata->pwr[7] = ((val >> 4) & AR5K_EEPROM_POWER_M);
+		cdata->pwr[8] = ((val << 2) & AR5K_EEPROM_POWER_M);
 
 		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_cal_pier[mode][2] =
-			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
+		cdata->pwr[8] |= ((val >> 14) & 0x3);
+		cdata->pwr[9] = ((val >> 8) & AR5K_EEPROM_POWER_M);
+		cdata->pwr[10] = ((val >> 2) & AR5K_EEPROM_POWER_M);
+
+		ath5k_get_pcdac_intercepts(ah, cdata->pcdac_min,
+			cdata->pcdac_max, cdata->pcdac);
+
+		for (j = 0; j < AR5K_EEPROM_N_PCDAC; j++) {
+			cdata->pwr[j] = (u16)
+				(AR5K_EEPROM_POWER_STEP * cdata->pwr[j]);
+		}
 	}
 
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
-		ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
+	return 0;
+}
 
-	/*
-	 * Get values for 802.11g (2.4GHz)
-	 */
-	mode = AR5K_EEPROM_MODE_11G;
-	offset = AR5K_EEPROM_MODES_11G(ah->ah_ee_version);
+static int
+ath5k_eeprom_read_pcal_info_5112(struct ath5k_hw *ah, int mode)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	struct ath5k_chan_pcal_info_rf5112 *chan_pcal_info;
+	struct ath5k_chan_pcal_info *gen_chan_info;
+	u32 offset;
+	unsigned int i, c;
+	u16 val;
+	int ret;
 
-	ret = ath5k_eeprom_read_ants(ah, &offset, mode);
-	if (ret)
-		return ret;
+	switch (mode) {
+	case AR5K_EEPROM_MODE_11A:
+		/*
+		 * Read 5GHz EEPROM channels
+		 */
+		offset = AR5K_EEPROM_GROUPS_START(ee->ee_version);
+		ath5k_eeprom_init_11a_pcal_freq(ah, offset);
+
+		offset += AR5K_EEPROM_GROUP2_OFFSET;
+		gen_chan_info = ee->ee_pwr_cal_a;
+		break;
+	case AR5K_EEPROM_MODE_11B:
+		offset = AR5K_EEPROM_GROUPS_START(ee->ee_version);
+		if (AR5K_EEPROM_HDR_11A(ee->ee_header))
+			offset += AR5K_EEPROM_GROUP3_OFFSET;
+
+		/* NB: frequency piers parsed during mode init */
+		gen_chan_info = ee->ee_pwr_cal_b;
+		break;
+	case AR5K_EEPROM_MODE_11G:
+		offset = AR5K_EEPROM_GROUPS_START(ee->ee_version);
+		if (AR5K_EEPROM_HDR_11A(ee->ee_header))
+			offset += AR5K_EEPROM_GROUP4_OFFSET;
+		else if (AR5K_EEPROM_HDR_11B(ee->ee_header))
+			offset += AR5K_EEPROM_GROUP2_OFFSET;
+
+		/* NB: frequency piers parsed during mode init */
+		gen_chan_info = ee->ee_pwr_cal_g;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	AR5K_EEPROM_READ(offset++, val);
-	ee->ee_adc_desired_size[mode]	= (s8)((val >> 8) & 0xff);
-	ee->ee_ob[mode][1]		= (val >> 4) & 0x7;
-	ee->ee_db[mode][1]		= val & 0x7;
+	for (i = 0; i < ee->ee_n_piers[mode]; i++) {
+		chan_pcal_info = &gen_chan_info[i].rf5112_info;
 
-	ret = ath5k_eeprom_read_modes(ah, &offset, mode);
-	if (ret)
-		return ret;
+		/* Power values in dBm * 4
+		 * for the lower xpd gain curve
+		 * (0 dBm -> higher output power) */
+		for (c = 0; c < AR5K_EEPROM_N_XPD0_POINTS; c++) {
+			AR5K_EEPROM_READ(offset++, val);
+			chan_pcal_info->pwr_x0[c] = (val & 0xff);
+			chan_pcal_info->pwr_x0[++c] = ((val >> 8) & 0xff);
+		}
 
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
+		/* PCDAC steps
+		 * corresponding to the above power
+		 * measurements */
+		AR5K_EEPROM_READ(offset++, val);
+		chan_pcal_info->pcdac_x0[1] = (val & 0x1f);
+		chan_pcal_info->pcdac_x0[2] = ((val >> 5) & 0x1f);
+		chan_pcal_info->pcdac_x0[3] = ((val >> 10) & 0x1f);
+
+		/* Power values in dBm * 4
+		 * for the higher xpd gain curve
+		 * (18 dBm -> lower output power) */
 		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_cal_pier[mode][0] =
-			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
-		ee->ee_cal_pier[mode][1] =
-			ath5k_eeprom_bin2freq(ah, (val >> 8) & 0xff, mode);
+		chan_pcal_info->pwr_x3[0] = (val & 0xff);
+		chan_pcal_info->pwr_x3[1] = ((val >> 8) & 0xff);
 
 		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_turbo_max_power[mode] = val & 0x7f;
-		ee->ee_xr_power[mode] = (val >> 7) & 0x3f;
+		chan_pcal_info->pwr_x3[2] = (val & 0xff);
+
+		/* PCDAC steps
+		 * corresponding to the above power
+		 * measurements (static) */
+		chan_pcal_info->pcdac_x3[0] = 20;
+		chan_pcal_info->pcdac_x3[1] = 35;
+		chan_pcal_info->pcdac_x3[2] = 63;
+
+		if (ee->ee_version >= AR5K_EEPROM_VERSION_4_3) {
+			chan_pcal_info->pcdac_x0[0] = ((val >> 8) & 0xff);
+
+			/* Last xpd0 power level is also channel maximum */
+			gen_chan_info[i].max_pwr = chan_pcal_info->pwr_x0[3];
+		} else {
+			chan_pcal_info->pcdac_x0[0] = 1;
+			gen_chan_info[i].max_pwr = ((val >> 8) & 0xff);
+		}
+
+		/* Recreate pcdac_x0 table for this channel using pcdac steps */
+		chan_pcal_info->pcdac_x0[1] += chan_pcal_info->pcdac_x0[0];
+		chan_pcal_info->pcdac_x0[2] += chan_pcal_info->pcdac_x0[1];
+		chan_pcal_info->pcdac_x0[3] += chan_pcal_info->pcdac_x0[2];
+	}
+
+	return 0;
+}
+
+static inline unsigned int
+ath5k_pdgains_size_2413(struct ath5k_eeprom_info *ee, unsigned int mode)
+{
+	static const unsigned int pdgains_size[] = { 4, 6, 9, 12 };
+	unsigned int sz;
+
+	sz = pdgains_size[ee->ee_pd_gains[mode] - 1];
+	sz *= ee->ee_n_piers[mode];
+
+	return sz;
+}
 
+static unsigned int
+ath5k_cal_data_offset_2413(struct ath5k_eeprom_info *ee, int mode)
+{
+	u32 offset = AR5K_EEPROM_CAL_DATA_START(ee->ee_misc4);
+
+	switch(mode) {
+	case AR5K_EEPROM_MODE_11G:
+		if (AR5K_EEPROM_HDR_11B(ee->ee_header))
+			offset += ath5k_pdgains_size_2413(ee, AR5K_EEPROM_MODE_11B) + 2;
+		/* fall through */
+	case AR5K_EEPROM_MODE_11B:
+		if (AR5K_EEPROM_HDR_11A(ee->ee_header))
+			offset += ath5k_pdgains_size_2413(ee, AR5K_EEPROM_MODE_11A) + 5;
+		/* fall through */
+	case AR5K_EEPROM_MODE_11A:
+		break;
+	default:
+		break;
+	}
+
+	return offset;
+}
+
+static int
+ath5k_eeprom_read_pcal_info_2413(struct ath5k_hw *ah, int mode)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	struct ath5k_chan_pcal_info_rf2413 *chan_pcal_info;
+	struct ath5k_chan_pcal_info *gen_chan_info;
+	unsigned int i, c;
+	u32 offset;
+	int ret;
+	u16 val;
+	u8 pd_gains = 0;
+
+	if (ee->ee_x_gain[mode] & 0x1) pd_gains++;
+	if ((ee->ee_x_gain[mode] >> 1) & 0x1) pd_gains++;
+	if ((ee->ee_x_gain[mode] >> 2) & 0x1) pd_gains++;
+	if ((ee->ee_x_gain[mode] >> 3) & 0x1) pd_gains++;
+	ee->ee_pd_gains[mode] = pd_gains;
+
+	offset = ath5k_cal_data_offset_2413(ee, mode);
+	switch (mode) {
+	case AR5K_EEPROM_MODE_11A:
+		if (!AR5K_EEPROM_HDR_11A(ee->ee_header))
+			return 0;
+
+		ath5k_eeprom_init_11a_pcal_freq(ah, offset);
+		offset += AR5K_EEPROM_N_5GHZ_CHAN / 2;
+		gen_chan_info = ee->ee_pwr_cal_a;
+		break;
+	case AR5K_EEPROM_MODE_11B:
+		if (!AR5K_EEPROM_HDR_11B(ee->ee_header))
+			return 0;
+
+		ath5k_eeprom_init_11bg_2413(ah, mode, offset);
+		offset += AR5K_EEPROM_N_2GHZ_CHAN_2413 / 2;
+		gen_chan_info = ee->ee_pwr_cal_b;
+		break;
+	case AR5K_EEPROM_MODE_11G:
+		if (!AR5K_EEPROM_HDR_11G(ee->ee_header))
+			return 0;
+
+		ath5k_eeprom_init_11bg_2413(ah, mode, offset);
+		offset += AR5K_EEPROM_N_2GHZ_CHAN_2413 / 2;
+		gen_chan_info = ee->ee_pwr_cal_g;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (pd_gains == 0)
+		return 0;
+
+	for (i = 0; i < ee->ee_n_piers[mode]; i++) {
+		chan_pcal_info = &gen_chan_info[i].rf2413_info;
+
+		/*
+		 * Read pwr_i, pddac_i and the first
+		 * 2 pd points (pwr, pddac)
+		 */
 		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_cal_pier[mode][2] =
-			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
+		chan_pcal_info->pwr_i[0] = val & 0x1f;
+		chan_pcal_info->pddac_i[0] = (val >> 5) & 0x7f;
+		chan_pcal_info->pwr[0][0] =
+					(val >> 12) & 0xf;
 
-		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
-			ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
+		AR5K_EEPROM_READ(offset++, val);
+		chan_pcal_info->pddac[0][0] = val & 0x3f;
+		chan_pcal_info->pwr[0][1] = (val >> 6) & 0xf;
+		chan_pcal_info->pddac[0][1] =
+					(val >> 10) & 0x3f;
 
 		AR5K_EEPROM_READ(offset++, val);
-		ee->ee_i_cal[mode] = (val >> 8) & 0x3f;
-		ee->ee_q_cal[mode] = (val >> 3) & 0x1f;
+		chan_pcal_info->pwr[0][2] = val & 0xf;
+		chan_pcal_info->pddac[0][2] =
+					(val >> 4) & 0x3f;
+
+		chan_pcal_info->pwr[0][3] = 0;
+		chan_pcal_info->pddac[0][3] = 0;
+
+		if (pd_gains > 1) {
+			/*
+			 * Pd gain 0 is not the last pd gain
+			 * so it only has 2 pd points.
+			 * Continue wih pd gain 1.
+			 */
+			chan_pcal_info->pwr_i[1] = (val >> 10) & 0x1f;
 
-		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_2) {
+			chan_pcal_info->pddac_i[1] = (val >> 15) & 0x1;
 			AR5K_EEPROM_READ(offset++, val);
-			ee->ee_cck_ofdm_gain_delta = val & 0xff;
+			chan_pcal_info->pddac_i[1] |= (val & 0x3F) << 1;
+
+			chan_pcal_info->pwr[1][0] = (val >> 6) & 0xf;
+			chan_pcal_info->pddac[1][0] =
+						(val >> 10) & 0x3f;
+
+			AR5K_EEPROM_READ(offset++, val);
+			chan_pcal_info->pwr[1][1] = val & 0xf;
+			chan_pcal_info->pddac[1][1] =
+						(val >> 4) & 0x3f;
+			chan_pcal_info->pwr[1][2] =
+						(val >> 10) & 0xf;
+
+			chan_pcal_info->pddac[1][2] =
+						(val >> 14) & 0x3;
+			AR5K_EEPROM_READ(offset++, val);
+			chan_pcal_info->pddac[1][2] |=
+						(val & 0xF) << 2;
+
+			chan_pcal_info->pwr[1][3] = 0;
+			chan_pcal_info->pddac[1][3] = 0;
+		} else if (pd_gains == 1) {
+			/*
+			 * Pd gain 0 is the last one so
+			 * read the extra point.
+			 */
+			chan_pcal_info->pwr[0][3] =
+						(val >> 10) & 0xf;
+
+			chan_pcal_info->pddac[0][3] =
+						(val >> 14) & 0x3;
+			AR5K_EEPROM_READ(offset++, val);
+			chan_pcal_info->pddac[0][3] |=
+						(val & 0xF) << 2;
+		}
+
+		/*
+		 * Proceed with the other pd_gains
+		 * as above.
+		 */
+		if (pd_gains > 2) {
+			chan_pcal_info->pwr_i[2] = (val >> 4) & 0x1f;
+			chan_pcal_info->pddac_i[2] = (val >> 9) & 0x7f;
+
+			AR5K_EEPROM_READ(offset++, val);
+			chan_pcal_info->pwr[2][0] =
+						(val >> 0) & 0xf;
+			chan_pcal_info->pddac[2][0] =
+						(val >> 4) & 0x3f;
+			chan_pcal_info->pwr[2][1] =
+						(val >> 10) & 0xf;
+
+			chan_pcal_info->pddac[2][1] =
+						(val >> 14) & 0x3;
+			AR5K_EEPROM_READ(offset++, val);
+			chan_pcal_info->pddac[2][1] |=
+						(val & 0xF) << 2;
+
+			chan_pcal_info->pwr[2][2] =
+						(val >> 4) & 0xf;
+			chan_pcal_info->pddac[2][2] =
+						(val >> 8) & 0x3f;
+
+			chan_pcal_info->pwr[2][3] = 0;
+			chan_pcal_info->pddac[2][3] = 0;
+		} else if (pd_gains == 2) {
+			chan_pcal_info->pwr[1][3] =
+						(val >> 4) & 0xf;
+			chan_pcal_info->pddac[1][3] =
+						(val >> 8) & 0x3f;
+		}
+
+		if (pd_gains > 3) {
+			chan_pcal_info->pwr_i[3] = (val >> 14) & 0x3;
+			AR5K_EEPROM_READ(offset++, val);
+			chan_pcal_info->pwr_i[3] |= ((val >> 0) & 0x7) << 2;
+
+			chan_pcal_info->pddac_i[3] = (val >> 3) & 0x7f;
+			chan_pcal_info->pwr[3][0] =
+						(val >> 10) & 0xf;
+			chan_pcal_info->pddac[3][0] =
+						(val >> 14) & 0x3;
+
+			AR5K_EEPROM_READ(offset++, val);
+			chan_pcal_info->pddac[3][0] |=
+						(val & 0xF) << 2;
+			chan_pcal_info->pwr[3][1] =
+						(val >> 4) & 0xf;
+			chan_pcal_info->pddac[3][1] =
+						(val >> 8) & 0x3f;
+
+			chan_pcal_info->pwr[3][2] =
+						(val >> 14) & 0x3;
+			AR5K_EEPROM_READ(offset++, val);
+			chan_pcal_info->pwr[3][2] |=
+						((val >> 0) & 0x3) << 2;
+
+			chan_pcal_info->pddac[3][2] =
+						(val >> 2) & 0x3f;
+			chan_pcal_info->pwr[3][3] =
+						(val >> 8) & 0xf;
+
+			chan_pcal_info->pddac[3][3] =
+						(val >> 12) & 0xF;
+			AR5K_EEPROM_READ(offset++, val);
+			chan_pcal_info->pddac[3][3] |=
+						((val >> 0) & 0x3) << 4;
+		} else if (pd_gains == 3) {
+			chan_pcal_info->pwr[2][3] =
+						(val >> 14) & 0x3;
+			AR5K_EEPROM_READ(offset++, val);
+			chan_pcal_info->pwr[2][3] |=
+						((val >> 0) & 0x3) << 2;
+
+			chan_pcal_info->pddac[2][3] =
+						(val >> 2) & 0x3f;
+		}
+
+		for (c = 0; c < pd_gains; c++) {
+			/* Recreate pwr table for this channel using pwr steps */
+			chan_pcal_info->pwr[c][0] += chan_pcal_info->pwr_i[c] * 2;
+			chan_pcal_info->pwr[c][1] += chan_pcal_info->pwr[c][0];
+			chan_pcal_info->pwr[c][2] += chan_pcal_info->pwr[c][1];
+			chan_pcal_info->pwr[c][3] += chan_pcal_info->pwr[c][2];
+			if (chan_pcal_info->pwr[c][3] == chan_pcal_info->pwr[c][2])
+				chan_pcal_info->pwr[c][3] = 0;
+
+			/* Recreate pddac table for this channel using pddac steps */
+			chan_pcal_info->pddac[c][0] += chan_pcal_info->pddac_i[c];
+			chan_pcal_info->pddac[c][1] += chan_pcal_info->pddac[c][0];
+			chan_pcal_info->pddac[c][2] += chan_pcal_info->pddac[c][1];
+			chan_pcal_info->pddac[c][3] += chan_pcal_info->pddac[c][2];
+			if (chan_pcal_info->pddac[c][3] == chan_pcal_info->pddac[c][2])
+				chan_pcal_info->pddac[c][3] = 0;
 		}
 	}
 
-	/*
-	 * Read 5GHz EEPROM channels
-	 */
+	return 0;
+}
+
+/*
+ * Read per rate target power (this is the maximum tx power
+ * supported by the card). This info is used when setting
+ * tx power, no matter the channel.
+ *
+ * This also works for v5 EEPROMs.
+ */
+static int ath5k_eeprom_read_target_rate_pwr_info(struct ath5k_hw *ah, unsigned int mode)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	struct ath5k_rate_pcal_info *rate_pcal_info;
+	u16 *rate_target_pwr_num;
+	u32 offset;
+	u16 val;
+	int ret, i;
+
+	offset = AR5K_EEPROM_TARGET_PWRSTART(ee->ee_misc1);
+	rate_target_pwr_num = &ee->ee_rate_target_pwr_num[mode];
+	switch (mode) {
+	case AR5K_EEPROM_MODE_11A:
+		offset += AR5K_EEPROM_TARGET_PWR_OFF_11A(ee->ee_version);
+		rate_pcal_info = ee->ee_rate_tpwr_a;
+		ee->ee_rate_target_pwr_num[mode] = AR5K_EEPROM_N_5GHZ_CHAN;
+		break;
+	case AR5K_EEPROM_MODE_11B:
+		offset += AR5K_EEPROM_TARGET_PWR_OFF_11B(ee->ee_version);
+		rate_pcal_info = ee->ee_rate_tpwr_b;
+		ee->ee_rate_target_pwr_num[mode] = 2; /* 3rd is g mode's 1st */
+		break;
+	case AR5K_EEPROM_MODE_11G:
+		offset += AR5K_EEPROM_TARGET_PWR_OFF_11G(ee->ee_version);
+		rate_pcal_info = ee->ee_rate_tpwr_g;
+		ee->ee_rate_target_pwr_num[mode] = AR5K_EEPROM_N_2GHZ_CHAN;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Different freq mask for older eeproms (<= v3.2) */
+	if (ee->ee_version <= AR5K_EEPROM_VERSION_3_2) {
+		for (i = 0; i < (*rate_target_pwr_num); i++) {
+			AR5K_EEPROM_READ(offset++, val);
+			rate_pcal_info[i].freq =
+			    ath5k_eeprom_bin2freq(ee, (val >> 9) & 0x7f, mode);
+
+			rate_pcal_info[i].target_power_6to24 = ((val >> 3) & 0x3f);
+			rate_pcal_info[i].target_power_36 = (val << 3) & 0x3f;
+
+			AR5K_EEPROM_READ(offset++, val);
+
+			if (rate_pcal_info[i].freq == AR5K_EEPROM_CHANNEL_DIS ||
+			    val == 0) {
+				(*rate_target_pwr_num) = i;
+				break;
+			}
+
+			rate_pcal_info[i].target_power_36 |= ((val >> 13) & 0x7);
+			rate_pcal_info[i].target_power_48 = ((val >> 7) & 0x3f);
+			rate_pcal_info[i].target_power_54 = ((val >> 1) & 0x3f);
+		}
+	} else {
+		for (i = 0; i < (*rate_target_pwr_num); i++) {
+			AR5K_EEPROM_READ(offset++, val);
+			rate_pcal_info[i].freq =
+			    ath5k_eeprom_bin2freq(ee, (val >> 8) & 0xff, mode);
+
+			rate_pcal_info[i].target_power_6to24 = ((val >> 2) & 0x3f);
+			rate_pcal_info[i].target_power_36 = (val << 4) & 0x3f;
+
+			AR5K_EEPROM_READ(offset++, val);
+
+			if (rate_pcal_info[i].freq == AR5K_EEPROM_CHANNEL_DIS ||
+			    val == 0) {
+				(*rate_target_pwr_num) = i;
+				break;
+			}
+
+			rate_pcal_info[i].target_power_36 |= (val >> 12) & 0xf;
+			rate_pcal_info[i].target_power_48 = ((val >> 6) & 0x3f);
+			rate_pcal_info[i].target_power_54 = (val & 0x3f);
+		}
+	}
+
+	return 0;
+}
+
+static int
+ath5k_eeprom_read_pcal_info(struct ath5k_hw *ah)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	int (*read_pcal)(struct ath5k_hw *hw, int mode);
+	int mode;
+	int err;
+
+	if ((ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) &&
+			(AR5K_EEPROM_EEMAP(ee->ee_misc0) == 1))
+		read_pcal = ath5k_eeprom_read_pcal_info_5112;
+	else if ((ah->ah_ee_version >= AR5K_EEPROM_VERSION_5_0) &&
+			(AR5K_EEPROM_EEMAP(ee->ee_misc0) == 2))
+		read_pcal = ath5k_eeprom_read_pcal_info_2413;
+	else
+		read_pcal = ath5k_eeprom_read_pcal_info_5111;
+
+	for (mode = AR5K_EEPROM_MODE_11A; mode <= AR5K_EEPROM_MODE_11G; mode++) {
+		err = read_pcal(ah, mode);
+		if (err)
+			return err;
+
+		err = ath5k_eeprom_read_target_rate_pwr_info(ah, mode);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+/* Read conformance test limits */
+static int
+ath5k_eeprom_read_ctl_info(struct ath5k_hw *ah)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	struct ath5k_edge_power *rep;
+	unsigned int fmask, pmask;
+	unsigned int ctl_mode;
+	int ret, i, j;
+	u32 offset;
+	u16 val;
+
+	pmask = AR5K_EEPROM_POWER_M;
+	fmask = AR5K_EEPROM_FREQ_M(ee->ee_version);
+	offset = AR5K_EEPROM_CTL(ee->ee_version);
+	ee->ee_ctls = AR5K_EEPROM_N_CTLS(ee->ee_version);
+	for (i = 0; i < ee->ee_ctls; i += 2) {
+		AR5K_EEPROM_READ(offset++, val);
+		ee->ee_ctl[i] = (val >> 8) & 0xff;
+		ee->ee_ctl[i + 1] = val & 0xff;
+	}
+
+	offset = AR5K_EEPROM_GROUP8_OFFSET;
+	if (ee->ee_version >= AR5K_EEPROM_VERSION_4_0)
+		offset += AR5K_EEPROM_TARGET_PWRSTART(ee->ee_misc1) -
+			AR5K_EEPROM_GROUP5_OFFSET;
+	else
+		offset += AR5K_EEPROM_GROUPS_START(ee->ee_version);
+
+	rep = ee->ee_ctl_pwr;
+	for(i = 0; i < ee->ee_ctls; i++) {
+		switch(ee->ee_ctl[i] & AR5K_CTL_MODE_M) {
+		case AR5K_CTL_11A:
+		case AR5K_CTL_TURBO:
+			ctl_mode = AR5K_EEPROM_MODE_11A;
+			break;
+		default:
+			ctl_mode = AR5K_EEPROM_MODE_11G;
+			break;
+		}
+		if (ee->ee_ctl[i] == 0) {
+			if (ee->ee_version >= AR5K_EEPROM_VERSION_3_3)
+				offset += 8;
+			else
+				offset += 7;
+			rep += AR5K_EEPROM_N_EDGES;
+			continue;
+		}
+		if (ee->ee_version >= AR5K_EEPROM_VERSION_3_3) {
+			for (j = 0; j < AR5K_EEPROM_N_EDGES; j += 2) {
+				AR5K_EEPROM_READ(offset++, val);
+				rep[j].freq = (val >> 8) & fmask;
+				rep[j + 1].freq = val & fmask;
+			}
+			for (j = 0; j < AR5K_EEPROM_N_EDGES; j += 2) {
+				AR5K_EEPROM_READ(offset++, val);
+				rep[j].edge = (val >> 8) & pmask;
+				rep[j].flag = (val >> 14) & 1;
+				rep[j + 1].edge = val & pmask;
+				rep[j + 1].flag = (val >> 6) & 1;
+			}
+		} else {
+			AR5K_EEPROM_READ(offset++, val);
+			rep[0].freq = (val >> 9) & fmask;
+			rep[1].freq = (val >> 2) & fmask;
+			rep[2].freq = (val << 5) & fmask;
+
+			AR5K_EEPROM_READ(offset++, val);
+			rep[2].freq |= (val >> 11) & 0x1f;
+			rep[3].freq = (val >> 4) & fmask;
+			rep[4].freq = (val << 3) & fmask;
+
+			AR5K_EEPROM_READ(offset++, val);
+			rep[4].freq |= (val >> 13) & 0x7;
+			rep[5].freq = (val >> 6) & fmask;
+			rep[6].freq = (val << 1) & fmask;
+
+			AR5K_EEPROM_READ(offset++, val);
+			rep[6].freq |= (val >> 15) & 0x1;
+			rep[7].freq = (val >> 8) & fmask;
+
+			rep[0].edge = (val >> 2) & pmask;
+			rep[1].edge = (val << 4) & pmask;
+
+			AR5K_EEPROM_READ(offset++, val);
+			rep[1].edge |= (val >> 12) & 0xf;
+			rep[2].edge = (val >> 6) & pmask;
+			rep[3].edge = val & pmask;
+
+			AR5K_EEPROM_READ(offset++, val);
+			rep[4].edge = (val >> 10) & pmask;
+			rep[5].edge = (val >> 4) & pmask;
+			rep[6].edge = (val << 2) & pmask;
+
+			AR5K_EEPROM_READ(offset++, val);
+			rep[6].edge |= (val >> 14) & 0x3;
+			rep[7].edge = (val >> 8) & pmask;
+		}
+		for (j = 0; j < AR5K_EEPROM_N_EDGES; j++) {
+			rep[j].freq = ath5k_eeprom_bin2freq(ee,
+				rep[j].freq, ctl_mode);
+		}
+		rep += AR5K_EEPROM_N_EDGES;
+	}
 
 	return 0;
 }
 
+
+/*
+ * Initialize eeprom power tables
+ */
+int
+ath5k_eeprom_init(struct ath5k_hw *ah)
+{
+	int err;
+
+	err = ath5k_eeprom_init_header(ah);
+	if (err < 0)
+		return err;
+
+	err = ath5k_eeprom_init_modes(ah);
+	if (err < 0)
+		return err;
+
+	err = ath5k_eeprom_read_pcal_info(ah);
+	if (err < 0)
+		return err;
+
+	err = ath5k_eeprom_read_ctl_info(ah);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
 /*
  * Read the MAC address from eeprom
  */
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -821,13 +821,6 @@ struct ath5k_athchan_2ghz {
 		return (false);			\
 } while (0)
 
-enum ath5k_ant_setting {
-	AR5K_ANT_VARIABLE	= 0,	/* variable by programming */
-	AR5K_ANT_FIXED_A	= 1,	/* fixed to 11a frequencies */
-	AR5K_ANT_FIXED_B	= 2,	/* fixed to 11b frequencies */
-	AR5K_ANT_MAX		= 3,
-};
-
 /*
  * Hardware interrupt abstraction
  */
--- a/drivers/net/wireless/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath5k/eeprom.h
@@ -25,24 +25,8 @@
 #define AR5K_EEPROM_MAGIC_5211		0x0000145b /* 5211 */
 #define AR5K_EEPROM_MAGIC_5210		0x0000145a /* 5210 */
 
-#define AR5K_EEPROM_PROTECT		0x003f	/* EEPROM protect status */
-#define AR5K_EEPROM_PROTECT_RD_0_31	0x0001	/* Read protection bit for offsets 0x0 - 0x1f */
-#define AR5K_EEPROM_PROTECT_WR_0_31	0x0002	/* Write protection bit for offsets 0x0 - 0x1f */
-#define AR5K_EEPROM_PROTECT_RD_32_63	0x0004	/* 0x20 - 0x3f */
-#define AR5K_EEPROM_PROTECT_WR_32_63	0x0008
-#define AR5K_EEPROM_PROTECT_RD_64_127	0x0010	/* 0x40 - 0x7f */
-#define AR5K_EEPROM_PROTECT_WR_64_127	0x0020
-#define AR5K_EEPROM_PROTECT_RD_128_191	0x0040	/* 0x80 - 0xbf (regdom) */
-#define AR5K_EEPROM_PROTECT_WR_128_191	0x0080
-#define AR5K_EEPROM_PROTECT_RD_192_207	0x0100	/* 0xc0 - 0xcf */
-#define AR5K_EEPROM_PROTECT_WR_192_207	0x0200
-#define AR5K_EEPROM_PROTECT_RD_208_223	0x0400	/* 0xd0 - 0xdf */
-#define AR5K_EEPROM_PROTECT_WR_208_223	0x0800
-#define AR5K_EEPROM_PROTECT_RD_224_239	0x1000	/* 0xe0 - 0xef */
-#define AR5K_EEPROM_PROTECT_WR_224_239	0x2000
-#define AR5K_EEPROM_PROTECT_RD_240_255	0x4000	/* 0xf0 - 0xff */
-#define AR5K_EEPROM_PROTECT_WR_240_255	0x8000
 #define AR5K_EEPROM_REG_DOMAIN		0x00bf	/* EEPROM regdom */
+#define AR5K_EEPROM_CHECKSUM		0x00c0	/* EEPROM checksum */
 #define AR5K_EEPROM_INFO_BASE		0x00c0	/* EEPROM header */
 #define AR5K_EEPROM_INFO_MAX		(0x400 - AR5K_EEPROM_INFO_BASE)
 #define AR5K_EEPROM_INFO_CKSUM		0xffff
@@ -53,15 +37,19 @@
 #define AR5K_EEPROM_VERSION_3_1		0x3001	/* ob/db values for 2Ghz (ar5211_rfregs) */
 #define AR5K_EEPROM_VERSION_3_2		0x3002	/* different frequency representation (eeprom_bin2freq) */
 #define AR5K_EEPROM_VERSION_3_3		0x3003	/* offsets changed, has 32 CTLs (see below) and ee_false_detect (eeprom_read_modes) */
-#define AR5K_EEPROM_VERSION_3_4		0x3004	/* has ee_i_gain ee_cck_ofdm_power_delta (eeprom_read_modes) */
-#define AR5K_EEPROM_VERSION_4_0		0x4000	/* has ee_misc*, ee_cal_pier, ee_turbo_max_power and ee_xr_power (eeprom_init) */
+#define AR5K_EEPROM_VERSION_3_4		0x3004	/* has ee_i_gain, ee_cck_ofdm_power_delta (eeprom_read_modes) */
+#define AR5K_EEPROM_VERSION_4_0		0x4000	/* has ee_misc, ee_cal_pier, ee_turbo_max_power and ee_xr_power (eeprom_init) */
 #define AR5K_EEPROM_VERSION_4_1		0x4001	/* has ee_margin_tx_rx (eeprom_init) */
 #define AR5K_EEPROM_VERSION_4_2		0x4002	/* has ee_cck_ofdm_gain_delta (eeprom_init) */
-#define AR5K_EEPROM_VERSION_4_3		0x4003
+#define AR5K_EEPROM_VERSION_4_3		0x4003	/* power calibration changes */
 #define AR5K_EEPROM_VERSION_4_4		0x4004
 #define AR5K_EEPROM_VERSION_4_5		0x4005
 #define AR5K_EEPROM_VERSION_4_6		0x4006	/* has ee_scaled_cck_delta */
-#define AR5K_EEPROM_VERSION_4_7		0x4007
+#define AR5K_EEPROM_VERSION_4_7		0x3007	/* 4007 ? */
+#define AR5K_EEPROM_VERSION_4_9		0x4009	/* EAR futureproofing */
+#define AR5K_EEPROM_VERSION_5_0		0x5000	/* Has 2413 PDADC calibration etc */
+#define AR5K_EEPROM_VERSION_5_1		0x5001	/* Has capability values */
+#define AR5K_EEPROM_VERSION_5_3		0x5003	/* Has spur mitigation tables */
 
 #define AR5K_EEPROM_MODE_11A		0
 #define AR5K_EEPROM_MODE_11B		1
@@ -74,8 +62,8 @@
 #define AR5K_EEPROM_HDR_T_2GHZ_DIS(_v)	(((_v) >> 3) & 0x1)	/* Disable turbo for 2Ghz (?) */
 #define AR5K_EEPROM_HDR_T_5GHZ_DBM(_v)	(((_v) >> 4) & 0x7f)	/* Max turbo power for a/XR mode (eeprom_init) */
 #define AR5K_EEPROM_HDR_DEVICE(_v)	(((_v) >> 11) & 0x7)
-#define AR5K_EEPROM_HDR_T_5GHZ_DIS(_v)	(((_v) >> 15) & 0x1)	/* Disable turbo for 5Ghz (?) */
 #define AR5K_EEPROM_HDR_RFKILL(_v)	(((_v) >> 14) & 0x1)	/* Device has RFKill support */
+#define AR5K_EEPROM_HDR_T_5GHZ_DIS(_v)	(((_v) >> 15) & 0x1)	/* Disable turbo for 5Ghz */
 
 #define AR5K_EEPROM_RFKILL_GPIO_SEL	0x0000001c
 #define AR5K_EEPROM_RFKILL_GPIO_SEL_S	2
@@ -87,27 +75,95 @@
 	(((_v) >= AR5K_EEPROM_VERSION_3_3) ? _v3_3 : _v3_0)
 
 #define AR5K_EEPROM_ANT_GAIN(_v)	AR5K_EEPROM_OFF(_v, 0x00c4, 0x00c3)
-#define AR5K_EEPROM_ANT_GAIN_5GHZ(_v)	((int8_t)(((_v) >> 8) & 0xff))
-#define AR5K_EEPROM_ANT_GAIN_2GHZ(_v)	((int8_t)((_v) & 0xff))
+#define AR5K_EEPROM_ANT_GAIN_5GHZ(_v)	((s8)(((_v) >> 8) & 0xff))
+#define AR5K_EEPROM_ANT_GAIN_2GHZ(_v)	((s8)((_v) & 0xff))
+
+/* Misc values available since EEPROM 4.0 */
+#define AR5K_EEPROM_MISC0		AR5K_EEPROM_INFO(4)
+#define AR5K_EEPROM_EARSTART(_v)	((_v) & 0xfff)
+#define AR5K_EEPROM_HDR_XR2_DIS(_v)	(((_v) >> 12) & 0x1)
+#define AR5K_EEPROM_HDR_XR5_DIS(_v)	(((_v) >> 13) & 0x1)
+#define AR5K_EEPROM_EEMAP(_v)		(((_v) >> 14) & 0x3)
+
+#define AR5K_EEPROM_MISC1			AR5K_EEPROM_INFO(5)
+#define AR5K_EEPROM_TARGET_PWRSTART(_v)		((_v) & 0xfff)
+#define AR5K_EEPROM_HAS32KHZCRYSTAL(_v)		(((_v) >> 14) & 0x1)
+#define AR5K_EEPROM_HAS32KHZCRYSTAL_OLD(_v)	(((_v) >> 15) & 0x1)
+
+#define AR5K_EEPROM_MISC2			AR5K_EEPROM_INFO(6)
+#define AR5K_EEPROM_EEP_FILE_VERSION(_v)	(((_v) >> 8) & 0xff)
+#define AR5K_EEPROM_EAR_FILE_VERSION(_v)	((_v) & 0xff)
+
+#define AR5K_EEPROM_MISC3		AR5K_EEPROM_INFO(7)
+#define AR5K_EEPROM_ART_BUILD_NUM(_v)	(((_v) >> 10) & 0x3f)
+#define AR5K_EEPROM_EAR_FILE_ID(_v)	((_v) & 0xff)
+
+#define AR5K_EEPROM_MISC4		AR5K_EEPROM_INFO(8)
+#define AR5K_EEPROM_CAL_DATA_START(_v)	(((_v) >> 4) & 0xfff)
+#define AR5K_EEPROM_MASK_R0(_v)		(((_v) >> 2) & 0x3)
+#define AR5K_EEPROM_MASK_R1(_v)		((_v) & 0x3)
+
+#define AR5K_EEPROM_MISC5		AR5K_EEPROM_INFO(9)
+#define AR5K_EEPROM_COMP_DIS(_v)	((_v) & 0x1)
+#define AR5K_EEPROM_AES_DIS(_v)		(((_v) >> 1) & 0x1)
+#define AR5K_EEPROM_FF_DIS(_v)		(((_v) >> 2) & 0x1)
+#define AR5K_EEPROM_BURST_DIS(_v)	(((_v) >> 3) & 0x1)
+#define AR5K_EEPROM_MAX_QCU(_v)		(((_v) >> 4) & 0xf)
+#define AR5K_EEPROM_HEAVY_CLIP_EN(_v)	(((_v) >> 8) & 0x1)
+#define AR5K_EEPROM_KEY_CACHE_SIZE(_v)	(((_v) >> 12) & 0xf)
+
+#define AR5K_EEPROM_MISC6		AR5K_EEPROM_INFO(10)
+#define AR5K_EEPROM_TX_CHAIN_DIS	((_v) & 0x8)
+#define AR5K_EEPROM_RX_CHAIN_DIS	(((_v) >> 3) & 0x8)
+#define AR5K_EEPROM_FCC_MID_EN		(((_v) >> 6) & 0x1)
+#define AR5K_EEPROM_JAP_U1EVEN_EN	(((_v) >> 7) & 0x1)
+#define AR5K_EEPROM_JAP_U2_EN		(((_v) >> 8) & 0x1)
+#define AR5K_EEPROM_JAP_U1ODD_EN	(((_v) >> 9) & 0x1)
+#define AR5K_EEPROM_JAP_11A_NEW_EN	(((_v) >> 10) & 0x1)
 
 /* calibration settings */
 #define AR5K_EEPROM_MODES_11A(_v)	AR5K_EEPROM_OFF(_v, 0x00c5, 0x00d4)
 #define AR5K_EEPROM_MODES_11B(_v)	AR5K_EEPROM_OFF(_v, 0x00d0, 0x00f2)
 #define AR5K_EEPROM_MODES_11G(_v)	AR5K_EEPROM_OFF(_v, 0x00da, 0x010d)
 #define AR5K_EEPROM_CTL(_v)		AR5K_EEPROM_OFF(_v, 0x00e4, 0x0128)	/* Conformance test limits */
+#define AR5K_EEPROM_GROUPS_START(_v)	AR5K_EEPROM_OFF(_v, 0x0100, 0x0150)	/* Start of Groups */
+#define AR5K_EEPROM_GROUP1_OFFSET	0x0
+#define AR5K_EEPROM_GROUP2_OFFSET	0x5
+#define AR5K_EEPROM_GROUP3_OFFSET	0x37
+#define AR5K_EEPROM_GROUP4_OFFSET	0x46
+#define AR5K_EEPROM_GROUP5_OFFSET	0x55
+#define AR5K_EEPROM_GROUP6_OFFSET	0x65
+#define AR5K_EEPROM_GROUP7_OFFSET	0x69
+#define AR5K_EEPROM_GROUP8_OFFSET	0x6f
+
+#define AR5K_EEPROM_TARGET_PWR_OFF_11A(_v)	AR5K_EEPROM_OFF(_v, AR5K_EEPROM_GROUPS_START(_v) + \
+								AR5K_EEPROM_GROUP5_OFFSET, 0x0000)
+#define AR5K_EEPROM_TARGET_PWR_OFF_11B(_v)	AR5K_EEPROM_OFF(_v, AR5K_EEPROM_GROUPS_START(_v) + \
+								AR5K_EEPROM_GROUP6_OFFSET, 0x0010)
+#define AR5K_EEPROM_TARGET_PWR_OFF_11G(_v)	AR5K_EEPROM_OFF(_v, AR5K_EEPROM_GROUPS_START(_v) + \
+								AR5K_EEPROM_GROUP7_OFFSET, 0x0014)
 
 /* [3.1 - 3.3] */
 #define AR5K_EEPROM_OBDB0_2GHZ		0x00ec
 #define AR5K_EEPROM_OBDB1_2GHZ		0x00ed
 
-/* Misc values available since EEPROM 4.0 */
-#define AR5K_EEPROM_MISC0		0x00c4
-#define AR5K_EEPROM_EARSTART(_v)	((_v) & 0xfff)
-#define AR5K_EEPROM_EEMAP(_v)		(((_v) >> 14) & 0x3)
-#define AR5K_EEPROM_MISC1		0x00c5
-#define AR5K_EEPROM_TARGET_PWRSTART(_v)	((_v) & 0xfff)
-#define AR5K_EEPROM_HAS32KHZCRYSTAL(_v)	(((_v) >> 14) & 0x1)
-
+#define AR5K_EEPROM_PROTECT		0x003f	/* EEPROM protect status */
+#define AR5K_EEPROM_PROTECT_RD_0_31	0x0001	/* Read protection bit for offsets 0x0 - 0x1f */
+#define AR5K_EEPROM_PROTECT_WR_0_31	0x0002	/* Write protection bit for offsets 0x0 - 0x1f */
+#define AR5K_EEPROM_PROTECT_RD_32_63	0x0004	/* 0x20 - 0x3f */
+#define AR5K_EEPROM_PROTECT_WR_32_63	0x0008
+#define AR5K_EEPROM_PROTECT_RD_64_127	0x0010	/* 0x40 - 0x7f */
+#define AR5K_EEPROM_PROTECT_WR_64_127	0x0020
+#define AR5K_EEPROM_PROTECT_RD_128_191	0x0040	/* 0x80 - 0xbf (regdom) */
+#define AR5K_EEPROM_PROTECT_WR_128_191	0x0080
+#define AR5K_EEPROM_PROTECT_RD_192_207	0x0100	/* 0xc0 - 0xcf */
+#define AR5K_EEPROM_PROTECT_WR_192_207	0x0200
+#define AR5K_EEPROM_PROTECT_RD_208_223	0x0400	/* 0xd0 - 0xdf */
+#define AR5K_EEPROM_PROTECT_WR_208_223	0x0800
+#define AR5K_EEPROM_PROTECT_RD_224_239	0x1000	/* 0xe0 - 0xef */
+#define AR5K_EEPROM_PROTECT_WR_224_239	0x2000
+#define AR5K_EEPROM_PROTECT_RD_240_255	0x4000	/* 0xf0 - 0xff */
+#define AR5K_EEPROM_PROTECT_WR_240_255	0x8000
 
 /* Some EEPROM defines */
 #define AR5K_EEPROM_EEP_SCALE		100
@@ -115,8 +171,11 @@
 #define AR5K_EEPROM_N_MODES		3
 #define AR5K_EEPROM_N_5GHZ_CHAN		10
 #define AR5K_EEPROM_N_2GHZ_CHAN		3
+#define AR5K_EEPROM_N_2GHZ_CHAN_2413	4
 #define AR5K_EEPROM_MAX_CHAN		10
+#define AR5K_EEPROM_N_PWR_POINTS_5111	11
 #define AR5K_EEPROM_N_PCDAC		11
+#define AR5K_EEPROM_N_PHASE_CAL		5
 #define AR5K_EEPROM_N_TEST_FREQ		8
 #define AR5K_EEPROM_N_EDGES		8
 #define AR5K_EEPROM_N_INTERCEPTS	11
@@ -136,6 +195,8 @@
 #define AR5K_EEPROM_N_XPD_PER_CHANNEL	4
 #define AR5K_EEPROM_N_XPD0_POINTS	4
 #define AR5K_EEPROM_N_XPD3_POINTS	3
+#define AR5K_EEPROM_N_PD_GAINS		4
+#define AR5K_EEPROM_N_PD_POINTS		5
 #define AR5K_EEPROM_N_INTERCEPT_10_2GHZ	35
 #define AR5K_EEPROM_N_INTERCEPT_10_5GHZ	55
 #define AR5K_EEPROM_POWER_M		0x3f
@@ -158,8 +219,99 @@
 #define AR5K_EEPROM_READ_HDR(_o, _v)					\
 	AR5K_EEPROM_READ(_o, ah->ah_capabilities.cap_eeprom._v);	\
 
-/* Struct to hold EEPROM calibration data */
+enum ath5k_ant_setting {
+	AR5K_ANT_VARIABLE	= 0,	/* variable by programming */
+	AR5K_ANT_FIXED_A	= 1,	/* fixed to 11a frequencies */
+	AR5K_ANT_FIXED_B	= 2,	/* fixed to 11b frequencies */
+	AR5K_ANT_MAX		= 3,
+};
+
+enum ath5k_ctl_mode {
+	AR5K_CTL_11A = 0,
+	AR5K_CTL_11B = 1,
+	AR5K_CTL_11G = 2,
+	AR5K_CTL_TURBO = 3,
+	AR5K_CTL_108G = 4,
+	AR5K_CTL_2GHT20 = 5,
+	AR5K_CTL_5GHT20 = 6,
+	AR5K_CTL_2GHT40 = 7,
+	AR5K_CTL_5GHT40 = 8,
+	AR5K_CTL_MODE_M = 15,
+};
+
+/* Per channel calibration data, used for power table setup */
+struct ath5k_chan_pcal_info_rf5111 {
+	/* Power levels in half dbm units
+	 * for one power curve. */
+	u8		pwr[AR5K_EEPROM_N_PWR_POINTS_5111];
+	/* PCDAC table steps
+	 * for the above values */
+	u8		pcdac[AR5K_EEPROM_N_PWR_POINTS_5111];
+	/* Starting PCDAC step */
+	u8		pcdac_min;
+	/* Final PCDAC step */
+	u8		pcdac_max;
+};
+
+struct ath5k_chan_pcal_info_rf5112 {
+	/* Power levels in quarter dBm units
+	 * for lower (0) and higher (3)
+	 * level curves */
+	s8		pwr_x0[AR5K_EEPROM_N_XPD0_POINTS];
+	s8		pwr_x3[AR5K_EEPROM_N_XPD3_POINTS];
+	/* PCDAC table steps
+	 * for the above values */
+	u8	pcdac_x0[AR5K_EEPROM_N_XPD0_POINTS];
+	u8	pcdac_x3[AR5K_EEPROM_N_XPD3_POINTS];
+};
+
+struct ath5k_chan_pcal_info_rf2413 {
+	/* Starting pwr/pddac values */
+	s8		pwr_i[AR5K_EEPROM_N_PD_GAINS];
+	u8	pddac_i[AR5K_EEPROM_N_PD_GAINS];
+	/* (pwr,pddac) points */
+	s8		pwr[AR5K_EEPROM_N_PD_GAINS]
+				[AR5K_EEPROM_N_PD_POINTS];
+	u8	pddac[AR5K_EEPROM_N_PD_GAINS]
+				[AR5K_EEPROM_N_PD_POINTS];
+};
+
+struct ath5k_chan_pcal_info {
+	/* Frequency */
+	u16	freq;
+	/* Max available power */
+	s8		max_pwr;
+	union {
+		struct ath5k_chan_pcal_info_rf5111 rf5111_info;
+		struct ath5k_chan_pcal_info_rf5112 rf5112_info;
+		struct ath5k_chan_pcal_info_rf2413 rf2413_info;
+	};
+};
+
+/* Per rate calibration data for each mode, used for power table setup */
+struct ath5k_rate_pcal_info {
+	u16	freq; /* Frequency */
+	/* Power level for 6-24Mbit/s rates */
+	u16	target_power_6to24;
+	/* Power level for 36Mbit rate */
+	u16	target_power_36;
+	/* Power level for 48Mbit rate */
+	u16	target_power_48;
+	/* Power level for 54Mbit rate */
+	u16	target_power_54;
+};
+
+/* Power edges for conformance test limits */
+struct ath5k_edge_power {
+	u16 freq;
+	u16 edge; /* in half dBm */
+	bool flag;
+};
+
+/* EEPROM calibration data */
 struct ath5k_eeprom_info {
+
+	/* Header information */
 	u16	ee_magic;
 	u16	ee_protect;
 	u16	ee_regdomain;
@@ -168,6 +320,11 @@ struct ath5k_eeprom_info {
 	u16	ee_ant_gain;
 	u16	ee_misc0;
 	u16	ee_misc1;
+	u16	ee_misc2;
+	u16	ee_misc3;
+	u16	ee_misc4;
+	u16	ee_misc5;
+	u16	ee_misc6;
 	u16	ee_cck_ofdm_gain_delta;
 	u16	ee_cck_ofdm_power_delta;
 	u16	ee_scaled_cck_delta;
@@ -185,7 +342,7 @@ struct ath5k_eeprom_info {
 	u16	ee_turbo_max_power[AR5K_EEPROM_N_MODES];
 	u16	ee_xr_power[AR5K_EEPROM_N_MODES];
 	u16	ee_switch_settling[AR5K_EEPROM_N_MODES];
-	u16	ee_ant_tx_rx[AR5K_EEPROM_N_MODES];
+	u16	ee_atn_tx_rx[AR5K_EEPROM_N_MODES];
 	u16	ee_ant_control[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_PCDAC];
 	u16	ee_ob[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_OBDB];
 	u16	ee_db[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_OBDB];
@@ -198,18 +355,40 @@ struct ath5k_eeprom_info {
 	u16	ee_x_gain[AR5K_EEPROM_N_MODES];
 	u16	ee_i_gain[AR5K_EEPROM_N_MODES];
 	u16	ee_margin_tx_rx[AR5K_EEPROM_N_MODES];
+	u16	ee_switch_settling_turbo[AR5K_EEPROM_N_MODES];
+	u16	ee_margin_tx_rx_turbo[AR5K_EEPROM_N_MODES];
+	u16	ee_atn_tx_rx_turbo[AR5K_EEPROM_N_MODES];
 
-	/* Unused */
+	/* Power calibration data */
 	u16	ee_false_detect[AR5K_EEPROM_N_MODES];
-	u16	ee_cal_pier[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_2GHZ_CHAN];
-	u16	ee_channel[AR5K_EEPROM_N_MODES][AR5K_EEPROM_MAX_CHAN]; /*empty*/
+
+	/* Number of pd gain curves per mode (RF2413) */
+	u8 ee_pd_gains[AR5K_EEPROM_N_MODES];
+
+	u8 ee_n_piers[AR5K_EEPROM_N_MODES];
+	struct ath5k_chan_pcal_info	ee_pwr_cal_a[AR5K_EEPROM_N_5GHZ_CHAN];
+	struct ath5k_chan_pcal_info	ee_pwr_cal_b[AR5K_EEPROM_N_2GHZ_CHAN];
+	struct ath5k_chan_pcal_info	ee_pwr_cal_g[AR5K_EEPROM_N_2GHZ_CHAN];
+
+	/* Per rate target power levels */
+	u16	ee_rate_target_pwr_num[AR5K_EEPROM_N_MODES];
+	struct ath5k_rate_pcal_info	ee_rate_tpwr_a[AR5K_EEPROM_N_5GHZ_CHAN];
+	struct ath5k_rate_pcal_info	ee_rate_tpwr_b[AR5K_EEPROM_N_2GHZ_CHAN];
+	struct ath5k_rate_pcal_info	ee_rate_tpwr_g[AR5K_EEPROM_N_2GHZ_CHAN];
 
 	/* Conformance test limits (Unused) */
 	u16	ee_ctls;
 	u16	ee_ctl[AR5K_EEPROM_MAX_CTLS];
+	struct ath5k_edge_power ee_ctl_pwr[AR5K_EEPROM_N_EDGES * AR5K_EEPROM_MAX_CTLS];
 
 	/* Noise Floor Calibration settings */
 	s16	ee_noise_floor_thr[AR5K_EEPROM_N_MODES];
 	s8	ee_adc_desired_size[AR5K_EEPROM_N_MODES];
 	s8	ee_pga_desired_size[AR5K_EEPROM_N_MODES];
+	s8	ee_adc_desired_size_turbo[AR5K_EEPROM_N_MODES];
+	s8	ee_pga_desired_size_turbo[AR5K_EEPROM_N_MODES];
+	s8	ee_pd_gain_overlap;
+
+	u32	ee_antenna[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
 };
+
--- a/drivers/net/wireless/ath5k/reset.c
+++ b/drivers/net/wireless/ath5k/reset.c
@@ -674,7 +674,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, 
 			(ee->ee_switch_settling[ee_mode] << 7) & 0x3f80,
 			0xffffc07f);
 		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_GAIN,
-			(ee->ee_ant_tx_rx[ee_mode] << 12) & 0x3f000,
+			(ee->ee_atn_tx_rx[ee_mode] << 12) & 0x3f000,
 			0xfffc0fff);
 		AR5K_REG_MASKED_BITS(ah, AR5K_PHY_DESIRED_SIZE,
 			(ee->ee_adc_desired_size[ee_mode] & 0x00ff) |

