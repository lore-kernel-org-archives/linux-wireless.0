Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54926 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753963AbcIOSNN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:13:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:30 +0300
Message-Id: <20160915181131.32213-24-luca@coelho.fi> (sfid-20160915_201321_334792_173FBC1E)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 24/25] iwlwifi: mvm: remove pointless _bh from spinlock in timer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Inside the reorder timer expire function, there's no point in
disabling BHs since it is in BH context. Remove that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 08d8a8a..7845dbe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -452,10 +452,10 @@ void iwl_mvm_reorder_timer_expired(unsigned long data)
 	u16 sn = 0, index = 0;
 	bool expired = false;
 
-	spin_lock_bh(&buf->lock);
+	spin_lock(&buf->lock);
 
 	if (!buf->num_stored || buf->removed) {
-		spin_unlock_bh(&buf->lock);
+		spin_unlock(&buf->lock);
 		return;
 	}
 
@@ -492,7 +492,7 @@ void iwl_mvm_reorder_timer_expired(unsigned long data)
 			  buf->reorder_time[index] +
 			  1 + RX_REORDER_BUF_TIMEOUT_MQ);
 	}
-	spin_unlock_bh(&buf->lock);
+	spin_unlock(&buf->lock);
 }
 
 static void iwl_mvm_del_ba(struct iwl_mvm *mvm, int queue,
-- 
2.9.3
