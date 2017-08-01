Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41530 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751599AbdHAJkt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:40:49 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  1 Aug 2017 12:40:36 +0300
Message-Id: <20170801094039.22349-6-luca@coelho.fi> (sfid-20170801_114103_047192_942580E1)
In-Reply-To: <20170801094039.22349-1-luca@coelho.fi>
References: <20170801094039.22349-1-luca@coelho.fi>
Subject: [PATCH 5/8] iwlwifi: mvm: rs: fix TLC statistics collection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

Statistics should be collected according to the actual rate a
frame/aggregation was transmitted and not according to the initial rate
from the last LQ command (these rates are different if the frames were
retransmitted at a lower rate from the rate scale table).

This is needed to remove throughput degradation.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 65beca3a457a..8999a1199d60 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -1291,7 +1291,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	 * first index into rate scale table.
 	 */
 	if (info->flags & IEEE80211_TX_STAT_AMPDU) {
-		rs_collect_tpc_data(mvm, lq_sta, curr_tbl, lq_rate.index,
+		rs_collect_tpc_data(mvm, lq_sta, curr_tbl, tx_resp_rate.index,
 				    info->status.ampdu_len,
 				    info->status.ampdu_ack_len,
 				    reduced_txp);
@@ -1312,7 +1312,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		if (info->status.ampdu_ack_len == 0)
 			info->status.ampdu_len = 1;
 
-		rs_collect_tlc_data(mvm, lq_sta, curr_tbl, lq_rate.index,
+		rs_collect_tlc_data(mvm, lq_sta, curr_tbl, tx_resp_rate.index,
 				    info->status.ampdu_len,
 				    info->status.ampdu_ack_len);
 
@@ -1348,11 +1348,11 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 				continue;
 
 			rs_collect_tpc_data(mvm, lq_sta, tmp_tbl,
-					    lq_rate.index, 1,
+					    tx_resp_rate.index, 1,
 					    i < retries ? 0 : legacy_success,
 					    reduced_txp);
 			rs_collect_tlc_data(mvm, lq_sta, tmp_tbl,
-					    lq_rate.index, 1,
+					    tx_resp_rate.index, 1,
 					    i < retries ? 0 : legacy_success);
 		}
 
-- 
2.13.2
