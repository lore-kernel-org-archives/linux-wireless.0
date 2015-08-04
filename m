Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbbHDU65 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:58:57 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/37] iwlwifi: pcie: lock start_hw / start_fw / stop_device
Date: Tue,  4 Aug 2015 23:42:55 +0300
Message-Id: <1438721007-23283-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_225908_986605_CBADD248)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows to ensure that we don't have races between them.
A user reported that stop_device was called twice upon
rfkill interrupt after suspend. When the interrupts are
enabled, and right after when we directly check the rfkill
state.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c      |  4 ++
 drivers/net/wireless/iwlwifi/pcie/internal.h |  3 +
 drivers/net/wireless/iwlwifi/pcie/rx.c       |  2 +
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 82 ++++++++++++++++++++++++----
 4 files changed, 81 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 2ed1e4d..dbd2a03 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -613,6 +613,7 @@ static int iwl_pci_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct iwl_trans *trans = pci_get_drvdata(pdev);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	bool hw_rfkill;
 
 	/* Before you put code here, think about WoWLAN. You cannot check here
@@ -643,7 +644,10 @@ static int iwl_pci_resume(struct device *device)
 	}
 
 	hw_rfkill = iwl_is_rfkill_set(trans);
+
+	mutex_lock(&trans_pcie->mutex);
 	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
+	mutex_unlock(&trans_pcie->mutex);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 31f72a6..4f06407 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -301,6 +301,7 @@ iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
  * @scd_set_active: should the transport configure the SCD for HCMD queue
  * @rx_page_order: page order for receive buffer size
  * @reg_lock: protect hw register access
+ * @mutex: to protect stop_device / start_fw / start_hw
  * @cmd_in_flight: true when we have a host command in flight
  * @fw_mon_phys: physical address of the buffer for the firmware monitor
  * @fw_mon_page: points to the first page of the buffer for the firmware monitor
@@ -320,9 +321,11 @@ struct iwl_trans_pcie {
 	dma_addr_t ict_tbl_dma;
 	int ict_index;
 	bool use_ict;
+	bool is_down;
 	struct isr_statistics isr_stats;
 
 	spinlock_t irq_lock;
+	struct mutex mutex;
 	u32 inta_mask;
 	u32 scd_base_addr;
 	struct iwl_dma_ptr scd_bc_tbls;
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index a3fbaa0..93062f2 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1251,7 +1251,9 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 
 		isr_stats->rfkill++;
 
+		mutex_lock(&trans_pcie->mutex);
 		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
+		mutex_unlock(&trans_pcie->mutex);
 		if (hw_rfkill) {
 			set_bit(STATUS_RFKILL, &trans->status);
 			if (test_and_clear_bit(STATUS_SYNC_HCMD_ACTIVE,
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 43ae658..23f2824 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -982,13 +982,25 @@ static int iwl_pcie_load_given_ucode_8000(struct iwl_trans *trans,
 static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 				   const struct fw_img *fw, bool run_in_rfkill)
 {
-	int ret;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	bool hw_rfkill;
+	int ret;
+
+	mutex_lock(&trans_pcie->mutex);
+
+	/* Someone called stop_device, don't try to start_fw */
+	if (trans_pcie->is_down) {
+		IWL_WARN(trans,
+			 "Can't start_fw since the HW hasn't been started\n");
+		ret = EIO;
+		goto out;
+	}
 
 	/* This may fail if AMT took ownership of the device */
 	if (iwl_pcie_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	iwl_enable_rfkill_int(trans);
@@ -1000,15 +1012,17 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	else
 		clear_bit(STATUS_RFKILL, &trans->status);
 	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
-	if (hw_rfkill && !run_in_rfkill)
-		return -ERFKILL;
+	if (hw_rfkill && !run_in_rfkill) {
+		ret = -ERFKILL;
+		goto out;
+	}
 
 	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
 
 	ret = iwl_pcie_nic_init(trans);
 	if (ret) {
 		IWL_ERR(trans, "Unable to init nic\n");
-		return ret;
+		goto out;
 	}
 
 	/* make sure rfkill handshake bits are cleared */
@@ -1026,9 +1040,13 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 
 	/* Load the given image to the HW */
 	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
-		return iwl_pcie_load_given_ucode_8000(trans, fw);
+		ret = iwl_pcie_load_given_ucode_8000(trans, fw);
 	else
-		return iwl_pcie_load_given_ucode(trans, fw);
+		ret = iwl_pcie_load_given_ucode(trans, fw);
+
+out:
+	mutex_unlock(&trans_pcie->mutex);
+	return ret;
 }
 
 static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans, u32 scd_addr)
