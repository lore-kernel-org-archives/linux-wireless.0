Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15916 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbZFCShR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 14:37:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/6] iwl3945: port allow skb allocation in tasklet patch
Date: Wed,  3 Jun 2009 11:44:08 -0700
Message-Id: <1244054652-19451-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244054652-19451-2-git-send-email-reinette.chatre@intel.com>
References: <1244054652-19451-1-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Port "iwlcore: Allow skb allocation from tasklet" to 3945

commit c8881170b7ce9897a7b9087d37ca3f281b347707
Author: Mohamed Abbas <mohamed.abbas@intel.com>
Date:   Fri May 22 11:01:51 2009 -0700

    iwlcore: Allow skb allocation from tasklet.

If RX queue becomes empty then we need to restock the queue from tasklet to prevent
ucode from starving. A caller to iwl_rx_allocate will decide if allocated buffer should
come from GFP_ATOMIC or GFP_KERNEL.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   32 +++++++++++++++++++++------
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 745eaae..92fa1a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1176,7 +1176,7 @@ static int iwl3945_rx_queue_restock(struct iwl_priv *priv)
 
 	/* If we've added more space for the firmware to place data, tell it.
 	 * Increment device's write pointer in multiples of 8. */
-	if ((write != (rxq->write & ~0x7))
+	if ((rxq->write_actual != (rxq->write & ~0x7))
 	    || (abs(rxq->write - rxq->read) > 7)) {
 		spin_lock_irqsave(&rxq->lock, flags);
 		rxq->need_update = 1;
@@ -1197,7 +1197,7 @@ static int iwl3945_rx_queue_restock(struct iwl_priv *priv)
  * Also restock the Rx queue via iwl3945_rx_queue_restock.
  * This is called as a scheduled work item (except for during initialization)
  */
-static void iwl3945_rx_allocate(struct iwl_priv *priv)
+static void iwl3945_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
@@ -1220,7 +1220,7 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv)
 		/* Alloc a new receive buffer */
 		rxb->skb =
 		    alloc_skb(priv->hw_params.rx_buf_size,
-				GFP_KERNEL);
+				priority);
 		if (!rxb->skb) {
 			if (net_ratelimit())
 				IWL_CRIT(priv, ": Can not allocate SKB buffers\n");
@@ -1279,6 +1279,7 @@ void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	 * not restocked the Rx queue with fresh buffers */
 	rxq->read = rxq->write = 0;
 	rxq->free_count = 0;
+	rxq->write_actual = 0;
 	spin_unlock_irqrestore(&rxq->lock, flags);
 }
 
@@ -1287,13 +1288,21 @@ void iwl3945_rx_replenish(void *data)
 	struct iwl_priv *priv = data;
 	unsigned long flags;
 
-	iwl3945_rx_allocate(priv);
+	iwl3945_rx_allocate(priv, GFP_KERNEL);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl3945_rx_queue_restock(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
+static void iwl3945_rx_replenish_now(struct iwl_priv *priv)
+{
+	iwl3945_rx_allocate(priv, GFP_ATOMIC);
+
+	iwl3945_rx_queue_restock(priv);
+}
+
+
 /* Assumes that the skb field of the buffers in 'pool' is kept accurate.
  * If an SKB has been detached, the POOL needs to have its SKB set to NULL
  * This free routine walks the list of POOL entries and if SKB is set to
@@ -1416,13 +1425,19 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 	unsigned long flags;
 	u8 fill_rx = 0;
 	u32 count = 8;
+	int total_empty = 0;
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
 	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
 	i = rxq->read;
 
-	if (iwl_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
+	/* calculate total frames need to be restock after handling RX */
+	total_empty = r - priv->rxq.write_actual;
+	if (total_empty < 0)
+		total_empty += RX_QUEUE_SIZE;
+
+	if (total_empty > (RX_QUEUE_SIZE / 2))
 		fill_rx = 1;
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
@@ -1499,7 +1514,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 			count++;
 			if (count >= 8) {
 				priv->rxq.read = i;
-				iwl3945_rx_queue_restock(priv);
+				iwl3945_rx_replenish_now(priv);
 				count = 0;
 			}
 		}
@@ -1507,7 +1522,10 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 
 	/* Backtrack one entry */
 	priv->rxq.read = i;
-	iwl3945_rx_queue_restock(priv);
+	if (fill_rx)
+		iwl3945_rx_replenish_now(priv);
+	else
+		iwl3945_rx_queue_restock(priv);
 }
 
 /* call this function to flush any scheduled tasklet */
-- 
1.5.6.3

