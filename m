Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27309 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbYJ2VFZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:05:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/7] iwlwifi: reorganize flow handler bitology
Date: Wed, 29 Oct 2008 14:05:43 -0700
Message-Id: <1225314349-11139-2-git-send-email-reinette.chatre@intel.com> (sfid-20081029_220533_306004_B0E93285)
In-Reply-To: <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch cleans up FH bits and adds missing register values
that will be used later in TX initialization rewrite

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-fh.h   |   52 +++++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    4 +-
 3 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 4348c7d..1608b28 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -535,7 +535,7 @@ static int iwl5000_load_section(struct iwl_priv *priv,
 	iwl_write_direct32(priv,
 		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	|
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE_VAL |
+		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
 		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
 	iwl_release_nic_access(priv);
@@ -549,14 +549,13 @@ static int iwl5000_load_given_ucode(struct iwl_priv *priv,
 {
 	int ret = 0;
 
-	ret = iwl5000_load_section(
-		priv, inst_image, RTC_INST_LOWER_BOUND);
+	ret = iwl5000_load_section(priv, inst_image, RTC_INST_LOWER_BOUND);
 	if (ret)
 		return ret;
 
 	IWL_DEBUG_INFO("INST uCode section being loaded...\n");
 	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
-				priv->ucode_write_complete, 5 * HZ);
+					priv->ucode_write_complete, 5 * HZ);
 	if (ret == -ERESTARTSYS) {
 		IWL_ERROR("Could not load the INST uCode section due "
 			"to interrupt\n");
@@ -753,6 +752,7 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 	priv->cfg->ops->lib->txq_set_sched(priv, IWL_MASK(0, 7));
 
 	iwl5000_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
+
 	/* map qos queues to fifos one-to-one */
 	for (i = 0; i < ARRAY_SIZE(iwl5000_default_queue_to_tx_fifo); i++) {
 		int ac = iwl5000_default_queue_to_tx_fifo[i];
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index f2688d5..97e2cf4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -318,34 +318,40 @@
 #define FH_TCSR_UPPER_BOUND  (FH_MEM_LOWER_BOUND + 0xE60)
 
 /* Find Control/Status reg for given Tx DMA/FIFO channel */
-#define FH_TCSR_CHNL_TX_CONFIG_REG(_chnl) \
-	(FH_TCSR_LOWER_BOUND + 0x20 * _chnl)
+#define FH49_TCSR_CHNL_NUM                            (7)
+#define FH50_TCSR_CHNL_NUM                            (8)
 
-#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE_VAL    (0x00000000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL     (0x00000008)
+#define FH_TCSR_CHNL_TX_CONFIG_REG(_chnl)	\
+		(FH_TCSR_LOWER_BOUND + 0x20 * (_chnl))
+#define FH_TCSR_CHNL_TX_CREDIT_REG(_chnl)	\
+		(FH_TCSR_LOWER_BOUND + 0x20 * (_chnl) + 0x4)
+#define FH_TCSR_CHNL_TX_BUF_STS_REG(_chnl)	\
+		(FH_TCSR_LOWER_BOUND + 0x20 * (_chnl) + 0x8)
 
-#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE            (0x00000000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE_EOF        (0x40000000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE           (0x80000000)
+#define FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF		(0x00000000)
+#define FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_DRV		(0x00000001)
 
-#define FH_TCSR_CHNL_NUM                            (7)
+#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	(0x00000000)
+#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE	(0x00000008)
 
-#define FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_EMPTY          (0x00000000)
-#define FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_WAIT           (0x00002000)
-#define FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID          (0x00000003)
+#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_NOINT	(0x00000000)
+#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD	(0x00100000)
+#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD	(0x00200000)
 
-#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_NOINT           (0x00000000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD          (0x00100000)
-#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD           (0x00200000)
+#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT	(0x00000000)
+#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_ENDTFD	(0x00400000)
+#define FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_IFTFD	(0x00800000)
 
-#define FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM      (20)
-#define FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX      (12)
-#define FH_TCSR_CHNL_TX_CONFIG_REG(_chnl) \
-	(FH_TCSR_LOWER_BOUND + 0x20 * _chnl)
-#define FH_TCSR_CHNL_TX_CREDIT_REG(_chnl) \
-	  (FH_TCSR_LOWER_BOUND + 0x20 * _chnl + 0x4)
-#define FH_TCSR_CHNL_TX_BUF_STS_REG(_chnl) \
-	 (FH_TCSR_LOWER_BOUND + 0x20 * _chnl + 0x8)
+#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE	(0x00000000)
+#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE_EOF	(0x40000000)
+#define FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	(0x80000000)
+
+#define FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_EMPTY	(0x00000000)
+#define FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_WAIT	(0x00002000)
+#define FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID	(0x00000003)
+
+#define FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM		(20)
+#define FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX		(12)
 
 /**
  * Tx Shared Status Registers (TSSR)
@@ -362,7 +368,7 @@
 #define FH_TSSR_LOWER_BOUND		(FH_MEM_LOWER_BOUND + 0xEA0)
 #define FH_TSSR_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xEC0)
 
-#define FH_TSSR_TX_STATUS_REG	(FH_TSSR_LOWER_BOUND + 0x010)
+#define FH_TSSR_TX_STATUS_REG		(FH_TSSR_LOWER_BOUND + 0x010)
 
 #define FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_chnl) ((1 << (_chnl)) << 24)
 #define FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_chnl) ((1 << (_chnl)) << 16)
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 3649360..785da5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -431,8 +431,8 @@ static int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 
 	/* Enable DMA channel, using same id as for TFD queue */
 	iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(txq_id),
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL);
+			FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+			FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
 
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.5.4.3

