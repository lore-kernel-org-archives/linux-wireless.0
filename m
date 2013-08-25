Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48777 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab3HYJQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Aug 2013 05:16:59 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix ASPM for AR9462
Date: Sun, 25 Aug 2013 14:43:09 +0530
Message-Id: <1377421989-21240-1-git-send-email-sujith@msujith.org> (sfid-20130825_111702_777578_06B9461D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

If the L1 entrance latency is not calibrated properly
in the EEPROM in WB222 boards, there could be problems
in connectivity. Check and correct the calibrated value
if it doesn't match the optimal value for WB222, 4us.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 14 ++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h        |  1 +
 drivers/net/wireless/ath/ath9k/pci.c       | 16 ++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 738aa7e..582cddd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -745,6 +745,20 @@ static void ar9003_hw_init_mode_gain_regs(struct ath_hw *ah)
 static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 					 bool power_off)
 {
+	/*
+	 * Increase L1 Entry Latency. Some WB222 boards don't have
+	 * this change in eeprom/OTP.
+	 *
+	 */
+	if (AR_SREV_9462(ah)) {
+		u32 val = ah->config.aspm_l1_fix;
+		if ((val & 0xff000000) == 0x17000000) {
+			val &= 0x00ffffff;
+			val |= 0x27000000;
+			REG_WRITE(ah, 0x570c, val);
+		}
+	}
+
 	/* Nothing to do on restore for 11N */
 	if (!power_off /* !restore */) {
 		/* set bit 19 to allow forcing of pcie core into L1 state */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index fa543a6..69a907b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -311,6 +311,7 @@ struct ath9k_ops_config {
 	u16 ani_poll_interval; /* ANI poll interval in ms */
 
 	/* Platform specific config */
+	u32 aspm_l1_fix;
 	u32 xlna_gpio;
 	u32 ant_ctrl_comm2g_switch_enable;
 	bool xatten_margin_cfg;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 3280798..e7996a6 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -314,6 +314,22 @@ static void ath_pci_aspm_init(struct ath_common *common)
 		return;
 	}
 
+	/*
+	 * 0x70c - Ack Frequency Register.
+	 *
+	 * Bits 27:29 - DEFAULT_L1_ENTRANCE_LATENCY.
+	 *
+	 * 000 : 1 us
+	 * 001 : 2 us
+	 * 010 : 4 us
+	 * 011 : 8 us
+	 * 100 : 16 us
+	 * 101 : 32 us
+	 * 110/111 : 64 us
+	 */
+	if (AR_SREV_9462(ah))
+		pci_read_config_dword(pdev, 0x70c, &ah->config.aspm_l1_fix);
+
 	pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &aspm);
 	if (aspm & (PCI_EXP_LNKCTL_ASPM_L0S | PCI_EXP_LNKCTL_ASPM_L1)) {
 		ah->aspm_enabled = true;
-- 
1.8.3.4

