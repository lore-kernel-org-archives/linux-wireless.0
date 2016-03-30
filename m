Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47797 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbcC3OFr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:47 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/43] iwlwifi: pcie: refcounting is not necessary anymore
Date: Wed, 30 Mar 2016 17:04:41 +0300
Message-Id: <1459346715-7954-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160811_466490_327C7E47)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We don't use the refcount value anymore, all the refcounting is done
in the runtime PM usage_count value.  Remove it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  4 +---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  4 ----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 25 ++++++++--------------
 3 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 05b9685..3456669 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -651,10 +651,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* The PCI device starts with a reference taken and we are
 	 * supposed to release it here.  But to simplify the
 	 * interaction with the opmode, we don't do it now, but let
-	 * the opmode release it when it's ready.  To account for this
-	 * reference, we start with ref_count set to 1.
+	 * the opmode release it when it's ready.
 	 */
-	trans_pcie->ref_count = 1;
 
 	return 0;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 34bf7ce..9ce4ec6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -403,10 +403,6 @@ struct iwl_trans_pcie {
 	bool cmd_hold_nic_awake;
 	bool ref_cmd_in_flight;
 
-	/* protect ref counter */
-	spinlock_t ref_lock;
-	u32 ref_count;
-
 	dma_addr_t fw_mon_phys;
 	struct page *fw_mon_page;
 	u32 fw_mon_size;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index d4306e2..007bcb5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2015,38 +2015,32 @@ static void iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans, u32 reg,
 void iwl_trans_pcie_ref(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 
 	if (iwlwifi_mod_params.d0i3_disable)
 		return;
 
-	spin_lock_irqsave(&trans_pcie->ref_lock, flags);
-	IWL_DEBUG_RPM(trans, "ref_counter: %d\n", trans_pcie->ref_count);
-	trans_pcie->ref_count++;
 	pm_runtime_get(&trans_pcie->pci_dev->dev);
-	spin_unlock_irqrestore(&trans_pcie->ref_lock, flags);
+
+#ifdef CONFIG_PM
+	IWL_DEBUG_RPM(trans, "runtime usage count: %d\n",
+		      atomic_read(&trans_pcie->pci_dev->dev.power.usage_count));
+#endif /* CONFIG_PM */
 }
 
 void iwl_trans_pcie_unref(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 
 	if (iwlwifi_mod_params.d0i3_disable)
 		return;
 
-	spin_lock_irqsave(&trans_pcie->ref_lock, flags);
-	IWL_DEBUG_RPM(trans, "ref_counter: %d\n", trans_pcie->ref_count);
-	if (WARN_ON_ONCE(trans_pcie->ref_count == 0)) {
-		spin_unlock_irqrestore(&trans_pcie->ref_lock, flags);
-		return;
-	}
-	trans_pcie->ref_count--;
-
 	pm_runtime_mark_last_busy(&trans_pcie->pci_dev->dev);
 	pm_runtime_put_autosuspend(&trans_pcie->pci_dev->dev);
 
-	spin_unlock_irqrestore(&trans_pcie->ref_lock, flags);
+#ifdef CONFIG_PM
+	IWL_DEBUG_RPM(trans, "runtime usage count: %d\n",
+		      atomic_read(&trans_pcie->pci_dev->dev.power.usage_count));
+#endif /* CONFIG_PM */
 }
 
 static const char *get_csr_string(int cmd)
@@ -2794,7 +2788,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	trans_pcie->trans = trans;
 	spin_lock_init(&trans_pcie->irq_lock);
 	spin_lock_init(&trans_pcie->reg_lock);
-	spin_lock_init(&trans_pcie->ref_lock);
 	mutex_init(&trans_pcie->mutex);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 	trans_pcie->tso_hdr_page = alloc_percpu(struct iwl_tso_hdr_page);
-- 
2.5.0

