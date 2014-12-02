Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53038 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbaLBSL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:57 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so28830854wiv.11
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:56 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/26] iwlwifi: mvm: send dbg config hcmds to fw if set in tlv
Date: Tue,  2 Dec 2014 20:11:14 +0200
Message-Id: <1417543877-24193-23-git-send-email-egrumbach@gmail.com> (sfid-20141202_191202_610210_74F706E9)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Send all debug-configuration HCMDs that are set in the TLVs
to the FW. This may include HCMDs to configure the FW
monitor and FW log level, for example.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c  | 39 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h |  1 +
 2 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index bbb78710..1f1337a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -394,6 +394,42 @@ out:
 	return ret;
 }
 
+static int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm,
+				     enum iwl_fw_dbg_conf conf_id)
+{
+	u8 *ptr;
+	int ret;
+	int i;
+
+	if (WARN_ONCE(conf_id >= ARRAY_SIZE(mvm->fw->dbg_conf_tlv),
+		      "Invalid configuration %d\n", conf_id))
+		return -EINVAL;
+
+	if (!mvm->fw->dbg_conf_tlv[conf_id])
+		return -EINVAL;
+
+	if (mvm->fw_dbg_conf != FW_DBG_INVALID)
+		IWL_WARN(mvm, "FW already configured (%d) - re-configuring\n",
+			 mvm->fw_dbg_conf);
+
+	/* Send all HCMDs for configuring the FW debug */
+	ptr = (void *)&mvm->fw->dbg_conf_tlv[conf_id]->hcmd;
+	for (i = 0; i < mvm->fw->dbg_conf_tlv[conf_id]->num_of_hcmds; i++) {
+		struct iwl_fw_dbg_conf_hcmd *cmd = (void *)ptr;
+
+		ret = iwl_mvm_send_cmd_pdu(mvm, cmd->id, 0,
+					   le16_to_cpu(cmd->len), cmd->data);
+		if (ret)
+			return ret;
+
+		ptr += sizeof(*cmd);
+		ptr += le16_to_cpu(cmd->len);
+	}
+
+	mvm->fw_dbg_conf = conf_id;
+	return ret;
+}
+
 int iwl_mvm_up(struct iwl_mvm *mvm)
 {
 	int ret, i;
@@ -445,6 +481,9 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		IWL_ERR(mvm, "Failed to initialize Smart Fifo\n");
 
+	mvm->fw_dbg_conf = FW_DBG_INVALID;
+	iwl_mvm_start_fw_dbg_conf(mvm, FW_DBG_CUSTOM);
+
 	ret = iwl_send_tx_ant_cfg(mvm, mvm->fw->valid_tx_ant);
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 12be7f3..d24660f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -670,6 +670,7 @@ struct iwl_mvm {
 	/* -1 for always, 0 for never, >0 for that many times */
 	s8 restart_fw;
 	struct work_struct fw_error_dump_wk;
+	enum iwl_fw_dbg_conf fw_dbg_conf;
 
 #ifdef CONFIG_IWLWIFI_LEDS
 	struct led_classdev led;
-- 
1.9.1

