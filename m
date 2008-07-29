Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17148 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbYG2Frq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:46 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:46 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, Sujith <Sujith.Manoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 13/16] ath9k: Break down ath9k_regd_init_channels and use helper functions
Date: Mon, 28 Jul 2008 22:47:22 -0700
Message-ID: <7860251c2a757f93a1f48e40c9eb344d7a367585.1217309552.git.lrodriguez@atheros.com> (sfid-20080729_081545_968104_D8A51A0E)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index d2c7109..a3dee36 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -111,10 +111,9 @@ static bool ath9k_regd_is_ccode_valid(struct ath_hal *ah,
 		 __func__, rd);
 
 	if (rd & COUNTRY_ERD_FLAG) {
-
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			 "%s: EEPROM setting is country code %u\n",
-			 __func__, rd & ~COUNTRY_ERD_FLAG);
+			"%s: EEPROM setting is country code %u\n",
+			__func__, rd & ~COUNTRY_ERD_FLAG);
 		return cc == (rd & ~COUNTRY_ERD_FLAG);
 	}
 
@@ -193,8 +192,8 @@ bool ath9k_regd_is_public_safety_sku(struct ath_hal *ah)
 	return false;
 }
 
-static struct country_code_to_enum_rd *ath9k_regd_find_country(u_int16_t
-							       countryCode)
+static struct country_code_to_enum_rd*
+ath9k_regd_find_country(u_int16_t countryCode)
 {
 	int i;
 
@@ -283,7 +282,6 @@ ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
 	}
 
 	if ((regDmn & MULTI_DOMAIN_MASK) == 0) {
-
 		for (i = 0, found = 0;
 		     (i < ARRAY_SIZE(regDomainPairs)) && (!found); i++) {
 			if (regDomainPairs[i].regDmnEnum == regDmn) {
@@ -293,8 +291,8 @@ ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
 		}
 		if (!found) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				 "%s: Failed to find reg domain pair %u\n",
-				 __func__, regDmn);
+				"%s: Failed to find reg domain pair %u\n",
+				__func__, regDmn);
 			return false;
 		}
 		if (!(channelFlag & CHANNEL_2GHZ)) {
@@ -310,8 +308,8 @@ ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
 	found = ath9k_regd_is_valid_reg_domain(regDmn, rd);
 	if (!found) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			 "%s: Failed to find unitary reg domain %u\n",
-			 __func__, regDmn);
+			"%s: Failed to find unitary reg domain %u\n",
+			__func__, regDmn);
 		return false;
 	} else {
 		rd->pscan &= regPair->pscanMask;
@@ -396,6 +394,186 @@ static void ath9k_regd_init_rf_buffer(struct hal_channel_internal *ichans,
 }
 #endif
 
+static bool
+ath9k_regd_add_channel(struct ath_hal *ah,
+		       u_int16_t c,
+		       u_int16_t c_lo,
+		       u_int16_t c_hi,
+		       u_int16_t maxChan,
+		       u_int8_t ctl,
+		       int pos,
+		       struct regDomain rd5GHz,
+		       struct RegDmnFreqBand *fband,
+		       struct regDomain *rd,
+		       const struct cmode *cm,
+		       struct hal_channel_internal *ichans,
+		       bool enableExtendedChannels)
+{
+	struct hal_channel_internal icv;
+
+	if (!(c_lo <= c && c <= c_hi)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+			"%s: c %u out of range [%u..%u]\n",
+			__func__, c, c_lo, c_hi);
+		return false;
+	}
+	if ((fband->channelBW == CHANNEL_HALF_BW) &&
+	    !ah->ah_caps.halChanHalfRate) {
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+			"%s: Skipping %u half rate channel\n",
+			__func__, c);
+		return false;
+	}
+
+	if ((fband->channelBW == CHANNEL_QUARTER_BW) &&
+	    !ah->ah_caps.halChanQuarterRate) {
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+			"%s: Skipping %u quarter rate channel\n",
+			__func__, c);
+		return false;
+	}
+
+	if (((c + fband->channelSep) / 2) > (maxChan + HALF_MAXCHANBW)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+			"%s: c %u > maxChan %u\n",
+			__func__, c, maxChan);
+		return false;
+	}
+
+	if ((fband->usePassScan & IS_ECM_CHAN) && !enableExtendedChannels) {
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+			"Skipping ecm channel\n");
+		return false;
+	}
+
+	if ((rd->flags & NO_HOSTAP) && (ah->ah_opmode == HAL_M_HOSTAP)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+			"Skipping HOSTAP channel\n");
+		return false;
+	}
+
+	if (IS_HT40_MODE(cm->mode) &&
+	    !(ath9k_regd_get_eeprom_reg_ext_bits(ah, REG_EXT_FCC_DFS_HT40)) &&
+	    (fband->useDfs) &&
+	    (rd->conformanceTestLimit != MKK)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+			"Skipping HT40 channel (en_fcc_dfs_ht40 = 0)\n");
+		return false;
+	}
+
+	if (IS_HT40_MODE(cm->mode) &&
+	    !(ath9k_regd_get_eeprom_reg_ext_bits(ah,
+						 REG_EXT_JAPAN_NONDFS_HT40)) &&
+	    !(fband->useDfs) && (rd->conformanceTestLimit == MKK)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+			"Skipping HT40 channel (en_jap_ht40 = 0)\n");
+		return false;
+	}
+
+	if (IS_HT40_MODE(cm->mode) &&
+	    !(ath9k_regd_get_eeprom_reg_ext_bits(ah, REG_EXT_JAPAN_DFS_HT40)) &&
+	    (fband->useDfs) &&
+	    (rd->conformanceTestLimit == MKK)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+			"Skipping HT40 channel (en_jap_dfs_ht40 = 0)\n");
+		return false;
+	}
+
+	memset(&icv, 0, sizeof(icv));
+	icv.channel = c;
+	icv.channelFlags = cm->flags;
+
+	switch (fband->channelBW) {
+	case CHANNEL_HALF_BW:
+		icv.channelFlags |= CHANNEL_HALF;
+		break;
+	case CHANNEL_QUARTER_BW:
+		icv.channelFlags |= CHANNEL_QUARTER;
+		break;
+	}
+
+	icv.maxRegTxPower = fband->powerDfs;
+	icv.antennaMax = fband->antennaMax;
+	icv.regDmnFlags = rd->flags;
+	icv.conformanceTestLimit = ctl;
+	if (fband->usePassScan & rd->pscan)
+		icv.channelFlags |= CHANNEL_PASSIVE;
+	else
+		icv.channelFlags &= ~CHANNEL_PASSIVE;
+	if (fband->useDfs & rd->dfsMask)
+		icv.privFlags = CHANNEL_DFS;
+	else
+		icv.privFlags = 0;
+	if (rd->flags & LIMIT_FRAME_4MS)
+		icv.privFlags |= CHANNEL_4MS_LIMIT;
+	if (icv.privFlags & CHANNEL_DFS)
+		icv.privFlags |= CHANNEL_DISALLOW_ADHOC;
+	if (icv.regDmnFlags & ADHOC_PER_11D)
+		icv.privFlags |= CHANNEL_PER_11D_ADHOC;
+
+	if (icv.channelFlags & CHANNEL_PASSIVE) {
+		if ((icv.channel < 2412) || (icv.channel > 2462)) {
+			if (rd5GHz.regDmnEnum == MKK1 ||
+			    rd5GHz.regDmnEnum == MKK2) {
+				u_int32_t regcap = ah->ah_caps.halRegCap;
+				if (!(regcap &
+				      (AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN |
+				       AR_EEPROM_EEREGCAP_EN_KK_U2 |
+				       AR_EEPROM_EEREGCAP_EN_KK_MIDBAND)) &&
+				    isUNII1OddChan(icv.channel)) {
+					icv.channelFlags &= ~CHANNEL_PASSIVE;
+				} else {
+					icv.privFlags |= CHANNEL_DISALLOW_ADHOC;
+				}
+			} else {
+				icv.privFlags |= CHANNEL_DISALLOW_ADHOC;
+			}
+		}
+	}
+
+	if (cm->mode & (ATH9K_MODE_SEL_11A |
+			ATH9K_MODE_SEL_11NA_HT20 |
+			ATH9K_MODE_SEL_11NA_HT40PLUS |
+			ATH9K_MODE_SEL_11NA_HT40MINUS)) {
+		if (icv.regDmnFlags & (ADHOC_NO_11A | DISALLOW_ADHOC_11A))
+			icv.privFlags |= CHANNEL_DISALLOW_ADHOC;
+	}
+
+	memcpy(&ichans[pos], &icv,
+	       sizeof(struct hal_channel_internal));
+
+	return true;
+}
+
+static bool ath9k_regd_japan_check(struct ath_hal *ah,
+				   int b,
+				   struct regDomain *rd5GHz)
+{
+	bool skipband = false;
+	int i;
+	u_int32_t regcap;
+
+	for (i = 0; i < ARRAY_SIZE(j_bandcheck); i++) {
+		if (j_bandcheck[i].freqbandbit == b) {
+			regcap = ah->ah_caps.halRegCap;
+			if ((j_bandcheck[i].eepromflagtocheck & regcap) == 0) {
+				skipband = true;
+			} else if ((regcap & AR_EEPROM_EEREGCAP_EN_KK_U2) ||
+				  (regcap & AR_EEPROM_EEREGCAP_EN_KK_MIDBAND)) {
+				rd5GHz->dfsMask |= DFS_MKK4;
+				rd5GHz->pscan |= PSCAN_MKK3;
+			}
+			break;
+		}
+	}
+
+	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+		"%s: Skipping %d freq band\n",
+		__func__, j_bandcheck[i].freqbandbit);
+
+	return skipband;
+}
+
 bool
 ath9k_regd_init_channels(struct ath_hal *ah,
 			 struct hal_channel *chans, u_int maxchans,
@@ -412,7 +590,6 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 	struct hal_channel_internal *ichans = &ah->ah_channels[0];
 	int next = 0, b;
 	u_int8_t ctl;
-	int is_quarterchan_cap, is_halfchan_cap;
 	int regdmn;
 	u_int16_t chanSep;
 
@@ -422,31 +599,27 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 		 enableExtendedChannels ? " Enable ecm" : "");
 
 	if (!ath9k_regd_is_ccode_valid(ah, cc)) {
-
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			 "%s: invalid country code %d\n", __func__, cc);
+			"%s: invalid country code %d\n", __func__, cc);
 		return false;
 	}
 
 	if (!ath9k_regd_is_eeprom_valid(ah)) {
-
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			 "%s: invalid EEPROM contents\n", __func__);
+			"%s: invalid EEPROM contents\n", __func__);
 		return false;
 	}
 
 	ah->ah_countryCode = ath9k_regd_get_default_country(ah);
 
 	if (ah->ah_countryCode == CTRY_DEFAULT) {
-
 		ah->ah_countryCode = cc & COUNTRY_CODE_MASK;
-
 		if ((ah->ah_countryCode == CTRY_DEFAULT) &&
 		    (ath9k_regd_get_eepromRD(ah) == CTRY_DEFAULT)) {
-
 			ah->ah_countryCode = CTRY_UNITED_STATES;
 		}
 	}
