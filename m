Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:35004 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759377Ab3ICFCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 01:02:48 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath9k: Add and use initvals for channel 14
Date: Tue,  3 Sep 2013 10:28:56 +0530
Message-Id: <1378184337-1816-2-git-send-email-sujith@msujith.org> (sfid-20130903_070252_366258_E88A4864)
In-Reply-To: <1378184337-1816-1-git-send-email-sujith@msujith.org>
References: <1378184337-1816-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This is missing for AR9565.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c           | 2 ++
 drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index d40bdd2..b07f164 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -364,6 +364,8 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 
 		INIT_INI_ARRAY(&ah->iniModesFastClock,
 				ar9565_1p0_modes_fast_clock);
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+			       ar9565_1p0_baseband_core_txfir_coeff_japan_2484);
 	} else {
 		/* mac */
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
diff --git a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
index 03ecc07..a8c757b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
@@ -1231,4 +1231,11 @@ static const u32 ar9565_1p0_modes_high_power_tx_gain_table[][5] = {
 	{0x00016054, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 };
 
+static const u32 ar9565_1p0_baseband_core_txfir_coeff_japan_2484[][2] = {
+	/* Addr      allmodes  */
+	{0x0000a398, 0x00000000},
+	{0x0000a39c, 0x6f7f0301},
+	{0x0000a3a0, 0xca9228ee},
+};
+
 #endif /* INITVALS_9565_1P0_H */
-- 
1.8.4

