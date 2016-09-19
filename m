Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55992 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932428AbcISHcB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:32:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:17 +0300
Message-Id: <20160919073028.22065-14-luca@coelho.fi> (sfid-20160919_093204_831290_FA5170A1)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 14/25] iwlwifi: move to wide ID for all commands
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Due to firmware design considerations, move to wide ID for
all commands.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c | 8 ++++++--
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c      | 3 +++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h      | 5 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c        | 4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h  | 2 --
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c     | 1 -
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c        | 2 +-
 7 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c b/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c
index 8aa1f2b..88f260d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c
@@ -99,8 +99,12 @@ void iwl_notification_wait_notify(struct iwl_notif_wait_data *notif_wait,
 				continue;
 
 			for (i = 0; i < w->n_cmds; i++) {
-				if (w->cmds[i] ==
-				    WIDE_ID(pkt->hdr.group_id, pkt->hdr.cmd)) {
+				u16 rec_id = WIDE_ID(pkt->hdr.group_id,
+						     pkt->hdr.cmd);
+
+				if (w->cmds[i] == rec_id ||
+				    (!iwl_cmd_groupid(w->cmds[i]) &&
+				     DEF_ID(w->cmds[i]) == rec_id)) {
 					found = true;
 					break;
 				}
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index b0bd67c..b42152c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -140,6 +140,9 @@ int iwl_trans_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	if (!(cmd->flags & CMD_ASYNC))
 		lock_map_acquire_read(&trans->sync_cmd_lockdep_map);
 
+	if (trans->wide_cmd_header && !iwl_cmd_groupid(cmd->id))
+		cmd->id = DEF_ID(cmd->id);
+
 	ret = trans->ops->send_cmd(trans, cmd);
 
 	if (!(cmd->flags & CMD_ASYNC))
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 04e998d..0296124 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -153,6 +153,7 @@ static inline u32 iwl_cmd_id(u8 opcode, u8 groupid, u8 version)
 
 /* make u16 wide id out of u8 group and opcode */
 #define WIDE_ID(grp, opcode) ((grp << 8) | opcode)
+#define DEF_ID(opcode) ((1 << 8) | (opcode))
 
 /* due to the conversion, this group is special; new groups
  * should be defined in the appropriate fw-api header files
@@ -484,7 +485,6 @@ struct iwl_hcmd_arr {
  * @bc_table_dword: set to true if the BC table expects the byte count to be
  *	in DWORD (as opposed to bytes)
  * @scd_set_active: should the transport configure the SCD for HCMD queue
- * @wide_cmd_header: firmware supports wide host command header
  * @sw_csum_tx: transport should compute the TCP checksum
  * @command_groups: array of command groups, each member is an array of the
  *	commands in the group; for debugging only
@@ -506,7 +506,6 @@ struct iwl_trans_config {
 	enum iwl_amsdu_size rx_buf_size;
 	bool bc_table_dword;
 	bool scd_set_active;
-	bool wide_cmd_header;
 	bool sw_csum_tx;
 	const struct iwl_hcmd_arr *command_groups;
 	int command_groups_size;
@@ -770,6 +769,7 @@ enum iwl_plat_pm_mode {
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
  * @pm_support: set to true in start_hw if link pm is supported
  * @ltr_enabled: set to true if the LTR is enabled
+ * @wide_cmd_header: true when ucode supports wide command header format
  * @num_rx_queues: number of RX queues allocated by the transport;
  *	the transport must set this before calling iwl_drv_start()
  * @dev_cmd_pool: pool for Tx cmd allocation - for internal use only.
@@ -821,6 +821,7 @@ struct iwl_trans {
 
 	const struct iwl_hcmd_arr *command_groups;
 	int command_groups_size;
+	bool wide_cmd_header;
 
 	u8 num_rx_queues;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index de34c9f..b2d8722 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -652,8 +652,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	/* the hardware splits the A-MSDU */
 	if (mvm->cfg->mq_rx_supported)
 		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
-	trans_cfg.wide_cmd_header = fw_has_api(&mvm->fw->ucode_capa,
-					       IWL_UCODE_TLV_API_WIDE_CMD_HDR);
+	trans->wide_cmd_header = fw_has_api(&mvm->fw->ucode_capa,
+					    IWL_UCODE_TLV_API_WIDE_CMD_HDR);
 
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DW_BC_TABLE)
 		trans_cfg.bc_table_dword = true;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 987a077..2d81630 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -332,7 +332,6 @@ enum iwl_shared_irq_flags {
  * @rx_buf_size: Rx buffer size
  * @bc_table_dword: true if the BC table expects DWORD (as opposed to bytes)
  * @scd_set_active: should the transport configure the SCD for HCMD queue
- * @wide_cmd_header: true when ucode supports wide command header format
  * @sw_csum_tx: if true, then the transport will compute the csum of the TXed
  *	frame.
  * @rx_page_order: page order for receive buffer size
@@ -405,7 +404,6 @@ struct iwl_trans_pcie {
 	enum iwl_amsdu_size rx_buf_size;
 	bool bc_table_dword;
 	bool scd_set_active;
-	bool wide_cmd_header;
 	bool sw_csum_tx;
 	u32 rx_page_order;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 74199b1..68fa843 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1755,7 +1755,6 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	trans_pcie->rx_page_order =
 		iwl_trans_get_rb_size_order(trans_pcie->rx_buf_size);
 
-	trans_pcie->wide_cmd_header = trans_cfg->wide_cmd_header;
 	trans_pcie->bc_table_dword = trans_cfg->bc_table_dword;
 	trans_pcie->scd_set_active = trans_cfg->scd_set_active;
 	trans_pcie->sw_csum_tx = trans_cfg->sw_csum_tx;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 0d156fd..e00e7d8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1493,7 +1493,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
 
-	if (WARN(!trans_pcie->wide_cmd_header &&
+	if (WARN(!trans->wide_cmd_header &&
 		 group_id > IWL_ALWAYS_LONG_GROUP,
 		 "unsupported wide command %#x\n", cmd->id))
 		return -EINVAL;
-- 
2.9.3
