Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26170 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab0KPQGm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:42 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/18] iwlagn: fix some naming regarding FIFOs
Date: Tue, 16 Nov 2010 08:01:39 -0800
Message-Id: <1289923311-14920-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some variables are misnamed in the FIFO setup
code, fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 7036211..8b129e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -429,7 +429,7 @@ void iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 
 int iwlagn_alive_notify(struct iwl_priv *priv)
 {
-	const s8 *queues;
+	const s8 *queue_to_fifo;
 	u32 a;
 	unsigned long flags;
 	int i, chan;
@@ -492,9 +492,9 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 
 	/* map queues to FIFOs */
 	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
-		queues = iwlagn_ipan_queue_to_tx_fifo;
+		queue_to_fifo = iwlagn_ipan_queue_to_tx_fifo;
 	else
-		queues = iwlagn_default_queue_to_tx_fifo;
+		queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
 
 	iwlagn_set_wr_ptrs(priv, priv->cmd_queue, 0);
 
@@ -510,14 +510,14 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) != 10);
 
 	for (i = 0; i < 10; i++) {
-		int ac = queues[i];
+		int fifo = queue_to_fifo[i];
 
 		iwl_txq_ctx_activate(priv, i);
 
-		if (ac == IWL_TX_FIFO_UNUSED)
+		if (fifo == IWL_TX_FIFO_UNUSED)
 			continue;
 
-		iwlagn_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
+		iwlagn_tx_queue_set_status(priv, &priv->txq[i], fifo, 0);
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.7.0.4

