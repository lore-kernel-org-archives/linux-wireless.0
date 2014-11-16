Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:45769 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaKPAjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 19:39:47 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	Miaoqing Pan <miaoqing@qca.qualcomm.com>
Subject: [PATCH v2 05/11] ath9k: Store the chip chainmask in HW capabilities
Date: Sun, 16 Nov 2014 06:11:04 +0530
Message-Id: <1416098470-14122-6-git-send-email-sujith@msujith.org> (sfid-20141116_013951_457985_57C43687)
In-Reply-To: <1416098470-14122-1-git-send-email-sujith@msujith.org>
References: <1416098470-14122-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Cc: Miaoqing Pan <miaoqing@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 20 ++++++++++----------
 drivers/net/wireless/ath/ath9k/hw.h |  1 +
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 11a1fbd..12ee8c2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2322,7 +2322,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath_common *common = ath9k_hw_common(ah);
-	unsigned int chip_chainmask;
 
 	u16 eeval;
 	u8 ant_div_ctl1, tx_chainmask, rx_chainmask;
@@ -2366,15 +2365,16 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	    AR_SREV_9285(ah) ||
 	    AR_SREV_9330(ah) ||
 	    AR_SREV_9565(ah))
-		chip_chainmask = 1;
-	else if (AR_SREV_9462(ah))
-		chip_chainmask = 3;
+		pCap->chip_chainmask = 1;
 	else if (!AR_SREV_9280_20_OR_LATER(ah))
-		chip_chainmask = 7;
-	else if (!AR_SREV_9300_20_OR_LATER(ah) || AR_SREV_9340(ah))
-		chip_chainmask = 3;
+		pCap->chip_chainmask = 7;
+	else if (!AR_SREV_9300_20_OR_LATER(ah) ||
+		 AR_SREV_9340(ah) ||
+		 AR_SREV_9462(ah) ||
+		 AR_SREV_9531(ah))
+		pCap->chip_chainmask = 3;
 	else
-		chip_chainmask = 7;
+		pCap->chip_chainmask = 7;
 
 	pCap->tx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_TX_MASK);
 	/*
@@ -2392,8 +2392,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		/* Use rx_chainmask from EEPROM. */
 		pCap->rx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_RX_MASK);
 
-	pCap->tx_chainmask = fixup_chainmask(chip_chainmask, pCap->tx_chainmask);
-	pCap->rx_chainmask = fixup_chainmask(chip_chainmask, pCap->rx_chainmask);
+	pCap->tx_chainmask = fixup_chainmask(pCap->chip_chainmask, pCap->tx_chainmask);
+	pCap->rx_chainmask = fixup_chainmask(pCap->chip_chainmask, pCap->rx_chainmask);
 	ah->txchainmask = pCap->tx_chainmask;
 	ah->rxchainmask = pCap->rx_chainmask;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a4f0f65..f294854 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -276,6 +276,7 @@ struct ath9k_hw_capabilities {
 	u16 rts_aggr_limit;
 	u8 tx_chainmask;
 	u8 rx_chainmask;
+	u8 chip_chainmask;
 	u8 max_txchains;
 	u8 max_rxchains;
 	u8 num_gpio_pins;
-- 
2.1.3

