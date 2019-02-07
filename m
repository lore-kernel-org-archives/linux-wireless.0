Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CE8C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCDED2173B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfBGWhH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:37:07 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56696 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726758AbfBGWhG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 17:37:06 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grsHn-0002II-4W; Fri, 08 Feb 2019 00:36:48 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 00:36:18 +0200
Message-Id: <20190207223622.9642-14-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207223622.9642-1-luca@coelho.fi>
References: <20190207223622.9642-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/17] iwlwifi: introduce device family AX210
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

Add new device family AX210.
Make the needed changes for this family.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 47 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  7 +++
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |  3 +-
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       | 13 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  8 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 15 +++++-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  7 +--
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 17 +++++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 12 ++++-
 10 files changed, 119 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index e4933c355dfd..6f231d05fc1b 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -84,6 +84,10 @@
 #define IWL_22000_SU_Z0_FW_PRE		"iwlwifi-su-z0-"
 #define IWL_QU_B_JF_B_FW_PRE		"iwlwifi-Qu-b0-jf-b0-"
 #define IWL_CC_A_FW_PRE			"iwlwifi-cc-a0-"
+#define IWL_22000_SO_A_JF_B_FW_PRE	"iwlwifi-so-a0-jf-b0-"
+#define IWL_22000_SO_A_HR_B_FW_PRE      "iwlwifi-so-a0-hr-b0-"
+#define IWL_22000_SO_A_GF_A_FW_PRE      "iwlwifi-so-a0-gf-a0-"
+#define IWL_22000_TY_A_GF_A_FW_PRE      "iwlwifi-ty-a0-gf-a0-"
 
 #define IWL_22000_HR_MODULE_FIRMWARE(api) \
 	IWL_22000_HR_FW_PRE __stringify(api) ".ucode"
@@ -107,6 +111,14 @@
 	IWL_QU_B_JF_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_CC_A_MODULE_FIRMWARE(api) \
 	IWL_CC_A_FW_PRE __stringify(api) ".ucode"
+#define IWL_22000_SO_A_JF_B_MODULE_FIRMWARE(api) \
+	IWL_22000_SO_A_JF_B_FW_PRE __stringify(api) ".ucode"
+#define IWL_22000_SO_A_HR_B_MODULE_FIRMWARE(api) \
+	IWL_22000_SO_A_HR_B_FW_PRE __stringify(api) ".ucode"
+#define IWL_22000_SO_A_GF_A_MODULE_FIRMWARE(api) \
+	IWL_22000_SO_A_GF_A_FW_PRE __stringify(api) ".ucode"
+#define IWL_22000_TY_A_GF_A_MODULE_FIRMWARE(api) \
+	IWL_22000_TY_A_GF_A_FW_PRE __stringify(api) ".ucode"
 
 static const struct iwl_base_params iwl_22000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_32K,
@@ -179,6 +191,13 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.base_params = &iwl_22560_base_params,				\
 	.csr = &iwl_csr_v2
 
