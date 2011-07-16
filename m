Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab1GPPcL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/18] iwlagn: move the Rx dispatching to the upper layer
Date: Sat, 16 Jul 2011 07:56:25 -0700
Message-Id: <1310828199-18000-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173221_185498_612D60AD)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The upper layer receives a pointer to an iwl_rx_mem_buffer. I would prefer the
upper layer to receive a pointer to an iwl_rx_packet, but this is impossible
since the Rx path needs to add the address of the page to the skb.
I may find a solution later.

All the pre_rx_handler and notification code has been moved to the upper layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   42 +++--------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-rx.c  |   46 ++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c91e010..ba4e2a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -513,6 +513,9 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 			       DMA_FROM_DEVICE);
 		pkt = rxb_addr(rxb);
 
+		IWL_DEBUG_RX(priv, "r = %d, i = %d, %s, 0x%02x\n", r,
+			i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
+
 		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 		len += sizeof(u32); /* account for status word */
 		trace_iwlwifi_dev_rx(priv, pkt, len);
@@ -531,44 +534,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
 			(pkt->hdr.cmd != REPLY_TX);
 
-		/*
-		 * Do the notification wait before RX handlers so
-		 * even if the RX handler consumes the RXB we have
-		 * access to it in the notification wait entry.
-		 */
-		if (!list_empty(&priv->_agn.notif_waits)) {
-			struct iwl_notification_wait *w;
-
-			spin_lock(&priv->_agn.notif_wait_lock);
-			list_for_each_entry(w, &priv->_agn.notif_waits, list) {
-				if (w->cmd == pkt->hdr.cmd) {
-					w->triggered = true;
-					if (w->fn)
-						w->fn(priv, pkt, w->fn_data);
-				}
-			}
-			spin_unlock(&priv->_agn.notif_wait_lock);
-
-			wake_up_all(&priv->_agn.notif_waitq);
-		}
-		if (priv->pre_rx_handler)
-			priv->pre_rx_handler(priv, rxb);
-
-		/* Based on type of command response or notification,
-		 *   handle those that need handling via function in
-		 *   rx_handlers table.  See iwl_setup_rx_handlers() */
-		if (priv->rx_handlers[pkt->hdr.cmd]) {
-			IWL_DEBUG_RX(priv, "r = %d, i = %d, %s, 0x%02x\n", r,
-				i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
-			priv->isr_stats.rx_handlers[pkt->hdr.cmd]++;
-			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
-		} else {
-			/* No handling needed */
-			IWL_DEBUG_RX(priv,
-				"r %d i %d No handler needed for %s, 0x%02x\n",
-				r, i, get_cmd_string(pkt->hdr.cmd),
-				pkt->hdr.cmd);
-		}
+		iwl_rx_dispatch(priv, rxb);
 
 		/*
 		 * XXX: After here, we should always check rxb->page
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index fe5451e..666376e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -187,6 +187,8 @@ void iwlagn_rx_replenish(struct iwl_priv *priv);
 void iwlagn_rx_replenish_now(struct iwl_priv *priv);
 int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
 void iwl_setup_rx_handlers(struct iwl_priv *priv);
+void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
+
 
 /* tx */
 void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq,
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index f3f3efe..c5eb379 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1105,3 +1105,49 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	/* Set up hardware specific Rx handlers */
 	priv->cfg->ops->lib->rx_handler_setup(priv);
 }
+
+void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+
+	/*
+	 * Do the notification wait before RX handlers so
+	 * even if the RX handler consumes the RXB we have
+	 * access to it in the notification wait entry.
+	 */
+	if (!list_empty(&priv->_agn.notif_waits)) {
+		struct iwl_notification_wait *w;
+
+		spin_lock(&priv->_agn.notif_wait_lock);
+		list_for_each_entry(w, &priv->_agn.notif_waits, list) {
+			if (w->cmd != pkt->hdr.cmd)
+				continue;
+			IWL_DEBUG_RX(priv,
+				"Notif: %s, 0x%02x - wake the callers up\n",
+				get_cmd_string(pkt->hdr.cmd),
+				pkt->hdr.cmd);
+			w->triggered = true;
+			if (w->fn)
+				w->fn(priv, pkt, w->fn_data);
+		}
+		spin_unlock(&priv->_agn.notif_wait_lock);
+
+		wake_up_all(&priv->_agn.notif_waitq);
+	}
+
+	if (priv->pre_rx_handler)
+		priv->pre_rx_handler(priv, rxb);
+
+	/* Based on type of command response or notification,
+	 *   handle those that need handling via function in
+	 *   rx_handlers table.  See iwl_setup_rx_handlers() */
+	if (priv->rx_handlers[pkt->hdr.cmd]) {
+		priv->isr_stats.rx_handlers[pkt->hdr.cmd]++;
+		priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
+	} else {
+		/* No handling needed */
+		IWL_DEBUG_RX(priv,
+			"No handler needed for %s, 0x%02x\n",
+			get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
+	}
+}
-- 
1.7.0.4

