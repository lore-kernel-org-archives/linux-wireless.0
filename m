Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52816 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754250AbdDRWV1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:21:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:21 +0300
Message-Id: <20170418221729.28372-18-luca@coelho.fi> (sfid-20170419_002131_520069_2BC2C62B)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 17/25] iwlwifi: mvm: support init extended command
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When we load firmware in extended mode (as we do by default for
now) driver should send a command what kind of commands ucode
should stop and wait for before proceeding with phy calibrations.
Support this command. Currently we only do NVM access - so mark
this bit only.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 23 +++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 15 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c    |  1 +
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 5086dc00346c..8302cf03ac28 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -327,6 +327,7 @@ enum iwl_phy_ops_subcmd_ids {
 
 enum iwl_system_subcmd_ids {
 	SHARED_MEM_CFG_CMD = 0x0,
+	INIT_EXTENDED_CFG_CMD = 0x03,
 };
 
 enum iwl_data_path_subcmd_ids {
@@ -2236,4 +2237,26 @@ struct iwl_nvm_access_complete_cmd {
 	__le32 reserved;
 } __packed; /* NVM_ACCESS_COMPLETE_CMD_API_S_VER_1 */
 
+/**
+ * enum iwl_extended_cfg_flag - commands driver may send before
+ *	finishing init flow
+ * @IWL_INIT_DEBUG_CFG: driver is going to send debug config command
+ * @IWL_INIT_NVM: driver is going to send NVM_ACCESS commands
+ * @IWL_INIT_PHY: driver is going to send PHY_DB commands
+ */
+enum iwl_extended_cfg_flags {
+	IWL_INIT_DEBUG_CFG,
+	IWL_INIT_NVM,
+	IWL_INIT_PHY,
+};
+
+/**
+ * struct iwl_extended_cfg_cmd - mark what commands ucode should wait for
+ * before finishing init flows
+ * @init_flags: values from iwl_extended_cfg_flags
+ */
+struct iwl_init_extended_cfg_cmd {
+	__le32 init_flags;
+} __packed; /* INIT_EXTENDED_CFG_CMD_API_S_VER_1 */
+
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index bce3cf5fab67..900f1e25b9da 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -836,6 +836,9 @@ int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 {
 	struct iwl_notification_wait init_wait;
 	struct iwl_nvm_access_complete_cmd nvm_complete = {};
+	struct iwl_init_extended_cfg_cmd init_cfg = {
+		.init_flags = cpu_to_le32(BIT(IWL_INIT_NVM)),
+	};
 	static const u16 init_complete[] = {
 		INIT_COMPLETE_NOTIF,
 	};
@@ -857,6 +860,18 @@ int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 		goto error;
 	}
 
+	/* Send init config command to mark that we are sending NVM access
+	 * commands
+	 */
+	ret = iwl_mvm_send_cmd_pdu(mvm, WIDE_ID(SYSTEM_GROUP,
+						INIT_EXTENDED_CFG_CMD), 0,
+				   sizeof(init_cfg), &init_cfg);
+	if (ret) {
+		IWL_ERR(mvm, "Failed to run init config command: %d\n",
+			ret);
+		goto error;
+	}
+
 	/* Read the NVM only at driver load time, no need to do this twice */
 	if (read_nvm) {
 		/* Read nvm */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 488d3c948fe8..888053323c92 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -428,6 +428,7 @@ static const struct iwl_hcmd_names iwl_mvm_legacy_names[] = {
  */
 static const struct iwl_hcmd_names iwl_mvm_system_names[] = {
 	HCMD_NAME(SHARED_MEM_CFG_CMD),
+	HCMD_NAME(INIT_EXTENDED_CFG_CMD),
 };
 
 /* Please keep this array *SORTED* by hex value.
-- 
2.11.0
