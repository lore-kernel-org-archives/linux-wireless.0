Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41449 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab0DBEKq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 00:10:46 -0400
Date: Fri, 2 Apr 2010 13:10:39 +0900
To: yi.zhu@intel.com, reinette.chatre@intel.com, ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: use the dma state API instead of the pci
 equivalents
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20100402131008B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DMA API is preferred.

No functional change.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 3b5889d..0585ffe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -774,8 +774,8 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	/* Unmap tx_cmd */
 	if (counter)
 		pci_unmap_single(dev,
-				pci_unmap_addr(&txq->meta[index], mapping),
-				pci_unmap_len(&txq->meta[index], len),
+				dma_unmap_addr(&txq->meta[index], mapping),
+				dma_unmap_len(&txq->meta[index], len),
 				PCI_DMA_TODEVICE);
 
 	/* unmap chunks if any */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0a376f7..5241692 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -470,8 +470,8 @@ void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	/* Unmap tx_cmd */
 	if (num_tbs)
 		pci_unmap_single(dev,
-				pci_unmap_addr(&txq->meta[index], mapping),
-				pci_unmap_len(&txq->meta[index], len),
+				dma_unmap_addr(&txq->meta[index], mapping),
+				dma_unmap_len(&txq->meta[index], len),
 				PCI_DMA_BIDIRECTIONAL);
 
 	/* Unmap chunks, if any. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e847e61..b9f641b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -170,8 +170,8 @@ struct iwl_cmd_meta {
 	 * structure is stored at the end of the shared queue memory. */
 	u32 flags;
 
-	DECLARE_PCI_UNMAP_ADDR(mapping)
-	DECLARE_PCI_UNMAP_LEN(len)
+	DEFINE_DMA_UNMAP_ADDR(mapping);
+	DEFINE_DMA_UNMAP_LEN(len);
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 1e481f3..0a0274b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -928,8 +928,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txcmd_phys = pci_map_single(priv->pci_dev,
 				    &out_cmd->hdr, len,
 				    PCI_DMA_BIDIRECTIONAL);
-	pci_unmap_addr_set(out_meta, mapping, txcmd_phys);
-	pci_unmap_len_set(out_meta, len, len);
+	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
+	dma_unmap_len_set(out_meta, len, len);
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
 	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
@@ -1129,8 +1129,8 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	phys_addr = pci_map_single(priv->pci_dev, &out_cmd->hdr,
 				   fix_size, PCI_DMA_BIDIRECTIONAL);
-	pci_unmap_addr_set(out_meta, mapping, phys_addr);
-	pci_unmap_len_set(out_meta, len, fix_size);
+	dma_unmap_addr_set(out_meta, mapping, phys_addr);
+	dma_unmap_len_set(out_meta, len, fix_size);
 
 	trace_iwlwifi_dev_hcmd(priv, &out_cmd->hdr, fix_size, cmd->flags);
 
@@ -1270,8 +1270,8 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	meta = &priv->txq[IWL_CMD_QUEUE_NUM].meta[cmd_index];
 
 	pci_unmap_single(priv->pci_dev,
-			 pci_unmap_addr(meta, mapping),
-			 pci_unmap_len(meta, len),
+			 dma_unmap_addr(meta, mapping),
+			 dma_unmap_len(meta, len),
 			 PCI_DMA_BIDIRECTIONAL);
 
 	/* Input error checking is done when commands are added to queue. */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4995134..795ae66 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -630,8 +630,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 				    len, PCI_DMA_TODEVICE);
 	/* we do not map meta data ... so we can safely access address to
 	 * provide to unmap command*/
-	pci_unmap_addr_set(out_meta, mapping, txcmd_phys);
-	pci_unmap_len_set(out_meta, len, len);
+	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
+	dma_unmap_len_set(out_meta, len, len);
 
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
-- 
1.7.0

