Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:45906 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbbBBMsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 07:48:18 -0500
Received: from [117.216.55.194] (port=15247 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YIGQL-002djK-Ki
	for linux-wireless@vger.kernel.org; Mon, 02 Feb 2015 07:48:18 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] ath9k: Fix issues with WoW enable
Date: Mon,  2 Feb 2015 18:21:10 +0530
Message-Id: <1422881473-24580-4-git-send-email-sujith@msujith.org> (sfid-20150202_135440_027704_2C9ADD7D)
In-Reply-To: <1422881473-24580-1-git-send-email-sujith@msujith.org>
References: <1422881473-24580-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch addresses several issues with the
ath9k_hw_wow_enable() routine:

* The usage of set/clr variables is removed. Writing
  the required values to registers is cleaner.

* The shift value of 28 for the contention window field
  in AR_WOW_PATTERN is incorrect, change it to 27.

* Disabling Keep Alive needs to be done based on the
  LINK_CHANGE option. This is done unconditionally now,
  fix this.

* The workaround for the D1/D3 issue is required only
  for AR9462.

* The bitfield for enabling pattern matching for packets
  less than 256 bytes has expanded for new chips, handle
  this accordingly.

* General cleanup.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 181 ++++++++++++++--------------
 drivers/net/wireless/ath/ath9k/hw.h         |   2 +-
 drivers/net/wireless/ath/ath9k/reg_wow.h    |   5 +-
 3 files changed, 93 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index 4b53d0b..6ffa0e0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -222,14 +222,9 @@ EXPORT_SYMBOL(ath9k_hw_wow_wakeup);
 void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 {
 	u32 wow_event_mask;
+	u32 keep_alive, magic_pattern, host_pm_ctrl;
 	u32 set, clr;
 
-	/*
-	 * wow_event_mask is a mask to the AR_WOW_PATTERN register to
-	 * indicate which WoW events we have enabled. The WoW events
-	 * are from the 'pattern_enable' in this function and
-	 * 'pattern_count' of ath9k_hw_wow_apply_pattern()
-	 */
 	wow_event_mask = ah->wow.wow_event_mask;
 
 	/*
@@ -249,152 +244,154 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 	}
 
 	/*
-	 * set the power states appropriately and enable PME
+	 * AR_PMCTRL_HOST_PME_EN - Override PME enable in configuration
+	 *                         space and allow MAC to generate WoW anyway.
+	 *
+	 * AR_PMCTRL_PWR_PM_CTRL_ENA - ???
+	 *
+	 * AR_PMCTRL_AUX_PWR_DET - PCI core SYS_AUX_PWR_DET signal,
+	 *                         needs to be set for WoW in PCI mode.
+	 *
+	 * AR_PMCTRL_WOW_PME_CLR - WoW Clear Signal going to the MAC.
+	 *
+	 * Set the power states appropriately and enable PME.
+	 *
+	 * Set and clear WOW_PME_CLEAR for the chip
+	 * to generate next wow signal.
 	 */
-	set = AR_PMCTRL_HOST_PME_EN | AR_PMCTRL_PWR_PM_CTRL_ENA |
-	      AR_PMCTRL_AUX_PWR_DET | AR_PMCTRL_WOW_PME_CLR;
+	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PMCTRL_HOST_PME_EN |
+		    			 AR_PMCTRL_PWR_PM_CTRL_ENA |
+		    			 AR_PMCTRL_AUX_PWR_DET |
+		    			 AR_PMCTRL_WOW_PME_CLR);
+	REG_CLR_BIT(ah, AR_PCIE_PM_CTRL, AR_PMCTRL_WOW_PME_CLR);
 
 	/*
-	 * set and clear WOW_PME_CLEAR registers for the chip
-	 * to generate next wow signal.
+	 * Random Backoff.
+	 *
+	 * 31:28 in AR_WOW_PATTERN : Indicates the number of bits used in the
+	 *                           contention window. For value N,
+	 *                           the random backoff will be selected between
+	 *                           0 and (2 ^ N) - 1.
 	 */
