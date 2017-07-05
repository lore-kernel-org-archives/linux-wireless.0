Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37312 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751913AbdGEGFt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 02:05:49 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Jul 2017 09:05:35 +0300
Message-Id: <20170705060539.20737-4-luca@coelho.fi> (sfid-20170705_080558_642000_5D45B8F9)
In-Reply-To: <20170705060539.20737-1-luca@coelho.fi>
References: <20170705060539.20737-1-luca@coelho.fi>
Subject: [PATCH 3/7] iwlwifi: mvm: fix a NULL pointer dereference of error in recovery
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Sometimes, we can have an firmware crash while trying to
recover from a previous firmware problem.
When that happens, lots of things can go wrong. For example
the stations don't get added properly to mvm->fw_id_to_mac_id.

Mac80211 tries to stop A-MPDU upon reconfig but in case of
a firmware crash we will bail out fairly early and in the
end, we won't delete the A-MPDU Rx timeout.
When that timer expired after a double firmware crash,
we end up dereferencing mvm->fw_id_to_mac_id[sta_id]
which is NULL.

Fixes: 10b2b2019d81 ("iwlwifi: mvm: add infrastructure for tracking BA session in driver")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 4df5f13fcdae..4a6df45b73df 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -277,6 +277,18 @@ static void iwl_mvm_rx_agg_session_expired(unsigned long data)
 
 	/* Timer expired */
 	sta = rcu_dereference(ba_data->mvm->fw_id_to_mac_id[ba_data->sta_id]);
+
+	/*
+	 * sta should be valid unless the following happens:
+	 * The firmware asserts which triggers a reconfig flow, but
+	 * the reconfig fails before we set the pointer to sta into
+	 * the fw_id_to_mac_id pointer table. Mac80211 can't stop
+	 * A-MDPU and hence the timer continues to run. Then, the
+	 * timer expires and sta is NULL.
+	 */
+	if (!sta)
+		goto unlock;
+
 	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	ieee80211_stop_rx_ba_session_offl(mvm_sta->vif,
 					  sta->addr, ba_data->tid);
-- 
2.11.0
