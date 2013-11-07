Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50408 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3KGAQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 19:16:45 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/13] ath9k: Add SERDES initvals for AR9462 2.1
Date: Thu,  7 Nov 2013 05:41:55 +0530
Message-Id: <1383783120-22435-9-git-send-email-sujith@msujith.org> (sfid-20131107_011649_442962_0068EEEA)
In-Reply-To: <1383783120-22435-1-git-send-email-sujith@msujith.org>
References: <1383783120-22435-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c           | 4 ++++
 drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index b07f164..a6e06a1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -223,6 +223,10 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 			       ar9462_2p1_modes_fast_clock);
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
 			       ar9462_2p1_baseband_core_txfir_coeff_japan_2484);
+		INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			       ar9462_2p1_pciephy_clkreq_disable_L1);
+		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+			       ar9462_2p1_pciephy_clkreq_disable_L1);
 	} else if (AR_SREV_9462_20(ah)) {
 
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE], ar9462_2p0_mac_core);
diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h
index 4dbc294..bec18bf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h
@@ -1771,4 +1771,11 @@ static const u32 ar9462_2p1_baseband_core_txfir_coeff_japan_2484[][2] = {
 	{0x0000a3a0, 0xca9228ee},
 };
 
+static const u32 ar9462_2p1_pciephy_clkreq_disable_L1[][2] = {
+	/* Addr      allmodes  */
+	{0x00018c00, 0x18213ede},
+	{0x00018c04, 0x000801d8},
+	{0x00018c08, 0x0003780c},
+};
+
 #endif /* INITVALS_9462_2P1_H */
-- 
1.8.4.2

