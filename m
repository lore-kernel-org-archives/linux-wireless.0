Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55505 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaKTNbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 08:31:46 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so8720796wiw.13
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2014 05:31:44 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: [RFC 2/3] ath9k: add TX power per-rate per-chain tables
Date: Thu, 20 Nov 2014 14:31:39 +0100
Message-Id: <1416490300-6451-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141120_143156_395575_0D75C9A8)
In-Reply-To: <1416490300-6451-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1416490300-6451-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add TX power per-rate per-chain tables for different MIMO modes (e.g STBC) in
order to cap the maximum TX power value per-rate in the TX descriptor path.
Cap TX power for self generated frames (ACK, RTS/CTS).
Currently TPC is supported just by AR9003 based chips

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  67 +++++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |   5 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 281 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h            |   6 +
 drivers/net/wireless/ath/ath9k/reg.h           |   2 +
 5 files changed, 358 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 96d7538..8acabcd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4377,6 +4377,25 @@ static u8 ar9003_hw_eeprom_get_cck_tgt_pwr(struct ath_hw *ah,
 						 targetPowerArray, numPiers);
 }
 
+static void ar9003_hw_selfgen_tpc_txpower(struct ath_hw *ah,
+					  struct ath9k_channel *chan,
+					  u8 *pwr_array)
+{
+	u32 val;
+
+	/* target power values for self generated frames (ACK,RTS/CTS) */
+	if (IS_CHAN_2GHZ(chan)) {
+		val = SM(pwr_array[ALL_TARGET_LEGACY_1L_5L], AR_TPC_ACK) |
+		      SM(pwr_array[ALL_TARGET_LEGACY_1L_5L], AR_TPC_CTS) |
+		      SM(0x3f, AR_TPC_CHIRP) | SM(0x3f, AR_TPC_RPT);
+	} else {
+		val = SM(pwr_array[ALL_TARGET_LEGACY_6_24], AR_TPC_ACK) |
+		      SM(pwr_array[ALL_TARGET_LEGACY_6_24], AR_TPC_CTS) |
+		      SM(0x3f, AR_TPC_CHIRP) | SM(0x3f, AR_TPC_RPT);
+	}
+	REG_WRITE(ah, AR_TPC, val);
+}
+
 /* Set tx power registers to array of values passed in */
 static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 {
@@ -5089,7 +5108,7 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
 					       struct ath9k_channel *chan,
 					       u8 *pPwrArray, u16 cfgCtl,
 					       u8 antenna_reduction,
-					       u16 powerLimit)
+					       u16 powerLimit, u8 chainmask)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ar9300_eeprom *pEepData = &ah->eeprom.ar9300_eep;
@@ -5115,7 +5134,7 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 	scaledPower = ath9k_hw_get_scaled_power(ah, powerLimit,
 						antenna_reduction,
-						ah->txchainmask);
+						chainmask);
 
 	if (is2ghz) {
 		/* Setup for CTL modes */
@@ -5313,6 +5332,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 	struct ar9300_modal_eep_header *modal_hdr;
 	u8 targetPowerValT2[ar9300RateSize];
 	u8 target_power_val_t2_eep[ar9300RateSize];
+	u8 targetPowerValT2_tpc[ar9300RateSize];
 	unsigned int i = 0, paprd_scale_factor = 0;
 	u8 pwr_idx, min_pwridx = 0;
 
@@ -5359,10 +5379,13 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 		       sizeof(targetPowerValT2));
 	}
 
