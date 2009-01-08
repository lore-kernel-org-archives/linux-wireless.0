Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbZAHSSX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:18:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 03/11] iwl3945: kill iwl3945_rx_queue_space
Date: Thu,  8 Jan 2009 10:19:54 -0800
Message-Id: <1231438802-10991-4-git-send-email-reinette.chatre@intel.com> (sfid-20090108_191840_586766_F4D95E4E)
In-Reply-To: <1231438802-10991-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1231438802-10991-1-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-2-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch replaces iwl3945_rx_queue_space with iwl_rx_queue_space.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c39b6d3..611c35e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3210,21 +3210,6 @@ static void iwl3945_tx_cmd_complete(struct iwl_priv *priv,
  */
 
 /**
- * iwl3945_rx_queue_space - Return number of free slots available in queue.
- */
-static int iwl3945_rx_queue_space(const struct iwl_rx_queue *q)
-{
-	int s = q->read - q->write;
-	if (s <= 0)
-		s += RX_QUEUE_SIZE;
-	/* keep some buffer to not confuse full and empty queue */
-	s -= 2;
-	if (s < 0)
-		s = 0;
-	return s;
-}
-
-/**
  * iwl3945_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
  */
 static inline __le32 iwl3945_dma_addr2rbd_ptr(struct iwl_priv *priv,
@@ -3254,7 +3239,7 @@ static int iwl3945_rx_queue_restock(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&rxq->lock, flags);
 	write = rxq->write & ~0x7;
-	while ((iwl3945_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
+	while ((iwl_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
 		/* Get next free Rx buffer, remove from free list */
 		element = rxq->rx_free.next;
 		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
@@ -3465,7 +3450,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
 	i = rxq->read;
 
-	if (iwl3945_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
+	if (iwl_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
 		fill_rx = 1;
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
-- 
1.5.4.3

