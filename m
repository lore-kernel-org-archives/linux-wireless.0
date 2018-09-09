Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48078 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726627AbeIIO04 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:56 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:53 +0300
Message-Id: <20180909093656.10194-14-luca@coelho.fi> (sfid-20180909_113753_638722_861A3657)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 13/16] iwlwifi: pcie: add infrastructure for multiple debug buffers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In future devices we will have more than one debug buffer.
Prepare the infrastructure for allocation and release of
multiple debug buffers by grouping the variables in an array
of structures and moving it to trans section, where they will
be visible to opmode and FW.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  17 +++
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       |   4 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  19 ---
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 116 +++++++++---------
 4 files changed, 79 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 388793b89856..6c636b2a6b43 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -679,6 +679,19 @@ enum iwl_plat_pm_mode {
  * enter/exit (in msecs).
  */
 #define IWL_TRANS_IDLE_TIMEOUT 2000
+#define IWL_MAX_DEBUG_ALLOCATIONS	1
+
+/**
+ * struct iwl_dram_data
+ * @physical: page phy pointer
+ * @block: pointer to the allocated block/page
+ * @size: size of the block/page
+ */
+struct iwl_dram_data {
+	dma_addr_t physical;
+	void *block;
+	int size;
+};
 
 /**
  * struct iwl_trans - transport common data
@@ -713,6 +726,8 @@ enum iwl_plat_pm_mode {
  * @dbg_conf_tlv: array of pointers to configuration TLVs for debug
  * @dbg_trigger_tlv: array of pointers to triggers TLVs for debug
  * @dbg_dest_reg_num: num of reg_ops in %dbg_dest_tlv
+ * @num_blocks: number of blocks in fw_mon
+ * @fw_mon: address of the buffers for firmware monitor
  * @system_pm_mode: the system-wide power management mode in use.
  *	This mode is set dynamically, depending on the WoWLAN values
  *	configured from the userspace at runtime.
@@ -764,6 +779,8 @@ struct iwl_trans {
 	struct iwl_fw_dbg_trigger_tlv * const *dbg_trigger_tlv;
 	u32 dbg_dump_mask;
 	u8 dbg_dest_reg_num;
+	int num_blocks;
+	struct iwl_dram_data fw_mon[IWL_MAX_DEBUG_ALLOCATIONS];
 
 	enum iwl_plat_pm_mode system_pm_mode;
 	enum iwl_plat_pm_mode runtime_pm_mode;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index 2146fda8da2f..05ed4fb88e0c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -96,9 +96,9 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	/* Configure debug, for integration */
 	iwl_pcie_alloc_fw_monitor(trans, 0);
 	prph_sc_ctrl->hwm_cfg.hwm_base_addr =
-		cpu_to_le64(trans_pcie->fw_mon_phys);
+		cpu_to_le64(trans->fw_mon[0].physical);
 	prph_sc_ctrl->hwm_cfg.hwm_size =
-		cpu_to_le32(trans_pcie->fw_mon_size);
+		cpu_to_le32(trans->fw_mon[0].size);
 
 	/* allocate ucode sections in dram and set addresses */
 	ret = iwl_pcie_init_fw_sec(trans, fw, &prph_scratch->dram);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 769b7354fabe..f9c4c64dee66 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -400,18 +400,6 @@ enum iwl_image_response_code {
 	IWL_IMAGE_RESP_FAIL		= 2,
 };
 
-/**
- * struct iwl_dram_data
- * @physical: page phy pointer
- * @block: pointer to the allocated block/page
- * @size: size of the block/page
- */
-struct iwl_dram_data {
-	dma_addr_t physical;
-	void *block;
-	int size;
-};
-
 /**
  * struct iwl_self_init_dram - dram data used by self init process
  * @fw: lmac and umac dram data
@@ -463,9 +451,6 @@ struct iwl_self_init_dram {
  * @reg_lock: protect hw register access
  * @mutex: to protect stop_device / start_fw / start_hw
  * @cmd_in_flight: true when we have a host command in flight
- * @fw_mon_phys: physical address of the buffer for the firmware monitor
- * @fw_mon_cpu_addr: address of the buffer for the firmware monitor
- * @fw_mon_size: size of the buffer for the firmware monitor
  * @msix_entries: array of MSI-X entries
  * @msix_enabled: true if managed to enable MSI-X
  * @shared_vec_mask: the type of causes the shared vector handles
@@ -553,10 +538,6 @@ struct iwl_trans_pcie {
 	bool cmd_hold_nic_awake;
 	bool ref_cmd_in_flight;
 
-	dma_addr_t fw_mon_phys;
-	void *fw_mon_cpu_addr;
-	u32 fw_mon_size;
-
 	struct msix_entry msix_entries[IWL_MAX_RX_HW_QUEUES];
 	bool msix_enabled;
 	u8 shared_vec_mask;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index a5f51018029a..bc6682a11fa4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -185,44 +185,28 @@ static void iwl_trans_pcie_sw_reset(struct iwl_trans *trans)
 
 static void iwl_pcie_free_fw_monitor(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (!trans_pcie->fw_mon_cpu_addr)
-		return;
+	int i;
 
-	dma_free_coherent(trans->dev, trans_pcie->fw_mon_size,
-			  trans_pcie->fw_mon_cpu_addr,
-			  trans_pcie->fw_mon_phys);
-	trans_pcie->fw_mon_cpu_addr = NULL;
-	trans_pcie->fw_mon_phys = 0;
-	trans_pcie->fw_mon_size = 0;
+	for (i = 0; i < trans->num_blocks; i++) {
+		dma_free_coherent(trans->dev, trans->fw_mon[i].size,
+				  trans->fw_mon[i].block,
+				  trans->fw_mon[i].physical);
+		trans->fw_mon[i].block = NULL;
+		trans->fw_mon[i].physical = 0;
+		trans->fw_mon[i].size = 0;
+		trans->num_blocks--;
+	}
 }
 
-void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans, u8 max_power)
+static void iwl_pcie_alloc_fw_monitor_block(struct iwl_trans *trans,
+					    u8 max_power, u8 min_power)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	void *cpu_addr = NULL;
-	dma_addr_t phys;
+	dma_addr_t phys = 0;
 	u32 size = 0;
 	u8 power;
 
-	if (!max_power) {
-		/* default max_power is maximum */
-		max_power = 26;
-	} else {
-		max_power += 11;
-	}
-
-	if (WARN(max_power > 26,
-		 "External buffer size for monitor is too big %d, check the FW TLV\n",
-		 max_power))
-		return;
-
-	if (trans_pcie->fw_mon_cpu_addr)
-		return;
-
-	phys = 0;
-	for (power = max_power; power >= 11; power--) {
+	for (power = max_power; power >= min_power; power--) {
 		size = BIT(power);
 		cpu_addr = dma_alloc_coherent(trans->dev, size, &phys,
 					      GFP_KERNEL | __GFP_NOWARN |
@@ -245,9 +229,34 @@ void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans, u8 max_power)
 			(unsigned long)BIT(power - 10),
 			(unsigned long)BIT(max_power - 10));
 
-	trans_pcie->fw_mon_cpu_addr = cpu_addr;
-	trans_pcie->fw_mon_phys = phys;
-	trans_pcie->fw_mon_size = size;
+	trans->fw_mon[trans->num_blocks].block = cpu_addr;
+	trans->fw_mon[trans->num_blocks].physical = phys;
+	trans->fw_mon[trans->num_blocks].size = size;
+	trans->num_blocks++;
+}
+
+void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans, u8 max_power)
+{
+	if (!max_power) {
+		/* default max_power is maximum */
+		max_power = 26;
+	} else {
+		max_power += 11;
+	}
+
+	if (WARN(max_power > 26,
+		 "External buffer size for monitor is too big %d, check the FW TLV\n",
+		 max_power))
+		return;
+
+	/*
+	 * This function allocats the default fw monitor.
+	 * The optional additional ones will be allocated in runtime
+	 */
+	if (trans->num_blocks)
+		return;
+
+	iwl_pcie_alloc_fw_monitor_block(trans, max_power, 11);
 }
 
 static u32 iwl_trans_pcie_read_shr(struct iwl_trans *trans, u32 reg)
