Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:35836 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3LQUpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:09 -0500
Received: by mail-ee0-f53.google.com with SMTP id b57so3139686eek.40
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:07 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/36] iwlwifi: trans: divide stop_hw into stop_device/op_mode_leave
Date: Tue, 17 Dec 2013 22:44:19 +0200
Message-Id: <1387313079-28123-16-git-send-email-egrumbach@gmail.com> (sfid-20131217_214517_822961_1A149921)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The stop_hw trans callback is not well defined. It is missing in many
cleanup flows and the division of labor between stop_device/stop_hw
is cumbersome. Remove stop_hw and use stop_device to perform both.
Implement this for all current transports.

PCIE needs some extra configuration the op-mode is leaving to configure
RF kill. Expose this explicitly as a new op_mode_leave trans callback.
Take the call to stop_device outside iwl_run_mvm_init_ucode, this
makes more sense and WARN when we want to run the INIT firmware while
it has run already.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |    6 ----
 drivers/net/wireless/iwlwifi/dvm/main.c     |    4 +--
 drivers/net/wireless/iwlwifi/iwl-trans.h    |   25 +++++++-------
 drivers/net/wireless/iwlwifi/mvm/fw.c       |   24 +++++++------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    2 --
 drivers/net/wireless/iwlwifi/mvm/ops.c      |    9 ++---
 drivers/net/wireless/iwlwifi/mvm/tt.c       |    2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c   |   50 ++++++++++++---------------
 8 files changed, 55 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 217f1ca..9f4239d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -322,12 +322,6 @@ static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 
 	flush_workqueue(priv->workqueue);
 
-	/* User space software may expect getting rfkill changes
-	 * even if interface is down, trans->down will leave the RF
-	 * kill interrupt enabled
-	 */
-	iwl_trans_stop_hw(priv->trans, false);
-
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 7aad766..fd9f6cf 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1313,7 +1313,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	}
 
 	/* Reset chip to save power until we load uCode during "up". */
-	iwl_trans_stop_hw(priv->trans, false);
+	iwl_trans_stop_device(priv->trans);
 
 	priv->nvm_data = iwl_parse_eeprom_data(priv->trans->dev, priv->cfg,
 						  priv->eeprom_blob,
@@ -1458,7 +1458,7 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 
 	dev_kfree_skb(priv->beacon_skb);
 
-	iwl_trans_stop_hw(priv->trans, true);
+	iwl_trans_op_mode_leave(priv->trans);
 	ieee80211_free_hw(priv->hw);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 143292b..43ea124 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -100,8 +100,7 @@
  *	   start_fw
  *
  *	5) Then when finished (or reset):
- *	   stop_fw (a.k.a. stop device for the moment)
- *	   stop_hw
+ *	   stop_device
  *
  *	6) Eventually, the free function will be called.
  */
@@ -361,9 +360,7 @@ struct iwl_trans;
  *
  * @start_hw: starts the HW- from that point on, the HW can send interrupts
  *	May sleep
- * @stop_hw: stops the HW- from that point on, the HW will be in low power but
- *	will still issue interrupt if the HW RF kill is triggered unless
- *	op_mode_leaving is true.
+ * @op_mode_leave: Turn off the HW RF kill indication if on
  *	May sleep
  * @start_fw: allocates and inits all the resources for the transport
  *	layer. Also kick a fw image.
@@ -371,8 +368,11 @@ struct iwl_trans;
  * @fw_alive: called when the fw sends alive notification. If the fw provides
  *	the SCD base address in SRAM, then provide it here, or 0 otherwise.
  *	May sleep
- * @stop_device:stops the whole device (embedded CPU put to reset)
- *	May sleep
+ * @stop_device: stops the whole device (embedded CPU put to reset) and stops
+ *	the HW. From that point on, the HW will be in low power but will still
+ *	issue interrupt if the HW RF kill is triggered. This callback must do
+ *	the right thing and not crash even if start_hw() was called but not
+ *	start_fw(). May sleep
  * @d3_suspend: put the device into the correct mode for WoWLAN during
  *	suspend. This is optional, if not implemented WoWLAN will not be
  *	supported. This callback may sleep.
