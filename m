Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758612Ab1FKOzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/18] iwlagn: Sanity check for valid context
Date: Sat, 11 Jun 2011 07:25:52 -0700
Message-Id: <1307802352-16398-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165607_927919_6117BEBA)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check EEPROM for multiple contexts support

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   56 +++++++++++++++++++-------------
 1 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 488081f..0acf929 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1485,7 +1485,8 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	priv->new_scan_threshold_behaviour =
 		!!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
 
-	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
+	if ((priv->cfg->sku & EEPROM_SKU_CAP_IPAN_ENABLE) &&
+	    (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN)) {
 		priv->valid_contexts |= BIT(IWL_RXON_CTX_PAN);
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
 	} else
@@ -3425,27 +3426,9 @@ out:
 	return hw;
 }
 
-static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+static void iwl_init_context(struct iwl_priv *priv)
 {
-	int err = 0, i;
-	struct iwl_priv *priv;
-	struct ieee80211_hw *hw;
-	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
-	unsigned long flags;
-	u16 pci_cmd, num_mac;
-	u32 hw_rev;
-
-	/************************
-	 * 1. Allocating HW data
-	 ************************/
-
-	hw = iwl_alloc_all(cfg);
-	if (!hw) {
-		err = -ENOMEM;
-		goto out;
-	}
-	priv = hw->priv;
-	/* At this point both hw and priv are allocated. */
+	int i;
 
 	/*
 	 * The default context is always valid,
@@ -3477,8 +3460,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->contexts[IWL_RXON_CTX_BSS].unused_devtype = RXON_DEV_TYPE_ESS;
 
 	priv->contexts[IWL_RXON_CTX_PAN].rxon_cmd = REPLY_WIPAN_RXON;
-	priv->contexts[IWL_RXON_CTX_PAN].rxon_timing_cmd = REPLY_WIPAN_RXON_TIMING;
-	priv->contexts[IWL_RXON_CTX_PAN].rxon_assoc_cmd = REPLY_WIPAN_RXON_ASSOC;
+	priv->contexts[IWL_RXON_CTX_PAN].rxon_timing_cmd =
+		REPLY_WIPAN_RXON_TIMING;
+	priv->contexts[IWL_RXON_CTX_PAN].rxon_assoc_cmd =
+		REPLY_WIPAN_RXON_ASSOC;
 	priv->contexts[IWL_RXON_CTX_PAN].qos_cmd = REPLY_WIPAN_QOS_PARAM;
 	priv->contexts[IWL_RXON_CTX_PAN].ap_sta_id = IWL_AP_ID_PAN;
 	priv->contexts[IWL_RXON_CTX_PAN].wep_key_cmd = REPLY_WIPAN_WEPKEY;
@@ -3498,6 +3483,28 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->contexts[IWL_RXON_CTX_PAN].unused_devtype = RXON_DEV_TYPE_P2P;
 
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
+}
+
+static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	int err = 0;
+	struct iwl_priv *priv;
+	struct ieee80211_hw *hw;
+	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
+	unsigned long flags;
+	u16 pci_cmd, num_mac;
+	u32 hw_rev;
+
+	/************************
+	 * 1. Allocating HW data
+	 ************************/
+
+	hw = iwl_alloc_all(cfg);
+	if (!hw) {
+		err = -ENOMEM;
+		goto out;	}
+	priv = hw->priv;
+	/* At this point both hw and priv are allocated. */
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
@@ -3622,6 +3629,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		priv->hw->wiphy->n_addresses++;
 	}
 
+	/* initialize all valid contexts */
+	iwl_init_context(priv);
+
 	/************************
 	 * 5. Setup HW constants
 	 ************************/
-- 
1.7.0.4

