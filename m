Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50700 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752712AbdDKMjo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:39:44 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:40 +0300
Message-Id: <20170411123742.12214-24-luca@coelho.fi> (sfid-20170411_145543_738393_11DDD499)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 23/25] iwlwifi: pcie: add context information support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Context information structure is going to be used in a000
devices for firmware self init.

The self init includes firmware self loading from DRAM by
ROM.
This means the TFH relevant firmware loading can be cleaned up.

The firmware loading includes the paging memory as well, so op
mode can stop initializing the paging and sending the DRAM_BLOCK_CMD.

Firmware is doing RFH, TFH and SCD configuration, while driver
only fills the required configurations and addresses in the
context information structure.

The only remaining access to RFH is the write pointer, which
is updated upon alive interrupt after FW configured the RFH.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Makefile        |   1 +
 .../net/wireless/intel/iwlwifi/iwl-context-info.h  | 203 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |   4 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   1 +
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    | 274 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  50 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  45 +++-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   | 226 +++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  60 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  78 ++++--
 10 files changed, 867 insertions(+), 75 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-context-info.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c

diff --git a/drivers/net/wireless/intel/iwlwifi/Makefile b/drivers/net/wireless/intel/iwlwifi/Makefile
index 92e611841200..b27bcac8f5db 100644
--- a/drivers/net/wireless/intel/iwlwifi/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/Makefile
@@ -7,6 +7,7 @@ iwlwifi-objs		+= iwl-notif-wait.o
 iwlwifi-objs		+= iwl-eeprom-read.o iwl-eeprom-parse.o
 iwlwifi-objs		+= iwl-phy-db.o iwl-nvm-parse.o
 iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
