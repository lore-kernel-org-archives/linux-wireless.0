Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58101 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3GZI2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:28:53 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/30] iwlwifi: pcie: make unused queue warning more readable
Date: Fri, 26 Jul 2013 10:28:22 +0200
Message-Id: <1374827327-3464-6-git-send-email-johannes@sipsolutions.net> (sfid-20130726_102909_747571_E405042E)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use the return value of WARN_ONCE() and add a message with
the queue ID that's getting used.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index c47c921..134f7a1 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1619,10 +1619,9 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	txq = &trans_pcie->txq[txq_id];
 	q = &txq->q;
 
-	if (unlikely(!test_bit(txq_id, trans_pcie->queue_used))) {
-		WARN_ON_ONCE(1);
+	if (WARN_ONCE(!test_bit(txq_id, trans_pcie->queue_used),
+		      "TX on unused queue %d\n", txq_id))
 		return -EINVAL;
-	}
 
 	spin_lock(&txq->lock);
 
-- 
1.8.0

