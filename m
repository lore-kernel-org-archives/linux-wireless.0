Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54680 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 04/15] ath9k_hw: start documenting 802.11n RF anlong front ends
Date: Mon, 19 Oct 2009 02:33:35 -0400
Message-Id: <1255934026-20686-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Document what we can about the RF analog front ends (radios)
of Atheros 802.11n devices. What should be clearer now is the
what we do for old pre AR5416 and AR5418 MAC based devices in
comparison to the modern sigle-chip 802.11n solutions.

All devices after AR9280 are single chip and require less
programming -- the RF registers no longer need to be initialized
as they all have the RF analog front end embedded together with
the MAC/BB; this includes the AR9271. Older devices such as the
ones with the AR5416 MACs (PCI) or AR5418 MACs (PCI-E) have an
external 2.4 GHz AR2133 radio or a dual band 2.4 GHz / 5 GHz
AR5133 radio. These external radios require additional programming
of the RF registers.

Clarify which parts are for what devices and which code is
shared. This patch has no functional changes.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.h  |    9 ++
 drivers/net/wireless/ath/ath9k/phy.c |  166 +++++++++++++++++++++++++++++++++-
 2 files changed, 170 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0b3fc4e..8fe64cf 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -148,6 +148,15 @@ enum wireless_mode {
 	ATH9K_MODE_MAX,
 };
 
+/**
+ * ath9k_ant_setting - transmit antenna settings
+ *
+ * Configures the antenna setting to use for transmit.
+ *
+ * @ATH9K_ANT_VARIABLE: this means transmit on all active antennas
+ * @ATH9K_ANT_FIXED_A: this means transmit on the first antenna only
+ * @ATH9K_ANT_FIXED_B: this means transmit on the second antenna only
+ */
 enum ath9k_ant_setting {
 	ATH9K_ANT_VARIABLE = 0,
 	ATH9K_ANT_FIXED_A,
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index 72a17c4..9e51503 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -14,8 +14,44 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+/**
+ * DOC: Programming Atheros 802.11n analog front end radios
+ *
+ * AR5416 MAC based PCI devices and AR518 MAC based PCI-Express
+ * devices have either an external AR2133 analog front end radio for single
+ * band 2.4 GHz communication or an AR5133 analog front end radio for dual
+ * band 2.4 GHz / 5 GHz communication.
+ *
+ * All devices after the AR5416 and AR5418 family starting with the AR9280
+ * have their analog front radios, MAC/BB and host PCIe/USB interface embedded
+ * into a single-chip and require less programming.
+ *
+ * The following single-chips exist with a respective embedded radio:
+ *
+ * AR9280 - 11n dual-band 2x2 MIMO for PCIe
+ * AR9281 - 11n single-band 1x2 MIMO for PCIe
+ * AR9285 - 11n single-band 1x1 for PCIe
+ * AR9287 - 11n single-band 2x2 MIMO for PCIe
+ *
+ * AR9220 - 11n dual-band 2x2 MIMO for PCI
+ * AR9223 - 11n single-band 2x2 MIMO for PCI
+ *
+ * AR9287 - 11n single-band 1x1 MIMO for USB
+ */
+
 #include "hw.h"
 
+/**
+ * ath9k_hw_write_regs - ??
+ *
+ * @ah: atheros hardware structure
+ * @modesIndex:
+ * @freqIndex:
+ * @regWrites:
+ *
+ * Used for both the chipsets with an external AR2133/AR5133 radios and
+ * single-chip devices.
+ */
 void
 ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex, u32 freqIndex,
 		    int regWrites)
@@ -23,6 +59,15 @@ ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex, u32 freqIndex,
 	REG_WRITE_ARRAY(&ah->iniBB_RfGain, freqIndex, regWrites);
 }
 
