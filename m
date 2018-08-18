Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42176 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726417AbeHRLfK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 07:35:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 18 Aug 2018 11:27:46 +0300
Message-Id: <20180818082750.28717-13-luca@coelho.fi> (sfid-20180818_102829_553138_E9A58EC2)
In-Reply-To: <20180818082750.28717-1-luca@coelho.fi>
References: <20180818082750.28717-1-luca@coelho.fi>
Subject: [PATCH 12/16] iwlwifi: mvm: move he RX handling to a separate function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The HE code is bloating the RX handling, and makes it too big.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 582 +++++++++---------
 1 file changed, 286 insertions(+), 296 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 311c639e23de..968f1c372f1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -856,6 +856,289 @@ static void iwl_mvm_flip_address(u8 *addr)
 	ether_addr_copy(addr, mac_addr);
 }
 
+static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
+			  struct iwl_rx_mpdu_desc *desc,
+			  u32 rate_n_flags, u16 phy_info, int queue)
+{
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
+	/* this is invalid e.g. because puncture type doesn't allow 0b11 */
+#define HE_PHY_DATA_INVAL ((u64)-1)
+	u64 he_phy_data = HE_PHY_DATA_INVAL;
+	struct ieee80211_radiotap_he *he = NULL;
+	struct ieee80211_radiotap_he_mu *he_mu = NULL;
+	u32 he_type = 0xffffffff;
+	u8 stbc;
+
+	static const struct ieee80211_radiotap_he known = {
+		.data1 = cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_DATA_MCS_KNOWN |
+				     IEEE80211_RADIOTAP_HE_DATA1_DATA_DCM_KNOWN |
+				     IEEE80211_RADIOTAP_HE_DATA1_STBC_KNOWN |
+				     IEEE80211_RADIOTAP_HE_DATA1_CODING_KNOWN),
+		.data2 = cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_GI_KNOWN |
+				     IEEE80211_RADIOTAP_HE_DATA2_TXBF_KNOWN),
+	};
+	static const struct ieee80211_radiotap_he_mu mu_known = {
+		.flags1 = cpu_to_le16(IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_MCS_KNOWN |
+				      IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_DCM_KNOWN |
+				      IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_SYMS_USERS_KNOWN |
+				      IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_COMP_KNOWN),
+		.flags2 = cpu_to_le16(IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW_KNOWN),
+	};
+	unsigned int radiotap_len = 0;
+	bool overload = phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD;
+
+	he = skb_put_data(skb, &known, sizeof(known));
+	radiotap_len += sizeof(known);
+	rx_status->flag |= RX_FLAG_RADIOTAP_HE;
+
+	he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
+
+	if (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD) {
+		if (mvm->trans->cfg->device_family >=
+				IWL_DEVICE_FAMILY_22560)
+			he_phy_data = le64_to_cpu(desc->v3.he_phy_data);
+		else
+			he_phy_data = le64_to_cpu(desc->v1.he_phy_data);
+
+		if (he_type == RATE_MCS_HE_TYPE_MU) {
+			he_mu = skb_put_data(skb, &mu_known,
+					     sizeof(mu_known));
+			radiotap_len += sizeof(mu_known);
+			rx_status->flag |= RX_FLAG_RADIOTAP_HE_MU;
+		}
+	}
+
+	/* temporarily hide the radiotap data */
+	__skb_pull(skb, radiotap_len);
+
+	if (overload && he_type == RATE_MCS_HE_TYPE_SU) {
+		he->data1 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN);
+		if (FIELD_GET(IWL_RX_HE_PHY_UPLINK, he_phy_data))
+			he->data3 |=
+				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
+
+		if (!queue && !(phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
+			rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
+			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
+			if (FIELD_GET(IWL_RX_HE_PHY_DELIM_EOF, he_phy_data))
+				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
+		}
+	} else if (overload && he_mu && he_phy_data != HE_PHY_DATA_INVAL) {
+		he_mu->flags1 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SIBG_SYM_OR_USER_NUM_MASK,
+						  he_phy_data),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_SYMS_USERS);
+		he_mu->flags1 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SIGB_DCM,
+						  he_phy_data),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_DCM);
+		he_mu->flags1 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SIGB_MCS_MASK,
+						  he_phy_data),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_MCS);
+		he_mu->flags2 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SIGB_COMPRESSION,
+						  he_phy_data),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_COMP);
+		he_mu->flags2 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_PREAMBLE_PUNC_TYPE_MASK,
+						  he_phy_data),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW);
+	}
+
+	if (he_phy_data != HE_PHY_DATA_INVAL) {
+		he->data1 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN);
+		he->data3 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_BSS_COLOR_MASK,
+						  he_phy_data),
+					 IEEE80211_RADIOTAP_HE_DATA3_BSS_COLOR);
+	}
+
+	/* update aggregation data for monitor sake on default queue */
+	if (!queue && (phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
+		bool toggle_bit = phy_info & IWL_RX_MPDU_PHY_AMPDU_TOGGLE;
+
+		/* toggle is switched whenever new aggregation starts */
+		if (toggle_bit != mvm->ampdu_toggle &&
+		    he_phy_data != HE_PHY_DATA_INVAL &&
+		    (he_type == RATE_MCS_HE_TYPE_MU ||
+		     he_type == RATE_MCS_HE_TYPE_SU)) {
+			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
+			if (FIELD_GET(IWL_RX_HE_PHY_DELIM_EOF,
+				      he_phy_data))
+				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
+		}
+	}
+
+	if (he_type == RATE_MCS_HE_TYPE_EXT_SU &&
+	    rate_n_flags & RATE_MCS_HE_106T_MSK) {
+		rx_status->bw = RATE_INFO_BW_HE_RU;
+		rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_106;
+	}
+	if (he_mu) {
+		/*
+		 * Unfortunately, we have to leave the mac80211 data
+		 * incorrect for the case that we receive an HE-MU
+		 * transmission and *don't* have the he_mu pointer,
+		 * i.e. we don't have the phy data (due to the bits
+		 * being used for TSF). This shouldn't happen though
+		 * as management frames where we need the TSF/timers
+		 * are not be transmitted in HE-MU, I think.
+		 */
+		u8 ru = FIELD_GET(IWL_RX_HE_PHY_RU_ALLOC_MASK, he_phy_data);
+		u8 offs = 0;
+
+		rx_status->bw = RATE_INFO_BW_HE_RU;
+
+		switch (ru) {
+		case 0 ... 36:
+			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_26;
+			offs = ru;
+			break;
+		case 37 ... 52:
+			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_52;
+			offs = ru - 37;
+			break;
+		case 53 ... 60:
+			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_106;
+			offs = ru - 53;
+			break;
+		case 61 ... 64:
+			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_242;
+			offs = ru - 61;
+			break;
+		case 65 ... 66:
+			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_484;
+			offs = ru - 65;
+			break;
+		case 67:
+			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_996;
+			break;
+		case 68:
+			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_2x996;
+			break;
+		}
+		he->data2 |=
+			le16_encode_bits(offs,
+					 IEEE80211_RADIOTAP_HE_DATA2_RU_OFFSET);
+		he->data2 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_KNOWN);
+		if (he_phy_data & IWL_RX_HE_PHY_RU_ALLOC_SEC80)
+			he->data2 |=
+				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_SEC);
+	} else if (he) {
+		he->data1 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BW_RU_ALLOC_KNOWN);
+	}
+
+	stbc = (rate_n_flags & RATE_MCS_STBC_MSK) >> RATE_MCS_STBC_POS;
+	rx_status->nss =
+		((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
+					RATE_VHT_MCS_NSS_POS) + 1;
+	rx_status->rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
+	rx_status->encoding = RX_ENC_HE;
+	rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
+	if (rate_n_flags & RATE_MCS_BF_MSK)
+		rx_status->enc_flags |= RX_ENC_FLAG_BF;
+
+	rx_status->he_dcm =
+		!!(rate_n_flags & RATE_HE_DUAL_CARRIER_MODE_MSK);
+
+#define CHECK_TYPE(F)							\
+	BUILD_BUG_ON(IEEE80211_RADIOTAP_HE_DATA1_FORMAT_ ## F !=	\
+		     (RATE_MCS_HE_TYPE_ ## F >> RATE_MCS_HE_TYPE_POS))
+
+	CHECK_TYPE(SU);
+	CHECK_TYPE(EXT_SU);
+	CHECK_TYPE(MU);
+	CHECK_TYPE(TRIG);
+
+	he->data1 |= cpu_to_le16(he_type >> RATE_MCS_HE_TYPE_POS);
+
+	if (rate_n_flags & RATE_MCS_BF_POS)
+		he->data5 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA5_TXBF);
+
+	switch ((rate_n_flags & RATE_MCS_HE_GI_LTF_MSK) >>
+		RATE_MCS_HE_GI_LTF_POS) {
+	case 0:
+		rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
+		break;
+	case 1:
+		rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
+		break;
+	case 2:
+		rx_status->he_gi = NL80211_RATE_INFO_HE_GI_1_6;
+		break;
+	case 3:
+		if (rate_n_flags & RATE_MCS_SGI_MSK)
+			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
+		else
+			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_3_2;
+		break;
+	}
+
+	switch (he_type) {
+	case RATE_MCS_HE_TYPE_SU: {
+		u16 val;
+
+		/* LTF syms correspond to streams */
+		he->data2 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_NUM_LTF_SYMS_KNOWN);
+		switch (rx_status->nss) {
+		case 1:
+			val = 0;
+			break;
+		case 2:
+			val = 1;
+			break;
+		case 3:
+		case 4:
+			val = 2;
+			break;
+		case 5:
+		case 6:
+			val = 3;
+			break;
+		case 7:
+		case 8:
+			val = 4;
+			break;
+		default:
+			WARN_ONCE(1, "invalid nss: %d\n",
+				  rx_status->nss);
+			val = 0;
+		}
+		he->data5 |=
+			le16_encode_bits(val,
+					 IEEE80211_RADIOTAP_HE_DATA5_NUM_LTF_SYMS);
+		}
+		break;
+	case RATE_MCS_HE_TYPE_MU: {
+		u16 val;
+
+		if (he_phy_data == HE_PHY_DATA_INVAL)
+			break;
+
+		val = FIELD_GET(IWL_RX_HE_PHY_HE_LTF_NUM_MASK,
+				he_phy_data);
+
+		he->data2 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_NUM_LTF_SYMS_KNOWN);
+		he->data5 |=
+			cpu_to_le16(FIELD_PREP(
+				IEEE80211_RADIOTAP_HE_DATA5_NUM_LTF_SYMS,
+				val));
+		}
+		break;
+	case RATE_MCS_HE_TYPE_EXT_SU:
+	case RATE_MCS_HE_TYPE_TRIG:
+		/* not supported */
+		break;
+	}
+}
+
 void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb, int queue)
 {
@@ -869,12 +1152,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	struct ieee80211_sta *sta = NULL;
 	struct sk_buff *skb;
 	u8 crypt_len = 0, channel, energy_a, energy_b;
-	struct ieee80211_radiotap_he *he = NULL;
-	struct ieee80211_radiotap_he_mu *he_mu = NULL;
-	u32 he_type = 0xffffffff;
-	/* this is invalid e.g. because puncture type doesn't allow 0b11 */
-#define HE_PHY_DATA_INVAL ((u64)-1)
-	u64 he_phy_data = HE_PHY_DATA_INVAL;
 	size_t desc_size;
 
 	if (unlikely(test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)))
