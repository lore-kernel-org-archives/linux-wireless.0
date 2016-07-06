Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33578 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753917AbcGFKqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:46:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:51 +0300
Message-Id: <1467801651-1816-56-git-send-email-luca@coelho.fi> (sfid-20160706_124613_515885_4382524B)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 56/56] iwlwifi: move iwl_drv to be shared across transports
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

All transports has this structure. By moving it to be
shared, we can get rid of casting to the specific transport
in probe and remove.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 14 +++++---------
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 --
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 9ac47e0..5535e22 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -761,6 +761,7 @@ enum iwl_plat_pm_mode {
  * @ops - pointer to iwl_trans_ops
  * @op_mode - pointer to the op_mode
  * @cfg - pointer to the configuration
+ * @drv - pointer to iwl_drv
  * @status: a bit-mask of transport status flags
  * @dev - pointer to struct device * that represents the device
  * @max_skb_frags: maximum number of fragments an SKB can have when transmitted.
@@ -804,6 +805,7 @@ struct iwl_trans {
 	const struct iwl_trans_ops *ops;
 	struct iwl_op_mode *op_mode;
 	const struct iwl_cfg *cfg;
+	struct iwl_drv *drv;
 	enum iwl_trans_state state;
 	unsigned long status;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index f70c3e2..78cf9a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -610,7 +610,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	const struct iwl_cfg *cfg_7265d __maybe_unused = NULL;
 	const struct iwl_cfg *cfg_9260lc __maybe_unused = NULL;
 	struct iwl_trans *iwl_trans;
-	struct iwl_trans_pcie *trans_pcie;
 	int ret;
 
 	iwl_trans = iwl_trans_pcie_alloc(pdev, ent, cfg);
@@ -648,12 +647,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 
 	pci_set_drvdata(pdev, iwl_trans);
+	iwl_trans->drv = iwl_drv_start(iwl_trans, cfg);
 
-	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(iwl_trans);
-	trans_pcie->drv = iwl_drv_start(iwl_trans, cfg);
-
-	if (IS_ERR(trans_pcie->drv)) {
-		ret = PTR_ERR(trans_pcie->drv);
+	if (IS_ERR(iwl_trans->drv)) {
+		ret = PTR_ERR(iwl_trans->drv);
 		goto out_free_trans;
 	}
 
@@ -692,7 +689,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 out_free_drv:
-	iwl_drv_stop(trans_pcie->drv);
+	iwl_drv_stop(iwl_trans->drv);
 out_free_trans:
 	iwl_trans_pcie_free(iwl_trans);
 	return ret;
@@ -701,7 +698,6 @@ out_free_trans:
 static void iwl_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_trans *trans = pci_get_drvdata(pdev);
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	/* if RTPM was in use, restore it to the state before probe */
 	if (trans->runtime_pm_mode != IWL_PLAT_PM_MODE_DISABLED) {
@@ -712,7 +708,7 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 		pm_runtime_forbid(trans->dev);
 	}
 
-	iwl_drv_stop(trans_pcie->drv);
+	iwl_drv_stop(trans->drv);
 
 	iwl_trans_pcie_free(trans);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index e3047f2..11e347d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -314,7 +314,6 @@ struct iwl_tso_hdr_page {
  * @rx_pool: initial pool of iwl_rx_mem_buffer for all the queues
  * @global_table: table mapping received VID from hw to rxb
  * @rba: allocator for RX replenishing
- * @drv - pointer to iwl_drv
  * @trans: pointer to the generic transport area
  * @scd_base_addr: scheduler sram base address in SRAM
  * @scd_bc_tbls: pointer to the byte count table of the scheduler
@@ -352,7 +351,6 @@ struct iwl_trans_pcie {
 	struct iwl_rx_mem_buffer *global_table[RX_POOL_SIZE];
 	struct iwl_rb_allocator rba;
 	struct iwl_trans *trans;
-	struct iwl_drv *drv;
 
 	struct net_device napi_dev;
 
-- 
2.8.1

