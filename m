Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43974 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727495AbeHXOFG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:05:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:15 +0300
Message-Id: <20180824103018.15011-14-luca@coelho.fi> (sfid-20180824_123108_108668_4BE70914)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 13/16] iwlwifi: mvm: decode HE TB PPDU data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Decode the HE TB PPDU data that we get in sniffer mode
and use it to populate the HE radiotap information.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    | 21 ++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 38 ++++++++++---------
 2 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index e966679a964e..2078ef425f8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -362,22 +362,27 @@ enum iwl_rx_he_phy {
 	/* 6 bits reserved */
 	IWL_RX_HE_PHY_DELIM_EOF			= BIT(31),
 
-	/* second dword - MU data */
-	IWL_RX_HE_PHY_SIGB_COMPRESSION		= BIT_ULL(32 + 0),
-	IWL_RX_HE_PHY_SIBG_SYM_OR_USER_NUM_MASK	= 0x1e00000000ULL,
+	/* second dword - common data */
 	IWL_RX_HE_PHY_HE_LTF_NUM_MASK		= 0xe000000000ULL,
 	IWL_RX_HE_PHY_RU_ALLOC_SEC80		= BIT_ULL(32 + 8),
 	/* trigger encoded */
 	IWL_RX_HE_PHY_RU_ALLOC_MASK		= 0xfe0000000000ULL,
-	IWL_RX_HE_PHY_SIGB_MCS_MASK		= 0xf000000000000ULL,
-	/* 1 bit reserved */
-	IWL_RX_HE_PHY_SIGB_DCM			= BIT_ULL(32 + 21),
-	IWL_RX_HE_PHY_PREAMBLE_PUNC_TYPE_MASK	= 0xc0000000000000ULL,
-	/* 4 bits reserved */
 	IWL_RX_HE_PHY_INFO_TYPE_MASK		= 0xf000000000000000ULL,
 	IWL_RX_HE_PHY_INFO_TYPE_SU		= 0x0,
 	IWL_RX_HE_PHY_INFO_TYPE_MU		= 0x1,
 	IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO	= 0x2,
+	IWL_RX_HE_PHY_INFO_TYPE_TB_EXT_INFO	= 0x3,
+
+	/* second dword - MU data */
+	IWL_RX_HE_PHY_MU_SIGB_COMPRESSION		= BIT_ULL(32 + 0),
+	IWL_RX_HE_PHY_MU_SIBG_SYM_OR_USER_NUM_MASK	= 0x1e00000000ULL,
+	IWL_RX_HE_PHY_MU_SIGB_MCS_MASK			= 0xf000000000000ULL,
+	IWL_RX_HE_PHY_MU_SIGB_DCM			= BIT_ULL(32 + 21),
+	IWL_RX_HE_PHY_MU_PREAMBLE_PUNC_TYPE_MASK	= 0xc0000000000000ULL,
+
+	/* second dword - TB data */
+	IWL_RX_HE_PHY_TB_PILOT_TYPE			= BIT_ULL(32 + 0),
+	IWL_RX_HE_PHY_TB_LOW_SS_MASK			= 0xe00000000ULL
 };
 
 enum iwl_rx_he_sigb_common0 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 2eae657b16b6..f415c72394ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -988,23 +988,23 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 		}
 	} else if (overload && he_mu && he_phy_data != HE_PHY_DATA_INVAL) {
 		he_mu->flags1 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SIBG_SYM_OR_USER_NUM_MASK,
-						  he_phy_data),
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIBG_SYM_OR_USER_NUM_MASK,
+						   he_phy_data),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_SYMS_USERS);
 		he_mu->flags1 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SIGB_DCM,
-						  he_phy_data),
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_DCM,
+						   he_phy_data),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_DCM);
 		he_mu->flags1 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SIGB_MCS_MASK,
-						  he_phy_data),
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_MCS_MASK,
+						   he_phy_data),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_MCS);
 		he_mu->flags2 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SIGB_COMPRESSION,
-						  he_phy_data),
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_COMPRESSION,
+						   he_phy_data),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_COMP);
 		he_mu->flags2 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_PREAMBLE_PUNC_TYPE_MASK,
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_PREAMBLE_PUNC_TYPE_MASK,
 						   he_phy_data),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW);
 
@@ -1049,15 +1049,18 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 		rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_106;
 	}
 
-	if (he_mu) {
+	if (he_phy_data != HE_PHY_DATA_INVAL &&
+	    (FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK, he_phy_data) ==
+			IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO ||
+	     FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK, he_phy_data) ==
+			IWL_RX_HE_PHY_INFO_TYPE_TB_EXT_INFO)) {
 		/*
 		 * Unfortunately, we have to leave the mac80211 data
 		 * incorrect for the case that we receive an HE-MU
-		 * transmission and *don't* have the he_mu pointer,
-		 * i.e. we don't have the phy data (due to the bits
-		 * being used for TSF). This shouldn't happen though
-		 * as management frames where we need the TSF/timers
-		 * are not be transmitted in HE-MU, I think.
+		 * transmission and *don't* have the HE phy data (due
+		 * to the bits being used for TSF). This shouldn't
+		 * happen though as management frames where we need
+		 * the TSF/timers are not be transmitted in HE-MU.
 		 */
 		u8 ru = FIELD_GET(IWL_RX_HE_PHY_RU_ALLOC_MASK, he_phy_data);
 		u8 offs = 0;
@@ -1100,10 +1103,11 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 					 IEEE80211_RADIOTAP_HE_DATA2_RU_OFFSET);
 		he->data2 |=
 			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_KNOWN);
-		if (he_phy_data & IWL_RX_HE_PHY_RU_ALLOC_SEC80) {
+		if (he_phy_data & IWL_RX_HE_PHY_RU_ALLOC_SEC80)
 			he->data2 |=
 				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_SEC);
 
+		if (he_mu) {
 #define CHECK_BW(bw) \
 	BUILD_BUG_ON(IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW_ ## bw ## MHZ != \
 		     RATE_MCS_CHAN_WIDTH_##bw >> RATE_MCS_CHAN_WIDTH_POS)
@@ -1111,7 +1115,7 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 			CHECK_BW(40);
 			CHECK_BW(80);
 			CHECK_BW(160);
-			he_mu->flags2 |=
+			he->data2 |=
 				le16_encode_bits(FIELD_GET(RATE_MCS_CHAN_WIDTH_MSK,
 							   rate_n_flags),
 						 IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW);
-- 
2.18.0