@@ -911,7 +920,6 @@ static int iwl_pcie_load_cpu_sections(struct iwl_trans *trans,
 
 void iwl_pcie_apply_destination(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	const struct iwl_fw_dbg_dest_tlv_v1 *dest = trans->dbg_dest_tlv;
 	int i;
 
@@ -962,18 +970,18 @@ void iwl_pcie_apply_destination(struct iwl_trans *trans)
 	}
 
 monitor:
-	if (dest->monitor_mode == EXTERNAL_MODE && trans_pcie->fw_mon_size) {
+	if (dest->monitor_mode == EXTERNAL_MODE && trans->fw_mon[0].size) {
 		iwl_write_prph(trans, le32_to_cpu(dest->base_reg),
-			       trans_pcie->fw_mon_phys >> dest->base_shift);
+			       trans->fw_mon[0].physical >> dest->base_shift);
 		if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_8000)
 			iwl_write_prph(trans, le32_to_cpu(dest->end_reg),
-				       (trans_pcie->fw_mon_phys +
-					trans_pcie->fw_mon_size - 256) >>
+				       (trans->fw_mon[0].physical +
+					trans->fw_mon[0].size - 256) >>
 						dest->end_shift);
 		else
 			iwl_write_prph(trans, le32_to_cpu(dest->end_reg),
-				       (trans_pcie->fw_mon_phys +
-					trans_pcie->fw_mon_size) >>
+				       (trans->fw_mon[0].physical +
+					trans->fw_mon[0].size) >>
 						dest->end_shift);
 	}
 }
