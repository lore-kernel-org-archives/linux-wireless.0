Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33463 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZKPGKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 01:10:16 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 15 Nov 2009 22:10:22 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19200.60653.972167.370247@gargle.gargle.HOWL>
Date: Mon, 16 Nov 2009 11:40:53 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] ath9k: Remove a few unused functions
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ATH9K_ANT_VARIABLE is the default diversity control used.
Consequently ath9k_hw_decrease_chain_power() does nothing.
ath9k_hw_setantennaswitch() is unused too.

Also, gbeacon_rate is unused.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   53 --------------------
 drivers/net/wireless/ath/ath9k/hw.h  |   23 ---------
 drivers/net/wireless/ath/ath9k/phy.c |   90 ----------------------------------
 drivers/net/wireless/ath/ath9k/phy.h |    3 -
 4 files changed, 0 insertions(+), 169 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b25eedf..ffcc4f0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -390,8 +390,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.cck_trig_high = 200;
 	ah->config.cck_trig_low = 100;
 	ah->config.enable_ani = 1;
-	ah->config.diversity_control = ATH9K_ANT_VARIABLE;
-	ah->config.antenna_switch_swap = 0;
 
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 		ah->config.spurchans[i][0] = AR_NO_SPUR;
@@ -446,9 +444,6 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->acktimeout = (u32) -1;
 	ah->ctstimeout = (u32) -1;
 	ah->globaltxtimeout = (u32) -1;
-
-	ah->gbeacon_rate = 0;
-
 	ah->power_mode = ATH9K_PM_UNDEFINED;
 }
 
@@ -2056,9 +2051,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ah->ath9k_hw_spur_mitigate_freq(ah, chan);
 	ah->eep_ops->set_board_values(ah, chan);
 
-	if (AR_SREV_5416(ah))
-		ath9k_hw_decrease_chain_power(ah, chan);
-
 	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
 	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
 		  | macStaId1
@@ -3518,51 +3510,6 @@ void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna)
 }
 EXPORT_SYMBOL(ath9k_hw_setantenna);
 
-bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
-			       enum ath9k_ant_setting settings,
-			       struct ath9k_channel *chan,
-			       u8 *tx_chainmask,
-			       u8 *rx_chainmask,
-			       u8 *antenna_cfgd)
-{
-	static u8 tx_chainmask_cfg, rx_chainmask_cfg;
-
-	if (AR_SREV_9280(ah)) {
-		if (!tx_chainmask_cfg) {
-
-			tx_chainmask_cfg = *tx_chainmask;
-			rx_chainmask_cfg = *rx_chainmask;
-		}
-
-		switch (settings) {
-		case ATH9K_ANT_FIXED_A:
-			*tx_chainmask = ATH9K_ANTENNA0_CHAINMASK;
-			*rx_chainmask = ATH9K_ANTENNA0_CHAINMASK;
-			*antenna_cfgd = true;
-			break;
-		case ATH9K_ANT_FIXED_B:
-			if (ah->caps.tx_chainmask >
-			    ATH9K_ANTENNA1_CHAINMASK) {
-				*tx_chainmask = ATH9K_ANTENNA1_CHAINMASK;
-			}
-			*rx_chainmask = ATH9K_ANTENNA1_CHAINMASK;
-			*antenna_cfgd = true;
-			break;
-		case ATH9K_ANT_VARIABLE:
-			*tx_chainmask = tx_chainmask_cfg;
-			*rx_chainmask = rx_chainmask_cfg;
-			*antenna_cfgd = true;
-			break;
-		default:
-			break;
-		}
-	} else {
-		ah->config.diversity_control = settings;
-	}
-
-	return true;
-}
-
 /*********************/
 /* General Operation */
 /*********************/
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index abaa2f0..f8f5e99 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -148,21 +148,6 @@ enum wireless_mode {
 	ATH9K_MODE_MAX,
 };
 
-/**
- * ath9k_ant_setting - transmit antenna settings
- *
- * Configures the antenna setting to use for transmit.
- *
- * @ATH9K_ANT_VARIABLE: this means transmit on all active antennas
- * @ATH9K_ANT_FIXED_A: this means transmit on the first antenna only
- * @ATH9K_ANT_FIXED_B: this means transmit on the second antenna only
- */
-enum ath9k_ant_setting {
-	ATH9K_ANT_VARIABLE = 0,
-	ATH9K_ANT_FIXED_A,
-	ATH9K_ANT_FIXED_B
-};
-
 enum ath9k_hw_caps {
 	ATH9K_HW_CAP_MIC_AESCCM                 = BIT(0),
 	ATH9K_HW_CAP_MIC_CKIP                   = BIT(1),
@@ -226,8 +211,6 @@ struct ath9k_ops_config {
 	u32 cck_trig_high;
 	u32 cck_trig_low;
 	u32 enable_ani;
-	enum ath9k_ant_setting diversity_control;
-	u16 antenna_switch_swap;
 	int serialize_regmode;
 	bool intr_mitigation;
 #define SPUR_DISABLE        	0
@@ -572,7 +555,6 @@ struct ath_hw {
 	u32 acktimeout;
 	u32 ctstimeout;
 	u32 globaltxtimeout;
-	u8 gbeacon_rate;
 
 	/* ANI */
 	u32 proc_phyerr;
@@ -659,11 +641,6 @@ void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val);
 u32 ath9k_hw_getdefantenna(struct ath_hw *ah);
 void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna);
-bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
-			       enum ath9k_ant_setting settings,
-			       struct ath9k_channel *chan,
-			       u8 *tx_chainmask, u8 *rx_chainmask,
-			       u8 *antenna_cfgd);
 
 /* General Operation */
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout);
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index 13ab4d7..c3b5939 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -528,95 +528,6 @@ static void ath9k_hw_force_bias(struct ath_hw *ah, u16 synth_freq)
 }
 
 /**
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
-void ath9k_hw_decrease_chain_power(struct ath_hw *ah,
-				   struct ath9k_channel *chan)
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
-
-/**
  * ath9k_hw_set_channel - tune to a channel on the external AR2133/AR5133 radios
  * @ah: atheros hardware stucture
  * @chan:
@@ -687,7 +598,6 @@ int ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	}
 
 	ath9k_hw_force_bias(ah, freq);
-	ath9k_hw_decrease_chain_power(ah, chan);
 
 	reg32 =
 	    (channelSel << 8) | (aModeRefSel << 2) | (bModeSynth << 1) |
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index dc145a1..31de27d 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -35,9 +35,6 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
 			  struct ath9k_channel *chan,
 			  u16 modesIndex);
 
-void ath9k_hw_decrease_chain_power(struct ath_hw *ah,
-				   struct ath9k_channel *chan);
-
 #define AR_PHY_BASE     0x9800
 #define AR_PHY(_n)      (AR_PHY_BASE + ((_n)<<2))
 
-- 
1.6.5.2

