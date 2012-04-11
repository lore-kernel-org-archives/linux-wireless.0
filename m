Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36335 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2DKEEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 00:04:48 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20357.696.348053.48133@gargle.gargle.HOWL> (sfid-20120411_060451_943455_6A41F456)
Date: Wed, 11 Apr 2012 09:34:08 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_hw: Remove BTCOEX initvals
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MAX_TXPWR table for BTCOEX is not needed for AR9462.
Programming these values to the HW results in undesirable
behavior - for example, large number of delimiter/data
underruns are seen in AES-CCMP mode. Also, registers like
AR_PCU_MISC_MODE2 return 0xdeadbeef after the BTCOEX_MAX
power table is programmed to the HW, and frames being transmitted
end up being looped back to the RX engine, an example being beacon
frames in IBSS mode.

Remove this table for now - this fixes CCMP performance and general
IBSS usage.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c           |    5 -----
 drivers/net/wireless/ath/ath9k/ar9003_phy.c          |    3 ---
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h |   12 ------------
 3 files changed, 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 0f56e32..a0e3394 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -305,11 +305,6 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 				ar9462_common_rx_gain_table_2p0,
 				ARRAY_SIZE(ar9462_common_rx_gain_table_2p0), 2);
 
-		INIT_INI_ARRAY(&ah->ini_BTCOEX_MAX_TXPWR,
-				ar9462_2p0_BTCOEX_MAX_TXPWR_table,
-				ARRAY_SIZE(ar9462_2p0_BTCOEX_MAX_TXPWR_table),
-				2);
-
 		/* Awake -> Sleep Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
 				PCIE_PLL_ON_CREQ_DIS_L1_2P0,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 79070bf..d4313aa 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -684,9 +684,6 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 
 	REG_WRITE_ARRAY(&ah->iniAdditional, 1, regWrites);
 
-	if (AR_SREV_9462(ah))
-		ar9003_hw_prog_ini(ah, &ah->ini_BTCOEX_MAX_TXPWR, 1);
-
 	if (chan->channel == 2484)
 		ar9003_hw_prog_ini(ah, &ah->ini_japan2484, 1);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index b6ba1e8..b39870c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -1448,16 +1448,4 @@ static const u32 ar9462_common_mixed_rx_gain_table_2p0[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
-static const u32 ar9462_2p0_BTCOEX_MAX_TXPWR_table[][2] = {
-	/* Addr      allmodes  */
-	{0x000018c0, 0x10101010},
-	{0x000018c4, 0x10101010},
-	{0x000018c8, 0x10101010},
-	{0x000018cc, 0x10101010},
-	{0x000018d0, 0x10101010},
-	{0x000018d4, 0x10101010},
-	{0x000018d8, 0x10101010},
-	{0x000018dc, 0x10101010},
-};
-
 #endif /* INITVALS_9462_2P0_H */
-- 
1.7.10

