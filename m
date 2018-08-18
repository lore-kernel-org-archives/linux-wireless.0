Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42096 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726072AbeHRLew (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 07:34:52 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 18 Aug 2018 11:27:39 +0300
Message-Id: <20180818082750.28717-6-luca@coelho.fi> (sfid-20180818_102814_743008_1CDAE626)
In-Reply-To: <20180818082750.28717-1-luca@coelho.fi>
References: <20180818082750.28717-1-luca@coelho.fi>
Subject: [PATCH 05/16] iwlwifi: add d3 debug data support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

During d3, the firmware records debug data into internal buffer
if debug data collection occurs, collect the data that was written to the
buffer

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 48 +++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   | 10 ++++
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  8 ++--
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  2 +
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  1 +
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  4 ++
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  6 ++-
 12 files changed, 85 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 91ca77c7571c..c6b738c8fd84 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -155,7 +155,9 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.gen2 = true,							\
 	.nvm_type = IWL_NVM_EXT,					\
 	.dbgc_supported = true,						\
-	.min_umac_error_event_table = 0x400000
+	.min_umac_error_event_table = 0x400000,				\
+	.d3_debug_data_base_addr = 0x401000,				\
+	.d3_debug_data_length = 60 * 1024
 
 #define IWL_DEVICE_22500						\
 	IWL_DEVICE_22000_COMMON,					\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index 24b2f7cbb308..37deaf4fd7b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -155,7 +155,9 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.nvm_type = IWL_NVM_EXT,					\
 	.dbgc_supported = true,						\
 	.min_umac_error_event_table = 0x800000,				\
-	.csr = &iwl_csr_v1
+	.csr = &iwl_csr_v1,						\
+	.d3_debug_data_base_addr = 0x401000,				\
+	.d3_debug_data_length = 92 * 1024
 
 const struct iwl_cfg iwl9160_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9160",
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index bab54c9889af..70173ad11050 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -746,6 +746,11 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 			 sizeof(struct iwl_fw_error_dump_paging) +
 			 PAGING_BLOCK_SIZE);
 
+	if (iwl_fw_dbg_is_d3_debug_enabled(fwrt) && fwrt->dump.d3_debug_data) {
+		file_len += sizeof(*dump_data) +
+			fwrt->trans->cfg->d3_debug_data_length * 2;
+	}
+
 	/* If we only want a monitor dump, reset the file length */
 	if (monitor_dump_only) {
 		file_len = sizeof(*dump_file) + sizeof(*dump_data) * 2 +
@@ -858,6 +863,26 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
+	if (iwl_fw_dbg_is_d3_debug_enabled(fwrt) && fwrt->dump.d3_debug_data) {
+		u32 addr = fwrt->trans->cfg->d3_debug_data_base_addr;
+		size_t data_size = fwrt->trans->cfg->d3_debug_data_length;
+
+		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_D3_DEBUG_DATA);
+		dump_data->len = cpu_to_le32(data_size * 2);
+
+		memcpy(dump_data->data, fwrt->dump.d3_debug_data,
+		       data_size);
+
+		kfree(fwrt->dump.d3_debug_data);
+		fwrt->dump.d3_debug_data = NULL;
+
+		iwl_trans_read_mem_bytes(fwrt->trans, addr,
+					 dump_data->data + data_size,
+					 data_size);
+
+		dump_data = iwl_fw_error_next_data(dump_data);
+	}
+
 	for (i = 0; i < fwrt->fw->n_dbg_mem_tlv; i++) {
 		u32 len = le32_to_cpu(fw_dbg_mem[i].len);
 		u32 ofs = le32_to_cpu(fw_dbg_mem[i].ofs);
@@ -1212,3 +1237,26 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 		fwrt->ops->dump_end(fwrt->ops_ctx);
 }
 
