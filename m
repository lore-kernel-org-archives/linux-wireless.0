Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756612AbZAHSSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:18:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/11] iwl3945: use hw_params.rx_buf_size
Date: Thu,  8 Jan 2009 10:19:57 -0800
Message-Id: <1231438802-10991-7-git-send-email-reinette.chatre@intel.com> (sfid-20090108_191840_860249_4D38B4F6)
In-Reply-To: <1231438802-10991-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1231438802-10991-1-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-2-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-3-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-4-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-5-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch makes 3945 use of hw_params.rx_buf_size instead of
IWL_RX_BUF_SIZE. It also renames IWL_RX_BUF_SIZE to IWL_RX_BUF_SIZE_3K
and moves rx buffer defines into iwl-fh.h.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |   13 -------------
 drivers/net/wireless/iwlwifi/iwl-fh.h       |   15 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 +++++++++------
 5 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index fc34a42..1b712e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2486,7 +2486,7 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 		return -ENOMEM;
 	}
 
-	priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE;
+	priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_3K;
 	priv->hw_params.max_pkt_size = 2342;
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index be30134..491313b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -96,7 +96,6 @@ enum iwl3945_antenna {
  * else RTS for data/management frames where MPDU is larger
  *   than RTS value.
  */
-#define IWL_RX_BUF_SIZE           3000U
 #define DEFAULT_RTS_THRESHOLD     2347U
 #define MIN_RTS_THRESHOLD         0U
 #define MAX_RTS_THRESHOLD         2347U
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index e751c53..ed6baa5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -110,19 +110,6 @@
 
 #define IWL_DEFAULT_TX_RETRY  15
 
-#define RX_QUEUE_SIZE                         256
-#define RX_QUEUE_MASK                         255
-#define RX_QUEUE_SIZE_LOG                     8
-
-/*
- * RX related structures and functions
- */
-#define RX_FREE_BUFFERS 64
-#define RX_LOW_WATERMARK 8
-
-/* Size of one Rx buffer in host DRAM */
-#define IWL_RX_BUF_SIZE_4K (4 * 1024)
-#define IWL_RX_BUF_SIZE_8K (8 * 1024)
 
 /* Sizes and addresses for instruction and data memory (SRAM) in
  * 4965's embedded processor.  Driver access is via HBUS_TARG_MEM_* regs. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index a72aa1b..ad5a24e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -399,6 +399,21 @@
  */
 #define FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN	(0x00000002)
 
+#define RX_QUEUE_SIZE                         256
+#define RX_QUEUE_MASK                         255
+#define RX_QUEUE_SIZE_LOG                     8
+
+/*
+ * RX related structures and functions
+ */
+#define RX_FREE_BUFFERS 64
+#define RX_LOW_WATERMARK 8
+
+/* Size of one Rx buffer in host DRAM */
+#define IWL_RX_BUF_SIZE_3K (3 * 1000) /* 3945 only */
+#define IWL_RX_BUF_SIZE_4K (4 * 1024)
+#define IWL_RX_BUF_SIZE_8K (8 * 1024)
+
 /**
  * struct iwl_rb_status - reseve buffer status
  * 	host memory mapped FH registers
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f72ec15..a4c44d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3287,7 +3287,8 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv)
 
 		/* Alloc a new receive buffer */
 		rxb->skb =
-		    alloc_skb(IWL_RX_BUF_SIZE, __GFP_NOWARN | GFP_ATOMIC);
+		    alloc_skb(priv->hw_params.rx_buf_size,
+				__GFP_NOWARN | GFP_ATOMIC);
 		if (!rxb->skb) {
 			if (net_ratelimit())
 				IWL_CRIT(priv, ": Can not allocate SKB buffers\n");
@@ -3309,9 +3310,10 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv)
 		list_del(element);
 
 		/* Get physical address of RB/SKB */
-		rxb->real_dma_addr =
-		    pci_map_single(priv->pci_dev, rxb->skb->data,
-				   IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+		rxb->real_dma_addr = pci_map_single(priv->pci_dev,
+						rxb->skb->data,
+						priv->hw_params.rx_buf_size,
+						PCI_DMA_FROMDEVICE);
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
 	}
@@ -3460,7 +3462,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 		rxq->queue[i] = NULL;
 
 		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->real_dma_addr,
-					    IWL_RX_BUF_SIZE,
+					    priv->hw_params.rx_buf_size,
 					    PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
@@ -3510,7 +3512,8 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 		}
 
 		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
-				 IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+				priv->hw_params.rx_buf_size,
+				PCI_DMA_FROMDEVICE);
 		spin_lock_irqsave(&rxq->lock, flags);
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
 		spin_unlock_irqrestore(&rxq->lock, flags);
-- 
1.5.4.3

