Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:50693 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbYIZHOT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 03:14:19 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/3] iwlwifi: refactor rx register initialization
Date: Fri, 26 Sep 2008 15:09:32 +0800
Message-Id: <1222412974-18221-1-git-send-email-yi.zhu@intel.com> (sfid-20080926_091423_290173_A154DA6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

The patch adds HW bug W/A FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY so that we
can enable again interrupt coalescing. It also uses named constants for
open code.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h  |    9 +++++----
 drivers/net/wireless/iwlwifi/iwl-rx.c  |   30 +++++++++++++++++++-----------
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 52629fb..662edf4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -64,7 +64,7 @@
 #define CSR_BASE    (0x000)
 
 #define CSR_HW_IF_CONFIG_REG    (CSR_BASE+0x000) /* hardware interface config */
-#define CSR_INT_COALESCING      (CSR_BASE+0x004) /* accum ints, 32-usec units */
+#define CSR_INT_COALESCING     (CSR_BASE+0x004) /* accum ints, 32-usec units */
 #define CSR_INT                 (CSR_BASE+0x008) /* host interrupt status/ack */
 #define CSR_INT_MASK            (CSR_BASE+0x00c) /* host interrupt enable */
 #define CSR_FH_INT_STATUS       (CSR_BASE+0x010) /* busmaster int status/ack*/
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index cd11c0c..a72efdf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -247,8 +247,8 @@
 #define FH_RCSR_CHNL0_RX_CONFIG_RBDBC_SIZE_MSK (0x00F00000) /* bits 20-23 */
 #define FH_RCSR_CHNL0_RX_CONFIG_DMA_CHNL_EN_MSK (0xC0000000) /* bits 30-31*/
 
-#define FH_RCSR_RX_CONFIG_RBDCB_SIZE_BITSHIFT	(20)
-#define FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_BITSHIFT	(4)
+#define FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS	(20)
+#define FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS	(4)
 #define RX_RB_TIMEOUT	(0x10)
 
 #define FH_RCSR_RX_CONFIG_CHNL_EN_PAUSE_VAL         (0x00000000)
@@ -260,8 +260,9 @@
 #define FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_12K   (0x00020000)
 #define FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_16K   (0x00030000)
 
-#define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_NO_INT_VAL       (0x00000000)
-#define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL     (0x00001000)
+#define FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY              (0x00000004)
+#define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_NO_INT_VAL    (0x00000000)
+#define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL  (0x00001000)
 
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 38b2946..7cde9d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -376,7 +376,9 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
 	int ret;
 	unsigned long flags;
-	unsigned int rb_size;
+	u32 rb_size;
+	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
+	const u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT why this stalls RX */
 
 	spin_lock_irqsave(&priv->lock, flags);
 	ret = iwl_grab_nic_access(priv);
@@ -398,26 +400,32 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 
 	/* Tell device where to find RBD circular buffer in DRAM */
 	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-			   rxq->dma_addr >> 8);
+			   (u32)(rxq->dma_addr >> 8));
 
 	/* Tell device where in DRAM to update its Rx status */
 	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
 			   (priv->shared_phys + priv->rb_closed_offset) >> 4);
 
-	/* Enable Rx DMA, enable host interrupt, Rx buffer size 4k, 256 RBDs */
+	/* Enable Rx DMA
+	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set becuase of HW bug in
+	 *      the credit mechanism in 5000 HW RX FIFO
+	 * Direct rx interrupts to hosts
+	 * Rx buffer size 4 or 8k
+	 * RB timeout 0x10
+	 * 256 RBDs
+	 */
 	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
 			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
+			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
 			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-			   rb_size |
-			     /* 0x10 << 4 | */
-			   (RX_QUEUE_SIZE_LOG <<
-			      FH_RCSR_RX_CONFIG_RBDCB_SIZE_BITSHIFT));
-
-	/*
-	 * iwl_write32(priv,CSR_INT_COAL_REG,0);
-	 */
+			   rb_size|
+			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
+			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
 
 	iwl_release_nic_access(priv);
+
+	iwl_write32(priv, CSR_INT_COALESCING, 0x40);
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
-- 
1.5.3.6