@@ -981,7 +989,6 @@ void iwl_pcie_apply_destination(struct iwl_trans *trans)
 static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 				const struct fw_img *image)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret = 0;
 	int first_ucode_section;
 
@@ -1011,12 +1018,12 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 	    trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
 		iwl_pcie_alloc_fw_monitor(trans, 0);
 
-		if (trans_pcie->fw_mon_size) {
+		if (trans->fw_mon[0].size) {
 			iwl_write_prph(trans, MON_BUFF_BASE_ADDR,
-				       trans_pcie->fw_mon_phys >> 4);
+				       trans->fw_mon[0].physical >> 4);
 			iwl_write_prph(trans, MON_BUFF_END_ADDR,
-				       (trans_pcie->fw_mon_phys +
-					trans_pcie->fw_mon_size) >> 4);
+				       (trans->fw_mon[0].physical +
+					trans->fw_mon[0].size) >> 4);
 		}
 	} else if (trans->dbg_dest_tlv) {
 		iwl_pcie_apply_destination(trans);
@@ -2852,10 +2859,9 @@ iwl_trans_pcie_dump_monitor(struct iwl_trans *trans,
 			    struct iwl_fw_error_dump_data **data,
 			    u32 monitor_len)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 len = 0;
 
-	if ((trans_pcie->fw_mon_cpu_addr &&
+	if ((trans->num_blocks &&
 	     trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) ||
 	    trans->dbg_dest_tlv) {
 		struct iwl_fw_error_dump_fw_mon *fw_mon_data;
@@ -2883,12 +2889,12 @@ iwl_trans_pcie_dump_monitor(struct iwl_trans *trans,
 			cpu_to_le32(iwl_read_prph(trans, base));
 
 		len += sizeof(**data) + sizeof(*fw_mon_data);
-		if (trans_pcie->fw_mon_cpu_addr) {
+		if (trans->num_blocks) {
 			memcpy(fw_mon_data->data,
-			       trans_pcie->fw_mon_cpu_addr,
-			       trans_pcie->fw_mon_size);
+			       trans->fw_mon[0].block,
+			       trans->fw_mon[0].size);
 
-			monitor_len = trans_pcie->fw_mon_size;
+			monitor_len = trans->fw_mon[0].size;
 		} else if (trans->dbg_dest_tlv->monitor_mode == SMEM_MODE) {
 			/*
 			 * Update pointers to reflect actual values after
@@ -2926,13 +2932,11 @@ iwl_trans_pcie_dump_monitor(struct iwl_trans *trans,
 
 static int iwl_trans_get_fw_monitor_len(struct iwl_trans *trans, int *len)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (trans_pcie->fw_mon_cpu_addr) {
+	if (trans->num_blocks) {
 		*len += sizeof(struct iwl_fw_error_dump_data) +
 			sizeof(struct iwl_fw_error_dump_fw_mon) +
-			trans_pcie->fw_mon_size;
-		return trans_pcie->fw_mon_size;
+			trans->fw_mon[0].size;
+		return trans->fw_mon[0].size;
 	} else if (trans->dbg_dest_tlv) {
 		u32 base, end, cfg_reg, monitor_len;
 
-- 
2.18.0
