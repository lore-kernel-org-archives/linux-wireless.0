Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089A4C282CC
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0EE121919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbfBHKr1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:27 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56972 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727660AbfBHKrZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:25 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3go-0002jg-CC; Fri, 08 Feb 2019 12:47:23 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:46:57 +0200
Message-Id: <20190208104712.16210-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/20] iwlwifi: align to new periphery address space for AX210 family
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

In AX210 family, UMAC periphery address space moved from
0xA00000 to 0xD00000.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 10 ++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 12 ++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   | 16 ++---
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   |  8 +--
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   | 43 ++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  5 +-
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       | 15 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 10 +--
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 64 ++++++++++---------
 10 files changed, 122 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index b9dd50174857..fd8416c53819 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -20,7 +20,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -179,6 +179,10 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.d3_debug_data_base_addr = 0x401000,				\
 	.d3_debug_data_length = 60 * 1024
 
+#define IWL_DEVICE_AX200_COMMON						\
+	IWL_DEVICE_22000_COMMON,					\
+	.umac_prph_offset = 0x300000
+
 #define IWL_DEVICE_22500						\
 	IWL_DEVICE_22000_COMMON,					\
 	.device_family = IWL_DEVICE_FAMILY_22000,			\
@@ -192,7 +196,7 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.csr = &iwl_csr_v2
 
 #define IWL_DEVICE_AX210						\
