Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13214 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab0FNSY4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 14:24:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/6] iwlwifi: rename rxq->dma_addr
Date: Mon, 14 Jun 2010 11:24:50 -0700
Message-Id: <1276539892-12471-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
References: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Rename rxq->dma_addr to rxq->bd_dma to better emphasize that the
physical address stands for the receive buffer descriptor's address.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 0fa1d51..93d513e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -844,7 +844,7 @@ static int iwl3945_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 
 static int iwl3945_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
-	iwl_write_direct32(priv, FH39_RCSR_RBD_BASE(0), rxq->dma_addr);
+	iwl_write_direct32(priv, FH39_RCSR_RBD_BASE(0), rxq->bd_dma);
 	iwl_write_direct32(priv, FH39_RCSR_RPTR_ADDR(0), rxq->rb_stts_dma);
 	iwl_write_direct32(priv, FH39_RCSR_WPTR(0), 0);
 	iwl_write_direct32(priv, FH39_RCSR_CONFIG(0),
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 548f51d..90bd98c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -486,7 +486,7 @@ int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 
 	/* Tell device where to find RBD circular buffer in DRAM */
 	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-			   (u32)(rxq->dma_addr >> 8));
+			   (u32)(rxq->bd_dma >> 8));
 
 	/* Tell device where in DRAM to update its Rx status */
 	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
@@ -751,7 +751,7 @@ void iwlagn_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	}
 
 	dma_free_coherent(&priv->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			  rxq->dma_addr);
+			  rxq->bd_dma);
 	dma_free_coherent(&priv->pci_dev->dev, sizeof(struct iwl_rb_status),
 			  rxq->rb_stts, rxq->rb_stts_dma);
 	rxq->bd = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 52c3cdd..da54e6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -348,7 +348,7 @@ struct iwl_host_cmd {
 /**
  * struct iwl_rx_queue - Rx queue
  * @bd: driver's pointer to buffer of receive buffer descriptors (rbd)
- * @dma_addr: bus address of buffer of receive buffer descriptors (rbd)
+ * @bd_dma: bus address of buffer of receive buffer descriptors (rbd)
  * @read: Shared index to newest available Rx buffer
  * @write: Shared index to oldest written Rx packet
  * @free_count: Number of pre-allocated buffers in rx_free
@@ -362,7 +362,7 @@ struct iwl_host_cmd {
  */
 struct iwl_rx_queue {
 	__le32 *bd;
-	dma_addr_t dma_addr;
+	dma_addr_t bd_dma;
 	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
 	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
 	u32 read;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 5e32057..86a3537 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -175,7 +175,7 @@ int iwl_rx_queue_alloc(struct iwl_priv *priv)
 	INIT_LIST_HEAD(&rxq->rx_used);
 
 	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
-	rxq->bd = dma_alloc_coherent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr,
+	rxq->bd = dma_alloc_coherent(dev, 4 * RX_QUEUE_SIZE, &rxq->bd_dma,
 				     GFP_KERNEL);
 	if (!rxq->bd)
 		goto err_bd;
@@ -199,7 +199,7 @@ int iwl_rx_queue_alloc(struct iwl_priv *priv)
 
 err_rb:
 	dma_free_coherent(&priv->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			  rxq->dma_addr);
+			  rxq->bd_dma);
 err_bd:
 	return -ENOMEM;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index fddae22..eb71a8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1171,7 +1171,7 @@ static void iwl3945_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rx
 	}
 
 	dma_free_coherent(&priv->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			  rxq->dma_addr);
+			  rxq->bd_dma);
 	dma_free_coherent(&priv->pci_dev->dev, sizeof(struct iwl_rb_status),
 			  rxq->rb_stts, rxq->rb_stts_dma);
 	rxq->bd = NULL;
-- 
1.7.0.4

