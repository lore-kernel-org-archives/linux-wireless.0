Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062F64483BE
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754910; cv=none; b=XlFSh9eDufqcyK7QfvJRbHqjevBWuo1/OkftD6zOPXrqblqLC8K6DQcFmNxUMXv93pSy62eMGI7ucvTwnlwoL507x49FuLQDFtZbN1lS9+/1f2zPmp2E/E05vfZjpJFXO0qyc7svK9WaUGfGwOcEiROaehxM6Z9HQ+AIvhwFi1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754910; c=relaxed/simple;
	bh=Ax2kOwSP6sWzOPWw4u1A3+y6rX1ERV6D1JK1hho4xLE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RVXLzyMdm/LtD/hPqaLHopaqEuYHT+0aO5B2bBH67b6jvzmoX1BfRivFRCPQ+Qh5KItdZCLT2r+z7KpYPLOJZFwDMEjaQfSIjKcDR3g6cre61QlZK7ZMJ31xghK4V+rvd8pBGaFfIC8IzY8eU4iW4pQD67V+8n5Wuj03o/MGoB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GJiIO1iS; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GJiIO1iS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754908; x=1822290908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ax2kOwSP6sWzOPWw4u1A3+y6rX1ERV6D1JK1hho4xLE=;
  b=GJiIO1iS0y4sSvKCHhmEO0QdI8e4e25jREPqTCtWJOTQMs4Np/j4lcOU
   X84Qz65PHff0rRCamobxR7sIZsj4J+tUb399cF1LD/XMP8BcNELAqCGTR
   k2d6NxE/GSREoAC5FHsc/DDUnnPFMxe2+T4i6x2iAj3rsWG0ceJO89vHU
   tqe7TxGWOE3uu8LZTI/tddkSiHh+UqIDlclpbSsRGAwUtainMYSdhDSgN
   /J6c/cQfKt+++DdEQnnHaF/qZXdCKA7U/HG20jwIDp459HoB8cmKJMEAl
   N8WUKhltcHYq8p2pmD1d7zemRCyt7stvsHQq7wJdYLC6o9/fK9TGghlKR
   w==;
X-CSE-ConnectionGUID: ppzKeLo+QPWLEytzGsCTDQ==
X-CSE-MsgGUID: iZnSrPiRSK+I+igM/emEZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296834"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296834"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:55:08 -0700
X-CSE-ConnectionGUID: RiD9fJgVQBCK/koG7ejsAA==
X-CSE-MsgGUID: 98UtuhKtRk2AXTqBSbcocQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278962993"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:55:06 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 14/15] wifi: iwlwifi: trans: bring virtualization back
Date: Wed, 30 Sep 2026 10:56:42 +0300
Message-Id: <20260930104825.c84aefce6e31.I0b53f83df3faad21c0c39b3e709896e7dde6ac35@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
References: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

We removed virtualization because PCIe is the only bus.

The problem with the if-else approach is that it causes a dual dependency:
the generic trans needs to include the bus specific, and vice-versa.
Besides being a bad design, it also has pratical problems:
1. small functions that could be static inline ones - can't, because
   only iwl-trans.c has the bus specific include.
2. This requires exposing all of the bus internals, not just what needs
   to be exposed.

This commit brings back the virtualization.

Since gen1 and gen2 were never split properly, and since they share
almost all the callbacks, pcie registers with a single ops struct.

This also fixed the debug code to call a generic API for fw reset
handshake, instead of calling the pcie directly.

