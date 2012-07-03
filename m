Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40394 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986Ab2GCROj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:14:39 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 09/20] ath9k: add mode register initialization code for AR9550
Date: Tue,  3 Jul 2012 19:13:23 +0200
Message-Id: <1341335614-15419-10-git-send-email-juhosg@openwrt.org> (sfid-20120703_192129_286132_B8927EDF)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c  |   86 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   61 +++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.h         |    1 +
 3 files changed, 145 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 325a360..41e88c6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -328,7 +328,61 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 
 		INIT_INI_ARRAY(&ah->ini_japan2484, AR9462_BBC_TXIFR_COEFFJ,
 				ARRAY_SIZE(AR9462_BBC_TXIFR_COEFFJ), 2);
+	} else if (AR_SREV_9550(ah)) {
+		/* mac */
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
+				ar955x_1p0_mac_core,
+				ARRAY_SIZE(ar955x_1p0_mac_core), 2);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
+				ar955x_1p0_mac_postamble,
+				ARRAY_SIZE(ar955x_1p0_mac_postamble), 5);
+
+		/* bb */
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
+				ar955x_1p0_baseband_core,
+				ARRAY_SIZE(ar955x_1p0_baseband_core), 2);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
+				ar955x_1p0_baseband_postamble,
+				ARRAY_SIZE(ar955x_1p0_baseband_postamble), 5);
+
+		/* radio */
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
+				ar955x_1p0_radio_core,
+				ARRAY_SIZE(ar955x_1p0_radio_core), 2);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
+				ar955x_1p0_radio_postamble,
+				ARRAY_SIZE(ar955x_1p0_radio_postamble), 5);
+
+		/* soc */
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
+				ar955x_1p0_soc_preamble,
+				ARRAY_SIZE(ar955x_1p0_soc_preamble), 2);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_CORE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
+				ar955x_1p0_soc_postamble,
+				ARRAY_SIZE(ar955x_1p0_soc_postamble), 5);
 
+		/* rx/tx gain */
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar955x_1p0_common_wo_xlna_rx_gain_table,
+			ARRAY_SIZE(ar955x_1p0_common_wo_xlna_rx_gain_table),
+			2);
+		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
+			ar955x_1p0_common_wo_xlna_rx_gain_bounds,
+			ARRAY_SIZE(ar955x_1p0_common_wo_xlna_rx_gain_bounds),
+			5);
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar955x_1p0_modes_xpa_tx_gain_table,
+				ARRAY_SIZE(ar955x_1p0_modes_xpa_tx_gain_table),
+				9);
+
+		/* Fast clock modal settings */
+		INIT_INI_ARRAY(&ah->iniModesFastClock,
+				ar955x_1p0_modes_fast_clock,
+				ARRAY_SIZE(ar955x_1p0_modes_fast_clock), 3);
 	} else if (AR_SREV_9580(ah)) {
 		/* mac */
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
@@ -471,6 +525,11 @@ static void ar9003_tx_gain_table_mode0(struct ath_hw *ah)
 			ar9485_modes_lowest_ob_db_tx_gain_1_1,
 			ARRAY_SIZE(ar9485_modes_lowest_ob_db_tx_gain_1_1),
 			5);
+	else if (AR_SREV_9550(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar955x_1p0_modes_xpa_tx_gain_table,
+			ARRAY_SIZE(ar955x_1p0_modes_xpa_tx_gain_table),
+			9);
 	else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9580_1p0_lowest_ob_db_tx_gain_table,
@@ -515,6 +574,11 @@ static void ar9003_tx_gain_table_mode1(struct ath_hw *ah)
 			ar9580_1p0_high_ob_db_tx_gain_table,
 			ARRAY_SIZE(ar9580_1p0_high_ob_db_tx_gain_table),
 			5);
+	else if (AR_SREV_9550(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar955x_1p0_modes_no_xpa_tx_gain_table,
+			ARRAY_SIZE(ar955x_1p0_modes_no_xpa_tx_gain_table),
+			9);
 	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9462_modes_high_ob_db_tx_gain_table_2p0,
@@ -636,7 +700,16 @@ static void ar9003_rx_gain_table_mode0(struct ath_hw *ah)
 				ar9485Common_wo_xlna_rx_gain_1_1,
 				ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_1),
 				2);
