Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6866B3AFAF8
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077691; cv=none; b=Ne9btwsJi4X+eTaXd4GC2LA5n4SUgwFBcKT40NNTe4NVTRBBeXNO4jCTscm2TY++eMbOiExOcsrt9BWwVN5/Y8SD1d9LAA4ld3KDGY285fqRHWXEB+B8VZEVqLwchSUM7XQeu4RRAazKkF3S+ox5gwtvzj6qyjy4PU7EGbkBpgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077691; c=relaxed/simple;
	bh=MI6X3vdyfbEoNUXxKECDumTrCKNQjTD/ST5HYRWEwnE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NmK96/2S8TdMTu93twfqdvhxBwXX+hFuUmRlJ3iqPiT4lhDBWGPqVomAi7c4pIZCxE7Rix7zVugOQ7GlrQWi+1pw33K+r56F7qGsg1hMmpMCRx8nW1+nXw6RRXtLkGbeCnyfKbEi8kct6nLQHTOIs9ZVd131Os68lEZMjE39rQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PPLRFcFn; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PPLRFcFn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077689; x=1821613689;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MI6X3vdyfbEoNUXxKECDumTrCKNQjTD/ST5HYRWEwnE=;
  b=PPLRFcFnUS8J+n6nylwqZjbj+GsJP8l8KqSPCxWYp/3/jGi4cVhauueL
   a4qCn065hCEICIxwLSBTZts6bNvaRxMev3moQZeZnhTg9KXdaOM8+XDdg
   lREGZs+hkwLlSucWhfsIFIDKvgtjk66bdMaLEEXYwqiyAnl5YvlAIaife
   CTizRKLCj0vd3+qstR5A0/pviqqjfmuDmQRoJr4BW7cL3+z81+f3mle72
   ryjwBxR7e2pSrmab1gtvTwpql0Yu7sUe5RHIT/X+7SAvnGr6i3St0h0su
   kre6+/DLD9A+1PEu7eUArsi9S2NUFs+5vSs6hv6QJ/Tw1t5vkjjS57oKZ
   w==;
X-CSE-ConnectionGUID: 3nD+tUJvQd+m3VLXclCmkA==
X-CSE-MsgGUID: bo8OW+pOQfmkNTAPLeeyfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170510"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170510"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:08 -0700
X-CSE-ConnectionGUID: AJ12CY+iQci965tpdETs8Q==
X-CSE-MsgGUID: 6G/wdzSyTM+WZ+8fLjKZYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275344"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:07 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 03/15] wifi: iwlwifi: pcie: remove monitor_data debugfs file
Date: Tue, 22 Sep 2026 14:49:50 +0300
Message-Id: <20260922144819.9e5d30a9caa4.Idf62277c82970daf49d3d4d7b7a021595672eeed@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
References: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The monitor_data debugfs file exposed the DRAM firmware monitor buffer
to userspace. Remove it along with all the code and data that only
existed to support it: the read/open/release handlers and the
iwl_write_to_user_buf() helper, the cont_rec state tracking structure
and iwl_fw_mon_dbgfs_state enum, the fw_mon_data field and its
initialization, and the now-unused debugfs cleanup path
(iwl_trans_pcie_debugfs_cleanup() and iwl_trans_debugfs_cleanup()).

This relied on old firmware monitor format.