+iwlwifi-objs		+= pcie/ctxt-info.o pcie/trans-gen2.o
 iwlwifi-$(CONFIG_IWLDVM) += iwl-1000.o iwl-2000.o iwl-5000.o iwl-6000.o
 iwlwifi-$(CONFIG_IWLMVM) += iwl-7000.o iwl-8000.o iwl-9000.o iwl-a000.o
 iwlwifi-objs		+= iwl-trans.o
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-context-info.h b/drivers/net/wireless/intel/iwlwifi/iwl-context-info.h
new file mode 100644
index 000000000000..b870c0986744
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-context-info.h
@@ -0,0 +1,203 @@
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
+
+#ifndef __iwl_context_info_file_h__
+#define __iwl_context_info_file_h__
+
+/* maximmum number of DRAM map entries supported by FW */
+#define IWL_MAX_DRAM_ENTRY	64
+#define CSR_CTXT_INFO_BA	0x40
+
+/**
+ * enum iwl_context_info_flags - Context information control flags
+ * @IWL_CTXT_INFO_AUTO_FUNC_INIT: If set, FW will not wait before interrupting
+ *	the init done for driver command that configures several system modes
+ * @IWL_CTXT_INFO_EARLY_DEBUG: enable early debug
+ * @IWL_CTXT_INFO_ENABLE_CDMP: enable core dump
+ * @IWL_CTXT_INFO_RB_SIZE_4K: Use 4K RB size (the default is 2K)
+ * @IWL_CTXT_INFO_RB_CB_SIZE_POS: position of the RBD Cyclic Buffer Size
+ *	exponent, the actual size is 2**value, valid sizes are 8-2048.
+ *	The value is four bits long. Maximum valid exponent is 12
+ * @IWL_CTXT_INFO_TFD_FORMAT_LONG: use long TFD Format (the
+ *	default is short format - not supported by the driver)
+ */
+enum iwl_context_info_flags {
+	IWL_CTXT_INFO_AUTO_FUNC_INIT	= BIT(0),
+	IWL_CTXT_INFO_EARLY_DEBUG	= BIT(1),
+	IWL_CTXT_INFO_ENABLE_CDMP	= BIT(2),
+	IWL_CTXT_INFO_RB_SIZE_4K	= BIT(3),
+	IWL_CTXT_INFO_RB_CB_SIZE_POS	= 4,
+	IWL_CTXT_INFO_TFD_FORMAT_LONG	= BIT(8),
+};
+
+/*
+ * struct iwl_context_info_version - version structure
+ * @mac_id: SKU and revision id
+ * @version: context information version id
+ * @size: the size of the context information in DWs
+ */
+struct iwl_context_info_version {
+	__le16 mac_id;
+	__le16 version;
+	__le16 size;
+	__le16 reserved;
+} __packed;
+
+/*
+ * struct iwl_context_info_control - version structure
+ * @control_flags: context information flags see &enum iwl_context_info_flags
+ */
+struct iwl_context_info_control {
+	__le32 control_flags;
+	__le32 reserved;
+} __packed;
+
+/*
+ * struct iwl_context_info_dram - images DRAM map
+ * each entry in the map represents a DRAM chunk of up to 32 KB
+ * @umac_img: UMAC image DRAM map
+ * @lmac_img: LMAC image DRAM map
+ * @virtual_img: paged image DRAM map
+ */
+struct iwl_context_info_dram {
+	__le64 umac_img[IWL_MAX_DRAM_ENTRY];
+	__le64 lmac_img[IWL_MAX_DRAM_ENTRY];
+	__le64 virtual_img[IWL_MAX_DRAM_ENTRY];
+} __packed;
+
+/*
+ * struct iwl_context_info_rbd_cfg - RBDs configuration
+ * @free_rbd_addr: default queue free RB CB base address
+ * @used_rbd_addr: default queue used RB CB base address
+ * @status_wr_ptr: default queue used RB status write pointer
+ */
+struct iwl_context_info_rbd_cfg {
+	__le64 free_rbd_addr;
+	__le64 used_rbd_addr;
+	__le64 status_wr_ptr;
+} __packed;
+
+/*
+ * struct iwl_context_info_hcmd_cfg  - command queue configuration
+ * @cmd_queue_addr: address of command queue
+ * @cmd_queue_size: number of entries
+ */
+struct iwl_context_info_hcmd_cfg {
+	__le64 cmd_queue_addr;
+	u8 cmd_queue_size;
+	u8 reserved[7];
+} __packed;
+
+/*
+ * struct iwl_context_info_dump_cfg - Core Dump configuration
+ * @core_dump_addr: core dump (debug DRAM address) start address
+ * @core_dump_size: size, in DWs
+ */
+struct iwl_context_info_dump_cfg {
+	__le64 core_dump_addr;
+	__le32 core_dump_size;
+	__le32 reserved;
+} __packed;
+
+/*
+ * struct iwl_context_info_pnvm_cfg - platform NVM data configuration
+ * @platform_nvm_addr: Platform NVM data start address
+ * @platform_nvm_size: size in DWs
+ */
+struct iwl_context_info_pnvm_cfg {
+	__le64 platform_nvm_addr;
+	__le32 platform_nvm_size;
+	__le32 reserved;
+} __packed;
+
+/*
+ * struct iwl_context_info_early_dbg_cfg - early debug configuration for
+ *	dumping DRAM addresses
+ * @early_debug_addr: early debug start address
+ * @early_debug_size: size in DWs
+ */
+struct iwl_context_info_early_dbg_cfg {
+	__le64 early_debug_addr;
+	__le32 early_debug_size;
+	__le32 reserved;
+} __packed;
+
+/*
+ * struct iwl_context_info - device INIT configuration
+ * @version: version information of context info and HW
+ * @control: control flags of FH configurations
+ * @rbd_cfg: default RX queue configuration
+ * @hcmd_cfg: command queue configuration
+ * @dump_cfg: core dump data
+ * @edbg_cfg: early debug configuration
+ * @pnvm_cfg: platform nvm configuration
+ * @dram: firmware image addresses in DRAM
+ */
+struct iwl_context_info {
+	struct iwl_context_info_version version;
+	struct iwl_context_info_control control;
+	__le64 reserved0;
+	struct iwl_context_info_rbd_cfg rbd_cfg;
+	struct iwl_context_info_hcmd_cfg hcmd_cfg;
+	__le32 reserved1[4];
+	struct iwl_context_info_dump_cfg dump_cfg;
+	struct iwl_context_info_early_dbg_cfg edbg_cfg;
+	struct iwl_context_info_pnvm_cfg pnvm_cfg;
+	__le32 reserved2[16];
+	struct iwl_context_info_dram dram;
+	__le32 reserved3[16];
+} __packed;
+
+int iwl_pcie_ctxt_info_init(struct iwl_trans *trans, const struct fw_img *fw);
+void iwl_pcie_ctxt_info_free(struct iwl_trans *trans);
+void iwl_pcie_ctxt_info_free_paging(struct iwl_trans *trans);
+
+#endif /* __iwl_context_info_file_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 361fc25e8618..62f9fe926d78 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -614,6 +614,8 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(struct iwl_trans *trans,
 #define RX_POOL_SIZE		(MQ_RX_NUM_RBDS +	\
 				 IWL_MAX_RX_HW_QUEUES *	\
 				 (RX_CLAIM_REQ_ALLOC - RX_POST_REQ_ALLOC))
+/* cb size is the exponent */
+#define RX_QUEUE_CB_SIZE(x)	ilog2(x)
 
 #define RX_QUEUE_SIZE                         256
 #define RX_QUEUE_MASK                         255