@@ -918,48 +1195,8 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	rx_status = IEEE80211_SKB_RXCB(skb);
 
-	if (rate_n_flags & RATE_MCS_HE_MSK) {
-		static const struct ieee80211_radiotap_he known = {
-			.data1 = cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_DATA_MCS_KNOWN |
-					     IEEE80211_RADIOTAP_HE_DATA1_DATA_DCM_KNOWN |
-					     IEEE80211_RADIOTAP_HE_DATA1_STBC_KNOWN |
-					     IEEE80211_RADIOTAP_HE_DATA1_CODING_KNOWN),
-			.data2 = cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_GI_KNOWN |
-					     IEEE80211_RADIOTAP_HE_DATA2_TXBF_KNOWN),
-		};
-		static const struct ieee80211_radiotap_he_mu mu_known = {
-			.flags1 = cpu_to_le16(IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_MCS_KNOWN |
-					      IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_DCM_KNOWN |
-					      IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_SYMS_USERS_KNOWN |
-					      IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_COMP_KNOWN),
-			.flags2 = cpu_to_le16(IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW_KNOWN),
-		};
-		unsigned int radiotap_len = 0;
-
-		he = skb_put_data(skb, &known, sizeof(known));
-		radiotap_len += sizeof(known);
-		rx_status->flag |= RX_FLAG_RADIOTAP_HE;
-
-		he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
-
-		if (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD) {
-			if (mvm->trans->cfg->device_family >=
-			    IWL_DEVICE_FAMILY_22560)
-				he_phy_data = le64_to_cpu(desc->v3.he_phy_data);
-			else
-				he_phy_data = le64_to_cpu(desc->v1.he_phy_data);
-
-			if (he_type == RATE_MCS_HE_TYPE_MU) {
-				he_mu = skb_put_data(skb, &mu_known,
-						     sizeof(mu_known));
-				radiotap_len += sizeof(mu_known);
-				rx_status->flag |= RX_FLAG_RADIOTAP_HE_MU;
-			}
-		}
-
-		/* temporarily hide the radiotap data */
-		__skb_pull(skb, radiotap_len);
-	}
+	if (rate_n_flags & RATE_MCS_HE_MSK)
+		iwl_mvm_rx_he(mvm, skb, desc, rate_n_flags, phy_info, queue);
 
 	rx_status = IEEE80211_SKB_RXCB(skb);
 
