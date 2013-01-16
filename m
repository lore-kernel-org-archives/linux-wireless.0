Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3APN6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 08:58:15 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/6] iwlwifi: don't memset scalar values
Date: Wed, 16 Jan 2013 14:58:34 +0100
Message-Id: <1358344719-26486-1-git-send-email-johannes@sipsolutions.net> (sfid-20130116_145824_066846_E3E7B900)
In-Reply-To: <1358344682.22862.4.camel@jlt4.sipsolutions.net>
References: <1358344682.22862.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The dma_addr_t type is a scalar value, so it should
just be assigned, not memset.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 6 +++---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 02c9016..ea9e991 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -436,7 +436,7 @@ static int iwl_pcie_rx_alloc(struct iwl_trans *trans)
 err_rb_stts:
 	dma_free_coherent(dev, sizeof(__le32) * RX_QUEUE_SIZE,
 			  rxq->bd, rxq->bd_dma);
-	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
+	rxq->bd_dma = 0;
 	rxq->bd = NULL;
 err_bd:
 	return -ENOMEM;
@@ -553,7 +553,7 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 
 	dma_free_coherent(trans->dev, sizeof(__le32) * RX_QUEUE_SIZE,
 			  rxq->bd, rxq->bd_dma);
-	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
+	rxq->bd_dma = 0;
 	rxq->bd = NULL;
 
 	if (rxq->rb_stts)
@@ -562,7 +562,7 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 				  rxq->rb_stts, rxq->rb_stts_dma);
 	else
 		IWL_DEBUG_INFO(trans, "Free rxq->rb_stts which is NULL\n");
-	memset(&rxq->rb_stts_dma, 0, sizeof(rxq->rb_stts_dma));
+	rxq->rb_stts_dma = 0;
 	rxq->rb_stts = NULL;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index d25fc8a..3ff3e8b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -615,7 +615,7 @@ static void iwl_pcie_txq_free(struct iwl_trans *trans, int txq_id)
 	if (txq->q.n_bd) {
 		dma_free_coherent(dev, sizeof(struct iwl_tfd) *
 				  txq->q.n_bd, txq->tfds, txq->q.dma_addr);
-		memset(&txq->q.dma_addr, 0, sizeof(txq->q.dma_addr));
+		txq->q.dma_addr = 0;
 	}
 
 	kfree(txq->entries);
-- 
1.8.0

