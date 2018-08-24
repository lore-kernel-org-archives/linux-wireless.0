Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43834 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726969AbeHXOE2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:05 +0300
Message-Id: <20180824103018.15011-4-luca@coelho.fi> (sfid-20180824_123034_484873_85FEB08B)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 03/16] iwlwifi: mvm: properly decode HE GI duration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The GI duration depends on the frame type in some cases,
take that into account when decoding for radiotap.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index f644bcf7e048..314012ed7a29 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1150,25 +1150,35 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 	switch ((rate_n_flags & RATE_MCS_HE_GI_LTF_MSK) >>
 		RATE_MCS_HE_GI_LTF_POS) {
 	case 0:
-		rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
+		if (he_type == RATE_MCS_HE_TYPE_TRIG)
+			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_1_6;
+		else
+			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
 		if (he_type == RATE_MCS_HE_TYPE_MU)
 			ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_4X;
 		else
 			ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_1X;
 		break;
 	case 1:
-		rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
+		if (he_type == RATE_MCS_HE_TYPE_TRIG)
+			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_1_6;
+		else
+			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
 		ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_2X;
 		break;
 	case 2:
-		rx_status->he_gi = NL80211_RATE_INFO_HE_GI_1_6;
-		if (he_type == RATE_MCS_HE_TYPE_TRIG)
+		if (he_type == RATE_MCS_HE_TYPE_TRIG) {
+			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_3_2;
 			ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_4X;
-		else
+		} else {
+			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_1_6;
 			ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_2X;
+		}
 		break;
 	case 3:
-		if (rate_n_flags & RATE_MCS_SGI_MSK)
+		if ((he_type == RATE_MCS_HE_TYPE_SU ||
+		     he_type == RATE_MCS_HE_TYPE_EXT_SU) &&
+		    rate_n_flags & RATE_MCS_SGI_MSK)
 			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
 		else
 			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_3_2;
-- 
2.18.0
