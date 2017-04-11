Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50520 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752369AbdDKMhy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:37:54 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:18 +0300
Message-Id: <20170411123742.12214-2-luca@coelho.fi> (sfid-20170411_143759_893074_004BCD42)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 01/25] iwlwifi: mvm: support new binding API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For a000 devices the binding API needs to include relevant
lmac ID - support the new API.
The new API should be used regardless if the device had CDB or
not. If there is no actual CDB support the binding is bound
to first lmac regardless of the band.
There are some functionality changes in binding restrictions
and quota allocations that will be handled in future patches.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c | 17 ++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c      | 16 ++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h  | 14 +++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     | 14 ++++++++------
 5 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index d01701ee4777..9f639fdf0f6e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -344,6 +344,8 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= (__force iwl_ucode_tlv_capa_t)30,
 	IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT		= (__force iwl_ucode_tlv_capa_t)31,
 	IWL_UCODE_TLV_CAPA_STA_PM_NOTIF			= (__force iwl_ucode_tlv_capa_t)38,
+	IWL_UCODE_TLV_CAPA_BINDING_CDB_SUPPORT		= (__force iwl_ucode_tlv_capa_t)39,
+	IWL_UCODE_TLV_CAPA_CDB_SUPPORT			= (__force iwl_ucode_tlv_capa_t)40,
 	IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE		= (__force iwl_ucode_tlv_capa_t)64,
 	IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS		= (__force iwl_ucode_tlv_capa_t)65,
 	IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)67,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
index 7cb68f6ed1b0..2e0ed080457f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/binding.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2016 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -82,6 +84,19 @@ static int iwl_mvm_binding_cmd(struct iwl_mvm *mvm, u32 action,
 	struct iwl_mvm_phy_ctxt *phyctxt = data->phyctxt;
 	int i, ret;
 	u32 status;
+	int size;
+
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_BINDING_CDB_SUPPORT)) {
+		size = sizeof(cmd);
+		if (phyctxt->channel->band == NL80211_BAND_2GHZ ||
+		    !iwl_mvm_is_cdb_supported(mvm))
+			cmd.lmac_id = cpu_to_le32(IWL_LMAC_24G_INDEX);
+		else
+			cmd.lmac_id = cpu_to_le32(IWL_LMAC_5G_INDEX);
+	} else {
+		size = IWL_BINDING_CMD_SIZE_V1;
+	}
 
 	memset(&cmd, 0, sizeof(cmd));
 
@@ -99,7 +114,7 @@ static int iwl_mvm_binding_cmd(struct iwl_mvm *mvm, u32 action,
 
 	status = 0;
 	ret = iwl_mvm_send_cmd_pdu_status(mvm, BINDING_CONTEXT_CMD,
-					  sizeof(cmd), &cmd, &status);
+					  size, &cmd, &status);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to send binding (action:%d): %d\n",
 			action, ret);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index c7eb1983c4f9..b7465857b4b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -665,6 +665,19 @@ static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_binding_cmd binding_cmd = {};
 	struct iwl_time_quota_cmd quota_cmd = {};
 	u32 status;
+	int size;
+
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_BINDING_CDB_SUPPORT)) {
+		size = sizeof(binding_cmd);
+		if (mvmvif->phy_ctxt->channel->band == NL80211_BAND_2GHZ ||
+		    !iwl_mvm_is_cdb_supported(mvm))
+			binding_cmd.lmac_id = cpu_to_le32(IWL_LMAC_24G_INDEX);
+		else
+			binding_cmd.lmac_id = cpu_to_le32(IWL_LMAC_5G_INDEX);
+	} else {
+		size = IWL_BINDING_CMD_SIZE_V1;
+	}
 
 	/* add back the PHY */
 	if (WARN_ON(!mvmvif->phy_ctxt))
@@ -711,8 +724,7 @@ static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	status = 0;
 	ret = iwl_mvm_send_cmd_pdu_status(mvm, BINDING_CONTEXT_CMD,
-					  sizeof(binding_cmd), &binding_cmd,
-					  &status);
+					  size, &binding_cmd, &status);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to add binding: %d\n", ret);
 		return ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index cf2b836f3888..248373a0990a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -673,10 +673,8 @@ struct iwl_error_resp {
 
 
 /* Common PHY, MAC and Bindings definitions */
-
 #define MAX_MACS_IN_BINDING	(3)
 #define MAX_BINDINGS		(4)
-#define AUX_BINDING_INDEX	(3)
 
 /* Used to extract ID and color from the context dword */
 #define FW_CTXT_ID_POS	  (0)
@@ -960,6 +958,7 @@ struct iwl_time_event_notif {
  * @action: action to perform, one of FW_CTXT_ACTION_*
  * @macs: array of MAC id and colors which belong to the binding
  * @phy: PHY id and color which belongs to the binding
+ * @lmac_id: the lmac id the binding belongs to
  */
 struct iwl_binding_cmd {
 	/* COMMON_INDEX_HDR_API_S_VER_1 */
@@ -968,7 +967,13 @@ struct iwl_binding_cmd {
 	/* BINDING_DATA_API_S_VER_1 */
 	__le32 macs[MAX_MACS_IN_BINDING];
 	__le32 phy;
-} __packed; /* BINDING_CMD_API_S_VER_1 */
+	/* BINDING_CMD_API_S_VER_1 */
+	__le32 lmac_id;
+} __packed; /* BINDING_CMD_API_S_VER_2 */
+
+#define IWL_BINDING_CMD_SIZE_V1	offsetof(struct iwl_binding_cmd, lmac_id)
+#define IWL_LMAC_24G_INDEX		0
+#define IWL_LMAC_5G_INDEX		1
 
 /* The maximal number of fragments in the FW's schedule session */
 #define IWL_MVM_MAX_QUOTA 128
@@ -990,6 +995,9 @@ struct iwl_time_quota_data {
  * struct iwl_time_quota_cmd - configuration of time quota between bindings
  * ( TIME_QUOTA_CMD = 0x2c )
  * @quotas: allocations per binding
+ * Note: on non-CDB the fourth one is the auxilary mac and is
+ *	essentially zero.
+ *	On CDB the fourth one is a regular binding.
  */
 struct iwl_time_quota_cmd {
 	struct iwl_time_quota_data quotas[MAX_BINDINGS];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 73a216524af2..88bc459b1f9a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1222,13 +1222,15 @@ static inline bool iwl_mvm_is_cdb_supported(struct iwl_mvm *mvm)
 {
 	/*
 	 * TODO:
-	 * The issue of how to determine CDB support is still not well defined.
-	 * It may be that it will be for all next HW devices and it may be per
-	 * FW compilation and it may also differ between different devices.
-	 * For now take a ride on the new TX API and get back to it when
-	 * it is well defined.
+	 * The issue of how to determine CDB APIs and usage is still not fully
+	 * defined.
+	 * There is a compilation for CDB and non-CDB FW, but there may
+	 * be also runtime check.
+	 * For now there is a TLV for checking compilation mode, but a
+	 * runtime check will also have to be here - once defined.
 	 */
-	return iwl_mvm_has_new_tx_api(mvm);
+	return fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_CDB_SUPPORT);
 }
 
 static inline bool iwl_mvm_is_tt_in_fw(struct iwl_mvm *mvm)
-- 
2.11.0
