Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52888 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755192AbdDRWWc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:22:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:25 +0300
Message-Id: <20170418221729.28372-22-luca@coelho.fi> (sfid-20170419_002241_807163_73CACFF7)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 21/25] iwlwifi: mvm: flip address 4 of AMSDU frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Address 4 is reversed as well.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 0f74a200e812..24c4fbe139a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -925,7 +925,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		 * Our hardware de-aggregates AMSDUs but copies the mac header
 		 * as it to the de-aggregated MPDUs. We need to turn off the
 		 * AMSDU bit in the QoS control ourselves.
-		 * In addition, HW reverses addr3 - reverse it back.
+		 * In addition, HW reverses addr3 and addr4 - reverse it back.
 		 */
 		if ((desc->mac_flags2 & IWL_RX_MPDU_MFLG2_AMSDU) &&
 		    !WARN_ON(!ieee80211_is_data_qos(hdr->frame_control))) {
@@ -938,6 +938,13 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			for (i = 0; i < ETH_ALEN; i++)
 				mac_addr[i] = hdr->addr3[ETH_ALEN - i - 1];
 			ether_addr_copy(hdr->addr3, mac_addr);
+
+			if (ieee80211_has_a4(hdr->frame_control)) {
+				for (i = 0; i < ETH_ALEN; i++)
+					mac_addr[i] =
+						hdr->addr4[ETH_ALEN - i - 1];
+				ether_addr_copy(hdr->addr4, mac_addr);
+			}
 		}
 		if (baid != IWL_RX_REORDER_DATA_INVALID_BAID) {
 			u32 reorder_data = le32_to_cpu(desc->reorder_data);
-- 
2.11.0