@@ -639,6 +641,8 @@ struct iwl_rb_status {
 
 
 #define TFD_QUEUE_SIZE_MAX      (256)
+/* cb size is the exponent - 3 */
+#define TFD_QUEUE_CB_SIZE(x)	(ilog2(x) - 3)
 #define TFD_QUEUE_SIZE_BC_DUP	(64)
 #define TFD_QUEUE_BC_SIZE	(TFD_QUEUE_SIZE_MAX + TFD_QUEUE_SIZE_BC_DUP)
 #define IWL_TX_DMA_MASK        DMA_BIT_MASK(36)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 3a8aeee3b55a..bb7e0d642981 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -309,6 +309,7 @@
  * Note this address is cleared after MAC reset.
  */
 #define UREG_UCODE_LOAD_STATUS		(0xa05c40)
+#define UREG_CPU_INIT_RUN		(0xa05c44)
 
 #define LMPM_SECURE_UCODE_LOAD_CPU1_HDR_ADDR	(0x1E78)
 #define LMPM_SECURE_UCODE_LOAD_CPU2_HDR_ADDR	(0x1E7C)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
new file mode 100644
index 000000000000..312ee0481ec5
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -0,0 +1,274 @@
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
+
+#include "iwl-trans.h"
+#include "iwl-fh.h"
+#include "iwl-context-info.h"
+#include "internal.h"
+#include "iwl-prph.h"
+
+static int iwl_pcie_get_num_sections(const struct fw_img *fw,
+				     int start)
+{
+	int i = 0;
+
+	while (start < fw->num_sec &&
+	       fw->sec[start].offset != CPU1_CPU2_SEPARATOR_SECTION &&
+	       fw->sec[start].offset != PAGING_SEPARATOR_SECTION) {
+		start++;
+		i++;
+	}
+
+	return i;
+}
+
+static int iwl_pcie_ctxt_info_alloc_dma(struct iwl_trans *trans,
+					const struct fw_desc *sec,
+					struct iwl_dram_data *dram)
+{
+	dram->block = dma_alloc_coherent(trans->dev, sec->len,
+					 &dram->physical,
+					 GFP_KERNEL);
+	if (!dram->block)
+		return -ENOMEM;
+
+	dram->size = sec->len;
+	memcpy(dram->block, sec->data, sec->len);
+
+	return 0;
+}
+
+static void iwl_pcie_ctxt_info_free_fw_img(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_self_init_dram *dram = &trans_pcie->init_dram;
+	int i;
+
+	if (!dram->fw) {
+		WARN_ON(dram->fw_cnt);
+		return;
+	}
+
+	for (i = 0; i < dram->fw_cnt; i++)
+		dma_free_coherent(trans->dev, dram->fw[i].size,
+				  dram->fw[i].block, dram->fw[i].physical);
+
+	kfree(dram->fw);
+	dram->fw_cnt = 0;
+}
+
+void iwl_pcie_ctxt_info_free_paging(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_self_init_dram *dram = &trans_pcie->init_dram;
+	int i;
+
+	if (!dram->paging) {
+		WARN_ON(dram->paging_cnt);
+		return;
+	}
+
+	/* free paging*/
+	for (i = 0; i < dram->paging_cnt; i++)
+		dma_free_coherent(trans->dev, dram->paging[i].size,
+				  dram->paging[i].block,
+				  dram->paging[i].physical);
+
+	kfree(dram->paging);
+	dram->paging_cnt = 0;
+}
+
+static int iwl_pcie_ctxt_info_init_fw_sec(struct iwl_trans *trans,
+					  const struct fw_img *fw,
+					  struct iwl_context_info *ctxt_info)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_self_init_dram *dram = &trans_pcie->init_dram;
+	struct iwl_context_info_dram *ctxt_dram = &ctxt_info->dram;
+	int i, ret, lmac_cnt, umac_cnt, paging_cnt;
+
+	lmac_cnt = iwl_pcie_get_num_sections(fw, 0);
+	/* add 1 due to separator */
+	umac_cnt = iwl_pcie_get_num_sections(fw, lmac_cnt + 1);
+	/* add 2 due to separators */
+	paging_cnt = iwl_pcie_get_num_sections(fw, lmac_cnt + umac_cnt + 2);
+
+	dram->fw = kcalloc(umac_cnt + lmac_cnt, sizeof(*dram->fw), GFP_KERNEL);
+	if (!dram->fw)
+		return -ENOMEM;
+	dram->paging = kcalloc(paging_cnt, sizeof(*dram->paging), GFP_KERNEL);
+	if (!dram->paging)
+		return -ENOMEM;
+
+	/* initialize lmac sections */
+	for (i = 0; i < lmac_cnt; i++) {
+		ret = iwl_pcie_ctxt_info_alloc_dma(trans, &fw->sec[i],
+						   &dram->fw[dram->fw_cnt]);
+		if (ret)
+			return ret;
+		ctxt_dram->lmac_img[i] =
+			cpu_to_le64(dram->fw[dram->fw_cnt].physical);
+		dram->fw_cnt++;
+	}
+
+	/* initialize umac sections */
+	for (i = 0; i < umac_cnt; i++) {
+		/* access FW with +1 to make up for lmac separator */
+		ret = iwl_pcie_ctxt_info_alloc_dma(trans,
+						   &fw->sec[dram->fw_cnt + 1],
+						   &dram->fw[dram->fw_cnt]);
+		if (ret)
+			return ret;
+		ctxt_dram->umac_img[i] =
+			cpu_to_le64(dram->fw[dram->fw_cnt].physical);
+		dram->fw_cnt++;
+	}
+
+	/*
+	 * Initialize paging.
+	 * Paging memory isn't stored in dram->fw as the umac and lmac - it is
+	 * stored separately.
+	 * This is since the timing of its release is different -
+	 * while fw memory can be released on alive, the paging memory can be
+	 * freed only when the device goes down.
+	 * Given that, the logic here in accessing the fw image is a bit
+	 * different - fw_cnt isn't changing so loop counter is added to it.
+	 */
+	for (i = 0; i < paging_cnt; i++) {
+		/* access FW with +2 to make up for lmac & umac separators */
+		int fw_idx = dram->fw_cnt + i + 2;
+
+		ret = iwl_pcie_ctxt_info_alloc_dma(trans, &fw->sec[fw_idx],
+						   &dram->paging[i]);
+		if (ret)
+			return ret;
+
+		ctxt_dram->virtual_img[i] =
+			cpu_to_le64(dram->paging[i].physical);
+		dram->paging_cnt++;
+	}
+
+	return 0;
+}
+
+int iwl_pcie_ctxt_info_init(struct iwl_trans *trans,
+			    const struct fw_img *fw)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_context_info *ctxt_info;
+	struct iwl_context_info_rbd_cfg *rx_cfg;
+	u32 control_flags = 0;
+	int ret;
+
+	ctxt_info = dma_alloc_coherent(trans->dev, sizeof(*ctxt_info),
+				       &trans_pcie->ctxt_info_dma_addr,
+				       GFP_KERNEL);
+	if (!ctxt_info)
+		return -ENOMEM;
+
+	ctxt_info->version.version = 0;
+	ctxt_info->version.mac_id =
+		cpu_to_le16((u16)iwl_read32(trans, CSR_HW_REV));
+	/* size is in DWs */
+	ctxt_info->version.size = cpu_to_le16(sizeof(*ctxt_info) / 4);
+
+	BUILD_BUG_ON(RX_QUEUE_CB_SIZE(MQ_RX_TABLE_SIZE) > 0xF);
+	control_flags = IWL_CTXT_INFO_RB_SIZE_4K |
+			IWL_CTXT_INFO_TFD_FORMAT_LONG |
+			RX_QUEUE_CB_SIZE(MQ_RX_TABLE_SIZE) <<
+			IWL_CTXT_INFO_RB_CB_SIZE_POS;
+	ctxt_info->control.control_flags = cpu_to_le32(control_flags);
+
+	/* initialize RX default queue */
+	rx_cfg = &ctxt_info->rbd_cfg;
+	rx_cfg->free_rbd_addr = cpu_to_le64(trans_pcie->rxq->bd_dma);
+	rx_cfg->used_rbd_addr = cpu_to_le64(trans_pcie->rxq->used_bd_dma);
+	rx_cfg->status_wr_ptr = cpu_to_le64(trans_pcie->rxq->rb_stts_dma);
+
+	/* initialize TX command queue */
+	ctxt_info->hcmd_cfg.cmd_queue_addr =
+		cpu_to_le64(trans_pcie->txq[trans_pcie->cmd_queue].dma_addr);
+	ctxt_info->hcmd_cfg.cmd_queue_size =
+		TFD_QUEUE_CB_SIZE(TFD_QUEUE_SIZE_MAX);
+
+	/* allocate ucode sections in dram and set addresses */
+	ret = iwl_pcie_ctxt_info_init_fw_sec(trans, fw, ctxt_info);
+	if (ret)
+		return ret;
+
+	trans_pcie->ctxt_info = ctxt_info;
+
+	iwl_enable_interrupts(trans);
+
+	/* kick FW self load */
+	iwl_write64(trans, CSR_CTXT_INFO_BA, trans_pcie->ctxt_info_dma_addr);
+	iwl_write_prph(trans, UREG_CPU_INIT_RUN, 1);
+
+	/* Context info will be released upon alive or failure to get one */
+
+	return 0;
+}
+
+void iwl_pcie_ctxt_info_free(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (!trans_pcie->ctxt_info)
+		return;
+
+	dma_free_coherent(trans->dev, sizeof(*trans_pcie->ctxt_info),
+			  trans_pcie->ctxt_info,
+			  trans_pcie->ctxt_info_dma_addr);
+	trans_pcie->ctxt_info_dma_addr = 0;
+	trans_pcie->ctxt_info = NULL;
+
+	iwl_pcie_ctxt_info_free_fw_img(trans);
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 1ef9bb83a43f..98c1308eab0d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -2,7 +2,7 @@
  *
  * Copyright(c) 2003 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -313,11 +313,43 @@ enum iwl_shared_irq_flags {
 };
 
 /**
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
+
+/**
+ * struct iwl_self_init_dram - dram data used by self init process
+ * @fw: lmac and umac dram data
+ * @fw_cnt: total number of items in array
+ * @paging: paging dram data
+ * @paging_cnt: total number of items in array
+ */
+struct iwl_self_init_dram {
+	struct iwl_dram_data *fw;
+	int fw_cnt;
+	struct iwl_dram_data *paging;
+	int paging_cnt;
+};
+
+/**
  * struct iwl_trans_pcie - PCIe transport specific data
  * @rxq: all the RX queue data
  * @rx_pool: initial pool of iwl_rx_mem_buffer for all the queues
  * @global_table: table mapping received VID from hw to rxb
  * @rba: allocator for RX replenishing
+ * @ctxt_info: context information for FW self init
+ * @ctxt_info_dma_addr: dma addr of context information
+ * @init_dram: DRAM data of firmware image (including paging).
+ *	Context information addresses will be taken from here.
+ *	This is driver's local copy for keeping track of size and
+ *	count for allocating and freeing the memory.
  * @trans: pointer to the generic transport area
  * @scd_base_addr: scheduler sram base address in SRAM
  * @scd_bc_tbls: pointer to the byte count table of the scheduler
@@ -355,6 +387,9 @@ struct iwl_trans_pcie {
 	struct iwl_rx_mem_buffer rx_pool[RX_POOL_SIZE];
 	struct iwl_rx_mem_buffer *global_table[RX_POOL_SIZE];
 	struct iwl_rb_allocator rba;
+	struct iwl_context_info *ctxt_info;
+	dma_addr_t ctxt_info_dma_addr;
+	struct iwl_self_init_dram init_dram;
 	struct iwl_trans *trans;
 
 	struct net_device napi_dev;
@@ -452,6 +487,7 @@ void iwl_trans_pcie_free(struct iwl_trans *trans);
 * RX
 ******************************************************/
 int iwl_pcie_rx_init(struct iwl_trans *trans);
+int iwl_pcie_gen2_rx_init(struct iwl_trans *trans);
 irqreturn_t iwl_pcie_msix_isr(int irq, void *data);
 irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id);
 irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id);
