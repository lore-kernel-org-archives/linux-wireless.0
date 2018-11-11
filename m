Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B334C43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A5022080D
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:08:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A5022080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730956AbeKLF55 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 00:57:57 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:36048 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726471AbeKLF55 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 00:57:57 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLw1L-0000JG-U0; Sun, 11 Nov 2018 22:07:51 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Lior Cohen <lior2.cohen@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 22:07:28 +0200
Message-Id: <20181111200732.8159-13-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111200732.8159-1-luca@coelho.fi>
References: <20181111200732.8159-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/16] iwlwifi: add debugfs file to read fw debug data recording
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lior Cohen <lior2.cohen@intel.com>

FW debug data will oneshot read all data available in DRAM
and fill the supplied user buffer. In case the read request
is greater than the new data in DRAM, the driver will write
all data it has and return the buffer immediately.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Lior Cohen <lior2.cohen@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  14 ++
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |   2 +
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |   3 +
 .../wireless/intel/iwlwifi/pcie/internal.h    |  44 +++++
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 160 ++++++++++++++++++
 6 files changed, 228 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 6b3c5677c53a..ab81ea8b636f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -266,6 +266,9 @@ _iwl_fw_dbg_stop_recording(struct iwl_trans *trans,
 	iwl_write_prph(trans, DBGC_IN_SAMPLE, 0);
 	udelay(100);
 	iwl_write_prph(trans, DBGC_OUT_CTRL, 0);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	trans->dbg_rec_on = false;
+#endif
 }
 
 static inline void
@@ -296,6 +299,14 @@ _iwl_fw_dbg_restart_recording(struct iwl_trans *trans,
 	}
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+static inline void iwl_fw_set_dbg_rec_on(struct iwl_fw_runtime *fwrt)
+{
+	if (fwrt->fw->dbg.dest_tlv && fwrt->cur_fw_img == IWL_UCODE_REGULAR)
+		fwrt->trans->dbg_rec_on = true;
+}
+#endif
+
 static inline void
 iwl_fw_dbg_restart_recording(struct iwl_fw_runtime *fwrt,
 			     struct iwl_fw_dbg_params *params)