+void iwl_fw_dbg_read_d3_debug_data(struct iwl_fw_runtime *fwrt)
+{
+	const struct iwl_cfg *cfg = fwrt->trans->cfg;
+
+	if (!iwl_fw_dbg_is_d3_debug_enabled(fwrt))
+		return;
+
+	if (!fwrt->dump.d3_debug_data) {
+		fwrt->dump.d3_debug_data = kmalloc(cfg->d3_debug_data_length,
+						   GFP_KERNEL);
+		if (!fwrt->dump.d3_debug_data) {
+			IWL_ERR(fwrt,
+				"failed to allocate memory for D3 debug data\n");
+			return;
+		}
+	}
+
+	/* if the buffer holds previous debug data it is overwritten */
+	iwl_trans_read_mem_bytes(fwrt->trans, cfg->d3_debug_data_base_addr,
+				 fwrt->dump.d3_debug_data,
+				 cfg->d3_debug_data_length);
+}
+IWL_EXPORT_SYMBOL(iwl_fw_dbg_read_d3_debug_data);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 507d9a49fa97..2c6df7756927 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -217,6 +217,16 @@ static inline void iwl_fw_dump_conf_clear(struct iwl_fw_runtime *fwrt)
 
 void iwl_fw_error_dump_wk(struct work_struct *work);
 
