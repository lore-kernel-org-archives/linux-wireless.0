Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab0CMFq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 00:46:58 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 04/12] ath9k_hw: fix RF analog setup for AR9271
Date: Sat, 13 Mar 2010 00:46:48 -0500
Message-Id: <1268459216-22372-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

AR9271 is a single chip and as such does not have external radios.
Devices with external radio require additional programming, skip
this for AR9271 as we do for other single chips.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    6 +++---
 drivers/net/wireless/ath/ath9k/phy.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b1a4a83..a0ef990 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -517,7 +517,7 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 		  ah->eep_ops->get_eeprom_ver(ah),
 		  ah->eep_ops->get_eeprom_rev(ah));
 
-        if (!AR_SREV_9280_10_OR_LATER(ah)) {
+	if (!AR_SREV_9280_10_OR_LATER(ah) && !AR_SREV_9271(ah)) {
 		ecode = ath9k_hw_rf_alloc_ext_banks(ah);
 		if (ecode) {
 			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
@@ -917,7 +917,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_cal_settings(ah);
 
 	ah->ani_function = ATH9K_ANI_ALL;
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_10_OR_LATER(ah) || AR_SREV_9271(ah)) {
 		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
 		ah->ath9k_hw_rf_set_freq = &ath9k_hw_ar9280_set_channel;
 		ah->ath9k_hw_spur_mitigate_freq = &ath9k_hw_9280_spur_mitigate;
@@ -1266,7 +1266,7 @@ void ath9k_hw_deinit(struct ath_hw *ah)
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 
 free_hw:
-	if (!AR_SREV_9280_10_OR_LATER(ah))
+	if (!AR_SREV_9280_10_OR_LATER(ah) && !AR_SREV_9271(ah))
 		ath9k_hw_rf_free_ext_banks(ah);
 	kfree(ah);
 	ah = NULL;
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index c3b5939..b761330 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -839,7 +839,7 @@ int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah)
 
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
+	BUG_ON(AR_SREV_9280_10_OR_LATER(ah) || AR_SREV_9271(ah));
 
 	ATH_ALLOC_BANK(ah->analogBank0Data, ah->iniBank0.ia_rows);
 	ATH_ALLOC_BANK(ah->analogBank1Data, ah->iniBank1.ia_rows);
@@ -870,7 +870,7 @@ ath9k_hw_rf_free_ext_banks(struct ath_hw *ah)
 		bank = NULL; \
 	} while (0);
 
-	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
+	BUG_ON(AR_SREV_9280_10_OR_LATER(ah) || AR_SREV_9271(ah));
 
 	ATH_FREE_BANK(ah->analogBank0Data);
 	ATH_FREE_BANK(ah->analogBank1Data);
@@ -910,7 +910,7 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 	 * for single chip devices, that is AR9280 or anything
 	 * after that.
 	 */
-	if (AR_SREV_9280_10_OR_LATER(ah))
+	if (AR_SREV_9280_10_OR_LATER(ah) || AR_SREV_9271(ah))
 		return true;
 
 	/* Setup rf parameters */
-- 
1.6.3.3

