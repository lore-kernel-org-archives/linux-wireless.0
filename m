Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54704 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750867AbcIOSLm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:11:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:07 +0300
Message-Id: <20160915181131.32213-1-luca@coelho.fi> (sfid-20160915_201146_099666_FE6AEB52)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 01/25] iwlwifi: mvm: call a different txq_enable function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Since the SCD_QUEUE_CFG command was introduced the driver
calls iwl_trans_txq_enable_cfg() with a NULL for scd_cfg
parameter.
This makes the transport avoid writing to the SCD pointers,
since it can cause races with firmware, which is also accessing
the registers.
The transport only updates the write pointer in that case.
Fix a wrong call to iwl_trans_txq_enable() which caused a
scd_cfg parameter to be sent to transport, resulting with an
access to SCD registers.

Fixes: 58f2cc57dc6a ("iwlwifi: mvm: support dqa-mode scd queue redirection")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 30fc3af..a92e12e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -588,9 +588,7 @@ int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 			ret);
 
 	/* Make sure the SCD wrptr is correctly set before reconfiguring */
-	iwl_trans_txq_enable(mvm->trans, queue, iwl_mvm_ac_to_tx_fifo[ac],
-			     cmd.sta_id, tid, LINK_QUAL_AGG_FRAME_LIMIT_DEF,
-			     ssn, wdg_timeout);
+	iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, NULL, wdg_timeout);
 
 	/* Update the TID "owner" of the queue */
 	spin_lock_bh(&mvm->queue_info_lock);
-- 
2.9.3
