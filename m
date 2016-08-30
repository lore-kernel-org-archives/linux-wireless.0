Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41136 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754327AbcH3Lj2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 07:39:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 14:38:47 +0300
Message-Id: <1472557142-14782-1-git-send-email-luca@coelho.fi> (sfid-20160830_133931_772886_D4D2216D)
In-Reply-To: <1472556999.27868.86.camel@coelho.fi>
References: <1472556999.27868.86.camel@coelho.fi>
Subject: [PATCH 01/16] iwlwifi: mvm: allow same PN for de-aggregated AMSDU
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The 9000 hardware will de-aggregate AMSDUs. In the process
it will copy the mac header "as is" to the new MPDUs.
This means driver should allow the same PN for MPDUs originated
from the same AMSDU.
Do that by incrementing the PN only for the last MPDU in the
sequence.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index df6c32c..08d8a8a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -132,7 +132,8 @@ static inline int iwl_mvm_check_pn(struct iwl_mvm *mvm, struct sk_buff *skb,
 		   IEEE80211_CCMP_PN_LEN) <= 0)
 		return -1;
 
-	memcpy(ptk_pn->q[queue].pn[tid], pn, IEEE80211_CCMP_PN_LEN);
+	if (!(stats->flag & RX_FLAG_AMSDU_MORE))
+		memcpy(ptk_pn->q[queue].pn[tid], pn, IEEE80211_CCMP_PN_LEN);
 	stats->flag |= RX_FLAG_PN_VALIDATED;
 
 	return 0;
@@ -883,6 +884,9 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			u8 *qc = ieee80211_get_qos_ctl(hdr);
 
 			*qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+			if (!(desc->amsdu_info &
+			      IWL_RX_MPDU_AMSDU_LAST_SUBFRAME))
+				rx_status->flag |= RX_FLAG_AMSDU_MORE;
 		}
 		if (baid != IWL_RX_REORDER_DATA_INVALID_BAID)
 			iwl_mvm_agg_rx_received(mvm, baid);
-- 
2.8.1