@@ -995,65 +1232,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		rx_status->mactime = tsf_on_air_rise;
 		/* TSF as indicated by the firmware is at INA time */
 		rx_status->flag |= RX_FLAG_MACTIME_PLCP_START;
-	} else if (he_type == RATE_MCS_HE_TYPE_SU) {
-		u64 he_phy_data;
-
-		if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
-			he_phy_data = le64_to_cpu(desc->v3.he_phy_data);
-		else
-			he_phy_data = le64_to_cpu(desc->v1.he_phy_data);
-
-		he->data1 |=
-			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN);
-		if (FIELD_GET(IWL_RX_HE_PHY_UPLINK,
-			      he_phy_data))
-			he->data3 |=
-				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
-
-		if (!queue && !(phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
-			rx_status->ampdu_reference = mvm->ampdu_ref;
-			mvm->ampdu_ref++;
-
-			rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
-			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
-			if (FIELD_GET(IWL_RX_HE_PHY_DELIM_EOF,
-				      he_phy_data))
-				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
-		}
-	} else if (he_mu && he_phy_data != HE_PHY_DATA_INVAL) {
-		he_mu->flags1 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SIBG_SYM_OR_USER_NUM_MASK,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_SYMS_USERS);
-		he_mu->flags1 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SIGB_DCM,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_DCM);
-		he_mu->flags1 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SIGB_MCS_MASK,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_MCS);
-		he_mu->flags2 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SIGB_COMPRESSION,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_COMP);
-		he_mu->flags2 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_PREAMBLE_PUNC_TYPE_MASK,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW);
-	}
-
-	if (he_phy_data != HE_PHY_DATA_INVAL &&
-	    (he_type == RATE_MCS_HE_TYPE_SU ||
-	     he_type == RATE_MCS_HE_TYPE_MU)) {
-		u8 bss_color = FIELD_GET(IWL_RX_HE_PHY_BSS_COLOR_MASK,
-					 he_phy_data);
-
-		if (bss_color) {
-			he->data1 |=
-				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN);
-			he->data3 |= cpu_to_le16(bss_color);
-		}
 	}
 
 	rx_status->device_timestamp = gp2_on_air_rise;
