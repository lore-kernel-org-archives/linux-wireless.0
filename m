Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63426 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbbHRH6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:04 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/26] iwlwifi: mvm: add the ability to trigger only monitor dumps
Date: Tue, 18 Aug 2015 10:57:18 +0300
Message-Id: <1439884656-18146-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_095812_590786_BCFD7FEF)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Change the FW debug trigger tlv to include a monitor only
option. Setting this option to true will cause fw dump triggers
to only collect monitor data and skip other dumps such as
SMEM, SRAM, CSR, PRPH, etc.
This option is used when accessing the different parts of the
firmware memory is not wanted and can cause unwanted behavior
like when debugging TX latency.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h  |   3 +
 drivers/net/wireless/iwlwifi/iwl-trans.h    |   9 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c       |  19 ++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  36 +++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   6 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c      |   3 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c   | 217 ++++++++++++++++------------
 8 files changed, 177 insertions(+), 118 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index d1c5b90..75809ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -498,10 +498,13 @@ struct iwl_fw_dbg_conf_hcmd {
  *
  * @IWL_FW_DBG_TRIGGER_START: when trigger occurs re-conf the dbg mechanism
  * @IWL_FW_DBG_TRIGGER_STOP: when trigger occurs pull the dbg data
+ * @IWL_FW_DBG_TRIGGER_MONITOR_ONLY: when trigger occurs trigger is set to
+ *	collect only monitor data
  */
 enum iwl_fw_dbg_trigger_mode {
 	IWL_FW_DBG_TRIGGER_START = BIT(0),
 	IWL_FW_DBG_TRIGGER_STOP = BIT(1),
+	IWL_FW_DBG_TRIGGER_MONITOR_ONLY = BIT(2),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index e68497a..151e3de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -608,7 +608,9 @@ struct iwl_trans_ops {
 	int  (*suspend)(struct iwl_trans *trans);
 	void (*resume)(struct iwl_trans *trans);
 
-	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans);
+	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans,
+						 struct iwl_fw_dbg_trigger_tlv
+						 *trigger);
 };
 
 /**
@@ -832,11 +834,12 @@ static inline void iwl_trans_resume(struct iwl_trans *trans)
 }
 
 static inline struct iwl_trans_dump_data *
-iwl_trans_dump_data(struct iwl_trans *trans)
+iwl_trans_dump_data(struct iwl_trans *trans,
+		    struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	if (!trans->ops->dump_data)
 		return NULL;
-	return trans->ops->dump_data(trans);
+	return trans->ops->dump_data(trans, trigger);
 }
 
 static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index ffb4b5c..17d7a05 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -974,7 +974,7 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	iwl_mvm_fw_dbg_collect(mvm, FW_DBG_TRIGGER_USER, NULL, 0, 0);
+	iwl_mvm_fw_dbg_collect(mvm, FW_DBG_TRIGGER_USER, NULL, 0, NULL);
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_PRPH_WRITE);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index e65a653..aff5bbf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -735,8 +735,13 @@ static void iwl_mvm_get_shared_mem_conf(struct iwl_mvm *mvm)
 
 int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
 				struct iwl_mvm_dump_desc *desc,
-				unsigned int delay)
+				struct iwl_fw_dbg_trigger_tlv *trigger)
 {
+	unsigned int delay = 0;
+
+	if (trigger)
+		delay = msecs_to_jiffies(le32_to_cpu(trigger->stop_delay));
+
 	if (test_and_set_bit(IWL_MVM_STATUS_DUMPING_FW_LOG, &mvm->status))
 		return -EBUSY;
 
@@ -747,6 +752,7 @@ int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
 		 le32_to_cpu(desc->trig_desc.type));
 
 	mvm->fw_dump_desc = desc;
+	mvm->fw_dump_trig = trigger;
 
 	queue_delayed_work(system_wq, &mvm->fw_dump_wk, delay);
 
@@ -754,7 +760,8 @@ int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
 }
 
 int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
-			   const char *str, size_t len, unsigned int delay)
+			   const char *str, size_t len,
+			   struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	struct iwl_mvm_dump_desc *desc;
 
@@ -766,14 +773,13 @@ int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
 	desc->trig_desc.type = cpu_to_le32(trig);
 	memcpy(desc->trig_desc.data, str, len);
 
-	return iwl_mvm_fw_dbg_collect_desc(mvm, desc, delay);
+	return iwl_mvm_fw_dbg_collect_desc(mvm, desc, trigger);
 }
 
 int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 				struct iwl_fw_dbg_trigger_tlv *trigger,
 				const char *fmt, ...)
 {
-	unsigned int delay = msecs_to_jiffies(le32_to_cpu(trigger->stop_delay));
 	u16 occurrences = le16_to_cpu(trigger->occurrences);
 	int ret, len = 0;
 	char buf[64];
@@ -797,8 +803,9 @@ int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 		len = strlen(buf) + 1;
 	}
 
-	ret = iwl_mvm_fw_dbg_collect(mvm, le32_to_cpu(trigger->id), buf,
-				     len, delay);
+	ret = iwl_mvm_fw_dbg_collect(mvm, le32_to_cpu(trigger->id), buf, len,
+				     trigger);
+
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 9e64184..08dd674 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1124,9 +1124,14 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	u32 file_len, fifo_data_len = 0;
 	u32 smem_len = mvm->cfg->smem_len;
 	u32 sram2_len = mvm->cfg->dccm2_len;
+	bool monitor_dump_only = false;
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (mvm->fw_dump_trig &&
+	    mvm->fw_dump_trig->mode & IWL_FW_DBG_TRIGGER_MONITOR_ONLY)
+		monitor_dump_only = true;
+
 	fw_error_dump = kzalloc(sizeof(*fw_error_dump), GFP_KERNEL);
 	if (!fw_error_dump)
 		return;
@@ -1178,6 +1183,20 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		   fifo_data_len +
 		   sizeof(*dump_info);
 
+	/* Make room for the SMEM, if it exists */
+	if (smem_len)
+		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + smem_len;
+
+	/* Make room for the secondary SRAM, if it exists */
+	if (sram2_len)
+		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + sram2_len;
+
+	/* If we only want a monitor dump, reset the file length */
+	if (monitor_dump_only) {
+		file_len = sizeof(*dump_file) + sizeof(*dump_data) +
+			   sizeof(*dump_info);
+	}
+
 	/*
 	 * In 8000 HW family B-step include the ICCM (which resides separately)
 	 */
