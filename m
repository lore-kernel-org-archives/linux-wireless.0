Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22835 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965572AbbD1Mn1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 08:43:27 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6/8] iwlwifi: mvm: don't power off the device between INIT and OPER firmwares
Date: Tue, 28 Apr 2015 15:43:10 +0300
Message-Id: <1430224992-20327-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150428_144333_035587_FB515339)
In-Reply-To: <1430224907.4748.3.camel@intel.com>
References: <1430224907.4748.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Our device needs two different firmwares: the INIT firmware
and the operational (OPER) firmware. The first one is run
when the driver loads and it returns calibrations results
as well as the NVM. The second one implements the WiFi
protocol.

If the wlan interface is not brought up, the device is put
to low power state: no firmware will be running. When the
interface is brought up, we would run the OPER firmware
only and reuse the results of the run of the INIT firmware
when the driver was loaded. This is changing with this
patch.
We now run the INIT firmware every time mac80211 calls
start(). The penalty for that is minimal since the INIT
firwmare run fast. I now also avoid to power down the device
between the INIT and OPER firmware on certains buses.

The motivation for this change is that there are components
on the device (MFUART) that are triggered by the INIT
firmware and need the device to be powered up in order to
keep running. Powering the device down between the INIT and
OPER firmware would stop these components and prevent them
from running again since they are triggered by the INIT
firmware only.
The new flow allows this and also allows to trigger these
components again when the interface is brought up after
it has been brought down.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h  | 41 ++++++++++++++++++----------
 drivers/net/wireless/iwlwifi/mvm/fw.c     | 45 +++++++++++++++----------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h    |  1 -
 drivers/net/wireless/iwlwifi/pcie/trans.c |  6 ++---
 4 files changed, 51 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 6dfed12..56254a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -421,8 +421,9 @@ struct iwl_trans_txq_scd_cfg {
  *
  * All the handlers MUST be implemented
  *
- * @start_hw: starts the HW- from that point on, the HW can send interrupts
- *	May sleep
+ * @start_hw: starts the HW. If low_power is true, the NIC needs to be taken
+ *	out of a low power state. From that point on, the HW can send
+ *	interrupts. May sleep.
  * @op_mode_leave: Turn off the HW RF kill indication if on
  *	May sleep
  * @start_fw: allocates and inits all the resources for the transport
@@ -432,10 +433,11 @@ struct iwl_trans_txq_scd_cfg {
  *	the SCD base address in SRAM, then provide it here, or 0 otherwise.
  *	May sleep
  * @stop_device: stops the whole device (embedded CPU put to reset) and stops
- *	the HW. From that point on, the HW will be in low power but will still
- *	issue interrupt if the HW RF kill is triggered. This callback must do
- *	the right thing and not crash even if start_hw() was called but not
- *	start_fw(). May sleep
+ *	the HW. If low_power is true, the NIC will be put in low power state.
+ *	From that point on, the HW will be stopped but will still issue an
+ *	interrupt if the HW RF kill switch is triggered.
+ *	This callback must do the right thing and not crash even if %start_hw()
+ *	was called but not &start_fw(). May sleep.
  * @d3_suspend: put the device into the correct mode for WoWLAN during
  *	suspend. This is optional, if not implemented WoWLAN will not be
  *	supported. This callback may sleep.
@@ -491,14 +493,14 @@ struct iwl_trans_txq_scd_cfg {
  */
 struct iwl_trans_ops {
 
-	int (*start_hw)(struct iwl_trans *iwl_trans);
+	int (*start_hw)(struct iwl_trans *iwl_trans, bool low_power);
 	void (*op_mode_leave)(struct iwl_trans *iwl_trans);
 	int (*start_fw)(struct iwl_trans *trans, const struct fw_img *fw,
 			bool run_in_rfkill);
 	int (*update_sf)(struct iwl_trans *trans,
 			 struct iwl_sf_region *st_fwrd_space);
 	void (*fw_alive)(struct iwl_trans *trans, u32 scd_addr);
-	void (*stop_device)(struct iwl_trans *trans);
+	void (*stop_device)(struct iwl_trans *trans, bool low_power);
 
 	void (*d3_suspend)(struct iwl_trans *trans, bool test);
 	int (*d3_resume)(struct iwl_trans *trans, enum iwl_d3_status *status,
@@ -652,11 +654,16 @@ static inline void iwl_trans_configure(struct iwl_trans *trans,
 	trans->ops->configure(trans, trans_cfg);
 }
 
-static inline int iwl_trans_start_hw(struct iwl_trans *trans)
+static inline int _iwl_trans_start_hw(struct iwl_trans *trans, bool low_power)
 {
 	might_sleep();
 
-	return trans->ops->start_hw(trans);
+	return trans->ops->start_hw(trans, low_power);
+}
+
+static inline int iwl_trans_start_hw(struct iwl_trans *trans)
+{
+	return trans->ops->start_hw(trans, true);
 }
 
 static inline void iwl_trans_op_mode_leave(struct iwl_trans *trans)
@@ -703,15 +710,21 @@ static inline int iwl_trans_update_sf(struct iwl_trans *trans,
 	return 0;
 }
 
-static inline void iwl_trans_stop_device(struct iwl_trans *trans)
+static inline void _iwl_trans_stop_device(struct iwl_trans *trans,
+					  bool low_power)
 {
 	might_sleep();
 
-	trans->ops->stop_device(trans);
+	trans->ops->stop_device(trans, low_power);
 
 	trans->state = IWL_TRANS_NO_FW;
 }
 
+static inline void iwl_trans_stop_device(struct iwl_trans *trans)
+{
+	_iwl_trans_stop_device(trans, true);
+}
+
 static inline void iwl_trans_d3_suspend(struct iwl_trans *trans, bool test)
 {
 	might_sleep();
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 9c28fe7..df86963 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -322,7 +322,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (WARN_ON_ONCE(mvm->init_ucode_complete || mvm->calibrating))
+	if (WARN_ON_ONCE(mvm->calibrating))
 		return 0;
 
 	iwl_init_notification_wait(&mvm->notif_wait,
@@ -396,8 +396,6 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	 */
 	ret = iwl_wait_notification(&mvm->notif_wait, &calib_wait,
 			MVM_UCODE_CALIB_TIMEOUT);
-	if (!ret)
-		mvm->init_ucode_complete = true;
 
 	if (ret && iwl_mvm_is_radio_killed(mvm)) {
 		IWL_DEBUG_RF_KILL(mvm, "RFKILL while calibrating.\n");
@@ -649,25 +647,24 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	 * module loading, load init ucode now
 	 * (for example, if we were in RFKILL)
 	 */
-	if (!mvm->init_ucode_complete) {
-		ret = iwl_run_init_mvm_ucode(mvm, false);
-		if (ret && !iwlmvm_mod_params.init_dbg) {
-			IWL_ERR(mvm, "Failed to run INIT ucode: %d\n", ret);
-			/* this can't happen */
-			if (WARN_ON(ret > 0))
-				ret = -ERFKILL;
-			goto error;
-		}
-		if (!iwlmvm_mod_params.init_dbg) {
-			/*
-			 * should stop and start HW since that INIT
-			 * image just loaded
-			 */
-			iwl_trans_stop_device(mvm->trans);
-			ret = iwl_trans_start_hw(mvm->trans);
-			if (ret)
-				return ret;
-		}
+	ret = iwl_run_init_mvm_ucode(mvm, false);
+	if (ret && !iwlmvm_mod_params.init_dbg) {
+		IWL_ERR(mvm, "Failed to run INIT ucode: %d\n", ret);
+		/* this can't happen */
+		if (WARN_ON(ret > 0))
+			ret = -ERFKILL;
+		goto error;
+	}
+	if (!iwlmvm_mod_params.init_dbg) {
+		/*
+		 * Stop and start the transport without entering low power
+		 * mode. This will save the state of other components on the
+		 * device that are triggered by the INIT firwmare (MFUART).
+		 */
+		_iwl_trans_stop_device(mvm->trans, false);
+		_iwl_trans_start_hw(mvm->trans, false);
+		if (ret)
+			return ret;
 	}
 
 	if (iwlmvm_mod_params.init_dbg)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d5522a1..cf70f68 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -603,7 +603,6 @@ struct iwl_mvm {
 
 	enum iwl_ucode_type cur_ucode;
 	bool ucode_loaded;
-	bool init_ucode_complete;
 	bool calibrating;
 	u32 error_event_table;
 	u32 log_event_table;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 6debb0c..47bbf57 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1021,7 +1021,7 @@ static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans, u32 scd_addr)
 	iwl_pcie_tx_start(trans, scd_addr);
 }
 
-static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
+static void iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	bool hw_rfkill, was_hw_rfkill;
@@ -1116,7 +1116,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state)
 {
 	if (iwl_op_mode_hw_rf_kill(trans->op_mode, state))
-		iwl_trans_pcie_stop_device(trans);
+		iwl_trans_pcie_stop_device(trans, true);
 }
 
 static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
@@ -1201,7 +1201,7 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 	return 0;
 }
 
-static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
+static int iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 {
 	bool hw_rfkill;
 	int err;
-- 
2.1.0