+
 #ifdef AH_SUPPORT_11D
 	if (ah->ah_countryCode == CTRY_DEFAULT) {
 		regdmn = ath9k_regd_get_eepromRD(ah);
@@ -454,22 +627,19 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 	} else {
 #endif
 		country = ath9k_regd_find_country(ah->ah_countryCode);
-
 		if (country == NULL) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				 "Country is NULL!!!!, cc= %d\n",
-				 ah->ah_countryCode);
+				"Country is NULL!!!!, cc= %d\n",
+				ah->ah_countryCode);
 			return false;
 		} else {
 			regdmn = country->regDmnEnum;
 #ifdef AH_SUPPORT_11D
-			if (((ath9k_regd_get_eepromRD(ah) & WORLD_SKU_MASK)
-			     == WORLD_SKU_PREFIX)
-			    && (cc == CTRY_UNITED_STATES)) {
+			if (((ath9k_regd_get_eepromRD(ah) &
+			      WORLD_SKU_MASK) == WORLD_SKU_PREFIX) &&
+			    (cc == CTRY_UNITED_STATES)) {
 				if (!isWwrSKU_NoMidband(ah)
-				    &&
-				    ath9k_regd_is_fcc_midband_supported
-				    (ah))
+				    && ath9k_regd_is_fcc_midband_supported(ah))
 					regdmn = FCC3_FCCA;
 				else
 					regdmn = FCC1_FCCA;
@@ -479,35 +649,38 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 #ifdef AH_SUPPORT_11D
 	}
 #endif
-
-	if (!ath9k_regd_get_wmode_regdomain
-	    (ah, regdmn, ~CHANNEL_2GHZ, &rd5GHz)) {
+	if (!ath9k_regd_get_wmode_regdomain(ah,
+					    regdmn,
+					    ~CHANNEL_2GHZ,
+					    &rd5GHz)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			"%s: couldn't find unitary "
 			"5GHz reg domain for country %u\n",
-			 __func__, ah->ah_countryCode);
+			__func__, ah->ah_countryCode);
 		return false;
 	}
