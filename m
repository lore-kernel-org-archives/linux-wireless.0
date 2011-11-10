Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab1KJBdc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:32 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/28] iwlagn: move ucode_write_complete from priv to trans structure
Date: Wed,  9 Nov 2011 16:39:11 -0800
Message-Id: <1320885571-19122-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023345_651824_9C4D0BBD)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

ucode_write_complete is used for ucode loading.  Move it as part of
restructuring work out of the priv structure.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c     |   29 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h         |    3 ++
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 8ba0dd5..502659a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -75,48 +75,49 @@ static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
 /*
  * ucode
  */
-static int iwlagn_load_section(struct iwl_priv *priv, const char *name,
+static int iwlagn_load_section(struct iwl_trans *trans, const char *name,
 				struct fw_desc *image, u32 dst_addr)
 {
+	struct iwl_bus *bus = bus(trans);
 	dma_addr_t phy_addr = image->p_addr;
 	u32 byte_cnt = image->len;
 	int ret;
 
-	priv->ucode_write_complete = 0;
+	trans->ucode_write_complete = 0;
 
-	iwl_write_direct32(bus(priv),
+	iwl_write_direct32(bus,
 		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
 
-	iwl_write_direct32(bus(priv),
+	iwl_write_direct32(bus,
 		FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL), dst_addr);
 
-	iwl_write_direct32(bus(priv),
+	iwl_write_direct32(bus,
 		FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
 		phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
 
-	iwl_write_direct32(bus(priv),
+	iwl_write_direct32(bus,
 		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
 		(iwl_get_dma_hi_addr(phy_addr)
 			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
 
-	iwl_write_direct32(bus(priv),
+	iwl_write_direct32(bus,
 		FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
 		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM |
 		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX |
 		FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
 
-	iwl_write_direct32(bus(priv),
+	iwl_write_direct32(bus,
 		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	|
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
 		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
-	IWL_DEBUG_FW(priv, "%s uCode section being loaded...\n", name);
-	ret = wait_event_timeout(priv->shrd->wait_command_queue,
-				 priv->ucode_write_complete, 5 * HZ);
+	IWL_DEBUG_FW(bus, "%s uCode section being loaded...\n", name);
+	ret = wait_event_timeout(trans->shrd->wait_command_queue,
+				 trans->ucode_write_complete, 5 * HZ);
 	if (!ret) {
-		IWL_ERR(priv, "Could not load the %s uCode section\n",
+		IWL_ERR(trans, "Could not load the %s uCode section\n",
 			name);
 		return -ETIMEDOUT;
 	}
@@ -129,12 +130,12 @@ static int iwlagn_load_given_ucode(struct iwl_priv *priv,
 {
 	int ret = 0;
 
-	ret = iwlagn_load_section(priv, "INST", &image->code,
+	ret = iwlagn_load_section(trans(priv), "INST", &image->code,
 				   IWLAGN_RTC_INST_LOWER_BOUND);
 	if (ret)
 		return ret;
 
-	return iwlagn_load_section(priv, "DATA", &image->data,
+	return iwlagn_load_section(trans(priv), "DATA", &image->data,
 				    IWLAGN_RTC_DATA_LOWER_BOUND);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ef8620b..4279e01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -920,7 +920,6 @@ struct iwl_priv {
 	struct fw_img ucode_wowlan;
 
 	enum iwlagn_ucode_type ucode_type;
-	u8 ucode_write_complete;	/* the image write is complete */
 	char firmware_name[25];
 
 	struct iwl_rxon_context contexts[NUM_IWL_RXON_CTX];
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 374c68c..ee126f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1108,7 +1108,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		isr_stats->tx++;
 		handled |= CSR_INT_BIT_FH_TX;
 		/* Wake up uCode load routine, now that load is complete */
-		priv(trans)->ucode_write_complete = 1;
+		trans->ucode_write_complete = 1;
 		wake_up(&trans->shrd->wait_command_queue);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index c592312..34b817f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -212,12 +212,15 @@ struct iwl_trans_ops {
  * @ops - pointer to iwl_trans_ops
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
  * @hcmd_lock: protects HCMD
+ * @ucode_write_complete: indicates that the ucode has been copied.
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
 	struct iwl_shared *shrd;
 	spinlock_t hcmd_lock;
 
+	u8 ucode_write_complete;	/* the image write is complete */
+
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char trans_specific[0] __attribute__((__aligned__(sizeof(void *))));
-- 
1.7.0.4

