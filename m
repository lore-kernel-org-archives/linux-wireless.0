Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21335 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab1DERBd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/25] iwlagn: remove ucode_data_backup
Date: Tue,  5 Apr 2011 09:41:59 -0700
Message-Id: <1302021732-21250-13-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This was used only on 4965 in conjunction with
the bootstrap ucode.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   19 +------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h |    1 -
 2 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f959cf4..32028cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1176,7 +1176,6 @@ static void iwl_dealloc_ucode_pci(struct iwl_priv *priv)
 {
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_code);
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_data);
-	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_data_backup);
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_init);
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_init_data);
 }
@@ -1643,11 +1642,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	priv->ucode_data.len = pieces.data_size;
 	iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_data);
 
-	priv->ucode_data_backup.len = pieces.data_size;
-	iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_data_backup);
-
-	if (!priv->ucode_code.v_addr || !priv->ucode_data.v_addr ||
-	    !priv->ucode_data_backup.v_addr)
+	if (!priv->ucode_code.v_addr || !priv->ucode_data.v_addr)
 		goto err_pci_alloc;
 
 	/* Initialization instructions and data */
@@ -1707,7 +1702,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	IWL_DEBUG_INFO(priv, "Copying (but not loading) uCode data len %Zd\n",
 			pieces.data_size);
 	memcpy(priv->ucode_data.v_addr, pieces.data, pieces.data_size);
-	memcpy(priv->ucode_data_backup.v_addr, pieces.data, pieces.data_size);
 
 	/* Initialization instructions */
 	if (pieces.init_size) {
@@ -2482,11 +2476,6 @@ static int __iwl_up(struct iwl_priv *priv)
 		return -EIO;
 	}
 
-	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
-		IWL_ERR(priv, "ucode not available for device bringup\n");
-		return -EIO;
-	}
-
 	for_each_context(priv, ctx) {
 		ret = iwlagn_alloc_bcast_station(priv, ctx);
 		if (ret) {
@@ -2543,12 +2532,6 @@ static int __iwl_up(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
-	/* Copy original ucode data image from disk into backup cache.
-	 * This will be used to initialize the on-board processor's
-	 * data SRAM for a clean start when the runtime program first loads. */
-	memcpy(priv->ucode_data_backup.v_addr, priv->ucode_data.v_addr,
-	       priv->ucode_data.len);
-
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
 		/* load bootstrap state machine,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c3a9ec8..b7f88fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1259,7 +1259,6 @@ struct iwl_priv {
 					   iwl_ucode.ver */
 	struct fw_desc ucode_code;	/* runtime inst */
 	struct fw_desc ucode_data;	/* runtime data original */
-	struct fw_desc ucode_data_backup;	/* runtime data save/restore */
 	struct fw_desc ucode_init;	/* initialization inst */
 	struct fw_desc ucode_init_data;	/* initialization data */
 	enum ucode_type ucode_type;
-- 
1.7.0.4

