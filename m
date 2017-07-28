Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40850 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752059AbdG1OYF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:24:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:17 +0300
Message-Id: <20170728142337.19183-5-luca@coelho.fi> (sfid-20170728_162413_752298_E9AACE71)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 04/24] iwlwifi: refactor firmware debug code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Split out the firmware debug code to be more general, so that it
can be used by different subdrivers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Makefile        |   2 +-
 .../intel/iwlwifi/{mvm/fw-dbg.c => fw/dbg.c}       | 438 ++++++++++++---------
 .../intel/iwlwifi/{mvm/fw-dbg.h => fw/dbg.h}       | 125 ++++--
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |  75 ++++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |  42 +-
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  72 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  40 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  99 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   7 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   6 +-
 18 files changed, 563 insertions(+), 413 deletions(-)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-dbg.c => fw/dbg.c} (69%)
 rename drivers/net/wireless/intel/iwlwifi/{mvm/fw-dbg.h => fw/dbg.h} (59%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/init.c

diff --git a/drivers/net/wireless/intel/iwlwifi/Makefile b/drivers/net/wireless/intel/iwlwifi/Makefile
index ddc2bfb501c1..fd12b7394c5c 100644
--- a/drivers/net/wireless/intel/iwlwifi/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/Makefile
@@ -11,7 +11,7 @@ iwlwifi-$(CONFIG_IWLDVM) += cfg/1000.o cfg/2000.o cfg/5000.o cfg/6000.o
 iwlwifi-$(CONFIG_IWLMVM) += cfg/7000.o cfg/8000.o cfg/9000.o cfg/a000.o
 iwlwifi-objs		+= iwl-trans.o
 iwlwifi-objs		+= fw/notif-wait.o
-iwlwifi-$(CONFIG_IWLMVM) += fw/paging.o fw/smem.o
+iwlwifi-$(CONFIG_IWLMVM) += fw/paging.o fw/smem.o fw/init.o fw/dbg.o
 
 iwlwifi-objs += $(iwlwifi-m)
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
similarity index 69%
rename from drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
rename to drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 0c12e604f22b..77245fcba996 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -63,22 +63,37 @@
  *
  *****************************************************************************/
 #include <linux/devcoredump.h>
-
-#include "fw-dbg.h"
+#include "iwl-drv.h"
+#include "runtime.h"
+#include "dbg.h"
 #include "iwl-io.h"
-#include "mvm.h"
 #include "iwl-prph.h"
 #include "iwl-csr.h"
 
+/**
+ * struct iwl_fw_dump_ptrs - set of pointers needed for the fw-error-dump
+ *
+ * @fwrt_ptr: pointer to the buffer coming from fwrt
+ * @trans_ptr: pointer to struct %iwl_trans_dump_data which contains the
+ *	transport's data.
+ * @trans_len: length of the valid data in trans_ptr
+ * @fwrt_len: length of the valid data in fwrt_ptr
+ */
+struct iwl_fw_dump_ptrs {
+	struct iwl_trans_dump_data *trans_ptr;
+	void *fwrt_ptr;
+	u32 fwrt_len;
+};
+
 #define RADIO_REG_MAX_READ 0x2ad
-static void iwl_mvm_read_radio_reg(struct iwl_mvm *mvm,
-				   struct iwl_fw_error_dump_data **dump_data)
+static void iwl_read_radio_regs(struct iwl_fw_runtime *fwrt,
+				struct iwl_fw_error_dump_data **dump_data)
 {
 	u8 *pos = (void *)(*dump_data)->data;
 	unsigned long flags;
 	int i;
 
-	if (!iwl_trans_grab_nic_access(mvm->trans, &flags))
+	if (!iwl_trans_grab_nic_access(fwrt->trans, &flags))
 		return;
 
 	(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_RADIO_REG);
@@ -88,20 +103,20 @@ static void iwl_mvm_read_radio_reg(struct iwl_mvm *mvm,
 		u32 rd_cmd = RADIO_RSP_RD_CMD;
 
 		rd_cmd |= i << RADIO_RSP_ADDR_POS;
-		iwl_write_prph_no_grab(mvm->trans, RSP_RADIO_CMD, rd_cmd);
-		*pos =  (u8)iwl_read_prph_no_grab(mvm->trans, RSP_RADIO_RDDAT);
+		iwl_write_prph_no_grab(fwrt->trans, RSP_RADIO_CMD, rd_cmd);
+		*pos = (u8)iwl_read_prph_no_grab(fwrt->trans, RSP_RADIO_RDDAT);
 
 		pos++;
 	}
 
 	*dump_data = iwl_fw_error_next_data(*dump_data);
 
-	iwl_trans_release_nic_access(mvm->trans, &flags);
+	iwl_trans_release_nic_access(fwrt->trans, &flags);
 }
 
-static void iwl_mvm_dump_rxf(struct iwl_mvm *mvm,
-			     struct iwl_fw_error_dump_data **dump_data,
-			     int size, u32 offset, int fifo_num)
+static void iwl_fwrt_dump_rxf(struct iwl_fw_runtime *fwrt,
+			      struct iwl_fw_error_dump_data **dump_data,
+			      int size, u32 offset, int fifo_num)
 {
 	struct iwl_fw_error_dump_fifo *fifo_hdr;
 	u32 *fifo_data;
@@ -122,41 +137,41 @@ static void iwl_mvm_dump_rxf(struct iwl_mvm *mvm,
 
 	fifo_hdr->fifo_num = cpu_to_le32(fifo_num);
 	fifo_hdr->available_bytes =
-		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 						RXF_RD_D_SPACE + offset));
 	fifo_hdr->wr_ptr =
-		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 						RXF_RD_WR_PTR + offset));
 	fifo_hdr->rd_ptr =
-		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 						RXF_RD_RD_PTR + offset));
 	fifo_hdr->fence_ptr =
-		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 						RXF_RD_FENCE_PTR + offset));
 	fifo_hdr->fence_mode =
-		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 						RXF_SET_FENCE_MODE + offset));
 
 	/* Lock fence */
-	iwl_trans_write_prph(mvm->trans, RXF_SET_FENCE_MODE + offset, 0x1);
+	iwl_trans_write_prph(fwrt->trans, RXF_SET_FENCE_MODE + offset, 0x1);
 	/* Set fence pointer to the same place like WR pointer */
-	iwl_trans_write_prph(mvm->trans, RXF_LD_WR2FENCE + offset, 0x1);
+	iwl_trans_write_prph(fwrt->trans, RXF_LD_WR2FENCE + offset, 0x1);
 	/* Set fence offset */
-	iwl_trans_write_prph(mvm->trans,
+	iwl_trans_write_prph(fwrt->trans,
 			     RXF_LD_FENCE_OFFSET_ADDR + offset, 0x0);
 
 	/* Read FIFO */
 	fifo_len /= sizeof(u32); /* Size in DWORDS */
 	for (i = 0; i < fifo_len; i++)
-		fifo_data[i] = iwl_trans_read_prph(mvm->trans,
+		fifo_data[i] = iwl_trans_read_prph(fwrt->trans,
 						 RXF_FIFO_RD_FENCE_INC +
 						 offset);
 	*dump_data = iwl_fw_error_next_data(*dump_data);
 }
 
-static void iwl_mvm_dump_txf(struct iwl_mvm *mvm,
-			     struct iwl_fw_error_dump_data **dump_data,
-			     int size, u32 offset, int fifo_num)
+static void iwl_fwrt_dump_txf(struct iwl_fw_runtime *fwrt,
+			      struct iwl_fw_error_dump_data **dump_data,
+			      int size, u32 offset, int fifo_num)
 {
 	struct iwl_fw_error_dump_fifo *fifo_hdr;
 	u32 *fifo_data;
@@ -177,91 +192,91 @@ static void iwl_mvm_dump_txf(struct iwl_mvm *mvm,
 
 	fifo_hdr->fifo_num = cpu_to_le32(fifo_num);
 	fifo_hdr->available_bytes =
-		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 						TXF_FIFO_ITEM_CNT + offset));
 	fifo_hdr->wr_ptr =
-		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 						TXF_WR_PTR + offset));
 	fifo_hdr->rd_ptr =
-		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 						TXF_RD_PTR + offset));
 	fifo_hdr->fence_ptr =
-		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 						TXF_FENCE_PTR + offset));
 	fifo_hdr->fence_mode =
-		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+		cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 						TXF_LOCK_FENCE + offset));
 
 	/* Set the TXF_READ_MODIFY_ADDR to TXF_WR_PTR */
