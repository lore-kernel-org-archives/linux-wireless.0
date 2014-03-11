Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58782 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbaCKPK5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 11:10:57 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 1/2] ath9k_hw: set ANI cycpwr_thr1 as absolute values instead of relative
Date: Tue, 11 Mar 2014 16:10:33 +0100
Message-Id: <1394550634-42976-1-git-send-email-nbd@openwrt.org> (sfid-20140311_161107_302240_CABA27E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The table was copied from the ANI implementation of AR9300. It assumes
that the INI values contain a baseline value that is usable as reference
from which to increase/decrease based on the noise immunity value.

On older chips, the differences are bigger and especially AR5008/AR9001
are configured to much more sensitive values than what is useful.

Improve ANI behavior by reverting to the absolute values used in the
previous implementation (expressed as a simple formula instead of the
old table).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 44 ++++-------------------------
 1 file changed, 6 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index ff415e8..504e189 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -26,10 +26,6 @@ static const int firstep_table[] =
 /* level:  0   1   2   3   4   5   6   7   8  */
 	{ -4, -2,  0,  2,  4,  6,  8, 10, 12 }; /* lvl 0-8, default 2 */
 
-static const int cycpwrThr1_table[] =
-/* level:  0   1   2   3   4   5   6   7   8  */
-	{ -6, -4, -2,  0,  2,  4,  6,  8 };     /* lvl 0-7, default 3 */
-
 /*
  * register values to turn OFDM weak signal detection OFF
  */
@@ -1073,41 +1069,13 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 	case ATH9K_ANI_SPUR_IMMUNITY_LEVEL:{
 		u32 level = param;
 
-		if (level >= ARRAY_SIZE(cycpwrThr1_table)) {
-			ath_dbg(common, ANI,
-				"ATH9K_ANI_SPUR_IMMUNITY_LEVEL: level out of range (%u > %zu)\n",
-				level, ARRAY_SIZE(cycpwrThr1_table));
-			return false;
-		}
-		/*
-		 * make register setting relative to default
-		 * from INI file & cap value
-		 */
-		value = cycpwrThr1_table[level] -
-			cycpwrThr1_table[ATH9K_ANI_SPUR_IMMUNE_LVL] +
-			aniState->iniDef.cycpwrThr1;
-		if (value < ATH9K_SIG_SPUR_IMM_SETTING_MIN)
-			value = ATH9K_SIG_SPUR_IMM_SETTING_MIN;
-		if (value > ATH9K_SIG_SPUR_IMM_SETTING_MAX)
-			value = ATH9K_SIG_SPUR_IMM_SETTING_MAX;
+		value = (level + 1) * 2;
 		REG_RMW_FIELD(ah, AR_PHY_TIMING5,
-			      AR_PHY_TIMING5_CYCPWR_THR1,
-			      value);
+			      AR_PHY_TIMING5_CYCPWR_THR1, value);
 
-		/*
-		 * set AR_PHY_EXT_CCA for extension channel
-		 * make register setting relative to default
-		 * from INI file & cap value
-		 */
-		value2 = cycpwrThr1_table[level] -
-			 cycpwrThr1_table[ATH9K_ANI_SPUR_IMMUNE_LVL] +
-			 aniState->iniDef.cycpwrThr1Ext;
-		if (value2 < ATH9K_SIG_SPUR_IMM_SETTING_MIN)
-			value2 = ATH9K_SIG_SPUR_IMM_SETTING_MIN;
-		if (value2 > ATH9K_SIG_SPUR_IMM_SETTING_MAX)
-			value2 = ATH9K_SIG_SPUR_IMM_SETTING_MAX;
-		REG_RMW_FIELD(ah, AR_PHY_EXT_CCA,
-			      AR_PHY_EXT_TIMING5_CYCPWR_THR1, value2);
+		if (IS_CHAN_HT40(ah->curchan))
+			REG_RMW_FIELD(ah, AR_PHY_EXT_CCA,
+				      AR_PHY_EXT_TIMING5_CYCPWR_THR1, value);
 
 		if (level != aniState->spurImmunityLevel) {
 			ath_dbg(common, ANI,
@@ -1124,7 +1092,7 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 				aniState->spurImmunityLevel,
 				level,
 				ATH9K_ANI_SPUR_IMMUNE_LVL,
-				value2,
+				value,
 				aniState->iniDef.cycpwrThr1Ext);
 			if (level > aniState->spurImmunityLevel)
 				ah->stats.ast_ani_spurup++;
-- 
1.8.3.4 (Apple Git-47)

