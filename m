Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:9395 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256AbcAaLGg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:36 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Golan Ben-Ami <golan.ben.ami@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/31] iwlwifi: mvm: add trigger for firmware dump upon TX response status
Date: Sun, 31 Jan 2016 13:06:05 +0200
Message-Id: <1454238386-27032-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_123654_591499_85619E99)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

This will allow to collect the data when the firmware
sends a specific tx response status.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-fw-error-dump.h |  3 ++
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   | 13 +++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 33 ++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
index a5aaf68..8425e1a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
@@ -293,6 +293,8 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  * @FW_DBG_TX_LATENCY: trigger log collection when the tx latency goes above a
  *	threshold.
  * @FW_DBG_TDLS: trigger log collection upon TDLS related events.
+ * @FW_DBG_TRIGGER_TX_STATUS: trigger log collection upon tx status when
+ *  the firmware sends a tx reply.
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
@@ -309,6 +311,7 @@ enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_BA,
 	FW_DBG_TRIGGER_TX_LATENCY,
 	FW_DBG_TRIGGER_TDLS,
+	FW_DBG_TRIGGER_TX_STATUS,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 2273908..4050b4a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -750,6 +750,19 @@ struct iwl_fw_dbg_trigger_tdls {
 } __packed;
 
 /**
+ * struct iwl_fw_dbg_trigger_tx_status - configures trigger for tx response
+ *  status.
+ * @statuses: the list of statuses to trigger the collection on
+ */
+struct iwl_fw_dbg_trigger_tx_status {
+	struct tx_status {
+		u8 status;
+		u8 reserved[3];
+	} __packed statuses[16];
+	__le32 reserved[2];
+} __packed;
+
+/**
  * struct iwl_fw_dbg_conf_tlv - a TLV that describes a debug configuration.
  * @id: conf id
  * @usniffer: should the uSniffer image be used
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 8bf48a7..5d73db2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -736,6 +736,37 @@ static void iwl_mvm_hwrate_to_tx_status(u32 rate_n_flags,
 	iwl_mvm_hwrate_to_tx_rate(rate_n_flags, info->band, r);
 }
 
+static void iwl_mvm_tx_status_check_trigger(struct iwl_mvm *mvm,
+					    u32 status)
+{
+	struct iwl_fw_dbg_trigger_tlv *trig;
+	struct iwl_fw_dbg_trigger_tx_status *status_trig;
+	int i;
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_TX_STATUS))
+		return;
+
+	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_TX_STATUS);
+	status_trig = (void *)trig->data;
+
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, NULL, trig))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(status_trig->statuses); i++) {
+		/* don't collect on status 0 */
+		if (!status_trig->statuses[i].status)
+			break;
+
+		if (status_trig->statuses[i].status != (status & TX_STATUS_MSK))
+			continue;
+
+		iwl_mvm_fw_dbg_collect_trig(mvm, trig,
+					    "Tx status %d was received",
+					    status & TX_STATUS_MSK);
+		break;
+	}
+}
+
 static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 				     struct iwl_rx_packet *pkt)
 {
@@ -784,6 +815,8 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			break;
 		}
 
+		iwl_mvm_tx_status_check_trigger(mvm, status);
+
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		iwl_mvm_hwrate_to_tx_status(le32_to_cpu(tx_resp->initial_rate),
 					    info);
-- 
2.5.0

