Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50708 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752692AbdDKMju (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:39:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:38 +0300
Message-Id: <20170411123742.12214-22-luca@coelho.fi> (sfid-20170411_145544_413665_7687A240)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 21/25] iwlwifi: remove unnecessary dev_cmd_headroom parameter
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We don't need this parameter anymore, since we always pass 0 anyway.
Remove it from the structure and from all the relevant functions.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c  |  7 ++-----
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h  | 17 +++++------------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |  2 +-
 3 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index d42cab291025..0bde26bab15d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -70,8 +70,7 @@
 struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 				  struct device *dev,
 				  const struct iwl_cfg *cfg,
-				  const struct iwl_trans_ops *ops,
-				  size_t dev_cmd_headroom)
+				  const struct iwl_trans_ops *ops)
 {
 	struct iwl_trans *trans;
 #ifdef CONFIG_LOCKDEP
@@ -90,15 +89,13 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 	trans->dev = dev;
 	trans->cfg = cfg;
 	trans->ops = ops;
-	trans->dev_cmd_headroom = dev_cmd_headroom;
 	trans->num_rx_queues = 1;
 
 	snprintf(trans->dev_cmd_pool_name, sizeof(trans->dev_cmd_pool_name),
 		 "iwl_cmd_pool:%s", dev_name(trans->dev));
 	trans->dev_cmd_pool =
 		kmem_cache_create(trans->dev_cmd_pool_name,
-				  sizeof(struct iwl_device_cmd)
-				  + trans->dev_cmd_headroom,
+				  sizeof(struct iwl_device_cmd),
 				  sizeof(void *),
 				  SLAB_HWCACHE_ALIGN,
 				  NULL);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index b52804dd884f..1b4b62ede2c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -772,9 +772,6 @@ enum iwl_plat_pm_mode {
  *	the transport must set this before calling iwl_drv_start()
  * @dev_cmd_pool: pool for Tx cmd allocation - for internal use only.
  *	The user should use iwl_trans_{alloc,free}_tx_cmd.
- * @dev_cmd_headroom: room needed for the transport's private use before the
- *	device_cmd for Tx - for internal use only
- *	The user should use iwl_trans_{alloc,free}_tx_cmd.
  * @rx_mpdu_cmd: MPDU RX command ID, must be assigned by opmode before
  *	starting the firmware, used for tracing
  * @rx_mpdu_cmd_hdr_size: used for tracing, amount of data before the
@@ -825,7 +822,6 @@ struct iwl_trans {
 
 	/* The following fields are internal only */
 	struct kmem_cache *dev_cmd_pool;
-	size_t dev_cmd_headroom;
 	char dev_cmd_pool_name[50];
 
 	struct dentry *dbgfs_dir;
@@ -998,13 +994,13 @@ iwl_trans_dump_data(struct iwl_trans *trans,
 static inline struct iwl_device_cmd *
 iwl_trans_alloc_tx_cmd(struct iwl_trans *trans)
 {
-	u8 *dev_cmd_ptr = kmem_cache_alloc(trans->dev_cmd_pool, GFP_ATOMIC);
+	struct iwl_device_cmd *dev_cmd_ptr =
+		kmem_cache_alloc(trans->dev_cmd_pool, GFP_ATOMIC);
 
 	if (unlikely(dev_cmd_ptr == NULL))
 		return NULL;
 
-	return (struct iwl_device_cmd *)
-			(dev_cmd_ptr + trans->dev_cmd_headroom);
+	return dev_cmd_ptr;
 }
 
 int iwl_trans_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
@@ -1012,9 +1008,7 @@ int iwl_trans_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 static inline void iwl_trans_free_tx_cmd(struct iwl_trans *trans,
 					 struct iwl_device_cmd *dev_cmd)
 {
-	u8 *dev_cmd_ptr = (u8 *)dev_cmd - trans->dev_cmd_headroom;
-
-	kmem_cache_free(trans->dev_cmd_pool, dev_cmd_ptr);
+	kmem_cache_free(trans->dev_cmd_pool, dev_cmd);
 }
 
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
@@ -1237,8 +1231,7 @@ static inline void iwl_trans_fw_error(struct iwl_trans *trans)
 struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 				  struct device *dev,
 				  const struct iwl_cfg *cfg,
-				  const struct iwl_trans_ops *ops,
-				  size_t dev_cmd_headroom);
+				  const struct iwl_trans_ops *ops);
 void iwl_trans_free(struct iwl_trans *trans);
 
 /*****************************************************
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 15bf5100d096..b362779b66f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2948,7 +2948,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		return ERR_PTR(ret);
 
 	trans = iwl_trans_alloc(sizeof(struct iwl_trans_pcie),
-				&pdev->dev, cfg, &trans_ops_pcie, 0);
+				&pdev->dev, cfg, &trans_ops_pcie);
 	if (!trans)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.11.0
