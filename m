Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763498AbXHHHhq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:46 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 18/28] iwlwifi: shorten more function names
Date: Wed,  8 Aug 2007 15:33:35 +0800
Message-Id: <11865584683474-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584661209-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
 <11865584631842-git-send-email-yi.zhu@intel.com>
 <11865584661209-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c |    8 ++++----
 drivers/net/wireless/iwl-4965.c |    8 ++++----
 drivers/net/wireless/iwl-base.c |   10 +++++-----
 drivers/net/wireless/iwlwifi.h  |    9 +++------
 4 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index a9a1921..ce9688c 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -490,8 +490,8 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 	}
 }
 
-int iwl_hw_tx_queue_attach_buffer_to_tfd(struct iwl_priv *priv,
-					 void *ptr, dma_addr_t addr, u16 len)
+int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
+				 dma_addr_t addr, u16 len)
 {
 	int count;
 	u32 pad;
@@ -518,11 +518,11 @@ int iwl_hw_tx_queue_attach_buffer_to_tfd(struct iwl_priv *priv,
 }
 
 /**
- * iwl_hw_tx_queue_free_tfd - Free one TFD, those at index [txq->q.last_used]
+ * iwl_hw_txq_free_tfd - Free one TFD, those at index [txq->q.last_used]
  *
  * Does NOT advance any indexes
  */
-int iwl_hw_tx_queue_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	struct iwl_tfd_frame *bd_tmp = (struct iwl_tfd_frame *)&txq->bd[0];
 	struct iwl_tfd_frame *bd = &bd_tmp[txq->q.last_used];
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index a3e6603..de5b541 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -1762,11 +1762,11 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
 }
 
 /**
- * iwl_hw_tx_queue_free_tfd -  Free one TFD, those at index [txq->q.last_used]
+ * iwl_hw_txq_free_tfd -  Free one TFD, those at index [txq->q.last_used]
  *
  * Does NOT advance any indexes
  */
-int iwl_hw_tx_queue_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	struct iwl_tfd_frame *bd_tmp = (struct iwl_tfd_frame *)&txq->bd[0];
 	struct iwl_tfd_frame *bd = &bd_tmp[txq->q.last_used];
@@ -2754,8 +2754,8 @@ static inline u8 iwl4965_get_dma_hi_address(dma_addr_t addr)
 	return sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0;
 }
 
-int iwl_hw_tx_queue_attach_buffer_to_tfd(struct iwl_priv *priv,
-					 void *ptr, dma_addr_t addr, u16 len)
+int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
+				 dma_addr_t addr, u16 len)
 {
 	int index, is_odd;
 	struct iwl_tfd_frame *tfd = ptr;
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 3b08c7c..94d5ac8 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -308,7 +308,7 @@ void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	/* first, empty all BD's */
 	for (; q->first_empty != q->last_used;
 	     q->last_used = iwl_queue_inc_wrap(q->last_used, q->n_bd))
-		iwl_hw_tx_queue_free_tfd(priv, txq);
+		iwl_hw_txq_free_tfd(priv, txq);
 
 	len = sizeof(struct iwl_cmd) * q->n_window;
 	if (q->id == IWL_CMD_QUEUE_NUM);
@@ -622,7 +622,7 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	phys_addr = txq->dma_addr_cmd + sizeof(txq->cmd[0]) * idx +
 	    offsetof(struct iwl_cmd, hdr);
-	iwl_hw_tx_queue_attach_buffer_to_tfd(priv, tfd, phys_addr, fix_size);
+	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
 
 #if IWL == 3945
 	pad = U32_PAD(out_cmd->meta.len);
@@ -2913,7 +2913,7 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl_cmd) * idx +
 		     offsetof(struct iwl_cmd, hdr);
 
-	iwl_hw_tx_queue_attach_buffer_to_tfd(priv, tfd, txcmd_phys, len);
+	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
 
 	if (ctl->key_idx != -1)
 		iwl_build_tx_cmd_hwcrypto(priv, ctl, out_cmd, skb, 0);
@@ -2923,7 +2923,7 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 	if (len) {
 		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
 					   len, PCI_DMA_TODEVICE);
-		iwl_hw_tx_queue_attach_buffer_to_tfd(priv, tfd, phys_addr, len);
+		iwl_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
 	}
 
 #if IWL == 3945
@@ -3477,7 +3477,7 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 		if (txq_id != IWL_CMD_QUEUE_NUM) {
 			iwl_txstatus_to_ieee(priv,
 					     &(txq->txb[txq->q.last_used]));
-			iwl_hw_tx_queue_free_tfd(priv, txq);
+			iwl_hw_txq_free_tfd(priv, txq);
 		} else
 			is_next = 1;
 	}
diff --git a/drivers/net/wireless/iwlwifi.h b/drivers/net/wireless/iwlwifi.h
index 029b590..5b826bf 100644
--- a/drivers/net/wireless/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi.h
@@ -683,13 +683,10 @@ extern int iwl_hw_nic_stop_master(struct iwl_priv *priv);
 extern void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
 extern void iwl_hw_txq_ctx_stop(struct iwl_priv *priv);
 extern int iwl_hw_nic_reset(struct iwl_priv *priv);
-extern int iwl_hw_tx_queue_attach_buffer_to_tfd(
-	struct iwl_priv *priv, void *tfd, dma_addr_t addr, u16 len);
-extern int iwl_hw_tx_queue_free_tfd(struct iwl_priv *priv,
-				    struct iwl_tx_queue *txq);
+extern int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
+					dma_addr_t addr, u16 len);
+extern int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 extern int iwl_hw_get_temperature(struct iwl_priv *priv);
-extern int iwl_tx_queue_free_tfd(struct iwl_priv *priv,
-				 struct iwl_tx_queue *txq);
 extern int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 				struct iwl_tx_queue *txq);
 extern unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
-- 
1.5.2