-	iwl_trans_write_prph(mvm->trans, TXF_READ_MODIFY_ADDR + offset,
+	iwl_trans_write_prph(fwrt->trans, TXF_READ_MODIFY_ADDR + offset,
 			     TXF_WR_PTR + offset);
 
 	/* Dummy-read to advance the read pointer to the head */
-	iwl_trans_read_prph(mvm->trans, TXF_READ_MODIFY_DATA + offset);
+	iwl_trans_read_prph(fwrt->trans, TXF_READ_MODIFY_DATA + offset);
 
 	/* Read FIFO */
 	fifo_len /= sizeof(u32); /* Size in DWORDS */
 	for (i = 0; i < fifo_len; i++)
-		fifo_data[i] = iwl_trans_read_prph(mvm->trans,
+		fifo_data[i] = iwl_trans_read_prph(fwrt->trans,
 						  TXF_READ_MODIFY_DATA +
 						  offset);
 	*dump_data = iwl_fw_error_next_data(*dump_data);
 }
 
-static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
-			       struct iwl_fw_error_dump_data **dump_data)
+static void iwl_fw_dump_fifos(struct iwl_fw_runtime *fwrt,
+			      struct iwl_fw_error_dump_data **dump_data)
 {
 	struct iwl_fw_error_dump_fifo *fifo_hdr;
-	struct iwl_fwrt_shared_mem_cfg *cfg = &mvm->fwrt.smem_cfg;
+	struct iwl_fwrt_shared_mem_cfg *cfg = &fwrt->smem_cfg;
 	u32 *fifo_data;
 	u32 fifo_len;
 	unsigned long flags;
 	int i, j;
 
-	if (!iwl_trans_grab_nic_access(mvm->trans, &flags))
+	if (!iwl_trans_grab_nic_access(fwrt->trans, &flags))
 		return;
 
 	/* Pull RXF1 */
-	iwl_mvm_dump_rxf(mvm, dump_data, cfg->lmac[0].rxfifo1_size, 0, 0);
+	iwl_fwrt_dump_rxf(fwrt, dump_data, cfg->lmac[0].rxfifo1_size, 0, 0);
 	/* Pull RXF2 */
-	iwl_mvm_dump_rxf(mvm, dump_data, cfg->rxfifo2_size,
-			 RXF_DIFF_FROM_PREV, 1);
+	iwl_fwrt_dump_rxf(fwrt, dump_data, cfg->rxfifo2_size,
+			  RXF_DIFF_FROM_PREV, 1);
 	/* Pull LMAC2 RXF1 */
-	if (mvm->fwrt.smem_cfg.num_lmacs > 1)
-		iwl_mvm_dump_rxf(mvm, dump_data, cfg->lmac[1].rxfifo1_size,
-				 LMAC2_PRPH_OFFSET, 2);
+	if (fwrt->smem_cfg.num_lmacs > 1)
+		iwl_fwrt_dump_rxf(fwrt, dump_data, cfg->lmac[1].rxfifo1_size,
+				  LMAC2_PRPH_OFFSET, 2);
 
 	/* Pull TXF data from LMAC1 */
-	for (i = 0; i < mvm->fwrt.smem_cfg.num_txfifo_entries; i++) {
+	for (i = 0; i < fwrt->smem_cfg.num_txfifo_entries; i++) {
 		/* Mark the number of TXF we're pulling now */
-		iwl_trans_write_prph(mvm->trans, TXF_LARC_NUM, i);
-		iwl_mvm_dump_txf(mvm, dump_data, cfg->lmac[0].txfifo_size[i],
-				 0, i);
+		iwl_trans_write_prph(fwrt->trans, TXF_LARC_NUM, i);
+		iwl_fwrt_dump_txf(fwrt, dump_data, cfg->lmac[0].txfifo_size[i],
+				  0, i);
 	}
 
 	/* Pull TXF data from LMAC2 */
-	if (mvm->fwrt.smem_cfg.num_lmacs > 1) {
-		for (i = 0; i < mvm->fwrt.smem_cfg.num_txfifo_entries; i++) {
+	if (fwrt->smem_cfg.num_lmacs > 1) {
+		for (i = 0; i < fwrt->smem_cfg.num_txfifo_entries; i++) {
 			/* Mark the number of TXF we're pulling now */
-			iwl_trans_write_prph(mvm->trans,
+			iwl_trans_write_prph(fwrt->trans,
 					     TXF_LARC_NUM + LMAC2_PRPH_OFFSET,
 					     i);
-			iwl_mvm_dump_txf(mvm, dump_data,
-					 cfg->lmac[1].txfifo_size[i],
-					 LMAC2_PRPH_OFFSET,
-					 i + cfg->num_txfifo_entries);
+			iwl_fwrt_dump_txf(fwrt, dump_data,
+					  cfg->lmac[1].txfifo_size[i],
+					  LMAC2_PRPH_OFFSET,
+					  i + cfg->num_txfifo_entries);
 		}
 	}
 
-	if (fw_has_capa(&mvm->fw->ucode_capa,
+	if (fw_has_capa(&fwrt->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
 		/* Pull UMAC internal TXF data from all TXFs */
 		for (i = 0;
-		     i < ARRAY_SIZE(mvm->fwrt.smem_cfg.internal_txfifo_size);
+		     i < ARRAY_SIZE(fwrt->smem_cfg.internal_txfifo_size);
 		     i++) {
 			fifo_hdr = (void *)(*dump_data)->data;
 			fifo_data = (void *)fifo_hdr->data;
-			fifo_len = mvm->fwrt.smem_cfg.internal_txfifo_size[i];
+			fifo_len = fwrt->smem_cfg.internal_txfifo_size[i];
 
 			/* No need to try to read the data if the length is 0 */
 			if (fifo_len == 0)
@@ -276,52 +291,45 @@ static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 			fifo_hdr->fifo_num = cpu_to_le32(i);
 
 			/* Mark the number of TXF we're pulling now */
-			iwl_trans_write_prph(mvm->trans, TXF_CPU2_NUM, i +
-				mvm->fwrt.smem_cfg.num_txfifo_entries);
+			iwl_trans_write_prph(fwrt->trans, TXF_CPU2_NUM, i +
+				fwrt->smem_cfg.num_txfifo_entries);
 
 			fifo_hdr->available_bytes =
-				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+				cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 								TXF_CPU2_FIFO_ITEM_CNT));
 			fifo_hdr->wr_ptr =
-				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+				cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 								TXF_CPU2_WR_PTR));
 			fifo_hdr->rd_ptr =
-				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+				cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 								TXF_CPU2_RD_PTR));
 			fifo_hdr->fence_ptr =
-				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+				cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 								TXF_CPU2_FENCE_PTR));
 			fifo_hdr->fence_mode =
-				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+				cpu_to_le32(iwl_trans_read_prph(fwrt->trans,
 								TXF_CPU2_LOCK_FENCE));
 
 			/* Set TXF_CPU2_READ_MODIFY_ADDR to TXF_CPU2_WR_PTR */
-			iwl_trans_write_prph(mvm->trans,
+			iwl_trans_write_prph(fwrt->trans,
 					     TXF_CPU2_READ_MODIFY_ADDR,
 					     TXF_CPU2_WR_PTR);
 
 			/* Dummy-read to advance the read pointer to head */
-			iwl_trans_read_prph(mvm->trans,
+			iwl_trans_read_prph(fwrt->trans,
 					    TXF_CPU2_READ_MODIFY_DATA);
 
 			/* Read FIFO */
 			fifo_len /= sizeof(u32); /* Size in DWORDS */
 			for (j = 0; j < fifo_len; j++)
 				fifo_data[j] =
-					iwl_trans_read_prph(mvm->trans,
+					iwl_trans_read_prph(fwrt->trans,
 							    TXF_CPU2_READ_MODIFY_DATA);
 			*dump_data = iwl_fw_error_next_data(*dump_data);
 		}
 	}
 
-	iwl_trans_release_nic_access(mvm->trans, &flags);
-}
-
-void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm)
-{
-	if (mvm->fw_dump_desc != &iwl_mvm_dump_desc_assert)
-		kfree(mvm->fw_dump_desc);
-	mvm->fw_dump_desc = NULL;
+	iwl_trans_release_nic_access(fwrt->trans, &flags);
 }
 
 #define IWL8260_ICCM_OFFSET		0x44000 /* Only for B-step */
@@ -531,37 +539,32 @@ static struct scatterlist *alloc_sgtable(int size)
 	return table;
 }
 
