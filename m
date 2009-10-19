Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 14/15] ath9k_hw: Fix and complete force bias for AR5416
Date: Mon, 19 Oct 2009 02:33:45 -0400
Message-Id: <1255934026-20686-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Force bias is a fix for usage of AR5416 radios on the 2.4 GHz band
for orientation sensitivity. This was only partially implemented
with the ath9k_hw_decrease_chain_power() but first -- this was being
called for all chipsets which is not correct and second -- it was
missing the actual orientation code.

We now ensure to only enable force bias only for AR5416 and BUG_ON()
on other chipsets. Although ath9k_hw_decrease_chain_power() was enabled
for newer chipsets I suspect that it never ran unless the EEPROM had
ATH9K_ANT_FIXED_A or ATH9K_ANT_FIXED_B for antenna diversity.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    4 +-
 drivers/net/wireless/ath/ath9k/phy.c |   70 ++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d435369..db95876 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2054,7 +2054,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ah->ath9k_hw_spur_mitigate_freq(ah, chan);
 	ah->eep_ops->set_board_values(ah, chan);
-	ath9k_hw_decrease_chain_power(ah, chan);
+
+	if (AR_SREV_5416(ah))
+		ath9k_hw_decrease_chain_power(ah, chan);
 
 	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
 	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index a15532e..df55e28 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -41,6 +41,10 @@
 
 #include "hw.h"
 
+static void ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
+				       u32 numBits, u32 firstBit,
+				       u32 column);
+
 /**
  * ath9k_hw_write_regs - ??
  *
@@ -429,6 +433,67 @@ void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
 
 /* All code below is for non single-chip solutions */
 
+/*
+ * Fix on 2.4 GHz band for orientation sensitivity issue by increasing
+ * rf_pwd_icsyndiv.
+ *
+ * Theoretical Rules:
+ *   if 2 GHz band
+ *      if forceBiasAuto
+ *         if synth_freq < 2412
+ *            bias = 0
+ *         else if 2412 <= synth_freq <= 2422
+ *            bias = 1
+ *         else // synth_freq > 2422
+ *            bias = 2
+ *      else if forceBias > 0
+ *         bias = forceBias & 7
+ *      else
+ *         no change, use value from ini file
+ *   else
+ *      no change, invalid band
+ *
+ *  1st Mod:
+ *    2422 also uses value of 2
+ *    <approved>
+ *
+ *  2nd Mod:
+ *    Less than 2412 uses value of 0, 2412 and above uses value of 2
+ */
+static void ath9k_hw_force_bias(struct ath_hw *ah, u16 synth_freq)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 tmp_reg;
+	int reg_writes = 0;
+	u32 new_bias = 0;
+
+	if (!AR_SREV_5416(ah) || synth_freq >= 3000) {
+		return;
+	}
+
+	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
+
+	if (synth_freq < 2412)
+		new_bias = 0;
+	else if (synth_freq < 2422)
+		new_bias = 1;
+	else
+		new_bias = 2;
+
+	/* pre-reverse this field */
+	tmp_reg = ath9k_hw_reverse_bits(new_bias, 3);
+
+	ath_print(common, ATH_DBG_CONFIG,
+		  "Force rf_pwd_icsyndiv to %1d on %4d\n",
+		  new_bias, synth_freq);
+
+	/* swizzle rf_pwd_icsyndiv */
+	ath9k_phy_modify_rx_buffer(ah->analogBank6Data, tmp_reg, 3, 181, 3);
+
+	/* write Bank 6 with new params */
+	REG_WRITE_RF_ARRAY(&ah->iniBank6, ah->analogBank6Data, reg_writes);
+}
+
 /**
  * ath9k_hw_set_channel - tune to a channel on the external AR2133/AR5133 radios
  * @ah: atheros hardware stucture
@@ -499,6 +564,9 @@ int ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 		return -EINVAL;
 	}
 
+	ath9k_hw_force_bias(ah, freq);
+	ath9k_hw_decrease_chain_power(ah, chan);
+
 	reg32 =
 	    (channelSel << 8) | (aModeRefSel << 2) | (bModeSynth << 1) |
 	    (1 << 5) | 0x1;
@@ -946,6 +1014,8 @@ ath9k_hw_decrease_chain_power(struct ath_hw *ah, struct ath9k_channel *chan)
 	u32 bank6SelMask;
 	u32 *bank6Temp = ah->bank6Temp;
 
+	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
+
 	switch (ah->config.diversity_control) {
 	case ATH9K_ANT_FIXED_A:
 		bank6SelMask =
-- 
1.6.0.4

