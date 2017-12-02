Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48662 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752387AbdLBQ3g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:29:36 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Dec 2017 18:28:56 +0200
Message-Id: <20171202162858.4167-14-luca@coelho.fi> (sfid-20171202_172946_579749_29E9E3B1)
In-Reply-To: <20171202162858.4167-1-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
Subject: [PATCH 13/15] iwlwifi: mvm: mark MIC stripped MPDUs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When RADA is active, the hardware decrypts the packets and strips off
the MIC as it is useless after decryption. Indicate that to mac80211.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 0e6a7dd30aa9..a81ff4163d05 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -253,6 +253,8 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			return -1;
 
 		stats->flag |= RX_FLAG_DECRYPTED;
+		if (pkt_flags & FH_RSCSR_RADA_EN)
+			stats->flag |= RX_FLAG_MIC_STRIPPED;
 		*crypt_len = IEEE80211_CCMP_HDR_LEN;
 		return 0;
 	case IWL_RX_MPDU_STATUS_SEC_TKIP:
-- 
2.15.0
