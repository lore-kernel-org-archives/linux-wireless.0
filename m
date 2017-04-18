Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52728 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757574AbdDRWRs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:17:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:11 +0300
Message-Id: <20170418221729.28372-8-luca@coelho.fi> (sfid-20170419_001756_010143_E8140E0B)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 07/25] iwlwifi: mvm: do not turn on RX_FLAG_AMSDU_MORE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This flag is used for mac80211 reordering. As we do reordering
ourselves, turning it on is misleading and pointless.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 29c9c56ed3fa..44072c3c4b5f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -917,9 +917,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			u8 *qc = ieee80211_get_qos_ctl(hdr);
 
 			*qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
-			if (!(desc->amsdu_info &
-			      IWL_RX_MPDU_AMSDU_LAST_SUBFRAME))
-				rx_status->flag |= RX_FLAG_AMSDU_MORE;
 		}
 		if (baid != IWL_RX_REORDER_DATA_INVALID_BAID)
 			iwl_mvm_agg_rx_received(mvm, baid);
-- 
2.11.0
