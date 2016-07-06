Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33510 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753772AbcGFKpE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:45:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:07 +0300
Message-Id: <1467801651-1816-12-git-send-email-luca@coelho.fi> (sfid-20160706_124543_710455_E7588FC9)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 12/56] iwlwifi: mvm: support dqa-enable hcmd
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Support sending the DQA-enablement HCMD to the FW when
working in DQA mode.

This HCMD will enable DQA-specific flows in the FW.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h |  9 +++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 26 +++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index a1d3d95..eea03ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -332,6 +332,7 @@ enum iwl_system_subcmd_ids {
 };
 
 enum iwl_data_path_subcmd_ids {
+	DQA_ENABLE_CMD = 0x0,
 	UPDATE_MU_GROUPS_CMD = 0x1,
 	TRIGGER_RX_QUEUES_NOTIF_CMD = 0x2,
 	MU_GROUP_MGMT_NOTIF = 0xFE,
@@ -362,6 +363,14 @@ struct iwl_cmd_response {
 };
 
 /*
+ * struct iwl_dqa_enable_cmd
+ * @cmd_queue: the TXQ number of the command queue
+ */
+struct iwl_dqa_enable_cmd {
+	__le32 cmd_queue;
+} __packed; /* DQA_CONTROL_CMD_API_S_VER_1 */
+
+/*
  * struct iwl_tx_ant_cfg_cmd
  * @valid: valid antenna configuration
  */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 0a5490c..510b4c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -134,6 +134,23 @@ static int iwl_send_rss_cfg_cmd(struct iwl_mvm *mvm)
 	return iwl_mvm_send_cmd_pdu(mvm, RSS_CONFIG_CMD, 0, sizeof(cmd), &cmd);
 }
 
+static int iwl_mvm_send_dqa_cmd(struct iwl_mvm *mvm)
+{
+	struct iwl_dqa_enable_cmd dqa_cmd = {
+		.cmd_queue = cpu_to_le32(IWL_MVM_DQA_CMD_QUEUE),
+	};
+	u32 cmd_id = iwl_cmd_id(DQA_ENABLE_CMD, DATA_PATH_GROUP, 0);
+	int ret;
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, cmd_id, 0, sizeof(dqa_cmd), &dqa_cmd);
+	if (ret)
+		IWL_ERR(mvm, "Failed to send DQA enabling command: %d\n", ret);
+	else
+		IWL_DEBUG_FW(mvm, "Working in DQA mode\n");
+
+	return ret;
+}
+
 void iwl_free_fw_paging(struct iwl_mvm *mvm)
 {
 	int i;
@@ -979,6 +996,15 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	/* reset quota debouncing buffer - 0xff will yield invalid data */
 	memset(&mvm->last_quota_cmd, 0xff, sizeof(mvm->last_quota_cmd));
 
+	/* Enable DQA-mode if required */
+	if (iwl_mvm_is_dqa_supported(mvm)) {
+		ret = iwl_mvm_send_dqa_cmd(mvm);
+		if (ret)
+			goto error;
+	} else {
+		IWL_DEBUG_FW(mvm, "Working in non-DQA mode\n");
+	}
+
 	/* Add auxiliary station for scanning */
 	ret = iwl_mvm_add_aux_sta(mvm);
 	if (ret)
-- 
2.8.1