@@ -1190,14 +1209,6 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		file_len += sizeof(*dump_data) + sizeof(*dump_trig) +
 			    mvm->fw_dump_desc->len;
 
-	/* Make room for the SMEM, if it exists */
-	if (smem_len)
-		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + smem_len;
-
-	/* Make room for the secondary SRAM, if it exists */
-	if (sram2_len)
-		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + sram2_len;
-
 	dump_file = vzalloc(file_len);
 	if (!dump_file) {
 		kfree(fw_error_dump);
@@ -1243,6 +1254,10 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
+	/* In case we only want monitor dump, skip to dump trasport data */
+	if (monitor_dump_only)
+		goto dump_trans_data;
+
 	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 	dump_data->len = cpu_to_le32(sram_len + sizeof(*dump_mem));
 	dump_mem = (void *)dump_data->data;
@@ -1286,7 +1301,9 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 					 dump_mem->data, IWL8260_ICCM_LEN);
 	}
 
-	fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans);
+dump_trans_data:
+	fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans,
+						       mvm->fw_dump_trig);
 	fw_error_dump->op_mode_len = file_len;
 	if (fw_error_dump->trans_ptr)
 		file_len += fw_error_dump->trans_ptr->len;
@@ -1295,6 +1312,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	dev_coredumpm(mvm->trans->dev, THIS_MODULE, fw_error_dump, 0,
 		      GFP_KERNEL, iwl_mvm_read_coredump, iwl_mvm_free_coredump);
 
