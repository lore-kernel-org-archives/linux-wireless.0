Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0FFG4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/23] iwl3945: fix bugs in txq freeing
Date: Sat,  5 Jun 2010 23:56:29 -0700
Message-Id: <1275807398-18184-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we free a txq that had no txb array allocated,
we still try to access it. Fix that, and also free
all SKBs that may be in the txb array (although it
can just be a single one).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 295b67a..fec05b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -705,16 +705,18 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	for (i = 1; i < counter; i++) {
 		pci_unmap_single(dev, le32_to_cpu(tfd->tbs[i].addr),
 			 le32_to_cpu(tfd->tbs[i].len), PCI_DMA_TODEVICE);
-		if (txq->txb[txq->q.read_ptr].skb[0]) {
-			struct sk_buff *skb = txq->txb[txq->q.read_ptr].skb[0];
-			if (txq->txb[txq->q.read_ptr].skb[0]) {
-				/* Can be called from interrupt context */
+		if (txq->txb) {
+			struct sk_buff *skb;
+
+			skb = txq->txb[txq->q.read_ptr].skb[i - 1];
+
+			/* can be called from irqs-disabled context */
+			if (skb) {
 				dev_kfree_skb_any(skb);
-				txq->txb[txq->q.read_ptr].skb[0] = NULL;
+				txq->txb[txq->q.read_ptr].skb[i - 1] = NULL;
 			}
 		}
 	}
-	return ;
 }
 
 /**
-- 
1.7.0.4

