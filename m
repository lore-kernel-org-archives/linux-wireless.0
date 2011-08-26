Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44772 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab1HZGxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 51/60] iwlagn: upper layer uses slabs to allocate tx cmds
Date: Thu, 25 Aug 2011 23:11:23 -0700
Message-Id: <1314339092-20797-52-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085359_741269_7BB36E6F)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In a near future, the upper layer won't be aware of the tx queues.
This allows to remove one place where the upper layer needed to
provide the tx queue index to the transport layer.
This also saves around 1.5MB.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   19 +++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    9 ++++
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    2 +
 drivers/net/wireless/iwlwifi/iwl-trans.c     |   57 +++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   17 +++-----
 6 files changed, 55 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 2b8fb53..bf66575 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -276,6 +276,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_station_priv *sta_priv = NULL;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	struct iwl_device_cmd *dev_cmd = NULL;
 	struct iwl_tx_cmd *tx_cmd;
 	int txq_id;
 
@@ -386,10 +387,14 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		}
 	}
 
-	tx_cmd = iwl_trans_get_tx_cmd(trans(priv), txq_id);
-	if (unlikely(!tx_cmd))
+	dev_cmd = kmem_cache_alloc(priv->tx_cmd_pool, GFP_ATOMIC);
+
+	if (unlikely(!dev_cmd))
 		goto drop_unlock_sta;
 
+	memset(dev_cmd, 0, sizeof(*dev_cmd));
+	tx_cmd = &dev_cmd->cmd.tx;
+
 	/* Copy MAC header from skb into command buffer */
 	memcpy(tx_cmd->hdr, hdr, hdr_len);
 
@@ -409,8 +414,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_update_stats(priv, true, fc, len);
 
 	info->driver_data[0] = ctx;
+	info->driver_data[1] = dev_cmd;
 
-	if (iwl_trans_tx(trans(priv), skb, tx_cmd, txq_id, fc, is_agg))
+	if (iwl_trans_tx(trans(priv), skb, dev_cmd, txq_id, fc, is_agg))
 		goto drop_unlock_sta;
 
 	if (ieee80211_is_data_qos(fc)) {
@@ -436,6 +442,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	return 0;
 
 drop_unlock_sta:
+	if (dev_cmd)
+		kmem_cache_free(priv->tx_cmd_pool, dev_cmd);
 	spin_unlock(&priv->shrd->sta_lock);
 drop_unlock_priv:
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
@@ -1010,6 +1018,8 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 
 			info = IEEE80211_SKB_CB(skb);
 			ctx = info->driver_data[0];
+			kmem_cache_free(priv->tx_cmd_pool,
+					(info->driver_data[1]));
 
 			memset(&info->status, 0, sizeof(info->status));
 
@@ -1184,6 +1194,9 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 						    info);
 		}
 
+		info = IEEE80211_SKB_CB(skb);
+		kmem_cache_free(priv->tx_cmd_pool, (info->driver_data[1]));
+
 		ieee80211_tx_status_irqsafe(priv->hw, skb);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 02b00d1..ddb255a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -351,6 +351,15 @@ static int iwlagn_alive_notify(struct iwl_priv *priv)
 {
 	int ret;
 
+	if (!priv->tx_cmd_pool)
+		priv->tx_cmd_pool =
+			kmem_cache_create("iwlagn_dev_cmd",
+					  sizeof(struct iwl_device_cmd),
+					  sizeof(void *), 0, NULL);
+
+	if (!priv->tx_cmd_pool)
+		return -ENOMEM;
+
 	iwl_trans_tx_start(trans(priv));
 
 	ret = iwlagn_send_wimax_coex(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d3e103c..cfb4a4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3124,6 +3124,8 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 	iwl_calib_free_results(priv);
 	iwl_free_geos(priv);
 	iwl_free_channel_map(priv);
+	if (priv->tx_cmd_pool)
+		kmem_cache_destroy(priv->tx_cmd_pool);
 	kfree(priv->scan_cmd);
 	kfree(priv->beacon_cmd);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5e79c14..977015b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -36,6 +36,7 @@
 #include <linux/kernel.h>
 #include <linux/wait.h>
 #include <linux/leds.h>
+#include <linux/slab.h>
 #include <net/ieee80211_radiotap.h>
 
 #include "iwl-eeprom.h"
@@ -1053,6 +1054,7 @@ struct iwl_priv {
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
 	struct ieee80211_rate *ieee_rates;
+	struct kmem_cache *tx_cmd_pool;
 	struct iwl_cfg *cfg;
 
 	enum ieee80211_band band;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index e545898..7de042c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -317,12 +317,13 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 	if (!txq->meta || !txq->cmd)
 		goto error;
 
-	for (i = 0; i < slots_num; i++) {
-		txq->cmd[i] = kmalloc(sizeof(struct iwl_device_cmd),
-					GFP_KERNEL);
-		if (!txq->cmd[i])
-			goto error;
-	}
+	if (txq_id == trans->shrd->cmd_queue)
+		for (i = 0; i < slots_num; i++) {
+			txq->cmd[i] = kmalloc(sizeof(struct iwl_device_cmd),
+						GFP_KERNEL);
+			if (!txq->cmd[i])
+				goto error;
+		}
 
 	/* Alloc driver data array and TFD circular buffer */
 	/* Driver private data, only for Tx (not command) queues,
@@ -355,7 +356,7 @@ error:
 	txq->skbs = NULL;
 	/* since txq->cmd has been zeroed,
 	 * all non allocated cmd[i] will be NULL */
-	if (txq->cmd)
+	if (txq->cmd && txq_id == trans->shrd->cmd_queue)
 		for (i = 0; i < slots_num; i++)
 			kfree(txq->cmd[i]);
 	kfree(txq->meta);
@@ -442,8 +443,10 @@ static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
 	iwl_tx_queue_unmap(trans, txq_id);
 
 	/* De-alloc array of command/tx buffers */
-	for (i = 0; i < txq->q.n_window; i++)
-		kfree(txq->cmd[i]);
+
+	if (txq_id == trans->shrd->cmd_queue)
+		for (i = 0; i < txq->q.n_window; i++)
+			kfree(txq->cmd[i]);
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd) {
@@ -1009,37 +1012,13 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	iwl_apm_stop(priv(trans));
 }
 
-static struct iwl_tx_cmd *iwl_trans_pcie_get_tx_cmd(struct iwl_trans *trans,
-						int txq_id)
-{
-	struct iwl_priv *priv = priv(trans);
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
-	struct iwl_device_cmd *dev_cmd;
-
-	if (unlikely(iwl_queue_space(q) < q->high_mark))
-		return NULL;
-
-	/*
-	 * Set up the Tx-command (not MAC!) header.
-	 * Store the chosen Tx queue and TFD index within the sequence field;
-	 * after Tx, uCode's Tx response will return this value so driver can
-	 * locate the frame within the tx queue and do post-tx processing.
-	 */
-	dev_cmd = txq->cmd[q->write_ptr];
-	memset(dev_cmd, 0, sizeof(*dev_cmd));
-	dev_cmd->hdr.cmd = REPLY_TX;
-	dev_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
-				INDEX_TO_SEQ(q->write_ptr)));
-	return &dev_cmd->cmd.tx;
-}
-
 static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
