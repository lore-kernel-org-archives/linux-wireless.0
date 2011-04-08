Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52430 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab1DHTp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 15:45:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Eugene A. Shatokhin" <dame_eugene@mail.ru>,
	Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	ath5k-devel@venema.h4ckr.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: improve pcal error handling for ENOMEM case
Date: Fri,  8 Apr 2011 15:33:12 -0400
Message-Id: <1302291192-19249-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath5k driver does kmalloc allocations for pcal info in a loop.
But, if one fails it was simply returning -ENOMEM without freeing
already allocated memory.  This patch corrects that oversight.

Reported-by: Eugene A. Shatokhin <dame_eugene@mail.ru>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
The move of ath5k_eeprom_free_pcal_info is just to avoid a forward
declaration.

 drivers/net/wireless/ath/ath5k/eeprom.c |  129 +++++++++++++++++--------------
 1 files changed, 70 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index b6561f7..fb12027 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -660,6 +660,53 @@ ath5k_get_pcdac_intercepts(struct ath5k_hw *ah, u8 min, u8 max, u8 *vp)
 		vp[i] = (ip[i] * max + (100 - ip[i]) * min) / 100;
 }
 
+static int
+ath5k_eeprom_free_pcal_info(struct ath5k_hw *ah, int mode)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	struct ath5k_chan_pcal_info *chinfo;
+	u8 pier, pdg;
+
+	switch (mode) {
+	case AR5K_EEPROM_MODE_11A:
+		if (!AR5K_EEPROM_HDR_11A(ee->ee_header))
+			return 0;
+		chinfo = ee->ee_pwr_cal_a;
+		break;
+	case AR5K_EEPROM_MODE_11B:
+		if (!AR5K_EEPROM_HDR_11B(ee->ee_header))
+			return 0;
+		chinfo = ee->ee_pwr_cal_b;
+		break;
+	case AR5K_EEPROM_MODE_11G:
+		if (!AR5K_EEPROM_HDR_11G(ee->ee_header))
+			return 0;
+		chinfo = ee->ee_pwr_cal_g;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	for (pier = 0; pier < ee->ee_n_piers[mode]; pier++) {
+		if (!chinfo[pier].pd_curves)
+			continue;
+
+		for (pdg = 0; pdg < ee->ee_pd_gains[mode]; pdg++) {
+			struct ath5k_pdgain_info *pd =
+					&chinfo[pier].pd_curves[pdg];
+
+			if (pd != NULL) {
+				kfree(pd->pd_step);
+				kfree(pd->pd_pwr);
+			}
+		}
+
+		kfree(chinfo[pier].pd_curves);
+	}
+
+	return 0;
+}
+
 /* Convert RF5111 specific data to generic raw data
  * used by interpolation code */
 static int
@@ -684,7 +731,7 @@ ath5k_eeprom_convert_pcal_info_5111(struct ath5k_hw *ah, int mode,
 				GFP_KERNEL);
 
 		if (!chinfo[pier].pd_curves)
-			return -ENOMEM;
+			goto err_out;
 
 		/* Only one curve for RF5111
 		 * find out which one and place
@@ -708,12 +755,12 @@ ath5k_eeprom_convert_pcal_info_5111(struct ath5k_hw *ah, int mode,
 		pd->pd_step = kcalloc(AR5K_EEPROM_N_PWR_POINTS_5111,
 					sizeof(u8), GFP_KERNEL);
 		if (!pd->pd_step)
-			return -ENOMEM;
+			goto err_out;
 
 		pd->pd_pwr = kcalloc(AR5K_EEPROM_N_PWR_POINTS_5111,
 					sizeof(s16), GFP_KERNEL);
 		if (!pd->pd_pwr)
-			return -ENOMEM;
+			goto err_out;
 
 		/* Fill raw dataset
 		 * (convert power to 0.25dB units
@@ -734,6 +781,10 @@ ath5k_eeprom_convert_pcal_info_5111(struct ath5k_hw *ah, int mode,
 	}
 
 	return 0;
+
+err_out:
+	ath5k_eeprom_free_pcal_info(ah, mode);
+	return -ENOMEM;
 }
 
 /* Parse EEPROM data */
@@ -867,7 +918,7 @@ ath5k_eeprom_convert_pcal_info_5112(struct ath5k_hw *ah, int mode,
 					GFP_KERNEL);
 
 		if (!chinfo[pier].pd_curves)
