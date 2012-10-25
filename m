Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:38139 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab2JYPZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 11:25:17 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k: Restore main and alternate antenna.
Date: Thu, 25 Oct 2012 20:54:52 +0530
Message-ID: <1351178692-2054-3-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121025_172521_887396_34F8B0C6)
In-Reply-To: <1351178692-2054-1-git-send-email-bkamatch@qca.qualcomm.com>
References: <1351178692-2054-1-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Restore main to LNA1 and ALT to LNA2 for AR9565 only
when shared LNA diversity is not enabled.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 105390a..672530c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3674,7 +3674,10 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 			regval &= ~AR_FAST_DIV_ENABLE;
 		REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
 
-		if (pCap->hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
+		if ((AR_SREV_9485_11(ah) &&
+		     pCap->hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) ||
+		    (AR_SREV_9565(ah) &&
+		     !ah->shared_chain_lnadiv)) {
 			regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
 			/*
 			 * clear bits 25-30 main_lnaconf, alt_lnaconf,
-- 
1.7.4.1