Assisted-by: GitHubCopilot:claude-opus-4.8
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |   4 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  11 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    | 147 +++++++++++++++++-
 .../wireless/intel/iwlwifi/pcie/internal.h    |   5 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  83 +++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |   3 +
 6 files changed, 246 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 8be5202dba94..1d34ad59bb71 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1820,14 +1820,14 @@ static u32 iwl_dump_ini_trigger(struct iwl_fw_runtime *fwrt,
 			cpu_to_le32(IWL_FW_INI_APPLY_POLICY_SPLIT_DUMP_RESET)) {
 		size += iwl_dump_ini_dump_entries(fwrt, list,
 						  IWL_INI_DUMP_EARLY_REGIONS);
-		iwl_trans_pcie_fw_reset_handshake(fwrt->trans);
+		iwl_trans_fw_reset_handshake(fwrt->trans);
 		size += iwl_dump_ini_dump_entries(fwrt, list,
 						  IWL_INI_DUMP_LATE_REGIONS);
 	} else {
 		if (fw_has_capa(&fwrt->fw->ucode_capa,
 				IWL_UCODE_TLV_CAPA_RESET_DURING_ASSERT) &&
 		    iwl_dump_due_to_error(tp_id))
-			iwl_trans_pcie_fw_reset_handshake(fwrt->trans);
+			iwl_trans_fw_reset_handshake(fwrt->trans);
 		size += iwl_dump_ini_dump_entries(fwrt, list,
 						  IWL_INI_DUMP_ALL_REGIONS);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index b0eb3deba23d..6e068f19af7f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -268,6 +268,7 @@ static void iwl_trans_restart_wk(struct work_struct *wk)
 
 struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 				  struct device *dev,
+				  const struct iwl_trans_ops *ops,
 				  const struct iwl_mac_cfg *mac_cfg)
 {
 	struct iwl_trans *trans;
@@ -279,6 +280,7 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 	if (!trans)
 		return NULL;
 
+	trans->ops = ops;
 	trans->mac_cfg = mac_cfg;
 
 #ifdef CONFIG_LOCKDEP
@@ -932,7 +934,14 @@ IWL_EXPORT_SYMBOL(iwl_trans_activate_nic);
 
 void iwl_trans_reset(struct iwl_trans *trans, enum iwl_reset_mode mode)
 {
-	iwl_trans_pcie_reset(trans, mode);
+	if (!WARN_ON_ONCE(!trans->ops->reset))
+		trans->ops->reset(trans, mode);
 }
 IWL_EXPORT_SYMBOL(iwl_trans_reset);
 
+void iwl_trans_fw_reset_handshake(struct iwl_trans *trans)
+{
+	if (!WARN_ON_ONCE(!trans->ops->fw_reset_handshake))
+		trans->ops->fw_reset_handshake(trans);
+}
+
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 719b6c9ba360..90100f16ddd5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -734,12 +734,15 @@ struct iwl_trans_info {
 	u8 num_rxqs;
 };
 
+struct iwl_trans_ops;
+
 /**
  * struct iwl_trans - transport common data
  *
  * @csme_own: true if we couldn't get ownership on the device
  * @op_mode: pointer to the op_mode
  * @mac_cfg: the trans-specific configuration part
+ * @ops: bus-specific transport operations, see &struct iwl_trans_ops
  * @cfg: pointer to the configuration
  * @drv: pointer to iwl_drv
  * @conf: configuration set by the opmode before enter
@@ -773,6 +776,7 @@ struct iwl_trans {
 	bool csme_own;
 	struct iwl_op_mode *op_mode;
 	const struct iwl_mac_cfg *mac_cfg;
+	const struct iwl_trans_ops *ops;
 	const struct iwl_rf_cfg *cfg;
 	struct iwl_drv *drv;
 	struct iwl_trans_config conf;
@@ -1146,6 +1150,7 @@ static inline void iwl_trans_finish_sw_reset(struct iwl_trans *trans)
  *****************************************************/
 struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 				  struct device *dev,
+				  const struct iwl_trans_ops *ops,
 				  const struct iwl_mac_cfg *mac_cfg);
 void iwl_trans_free(struct iwl_trans *trans);
 
@@ -1217,7 +1222,147 @@ enum iwl_reset_mode {
 };
 
 void iwl_trans_reset(struct iwl_trans *trans, enum iwl_reset_mode mode);
