Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab2BCAQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:58 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/28] iwlwifi: move hw_rev to transport layer
Date: Thu,  2 Feb 2012 15:09:12 -0800
Message-Id: <1328224159-18134-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011703_305376_36B0F6AC)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The HW revision is now read by the transport layer in its allocation.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   13 ++-----------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h      |    1 +
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 14f8b75..36f7ade 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1691,13 +1691,6 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 #endif
 }
 
-
-
-static u32 iwl_hw_detect(struct iwl_priv *priv)
-{
-	return iwl_read32(trans(priv), CSR_HW_REV);
-}
-
 /* Size of one Rx buffer in host DRAM */
 #define IWL_RX_BUF_SIZE_4K (4 * 1024)
 #define IWL_RX_BUF_SIZE_8K (8 * 1024)
@@ -1769,7 +1762,6 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
 	u16 num_mac;
-	u32 hw_rev;
 
 	/************************
 	 * 1. Allocating HW data
@@ -1818,9 +1810,8 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	/***********************
 	 * 3. Read REV register
 	 ***********************/
-	hw_rev = iwl_hw_detect(priv);
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
-		cfg(priv)->name, hw_rev);
+		cfg(priv)->name, trans(priv)->hw_rev);
 
 	err = iwl_trans_start_hw(trans(priv));
 	if (err)
@@ -1830,7 +1821,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	 * 4. Read EEPROM
 	 *****************/
 	/* Read the EEPROM */
-	err = iwl_eeprom_init(priv, hw_rev);
+	err = iwl_eeprom_init(priv, trans(priv)->hw_rev);
 	/* Reset chip to save power until we load uCode during "up". */
 	iwl_trans_stop_hw(trans(priv));
 	if (err) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 4b711b7..ed2a921 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -2317,6 +2317,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 	trans->dev = &pdev->dev;
 	trans->irq = pdev->irq;
 	trans_pcie->pci_dev = pdev;
+	trans->hw_rev = iwl_read32(trans, CSR_HW_REV);
 	trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
 	snprintf(trans->hw_id_str, sizeof(trans->hw_id_str),
 		 "PCI ID: 0x%04X:0x%04X", pdev->device, pdev->subsystem_device);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 0359d71..a305e96 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -253,6 +253,7 @@ struct iwl_trans {
 
 	struct device *dev;
 	unsigned int irq;
+	u32 hw_rev;
 	u32 hw_id;
 	char hw_id_str[52];
 
-- 
1.7.0.4

