Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:60041 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3FCDwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 23:52:17 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/7] ath9k: Enable WoW only for AR9462
Date: Mon,  3 Jun 2013 09:19:24 +0530
Message-Id: <1370231369-16241-2-git-send-email-sujith@msujith.org> (sfid-20130603_055221_522494_BD05D11A)
In-Reply-To: <1370231369-16241-1-git-send-email-sujith@msujith.org>
References: <1370231369-16241-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The only card with which WoW has been tested and verified is
AR9462. Do not enable it for all cards since WoW is really quirky
and needs to be tested properly with each chip.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c       |   4 -
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h |  14 --
 drivers/net/wireless/ath/ath9k/hw.c              |   9 +-
 drivers/net/wireless/ath/ath9k/hw.h              |   9 +-
 drivers/net/wireless/ath/ath9k/init.c            |   4 -
 drivers/net/wireless/ath/ath9k/main.c            |  34 +----
 drivers/net/wireless/ath/ath9k/wow.c             | 168 ++++-------------------
 7 files changed, 35 insertions(+), 207 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 830daa1..8dc2d08 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -38,10 +38,6 @@ static int ar9002_hw_init_mode_regs(struct ath_hw *ah)
 	else
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
 			   ar9280PciePhy_clkreq_always_on_L1_9280);
-#ifdef CONFIG_PM_SLEEP
-		INIT_INI_ARRAY(&ah->iniPcieSerdesWow,
-			       ar9280PciePhy_awow);
-#endif
 
 	if (AR_SREV_9287_11_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1);
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
index beb6162..4d18c66 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
@@ -925,20 +925,6 @@ static const u32 ar9280PciePhy_clkreq_always_on_L1_9280[][2] = {
 	{0x00004044, 0x00000000},
 };
 
-static const u32 ar9280PciePhy_awow[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x9248fd00},
-	{0x00004040, 0x24924924},
-	{0x00004040, 0xa8000019},
-	{0x00004040, 0x13160820},
-	{0x00004040, 0xe5980560},
-	{0x00004040, 0xc01dcffd},
-	{0x00004040, 0x1aaabe41},
-	{0x00004040, 0xbe105554},
-	{0x00004040, 0x00043007},
-	{0x00004044, 0x00000000},
-};
-
 static const u32 ar9285Modes_9285_1_2[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160},
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2caf7de..c71027c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2604,13 +2604,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			pCap->hw_caps |= ATH9K_HW_CAP_RTT;
 	}
 
