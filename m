Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7687 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab2BCAQ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:57 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/28] iwlwifi: consolidate the start_device flow
Date: Thu,  2 Feb 2012 15:09:07 -0800
Message-Id: <1328224159-18134-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011727_810782_FC8FFEA7)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Now there is only one transport function that launch a specific fw:
trans_ops->start_fw. This one replaces trans_ops->start_device and
trans_ops->kick_nic. The code that actually loads the fw to the
device has been moved to the transport specific code.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    4 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |   88 +++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-trans.h         |   44 +++++------
 drivers/net/wireless/iwlwifi/iwl-ucode.c         |   87 ++--------------------
 4 files changed, 103 insertions(+), 120 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index ebea243..731f287 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1130,11 +1130,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		isr_stats->tx++;
 		handled |= CSR_INT_BIT_FH_TX;
 		/* Wake up uCode load routine, now that load is complete */
-#ifdef CONFIG_IWLWIFI_IDI
-		trans->shrd->trans->ucode_write_complete = 1;
-#else
 		trans->ucode_write_complete = 1;
-#endif
 		wake_up(&trans->shrd->wait_command_queue);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 362444a..1030a25 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -64,6 +64,7 @@
 #include <linux/pci-aspm.h>
 #include <linux/interrupt.h>
 #include <linux/debugfs.h>
+#include <linux/sched.h>
 #include <linux/bitops.h>
 #include <linux/gfp.h>
 
@@ -895,7 +896,79 @@ static const u8 iwlagn_pan_ac_to_queue[] = {
 	7, 6, 5, 4,
 };
 
