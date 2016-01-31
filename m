Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:17611 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275AbcAaLGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:31 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/31] iwlwifi: mvm: Do not switch to D3 image on suspend
Date: Sun, 31 Jan 2016 13:06:01 +0200
Message-Id: <1454238386-27032-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_120759_226242_BFBDC615)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Currently when the driver is configured with wowlan parameters, and enters
D3 mode, the driver switches the FW image to D3, and when it exists
suspend, it reloads the D0 image.

If the firmware supports the consolidation of the D0 & D3 images there is
no need to load the D3 image on suspend, and no need to reload the D0
image on resume.

Do not switch images on suspend / resume, for firmwares that support
consolidated images.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c |  4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h  |  2 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h    | 13 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       | 70 ++++++++++++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     |  4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c     |  4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   | 11 ++--
 7 files changed, 70 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 29ea1c6..4db4cb7 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -396,7 +396,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_SET,
 		    CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
 
-	iwl_trans_d3_suspend(priv->trans, false);
+	iwl_trans_d3_suspend(priv->trans, false, true);
 
 	goto out;
 
@@ -469,7 +469,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	/* we'll clear ctx->vif during iwlagn_prepare_restart() */
 	vif = ctx->vif;
 
-	ret = iwl_trans_d3_resume(priv->trans, &d3_status, false);
+	ret = iwl_trans_d3_resume(priv->trans, &d3_status, false, true);
 	if (ret)
 		goto out_unlock;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 84f8aeb..2273908 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -297,6 +297,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_DQA_SUPPORT: supports dynamic queue allocation (DQA),
  *	which also implies support for the scheduler configuration command
  * @IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH: supports TDLS channel switching
+ * @IWL_UCODE_TLV_CAPA_CNSLDTD_D3_D0_IMG: Consolidated D3-D0 image
  * @IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT: supports Hot Spot Command
  * @IWL_UCODE_TLV_CAPA_DC2DC_SUPPORT: supports DC2DC Command
  * @IWL_UCODE_TLV_CAPA_CSUM_SUPPORT: supports TCP Checksum Offload
@@ -330,6 +331,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT		= (__force iwl_ucode_tlv_capa_t)11,
 	IWL_UCODE_TLV_CAPA_DQA_SUPPORT			= (__force iwl_ucode_tlv_capa_t)12,
 	IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH		= (__force iwl_ucode_tlv_capa_t)13,
+	IWL_UCODE_TLV_CAPA_CNSLDTD_D3_D0_IMG		= (__force iwl_ucode_tlv_capa_t)17,
 	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)18,
 	IWL_UCODE_TLV_CAPA_DC2DC_CONFIG_SUPPORT		= (__force iwl_ucode_tlv_capa_t)19,
 	IWL_UCODE_TLV_CAPA_CSUM_SUPPORT			= (__force iwl_ucode_tlv_capa_t)21,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index fe170a3..e6a5e99 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -618,9 +618,9 @@ struct iwl_trans_ops {
 	void (*fw_alive)(struct iwl_trans *trans, u32 scd_addr);
 	void (*stop_device)(struct iwl_trans *trans, bool low_power);
 
-	void (*d3_suspend)(struct iwl_trans *trans, bool test);
+	void (*d3_suspend)(struct iwl_trans *trans, bool test, bool reset);
 	int (*d3_resume)(struct iwl_trans *trans, enum iwl_d3_status *status,
-			 bool test);
+			 bool test, bool reset);
 
 	int (*send_cmd)(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 
@@ -925,22 +925,23 @@ static inline void iwl_trans_stop_device(struct iwl_trans *trans)
 	_iwl_trans_stop_device(trans, true);
 }
 
