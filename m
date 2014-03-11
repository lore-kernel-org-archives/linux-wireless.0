Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58780 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbaCKPK5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 11:10:57 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 2/2] ath9k_hw: set ANI firstep as absolute values instead of relative
Date: Tue, 11 Mar 2014 16:10:34 +0100
Message-Id: <1394550634-42976-2-git-send-email-nbd@openwrt.org> (sfid-20140311_161107_924462_83FA9B78)
In-Reply-To: <1394550634-42976-1-git-send-email-nbd@openwrt.org>
References: <1394550634-42976-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On older chips, the INI value differ in similar ways as cycpwr_thr1, so
convert it to absolute values as well.

Since the ANI algorithm is different here compared to the old
implementation (fewer steps, controlled at a different point in time),
it makes sense to use values similar to what would be applied for newer
chips, just without relying on INI defaults.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 41 ++++-------------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 504e189..3b3e910 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -917,7 +917,7 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_channel *chan = ah->curchan;
 	struct ar5416AniState *aniState = &ah->ani;
-	s32 value, value2;
+	s32 value;
 
 	switch (cmd & ah->ani_function) {
 	case ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION:{
@@ -1004,42 +1004,11 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 	case ATH9K_ANI_FIRSTEP_LEVEL:{
 		u32 level = param;
 
-		if (level >= ARRAY_SIZE(firstep_table)) {
-			ath_dbg(common, ANI,
-				"ATH9K_ANI_FIRSTEP_LEVEL: level out of range (%u > %zu)\n",
-				level, ARRAY_SIZE(firstep_table));
-			return false;
-		}
-
-		/*
-		 * make register setting relative to default
-		 * from INI file & cap value
-		 */
-		value = firstep_table[level] -
-			firstep_table[ATH9K_ANI_FIRSTEP_LVL] +
-			aniState->iniDef.firstep;
-		if (value < ATH9K_SIG_FIRSTEP_SETTING_MIN)
-			value = ATH9K_SIG_FIRSTEP_SETTING_MIN;
-		if (value > ATH9K_SIG_FIRSTEP_SETTING_MAX)
-			value = ATH9K_SIG_FIRSTEP_SETTING_MAX;
+		value = level * 2;
 		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
-			      AR_PHY_FIND_SIG_FIRSTEP,
-			      value);
-		/*
-		 * we need to set first step low register too
-		 * make register setting relative to default
-		 * from INI file & cap value
-		 */
-		value2 = firstep_table[level] -
-			 firstep_table[ATH9K_ANI_FIRSTEP_LVL] +
-			 aniState->iniDef.firstepLow;
-		if (value2 < ATH9K_SIG_FIRSTEP_SETTING_MIN)
-			value2 = ATH9K_SIG_FIRSTEP_SETTING_MIN;
-		if (value2 > ATH9K_SIG_FIRSTEP_SETTING_MAX)
-			value2 = ATH9K_SIG_FIRSTEP_SETTING_MAX;
-
+			      AR_PHY_FIND_SIG_FIRSTEP, value);
 		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG_LOW,
-			      AR_PHY_FIND_SIG_FIRSTEP_LOW, value2);
+			      AR_PHY_FIND_SIG_FIRSTEP_LOW, value);
 
 		if (level != aniState->firstepLevel) {
 			ath_dbg(common, ANI,
@@ -1056,7 +1025,7 @@ static bool ar5008_hw_ani_control_new(struct ath_hw *ah,
 				aniState->firstepLevel,
 				level,
 				ATH9K_ANI_FIRSTEP_LVL,
-				value2,
+				value,
 				aniState->iniDef.firstepLow);
 			if (level > aniState->firstepLevel)
 				ah->stats.ast_ani_stepup++;
-- 
1.8.3.4 (Apple Git-47)