-static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
+/*
+ * ucode
+ */
+static int iwl_load_section(struct iwl_trans *trans, const char *name,
+				struct fw_desc *image, u32 dst_addr)
+{
+	dma_addr_t phy_addr = image->p_addr;
+	u32 byte_cnt = image->len;
+	int ret;
+
+	trans->ucode_write_complete = 0;
+
+	iwl_write_direct32(trans,
+		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
+		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
+
+	iwl_write_direct32(trans,
+		FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL), dst_addr);
+
+	iwl_write_direct32(trans,
+		FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
+		phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
+
+	iwl_write_direct32(trans,
+		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
+		(iwl_get_dma_hi_addr(phy_addr)
+			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
+
+	iwl_write_direct32(trans,
+		FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
+		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM |
+		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX |
+		FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
+
+	iwl_write_direct32(trans,
+		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
+		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	|
+		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
+		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
+
+	IWL_DEBUG_FW(trans, "%s uCode section being loaded...\n", name);
+	ret = wait_event_timeout(trans->shrd->wait_command_queue,
+				 trans->ucode_write_complete, 5 * HZ);
+	if (!ret) {
+		IWL_ERR(trans, "Could not load the %s uCode section\n",
+			name);
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static int iwl_load_given_ucode(struct iwl_trans *trans, struct fw_img *image)
+{
+	int ret = 0;
+
+	ret = iwl_load_section(trans, "INST", &image->code,
+				   IWLAGN_RTC_INST_LOWER_BOUND);
+	if (ret)
+		return ret;
+
+	ret = iwl_load_section(trans, "DATA", &image->data,
+				    IWLAGN_RTC_DATA_LOWER_BOUND);
+	if (ret)
+		return ret;
+
+	/* Remove all resets to allow NIC to operate */
+	iwl_write32(trans, CSR_RESET, 0);
+
+	return 0;
+}
+
+static int iwl_trans_pcie_start_fw(struct iwl_trans *trans, struct fw_img *fw)
 {
 	int ret;
 	struct iwl_trans_pcie *trans_pcie =
@@ -951,6 +1024,9 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
+	/* Load the given image to the HW */
+	iwl_load_given_ucode(trans, fw);
+
 	return 0;
 }
 
@@ -1353,12 +1429,6 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	return 0;
 }
 
-static void iwl_trans_pcie_kick_nic(struct iwl_trans *trans)
-{
-	/* Remove all resets to allow NIC to operate */
-	iwl_write32(trans, CSR_RESET, 0);
-}
-
 static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie =
@@ -2086,7 +2156,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.start_hw = iwl_trans_pcie_start_hw,
 	.stop_hw = iwl_trans_pcie_stop_hw,
 	.fw_alive = iwl_trans_pcie_fw_alive,
-	.start_device = iwl_trans_pcie_start_device,
+	.start_fw = iwl_trans_pcie_start_fw,
 	.stop_device = iwl_trans_pcie_stop_device,
 
 	.wake_any_queue = iwl_trans_pcie_wake_any_queue,
@@ -2100,8 +2170,6 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.tx_agg_alloc = iwl_trans_pcie_tx_agg_alloc,
 	.tx_agg_setup = iwl_trans_pcie_tx_agg_setup,
 
-	.kick_nic = iwl_trans_pcie_kick_nic,
-
 	.free = iwl_trans_pcie_free,
 	.stop_queue = iwl_trans_pcie_stop_queue,
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index d0b6146..4d1ae65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -131,13 +131,25 @@ struct iwl_host_cmd {
 	u8 id;
 };
 
+/* one for each uCode image (inst/data, boot/init/runtime) */
+struct fw_desc {
+	dma_addr_t p_addr;	/* hardware address */
+	void *v_addr;		/* software address */
+	u32 len;		/* size in bytes */
+};
+
+struct fw_img {
+	struct fw_desc code;	/* firmware code image */
+	struct fw_desc data;	/* firmware data image */
+};
+
 /**
  * struct iwl_trans_ops - transport specific operations
  * @start_hw: starts the HW- from that point on, the HW can send interrupts
  * @stop_hw: stops the HW- from that point on, the HW will be in low power but
  *	will still issue interrupt if the HW RF kill is triggered.
- * @start_device: allocates and inits all the resources for the transport
- *                layer.
+ * @start_fw: allocates and inits all the resources for the transport
+ *	layer. Also kick a fw image. This handler may sleep.
  * @fw_alive: called when the fw sends alive notification
  * @wake_any_queue: wake all the queues of a specfic context IWL_RXON_CTX_*
  * @stop_device:stops the whole device (embedded CPU put to reset)
@@ -148,7 +160,6 @@ struct iwl_host_cmd {
  * @tx_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
  *                 ready and a successful ADDBA response has been received.
  * @tx_agg_disable: de-configure a Tx queue to send AMPDUs
- * @kick_nic: remove the RESET from the embedded CPU and let it run
  * @free: release all the ressource for the transport layer itself such as
  *        irq, tasklet etc...
  * @stop_queue: stop a specific queue
@@ -166,7 +177,7 @@ struct iwl_trans_ops {
 
 	int (*start_hw)(struct iwl_trans *iwl_trans);
 	void (*stop_hw)(struct iwl_trans *iwl_trans);
-	int (*start_device)(struct iwl_trans *trans);
+	int (*start_fw)(struct iwl_trans *trans, struct fw_img *fw);
 	void (*fw_alive)(struct iwl_trans *trans);
 	void (*stop_device)(struct iwl_trans *trans);
 
@@ -191,8 +202,6 @@ struct iwl_trans_ops {
 			     enum iwl_rxon_context_id ctx, int sta_id, int tid,
 			     int frame_limit, u16 ssn);
 
-	void (*kick_nic)(struct iwl_trans *trans);
-
 	void (*free)(struct iwl_trans *trans);
 
 	void (*stop_queue)(struct iwl_trans *trans, int q, const char *msg);
@@ -209,18 +218,6 @@ struct iwl_trans_ops {
 	u32 (*read32)(struct iwl_trans *trans, u32 ofs);
 };
 
-/* one for each uCode image (inst/data, boot/init/runtime) */
-struct fw_desc {
-	dma_addr_t p_addr;	/* hardware address */
-	void *v_addr;		/* software address */
-	u32 len;		/* size in bytes */
-};
-
-struct fw_img {
-	struct fw_desc code;	/* firmware code image */
-	struct fw_desc data;	/* firmware data image */
-};
-
 /* Opaque calibration results */
 struct iwl_calib_result {
 	struct list_head list;
@@ -284,9 +281,11 @@ static inline void iwl_trans_fw_alive(struct iwl_trans *trans)
 	trans->ops->fw_alive(trans);
 }
 
-static inline int iwl_trans_start_device(struct iwl_trans *trans)
+static inline int iwl_trans_start_fw(struct iwl_trans *trans, struct fw_img *fw)
 {
-	return trans->ops->start_device(trans);
+	might_sleep();
+
+	return trans->ops->start_fw(trans, fw);
 }
 
 static inline void iwl_trans_stop_device(struct iwl_trans *trans)
@@ -347,11 +346,6 @@ static inline void iwl_trans_tx_agg_setup(struct iwl_trans *trans,
 	trans->ops->tx_agg_setup(trans, ctx, sta_id, tid, frame_limit, ssn);
 }
 
-static inline void iwl_trans_kick_nic(struct iwl_trans *trans)
-{
-	trans->ops->kick_nic(trans);
-}
-
 static inline void iwl_trans_free(struct iwl_trans *trans)
 {
 	trans->ops->free(trans);
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 793524a..87ce587 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -120,58 +120,6 @@ int iwl_alloc_fw_desc(struct iwl_trans *trans, struct fw_desc *desc,
 	return 0;
 }
 
-/*
- * ucode
- */
-static int iwl_load_section(struct iwl_trans *trans, const char *name,
-				struct fw_desc *image, u32 dst_addr)
-{
-	dma_addr_t phy_addr = image->p_addr;
-	u32 byte_cnt = image->len;
-	int ret;
-
-	trans->ucode_write_complete = 0;
-
-	iwl_write_direct32(trans,
-		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
-
-	iwl_write_direct32(trans,
-		FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL), dst_addr);
-
-	iwl_write_direct32(trans,
-		FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
-		phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
-
-	iwl_write_direct32(trans,
-		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
-		(iwl_get_dma_hi_addr(phy_addr)
-			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
-
-	iwl_write_direct32(trans,
-		FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
-		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM |
-		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX |
-		FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
-
-	iwl_write_direct32(trans,
-		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	|
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
-		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
-
-	IWL_DEBUG_FW(trans, "%s uCode section being loaded...\n", name);
-	ret = wait_event_timeout(trans->shrd->wait_command_queue,
-				 trans->ucode_write_complete, 5 * HZ);
-	if (!ret) {
-		IWL_ERR(trans, "Could not load the %s uCode section\n",
-			name);
-		return -ETIMEDOUT;
-	}
-
-	return 0;
-}
-
 static inline struct fw_img *iwl_get_ucode_image(struct iwl_trans *trans,
 					enum iwl_ucode_type ucode_type)
 {
@@ -188,28 +136,6 @@ static inline struct fw_img *iwl_get_ucode_image(struct iwl_trans *trans,
 	return NULL;
 }
 
-static int iwl_load_given_ucode(struct iwl_trans *trans,
-				   enum iwl_ucode_type ucode_type)
-{
-	int ret = 0;
-	struct fw_img *image = iwl_get_ucode_image(trans, ucode_type);
-
-
-	if (!image) {
-		IWL_ERR(trans, "Invalid ucode requested (%d)\n",
-			ucode_type);
-		return -EINVAL;
-	}
-
-	ret = iwl_load_section(trans, "INST", &image->code,
-				   IWLAGN_RTC_INST_LOWER_BOUND);
-	if (ret)
-		return ret;
-
-	return iwl_load_section(trans, "DATA", &image->data,
-				    IWLAGN_RTC_DATA_LOWER_BOUND);
-}
-
 /*
  *  Calibration
  */
@@ -646,28 +572,27 @@ int iwl_load_ucode_wait_alive(struct iwl_trans *trans,
 {
 	struct iwl_notification_wait alive_wait;
 	struct iwl_alive_data alive_data;
+	struct fw_img *fw;
 	int ret;
 	enum iwl_ucode_type old_type;
 
-	ret = iwl_trans_start_device(trans);
-	if (ret)
-		return ret;
-
 	iwl_init_notification_wait(trans->shrd, &alive_wait, REPLY_ALIVE,
 				      iwl_alive_fn, &alive_data);
 
 	old_type = trans->shrd->ucode_type;
 	trans->shrd->ucode_type = ucode_type;
+	fw = iwl_get_ucode_image(trans, ucode_type);
 
-	ret = iwl_load_given_ucode(trans, ucode_type);
+	if (!fw)
+		return -EINVAL;
+
+	ret = iwl_trans_start_fw(trans, fw);
 	if (ret) {
 		trans->shrd->ucode_type = old_type;
 		iwl_remove_notification(trans->shrd, &alive_wait);
 		return ret;
 	}
 
-	iwl_trans_kick_nic(trans);
-
 	/*
 	 * Some things may run in the background now, but we
 	 * just wait for the ALIVE notification here.
-- 
1.7.0.4