-	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, set);
-	clr = AR_PMCTRL_WOW_PME_CLR;
-	REG_CLR_BIT(ah, AR_PCIE_PM_CTRL, clr);
+	REG_SET_BIT(ah, AR_WOW_PATTERN,
+		    AR_WOW_BACK_OFF_SHIFT(AR_WOW_PAT_BACKOFF));
 
 	/*
-	 * Setup for:
-	 *	- beacon misses
-	 *	- magic pattern
-	 *	- keep alive timeout
-	 *	- pattern matching
+	 * AIFS time, Slot time, Keep Alive count.
 	 */
-
+	REG_SET_BIT(ah, AR_WOW_COUNT, AR_WOW_AIFS_CNT(AR_WOW_CNT_AIFS_CNT) |
+		    		      AR_WOW_SLOT_CNT(AR_WOW_CNT_SLOT_CNT) |
+		    		      AR_WOW_KEEP_ALIVE_CNT(AR_WOW_CNT_KA_CNT));
 	/*
-	 * Program default values for pattern backoff, aifs/slot/KAL count,
-	 * beacon miss timeout, KAL timeout, etc.
+	 * Beacon timeout.
 	 */
-	set = AR_WOW_BACK_OFF_SHIFT(AR_WOW_PAT_BACKOFF);
-	REG_SET_BIT(ah, AR_WOW_PATTERN, set);
-
-	set = AR_WOW_AIFS_CNT(AR_WOW_CNT_AIFS_CNT) |
-	      AR_WOW_SLOT_CNT(AR_WOW_CNT_SLOT_CNT) |
-	      AR_WOW_KEEP_ALIVE_CNT(AR_WOW_CNT_KA_CNT);
-	REG_SET_BIT(ah, AR_WOW_COUNT, set);
-
 	if (pattern_enable & AH_WOW_BEACON_MISS)
-		set = AR_WOW_BEACON_TIMO;
-	/* We are not using beacon miss, program a large value */
+		REG_WRITE(ah, AR_WOW_BCN_TIMO, AR_WOW_BEACON_TIMO);
 	else
-		set = AR_WOW_BEACON_TIMO_MAX;
-
-	REG_WRITE(ah, AR_WOW_BCN_TIMO, set);
+		REG_WRITE(ah, AR_WOW_BCN_TIMO, AR_WOW_BEACON_TIMO_MAX);
 
 	/*
-	 * Keep alive timo in ms except AR9280
+	 * Keep alive timeout in ms.
 	 */
 	if (!pattern_enable)
-		set = AR_WOW_KEEP_ALIVE_NEVER;
+		REG_WRITE(ah, AR_WOW_KEEP_ALIVE_TIMO, AR_WOW_KEEP_ALIVE_NEVER);
 	else
-		set = KAL_TIMEOUT * 32;
-
-	REG_WRITE(ah, AR_WOW_KEEP_ALIVE_TIMO, set);
+		REG_WRITE(ah, AR_WOW_KEEP_ALIVE_TIMO, KAL_TIMEOUT * 32);
 
 	/*
-	 * Keep alive delay in us. based on 'power on clock',
-	 * therefore in usec
+	 * Keep alive delay in us.
 	 */
-	set = KAL_DELAY * 1000;
-	REG_WRITE(ah, AR_WOW_KEEP_ALIVE_DELAY, set);
+	REG_WRITE(ah, AR_WOW_KEEP_ALIVE_DELAY, KAL_DELAY * 1000);
 
 	/*
-	 * Create keep alive pattern to respond to beacons
+	 * Create keep alive pattern to respond to beacons.
 	 */
 	ath9k_wow_create_keep_alive_pattern(ah);
 
 	/*
-	 * Configure MAC WoW Registers
+	 * Configure keep alive register.
 	 */
-	set = 0;
+	keep_alive = REG_READ(ah, AR_WOW_KEEP_ALIVE);
+
 	/* Send keep alive timeouts anyway */
-	clr = AR_WOW_KEEP_ALIVE_AUTO_DIS;
+	keep_alive &= ~AR_WOW_KEEP_ALIVE_AUTO_DIS;
 
