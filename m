Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17196 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab0KPQGm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:42 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/18] iwlagn: remove unused variable swq_id
Date: Tue, 16 Nov 2010 08:01:40 -0800
Message-Id: <1289923311-14920-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Simply remove the unused variable swq_id.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 522c77f..0fc86c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -518,7 +518,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct iwl_cmd_meta *out_meta;
 	struct iwl_tx_cmd *tx_cmd;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	int swq_id, txq_id;
+	int txq_id;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	dma_addr_t scratch_phys;
@@ -620,7 +620,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	}
 
 	txq = &priv->txq[txq_id];
-	swq_id = txq->swq_id;
 	q = &txq->q;
 
 	if (unlikely(iwl_queue_space(q) < q->high_mark)) {
-- 
1.7.0.4

