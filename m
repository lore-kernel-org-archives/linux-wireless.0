Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5408 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758640AbZIQRn5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/13 2.6.32 and w-t] iwlwifi: reduce noise when skb allocation fails
Date: Thu, 17 Sep 2009 10:43:56 -0700
Message-Id: <1253209436-2309-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replenishment of receive buffers is done in the tasklet handling
received frames as well as in a workqueue. When we are in the tasklet
we cannot sleep and thus attempt atomic skb allocations. It is generally
not a big problem if this fails since iwl_rx_allocate is always followed
by a call to iwl_rx_queue_restock which will queue the work to replenish
the buffers at a time when sleeping is allowed.

We thus add the __GFP_NOWARN to the skb allocation in iwl_rx_allocate to
reduce the noise if such an allocation fails while we still have enough
buffers. We do maintain the warning and the error message when we are low
on buffers to communicate to the user that there is a potential problem with
memory availability on system

This addresses issue reported upstream in thread "iwlagn: order 2 page
allocation failures" in
http://thread.gmane.org/gmane.linux.kernel.wireless.general/39187

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   10 +++++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 ++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b90adcb..8e1bb53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -250,12 +250,20 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		}
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
+		if (rxq->free_count > RX_LOW_WATERMARK)
+			priority |= __GFP_NOWARN;
 		/* Alloc a new receive buffer */
 		skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
 						priority);
 
 		if (!skb) {
-			IWL_CRIT(priv, "Can not allocate SKB buffers\n");
+			if (net_ratelimit())
+				IWL_DEBUG_INFO(priv, "Failed to allocate SKB buffer.\n");
+			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
+			    net_ratelimit())
+				IWL_CRIT(priv, "Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
+					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
+					 rxq->free_count);
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3b31bd5..c92db01 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1146,11 +1146,18 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		}
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
+		if (rxq->free_count > RX_LOW_WATERMARK)
+			priority |= __GFP_NOWARN;
 		/* Alloc a new receive buffer */
 		skb = alloc_skb(priv->hw_params.rx_buf_size, priority);
 		if (!skb) {
 			if (net_ratelimit())
-				IWL_CRIT(priv, ": Can not allocate SKB buffers\n");
+				IWL_DEBUG_INFO(priv, "Failed to allocate SKB buffer.\n");
+			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
+			    net_ratelimit())
+				IWL_CRIT(priv, "Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
+					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
+					 rxq->free_count);
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */
-- 
1.5.6.3