@@ -472,6 +508,7 @@ void iwl_pcie_disable_ict(struct iwl_trans *trans);
 * TX / HCMD
 ******************************************************/
 int iwl_pcie_tx_init(struct iwl_trans *trans);
+int iwl_pcie_gen2_tx_init(struct iwl_trans *trans);
 void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr);
 int iwl_pcie_tx_stop(struct iwl_trans *trans);
 void iwl_pcie_tx_free(struct iwl_trans *trans);
@@ -716,4 +753,15 @@ int iwl_pci_fw_enter_d0i3(struct iwl_trans *trans);
 
 void iwl_pcie_enable_rx_wake(struct iwl_trans *trans, bool enable);
 
+/* common functions that are used by gen2 transport */
+void iwl_pcie_apm_config(struct iwl_trans *trans);
+int iwl_pcie_prepare_card_hw(struct iwl_trans *trans);
+void iwl_pcie_synchronize_irqs(struct iwl_trans *trans);
+bool iwl_trans_check_hw_rf_kill(struct iwl_trans *trans);
+
+/* transport gen 2 exported functions */
+int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
+				 const struct fw_img *fw, bool run_in_rfkill);
+void iwl_trans_pcie_gen2_fw_alive(struct iwl_trans *trans, u32 scd_addr);
+
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 17806d82f3a3..c6178d36698c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -2,7 +2,7 @@
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -880,7 +880,7 @@ static int iwl_pcie_dummy_napi_poll(struct napi_struct *napi, int budget)
 	return 0;
 }
 