@@ -304,6 +315,9 @@ iwl_fw_dbg_restart_recording(struct iwl_fw_runtime *fwrt,
 		_iwl_fw_dbg_restart_recording(fwrt->trans, params);
 	else
 		iwl_fw_dbg_start_stop_hcmd(fwrt, true);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	iwl_fw_set_dbg_rec_on(fwrt);
+#endif
 }
 
 static inline void iwl_fw_dump_conf_clear(struct iwl_fw_runtime *fwrt)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 7b98125e4eb9..a65ba955783d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1628,6 +1628,8 @@ void iwl_drv_stop(struct iwl_drv *drv)
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
+	drv->trans->ops->debugfs_cleanup(drv->trans);
+
 	debugfs_remove_recursive(drv->dbgfs_drv);
 #endif
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index c2531eae5e16..a7009cd4232d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -536,6 +536,8 @@ struct iwl_trans_rxq_dma_data {
  * @dump_data: return a vmalloc'ed buffer with debug data, maybe containing last
  *	TX'ed commands and similar. The buffer will be vfree'd by the caller.
  *	Note that the transport must fill in the proper file headers.
+ * @debugfs_cleanup: used in the driver unload flow to make a proper cleanup
+ *	of the trans debugfs
  */
 struct iwl_trans_ops {
 
@@ -605,6 +607,7 @@ struct iwl_trans_ops {
 
 	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans,
 						 u32 dump_mask);
+	void (*debugfs_cleanup)(struct iwl_trans *trans);
 };
 
 /**
@@ -734,6 +737,7 @@ struct iwl_dram_data {
  * @runtime_pm_mode: the runtime power management mode in use.  This
  *	mode is set during the initialization phase and is not
  *	supposed to change during runtime.
+ * @dbg_rec_on: true iff there is a fw debug recording currently active
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
@@ -790,6 +794,7 @@ struct iwl_trans {
 	enum iwl_plat_pm_mode system_pm_mode;
 	enum iwl_plat_pm_mode runtime_pm_mode;
 	bool suspending;
+	bool dbg_rec_on;
 
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 2cd07247e0a7..263b03b3ea66 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -377,6 +377,9 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 		atomic_set(&mvm->mac80211_queue_stop_count[i], 0);
 
 	set_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	iwl_fw_set_dbg_rec_on(&mvm->fwrt);
+#endif
 	clear_bit(IWL_FWRT_STATUS_WAIT_ALIVE, &mvm->fwrt.status);
 
 	return 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index f9c4c64dee66..0f816761ca45 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -378,6 +378,23 @@ struct iwl_tso_hdr_page {
 	u8 *pos;
 };
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+/**
+ * enum iwl_fw_mon_dbgfs_state - the different states of the monitor_data
+ * debugfs file
+ *
+ * @IWL_FW_MON_DBGFS_STATE_CLOSED: the file is closed.
+ * @IWL_FW_MON_DBGFS_STATE_OPEN: the file is open.
+ * @IWL_FW_MON_DBGFS_STATE_DISABLED: the file is disabled, once this state is
+ *	set the file can no longer be used.
+ */
+enum iwl_fw_mon_dbgfs_state {
+	IWL_FW_MON_DBGFS_STATE_CLOSED,
+	IWL_FW_MON_DBGFS_STATE_OPEN,
+	IWL_FW_MON_DBGFS_STATE_DISABLED,
+};
+#endif
+
 /**
  * enum iwl_shared_irq_flags - level of sharing for irq
  * @IWL_SHARED_IRQ_NON_RX: interrupt vector serves non rx causes.
@@ -414,6 +431,26 @@ struct iwl_self_init_dram {
 	int paging_cnt;
 };
 
+/**
+ * struct cont_rec: continuous recording data structure
+ * @prev_wr_ptr: the last address that was read in monitor_data
+ *	debugfs file
+ * @prev_wrap_cnt: the wrap count that was used during the last read in
+ *	monitor_data debugfs file
+ * @state: the state of monitor_data debugfs file as described
+ *	in &iwl_fw_mon_dbgfs_state enum
+ * @mutex: locked while reading from monitor_data debugfs file
+ */
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+struct cont_rec {
+	u32 prev_wr_ptr;
+	u32 prev_wrap_cnt;
+	u8  state;
+	/* Used to sync monitor_data debugfs file with driver unload flow */
+	struct mutex mutex;
+};
+#endif
+
 /**
  * struct iwl_trans_pcie - PCIe transport specific data
  * @rxq: all the RX queue data
@@ -451,6 +488,9 @@ struct iwl_self_init_dram {
  * @reg_lock: protect hw register access
  * @mutex: to protect stop_device / start_fw / start_hw
  * @cmd_in_flight: true when we have a host command in flight
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+ * @fw_mon_data: fw continuous recording data
+#endif
  * @msix_entries: array of MSI-X entries
  * @msix_enabled: true if managed to enable MSI-X
  * @shared_vec_mask: the type of causes the shared vector handles
@@ -538,6 +578,10 @@ struct iwl_trans_pcie {
 	bool cmd_hold_nic_awake;
 	bool ref_cmd_in_flight;
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	struct cont_rec fw_mon_data;
+#endif
+
 	struct msix_entry msix_entries[IWL_MAX_RX_HW_QUEUES];
 	bool msix_enabled;
 	u8 shared_vec_mask;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 231ec8131ee8..166bacc5ea54 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -71,6 +71,7 @@
 #include <linux/vmalloc.h>
 #include <linux/pm_runtime.h>
 #include <linux/module.h>
+#include <linux/wait.h>
 
 #include "iwl-drv.h"
 #include "iwl-trans.h"
@@ -2709,6 +2710,137 @@ static ssize_t iwl_dbgfs_rfkill_write(struct file *file,
 	return count;
 }
 
+static int iwl_dbgfs_monitor_data_open(struct inode *inode,
+				       struct file *file)
+{
+	struct iwl_trans *trans = inode->i_private;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (!trans->dbg_dest_tlv ||
+	    trans->dbg_dest_tlv->monitor_mode != EXTERNAL_MODE) {
+		IWL_ERR(trans, "Debug destination is not set to DRAM\n");
+		return -ENOENT;
+	}
+
+	if (trans_pcie->fw_mon_data.state != IWL_FW_MON_DBGFS_STATE_CLOSED)
+		return -EBUSY;
+
+	trans_pcie->fw_mon_data.state = IWL_FW_MON_DBGFS_STATE_OPEN;
+	return simple_open(inode, file);
+}
+
+static int iwl_dbgfs_monitor_data_release(struct inode *inode,
+					  struct file *file)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(inode->i_private);
+
+	if (trans_pcie->fw_mon_data.state == IWL_FW_MON_DBGFS_STATE_OPEN)
+		trans_pcie->fw_mon_data.state = IWL_FW_MON_DBGFS_STATE_CLOSED;
+	return 0;
+}
+
+static bool iwl_write_to_user_buf(char __user *user_buf, ssize_t count,
+				  void *buf, ssize_t *size,
+				  ssize_t *bytes_copied)
+{
+	int buf_size_left = count - *bytes_copied;
+
+	buf_size_left = buf_size_left - (buf_size_left % sizeof(u32));
+	if (*size > buf_size_left)
+		*size = buf_size_left;
+
+	*size -= copy_to_user(user_buf, buf, *size);
+	*bytes_copied += *size;
+
+	if (buf_size_left == *size)
+		return true;
+	return false;
+}
+
+static ssize_t iwl_dbgfs_monitor_data_read(struct file *file,
+					   char __user *user_buf,
+					   size_t count, loff_t *ppos)
+{
+	struct iwl_trans *trans = file->private_data;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	void *cpu_addr = (void *)trans->fw_mon[0].block, *curr_buf;
+	struct cont_rec *data = &trans_pcie->fw_mon_data;
+	u32 write_ptr_addr, wrap_cnt_addr, write_ptr, wrap_cnt;
+	ssize_t size, bytes_copied = 0;
+	bool b_full;
+
+	if (trans->dbg_dest_tlv) {
+		write_ptr_addr =
+			le32_to_cpu(trans->dbg_dest_tlv->write_ptr_reg);
+		wrap_cnt_addr = le32_to_cpu(trans->dbg_dest_tlv->wrap_count);
+	} else {
+		write_ptr_addr = MON_BUFF_WRPTR;
+		wrap_cnt_addr = MON_BUFF_CYCLE_CNT;
+	}
+
+	if (unlikely(!trans->dbg_rec_on))
+		return 0;
+
+	mutex_lock(&data->mutex);
+	if (data->state ==
+	    IWL_FW_MON_DBGFS_STATE_DISABLED) {
+		mutex_unlock(&data->mutex);
+		return 0;
+	}
+
+	/* write_ptr position in bytes rather then DW */
+	write_ptr = iwl_read_prph(trans, write_ptr_addr) * sizeof(u32);
+	wrap_cnt = iwl_read_prph(trans, wrap_cnt_addr);
+
+	if (data->prev_wrap_cnt == wrap_cnt) {
+		size = write_ptr - data->prev_wr_ptr;
+		curr_buf = cpu_addr + data->prev_wr_ptr;
+		b_full = iwl_write_to_user_buf(user_buf, count,
+					       curr_buf, &size,
+					       &bytes_copied);
+		data->prev_wr_ptr += size;
+
+	} else if (data->prev_wrap_cnt == wrap_cnt - 1 &&
+		   write_ptr < data->prev_wr_ptr) {
+		size = trans->fw_mon[0].size - data->prev_wr_ptr;
+		curr_buf = cpu_addr + data->prev_wr_ptr;
+		b_full = iwl_write_to_user_buf(user_buf, count,
+					       curr_buf, &size,
+					       &bytes_copied);
+		data->prev_wr_ptr += size;
+
+		if (!b_full) {
+			size = write_ptr;
+			b_full = iwl_write_to_user_buf(user_buf, count,
+						       cpu_addr, &size,
+						       &bytes_copied);
+			data->prev_wr_ptr = size;
+			data->prev_wrap_cnt++;
+		}
+	} else {
+		if (data->prev_wrap_cnt == wrap_cnt - 1 &&
+		    write_ptr > data->prev_wr_ptr)
+			IWL_WARN(trans,
+				 "write pointer passed previous write pointer, start copying from the beginning\n");
+		else if (!unlikely(data->prev_wrap_cnt == 0 &&
+				   data->prev_wr_ptr == 0))
+			IWL_WARN(trans,
+				 "monitor data is out of sync, start copying from the beginning\n");
+
+		size = write_ptr;
+		b_full = iwl_write_to_user_buf(user_buf, count,
+					       cpu_addr, &size,
+					       &bytes_copied);
+		data->prev_wr_ptr = size;
+		data->prev_wrap_cnt = wrap_cnt;
+	}
+
+	mutex_unlock(&data->mutex);
+
+	return bytes_copied;
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_FILE_OPS(rx_queue);
@@ -2716,6 +2848,12 @@ DEBUGFS_READ_FILE_OPS(tx_queue);
 DEBUGFS_WRITE_FILE_OPS(csr);
 DEBUGFS_READ_WRITE_FILE_OPS(rfkill);
 
+static const struct file_operations iwl_dbgfs_monitor_data_ops = {
+	.read = iwl_dbgfs_monitor_data_read,
+	.open = iwl_dbgfs_monitor_data_open,
+	.release = iwl_dbgfs_monitor_data_release,
+};
+
 /* Create the debugfs files and directories */
 int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 {
@@ -2727,12 +2865,23 @@ int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 	DEBUGFS_ADD_FILE(csr, dir, 0200);
 	DEBUGFS_ADD_FILE(fh_reg, dir, 0400);
 	DEBUGFS_ADD_FILE(rfkill, dir, 0600);
+	DEBUGFS_ADD_FILE(monitor_data, dir, 0400);
 	return 0;
 
 err:
 	IWL_ERR(trans, "failed to create the trans debugfs entry\n");
 	return -ENOMEM;
 }
+
+static void iwl_trans_pcie_debugfs_cleanup(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct cont_rec *data = &trans_pcie->fw_mon_data;
+
+	mutex_lock(&data->mutex);
+	data->state = IWL_FW_MON_DBGFS_STATE_DISABLED;
+	mutex_unlock(&data->mutex);
+}
 #endif /*CONFIG_IWLWIFI_DEBUGFS */
 
 static u32 iwl_trans_pcie_get_cmdlen(struct iwl_trans *trans, void *tfd)
@@ -3211,6 +3360,9 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 
 	.freeze_txq_timer = iwl_trans_pcie_freeze_txq_timer,
 	.block_txq_ptrs = iwl_trans_pcie_block_txq_ptrs,
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	.debugfs_cleanup = iwl_trans_pcie_debugfs_cleanup,
+#endif
 };
 
 static const struct iwl_trans_ops trans_ops_pcie_gen2 = {
@@ -3230,6 +3382,9 @@ static const struct iwl_trans_ops trans_ops_pcie_gen2 = {
 	.txq_free = iwl_trans_pcie_dyn_txq_free,
 	.wait_txq_empty = iwl_trans_pcie_wait_txq_empty,
 	.rxq_dma_data = iwl_trans_pcie_rxq_dma_data,
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	.debugfs_cleanup = iwl_trans_pcie_debugfs_cleanup,
+#endif
 };
 
 struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
@@ -3481,6 +3636,11 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	trans->runtime_pm_mode = IWL_PLAT_PM_MODE_DISABLED;
 #endif /* CONFIG_IWLWIFI_PCIE_RTPM */
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	trans_pcie->fw_mon_data.state = IWL_FW_MON_DBGFS_STATE_CLOSED;
+	mutex_init(&trans_pcie->fw_mon_data.mutex);
+#endif
+
 	return trans;
 
 out_free_ict:
-- 
2.19.1