+static inline bool iwl_fw_dbg_is_d3_debug_enabled(struct iwl_fw_runtime *fwrt)
+{
+	return fw_has_capa(&fwrt->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_D3_DEBUG) &&
+		fwrt->trans->cfg->d3_debug_data_length &&
+		fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_D3_DEBUG_DATA);
+}
+
+void iwl_fw_dbg_read_d3_debug_data(struct iwl_fw_runtime *fwrt);
+
 static inline void iwl_fw_flush_dump(struct iwl_fw_runtime *fwrt)
 {
 	flush_delayed_work(&fwrt->dump.wk);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index ed7beca8817e..6d3ef331b7d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2014 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
@@ -35,6 +31,7 @@
  * Copyright(c) 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2014 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -116,6 +113,7 @@ enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_INTERNAL_TXF = 14,
 	IWL_FW_ERROR_DUMP_EXTERNAL = 15, /* Do not move */
 	IWL_FW_ERROR_DUMP_MEM_CFG = 16,
+	IWL_FW_ERROR_DUMP_D3_DEBUG_DATA = 17,
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index bbf2b265a06a..257ef70f8a1e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -349,6 +349,7 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  *	command size (command version 4) that supports toggling ACK TX
  *	power reduction.
  * @IWL_UCODE_TLV_CAPA_MLME_OFFLOAD: supports MLME offload
+ * @IWL_UCODE_TLV_CAPA_D3_DEBUG: supports debug recording during D3
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -397,6 +398,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_LQM_SUPPORT			= (__force iwl_ucode_tlv_capa_t)81,
 	IWL_UCODE_TLV_CAPA_TX_POWER_ACK			= (__force iwl_ucode_tlv_capa_t)84,
 	IWL_UCODE_TLV_CAPA_LED_CMD_SUPPORT		= (__force iwl_ucode_tlv_capa_t)86,
+	IWL_UCODE_TLV_CAPA_D3_DEBUG			= (__force iwl_ucode_tlv_capa_t)87,
 	IWL_UCODE_TLV_CAPA_MLME_OFFLOAD			= (__force iwl_ucode_tlv_capa_t)96,
 
 	NUM_IWL_UCODE_TLV_CAPA
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index ed23367f7088..9ed5819defaf 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -136,6 +136,7 @@ struct iwl_fw_runtime {
 
 		/* ts of the beginning of a non-collect fw dbg data period */
 		unsigned long non_collect_ts_start[FW_DBG_TRIGGER_MAX - 1];
+		u32 *d3_debug_data;
 	} dump;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 12fddcf15bab..4d16ac545269 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -388,6 +388,8 @@ struct iwl_csr_params {
  * @gen2: 22000 and on transport operation
  * @cdb: CDB support
  * @nvm_type: see &enum iwl_nvm_type
+ * @d3_debug_data_base_addr: base address where D3 debug data is stored
+ * @d3_debug_data_length: length of the D3 debug data
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -452,6 +454,8 @@ struct iwl_cfg {
 	u8 ucode_api_min;
 	u32 min_umac_error_event_table;
 	u32 extra_phy_cfg_flags;
+	u32 d3_debug_data_base_addr;
+	u32 d3_debug_data_length;
 };
 
 static const struct iwl_csr_params iwl_csr_v1 = {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index 9019de99f077..e2b29b844c3a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -188,6 +188,7 @@
 #define CSR_HW_IF_CONFIG_REG_MSK_BOARD_VER	(0x000000C0)
 #define CSR_HW_IF_CONFIG_REG_BIT_MAC_SI		(0x00000100)
 #define CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI	(0x00000200)
+#define CSR_HW_IF_CONFIG_REG_D3_DEBUG		(0x00000200)
 #define CSR_HW_IF_CONFIG_REG_MSK_PHY_TYPE	(0x00000C00)
 #define CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH	(0x00003000)
 #define CSR_HW_IF_CONFIG_REG_MSK_PHY_STEP	(0x0000C000)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index c0631255aee7..39a1eadfc4b7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1275,8 +1275,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	fw->ucode_capa.standard_phy_calibration_size =
 			IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE;
 	fw->ucode_capa.n_scan_channels = IWL_DEFAULT_SCAN_CHANNELS;
-	/* dump all fw memory areas by default */
-	fw->dbg_dump_mask = 0xffffffff;
+	/* dump all fw memory areas by default except d3 debug data */
+	fw->dbg_dump_mask = 0xfffdffff;
 
 	pieces = kzalloc(sizeof(*pieces), GFP_KERNEL);
 	if (!pieces)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 79bdae994822..47ceffbfd9af 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1883,6 +1883,7 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 		goto err;
 	}
 
+	iwl_fw_dbg_read_d3_debug_data(&mvm->fwrt);
 	/* query SRAM first in case we want event logging */
 	iwl_mvm_read_d3_sram(mvm);
 
@@ -2117,6 +2118,8 @@ static int iwl_mvm_d3_test_release(struct inode *inode, struct file *file)
 
 	mvm->d3_test_active = false;
 
+	iwl_fw_dbg_read_d3_debug_data(&mvm->fwrt);
+
 	rtnl_lock();
 	__iwl_mvm_resume(mvm, true);
 	rtnl_unlock();
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0e26619fb330..bce5d150eb58 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -182,6 +182,9 @@ static void iwl_mvm_nic_config(struct iwl_op_mode *op_mode)
 	if (mvm->trans->cfg->device_family < IWL_DEVICE_FAMILY_8000)
 		reg_val |= CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI;
 
+	if (iwl_fw_dbg_is_d3_debug_enabled(&mvm->fwrt))
+		reg_val |= CSR_HW_IF_CONFIG_REG_D3_DEBUG;
+
 	iwl_trans_set_bits_mask(mvm->trans, CSR_HW_IF_CONFIG_REG,
 				CSR_HW_IF_CONFIG_REG_MSK_MAC_DASH |
 				CSR_HW_IF_CONFIG_REG_MSK_MAC_STEP |
@@ -189,7 +192,8 @@ static void iwl_mvm_nic_config(struct iwl_op_mode *op_mode)
 				CSR_HW_IF_CONFIG_REG_MSK_PHY_STEP |
 				CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH |
 				CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-				CSR_HW_IF_CONFIG_REG_BIT_MAC_SI,
+				CSR_HW_IF_CONFIG_REG_BIT_MAC_SI   |
+				CSR_HW_IF_CONFIG_REG_D3_DEBUG,
 				reg_val);
 
 	IWL_DEBUG_INFO(mvm, "Radio type=0x%x-0x%x-0x%x\n", radio_cfg_type,
-- 
2.18.0