+	memcpy(targetPowerValT2_tpc, targetPowerValT2,
+	       sizeof(targetPowerValT2));
+
 	ar9003_hw_set_power_per_rate_table(ah, chan,
 					   targetPowerValT2, cfgCtl,
 					   twiceAntennaReduction,
-					   powerLimit);
+					   powerLimit, ah->txchainmask);
 
 	if (ar9003_is_paprd_enabled(ah)) {
 		for (i = 0; i < ar9300RateSize; i++) {
@@ -5397,6 +5420,44 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 	ar9003_hw_tx_power_regwrite(ah, targetPowerValT2);
 	ar9003_hw_calibration_apply(ah, chan->channel);
 	ar9003_paprd_set_txpower(ah, chan, targetPowerValT2);
+
+	ar9003_hw_selfgen_tpc_txpower(ah, chan, targetPowerValT2);
+
+	/* TPC initializations */
+	if (ah->tpc_enabled) {
+		u32 val;
+		u8 chainmask[] = {
+			AR9300_1_CHAINMASK,
+			AR9300_2LOHI_CHAINMASK,
+			AR9300_3_CHAINMASK
+		};
+		for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+			memcpy(targetPowerValT2, targetPowerValT2_tpc,
+			       sizeof(targetPowerValT2));
+			ar9003_hw_set_power_per_rate_table(ah, chan,
+							   targetPowerValT2,
+							   cfgCtl,
+							   twiceAntennaReduction,
+							   powerLimit,
+							   chainmask[i]);
+			ar9003_hw_init_rate_txpower(ah, targetPowerValT2,
+						    chan, chainmask[i]);
+		}
+		/* Enable TPC */
+		REG_WRITE(ah, AR_PHY_PWRTX_MAX,
+			  AR_PHY_POWER_TX_RATE_MAX_TPC_ENABLE);
+		/* Disable per chain power reduction */
+		val = REG_READ(ah, AR_PHY_POWER_TX_SUB);
+		if (AR_SREV_9340(ah))
+			REG_WRITE(ah, AR_PHY_POWER_TX_SUB,
+				  val & 0xFFFFFFC0);
+		else
+			REG_WRITE(ah, AR_PHY_POWER_TX_SUB,
+				  val & 0xFFFFF000);
+	} else {
+		/* Disable TPC */
+		REG_WRITE(ah, AR_PHY_PWRTX_MAX, 0);
+	}
 }
 
 static u16 ath9k_hw_ar9300_get_spur_channel(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 694ca2e..02bcc85 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -46,6 +46,11 @@
 #define AR9300_ANT_16S               25
 #define AR9300_FUTURE_MODAL_SZ       6
 
+#define AR9300_1_CHAINMASK		1
+#define AR9300_2LOMID_CHAINMASK		3
+#define AR9300_2LOHI_CHAINMASK		5
+#define AR9300_3_CHAINMASK		7
+
 #define AR9300_PAPRD_RATE_MASK		0x01ffffff
 #define AR9300_PAPRD_SCALE_1		0x0e000000
 #define AR9300_PAPRD_SCALE_1_S		25
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 2df6d2e..9f1445e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -18,6 +18,21 @@
 #include "hw.h"
 #include "ar9003_phy.h"
 
+#define AR9300_OFDM_RATES	8
+#define AR9300_HT_SS_RATES	8
+#define AR9300_HT_DS_RATES	8
+#define AR9300_HT_TS_RATES	8
+
+#define AR9300_11NA_OFDM_SHIFT		0
+#define AR9300_11NA_HT_SS_SHIFT		8
+#define AR9300_11NA_HT_DS_SHIFT		16
+#define AR9300_11NA_HT_TS_SHIFT		24
+
+#define AR9300_11NG_OFDM_SHIFT		4
+#define AR9300_11NG_HT_SS_SHIFT		12
+#define AR9300_11NG_HT_DS_SHIFT		20
+#define AR9300_11NG_HT_TS_SHIFT		28
+
 static const int firstep_table[] =
 /* level:  0   1   2   3   4   5   6   7   8  */
 	{ -4, -2,  0,  2,  4,  6,  8, 10, 12 }; /* lvl 0-8, default 2 */
@@ -40,6 +55,71 @@ static const int m2ThreshLowExt_off = 127;
 static const int m1ThreshExt_off = 127;
 static const int m2ThreshExt_off = 127;
 
+static const u8 ofdm2pwr[] = {
+	ALL_TARGET_LEGACY_6_24,
+	ALL_TARGET_LEGACY_6_24,
+	ALL_TARGET_LEGACY_6_24,
+	ALL_TARGET_LEGACY_6_24,
+	ALL_TARGET_LEGACY_6_24,
+	ALL_TARGET_LEGACY_36,
+	ALL_TARGET_LEGACY_48,
+	ALL_TARGET_LEGACY_54
+};
+
+static const u8 mcs2pwr_ht20[] = {
+	ALL_TARGET_HT20_0_8_16,
+	ALL_TARGET_HT20_1_3_9_11_17_19,
+	ALL_TARGET_HT20_1_3_9_11_17_19,
+	ALL_TARGET_HT20_1_3_9_11_17_19,
+	ALL_TARGET_HT20_4,
+	ALL_TARGET_HT20_5,
+	ALL_TARGET_HT20_6,
+	ALL_TARGET_HT20_7,
+	ALL_TARGET_HT20_0_8_16,
+	ALL_TARGET_HT20_1_3_9_11_17_19,
+	ALL_TARGET_HT20_1_3_9_11_17_19,
+	ALL_TARGET_HT20_1_3_9_11_17_19,
+	ALL_TARGET_HT20_12,
+	ALL_TARGET_HT20_13,
+	ALL_TARGET_HT20_14,
+	ALL_TARGET_HT20_15,
+	ALL_TARGET_HT20_0_8_16,
+	ALL_TARGET_HT20_1_3_9_11_17_19,
+	ALL_TARGET_HT20_1_3_9_11_17_19,
+	ALL_TARGET_HT20_1_3_9_11_17_19,
+	ALL_TARGET_HT20_20,
+	ALL_TARGET_HT20_21,
+	ALL_TARGET_HT20_22,
+	ALL_TARGET_HT20_23
+};
+
+static const u8 mcs2pwr_ht40[] = {
+	ALL_TARGET_HT40_0_8_16,
+	ALL_TARGET_HT40_1_3_9_11_17_19,
+	ALL_TARGET_HT40_1_3_9_11_17_19,
+	ALL_TARGET_HT40_1_3_9_11_17_19,
+	ALL_TARGET_HT40_4,
+	ALL_TARGET_HT40_5,
+	ALL_TARGET_HT40_6,
+	ALL_TARGET_HT40_7,
+	ALL_TARGET_HT40_0_8_16,
+	ALL_TARGET_HT40_1_3_9_11_17_19,
+	ALL_TARGET_HT40_1_3_9_11_17_19,
+	ALL_TARGET_HT40_1_3_9_11_17_19,
+	ALL_TARGET_HT40_12,
+	ALL_TARGET_HT40_13,
+	ALL_TARGET_HT40_14,
+	ALL_TARGET_HT40_15,
+	ALL_TARGET_HT40_0_8_16,
+	ALL_TARGET_HT40_1_3_9_11_17_19,
+	ALL_TARGET_HT40_1_3_9_11_17_19,
+	ALL_TARGET_HT40_1_3_9_11_17_19,
+	ALL_TARGET_HT40_20,
+	ALL_TARGET_HT40_21,
+	ALL_TARGET_HT40_22,
+	ALL_TARGET_HT40_23,
+};
+
 /**
  * ar9003_hw_set_channel - set channel on single-chip device
  * @ah: atheros hardware structure
@@ -1799,6 +1879,207 @@ static void ar9003_hw_tx99_set_txpower(struct ath_hw *ah, u8 txpower)
 		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_14],  0));
 }
 
+static void ar9003_hw_init_txpower_cck(struct ath_hw *ah, u8 *rate_array)
+{
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		ah->tx_power[0][i] = rate_array[ALL_TARGET_LEGACY_1L_5L];
+		ah->tx_power[1][i] = rate_array[ALL_TARGET_LEGACY_1L_5L];
+		ah->tx_power[2][i] = min(rate_array[ALL_TARGET_LEGACY_1L_5L],
+					 rate_array[ALL_TARGET_LEGACY_5S]);
+		ah->tx_power[3][i] = min(rate_array[ALL_TARGET_LEGACY_11L],
+					 rate_array[ALL_TARGET_LEGACY_11S]);
+	}
+}
+
+static void ar9003_hw_init_txpower_ofdm(struct ath_hw *ah, u8 *rate_array,
+					int offset, u8 chainmask)
+{
+	int i, j;
+
+	for (i = offset; i < offset + AR9300_OFDM_RATES; i++) {
+		/* OFDM rate to power table idx */
+		j = ofdm2pwr[i - offset];
+		switch (chainmask) {
+		case AR9300_1_CHAINMASK:
+			ah->tx_power[i][0] = rate_array[j];
+			break;
+		case AR9300_2LOMID_CHAINMASK:
+		case AR9300_2LOHI_CHAINMASK:
+			ah->tx_power[i][1] = rate_array[j];
+			break;
+		case AR9300_3_CHAINMASK:
+			ah->tx_power[i][2] = rate_array[j];
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void ar9003_hw_init_txpower_ht(struct ath_hw *ah, u8 *rate_array,
+				      int ss_offset, int ds_offset,
+				      int ts_offset, u8 chainmask, bool is_40)
+{
+	int i, j, mcs_idx = 0;
+	const u8 *mcs2pwr = (is_40) ? mcs2pwr_ht40 : mcs2pwr_ht20;
+
+	for (i = ss_offset; i < ss_offset + AR9300_HT_SS_RATES; i++) {
+		j = mcs2pwr[mcs_idx];
+		switch (chainmask) {
+		case AR9300_1_CHAINMASK:
+			ah->tx_power[i][0] = rate_array[j];
+			break;
+		case AR9300_2LOMID_CHAINMASK:
+		case AR9300_2LOHI_CHAINMASK:
+			ah->tx_power[i][1] = rate_array[j];
+			break;
+		case AR9300_3_CHAINMASK:
+			ah->tx_power[i][2] = rate_array[j];
+			break;
+		default:
+			break;
+		}
+		mcs_idx++;
+	}
+
+	for (i = ds_offset; i < ds_offset + AR9300_HT_DS_RATES; i++) {
+		j = mcs2pwr[mcs_idx];
+		switch (chainmask) {
+		case AR9300_1_CHAINMASK:
+			ah->tx_power[i][0] = rate_array[j];
+			break;
+		case AR9300_2LOMID_CHAINMASK:
+		case AR9300_2LOHI_CHAINMASK:
+			ah->tx_power[i][1] = rate_array[j];
+			break;
+		case AR9300_3_CHAINMASK:
+			ah->tx_power[i][2] = rate_array[j];
+			break;
+		default:
+			break;
+		}
+		mcs_idx++;
+	}
+
+	for (i = ts_offset; i < ts_offset + AR9300_HT_TS_RATES; i++) {
+		j = mcs2pwr[mcs_idx];
+		switch (chainmask) {
+		case AR9300_1_CHAINMASK:
+			ah->tx_power[i][0] = rate_array[j];
+			break;
+		case AR9300_2LOMID_CHAINMASK:
+		case AR9300_2LOHI_CHAINMASK:
+			ah->tx_power[i][1] = rate_array[j];
+			break;
+		case AR9300_3_CHAINMASK:
+			ah->tx_power[i][2] = rate_array[j];
+			break;
+		default:
+			break;
+		}
+		mcs_idx++;
+	}
+}
+
+static void ar9003_hw_init_txpower_stbc(struct ath_hw *ah, u8 chainmask,
+					int ss_offset, int ds_offset,
+					int ts_offset)
+{
+	int i;
+
+	for (i = ss_offset; i < ss_offset + AR9300_HT_SS_RATES; i++) {
+		switch (chainmask) {
+		case AR9300_1_CHAINMASK:
+			ah->tx_power_stbc[i][0] = ah->tx_power[i][0];
+			break;
+		case AR9300_2LOMID_CHAINMASK:
+		case AR9300_2LOHI_CHAINMASK:
+			ah->tx_power_stbc[i][1] = ah->tx_power[i][1];
+			break;
+		case AR9300_3_CHAINMASK:
+			ah->tx_power_stbc[i][2] = ah->tx_power[i][2];
+			break;
+		default:
+			break;
+		}
+	}
+
+	for (i = ds_offset; i < ds_offset + AR9300_HT_DS_RATES; i++) {
+		switch (chainmask) {
+		case AR9300_1_CHAINMASK:
+			ah->tx_power_stbc[i][0] = ah->tx_power[i][0];
+			break;
+		case AR9300_2LOMID_CHAINMASK:
+		case AR9300_2LOHI_CHAINMASK:
+			ah->tx_power_stbc[i][1] = ah->tx_power[i][1];
+			break;
+		case AR9300_3_CHAINMASK:
+			ah->tx_power_stbc[i][2] = ah->tx_power[i][2];
+			break;
+		default:
+			break;
+		}
+	}
+
+	for (i = ts_offset; i < ts_offset + AR9300_HT_TS_RATES; i++) {
+		switch (chainmask) {
+		case AR9300_1_CHAINMASK:
+			ah->tx_power_stbc[i][0] = ah->tx_power[i][0];
+			break;
+		case AR9300_2LOMID_CHAINMASK:
+		case AR9300_2LOHI_CHAINMASK:
+			ah->tx_power_stbc[i][1] = ah->tx_power[i][1];
+			break;
+		case AR9300_3_CHAINMASK:
+			ah->tx_power_stbc[i][2] = ah->tx_power[i][2];
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+void ar9003_hw_init_rate_txpower(struct ath_hw *ah, u8 *rate_array,
+				 struct ath9k_channel *chan, u8 chainmask)
+{
+	if (IS_CHAN_5GHZ(chan)) {
+		ar9003_hw_init_txpower_ofdm(ah, rate_array,
+					    AR9300_11NA_OFDM_SHIFT,
+					    chainmask);
+		if (IS_CHAN_HT20(chan) || IS_CHAN_HT40(chan)) {
+			ar9003_hw_init_txpower_ht(ah, rate_array,
+						  AR9300_11NA_HT_SS_SHIFT,
+						  AR9300_11NA_HT_DS_SHIFT,
+						  AR9300_11NA_HT_TS_SHIFT,
+						  IS_CHAN_HT40(chan),
+						  chainmask);
+			ar9003_hw_init_txpower_stbc(ah, chainmask,
+						    AR9300_11NA_HT_SS_SHIFT,
+						    AR9300_11NA_HT_DS_SHIFT,
+						    AR9300_11NA_HT_TS_SHIFT);
+		}
+	} else {
+		ar9003_hw_init_txpower_cck(ah, rate_array);
+		ar9003_hw_init_txpower_ofdm(ah, rate_array,
+					    AR9300_11NG_OFDM_SHIFT,
+					    chainmask);
+		if (IS_CHAN_HT20(chan) || IS_CHAN_HT40(chan)) {
+			ar9003_hw_init_txpower_ht(ah, rate_array,
+						  AR9300_11NG_HT_SS_SHIFT,
+						  AR9300_11NG_HT_DS_SHIFT,
+						  AR9300_11NG_HT_TS_SHIFT,
+						  IS_CHAN_HT40(chan),
+						  chainmask);
+			ar9003_hw_init_txpower_stbc(ah, chainmask,
+						    AR9300_11NG_HT_SS_SHIFT,
+						    AR9300_11NG_HT_DS_SHIFT,
+						    AR9300_11NG_HT_TS_SHIFT);
+		}
+	}
+}
+
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4cf9e0a..3fcfdaf 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -940,6 +940,10 @@ struct ath_hw {
 	const struct firmware *eeprom_blob;
 
 	struct ath_dynack dynack;
+
+	bool tpc_enabled;
+	u8 tx_power[Ar5416RateSize][AR5416_MAX_CHAINS];
+	u8 tx_power_stbc[Ar5416RateSize][AR5416_MAX_CHAINS];
 };
 
 struct ath_bus_ops {
@@ -1080,6 +1084,8 @@ int ar9003_paprd_init_table(struct ath_hw *ah);
 bool ar9003_paprd_is_done(struct ath_hw *ah);
 bool ar9003_is_paprd_enabled(struct ath_hw *ah);
 void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx);
+void ar9003_hw_init_rate_txpower(struct ath_hw *ah, u8 *rate_array,
+				 struct ath9k_channel *chan, u8 chainmask);
 
 /* Hardware family op attach helpers */
 int ar5008_hw_attach_phy_ops(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index ced36b4..fb11a91 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1724,6 +1724,8 @@ enum {
 #define AR_TPC_CTS_S           8
 #define AR_TPC_CHIRP           0x003f0000
 #define AR_TPC_CHIRP_S         16
+#define AR_TPC_RPT	       0x3f000000
+#define AR_TPC_RPT_S	       24
 
 #define AR_QUIET1          0x80fc
 #define AR_QUIET1_NEXT_QUIET_S         0
-- 
2.1.0

