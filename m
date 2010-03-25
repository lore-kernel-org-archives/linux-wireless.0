Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab0CYUoy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:54 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/22] iwlwifi: code cleanup for "load ucode" function
Date: Thu, 25 Mar 2010 13:44:32 -0700
Message-Id: <1269549890-19195-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Loading uCode functions are shared across multiple agn devices.
Move those functions to iwl-agn-ucode.c file with other uCode
related functions.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c      |  103 +-------------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |  102 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    3 +
 5 files changed, 110 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index ad61464..283c4ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -173,7 +173,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.rx_handler_setup = iwl5000_rx_handler_setup,
 	.setup_deferred_work = iwl5000_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
-	.load_ucode = iwl5000_load_ucode,
+	.load_ucode = iwlagn_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index bbcb9c5..bea2f46 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -423,105 +423,6 @@ static void iwl5000_rx_calib_complete(struct iwl_priv *priv,
 	queue_work(priv->workqueue, &priv->restart);
 }
 
-/*
- * ucode
- */
-static int iwl5000_load_section(struct iwl_priv *priv, const char *name,
-				struct fw_desc *image, u32 dst_addr)
-{
-	dma_addr_t phy_addr = image->p_addr;
-	u32 byte_cnt = image->len;
-	int ret;
-
-	priv->ucode_write_complete = 0;
-
-	iwl_write_direct32(priv,
-		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
-
-	iwl_write_direct32(priv,
-		FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL), dst_addr);
-
-	iwl_write_direct32(priv,
-		FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
-		phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
-
-	iwl_write_direct32(priv,
-		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
-		(iwl_get_dma_hi_addr(phy_addr)
-			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
-
-	iwl_write_direct32(priv,
-		FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
-		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM |
-		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX |
-		FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
-
-	iwl_write_direct32(priv,
-		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	|
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
-		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
-
-	IWL_DEBUG_INFO(priv, "%s uCode section being loaded...\n", name);
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
-					priv->ucode_write_complete, 5 * HZ);
-	if (ret == -ERESTARTSYS) {
-		IWL_ERR(priv, "Could not load the %s uCode section due "
-			"to interrupt\n", name);
-		return ret;
-	}
-	if (!ret) {
-		IWL_ERR(priv, "Could not load the %s uCode section\n",
-			name);
-		return -ETIMEDOUT;
-	}
-
-	return 0;
-}
-
-static int iwl5000_load_given_ucode(struct iwl_priv *priv,
-		struct fw_desc *inst_image,
-		struct fw_desc *data_image)
-{
-	int ret = 0;
-
-	ret = iwl5000_load_section(priv, "INST", inst_image,
-				   IWL50_RTC_INST_LOWER_BOUND);
-	if (ret)
-		return ret;
-
-	return iwl5000_load_section(priv, "DATA", data_image,
-				    IWL50_RTC_DATA_LOWER_BOUND);
-}
-
-int iwl5000_load_ucode(struct iwl_priv *priv)
-{
-	int ret = 0;
-
-	/* check whether init ucode should be loaded, or rather runtime ucode */
-	if (priv->ucode_init.len && (priv->ucode_type == UCODE_NONE)) {
-		IWL_DEBUG_INFO(priv, "Init ucode found. Loading init ucode...\n");
-		ret = iwl5000_load_given_ucode(priv,
-			&priv->ucode_init, &priv->ucode_init_data);
-		if (!ret) {
-			IWL_DEBUG_INFO(priv, "Init ucode load complete.\n");
-			priv->ucode_type = UCODE_INIT;
-		}
-	} else {
-		IWL_DEBUG_INFO(priv, "Init ucode not found, or already loaded. "
-			"Loading runtime ucode...\n");
-		ret = iwl5000_load_given_ucode(priv,
-			&priv->ucode_code, &priv->ucode_data);
-		if (!ret) {
-			IWL_DEBUG_INFO(priv, "Runtime ucode load complete.\n");
-			priv->ucode_type = UCODE_RT;
-		}
-	}
-
-	return ret;
-}
-
 void iwl5000_init_alive_start(struct iwl_priv *priv)
 {
 	int ret = 0;
@@ -1413,7 +1314,7 @@ struct iwl_lib_ops iwl5000_lib = {
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
 	.dump_fh = iwl_dump_fh,
-	.load_ucode = iwl5000_load_ucode,
+	.load_ucode = iwlagn_load_ucode,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
@@ -1470,7 +1371,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
-	.load_ucode = iwl5000_load_ucode,
+	.load_ucode = iwlagn_load_ucode,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 4026eb4..b729717 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -237,7 +237,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.rx_handler_setup = iwl5000_rx_handler_setup,
 	.setup_deferred_work = iwl5000_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
-	.load_ucode = iwl5000_load_ucode,
+	.load_ucode = iwlagn_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
@@ -304,7 +304,7 @@ static struct iwl_lib_ops iwl6050_lib = {
 	.rx_handler_setup = iwl5000_rx_handler_setup,
 	.setup_deferred_work = iwl5000_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
-	.load_ucode = iwl5000_load_ucode,
+	.load_ucode = iwlagn_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 67f15c0..f57a4f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -30,9 +30,111 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
+#include "iwl-io.h"
+#include "iwl-5000-hw.h"
+
+/*
+ * ucode
+ */
+static int iwlagn_load_section(struct iwl_priv *priv, const char *name,
+				struct fw_desc *image, u32 dst_addr)
+{
+	dma_addr_t phy_addr = image->p_addr;
+	u32 byte_cnt = image->len;
+	int ret;
+
+	priv->ucode_write_complete = 0;
+
+	iwl_write_direct32(priv,
+		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
+		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
+
+	iwl_write_direct32(priv,
+		FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL), dst_addr);
+
+	iwl_write_direct32(priv,
+		FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
+		phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
+
+	iwl_write_direct32(priv,
+		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
+		(iwl_get_dma_hi_addr(phy_addr)
+			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
+
+	iwl_write_direct32(priv,
+		FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
+		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM |
+		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX |
+		FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
+
+	iwl_write_direct32(priv,
+		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
+		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	|
+		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
+		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
+
+	IWL_DEBUG_INFO(priv, "%s uCode section being loaded...\n", name);
+	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+					priv->ucode_write_complete, 5 * HZ);
+	if (ret == -ERESTARTSYS) {
+		IWL_ERR(priv, "Could not load the %s uCode section due "
+			"to interrupt\n", name);
+		return ret;
+	}
+	if (!ret) {
+		IWL_ERR(priv, "Could not load the %s uCode section\n",
+			name);
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static int iwlagn_load_given_ucode(struct iwl_priv *priv,
+		struct fw_desc *inst_image,
+		struct fw_desc *data_image)
+{
+	int ret = 0;
+
+	ret = iwlagn_load_section(priv, "INST", inst_image,
+				   IWL50_RTC_INST_LOWER_BOUND);
+	if (ret)
+		return ret;
+
+	return iwlagn_load_section(priv, "DATA", data_image,
+				    IWL50_RTC_DATA_LOWER_BOUND);
+}
+
+int iwlagn_load_ucode(struct iwl_priv *priv)
+{
+	int ret = 0;
+
+	/* check whether init ucode should be loaded, or rather runtime ucode */
+	if (priv->ucode_init.len && (priv->ucode_type == UCODE_NONE)) {
+		IWL_DEBUG_INFO(priv, "Init ucode found. Loading init ucode...\n");
+		ret = iwlagn_load_given_ucode(priv,
+			&priv->ucode_init, &priv->ucode_init_data);
+		if (!ret) {
+			IWL_DEBUG_INFO(priv, "Init ucode load complete.\n");
+			priv->ucode_type = UCODE_INIT;
+		}
+	} else {
+		IWL_DEBUG_INFO(priv, "Init ucode not found, or already loaded. "
+			"Loading runtime ucode...\n");
+		ret = iwlagn_load_given_ucode(priv,
+			&priv->ucode_code, &priv->ucode_data);
+		if (!ret) {
+			IWL_DEBUG_INFO(priv, "Runtime ucode load complete.\n");
+			priv->ucode_type = UCODE_RT;
+		}
+	}
+
+	return ret;
+}
 
 #define IWL_UCODE_GET(item)						\
 static u32 iwlagn_ucode_get_##item(const struct iwl_ucode_header *ucode,\
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index a266649..5af528d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -75,4 +75,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data);
 bool iwl_good_ack_health(struct iwl_priv *priv,
 			 struct iwl_rx_packet *pkt);
 
+/* uCode */
+int iwlagn_load_ucode(struct iwl_priv *priv);
+
 #endif /* __iwl_agn_h__ */
-- 
1.6.3.3

