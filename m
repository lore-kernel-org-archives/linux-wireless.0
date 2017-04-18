Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52736 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757578AbdDRWRs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:17:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:12 +0300
Message-Id: <20170418221729.28372-9-luca@coelho.fi> (sfid-20170419_001807_198587_A0395F49)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 08/25] iwlwifi: mvm: work around HW issue with AMSDU de-aggregation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Seems like HW is reversing addr3 in the MAC header of de-aggregated
AMSDU. Reverse it back.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 44072c3c4b5f..c99775039f59 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -911,12 +911,19 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		 * Our hardware de-aggregates AMSDUs but copies the mac header
 		 * as it to the de-aggregated MPDUs. We need to turn off the
 		 * AMSDU bit in the QoS control ourselves.
+		 * In addition, HW reverses addr3 - reverse it back.
 		 */
 		if ((desc->mac_flags2 & IWL_RX_MPDU_MFLG2_AMSDU) &&
 		    !WARN_ON(!ieee80211_is_data_qos(hdr->frame_control))) {
+			int i;
 			u8 *qc = ieee80211_get_qos_ctl(hdr);
+			u8 mac_addr[ETH_ALEN];
 
 			*qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+
+			for (i = 0; i < ETH_ALEN; i++)
+				mac_addr[i] = hdr->addr3[ETH_ALEN - i - 1];
+			ether_addr_copy(hdr->addr3, mac_addr);
 		}
 		if (baid != IWL_RX_REORDER_DATA_INVALID_BAID)
 			iwl_mvm_agg_rx_received(mvm, baid);
-- 
2.11.0
