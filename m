Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54938 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753963AbcIOSNT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:13:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:19 +0300
Message-Id: <20160915181131.32213-13-luca@coelho.fi> (sfid-20160915_201323_671190_B5517BE8)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 13/25] iwlwifi: mvm: fix pending frames tracking on tx resp
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In iwl_mvm_rx_tx_cmd_single(), when checking if a given TID is
aggregated, the driver doesn't check whether or not the queue
itself can be aggregated. For example, a management queue might
be marked as aggregated if TID 0 is aggregated on a (different)
data queue.

Make sure that mgmt frames are sent with TID IWL_TID_NON_QOS,
and in this way make sure no mixups of this sort happen.

Fixes: commit 24afba7690e4 ("iwlwifi: mvm: support bss dynamic alloc/dealloc of queues")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 96482a5..1051777 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -920,9 +920,13 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 		tid = IWL_MAX_TID_COUNT;
 	}
 
-	if (iwl_mvm_is_dqa_supported(mvm))
+	if (iwl_mvm_is_dqa_supported(mvm)) {
 		txq_id = mvmsta->tid_data[tid].txq_id;
 
+		if (ieee80211_is_mgmt(fc))
+			tx_cmd->tid_tspec = IWL_TID_NON_QOS;
+	}
+
 	/* Copy MAC header from skb into command buffer */
 	memcpy(tx_cmd->hdr, hdr, hdrlen);
 
-- 
2.9.3