-	if (!ath9k_regd_get_wmode_regdomain
-	    (ah, regdmn, CHANNEL_2GHZ, &rd2GHz)) {
+	if (!ath9k_regd_get_wmode_regdomain(ah,
+					    regdmn,
+					    CHANNEL_2GHZ,
+					    &rd2GHz)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			"%s: couldn't find unitary 2GHz "
 			"reg domain for country %u\n",
-			 __func__, ah->ah_countryCode);
+			__func__, ah->ah_countryCode);
 		return false;
 	}
 
-	if (!isWwrSKU(ah)
-	    && ((rd5GHz.regDmnEnum == FCC1)
-		|| (rd5GHz.regDmnEnum == FCC2))) {
+	if (!isWwrSKU(ah) && ((rd5GHz.regDmnEnum == FCC1) ||
+			      (rd5GHz.regDmnEnum == FCC2))) {
 		if (ath9k_regd_is_fcc_midband_supported(ah)) {
-
-			if (!ath9k_regd_get_wmode_regdomain
-			    (ah, FCC3_FCCA, ~CHANNEL_2GHZ, &rd5GHz)) {
+			if (!ath9k_regd_get_wmode_regdomain(ah,
+							    FCC3_FCCA,
+							    ~CHANNEL_2GHZ,
+							    &rd5GHz)) {
 				DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 					"%s: couldn't find unitary 5GHz "
 					"reg domain for country %u\n",
-					 __func__, ah->ah_countryCode);
+					__func__, ah->ah_countryCode);
 				return false;
 			}
 		}
@@ -516,9 +689,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 	if (country == NULL) {
 		modesAvail = ah->ah_caps.halWirelessModes;
 	} else {
-		modesAvail =
-		    ath9k_regd_get_wmodes_nreg(ah, country, &rd5GHz);
-
+		modesAvail = ath9k_regd_get_wmodes_nreg(ah, country, &rd5GHz);
 		if (!enableOutdoor)
 			maxChan = country->outdoorChanStart;
 	}
@@ -528,8 +699,6 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 	if (maxchans > ARRAY_SIZE(ah->ah_channels))
 		maxchans = ARRAY_SIZE(ah->ah_channels);
 
-	is_halfchan_cap = ah->ah_caps.halChanHalfRate;
-	is_quarterchan_cap = ah->ah_caps.halChanQuarterRate;
 	for (cm = modes; cm < &modes[ARRAY_SIZE(modes)]; cm++) {
 		u_int16_t c, c_hi, c_lo;
 		u_int64_t *channelBM = NULL;
@@ -539,25 +708,25 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 
 		if ((cm->mode & modeSelect) == 0) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				 "%s: skip mode 0x%x flags 0x%x\n",
-				 __func__, cm->mode, cm->flags);
+				"%s: skip mode 0x%x flags 0x%x\n",
+				__func__, cm->mode, cm->flags);
 			continue;
 		}
 		if ((cm->mode & modesAvail) == 0) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				 "%s: !avail mode 0x%x (0x%x) flags 0x%x\n",