-	if (pattern_enable & AH_WOW_LINK_CHANGE)
+	if (pattern_enable & AH_WOW_LINK_CHANGE) {
+		keep_alive &= ~AR_WOW_KEEP_ALIVE_FAIL_DIS;
 		wow_event_mask |= AR_WOW_KEEP_ALIVE_FAIL;
-	else
-		set = AR_WOW_KEEP_ALIVE_FAIL_DIS;
+	} else {
+		keep_alive |= AR_WOW_KEEP_ALIVE_FAIL_DIS;
+	}
 
-	set = AR_WOW_KEEP_ALIVE_FAIL_DIS;
-	REG_RMW(ah, AR_WOW_KEEP_ALIVE, set, clr);
+	REG_WRITE(ah, AR_WOW_KEEP_ALIVE, keep_alive);
 
 	/*
-	 * we are relying on a bmiss failure. ensure we have
-	 * enough threshold to prevent false positives
+	 * We are relying on a bmiss failure, ensure we have
+	 * enough threshold to prevent false positives.
 	 */
 	REG_RMW_FIELD(ah, AR_RSSI_THR, AR_RSSI_THR_BM_THR,
 		      AR_WOW_BMISSTHRESHOLD);
 
-	set = 0;
-	clr = 0;
-
 	if (pattern_enable & AH_WOW_BEACON_MISS) {
-		set = AR_WOW_BEACON_FAIL_EN;
 		wow_event_mask |= AR_WOW_BEACON_FAIL;
+		REG_SET_BIT(ah, AR_WOW_BCN_EN, AR_WOW_BEACON_FAIL_EN);
 	} else {
-		clr = AR_WOW_BEACON_FAIL_EN;
+		REG_CLR_BIT(ah, AR_WOW_BCN_EN, AR_WOW_BEACON_FAIL_EN);
 	}
 
-	REG_RMW(ah, AR_WOW_BCN_EN, set, clr);
-
-	set = 0;
-	clr = 0;
 	/*
-	 * Enable the magic packet registers
+	 * Enable the magic packet registers.
 	 */
+	magic_pattern = REG_READ(ah, AR_WOW_PATTERN);
+	magic_pattern |= AR_WOW_MAC_INTR_EN;
+
 	if (pattern_enable & AH_WOW_MAGIC_PATTERN_EN) {
-		set = AR_WOW_MAGIC_EN;
+		magic_pattern |= AR_WOW_MAGIC_EN;
 		wow_event_mask |= AR_WOW_MAGIC_PAT_FOUND;
 	} else {
-		clr = AR_WOW_MAGIC_EN;
+		magic_pattern &= ~AR_WOW_MAGIC_EN;
 	}
-	set |= AR_WOW_MAC_INTR_EN;
-	REG_RMW(ah, AR_WOW_PATTERN, set, clr);
 
+	REG_WRITE(ah, AR_WOW_PATTERN, magic_pattern);
+
+	/*
+	 * Enable pattern matching for packets which are less
+	 * than 256 bytes.
+	 */
 	REG_WRITE(ah, AR_WOW_PATTERN_MATCH_LT_256B,
 		  AR_WOW_PATTERN_SUPPORTED);
 
 	/*
-	 * Set the power states appropriately and enable PME
+	 * Set the power states appropriately and enable PME.
 	 */
-	clr = 0;
-	set = AR_PMCTRL_PWR_STATE_D1D3 | AR_PMCTRL_HOST_PME_EN |
-	      AR_PMCTRL_PWR_PM_CTRL_ENA;
+	host_pm_ctrl = REG_READ(ah, AR_PCIE_PM_CTRL);
+	host_pm_ctrl |= AR_PMCTRL_PWR_STATE_D1D3 |
+			AR_PMCTRL_HOST_PME_EN |
+			AR_PMCTRL_PWR_PM_CTRL_ENA;
+	host_pm_ctrl &= ~AR_PCIE_PM_CTRL_ENA;
 
