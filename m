Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab2FFNXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/29] iwlwifi: use iwl_trans_set_wr_ptrs to init the queues
Date: Wed,  6 Jun 2012 15:21:58 +0200
Message-Id: <1338988930-11561-17-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152337_463715_F5AA8A68)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This functions does the job so use it instead of duplicating
the code.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 2d33015..0d0c7d8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1060,8 +1060,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 
 	/* initiate the queues */
 	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
-		iwl_write_prph(trans, SCD_QUEUE_RDPTR(i), 0);
-		iwl_write_direct32(trans, HBUS_TARG_WRPTR, 0 | (i << 8));
+		iwl_trans_set_wr_ptrs(trans, i, 0);
 		iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
 				SCD_CONTEXT_QUEUE_OFFSET(i), 0);
 		iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
@@ -1075,8 +1074,6 @@ static void iwl_tx_start(struct iwl_trans *trans)
 				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 	}
 
-	iwl_trans_set_wr_ptrs(trans, trans_pcie->cmd_queue, 0);
-
 	for (i = 0; i < trans_pcie->n_q_to_fifo; i++) {
 		int fifo = trans_pcie->setup_q_to_fifo[i];
 
-- 
1.7.10

