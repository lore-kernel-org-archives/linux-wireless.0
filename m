Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54130 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954128AbdDYUXH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:23:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sharon Dvir <sharon.dvir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:21 +0300
Message-Id: <20170425202243.7844-4-luca@coelho.fi> (sfid-20170425_222325_106361_794EFE8C)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 03/25] iwlwifi: mvm: check if returned value is NULL
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sharon Dvir <sharon.dvir@intel.com>

While freeing inactive queue, check mvmsta to be valid before
dereferencing it.  Found by Klocwork.

Signed-off-by: Sharon Dvir <sharon.dvir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index a2a1fa06b781..fc6d854b04b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -495,6 +495,8 @@ static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
 	spin_unlock_bh(&mvm->queue_info_lock);
 
 	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, sta_id);
+	if (WARN_ON(!mvmsta))
+		return -EINVAL;
 
 	disable_agg_tids = iwl_mvm_remove_sta_queue_marking(mvm, queue);
 	/* Disable the queue */
-- 
2.11.0
