Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54774 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795Ab0DODax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 33/97] ath9k_hw: add helpers for processing the AR9003 INI
Date: Wed, 14 Apr 2010 23:29:47 -0400
Message-Id: <1271302251-9075-34-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  186 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    2 +
 drivers/net/wireless/ath/ath9k/reg.h        |   13 ++
 3 files changed, 198 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 3e3472e..acbf122 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -186,7 +186,40 @@ static u32 ar9003_hw_compute_pll_control(struct ath_hw *ah,
 static void ar9003_hw_set_channel_regs(struct ath_hw *ah,
 				       struct ath9k_channel *chan)
 {
-	/* TODO */
+	u32 phymode;
+	u32 enableDacFifo = 0;
+
+	enableDacFifo =
+		(REG_READ(ah, AR_PHY_GEN_CTRL) & AR_PHY_GC_ENABLE_DAC_FIFO);
+
+	/* Enable 11n HT, 20 MHz */
+	phymode = AR_PHY_GC_HT_EN | AR_PHY_GC_SINGLE_HT_LTF1 | AR_PHY_GC_WALSH |
+		  AR_PHY_GC_SHORT_GI_40 | enableDacFifo;
+
+	/* Configure baseband for dynamic 20/40 operation */
+	if (IS_CHAN_HT40(chan)) {
+		phymode |= AR_PHY_GC_DYN2040_EN;
+		/* Configure control (primary) channel at +-10MHz */
+		if ((chan->chanmode == CHANNEL_A_HT40PLUS) ||
+		    (chan->chanmode == CHANNEL_G_HT40PLUS))
+			phymode |= AR_PHY_GC_DYN2040_PRI_CH;
+
+	}
+
+	/* make sure we preserve INI settings */
+	phymode |= REG_READ(ah, AR_PHY_GEN_CTRL);
+	/* turn off Green Field detection for STA for now */
+	phymode &= ~AR_PHY_GC_GF_DETECT_EN;
+
+	REG_WRITE(ah, AR_PHY_GEN_CTRL, phymode);
+
+	/* Configure MAC for 20/40 operation */
+	ath9k_hw_set11nmac2040(ah);
+
+	/* global transmit timeout (25 TUs default)*/
+	REG_WRITE(ah, AR_GTXTO, 25 << AR_GTXTO_TIMEOUT_LIMIT_S);
+	/* carrier sense timeout */
+	REG_WRITE(ah, AR_CST, 0xF << AR_CST_TIMEOUT_LIMIT_S);
 }
 
 static void ar9003_hw_init_bb(struct ath_hw *ah,
@@ -195,11 +228,158 @@ static void ar9003_hw_init_bb(struct ath_hw *ah,
 	/* TODO */
 }
 
+void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
+{
+	switch (rx) {
+	case 0x5:
+		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
+			    AR_PHY_SWAP_ALT_CHAIN);
+	case 0x3:
+	case 0x1:
+	case 0x2:
+	case 0x7:
+		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx);
+		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx);
+		break;
+	default:
+		break;
+	}
+
+	REG_WRITE(ah, AR_SELFGEN_MASK, tx);
+	if (tx == 0x5) {
+		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
+			    AR_PHY_SWAP_ALT_CHAIN);
+	}
+}
+
+/*
+ * Override INI values with chip specific configuration.
+ */
+static void ar9003_hw_override_ini(struct ath_hw *ah)
+{
+	u32 val;
+
+	/*
+	 * Set the RX_ABORT and RX_DIS and clear it only after
+	 * RXE is set for MAC. This prevents frames with
+	 * corrupted descriptor status.
+	 */
+	REG_SET_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
+
+	/*
+	 * For AR9280 and above, there is a new feature that allows
+	 * Multicast search based on both MAC Address and Key ID. By default,
+	 * this feature is enabled. But since the driver is not using this
+	 * feature, we switch it off; otherwise multicast search based on
+	 * MAC addr only will fail.
+	 */
+	val = REG_READ(ah, AR_PCU_MISC_MODE2) & (~AR_ADHOC_MCAST_KEYID_ENABLE);
+	REG_WRITE(ah, AR_PCU_MISC_MODE2,
+		  val | AR_AGG_WEP_ENABLE_FIX | AR_AGG_WEP_ENABLE);
+}
+
+static void ar9003_hw_prog_ini(struct ath_hw *ah,
+			       struct ar5416IniArray *iniArr,
+			       int column)
+{
+	unsigned int i, regWrites = 0;
+
+	/* New INI format: Array may be undefined (pre, core, post arrays) */
+	if (!iniArr->ia_array)
+		return;
+
+	/*
+	 * New INI format: Pre, core, and post arrays for a given subsystem
+	 * may be modal (> 2 columns) or non-modal (2 columns). Determine if
+	 * the array is non-modal and force the column to 1.
+	 */
+	if (column >= iniArr->ia_columns)
+		column = 1;
+
+	for (i = 0; i < iniArr->ia_rows; i++) {
+		u32 reg = INI_RA(iniArr, i, 0);
+		u32 val = INI_RA(iniArr, i, column);
+
+		REG_WRITE(ah, reg, val);
+
+		/*
+		 * Determine if this is a shift register value, and insert the
+		 * configured delay if so.
+		 */
+		if (reg >= 0x16000 && reg < 0x17000
+		    && ah->config.analog_shiftreg)
+			udelay(100);
+
+		DO_DELAY(regWrites);
+	}
+}
+
 static int ar9003_hw_process_ini(struct ath_hw *ah,
 				 struct ath9k_channel *chan)
 {
-	/* TODO */
-	return -1;
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	unsigned int regWrites = 0, i;
+	struct ieee80211_channel *channel = chan->chan;
+	u32 modesIndex, freqIndex;
+
+	switch (chan->chanmode) {
+	case CHANNEL_A:
+	case CHANNEL_A_HT20:
+		modesIndex = 1;
+		freqIndex = 1;
+		break;
+	case CHANNEL_A_HT40PLUS:
+	case CHANNEL_A_HT40MINUS:
+		modesIndex = 2;
+		freqIndex = 1;
+		break;
+	case CHANNEL_G:
+	case CHANNEL_G_HT20:
+	case CHANNEL_B:
+		modesIndex = 4;
+		freqIndex = 2;
+		break;
+	case CHANNEL_G_HT40PLUS:
+	case CHANNEL_G_HT40MINUS:
+		modesIndex = 3;
+		freqIndex = 2;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ATH_INI_NUM_SPLIT; i++) {
+		ar9003_hw_prog_ini(ah, &ah->iniSOC[i], modesIndex);
+		ar9003_hw_prog_ini(ah, &ah->iniMac[i], modesIndex);
+		ar9003_hw_prog_ini(ah, &ah->iniBB[i], modesIndex);
+		ar9003_hw_prog_ini(ah, &ah->iniRadio[i], modesIndex);
+	}
+
+	REG_WRITE_ARRAY(&ah->iniModesRxGain, 1, regWrites);
+	REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
+
+	/*
+	 * For 5GHz channels requiring Fast Clock, apply
+	 * different modal values.
+	 */
+	if (IS_CHAN_A_5MHZ_SPACED(chan))
+		REG_WRITE_ARRAY(&ah->iniModesAdditional,
+				modesIndex, regWrites);
+
+	ar9003_hw_override_ini(ah);
+	ar9003_hw_set_channel_regs(ah, chan);
+	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
+
+	/* Set TX power */
+	ah->eep_ops->set_txpower(ah, chan,
+				 ath9k_regd_get_ctl(regulatory, chan),
+				 channel->max_antenna_gain * 2,
+				 channel->max_power * 2,
+				 min((u32) MAX_RATE_POWER,
+				 (u32) regulatory->power_limit));
+
+	return 0;
 }
 
 static void ar9003_hw_set_rfmode(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 2e51e57..70e647b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -801,4 +801,6 @@
 
 #define AR_PHY_BB_WD_STATUS_CLR         0x00000008
 
+void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx);
+
 #endif  /* AR9003_PHY_H */
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 9d63286..96b2cfe 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1756,4 +1756,17 @@ enum {
 #define AR9271_CORE_CLOCK	117   /* clock to 117Mhz */
 #define AR9271_TARGET_BAUD_RATE	19200 /* 115200 */
 
+#define AR_AGG_WEP_ENABLE_FIX		0x00000008  /* This allows the use of AR_AGG_WEP_ENABLE */
+#define AR_ADHOC_MCAST_KEYID_ENABLE     0x00000040  /* This bit enables the Multicast search
+						     * based on both MAC Address and Key ID.
+						     * If bit is 0, then Multicast search is
+						     * based on MAC address only.
+						     * For Merlin and above only.
+						     */
+#define AR_AGG_WEP_ENABLE               0x00020000  /* This field enables AGG_WEP feature,
+						     * when it is enable, AGG_WEP would takes
+						     * charge of the encryption interface of
+						     * pcu_txsm.
+						     */
+
 #endif
-- 
1.6.3.3