+	mvm->fw_dump_trig = NULL;
 	clear_bit(IWL_MVM_STATUS_DUMPING_FW_LOG, &mvm->status);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index fdf401b..2b2e299 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -708,6 +708,7 @@ struct iwl_mvm {
 	u8 fw_dbg_conf;
 	struct delayed_work fw_dump_wk;
 	struct iwl_mvm_dump_desc *fw_dump_desc;
+	struct iwl_fw_dbg_trigger_tlv *fw_dump_trig;
 
 #ifdef CONFIG_IWLWIFI_LEDS
 	struct led_classdev led;
@@ -1443,10 +1444,11 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
 
 int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 id);
 int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
-			   const char *str, size_t len, unsigned int delay);
+			   const char *str, size_t len,
+			   struct iwl_fw_dbg_trigger_tlv *trigger);
 int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
 				struct iwl_mvm_dump_desc *desc,
-				unsigned int delay);
+				struct iwl_fw_dbg_trigger_tlv *trigger);
 void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm);
 int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 				struct iwl_fw_dbg_trigger_tlv *trigger,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index ef09a05..4873112 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -914,7 +914,8 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	 * can't recover this since we're already half suspended.
 	 */
 	if (!mvm->restart_fw && fw_error) {
-		iwl_mvm_fw_dbg_collect_desc(mvm, &iwl_mvm_dump_desc_assert, 0);
+		iwl_mvm_fw_dbg_collect_desc(mvm, &iwl_mvm_dump_desc_assert,
+					    NULL);
 	} else if (test_and_set_bit(IWL_MVM_STATUS_IN_HW_RESTART,
 				    &mvm->status)) {
 		struct iwl_mvm_reprobe *reprobe;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index fb55810..6a3ee04 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2385,8 +2385,87 @@ iwl_trans_pci_dump_marbh_monitor(struct iwl_trans *trans,
 	return monitor_len;
 }
 
-static
-struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
+static u32
+iwl_trans_pcie_dump_monitor(struct iwl_trans *trans,
+			    struct iwl_fw_error_dump_data **data,
+			    u32 monitor_len)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	u32 len = 0;
+
+	if ((trans_pcie->fw_mon_page &&
+	     trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) ||
+	    trans->dbg_dest_tlv) {
+		struct iwl_fw_error_dump_fw_mon *fw_mon_data;
+		u32 base, write_ptr, wrap_cnt;
+
+		/* If there was a dest TLV - use the values from there */
+		if (trans->dbg_dest_tlv) {
+			write_ptr =
+				le32_to_cpu(trans->dbg_dest_tlv->write_ptr_reg);
+			wrap_cnt = le32_to_cpu(trans->dbg_dest_tlv->wrap_count);
+			base = le32_to_cpu(trans->dbg_dest_tlv->base_reg);
+		} else {
+			base = MON_BUFF_BASE_ADDR;
+			write_ptr = MON_BUFF_WRPTR;
+			wrap_cnt = MON_BUFF_CYCLE_CNT;
+		}
+
+		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_FW_MONITOR);
+		fw_mon_data = (void *)(*data)->data;
+		fw_mon_data->fw_mon_wr_ptr =
+			cpu_to_le32(iwl_read_prph(trans, write_ptr));
+		fw_mon_data->fw_mon_cycle_cnt =
+			cpu_to_le32(iwl_read_prph(trans, wrap_cnt));
+		fw_mon_data->fw_mon_base_ptr =
+			cpu_to_le32(iwl_read_prph(trans, base));
+
+		len += sizeof(**data) + sizeof(*fw_mon_data);
+		if (trans_pcie->fw_mon_page) {
+			/*
+			 * The firmware is now asserted, it won't write anything
+			 * to the buffer. CPU can take ownership to fetch the
+			 * data. The buffer will be handed back to the device
+			 * before the firmware will be restarted.
+			 */
+			dma_sync_single_for_cpu(trans->dev,
+						trans_pcie->fw_mon_phys,
+						trans_pcie->fw_mon_size,
+						DMA_FROM_DEVICE);
+			memcpy(fw_mon_data->data,
+			       page_address(trans_pcie->fw_mon_page),
+			       trans_pcie->fw_mon_size);
+
+			monitor_len = trans_pcie->fw_mon_size;
+		} else if (trans->dbg_dest_tlv->monitor_mode == SMEM_MODE) {
+			/*
+			 * Update pointers to reflect actual values after
+			 * shifting
+			 */
+			base = iwl_read_prph(trans, base) <<
+			       trans->dbg_dest_tlv->base_shift;
+			iwl_trans_read_mem(trans, base, fw_mon_data->data,
+					   monitor_len / sizeof(u32));
+		} else if (trans->dbg_dest_tlv->monitor_mode == MARBH_MODE) {
+			monitor_len =
+				iwl_trans_pci_dump_marbh_monitor(trans,
+								 fw_mon_data,
+								 monitor_len);
+		} else {
+			/* Didn't match anything - output no monitor data */
+			monitor_len = 0;
+		}
+
+		len += monitor_len;
+		(*data)->len = cpu_to_le32(monitor_len + sizeof(*fw_mon_data));
+	}
+
+	return len;
+}
+
+static struct iwl_trans_dump_data
+*iwl_trans_pcie_dump_data(struct iwl_trans *trans,
+			  struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_fw_error_dump_data *data;
@@ -2405,33 +2484,6 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 	len += sizeof(*data) +
 		cmdq->q.n_window * (sizeof(*txcmd) + TFD_MAX_PAYLOAD_SIZE);
 
-	/* CSR registers */
-	len += sizeof(*data) + IWL_CSR_TO_DUMP;
-
-	/* PRPH registers */
-	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
-		/* The range includes both boundaries */
-		int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
-			iwl_prph_dump_addr[i].start + 4;
-
-		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_prph) +
-			num_bytes_in_chunk;
-	}
-
-	/* FH registers */
-	len += sizeof(*data) + (FH_MEM_UPPER_BOUND - FH_MEM_LOWER_BOUND);
-
-	if (dump_rbs) {
-		/* RBs */
-		num_rbs = le16_to_cpu(ACCESS_ONCE(
-				      trans_pcie->rxq.rb_stts->closed_rb_num))
-				      & 0x0FFF;
-		num_rbs = (num_rbs - trans_pcie->rxq.read) & RX_QUEUE_MASK;
-		len += num_rbs * (sizeof(*data) +
-				  sizeof(struct iwl_fw_error_dump_rb) +
-				  (PAGE_SIZE << trans_pcie->rx_page_order));
-	}
-
 	/* FW monitor */
 	if (trans_pcie->fw_mon_page) {
 		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_fw_mon) +
