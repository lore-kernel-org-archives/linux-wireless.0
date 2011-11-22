Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24908 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab1KVNWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 08:22:09 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Fix minimum CTL power for each runtime mode
Date: Tue, 22 Nov 2011 18:52:00 +0530
Message-ID: <1321968120-15532-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111122_142214_570879_E096E60F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The conformance test limits (CTL) for each regulatory domains
(FCC/ETSI/MKK) are programmed for each runtime modes (11B,11G,
HT20 and HT40) in EEPROM. The lowest ctledge power value of a
particular running mode should not be used while computing
ctledge power for a different running mode.(i.e 11G's min ctledge
power should not be used while computing ctledge power for HT20).

Currently, the code does not handle this properly which would
result in incorrect txpowers in certain cases. So reset the
twiceMaxEdgePower to the default while computing min ctlegepower
for every mode.

Cc: David Quan <dquan@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    3 ++-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |    6 ++----
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |    3 ++-
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |    6 ++----
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index a93bd63..4ba6f52 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4779,7 +4779,7 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ar9300_eeprom *pEepData = &ah->eeprom.ar9300_eep;
-	u16 twiceMaxEdgePower = MAX_RATE_POWER;
+	u16 twiceMaxEdgePower;
 	int i;
 	u16 scaledPower = 0, minCtlPower;
 	static const u16 ctlModesFor11a[] = {
@@ -4880,6 +4880,7 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
 			ctlNum = AR9300_NUM_CTLS_5G;
 		}
 
+		twiceMaxEdgePower = MAX_RATE_POWER;
 		for (i = 0; (i < ctlNum) && ctlIndex[i]; i++) {
 			ath_dbg(common, ATH_DBG_REGULATORY,
 				"LOOP-Ctlidx %d: cfgCtl 0x%2.2x pCtlMode 0x%2.2x ctlIndex 0x%2.2x chan %d\n",
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 9a7520f..61fcab0 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -473,7 +473,7 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 
 	int i;
 	u16 twiceMinEdgePower;
-	u16 twiceMaxEdgePower = MAX_RATE_POWER;
+	u16 twiceMaxEdgePower;
 	u16 scaledPower = 0, minCtlPower;
 	u16 numCtlModes;
 	const u16 *pCtlMode;
@@ -542,9 +542,7 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 		else
 			freq = centers.ctl_center;
 
-		if (ah->eep_ops->get_eeprom_ver(ah) == 14 &&
-		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
-			twiceMaxEdgePower = MAX_RATE_POWER;
+		twiceMaxEdgePower = MAX_RATE_POWER;
 
 		for (i = 0; (i < AR5416_EEP4K_NUM_CTLS) &&
 			     pEepData->ctlIndex[i]; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 4f5c50a..0981c07 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -569,7 +569,7 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6
 #define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10
 
-	u16 twiceMaxEdgePower = MAX_RATE_POWER;
+	u16 twiceMaxEdgePower;
 	int i;
 	struct cal_ctl_data_ar9287 *rep;
 	struct cal_target_power_leg targetPowerOfdm = {0, {0, 0, 0, 0} },
@@ -669,6 +669,7 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 		else
 			freq = centers.ctl_center;
 
+		twiceMaxEdgePower = MAX_RATE_POWER;
 		/* Walk through the CTL indices stored in EEPROM */
 		for (i = 0; (i < AR9287_NUM_CTLS) && pEepData->ctlIndex[i]; i++) {
 			struct cal_ctl_edges *pRdEdgesPower;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 81e6296..55a21d3 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1000,7 +1000,7 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 #define REDUCE_SCALED_POWER_BY_THREE_CHAIN   9 /* 10*log10(3)*2 */
 
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
-	u16 twiceMaxEdgePower = MAX_RATE_POWER;
+	u16 twiceMaxEdgePower;
 	int i;
 	struct cal_ctl_data *rep;
 	struct cal_target_power_leg targetPowerOfdm, targetPowerCck = {
@@ -1121,9 +1121,7 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 		else
 			freq = centers.ctl_center;
 
-		if (ah->eep_ops->get_eeprom_ver(ah) == 14 &&
-		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
-			twiceMaxEdgePower = MAX_RATE_POWER;
+		twiceMaxEdgePower = MAX_RATE_POWER;
 
 		for (i = 0; (i < AR5416_NUM_CTLS) && pEepData->ctlIndex[i]; i++) {
 			if ((((cfgCtl & ~CTL_MODE_M) |
-- 
1.7.7.4