@@ -1037,11 +1055,18 @@ static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans, u32 scd_addr)
 	iwl_pcie_tx_start(trans, scd_addr);
 }
 
-static void iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
+static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	bool hw_rfkill, was_hw_rfkill;
 
+	lockdep_assert_held(&trans_pcie->mutex);
+
+	if (trans_pcie->is_down)
+		return;
+
+	trans_pcie->is_down = true;
+
 	was_hw_rfkill = iwl_is_rfkill_set(trans);
 
 	/* tell the device to stop sending interrupts */
@@ -1131,10 +1156,24 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 	iwl_pcie_prepare_card_hw(trans);
 }
 
+static void iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	mutex_lock(&trans_pcie->mutex);
+	_iwl_trans_pcie_stop_device(trans, low_power);
+	mutex_unlock(&trans_pcie->mutex);
+}
+
 void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state)
 {
+	struct iwl_trans_pcie __maybe_unused *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	lockdep_assert_held(&trans_pcie->mutex);
+
 	if (iwl_op_mode_hw_rf_kill(trans->op_mode, state))
-		iwl_trans_pcie_stop_device(trans, true);
+		_iwl_trans_pcie_stop_device(trans, true);
 }
 
 static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
@@ -1219,11 +1258,14 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 	return 0;
 }
 
-static int iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
+static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	bool hw_rfkill;
 	int err;
 
+	lockdep_assert_held(&trans_pcie->mutex);
+
 	err = iwl_pcie_prepare_card_hw(trans);
 	if (err) {
 		IWL_ERR(trans, "Error while preparing HW: %d\n", err);
@@ -1240,20 +1282,38 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 	/* From now on, the op_mode will be kept updated about RF kill state */
 	iwl_enable_rfkill_int(trans);
 
+	/* Set is_down to false here so that...*/
+	trans_pcie->is_down = false;
+
 	hw_rfkill = iwl_is_rfkill_set(trans);
 	if (hw_rfkill)
 		set_bit(STATUS_RFKILL, &trans->status);
 	else
 		clear_bit(STATUS_RFKILL, &trans->status);
+	/* ... rfkill can call stop_device and set it false if needed */
 	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
 
 	return 0;
 }
 
+static int iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int ret;
+
+	mutex_lock(&trans_pcie->mutex);
+	ret = _iwl_trans_pcie_start_hw(trans, low_power);
+	mutex_unlock(&trans_pcie->mutex);
+
+	return ret;
+}
+
 static void iwl_trans_pcie_op_mode_leave(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	mutex_lock(&trans_pcie->mutex);
+
 	/* disable interrupts - don't enable HW RF kill interrupt */
 	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
@@ -1266,6 +1326,7 @@ static void iwl_trans_pcie_op_mode_leave(struct iwl_trans *trans)
 	spin_unlock(&trans_pcie->irq_lock);
 
 	iwl_pcie_disable_ict(trans);
+	mutex_unlock(&trans_pcie->mutex);
 }
 
 static void iwl_trans_pcie_write8(struct iwl_trans *trans, u32 ofs, u8 val)
@@ -2472,6 +2533,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	spin_lock_init(&trans_pcie->irq_lock);
 	spin_lock_init(&trans_pcie->reg_lock);
 	spin_lock_init(&trans_pcie->ref_lock);
+	mutex_init(&trans_pcie->mutex);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 
 	err = pci_enable_device(pdev);
-- 
2.1.4