-int iwl_pcie_rx_init(struct iwl_trans *trans)
+static int _iwl_pcie_rx_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *def_rxq;
@@ -958,20 +958,40 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 
 	iwl_pcie_rxq_alloc_rbs(trans, GFP_KERNEL, def_rxq);
 
+	return 0;
+}
+
+int iwl_pcie_rx_init(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int ret = _iwl_pcie_rx_init(trans);
+
+	if (ret)
+		return ret;
+
 	if (trans->cfg->mq_rx_supported)
 		iwl_pcie_rx_mq_hw_init(trans);
 	else
-		iwl_pcie_rx_hw_init(trans, def_rxq);
+		iwl_pcie_rx_hw_init(trans, trans_pcie->rxq);
 
-	iwl_pcie_rxq_restock(trans, def_rxq);
+	iwl_pcie_rxq_restock(trans, trans_pcie->rxq);
 
-	spin_lock(&def_rxq->lock);
-	iwl_pcie_rxq_inc_wr_ptr(trans, def_rxq);
-	spin_unlock(&def_rxq->lock);
+	spin_lock(&trans_pcie->rxq->lock);
+	iwl_pcie_rxq_inc_wr_ptr(trans, trans_pcie->rxq);
+	spin_unlock(&trans_pcie->rxq->lock);
 
 	return 0;
 }
 
+int iwl_pcie_gen2_rx_init(struct iwl_trans *trans)
+{
+	/*
+	 * We don't configure the RFH.
+	 * Restock will be done at alive, after firmware configured the RFH.
+	 */
+	return _iwl_pcie_rx_init(trans);
+}
+
 void iwl_pcie_rx_free(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -1594,6 +1614,13 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		if (inta & CSR_INT_BIT_ALIVE) {
 			IWL_DEBUG_ISR(trans, "Alive interrupt\n");
 			isr_stats->alive++;
+			if (trans->cfg->gen2) {
+				/*
+				 * We can restock, since firmware configured
+				 * the RFH
+				 */
+				iwl_pcie_rxmq_restock(trans, trans_pcie->rxq);
+			}
 		}
 	}
 
@@ -1930,6 +1957,10 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 	if (inta_hw & MSIX_HW_INT_CAUSES_REG_ALIVE) {
 		IWL_DEBUG_ISR(trans, "Alive interrupt\n");
 		isr_stats->alive++;
+		if (trans->cfg->gen2) {
+			/* We can restock, since firmware configured the RFH */
+			iwl_pcie_rxmq_restock(trans, trans_pcie->rxq);
+		}
 	}
 
 	/* uCode wakes up after power-down sleep */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
