Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab0FFG4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 17/23] iwlwifi: reduce memory allocation
Date: Sat,  5 Jun 2010 23:56:32 -0700
Message-Id: <1275807398-18184-18-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, the driver allocates up to 19 skb pointers
for each TFD, of which we have 256 per queue. This
means that for each TX queue, we allocate 19k/38k
(an order 4 or 5 allocation on 32/64 bit respectively)
just for each queue's "txb" array, which contains only
the SKB pointers.

However, due to the way we use these pointers only the
first one can ever be assigned. When the driver was
initially written, the idea was that it could be
passed multiple SKBs for each TFD and attach all
those to implement gather DMA. However, due to
constraints in the userspace API and lack of TCP/IP
level checksumming in the device, this is in fact not
possible. And even if it were, the SKBs would be
chained, and we wouldn't need to keep pointers to
each anyway.

Change this to only keep track of one SKB per TFD,
and thereby reduce memory consumption to just one
pointer per TFD, which is an order 0 allocation per
transmit queue.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   25 +++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   18 +++++++++---------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 +++---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 7 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index fec05b5..658c614 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -279,8 +279,8 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
-		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0]);
-		tx_info->skb[0] = NULL;
+		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb);
+		tx_info->skb = NULL;
 		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
 	}
 
@@ -315,7 +315,7 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
 		return;
 	}
 
-	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb[0]);
+	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb);
 	ieee80211_tx_info_clear_status(info);
 
 	/* Fill the MRR chain with some info about on-chip retransmissions */
@@ -702,19 +702,20 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 
 	/* unmap chunks if any */
 
-	for (i = 1; i < counter; i++) {
+	for (i = 1; i < counter; i++)
 		pci_unmap_single(dev, le32_to_cpu(tfd->tbs[i].addr),
 			 le32_to_cpu(tfd->tbs[i].len), PCI_DMA_TODEVICE);
-		if (txq->txb) {
-			struct sk_buff *skb;
 
-			skb = txq->txb[txq->q.read_ptr].skb[i - 1];
+	/* free SKB */
+	if (txq->txb) {
+		struct sk_buff *skb;
 
-			/* can be called from irqs-disabled context */
-			if (skb) {
-				dev_kfree_skb_any(skb);
-				txq->txb[txq->q.read_ptr].skb[i - 1] = NULL;
-			}
+		skb = txq->txb[txq->q.read_ptr].skb;
+
+		/* can be called from irqs-disabled context */
+		if (skb) {
+			dev_kfree_skb_any(skb);
+			txq->txb[txq->q.read_ptr].skb = NULL;
 		}
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1e4f1bc..a51c4b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1908,7 +1908,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, StartIdx=%d idx=%d\n",
 				   agg->frame_count, agg->start_idx, idx);
 
-		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
+		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb);
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 		info->flags |= iwl_tx_status_to_mac80211(status);
@@ -2074,7 +2074,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		return;
 	}
 
-	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb[0]);
+	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb);
 	memset(&info->status, 0, sizeof(info->status));
 
 	hdr = iwl_tx_queue_get_hdr(priv, txq_id, index);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 848cb3b..5bec72a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -77,7 +77,7 @@ static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 		IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, StartIdx=%d idx=%d\n",
 				   agg->frame_count, agg->start_idx, idx);
 
-		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
+		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb);
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 		info->flags |= iwl_tx_status_to_mac80211(status);
@@ -194,7 +194,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 		return;
 	}
 
-	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb[0]);
+	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb);
 	memset(&info->status, 0, sizeof(info->status));
 
 	tid = (tx_resp->ra_tid & IWL50_TX_RES_TID_MSK) >> IWL50_TX_RES_TID_POS;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index eb0a6da..0037a52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -638,7 +638,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
-	txq->txb[q->write_ptr].skb[0] = skb;
+	txq->txb[q->write_ptr].skb = skb;
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[q->write_ptr];
@@ -1178,12 +1178,12 @@ int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
-		iwlagn_tx_status(priv, tx_info->skb[0]);
+		iwlagn_tx_status(priv, tx_info->skb);
 
-		hdr = (struct ieee80211_hdr *)tx_info->skb[0]->data;
+		hdr = (struct ieee80211_hdr *)tx_info->skb->data;
 		if (hdr && ieee80211_is_data_qos(hdr->frame_control))
 			nfreed++;
-		tx_info->skb[0] = NULL;
+		tx_info->skb = NULL;
 
 		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)
 			priv->cfg->ops->lib->txq_inval_byte_cnt_tbl(priv, txq);
@@ -1247,7 +1247,7 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 			agg->start_idx + i);
 	}
 
-	info = IEEE80211_SKB_CB(priv->txq[scd_flow].txb[agg->start_idx].skb[0]);
+	info = IEEE80211_SKB_CB(priv->txq[scd_flow].txb[agg->start_idx].skb);
 	memset(&info->status, 0, sizeof(info->status));
 	info->flags |= IEEE80211_TX_STAT_ACK;
 	info->flags |= IEEE80211_TX_STAT_AMPDU;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a61d567..a0e995e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -479,20 +479,20 @@ void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 				PCI_DMA_BIDIRECTIONAL);
 
 	/* Unmap chunks, if any. */
-	for (i = 1; i < num_tbs; i++) {
+	for (i = 1; i < num_tbs; i++)
 		pci_unmap_single(dev, iwl_tfd_tb_get_addr(tfd, i),
 				iwl_tfd_tb_get_len(tfd, i), PCI_DMA_TODEVICE);
 
-		if (txq->txb) {
-			struct sk_buff *skb;
+	/* free SKB */
+	if (txq->txb) {
+		struct sk_buff *skb;
 
-			skb = txq->txb[txq->q.read_ptr].skb[i - 1];
+		skb = txq->txb[txq->q.read_ptr].skb;
 
-			/* can be called from irqs-disabled context */
-			if (skb) {
-				dev_kfree_skb_any(skb);
-				txq->txb[txq->q.read_ptr].skb[i - 1] = NULL;
-			}
+		/* can be called from irqs-disabled context */
+		if (skb) {
+			dev_kfree_skb_any(skb);
+			txq->txb[txq->q.read_ptr].skb = NULL;
 		}
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4abc24e..de326a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -142,7 +142,7 @@ struct iwl_queue {
 
 /* One for each TFD */
 struct iwl_tx_info {
-	struct sk_buff *skb[IWL_NUM_OF_TBS - 1];
+	struct sk_buff *skb;
 };
 
 /**
@@ -1425,9 +1425,9 @@ static inline u32 iwl_get_debug_level(struct iwl_priv *priv)
 static inline struct ieee80211_hdr *iwl_tx_queue_get_hdr(struct iwl_priv *priv,
 							 int txq_id, int idx)
 {
-	if (priv->txq[txq_id].txb[idx].skb[0])
+	if (priv->txq[txq_id].txb[idx].skb)
 		return (struct ieee80211_hdr *)priv->txq[txq_id].
-				txb[idx].skb[0]->data;
+				txb[idx].skb->data;
 	return NULL;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index eeeb6e8..c3e9d63 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -538,7 +538,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
-	txq->txb[q->write_ptr].skb[0] = skb;
+	txq->txb[q->write_ptr].skb = skb;
 
 	/* Init first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[idx];
-- 
1.7.0.4

