Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:21894 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2JYLxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 07:53:02 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/4] ath9k_hw: Enable hw PLL power save for AR9565
Date: Thu, 25 Oct 2012 17:16:51 +0530
Message-ID: <1351165614-12691-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121025_135308_173533_149A08A5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reduced the power consumption to half in full and network sleep.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c           | 4 ++--
 drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 0a6b7a3..0693cd9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -328,9 +328,9 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 			       ar9565_1p0_Modes_lowest_ob_db_tx_gain_table);
 
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9565_1p0_pciephy_pll_on_clkreq_disable_L1);
+			       ar9565_1p0_pciephy_clkreq_disable_L1);
 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-			       ar9565_1p0_pciephy_pll_on_clkreq_disable_L1);
+			       ar9565_1p0_pciephy_clkreq_disable_L1);
 
 		INIT_INI_ARRAY(&ah->iniModesFastClock,
 				ar9565_1p0_modes_fast_clock);
diff --git a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
index 843e79f..0c2ac0c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
@@ -768,9 +768,9 @@ static const u32 ar9565_1p0_Modes_lowest_ob_db_tx_gain_table[][5] = {
 	{0x00016054, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 };
 
-static const u32 ar9565_1p0_pciephy_pll_on_clkreq_disable_L1[][2] = {
+static const u32 ar9565_1p0_pciephy_clkreq_disable_L1[][2] = {
 	/* Addr      allmodes  */
-	{0x00018c00, 0x18212ede},
+	{0x00018c00, 0x18213ede},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0003780c},
 };
-- 
1.8.0