-void iwl_trans_pcie_fw_reset_handshake(struct iwl_trans *trans);
+void iwl_trans_fw_reset_handshake(struct iwl_trans *trans);
+
+/**
+ * struct iwl_trans_ops - bus-specific transport operations
+ *
+ * Function-pointer table filled in by the bus implementation. Unless noted
+ * otherwise, each callback implements the identically named iwl_trans_*()
+ * API, see its documentation.
+ *
+ * @op_mode_enter: the op_mode took ownership of the transport
+ * @start_hw: start the hardware
+ * @op_mode_leave: the op_mode released the transport
+ * @send_cmd: send a host command to the firmware
+ * @alloc_tx_cmd: allocate a device TX command
+ * @free_tx_cmd: free a device TX command
+ * @write8: write a byte to a device register
+ * @write32: write a dword to a device register
+ * @read32: read a dword from a device register
+ * @read_prph: read a peripheral register
+ * @write_prph: write a peripheral register
+ * @read_mem: read device memory, taking NIC access
+ * @read_mem_no_grab: read device memory, NIC access already taken
+ * @set_bits_mask: read-modify-write a device register
+ * @read_config32: read a dword from the bus configuration space
+ * @grab_nic_access: keep the NIC awake for register access
+ * @release_nic_access: release the NIC access taken by @grab_nic_access
+ * @resched_with_nic_access: reschedule while holding NIC access
+ * @sw_reset: perform a software reset of the device
+ * @reset: reset the device, see &enum iwl_reset_mode
+ * @fw_reset_handshake: do a firmware reset handshake.
+ * @dump_data: collect a firmware error dump
+ * @d3_suspend: prepare the device for D3 (WoWLAN)
+ * @d3_resume: resume the device from D3 (WoWLAN)
+ * @sync_nmi: trigger an NMI and wait for it to be handled
+ * @write_imr_mem: write to the IMR memory region
+ * @fw_alive: Notify trans that the firmware sent the ALIVE notification
+ * @start_fw: download firmware code to the device and and start the firmware
+ * @stop_device: stop the device and the firmware
+ * @tx: transmit an MPDU
+ * @reclaim: free TX MPDUs up to the given sequence number
+ * @txq_disable: disable a TX queue (gen1)
+ * @txq_enable: enable a TX queue (gen1)
+ * @wait_txq_empty: wait for a single TX queue to become empty
+ * @wait_txqs_empty: wait for the given TX queues to become empty
+ * @freeze_txq_timer: freeze/unfreeze the watchdog of the given TX queues
+ * @txq_set_shared_mode: mark a TX queue as shared between TIDs
+ * @set_q_ptrs: set the write pointer of a TX queue
+ * @txq_alloc: allocate a TX queue (gen2)
+ * @txq_free: free a TX queue allocated by @txq_alloc
+ * @rxq_dma_data: get the DMA addresses of an RX queue
+ * @load_pnvm: load the PNVM image
+ * @set_pnvm: tell the firmware to use the loaded PNVM
+ * @load_reduce_power: load the reduced power table
+ * @set_reduce_power: tell the firmware to use the reduced power table
+ * @is_pm_supported: whether bus power management is supported
+ * @is_ltr_enabled: whether LTR is enabled on the bus
+ * @activate_nic: bring the NIC out of low power and make it accessible
+ */
+struct iwl_trans_ops {
+	void (*op_mode_enter)(struct iwl_trans *trans);
+	int (*start_hw)(struct iwl_trans *trans);
+	void (*op_mode_leave)(struct iwl_trans *trans);
+
+	int (*send_cmd)(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
+	struct iwl_device_tx_cmd *(*alloc_tx_cmd)(struct iwl_trans *trans);
+	void (*free_tx_cmd)(struct iwl_trans *trans,
+			    struct iwl_device_tx_cmd *dev_cmd);
+
+	void (*write8)(struct iwl_trans *trans, u32 ofs, u8 val);
+	void (*write32)(struct iwl_trans *trans, u32 ofs, u32 val);
+	u32 (*read32)(struct iwl_trans *trans, u32 ofs);
+	u32 (*read_prph)(struct iwl_trans *trans, u32 ofs);
+	void (*write_prph)(struct iwl_trans *trans, u32 ofs, u32 val);
+	int (*read_mem)(struct iwl_trans *trans, u32 addr,
+			void *buf, int dwords);
+	int (*read_mem_no_grab)(struct iwl_trans *trans, u32 addr,
+				void *buf, u32 dwords);
+	void (*set_bits_mask)(struct iwl_trans *trans, u32 reg,
+			      u32 mask, u32 value);
+	int (*read_config32)(struct iwl_trans *trans, u32 ofs, u32 *val);
+	bool (*grab_nic_access)(struct iwl_trans *trans);
+	void (*release_nic_access)(struct iwl_trans *trans);
+	void (*resched_with_nic_access)(struct iwl_trans *trans);
+
+	int (*sw_reset)(struct iwl_trans *trans, bool retake_ownership);
+	void (*reset)(struct iwl_trans *trans, enum iwl_reset_mode mode);
+	void (*fw_reset_handshake)(struct iwl_trans *trans);
+
+	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans,
+						 u32 dump_mask,
+						 const struct iwl_dump_sanitize_ops *sanitize_ops,
+						 void *sanitize_ctx);
+	int (*d3_suspend)(struct iwl_trans *trans, bool reset);
+	int (*d3_resume)(struct iwl_trans *trans, bool reset);
+
+	void (*sync_nmi)(struct iwl_trans *trans);
+	int (*write_imr_mem)(struct iwl_trans *trans, u32 dst_addr,
+			     u64 src_addr, u32 byte_cnt);
+
+	void (*fw_alive)(struct iwl_trans *trans);
+	int (*start_fw)(struct iwl_trans *trans, const struct iwl_fw *fw,
+			const struct fw_img *img, bool run_in_rfkill);
+	void (*stop_device)(struct iwl_trans *trans);
+
+	int (*tx)(struct iwl_trans *trans, struct sk_buff *skb,
+		  struct iwl_device_tx_cmd *dev_cmd, int queue);
+	void (*reclaim)(struct iwl_trans *trans, int queue, int ssn,
+			struct sk_buff_head *skbs, bool is_flush);
+	void (*txq_disable)(struct iwl_trans *trans, int queue,
+			    bool configure_scd);
+	bool (*txq_enable)(struct iwl_trans *trans, int queue, u16 ssn,
+			   const struct iwl_trans_txq_scd_cfg *cfg,
+			   unsigned int queue_wdg_timeout);
+	int (*wait_txq_empty)(struct iwl_trans *trans, int queue);
+	int (*wait_txqs_empty)(struct iwl_trans *trans, u32 txqs);
+	void (*freeze_txq_timer)(struct iwl_trans *trans,
+				 unsigned long txqs, bool freeze);
+	void (*txq_set_shared_mode)(struct iwl_trans *trans, u32 txq_id,
+				    bool shared_mode);
+	void (*set_q_ptrs)(struct iwl_trans *trans, int queue, int ptr);
+	int (*txq_alloc)(struct iwl_trans *trans, u32 flags, u32 sta_mask,
+			 u8 tid, int size, unsigned int wdg_timeout);
+	void (*txq_free)(struct iwl_trans *trans, int queue);
+	int (*rxq_dma_data)(struct iwl_trans *trans, int queue,
+			    struct iwl_trans_rxq_dma_data *data);
+
+	int (*load_pnvm)(struct iwl_trans *trans,
+			 const struct iwl_pnvm_image *pnvm_data,
+			 const struct iwl_ucode_capabilities *capa);
+	void (*set_pnvm)(struct iwl_trans *trans,
+			 const struct iwl_ucode_capabilities *capa);
+	int (*load_reduce_power)(struct iwl_trans *trans,
+				 const struct iwl_pnvm_image *payloads,
+				 const struct iwl_ucode_capabilities *capa);
+	void (*set_reduce_power)(struct iwl_trans *trans,
+				 const struct iwl_ucode_capabilities *capa);
+
+	bool (*is_pm_supported)(struct iwl_trans *trans);
+	bool (*is_ltr_enabled)(struct iwl_trans *trans);
+	int (*activate_nic)(struct iwl_trans *trans);
+};
 
 /* Internal helper */
 static inline void iwl_trans_set_info(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index fab73693e683..01bfc1492c84 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -31,6 +31,9 @@ u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs);
 u32 iwl_trans_pcie_read_prph(struct iwl_trans *trans, u32 reg);
 void iwl_pcie_write_prph_no_grab(struct iwl_trans *trans, u32 addr, u32 val);
 
