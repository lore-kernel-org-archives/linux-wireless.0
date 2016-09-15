Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54856 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752020AbcIOSMf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:12:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:31 +0300
Message-Id: <20160915181131.32213-25-luca@coelho.fi> (sfid-20160915_203149_211461_60EF4A2D)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 25/25] iwlwifi: mvm: tighten BAID range check
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As pointed out by smatch, checking the BAID for just >= INVALID
is a bad idea since only 32 (IWL_MAX_BAID) actually exist. Check
the range for that and print invalid ones in the warning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 7845dbe..d6d9ec4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -503,7 +503,7 @@ static void iwl_mvm_del_ba(struct iwl_mvm *mvm, int queue,
 	struct iwl_mvm_reorder_buffer *reorder_buf;
 	u8 baid = data->baid;
 
-	if (WARN_ON_ONCE(baid >= IWL_RX_REORDER_DATA_INVALID_BAID))
+	if (WARN_ONCE(baid >= IWL_MAX_BAID, "invalid BAID: %x\n", baid))
 		return;
 
 	rcu_read_lock();
-- 
2.9.3