new file mode 100644
index 000000000000..302310dfef9e
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -0,0 +1,226 @@
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
+#include "iwl-trans.h"
+#include "iwl-context-info.h"
+#include "internal.h"
+
+/*
+ * Start up NIC's basic functionality after it has been reset
+ * (e.g. after platform boot, or shutdown via iwl_pcie_apm_stop())
+ * NOTE:  This does not load uCode nor start the embedded processor
+ */
+static int iwl_pcie_gen2_apm_init(struct iwl_trans *trans)
+{
+	int ret = 0;
+
+	IWL_DEBUG_INFO(trans, "Init card's basic functions\n");
+
+	/*
+	 * Use "set_bit" below rather than "write", to preserve any hardware
+	 * bits already set by default after reset.
+	 */
+
+	/*
+	 * Disable L0s without affecting L1;
+	 * don't wait for ICH L0s (ICH bug W/A)
+	 */
+	iwl_set_bit(trans, CSR_GIO_CHICKEN_BITS,
+		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
+
+	/* Set FH wait threshold to maximum (HW error during stress W/A) */
+	iwl_set_bit(trans, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
+
+	/*
+	 * Enable HAP INTA (interrupt from management bus) to
+	 * wake device's PCI Express link L1a -> L0s
+	 */
+	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+		    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
+
+	iwl_pcie_apm_config(trans);
+
+	/*
+	 * Set "initialization complete" bit to move adapter from
+	 * D0U* --> D0A* (powered-up active) state.
+	 */
+	iwl_set_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+	/*
+	 * Wait for clock stabilization; once stabilized, access to
+	 * device-internal resources is supported, e.g. iwl_write_prph()
+	 * and accesses to uCode SRAM.
+	 */
+	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	if (ret < 0) {
+		IWL_DEBUG_INFO(trans, "Failed to init the card\n");
+		return ret;
+	}
+
+	set_bit(STATUS_DEVICE_ENABLED, &trans->status);
+
+	return 0;
+}
+
+static int iwl_pcie_gen2_nic_init(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	/* TODO: most of the logic can be removed in A0 - but not in Z0 */
+	spin_lock(&trans_pcie->irq_lock);
+	iwl_pcie_gen2_apm_init(trans);
+	spin_unlock(&trans_pcie->irq_lock);
+
+	iwl_op_mode_nic_config(trans->op_mode);
+
+	/* Allocate the RX queue, or reset if it is already allocated */
+	if (iwl_pcie_gen2_rx_init(trans))
+		return -ENOMEM;
+
+	/* Allocate or reset and init all Tx and Command queues */
+	if (iwl_pcie_gen2_tx_init(trans))
+		return -ENOMEM;
+
+	/* enable shadow regs in HW */
+	iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL, 0x800FFFFF);
+	IWL_DEBUG_INFO(trans, "Enabling shadow registers in device\n");
+
+	return 0;
+}
+
+void iwl_trans_pcie_gen2_fw_alive(struct iwl_trans *trans, u32 scd_addr)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	iwl_pcie_reset_ict(trans);
+
+	/* make sure all queue are not stopped/used */
+	memset(trans_pcie->queue_stopped, 0, sizeof(trans_pcie->queue_stopped));
+	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
+
+	/* now that we got alive we can free the fw image & the context info.
+	 * paging memory cannot be freed included since FW will still use it
+	 */
+	iwl_pcie_ctxt_info_free(trans);
+}
+
+int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
+				 const struct fw_img *fw, bool run_in_rfkill)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	bool hw_rfkill;
+	int ret;
+
+	/* This may fail if AMT took ownership of the device */
+	if (iwl_pcie_prepare_card_hw(trans)) {
+		IWL_WARN(trans, "Exit HW not ready\n");
+		ret = -EIO;
+		goto out;
+	}
+
+	iwl_enable_rfkill_int(trans);
+
+	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
+
+	/*
+	 * We enabled the RF-Kill interrupt and the handler may very
+	 * well be running. Disable the interrupts to make sure no other
+	 * interrupt can be fired.
+	 */
+	iwl_disable_interrupts(trans);
+
+	/* Make sure it finished running */
+	iwl_pcie_synchronize_irqs(trans);
+
+	mutex_lock(&trans_pcie->mutex);
+
+	/* If platform's RF_KILL switch is NOT set to KILL */
+	hw_rfkill = iwl_trans_check_hw_rf_kill(trans);
+	if (hw_rfkill && !run_in_rfkill) {
+		ret = -ERFKILL;
+		goto out;
+	}
+
+	/* Someone called stop_device, don't try to start_fw */
+	if (trans_pcie->is_down) {
+		IWL_WARN(trans,
+			 "Can't start_fw since the HW hasn't been started\n");
+		ret = -EIO;
+		goto out;
+	}
+
+	/* make sure rfkill handshake bits are cleared */
+	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR,
+		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
+
+	/* clear (again), then enable host interrupts */
+	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
+
+	ret = iwl_pcie_gen2_nic_init(trans);
+	if (ret) {
+		IWL_ERR(trans, "Unable to init nic\n");
+		goto out;
+	}
+
+	if (iwl_pcie_ctxt_info_init(trans, fw))
+		return -ENOMEM;
+
+	/* re-check RF-Kill state since we may have missed the interrupt */
+	hw_rfkill = iwl_trans_check_hw_rf_kill(trans);
+	if (hw_rfkill && !run_in_rfkill)
+		ret = -ERFKILL;
+
+out:
+	mutex_unlock(&trans_pcie->mutex);
+	return ret;
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 16c8b37bf6d7..361f0b0a6f42 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -80,6 +80,7 @@
 #include "iwl-prph.h"
 #include "iwl-scd.h"
 #include "iwl-agn-hw.h"