@@ -2459,6 +2511,45 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 		monitor_len = 0;
 	}
 
+	if (trigger && (trigger->mode & IWL_FW_DBG_TRIGGER_MONITOR_ONLY)) {
+		dump_data = vzalloc(len);
+		if (!dump_data)
+			return NULL;
+
+		data = (void *)dump_data->data;
+		len = iwl_trans_pcie_dump_monitor(trans, &data, monitor_len);
+		dump_data->len = len;
+
+		return dump_data;
+	}
+
+	/* CSR registers */
+	len += sizeof(*data) + IWL_CSR_TO_DUMP;
+
+	/* PRPH registers */
+	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
+		/* The range includes both boundaries */
+		int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
+			iwl_prph_dump_addr[i].start + 4;
+
+		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_prph) +
+		       num_bytes_in_chunk;
+	}
+
+	/* FH registers */
+	len += sizeof(*data) + (FH_MEM_UPPER_BOUND - FH_MEM_LOWER_BOUND);
+
+	if (dump_rbs) {
+		/* RBs */
+		num_rbs = le16_to_cpu(ACCESS_ONCE(
+				      trans_pcie->rxq.rb_stts->closed_rb_num))
+				      & 0x0FFF;
+		num_rbs = (num_rbs - trans_pcie->rxq.read) & RX_QUEUE_MASK;
+		len += num_rbs * (sizeof(*data) +
+				  sizeof(struct iwl_fw_error_dump_rb) +
+				  (PAGE_SIZE << trans_pcie->rx_page_order));
+	}
+
 	dump_data = vzalloc(len);
 	if (!dump_data)
 		return NULL;
