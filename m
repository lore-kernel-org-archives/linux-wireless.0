Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:35769 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759212Ab2AFWTq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 17:19:46 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/7] iwlwifi: don't process the info from uCode if does not has ownership
Date: Fri,  6 Jan 2012 13:16:27 -0800
Message-Id: <1325884593-31298-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120106_232021_308930_2C565F8F)
In-Reply-To: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When enable the testmode from user space and working with uCode, driver does
not own the uCode and should not process the notifications or pkts from uCode

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index b22b297..eda95ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1172,20 +1172,22 @@ int iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 		wake_up_all(&priv->shrd->notif_waitq);
 	}
 
-	if (priv->pre_rx_handler)
+	if (priv->pre_rx_handler &&
+	    priv->shrd->ucode_owner == IWL_OWNERSHIP_TM)
 		priv->pre_rx_handler(priv, rxb);
-
-	/* Based on type of command response or notification,
-	 *   handle those that need handling via function in
-	 *   rx_handlers table.  See iwl_setup_rx_handlers() */
-	if (priv->rx_handlers[pkt->hdr.cmd]) {
-		priv->rx_handlers_stats[pkt->hdr.cmd]++;
-		err = priv->rx_handlers[pkt->hdr.cmd] (priv, rxb, cmd);
-	} else {
-		/* No handling needed */
-		IWL_DEBUG_RX(priv,
-			"No handler needed for %s, 0x%02x\n",
-			get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
+	else {
+		/* Based on type of command response or notification,
+		 *   handle those that need handling via function in
+		 *   rx_handlers table.  See iwl_setup_rx_handlers() */
+		if (priv->rx_handlers[pkt->hdr.cmd]) {
+			priv->rx_handlers_stats[pkt->hdr.cmd]++;
+			err = priv->rx_handlers[pkt->hdr.cmd] (priv, rxb, cmd);
+		} else {
+			/* No handling needed */
+			IWL_DEBUG_RX(priv,
+				"No handler needed for %s, 0x%02x\n",
+				get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
+		}
 	}
 	return err;
 }
-- 
1.7.0.4