@@ -418,7 +418,7 @@ struct iwl_trans;
 struct iwl_trans_ops {
 
 	int (*start_hw)(struct iwl_trans *iwl_trans);
-	void (*stop_hw)(struct iwl_trans *iwl_trans, bool op_mode_leaving);
+	void (*op_mode_leave)(struct iwl_trans *iwl_trans);
 	int (*start_fw)(struct iwl_trans *trans, const struct fw_img *fw,
 			bool run_in_rfkill);
 	void (*fw_alive)(struct iwl_trans *trans, u32 scd_addr);
@@ -540,15 +540,14 @@ static inline int iwl_trans_start_hw(struct iwl_trans *trans)
 	return trans->ops->start_hw(trans);
 }
 
-static inline void iwl_trans_stop_hw(struct iwl_trans *trans,
-				     bool op_mode_leaving)
+static inline void iwl_trans_op_mode_leave(struct iwl_trans *trans)
 {
 	might_sleep();
 
-	trans->ops->stop_hw(trans, op_mode_leaving);
+	if (trans->ops->op_mode_leave)
+		trans->ops->op_mode_leave(trans);
 
-	if (op_mode_leaving)
-		trans->op_mode = NULL;
+	trans->op_mode = NULL;
 
 	trans->state = IWL_TRANS_NO_FW;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index b2bfa73..27ba104 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -241,7 +241,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (mvm->init_ucode_complete)
+	if (WARN_ON_ONCE(mvm->init_ucode_complete))
 		return 0;
 
 	iwl_init_notification_wait(&mvm->notif_wait,
@@ -287,7 +287,8 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 		IWL_DEBUG_RF_KILL(mvm,
 				  "jump over all phy activities due to RF kill\n");
 		iwl_remove_notification(&mvm->notif_wait, &calib_wait);
-		return 1;
+		ret = 1;
+		goto out;
 	}
 
 	/* Send TX valid antennas before triggering calibrations */
@@ -319,9 +320,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 error:
 	iwl_remove_notification(&mvm->notif_wait, &calib_wait);
 out:
-	if (!iwlmvm_mod_params.init_dbg) {
-		iwl_trans_stop_device(mvm->trans);
-	} else if (!mvm->nvm_data) {
+	if (iwlmvm_mod_params.init_dbg && !mvm->nvm_data) {
 		/* we want to debug INIT and we have no NVM - fake */
 		mvm->nvm_data = kzalloc(sizeof(struct iwl_nvm_data) +
 					sizeof(struct ieee80211_channel) +
@@ -370,11 +369,16 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 				ret = -ERFKILL;
 			goto error;
 		}
-		/* should stop & start HW since that INIT image just loaded */
-		iwl_trans_stop_hw(mvm->trans, false);
-		ret = iwl_trans_start_hw(mvm->trans);
-		if (ret)
-			return ret;
+		if (!iwlmvm_mod_params.init_dbg) {
+			/*
+			 * should stop and start HW since that INIT
+			 * image just loaded
+			 */
+			iwl_trans_stop_device(mvm->trans);
+			ret = iwl_trans_start_hw(mvm->trans);
+			if (ret)
+				return ret;
+		}
 	}
 
 	if (iwlmvm_mod_params.init_dbg)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index fbd3114..272aabd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -405,7 +405,6 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 {
 	iwl_trans_stop_device(mvm->trans);
-	iwl_trans_stop_hw(mvm->trans, false);
 
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
 
@@ -477,7 +476,6 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&mvm->roc_done_wk);
 
 	iwl_trans_stop_device(mvm->trans);
-	iwl_trans_stop_hw(mvm->trans, false);
 
 	iwl_mvm_async_handlers_purge(mvm);
 	/* async_handlers_list is empty and will stay empty: HW is stopped */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 668525f..a6f4be8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -436,16 +436,13 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 		mutex_lock(&mvm->mutex);
 		err = iwl_run_init_mvm_ucode(mvm, true);
+		iwl_trans_stop_device(trans);
 		mutex_unlock(&mvm->mutex);
 		/* returns 0 if successful, 1 if success but in rfkill */
 		if (err < 0 && !iwlmvm_mod_params.init_dbg) {
 			IWL_ERR(mvm, "Failed to run INIT ucode: %d\n", err);
 			goto out_free;
 		}
-
-		/* Stop the hw after the ALIVE and NVM has been read */
-		if (!iwlmvm_mod_params.init_dbg)
-			iwl_trans_stop_hw(mvm->trans, false);
 	}
 
 	scan_size = sizeof(struct iwl_scan_cmd) +
@@ -478,7 +475,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	iwl_phy_db_free(mvm->phy_db);
 	kfree(mvm->scan_cmd);
 	if (!iwlwifi_mod_params.nvm_file)
-		iwl_trans_stop_hw(trans, true);
+		iwl_trans_op_mode_leave(trans);
 	ieee80211_free_hw(mvm->hw);
 	return NULL;
 }
