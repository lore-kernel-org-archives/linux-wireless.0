Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934209Ab1IOTcD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:03 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/27] iwlagn: unmap cmd queue's tfds as BIDI
Date: Thu, 15 Sep 2011 11:46:29 -0700
Message-Id: <1316112414-6341-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213208_620279_A184334E)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

If the driver is unloaded while there is still a host command in
flight, its tfd will be freed by iwl_tx_queue_free.
This function is called for both types of queues: Tx queues and cmd
queue. This didn't take in count the fact that in Tx queues, tfds are
mapped as TO_DEVICE (besides the first TB), whereas in cmd queue, all
TBs are mapped as BIDI.

Hence, tx_queue_free unmapped the second (and higher) TB of each tfd
in the cmd queue as TO_DEVICE, whereas they must be freed as BIDI.
This means that if a multi TFD is in flight while we unload the
driver (which is quite unlikely but can happen), we will get the
warning below.

This patch fixes this.

[  445.234060] ------------[ cut here ]------------
[  445.236273] WARNING: at lib/dma-debug.c:861 check_unmap+0x337/0x780()
[  445.236654] iwlagn 0000:02:00.0: DMA-API: device driver frees DMA memory with different direction [device address=0x0000000126950540] [size=8 bytes] [mapped with DMA_BIDIRECTIONAL] [unmapped with DMA_TO_DEVICE]
[  445.236654] Modules linked in: ...
[  445.236654] Pid: 1415, comm: modprobe Not tainted 3.1.0-rc4-wl-65912-g5215ff1-dirty #79
[  445.236654] Call Trace:
[  445.236654]  [<ffffffff81043a51>] warn_slowpath_common+0x71/0xa0
[  445.236654]  [<ffffffff81043b37>] warn_slowpath_fmt+0x47/0x50
[  445.236654]  [<ffffffff8121e687>] check_unmap+0x337/0x780
[  445.236654]  [<ffffffff810e9136>] ? free_one_page+0x156/0x320
[  445.236654]  [<ffffffff8121ec5a>] debug_dma_unmap_page+0x5a/0x60
[  445.236654]  [<ffffffffa021d701>] iwlagn_unmap_tfd.isra.11+0x121/0x1c0 [iwlagn]
[  445.236654]  [<ffffffffa021ddf2>] iwlagn_txq_free_tfd+0x42/0x70 [iwlagn]
[  445.236654]  [<ffffffffa02121de>] iwl_tx_queue_unmap+0x4e/0x70 [iwlagn]
[  445.236654]  [<ffffffffa0212fad>] iwl_trans_pcie_tx_free+0x10d/0x440 [iwlagn]
[  445.236654]  [<ffffffff81064959>] ? destroy_workqueue+0xb9/0x1e0
[  445.236654]  [<ffffffffa021330a>] iwl_trans_pcie_free+0x2a/0x2c0 [iwlagn]
[  445.236654]  [<ffffffffa022f4f2>] iwl_remove+0x149/0x17e [iwlagn]
[  445.236654]  [<ffffffffa022f546>] iwl_pci_remove+0x1f/0x65 [iwlagn]
[  445.236654]  [<ffffffff81228337>] pci_device_remove+0x47/0x120
[  445.236654]  [<ffffffff8134566c>] __device_release_driver+0x7c/0xe0
[  445.236654]  [<ffffffff81345dc8>] driver_detach+0xc8/0xd0
[  445.236654]  [<ffffffff813454c8>] bus_remove_driver+0x88/0xe0
[  445.236654]  [<ffffffff81346572>] driver_unregister+0x62/0xa0
[  445.236654]  [<ffffffff812271d4>] pci_unregister_driver+0x44/0xc0
[  445.236654]  [<ffffffffa0211ce5>] iwl_pci_unregister_driver+0x15/0x20 [iwlagn]
[  445.236654]  [<ffffffffa022f595>] iwl_exit+0x9/0xa74 [iwlagn]
[  445.236654]  [<ffffffff810918f4>] sys_delete_module+0x184/0x240
[  445.236654]  [<ffffffff81452ece>] ? retint_swapgs+0xe/0x13
[  445.236654]  [<ffffffff8121098e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  445.236654]  [<ffffffff81459e2b>] system_call_fastpath+0x16/0x1b
[  445.236654] ---[ end trace 1fbc362b7dbe5d74 ]---
[  445.236654] Mapped at:
[  445.236654]  [<ffffffff8121d7cb>] debug_dma_map_page+0x8b/0x150
[  445.236654]  [<ffffffffa021e7b7>] iwl_enqueue_hcmd+0x837/0xa40 [iwlagn]
[  445.236654]  [<ffffffffa021f92d>] iwl_trans_pcie_send_cmd+0x8d/0x580 [iwlagn]
[  445.236654]  [<ffffffffa01f7c75>] iwl_send_calib_results+0x75/0xd0 [iwlagn]
[  445.236654]  [<ffffffffa01f21f6>] iwlagn_alive_notify+0x196/0x1f0 [iwlagn]
[  445.386500] iwlagn 0000:02:00.0: PCI INT A disabled

