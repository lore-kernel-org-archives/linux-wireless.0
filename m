Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33350 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751203AbcGFKoH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:16 +0300
Message-Id: <1467801651-1816-21-git-send-email-luca@coelho.fi> (sfid-20160706_124417_010532_DE4DC083)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 21/56] iwlwifi: mvm: fix txq aggregation bug
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Fix an issue where nullfunc frames and block ack requests
had the same tid as aggregation frames and were queued on
a non aggregation queue. The pending frames counter included
those frames but the check whether to decrement the pending
frames counter relied on the tid status and not on the txq id.
The result was an inconsistent state of the pending frames
counter followed by a failure to remove the station.
This failure triggered SYSASSERT 0x3421.

In addition, fix a situation in DQA mode where the number
of pending frames turned negative. This was due to the TX queue
being on the IWL_EMPTYING_HW_QUEUE_DELBA state and its frames
were still decremented.

Even though the SYSASSERT issue is fixed when DQA is disabled,
the issue is not completely solved when DQA is enabled and
should still be fixed.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Fixes: cf961e16620f ("iwlwifi: mvm: support dqa-mode agg on non-shared queue")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index d91edab..1f23cee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1329,7 +1329,15 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			bool send_eosp_ndp = false;
 
 			spin_lock_bh(&mvmsta->lock);
-			txq_agg = (mvmsta->tid_data[tid].state == IWL_AGG_ON);
+			if (iwl_mvm_is_dqa_supported(mvm)) {
+				enum iwl_mvm_agg_state state;
+
+				state = mvmsta->tid_data[tid].state;
+				txq_agg = (state == IWL_AGG_ON ||
+					state == IWL_EMPTYING_HW_QUEUE_DELBA);
+			} else {
+				txq_agg = txq_id >= mvm->first_agg_queue;
+			}
 
 			if (!is_ndp) {
 				tid_data->next_reclaimed = next_reclaimed;
-- 
2.8.1

