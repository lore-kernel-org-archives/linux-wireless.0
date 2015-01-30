Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:44216 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594AbbA3Nc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:56 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgt-004FiR-EQ
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:55 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 12/17] ath9k: Add a HW structure for WOW
Date: Fri, 30 Jan 2015 19:05:32 +0530
Message-Id: <1422624937-4810-13-git-send-email-sujith@msujith.org> (sfid-20150130_143259_727799_62DD87CF)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This can be used to hold the WOW state in
ath9k_hw.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 10 +++++-----
 drivers/net/wireless/ath/ath9k/hw.h         |  6 +++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index 3abc907..bb61417 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -137,7 +137,7 @@ void ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
 	 * other fields
 	 */
 
-	ah->wow_event_mask |= BIT(pattern_count + AR_WOW_PAT_FOUND_SHIFT);
+	ah->wow.wow_event_mask |= BIT(pattern_count + AR_WOW_PAT_FOUND_SHIFT);
 
 	if (pattern_count < 4) {
 		/* Pattern 0-3 uses AR_WOW_LENGTH1 register */
@@ -174,7 +174,7 @@ u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 	 * register. This mask will clean it up.
 	 */
 
-	val &= ah->wow_event_mask;
+	val &= ah->wow.wow_event_mask;
 
 	if (val) {
 		if (val & AR_WOW_MAGIC_PAT_FOUND)
@@ -218,7 +218,7 @@ u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 	if (ah->is_pciexpress)
 		ath9k_hw_configpcipowersave(ah, false);
 
-	ah->wow_event_mask = 0;
+	ah->wow.wow_event_mask = 0;
 
 	return wow_status;
 }
@@ -235,7 +235,7 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 	 * are from the 'pattern_enable' in this function and
 	 * 'pattern_count' of ath9k_hw_wow_apply_pattern()
 	 */
-	wow_event_mask = ah->wow_event_mask;
+	wow_event_mask = ah->wow.wow_event_mask;
 
 	/*
 	 * Untie Power-on-Reset from the PCI-E-Reset. When we are in
@@ -402,6 +402,6 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 	REG_CLR_BIT(ah, AR_PCU_MISC_MODE3, clr);
 
 	ath9k_hw_set_powermode_wow_sleep(ah);
-	ah->wow_event_mask = wow_event_mask;
+	ah->wow.wow_event_mask = wow_event_mask;
 }
 EXPORT_SYMBOL(ath9k_hw_wow_enable);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 22b0422..d36210a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -270,6 +270,10 @@ enum ath9k_hw_caps {
  * of those types.
  */
 
+struct ath9k_hw_wow {
+	u32 wow_event_mask;
+};
+
 struct ath9k_hw_capabilities {
 	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
 	u16 rts_aggr_limit;
@@ -928,7 +932,7 @@ struct ath_hw {
 	u32 ent_mode;
 
 #ifdef CONFIG_ATH9K_WOW
-	u32 wow_event_mask;
+	struct ath9k_hw_wow wow;
 #endif
 	bool is_clk_25mhz;
 	int (*get_mac_revision)(void);
-- 
2.2.2

