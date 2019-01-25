Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB33C282C6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15E08218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbfAYUNV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:13:21 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50820 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726895AbfAYUNU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:13:20 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn7qn-00010a-Ql; Fri, 25 Jan 2019 22:13:18 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 22:12:56 +0200
Message-Id: <20190125201305.5616-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125201305.5616-1-luca@coelho.fi>
References: <20190125201305.5616-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/17] iwlwifi: mvm: clean up LDBG config command usage
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Clean up the LDBG config command to not be called "continuous
recording", and while at it actually remove the continuous
recording implementation completely since it was only used for
store & forward architectures.

This also fixes a bug at least in iwl_fw_dbg_buffer_allocation()
because what's now "__le32 type" (matching the firmware) used to
be "__le16 enable_recording", so the buffer allocation config
sub-struct would erroneously have started at the wrong offset.
In the other cases this didn't actually lead to a bug as other
bytes in pad[] were all zeroes, so accessing the 16-bit value as
a 32-bit value wouldn't make a difference (in little endian.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/debug.h | 33 ++++++--------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 12 +++---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   | 13 +++---
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 43 -------------------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  3 ++
 5 files changed, 29 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h b/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
index dc1fa377087a..988584973aba 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
@@ -335,29 +335,11 @@ struct iwl_dbg_mem_access_rsp {
 	__le32 data[];
 } __packed; /* DEBUG_(U|L)MAC_RD_WR_RSP_API_S_VER_1 */
 
-#define CONT_REC_COMMAND_SIZE	80
-#define ENABLE_CONT_RECORDING	0x15
-#define DISABLE_CONT_RECORDING	0x16
+#define LDBG_CFG_COMMAND_SIZE	80
 #define BUFFER_ALLOCATION	0x27
 #define START_DEBUG_RECORDING	0x29
 #define STOP_DEBUG_RECORDING	0x2A
 
-/*
- * struct iwl_continuous_record_mode - recording mode
- */
-struct iwl_continuous_record_mode {
-	__le16 enable_recording;
-} __packed;
-
-/*
- * struct iwl_continuous_record_cmd - enable/disable continuous recording
- */
-struct iwl_continuous_record_cmd {
-	struct iwl_continuous_record_mode record_mode;
-	u8 pad[CONT_REC_COMMAND_SIZE -
-		sizeof(struct iwl_continuous_record_mode)];
-} __packed;
-
 /* maximum fragments to be allocated per target of allocationId */
 #define IWL_BUFFER_LOCATION_MAX_FRAGS	2
 
@@ -385,4 +367,17 @@ struct iwl_buffer_allocation_cmd {
 	struct iwl_fragment_data fragments[IWL_BUFFER_LOCATION_MAX_FRAGS];
 } __packed; /* BUFFER_ALLOCATION_CMD_API_S_VER_1 */
 
