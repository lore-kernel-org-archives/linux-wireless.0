Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30959 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbYDXAPM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 04/16] iwlwifi: handle shared memory
Date: Wed, 23 Apr 2008 17:14:56 -0700
Message-Id: <1208996108-15326-5-git-send-email-reinette.chatre@intel.com> (sfid-20080424_021605_237583_F5106A2A)
In-Reply-To: <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch generalize the use of shared memory, as size of this memory is
now allocated and freed by handlers, and also changes the location of those
actions for better resource management

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   36 ++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 ++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   23 ++++++----------
 3 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a41a83a..e80f602 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -276,18 +276,6 @@ static int iwl4965_init_drv(struct iwl_priv *priv)
 	spin_lock_init(&priv->hcmd_lock);
 	spin_lock_init(&priv->lq_mngr.lock);
 
-	priv->shared_virt = pci_alloc_consistent(priv->pci_dev,
-					sizeof(struct iwl4965_shared),
-					&priv->shared_phys);
-
-	if (!priv->shared_virt) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	memset(priv->shared_virt, 0, sizeof(struct iwl4965_shared));
-
-
 	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++)
 		INIT_LIST_HEAD(&priv->ibss_mac_hash[i]);
 
@@ -2492,6 +2480,28 @@ static void iwl4965_hw_card_show_info(struct iwl_priv *priv)
 		       &priv->eeprom[EEPROM_4965_BOARD_PBA]);
 }
 
+static int iwl4965_alloc_shared_mem(struct iwl_priv *priv)
+{
+	priv->shared_virt = pci_alloc_consistent(priv->pci_dev,
+					sizeof(struct iwl4965_shared),
+					&priv->shared_phys);
+	if (!priv->shared_virt)
+		return -ENOMEM;
+
+	memset(priv->shared_virt, 0, sizeof(struct iwl4965_shared));
+
+	return 0;
+}
+
+static void iwl4965_free_shared_mem(struct iwl_priv *priv)
+{
+	if (priv->shared_virt)
+		pci_free_consistent(priv->pci_dev,
+				    sizeof(struct iwl4965_shared),
+				    priv->shared_virt,
+				    priv->shared_phys);
+}
+
 #define IWL_TX_CRC_SIZE		4
 #define IWL_TX_DELIMITER_SIZE	4
 
@@ -4351,6 +4361,8 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 static struct iwl_lib_ops iwl4965_lib = {
 	.init_drv = iwl4965_init_drv,
 	.set_hw_params = iwl4965_hw_set_hw_params,
+	.alloc_shared_mem = iwl4965_alloc_shared_mem,
+	.free_shared_mem = iwl4965_free_shared_mem,
 	.txq_update_byte_cnt_tbl = iwl4965_txq_update_byte_cnt_tbl,
 	.hw_nic_init = iwl4965_hw_nic_init,
 	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index eff076e..e94aea3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -101,7 +101,9 @@ struct iwl_lib_ops {
 	int (*init_drv)(struct iwl_priv *priv);
 	/* set hw dependant perameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
-
+	/* ucode shared memory */
+	int (*alloc_shared_mem)(struct iwl_priv *priv);
+	void (*free_shared_mem)(struct iwl_priv *priv);
 	void (*txq_update_byte_cnt_tbl)(struct iwl_priv *priv,
 					struct iwl4965_tx_queue *txq,
 					u16 byte_cnt);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index de9b932..5299ba3 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1128,15 +1128,6 @@ static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
  *
  ******************************************************************************/
 
-static void iwl4965_unset_hw_params(struct iwl_priv *priv)
-{
-	if (priv->shared_virt)
-		pci_free_consistent(priv->pci_dev,
-				    sizeof(struct iwl4965_shared),
-				    priv->shared_virt,
-				    priv->shared_phys);
-}
-
 /**
  * iwl4965_supported_rate_to_ie - fill in the supported rate in IE field
  *
@@ -5298,6 +5289,7 @@ static void __iwl4965_down(struct iwl_priv *priv)
 	iwl4965_hw_nic_stop_master(priv);
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 	iwl4965_hw_nic_reset(priv);
+	priv->cfg->ops->lib->free_shared_mem(priv);
 
  exit:
 	memset(&priv->card_alive, 0, sizeof(struct iwl4965_alive_resp));
@@ -5359,6 +5351,12 @@ static int __iwl4965_up(struct iwl_priv *priv)
 	iwl_rfkill_set_hw_state(priv);
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
+	ret = priv->cfg->ops->lib->alloc_shared_mem(priv);
+	if (ret) {
+		IWL_ERROR("Unable to allocate shared memory\n");
+		return ret;
+	}
+
 	ret = priv->cfg->ops->lib->hw_nic_init(priv);
 	if (ret) {
 		IWL_ERROR("Unable to init nic\n");
@@ -7504,7 +7502,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	err = iwl_setup(priv);
 	if (err)
-		goto out_unset_hw_params;
+		goto out_free_eeprom;
 	/* At this point both hw and priv are initialized. */
 
 	/**********************************
@@ -7530,7 +7528,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 	if (err) {
 		IWL_ERROR("failed to create sysfs device attributes\n");
-		goto out_unset_hw_params;
+		goto out_free_eeprom;
 	}
 
 	err = iwl_dbgfs_register(priv, DRV_NAME);
@@ -7554,8 +7552,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
  out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
- out_unset_hw_params:
-	iwl4965_unset_hw_params(priv);
  out_free_eeprom:
 	iwl_eeprom_free(priv);
  out_iounmap:
@@ -7619,7 +7615,6 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 		iwl4965_rx_queue_free(priv, &priv->rxq);
 	iwl4965_hw_txq_ctx_free(priv);
 
-	iwl4965_unset_hw_params(priv);
 	iwlcore_clear_stations_table(priv);
 	iwl_eeprom_free(priv);
 
-- 
1.5.3.4