+/**
+ * ath9k_hw_set_channel - tune to a channel on the external AR2133/AR5133 radios
+ * @ah: atheros hardware stucture
+ * @chan:
+ *
+ * For the external AR2133/AR5133 radios, takes the MHz channel value and set
+ * the channel value. Assumes writes enabled to analog bus and bank6 register
+ * cache in ah->analogBank6Data.
+ */
 bool
 ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 {
@@ -97,6 +142,27 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	return true;
 }
 
+/**
+ * ath9k_hw_ar9280_set_channel - set channel on single-chip device
+ * @ah: atheros hardware structure
+ * @chan:
+ *
+ * This is the function to change channel on single-chip devices, that is
+ * all devices after ar9280.
+ *
+ * This function takes the channel value in MHz and sets
+ * hardware channel value. Assumes writes have been enabled to analog bus.
+ *
+ * Actual Expression,
+ *
+ * For 2GHz channel,
+ * Channel Frequency = (3/4) * freq_ref * (chansel[8:0] + chanfrac[16:0]/2^17)
+ * (freq_ref = 40MHz)
+ *
+ * For 5GHz channel,
+ * Channel Frequency = (3/2) * freq_ref * (chansel[8:0] + chanfrac[16:0]/2^10)
+ * (freq_ref = 40MHz/(24>>amodeRefSel))
+ */
 void ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 				 struct ath9k_channel *chan)
 {
@@ -111,7 +177,7 @@ void ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 	reg32 = REG_READ(ah, AR_PHY_SYNTH_CONTROL);
 	reg32 &= 0xc0000000;
 
-	if (freq < 4800) {
+	if (freq < 4800) { /* 2 GHz, fractional mode */
 		u32 txctl;
 		int regWrites = 0;
 
@@ -122,6 +188,7 @@ void ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 
 		if (AR_SREV_9287_11_OR_LATER(ah)) {
 			if (freq == 2484) {
+				/* Enable channel spreading for channel 14 */
 				REG_WRITE_ARRAY(&ah->iniCckfirJapan2484,
 						1, regWrites);
 			} else {
@@ -155,10 +222,15 @@ void ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 		case 1:
 		default:
 			aModeRefSel = 0;
+			/*
+			 * Enable 2G (fractional) mode for channels
+			 * which are 5MHz spaced.
+			 */
 			fracMode = 1;
 			refDivA = 1;
 			channelSel = (freq * 0x8000) / 15;
 
+			/* RefDivA setting */
 			REG_RMW_FIELD(ah, AR_AN_SYNTH9,
 				      AR_AN_SYNTH9_REFDIVA, refDivA);
 
@@ -182,6 +254,17 @@ void ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 	ah->curchan_rad_index = -1;
 }
 
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
 static void
 ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
 			   u32 numBits, u32 firstBit,
@@ -209,6 +292,18 @@ ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
 	}
 }
 
+/* *
+ * ath9k_hw_set_rf_regs - programs rf registers based on EEPROM
+ * @ah: atheros hardware structure
+ * @chan:
+ * @modesIndex:
+ *
+ * Used for the external AR2133/AR5133 radios.
+ *
+ * Reads the EEPROM header info from the device structure and programs
+ * all rf registers. This routine requires access to the analog
+ * rf device. This is not required for single-chip devices.
+ */
 bool
 ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 		     u16 modesIndex)
@@ -218,17 +313,27 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 	u32 ob2GHz = 0, db2GHz = 0;
 	int regWrites = 0;
 
+	/*
+	 * Software does not need to program bank data
+	 * for single chip devices, that is AR9280 or anything
+	 * after that.
+	 */
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		return true;
 
+	/* Setup rf parameters */
 	eepMinorRev = ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV);
 
+	/* Setup Bank 0 Write */
 	RF_BANK_SETUP(ah->analogBank0Data, &ah->iniBank0, 1);
 
+	/* Setup Bank 1 Write */
 	RF_BANK_SETUP(ah->analogBank1Data, &ah->iniBank1, 1);
 
