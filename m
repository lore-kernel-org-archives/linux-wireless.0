Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43820 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726572AbeHXOE1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:03 +0300
Message-Id: <20180824103018.15011-2-luca@coelho.fi> (sfid-20180824_123033_890076_F898CD13)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 01/16] iwlwifi: mvm: implement extended HE-MU sniffer API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Implement the extended HE-MU info type decoding to show the HE-SIG-B
common contents in the HE-MU radiotap field.

The DW4 data is partially overwritten by the hardware in all cases, so
only the higher 16 bits can be used.  To be able to use it for the HE
SIG-B common data anyway, move the bits around in the following way:

  SIG-B common 0: DW 4 -> DW 7
  SIG-B common 1: DW 7 -> DW 8
  SIG-B common 2: DW 8 -> DW 4 (upper half)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    | 117 +++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 140 ++++++++++++++----
 2 files changed, 206 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index 2ba1401e5c0d..e966679a964e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -373,7 +373,33 @@ enum iwl_rx_he_phy {
 	/* 1 bit reserved */
 	IWL_RX_HE_PHY_SIGB_DCM			= BIT_ULL(32 + 21),
 	IWL_RX_HE_PHY_PREAMBLE_PUNC_TYPE_MASK	= 0xc0000000000000ULL,
-	/* 8 bits reserved */
+	/* 4 bits reserved */
+	IWL_RX_HE_PHY_INFO_TYPE_MASK		= 0xf000000000000000ULL,
+	IWL_RX_HE_PHY_INFO_TYPE_SU		= 0x0,
+	IWL_RX_HE_PHY_INFO_TYPE_MU		= 0x1,
+	IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO	= 0x2,
+};
+
+enum iwl_rx_he_sigb_common0 {
+	/* the a1/a2/... is what the PHY/firmware calls the values */
+	IWL_RX_HE_SIGB_COMMON0_CH1_RU0		= 0x000000ff, /* a1 */
+	IWL_RX_HE_SIGB_COMMON0_CH1_RU2		= 0x0000ff00, /* a2 */
+	IWL_RX_HE_SIGB_COMMON0_CH2_RU0		= 0x00ff0000, /* b1 */
+	IWL_RX_HE_SIGB_COMMON0_CH2_RU2		= 0xff000000, /* b2 */
+};
+
+enum iwl_rx_he_sigb_common1 {
+	IWL_RX_HE_SIGB_COMMON1_CH1_RU1		= 0x000000ff, /* c1 */
+	IWL_RX_HE_SIGB_COMMON1_CH1_RU3		= 0x0000ff00, /* c2 */
+	IWL_RX_HE_SIGB_COMMON1_CH2_RU1		= 0x00ff0000, /* d1 */
+	IWL_RX_HE_SIGB_COMMON1_CH2_RU3		= 0xff000000, /* d2 */
+};
+
+enum iwl_rx_he_sigb_common2 {
+	IWL_RX_HE_SIGB_COMMON2_CH1_CTR_RU	= 0x0001,
+	IWL_RX_HE_SIGB_COMMON2_CH2_CTR_RU	= 0x0002,
+	IWL_RX_HE_SIGB_COMMON2_CH1_CRC_OK	= 0x0004,
+	IWL_RX_HE_SIGB_COMMON2_CH2_CRC_OK	= 0x0008,
 };
 
 /**
@@ -381,15 +407,31 @@ enum iwl_rx_he_phy {
  */
 struct iwl_rx_mpdu_desc_v1 {
 	/* DW7 - carries rss_hash only when rpa_en == 1 */
-	/**
-	 * @rss_hash: RSS hash value
-	 */
-	__le32 rss_hash;
+	union {
+		/**
+		 * @rss_hash: RSS hash value
+		 */
+		__le32 rss_hash;
+
+		/**
+		 * @sigb_common0: for HE sniffer, HE-SIG-B common part 0
+		 */
+		__le32 sigb_common0;
+	};
+
 	/* DW8 - carries filter_match only when rpa_en == 1 */
-	/**
-	 * @filter_match: filter match value
-	 */
-	__le32 filter_match;
+	union {
+		/**
+		 * @filter_match: filter match value
+		 */
+		__le32 filter_match;
+
+		/**
+		 * @sigb_common1: for HE sniffer, HE-SIG-B common part 1
+		 */
+		__le32 sigb_common1;
+	};
+
 	/* DW9 */
 	/**
 	 * @rate_n_flags: RX rate/flags encoding
@@ -439,15 +481,30 @@ struct iwl_rx_mpdu_desc_v1 {
  */
 struct iwl_rx_mpdu_desc_v3 {
 	/* DW7 - carries filter_match only when rpa_en == 1 */
-	/**
-	 * @filter_match: filter match value
-	 */
-	__le32 filter_match;
+	union {
+		/**
+		 * @filter_match: filter match value
+		 */
+		__le32 filter_match;
+
+		/**
+		 * @sigb_common0: for HE sniffer, HE-SIG-B common part 0
+		 */
+		__le32 sigb_common0;
+	};
+
 	/* DW8 - carries rss_hash only when rpa_en == 1 */
-	/**
-	 * @rss_hash: RSS hash value
-	 */
-	__le32 rss_hash;
+	union {
+		/**
+		 * @rss_hash: RSS hash value
+		 */
+		__le32 rss_hash;
+
+		/**
+		 * @sigb_common1: for HE sniffer, HE-SIG-B common part 1
+		 */
+		__le32 sigb_common1;
+	};
 	/* DW9 */
 	/**
 	 * @partial_hash: 31:0 ip/tcp header hash
@@ -539,14 +596,24 @@ struct iwl_rx_mpdu_desc {
 	 */
 	u8 mac_phy_idx;
 	/* DW4 - carries csum data only when rpa_en == 1 */
-	/**
-	 * @raw_csum: raw checksum (alledgedly unreliable)
-	 */
-	__le16 raw_csum;
-	/**
-	 * @l3l4_flags: &enum iwl_rx_l3l4_flags
-	 */
-	__le16 l3l4_flags;
+	struct {
+		/**
+		 * @raw_csum: raw checksum (alledgedly unreliable)
+		 */
+		__le16 raw_csum;
+
+		union {
+			/**
+			 * @l3l4_flags: &enum iwl_rx_l3l4_flags
+			 */
+			__le16 l3l4_flags;
+
+			/**
+			 * @sigb_common2: for HE sniffer, HE-SIG-B common part 2
+			 */
+			__le16 sigb_common2;
+		};
+	};
 	/* DW5 */
 	/**
 	 * @status: &enum iwl_rx_mpdu_status
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 968f1c372f1c..fd66ea7c4b66 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -856,6 +856,64 @@ static void iwl_mvm_flip_address(u8 *addr)
 	ether_addr_copy(addr, mac_addr);
 }
 
+static void iwl_mvm_decode_he_sigb(struct iwl_mvm *mvm,
+				   struct iwl_rx_mpdu_desc *desc,
+				   struct ieee80211_radiotap_he_mu *he_mu)
+{
+	u32 sigb0, sigb1;
+	u16 sigb2;
+
+	if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
+		sigb0 = le32_to_cpu(desc->v3.sigb_common0);
+		sigb1 = le32_to_cpu(desc->v3.sigb_common1);
+	} else {
+		sigb0 = le32_to_cpu(desc->v1.sigb_common0);
+		sigb1 = le32_to_cpu(desc->v1.sigb_common1);
+	}
+
+	sigb2 = le16_to_cpu(desc->sigb_common2);
+
+	if (FIELD_GET(IWL_RX_HE_SIGB_COMMON2_CH1_CRC_OK, sigb2)) {
+		he_mu->flags1 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_MU_FLAGS1_CH1_RU_KNOWN |
+				    IEEE80211_RADIOTAP_HE_MU_FLAGS1_CH1_CTR_26T_RU_KNOWN);
+
+		he_mu->flags1 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_SIGB_COMMON2_CH1_CTR_RU,
+						   sigb2),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_CH1_CTR_26T_RU);
+
+		he_mu->ru_ch1[0] = FIELD_GET(IWL_RX_HE_SIGB_COMMON0_CH1_RU0,
+					     sigb0);
+		he_mu->ru_ch1[1] = FIELD_GET(IWL_RX_HE_SIGB_COMMON1_CH1_RU1,
+					     sigb1);
+		he_mu->ru_ch1[2] = FIELD_GET(IWL_RX_HE_SIGB_COMMON0_CH1_RU2,
+					     sigb0);
+		he_mu->ru_ch1[3] = FIELD_GET(IWL_RX_HE_SIGB_COMMON1_CH1_RU3,
+					     sigb1);
+	}
+
+	if (FIELD_GET(IWL_RX_HE_SIGB_COMMON2_CH2_CRC_OK, sigb2)) {
+		he_mu->flags1 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_MU_FLAGS1_CH2_RU_KNOWN |
+				    IEEE80211_RADIOTAP_HE_MU_FLAGS1_CH2_CTR_26T_RU_KNOWN);
+
+		he_mu->flags2 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_SIGB_COMMON2_CH2_CTR_RU,
+						   sigb2),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_CH2_CTR_26T_RU);
+
+		he_mu->ru_ch2[0] = FIELD_GET(IWL_RX_HE_SIGB_COMMON0_CH2_RU0,
+					     sigb0);
+		he_mu->ru_ch2[1] = FIELD_GET(IWL_RX_HE_SIGB_COMMON1_CH2_RU1,
+					     sigb1);
+		he_mu->ru_ch2[2] = FIELD_GET(IWL_RX_HE_SIGB_COMMON0_CH2_RU2,
+					     sigb0);
+		he_mu->ru_ch2[3] = FIELD_GET(IWL_RX_HE_SIGB_COMMON1_CH2_RU3,
+					     sigb1);
+	}
+}
+
 static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 			  struct iwl_rx_mpdu_desc *desc,
 			  u32 rate_n_flags, u16 phy_info, int queue)
@@ -882,10 +940,12 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 				      IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_DCM_KNOWN |
 				      IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_SYMS_USERS_KNOWN |
 				      IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_COMP_KNOWN),
-		.flags2 = cpu_to_le16(IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW_KNOWN),
+		.flags2 = cpu_to_le16(IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW_KNOWN |
+				      IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW_KNOWN),
 	};
 	unsigned int radiotap_len = 0;
 	bool overload = phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD;
+	bool sigb_data = false;
 
 	he = skb_put_data(skb, &known, sizeof(known));
 	radiotap_len += sizeof(known);
@@ -943,17 +1003,26 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_COMP);
 		he_mu->flags2 |=
 			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_PREAMBLE_PUNC_TYPE_MASK,
-						  he_phy_data),
+						   he_phy_data),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW);
-	}
 
-	if (he_phy_data != HE_PHY_DATA_INVAL) {
-		he->data1 |=
-			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN);
-		he->data3 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_BSS_COLOR_MASK,
-						  he_phy_data),
-					 IEEE80211_RADIOTAP_HE_DATA3_BSS_COLOR);
+		sigb_data = FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK,
+				      he_phy_data) ==
+				IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO;
+		if (sigb_data)
+			iwl_mvm_decode_he_sigb(mvm, desc, he_mu);
+	}
+	if (he_phy_data != HE_PHY_DATA_INVAL &&
+	    (he_type == RATE_MCS_HE_TYPE_SU ||
+	     he_type == RATE_MCS_HE_TYPE_MU)) {
+		u8 bss_color = FIELD_GET(IWL_RX_HE_PHY_BSS_COLOR_MASK,
+					 he_phy_data);
+
+		if (bss_color) {
+			he->data1 |=
+				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN);
+			he->data3 |= cpu_to_le16(bss_color);
+		}
 	}
 
 	/* update aggregation data for monitor sake on default queue */
@@ -977,6 +1046,7 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 		rx_status->bw = RATE_INFO_BW_HE_RU;
 		rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_106;
 	}
+
 	if (he_mu) {
 		/*
 		 * Unfortunately, we have to leave the mac80211 data
@@ -992,6 +1062,9 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 		rx_status->bw = RATE_INFO_BW_HE_RU;
 
+		he->data1 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BW_RU_ALLOC_KNOWN);
+
 		switch (ru) {
 		case 0 ... 36:
 			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_26;
@@ -1025,10 +1098,24 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 					 IEEE80211_RADIOTAP_HE_DATA2_RU_OFFSET);
 		he->data2 |=
 			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_KNOWN);
-		if (he_phy_data & IWL_RX_HE_PHY_RU_ALLOC_SEC80)
+		if (he_phy_data & IWL_RX_HE_PHY_RU_ALLOC_SEC80) {
 			he->data2 |=
 				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_SEC);
-	} else if (he) {
+
+#define CHECK_BW(bw) \
+	BUILD_BUG_ON(IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW_ ## bw ## MHZ != \
+		     RATE_MCS_CHAN_WIDTH_##bw >> RATE_MCS_CHAN_WIDTH_POS)
+			CHECK_BW(20);
+			CHECK_BW(40);
+			CHECK_BW(80);
+			CHECK_BW(160);
+			he_mu->flags2 |=
+				le16_encode_bits(FIELD_GET(RATE_MCS_CHAN_WIDTH_MSK,
+							   rate_n_flags),
+						 IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW);
+		}
+	} else if (he_type == RATE_MCS_HE_TYPE_SU ||
+		   he_type == RATE_MCS_HE_TYPE_EXT_SU) {
 		he->data1 |=
 			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BW_RU_ALLOC_KNOWN);
 	}
@@ -1195,6 +1282,21 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	rx_status = IEEE80211_SKB_RXCB(skb);
 
+	/* This may be overridden by iwl_mvm_rx_he() to HE_RU */
+	switch (rate_n_flags & RATE_MCS_CHAN_WIDTH_MSK) {
+	case RATE_MCS_CHAN_WIDTH_20:
+		break;
+	case RATE_MCS_CHAN_WIDTH_40:
+		rx_status->bw = RATE_INFO_BW_40;
+		break;
+	case RATE_MCS_CHAN_WIDTH_80:
+		rx_status->bw = RATE_INFO_BW_80;
+		break;
+	case RATE_MCS_CHAN_WIDTH_160:
+		rx_status->bw = RATE_INFO_BW_160;
+		break;
+	}
+
 	if (rate_n_flags & RATE_MCS_HE_MSK)
 		iwl_mvm_rx_he(mvm, skb, desc, rate_n_flags, phy_info, queue);
 
@@ -1366,20 +1468,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		}
 	}
 
-	switch (rate_n_flags & RATE_MCS_CHAN_WIDTH_MSK) {
-	case RATE_MCS_CHAN_WIDTH_20:
-		break;
-	case RATE_MCS_CHAN_WIDTH_40:
-		rx_status->bw = RATE_INFO_BW_40;
-		break;
-	case RATE_MCS_CHAN_WIDTH_80:
-		rx_status->bw = RATE_INFO_BW_80;
-		break;
-	case RATE_MCS_CHAN_WIDTH_160:
-		rx_status->bw = RATE_INFO_BW_160;
-		break;
-	}
-
 	if (!(rate_n_flags & RATE_MCS_CCK_MSK) &&
 	    rate_n_flags & RATE_MCS_SGI_MSK)
 		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
-- 
2.18.0