@@ -2498,73 +2589,7 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 	if (dump_rbs)
 		len += iwl_trans_pcie_dump_rbs(trans, &data, num_rbs);
 
-	/* data is already pointing to the next section */
-	if ((trans_pcie->fw_mon_page &&
-	     trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) ||
-	    trans->dbg_dest_tlv) {
-		struct iwl_fw_error_dump_fw_mon *fw_mon_data;
-		u32 base, write_ptr, wrap_cnt;
-
-		/* If there was a dest TLV - use the values from there */
-		if (trans->dbg_dest_tlv) {
-			write_ptr =
-				le32_to_cpu(trans->dbg_dest_tlv->write_ptr_reg);
-			wrap_cnt = le32_to_cpu(trans->dbg_dest_tlv->wrap_count);
-			base = le32_to_cpu(trans->dbg_dest_tlv->base_reg);
-		} else {
-			base = MON_BUFF_BASE_ADDR;
-			write_ptr = MON_BUFF_WRPTR;
-			wrap_cnt = MON_BUFF_CYCLE_CNT;
-		}
-
-		data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_FW_MONITOR);
-		fw_mon_data = (void *)data->data;
-		fw_mon_data->fw_mon_wr_ptr =
-			cpu_to_le32(iwl_read_prph(trans, write_ptr));
-		fw_mon_data->fw_mon_cycle_cnt =
-			cpu_to_le32(iwl_read_prph(trans, wrap_cnt));
-		fw_mon_data->fw_mon_base_ptr =
-			cpu_to_le32(iwl_read_prph(trans, base));
-
-		len += sizeof(*data) + sizeof(*fw_mon_data);
-		if (trans_pcie->fw_mon_page) {
-			/*
-			 * The firmware is now asserted, it won't write anything
-			 * to the buffer. CPU can take ownership to fetch the
-			 * data. The buffer will be handed back to the device
-			 * before the firmware will be restarted.
-			 */
-			dma_sync_single_for_cpu(trans->dev,
-						trans_pcie->fw_mon_phys,
-						trans_pcie->fw_mon_size,
-						DMA_FROM_DEVICE);
-			memcpy(fw_mon_data->data,
-			       page_address(trans_pcie->fw_mon_page),
-			       trans_pcie->fw_mon_size);
-
-			monitor_len = trans_pcie->fw_mon_size;
-		} else if (trans->dbg_dest_tlv->monitor_mode == SMEM_MODE) {
-			/*
-			 * Update pointers to reflect actual values after
-			 * shifting
-			 */
-			base = iwl_read_prph(trans, base) <<
-			       trans->dbg_dest_tlv->base_shift;
-			iwl_trans_read_mem(trans, base, fw_mon_data->data,
-					   monitor_len / sizeof(u32));
-		} else if (trans->dbg_dest_tlv->monitor_mode == MARBH_MODE) {
-			monitor_len =
-				iwl_trans_pci_dump_marbh_monitor(trans,
-								 fw_mon_data,
-								 monitor_len);
-		} else {
-			/* Didn't match anything - output no monitor data */
-			monitor_len = 0;
-		}
-
-		len += monitor_len;
-		data->len = cpu_to_le32(monitor_len + sizeof(*fw_mon_data));
-	}
+	len += iwl_trans_pcie_dump_monitor(trans, &data, monitor_len);
 
 	dump_data->len = len;
 
-- 
2.1.4

