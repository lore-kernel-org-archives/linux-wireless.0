Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:34105
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750851Ab2KLFdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 00:33:42 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] ath9k: Remove unused workaround
Date: Mon, 12 Nov 2012 10:56:44 +0530
Message-Id: <1352698004-10790-2-git-send-email-sujith@msujith.org> (sfid-20121112_063359_418813_FFC5ACC7)
In-Reply-To: <1352698004-10790-1-git-send-email-sujith@msujith.org>
References: <1352698004-10790-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The workaround for ASPM/L0s is needed only for AR9485 1.0,
which was never sold and is not supported by ath9k.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |  5 -----
 drivers/net/wireless/ath/ath9k/hw.h   |  3 ---
 drivers/net/wireless/ath/ath9k/main.c |  3 ---
 drivers/net/wireless/ath/ath9k/pci.c  | 12 ------------
 4 files changed, 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 71cd9f0..756191b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2561,11 +2561,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			pCap->hw_caps |= ATH9K_HW_CAP_ANT_DIV_COMB;
 	}
 
-	if (AR_SREV_9485_10(ah)) {
-		pCap->pcie_lcr_extsync_en = true;
-		pCap->pcie_lcr_offset = 0x80;
-	}
-
 	if (ath9k_hw_dfs_tested(ah))
 		pCap->hw_caps |= ATH9K_HW_CAP_DFS;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3e73bfe..bdabbda 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -273,8 +273,6 @@ struct ath9k_hw_capabilities {
 	u8 rx_status_len;
 	u8 tx_desc_len;
 	u8 txs_len;
-	u16 pcie_lcr_offset;
-	bool pcie_lcr_extsync_en;
 };
 
 struct ath9k_ops_config {
@@ -930,7 +928,6 @@ struct ath_bus_ops {
 	void (*read_cachesize)(struct ath_common *common, int *csz);
 	bool (*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
 	void (*bt_coex_prep)(struct ath_common *common);
-	void (*extn_synch_en)(struct ath_common *common);
 	void (*aspm_init)(struct ath_common *common);
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 578a723..5d5a914 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -686,9 +686,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
-	if (ah->caps.pcie_lcr_extsync_en && common->bus_ops->extn_synch_en)
-		common->bus_ops->extn_synch_en(common);
-
 	mutex_unlock(&sc->mutex);
 
 	ath9k_ps_restore(sc);
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index f088f4b..9553203 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -96,17 +96,6 @@ static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 	return true;
 }
 
-static void ath_pci_extn_synch_enable(struct ath_common *common)
-{
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
-	struct pci_dev *pdev = to_pci_dev(sc->dev);
-	u8 lnkctl;
-
-	pci_read_config_byte(pdev, sc->sc_ah->caps.pcie_lcr_offset, &lnkctl);
-	lnkctl |= PCI_EXP_LNKCTL_ES;
-	pci_write_config_byte(pdev, sc->sc_ah->caps.pcie_lcr_offset, lnkctl);
-}
-
 /* Need to be called after we discover btcoex capabilities */
 static void ath_pci_aspm_init(struct ath_common *common)
 {
@@ -153,7 +142,6 @@ static const struct ath_bus_ops ath_pci_bus_ops = {
 	.ath_bus_type = ATH_PCI,
 	.read_cachesize = ath_pci_read_cachesize,
 	.eeprom_read = ath_pci_eeprom_read,
-	.extn_synch_en = ath_pci_extn_synch_enable,
 	.aspm_init = ath_pci_aspm_init,
 };
 
-- 
1.8.0