-	IWL_DEVICE_22000_COMMON,					\
+	IWL_DEVICE_AX200_COMMON,					\
 	.device_family = IWL_DEVICE_FAMILY_AX210,			\
 	.base_params = &iwl_22000_base_params,				\
 	.csr = &iwl_csr_v1,						\
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 1abaed5dfbf1..3b3692473702 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -242,7 +242,8 @@ static void iwl_fw_dump_rxf(struct iwl_fw_runtime *fwrt,
 				  cfg->lmac[0].rxfifo1_size, 0, 0);
 		/* Pull RXF2 */
 		iwl_fwrt_dump_rxf(fwrt, dump_data, cfg->rxfifo2_size,
-				  RXF_DIFF_FROM_PREV, 1);
+				  RXF_DIFF_FROM_PREV +
+				  fwrt->trans->cfg->umac_prph_offset, 1);
 		/* Pull LMAC2 RXF1 */
 		if (fwrt->smem_cfg.num_lmacs > 1)
 			iwl_fwrt_dump_rxf(fwrt, dump_data,
@@ -1140,7 +1141,8 @@ iwl_dump_ini_mon_dram_iter(struct iwl_fw_runtime *fwrt,
 			   struct iwl_fw_ini_region_cfg *reg,
 			   int idx)
 {
-	u32 start_addr = iwl_read_prph(fwrt->trans, MON_BUFF_BASE_ADDR_VER2);
+	u32 start_addr = iwl_read_umac_prph(fwrt->trans,
+					    MON_BUFF_BASE_ADDR_VER2);
 
 	if (start_addr == 0x5a5a5a5a)
 		return -1;
@@ -1173,8 +1175,10 @@ static struct iwl_fw_ini_error_dump_range
 		IWL_ERR(fwrt, "Failed to get DRAM monitor header\n");
 		return NULL;
 	}
-	write_ptr = iwl_read_prph_no_grab(fwrt->trans, MON_BUFF_WRPTR_VER2);
-	cycle_cnt = iwl_read_prph_no_grab(fwrt->trans, MON_BUFF_CYCLE_CNT_VER2);
+	write_ptr = iwl_read_umac_prph_no_grab(fwrt->trans,
+					       MON_BUFF_WRPTR_VER2);
+	cycle_cnt = iwl_read_umac_prph_no_grab(fwrt->trans,
+					       MON_BUFF_CYCLE_CNT_VER2);
 	iwl_trans_release_nic_access(fwrt->trans, &flags);
 
 	mon_dump->write_ptr = cpu_to_le32(write_ptr);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index b64fdfdcbce7..3ee86d18a97d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -299,13 +299,13 @@ _iwl_fw_dbg_stop_recording(struct iwl_trans *trans,
 	}
 
 	if (params) {
-		params->in_sample = iwl_read_prph(trans, DBGC_IN_SAMPLE);
-		params->out_ctrl = iwl_read_prph(trans, DBGC_OUT_CTRL);
+		params->in_sample = iwl_read_umac_prph(trans, DBGC_IN_SAMPLE);
+		params->out_ctrl = iwl_read_umac_prph(trans, DBGC_OUT_CTRL);
 	}
 
-	iwl_write_prph(trans, DBGC_IN_SAMPLE, 0);
+	iwl_write_umac_prph(trans, DBGC_IN_SAMPLE, 0);
 	udelay(100);
-	iwl_write_prph(trans, DBGC_OUT_CTRL, 0);
+	iwl_write_umac_prph(trans, DBGC_OUT_CTRL, 0);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	trans->dbg_rec_on = false;
 #endif
@@ -333,9 +333,9 @@ _iwl_fw_dbg_restart_recording(struct iwl_trans *trans,
 		iwl_clear_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x1);
 		iwl_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x1);
 	} else {
-		iwl_write_prph(trans, DBGC_IN_SAMPLE, params->in_sample);
+		iwl_write_umac_prph(trans, DBGC_IN_SAMPLE, params->in_sample);
 		udelay(100);
-		iwl_write_prph(trans, DBGC_OUT_CTRL, params->out_ctrl);
+		iwl_write_umac_prph(trans, DBGC_OUT_CTRL, params->out_ctrl);
 	}
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index d25b632eaa41..d06196802c61 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  * Copyright (C) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -29,7 +29,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright (C) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -382,6 +382,7 @@ struct iwl_csr_params {
  * @d3_debug_data_length: length of the D3 debug data
  * @bisr_workaround: BISR hardware workaround (for 22260 series devices)
  * @min_txq_size: minimum number of slots required in a TX queue
+ * @umac_prph_offset: offset to add to UMAC periphery address
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -448,6 +449,7 @@ struct iwl_cfg {
 	u32 d3_debug_data_base_addr;
 	u32 d3_debug_data_length;
 	u32 min_txq_size;
+	u32 umac_prph_offset;
 };
 
 extern const struct iwl_csr_params iwl_csr_v1;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index bf171edad53a..edba08768fac 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright(C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -29,7 +29,7 @@
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -308,8 +308,8 @@ void iwl_force_nmi(struct iwl_trans *trans)
 		iwl_write_prph(trans, DEVICE_SET_NMI_REG,
 			       DEVICE_SET_NMI_VAL_DRV);
 	else
-		iwl_write_prph(trans, UREG_NIC_SET_NMI_DRIVER,
-			       UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER_MSK);
+		iwl_write_umac_prph(trans, UREG_NIC_SET_NMI_DRIVER,
+				UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER_MSK);
 }
 IWL_EXPORT_SYMBOL(iwl_force_nmi);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index bf1100837d72..920e2146ea3f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -25,7 +25,7 @@
  *
  * BSD LICENSE
  *
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -104,4 +104,43 @@ int iwl_finish_nic_init(struct iwl_trans *trans);
 /* Error handling */
 int iwl_dump_fh(struct iwl_trans *trans, char **buf);
 
+/*
+ * UMAC periphery address space changed from 0xA00000 to 0xD00000 starting from
+ * device family AX200. So peripheries used in families above and below AX200
+ * should go through iwl_..._umac_..._prph.
+ */
+static inline u32 iwl_umac_prph(struct iwl_trans *trans, u32 ofs)
+{
+	return ofs + trans->cfg->umac_prph_offset;
+}
+
+static inline u32 iwl_read_umac_prph_no_grab(struct iwl_trans *trans, u32 ofs)
+{
+	return iwl_read_prph_no_grab(trans, ofs + trans->cfg->umac_prph_offset);
+}
+
+static inline u32 iwl_read_umac_prph(struct iwl_trans *trans, u32 ofs)
+{
+	return iwl_read_prph(trans, ofs + trans->cfg->umac_prph_offset);
+}
+
+static inline void iwl_write_umac_prph_no_grab(struct iwl_trans *trans, u32 ofs,
+					       u32 val)
+{
+	iwl_write_prph_no_grab(trans,  ofs + trans->cfg->umac_prph_offset, val);
+}
+
+static inline void iwl_write_umac_prph(struct iwl_trans *trans, u32 ofs,
+				       u32 val)
+{
+	iwl_write_prph(trans,  ofs + trans->cfg->umac_prph_offset, val);
+}
+
+static inline int iwl_poll_umac_prph_bit(struct iwl_trans *trans, u32 addr,
+					 u32 bits, u32 mask, int timeout)
+{
+	return iwl_poll_prph_bit(trans, addr + trans->cfg->umac_prph_offset,
+				 bits, mask, timeout);
+}
+
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 0278f19180d5..1589b64232ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -351,8 +351,9 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 		if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22000)
 			IWL_ERR(mvm,
 				"SecBoot CPU1 Status: 0x%x, CPU2 Status: 0x%x\n",
-				iwl_read_prph(trans, UMAG_SB_CPU_1_STATUS),
-				iwl_read_prph(trans, UMAG_SB_CPU_2_STATUS));
+				iwl_read_umac_prph(trans, UMAG_SB_CPU_1_STATUS),
+				iwl_read_umac_prph(trans,
+						   UMAG_SB_CPU_2_STATUS));
 		else if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_8000)
 			IWL_ERR(mvm,
 				"SecBoot CPU1 Status: 0x%x, CPU2 Status: 0x%x\n",
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index 55b9120a1360..1e36459948db 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,7 +18,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -177,13 +177,12 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 		    trans_pcie->iml_dma_addr);
 	iwl_write32(trans, CSR_IML_SIZE_ADDR, trans->iml_len);
 