-	if (AR_SREV_9280_20_OR_LATER(ah)) {
-		pCap->hw_caps |= ATH9K_HW_WOW_DEVICE_CAPABLE |
-				 ATH9K_HW_WOW_PATTERN_MATCH_EXACT;
-
-		if (AR_SREV_9280(ah))
-			pCap->hw_caps |= ATH9K_HW_WOW_PATTERN_MATCH_DWORD;
-	}
+	if (AR_SREV_9462(ah))
+		pCap->hw_caps |= ATH9K_HW_WOW_DEVICE_CAPABLE;
 
 	if (AR_SREV_9300_20_OR_LATER(ah) &&
 	    ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ae30343..e3c3997 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -246,9 +246,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_MCI			= BIT(15),
 	ATH9K_HW_CAP_DFS			= BIT(16),
 	ATH9K_HW_WOW_DEVICE_CAPABLE		= BIT(17),
-	ATH9K_HW_WOW_PATTERN_MATCH_EXACT	= BIT(18),
-	ATH9K_HW_WOW_PATTERN_MATCH_DWORD	= BIT(19),
-	ATH9K_HW_CAP_PAPRD			= BIT(20),
+	ATH9K_HW_CAP_PAPRD			= BIT(18),
 };
 
 /*
@@ -882,9 +880,6 @@ struct ath_hw {
 	struct ar5416IniArray iniBank6;
 	struct ar5416IniArray iniAddac;
 	struct ar5416IniArray iniPcieSerdes;
-#ifdef CONFIG_PM_SLEEP
-	struct ar5416IniArray iniPcieSerdesWow;
-#endif
 	struct ar5416IniArray iniPcieSerdesLowPower;
 	struct ar5416IniArray iniModesFastClock;
 	struct ar5416IniArray iniAdditional;
@@ -1165,8 +1160,6 @@ static inline void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 }
 #endif
 
-
-
 #define ATH9K_CLOCK_RATE_CCK		22
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 9fc4d67..522c198 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -797,21 +797,17 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 #ifdef CONFIG_PM_SLEEP
-
 	if ((ah->caps.hw_caps & ATH9K_HW_WOW_DEVICE_CAPABLE) &&
 	    device_can_wakeup(sc->dev)) {
-
 		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
 					  WIPHY_WOWLAN_DISCONNECT;
 		hw->wiphy->wowlan.n_patterns = MAX_NUM_USER_PATTERN;
 		hw->wiphy->wowlan.pattern_min_len = 1;
 		hw->wiphy->wowlan.pattern_max_len = MAX_PATTERN_SIZE;
-
 	}
 
 	atomic_set(&sc->wow_sleep_proc_intr, -1);
 	atomic_set(&sc->wow_got_bmiss_intr, -1);
-
 #endif
 
 	hw->queues = 4;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6c147b8..e5b186b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2006,7 +2006,6 @@ static void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_hw_capabilities *pcaps = &ah->caps;
 	int pattern_count = 0;
 	int i, byte_cnt;
 	u8 dis_deauth_pattern[MAX_PATTERN_SIZE];
@@ -2076,36 +2075,9 @@ static void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
 
 	/* Create Disassociate pattern mask */
 
-	if (pcaps->hw_caps & ATH9K_HW_WOW_PATTERN_MATCH_EXACT) {
-
-		if (pcaps->hw_caps & ATH9K_HW_WOW_PATTERN_MATCH_DWORD) {
-			/*
-			 * for AR9280, because of hardware limitation, the
-			 * first 4 bytes have to be matched for all patterns.
-			 * the mask for disassociation and de-auth pattern
-			 * matching need to enable the first 4 bytes.
-			 * also the duration field needs to be filled.
-			 */
-			dis_deauth_mask[0] = 0xf0;
-
-			/*
-			 * fill in duration field
-			 FIXME: what is the exact value ?
-			 */
-			dis_deauth_pattern[2] = 0xff;
-			dis_deauth_pattern[3] = 0xff;
-		} else {
-			dis_deauth_mask[0] = 0xfe;
-		}
-
-		dis_deauth_mask[1] = 0x03;
-		dis_deauth_mask[2] = 0xc0;
-	} else {
-		dis_deauth_mask[0] = 0xef;
-		dis_deauth_mask[1] = 0x3f;
-		dis_deauth_mask[2] = 0x00;
-		dis_deauth_mask[3] = 0xfc;
-	}
+	dis_deauth_mask[0] = 0xfe;
+	dis_deauth_mask[1] = 0x03;
+	dis_deauth_mask[2] = 0xc0;
 
 	ath_dbg(common, WOW, "Adding disassoc/deauth patterns for WoW\n");
 
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 9f85630..81c88dd 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -34,17 +34,6 @@ const char *ath9k_hw_wow_event_to_string(u32 wow_event)
 }
 EXPORT_SYMBOL(ath9k_hw_wow_event_to_string);
 
-static void ath9k_hw_config_serdes_wow_sleep(struct ath_hw *ah)
-{
-	int i;
-
-	for (i = 0; i < ah->iniPcieSerdesWow.ia_rows; i++)
-		REG_WRITE(ah, INI_RA(&ah->iniPcieSerdesWow, i, 0),
-			  INI_RA(&ah->iniPcieSerdesWow, i, 1));
-
-	usleep_range(1000, 1500);
-}
-
 static void ath9k_hw_set_powermode_wow_sleep(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -58,15 +47,8 @@ static void ath9k_hw_set_powermode_wow_sleep(struct ath_hw *ah)
 		ath_err(common, "Failed to stop Rx DMA in 10ms AR_CR=0x%08x AR_DIAG_SW=0x%08x\n",
 			REG_READ(ah, AR_CR), REG_READ(ah, AR_DIAG_SW));
 		return;
-	} else {
-		if (!AR_SREV_9300_20_OR_LATER(ah))
-			REG_WRITE(ah, AR_RXDP, 0x0);
 	}
 
