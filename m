Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527Ab1DERBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/25] iwlagn: remove hw_rev
Date: Tue,  5 Apr 2011 09:42:08 -0700
Message-Id: <1302021732-21250-22-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The hw_rev variable is used only during init,
so there's no need to keep it around.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   11 ++++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 -
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index da515b2..5912ede 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3683,11 +3683,11 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.offchannel_tx_cancel_wait = iwl_mac_offchannel_tx_cancel_wait,
 };
 
-static void iwl_hw_detect(struct iwl_priv *priv)
+static u32 iwl_hw_detect(struct iwl_priv *priv)
 {
-	priv->hw_rev = _iwl_read32(priv, CSR_HW_REV);
 	priv->rev_id = priv->pci_dev->revision;
 	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", priv->rev_id);
+	return _iwl_read32(priv, CSR_HW_REV);
 }
 
 static int iwl_set_hw_params(struct iwl_priv *priv)
@@ -3738,6 +3738,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	unsigned long flags;
 	u16 pci_cmd, num_mac;
+	u32 hw_rev;
 
 	/************************
 	 * 1. Allocating HW data
@@ -3883,9 +3884,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
-	iwl_hw_detect(priv);
+	hw_rev = iwl_hw_detect(priv);
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
-		priv->cfg->name, priv->hw_rev);
+		priv->cfg->name, hw_rev);
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
 	 * PCI Tx retries from interfering with C3 CPU state */
@@ -3901,7 +3902,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * 4. Read EEPROM
 	 *****************/
 	/* Read the EEPROM */
-	err = iwl_eeprom_init(priv);
+	err = iwl_eeprom_init(priv, hw_rev);
 	if (err) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
 		goto out_iounmap;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f004dae..892bcfa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1253,7 +1253,6 @@ struct iwl_priv {
 
 	/* pci hardware address support */
 	void __iomem *hw_base;
-	u32  hw_rev;
 	u8   rev_id;
 
 	/* microcode/device supports multiple contexts */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index f70d871..4f8c13e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -188,13 +188,13 @@ static void iwl_set_otp_access(struct iwl_priv *priv, enum iwl_access_mode mode)
 				CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 }
 
-static int iwlcore_get_nvm_type(struct iwl_priv *priv)
+static int iwlcore_get_nvm_type(struct iwl_priv *priv, u32 hw_rev)
 {
 	u32 otpgp;
 	int nvm_type;
 
 	/* OTP only valid for CP/PP and after */
-	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
+	switch (hw_rev & CSR_HW_REV_TYPE_MSK) {
 	case CSR_HW_REV_TYPE_NONE:
 		IWL_ERR(priv, "Unknown hardware type\n");
 		return -ENOENT;
@@ -394,7 +394,7 @@ u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset)
  *
  * NOTE:  This routine uses the non-debug IO access functions.
  */
-int iwl_eeprom_init(struct iwl_priv *priv)
+int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 {
 	__le16 *e;
 	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
@@ -404,7 +404,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 	u16 validblockaddr = 0;
 	u16 cache_addr = 0;
 
-	priv->nvm_device_type = iwlcore_get_nvm_type(priv);
+	priv->nvm_device_type = iwlcore_get_nvm_type(priv, hw_rev);
 	if (priv->nvm_device_type == -ENOENT)
 		return -ENOENT;
 	/* allocate eeprom */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 35bf54b..6b4343b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -302,7 +302,7 @@ struct iwl_eeprom_ops {
 };
 
 
-int iwl_eeprom_init(struct iwl_priv *priv);
+int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev);
 void iwl_eeprom_free(struct iwl_priv *priv);
 int  iwl_eeprom_check_version(struct iwl_priv *priv);
 int  iwl_eeprom_check_sku(struct iwl_priv *priv);
-- 
1.7.0.4

