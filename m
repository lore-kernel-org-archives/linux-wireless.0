Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:58708 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab0FCFTn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 01:19:43 -0400
Date: Thu, 3 Jun 2010 14:19:20 +0900
To: yi.zhu@intel.com, reinette.chatre@intel.com, ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: [PATCH] iwlwifi: use the DMA state API instead of the pci
 equivalents
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20100603141853Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be cleanly applied to wireless-2.6 and iwlwifi git trees.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] iwlwifi: use the DMA state API instead of the pci equivalents

This replace the PCI DMA state API (include/linux/pci-dma.h) with the
DMA equivalents since the PCI DMA state API will be obsolete.

No functional change.

For further information about the background:

http://marc.info/?l=linux-netdev&m=127037540020276&w=2

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 253d032..0fa1d51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -696,8 +696,8 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	/* Unmap tx_cmd */
 	if (counter)
 		pci_unmap_single(dev,
-				pci_unmap_addr(&txq->meta[index], mapping),
-				pci_unmap_len(&txq->meta[index], len),
+				dma_unmap_addr(&txq->meta[index], mapping),
+				dma_unmap_len(&txq->meta[index], len),
 				PCI_DMA_TODEVICE);
 
 	/* unmap chunks if any */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 7e68517..fa82f86 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -705,8 +705,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ef05f63..776ef2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -475,8 +475,8 @@ void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
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
index 401ce2e..57cddab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -114,8 +114,8 @@ struct iwl_cmd_meta {
 	 * structure is stored at the end of the shared queue memory. */
 	u32 flags;
 
-	DECLARE_PCI_UNMAP_ADDR(mapping)
-	DECLARE_PCI_UNMAP_LEN(len)
+	DEFINE_DMA_UNMAP_ADDR(mapping);
+	DEFINE_DMA_UNMAP_LEN(len);
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 788dcf1..a81989c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -154,15 +154,15 @@ void iwl_cmd_queue_free(struct iwl_priv *priv)
 		}
 
 		pci_unmap_single(priv->pci_dev,
-				 pci_unmap_addr(&txq->meta[i], mapping),
-				 pci_unmap_len(&txq->meta[i], len),
+				 dma_unmap_addr(&txq->meta[i], mapping),
+				 dma_unmap_len(&txq->meta[i], len),
 				 PCI_DMA_BIDIRECTIONAL);
 	}
 	if (huge) {
 		i = q->n_window;
 		pci_unmap_single(priv->pci_dev,
-				 pci_unmap_addr(&txq->meta[i], mapping),
-				 pci_unmap_len(&txq->meta[i], len),
+				 dma_unmap_addr(&txq->meta[i], mapping),
+				 dma_unmap_len(&txq->meta[i], len),
 				 PCI_DMA_BIDIRECTIONAL);
 	}
 
@@ -516,8 +516,8 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	phys_addr = pci_map_single(priv->pci_dev, &out_cmd->hdr,
 				   fix_size, PCI_DMA_BIDIRECTIONAL);
-	pci_unmap_addr_set(out_meta, mapping, phys_addr);
-	pci_unmap_len_set(out_meta, len, fix_size);
+	dma_unmap_addr_set(out_meta, mapping, phys_addr);
+	dma_unmap_len_set(out_meta, len, fix_size);
 
 	trace_iwlwifi_dev_hcmd(priv, &out_cmd->hdr, fix_size, cmd->flags);
 
@@ -611,8 +611,8 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	meta = &txq->meta[cmd_index];
 
 	pci_unmap_single(priv->pci_dev,
-			 pci_unmap_addr(meta, mapping),
-			 pci_unmap_len(meta, len),
+			 dma_unmap_addr(meta, mapping),
+			 dma_unmap_len(meta, len),
 			 PCI_DMA_BIDIRECTIONAL);
 
 	/* Input error checking is done when commands are added to queue. */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a527895..a1bac61 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -619,8 +619,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
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
1.6.5