-	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
-		iwl_write_prph(trans, UREG_CPU_INIT_RUN, 1);
-	} else {
-		iwl_set_bit(trans, CSR_CTXT_INFO_BOOT_CTRL,
-			    CSR_AUTO_FUNC_BOOT_ENA);
+	iwl_set_bit(trans, CSR_CTXT_INFO_BOOT_CTRL,
+		    CSR_AUTO_FUNC_BOOT_ENA);
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_AX210)
+		iwl_write_umac_prph(trans, UREG_CPU_INIT_RUN, 1);
+	else
 		iwl_set_bit(trans, CSR_GP_CNTRL, CSR_AUTO_FUNC_INIT);
-	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 587bb06c2cb1..38844215a58e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -202,9 +202,9 @@ int iwl_pcie_rx_stop(struct iwl_trans *trans)
 {
 	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
 		/* TODO: remove this for 22560 once fw does it */
-		iwl_write_prph(trans, RFH_RXF_DMA_CFG_GEN3, 0);
-		return iwl_poll_prph_bit(trans, RFH_GEN_STATUS_GEN3,
-					 RXF_DMA_IDLE, RXF_DMA_IDLE, 1000);
+		iwl_write_umac_prph(trans, RFH_RXF_DMA_CFG_GEN3, 0);
+		return iwl_poll_umac_prph_bit(trans, RFH_GEN_STATUS_GEN3,
+					      RXF_DMA_IDLE, RXF_DMA_IDLE, 1000);
 	} else if (trans->cfg->mq_rx_supported) {
 		iwl_write_prph(trans, RFH_RXF_DMA_CFG, 0);
 		return iwl_poll_prph_bit(trans, RFH_GEN_STATUS,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 4b31b0cdbd09..e2579a0bcc25 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2007 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2005 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -896,13 +896,13 @@ void iwl_pcie_apply_destination(struct iwl_trans *trans)
 		if (!trans->num_blocks)
 			return;
 
-		iwl_write_prph(trans, MON_BUFF_BASE_ADDR_VER2,
-			       trans->fw_mon[0].physical >>
-			       MON_BUFF_SHIFT_VER2);
-		iwl_write_prph(trans, MON_BUFF_END_ADDR_VER2,
-			       (trans->fw_mon[0].physical +
-				trans->fw_mon[0].size - 256) >>
-			       MON_BUFF_SHIFT_VER2);
+		iwl_write_umac_prph(trans, MON_BUFF_BASE_ADDR_VER2,
+				    trans->fw_mon[0].physical >>
+				    MON_BUFF_SHIFT_VER2);
+		iwl_write_umac_prph(trans, MON_BUFF_END_ADDR_VER2,
+				    (trans->fw_mon[0].physical +
+				     trans->fw_mon[0].size - 256) >>
+				    MON_BUFF_SHIFT_VER2);
 		return;
 	}
 
@@ -1183,8 +1183,8 @@ void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie)
 	if (!trans_pcie->msix_enabled) {
 		if (trans->cfg->mq_rx_supported &&
 		    test_bit(STATUS_DEVICE_ENABLED, &trans->status))
-			iwl_write_prph(trans, UREG_CHICK,
-				       UREG_CHICK_MSI_ENABLE);
+			iwl_write_umac_prph(trans, UREG_CHICK,
+					    UREG_CHICK_MSI_ENABLE);
 		return;
 	}
 	/*
@@ -1193,7 +1193,7 @@ void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie)
 	 * prph.
 	 */
 	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status))
