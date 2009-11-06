Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15281 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760095AbZKFWxF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:05 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 18/20] iwlagn: update write pointers in iwl_irq_tasklet()
Date: Fri,  6 Nov 2009 14:53:01 -0800
Message-Id: <1257547983-12590-19-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Follow-up to "update write pointers for all tx queues after wakeup"; that
patch changed iwl_irq_tasklet_legacy(), but not iwl_irq_tasklet(), so
newer devices were not covered.

Comments from original patch:

Wakeup interrupt has been updating write pointers (indexes, actually) only
for tx queues 0-5.  This is adequate just for 3945, but inadequate for other
devices, all of which have more tx queues.  Now updating all tx/command queues,
so device can be aware of all new tx and host commands enqueued while
device was asleep.

This can potentially improve data traffic bandwidth and/or latency.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a1d2cda..4ba4282 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1085,6 +1085,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	u32 inta = 0;
 	u32 handled = 0;
 	unsigned long flags;
+	u32 i;
 #ifdef CONFIG_IWLWIFI_DEBUG
 	u32 inta_mask;
 #endif
@@ -1195,12 +1196,8 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR(priv, "Wakeup interrupt\n");
 		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
-		iwl_txq_update_write_ptr(priv, &priv->txq[0]);
-		iwl_txq_update_write_ptr(priv, &priv->txq[1]);
-		iwl_txq_update_write_ptr(priv, &priv->txq[2]);
-		iwl_txq_update_write_ptr(priv, &priv->txq[3]);
-		iwl_txq_update_write_ptr(priv, &priv->txq[4]);
-		iwl_txq_update_write_ptr(priv, &priv->txq[5]);
+		for (i = 0; i < priv->hw_params.max_txq_num; i++)
+			iwl_txq_update_write_ptr(priv, &priv->txq[i]);
 
 		priv->isr_stats.wakeup++;
 
-- 
1.5.6.3

