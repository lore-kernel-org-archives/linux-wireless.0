Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43081 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab3ATUzc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 15:55:32 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	stable@vger.kernel.org
Subject: [PATCH 3.8 2/3] ath9k_hw: fix chain swap setting when setting rx chainmask to 5
Date: Sun, 20 Jan 2013 21:55:21 +0100
Message-Id: <1358715322-46447-2-git-send-email-nbd@openwrt.org> (sfid-20130120_215536_350426_6DCCD417)
In-Reply-To: <1358715322-46447-1-git-send-email-nbd@openwrt.org>
References: <1358715322-46447-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chain swapping should only be enabled when the EEPROM chainmask is set to 5,
regardless of what the runtime chainmask is.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 8290edd..3afc24b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -588,30 +588,17 @@ static void ar9003_hw_init_bb(struct ath_hw *ah,
 
 void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
 {
-	switch (rx) {
-	case 0x5:
+	if (ah->caps.tx_chainmask == 5 || ah->caps.rx_chainmask == 5)
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
 			    AR_PHY_SWAP_ALT_CHAIN);
-	case 0x3:
-	case 0x1:
-	case 0x2:
-	case 0x7:
-		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx);
-		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx);
-		break;
-	default:
-		break;
-	}
+
+	REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx);
+	REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx);
 
 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7))
-		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
-	else
-		REG_WRITE(ah, AR_SELFGEN_MASK, tx);
+		tx = 3;
 
-	if (tx == 0x5) {
-		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
-			    AR_PHY_SWAP_ALT_CHAIN);
-	}
+	REG_WRITE(ah, AR_SELFGEN_MASK, tx);
 }
 
 /*
-- 
1.8.0.2