-	/* AR9280 WoW has sleep issue, do not set it to sleep */
-	if (AR_SREV_9280_20(ah))
-		return;
-
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_ON_INT);
 }
 
@@ -84,27 +66,16 @@ static void ath9k_wow_create_keep_alive_pattern(struct ath_hw *ah)
 
 	/* set the transmit buffer */
 	ctl[0] = (KAL_FRAME_LEN | (MAX_RATE_POWER << 16));
-
-	if (!(AR_SREV_9300_20_OR_LATER(ah)))
-		ctl[0] += (KAL_ANTENNA_MODE << 25);
-
 	ctl[1] = 0;
 	ctl[3] = 0xb;	/* OFDM_6M hardware value for this rate */
 	ctl[4] = 0;
 	ctl[7] = (ah->txchainmask) << 2;
-
-	if (AR_SREV_9300_20_OR_LATER(ah))
-		ctl[2] = 0xf << 16; /* tx_tries 0 */
-	else
-		ctl[2] = 0x7 << 16; /* tx_tries 0 */
-
+	ctl[2] = 0xf << 16; /* tx_tries 0 */
 
 	for (i = 0; i < KAL_NUM_DESC_WORDS; i++)
 		REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + i * 4), ctl[i]);
 
-	/* for AR9300 family 13 descriptor words */
-	if (AR_SREV_9300_20_OR_LATER(ah))
-		REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + i * 4), ctl[i]);
+	REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + i * 4), ctl[i]);
 
 	data_word[0] = (KAL_FRAME_TYPE << 2) | (KAL_FRAME_SUB_TYPE << 4) |
 		       (KAL_TO_DS << 8) | (KAL_DURATION_ID << 16);
@@ -183,9 +154,6 @@ void ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
 
 	ah->wow_event_mask |= BIT(pattern_count + AR_WOW_PAT_FOUND_SHIFT);
 
