Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47351 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbaDMTU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:28 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so3126232wiv.15
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:28 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/47] iwlwifi: pcie: unify iwl_rx_replenish and iwl_rx_replenish_now
Date: Sun, 13 Apr 2014 22:19:27 +0300
Message-Id: <1397416802-32403-12-git-send-email-egrumbach@gmail.com> (sfid-20140413_212235_724993_6CC9DEE4)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Besides the different allocation flags, they are really
the same. Pass the gfp_t flags as a parameter, and unify
them.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 0937f84..4a26a08 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -373,16 +373,9 @@ static void iwl_pcie_rxq_free_rbs(struct iwl_trans *trans)
  * Also restock the Rx queue via iwl_pcie_rxq_restock.
  * This is called as a scheduled work item (except for during initialization)
  */
-static void iwl_pcie_rx_replenish(struct iwl_trans *trans)
+static void iwl_pcie_rx_replenish(struct iwl_trans *trans, gfp_t gfp)
 {
-	iwl_pcie_rxq_alloc_rbs(trans, GFP_KERNEL);
-
-	iwl_pcie_rxq_restock(trans);
-}
-
-static void iwl_pcie_rx_replenish_now(struct iwl_trans *trans)
-{
-	iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC);
+	iwl_pcie_rxq_alloc_rbs(trans, gfp);
 
 	iwl_pcie_rxq_restock(trans);
 }
@@ -392,7 +385,7 @@ static void iwl_pcie_rx_replenish_work(struct work_struct *data)
 	struct iwl_trans_pcie *trans_pcie =
 	    container_of(data, struct iwl_trans_pcie, rx_replenish);
 
-	iwl_pcie_rx_replenish(trans_pcie->trans);
+	iwl_pcie_rx_replenish(trans_pcie->trans, GFP_KERNEL);
 }
 
 static int iwl_pcie_rx_alloc(struct iwl_trans *trans)
@@ -528,7 +521,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 	memset(rxq->rb_stts, 0, sizeof(*rxq->rb_stts));
 	spin_unlock(&rxq->lock);
 
-	iwl_pcie_rx_replenish(trans);
+	iwl_pcie_rx_replenish(trans, GFP_KERNEL);
 
 	iwl_pcie_rx_hw_init(trans, rxq);
 
@@ -750,7 +743,7 @@ restart:
 			if (count >= 8) {
 				rxq->read = i;
 				spin_unlock(&rxq->lock);
-				iwl_pcie_rx_replenish_now(trans);
+				iwl_pcie_rx_replenish(trans, GFP_ATOMIC);
 				count = 0;
 				goto restart;
 			}
@@ -762,7 +755,7 @@ restart:
 	spin_unlock(&rxq->lock);
 
 	if (fill_rx)
-		iwl_pcie_rx_replenish_now(trans);
+		iwl_pcie_rx_replenish(trans, GFP_ATOMIC);
 	else
 		iwl_pcie_rxq_restock(trans);
 
-- 
1.8.3.2

