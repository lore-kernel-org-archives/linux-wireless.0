Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50202 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S944659AbcJSPSY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:18:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 13:07:46 +0300
Message-Id: <20161019100755.23874-2-luca@coelho.fi> (sfid-20161019_171828_761433_012FAD15)
In-Reply-To: <20161019100755.23874-1-luca@coelho.fi>
References: <20161019100755.23874-1-luca@coelho.fi>
Subject: [PATCH 01/10] iwlwifi: mvm: update txq metadata to current owner
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When a TXQ's owner is changed, the FW is indeed notified, but
the driver doesn't update the current metadata to reflect the
owner change. Fix that.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index fc77188..a65030f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -875,12 +875,17 @@ static void iwl_mvm_change_queue_owner(struct iwl_mvm *mvm, int queue)
 	cmd.tx_fifo = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
 
 	ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd), &cmd);
-	if (ret)
+	if (ret) {
 		IWL_ERR(mvm, "Failed to update owner of TXQ %d (ret=%d)\n",
 			queue, ret);
-	else
-		IWL_DEBUG_TX_QUEUES(mvm, "Changed TXQ %d ownership to tid %d\n",
-				    queue, tid);
+		return;
+	}
+
+	spin_lock_bh(&mvm->queue_info_lock);
+	mvm->queue_info[queue].txq_tid = tid;
+	spin_unlock_bh(&mvm->queue_info_lock);
+	IWL_DEBUG_TX_QUEUES(mvm, "Changed TXQ %d ownership to tid %d\n",
+			    queue, tid);
 }
 
 static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
-- 
2.9.3
