Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46242 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3HDIzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Aug 2013 04:55:48 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/11] ath9k: Remove "shared_chain_lnadiv"
Date: Sun,  4 Aug 2013 14:22:00 +0530
Message-Id: <1375606322-9983-9-git-send-email-sujith@msujith.org> (sfid-20130804_105608_479600_35711E07)
In-Reply-To: <1375606322-9983-1-git-send-email-sujith@msujith.org>
References: <1375606322-9983-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This variable is redundant since we can use
common->bt_ant_diversity to determine if diversity
has to be enabled/disabled.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 3 ++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 1 -
 drivers/net/wireless/ath/ath9k/hw.c            | 2 +-
 drivers/net/wireless/ath/ath9k/hw.h            | 1 -
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index a98e6a3..c2f1f18 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3561,6 +3561,7 @@ static u16 ar9003_hw_ant_ctrl_chain_get(struct ath_hw *ah, int chain,
 
 static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	int chain;
 	u32 regval, value, gpio;
@@ -3646,7 +3647,7 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 		regval |= ((value >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
 
 		if (AR_SREV_9565(ah)) {
-			if (ah->shared_chain_lnadiv) {
+			if (common->bt_ant_diversity) {
 				regval |= (1 << AR_PHY_ANT_SW_RX_PROT_S);
 			} else {
 				regval &= ~(1 << AR_PHY_ANT_DIV_LNADIV_S);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index f9fe9c8..55021f1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1420,7 +1420,6 @@ static void ar9003_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 	if (!AR_SREV_9565(ah))
 		return;
 
-	ah->shared_chain_lnadiv = enable;
 	ant_div_ctl1 = ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
 
 	regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8bd602c..151443b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2056,7 +2056,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_apply_gpio_override(ah);
 
-	if (AR_SREV_9565(ah) && ah->shared_chain_lnadiv)
+	if (AR_SREV_9565(ah) && common->bt_ant_diversity)
 		REG_SET_BIT(ah, AR_BTCOEX_WL_LNADIV, AR_BTCOEX_WL_LNADIV_FORCE_ON);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c037718..9dc6773 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -767,7 +767,6 @@ struct ath_hw {
 	bool aspm_enabled;
 	bool is_monitoring;
 	bool need_an_top2_fixup;
-	bool shared_chain_lnadiv;
 	u16 tx_trig_level;
 
 	u32 nf_regs[6];
-- 
1.8.3.4

