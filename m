Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:46619 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZH1Q65 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 12:58:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwl3945: reduce debug noise when default debug flags used
Date: Fri, 28 Aug 2009 09:58:50 -0700
Message-Id: <1251478730-13935-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Significant literature suggests users use debug flags 0x43fff - this causes
the debug flags to be set that causes information to be printed for every
received frame - including beacons. In the best case it fills up the logs,
at worst it slows driver down and causes failures due to timeouts.

In the RX handler, print debugging only if user requested RX debugging.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3479041..2238c9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1373,7 +1373,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 		fill_rx = 1;
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
-		IWL_DEBUG(priv, IWL_DL_RX | IWL_DL_ISR, "r = %d, i = %d\n", r, i);
+		IWL_DEBUG_RX(priv, "r = %d, i = %d\n", r, i);
 
 	while (i != r) {
 		rxb = rxq->queue[i];
@@ -1404,15 +1404,13 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 		 *   handle those that need handling via function in
 		 *   rx_handlers table.  See iwl3945_setup_rx_handlers() */
 		if (priv->rx_handlers[pkt->hdr.cmd]) {
-			IWL_DEBUG(priv, IWL_DL_HCMD | IWL_DL_RX | IWL_DL_ISR,
-				"r = %d, i = %d, %s, 0x%02x\n", r, i,
+			IWL_DEBUG_RX(priv, "r = %d, i = %d, %s, 0x%02x\n", r, i,
 				get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
 			priv->isr_stats.rx_handlers[pkt->hdr.cmd]++;
 		} else {
 			/* No handling needed */
-			IWL_DEBUG(priv, IWL_DL_HCMD | IWL_DL_RX | IWL_DL_ISR,
-				"r %d i %d No handler needed for %s, 0x%02x\n",
+			IWL_DEBUG_RX(priv, "r %d i %d No handler needed for %s, 0x%02x\n",
 				r, i, get_cmd_string(pkt->hdr.cmd),
 				pkt->hdr.cmd);
 		}
-- 
1.5.6.3

