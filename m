Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57292 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab1DSODP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 10:03:15 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 07:02:49 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH V2 06/22] ath9k_hw: Initialize mode registers from initvals.h for AR9340
Date: Tue, 19 Apr 2011 19:33:20 +0530
Message-ID: <1303221803-25230-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1303221803-25230-1-git-send-email-vasanth@atheros.com>
References: <1303221803-25230-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c  |   59 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    3 +
 drivers/net/wireless/ath/ath9k/hw.h         |    1 +
 3 files changed, 62 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index aebaad9..37af721 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -18,6 +18,7 @@
 #include "ar9003_mac.h"
 #include "ar9003_2p2_initvals.h"
 #include "ar9485_initvals.h"
+#include "ar9340_initvals.h"
 
 /* General hardware code for the AR9003 hadware family */
 
@@ -28,7 +29,63 @@
  */
 static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 {
-	if (AR_SREV_9485_11(ah)) {
+	if (AR_SREV_9340(ah)) {
+		/* mac */
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
+				ar9340_1p0_mac_core,
+				ARRAY_SIZE(ar9340_1p0_mac_core), 2);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
+				ar9340_1p0_mac_postamble,
+				ARRAY_SIZE(ar9340_1p0_mac_postamble), 5);
+
+		/* bb */
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
+				ar9340_1p0_baseband_core,
+				ARRAY_SIZE(ar9340_1p0_baseband_core), 2);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
+				ar9340_1p0_baseband_postamble,
+				ARRAY_SIZE(ar9340_1p0_baseband_postamble), 5);
+
+		/* radio */
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_PRE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
+				ar9340_1p0_radio_core,
+				ARRAY_SIZE(ar9340_1p0_radio_core), 2);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
+				ar9340_1p0_radio_postamble,
+				ARRAY_SIZE(ar9340_1p0_radio_postamble), 5);
+
+		/* soc */
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
+				ar9340_1p0_soc_preamble,
+				ARRAY_SIZE(ar9340_1p0_soc_preamble), 2);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_CORE], NULL, 0, 0);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
+				ar9340_1p0_soc_postamble,
+				ARRAY_SIZE(ar9340_1p0_soc_postamble), 5);
+
+		/* rx/tx gain */
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9340Common_wo_xlna_rx_gain_table_1p0,
+				ARRAY_SIZE(ar9340Common_wo_xlna_rx_gain_table_1p0),
+				5);
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9340Modes_high_ob_db_tx_gain_table_1p0,
+				ARRAY_SIZE(ar9340Modes_high_ob_db_tx_gain_table_1p0),
+				5);
+
+		INIT_INI_ARRAY(&ah->iniModesAdditional,
+				ar9340Modes_fast_clock_1p0,
+				ARRAY_SIZE(ar9340Modes_fast_clock_1p0),
+				3);
+
+		INIT_INI_ARRAY(&ah->iniModesAdditional_40M,
+				ar9340_1p0_radio_core_40M,
+				ARRAY_SIZE(ar9340_1p0_radio_core_40M),
+				2);
+	} else if (AR_SREV_9485_11(ah)) {
 		/* mac */
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 1bc33f5..c4d0805 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -646,6 +646,9 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 		REG_WRITE_ARRAY(&ah->iniModesAdditional,
 				modesIndex, regWrites);
 
+	if (AR_SREV_9340(ah) && !ah->is_clk_25mhz)
+		REG_WRITE_ARRAY(&ah->iniModesAdditional_40M, 1, regWrites);
+
 	ar9003_hw_override_ini(ah);
 	ar9003_hw_set_channel_regs(ah, chan);
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b08df20..ec6e60d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -799,6 +799,7 @@ struct ath_hw {
 	struct ar5416IniArray iniPcieSerdes;
 	struct ar5416IniArray iniPcieSerdesLowPower;
 	struct ar5416IniArray iniModesAdditional;
+	struct ar5416IniArray iniModesAdditional_40M;
 	struct ar5416IniArray iniModesRxGain;
 	struct ar5416IniArray iniModesTxGain;
 	struct ar5416IniArray iniModes_9271_1_0_only;
-- 
1.7.0.4

