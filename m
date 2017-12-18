Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51014 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933777AbdLRMi2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 07:38:28 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 18 Dec 2017 14:38:12 +0200
Message-Id: <20171218123815.3968-9-luca@coelho.fi> (sfid-20171218_133851_179290_8E99ED6B)
In-Reply-To: <20171218123815.3968-1-luca@coelho.fi>
References: <20171218123815.3968-1-luca@coelho.fi>
Subject: [PATCH 08/11] iwlwifi: mvm: don't warn on multiple packets when opening a queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When we have TSO enabled, we might end up segmenting it and
queuing multiple packets before the queue is even enabled.  This causes
a warning.

For example, when starting TCP traffic on a non-zero TID, the
first packets may not have DSCP and will be sent on TID 0, while
the actual data packets will be sent on the TID.

To prevent this, simply remove the warning.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index b65b4e8f8606..b926fd49e734 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -887,10 +887,9 @@ static void iwl_mvm_tx_add_stream(struct iwl_mvm *mvm,
 	/*
 	 * The first deferred frame should've stopped the MAC queues, so we
 	 * should never get a second deferred frame for the RA/TID.
+	 * In case of GSO the first packet may have been split, so don't warn.
 	 */
-	if (!WARN(skb_queue_len(deferred_tx_frames) != 1,
-		  "RATID %d/%d has %d deferred frames\n", mvm_sta->sta_id, tid,
-		  skb_queue_len(deferred_tx_frames))) {
+	if (skb_queue_len(deferred_tx_frames) == 1) {
 		iwl_mvm_stop_mac_queues(mvm, BIT(mac_queue));
 		schedule_work(&mvm->add_stream_wk);
 	}
-- 
2.15.1
