Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab0CKB2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 20:28:32 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 10/14] ath9k_hw: add helpers for writing phy errors counts
Date: Wed, 10 Mar 2010 20:28:27 -0500
Message-Id: <1268270911-24568-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
References: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hardware phy error counter are updated through the ANI
code, provide a few helpers which make the access to hardware
easier to abstract.

Extend the documentation of the phy error counts and masks.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |  104 +++++++++++++++++++++++++++++-----
 1 files changed, 89 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 08deda3..52852fc 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -243,6 +243,79 @@ static void ath9k_hw_update_phy_err_masks(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 }
 
+static void ath9k_hw_update_phy_err1_count(struct ath_hw *ah,
+					   u32 err_count,
+					   bool reset_mask)
+{
+	REG_WRITE(ah, AR_PHY_ERR_1, err_count);
+
+	if (reset_mask)
+		REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
+}
+
+static void ath9k_hw_update_phy_err2_count(struct ath_hw *ah,
+					   u32 err_count,
+					   bool reset_mask)
+{
+	REG_WRITE(ah, AR_PHY_ERR_2, err_count);
+
+	if (reset_mask)
+		REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
+}
+
+/**
+ * ath9k_hw_update_phy_err_count - update phy error counts
+ *
+ * @ah: atheros hardware structure
+ * @phy_err_count1: number of OFDM PHY timing errors to set
+ * @phy_err_count2: number of CCK PHY timing errors to set
+ * @reset_masks: whether or not the masks for each counter
+ *	type should be reset to default values
+ *
+ * The hardware keeps track of different types of PHY errors
+ * depending on specific programmed mask for OFDM and CCK. The
+ * registers are used as follows:
+ *
+ *   - 0x8124 Filtered OFDM Frames Count
+ *   - 0x8128 Filtered CCK Frames Count
+ *   - 0x812C Phy Error1 Count
+ *   - 0x8130 Phy Error1 Count Mask
+ *   - 0x8134 Phy Error2 Count
+ *   - 0x8138 Phy Error2 Count Mask
+ *
+ *
+ * The Filtered OFDM Frames Count count OFDM data frames which
+ * were filtered.
+ *
+ * The Filtered CCK Frames Count count CCK data frames which
+ * were filtered.
+ *
+ * The Phy Error1 and Phy Error2 Count will count any phy error
+ * which matches the respective mask (Phy Error1 and Phy Error2
+ * Count Mask).  The bits of 32-bit masks correspond to the first
+ * 32 encoded values of the error.  Setting multiple bits in the
+ * mask will provide an ORing function to provide flexibility in
+ * counting.  For examples if we set the mask bits to 0xFF0000FF:
+ * then all phy errors from 0-7 and 24-31 will be counted.
+ *
+ * The 4 counters will use the PCI MIB control signals.  The PCI
+ * MIB freeze register will hold all the values of these registers.
+ * PCI MIB clear will zero out all the values of these registers.
+ * PCI MIB force will force increment of all the registers each
+ * cycle.  These 4 counters will saturate at the highest value and
+ * are writable.  If the upper two bits of these counters are 'b11
+ * then the pcu_mib_threshold will be asserted and an interrupt
+ * will be generated.
+ */
+static void ath9k_hw_update_phy_err_count(struct ath_hw *ah,
+					  u32 phy_err_count1,
+					  u32 phy_err_count2,
+					  bool reset_masks)
+{
+	ath9k_hw_update_phy_err1_count(ah, phy_err_count1, reset_masks);
+	ath9k_hw_update_phy_err2_count(ah, phy_err_count2, reset_masks);
+}
+
 static void ath9k_ani_restart(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
@@ -274,9 +347,11 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 		  "Writing ofdmbase=%u   cckbase=%u\n",
 		  aniState->ofdmPhyErrBase,
 		  aniState->cckPhyErrBase);
-	REG_WRITE(ah, AR_PHY_ERR_1, aniState->ofdmPhyErrBase);
-	REG_WRITE(ah, AR_PHY_ERR_2, aniState->cckPhyErrBase);
-	ath9k_hw_update_phy_err_masks(ah);
+
+	ath9k_hw_update_phy_err_count(ah,
+				      aniState->ofdmPhyErrBase,
+				      aniState->cckPhyErrBase,
+				      true);
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
@@ -590,10 +665,9 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 				  "counter value to 0x%x\n",
 				  phyCnt1,
 				  aniState->ofdmPhyErrBase);
-			REG_WRITE(ah, AR_PHY_ERR_1,
-				  aniState->ofdmPhyErrBase);
-			REG_WRITE(ah, AR_PHY_ERR_MASK_1,
-				  AR_PHY_ERR_OFDM_TIMING);
+			ath9k_hw_update_phy_err1_count(ah,
+						       aniState->ofdmPhyErrBase,
+						       true);
 		}
 		if (phyCnt2 < aniState->cckPhyErrBase) {
 			ath_print(common, ATH_DBG_ANI,
@@ -601,10 +675,9 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 				  "counter value to 0x%x\n",
 				  phyCnt2,
 				  aniState->cckPhyErrBase);
-			REG_WRITE(ah, AR_PHY_ERR_2,
-				  aniState->cckPhyErrBase);
-			REG_WRITE(ah, AR_PHY_ERR_MASK_2,
-				  AR_PHY_ERR_CCK_TIMING);
+			ath9k_hw_update_phy_err2_count(ah,
+						       aniState->cckPhyErrBase,
+						       true);
 		}
 		return;
 	}
@@ -818,8 +891,10 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 	ath_print(common, ATH_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
 		  ah->ani[0].cckPhyErrBase);
 
-	REG_WRITE(ah, AR_PHY_ERR_1, ah->ani[0].ofdmPhyErrBase);
-	REG_WRITE(ah, AR_PHY_ERR_2, ah->ani[0].cckPhyErrBase);
+	ath9k_hw_update_phy_err_count(ah,
+				      ah->ani[0].ofdmPhyErrBase,
+				      ah->ani[0].cckPhyErrBase,
+				      false);
 	ath9k_enable_mib_counters(ah);
 
 	ah->aniperiod = ATH9K_ANI_PERIOD;
@@ -832,6 +907,5 @@ void ath9k_hw_ani_disable(struct ath_hw *ah)
 	ath_print(ath9k_hw_common(ah), ATH_DBG_ANI, "Disabling ANI\n");
 
 	ath9k_hw_disable_mib_counters(ah);
-	REG_WRITE(ah, AR_PHY_ERR_1, 0);
-	REG_WRITE(ah, AR_PHY_ERR_2, 0);
+	ath9k_hw_update_phy_err_count(ah, 0, 0, false);
 }
-- 
1.6.3.3

