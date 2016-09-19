Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56018 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S936361AbcISHca (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:32:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
        Ido Yariv <idox.yariv@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:25 +0300
Message-Id: <20160919073028.22065-22-luca@coelho.fi> (sfid-20160919_093233_102334_ADA949CA)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 22/25] iwlwifi: mvm: Add mem debugfs entry
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

In order to access cached/paged memory, there are a couple of firmware
commands (one for UMAC and one for LMAC) that let the host access memory
and registers indirectly. Since this is done by the firmware on behalf
of the host, even if memory is paged out or cached, the host will
retrieve the memory as the firmware sees it (paged out memory will get
paged in).

Export this mechanism via a debugfs entry for both read and write
access.

WARNING: This mechanism has no protections at all. Invalid addresses may
crash or hang the firmware. Writing to arbitrary memory also comes with
no guarantees.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 129 +++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h  |  50 +++++++++
 2 files changed, 179 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 540b7c9..539d718 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1518,6 +1518,132 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters_macs, 256);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d3_sram, 8);
 #endif
 
+static ssize_t iwl_dbgfs_mem_read(struct file *file, char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	struct iwl_dbg_mem_access_cmd cmd = {};
+	struct iwl_dbg_mem_access_rsp *rsp;
+	struct iwl_host_cmd hcmd = {
+		.flags = CMD_WANT_SKB | CMD_SEND_IN_RFKILL,
+		.data = { &cmd, },
+		.len = { sizeof(cmd) },
+	};
+	size_t delta, len;
+	ssize_t ret;
+
+	hcmd.id = iwl_cmd_id(*ppos >> 24 ? UMAC_RD_WR : LMAC_RD_WR,
+			     DEBUG_GROUP, 0);
+	cmd.op = cpu_to_le32(DEBUG_MEM_OP_READ);
+
+	/* Take care of alignment of both the position and the length */
+	delta = *ppos & 0x3;
+	cmd.addr = cpu_to_le32(*ppos - delta);
+	cmd.len = cpu_to_le32(min(ALIGN(count + delta, 4) / 4,
+				  (size_t)DEBUG_MEM_MAX_SIZE_DWORDS));
+
+	mutex_lock(&mvm->mutex);
+	ret = iwl_mvm_send_cmd(mvm, &hcmd);
+	mutex_unlock(&mvm->mutex);
+
+	if (ret < 0)
+		return ret;
+
+	rsp = (void *)hcmd.resp_pkt->data;
+	if (le32_to_cpu(rsp->status) != DEBUG_MEM_STATUS_SUCCESS) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	len = min((size_t)le32_to_cpu(rsp->len) << 2,
+		  iwl_rx_packet_payload_len(hcmd.resp_pkt) - sizeof(*rsp));
+	len = min(len - delta, count);
+	if (len < 0) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = len - copy_to_user(user_buf, (void *)rsp->data + delta, len);
+	*ppos += ret;
+
+out:
+	iwl_free_resp(&hcmd);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_mem_write(struct file *file,
+				   const char __user *user_buf, size_t count,
+				   loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	struct iwl_dbg_mem_access_cmd *cmd;
+	struct iwl_dbg_mem_access_rsp *rsp;
+	struct iwl_host_cmd hcmd = {};
+	size_t cmd_size;
+	size_t data_size;
+	u32 op, len;
+	ssize_t ret;
+
+	hcmd.id = iwl_cmd_id(*ppos >> 24 ? UMAC_RD_WR : LMAC_RD_WR,
+			     DEBUG_GROUP, 0);
+
+	if (*ppos & 0x3 || count < 4) {
+		op = DEBUG_MEM_OP_WRITE_BYTES;
+		len = min(count, (size_t)(4 - (*ppos & 0x3)));
+		data_size = len;
+	} else {
+		op = DEBUG_MEM_OP_WRITE;
+		len = min(count >> 2, (size_t)DEBUG_MEM_MAX_SIZE_DWORDS);
+		data_size = len << 2;
+	}
+
+	cmd_size = sizeof(*cmd) + ALIGN(data_size, 4);
+	cmd = kzalloc(cmd_size, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->op = cpu_to_le32(op);
+	cmd->len = cpu_to_le32(len);
+	cmd->addr = cpu_to_le32(*ppos);
+	if (copy_from_user((void *)cmd->data, user_buf, data_size)) {
+		kfree(cmd);
+		return -EFAULT;
+	}
+
+	hcmd.flags = CMD_WANT_SKB | CMD_SEND_IN_RFKILL,
+	hcmd.data[0] = (void *)cmd;
+	hcmd.len[0] = cmd_size;
+
+	mutex_lock(&mvm->mutex);
+	ret = iwl_mvm_send_cmd(mvm, &hcmd);
+	mutex_unlock(&mvm->mutex);
+
+	kfree(cmd);
+
+	if (ret < 0)
+		return ret;
+
+	rsp = (void *)hcmd.resp_pkt->data;
+	if (rsp->status != DEBUG_MEM_STATUS_SUCCESS) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	ret = data_size;
+	*ppos += ret;
+
+out:
+	iwl_free_resp(&hcmd);
+	return ret;
+}
+
+static const struct file_operations iwl_dbgfs_mem_ops = {
+	.read = iwl_dbgfs_mem_read,
+	.write = iwl_dbgfs_mem_write,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
 int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 {
 	struct dentry *bcast_dir __maybe_unused;
@@ -1615,6 +1741,9 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 				 mvm->debugfs_dir, &mvm->nvm_phy_sku_blob))
 		goto err;
 
+	debugfs_create_file("mem", S_IRUSR | S_IWUSR, dbgfs_dir, mvm,
+			    &iwl_dbgfs_mem_ops);
+
 	/*
 	 * Create a symlink with mac80211. It will be removed when mac80211
 	 * exists (before the opmode exists which removes the target.)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 2f92994..fdd9506 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -340,6 +340,11 @@ enum iwl_prot_offload_subcmd_ids {
 	STORED_BEACON_NTF = 0xFF,
 };
 
+enum iwl_fmac_debug_cmds {
+	LMAC_RD_WR = 0x0,
+	UMAC_RD_WR = 0x1,
+};
+
 /* command groups */
 enum {
 	LEGACY_GROUP = 0x0,
@@ -349,6 +354,7 @@ enum {
 	PHY_OPS_GROUP = 0x4,
 	DATA_PATH_GROUP = 0x5,
 	PROT_OFFLOAD_GROUP = 0xb,
+	DEBUG_GROUP = 0xf,
 };
 
 /**
@@ -2149,4 +2155,48 @@ struct iwl_channel_switch_noa_notif {
 	__le32 id_and_color;
 } __packed; /* CHANNEL_SWITCH_START_NTFY_API_S_VER_1 */
 
+/* Operation types for the debug mem access */
+enum {
+	DEBUG_MEM_OP_READ = 0,
+	DEBUG_MEM_OP_WRITE = 1,
+	DEBUG_MEM_OP_WRITE_BYTES = 2,
+};
+
+#define DEBUG_MEM_MAX_SIZE_DWORDS 32
+
+/**
+ * struct iwl_dbg_mem_access_cmd - Request the device to read/write memory
+ * @op: DEBUG_MEM_OP_*
+ * @addr: address to read/write from/to
+ * @len: in dwords, to read/write
+ * @data: for write opeations, contains the source buffer
+ */
+struct iwl_dbg_mem_access_cmd {
+	__le32 op;
+	__le32 addr;
+	__le32 len;
+	__le32 data[];
+} __packed; /* DEBUG_(U|L)MAC_RD_WR_CMD_API_S_VER_1 */
+
+/* Status responses for the debug mem access */
+enum {
+	DEBUG_MEM_STATUS_SUCCESS = 0x0,
+	DEBUG_MEM_STATUS_FAILED = 0x1,
+	DEBUG_MEM_STATUS_LOCKED = 0x2,
+	DEBUG_MEM_STATUS_HIDDEN = 0x3,
+	DEBUG_MEM_STATUS_LENGTH = 0x4,
+};
+
+/**
+ * struct iwl_dbg_mem_access_rsp - Response to debug mem commands
+ * @status: DEBUG_MEM_STATUS_*
+ * @len: read dwords (0 for write operations)
+ * @data: contains the read DWs
+ */
+struct iwl_dbg_mem_access_rsp {
+	__le32 status;
+	__le32 len;
+	__le32 data[];
+} __packed; /* DEBUG_(U|L)MAC_RD_WR_RSP_API_S_VER_1 */
+
 #endif /* __fw_api_h__ */
-- 
2.9.3