+/* bus-specific transport operations table */
+extern const struct iwl_trans_ops iwl_trans_pcie_ops;
+
 /*
  * RX related structures and functions
  */
@@ -1148,7 +1151,7 @@ int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 int iwl_trans_pcie_read_mem_no_grab(struct iwl_trans *trans, u32 addr,
 				    void *buf, u32 dwords);
 int iwl_trans_pcie_sw_reset(struct iwl_trans *trans, bool retake_ownership);
-void iwl_trans_pcie_reset(struct iwl_trans *trans, enum iwl_reset_mode mode);
+void iwl_trans_pcie_fw_reset_handshake(struct iwl_trans *trans);
 struct iwl_trans_dump_data *
 iwl_trans_pcie_dump_data(struct iwl_trans *trans, u32 dump_mask,
 			 const struct iwl_dump_sanitize_ops *sanitize_ops,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 59e9ef0d6b51..eda88940dd07 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1288,6 +1288,10 @@ int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	bool hw_rfkill;
 	int ret;
 
+	if (trans->mac_cfg->gen2)
+		return iwl_trans_pcie_gen2_start_fw(trans, fw, img,
+						    run_in_rfkill);
+
 	/* This may fail if AMT took ownership of the device */
 	if (iwl_pcie_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
@@ -1370,6 +1374,11 @@ int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 
 void iwl_trans_pcie_fw_alive(struct iwl_trans *trans)
 {
+	if (trans->mac_cfg->gen2) {
+		iwl_trans_pcie_gen2_fw_alive(trans);
+		return;
+	}
+
 	iwl_pcie_reset_ict(trans);
 	iwl_pcie_tx_start(trans);
 }
@@ -1408,6 +1417,11 @@ void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	bool was_in_rfkill;
 
+	if (trans->mac_cfg->gen2) {
+		iwl_trans_pcie_gen2_stop_device(trans);
+		return;
+	}
+
 	iwl_op_mode_time_point(trans->op_mode,
 			       IWL_FW_INI_TIME_POINT_HOST_DEVICE_DISABLE,
 			       NULL);
@@ -1846,6 +1860,11 @@ void iwl_trans_pcie_op_mode_leave(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	if (trans->mac_cfg->gen2) {
+		iwl_trans_pcie_gen2_op_mode_leave(trans);
+		return;
+	}
+
 	mutex_lock(&trans_pcie->mutex);
 
 	/* disable interrupts - don't enable HW RF kill interrupt */
@@ -2274,7 +2293,7 @@ static void iwl_trans_pcie_removal_wk(struct work_struct *wk)
 	module_put(THIS_MODULE);
 }
 
-void iwl_trans_pcie_reset(struct iwl_trans *trans, enum iwl_reset_mode mode)
+static void iwl_trans_pcie_reset(struct iwl_trans *trans, enum iwl_reset_mode mode)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_trans_pcie_removal *removal;
@@ -3659,6 +3678,66 @@ static int iwl_trans_pcie_alloc_txcmd_pool(struct iwl_trans *trans)
 	return 0;
 }
 
+const struct iwl_trans_ops iwl_trans_pcie_ops = {
+	.op_mode_enter = iwl_trans_pcie_op_mode_enter,
+	.start_hw = iwl_trans_pcie_start_hw,
+	.op_mode_leave = iwl_trans_pcie_op_mode_leave,
+
+	.send_cmd = iwl_trans_pcie_send_hcmd,
+	.alloc_tx_cmd = iwl_pcie_alloc_tx_cmd,
+	.free_tx_cmd = iwl_pcie_free_tx_cmd,
+
+	.write8 = iwl_trans_pcie_write8,
+	.write32 = iwl_trans_pcie_write32,
+	.read32 = iwl_trans_pcie_read32,
+	.read_prph = iwl_trans_pcie_read_prph,
+	.write_prph = iwl_pcie_write_prph_no_grab,
+	.read_mem = iwl_trans_pcie_read_mem,
+	.read_mem_no_grab = iwl_trans_pcie_read_mem_no_grab,
+	.set_bits_mask = iwl_trans_pcie_set_bits_mask,
+	.read_config32 = iwl_trans_pcie_read_config32,
+	.grab_nic_access = iwl_trans_pcie_grab_nic_access,
+	.release_nic_access = iwl_trans_pcie_release_nic_access,
+	.resched_with_nic_access = iwl_trans_pcie_resched_with_nic_access,
+
+	.sw_reset = iwl_trans_pcie_sw_reset,
+	.reset = iwl_trans_pcie_reset,
+	.fw_reset_handshake = iwl_trans_pcie_fw_reset_handshake,
+
+	.dump_data = iwl_trans_pcie_dump_data,
+	.d3_suspend = iwl_trans_pcie_d3_suspend,
+	.d3_resume = iwl_trans_pcie_d3_resume,
+
+	.sync_nmi = iwl_trans_pcie_sync_nmi,
+	.write_imr_mem = iwl_trans_pcie_copy_imr,
+
+	.fw_alive = iwl_trans_pcie_fw_alive,
+	.start_fw = iwl_trans_pcie_start_fw,
+	.stop_device = iwl_trans_pcie_stop_device,
+
+	.tx = iwl_trans_pcie_tx,
+	.reclaim = iwl_pcie_reclaim,
+	.txq_disable = iwl_trans_pcie_txq_disable,
+	.txq_enable = iwl_trans_pcie_txq_enable,
+	.wait_txq_empty = iwl_trans_pcie_wait_txq_empty,
+	.wait_txqs_empty = iwl_trans_pcie_wait_txqs_empty,
+	.freeze_txq_timer = iwl_pcie_freeze_txq_timer,
+	.txq_set_shared_mode = iwl_trans_pcie_txq_set_shared_mode,
+	.set_q_ptrs = iwl_pcie_set_q_ptrs,
+	.txq_alloc = iwl_txq_dyn_alloc,
+	.txq_free = iwl_txq_dyn_free,
+	.rxq_dma_data = iwl_trans_pcie_rxq_dma_data,
+
+	.load_pnvm = iwl_trans_pcie_ctx_info_v2_load_pnvm,
+	.set_pnvm = iwl_trans_pcie_ctx_info_v2_set_pnvm,
+	.load_reduce_power = iwl_trans_pcie_ctx_info_v2_load_reduce_power,
+	.set_reduce_power = iwl_trans_pcie_ctx_info_v2_set_reduce_power,
+
+	.is_pm_supported = iwl_pcie_gen1_is_pm_supported,
+	.is_ltr_enabled = iwl_pcie_is_ltr_enabled,
+	.activate_nic = iwl_pcie_activate_nic,
+};
+
 static struct iwl_trans *
 iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		     const struct iwl_mac_cfg *mac_cfg,
@@ -3670,7 +3749,7 @@ iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	int ret, addr_size;
 
 	trans = iwl_trans_alloc(sizeof(struct iwl_trans_pcie), &pdev->dev,
-				mac_cfg);
+				&iwl_trans_pcie_ops, mac_cfg);
 	if (!trans)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index d612678ae122..0c29fb6b9ca7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -2147,6 +2147,9 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	u16 wifi_seq;
 	bool amsdu;
 
+	if (trans->mac_cfg->gen2)
+		return iwl_txq_gen2_tx(trans, skb, dev_cmd, txq_id);
+
 	txq = trans_pcie->txqs.txq[txq_id];
 
 	if (WARN_ONCE(!test_bit(txq_id, trans_pcie->txqs.queue_used),
-- 
2.34.1