+/**
+ * struct iwl_ldbg_config_cmd - LDBG config command
+ * @type: configuration type
+ * @pad: reserved space for type-dependent data
+ */
+struct iwl_ldbg_config_cmd {
+	__le32 type;
+	union {
+		u8 pad[LDBG_CFG_COMMAND_SIZE - sizeof(__le32)];
+		struct iwl_buffer_allocation_cmd buffer_allocation;
+	}; /* LDBG_CFG_BODY_API_U_VER_2 (partially) */
+} __packed; /* LDBG_CFG_CMD_API_S_VER_2 */
+
 #endif /* __iwl_fw_api_debug_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index a97bf17da14d..917aafe1a9db 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1678,20 +1678,20 @@ iwl_fw_dbg_buffer_allocation(struct iwl_fw_runtime *fwrt,
 			     struct iwl_fw_ini_allocation_tlv *alloc)
 {
 	struct iwl_trans *trans = fwrt->trans;
-	struct iwl_continuous_record_cmd cont_rec = {};
-	struct iwl_buffer_allocation_cmd *cmd = (void *)&cont_rec.pad[0];
+	struct iwl_ldbg_config_cmd ldbg_cmd = {
+		.type = cpu_to_le32(BUFFER_ALLOCATION),
+	};
+	struct iwl_buffer_allocation_cmd *cmd = &ldbg_cmd.buffer_allocation;
 	struct iwl_host_cmd hcmd = {
 		.id = LDBG_CONFIG_CMD,
 		.flags = CMD_ASYNC,
-		.data[0] = &cont_rec,
-		.len[0] = sizeof(cont_rec),
+		.data[0] = &ldbg_cmd,
+		.len[0] = sizeof(ldbg_cmd),
 	};
 	void *virtual_addr = NULL;
 	u32 size = le32_to_cpu(alloc->size);
 	dma_addr_t phys_addr;
 
-	cont_rec.record_mode.enable_recording = cpu_to_le16(BUFFER_ALLOCATION);
-
 	if (!trans->num_blocks &&
 	    le32_to_cpu(alloc->buffer_location) !=
 	    IWL_FW_INI_LOCATION_DRAM_PATH)
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 40dcc3deb257..7cd206e6fb9e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -271,18 +271,17 @@ _iwl_fw_dbg_trigger_simple_stop(struct iwl_fw_runtime *fwrt,
 
 static int iwl_fw_dbg_start_stop_hcmd(struct iwl_fw_runtime *fwrt, bool start)
 {
-	struct iwl_continuous_record_cmd cont_rec = {};
+	struct iwl_ldbg_config_cmd cmd = {
+		.type = start ? cpu_to_le32(START_DEBUG_RECORDING) :
+				cpu_to_le32(STOP_DEBUG_RECORDING),
+	};
 	struct iwl_host_cmd hcmd = {
 		.id = LDBG_CONFIG_CMD,
 		.flags = CMD_ASYNC,
-		.data[0] = &cont_rec,
-		.len[0] = sizeof(cont_rec),
+		.data[0] = &cmd,
+		.len[0] = sizeof(cmd),
 	};
 
-	cont_rec.record_mode.enable_recording = start ?
-		cpu_to_le16(START_DEBUG_RECORDING) :
-		cpu_to_le16(STOP_DEBUG_RECORDING);
-
 	return iwl_trans_send_cmd(fwrt->trans, &hcmd);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 52c361a6124c..514aaec6d59e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1206,47 +1206,6 @@ static ssize_t iwl_dbgfs_fw_dbg_conf_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-/*
- * Enable / Disable continuous recording.
- * Cause the FW to start continuous recording, by sending the relevant hcmd.
- * Enable: input of every integer larger than 0, ENABLE_CONT_RECORDING.
- * Disable: for 0 as input, DISABLE_CONT_RECORDING.
- */
-static ssize_t iwl_dbgfs_cont_recording_write(struct iwl_mvm *mvm,
-					      char *buf, size_t count,
-					      loff_t *ppos)
-{
-	struct iwl_trans *trans = mvm->trans;
-	const struct iwl_fw_dbg_dest_tlv_v1 *dest = trans->dbg_dest_tlv;
-	struct iwl_continuous_record_cmd cont_rec = {};
-	int ret, rec_mode;
-
-	if (!iwl_mvm_firmware_running(mvm))
-		return -EIO;
-
-	if (!dest)
-		return -EOPNOTSUPP;
-
-	if (dest->monitor_mode != SMEM_MODE ||
-	    trans->cfg->device_family < IWL_DEVICE_FAMILY_8000)
-		return -EOPNOTSUPP;
-
-	ret = kstrtoint(buf, 0, &rec_mode);
-	if (ret)
-		return ret;
-
-	cont_rec.record_mode.enable_recording = rec_mode ?
-		cpu_to_le16(ENABLE_CONT_RECORDING) :
-		cpu_to_le16(DISABLE_CONT_RECORDING);
-
-	mutex_lock(&mvm->mutex);
-	ret = iwl_mvm_send_cmd_pdu(mvm, LDBG_CONFIG_CMD, 0,
-				   sizeof(cont_rec), &cont_rec);
-	mutex_unlock(&mvm->mutex);
-
-	return ret ?: count;
-}
-
 static ssize_t iwl_dbgfs_fw_dbg_conf_write(struct iwl_mvm *mvm,
 					   char *buf, size_t count,
 					   loff_t *ppos)
@@ -1800,7 +1759,6 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(fw_dbg_conf, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_dbg_collect, 64);
-MVM_DEBUGFS_WRITE_FILE_OPS(cont_recording, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(max_amsdu_len, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(indirection_tbl,
 			   (IWL_RSS_INDIRECTION_TABLE_SIZE * 2));
@@ -2004,7 +1962,6 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_collect, mvm->debugfs_dir, 0200);
 	MVM_DEBUGFS_ADD_FILE(max_amsdu_len, mvm->debugfs_dir, 0200);
 	MVM_DEBUGFS_ADD_FILE(send_echo_cmd, mvm->debugfs_dir, 0200);
-	MVM_DEBUGFS_ADD_FILE(cont_recording, mvm->debugfs_dir, 0200);
 	MVM_DEBUGFS_ADD_FILE(indirection_tbl, mvm->debugfs_dir, 0200);
 	MVM_DEBUGFS_ADD_FILE(inject_packet, mvm->debugfs_dir, 0200);
 #ifdef CONFIG_ACPI
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d257c143e624..ee2ef3f0042c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -737,6 +737,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		trans_cfg.rx_buf_size = rb_size_default;
 	}
 
+	BUILD_BUG_ON(sizeof(struct iwl_ldbg_config_cmd) !=
+		     LDBG_CFG_COMMAND_SIZE);
+
 	trans->wide_cmd_header = true;
 	trans_cfg.bc_table_dword =
 		mvm->trans->cfg->device_family < IWL_DEVICE_FAMILY_22560;
-- 
2.20.1