-	else if (AR_SREV_9580(ah))
+	else if (AR_SREV_9550(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar955x_1p0_common_rx_gain_table,
+				ARRAY_SIZE(ar955x_1p0_common_rx_gain_table),
+				2);
+		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
+				ar955x_1p0_common_rx_gain_bounds,
+				ARRAY_SIZE(ar955x_1p0_common_rx_gain_bounds),
+				5);
+	} else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 				ar9580_1p0_rx_gain_table,
 				ARRAY_SIZE(ar9580_1p0_rx_gain_table),
@@ -680,7 +753,16 @@ static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
 			ar9462_common_wo_xlna_rx_gain_table_2p0,
 			ARRAY_SIZE(ar9462_common_wo_xlna_rx_gain_table_2p0),
 			2);
-	else if (AR_SREV_9580(ah))
+	else if (AR_SREV_9550(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar955x_1p0_common_wo_xlna_rx_gain_table,
+			ARRAY_SIZE(ar955x_1p0_common_wo_xlna_rx_gain_table),
+			2);
+		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
+			ar955x_1p0_common_wo_xlna_rx_gain_bounds,
+			ARRAY_SIZE(ar955x_1p0_common_wo_xlna_rx_gain_bounds),
+			5);
+	} else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9580_1p0_wo_xlna_rx_gain_table,
 			ARRAY_SIZE(ar9580_1p0_wo_xlna_rx_gain_table),
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 6b91ebb..898ee14 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -618,6 +618,50 @@ static void ar9003_hw_prog_ini(struct ath_hw *ah,
 	}
 }
 
+static int ar9550_hw_get_modes_txgain_index(struct ath_hw *ah,
+					    struct ath9k_channel *chan)
+{
+	int ret;
+
+	switch (chan->chanmode) {
+	case CHANNEL_A:
+	case CHANNEL_A_HT20:
+		if (chan->channel <= 5350)
+			ret = 1;
+		else if ((chan->channel > 5350) && (chan->channel <= 5600))
+			ret = 3;
+		else
+			ret = 5;
+		break;
+
+	case CHANNEL_A_HT40PLUS:
+	case CHANNEL_A_HT40MINUS:
+		if (chan->channel <= 5350)
+			ret = 2;
+		else if ((chan->channel > 5350) && (chan->channel <= 5600))
+			ret = 4;
+		else
+			ret = 6;
+		break;
+
+	case CHANNEL_G:
+	case CHANNEL_G_HT20:
+	case CHANNEL_B:
+		ret = 8;
+		break;
+
+	case CHANNEL_G_HT40PLUS:
+	case CHANNEL_G_HT40MINUS:
+		ret = 7;
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 static int ar9003_hw_process_ini(struct ath_hw *ah,
 				 struct ath9k_channel *chan)
 {
@@ -659,7 +703,22 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	}
 
 	REG_WRITE_ARRAY(&ah->iniModesRxGain, 1, regWrites);
-	REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
+	if (AR_SREV_9550(ah))
+		REG_WRITE_ARRAY(&ah->ini_modes_rx_gain_bounds, modesIndex,
+				regWrites);
+
+	if (AR_SREV_9550(ah)) {
+		int modes_txgain_index;
+
+		modes_txgain_index = ar9550_hw_get_modes_txgain_index(ah, chan);
+		if (modes_txgain_index < 0)
+			return -EINVAL;
+
+		REG_WRITE_ARRAY(&ah->iniModesTxGain, modes_txgain_index,
+				regWrites);
+	} else {
+		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
+	}
 
 	/*
 	 * For 5GHz channels requiring Fast Clock, apply
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 97060c6..26da173 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -819,6 +819,7 @@ struct ath_hw {
 	struct ar5416IniArray iniModesFastClock;
 	struct ar5416IniArray iniAdditional;
 	struct ar5416IniArray iniModesRxGain;
+	struct ar5416IniArray ini_modes_rx_gain_bounds;
 	struct ar5416IniArray iniModesTxGain;
 	struct ar5416IniArray iniCckfirNormal;
 	struct ar5416IniArray iniCckfirJapan2484;
-- 
1.7.2.1

