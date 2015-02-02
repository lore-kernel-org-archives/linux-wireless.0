Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46066 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbbBBMsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 07:48:20 -0500
Received: from [117.216.55.194] (port=15247 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YIGQN-002djK-D9
	for linux-wireless@vger.kernel.org; Mon, 02 Feb 2015 07:48:19 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] ath9k: Program AR_WA correctly
Date: Mon,  2 Feb 2015 18:21:11 +0530
Message-Id: <1422881473-24580-5-git-send-email-sujith@msujith.org> (sfid-20150202_134840_488465_9D7DD298)
In-Reply-To: <1422881473-24580-1-git-send-email-sujith@msujith.org>
References: <1422881473-24580-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Setting the required configuration in the PCIE
WorkAround register needs to be done after all the
WoW parameters have been set.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 39 ++++++++++++++++-------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index 6ffa0e0..cf45b91 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -219,31 +219,34 @@ u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_wow_wakeup);
 
+static void ath9k_hw_wow_set_arwr_reg(struct ath_hw *ah)
+{
+	u32 wa_reg;
+
+	if (!ah->is_pciexpress)
+		return;
+
+	/*
+	 * We need to untie the internal POR (power-on-reset)
+	 * to the external PCI-E reset. We also need to tie
+	 * the PCI-E Phy reset to the PCI-E reset.
+	 */
+	wa_reg = REG_READ(ah, AR_WA);
+	wa_reg &= ~AR_WA_UNTIE_RESET_EN;
+	wa_reg |= AR_WA_RESET_EN;
+	wa_reg |= AR_WA_POR_SHORT;
+
+	REG_WRITE(ah, AR_WA, wa_reg);
+}
+
 void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 {
 	u32 wow_event_mask;
 	u32 keep_alive, magic_pattern, host_pm_ctrl;
-	u32 set, clr;
 
 	wow_event_mask = ah->wow.wow_event_mask;
 
 	/*
-	 * Untie Power-on-Reset from the PCI-E-Reset. When we are in
-	 * WOW sleep, we do want the Reset from the PCI-E to disturb
-	 * our hw state
-	 */
-	if (ah->is_pciexpress) {
-		/*
-		 * we need to untie the internal POR (power-on-reset)
-		 * to the external PCI-E reset. We also need to tie
-		 * the PCI-E Phy reset to the PCI-E reset.
-		 */
-		set = AR_WA_RESET_EN | AR_WA_POR_SHORT;
-		clr = AR_WA_UNTIE_RESET_EN | AR_WA_D3_L1_DISABLE;
-		REG_RMW(ah, AR_WA, set, clr);
-	}
-
-	/*
 	 * AR_PMCTRL_HOST_PME_EN - Override PME enable in configuration
 	 *                         space and allow MAC to generate WoW anyway.
 	 *
@@ -390,6 +393,8 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 	/* To bring down WOW power low margin */
 	REG_SET_BIT(ah, AR_PCIE_PHY_REG3, BIT(13));
 
+	ath9k_hw_wow_set_arwr_reg(ah);
+
 	/* HW WoW */
 	REG_CLR_BIT(ah, AR_PCU_MISC_MODE3, BIT(5));
 
-- 
2.2.2