+#define IWL_DEVICE_AX210						\
+	IWL_DEVICE_22000_COMMON,					\
+	.device_family = IWL_DEVICE_FAMILY_AX210,			\
+	.base_params = &iwl_22000_base_params,				\
+	.csr = &iwl_csr_v1,						\
+	.min_txq_size = 128
+
 const struct iwl_cfg iwl22000_2ac_cfg_hr = {
 	.name = "Intel(R) Dual Band Wireless AC 22000",
 	.fw_name_pre = IWL_22000_HR_FW_PRE,
@@ -387,6 +406,30 @@ const struct iwl_cfg iwl22560_2ax_cfg_su_cdb = {
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
+const struct iwl_cfg iwlax210_2ax_cfg_so_jf_a0 = {
+	.name = "Intel(R) Wireless-AC 9560 160MHz",
+	.fw_name_pre = IWL_22000_SO_A_JF_B_FW_PRE,
+	IWL_DEVICE_AX210,
+};
+
+const struct iwl_cfg iwlax210_2ax_cfg_so_hr_a0 = {
+	.name = "Intel(R) Wi-Fi 6 AX201 160MHz",
+	.fw_name_pre = IWL_22000_SO_A_HR_B_FW_PRE,
+	IWL_DEVICE_AX210,
+};
+
+const struct iwl_cfg iwlax210_2ax_cfg_so_gf_a0 = {
+	.name = "Intel(R) Wi-Fi 7 AX211 160MHz",
+	.fw_name_pre = IWL_22000_SO_A_GF_A_FW_PRE,
+	IWL_DEVICE_AX210,
+};
+
+const struct iwl_cfg iwlax210_2ax_cfg_ty_gf_a0 = {
+	.name = "Intel(R) Wi-Fi 7 AX210 160MHz",
+	.fw_name_pre = IWL_22000_TY_A_GF_A_FW_PRE,
+	IWL_DEVICE_AX210,
+};
+
 MODULE_FIRMWARE(IWL_22000_HR_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_JF_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
@@ -397,3 +440,7 @@ MODULE_FIRMWARE(IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_SU_Z0_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_B_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_CC_A_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_22000_SO_A_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_22000_SO_A_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_22000_SO_A_GF_A_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_22000_TY_A_GF_A_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 5e713730165a..d25b632eaa41 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -89,6 +89,7 @@ enum iwl_device_family {
 	IWL_DEVICE_FAMILY_9000,
 	IWL_DEVICE_FAMILY_22000,
 	IWL_DEVICE_FAMILY_22560,
+	IWL_DEVICE_FAMILY_AX210,
 };
 
 /*
@@ -380,6 +381,7 @@ struct iwl_csr_params {
  * @d3_debug_data_base_addr: base address where D3 debug data is stored
  * @d3_debug_data_length: length of the D3 debug data
  * @bisr_workaround: BISR hardware workaround (for 22260 series devices)
+ * @min_txq_size: minimum number of slots required in a TX queue
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -445,6 +447,7 @@ struct iwl_cfg {
 	u32 extra_phy_cfg_flags;
 	u32 d3_debug_data_base_addr;
 	u32 d3_debug_data_length;
+	u32 min_txq_size;
 };
 
 extern const struct iwl_csr_params iwl_csr_v1;
@@ -563,6 +566,10 @@ extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_b0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_jf_b0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0;
 extern const struct iwl_cfg iwl22560_2ax_cfg_su_cdb;
+extern const struct iwl_cfg iwlax210_2ax_cfg_so_jf_a0;
+extern const struct iwl_cfg iwlax210_2ax_cfg_so_hr_a0;
+extern const struct iwl_cfg iwlax210_2ax_cfg_so_gf_a0;
+extern const struct iwl_cfg iwlax210_2ax_cfg_ty_gf_a0;
 #endif /* CPTCFG_IWLMVM || CPTCFG_IWLFMAC */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index d0ce3a79c387..aea6d03e545a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -328,11 +328,14 @@ enum {
 #define CSR_HW_REV_TYPE_QNJ		(0x0000360)
 #define CSR_HW_REV_TYPE_QNJ_B0		(0x0000364)
 #define CSR_HW_REV_TYPE_HR_CDB		(0x0000340)
+#define CSR_HW_REV_TYPE_SO		(0x0000370)
+#define CSR_HW_REV_TYPE_TY		(0x0000420)
 
 /* RF_ID value */
 #define CSR_HW_RF_ID_TYPE_JF		(0x00105100)
 #define CSR_HW_RF_ID_TYPE_HR		(0x0010A000)
 #define CSR_HW_RF_ID_TYPE_HRCDB		(0x00109F00)
+#define CSR_HW_RF_ID_TYPE_GF		(0x0010D000)
 
 /* HW_RF CHIP ID  */
 #define CSR_HW_RF_ID_TYPE_CHIP_ID(_val) (((_val) >> 12) & 0xFFF)
@@ -594,6 +597,7 @@ enum msix_hw_int_causes {
 	MSIX_HW_INT_CAUSES_REG_ALIVE		= BIT(0),
 	MSIX_HW_INT_CAUSES_REG_WAKEUP		= BIT(1),
 	MSIX_HW_INT_CAUSES_REG_IPC		= BIT(1),
+	MSIX_HW_INT_CAUSES_REG_IML              = BIT(2),
 	MSIX_HW_INT_CAUSES_REG_SW_ERR_V2	= BIT(5),
 	MSIX_HW_INT_CAUSES_REG_CT_KILL		= BIT(6),
 	MSIX_HW_INT_CAUSES_REG_RF_KILL		= BIT(7),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 27839c10d5e3..498c315291cf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -750,7 +750,8 @@ static int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm,
 
 	if (tid == IWL_MAX_TID_COUNT) {
 		tid = IWL_MGMT_TID;
-		size = IWL_MGMT_QUEUE_SIZE;
+		size = max_t(u32, IWL_MGMT_QUEUE_SIZE,
+			     mvm->trans->cfg->min_txq_size);
 	}
 	queue = iwl_trans_txq_alloc(mvm->trans,
 				    cpu_to_le16(TX_QUEUE_CFG_ENABLE_QUEUE),
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index ceb3aa03d561..55b9120a1360 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -66,6 +66,7 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	void *iml_img;
 	u32 control_flags = 0;
 	int ret;
+	int cmdq_size = max_t(u32, TFD_CMD_SLOTS, trans->cfg->min_txq_size);
 
 	/* Allocate prph scratch */
 	prph_scratch = dma_alloc_coherent(trans->dev, sizeof(*prph_scratch),
@@ -151,7 +152,7 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	ctxt_info_gen3->mcr_base_addr =
 		cpu_to_le64(trans_pcie->rxq->used_bd_dma);
 	ctxt_info_gen3->mtr_size =
-		cpu_to_le16(TFD_QUEUE_CB_SIZE(TFD_CMD_SLOTS));
+		cpu_to_le16(TFD_QUEUE_CB_SIZE(cmdq_size));
 	ctxt_info_gen3->mcr_size =
 		cpu_to_le16(RX_QUEUE_CB_SIZE(MQ_RX_TABLE_SIZE));
 
@@ -175,8 +176,14 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	iwl_write64(trans, CSR_IML_DATA_ADDR,
 		    trans_pcie->iml_dma_addr);
 	iwl_write32(trans, CSR_IML_SIZE_ADDR, trans->iml_len);
-	iwl_set_bit(trans, CSR_CTXT_INFO_BOOT_CTRL, CSR_AUTO_FUNC_BOOT_ENA);
-	iwl_set_bit(trans, CSR_GP_CNTRL, CSR_AUTO_FUNC_INIT);
+
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
+		iwl_write_prph(trans, UREG_CPU_INIT_RUN, 1);
+	} else {
+		iwl_set_bit(trans, CSR_CTXT_INFO_BOOT_CTRL,
+			    CSR_AUTO_FUNC_BOOT_ENA);
+		iwl_set_bit(trans, CSR_GP_CNTRL, CSR_AUTO_FUNC_INIT);
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index a22e47639a4e..4a1b7bb9a6c6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -948,6 +948,14 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x1a56, 0x1653, killer1650w_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x1a56, 0x1654, killer1650x_2ax_cfg)},
 
+	{IWL_PCI_DEVICE(0x2725, 0x0090, iwlax210_2ax_cfg_so_hr_a0)},
+	{IWL_PCI_DEVICE(0x7A70, 0x0090, iwlax210_2ax_cfg_so_hr_a0)},
+	{IWL_PCI_DEVICE(0x7A70, 0x0310, iwlax210_2ax_cfg_so_hr_a0)},
+	{IWL_PCI_DEVICE(0x2725, 0x0020, iwlax210_2ax_cfg_so_hr_a0)},
+	{IWL_PCI_DEVICE(0x2725, 0x0310, iwlax210_2ax_cfg_so_hr_a0)},
+	{IWL_PCI_DEVICE(0x2725, 0x0A10, iwlax210_2ax_cfg_so_hr_a0)},
+	{IWL_PCI_DEVICE(0x2725, 0x00B0, iwlax210_2ax_cfg_so_hr_a0)},
+
 #endif /* CONFIG_IWLMVM */
 
 	{0}
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 49c2ce549c86..587bb06c2cb1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -247,7 +247,7 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 	}
 
 	rxq->write_actual = round_down(rxq->write, 8);
-	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_22560)
 		iwl_write32(trans, HBUS_TARG_WRPTR,
 			    (rxq->write_actual |
 			     ((FIRST_RX_QUEUE + rxq->id) << 16)));
@@ -2133,7 +2133,7 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 		}
 	}
 
-	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560 &&
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_22560 &&
 	    inta_hw & MSIX_HW_INT_CAUSES_REG_IPC) {
 		/* Reflect IML transfer status */
 		int res = iwl_read32(trans, CSR_IML_RESP_ADDR);
@@ -2152,6 +2152,17 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 		isr_stats->wakeup++;
 	}
 
+	if (inta_hw & MSIX_HW_INT_CAUSES_REG_IML) {
+		/* Reflect IML transfer status */
+		int res = iwl_read32(trans, CSR_IML_RESP_ADDR);
+
+		IWL_DEBUG_ISR(trans, "IML transfer status: %d\n", res);
+		if (res == IWL_IMAGE_RESP_FAIL) {
+			isr_stats->sw++;
+			iwl_pcie_irq_handle_error(trans);
+		}
+	}
+
 	/* Chip got too hot and stopped itself */
 	if (inta_hw & MSIX_HW_INT_CAUSES_REG_CT_KILL) {
 		IWL_ERR(trans, "Microcode CT kill error detected.\n");
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index e2d64378c932..9c203ca75de9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -171,7 +171,7 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power)
 	}
 
 	iwl_pcie_ctxt_info_free_paging(trans);