Assisted-By: GitHubCopilot:Claude Opus 4.8
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |   2 -
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |   7 -
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   4 -
 .../intel/iwlwifi/pcie/gen1_2/internal.h      |  43 -----
 .../intel/iwlwifi/pcie/gen1_2/trans.c         | 153 ------------------
 5 files changed, 209 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 7f1515dfc5bf..ef9d50ee3704 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -2039,8 +2039,6 @@ void iwl_drv_stop(struct iwl_drv *drv)
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	iwl_trans_debugfs_cleanup(drv->trans);
-
 	debugfs_remove_recursive(drv->dbgfs_drv);
 #endif
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 73aae1125042..a1545e9d2cd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -746,13 +746,6 @@ void iwl_trans_txq_set_shared_mode(struct iwl_trans *trans,
 }
 IWL_EXPORT_SYMBOL(iwl_trans_txq_set_shared_mode);
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-void iwl_trans_debugfs_cleanup(struct iwl_trans *trans)
-{
-	iwl_trans_pcie_debugfs_cleanup(trans);
-}
-#endif
-
 void iwl_trans_set_q_ptrs(struct iwl_trans *trans, int queue, int ptr)
 {
 	if (WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index c581cc8f5bcb..dfad839dd2e6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -934,10 +934,6 @@ int iwl_trans_read_mem_no_grab(struct iwl_trans *trans, u32 addr,
 int iwl_trans_read_config32(struct iwl_trans *trans, u32 ofs,
 			    u32 *val);
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-void iwl_trans_debugfs_cleanup(struct iwl_trans *trans);
-#endif
-
 #define iwl_trans_read_mem_bytes(trans, addr, buf, bufsize)	\
 	({							\
 		if (__builtin_constant_p(bufsize))		\
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
index d84c7c1efee1..f0e70b0fedfe 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
@@ -206,23 +206,6 @@ static inline u16 iwl_get_closed_rb_stts(struct iwl_trans *trans,
 	}
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-/**
- * enum iwl_fw_mon_dbgfs_state - the different states of the monitor_data
- * debugfs file
- *
- * @IWL_FW_MON_DBGFS_STATE_CLOSED: the file is closed.
- * @IWL_FW_MON_DBGFS_STATE_OPEN: the file is open.
- * @IWL_FW_MON_DBGFS_STATE_DISABLED: the file is disabled, once this state is
- *	set the file can no longer be used.
- */
-enum iwl_fw_mon_dbgfs_state {
-	IWL_FW_MON_DBGFS_STATE_CLOSED,
-	IWL_FW_MON_DBGFS_STATE_OPEN,
-	IWL_FW_MON_DBGFS_STATE_DISABLED,
-};
-#endif
-
 /**
  * enum iwl_shared_irq_flags - level of sharing for irq
  * @IWL_SHARED_IRQ_NON_RX: interrupt vector serves non rx causes.
@@ -245,26 +228,6 @@ enum iwl_image_response_code {
 	IWL_IMAGE_RESP_FAIL		= 2,
 };
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-/**
- * struct cont_rec: continuous recording data structure
- * @prev_wr_ptr: the last address that was read in monitor_data
- *	debugfs file
- * @prev_wrap_cnt: the wrap count that was used during the last read in
- *	monitor_data debugfs file
- * @state: the state of monitor_data debugfs file as described
- *	in &iwl_fw_mon_dbgfs_state enum
- * @mutex: locked while reading from monitor_data debugfs file
- */
-struct cont_rec {
-	u32 prev_wr_ptr;
-	u32 prev_wrap_cnt;
-	u8  state;
-	/* Used to sync monitor_data debugfs file with driver unload flow */
-	struct mutex mutex;
-};
-#endif
-
 enum iwl_pcie_fw_reset_state {
 	FW_RESET_IDLE,
 	FW_RESET_REQUESTED,
@@ -451,7 +414,6 @@ struct iwl_pcie_txqs {
  * @rx_buf_bytes: RX buffer (RB) size in bytes
  * @reg_lock: protect hw register access
  * @mutex: to protect stop_device / start_fw / start_hw
- * @fw_mon_data: fw continuous recording data
  * @cmd_hold_nic_awake: indicates NIC is held awake for APMG workaround
  *	during commands in flight
  * @msix_entries: array of MSI-X entries
@@ -577,10 +539,6 @@ struct iwl_trans_pcie {
 	spinlock_t reg_lock;
 	bool cmd_hold_nic_awake;
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	struct cont_rec fw_mon_data;
-#endif
-
 	struct msix_entry msix_entries[IWL_MAX_RX_HW_QUEUES];
 	bool msix_enabled;
 	u8 shared_vec_mask;
@@ -1167,7 +1125,6 @@ void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state, bool from_irq);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 void iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans);
-void iwl_trans_pcie_debugfs_cleanup(struct iwl_trans *trans);
 #else
 static inline void iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans) { }
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index 28b276c65952..71c4746c61a6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -3073,137 +3073,6 @@ static ssize_t iwl_dbgfs_rfkill_write(struct file *file,
 	return count;
 }
 
-static int iwl_dbgfs_monitor_data_open(struct inode *inode,
-				       struct file *file)
-{
-	struct iwl_trans *trans = inode->i_private;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (!trans->dbg.dest_tlv ||
-	    trans->dbg.dest_tlv->monitor_mode != EXTERNAL_MODE) {
-		IWL_ERR(trans, "Debug destination is not set to DRAM\n");
-		return -ENOENT;
-	}
-
-	if (trans_pcie->fw_mon_data.state != IWL_FW_MON_DBGFS_STATE_CLOSED)
-		return -EBUSY;
-
-	trans_pcie->fw_mon_data.state = IWL_FW_MON_DBGFS_STATE_OPEN;
-	return simple_open(inode, file);
-}
-
-static int iwl_dbgfs_monitor_data_release(struct inode *inode,
-					  struct file *file)
-{
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(inode->i_private);
-
-	if (trans_pcie->fw_mon_data.state == IWL_FW_MON_DBGFS_STATE_OPEN)
-		trans_pcie->fw_mon_data.state = IWL_FW_MON_DBGFS_STATE_CLOSED;
-	return 0;
-}
-
-static bool iwl_write_to_user_buf(char __user *user_buf, ssize_t count,
-				  void *buf, ssize_t *size,
-				  ssize_t *bytes_copied)
-{
-	ssize_t buf_size_left = count - *bytes_copied;
-
-	buf_size_left = buf_size_left - (buf_size_left % sizeof(u32));
-	if (*size > buf_size_left)
-		*size = buf_size_left;
-
-	*size -= copy_to_user(user_buf, buf, *size);
-	*bytes_copied += *size;
-
-	if (buf_size_left == *size)
-		return true;
-	return false;
-}
-
-static ssize_t iwl_dbgfs_monitor_data_read(struct file *file,
-					   char __user *user_buf,
-					   size_t count, loff_t *ppos)
-{
-	struct iwl_trans *trans = file->private_data;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u8 *cpu_addr = (void *)trans->dbg.fw_mon.block, *curr_buf;
-	struct cont_rec *data = &trans_pcie->fw_mon_data;
-	u32 write_ptr_addr, wrap_cnt_addr, write_ptr, wrap_cnt;
-	ssize_t size, bytes_copied = 0;
-	bool b_full;
-
-	if (trans->dbg.dest_tlv) {
-		write_ptr_addr =
-			le32_to_cpu(trans->dbg.dest_tlv->write_ptr_reg);
-		wrap_cnt_addr = le32_to_cpu(trans->dbg.dest_tlv->wrap_count);
-	} else {
-		write_ptr_addr = MON_BUFF_WRPTR;
-		wrap_cnt_addr = MON_BUFF_CYCLE_CNT;
-	}
-
-	if (unlikely(!trans->dbg.rec_on))
-		return 0;
-
-	mutex_lock(&data->mutex);
-	if (data->state ==
-	    IWL_FW_MON_DBGFS_STATE_DISABLED) {
-		mutex_unlock(&data->mutex);
-		return 0;
-	}
-
-	/* write_ptr position in bytes rather then DW */
-	write_ptr = iwl_read_prph(trans, write_ptr_addr) * sizeof(u32);
-	wrap_cnt = iwl_read_prph(trans, wrap_cnt_addr);
-
-	if (data->prev_wrap_cnt == wrap_cnt) {
-		size = write_ptr - data->prev_wr_ptr;
-		curr_buf = cpu_addr + data->prev_wr_ptr;
-		b_full = iwl_write_to_user_buf(user_buf, count,
-					       curr_buf, &size,
-					       &bytes_copied);
-		data->prev_wr_ptr += size;
-
-	} else if (data->prev_wrap_cnt == wrap_cnt - 1 &&
-		   write_ptr < data->prev_wr_ptr) {
-		size = trans->dbg.fw_mon.size - data->prev_wr_ptr;
-		curr_buf = cpu_addr + data->prev_wr_ptr;
-		b_full = iwl_write_to_user_buf(user_buf, count,
-					       curr_buf, &size,
-					       &bytes_copied);
-		data->prev_wr_ptr += size;
-
-		if (!b_full) {
-			size = write_ptr;
-			b_full = iwl_write_to_user_buf(user_buf, count,
-						       cpu_addr, &size,
-						       &bytes_copied);
-			data->prev_wr_ptr = size;
-			data->prev_wrap_cnt++;
-		}
-	} else {
-		if (data->prev_wrap_cnt == wrap_cnt - 1 &&
-		    write_ptr > data->prev_wr_ptr)
-			IWL_WARN(trans,
-				 "write pointer passed previous write pointer, start copying from the beginning\n");
-		else if (!unlikely(data->prev_wrap_cnt == 0 &&
-				   data->prev_wr_ptr == 0))
-			IWL_WARN(trans,
-				 "monitor data is out of sync, start copying from the beginning\n");
-
-		size = write_ptr;
-		b_full = iwl_write_to_user_buf(user_buf, count,
-					       cpu_addr, &size,
-					       &bytes_copied);
-		data->prev_wr_ptr = size;
-		data->prev_wrap_cnt = wrap_cnt;
-	}
-
-	mutex_unlock(&data->mutex);
-
-	return bytes_copied;
-}
-
 static ssize_t iwl_dbgfs_rf_read(struct file *file,
 				 char __user *user_buf,
 				 size_t count, loff_t *ppos)
@@ -3279,12 +3148,6 @@ static const struct file_operations iwl_dbgfs_tx_queue_ops = {
 	.release = seq_release_private,
 };
 
-static const struct file_operations iwl_dbgfs_monitor_data_ops = {
-	.read = iwl_dbgfs_monitor_data_read,
-	.open = iwl_dbgfs_monitor_data_open,
-	.release = iwl_dbgfs_monitor_data_release,
-};
-
 /* Create the debugfs files and directories */
 void iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 {
@@ -3296,20 +3159,9 @@ void iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 	DEBUGFS_ADD_FILE(csr, dir, 0200);
 	DEBUGFS_ADD_FILE(fh_reg, dir, 0400);
 	DEBUGFS_ADD_FILE(rfkill, dir, 0600);
-	DEBUGFS_ADD_FILE(monitor_data, dir, 0400);
 	DEBUGFS_ADD_FILE(rf, dir, 0400);
 	DEBUGFS_ADD_FILE(reset, dir, 0200);
 }
-
-void iwl_trans_pcie_debugfs_cleanup(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct cont_rec *data = &trans_pcie->fw_mon_data;
-
-	mutex_lock(&data->mutex);
-	data->state = IWL_FW_MON_DBGFS_STATE_DISABLED;
-	mutex_unlock(&data->mutex);
-}
 #endif /*CONFIG_IWLWIFI_DEBUGFS */
 
 static u32 iwl_trans_pcie_get_cmdlen(struct iwl_trans *trans, void *tfd)
@@ -3974,11 +3826,6 @@ iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	 }
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	trans_pcie->fw_mon_data.state = IWL_FW_MON_DBGFS_STATE_CLOSED;
-	mutex_init(&trans_pcie->fw_mon_data.mutex);
-#endif
-
 	iwl_dbg_tlv_init(trans);
 
 	return trans;
-- 
2.34.1

