Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:13231 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbYCGVx4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 16:53:56 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: fix potential lock inversion deadlock
Date: Fri,  7 Mar 2008 13:47:20 -0800
Message-Id: <1204926440-16839-1-git-send-email-reinette.chatre@intel.com> (sfid-20080307_215401_141183_D41DFAA5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a change to a previous patch ("iwlwifi: 3945 split tx_complete
to command and packet function") to ensure we do not have hardirq safe
locks (priv->lock in this case) depend on hardirq unsafe locks.

We only call iwl3945_tx_queue_reclaim while in a tasklet so we have to use
the irqsafe version of the function.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index b1eedec..bcfa299 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -283,8 +283,8 @@ static void iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv,
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
-		ieee80211_tx_status(priv->hw, tx_info->skb[0],
-				    &tx_info->status);
+		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0],
+					    &tx_info->status);
 		tx_info->skb[0] = NULL;
 		iwl3945_hw_txq_free_tfd(priv, txq);
 	}
-- 
1.5.3.4