+#include "iwl-context-info.h"
 #include "iwl-fw-error-dump.h"
 #include "internal.h"
 #include "iwl-fh.h"
@@ -201,7 +202,7 @@ static void iwl_pcie_set_pwr(struct iwl_trans *trans, bool vaux)
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
 
-static void iwl_pcie_apm_config(struct iwl_trans *trans)
+void iwl_pcie_apm_config(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u16 lctl;
@@ -567,7 +568,7 @@ static int iwl_pcie_set_hw_ready(struct iwl_trans *trans)
 }
 
 /* Note: returns standard 0/-ERROR code */
-static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
+int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 {
 	int ret;
 	int t = 0;
@@ -636,29 +637,6 @@ static void iwl_pcie_load_firmware_chunk_fh(struct iwl_trans *trans,
 		    FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 }
 
-static void iwl_pcie_load_firmware_chunk_tfh(struct iwl_trans *trans,
-					     u32 dst_addr, dma_addr_t phy_addr,
-					     u32 byte_cnt)
-{
-	/* Stop DMA channel */
-	iwl_write32(trans, TFH_SRV_DMA_CHNL0_CTRL, 0);
-
-	/* Configure SRAM address */
-	iwl_write32(trans, TFH_SRV_DMA_CHNL0_SRAM_ADDR,
-		    dst_addr);
-
-	/* Configure DRAM address - 64 bit */
-	iwl_write64(trans, TFH_SRV_DMA_CHNL0_DRAM_ADDR, phy_addr);
-
-	/* Configure byte count to transfer */
-	iwl_write32(trans, TFH_SRV_DMA_CHNL0_BC, byte_cnt);
-
-	/* Enable the DRAM2SRAM to start */
-	iwl_write32(trans, TFH_SRV_DMA_CHNL0_CTRL, TFH_SRV_DMA_SNOOP |
-						   TFH_SRV_DMA_TO_DRIVER |
-						   TFH_SRV_DMA_START);
-}
-
 static int iwl_pcie_load_firmware_chunk(struct iwl_trans *trans,
 					u32 dst_addr, dma_addr_t phy_addr,
 					u32 byte_cnt)
@@ -672,12 +650,8 @@ static int iwl_pcie_load_firmware_chunk(struct iwl_trans *trans,
 	if (!iwl_trans_grab_nic_access(trans, &flags))
 		return -EIO;
 
-	if (trans->cfg->use_tfh)
-		iwl_pcie_load_firmware_chunk_tfh(trans, dst_addr, phy_addr,
-						 byte_cnt);
-	else
-		iwl_pcie_load_firmware_chunk_fh(trans, dst_addr, phy_addr,
-						byte_cnt);
+	iwl_pcie_load_firmware_chunk_fh(trans, dst_addr, phy_addr,
+					byte_cnt);
 	iwl_trans_release_nic_access(trans, &flags);
 
 	ret = wait_event_timeout(trans_pcie->ucode_write_waitq,
@@ -828,15 +802,10 @@ static int iwl_pcie_load_cpu_sections_8000(struct iwl_trans *trans,
 			return ret;
 
 		/* Notify ucode of loaded section number and status */
-		if (trans->cfg->use_tfh) {
-			val = iwl_read_prph(trans, UREG_UCODE_LOAD_STATUS);
-			val = val | (sec_num << shift_param);
-			iwl_write_prph(trans, UREG_UCODE_LOAD_STATUS, val);
-		} else {
-			val = iwl_read_direct32(trans, FH_UCODE_LOAD_STATUS);
-			val = val | (sec_num << shift_param);
-			iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, val);
-		}
+		val = iwl_read_direct32(trans, FH_UCODE_LOAD_STATUS);
+		val = val | (sec_num << shift_param);
+		iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, val);
+
 		sec_num = (sec_num << 1) | 0x1;
 	}
 
@@ -1072,7 +1041,7 @@ static int iwl_pcie_load_given_ucode_8000(struct iwl_trans *trans,
 					       &first_ucode_section);
 }
 
-static bool iwl_trans_check_hw_rf_kill(struct iwl_trans *trans)
+bool iwl_trans_check_hw_rf_kill(struct iwl_trans *trans)
 {
 	bool hw_rfkill = iwl_is_rfkill_set(trans);
 
@@ -1244,6 +1213,9 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 		}
 	}
 
