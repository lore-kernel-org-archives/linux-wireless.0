Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:42800 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759282AbYEWCL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:27 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: add ucode loaders for iwl5000
Date: Fri, 23 May 2008 10:08:58 +0800
Message-Id: <1211508569-3163-21-git-send-email-yi.zhu@intel.com> (sfid-20080523_042832_524163_10EB7701)
In-Reply-To: <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds ucode initialization handler and functions to load
ucode for iwl5000 NIC.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |  134 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    8 ++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 +
 3 files changed, 145 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 00ad360..b6bdffc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -287,6 +287,139 @@ static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
 	return &priv->eeprom[address];
 }
 
+/*
+ * ucode
+ */
+static int iwl5000_load_section(struct iwl_priv *priv,
+				struct fw_desc *image,
+				u32 dst_addr)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	dma_addr_t phy_addr = image->p_addr;
+	u32 byte_cnt = image->len;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	ret = iwl_grab_nic_access(priv);
+	if (ret) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return ret;
+	}
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
+	/* FIME: write the MSB of the phy_addr in CTRL1
+	 * iwl_write_direct32(priv,
+		IWL_FH_TFDIB_CTRL1_REG(IWL_FH_SRVC_CHNL),
+		((phy_addr & MSB_MSK)
+			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_count);
+	 */
+	iwl_write_direct32(priv,
+		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL), byte_cnt);
+	iwl_write_direct32(priv,
+		FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
+		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM |
+		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX |
+		FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
+
+	iwl_write_direct32(priv,
+		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
+		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	|
+		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE_VAL |
+		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
+
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return 0;
+}
+
+static int iwl5000_load_given_ucode(struct iwl_priv *priv,
+		struct fw_desc *inst_image,
+		struct fw_desc *data_image)
+{
+	int ret = 0;
+
+	ret = iwl5000_load_section(
+		priv, inst_image, RTC_INST_LOWER_BOUND);
+	if (ret)
+		return ret;
+
+	IWL_DEBUG_INFO("INST uCode section being loaded...\n");
+	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+				priv->ucode_write_complete, 5 * HZ);
+	if (ret == -ERESTARTSYS) {
+		IWL_ERROR("Could not load the INST uCode section due "
+			"to interrupt\n");
+		return ret;
+	}
+	if (!ret) {
+		IWL_ERROR("Could not load the INST uCode section\n");
+		return -ETIMEDOUT;
+	}
+
+	priv->ucode_write_complete = 0;
+
+	ret = iwl5000_load_section(
+		priv, data_image, RTC_DATA_LOWER_BOUND);
+	if (ret)
+		return ret;
+
+	IWL_DEBUG_INFO("DATA uCode section being loaded...\n");
+
+	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+				priv->ucode_write_complete, 5 * HZ);
+	if (ret == -ERESTARTSYS) {
+		IWL_ERROR("Could not load the INST uCode section due "
+			"to interrupt\n");
+		return ret;
+	} else if (!ret) {
+		IWL_ERROR("Could not load the DATA uCode section\n");
+		return -ETIMEDOUT;
+	} else
+		ret = 0;
+
+	priv->ucode_write_complete = 0;
+
+	return ret;
+}
+
+static int iwl5000_load_ucode(struct iwl_priv *priv)
+{
+	int ret = 0;
+
+	/* check whether init ucode should be loaded, or rather runtime ucode */
+	if (priv->ucode_init.len && (priv->ucode_type == UCODE_NONE)) {
+		IWL_DEBUG_INFO("Init ucode found. Loading init ucode...\n");
+		ret = iwl5000_load_given_ucode(priv,
+			&priv->ucode_init, &priv->ucode_init_data);
+		if (!ret) {
+			IWL_DEBUG_INFO("Init ucode load complete.\n");
+			priv->ucode_type = UCODE_INIT;
+		}
+	} else {
+		IWL_DEBUG_INFO("Init ucode not found, or already loaded. "
+			"Loading runtime ucode...\n");
+		ret = iwl5000_load_given_ucode(priv,
+			&priv->ucode_code, &priv->ucode_data);
+		if (!ret) {
+			IWL_DEBUG_INFO("Runtime ucode load complete.\n");
+			priv->ucode_type = UCODE_RT;
+		}
+	}
+
+	return ret;
+}
+
 static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if ((priv->cfg->mod_params->num_of_queues > IWL50_NUM_QUEUES) ||
@@ -488,6 +621,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.disable_tx_fifo = iwl5000_disable_tx_fifo,
 	.rx_handler_setup = iwl5000_rx_handler_setup,
+	.load_ucode = iwl5000_load_ucode,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.config = iwl5000_nic_config,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 533479e..b1ff0af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -876,6 +876,12 @@ struct statistics_general_data {
 	u32 beacon_energy_c;
 };
 
+enum ucode_type {
+	UCODE_NONE = 0,
+	UCODE_INIT,
+	UCODE_RT
+};
+
 #ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 /* Sensitivity calib data */
 struct iwl_sensitivity_data {
@@ -1010,6 +1016,8 @@ struct iwl_priv {
 	struct fw_desc ucode_init;	/* initialization inst */
 	struct fw_desc ucode_init_data;	/* initialization data */
 	struct fw_desc ucode_boot;	/* bootstrap inst */
+	enum ucode_type ucode_type;
+	u8 ucode_write_complete;	/* the image write is complete */
 
 
 	struct iwl4965_rxon_time_cmd rxon_timing;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 40616db..e06142d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2978,6 +2978,9 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	if (inta & CSR_INT_BIT_FH_TX) {
 		IWL_DEBUG_ISR("Tx interrupt\n");
 		handled |= CSR_INT_BIT_FH_TX;
+		/* FH finished to write, send event */
+		priv->ucode_write_complete = 1;
+		wake_up_interruptible(&priv->wait_command_queue);
 	}
 
 	if (inta & ~handled)
-- 
1.5.3.6