@@ -1080,16 +1258,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		if (toggle_bit != mvm->ampdu_toggle) {
 			mvm->ampdu_ref++;
 			mvm->ampdu_toggle = toggle_bit;
-
-			if (he_phy_data != HE_PHY_DATA_INVAL &&
-			    (he_type == RATE_MCS_HE_TYPE_MU ||
-			     he_type == RATE_MCS_HE_TYPE_SU)) {
-				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
-				if (FIELD_GET(IWL_RX_HE_PHY_DELIM_EOF,
-					      he_phy_data))
-					rx_status->flag |=
-						RX_FLAG_AMPDU_EOF_BIT;
-			}
 		}
 	}
 
@@ -1212,70 +1380,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		break;
 	}
 
-	if (he_type == RATE_MCS_HE_TYPE_EXT_SU &&
-	    rate_n_flags & RATE_MCS_HE_106T_MSK) {
-		rx_status->bw = RATE_INFO_BW_HE_RU;
-		rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_106;
-	}
-
-	if (rate_n_flags & RATE_MCS_HE_MSK &&
-	    phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD &&
-	    he_type == RATE_MCS_HE_TYPE_MU) {
-		/*
-		 * Unfortunately, we have to leave the mac80211 data
-		 * incorrect for the case that we receive an HE-MU
-		 * transmission and *don't* have the he_mu pointer,
-		 * i.e. we don't have the phy data (due to the bits
-		 * being used for TSF). This shouldn't happen though
-		 * as management frames where we need the TSF/timers
-		 * are not be transmitted in HE-MU, I think.
-		 */
-		u8 ru = FIELD_GET(IWL_RX_HE_PHY_RU_ALLOC_MASK, he_phy_data);
-		u8 offs = 0;
-
-		rx_status->bw = RATE_INFO_BW_HE_RU;
-
-		switch (ru) {
-		case 0 ... 36:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_26;
-			offs = ru;
-			break;
-		case 37 ... 52:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_52;
-			offs = ru - 37;
-			break;
-		case 53 ... 60:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_106;
-			offs = ru - 53;
-			break;
-		case 61 ... 64:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_242;
-			offs = ru - 61;
-			break;
-		case 65 ... 66:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_484;
-			offs = ru - 65;
-			break;
-		case 67:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_996;
-			break;
-		case 68:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_2x996;
-			break;
-		}
-		he->data2 |=
-			le16_encode_bits(offs,
-					 IEEE80211_RADIOTAP_HE_DATA2_RU_OFFSET);
-		he->data2 |=
-			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_KNOWN);
-		if (he_phy_data & IWL_RX_HE_PHY_RU_ALLOC_SEC80)
-			he->data2 |=
-				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_SEC);
-	} else if (he) {
-		he->data1 |=
-			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BW_RU_ALLOC_KNOWN);
-	}
-
 	if (!(rate_n_flags & RATE_MCS_CCK_MSK) &&
 	    rate_n_flags & RATE_MCS_SGI_MSK)
 		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
