Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35024 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751134AbdFYLNT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:13:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:46 +0300
Message-Id: <20170625111158.1792-15-luca@coelho.fi> (sfid-20170625_131322_700236_7127717D)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 14/26] iwlwifi: mvm: don't mark TIDs that are not idle wrt BA as inactive
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

A TID may not have traffic but still have a BA agreement
active (or being setup / torn down) since a BA agreement
can be triggered by a debugfs hook.
Just avoid to consider such a TID as inactive to make the
logic safer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index e7cc8e05615a..8ba8b71dd1a4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1215,6 +1215,10 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 		/* If some TFDs are still queued - don't mark TID as inactive */
 		if (iwl_mvm_tid_queued(mvm, &mvmsta->tid_data[tid]))
 			tid_bitmap &= ~BIT(tid);
+
+		/* Don't mark as inactive any TID that has an active BA */
+		if (mvmsta->tid_data[tid].state != IWL_AGG_OFF)
+			tid_bitmap &= ~BIT(tid);
 	}
 
 	/* If all TIDs in the queue are inactive - mark queue as inactive. */
-- 
2.11.0
