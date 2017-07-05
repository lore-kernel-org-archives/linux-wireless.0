Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37306 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751594AbdGEGFs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 02:05:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Mordechai Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Jul 2017 09:05:34 +0300
Message-Id: <20170705060539.20737-3-luca@coelho.fi> (sfid-20170705_080601_763140_C3CF91A2)
In-Reply-To: <20170705060539.20737-1-luca@coelho.fi>
References: <20170705060539.20737-1-luca@coelho.fi>
Subject: [PATCH 2/7] iwlwifi: pcie: fix unused txq NULL pointer dereference
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mordechai Goodstein <mordechay.goodstein@intel.com>

Before TVQM, all TX queues were allocated straight at init.
With TVQM, queues are allocated on demand and hence we need
to check if a queue exists before dereferencing it.

Fixes: 66128fa08806 ("iwlwifi: move to TVQM mode")
Signed-off-by: Mordechai Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index de50418adae5..034bdb4a0b06 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -298,6 +298,9 @@ void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans)
 	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
 		struct iwl_txq *txq = trans_pcie->txq[i];
 
+		if (!test_bit(i, trans_pcie->queue_used))
+			continue;
+
 		spin_lock_bh(&txq->lock);
 		if (txq->need_update) {
 			iwl_pcie_txq_inc_wr_ptr(trans, txq);
-- 
2.11.0
