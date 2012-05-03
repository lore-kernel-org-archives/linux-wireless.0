Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:64003 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758770Ab2ECV2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 17:28:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 6/6] iwlwifi: don't disable AGG queues that are not enabled
Date: Thu,  3 May 2012 14:22:06 -0700
Message-Id: <1336080126-22606-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120503_232852_131435_C72AE2EA)
In-Reply-To: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

If the BA session is torn down before we had a chance to start it
we shouldn't disable the AGG tx queues that weren't enabled.
This can happen in two cases:

1) We get a delBA before we drained our Tx queues in agg start flow
2) We didn't get the (successfull) addBA response on time

Reported-by: Daniel Chyan <dchyan@princeton.edu>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index d8b6fa2..3366e2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -590,11 +590,17 @@ turn_off:
 	spin_unlock_bh(&priv->sta_lock);
 
 	if (test_bit(txq_id, priv->agg_q_alloc)) {
-		/* If the transport didn't know that we wanted to start
-		 * agreggation, don't tell it that we want to stop them
+		/*
+		 * If the transport didn't know that we wanted to start
+		 * agreggation, don't tell it that we want to stop them.
+		 * This can happen when we don't get the addBA response on
+		 * time, or we hadn't time to drain the AC queues.
 		 */
-		if (agg_state != IWL_AGG_STARTING)
+		if (agg_state == IWL_AGG_ON)
 			iwl_trans_tx_agg_disable(priv->trans, txq_id);
+		else
+			IWL_DEBUG_TX_QUEUES(priv, "Don't disable tx agg: %d\n",
+					    agg_state);
 		iwlagn_dealloc_agg_txq(priv, txq_id);
 	}
 
-- 
1.7.0.4

