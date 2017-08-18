Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44482 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751646AbdHRPtg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:49:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:05 +0300
Message-Id: <20170818154922.2904-8-luca@coelho.fi> (sfid-20170818_180252_695477_5549EE7B)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 07/24] iwlwifi: mvm: include more debug data when we get an unexpected baid
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we get a valid baid in a received frame, we need to
check that we are aware of this baid. If not, we check
that the OLD_SN bit set. If that's not the case, we issue
a WARNING. Print more data when that happens.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 6b8e57b7234a..4fbf102b3a98 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -636,8 +636,8 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	baid_data = rcu_dereference(mvm->baid_map[baid]);
 	if (!baid_data) {
 		WARN(!(reorder & IWL_RX_MPDU_REORDER_BA_OLD_SN),
-		     "Received baid %d, but no data exists for this BAID\n",
-		     baid);
+		     "Received baid %d, but no data exists for this BAID - reorder data 0x%x\n",
+		     baid, reorder);
 		return false;
 	}
 
@@ -758,7 +758,9 @@ static void iwl_mvm_agg_rx_received(struct iwl_mvm *mvm,
 
 	data = rcu_dereference(mvm->baid_map[baid]);
 	if (!data) {
-		WARN_ON(!(reorder_data & IWL_RX_MPDU_REORDER_BA_OLD_SN));
+		WARN(!(reorder_data & IWL_RX_MPDU_REORDER_BA_OLD_SN),
+		     "OLD_SN isn't set, but no data exists for baid %d - reorder data 0x%x\n",
+		     baid, reorder_data);
 		goto out;
 	}
 
-- 
2.14.1