-	clr = AR_PCIE_PM_CTRL_ENA;
-	REG_RMW(ah, AR_PCIE_PM_CTRL, set, clr);
+	if (AR_SREV_9462(ah)) {
+		/*
+		 * This is needed to prevent the chip waking up
+		 * the host within 3-4 seconds with certain
+		 * platform/BIOS.
+		 */
+		host_pm_ctrl &= ~AR_PMCTRL_PWR_STATE_D1D3;
+		host_pm_ctrl |= AR_PMCTRL_PWR_STATE_D1D3_REAL;
+	}
+
+	REG_WRITE(ah, AR_PCIE_PM_CTRL, host_pm_ctrl);
 
 	/*
-	 * this is needed to prevent the chip waking up
-	 * the host within 3-4 seconds with certain
-	 * platform/BIOS. The fix is to enable
-	 * D1 & D3 to match original definition and
-	 * also match the OTP value. Anyway this
-	 * is more related to SW WOW.
+	 * Enable sequence number generation when asleep.
 	 */
-	clr = AR_PMCTRL_PWR_STATE_D1D3;
-	REG_CLR_BIT(ah, AR_PCIE_PM_CTRL, clr);
-
-	set = AR_PMCTRL_PWR_STATE_D1D3_REAL;
-	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, set);
-
 	REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PRESERVE_SEQNUM);
 
-	/* to bring down WOW power low margin */
-	set = BIT(13);
-	REG_SET_BIT(ah, AR_PCIE_PHY_REG3, set);
+	/* To bring down WOW power low margin */
+	REG_SET_BIT(ah, AR_PCIE_PHY_REG3, BIT(13));
+
 	/* HW WoW */
-	clr = BIT(5);
-	REG_CLR_BIT(ah, AR_PCU_MISC_MODE3, clr);
+	REG_CLR_BIT(ah, AR_PCU_MISC_MODE3, BIT(5));
 
 	ath9k_hw_set_powermode_wow_sleep(ah);
 	ah->wow.wow_event_mask = wow_event_mask;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c8b3d8f..e82e570 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -199,7 +199,7 @@
 #define KAL_NUM_DESC_WORDS	12
 #define KAL_ANTENNA_MODE	1
 #define KAL_TO_DS		1
-#define KAL_DELAY		4	/*delay of 4ms between 2 KAL frames */
+#define KAL_DELAY		4	/* delay of 4ms between 2 KAL frames */
 #define KAL_TIMEOUT		900
 
 #define MAX_PATTERN_SIZE		256
diff --git a/drivers/net/wireless/ath/ath9k/reg_wow.h b/drivers/net/wireless/ath/ath9k/reg_wow.h
index 83f27f9..3abfca5 100644
--- a/drivers/net/wireless/ath/ath9k/reg_wow.h
+++ b/drivers/net/wireless/ath/ath9k/reg_wow.h
@@ -68,7 +68,7 @@
 #define AR_CLR_MAC_INTERRUPT            0x20
 #define AR_CLR_KA_INTERRUPT             0x40
 
-#define AR_WOW_BACK_OFF_SHIFT(x)        ((x & 0xf) << 28) /* in usecs */
+#define AR_WOW_BACK_OFF_SHIFT(x)        ((x & 0xf) << 27) /* in usecs */
 #define AR_WOW_MAC_INTR_EN              0x00040000
 #define AR_WOW_MAGIC_EN                 0x00010000
 #define AR_WOW_PATTERN_EN(x)            (x & 0xff)
@@ -113,7 +113,8 @@
 #define AR_WOW_KA_DESC_WORD2            0xe000
 #define AR_WOW_TB_PATTERN(i)            (0xe100 + (i << 8))
 #define AR_WOW_TB_MASK(i)               (0xec00 + (i << 5))
-#define AR_WOW_PATTERN_SUPPORTED        0xff
+#define AR_WOW_PATTERN_SUPPORTED_LEGACY 0xff
+#define AR_WOW_PATTERN_SUPPORTED        0xffff
 #define AR_WOW_LENGTH_MAX               0xff
 #define AR_WOW_LEN1_SHIFT(_i)           ((0x3 - ((_i) & 0x3)) << 0x3)
 #define AR_WOW_LENGTH1_MASK(_i)         (AR_WOW_LENGTH_MAX << AR_WOW_LEN1_SHIFT(_i))
-- 
2.2.2

