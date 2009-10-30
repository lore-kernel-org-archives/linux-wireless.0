Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757447AbZJ3VgP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/15] iwlagn: update write pointers for all tx queues after wakeup
Date: Fri, 30 Oct 2009 14:36:09 -0700
Message-Id: <1256938578-9638-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Wakeup interrupt has been updating write pointers (indexes, actually) only
for tx queues 0-5.  This is adequate just for 3945, but inadequate for other
devices, all of which have more tx queues.  Now updating all tx/command queues,
so device can be aware of all new tx and host commands enqueued while
device was asleep.

This can potentially improve data traffic bandwidth and/or latency.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f36a7d1..3eeffcb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -891,6 +891,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
+	u32 i;
 #ifdef CONFIG_IWLWIFI_DEBUG
 	u32 inta_mask;
 #endif
@@ -1008,19 +1009,17 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
 
-	/* uCode wakes up after power-down sleep */
+	/*
+	 * uCode wakes up after power-down sleep.
+	 * Tell device about any new tx or host commands enqueued,
+	 * and about any Rx buffers made available while asleep.
+	 */
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR(priv, "Wakeup interrupt\n");
 		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
-		iwl_txq_update_write_ptr(priv, &priv->txq[0]);
-		iwl_txq_update_write_ptr(priv, &priv->txq[1]);
-		iwl_txq_update_write_ptr(priv, &priv->txq[2]);
-		iwl_txq_update_write_ptr(priv, &priv->txq[3]);
-		iwl_txq_update_write_ptr(priv, &priv->txq[4]);
-		iwl_txq_update_write_ptr(priv, &priv->txq[5]);
-
+		for (i = 0; i < priv->hw_params.max_txq_num; i++)
+			iwl_txq_update_write_ptr(priv, &priv->txq[i]);
 		priv->isr_stats.wakeup++;
-
 		handled |= CSR_INT_BIT_WAKEUP;
 	}
 
-- 
1.5.6.3

