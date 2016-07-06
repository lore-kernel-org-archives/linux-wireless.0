Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33482 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753766AbcGFKoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:39 +0300
Message-Id: <1467801651-1816-44-git-send-email-luca@coelho.fi> (sfid-20160706_124459_114312_CC0012AC)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 44/56] iwlwifi: mvm: free RX reorder buffer on restart
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Restart flow zeroes the rx_ba_sessions counter. Mac80211 asks
driver to tear down of the session only afterwards, and as a
result driver didn't free the data. Fix it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Fixes: 10b2b2019d81 ("iwlwifi: mvm: add infrastructure for tracking BA session in driver")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index c0c2ea3..61f16c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1828,11 +1828,12 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			     mvm_sta->sta_id, tid, baid);
 		WARN_ON(rcu_access_pointer(mvm->baid_map[baid]));
 		rcu_assign_pointer(mvm->baid_map[baid], baid_data);
-	} else if (mvm->rx_ba_sessions > 0) {
+	} else  {
 		u8 baid = mvm_sta->tid_to_baid[tid];
 
-		/* check that restart flow didn't zero the counter */
-		mvm->rx_ba_sessions--;
+		if (mvm->rx_ba_sessions > 0)
+			/* check that restart flow didn't zero the counter */
+			mvm->rx_ba_sessions--;
 		if (!iwl_mvm_has_new_rx_api(mvm))
 			return 0;
 
-- 
2.8.1