@@ -502,7 +499,7 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	kfree(mvm->d3_resume_sram);
 #endif
 
-	iwl_trans_stop_hw(mvm->trans, true);
+	iwl_trans_op_mode_leave(mvm->trans);
 
 	iwl_phy_db_free(mvm->phy_db);
 	mvm->phy_db = NULL;
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 18be04d..a0ec7b3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -340,7 +340,7 @@ static void check_exit_ctkill(struct work_struct *work)
 
 	iwl_trans_start_hw(mvm->trans);
 	temp = check_nic_temperature(mvm);
-	iwl_trans_stop_hw(mvm->trans, false);
+	iwl_trans_stop_device(mvm->trans);
 
 	if (temp < MIN_TEMPERATURE || temp > MAX_TEMPERATURE) {
 		IWL_DEBUG_TEMP(mvm, "Failed to measure NIC temperature\n");
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index cde9c16..43eed4d 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -641,6 +641,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	unsigned long flags;
+	bool hw_rfkill;
 
 	/* tell the device to stop sending interrupts */
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
@@ -681,8 +682,6 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	iwl_disable_interrupts(trans);
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
-	iwl_enable_rfkill_int(trans);
-
 	/* stop and reset the on-board processor */
 	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
@@ -692,6 +691,25 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	clear_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status);
 	clear_bit(STATUS_TPOWER_PMI, &trans_pcie->status);
 	clear_bit(STATUS_RFKILL, &trans_pcie->status);
+
+	/*
+	 * Even if we stop the HW, we still want the RF kill
+	 * interrupt
+	 */
+	iwl_enable_rfkill_int(trans);
+
+	/*
+	 * Check again since the RF kill state may have changed while
+	 * all the interrupts were disabled, in this case we couldn't
+	 * receive the RF kill interrupt and update the state in the
+	 * op_mode.
+	 */
+	hw_rfkill = iwl_is_rfkill_set(trans);
+	if (hw_rfkill)
+		set_bit(STATUS_RFKILL, &trans_pcie->status);
+	else
+		clear_bit(STATUS_RFKILL, &trans_pcie->status);
+	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 }
 
 static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
@@ -806,13 +824,12 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 	return 0;
 }
 
-static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans,
-				   bool op_mode_leaving)
+static void iwl_trans_pcie_op_mode_leave(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	bool hw_rfkill;
 	unsigned long flags;
 
+	/* disable interrupts - don't enable HW RF kill interrupt */
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 	iwl_disable_interrupts(trans);
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
@@ -824,27 +841,6 @@ static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans,
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	iwl_pcie_disable_ict(trans);
-
-	if (!op_mode_leaving) {
-		/*
-		 * Even if we stop the HW, we still want the RF kill
-		 * interrupt
-		 */
-		iwl_enable_rfkill_int(trans);
-
-		/*
-		 * Check again since the RF kill state may have changed while
-		 * all the interrupts were disabled, in this case we couldn't
-		 * receive the RF kill interrupt and update the state in the
-		 * op_mode.
-		 */
-		hw_rfkill = iwl_is_rfkill_set(trans);
-		if (hw_rfkill)
-			set_bit(STATUS_RFKILL, &trans_pcie->status);
-		else
-			clear_bit(STATUS_RFKILL, &trans_pcie->status);
-		iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
-	}
 }
 
 static void iwl_trans_pcie_write8(struct iwl_trans *trans, u32 ofs, u8 val)
@@ -1457,7 +1453,7 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 
 static const struct iwl_trans_ops trans_ops_pcie = {
 	.start_hw = iwl_trans_pcie_start_hw,
-	.stop_hw = iwl_trans_pcie_stop_hw,
+	.op_mode_leave = iwl_trans_pcie_op_mode_leave,
 	.fw_alive = iwl_trans_pcie_fw_alive,
 	.start_fw = iwl_trans_pcie_start_fw,
 	.stop_device = iwl_trans_pcie_stop_device,
-- 
1.7.9.5