-	if (!AR_SREV_9285_12_OR_LATER(ah))
-		return;
-
 	if (pattern_count < 4) {
 		/* Pattern 0-3 uses AR_WOW_LENGTH1 register */
 		set = (pattern_len & AR_WOW_LENGTH_MAX) <<
@@ -207,6 +175,7 @@ u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 {
 	u32 wow_status = 0;
 	u32 val = 0, rval;
+
 	/*
 	 * read the WoW status register to know
 	 * the wakeup reason
@@ -223,19 +192,14 @@ u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 	val &= ah->wow_event_mask;
 
 	if (val) {
-
 		if (val & AR_WOW_MAGIC_PAT_FOUND)
 			wow_status |= AH_WOW_MAGIC_PATTERN_EN;
-
 		if (AR_WOW_PATTERN_FOUND(val))
 			wow_status |= AH_WOW_USER_PATTERN_EN;
-
 		if (val & AR_WOW_KEEP_ALIVE_FAIL)
 			wow_status |= AH_WOW_LINK_CHANGE;
-
 		if (val & AR_WOW_BEACON_FAIL)
 			wow_status |= AH_WOW_BEACON_MISS;
-
 	}
 
 	/*
@@ -255,17 +219,6 @@ u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 		  AR_WOW_CLEAR_EVENTS(REG_READ(ah, AR_WOW_PATTERN)));
 
 	/*
-	 * tie reset register for AR9002 family of chipsets
-	 * NB: not tieing it back might have some repurcussions.
-	 */
-
-	if (!AR_SREV_9300_20_OR_LATER(ah)) {
-		REG_SET_BIT(ah, AR_WA, AR_WA_UNTIE_RESET_EN |
-			    AR_WA_POR_SHORT | AR_WA_RESET_EN);
-	}
-
-
-	/*
 	 * restore the beacon threshold to init value
 	 */
 	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
@@ -277,8 +230,7 @@ u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 	 * reset to our Chip's Power On Reset so that any PCI-E
 	 * reset from the bus will not reset our chip
 	 */
-
-	if (AR_SREV_9280_20_OR_LATER(ah) && ah->is_pciexpress)
+	if (ah->is_pciexpress)
 		ath9k_hw_configpcipowersave(ah, false);
 
 	ah->wow_event_mask = 0;
@@ -298,7 +250,6 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 	 * are from the 'pattern_enable' in this function and
 	 * 'pattern_count' of ath9k_hw_wow_apply_pattern()
 	 */
-
 	wow_event_mask = ah->wow_event_mask;
 
 	/*
@@ -306,50 +257,15 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 	 * WOW sleep, we do want the Reset from the PCI-E to disturb
 	 * our hw state
 	 */
-
 	if (ah->is_pciexpress) {
-
 		/*
 		 * we need to untie the internal POR (power-on-reset)
 		 * to the external PCI-E reset. We also need to tie
 		 * the PCI-E Phy reset to the PCI-E reset.
 		 */
-
-		if (AR_SREV_9300_20_OR_LATER(ah)) {
-			set = AR_WA_RESET_EN | AR_WA_POR_SHORT;
-			clr = AR_WA_UNTIE_RESET_EN | AR_WA_D3_L1_DISABLE;
-			REG_RMW(ah, AR_WA, set, clr);
-		} else {
-			if (AR_SREV_9285(ah) || AR_SREV_9287(ah))
-				set = AR9285_WA_DEFAULT;
-			else
-				set = AR9280_WA_DEFAULT;
-
-			/*
-			 * In AR9280 and AR9285, bit 14 in WA register
-			 * (disable L1) should only be set when device
-			 * enters D3 state and be cleared when device
-			 * comes back to D0
-			 */
-
-			if (ah->config.pcie_waen & AR_WA_D3_L1_DISABLE)
-				set |= AR_WA_D3_L1_DISABLE;
-
-			clr = AR_WA_UNTIE_RESET_EN;
-			set |= AR_WA_RESET_EN | AR_WA_POR_SHORT;
-			REG_RMW(ah, AR_WA, set, clr);
-
-			/*
-			 * for WoW sleep, we reprogram the SerDes so that the
-			 * PLL and CLK REQ are both enabled. This uses more
-			 * power but otherwise WoW sleep is unstable and the
-			 * chip may disappear.
-			 */
-
-			if (AR_SREV_9285_12_OR_LATER(ah))
-				ath9k_hw_config_serdes_wow_sleep(ah);
-
-		}
+		set = AR_WA_RESET_EN | AR_WA_POR_SHORT;
+		clr = AR_WA_UNTIE_RESET_EN | AR_WA_D3_L1_DISABLE;
+		REG_RMW(ah, AR_WA, set, clr);
 	}
 
 	/*
@@ -378,7 +294,6 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 	 * Program default values for pattern backoff, aifs/slot/KAL count,
 	 * beacon miss timeout, KAL timeout, etc.
 	 */
-
 	set = AR_WOW_BACK_OFF_SHIFT(AR_WOW_PAT_BACKOFF);
 	REG_SET_BIT(ah, AR_WOW_PATTERN, set);
 
@@ -398,7 +313,7 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 	/*
 	 * Keep alive timo in ms except AR9280
 	 */
-	if (!pattern_enable || AR_SREV_9280(ah))
+	if (!pattern_enable)
 		set = AR_WOW_KEEP_ALIVE_NEVER;
 	else
 		set = KAL_TIMEOUT * 32;
@@ -420,7 +335,6 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 	/*
 	 * Configure MAC WoW Registers
 	 */
-
 	set = 0;
 	/* Send keep alive timeouts anyway */
 	clr = AR_WOW_KEEP_ALIVE_AUTO_DIS;
@@ -430,16 +344,9 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 	else
 		set = AR_WOW_KEEP_ALIVE_FAIL_DIS;
 
-	/*
-	 * FIXME: For now disable keep alive frame
-	 * failure. This seems to sometimes trigger
-	 * unnecessary wake up with AR9485 chipsets.
-	 */
 	set = AR_WOW_KEEP_ALIVE_FAIL_DIS;
-
 	REG_RMW(ah, AR_WOW_KEEP_ALIVE, set, clr);
 
-
 	/*
 	 * we are relying on a bmiss failure. ensure we have
 	 * enough threshold to prevent false positives
@@ -473,14 +380,8 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 	set |= AR_WOW_MAC_INTR_EN;
 	REG_RMW(ah, AR_WOW_PATTERN, set, clr);
 
-	/*
-	 * For AR9285 and later version of chipsets
-	 * enable WoW pattern match for packets less
-	 * than 256 bytes for all patterns
-	 */
-	if (AR_SREV_9285_12_OR_LATER(ah))
-		REG_WRITE(ah, AR_WOW_PATTERN_MATCH_LT_256B,
-			  AR_WOW_PATTERN_SUPPORTED);
+	REG_WRITE(ah, AR_WOW_PATTERN_MATCH_LT_256B,
+		  AR_WOW_PATTERN_SUPPORTED);
 
 	/*
 	 * Set the power states appropriately and enable PME
@@ -488,43 +389,32 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 	clr = 0;
 	set = AR_PMCTRL_PWR_STATE_D1D3 | AR_PMCTRL_HOST_PME_EN |
 	      AR_PMCTRL_PWR_PM_CTRL_ENA;
-	/*
-	 * This is needed for AR9300 chipsets to wake-up
-	 * the host.
-	 */
-	if (AR_SREV_9300_20_OR_LATER(ah))
-		clr = AR_PCIE_PM_CTRL_ENA;
 
+	clr = AR_PCIE_PM_CTRL_ENA;
 	REG_RMW(ah, AR_PCIE_PM_CTRL, set, clr);
 
-	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
-		/*
-		 * this is needed to prevent the chip waking up
-		 * the host within 3-4 seconds with certain
-		 * platform/BIOS. The fix is to enable
-		 * D1 & D3 to match original definition and
-		 * also match the OTP value. Anyway this
-		 * is more related to SW WOW.
-		 */
-		clr = AR_PMCTRL_PWR_STATE_D1D3;
-		REG_CLR_BIT(ah, AR_PCIE_PM_CTRL, clr);
-
-		set = AR_PMCTRL_PWR_STATE_D1D3_REAL;
-		REG_SET_BIT(ah, AR_PCIE_PM_CTRL, set);
-	}
-
+	/*
+	 * this is needed to prevent the chip waking up
+	 * the host within 3-4 seconds with certain
+	 * platform/BIOS. The fix is to enable
+	 * D1 & D3 to match original definition and
+	 * also match the OTP value. Anyway this
+	 * is more related to SW WOW.
+	 */
+	clr = AR_PMCTRL_PWR_STATE_D1D3;
+	REG_CLR_BIT(ah, AR_PCIE_PM_CTRL, clr);
 
+	set = AR_PMCTRL_PWR_STATE_D1D3_REAL;
+	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, set);
 
 	REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PRESERVE_SEQNUM);
 
-	if (AR_SREV_9300_20_OR_LATER(ah)) {
-		/* to bring down WOW power low margin */
-		set = BIT(13);
-		REG_SET_BIT(ah, AR_PCIE_PHY_REG3, set);
-		/* HW WoW */
-		clr = BIT(5);
-		REG_CLR_BIT(ah, AR_PCU_MISC_MODE3, clr);
-	}
+	/* to bring down WOW power low margin */
+	set = BIT(13);
+	REG_SET_BIT(ah, AR_PCIE_PHY_REG3, set);
+	/* HW WoW */
+	clr = BIT(5);
+	REG_CLR_BIT(ah, AR_PCU_MISC_MODE3, clr);
 
 	ath9k_hw_set_powermode_wow_sleep(ah);
 	ah->wow_event_mask = wow_event_mask;
-- 
1.8.3