-void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
+void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 {
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_error_dump_data *dump_data;
 	struct iwl_fw_error_dump_info *dump_info;
 	struct iwl_fw_error_dump_mem *dump_mem;
 	struct iwl_fw_error_dump_trigger_desc *dump_trig;
-	struct iwl_mvm_dump_ptrs *fw_error_dump;
+	struct iwl_fw_dump_ptrs *fw_error_dump;
 	struct scatterlist *sg_dump_data;
 	u32 sram_len, sram_ofs;
-	const struct iwl_fw_dbg_mem_seg_tlv *fw_dbg_mem = mvm->fw->dbg_mem_tlv;
+	const struct iwl_fw_dbg_mem_seg_tlv *fw_dbg_mem = fwrt->fw->dbg_mem_tlv;
 	u32 file_len, fifo_data_len = 0, prph_len = 0, radio_len = 0;
-	u32 smem_len = mvm->fw->n_dbg_mem_tlv ? 0 : mvm->cfg->smem_len;
-	u32 sram2_len = mvm->fw->n_dbg_mem_tlv ? 0 : mvm->cfg->dccm2_len;
+	u32 smem_len = fwrt->fw->n_dbg_mem_tlv ? 0 : fwrt->trans->cfg->smem_len;
+	u32 sram2_len = fwrt->fw->n_dbg_mem_tlv ?
+				0 : fwrt->trans->cfg->dccm2_len;
 	bool monitor_dump_only = false;
 	int i;
 
-	if (!IWL_MVM_COLLECT_FW_ERR_DUMP &&
-	    !mvm->trans->dbg_dest_tlv)
-		return;
-
-	lockdep_assert_held(&mvm->mutex);
-
 	/* there's no point in fw dump if the bus is dead */
-	if (test_bit(STATUS_TRANS_DEAD, &mvm->trans->status)) {
-		IWL_ERR(mvm, "Skip fw error dump since bus is dead\n");
+	if (test_bit(STATUS_TRANS_DEAD, &fwrt->trans->status)) {
+		IWL_ERR(fwrt, "Skip fw error dump since bus is dead\n");
 		goto out;
 	}
 
-	if (mvm->fw_dump_trig &&
-	    mvm->fw_dump_trig->mode & IWL_FW_DBG_TRIGGER_MONITOR_ONLY)
+	if (fwrt->dump.trig &&
+	    fwrt->dump.trig->mode & IWL_FW_DBG_TRIGGER_MONITOR_ONLY)
 		monitor_dump_only = true;
 
 	fw_error_dump = kzalloc(sizeof(*fw_error_dump), GFP_KERNEL);
@@ -569,20 +572,20 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		goto out;
 
 	/* SRAM - include stack CCM if driver knows the values for it */
-	if (!mvm->cfg->dccm_offset || !mvm->cfg->dccm_len) {
+	if (!fwrt->trans->cfg->dccm_offset || !fwrt->trans->cfg->dccm_len) {
 		const struct fw_img *img;
 
-		img = &mvm->fw->img[mvm->fwrt.cur_fw_img];
+		img = &fwrt->fw->img[fwrt->cur_fw_img];
 		sram_ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
 		sram_len = img->sec[IWL_UCODE_SECTION_DATA].len;
 	} else {
-		sram_ofs = mvm->cfg->dccm_offset;
-		sram_len = mvm->cfg->dccm_len;
+		sram_ofs = fwrt->trans->cfg->dccm_offset;
+		sram_len = fwrt->trans->cfg->dccm_len;
 	}
 
 	/* reading RXF/TXF sizes */
-	if (test_bit(STATUS_FW_ERROR, &mvm->trans->status)) {
-		struct iwl_fwrt_shared_mem_cfg *mem_cfg = &mvm->fwrt.smem_cfg;
+	if (test_bit(STATUS_FW_ERROR, &fwrt->trans->status)) {
+		struct iwl_fwrt_shared_mem_cfg *mem_cfg = &fwrt->smem_cfg;
 
 		fifo_data_len = 0;
 
@@ -621,7 +624,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 			}
 		}
 
-		if (fw_has_capa(&mvm->fw->ucode_capa,
+		if (fw_has_capa(&fwrt->fw->ucode_capa,
 				IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
 			for (i = 0;
 			     i < ARRAY_SIZE(mem_cfg->internal_txfifo_size);
@@ -638,7 +641,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		}
 
 		/* Make room for PRPH registers */
-		if (!mvm->trans->cfg->gen2) {
+		if (!fwrt->trans->cfg->gen2) {
 			for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr_comm);
 			     i++) {
 				/* The range includes both boundaries */
@@ -652,7 +655,8 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 			}
 		}
 
-		if (!mvm->trans->cfg->gen2 && mvm->cfg->mq_rx_supported) {
+		if (!fwrt->trans->cfg->gen2 &&
+		    fwrt->trans->cfg->mq_rx_supported) {
 			for (i = 0; i <
 				ARRAY_SIZE(iwl_prph_dump_addr_9000); i++) {
 				/* The range includes both boundaries */
@@ -666,7 +670,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 			}
 		}
 
-		if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000)
+		if (fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000)
 			radio_len = sizeof(*dump_data) + RADIO_REG_MAX_READ;
 	}
 
@@ -686,16 +690,16 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + sram2_len;
 
 	/* Make room for MEM segments */
-	for (i = 0; i < mvm->fw->n_dbg_mem_tlv; i++) {
+	for (i = 0; i < fwrt->fw->n_dbg_mem_tlv; i++) {
 		file_len += sizeof(*dump_data) + sizeof(*dump_mem) +
 			    le32_to_cpu(fw_dbg_mem[i].len);
 	}
 
 	/* Make room for fw's virtual image pages, if it exists */
-	if (!mvm->trans->cfg->gen2 &&
-	    mvm->fw->img[mvm->fwrt.cur_fw_img].paging_mem_size &&
-	    mvm->fwrt.fw_paging_db[0].fw_paging_block)
-		file_len += mvm->fwrt.num_of_paging_blk *
+	if (!fwrt->trans->cfg->gen2 &&
+	    fwrt->fw->img[fwrt->cur_fw_img].paging_mem_size &&
+	    fwrt->fw_paging_db[0].fw_paging_block)
+		file_len += fwrt->num_of_paging_blk *
 			(sizeof(*dump_data) +
 			 sizeof(struct iwl_fw_error_dump_paging) +
 			 PAGING_BLOCK_SIZE);
@@ -706,11 +710,11 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 			   sizeof(*dump_info);
 	}
 
-	if (mvm->fw_dump_desc)
+	if (fwrt->dump.desc)
 		file_len += sizeof(*dump_data) + sizeof(*dump_trig) +
-			    mvm->fw_dump_desc->len;
+			    fwrt->dump.desc->len;
 
-	if (!mvm->fw->n_dbg_mem_tlv)
+	if (!fwrt->fw->n_dbg_mem_tlv)
 		file_len += sram_len + sizeof(*dump_mem);
 
 	dump_file = vzalloc(file_len);
@@ -719,7 +723,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		goto out;
 	}
 
-	fw_error_dump->op_mode_ptr = dump_file;
+	fw_error_dump->fwrt_ptr = dump_file;
 
 	dump_file->barker = cpu_to_le32(IWL_FW_ERROR_DUMP_BARKER);
 	dump_data = (void *)dump_file->data;
@@ -728,32 +732,32 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	dump_data->len = cpu_to_le32(sizeof(*dump_info));
 	dump_info = (void *)dump_data->data;
 	dump_info->device_family =
-		mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000 ?
+		fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000 ?
 			cpu_to_le32(IWL_FW_ERROR_DUMP_FAMILY_7) :
 			cpu_to_le32(IWL_FW_ERROR_DUMP_FAMILY_8);
-	dump_info->hw_step = cpu_to_le32(CSR_HW_REV_STEP(mvm->trans->hw_rev));
-	memcpy(dump_info->fw_human_readable, mvm->fw->human_readable,
+	dump_info->hw_step = cpu_to_le32(CSR_HW_REV_STEP(fwrt->trans->hw_rev));
+	memcpy(dump_info->fw_human_readable, fwrt->fw->human_readable,
 	       sizeof(dump_info->fw_human_readable));
-	strncpy(dump_info->dev_human_readable, mvm->cfg->name,
+	strncpy(dump_info->dev_human_readable, fwrt->trans->cfg->name,
 		sizeof(dump_info->dev_human_readable));
-	strncpy(dump_info->bus_human_readable, mvm->dev->bus->name,
+	strncpy(dump_info->bus_human_readable, fwrt->dev->bus->name,
 		sizeof(dump_info->bus_human_readable));
 
 	dump_data = iwl_fw_error_next_data(dump_data);
 	/* We only dump the FIFOs if the FW is in error state */
-	if (test_bit(STATUS_FW_ERROR, &mvm->trans->status)) {
-		iwl_mvm_dump_fifos(mvm, &dump_data);
+	if (test_bit(STATUS_FW_ERROR, &fwrt->trans->status)) {
+		iwl_fw_dump_fifos(fwrt, &dump_data);
 		if (radio_len)
-			iwl_mvm_read_radio_reg(mvm, &dump_data);
+			iwl_read_radio_regs(fwrt, &dump_data);
 	}
 
-	if (mvm->fw_dump_desc) {
+	if (fwrt->dump.desc) {
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_ERROR_INFO);
 		dump_data->len = cpu_to_le32(sizeof(*dump_trig) +
-					     mvm->fw_dump_desc->len);
+					     fwrt->dump.desc->len);
 		dump_trig = (void *)dump_data->data;
-		memcpy(dump_trig, &mvm->fw_dump_desc->trig_desc,
-		       sizeof(*dump_trig) + mvm->fw_dump_desc->len);
+		memcpy(dump_trig, &fwrt->dump.desc->trig_desc,
+		       sizeof(*dump_trig) + fwrt->dump.desc->len);
 
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
@@ -762,18 +766,18 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (monitor_dump_only)
 		goto dump_trans_data;
 
-	if (!mvm->fw->n_dbg_mem_tlv) {
+	if (!fwrt->fw->n_dbg_mem_tlv) {
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 		dump_data->len = cpu_to_le32(sram_len + sizeof(*dump_mem));
 		dump_mem = (void *)dump_data->data;
 		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
 		dump_mem->offset = cpu_to_le32(sram_ofs);
-		iwl_trans_read_mem_bytes(mvm->trans, sram_ofs, dump_mem->data,
+		iwl_trans_read_mem_bytes(fwrt->trans, sram_ofs, dump_mem->data,
 					 sram_len);
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
-	for (i = 0; i < mvm->fw->n_dbg_mem_tlv; i++) {
+	for (i = 0; i < fwrt->fw->n_dbg_mem_tlv; i++) {
 		u32 len = le32_to_cpu(fw_dbg_mem[i].len);
 		u32 ofs = le32_to_cpu(fw_dbg_mem[i].ofs);
 		bool success;
@@ -786,13 +790,13 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 		switch (dump_mem->type & cpu_to_le32(FW_DBG_MEM_TYPE_MASK)) {
 		case cpu_to_le32(FW_DBG_MEM_TYPE_REGULAR):
-			iwl_trans_read_mem_bytes(mvm->trans, ofs,
+			iwl_trans_read_mem_bytes(fwrt->trans, ofs,
 						 dump_mem->data,
 						 len);
 			success = true;
 			break;
 		case cpu_to_le32(FW_DBG_MEM_TYPE_PRPH):
-			success = iwl_read_prph_block(mvm->trans, ofs, len,
+			success = iwl_read_prph_block(fwrt->trans, ofs, len,
 						      (void *)dump_mem->data);
 			break;
 		default:
@@ -813,8 +817,9 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		dump_data->len = cpu_to_le32(smem_len + sizeof(*dump_mem));
 		dump_mem = (void *)dump_data->data;
 		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SMEM);
-		dump_mem->offset = cpu_to_le32(mvm->cfg->smem_offset);
-		iwl_trans_read_mem_bytes(mvm->trans, mvm->cfg->smem_offset,
+		dump_mem->offset = cpu_to_le32(fwrt->trans->cfg->smem_offset);
+		iwl_trans_read_mem_bytes(fwrt->trans,
+					 fwrt->trans->cfg->smem_offset,
 					 dump_mem->data, smem_len);
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
@@ -824,28 +829,29 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		dump_data->len = cpu_to_le32(sram2_len + sizeof(*dump_mem));
 		dump_mem = (void *)dump_data->data;
 		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
-		dump_mem->offset = cpu_to_le32(mvm->cfg->dccm2_offset);
-		iwl_trans_read_mem_bytes(mvm->trans, mvm->cfg->dccm2_offset,
+		dump_mem->offset = cpu_to_le32(fwrt->trans->cfg->dccm2_offset);
+		iwl_trans_read_mem_bytes(fwrt->trans,
+					 fwrt->trans->cfg->dccm2_offset,
 					 dump_mem->data, sram2_len);
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
 	/* Dump fw's virtual image */
-	if (!mvm->trans->cfg->gen2 &&
-	    mvm->fw->img[mvm->fwrt.cur_fw_img].paging_mem_size &&
-	    mvm->fwrt.fw_paging_db[0].fw_paging_block) {
-		for (i = 1; i < mvm->fwrt.num_of_paging_blk + 1; i++) {
+	if (!fwrt->trans->cfg->gen2 &&
+	    fwrt->fw->img[fwrt->cur_fw_img].paging_mem_size &&
+	    fwrt->fw_paging_db[0].fw_paging_block) {
+		for (i = 1; i < fwrt->num_of_paging_blk + 1; i++) {
 			struct iwl_fw_error_dump_paging *paging;
 			struct page *pages =
-				mvm->fwrt.fw_paging_db[i].fw_paging_block;
-			dma_addr_t addr = mvm->fwrt.fw_paging_db[i].fw_paging_phys;
+				fwrt->fw_paging_db[i].fw_paging_block;
+			dma_addr_t addr = fwrt->fw_paging_db[i].fw_paging_phys;
 
 			dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PAGING);
 			dump_data->len = cpu_to_le32(sizeof(*paging) +
 						     PAGING_BLOCK_SIZE);
 			paging = (void *)dump_data->data;
 			paging->index = cpu_to_le32(i);
-			dma_sync_single_for_cpu(mvm->trans->dev, addr,
+			dma_sync_single_for_cpu(fwrt->trans->dev, addr,
 						PAGING_BLOCK_SIZE,
 						DMA_BIDIRECTIONAL);
 			memcpy(paging->data, page_address(pages),
@@ -855,20 +861,20 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	}
 
 	if (prph_len) {
-		iwl_dump_prph(mvm->trans, &dump_data,
+		iwl_dump_prph(fwrt->trans, &dump_data,
 			      iwl_prph_dump_addr_comm,
 			      ARRAY_SIZE(iwl_prph_dump_addr_comm));
 
-		if (mvm->cfg->mq_rx_supported)
-			iwl_dump_prph(mvm->trans, &dump_data,
+		if (fwrt->trans->cfg->mq_rx_supported)
+			iwl_dump_prph(fwrt->trans, &dump_data,
 				      iwl_prph_dump_addr_9000,
 				      ARRAY_SIZE(iwl_prph_dump_addr_9000));
 	}
 
 dump_trans_data:
-	fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans,
-						       mvm->fw_dump_trig);
-	fw_error_dump->op_mode_len = file_len;
+	fw_error_dump->trans_ptr = iwl_trans_dump_data(fwrt->trans,
+						       fwrt->dump.trig);
+	fw_error_dump->fwrt_len = file_len;
 	if (fw_error_dump->trans_ptr)
 		file_len += fw_error_dump->trans_ptr->len;
 	dump_file->file_len = cpu_to_le32(file_len);
@@ -877,68 +883,72 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (sg_dump_data) {
 		sg_pcopy_from_buffer(sg_dump_data,
 				     sg_nents(sg_dump_data),
-				     fw_error_dump->op_mode_ptr,
-				     fw_error_dump->op_mode_len, 0);
+				     fw_error_dump->fwrt_ptr,
+				     fw_error_dump->fwrt_len, 0);
 		if (fw_error_dump->trans_ptr)
 			sg_pcopy_from_buffer(sg_dump_data,
 					     sg_nents(sg_dump_data),
 					     fw_error_dump->trans_ptr->data,
 					     fw_error_dump->trans_ptr->len,
-					     fw_error_dump->op_mode_len);
-		dev_coredumpsg(mvm->trans->dev, sg_dump_data, file_len,
+					     fw_error_dump->fwrt_len);
+		dev_coredumpsg(fwrt->trans->dev, sg_dump_data, file_len,
 			       GFP_KERNEL);
 	}
-	vfree(fw_error_dump->op_mode_ptr);
+	vfree(fw_error_dump->fwrt_ptr);
 	vfree(fw_error_dump->trans_ptr);
 	kfree(fw_error_dump);
 
 out:
-	iwl_mvm_free_fw_dump_desc(mvm);
-	mvm->fw_dump_trig = NULL;
-	clear_bit(IWL_MVM_STATUS_DUMPING_FW_LOG, &mvm->status);
+	iwl_fw_free_dump_desc(fwrt);
+	fwrt->dump.trig = NULL;
+	clear_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status);
 }
+IWL_EXPORT_SYMBOL(iwl_fw_error_dump);
 
-const struct iwl_mvm_dump_desc iwl_mvm_dump_desc_assert = {
+const struct iwl_fw_dump_desc iwl_dump_desc_assert = {
 	.trig_desc = {
 		.type = cpu_to_le32(FW_DBG_TRIGGER_FW_ASSERT),
 	},
 };
+IWL_EXPORT_SYMBOL(iwl_dump_desc_assert);
 
-int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
-				const struct iwl_mvm_dump_desc *desc,
-				const struct iwl_fw_dbg_trigger_tlv *trigger)
+int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
+			    const struct iwl_fw_dump_desc *desc,
+			    const struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	unsigned int delay = 0;
 
 	if (trigger)
 		delay = msecs_to_jiffies(le32_to_cpu(trigger->stop_delay));
 
-	if (WARN(mvm->trans->state == IWL_TRANS_NO_FW,
+	if (WARN(fwrt->trans->state == IWL_TRANS_NO_FW,
 		 "Can't collect dbg data when FW isn't alive\n"))
 		return -EIO;
 
-	if (test_and_set_bit(IWL_MVM_STATUS_DUMPING_FW_LOG, &mvm->status))
+	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status))
 		return -EBUSY;
 
-	if (WARN_ON(mvm->fw_dump_desc))
-		iwl_mvm_free_fw_dump_desc(mvm);
+	if (WARN_ON(fwrt->dump.desc))
+		iwl_fw_free_dump_desc(fwrt);
 
-	IWL_WARN(mvm, "Collecting data: trigger %d fired.\n",
+	IWL_WARN(fwrt, "Collecting data: trigger %d fired.\n",
 		 le32_to_cpu(desc->trig_desc.type));
 
-	mvm->fw_dump_desc = desc;
-	mvm->fw_dump_trig = trigger;
+	fwrt->dump.desc = desc;
+	fwrt->dump.trig = trigger;
 
-	schedule_delayed_work(&mvm->fw_dump_wk, delay);
+	schedule_delayed_work(&fwrt->dump.wk, delay);
 
 	return 0;
 }
+IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect_desc);
 
-int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
-			   const char *str, size_t len,
-			   const struct iwl_fw_dbg_trigger_tlv *trigger)
+int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
+		       enum iwl_fw_dbg_trigger trig,
+		       const char *str, size_t len,
+		       const struct iwl_fw_dbg_trigger_tlv *trigger)
 {
-	struct iwl_mvm_dump_desc *desc;
+	struct iwl_fw_dump_desc *desc;
 
 	desc = kzalloc(sizeof(*desc) + len, GFP_ATOMIC);
 	if (!desc)
@@ -948,12 +958,13 @@ int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
 	desc->trig_desc.type = cpu_to_le32(trig);
 	memcpy(desc->trig_desc.data, str, len);
 
-	return iwl_mvm_fw_dbg_collect_desc(mvm, desc, trigger);
+	return iwl_fw_dbg_collect_desc(fwrt, desc, trigger);
 }
+IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect);
 
-int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
-				struct iwl_fw_dbg_trigger_tlv *trigger,
-				const char *fmt, ...)
+int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
+			    struct iwl_fw_dbg_trigger_tlv *trigger,
+			    const char *fmt, ...)
 {
 	u16 occurrences = le16_to_cpu(trigger->occurrences);
 	int ret, len = 0;
@@ -978,8 +989,8 @@ int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 		len = strlen(buf) + 1;
 	}
 
-	ret = iwl_mvm_fw_dbg_collect(mvm, le32_to_cpu(trigger->id), buf, len,
-				     trigger);
+	ret = iwl_fw_dbg_collect(fwrt, le32_to_cpu(trigger->id), buf, len,
+				 trigger);
 
 	if (ret)
 		return ret;
@@ -987,37 +998,42 @@ int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 	trigger->occurrences = cpu_to_le16(occurrences - 1);
 	return 0;
 }
+IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect_trig);
 
-int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 conf_id)
+int iwl_fw_start_dbg_conf(struct iwl_fw_runtime *fwrt, u8 conf_id)
 {
 	u8 *ptr;
 	int ret;
 	int i;
 
-	if (WARN_ONCE(conf_id >= ARRAY_SIZE(mvm->fw->dbg_conf_tlv),
+	if (WARN_ONCE(conf_id >= ARRAY_SIZE(fwrt->fw->dbg_conf_tlv),
 		      "Invalid configuration %d\n", conf_id))
 		return -EINVAL;
 
 	/* EARLY START - firmware's configuration is hard coded */
-	if ((!mvm->fw->dbg_conf_tlv[conf_id] ||
-	     !mvm->fw->dbg_conf_tlv[conf_id]->num_of_hcmds) &&
+	if ((!fwrt->fw->dbg_conf_tlv[conf_id] ||
+	     !fwrt->fw->dbg_conf_tlv[conf_id]->num_of_hcmds) &&
 	    conf_id == FW_DBG_START_FROM_ALIVE)
 		return 0;
 
-	if (!mvm->fw->dbg_conf_tlv[conf_id])
+	if (!fwrt->fw->dbg_conf_tlv[conf_id])
 		return -EINVAL;
 
-	if (mvm->fw_dbg_conf != FW_DBG_INVALID)
-		IWL_WARN(mvm, "FW already configured (%d) - re-configuring\n",
-			 mvm->fw_dbg_conf);
+	if (fwrt->dump.conf != FW_DBG_INVALID)
+		IWL_WARN(fwrt, "FW already configured (%d) - re-configuring\n",
+			 fwrt->dump.conf);
 
 	/* Send all HCMDs for configuring the FW debug */
-	ptr = (void *)&mvm->fw->dbg_conf_tlv[conf_id]->hcmd;
-	for (i = 0; i < mvm->fw->dbg_conf_tlv[conf_id]->num_of_hcmds; i++) {
+	ptr = (void *)&fwrt->fw->dbg_conf_tlv[conf_id]->hcmd;
+	for (i = 0; i < fwrt->fw->dbg_conf_tlv[conf_id]->num_of_hcmds; i++) {
 		struct iwl_fw_dbg_conf_hcmd *cmd = (void *)ptr;
+		struct iwl_host_cmd hcmd = {
+			.id = cmd->id,
+			.len = { le16_to_cpu(cmd->len), },
+			.data = { cmd->data, },
+		};
 
-		ret = iwl_mvm_send_cmd_pdu(mvm, cmd->id, 0,
-					   le16_to_cpu(cmd->len), cmd->data);
+		ret = iwl_trans_send_cmd(fwrt->trans, &hcmd);
 		if (ret)
 			return ret;
 
@@ -1025,7 +1041,59 @@ int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 conf_id)
 		ptr += le16_to_cpu(cmd->len);
 	}
 
-	mvm->fw_dbg_conf = conf_id;
+	fwrt->dump.conf = conf_id;
 
 	return 0;
 }
+IWL_EXPORT_SYMBOL(iwl_fw_start_dbg_conf);
+
+void iwl_fw_error_dump_wk(struct work_struct *work)
+{
+	struct iwl_fw_runtime *fwrt =
+		container_of(work, struct iwl_fw_runtime, dump.wk.work);
+
+	if (fwrt->ops && fwrt->ops->dump_start &&
+	    fwrt->ops->dump_start(fwrt->ops_ctx))
+		return;
+
+	if (fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
+		/* stop recording */
+		iwl_set_bits_prph(fwrt->trans, MON_BUFF_SAMPLE_CTL, 0x100);
+
+		iwl_fw_error_dump(fwrt);
+
+		/* start recording again if the firmware is not crashed */
+		if (!test_bit(STATUS_FW_ERROR, &fwrt->trans->status) &&
+		    fwrt->fw->dbg_dest_tlv) {
+			iwl_clear_bits_prph(fwrt->trans,
+					    MON_BUFF_SAMPLE_CTL, 0x100);
+			iwl_clear_bits_prph(fwrt->trans,
+					    MON_BUFF_SAMPLE_CTL, 0x1);
+			iwl_set_bits_prph(fwrt->trans,
+					  MON_BUFF_SAMPLE_CTL, 0x1);
+		}
+	} else {
+		u32 in_sample = iwl_read_prph(fwrt->trans, DBGC_IN_SAMPLE);
+		u32 out_ctrl = iwl_read_prph(fwrt->trans, DBGC_OUT_CTRL);
+
+		/* stop recording */
+		iwl_write_prph(fwrt->trans, DBGC_IN_SAMPLE, 0);
+		udelay(100);
+		iwl_write_prph(fwrt->trans, DBGC_OUT_CTRL, 0);
+		/* wait before we collect the data till the DBGC stop */
+		udelay(500);
+
+		iwl_fw_error_dump(fwrt);
+
+		/* start recording again if the firmware is not crashed */
+		if (!test_bit(STATUS_FW_ERROR, &fwrt->trans->status) &&
+		    fwrt->fw->dbg_dest_tlv) {
+			iwl_write_prph(fwrt->trans, DBGC_IN_SAMPLE, in_sample);
+			iwl_write_prph(fwrt->trans, DBGC_OUT_CTRL, out_ctrl);
+		}
+	}
+
+	if (fwrt->ops && fwrt->ops->dump_end)
+		fwrt->ops->dump_end(fwrt->ops_ctx);
+}
+
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
similarity index 59%
rename from drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
rename to drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 4a5287a0c617..0f810ea89d31 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -63,24 +63,46 @@
  *
  *****************************************************************************/
 
-#ifndef __mvm_fw_dbg_h__
-#define __mvm_fw_dbg_h__
-#include "fw/file.h"
-#include "fw/error-dump.h"
-#include "mvm.h"
-
-void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
-void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm);
-int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
-				const struct iwl_mvm_dump_desc *desc,
-				const struct iwl_fw_dbg_trigger_tlv *trigger);
-int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
-			   const char *str, size_t len,
-			   const struct iwl_fw_dbg_trigger_tlv *trigger);
-int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
-				struct iwl_fw_dbg_trigger_tlv *trigger,
-				const char *fmt, ...) __printf(3, 4);
-int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 id);
+#ifndef __iwl_fw_dbg_h__
+#define __iwl_fw_dbg_h__
+#include <linux/workqueue.h>
+#include <net/cfg80211.h>
+#include "runtime.h"
+#include "file.h"
+#include "error-dump.h"
+
+/**
+ * struct iwl_fw_dump_desc - describes the dump
+ * @len: length of trig_desc->data
+ * @trig_desc: the description of the dump
+ */
+struct iwl_fw_dump_desc {
+	size_t len;
+	/* must be last */
+	struct iwl_fw_error_dump_trigger_desc trig_desc;
+};
+
+extern const struct iwl_fw_dump_desc iwl_dump_desc_assert;
+
+static inline void iwl_fw_free_dump_desc(struct iwl_fw_runtime *fwrt)
+{
+	if (fwrt->dump.desc != &iwl_dump_desc_assert)
+		kfree(fwrt->dump.desc);
+	fwrt->dump.desc = NULL;
+}
+
+void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt);
+int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
+			    const struct iwl_fw_dump_desc *desc,
+			    const struct iwl_fw_dbg_trigger_tlv *trigger);
+int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
+		       enum iwl_fw_dbg_trigger trig,
+		       const char *str, size_t len,
+		       const struct iwl_fw_dbg_trigger_tlv *trigger);
+int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
+			    struct iwl_fw_dbg_trigger_tlv *trigger,
+			    const char *fmt, ...) __printf(3, 4);
+int iwl_fw_start_dbg_conf(struct iwl_fw_runtime *fwrt, u8 id);
 
 #define iwl_fw_dbg_trigger_enabled(fw, id) ({			\
 	void *__dbg_trigger = (fw)->dbg_trigger_tlv[(id)];	\
@@ -101,25 +123,25 @@ _iwl_fw_dbg_get_trigger(const struct iwl_fw *fw, enum iwl_fw_dbg_trigger id)
 
 static inline bool
 iwl_fw_dbg_trigger_vif_match(struct iwl_fw_dbg_trigger_tlv *trig,
-			     struct ieee80211_vif *vif)
+			     struct wireless_dev *wdev)
 {
 	u32 trig_vif = le32_to_cpu(trig->vif_type);
 
 	return trig_vif == IWL_FW_DBG_CONF_VIF_ANY ||
-	       ieee80211_vif_type_p2p(vif) == trig_vif;
+	       wdev->iftype == trig_vif;
 }
 
 static inline bool
-iwl_fw_dbg_trigger_stop_conf_match(struct iwl_mvm *mvm,
+iwl_fw_dbg_trigger_stop_conf_match(struct iwl_fw_runtime *fwrt,
 				   struct iwl_fw_dbg_trigger_tlv *trig)
 {
 	return ((trig->mode & IWL_FW_DBG_TRIGGER_STOP) &&
-		(mvm->fw_dbg_conf == FW_DBG_INVALID ||
-		(BIT(mvm->fw_dbg_conf) & le32_to_cpu(trig->stop_conf_ids))));
+		(fwrt->dump.conf == FW_DBG_INVALID ||
+		(BIT(fwrt->dump.conf) & le32_to_cpu(trig->stop_conf_ids))));
 }
 
 static inline bool
-iwl_fw_dbg_no_trig_window(struct iwl_mvm *mvm,
+iwl_fw_dbg_no_trig_window(struct iwl_fw_runtime *fwrt,
 			  struct iwl_fw_dbg_trigger_tlv *trig)
 {
 	unsigned long wind_jiff =
@@ -127,49 +149,66 @@ iwl_fw_dbg_no_trig_window(struct iwl_mvm *mvm,
 	u32 id = le32_to_cpu(trig->id);
 
 	/* If this is the first event checked, jump to update start ts */
-	if (mvm->fw_dbg_non_collect_ts_start[id] &&
-	    (time_after(mvm->fw_dbg_non_collect_ts_start[id] + wind_jiff,
+	if (fwrt->dump.non_collect_ts_start[id] &&
+	    (time_after(fwrt->dump.non_collect_ts_start[id] + wind_jiff,
 			jiffies)))
 		return true;
 
-	mvm->fw_dbg_non_collect_ts_start[id] = jiffies;
+	fwrt->dump.non_collect_ts_start[id] = jiffies;
 	return false;
 }
 
 static inline bool
-iwl_fw_dbg_trigger_check_stop(struct iwl_mvm *mvm,
-			      struct ieee80211_vif *vif,
+iwl_fw_dbg_trigger_check_stop(struct iwl_fw_runtime *fwrt,
+			      struct wireless_dev *wdev,
 			      struct iwl_fw_dbg_trigger_tlv *trig)
 {
-	if (vif && !iwl_fw_dbg_trigger_vif_match(trig, vif))
+	if (wdev && !iwl_fw_dbg_trigger_vif_match(trig, wdev))
 		return false;
 
-	if (iwl_fw_dbg_no_trig_window(mvm, trig)) {
-		IWL_WARN(mvm, "Trigger %d occurred while no-collect window.\n",
+	if (iwl_fw_dbg_no_trig_window(fwrt, trig)) {
+		IWL_WARN(fwrt, "Trigger %d occurred while no-collect window.\n",
 			 trig->id);
 		return false;
 	}
 
-	return iwl_fw_dbg_trigger_stop_conf_match(mvm, trig);
+	return iwl_fw_dbg_trigger_stop_conf_match(fwrt, trig);
 }
 
 static inline void
-_iwl_fw_dbg_trigger_simple_stop(struct iwl_mvm *mvm,
-				struct ieee80211_vif *vif,
+_iwl_fw_dbg_trigger_simple_stop(struct iwl_fw_runtime *fwrt,
+				struct wireless_dev *wdev,
 				struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	if (!trigger)
 		return;
 
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trigger))
+	if (!iwl_fw_dbg_trigger_check_stop(fwrt, wdev, trigger))
 		return;
 
-	iwl_mvm_fw_dbg_collect_trig(mvm, trigger, NULL);
+	iwl_fw_dbg_collect_trig(fwrt, trigger, NULL);
 }
 
-#define iwl_fw_dbg_trigger_simple_stop(mvm, vif, trig)	\
-	_iwl_fw_dbg_trigger_simple_stop((mvm), (vif),	\
-					iwl_fw_dbg_get_trigger((mvm)->fw,\
+#define iwl_fw_dbg_trigger_simple_stop(fwrt, wdev, trig)	\
+	_iwl_fw_dbg_trigger_simple_stop((fwrt), (wdev),		\
+					iwl_fw_dbg_get_trigger((fwrt)->fw,\
 							       (trig)))
 
-#endif  /* __mvm_fw_dbg_h__ */
+static inline void iwl_fw_dump_conf_clear(struct iwl_fw_runtime *fwrt)
+{
+	fwrt->dump.conf = FW_DBG_INVALID;
+}
+
+void iwl_fw_error_dump_wk(struct work_struct *work);
+
+static inline void iwl_fw_flush_dump(struct iwl_fw_runtime *fwrt)
+{
+	flush_delayed_work(&fwrt->dump.wk);
+}
+
+static inline void iwl_fw_cancel_dump(struct iwl_fw_runtime *fwrt)
+{
+	cancel_delayed_work_sync(&fwrt->dump.wk);
+}
+
+#endif  /* __iwl_fw_dbg_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/init.c b/drivers/net/wireless/intel/iwlwifi/fw/init.c
new file mode 100644
index 000000000000..bfe5316bbb6a
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/fw/init.c
@@ -0,0 +1,75 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2017 Intel Deutschland GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <linuxwifi@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2017 Intel Deutschland GmbH
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#include "iwl-drv.h"
+#include "runtime.h"
+#include "dbg.h"
+
+void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
+			 const struct iwl_fw *fw,
+			 const struct iwl_fw_runtime_ops *ops, void *ops_ctx)
+{
+	memset(fwrt, 0, sizeof(*fwrt));
+	fwrt->trans = trans;
+	fwrt->fw = fw;
+	fwrt->dev = trans->dev;
+	fwrt->dump.conf = FW_DBG_INVALID;
+	fwrt->ops = ops;
+	fwrt->ops_ctx = ops_ctx;
+	INIT_DELAYED_WORK(&fwrt->dump.wk, iwl_fw_error_dump_wk);
+}
+IWL_EXPORT_SYMBOL(iwl_fw_runtime_init);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index c483a76cb0e5..02f1bc985383 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -63,6 +63,11 @@
 #include "img.h"
 #include "api.h"
 
+struct iwl_fw_runtime_ops {
+	int (*dump_start)(void *ctx);
+	void (*dump_end)(void *ctx);
+};
+
 #define MAX_NUM_LMAC 2
 struct iwl_fwrt_shared_mem_cfg {
 	int num_lmacs;
@@ -76,23 +81,36 @@ struct iwl_fwrt_shared_mem_cfg {
 	u32 internal_txfifo_size[TX_FIFO_INTERNAL_MAX_NUM];
 };
 
+enum iwl_fw_runtime_status {
+	IWL_FWRT_STATUS_DUMPING = 0,
+};
+
 /**
  * struct iwl_fw_runtime - runtime data for firmware
  * @fw: firmware image
  * @cfg: NIC configuration
  * @dev: device pointer
+ * @ops: user ops
+ * @ops_ctx: user ops context
+ * @status: status flags
  * @fw_paging_db: paging database
  * @num_of_paging_blk: number of paging blocks
  * @num_of_pages_in_last_blk: number of pages in the last block
  * @smem_cfg: saved firmware SMEM configuration
  * @cur_fw_img: current firmware image, must be maintained by
  *	the driver by calling &iwl_fw_set_current_image()
+ * @dump: debug dump data
  */
 struct iwl_fw_runtime {
 	struct iwl_trans *trans;
 	const struct iwl_fw *fw;
 	struct device *dev;
 
+	const struct iwl_fw_runtime_ops *ops;
+	void *ops_ctx;
+
+	unsigned long status;
+
 	/* Paging */
 	struct iwl_fw_paging fw_paging_db[NUM_OF_FW_PAGING_BLOCKS];
 	u16 num_of_paging_blk;
@@ -102,17 +120,23 @@ struct iwl_fw_runtime {
 
 	/* memory configuration */
 	struct iwl_fwrt_shared_mem_cfg smem_cfg;
+
+	/* debug */
+	struct {
+		const struct iwl_fw_dump_desc *desc;
+		const struct iwl_fw_dbg_trigger_tlv *trig;
+		struct delayed_work wk;
+
+		u8 conf;
+
+		/* ts of the beginning of a non-collect fw dbg data period */
+		unsigned long non_collect_ts_start[FW_DBG_TRIGGER_MAX - 1];
+	} dump;
 };
 
-static inline void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt,
-				       struct iwl_trans *trans,
-				       const struct iwl_fw *fw)
-{
-	memset(fwrt, 0, sizeof(*fwrt));
-	fwrt->trans = trans;
-	fwrt->fw = fw;
-	fwrt->dev = trans->dev;
-}
+void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
+			 const struct iwl_fw *fw,
+			 const struct iwl_fw_runtime_ops *ops, void *ops_ctx);
 
 static inline void iwl_fw_set_current_image(struct iwl_fw_runtime *fwrt,
 					    enum iwl_ucode_type cur_fw_img)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
index 83ac807e547d..00e6737dda72 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
@@ -6,7 +6,7 @@ iwlmvm-y += power.o coex.o
 iwlmvm-y += tt.o offloading.o tdls.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o debugfs-vif.o
 iwlmvm-$(CONFIG_IWLWIFI_LEDS) += led.o
-iwlmvm-y += tof.o fw-dbg.o
+iwlmvm-y += tof.o
 iwlmvm-$(CONFIG_PM) += d3.o
 
 ccflags-y += -I$(src)/../
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index 6fda8627b726..21845034d80d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -111,7 +111,6 @@
 #define IWL_MVM_SW_TX_CSUM_OFFLOAD		0
 #define IWL_MVM_HW_CSUM_DISABLE			0
 #define IWL_MVM_PARSE_NVM			0
-#define IWL_MVM_COLLECT_FW_ERR_DUMP		1
 #define IWL_MVM_RS_NUM_TRY_BEFORE_ANT_TOGGLE    1
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE      2
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE_TW   1
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 9991494314e2..29f1d1807415 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -69,7 +69,6 @@
 #include <linux/netdevice.h>
 
 #include "mvm.h"
-#include "fw-dbg.h"
 #include "sta.h"
 #include "iwl-io.h"
 #include "debugfs.h"
@@ -1123,7 +1122,7 @@ static ssize_t iwl_dbgfs_fw_dbg_conf_read(struct file *file,
 	int pos = 0;
 
 	mutex_lock(&mvm->mutex);
-	conf = mvm->fw_dbg_conf;
+	conf = mvm->fwrt.dump.conf;
 	mutex_unlock(&mvm->mutex);
 
 	pos += scnprintf(buf + pos, bufsz - pos, "%d\n", conf);
@@ -1190,7 +1189,7 @@ static ssize_t iwl_dbgfs_fw_dbg_conf_write(struct iwl_mvm *mvm,
 		return -EINVAL;
 
 	mutex_lock(&mvm->mutex);
-	ret = iwl_mvm_start_fw_dbg_conf(mvm, conf_id);
+	ret = iwl_fw_start_dbg_conf(&mvm->fwrt, conf_id);
 	mutex_unlock(&mvm->mutex);
 
 	return ret ?: count;
@@ -1211,8 +1210,8 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 	if (count == 0)
 		return 0;
 
-	iwl_mvm_fw_dbg_collect(mvm, FW_DBG_TRIGGER_USER, buf,
-			       (count - 1), NULL);
+	iwl_fw_dbg_collect(&mvm->fwrt, FW_DBG_TRIGGER_USER, buf,
+			   (count - 1), NULL);
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_PRPH_WRITE);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 08108620b977..e6f6de2500db 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -78,7 +78,7 @@
 #include "iwl-eeprom-parse.h"
 
 #include "mvm.h"
-#include "fw-dbg.h"
+#include "fw/dbg.h"
 #include "iwl-phy-db.h"
 
 #define MVM_UCODE_ALIVE_TIMEOUT	HZ
@@ -1091,11 +1091,11 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		IWL_ERR(mvm, "Failed to initialize Smart Fifo\n");
 
-	mvm->fw_dbg_conf = FW_DBG_INVALID;
+	mvm->fwrt.dump.conf = FW_DBG_INVALID;
 	/* if we have a destination, assume EARLY START */
 	if (mvm->fw->dbg_dest_tlv)
-		mvm->fw_dbg_conf = FW_DBG_START_FROM_ALIVE;
-	iwl_mvm_start_fw_dbg_conf(mvm, FW_DBG_START_FROM_ALIVE);
+		mvm->fwrt.dump.conf = FW_DBG_START_FROM_ALIVE;
+	iwl_fw_start_dbg_conf(&mvm->fwrt, FW_DBG_START_FROM_ALIVE);
 
 	ret = iwl_send_tx_ant_cfg(mvm, iwl_mvm_get_valid_tx_ant(mvm));
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index dc631b23e189..d130bdd76368 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -72,7 +72,6 @@
 #include "fw-api.h"
 #include "mvm.h"
 #include "time-event.h"
-#include "fw-dbg.h"
 
 const u8 iwl_mvm_ac_to_tx_fifo[] = {
 	IWL_MVM_TX_FIFO_VO,
@@ -1559,12 +1558,14 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 
 	/* TODO: implement start trigger */
 
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trigger))
+	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
+					   ieee80211_vif_to_wdev(vif),
+					   trigger))
 		return;
 
 	if (rx_missed_bcon_since_rx >= stop_trig_missed_bcon_since_rx ||
 	    rx_missed_bcon >= stop_trig_missed_bcon)
-		iwl_mvm_fw_dbg_collect_trig(mvm, trigger, NULL);
+		iwl_fw_dbg_collect_trig(&mvm->fwrt, trigger, NULL);
 }
 
 void iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index bcde1ba0f1c8..ab6c6bf79565 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -87,7 +87,6 @@
 #include "fw/error-dump.h"
 #include "iwl-prph.h"
 #include "iwl-nvm-parse.h"
-#include "fw-dbg.h"
 
 static const struct ieee80211_iface_limit iwl_mvm_limits[] = {
 	{
@@ -845,11 +844,11 @@ static inline bool iwl_enable_tx_ampdu(const struct iwl_cfg *cfg)
 	return true;
 }
 
-#define CHECK_BA_TRIGGER(_mvm, _trig, _tid_bm, _tid, _fmt...)	\
-	do {							\
-		if (!(le16_to_cpu(_tid_bm) & BIT(_tid)))	\
-			break;					\
-		iwl_mvm_fw_dbg_collect_trig(_mvm, _trig, _fmt);	\
+#define CHECK_BA_TRIGGER(_mvm, _trig, _tid_bm, _tid, _fmt...)		\
+	do {								\
+		if (!(le16_to_cpu(_tid_bm) & BIT(_tid)))		\
+			break;						\
+		iwl_fw_dbg_collect_trig(&(_mvm)->fwrt, _trig, _fmt);	\
 	} while (0)
 
 static void
@@ -866,7 +865,8 @@ iwl_mvm_ampdu_check_trigger(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_BA);
 	ba_trig = (void *)trig->data;
 
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
+	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
+					   ieee80211_vif_to_wdev(vif), trig))
 		return;
 
 	switch (action) {
@@ -1029,8 +1029,8 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	 * on D3->D0 transition
 	 */
 	if (!test_and_clear_bit(IWL_MVM_STATUS_D3_RECONFIG, &mvm->status)) {
-		mvm->fw_dump_desc = &iwl_mvm_dump_desc_assert;
-		iwl_mvm_fw_error_dump(mvm);
+		mvm->fwrt.dump.desc = &iwl_dump_desc_assert;
+		iwl_fw_error_dump(&mvm->fwrt);
 	}
 
 	/* cleanup all stale references (scan, roc), but keep the
@@ -1072,7 +1072,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 
 	mvm->vif_count = 0;
 	mvm->rx_ba_sessions = 0;
-	mvm->fw_dbg_conf = FW_DBG_INVALID;
+	mvm->fwrt.dump.conf = FW_DBG_INVALID;
 
 	/* keep statistics ticking */
 	iwl_mvm_accu_radio_stats(mvm);
@@ -1249,16 +1249,16 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	 * Lock and clear the firmware running bit here already, so that
 	 * new commands coming in elsewhere, e.g. from debugfs, will not
 	 * be able to proceed. This is important here because one of those
-	 * debugfs files causes the fw_dump_wk to be triggered, and if we
+	 * debugfs files causes the firmware dump to be triggered, and if we
 	 * don't stop debugfs accesses before canceling that it could be
 	 * retriggered after we flush it but before we've cleared the bit.
 	 */
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
 
-	cancel_delayed_work_sync(&mvm->fw_dump_wk);
+	iwl_fw_cancel_dump(&mvm->fwrt);
 	cancel_delayed_work_sync(&mvm->cs_tx_unblock_dwork);
 	cancel_delayed_work_sync(&mvm->scan_timeout_dwork);
-	iwl_mvm_free_fw_dump_desc(mvm);
+	iwl_fw_free_dump_desc(&mvm->fwrt);
 
 	mutex_lock(&mvm->mutex);
 	__iwl_mvm_mac_stop(mvm);
@@ -2566,7 +2566,8 @@ iwl_mvm_tdls_check_trigger(struct iwl_mvm *mvm,
 
 	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_TDLS);
 	tdls_trig = (void *)trig->data;
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
+	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
+					   ieee80211_vif_to_wdev(vif), trig))
 		return;
 
 	if (!(tdls_trig->action_bitmap & BIT(action)))
@@ -2576,9 +2577,9 @@ iwl_mvm_tdls_check_trigger(struct iwl_mvm *mvm,
 	    memcmp(tdls_trig->peer, peer_addr, ETH_ALEN) != 0)
 		return;
 
-	iwl_mvm_fw_dbg_collect_trig(mvm, trig,
-				    "TDLS event occurred, peer %pM, action %d",
-				    peer_addr, action);
+	iwl_fw_dbg_collect_trig(&mvm->fwrt, trig,
+				"TDLS event occurred, peer %pM, action %d",
+				peer_addr, action);
 }
 
 static void iwl_mvm_purge_deferred_tx_frames(struct iwl_mvm *mvm,
@@ -3876,7 +3877,9 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(mvm, "pre CSA to freq %d\n",
 			   chsw->chandef.center_freq1);
 
-	iwl_fw_dbg_trigger_simple_stop(mvm, vif, FW_DBG_TRIGGER_CHANNEL_SWITCH);
+	iwl_fw_dbg_trigger_simple_stop(&mvm->fwrt,
+				       ieee80211_vif_to_wdev(vif),
+				       FW_DBG_TRIGGER_CHANNEL_SWITCH);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
@@ -4151,11 +4154,11 @@ static void iwl_mvm_event_mlme_callback(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif,
 					const struct ieee80211_event *event)
 {
-#define CHECK_MLME_TRIGGER(_cnt, _fmt...)			\
-	do {							\
-		if ((trig_mlme->_cnt) && --(trig_mlme->_cnt))	\
-			break;					\
-		iwl_mvm_fw_dbg_collect_trig(mvm, trig, _fmt);	\
+#define CHECK_MLME_TRIGGER(_cnt, _fmt...)				\
+	do {								\
+		if ((trig_mlme->_cnt) && --(trig_mlme->_cnt))		\
+			break;						\
+		iwl_fw_dbg_collect_trig(&(mvm)->fwrt, trig, _fmt);	\
 	} while (0)
 
 	struct iwl_fw_dbg_trigger_tlv *trig;
@@ -4166,7 +4169,8 @@ static void iwl_mvm_event_mlme_callback(struct iwl_mvm *mvm,
 
 	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_MLME);
 	trig_mlme = (void *)trig->data;
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
+	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
+					   ieee80211_vif_to_wdev(vif), trig))
 		return;
 
 	if (event->u.mlme.data == ASSOC_EVENT) {
@@ -4207,16 +4211,17 @@ static void iwl_mvm_event_bar_rx_callback(struct iwl_mvm *mvm,
 
 	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_BA);
 	ba_trig = (void *)trig->data;
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
+	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
+					   ieee80211_vif_to_wdev(vif), trig))
 		return;
 
 	if (!(le16_to_cpu(ba_trig->rx_bar) & BIT(event->u.ba.tid)))
 		return;
 
-	iwl_mvm_fw_dbg_collect_trig(mvm, trig,
-				    "BAR received from %pM, tid %d, ssn %d",
-				    event->u.ba.sta->addr, event->u.ba.tid,
-				    event->u.ba.ssn);
+	iwl_fw_dbg_collect_trig(&mvm->fwrt, trig,
+				"BAR received from %pM, tid %d, ssn %d",
+				event->u.ba.sta->addr, event->u.ba.tid,
+				event->u.ba.ssn);
 }
 
 static void
@@ -4232,15 +4237,16 @@ iwl_mvm_event_frame_timeout_callback(struct iwl_mvm *mvm,
 
 	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_BA);
 	ba_trig = (void *)trig->data;
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
+	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
+					   ieee80211_vif_to_wdev(vif), trig))
 		return;
 
 	if (!(le16_to_cpu(ba_trig->frame_timeout) & BIT(event->u.ba.tid)))
 		return;
 
-	iwl_mvm_fw_dbg_collect_trig(mvm, trig,
-				    "Frame from %pM timed out, tid %d",
-				    event->u.ba.sta->addr, event->u.ba.tid);
+	iwl_fw_dbg_collect_trig(&mvm->fwrt, trig,
+				"Frame from %pM timed out, tid %d",
+				event->u.ba.sta->addr, event->u.ba.tid);
 }
 
 static void iwl_mvm_mac_event_callback(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 988f4c331d15..6fa2c44e6edd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -88,6 +88,7 @@
 #include "constants.h"
 #include "tof.h"
 #include "fw/runtime.h"
+#include "fw/dbg.h"
 
 #define IWL_MVM_MAX_ADDRESSES		5
 /* RSSI offset for WkP */
@@ -138,34 +139,6 @@ struct iwl_mvm_mod_params {
 };
 extern struct iwl_mvm_mod_params iwlmvm_mod_params;
 
-/**
- * struct iwl_mvm_dump_ptrs - set of pointers needed for the fw-error-dump
- *
- * @op_mode_ptr: pointer to the buffer coming from the mvm op_mode
- * @trans_ptr: pointer to struct %iwl_trans_dump_data which contains the
- *	transport's data.
- * @trans_len: length of the valid data in trans_ptr
- * @op_mode_len: length of the valid data in op_mode_ptr
- */
-struct iwl_mvm_dump_ptrs {
-	struct iwl_trans_dump_data *trans_ptr;
-	void *op_mode_ptr;
-	u32 op_mode_len;
-};
-
-/**
- * struct iwl_mvm_dump_desc - describes the dump
- * @len: length of trig_desc->data
- * @trig_desc: the description of the dump
- */
-struct iwl_mvm_dump_desc {
-	size_t len;
-	/* must be last */
-	struct iwl_fw_error_dump_trigger_desc trig_desc;
-};
-
-extern const struct iwl_mvm_dump_desc iwl_mvm_dump_desc_assert;
-
 struct iwl_mvm_phy_ctxt {
 	u16 id;
 	u16 color;
@@ -831,9 +804,6 @@ struct iwl_mvm {
 	/* max number of simultaneous scans the FW supports */
 	unsigned int max_scans;
 
-	/* ts of the beginning of a non-collect fw dbg data period */
-	unsigned long fw_dbg_non_collect_ts_start[FW_DBG_TRIGGER_MAX - 1];
-
 	/* UMAC scan tracking */
 	u32 scan_uid_status[IWL_MVM_MAX_UMAC_SCANS];
 
@@ -909,10 +879,6 @@ struct iwl_mvm {
 
 	/* -1 for always, 0 for never, >0 for that many times */
 	s8 fw_restart;
-	u8 fw_dbg_conf;
-	struct delayed_work fw_dump_wk;
-	const struct iwl_mvm_dump_desc *fw_dump_desc;
-	const struct iwl_fw_dbg_trigger_tlv *fw_dump_trig;
 
 #ifdef CONFIG_IWLWIFI_LEDS
 	struct led_classdev led;
@@ -1077,7 +1043,6 @@ struct iwl_mvm {
  * @IWL_MVM_STATUS_IN_D0I3: NIC is in D0i3
  * @IWL_MVM_STATUS_ROC_AUX_RUNNING: AUX remain-on-channel is running
  * @IWL_MVM_STATUS_D3_RECONFIG: D3 reconfiguration is being done
- * @IWL_MVM_STATUS_DUMPING_FW_LOG: FW log is being dumped
  * @IWL_MVM_STATUS_FIRMWARE_RUNNING: firmware is running
  */
 enum iwl_mvm_status {
@@ -1088,7 +1053,6 @@ enum iwl_mvm_status {
 	IWL_MVM_STATUS_IN_D0I3,
 	IWL_MVM_STATUS_ROC_AUX_RUNNING,
 	IWL_MVM_STATUS_D3_RECONFIG,
-	IWL_MVM_STATUS_DUMPING_FW_LOG,
 	IWL_MVM_STATUS_FIRMWARE_RUNNING,
 };
 
@@ -1780,7 +1744,7 @@ static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 {
 	iwl_free_fw_paging(&mvm->fwrt);
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
-	mvm->fw_dbg_conf = FW_DBG_INVALID;
+	iwl_fw_dump_conf_clear(&mvm->fwrt);
 	iwl_trans_stop_device(mvm->trans);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 60f0c9975538..3c4d82045c1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -84,7 +84,6 @@
 #include "rs.h"
 #include "fw-api-scan.h"
 #include "time-event.h"
-#include "fw-dbg.h"
 #include "fw-api.h"
 #include "fw-api-scan.h"
 
@@ -510,8 +509,6 @@ static u32 calc_min_backoff(struct iwl_trans *trans, const struct iwl_cfg *cfg)
 	return 0;
 }
 
-static void iwl_mvm_fw_error_dump_wk(struct work_struct *work);
-
 static void iwl_mvm_tx_unblock_dwork(struct work_struct *work)
 {
 	struct iwl_mvm *mvm =
@@ -535,6 +532,34 @@ static void iwl_mvm_tx_unblock_dwork(struct work_struct *work)
 	mutex_unlock(&mvm->mutex);
 }
 
+static int iwl_mvm_fwrt_dump_start(void *ctx)
+{
+	struct iwl_mvm *mvm = ctx;
+	int ret;
+
+	ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_FW_DBG_COLLECT);
+	if (ret)
+		return ret;
+
+	mutex_lock(&mvm->mutex);
+
+	return 0;
+}
+
+static void iwl_mvm_fwrt_dump_end(void *ctx)
+{
+	struct iwl_mvm *mvm = ctx;
+
+	mutex_unlock(&mvm->mutex);
+
+	iwl_mvm_unref(mvm, IWL_MVM_REF_FW_DBG_COLLECT);
+}
+
+static const struct iwl_fw_runtime_ops iwl_mvm_fwrt_ops = {
+	.dump_start = iwl_mvm_fwrt_dump_start,
+	.dump_end = iwl_mvm_fwrt_dump_end,
+};
+
 static struct iwl_op_mode *
 iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		      const struct iwl_fw *fw, struct dentry *dbgfs_dir)
@@ -580,7 +605,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mvm->fw = fw;
 	mvm->hw = hw;
 
-	iwl_fw_runtime_init(&mvm->fwrt, trans, fw);
+	iwl_fw_runtime_init(&mvm->fwrt, trans, fw, &iwl_mvm_fwrt_ops, mvm);
 
 	mvm->init_status = 0;
 
@@ -639,7 +664,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_WORK(&mvm->roc_done_wk, iwl_mvm_roc_done_wk);
 	INIT_WORK(&mvm->sta_drained_wk, iwl_mvm_sta_drained_wk);
 	INIT_WORK(&mvm->d0i3_exit_work, iwl_mvm_d0i3_exit_work);
-	INIT_DELAYED_WORK(&mvm->fw_dump_wk, iwl_mvm_fw_error_dump_wk);
 	INIT_DELAYED_WORK(&mvm->tdls_cs.dwork, iwl_mvm_tdls_ch_switch_work);
 	INIT_DELAYED_WORK(&mvm->scan_timeout_dwork, iwl_mvm_scan_timeout_wk);
 	INIT_WORK(&mvm->add_stream_wk, iwl_mvm_add_new_dqa_stream_wk);
@@ -802,7 +826,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	iwl_mvm_leds_exit(mvm);
 	iwl_mvm_thermal_exit(mvm);
  out_free:
-	flush_delayed_work(&mvm->fw_dump_wk);
+	iwl_fw_flush_dump(&mvm->fwrt);
 
 	if (iwlmvm_mod_params.init_dbg)
 		return op_mode;
@@ -922,7 +946,7 @@ static inline void iwl_mvm_rx_check_trigger(struct iwl_mvm *mvm,
 	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_FW_NOTIF);
 	cmds_trig = (void *)trig->data;
 
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, NULL, trig))
+	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt, NULL, trig))
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(cmds_trig->cmds); i++) {
@@ -934,9 +958,9 @@ static inline void iwl_mvm_rx_check_trigger(struct iwl_mvm *mvm,
 		    cmds_trig->cmds[i].group_id != pkt->hdr.group_id)
 			continue;
 
-		iwl_mvm_fw_dbg_collect_trig(mvm, trig,
-					    "CMD 0x%02x.%02x received",
-					    pkt->hdr.group_id, pkt->hdr.cmd);
+		iwl_fw_dbg_collect_trig(&mvm->fwrt, trig,
+					"CMD 0x%02x.%02x received",
+					pkt->hdr.group_id, pkt->hdr.cmd);
 		break;
 	}
 }