-		iwl_write_prph(trans, UREG_CHICK, UREG_CHICK_MSIX_ENABLE);
+		iwl_write_umac_prph(trans, UREG_CHICK, UREG_CHICK_MSIX_ENABLE);
 
 	/*
 	 * Each cause from the causes list above and the RX causes is
@@ -1561,7 +1561,7 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 	}
 
 	IWL_DEBUG_POWER(trans, "WFPM value upon resume = 0x%08X\n",
-			iwl_read_prph(trans, WFPM_GP2));
+			iwl_read_umac_prph(trans, WFPM_GP2));
 
 	val = iwl_read32(trans, CSR_RESET);
 	if (val & CSR_RESET_REG_FLAG_NEVO_RESET)
@@ -1710,15 +1710,18 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 		return err;
 	}
 
-	hpm = iwl_trans_read_prph(trans, HPM_DEBUG);
+	hpm = iwl_read_umac_prph_no_grab(trans, HPM_DEBUG);
 	if (hpm != 0xa5a5a5a0 && (hpm & PERSISTENCE_BIT)) {
-		if (iwl_trans_read_prph(trans, PREG_PRPH_WPROT_0) &
-		    PREG_WFPM_ACCESS) {
+		int wfpm_val = iwl_read_umac_prph_no_grab(trans,
+							  PREG_PRPH_WPROT_0);
+
+		if (wfpm_val & PREG_WFPM_ACCESS) {
 			IWL_ERR(trans,
 				"Error, can not clear persistence bit\n");
 			return -EPERM;
 		}
-		iwl_trans_write_prph(trans, HPM_DEBUG, hpm & ~PERSISTENCE_BIT);
+		iwl_write_umac_prph_no_grab(trans, HPM_DEBUG,
+					    hpm & ~PERSISTENCE_BIT);
 	}
 
 	iwl_trans_pcie_sw_reset(trans);
@@ -2968,7 +2971,8 @@ static u32 iwl_trans_pcie_fh_regs_dump(struct iwl_trans *trans,
 		     i += sizeof(u32))
 			*val++ = cpu_to_le32(iwl_trans_pcie_read32(trans, i));
 	else
-		for (i = FH_MEM_LOWER_BOUND_GEN2; i < FH_MEM_UPPER_BOUND_GEN2;
+		for (i = iwl_umac_prph(trans, FH_MEM_LOWER_BOUND_GEN2);
+		     i < iwl_umac_prph(trans, FH_MEM_UPPER_BOUND_GEN2);
 		     i += sizeof(u32))
 			*val++ = cpu_to_le32(iwl_trans_pcie_read_prph(trans,
 								      i));
@@ -2993,11 +2997,11 @@ iwl_trans_pci_dump_marbh_monitor(struct iwl_trans *trans,
 	if (!iwl_trans_grab_nic_access(trans, &flags))
 		return 0;
 
-	iwl_write_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x1);
+	iwl_write_umac_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x1);
 	for (i = 0; i < buf_size_in_dwords; i++)
-		buffer[i] = iwl_read_prph_no_grab(trans,
-				MON_DMARB_RD_DATA_ADDR);
-	iwl_write_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x0);
+		buffer[i] = iwl_read_umac_prph_no_grab(trans,
+						       MON_DMARB_RD_DATA_ADDR);
+	iwl_write_umac_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x0);
 
 	iwl_trans_release_nic_access(trans, &flags);
 
@@ -3012,9 +3016,9 @@ iwl_trans_pcie_dump_pointers(struct iwl_trans *trans,
 
 	/* If there was a dest TLV - use the values from there */
 	if (trans->ini_valid) {
-		base = MON_BUFF_BASE_ADDR_VER2;
-		write_ptr = MON_BUFF_WRPTR_VER2;
-		wrap_cnt = MON_BUFF_CYCLE_CNT_VER2;
+		base = iwl_umac_prph(trans, MON_BUFF_BASE_ADDR_VER2);
+		write_ptr = iwl_umac_prph(trans, MON_BUFF_WRPTR_VER2);
+		wrap_cnt = iwl_umac_prph(trans, MON_BUFF_CYCLE_CNT_VER2);
 	} else if (trans->dbg_dest_tlv) {
 		write_ptr = le32_to_cpu(trans->dbg_dest_tlv->write_ptr_reg);
 		wrap_cnt = le32_to_cpu(trans->dbg_dest_tlv->wrap_count);
@@ -3176,8 +3180,8 @@ static struct iwl_trans_dump_data
 	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_FH_REGS)) {
 		if (trans->cfg->gen2)
 			len += sizeof(*data) +
-			       (FH_MEM_UPPER_BOUND_GEN2 -
-				FH_MEM_LOWER_BOUND_GEN2);
+			       (iwl_umac_prph(trans, FH_MEM_UPPER_BOUND_GEN2) -
+				iwl_umac_prph(trans, FH_MEM_LOWER_BOUND_GEN2));
 		else
 			len += sizeof(*data) +
 			       (FH_MEM_UPPER_BOUND -
@@ -3507,9 +3511,11 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		if (iwl_trans_grab_nic_access(trans, &flags)) {
 			u32 hw_step;
 
-			hw_step = iwl_read_prph_no_grab(trans, WFPM_CTRL_REG);
+			hw_step = iwl_read_umac_prph_no_grab(trans,
+							     WFPM_CTRL_REG);
 			hw_step |= ENABLE_WFPM;
-			iwl_write_prph_no_grab(trans, WFPM_CTRL_REG, hw_step);
+			iwl_write_umac_prph_no_grab(trans, WFPM_CTRL_REG,
+						    hw_step);
 			hw_step = iwl_read_prph_no_grab(trans, AUX_MISC_REG);
 			hw_step = (hw_step >> HW_STEP_LOCATION_BITS) & 0xF;
 			if (hw_step == 0x3)
-- 
2.20.1