-				 __func__, modesAvail, cm->mode,
-				 cm->flags);
+				"%s: !avail mode 0x%x (0x%x) flags 0x%x\n",
+				__func__, modesAvail, cm->mode,
+				cm->flags);
 			continue;
 		}
 		if (!ath9k_get_channel_edges(ah, cm->flags, &c_lo, &c_hi)) {
-
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 				"%s: channels 0x%x not supported "
 				"by hardware\n",
-				 __func__, cm->flags);
+				__func__, cm->flags);
 			continue;
 		}
+
 		switch (cm->mode) {
 		case ATH9K_MODE_SEL_11A:
 		case ATH9K_MODE_SEL_11NA_HT20:
@@ -585,14 +754,14 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 			break;
 		default:
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				 "%s: Unkonwn HAL mode 0x%x\n", __func__,
-				 cm->mode);
+				"%s: Unknown HAL mode 0x%x\n", __func__,
+				cm->mode);
 			continue;
 		}
+
 		if (ath9k_regd_is_chan_bm_zero(channelBM))
 			continue;
 
-
 		if ((cm->mode == ATH9K_MODE_SEL_11NA_HT40PLUS) ||
 		    (cm->mode == ATH9K_MODE_SEL_11NG_HT40PLUS)) {
 			hi_adj = -20;
@@ -607,57 +776,12 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 		for (b = 0; b < 64 * BMLEN; b++) {
 			if (ath9k_regd_is_bit_set(b, channelBM)) {
 				fband = &freqs[b];
-
-
 				if (rd5GHz.regDmnEnum == MKK1
 				    || rd5GHz.regDmnEnum == MKK2) {
-					int i, skipband = 0;
-					u_int32_t regcap;
-
-					for (i = 0;
-					     i < ARRAY_SIZE(j_bandcheck);
-					     i++) {
-						if (j_bandcheck[i].
-						    freqbandbit == b) {
-							regcap =
-							    ah->ah_caps.
-							    halRegCap;
-							if ((j_bandcheck
-							     [i].
-							     eepromflagtocheck
-							     & regcap) ==
-							    0) {
-								skipband =
-								    1;
-							} else
-							    if ((regcap &
-								 AR_EEPROM_EEREGCAP_EN_KK_U2)
-								|| (regcap
-								    &
-								    AR_EEPROM_EEREGCAP_EN_KK_MIDBAND)) {
-
-								rd5GHz.
-								    dfsMask
-								    |=
-								    DFS_MKK4;
-								rd5GHz.
-								    pscan
-								    |=
-								    PSCAN_MKK3;
-							}
-							break;
-						}
-					}
-					if (skipband) {
-						DPRINTF(ah->ah_sc,
-							 ATH_DBG_REGULATORY,
-							 "%s: Skipping %d "
-							"freq band.\n",
-							 __func__,
-							 j_bandcheck[i].
-							 freqbandbit);
+					if (ath9k_regd_japan_check(ah,
+								   b,
+								   &rd5GHz))
 						continue;
-					}
 				}
 
 				ath9k_regd_add_reg_classid(regclassids,
@@ -666,12 +790,8 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 							   fband->
 							   regClassId);
 
-				if (IS_HT40_MODE(cm->mode)
-				    && (rd == &rd5GHz)) {
-
+				if (IS_HT40_MODE(cm->mode) && (rd == &rd5GHz)) {
 					chanSep = 40;
-
-
 					if (fband->lowChannel == 5280)
 						low_adj += 20;
 
@@ -681,252 +801,48 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					chanSep = fband->channelSep;
 
 				for (c = fband->lowChannel + low_adj;
-				     ((c <= (fband->highChannel + hi_adj))
-				      && (c >=
-					  (fband->lowChannel + low_adj)));
+				     ((c <= (fband->highChannel + hi_adj)) &&
+				      (c >= (fband->lowChannel + low_adj)));
 				     c += chanSep) {
-					struct hal_channel_internal icv;
-
-					if (!(c_lo <= c && c <= c_hi)) {
-						DPRINTF(ah->ah_sc,
-							 ATH_DBG_REGULATORY,
-							"%s: c %u out of "
-							"range [%u..%u]\n",
-							 __func__, c, c_lo,
-							 c_hi);
-						continue;
-					}
-					if ((fband->channelBW ==
-					     CHANNEL_HALF_BW) &&
-					    !is_halfchan_cap) {
-						DPRINTF(ah->ah_sc,
-							 ATH_DBG_REGULATORY,
-							 "%s: Skipping %u half "
-							"rate channel\n",
-							 __func__, c);
-						continue;
-					}
-
-					if ((fband->channelBW ==
-					     CHANNEL_QUARTER_BW) &&
-					    !is_quarterchan_cap) {
-						DPRINTF(ah->ah_sc,
-							 ATH_DBG_REGULATORY,
-							"%s: Skipping %u "
-							"quarter rate "
-							"channel\n",
-							 __func__, c);
-						continue;
-					}
-
-					if (((c + fband->channelSep) / 2) >
-					    (maxChan + HALF_MAXCHANBW)) {
-						DPRINTF(ah->ah_sc,
-							ATH_DBG_REGULATORY,
-							"%s: c %u > "
-							"maxChan %u\n",
-							__func__, c,
-							 maxChan);
-						continue;
-					}
 					if (next >= maxchans) {
 						DPRINTF(ah->ah_sc,
-							 ATH_DBG_REGULATORY,
-							"%s: too many "
-							"channels for channel "
-							"table\n",
-							 __func__);
+							ATH_DBG_REGULATORY,
+							"%s: too many channels "
+							"for channel table\n",
+							__func__);
 						goto done;
 					}
-					if ((fband->
-					     usePassScan & IS_ECM_CHAN)
-					    && !enableExtendedChannels) {
-						DPRINTF(ah->ah_sc,
-							 ATH_DBG_REGULATORY,
-							"Skipping ecm "
-							"channel\n");
-						continue;
-					}
-					if ((rd->flags & NO_HOSTAP) &&
-					    (ah->ah_opmode ==
-					     HAL_M_HOSTAP)) {
-						DPRINTF(ah->ah_sc,
-							 ATH_DBG_REGULATORY,
-							"Skipping HOSTAP "
-							"channel\n");
-						continue;
-					}
-					if (IS_HT40_MODE(cm->mode) &&
-					    !
-					    (ath9k_regd_get_eeprom_reg_ext_bits
-					     (ah, REG_EXT_FCC_DFS_HT40))
-					    && (fband->useDfs)
-					    && (rd->conformanceTestLimit !=
-						MKK)) {
-
-						DPRINTF(ah->ah_sc,
-							 ATH_DBG_REGULATORY,
-							"Skipping HT40 "
-							"channel "
-							"(en_fcc_dfs_ht40 = "
-							"0)\n");
-						continue;
-					}
-					if (IS_HT40_MODE(cm->mode) &&
-					    !
-					    (ath9k_regd_get_eeprom_reg_ext_bits
-					     (ah,
-					      REG_EXT_JAPAN_NONDFS_HT40))
-					    && !(fband->useDfs)
-					    && (rd->conformanceTestLimit ==
-						MKK)) {
-						DPRINTF(ah->ah_sc,
-							 ATH_DBG_REGULATORY,
-							"Skipping HT40 "
-							"channel (en_jap_ht40 "
-							"= 0)\n");
-						continue;
-					}
-					if (IS_HT40_MODE(cm->mode) &&
-					    !
-					    (ath9k_regd_get_eeprom_reg_ext_bits
-					     (ah, REG_EXT_JAPAN_DFS_HT40))
-					    && (fband->useDfs)
-					    && (rd->conformanceTestLimit ==
-						MKK)) {
-						DPRINTF(ah->ah_sc,
-							 ATH_DBG_REGULATORY,
-							"Skipping HT40 channel"
-							" (en_jap_dfs_ht40 = "
-							"0)\n");
-						continue;
-					}
-					memset(&icv, 0, sizeof(icv));
-					icv.channel = c;
-					icv.channelFlags = cm->flags;
-
-					switch (fband->channelBW) {
-					case CHANNEL_HALF_BW:
-						icv.channelFlags |=
-						    CHANNEL_HALF;
-						break;
-					case CHANNEL_QUARTER_BW:
-						icv.channelFlags |=
-						    CHANNEL_QUARTER;
-						break;
-					}
-
-					icv.maxRegTxPower =
-					    fband->powerDfs;
-					icv.antennaMax = fband->antennaMax;
-					icv.regDmnFlags = rd->flags;
-					icv.conformanceTestLimit = ctl;
-					if (fband->usePassScan & rd->pscan)
-						icv.channelFlags |=
-						    CHANNEL_PASSIVE;
-					else
-						icv.channelFlags &=
-						    ~CHANNEL_PASSIVE;
-					if (fband->useDfs & rd->dfsMask)
-						icv.privFlags =
-						    CHANNEL_DFS;
-					else
-						icv.privFlags = 0;
-					if (rd->flags & LIMIT_FRAME_4MS)
-						icv.privFlags |=
-						    CHANNEL_4MS_LIMIT;
-
-					if (icv.privFlags & CHANNEL_DFS) {
-						icv.privFlags |=
-						    CHANNEL_DISALLOW_ADHOC;
-					}
-					if (icv.
-					    regDmnFlags & ADHOC_PER_11D) {
-						icv.privFlags |=
-						    CHANNEL_PER_11D_ADHOC;
-					}
-					if (icv.
-					    channelFlags & CHANNEL_PASSIVE) {
-
-						if ((icv.channel < 2412)
-						    || (icv.channel >
-							2462)) {
-							if (rd5GHz.
-							    regDmnEnum ==
-							    MKK1
-							    || rd5GHz.
-							    regDmnEnum ==
-							    MKK2) {
-								u_int32_t
-								    regcap
-								    =
-								    ah->
-								    ah_caps.
-								    halRegCap;
-								if (!
-								    (regcap
-								     &
-								     (AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN
-								      |
-								      AR_EEPROM_EEREGCAP_EN_KK_U2
-								      |
-								      AR_EEPROM_EEREGCAP_EN_KK_MIDBAND))
-&& isUNII1OddChan(icv.channel)) {
-
-									icv.channelFlags &= ~CHANNEL_PASSIVE;
-								} else {
-									icv.privFlags |= CHANNEL_DISALLOW_ADHOC;
-								}
-							} else {
-								icv.privFlags |= CHANNEL_DISALLOW_ADHOC;
-							}
-						}
-					}
-					if (cm->
-					    mode & (ATH9K_MODE_SEL_11A |
-						    ATH9K_MODE_SEL_11NA_HT20
-						    |
-						    ATH9K_MODE_SEL_11NA_HT40PLUS
-						    |
-						    ATH9K_MODE_SEL_11NA_HT40MINUS)) {
-						if (icv.
-						    regDmnFlags &
-						    (ADHOC_NO_11A |
-						     DISALLOW_ADHOC_11A)) {
-							icv.privFlags |=
-							    CHANNEL_DISALLOW_ADHOC;
-						}
-					}
-
-					memcpy(&ichans[next++], &icv,
-					       sizeof(struct
-						      hal_channel_internal));
+					if (ath9k_regd_add_channel(ah,
+						   c, c_lo, c_hi,
+						   maxChan, ctl,
+						   next,
+						   rd5GHz,
+						   fband, rd, cm,
+						   ichans,
+						   enableExtendedChannels))
+						next++;
 				}
-
-				if (IS_HT40_MODE(cm->mode)
-				    && (fband->lowChannel == 5280)) {
+				if (IS_HT40_MODE(cm->mode) &&
+				    (fband->lowChannel == 5280)) {
 					low_adj -= 20;
 				}
 			}
 		}
 	}
 done:
-      if (next != 0) {
+	if (next != 0) {
 		int i;
 
-
 		if (next > ARRAY_SIZE(ah->ah_channels)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				 "%s: too many channels %u; truncating to %u\n",
-				 __func__, next,
-				 (int) ARRAY_SIZE(ah->ah_channels));
+				"%s: too many channels %u; truncating to %u\n",
+				__func__, next,
+				(int) ARRAY_SIZE(ah->ah_channels));
 			next = ARRAY_SIZE(ah->ah_channels);
 		}
 #ifdef ATH_NF_PER_CHAN
-
 		ath9k_regd_init_rf_buffer(ichans, next);
 #endif
-
 		ath9k_regd_sort(ichans, next,
 				sizeof(struct hal_channel_internal),
 				ath9k_regd_chansort);
@@ -935,9 +851,9 @@ done:
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "Channel list:\n");
 		for (i = 0; i < next; i++) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				 "chan: %d flags: 0x%x\n",
-				 ichans[i].channel,
-				 ichans[i].channelFlags);
+				"chan: %d flags: 0x%x\n",
+				ichans[i].channel,
+				ichans[i].channelFlags);
 			chans[i].channel = ichans[i].channel;
 			chans[i].channelFlags = ichans[i].channelFlags;
 			chans[i].privFlags = ichans[i].privFlags;
