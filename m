Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43852 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726572AbeHXOE3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:07 +0300
Message-Id: <20180824103018.15011-6-luca@coelho.fi> (sfid-20180824_123035_124785_D37FF7F0)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 05/16] iwlwifi: mvm: remove channel 2 from HE radiotap if not applicable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the bandwidth is only 20 MHz, then the second channel doesn't
exist, but the hardware reports the CRC was OK. Suppress the data
of the second channel in the HE radiotap in this case, by marking
it as not known.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 05ce253b8c30..2eae657b16b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -858,6 +858,7 @@ static void iwl_mvm_flip_address(u8 *addr)
 
 static void iwl_mvm_decode_he_sigb(struct iwl_mvm *mvm,
 				   struct iwl_rx_mpdu_desc *desc,
+				   u32 rate_n_flags,
 				   struct ieee80211_radiotap_he_mu *he_mu)
 {
 	u32 sigb0, sigb1;
@@ -893,7 +894,8 @@ static void iwl_mvm_decode_he_sigb(struct iwl_mvm *mvm,
 					     sigb1);
 	}
 
-	if (FIELD_GET(IWL_RX_HE_SIGB_COMMON2_CH2_CRC_OK, sigb2)) {
+	if (FIELD_GET(IWL_RX_HE_SIGB_COMMON2_CH2_CRC_OK, sigb2) &&
+	    (rate_n_flags & RATE_MCS_CHAN_WIDTH_MSK) != RATE_MCS_CHAN_WIDTH_20) {
 		he_mu->flags1 |=
 			cpu_to_le16(IEEE80211_RADIOTAP_HE_MU_FLAGS1_CH2_RU_KNOWN |
 				    IEEE80211_RADIOTAP_HE_MU_FLAGS1_CH2_CTR_26T_RU_KNOWN);
@@ -1010,7 +1012,7 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 				      he_phy_data) ==
 				IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO;
 		if (sigb_data)
-			iwl_mvm_decode_he_sigb(mvm, desc, he_mu);
+			iwl_mvm_decode_he_sigb(mvm, desc, rate_n_flags, he_mu);
 	}
 	if (he_phy_data != HE_PHY_DATA_INVAL &&
 	    (he_type == RATE_MCS_HE_TYPE_SU ||
-- 
2.18.0