+	/* Setup Bank 2 Write */
 	RF_BANK_SETUP(ah->analogBank2Data, &ah->iniBank2, 1);
 
+	/* Setup Bank 6 Write */
 	RF_BANK_SETUP(ah->analogBank3Data, &ah->iniBank3,
 		      modesIndex);
 	{
@@ -239,6 +344,7 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 		}
 	}
 
+	/* Only the 5 or 2 GHz OB/DB need to be set for a mode */
 	if (eepMinorRev >= 2) {
 		if (IS_CHAN_2GHZ(chan)) {
 			ob2GHz = ah->eep_ops->get_eeprom(ah, EEP_OB_2);
@@ -257,8 +363,10 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 		}
 	}
 
+	/* Setup Bank 7 Setup */
 	RF_BANK_SETUP(ah->analogBank7Data, &ah->iniBank7, 1);
 
+	/* Write Analog registers */
 	REG_WRITE_RF_ARRAY(&ah->iniBank0, ah->analogBank0Data,
 			   regWrites);
 	REG_WRITE_RF_ARRAY(&ah->iniBank1, ah->analogBank1Data,
@@ -275,6 +383,11 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 	return true;
 }
 
+/**
+ * ath9k_hw_rf_free - Free memory for analog bank scratch buffers
+ * @ah: atheros hardware struture
+ * For the external AR2133/AR5133 radios.
+ */
 void
 ath9k_hw_rf_free(struct ath_hw *ah)
 {
@@ -295,6 +408,13 @@ ath9k_hw_rf_free(struct ath_hw *ah)
 #undef ATH_FREE_BANK
 }
 
+/**
+ * ath9k_hw_init_rf - initialize external radio structures
+ * @ah: atheros hardware structure
+ * @status:
+ *
+ * Only required for older devices with external AR2133/AR5133 radios.
+ */
 bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -360,6 +480,33 @@ bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 	return true;
 }
 
+/**
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
 void
 ath9k_hw_decrease_chain_power(struct ath_hw *ah, struct ath9k_channel *chan)
 {
@@ -371,26 +518,35 @@ ath9k_hw_decrease_chain_power(struct ath_hw *ah, struct ath9k_channel *chan)
 	case ATH9K_ANT_FIXED_A:
 		bank6SelMask =
 		    (ah->config.antenna_switch_swap & ANTSWAP_AB) ?
-			REDUCE_CHAIN_0 : REDUCE_CHAIN_1;
+			REDUCE_CHAIN_0 : /* swapped, reduce chain 0 */
+			REDUCE_CHAIN_1; /* normal, select chain 1/2 to reduce */
 		break;
 	case ATH9K_ANT_FIXED_B:
 		bank6SelMask =
 		    (ah->config.antenna_switch_swap & ANTSWAP_AB) ?
-			REDUCE_CHAIN_1 : REDUCE_CHAIN_0;
+			REDUCE_CHAIN_1 : /* swapped, reduce chain 1/2 */
+			REDUCE_CHAIN_0; /* normal, select chain 0 to reduce */
 		break;
 	case ATH9K_ANT_VARIABLE:
-		return;
+		return; /* do not change anything */
 		break;
 	default:
-		return;
+		return; /* do not change anything */
 		break;
 	}
 
 	for (i = 0; i < ah->iniBank6.ia_rows; i++)
 		bank6Temp[i] = ah->analogBank6Data[i];
 
+	/* Write Bank 5 to switch Bank 6 write to selected chain only */
 	REG_WRITE(ah, AR_PHY_BASE + 0xD8, bank6SelMask);
 
+	/*
+	 * Modify Bank6 selected chain to use lowest amplification.
+	 * Modifies the parameters to a value of 1.
+	 * Depends on existing bank 6 values to be cached in
+	 * ah->analogBank6Data
+	 */
 	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 189, 0);
 	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 190, 0);
 	ath9k_phy_modify_rx_buffer(bank6Temp, 1, 1, 191, 0);
-- 
1.6.0.4