+	iwl_pcie_ctxt_info_free_paging(trans);
+	iwl_pcie_ctxt_info_free(trans);
+
 	/* Make sure (redundant) we've released our request to stay awake */
 	iwl_clear_bit(trans, CSR_GP_CNTRL,
 		      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
@@ -1309,7 +1281,7 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 	iwl_pcie_prepare_card_hw(trans);
 }
 
-static void iwl_pcie_synchronize_irqs(struct iwl_trans *trans)
+void iwl_pcie_synchronize_irqs(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -2942,8 +2914,8 @@ static const struct iwl_trans_ops trans_ops_pcie_gen2 = {
 	IWL_TRANS_COMMON_OPS,
 	IWL_TRANS_PM_OPS
 	.start_hw = iwl_trans_pcie_start_hw,
-	.fw_alive = iwl_trans_pcie_fw_alive,
-	.start_fw = iwl_trans_pcie_start_fw,
+	.fw_alive = iwl_trans_pcie_gen2_fw_alive,
+	.start_fw = iwl_trans_pcie_gen2_start_fw,
 	.stop_device = iwl_trans_pcie_stop_device,
 
 	.send_cmd = iwl_trans_pcie_send_hcmd,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 9c8ab1a82b72..b3ac1fb51009 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -2,7 +2,7 @@
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -612,18 +612,6 @@ static int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
 
 	__skb_queue_head_init(&txq->overflow_q);
 
-	/*
-	 * Tell nic where to find circular buffer of Tx Frame Descriptors for
-	 * given Tx queue, and enable the DMA channel used for that queue.
-	 * Circular buffer (TFD queue in DRAM) physical base address */
-	if (trans->cfg->use_tfh)
-		iwl_write_direct64(trans,
-				   FH_MEM_CBBC_QUEUE(trans, txq_id),
-				   txq->dma_addr);
-	else
-		iwl_write_direct32(trans, FH_MEM_CBBC_QUEUE(trans, txq_id),
-				   txq->dma_addr >> 8);
-
 	return 0;
 }
 
@@ -775,9 +763,6 @@ void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr)
 	memset(trans_pcie->queue_stopped, 0, sizeof(trans_pcie->queue_stopped));
 	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
 
-	if (trans->cfg->use_tfh)
-		return;
-
 	trans_pcie->scd_base_addr =
 		iwl_read_prph(trans, SCD_SRAM_BASE_ADDR);
 
@@ -1009,6 +994,7 @@ static int iwl_pcie_tx_alloc(struct iwl_trans *trans)
 
 	return ret;
 }
+
 int iwl_pcie_tx_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -1045,14 +1031,15 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
 			goto error;
 		}
-	}
 
-	if (trans->cfg->use_tfh) {
-		iwl_write_direct32(trans, TFH_TRANSFER_MODE,
-				   TFH_TRANSFER_MAX_PENDING_REQ |
-				   TFH_CHUNK_SIZE_128 |
-				   TFH_CHUNK_SPLIT_MODE);
-		return 0;
+		/*
+		 * Tell nic where to find circular buffer of TFDs for a
+		 * given Tx queue, and enable the DMA channel used for that
+		 * queue.
+		 * Circular buffer (TFD queue in DRAM) physical base address
+		 */
+		iwl_write_direct32(trans, FH_MEM_CBBC_QUEUE(trans, txq_id),
+				   trans_pcie->txq[txq_id].dma_addr >> 8);
 	}
 
 	iwl_set_bits_prph(trans, SCD_GP_CTRL, SCD_GP_CTRL_AUTO_ACTIVE_MODE);
@@ -1068,6 +1055,51 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 	return ret;
 }
 
+int iwl_pcie_gen2_tx_init(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int ret;
+	int txq_id, slots_num;
+	bool alloc = false;
+
+	if (!trans_pcie->txq) {
+		/* TODO: change this when moving to new TX alloc model */
+		ret = iwl_pcie_tx_alloc(trans);
+		if (ret)
+			goto error;
+		alloc = true;
+	}
+
+	spin_lock(&trans_pcie->irq_lock);
+
+	/* Tell NIC where to find the "keep warm" buffer */
+	iwl_write_direct32(trans, FH_KW_MEM_ADDR_REG,
+			   trans_pcie->kw.dma >> 4);
+
+	spin_unlock(&trans_pcie->irq_lock);
+
+	/* TODO: remove this when moving to new TX alloc model */
+	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
+	     txq_id++) {
+		slots_num = (txq_id == trans_pcie->cmd_queue) ?
+					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+		ret = iwl_pcie_txq_init(trans, &trans_pcie->txq[txq_id],
+					slots_num, txq_id);
+		if (ret) {
+			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
+			goto error;
+		}
+	}
+
+	return 0;
+
+error:
+	/* Upon error, free only if we allocated something */
+	if (alloc)
+		iwl_pcie_tx_free(trans);
+	return ret;
+}
+
 static inline void iwl_pcie_txq_progress(struct iwl_txq *txq)
 {
 	lockdep_assert_held(&txq->lock);
-- 
2.11.0
