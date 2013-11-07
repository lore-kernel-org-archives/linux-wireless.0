Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45996 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3KGAQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 19:16:50 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/13] ath9k: Remove pcieSerDesWrite
Date: Thu,  7 Nov 2013 05:41:57 +0530
Message-Id: <1383783120-22435-11-git-send-email-sujith@msujith.org> (sfid-20131107_013807_388406_06F0DEDB)
In-Reply-To: <1383783120-22435-1-git-send-email-sujith@msujith.org>
References: <1383783120-22435-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This HW config option is always set to true and is not needed.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 20 +++++++++-----------
 drivers/net/wireless/ath/ath9k/hw.c        |  1 -
 drivers/net/wireless/ath/ath9k/hw.h        |  1 -
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index a6e06a1..42daea5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -754,6 +754,9 @@ static void ar9003_hw_init_mode_gain_regs(struct ath_hw *ah)
 static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 					 bool power_off)
 {
+	unsigned int i;
+	struct ar5416IniArray *array;
+
 	/*
 	 * Increase L1 Entry Latency. Some WB222 boards don't have
 	 * this change in eeprom/OTP.
@@ -779,18 +782,13 @@ static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 	 * Configire PCIE after Ini init. SERDES values now come from ini file
 	 * This enables PCIe low power mode.
 	 */
-	if (ah->config.pcieSerDesWrite) {
-		unsigned int i;
-		struct ar5416IniArray *array;
-
-		array = power_off ? &ah->iniPcieSerdes :
-				    &ah->iniPcieSerdesLowPower;
+	array = power_off ? &ah->iniPcieSerdes :
+		&ah->iniPcieSerdesLowPower;
 
-		for (i = 0; i < array->ia_rows; i++) {
-			REG_WRITE(ah,
-				  INI_RA(array, i, 0),
-				  INI_RA(array, i, 1));
-		}
+	for (i = 0; i < array->ia_rows; i++) {
+		REG_WRITE(ah,
+			  INI_RA(array, i, 0),
+			  INI_RA(array, i, 1));
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 54b0415..381fbe1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -454,7 +454,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	}
 
 	ah->config.rx_intr_mitigation = true;
-	ah->config.pcieSerDesWrite = true;
 
 	/*
 	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 69542c1..289e5ce 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -283,7 +283,6 @@ struct ath9k_ops_config {
 	int additional_swba_backoff;
 	int ack_6mb;
 	u32 cwm_ignore_extcca;
-	bool pcieSerDesWrite;
 	u8 pcie_clock_req;
 	u32 pcie_waen;
 	u8 analog_shiftreg;
-- 
1.8.4.2

