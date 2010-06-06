Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab0FFG4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/23] iwlagn: fix bug in txq freeing
Date: Sat,  5 Jun 2010 23:56:30 -0700
Message-Id: <1275807398-18184-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The iwl_hw_txq_free_tfd() function can be
called from contexts with IRQs disabled,
so it must not call dev_kfree_skb() but
rather dev_kfree_skb_any() instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9c85e1b..a61d567 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -484,8 +484,15 @@ void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 				iwl_tfd_tb_get_len(tfd, i), PCI_DMA_TODEVICE);
 
 		if (txq->txb) {
-			dev_kfree_skb(txq->txb[txq->q.read_ptr].skb[i - 1]);
-			txq->txb[txq->q.read_ptr].skb[i - 1] = NULL;
+			struct sk_buff *skb;
+
+			skb = txq->txb[txq->q.read_ptr].skb[i - 1];
+
+			/* can be called from irqs-disabled context */
+			if (skb) {
+				dev_kfree_skb_any(skb);
+				txq->txb[txq->q.read_ptr].skb[i - 1] = NULL;
+			}
 		}
 	}
 }
-- 
1.7.0.4

