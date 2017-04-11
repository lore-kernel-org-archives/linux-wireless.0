Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50748 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751797AbdDKMk3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:40:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:39 +0300
Message-Id: <20170411123742.12214-23-luca@coelho.fi> (sfid-20170411_145544_286370_1DC7FD11)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 22/25] iwlwifi: pcie: introduce split point to a000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

a000 devices are going to have a lot of flows simplified
and changed: init flow, RX, TX, and more.
This, combined with the fact that code is already very
complicated due to backward compatibility - introduce
a split that will enable to introduce simplified version
of functions.
Shared ops are moved to a macro, while functions that will
be updated in the next patches are defined twice for now.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c   |  3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 85 +++++++++++++++++--------
 3 files changed, 62 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index 20739e92aef6..df4e8714d627 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -121,7 +121,8 @@ static const struct iwl_ht_params iwl_a000_ht_params = {
 	.vht_mu_mimo_supported = true,					\
 	.mac_addr_from_csr = true,					\
 	.use_tfh = true,						\
-	.rf_id = true
+	.rf_id = true,							\
+	.gen2 = true
 
 const struct iwl_cfg iwla000_2ac_cfg_hr = {
 		.name = "Intel(R) Dual Band Wireless AC a000",
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 852963487bd9..717e089ff036 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -323,6 +323,7 @@ struct iwl_pwr_tx_backoff {
  * @vht_mu_mimo_supported: VHT MU-MIMO support
  * @rf_id: need to read rf_id to determine the firmware image
  * @integrated: discrete or integrated
+ * @gen2: a000 and on transport operation
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -368,7 +369,8 @@ struct iwl_cfg {
 	    vht_mu_mimo_supported:1,
 	    rf_id:1,
 	    integrated:1,
-	    use_tfh:1;
+	    use_tfh:1,
+	    gen2:1;
 	u8 valid_tx_ant;
 	u8 valid_rx_ant;
 	u8 non_shared_ant;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index b362779b66f4..16c8b37bf6d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2887,20 +2887,64 @@ static void iwl_trans_pcie_resume(struct iwl_trans *trans)
 }
 #endif /* CONFIG_PM_SLEEP */
 
+#define IWL_TRANS_COMMON_OPS						\
+	.op_mode_leave = iwl_trans_pcie_op_mode_leave,			\
+	.write8 = iwl_trans_pcie_write8,				\
+	.write32 = iwl_trans_pcie_write32,				\
+	.read32 = iwl_trans_pcie_read32,				\
+	.read_prph = iwl_trans_pcie_read_prph,				\
+	.write_prph = iwl_trans_pcie_write_prph,			\
+	.read_mem = iwl_trans_pcie_read_mem,				\
+	.write_mem = iwl_trans_pcie_write_mem,				\
+	.configure = iwl_trans_pcie_configure,				\
+	.set_pmi = iwl_trans_pcie_set_pmi,				\
+	.grab_nic_access = iwl_trans_pcie_grab_nic_access,		\
+	.release_nic_access = iwl_trans_pcie_release_nic_access,	\
+	.set_bits_mask = iwl_trans_pcie_set_bits_mask,			\
+	.ref = iwl_trans_pcie_ref,					\
+	.unref = iwl_trans_pcie_unref,					\
+	.dump_data = iwl_trans_pcie_dump_data,				\
+	.wait_tx_queue_empty = iwl_trans_pcie_wait_txq_empty,		\
+	.d3_suspend = iwl_trans_pcie_d3_suspend,			\
+	.d3_resume = iwl_trans_pcie_d3_resume
+
+#ifdef CONFIG_PM_SLEEP
+#define IWL_TRANS_PM_OPS						\
+	.suspend = iwl_trans_pcie_suspend,				\
+	.resume = iwl_trans_pcie_resume,
+#else
+#define IWL_TRANS_PM_OPS
+#endif /* CONFIG_PM_SLEEP */
+
 static const struct iwl_trans_ops trans_ops_pcie = {
+	IWL_TRANS_COMMON_OPS,
+	IWL_TRANS_PM_OPS
 	.start_hw = iwl_trans_pcie_start_hw,
-	.op_mode_leave = iwl_trans_pcie_op_mode_leave,
 	.fw_alive = iwl_trans_pcie_fw_alive,
 	.start_fw = iwl_trans_pcie_start_fw,
 	.stop_device = iwl_trans_pcie_stop_device,
 
-	.d3_suspend = iwl_trans_pcie_d3_suspend,
-	.d3_resume = iwl_trans_pcie_d3_resume,
+	.send_cmd = iwl_trans_pcie_send_hcmd,
+
+	.tx = iwl_trans_pcie_tx,
+	.reclaim = iwl_trans_pcie_reclaim,
 
-#ifdef CONFIG_PM_SLEEP
-	.suspend = iwl_trans_pcie_suspend,
-	.resume = iwl_trans_pcie_resume,
-#endif /* CONFIG_PM_SLEEP */
+	.txq_disable = iwl_trans_pcie_txq_disable,
+	.txq_enable = iwl_trans_pcie_txq_enable,
+
+	.txq_set_shared_mode = iwl_trans_pcie_txq_set_shared_mode,
+
+	.freeze_txq_timer = iwl_trans_pcie_freeze_txq_timer,
+	.block_txq_ptrs = iwl_trans_pcie_block_txq_ptrs,
+};
+
+static const struct iwl_trans_ops trans_ops_pcie_gen2 = {
+	IWL_TRANS_COMMON_OPS,
+	IWL_TRANS_PM_OPS
+	.start_hw = iwl_trans_pcie_start_hw,
+	.fw_alive = iwl_trans_pcie_fw_alive,
+	.start_fw = iwl_trans_pcie_start_fw,
+	.stop_device = iwl_trans_pcie_stop_device,
 
 	.send_cmd = iwl_trans_pcie_send_hcmd,
 
@@ -2912,27 +2956,8 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 
 	.txq_set_shared_mode = iwl_trans_pcie_txq_set_shared_mode,
 
-	.wait_tx_queue_empty = iwl_trans_pcie_wait_txq_empty,
 	.freeze_txq_timer = iwl_trans_pcie_freeze_txq_timer,
 	.block_txq_ptrs = iwl_trans_pcie_block_txq_ptrs,
-
-	.write8 = iwl_trans_pcie_write8,
-	.write32 = iwl_trans_pcie_write32,
-	.read32 = iwl_trans_pcie_read32,
-	.read_prph = iwl_trans_pcie_read_prph,
-	.write_prph = iwl_trans_pcie_write_prph,
-	.read_mem = iwl_trans_pcie_read_mem,
-	.write_mem = iwl_trans_pcie_write_mem,
-	.configure = iwl_trans_pcie_configure,
-	.set_pmi = iwl_trans_pcie_set_pmi,
-	.grab_nic_access = iwl_trans_pcie_grab_nic_access,
-	.release_nic_access = iwl_trans_pcie_release_nic_access,
-	.set_bits_mask = iwl_trans_pcie_set_bits_mask,
-
-	.ref = iwl_trans_pcie_ref,
-	.unref = iwl_trans_pcie_unref,
-
-	.dump_data = iwl_trans_pcie_dump_data,
 };
 
 struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
@@ -2947,8 +2972,12 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	if (ret)
 		return ERR_PTR(ret);
 
-	trans = iwl_trans_alloc(sizeof(struct iwl_trans_pcie),
-				&pdev->dev, cfg, &trans_ops_pcie);
+	if (cfg->gen2)
+		trans = iwl_trans_alloc(sizeof(struct iwl_trans_pcie),
+					&pdev->dev, cfg, &trans_ops_pcie_gen2);
+	else
+		trans = iwl_trans_alloc(sizeof(struct iwl_trans_pcie),
+					&pdev->dev, cfg, &trans_ops_pcie);
 	if (!trans)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.11.0