-	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_22560)
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
 		iwl_pcie_ctxt_info_gen3_free(trans);
 	else
 		iwl_pcie_ctxt_info_free(trans);
@@ -234,6 +234,7 @@ void iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power)
 static int iwl_pcie_gen2_nic_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int queue_size = max_t(u32, TFD_CMD_SLOTS, trans->cfg->min_txq_size);
 
 	/* TODO: most of the logic can be removed in A0 - but not in Z0 */
 	spin_lock(&trans_pcie->irq_lock);
@@ -247,7 +248,7 @@ static int iwl_pcie_gen2_nic_init(struct iwl_trans *trans)
 		return -ENOMEM;
 
 	/* Allocate or reset and init all Tx and Command queues */
-	if (iwl_pcie_gen2_tx_init(trans, trans_pcie->cmd_queue, TFD_CMD_SLOTS))
+	if (iwl_pcie_gen2_tx_init(trans, trans_pcie->cmd_queue, queue_size))
 		return -ENOMEM;
 
 	/* enable shadow regs in HW */
@@ -332,7 +333,7 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 		goto out;
 	}
 
-	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_22560)
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
 		ret = iwl_pcie_ctxt_info_gen3_init(trans, fw);
 	else
 		ret = iwl_pcie_ctxt_info_init(trans, fw);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 375d8f25b886..6c30c88fc41e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1094,6 +1094,7 @@ static struct iwl_causes_list causes_list[] = {
 	{MSIX_FH_INT_CAUSES_FH_ERR,		CSR_MSIX_FH_INT_MASK_AD, 0x5},
 	{MSIX_HW_INT_CAUSES_REG_ALIVE,		CSR_MSIX_HW_INT_MASK_AD, 0x10},
 	{MSIX_HW_INT_CAUSES_REG_WAKEUP,		CSR_MSIX_HW_INT_MASK_AD, 0x11},
+	{MSIX_HW_INT_CAUSES_REG_IML,            CSR_MSIX_HW_INT_MASK_AD, 0x12},
 	{MSIX_HW_INT_CAUSES_REG_CT_KILL,	CSR_MSIX_HW_INT_MASK_AD, 0x16},
 	{MSIX_HW_INT_CAUSES_REG_RF_KILL,	CSR_MSIX_HW_INT_MASK_AD, 0x17},
 	{MSIX_HW_INT_CAUSES_REG_PERIODIC,	CSR_MSIX_HW_INT_MASK_AD, 0x18},
@@ -1126,7 +1127,7 @@ static void iwl_pcie_map_non_rx_causes(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie =  IWL_TRANS_GET_PCIE_TRANS(trans);
 	int val = trans_pcie->def_irq | MSIX_NON_AUTO_CLEAR_CAUSE;
 	int i, arr_size =
-		(trans->cfg->device_family < IWL_DEVICE_FAMILY_22560) ?
+		(trans->cfg->device_family != IWL_DEVICE_FAMILY_22560) ?
 		ARRAY_SIZE(causes_list) : ARRAY_SIZE(causes_list_v2);
 
 	/*
@@ -1136,7 +1137,7 @@ static void iwl_pcie_map_non_rx_causes(struct iwl_trans *trans)
 	 */
 	for (i = 0; i < arr_size; i++) {
 		struct iwl_causes_list *causes =
-			(trans->cfg->device_family < IWL_DEVICE_FAMILY_22560) ?
+			(trans->cfg->device_family != IWL_DEVICE_FAMILY_22560) ?
 			causes_list : causes_list_v2;
 
 		iwl_write8(trans, CSR_MSIX_IVAR(causes[i].addr), val);
@@ -3503,7 +3504,17 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 #if IS_ENABLED(CONFIG_IWLMVM)
 	trans->hw_rf_id = iwl_read32(trans, CSR_HW_RF_ID);
 
-	if (cfg == &iwl22560_2ax_cfg_hr) {
+	if (cfg == &iwlax210_2ax_cfg_so_hr_a0) {
+		if (trans->hw_rev == CSR_HW_REV_TYPE_TY) {
+			trans->cfg = &iwlax210_2ax_cfg_ty_gf_a0;
+		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+			   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_JF)) {
+			trans->cfg = &iwlax210_2ax_cfg_so_jf_a0;
+		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+			   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_GF)) {
+			trans->cfg = &iwlax210_2ax_cfg_so_gf_a0;
+		}
+	} else if (cfg == &iwl22560_2ax_cfg_hr) {
 		if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
 			trans->cfg = &iwl22560_2ax_cfg_hr;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 28a371814387..d8773e0a6062 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -995,7 +995,11 @@ static int iwl_pcie_tx_alloc(struct iwl_trans *trans)
 	     txq_id++) {
 		bool cmd_queue = (txq_id == trans_pcie->cmd_queue);
 
-		slots_num = cmd_queue ? TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+		if (cmd_queue)
+			slots_num = max_t(u32, TFD_CMD_SLOTS,
+					  trans->cfg->min_txq_size);
+		else
+			slots_num = TFD_TX_CMD_SLOTS;
 		trans_pcie->txq[txq_id] = &trans_pcie->txq_memory[txq_id];
 		ret = iwl_pcie_txq_alloc(trans, trans_pcie->txq[txq_id],
 					 slots_num, cmd_queue);
@@ -1044,7 +1048,11 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 	     txq_id++) {
 		bool cmd_queue = (txq_id == trans_pcie->cmd_queue);
 
-		slots_num = cmd_queue ? TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+		if (cmd_queue)
+			slots_num = max_t(u32, TFD_CMD_SLOTS,
+					  trans->cfg->min_txq_size);
+		else
+			slots_num = TFD_TX_CMD_SLOTS;
 		ret = iwl_pcie_txq_init(trans, trans_pcie->txq[txq_id],
 					slots_num, cmd_queue);
 		if (ret) {
-- 
2.20.1

