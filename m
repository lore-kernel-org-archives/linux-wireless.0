Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449AbZJ3VgQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/15] iwlwifi: unmap memory before use
Date: Fri, 30 Oct 2009 14:36:10 -0700
Message-Id: <1256938578-9638-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Handling responses to driver originated commands include passing the
original command buffer to the caller. At this time it is possible for a
callback to be invoked that is passed this command buffer and thus likely
to access it.

We need to make sure that the memory associated with that buffer is not DMA
mapped at the time.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 2afa003..1868093 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1122,11 +1122,6 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id,
 		return;
 	}
 
-	pci_unmap_single(priv->pci_dev,
-		pci_unmap_addr(&txq->meta[cmd_idx], mapping),
-		pci_unmap_len(&txq->meta[cmd_idx], len),
-		PCI_DMA_BIDIRECTIONAL);
-
 	for (idx = iwl_queue_inc_wrap(idx, q->n_bd); q->read_ptr != idx;
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
@@ -1174,6 +1169,11 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
 	meta = &priv->txq[IWL_CMD_QUEUE_NUM].meta[cmd_index];
 
+	pci_unmap_single(priv->pci_dev,
+			 pci_unmap_addr(meta, mapping),
+			 pci_unmap_len(meta, len),
+			 PCI_DMA_BIDIRECTIONAL);
+
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
 		meta->source->reply_page = (unsigned long)rxb_addr(rxb);
-- 
1.5.6.3