-static inline void iwl_trans_d3_suspend(struct iwl_trans *trans, bool test)
+static inline void iwl_trans_d3_suspend(struct iwl_trans *trans, bool test,
+					bool reset)
 {
 	might_sleep();
 	if (trans->ops->d3_suspend)
-		trans->ops->d3_suspend(trans, test);
+		trans->ops->d3_suspend(trans, test, reset);
 }
 
 static inline int iwl_trans_d3_resume(struct iwl_trans *trans,
 				      enum iwl_d3_status *status,
-				      bool test)
+				      bool test, bool reset)
 {
 	might_sleep();
 	if (!trans->ops->d3_resume)
 		return 0;
 
-	return trans->ops->d3_resume(trans, status, test);
+	return trans->ops->d3_resume(trans, status, test, reset);
 }
 
 static inline void iwl_trans_ref(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index d3e21d9..78572ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016   Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016   Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1023,14 +1025,18 @@ iwl_mvm_wowlan_config(struct iwl_mvm *mvm,
 		      struct ieee80211_sta *ap_sta)
 {
 	int ret;
+	bool unified_image = fw_has_capa(&mvm->fw->ucode_capa,
+					 IWL_UCODE_TLV_CAPA_CNSLDTD_D3_D0_IMG);
 
-	ret = iwl_mvm_switch_to_d3(mvm);
-	if (ret)
-		return ret;
+	if (!unified_image) {
+		ret = iwl_mvm_switch_to_d3(mvm);
+		if (ret)
+			return ret;
 
-	ret = iwl_mvm_d3_reprogram(mvm, vif, ap_sta);
-	if (ret)
-		return ret;
+		ret = iwl_mvm_d3_reprogram(mvm, vif, ap_sta);
+		if (ret)
+			return ret;
+	}
 
 	if (!iwlwifi_mod_params.sw_crypto) {
 		/*
@@ -1072,10 +1078,14 @@ iwl_mvm_netdetect_config(struct iwl_mvm *mvm,
 {
 	struct iwl_wowlan_config_cmd wowlan_config_cmd = {};
 	int ret;
+	bool unified_image = fw_has_capa(&mvm->fw->ucode_capa,
+					 IWL_UCODE_TLV_CAPA_CNSLDTD_D3_D0_IMG);
 
-	ret = iwl_mvm_switch_to_d3(mvm);
-	if (ret)
-		return ret;
+	if (!unified_image) {
+		ret = iwl_mvm_switch_to_d3(mvm);
+		if (ret)
+			return ret;
+	}
 
 	/* rfkill release can be either for wowlan or netdetect */
 	if (wowlan->rfkill_release)
@@ -1151,6 +1161,8 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	};
 	int ret;
 	int len __maybe_unused;
+	bool unified_image = fw_has_capa(&mvm->fw->ucode_capa,
+					 IWL_UCODE_TLV_CAPA_CNSLDTD_D3_D0_IMG);
 
 	if (!wowlan) {
 		/*
@@ -1236,7 +1248,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 
 	clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
 
-	iwl_trans_d3_suspend(mvm->trans, test);
+	iwl_trans_d3_suspend(mvm->trans, test, !unified_image);
  out:
 	if (ret < 0) {
 		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
@@ -1299,7 +1311,7 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		__set_bit(D0I3_DEFER_WAKEUP, &mvm->d0i3_suspend_flags);
 		mutex_unlock(&mvm->d0i3_suspend_mutex);
 
-		iwl_trans_d3_suspend(trans, false);
+		iwl_trans_d3_suspend(trans, false, false);
 
 		return 0;
 	}
@@ -2041,9 +2053,14 @@ static void iwl_mvm_d3_disconnect_iter(void *data, u8 *mac,
 static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 {
 	struct ieee80211_vif *vif = NULL;
-	int ret;
+	int ret = 1;
 	enum iwl_d3_status d3_status;
 	bool keep = false;
+	bool unified_image = fw_has_capa(&mvm->fw->ucode_capa,
+					 IWL_UCODE_TLV_CAPA_CNSLDTD_D3_D0_IMG);
+
+	u32 flags = CMD_ASYNC | CMD_HIGH_PRIO | CMD_SEND_IN_IDLE |
+				    CMD_WAKE_UP_TRANS;
 
 	mutex_lock(&mvm->mutex);
 
@@ -2052,7 +2069,7 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	if (IS_ERR_OR_NULL(vif))
 		goto err;
 
-	ret = iwl_trans_d3_resume(mvm->trans, &d3_status, test);
+	ret = iwl_trans_d3_resume(mvm->trans, &d3_status, test, !unified_image);
 	if (ret)
 		goto err;
 
@@ -2095,17 +2112,28 @@ out_iterate:
 			iwl_mvm_d3_disconnect_iter, keep ? vif : NULL);
 
 out:
-	/* return 1 to reconfigure the device */
+	if (unified_image && !ret) {
+		ret = iwl_mvm_send_cmd_pdu(mvm, D0I3_END_CMD, flags, 0, NULL);
+		if (!ret) /* D3 ended successfully - no need to reset device */
+			return 0;
+	}
+
+	/*
+	 * Reconfigure the device in one of the following cases:
+	 * 1. We are not using a unified image
+	 * 2. We are using a unified image but had an error while exiting D3
+	 */
 	set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
 	set_bit(IWL_MVM_STATUS_D3_RECONFIG, &mvm->status);
-
-	/* We always return 1, which causes mac80211 to do a reconfig
-	 * with IEEE80211_RECONFIG_TYPE_RESTART.  This type of
-	 * reconfig calls iwl_mvm_restart_complete(), where we unref
-	 * the IWL_MVM_REF_UCODE_DOWN, so we need to take the
-	 * reference here.
+	/*
+	 * When switching images we return 1, which causes mac80211
+	 * to do a reconfig with IEEE80211_RECONFIG_TYPE_RESTART.
+	 * This type of reconfig calls iwl_mvm_restart_complete(),
+	 * where we unref the IWL_MVM_REF_UCODE_DOWN, so we need
+	 * to take the reference here.
 	 */
 	iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
+
 	return 1;
 }
 
@@ -2122,7 +2150,7 @@ static int iwl_mvm_resume_d0i3(struct iwl_mvm *mvm)
 	enum iwl_d3_status d3_status;
 	struct iwl_trans *trans = mvm->trans;
 
-	iwl_trans_d3_resume(trans, &d3_status, false);
+	iwl_trans_d3_resume(trans, &d3_status, false, false);
 
 	/*
 	 * make sure to clear D0I3_DEFER_WAKEUP before
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 9a15642..0476e76 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1109,7 +1109,7 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	cmd->general_flags = cpu_to_le32(iwl_mvm_scan_umac_flags(mvm, params,
 								 vif));
 
-	if (type == IWL_MVM_SCAN_SCHED)
+	if (type == IWL_MVM_SCAN_SCHED || type == IWL_MVM_SCAN_NETDETECT)
 		cmd->flags = cpu_to_le32(IWL_UMAC_SCAN_FLAG_PREEMPTIVE);
 
 	if (iwl_mvm_scan_use_ebs(mvm, vif))
@@ -1351,7 +1351,7 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
 		hcmd.id = iwl_cmd_id(SCAN_REQ_UMAC, IWL_ALWAYS_LONG_GROUP, 0);
-		ret = iwl_mvm_scan_umac(mvm, vif, &params, IWL_MVM_SCAN_SCHED);
+		ret = iwl_mvm_scan_umac(mvm, vif, &params, type);
 	} else {
 		hcmd.id = SCAN_OFFLOAD_REQUEST_CMD;
 		ret = iwl_mvm_scan_lmac(mvm, vif, &params);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 16b579a..762e7c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -787,7 +787,7 @@ static int iwl_pci_runtime_suspend(struct device *device)
 
 	trans->system_pm_mode = IWL_PLAT_PM_MODE_D0I3;
 
-	iwl_trans_d3_suspend(trans, false);
+	iwl_trans_d3_suspend(trans, false, false);
 
 	return 0;
 }
@@ -800,7 +800,7 @@ static int iwl_pci_runtime_resume(struct device *device)
 
 	IWL_DEBUG_RPM(trans, "exiting runtime suspend (resume)\n");
 
-	iwl_trans_d3_resume(trans, &d3_status, false);
+	iwl_trans_d3_resume(trans, &d3_status, false, false);
 
 	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status))
 		return iwl_pci_fw_exit_d0i3(trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index cfdc7f6..abe0916 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1219,11 +1219,12 @@ void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state)
 		_iwl_trans_pcie_stop_device(trans, true);
 }
 
-static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
+static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test,
+				      bool reset)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	if (trans->system_pm_mode == IWL_PLAT_PM_MODE_D0I3) {
+	if (!reset) {
 		/* Enable persistence mode to avoid reset */
 		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_PERSIST_MODE);
@@ -1247,7 +1248,7 @@ static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
 	iwl_clear_bit(trans, CSR_GP_CNTRL,
 		      CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
-	if (trans->system_pm_mode == IWL_PLAT_PM_MODE_D3) {
+	if (reset) {
 		/*
 		 * reset TX queues -- some of their registers reset during S3
 		 * so if we don't reset everything here the D3 image would try
@@ -1261,7 +1262,7 @@ static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
 
 static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 				    enum iwl_d3_status *status,
-				    bool test)
+				    bool test,  bool reset)
 {
 	u32 val;
 	int ret;
@@ -1296,7 +1297,7 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 
 	iwl_pcie_set_pwr(trans, false);
 
-	if (trans->system_pm_mode == IWL_PLAT_PM_MODE_D0I3) {
+	if (!reset) {
 		iwl_clear_bit(trans, CSR_GP_CNTRL,
 			      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	} else {
-- 
2.5.0