-			return -ENOMEM;
+			goto err_out;
 
 		/* Fill pd_curves */
 		for (pdg = 0; pdg < ee->ee_pd_gains[mode]; pdg++) {
@@ -886,14 +937,13 @@ ath5k_eeprom_convert_pcal_info_5112(struct ath5k_hw *ah, int mode,
 						sizeof(u8), GFP_KERNEL);
 
 				if (!pd->pd_step)
-					return -ENOMEM;
+					goto err_out;
 
 				pd->pd_pwr = kcalloc(pd->pd_points,
 						sizeof(s16), GFP_KERNEL);
 
 				if (!pd->pd_pwr)
-					return -ENOMEM;
-
+					goto err_out;
 
 				/* Fill raw dataset
 				 * (all power levels are in 0.25dB units) */
@@ -925,13 +975,13 @@ ath5k_eeprom_convert_pcal_info_5112(struct ath5k_hw *ah, int mode,
 						sizeof(u8), GFP_KERNEL);
 
 				if (!pd->pd_step)
-					return -ENOMEM;
+					goto err_out;
 
 				pd->pd_pwr = kcalloc(pd->pd_points,
 						sizeof(s16), GFP_KERNEL);
 
 				if (!pd->pd_pwr)
-					return -ENOMEM;
+					goto err_out;
 
 				/* Fill raw dataset
 				 * (all power levels are in 0.25dB units) */
@@ -954,6 +1004,10 @@ ath5k_eeprom_convert_pcal_info_5112(struct ath5k_hw *ah, int mode,
 	}
 
 	return 0;
+
+err_out:
+	ath5k_eeprom_free_pcal_info(ah, mode);
+	return -ENOMEM;
 }
 
 /* Parse EEPROM data */
@@ -1156,7 +1210,7 @@ ath5k_eeprom_convert_pcal_info_2413(struct ath5k_hw *ah, int mode,
 					GFP_KERNEL);
 
 		if (!chinfo[pier].pd_curves)
-			return -ENOMEM;
+			goto err_out;
 
 		/* Fill pd_curves */
 		for (pdg = 0; pdg < ee->ee_pd_gains[mode]; pdg++) {
@@ -1177,13 +1231,13 @@ ath5k_eeprom_convert_pcal_info_2413(struct ath5k_hw *ah, int mode,
 					sizeof(u8), GFP_KERNEL);
 
 			if (!pd->pd_step)
-				return -ENOMEM;
+				goto err_out;
 
 			pd->pd_pwr = kcalloc(pd->pd_points,
 					sizeof(s16), GFP_KERNEL);
 
 			if (!pd->pd_pwr)
-				return -ENOMEM;
+				goto err_out;
 
 			/* Fill raw dataset
 			 * convert all pwr levels to
@@ -1213,6 +1267,10 @@ ath5k_eeprom_convert_pcal_info_2413(struct ath5k_hw *ah, int mode,
 	}
 
 	return 0;
+
+err_out:
+	ath5k_eeprom_free_pcal_info(ah, mode);
+	return -ENOMEM;
 }
 
 /* Parse EEPROM data */
@@ -1534,53 +1592,6 @@ ath5k_eeprom_read_pcal_info(struct ath5k_hw *ah)
 	return 0;
 }
 
-static int
-ath5k_eeprom_free_pcal_info(struct ath5k_hw *ah, int mode)
-{
-	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	struct ath5k_chan_pcal_info *chinfo;
-	u8 pier, pdg;
-
-	switch (mode) {
-	case AR5K_EEPROM_MODE_11A:
-		if (!AR5K_EEPROM_HDR_11A(ee->ee_header))
-			return 0;
-		chinfo = ee->ee_pwr_cal_a;
-		break;
-	case AR5K_EEPROM_MODE_11B:
-		if (!AR5K_EEPROM_HDR_11B(ee->ee_header))
-			return 0;
-		chinfo = ee->ee_pwr_cal_b;
-		break;
-	case AR5K_EEPROM_MODE_11G:
-		if (!AR5K_EEPROM_HDR_11G(ee->ee_header))
-			return 0;
-		chinfo = ee->ee_pwr_cal_g;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	for (pier = 0; pier < ee->ee_n_piers[mode]; pier++) {
-		if (!chinfo[pier].pd_curves)
-			continue;
-
-		for (pdg = 0; pdg < ee->ee_pd_gains[mode]; pdg++) {
-			struct ath5k_pdgain_info *pd =
-					&chinfo[pier].pd_curves[pdg];
-
-			if (pd != NULL) {
-				kfree(pd->pd_step);
-				kfree(pd->pd_pwr);
-			}
-		}
-
-		kfree(chinfo[pier].pd_curves);
-	}
-
-	return 0;
-}
-
 /* Read conformance test limits used for regulatory control */
 static int
 ath5k_eeprom_read_ctl_info(struct ath5k_hw *ah)
-- 
1.7.4

