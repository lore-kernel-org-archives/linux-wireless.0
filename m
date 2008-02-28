Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:45269 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335AbYB1W7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 17:59:53 -0500
Date: Thu, 28 Feb 2008 17:59:49 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, bruno@thinktube.com,
	me@bobcopeland.com
Subject: [PATCH 6/8] ath5k: Fixes for PCI-E cards
Message-ID: <539106d71489e812ae2b9f000e15332022b21d75.1204236793.git.mcgrof@winlab.rutgers.edu> (sfid-20080228_225955_705566_8341B17B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6d5bb6d43d1ddfb60d5ed8b8d6ee472643eafd8.1204236793.git.mcgrof@winlab.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Fix nic_wakeup for PCI-E chips (don't set AR5K_RESET_CTL_PCI bit)

 * Fix dma size setting for PCI-E chips (thanx to Bob Copeland).

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/ath5k/ath5k.h |   10 ++++----
 drivers/net/wireless/ath5k/hw.c    |   39 ++++++++++++++++++++++++++---------
 2 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index c0b6596..04efcee 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -171,13 +171,13 @@ struct ath5k_srev_name {
 #define AR5K_SREV_VER_AR5213A	0x59
 #define AR5K_SREV_VER_AR2413	0x78
 #define AR5K_SREV_VER_AR2414	0x79
-#define AR5K_SREV_VER_AR2424	0xa0
-#define AR5K_SREV_VER_AR5424	0xa3
+#define AR5K_SREV_VER_AR2424	0xa0 /* PCI-E */
+#define AR5K_SREV_VER_AR5424	0xa3 /* PCI-E */
 #define AR5K_SREV_VER_AR5413	0xa4
 #define AR5K_SREV_VER_AR5414	0xa5
-#define AR5K_SREV_VER_AR5416	0xc0	/* ? */
-#define AR5K_SREV_VER_AR5418	0xca
-#define AR5K_SREV_VER_AR2425	0xe2
+#define AR5K_SREV_VER_AR5416	0xc0 /* PCI-E */
+#define AR5K_SREV_VER_AR5418	0xca /* PCI-E */
+#define AR5K_SREV_VER_AR2425	0xe2 /* PCI-E */
 
 #define AR5K_SREV_RAD_5110	0x00
 #define AR5K_SREV_RAD_5111	0x10
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 6bbd732..6f69e46 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -300,7 +300,8 @@ err:
  */
 static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 {
-	u32 turbo, mode, clock;
+	struct pci_dev *pdev = ah->ah_sc->pdev;
+	u32 turbo, mode, clock, bus_flags;
 	int ret;
 
 	turbo = 0;
@@ -377,9 +378,15 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 					AR5K_PHY_TURBO);
 	}
 
-	/* ...reset chipset and PCI device */
-	if (ah->ah_single_chip == false && ath5k_hw_nic_reset(ah,
-				AR5K_RESET_CTL_CHIP | AR5K_RESET_CTL_PCI)) {
+	/* reseting PCI on PCI-E cards results card to hang
+	 * and always return 0xffff... so we ingore that flag
+	 * for PCI-E cards */
+	bus_flags = (pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
+
+	/* Reset chipset */
+	ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
+		AR5K_RESET_CTL_BASEBAND | bus_flags);
+	if (ret) {
 		ATH5K_ERR(ah->ah_sc, "failed to reset the MAC Chip + PCI\n");
 		return -EIO;
 	}
@@ -588,7 +595,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	struct ieee80211_channel *channel, bool change_channel)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	u32 data, s_seq, s_ant, s_led[3];
+	struct pci_dev *pdev = ah->ah_sc->pdev;
+	u32 data, s_seq, s_ant, s_led[3], dma_size;
 	unsigned int i, mode, freq, ee_mode, ant[2];
 	int ret;
 
@@ -900,13 +908,24 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 	/*
 	 * Set Rx/Tx DMA Configuration
-	 *(passing dma size not available on 5210)
+	 *
+	 * Set maximum DMA size (512) except for PCI-E cards since
+	 * it causes rx overruns and tx errors (tested on 5424 but since
+	 * rx overruns also occur on 5416/5418 with madwifi we set 128
+	 * for all PCI-E cards to be safe).
+	 *
+	 * In dumps this is 128 for allchips.
+	 *
+	 * XXX: need to check 5210 for this
+	 * TODO: Check out tx triger level, it's always 64 on dumps but I
+	 * guess we can tweak it and see how it goes ;-)
 	 */
+	dma_size = (pdev->is_pcie) ? AR5K_DMASIZE_128B : AR5K_DMASIZE_512B;
 	if (ah->ah_version != AR5K_AR5210) {
-		AR5K_REG_WRITE_BITS(ah, AR5K_TXCFG, AR5K_TXCFG_SDMAMR,
-				AR5K_DMASIZE_512B | AR5K_TXCFG_DMASIZE);
-		AR5K_REG_WRITE_BITS(ah, AR5K_RXCFG, AR5K_RXCFG_SDMAMW,
-				AR5K_DMASIZE_512B);
+		AR5K_REG_WRITE_BITS(ah, AR5K_TXCFG,
+			AR5K_TXCFG_SDMAMR, dma_size);
+		AR5K_REG_WRITE_BITS(ah, AR5K_RXCFG,
+			AR5K_RXCFG_SDMAMW, dma_size);
 	}
 
 	/*
-- 
1.5.3.7