@@ -1300,120 +1404,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
 		if (rate_n_flags & RATE_MCS_BF_MSK)
 			rx_status->enc_flags |= RX_ENC_FLAG_BF;
-	} else if (he) {
-		u8 stbc = (rate_n_flags & RATE_MCS_STBC_MSK) >>
-				RATE_MCS_STBC_POS;
-		rx_status->nss =
-			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
-						RATE_VHT_MCS_NSS_POS) + 1;
-		rx_status->rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
-		rx_status->encoding = RX_ENC_HE;
-		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
-		if (rate_n_flags & RATE_MCS_BF_MSK)
-			rx_status->enc_flags |= RX_ENC_FLAG_BF;
-
-		rx_status->he_dcm =
-			!!(rate_n_flags & RATE_HE_DUAL_CARRIER_MODE_MSK);
-
-#define CHECK_TYPE(F)							\
-	BUILD_BUG_ON(IEEE80211_RADIOTAP_HE_DATA1_FORMAT_ ## F !=	\
-		     (RATE_MCS_HE_TYPE_ ## F >> RATE_MCS_HE_TYPE_POS))
-
-		CHECK_TYPE(SU);
-		CHECK_TYPE(EXT_SU);
-		CHECK_TYPE(MU);
-		CHECK_TYPE(TRIG);
-
-		he->data1 |= cpu_to_le16(he_type >> RATE_MCS_HE_TYPE_POS);
-
-		if (rate_n_flags & RATE_MCS_BF_POS)
-			he->data5 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA5_TXBF);
-
-		switch ((rate_n_flags & RATE_MCS_HE_GI_LTF_MSK) >>
-			RATE_MCS_HE_GI_LTF_POS) {
-		case 0:
-			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
-			break;
-		case 1:
-			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
-			break;
-		case 2:
-			rx_status->he_gi = NL80211_RATE_INFO_HE_GI_1_6;
-			break;
-		case 3:
-			if (rate_n_flags & RATE_MCS_SGI_MSK)
-				rx_status->he_gi = NL80211_RATE_INFO_HE_GI_0_8;
-			else
-				rx_status->he_gi = NL80211_RATE_INFO_HE_GI_3_2;
-			break;
-		}
-
-		switch (he_type) {
-		case RATE_MCS_HE_TYPE_SU: {
-			u16 val;
-
-			/* LTF syms correspond to streams */
-			he->data2 |=
-				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_NUM_LTF_SYMS_KNOWN);
-			switch (rx_status->nss) {
-			case 1:
-				val = 0;
-				break;
-			case 2:
-				val = 1;
-				break;
-			case 3:
-			case 4:
-				val = 2;
-				break;
-			case 5:
-			case 6:
-				val = 3;
-				break;
-			case 7:
-			case 8:
-				val = 4;
-				break;
-			default:
-				WARN_ONCE(1, "invalid nss: %d\n",
-					  rx_status->nss);
-				val = 0;
-			}
-			he->data5 |=
-				le16_encode_bits(val,
-						 IEEE80211_RADIOTAP_HE_DATA5_NUM_LTF_SYMS);
-			}
-			break;
-		case RATE_MCS_HE_TYPE_MU: {
-			u16 val;
-			u64 he_phy_data;
-
-			if (mvm->trans->cfg->device_family >=
-			    IWL_DEVICE_FAMILY_22560)
-				he_phy_data = le64_to_cpu(desc->v3.he_phy_data);
-			else
-				he_phy_data = le64_to_cpu(desc->v1.he_phy_data);
-
-			if (he_phy_data == HE_PHY_DATA_INVAL)
-				break;
-
-			val = FIELD_GET(IWL_RX_HE_PHY_HE_LTF_NUM_MASK,
-					he_phy_data);
-
-			he->data2 |=
-				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_NUM_LTF_SYMS_KNOWN);
-			he->data5 |=
-				cpu_to_le16(FIELD_PREP(
-					IEEE80211_RADIOTAP_HE_DATA5_NUM_LTF_SYMS,
-					val));
-			}
-			break;
-		case RATE_MCS_HE_TYPE_EXT_SU:
-		case RATE_MCS_HE_TYPE_TRIG:
-			/* not supported yet */
-			break;
-		}
-	} else {
+	} else if (!(rate_n_flags & RATE_MCS_HE_MSK)) {
 		int rate = iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
 							       rx_status->band);
 
@@ -1424,7 +1415,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			goto out;
 		}
 		rx_status->rate_idx = rate;
-
 	}
 
 	/* management stuff on default queue */
-- 
2.18.0
