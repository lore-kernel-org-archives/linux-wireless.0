Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39444 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754648AbeDMMnb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:43:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:56 +0300
Message-Id: <20180413124256.21769-26-luca@coelho.fi> (sfid-20180413_144334_912130_B9F4FB85)
In-Reply-To: <20180413124256.21769-1-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
Subject: [PATCH 25/25] iwlwifi: mvm: support 22000 HW opening agg before traffic
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When trying to open aggregations on 22000 HW before
traffic had actually passed, the driver will discover
it is missing a queue to aggregate on. In such a case -
allocate a queue.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 4f9d3e13d7e5..4ddd2c427b83 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -36,6 +36,7 @@
  * Copyright(c) 2012 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -2467,6 +2468,15 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (mvmsta->tid_data[tid].txq_id == IWL_MVM_INVALID_QUEUE &&
+	    iwl_mvm_has_new_tx_api(mvm)) {
+		u8 ac = tid_to_mac80211_ac[tid];
+
+		ret = iwl_mvm_sta_alloc_queue_tvqm(mvm, sta, ac, tid);
+		if (ret)
+			return ret;
+	}
+
 	spin_lock_bh(&mvmsta->lock);
 
 	/* possible race condition - we entered D0i3 while starting agg */
-- 
2.16.3