Reported-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   12 ++++++++----
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   12 +++++++++++-
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index 8047e95..fc33754 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -307,7 +307,7 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 				 enum iwl_rxon_context_id ctx,
 				 int sta_id, int tid, int frame_limit);
 void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
-	int index);
+	int index, enum dma_data_direction dma_dir);
 int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 			 struct sk_buff_head *skbs);
 int iwl_queue_space(const struct iwl_queue *q);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index ca686db..c7ddb22 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -207,17 +207,17 @@ static void iwlagn_unmap_tfd(struct iwl_trans *trans, struct iwl_cmd_meta *meta,
  * @trans - transport private data
  * @txq - tx queue
  * @index - the index of the TFD to be freed
+ *@dma_dir - the direction of the DMA mapping
  *
  * Does NOT advance any TFD circular buffer read/write indexes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
 void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
-	int index)
+	int index, enum dma_data_direction dma_dir)
 {
 	struct iwl_tfd *tfd_tmp = txq->tfds;
 
-	iwlagn_unmap_tfd(trans, &txq->meta[index], &tfd_tmp[index],
-			 DMA_TO_DEVICE);
+	iwlagn_unmap_tfd(trans, &txq->meta[index], &tfd_tmp[index], dma_dir);
 
 	/* free SKB */
 	if (txq->skbs) {
@@ -1119,6 +1119,10 @@ int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 	int last_to_free;
 	int freed = 0;
 
+	/* This function is not meant to release cmd queue*/
+	if (WARN_ON(txq_id == trans->shrd->cmd_queue))
+		return 0;
+
 	/*Since we free until index _not_ inclusive, the one before index is
 	 * the last we will free. This one must be used */
 	last_to_free = iwl_queue_dec_wrap(index, q->n_bd);
@@ -1151,7 +1155,7 @@ int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 
 		iwlagn_txq_inval_byte_cnt_tbl(trans, txq);
 
-		iwlagn_txq_free_tfd(trans, txq, txq->q.read_ptr);
+		iwlagn_txq_free_tfd(trans, txq, txq->q.read_ptr, DMA_TO_DEVICE);
 		freed++;
 	}
 	return freed;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index b2e8907..228c861 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -411,13 +411,23 @@ static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
+	enum dma_data_direction dma_dir;
 
 	if (!q->n_bd)
 		return;
 
+	/* In the command queue, all the TBs are mapped as BIDI
+	 * so unmap them as such.
+	 */
+	if (txq_id == trans->shrd->cmd_queue)
+		dma_dir = DMA_BIDIRECTIONAL;
+	else
+		dma_dir = DMA_TO_DEVICE;
+
 	while (q->write_ptr != q->read_ptr) {
 		/* The read_ptr needs to bound by q->n_window */
-		iwlagn_txq_free_tfd(trans, txq, get_cmd_index(q, q->read_ptr));
+		iwlagn_txq_free_tfd(trans, txq, get_cmd_index(q, q->read_ptr),
+				    dma_dir);
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 }
-- 
1.7.0.4