-		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu)
+		struct iwl_device_cmd *dev_cmd, int txq_id,
+		__le16 fc, bool ampdu)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
-	struct iwl_device_cmd *dev_cmd = txq->cmd[q->write_ptr];
+	struct iwl_tx_cmd *tx_cmd = &dev_cmd->cmd.tx;
 	struct iwl_cmd_meta *out_meta;
 
 	dma_addr_t phys_addr = 0;
@@ -1051,6 +1030,11 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 
 	/* Set up driver data for this TFD */
 	txq->skbs[q->write_ptr] = skb;
+	txq->cmd[q->write_ptr] = dev_cmd;
+
+	dev_cmd->hdr.cmd = REPLY_TX;
+	dev_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
+				INDEX_TO_SEQ(q->write_ptr)));
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_meta = &txq->meta[q->write_ptr];
@@ -1862,7 +1846,6 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.send_cmd = iwl_trans_pcie_send_cmd,
 	.send_cmd_pdu = iwl_trans_pcie_send_cmd_pdu,
 
-	.get_tx_cmd = iwl_trans_pcie_get_tx_cmd,
 	.tx = iwl_trans_pcie_tx,
 	.reclaim = iwl_trans_pcie_reclaim,
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 011c824..0691d39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -76,6 +76,7 @@ struct iwl_priv;
 struct iwl_rxon_context;
 struct iwl_host_cmd;
 struct iwl_shared;
+struct iwl_device_cmd;
 
 /**
  * struct iwl_trans_ops - transport specific operations
@@ -90,7 +91,6 @@ struct iwl_shared;
  * @stop_device:stops the whole device (embedded CPU put to reset)
  * @send_cmd:send a host command
  * @send_cmd_pdu:send a host command: flags can be CMD_*
- * @get_tx_cmd: returns a pointer to a new Tx cmd for the upper layer use
  * @tx: send an skb
  * @reclaim: free packet until ssn. Returns a list of freed packets.
  * @txq_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
@@ -117,9 +117,9 @@ struct iwl_trans_ops {
 
 	int (*send_cmd_pdu)(struct iwl_trans *trans, u8 id, u32 flags, u16 len,
 		     const void *data);
-	struct iwl_tx_cmd * (*get_tx_cmd)(struct iwl_trans *trans, int txq_id);
 	int (*tx)(struct iwl_priv *priv, struct sk_buff *skb,
-		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu);
+		struct iwl_device_cmd *dev_cmd,
+		int txq_id, __le16 fc, bool ampdu);
 	void (*reclaim)(struct iwl_trans *trans, int txq_id, int ssn,
 			u32 status, struct sk_buff_head *skbs);
 
@@ -190,16 +190,11 @@ static inline int iwl_trans_send_cmd_pdu(struct iwl_trans *trans, u8 id,
 	return trans->ops->send_cmd_pdu(trans, id, flags, len, data);
 }
 
-static inline struct iwl_tx_cmd *iwl_trans_get_tx_cmd(struct iwl_trans *trans,
-					int txq_id)
-{
-	return trans->ops->get_tx_cmd(trans, txq_id);
-}
-
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
-		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu)
+		struct iwl_device_cmd *dev_cmd,
+		int txq_id, __le16 fc, bool ampdu)
 {
-	return trans->ops->tx(priv(trans), skb, tx_cmd, txq_id, fc, ampdu);
+	return trans->ops->tx(priv(trans), skb, dev_cmd, txq_id, fc, ampdu);
 }
 
 static inline void iwl_trans_reclaim(struct iwl_trans *trans, int txq_id,
-- 
1.7.0.4

