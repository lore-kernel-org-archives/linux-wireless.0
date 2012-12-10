Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:41126
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab2LJBxW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 20:53:22 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] ath9k_hw: Add HW cap for PAPRD
Date: Mon, 10 Dec 2012 07:22:37 +0530
Message-Id: <1355104358-30062-7-git-send-email-sujith@msujith.org> (sfid-20121210_025336_482962_3273AE50)
In-Reply-To: <1355104358-30062-1-git-send-email-sujith@msujith.org>
References: <1355104358-30062-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Add a HW capability to indicate whether PAPRD is enabled
for the card, since PAPRD could be enabled in the EEPROM, but
disabled in the driver. This makes things clearer.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 8 ++------
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c  | 9 +++++++++
 drivers/net/wireless/ath/ath9k/hw.c            | 4 ++++
 drivers/net/wireless/ath/ath9k/hw.h            | 2 ++
 drivers/net/wireless/ath/ath9k/link.c          | 2 +-
 5 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index c86cb640..6b8861c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -2987,10 +2987,6 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 	case EEP_RX_MASK:
 		return pBase->txrxMask & 0xf;
 	case EEP_PAPRD:
-		if (AR_SREV_9462(ah))
-			return false;
-		if (!ah->config.enable_paprd)
-			return false;
 		return !!(pBase->featureEnable & BIT(5));
 	case EEP_CHAIN_MASK_REDUCE:
 		return (pBase->miscConfiguration >> 0x3) & 0x1;
@@ -5097,7 +5093,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 	 */
 	ar9003_hw_get_target_power_eeprom(ah, chan, targetPowerValT2);
 
-	if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD)) {
+	if (ar9003_is_paprd_enabled(ah)) {
 		if (IS_CHAN_2GHZ(chan))
 			modal_hdr = &eep->modalHeader2G;
 		else
@@ -5138,7 +5134,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 					   twiceAntennaReduction,
 					   powerLimit);
 
-	if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD)) {
+	if (ar9003_is_paprd_enabled(ah)) {
 		for (i = 0; i < ar9300RateSize; i++) {
 			if ((ah->paprd_ratemask & (1 << i)) &&
 			    (abs(targetPowerValT2[i] -
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index fb3a87e..aea1908 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -991,3 +991,12 @@ exit:
 	return !!paprd_done;
 }
 EXPORT_SYMBOL(ar9003_paprd_is_done);
+
+bool ar9003_is_paprd_enabled(struct ath_hw *ah)
+{
+	if ((ah->caps.hw_caps & ATH9K_HW_CAP_PAPRD) && ah->config.enable_paprd)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(ar9003_is_paprd_enabled);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e06bcec..7cb7870 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2599,6 +2599,10 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			pCap->hw_caps |= ATH9K_HW_WOW_PATTERN_MATCH_DWORD;
 	}
 
+	if (AR_SREV_9300_20_OR_LATER(ah) &&
+	    ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
+			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index fe87d0e..eff6759 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -247,6 +247,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_WOW_DEVICE_CAPABLE		= BIT(17),
 	ATH9K_HW_WOW_PATTERN_MATCH_EXACT	= BIT(18),
 	ATH9K_HW_WOW_PATTERN_MATCH_DWORD	= BIT(19),
+	ATH9K_HW_CAP_PAPRD			= BIT(20),
 };
 
 /*
@@ -1061,6 +1062,7 @@ int ar9003_paprd_create_curve(struct ath_hw *ah,
 void ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain);
 int ar9003_paprd_init_table(struct ath_hw *ah);
 bool ar9003_paprd_is_done(struct ath_hw *ah);
+bool ar9003_is_paprd_enabled(struct ath_hw *ah);
 
 /* Hardware family op attach helpers */
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index c70b31a..ade3afb 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -435,7 +435,7 @@ set_timer:
 
 	mod_timer(&common->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
 
-	if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD) && ah->caldata) {
+	if (ar9003_is_paprd_enabled(ah) && ah->caldata) {
 		if (!ah->caldata->paprd_done) {
 			ieee80211_queue_work(sc->hw, &sc->paprd_work);
 		} else if (!ah->paprd_table_write_done) {
-- 
1.8.0.1

