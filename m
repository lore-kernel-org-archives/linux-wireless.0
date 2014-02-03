Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:37159 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaBCU7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:16 -0500
Received: by mail-ee0-f51.google.com with SMTP id b57so3886644eek.24
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:15 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 37/62] iwlwifi: add very first D0i3 support
Date: Mon,  3 Feb 2014 22:57:43 +0200
Message-Id: <1391461088-8082-37-git-send-email-egrumbach@gmail.com> (sfid-20140203_223006_720592_BF389070)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When the bus is in D0i3, we can't send regular commands to
the firmware. This means that we need to add a state to
remember what is our d0i3 state and make sure that only
d0i3 exit commands can be sent.
Add flags to CMD_ flags and transport status for this
purpose.

Commands with CMD_HIGH_PRIO set are queued at the head of
the command queue, behind other high priority commands.

Commands with CMD_SEND_IN_IDLE set can be sent while the
transport is idle (without taking rpm reference).

Commands with CMD_MAKE_TRANS_IDLE set indicate that command
completion should mark the transport as idle (and release
the bus).

Commands with CMD_WAKE_UP_TRANS set instruct the transport
to exit from idle when this command is completed.

The transport is marked as idle (STATUS_TRANS_IDLE) when
the FW enters D0i3 state. This bit is cleared when it
enters D0 state again.

Process only commands with CMD_SEND_IN_IDLE flag while the
transport is idle. Other enqueued commands will be
processed only later, right after exiting D0i3.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h  |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h |    1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c    |   15 +++++++++++++--
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 1b2ac31..7b19274 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -193,12 +193,23 @@ static inline u32 iwl_rx_packet_payload_len(const struct iwl_rx_packet *pkt)
  * @CMD_ASYNC: Return right away and don't wait for the response
  * @CMD_WANT_SKB: valid only with CMD_SYNC. The caller needs the buffer of the
  *	response. The caller needs to call iwl_free_resp when done.
+ * @CMD_HIGH_PRIO: The command is high priority - it goes to the front of the
+ *	command queue, but after other high priority commands. valid only
+ *	with CMD_ASYNC.
+ * @CMD_SEND_IN_IDLE: The command should be sent even when the trans is idle.
+ * @CMD_MAKE_TRANS_IDLE: The command response should mark the trans as idle.
+ * @CMD_WAKE_UP_TRANS: The command response should wake up the trans
+ *	(i.e. mark it as non-idle).
  */
 enum CMD_MODE {
 	CMD_SYNC		= 0,
 	CMD_ASYNC		= BIT(0),
 	CMD_WANT_SKB		= BIT(1),
 	CMD_SEND_IN_RFKILL	= BIT(2),
+	CMD_HIGH_PRIO		= BIT(3),
+	CMD_SEND_IN_IDLE	= BIT(4),
+	CMD_MAKE_TRANS_IDLE	= BIT(5),
+	CMD_WAKE_UP_TRANS	= BIT(6),
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
@@ -335,6 +346,9 @@ enum iwl_d3_status {
  * @STATUS_INT_ENABLED: interrupts are enabled
  * @STATUS_RFKILL: the HW RFkill switch is in KILL position
  * @STATUS_FW_ERROR: the fw is in error state
+ * @STATUS_TRANS_GOING_IDLE: shutting down the trans, only special commands
+ *	are sent
+ * @STATUS_TRANS_IDLE: the trans is idle - general commands are not to be sent
  */
 enum iwl_trans_status {
 	STATUS_SYNC_HCMD_ACTIVE,
@@ -343,6 +357,8 @@ enum iwl_trans_status {
 	STATUS_INT_ENABLED,
 	STATUS_RFKILL,
 	STATUS_FW_ERROR,
+	STATUS_TRANS_GOING_IDLE,
+	STATUS_TRANS_IDLE,
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 32844e3..3bf5f82 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -199,6 +199,7 @@ enum {
 	PROT_OFFLOAD_CONFIG_CMD = 0xd4,
 	OFFLOADS_QUERY_CMD = 0xd5,
 	REMOTE_WAKE_CONFIG_CMD = 0xd6,
+	D0I3_END_CMD = 0xed,
 
 	/* for WoWLAN in particular */
 	WOWLAN_PATTERNS = 0xe0,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 0f87bc3..6e46b7c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -291,6 +291,7 @@ static const char *iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(REDUCE_TX_POWER_CMD),
 	CMD(TX_ANT_CONFIGURATION_CMD),
 	CMD(D3_CONFIG_CMD),
+	CMD(D0I3_END_CMD),
 	CMD(PROT_OFFLOAD_CONFIG_CMD),
 	CMD(OFFLOADS_QUERY_CMD),
 	CMD(REMOTE_WAKE_CONFIG_CMD),
@@ -815,17 +816,27 @@ static void iwl_mvm_cmd_queue_full(struct iwl_op_mode *op_mode)
 static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+	u32 flags = CMD_ASYNC | CMD_HIGH_PRIO | CMD_SEND_IN_IDLE;
+	struct iwl_d3_manager_config d3_cfg_cmd = {
+		.min_sleep_time = cpu_to_le32(1000),
+	};
 
 	IWL_DEBUG_RPM(mvm, "MVM entering D0i3\n");
-	return 0;
+
+	return iwl_mvm_send_cmd_pdu(mvm, D3_CONFIG_CMD,
+				    flags | CMD_MAKE_TRANS_IDLE,
+				    sizeof(d3_cfg_cmd), &d3_cfg_cmd);
 }
 
 static int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+	u32 flags = CMD_ASYNC | CMD_HIGH_PRIO | CMD_SEND_IN_IDLE |
+		    CMD_WAKE_UP_TRANS;
 
 	IWL_DEBUG_RPM(mvm, "MVM exiting D0i3\n");
-	return 0;
+
+	return iwl_mvm_send_cmd_pdu(mvm, D0I3_END_CMD, flags, 0, NULL);
 }
 
 static const struct iwl_op_mode_ops iwl_mvm_ops = {
-- 
1.7.9.5

