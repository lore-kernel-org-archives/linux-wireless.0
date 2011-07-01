Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26451 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab1GAPxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 11:53:04 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/11] iwlagn: add rx_free to transport layer
Date: Fri,  1 Jul 2011 08:20:00 -0700
Message-Id: <1309533605-25774-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110701_175314_010991_70E47D90)
In-Reply-To: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The transport layer ness to release all rx ressources. This function is an API for it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   27 ----------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-trans.c   |   78 +++++++++++++++++++++-------
 5 files changed, 62 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3d97114..a2c5c6b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -910,33 +910,6 @@ void iwlagn_rx_replenish_now(struct iwl_priv *priv)
 	iwlagn_rx_queue_restock(priv);
 }
 
-/* Assumes that the skb field of the buffers in 'pool' is kept accurate.
- * If an SKB has been detached, the POOL needs to have its SKB set to NULL
- * This free routine walks the list of POOL entries and if SKB is set to
- * non NULL it is unmapped and freed
- */
-void iwlagn_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
-{
-	int i;
-	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
-		if (rxq->pool[i].page != NULL) {
-			dma_unmap_page(priv->bus.dev, rxq->pool[i].page_dma,
-				PAGE_SIZE << priv->hw_params.rx_page_order,
-				DMA_FROM_DEVICE);
-			__iwl_free_pages(priv, rxq->pool[i].page);
-			rxq->pool[i].page = NULL;
-		}
-	}
-
-	dma_free_coherent(priv->bus.dev, 4 * RX_QUEUE_SIZE,
-			  rxq->bd, rxq->bd_dma);
-	dma_free_coherent(priv->bus.dev,
-			  sizeof(struct iwl_rb_status),
-			  rxq->rb_stts, rxq->rb_stts_dma);
-	rxq->bd = NULL;
-	rxq->rb_stts  = NULL;
-}
-
 int iwlagn_rxq_stop(struct iwl_priv *priv)
 {
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b065718..f9127e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3718,8 +3718,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 
 	iwl_dealloc_ucode(priv);
 
-	if (priv->rxq.bd)
-		iwlagn_rx_queue_free(priv, &priv->rxq);
+	priv->trans.ops->rx_free(priv);
 	iwlagn_hw_txq_ctx_free(priv);
 
 	iwl_eeprom_free(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 7273297..877a694 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -193,7 +193,6 @@ void iwlagn_rx_queue_restock(struct iwl_priv *priv);
 void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority);
 void iwlagn_rx_replenish(struct iwl_priv *priv);
 void iwlagn_rx_replenish_now(struct iwl_priv *priv);
-void iwlagn_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwlagn_rxq_stop(struct iwl_priv *priv);
 int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
 void iwl_setup_rx_handlers(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7d3e55d..04b19a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1233,9 +1233,11 @@ struct iwl_trans;
  * struct iwl_trans_ops - transport specific operations
 
  * @rx_init: inits the rx memory, allocate it if needed
+ *@rx_free: frees the rx memory
  */
 struct iwl_trans_ops {
 	int (*rx_init)(struct iwl_priv *priv);
+	void (*rx_free)(struct iwl_priv *priv);
 };
 
 struct iwl_trans {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index ccf73ff..1f5834b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -60,7 +60,7 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
- #include "iwl-dev.h"
+#include "iwl-dev.h"
 #include "iwl-trans.h"
 
 static int iwl_trans_rx_alloc(struct iwl_priv *priv)
@@ -78,12 +78,11 @@ static int iwl_trans_rx_alloc(struct iwl_priv *priv)
 		return -EINVAL;
 
 	/* Allocate the circular buffer of Read Buffer Descriptors (RBDs) */
-	/*Every descriptor is an __le32, hence its */
-	rxq->bd = dma_alloc_coherent(dev, 4 * RX_QUEUE_SIZE, &rxq->bd_dma,
-				     GFP_KERNEL);
+	rxq->bd = dma_alloc_coherent(dev, sizeof(__le32) * RX_QUEUE_SIZE,
+				     &rxq->bd_dma, GFP_KERNEL);
 	if (!rxq->bd)
 		goto err_bd;
-	memset(rxq->bd, 0, 4 * RX_QUEUE_SIZE);
+	memset(rxq->bd, 0, sizeof(__le32) * RX_QUEUE_SIZE);
 
 	/*Allocate the driver's pointer to receive buffer status */
 	rxq->rb_stts = dma_alloc_coherent(dev, sizeof(*rxq->rb_stts),
@@ -95,28 +94,18 @@ static int iwl_trans_rx_alloc(struct iwl_priv *priv)
 	return 0;
 
 err_rb_stts:
-	dma_free_coherent(dev, 4 * RX_QUEUE_SIZE, rxq->bd, rxq->bd_dma);
+	dma_free_coherent(dev, sizeof(__le32) * RX_QUEUE_SIZE,
+			rxq->bd, rxq->bd_dma);
 	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
 	rxq->bd = NULL;
 err_bd:
 	return -ENOMEM;
 }
 
-static int iwl_trans_rx_init(struct iwl_priv *priv)
+static void iwl_trans_rxq_free_rx_bufs(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
-	int i, err;
-	unsigned long flags;
-
-	if (!rxq->bd) {
-		err = iwl_trans_rx_alloc(priv);
-		if (err)
-			return err;
-	}
-
-	spin_lock_irqsave(&rxq->lock, flags);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
+	int i;
 
 	/* Fill the rx_used queue with _all_ of the Rx buffers */
 	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
@@ -131,6 +120,25 @@ static int iwl_trans_rx_init(struct iwl_priv *priv)
 		}
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
 	}
+}
+
+static int iwl_trans_rx_init(struct iwl_priv *priv)
+{
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	int i, err;
+	unsigned long flags;
+
+	if (!rxq->bd) {
+		err = iwl_trans_rx_alloc(priv);
+		if (err)
+			return err;
+	}
+
+	spin_lock_irqsave(&rxq->lock, flags);
+	INIT_LIST_HEAD(&rxq->rx_free);
+	INIT_LIST_HEAD(&rxq->rx_used);
+
+	iwl_trans_rxq_free_rx_bufs(priv);
 
 	for (i = 0; i < RX_QUEUE_SIZE; i++)
 		rxq->queue[i] = NULL;
@@ -145,8 +153,40 @@ static int iwl_trans_rx_init(struct iwl_priv *priv)
 	return 0;
 }
 
+static void iwl_trans_rx_free(struct iwl_priv *priv)
+{
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	unsigned long flags;
+
+	/*if rxq->bd is NULL, it means that nothing has been allocated,
+	 * exit now */
+	if (!rxq->bd) {
+		IWL_DEBUG_INFO(priv, "Free NULL rx context\n");
+		return;
+	}
+
+	spin_lock_irqsave(&rxq->lock, flags);
+	iwl_trans_rxq_free_rx_bufs(priv);
+	spin_unlock_irqrestore(&rxq->lock, flags);
+
+	dma_free_coherent(priv->bus.dev, sizeof(__le32) * RX_QUEUE_SIZE,
+			  rxq->bd, rxq->bd_dma);
+	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
+	rxq->bd = NULL;
+
+	if (rxq->rb_stts)
+		dma_free_coherent(priv->bus.dev,
+				  sizeof(struct iwl_rb_status),
+				  rxq->rb_stts, rxq->rb_stts_dma);
+	else
+		IWL_DEBUG_INFO(priv, "Free rxq->rb_stts which is NULL\n");
+	memset(&rxq->rb_stts_dma, 0, sizeof(rxq->rb_stts_dma));
+	rxq->rb_stts = NULL;
+}
+
 static const struct iwl_trans_ops trans_ops = {
 	.rx_init = iwl_trans_rx_init,
+	.rx_free = iwl_trans_rx_free,
 };
 
 void iwl_trans_register(struct iwl_trans *trans)
-- 
1.7.0.4

