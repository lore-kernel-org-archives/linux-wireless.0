Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43826 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726330AbeHXOE0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:26 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:04 +0300
Message-Id: <20180824103018.15011-3-luca@coelho.fi> (sfid-20180824_123028_898172_2AED4728)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 02/16] iwlwifi: mvm: put LTF symbol size into HE radiotap
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

I evidently completely confused "number of LTF symbols" and "LTF size".
Radiotap was reporting the former, while I thought it was the latter,
and we really need both.

Add the LTF symbol size into the newly defined field in radiotap.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index fd66ea7c4b66..f644bcf7e048 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -925,7 +925,7 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 	struct ieee80211_radiotap_he *he = NULL;
 	struct ieee80211_radiotap_he_mu *he_mu = NULL;
 	u32 he_type = 0xffffffff;
-	u8 stbc;
+	u8 stbc, ltf;
 
 	static const struct ieee80211_radiotap_he known = {
 		.data1 = cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_DATA_MCS_KNOWN |
@@ -1151,21 +1151,33 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 		RATE_MCS_HE_GI_LTF_POS) {
 	case 0:
 		rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
+		if (he_type == RATE_MCS_HE_TYPE_MU)
+			ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_4X;
+		else
+			ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_1X;
 		break;
 	case 1:
 		rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
+		ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_2X;
 		break;
 	case 2:
 		rx_status->he_gi = NL80211_RATE_INFO_HE_GI_1_6;
+		if (he_type == RATE_MCS_HE_TYPE_TRIG)
+			ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_4X;
+		else
+			ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_2X;
 		break;
 	case 3:
 		if (rate_n_flags & RATE_MCS_SGI_MSK)
 			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
 		else
 			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_3_2;
+		ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_4X;
 		break;
 	}
 
+	he->data5 |= le16_encode_bits(ltf, IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE);
+
 	switch (he_type) {
 	case RATE_MCS_HE_TYPE_SU: {
 		u16 val;
-- 
2.18.0
