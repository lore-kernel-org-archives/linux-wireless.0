Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33424 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1424069AbeCBMbV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 07:31:21 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Mar 2018 14:31:09 +0200
Message-Id: <20180302123112.27416-2-luca@coelho.fi> (sfid-20180302_133125_580753_D433CF29)
In-Reply-To: <20180302123112.27416-1-luca@coelho.fi>
References: <20180302123112.27416-1-luca@coelho.fi>
Subject: [PATCH 1/4] iwlwifi: mvm: set the correct tid when we flush the MCAST sta
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The tid being used for the queue (cab_queue) for the MCAST
station has been changed recently to be 0 (for BE).
The flush path still flushed only the special tid (15)
which means that the firmware wasn't flushing the right
queue and we could get a firmware crash upon remove
station if we had an MCAST packet on the ring.

The current code that flushes queues for a station only
differentiates between internal stations (stations that
aren't instantiated in mac80211, like the MCAST station)
and the non-internal ones.
Internal stations can be either: BCAST (beacons), MCAST
(for cab_queue), GENERAL_PURPOSE (p2p dev, and sniffer
injection). The internal stations can use different tids.

To make the code simpler, just flush all the tids always
and add the special internal tid (15) for internal
stations. The firmware will know how to handle this even
if we hadn't any queue mapped that that tid.

Fixes: e340c1a6ef4b ("iwlwifi: mvm: Correctly set the tid for mcast queue")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index af6dfceab6b8..7dfe4cde55e3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1894,14 +1894,12 @@ int iwl_mvm_flush_sta(struct iwl_mvm *mvm, void *sta, bool internal, u32 flags)
 	struct iwl_mvm_int_sta *int_sta = sta;
 	struct iwl_mvm_sta *mvm_sta = sta;
 
-	if (iwl_mvm_has_new_tx_api(mvm)) {
-		if (internal)
-			return iwl_mvm_flush_sta_tids(mvm, int_sta->sta_id,
-						      BIT(IWL_MGMT_TID), flags);
+	BUILD_BUG_ON(offsetof(struct iwl_mvm_int_sta, sta_id) !=
+		     offsetof(struct iwl_mvm_sta, sta_id));
 
+	if (iwl_mvm_has_new_tx_api(mvm))
 		return iwl_mvm_flush_sta_tids(mvm, mvm_sta->sta_id,
-					      0xFF, flags);
-	}
+					      0xff | BIT(IWL_MGMT_TID), flags);
 
 	if (internal)
 		return iwl_mvm_flush_tx_path(mvm, int_sta->tfd_queue_msk,
-- 
2.16.1
