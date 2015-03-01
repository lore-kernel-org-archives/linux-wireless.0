Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbbCATco (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:44 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/31] iwlwifi: mvm: add trigger for firmware dump upon command response
Date: Sun,  1 Mar 2015 21:31:40 +0200
Message-Id: <1425238304-498-27-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203417_725053_D9501D98)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow to collect the data as soon the firmware
sends a specific notification of command response.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  3 +++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       | 11 ++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c           | 34 ++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 1ee58b3..1d5195b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -244,6 +244,8 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  * @FW_DBG_TRIGGER_MISSED_BEACONS: trigger log collection when beacons are
  *	missed.
  * @FW_DBG_TRIGGER_CHANNEL_SWITCH: trigger log collection upon channel switch.
+ * @FW_DBG_TRIGGER_FW_NOTIF: trigger log collection when the firmware sends a
+ *	command response or a notification.
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
@@ -251,6 +253,7 @@ enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_FW_ASSERT,
 	FW_DBG_TRIGGER_MISSED_BEACONS,
 	FW_DBG_TRIGGER_CHANNEL_SWITCH,
+	FW_DBG_TRIGGER_FW_NOTIF,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 85745dc..49388c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -541,6 +541,17 @@ struct iwl_fw_dbg_trigger_missed_bcon {
 } __packed;
 
 /**
+ * struct iwl_fw_dbg_trigger_cmd - configures trigger for messages from FW.
+ * cmds: the list of commands to trigger the collection on
+ */
+struct iwl_fw_dbg_trigger_cmd {
+	struct cmd {
+		u8 cmd_id;
+		u8 group_id;
+	} __packed cmds[16];
+} __packed;
+
+/**
  * struct iwl_fw_dbg_conf_tlv - a TLV that describes a debug configuration.
  * @id: conf id
  * @usniffer: should the uSniffer image be used
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index f1c5751..fe40922 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -685,6 +685,38 @@ static void iwl_mvm_async_handlers_wk(struct work_struct *wk)
 	mutex_unlock(&mvm->mutex);
 }
 
+static inline void iwl_mvm_rx_check_trigger(struct iwl_mvm *mvm,
+					    struct iwl_rx_packet *pkt)
+{
+	struct iwl_fw_dbg_trigger_tlv *trig;
+	struct iwl_fw_dbg_trigger_cmd *cmds_trig;
+	char buf[32];
+	int i;
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_FW_NOTIF))
+		return;
+
+	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_FW_NOTIF);
+	cmds_trig = (void *)trig->data;
+
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, NULL, trig))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(cmds_trig->cmds); i++) {
+		/* don't collect on CMD 0 */
+		if (!cmds_trig->cmds[i].cmd_id)
+			break;
+
+		if (cmds_trig->cmds[i].cmd_id != pkt->hdr.cmd)
+			continue;
+
+		memset(buf, 0, sizeof(buf));
+		snprintf(buf, sizeof(buf), "CMD 0x%02x received", pkt->hdr.cmd);
+		iwl_mvm_fw_dbg_collect_trig(mvm, trig, buf, sizeof(buf));
+		break;
+	}
+}
+
 static int iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 			       struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd)
@@ -693,6 +725,8 @@ static int iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	u8 i;
 
+	iwl_mvm_rx_check_trigger(mvm, pkt);
+
 	/*
 	 * Do the notification wait before RX handlers so
 	 * even if the RX handler consumes the RXB we have
-- 
1.9.1

