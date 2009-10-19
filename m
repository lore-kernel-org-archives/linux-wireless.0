Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 15/15] ath9k_hw: make ath9k_phy_modify_rx_buffer() static
Date: Mon, 19 Oct 2009 02:33:46 -0400
Message-Id: <1255934026-20686-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To do this we reorder callers in order in which they are called.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/phy.c |  256 +++++++++++++++++-----------------
 1 files changed, 126 insertions(+), 130 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index df55e28..13ab4d7 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -41,10 +41,6 @@
 
 #include "hw.h"
 
-static void ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
-				       u32 numBits, u32 firstBit,
-				       u32 column);
-
 /**
  * ath9k_hw_write_regs - ??
  *
@@ -433,6 +429,43 @@ void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
 
 /* All code below is for non single-chip solutions */
 
+/**
+ * ath9k_phy_modify_rx_buffer() - perform analog swizzling of parameters
+ * @rfbuf:
+ * @reg32:
+ * @numBits:
+ * @firstBit:
+ * @column:
+ *
+ * Performs analog "swizzling" of parameters into their location.
+ * Used on external AR2133/AR5133 radios.
+ */
+static void ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
+				       u32 numBits, u32 firstBit,
+				       u32 column)
+{
+	u32 tmp32, mask, arrayEntry, lastBit;
+	int32_t bitPosition, bitsLeft;
+
+	tmp32 = ath9k_hw_reverse_bits(reg32, numBits);
+	arrayEntry = (firstBit - 1) / 8;
+	bitPosition = (firstBit - 1) % 8;
+	bitsLeft = numBits;
+	while (bitsLeft > 0) {
+		lastBit = (bitPosition + bitsLeft > 8) ?
+		    8 : bitPosition + bitsLeft;
+		mask = (((1 << lastBit) - 1) ^ ((1 << bitPosition) - 1)) <<
+		    (column * 8);
+		rfBuf[arrayEntry] &= ~mask;
+		rfBuf[arrayEntry] |= ((tmp32 << bitPosition) <<
+				      (column * 8)) & mask;
+		bitsLeft -= 8 - bitPosition;
+		tmp32 = tmp32 >> (8 - bitPosition);
+		bitPosition = 0;
+		arrayEntry++;
+	}
+}
+
 /*
  * Fix on 2.4 GHz band for orientation sensitivity issue by increasing
  * rf_pwd_icsyndiv.
@@ -495,6 +528,95 @@ static void ath9k_hw_force_bias(struct ath_hw *ah, u16 synth_freq)
 }
 
 /**
+ * ath9k_hw_decrease_chain_power()
+ *
+ * @ah: atheros hardware structure
+ * @chan:
+ *
+ * Only used on the AR5416 and AR5418 with the external AR2133/AR5133 radios.
+ *
+ * Sets a chain internal RF path to the lowest output power. Any
+ * further writes to bank6 after this setting will override these
+ * changes. Thus this function must be the last function in the
+ * sequence to modify bank 6.
+ *
+ * This function must be called after ar5416SetRfRegs() which is
+ * called from ath9k_hw_process_ini() due to swizzling of bank 6.
+ * Depends on ah->analogBank6Data being initialized by
+ * ath9k_hw_set_rf_regs()
+ *
+ * Additional additive reduction in power -
+ * change chain's switch table so chain's tx state is actually the rx
+ * state value. May produce different results in 2GHz/5GHz as well as
+ * board to board but in general should be a reduction.
+ *
+ * Activated by #ifdef ALTER_SWITCH.  Not tried yet.  If so, must be
+ * called after ah->eep_ops->set_board_values() due to RMW of
+ * PHY_SWITCH_CHAIN_0.
+ */
+void ath9k_hw_decrease_chain_power(struct ath_hw *ah,
+				   struct ath9k_channel *chan)
+{
+	int i, regWrites = 0;
+	u32 bank6SelMask;
+	u32 *bank6Temp = ah->bank6Temp;
+
+	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
+
+	switch (ah->config.diversity_control) {
+	case ATH9K_ANT_FIXED_A:
+		bank6SelMask =
+		    (ah->config.antenna_switch_swap & ANTSWAP_AB) ?
+			REDUCE_CHAIN_0 : /* swapped, reduce chain 0 */
+			REDUCE_CHAIN_1; /* normal, select chain 1/2 to reduce */
+		break;
+	case ATH9K_ANT_FIXED_B:
+		bank6SelMask =
+		    (ah->config.antenna_switch_swap & ANTSWAP_AB) ?
+			REDUCE_CHAIN_1 : /* swapped, reduce chain 1/2 */
+			REDUCE_CHAIN_0; /* normal, select chain 0 to reduce */
+		break;
+	case ATH9K_ANT_VARIABLE:
+		return; /* do not change anything */
+		break;
+	default:
+		return; /* do not change anything */
+		break;
+	}
+
+	for (i = 0; i < ah->iniBank6.ia_rows; i++)
+		bank6Temp[i] = ah->analogBank6Data[i];
+
+	/* Write Bank 5 to switch Bank 6 write to selected chain only */
+	REG_WRITE(ah, AR_PHY_BASE + 0xD8, bank6SelMask);
+
+	/*
+	 * Modify Bank6 selected chain to use lowest amplification.
+	 * Modifies the parameters to a value of 1.
+	 * Depends on existing bank 6 values to be cached in
+	 * ah->analogBank6Data
+	 */
+	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 189, 0);
+	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 190, 0);
+	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 191, 0);
+	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 192, 0);
+	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 193, 0);
+	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 222, 0);
+	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 245, 0);
+	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 246, 0);
+	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 247, 0);
+
+	REG_WRITE_RF_ARRAY(&ah->iniBank6, bank6Temp, regWrites);
+
+	REG_WRITE(ah, AR_PHY_BASE + 0xD8, 0x00000053);
+#ifdef ALTER_SWITCH
+	REG_WRITE(ah, PHY_SWITCH_CHAIN_0,
+		  (REG_READ(ah, PHY_SWITCH_CHAIN_0) & ~0x38)
+		  | ((REG_READ(ah, PHY_SWITCH_CHAIN_0) >> 3) & 0x38));
+#endif
+}
+
+/**
  * ath9k_hw_set_channel - tune to a channel on the external AR2133/AR5133 radios
  * @ah: atheros hardware stucture
  * @chan:
@@ -853,43 +975,6 @@ ath9k_hw_rf_free_ext_banks(struct ath_hw *ah)
 #undef ATH_FREE_BANK
 }
 
-/**
- * ath9k_phy_modify_rx_buffer() - perform analog swizzling of parameters
- * @rfbuf:
- * @reg32:
- * @numBits:
- * @firstBit:
- * @column:
- *
- * Performs analog "swizzling" of parameters into their location.
- * Used on external AR2133/AR5133 radios.
- */
-static void ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
-				       u32 numBits, u32 firstBit,
-				       u32 column)
-{
-	u32 tmp32, mask, arrayEntry, lastBit;
-	int32_t bitPosition, bitsLeft;
-
-	tmp32 = ath9k_hw_reverse_bits(reg32, numBits);
-	arrayEntry = (firstBit - 1) / 8;
-	bitPosition = (firstBit - 1) % 8;
-	bitsLeft = numBits;
-	while (bitsLeft > 0) {
-		lastBit = (bitPosition + bitsLeft > 8) ?
-		    8 : bitPosition + bitsLeft;
-		mask = (((1 << lastBit) - 1) ^ ((1 << bitPosition) - 1)) <<
-		    (column * 8);
-		rfBuf[arrayEntry] &= ~mask;
-		rfBuf[arrayEntry] |= ((tmp32 << bitPosition) <<
-				      (column * 8)) & mask;
-		bitsLeft -= 8 - bitPosition;
-		tmp32 = tmp32 >> (8 - bitPosition);
-		bitPosition = 0;
-		arrayEntry++;
-	}
-}
-
 /* *
  * ath9k_hw_set_rf_regs - programs rf registers based on EEPROM
  * @ah: atheros hardware structure
@@ -979,92 +1064,3 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	return true;
 }
-
-/**
- * ath9k_hw_decrease_chain_power()
- *
- * @ah: atheros hardware structure
- * @chan:
- *
- * Only used on the AR5416 and AR5418 with the external AR2133/AR5133 radios.
- *
- * Sets a chain internal RF path to the lowest output power. Any
- * further writes to bank6 after this setting will override these
- * changes. Thus this function must be the last function in the
- * sequence to modify bank 6.
- *
- * This function must be called after ar5416SetRfRegs() which is
- * called from ath9k_hw_process_ini() due to swizzling of bank 6.
- * Depends on ah->analogBank6Data being initialized by
- * ath9k_hw_set_rf_regs()
- *
- * Additional additive reduction in power -
- * change chain's switch table so chain's tx state is actually the rx
- * state value. May produce different results in 2GHz/5GHz as well as
- * board to board but in general should be a reduction.
- *
- * Activated by #ifdef ALTER_SWITCH.  Not tried yet.  If so, must be
- * called after ah->eep_ops->set_board_values() due to RMW of
- * PHY_SWITCH_CHAIN_0.
- */
-void
-ath9k_hw_decrease_chain_power(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	int i, regWrites = 0;
-	u32 bank6SelMask;
-	u32 *bank6Temp = ah->bank6Temp;
-
-	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
-
-	switch (ah->config.diversity_control) {
-	case ATH9K_ANT_FIXED_A:
-		bank6SelMask =
-		    (ah->config.antenna_switch_swap & ANTSWAP_AB) ?
-			REDUCE_CHAIN_0 : /* swapped, reduce chain 0 */
-			REDUCE_CHAIN_1; /* normal, select chain 1/2 to reduce */
-		break;
-	case ATH9K_ANT_FIXED_B:
-		bank6SelMask =
-		    (ah->config.antenna_switch_swap & ANTSWAP_AB) ?
-			REDUCE_CHAIN_1 : /* swapped, reduce chain 1/2 */
-			REDUCE_CHAIN_0; /* normal, select chain 0 to reduce */
-		break;
-	case ATH9K_ANT_VARIABLE:
-		return; /* do not change anything */
-		break;
-	default:
-		return; /* do not change anything */
-		break;
-	}
-
-	for (i = 0; i < ah->iniBank6.ia_rows; i++)
-		bank6Temp[i] = ah->analogBank6Data[i];
-
-	/* Write Bank 5 to switch Bank 6 write to selected chain only */
-	REG_WRITE(ah, AR_PHY_BASE + 0xD8, bank6SelMask);
-
-	/*
-	 * Modify Bank6 selected chain to use lowest amplification.
-	 * Modifies the parameters to a value of 1.
-	 * Depends on existing bank 6 values to be cached in
-	 * ah->analogBank6Data
-	 */
-	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 189, 0);
-	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 190, 0);
-	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 191, 0);
-	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 192, 0);
-	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 193, 0);
-	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 222, 0);
-	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 245, 0);
-	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 246, 0);
-	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 247, 0);
-
-	REG_WRITE_RF_ARRAY(&ah->iniBank6, bank6Temp, regWrites);
-
-	REG_WRITE(ah, AR_PHY_BASE + 0xD8, 0x00000053);
-#ifdef ALTER_SWITCH
-	REG_WRITE(ah, PHY_SWITCH_CHAIN_0,
-		  (REG_READ(ah, PHY_SWITCH_CHAIN_0) & ~0x38)
-		  | ((REG_READ(ah, PHY_SWITCH_CHAIN_0) >> 3) & 0x38));
-#endif
-}
-- 
1.6.0.4

