Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab2EJQGD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 12:06:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/4] iwlwifi: fix the Transmit Frame Descriptor rings
Date: Thu, 10 May 2012 18:05:50 +0200
Message-Id: <1336665952-24363-3-git-send-email-johannes@sipsolutions.net> (sfid-20120510_180611_132018_BA1732AA)
In-Reply-To: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The logic that allows to have a short TFD queue was completely wrong.
We do maintain 256 Transmit Frame Descriptors, but they point to
recycled buffers. We used to attach and de-attach different TFDs for
the same buffer and it worked since they pointed to the same buffer.

Also zero the number of BDs after unmapping a TFD. This seems not
necessary since we don't reclaim the same TFD twice, but I like
housekeeping.

This patch solves this warning:

[ 6427.079855] WARNING: at lib/dma-debug.c:866 check_unmap+0x727/0x7a0()
[ 6427.079859] Hardware name: Latitude E6410
[ 6427.079865] iwlwifi 0000:02:00.0: DMA-API: device driver tries to free DMA memory it has not allocated [device address=0x00000000296d393c] [size=8 bytes]
[ 6427.079870] Modules linked in: ...
[ 6427.079950] Pid: 6613, comm: ifconfig Tainted: G           O 3.3.3 #5
[ 6427.079954] Call Trace:
[ 6427.079963]  [<c10337a2>] warn_slowpath_common+0x72/0xa0
[ 6427.079982]  [<c1033873>] warn_slowpath_fmt+0x33/0x40
[ 6427.079988]  [<c12dcb77>] check_unmap+0x727/0x7a0
[ 6427.079995]  [<c12dcdaa>] debug_dma_unmap_page+0x5a/0x80
[ 6427.080024]  [<fe2312ac>] iwlagn_unmap_tfd+0x12c/0x180 [iwlwifi]
[ 6427.080048]  [<fe231349>] iwlagn_txq_free_tfd+0x49/0xb0 [iwlwifi]
[ 6427.080071]  [<fe228e37>] iwl_tx_queue_unmap+0x67/0x90 [iwlwifi]
[ 6427.080095]  [<fe22d221>] iwl_trans_pcie_stop_device+0x341/0x7b0 [iwlwifi]
[ 6427.080113]  [<fe204b0e>] iwl_down+0x17e/0x260 [iwlwifi]
[ 6427.080132]  [<fe20efec>] iwlagn_mac_stop+0x6c/0xf0 [iwlwifi]
[ 6427.080168]  [<fd8480ce>] ieee80211_stop_device+0x5e/0x190 [mac80211]
[ 6427.080198]  [<fd833208>] ieee80211_do_stop+0x288/0x620 [mac80211]
[ 6427.080243]  [<fd8335b7>] ieee80211_stop+0x17/0x20 [mac80211]
[ 6427.080250]  [<c148dac1>] __dev_close_many+0x81/0xd0
[ 6427.080270]  [<c148db3d>] __dev_close+0x2d/0x50
[ 6427.080276]  [<c148d152>] __dev_change_flags+0x82/0x150
[ 6427.080282]  [<c148e3e3>] dev_change_flags+0x23/0x60
[ 6427.080289]  [<c14f6320>] devinet_ioctl+0x6a0/0x770
[ 6427.080296]  [<c14f8705>] inet_ioctl+0x95/0xb0
[ 6427.080304]  [<c147a0f0>] sock_ioctl+0x70/0x270

Cc: stable@vger.kernel.org
Reported-by: Antonio Quartulli <ordex@autistici.org>
Tested-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   22 +++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    4 +---
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 6213c05..e959207 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -347,7 +347,7 @@ void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans, int queue, int fifo,
 				 int sta_id, int tid, int frame_limit, u16 ssn);
 void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
-	int index, enum dma_data_direction dma_dir);
+			 enum dma_data_direction dma_dir);
 int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 			 struct sk_buff_head *skbs);
 int iwl_queue_space(const struct iwl_queue *q);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 21a8a67..a875023 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -204,33 +204,39 @@ static void iwlagn_unmap_tfd(struct iwl_trans *trans, struct iwl_cmd_meta *meta,
 	for (i = 1; i < num_tbs; i++)
 		dma_unmap_single(trans->dev, iwl_tfd_tb_get_addr(tfd, i),
 				iwl_tfd_tb_get_len(tfd, i), dma_dir);
+
+	tfd->num_tbs = 0;
 }
 
 /**
  * iwlagn_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
  * @trans - transport private data
  * @txq - tx queue
- * @index - the index of the TFD to be freed
- *@dma_dir - the direction of the DMA mapping
+ * @dma_dir - the direction of the DMA mapping
  *
  * Does NOT advance any TFD circular buffer read/write indexes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
 void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
-	int index, enum dma_data_direction dma_dir)
+			 enum dma_data_direction dma_dir)
 {
 	struct iwl_tfd *tfd_tmp = txq->tfds;
 
+	/* rd_ptr is bounded by n_bd and idx is bounded by n_window */
+	int rd_ptr = txq->q.read_ptr;
+	int idx = get_cmd_index(&txq->q, rd_ptr);
+
 	lockdep_assert_held(&txq->lock);
 
-	iwlagn_unmap_tfd(trans, &txq->entries[index].meta,
-			 &tfd_tmp[index], dma_dir);
+	/* We have only q->n_window txq->entries, but we use q->n_bd tfds */
+	iwlagn_unmap_tfd(trans, &txq->entries[idx].meta,
+			 &tfd_tmp[rd_ptr], dma_dir);
 
 	/* free SKB */
 	if (txq->entries) {
 		struct sk_buff *skb;
 
-		skb = txq->entries[index].skb;
+		skb = txq->entries[idx].skb;
 
 		/* Can be called from irqs-disabled context
 		 * If skb is not NULL, it means that the whole queue is being
@@ -238,7 +244,7 @@ void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 		 */
 		if (skb) {
 			iwl_op_mode_free_skb(trans->op_mode, skb);
-			txq->entries[index].skb = NULL;
+			txq->entries[idx].skb = NULL;
 		}
 	}
 }
@@ -973,7 +979,7 @@ int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 
 		iwlagn_txq_inval_byte_cnt_tbl(trans, txq);
 
-		iwlagn_txq_free_tfd(trans, txq, txq->q.read_ptr, DMA_TO_DEVICE);
+		iwlagn_txq_free_tfd(trans, txq, DMA_TO_DEVICE);
 		freed++;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index b2f27ec..3cdc014 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -435,9 +435,7 @@ static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 
 	spin_lock_bh(&txq->lock);
 	while (q->write_ptr != q->read_ptr) {
-		/* The read_ptr needs to bound by q->n_window */
-		iwlagn_txq_free_tfd(trans, txq, get_cmd_index(q, q->read_ptr),
-				    dma_dir);
+		iwlagn_txq_free_tfd(trans, txq, dma_dir);
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 	spin_unlock_bh(&txq->lock);
-- 
1.7.10