@@ -1162,57 +1186,6 @@ static void iwl_mvm_reprobe_wk(struct work_struct *wk)
 	module_put(THIS_MODULE);
 }
 
-static void iwl_mvm_fw_error_dump_wk(struct work_struct *work)
-{
-	struct iwl_mvm *mvm =
-		container_of(work, struct iwl_mvm, fw_dump_wk.work);
-
-	if (iwl_mvm_ref_sync(mvm, IWL_MVM_REF_FW_DBG_COLLECT))
-		return;
-
-	mutex_lock(&mvm->mutex);
-
-	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
-		/* stop recording */
-		iwl_set_bits_prph(mvm->trans, MON_BUFF_SAMPLE_CTL, 0x100);
-
-		iwl_mvm_fw_error_dump(mvm);
-
-		/* start recording again if the firmware is not crashed */
-		if (!test_bit(STATUS_FW_ERROR, &mvm->trans->status) &&
-		    mvm->fw->dbg_dest_tlv) {
-			iwl_clear_bits_prph(mvm->trans,
-					    MON_BUFF_SAMPLE_CTL, 0x100);
-			iwl_clear_bits_prph(mvm->trans,
-					    MON_BUFF_SAMPLE_CTL, 0x1);
-			iwl_set_bits_prph(mvm->trans, MON_BUFF_SAMPLE_CTL, 0x1);
-		}
-	} else {
-		u32 in_sample = iwl_read_prph(mvm->trans, DBGC_IN_SAMPLE);
-		u32 out_ctrl = iwl_read_prph(mvm->trans, DBGC_OUT_CTRL);
-
-		/* stop recording */
-		iwl_write_prph(mvm->trans, DBGC_IN_SAMPLE, 0);
-		udelay(100);
-		iwl_write_prph(mvm->trans, DBGC_OUT_CTRL, 0);
-		/* wait before we collect the data till the DBGC stop */
-		udelay(500);
-
-		iwl_mvm_fw_error_dump(mvm);
-
-		/* start recording again if the firmware is not crashed */
-		if (!test_bit(STATUS_FW_ERROR, &mvm->trans->status) &&
-		    mvm->fw->dbg_dest_tlv) {
-			iwl_write_prph(mvm->trans, DBGC_IN_SAMPLE, in_sample);
-			iwl_write_prph(mvm->trans, DBGC_OUT_CTRL, out_ctrl);
-		}
-	}
-
-	mutex_unlock(&mvm->mutex);
-
-	iwl_mvm_unref(mvm, IWL_MVM_REF_FW_DBG_COLLECT);
-}
-
 void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 {
 	iwl_abort_notification_waits(&mvm->notif_wait);
@@ -1236,8 +1209,8 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	 * can't recover this since we're already half suspended.
 	 */
 	if (!mvm->fw_restart && fw_error) {
-		iwl_mvm_fw_dbg_collect_desc(mvm, &iwl_mvm_dump_desc_assert,
-					    NULL);
+		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
+					NULL);
 	} else if (test_and_set_bit(IWL_MVM_STATUS_IN_HW_RESTART,
 				    &mvm->status)) {
 		struct iwl_mvm_reprobe *reprobe;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 622d543abb70..184c749766f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -67,7 +67,6 @@
 #include "iwl-trans.h"
 #include "mvm.h"
 #include "fw-api.h"
-#include "fw-dbg.h"
 
 /*
  * iwl_mvm_rx_rx_phy_cmd - REPLY_RX_PHY_CMD handler
@@ -397,10 +396,12 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 			rssi = le32_to_cpu(rssi_trig->rssi);
 
 			trig_check =
-				iwl_fw_dbg_trigger_check_stop(mvm, mvmsta->vif,
+				iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
+							      ieee80211_vif_to_wdev(mvmsta->vif),
 							      trig);
 			if (trig_check && rx_status->signal < rssi)
-				iwl_mvm_fw_dbg_collect_trig(mvm, trig, NULL);
+				iwl_fw_dbg_collect_trig(&mvm->fwrt, trig,
+							NULL);
 		}
 
 		if (ieee80211_is_data(hdr->frame_control))
@@ -624,7 +625,7 @@ iwl_mvm_rx_stats_check_trigger(struct iwl_mvm *mvm, struct iwl_rx_packet *pkt)
 	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_STATS);
 	trig_stats = (void *)trig->data;
 
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, NULL, trig))
+	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt, NULL, trig))
 		return;
 
 	trig_offset = le32_to_cpu(trig_stats->stop_offset);
@@ -636,7 +637,7 @@ iwl_mvm_rx_stats_check_trigger(struct iwl_mvm *mvm, struct iwl_rx_packet *pkt)
 	if (le32_to_cpup((__le32 *) (pkt->data + trig_offset)) < trig_thold)
 		return;
 
-	iwl_mvm_fw_dbg_collect_trig(mvm, trig, NULL);
+	iwl_fw_dbg_collect_trig(&mvm->fwrt, trig, NULL);
 }
 
 void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index f3e608196369..13733252c1fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -63,7 +63,6 @@
 #include "iwl-trans.h"
 #include "mvm.h"
 #include "fw-api.h"
-#include "fw-dbg.h"
 
 static inline int iwl_mvm_check_pn(struct iwl_mvm *mvm, struct sk_buff *skb,
 				   int queue, struct ieee80211_sta *sta)
@@ -906,10 +905,12 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			rssi = le32_to_cpu(rssi_trig->rssi);
 
 			trig_check =
-				iwl_fw_dbg_trigger_check_stop(mvm, mvmsta->vif,
+				iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
+							      ieee80211_vif_to_wdev(mvmsta->vif),
 							      trig);
 			if (trig_check && rx_status->signal < rssi)
-				iwl_mvm_fw_dbg_collect_trig(mvm, trig, NULL);
+				iwl_fw_dbg_collect_trig(&mvm->fwrt, trig,
+							NULL);
 		}
 
 		if (ieee80211_is_data(hdr->frame_control))
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 5a682722adce..fcf2d1e4ff4e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -73,7 +73,6 @@
 #include "mvm.h"
 #include "iwl-io.h"
 #include "iwl-prph.h"
-#include "fw-dbg.h"
 
 /*
  * For the high priority TE use a time event type that has similar priority to
@@ -248,7 +247,9 @@ static void iwl_mvm_te_check_trigger(struct iwl_mvm *mvm,
 	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_TIME_EVENT);
 	te_trig = (void *)trig->data;
 
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, te_data->vif, trig))
+	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
+					   ieee80211_vif_to_wdev(te_data->vif),
+					   trig))
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(te_trig->time_events); i++) {
@@ -263,11 +264,11 @@ static void iwl_mvm_te_check_trigger(struct iwl_mvm *mvm,
 		    !(trig_status_bitmap & BIT(le32_to_cpu(notif->status))))
 			continue;
 
-		iwl_mvm_fw_dbg_collect_trig(mvm, trig,
-					    "Time event %d Action 0x%x received status: %d",
-					    te_data->id,
-					    le32_to_cpu(notif->action),
-					    le32_to_cpu(notif->status));
+		iwl_fw_dbg_collect_trig(&mvm->fwrt, trig,
+					"Time event %d Action 0x%x received status: %d",
+					te_data->id,
+					le32_to_cpu(notif->action),
+					le32_to_cpu(notif->status));
 		break;
 	}
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index c7ca6bd3129c..f263a1902e27 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -74,7 +74,6 @@
 #include "iwl-eeprom-parse.h"
 #include "mvm.h"
 #include "sta.h"
-#include "fw-dbg.h"
 
 static void
 iwl_mvm_bar_check_trigger(struct iwl_mvm *mvm, const u8 *addr,
@@ -89,15 +88,15 @@ iwl_mvm_bar_check_trigger(struct iwl_mvm *mvm, const u8 *addr,
 	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_BA);
 	ba_trig = (void *)trig->data;
 
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, NULL, trig))
+	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt, NULL, trig))
 		return;
 
 	if (!(le16_to_cpu(ba_trig->tx_bar) & BIT(tid)))
 		return;
 
-	iwl_mvm_fw_dbg_collect_trig(mvm, trig,
-				    "BAR sent to %pM, tid %d, ssn %d",
-				    addr, tid, ssn);
+	iwl_fw_dbg_collect_trig(&mvm->fwrt, trig,
+				"BAR sent to %pM, tid %d, ssn %d",
+				addr, tid, ssn);
 }
 
 #define OPT_HDR(type, skb, off) \
@@ -1296,7 +1295,7 @@ static void iwl_mvm_tx_status_check_trigger(struct iwl_mvm *mvm,
 	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_TX_STATUS);
 	status_trig = (void *)trig->data;
 
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, NULL, trig))
+	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt, NULL, trig))
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(status_trig->statuses); i++) {
@@ -1307,9 +1306,9 @@ static void iwl_mvm_tx_status_check_trigger(struct iwl_mvm *mvm,
 		if (status_trig->statuses[i].status != (status & TX_STATUS_MSK))
 			continue;
 
-		iwl_mvm_fw_dbg_collect_trig(mvm, trig,
-					    "Tx status %d was received",
-					    status & TX_STATUS_MSK);
+		iwl_fw_dbg_collect_trig(&mvm->fwrt, trig,
+					"Tx status %d was received",
+					status & TX_STATUS_MSK);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 4e80c8fa4741..3ccd16f26b91 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -70,7 +70,6 @@
 #include "iwl-io.h"
 #include "iwl-prph.h"
 #include "iwl-csr.h"
-#include "fw-dbg.h"
 #include "mvm.h"
 #include "fw-api-rs.h"
 
@@ -1190,14 +1189,15 @@ void iwl_mvm_connection_loss(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_MLME);
 	trig_mlme = (void *)trig->data;
-	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
+	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
+					   ieee80211_vif_to_wdev(vif), trig))
 		goto out;
 
 	if (trig_mlme->stop_connection_loss &&
 	    --trig_mlme->stop_connection_loss)
 		goto out;
 
-	iwl_mvm_fw_dbg_collect_trig(mvm, trig, "%s", errmsg);
+	iwl_fw_dbg_collect_trig(&mvm->fwrt, trig, "%s", errmsg);
 
 out:
 	ieee80211_connection_loss(vif);
-- 
2.13.2