@@ -964,11 +880,13 @@ done:
 		ah->ah_iso[0] = country->isoName[0];
 		ah->ah_iso[1] = country->isoName[1];
 	}
+
 	return next != 0;
 }
 
-struct hal_channel_internal *ath9k_regd_check_channel(struct ath_hal *ah,
-	const struct hal_channel *c)
+struct hal_channel_internal*
+ath9k_regd_check_channel(struct ath_hal *ah,
+			 const struct hal_channel *c)
 {
 	struct hal_channel_internal *base, *cc;
 
@@ -976,8 +894,8 @@ struct hal_channel_internal *ath9k_regd_check_channel(struct ath_hal *ah,
 	int n, lim;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-		 "%s: channel %u/0x%x (0x%x) requested\n", __func__,
-		 c->channel, c->channelFlags, flags);
+		"%s: channel %u/0x%x (0x%x) requested\n", __func__,
+		c->channel, c->channelFlags, flags);
 
 	cc = ah->ah_curchan;
 	if (cc != NULL && cc->channel == c->channel &&
@@ -998,8 +916,8 @@ struct hal_channel_internal *ath9k_regd_check_channel(struct ath_hal *ah,
 		d = c->channel - cc->channel;
 		if (d == 0) {
 			if ((cc->channelFlags & CHAN_FLAGS) == flags) {
-				if ((cc->privFlags & CHANNEL_INTERFERENCE)
-				    && (cc->privFlags & CHANNEL_DFS))
+				if ((cc->privFlags & CHANNEL_INTERFERENCE) &&
+				    (cc->privFlags & CHANNEL_DFS))
 					return NULL;
 				else
 					return cc;
@@ -1007,15 +925,15 @@ struct hal_channel_internal *ath9k_regd_check_channel(struct ath_hal *ah,
 			d = flags - (cc->channelFlags & CHAN_FLAGS);
 		}
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			 "%s: channel %u/0x%x d %d\n", __func__,
-			 cc->channel, cc->channelFlags, d);
+			"%s: channel %u/0x%x d %d\n", __func__,
+			cc->channel, cc->channelFlags, d);
 		if (d > 0) {
 			base = cc + 1;
 			lim--;
 		}
 	}
 	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "%s: no match for %u/0x%x\n",
-		 __func__, c->channel, c->channelFlags);
+		__func__, c->channel, c->channelFlags);
 	return NULL;
 }
 
-- 
1.5.4.3

