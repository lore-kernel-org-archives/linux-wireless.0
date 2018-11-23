Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD14C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E4BC206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:27:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E4BC206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409650AbeKWWLC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:11:02 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38362 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2409641AbeKWWLC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:11:02 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bh-0008GU-IA; Fri, 23 Nov 2018 13:26:46 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:27 +0200
Message-Id: <20181123112631.29360-12-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/15] iwlwifi: mvm: change PHY data RX for HE radiotap
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

The firmware changed the PHY data API, so follow suit.
Some data is now available even for HT/VHT frames, so
the info type in the metadata was changed. This change
isn't backwards compatible, but
 1) the firmware with the old API was never released;
 2) the only overlap in the info type field is from the
    old type of TB to the new of HT, so this basically
    just means that with older FW and newer driver the
    data will be considered missing.

While at it, remove the extra code to set the LTF syms
corresponding to the streams and use the data from the
device instead - we don't really need this in any case
other than when we have it from the device.

As the new API gives use the spatial reuse 1-4 fields
for trigger-based PPDUs, also expose that to radiotap.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    | 190 +++++----
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 367 +++++++++---------
 2 files changed, 296 insertions(+), 261 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index 0537496b6eb1..8961227ff44d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -345,66 +345,98 @@ enum iwl_rx_mpdu_mac_info {
 	IWL_RX_MPDU_PHY_PHY_INDEX_MASK		= 0xf0,
 };
 
-/*
- * enum iwl_rx_he_phy - HE PHY data
- */
-enum iwl_rx_he_phy {
-	IWL_RX_HE_PHY_BEAM_CHNG			= BIT(0),
-	IWL_RX_HE_PHY_UPLINK			= BIT(1),
-	IWL_RX_HE_PHY_BSS_COLOR_MASK		= 0xfc,
-	IWL_RX_HE_PHY_SPATIAL_REUSE_MASK	= 0xf00,
-	IWL_RX_HE_PHY_SU_EXT_BW10		= BIT(12),
-	IWL_RX_HE_PHY_TXOP_DUR_MASK		= 0xfe000,
-	IWL_RX_HE_PHY_LDPC_EXT_SYM		= BIT(20),
-	IWL_RX_HE_PHY_PRE_FEC_PAD_MASK		= 0x600000,
-	IWL_RX_HE_PHY_PE_DISAMBIG		= BIT(23),
-	IWL_RX_HE_PHY_DOPPLER			= BIT(24),
+/* TSF overload low dword */
+enum iwl_rx_phy_data0 {
+	/* info type: HE any */
+	IWL_RX_PHY_DATA0_HE_BEAM_CHNG				= 0x00000001,
+	IWL_RX_PHY_DATA0_HE_UPLINK				= 0x00000002,
+	IWL_RX_PHY_DATA0_HE_BSS_COLOR_MASK			= 0x000000fc,
+	IWL_RX_PHY_DATA0_HE_SPATIAL_REUSE_MASK			= 0x00000f00,
+	/* 1 bit reserved */
+	IWL_RX_PHY_DATA0_HE_TXOP_DUR_MASK			= 0x000fe000,
+	IWL_RX_PHY_DATA0_HE_LDPC_EXT_SYM			= 0x00100000,
+	IWL_RX_PHY_DATA0_HE_PRE_FEC_PAD_MASK			= 0x00600000,
+	IWL_RX_PHY_DATA0_HE_PE_DISAMBIG				= 0x00800000,
+	IWL_RX_PHY_DATA0_HE_DOPPLER				= 0x01000000,
 	/* 6 bits reserved */
-	IWL_RX_HE_PHY_DELIM_EOF			= BIT(31),
+	IWL_RX_PHY_DATA0_HE_DELIM_EOF				= 0x80000000,
+};
+
+enum iwl_rx_phy_info_type {
+	IWL_RX_PHY_INFO_TYPE_NONE				= 0,
+	IWL_RX_PHY_INFO_TYPE_CCK				= 1,
+	IWL_RX_PHY_INFO_TYPE_OFDM_LGCY				= 2,
+	IWL_RX_PHY_INFO_TYPE_HT					= 3,
+	IWL_RX_PHY_INFO_TYPE_VHT_SU				= 4,
+	IWL_RX_PHY_INFO_TYPE_VHT_MU				= 5,
+	IWL_RX_PHY_INFO_TYPE_HE_SU				= 6,
+	IWL_RX_PHY_INFO_TYPE_HE_MU				= 7,
+	IWL_RX_PHY_INFO_TYPE_HE_TB				= 8,
+	IWL_RX_PHY_INFO_TYPE_HE_MU_EXT				= 9,
+	IWL_RX_PHY_INFO_TYPE_HE_TB_EXT				= 10,
+};
+
+/* TSF overload high dword */
+enum iwl_rx_phy_data1 {
+	/*
+	 * check this first - if TSF overload is set,
+	 * see &enum iwl_rx_phy_info_type
+	 */
+	IWL_RX_PHY_DATA1_INFO_TYPE_MASK				= 0xf0000000,
+
+	/* info type: HT/VHT/HE any */
+	IWL_RX_PHY_DATA1_LSIG_LEN_MASK				= 0x0fff0000,
 
-	/* second dword - common data */
-	IWL_RX_HE_PHY_HE_LTF_NUM_MASK		= 0xe000000000ULL,
-	IWL_RX_HE_PHY_RU_ALLOC_SEC80		= BIT_ULL(32 + 8),
+	/* info type: HE MU/MU-EXT */
+	IWL_RX_PHY_DATA1_HE_MU_SIGB_COMPRESSION			= 0x00000001,
+	IWL_RX_PHY_DATA1_HE_MU_SIBG_SYM_OR_USER_NUM_MASK	= 0x0000001e,
+
+	/* info type: HE any */
+	IWL_RX_PHY_DATA1_HE_LTF_NUM_MASK			= 0x000000e0,
+	IWL_RX_PHY_DATA1_HE_RU_ALLOC_SEC80			= 0x00000100,
 	/* trigger encoded */
-	IWL_RX_HE_PHY_RU_ALLOC_MASK		= 0xfe0000000000ULL,
-	IWL_RX_HE_PHY_INFO_TYPE_MASK		= 0xf000000000000000ULL,
-	IWL_RX_HE_PHY_INFO_TYPE_SU		= 0x0, /* TSF low valid (first DW) */
-	IWL_RX_HE_PHY_INFO_TYPE_MU		= 0x1, /* TSF low/high valid (both DWs) */
-	IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO	= 0x2, /* same + SIGB-common0/1/2 valid */
-	IWL_RX_HE_PHY_INFO_TYPE_TB		= 0x3, /* TSF low/high valid (both DWs) */
-
-	/* second dword - MU data */
-	IWL_RX_HE_PHY_MU_SIGB_COMPRESSION		= BIT_ULL(32 + 0),
-	IWL_RX_HE_PHY_MU_SIBG_SYM_OR_USER_NUM_MASK	= 0x1e00000000ULL,
-	IWL_RX_HE_PHY_MU_SIGB_MCS_MASK			= 0xf000000000000ULL,
-	IWL_RX_HE_PHY_MU_SIGB_DCM			= BIT_ULL(32 + 21),
-	IWL_RX_HE_PHY_MU_PREAMBLE_PUNC_TYPE_MASK	= 0xc0000000000000ULL,
-
-	/* second dword - TB data */
-	IWL_RX_HE_PHY_TB_PILOT_TYPE			= BIT_ULL(32 + 0),
-	IWL_RX_HE_PHY_TB_LOW_SS_MASK			= 0xe00000000ULL
+	IWL_RX_PHY_DATA1_HE_RU_ALLOC_MASK			= 0x0000fe00,
+
+	/* info type: HE TB/TX-EXT */
+	IWL_RX_PHY_DATA1_HE_TB_PILOT_TYPE			= 0x00000001,
+	IWL_RX_PHY_DATA1_HE_TB_LOW_SS_MASK			= 0x0000000e,
 };
 
-enum iwl_rx_he_sigb_common0 {
+/* goes into Metadata DW 7 */
+enum iwl_rx_phy_data2 {
+	/* info type: HE MU-EXT */
 	/* the a1/a2/... is what the PHY/firmware calls the values */
-	IWL_RX_HE_SIGB_COMMON0_CH1_RU0		= 0x000000ff, /* a1 */
-	IWL_RX_HE_SIGB_COMMON0_CH1_RU2		= 0x0000ff00, /* a2 */
-	IWL_RX_HE_SIGB_COMMON0_CH2_RU0		= 0x00ff0000, /* b1 */
-	IWL_RX_HE_SIGB_COMMON0_CH2_RU2		= 0xff000000, /* b2 */
+	IWL_RX_PHY_DATA2_HE_MU_EXT_CH1_RU0		= 0x000000ff, /* a1 */
+	IWL_RX_PHY_DATA2_HE_MU_EXT_CH1_RU2		= 0x0000ff00, /* a2 */
+	IWL_RX_PHY_DATA2_HE_MU_EXT_CH2_RU0		= 0x00ff0000, /* b1 */
+	IWL_RX_PHY_DATA2_HE_MU_EXT_CH2_RU2		= 0xff000000, /* b2 */
+
+	/* info type: HE TB-EXT */
+	IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE1		= 0x0000000f,
+	IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE2		= 0x000000f0,
+	IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE3		= 0x00000f00,
+	IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE4		= 0x0000f000,
 };
 
-enum iwl_rx_he_sigb_common1 {
-	IWL_RX_HE_SIGB_COMMON1_CH1_RU1		= 0x000000ff, /* c1 */
-	IWL_RX_HE_SIGB_COMMON1_CH1_RU3		= 0x0000ff00, /* c2 */
-	IWL_RX_HE_SIGB_COMMON1_CH2_RU1		= 0x00ff0000, /* d1 */
-	IWL_RX_HE_SIGB_COMMON1_CH2_RU3		= 0xff000000, /* d2 */
+/* goes into Metadata DW 8 */
+enum iwl_rx_phy_data3 {
+	/* info type: HE MU-EXT */
+	IWL_RX_PHY_DATA3_HE_MU_EXT_CH1_RU1		= 0x000000ff, /* c1 */
+	IWL_RX_PHY_DATA3_HE_MU_EXT_CH1_RU3		= 0x0000ff00, /* c2 */
+	IWL_RX_PHY_DATA3_HE_MU_EXT_CH2_RU1		= 0x00ff0000, /* d1 */
+	IWL_RX_PHY_DATA3_HE_MU_EXT_CH2_RU3		= 0xff000000, /* d2 */
 };
 
-enum iwl_rx_he_sigb_common2 {
-	IWL_RX_HE_SIGB_COMMON2_CH1_CTR_RU	= 0x0001,
-	IWL_RX_HE_SIGB_COMMON2_CH2_CTR_RU	= 0x0002,
-	IWL_RX_HE_SIGB_COMMON2_CH1_CRC_OK	= 0x0004,
-	IWL_RX_HE_SIGB_COMMON2_CH2_CRC_OK	= 0x0008,
+/* goes into Metadata DW 4 high 16 bits */
+enum iwl_rx_phy_data4 {
+	/* info type: HE MU-EXT */
+	IWL_RX_PHY_DATA4_HE_MU_EXT_CH1_CTR_RU			= 0x0001,
+	IWL_RX_PHY_DATA4_HE_MU_EXT_CH2_CTR_RU			= 0x0002,
+	IWL_RX_PHY_DATA4_HE_MU_EXT_CH1_CRC_OK			= 0x0004,
+	IWL_RX_PHY_DATA4_HE_MU_EXT_CH2_CRC_OK			= 0x0008,
+	IWL_RX_PHY_DATA4_HE_MU_EXT_SIGB_MCS_MASK		= 0x00f0,
+	IWL_RX_PHY_DATA4_HE_MU_EXT_SIGB_DCM			= 0x0100,
+	IWL_RX_PHY_DATA4_HE_MU_EXT_PREAMBLE_PUNC_TYPE_MASK	= 0x0600,
 };
 
 /**
@@ -419,9 +451,9 @@ struct iwl_rx_mpdu_desc_v1 {
 		__le32 rss_hash;
 
 		/**
-		 * @sigb_common0: for HE sniffer, HE-SIG-B common part 0
+		 * @phy_data2: depends on info type (see @phy_data1)
 		 */
-		__le32 sigb_common0;
+		__le32 phy_data2;
 	};
 
 	/* DW8 - carries filter_match only when rpa_en == 1 */
@@ -432,9 +464,9 @@ struct iwl_rx_mpdu_desc_v1 {
 		__le32 filter_match;
 
 		/**
-		 * @sigb_common1: for HE sniffer, HE-SIG-B common part 1
+		 * @phy_data3: depends on info type (see @phy_data1)
 		 */
-		__le32 sigb_common1;
+		__le32 phy_data3;
 	};
 
 	/* DW9 */
@@ -472,12 +504,19 @@ struct iwl_rx_mpdu_desc_v1 {
 		 * %IWL_RX_MPDU_PHY_TSF_OVERLOAD isn't set
 		 */
 		__le64 tsf_on_air_rise;
-		/**
-		 * @he_phy_data:
-		 * HE PHY data, see &enum iwl_rx_he_phy, valid
-		 * only if %IWL_RX_MPDU_PHY_TSF_OVERLOAD is set
-		 */
-		__le64 he_phy_data;
+
+		struct {
+			/**
+			 * @phy_data0: depends on info_type, see @phy_data1
+			 */
+			__le32 phy_data0;
+			/**
+			 * @phy_data1: valid only if
+			 * %IWL_RX_MPDU_PHY_TSF_OVERLOAD is set,
+			 * see &enum iwl_rx_phy_data1.
+			 */
+			__le32 phy_data1;
+		};
 	};
 } __packed;
 
@@ -493,9 +532,9 @@ struct iwl_rx_mpdu_desc_v3 {
 		__le32 filter_match;
 
 		/**
-		 * @sigb_common0: for HE sniffer, HE-SIG-B common part 0
+		 * @phy_data2: depends on info type (see @phy_data1)
 		 */
-		__le32 sigb_common0;
+		__le32 phy_data2;
 	};
 
 	/* DW8 - carries rss_hash only when rpa_en == 1 */
@@ -506,9 +545,9 @@ struct iwl_rx_mpdu_desc_v3 {
 		__le32 rss_hash;
 
 		/**
-		 * @sigb_common1: for HE sniffer, HE-SIG-B common part 1
+		 * @phy_data3: depends on info type (see @phy_data1)
 		 */
-		__le32 sigb_common1;
+		__le32 phy_data3;
 	};
 	/* DW9 */
 	/**
@@ -556,12 +595,19 @@ struct iwl_rx_mpdu_desc_v3 {
 		 * %IWL_RX_MPDU_PHY_TSF_OVERLOAD isn't set
 		 */
 		__le64 tsf_on_air_rise;
-		/**
-		 * @he_phy_data:
-		 * HE PHY data, see &enum iwl_rx_he_phy, valid
-		 * only if %IWL_RX_MPDU_PHY_TSF_OVERLOAD is set
-		 */
-		__le64 he_phy_data;
+
+		struct {
+			/**
+			 * @phy_data0: depends on info_type, see @phy_data1
+			 */
+			__le32 phy_data0;
+			/**
+			 * @phy_data1: valid only if
+			 * %IWL_RX_MPDU_PHY_TSF_OVERLOAD is set,
+			 * see &enum iwl_rx_phy_data1.
+			 */
+			__le32 phy_data1;
+		};
 	};
 	/* DW16 & DW17 */
 	/**
@@ -613,9 +659,9 @@ struct iwl_rx_mpdu_desc {
 		__le16 l3l4_flags;
 
 		/**
-		 * @sigb_common2: for HE sniffer, HE-SIG-B common part 2
+		 * @phy_data4: depends on info type, see phy_data1
 		 */
-		__le16 sigb_common2;
+		__le16 phy_data4;
 	};
 	/* DW5 */
 	/**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index d5ad390da8f0..d7f6b7aec981 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -863,68 +863,65 @@ static void iwl_mvm_flip_address(u8 *addr)
 	ether_addr_copy(addr, mac_addr);
 }
 
-static void iwl_mvm_decode_he_sigb(struct iwl_mvm *mvm,
-				   struct iwl_rx_mpdu_desc *desc,
-				   u32 rate_n_flags,
-				   struct ieee80211_radiotap_he_mu *he_mu)
+struct iwl_mvm_rx_phy_data {
+	__le32 d0, d1, d2, d3;
+	__le16 d4;
+};
+
+static void iwl_mvm_decode_he_mu_ext(struct iwl_mvm *mvm,
+				     struct iwl_mvm_rx_phy_data *phy_data,
+				     u32 rate_n_flags,
+				     struct ieee80211_radiotap_he_mu *he_mu)
 {
-	u32 sigb0, sigb1;
-	u16 sigb2;
+	u32 phy_data2 = le32_to_cpu(phy_data->d2);
+	u32 phy_data3 = le32_to_cpu(phy_data->d3);
+	u16 phy_data4 = le16_to_cpu(phy_data->d4);
 
-	if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
-		sigb0 = le32_to_cpu(desc->v3.sigb_common0);
-		sigb1 = le32_to_cpu(desc->v3.sigb_common1);
-	} else {
-		sigb0 = le32_to_cpu(desc->v1.sigb_common0);
-		sigb1 = le32_to_cpu(desc->v1.sigb_common1);
-	}
-
-	sigb2 = le16_to_cpu(desc->sigb_common2);
-
-	if (FIELD_GET(IWL_RX_HE_SIGB_COMMON2_CH1_CRC_OK, sigb2)) {
+	if (FIELD_GET(IWL_RX_PHY_DATA4_HE_MU_EXT_CH1_CRC_OK, phy_data4)) {
 		he_mu->flags1 |=
 			cpu_to_le16(IEEE80211_RADIOTAP_HE_MU_FLAGS1_CH1_RU_KNOWN |
 				    IEEE80211_RADIOTAP_HE_MU_FLAGS1_CH1_CTR_26T_RU_KNOWN);
 
 		he_mu->flags1 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_SIGB_COMMON2_CH1_CTR_RU,
-						   sigb2),
+			le16_encode_bits(FIELD_GET(IWL_RX_PHY_DATA4_HE_MU_EXT_CH1_CTR_RU,
+						   phy_data4),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_CH1_CTR_26T_RU);
 
-		he_mu->ru_ch1[0] = FIELD_GET(IWL_RX_HE_SIGB_COMMON0_CH1_RU0,
-					     sigb0);
-		he_mu->ru_ch1[1] = FIELD_GET(IWL_RX_HE_SIGB_COMMON1_CH1_RU1,
-					     sigb1);
-		he_mu->ru_ch1[2] = FIELD_GET(IWL_RX_HE_SIGB_COMMON0_CH1_RU2,
-					     sigb0);
-		he_mu->ru_ch1[3] = FIELD_GET(IWL_RX_HE_SIGB_COMMON1_CH1_RU3,
-					     sigb1);
+		he_mu->ru_ch1[0] = FIELD_GET(IWL_RX_PHY_DATA2_HE_MU_EXT_CH1_RU0,
+					     phy_data2);
+		he_mu->ru_ch1[1] = FIELD_GET(IWL_RX_PHY_DATA3_HE_MU_EXT_CH1_RU1,
+					     phy_data3);
+		he_mu->ru_ch1[2] = FIELD_GET(IWL_RX_PHY_DATA2_HE_MU_EXT_CH1_RU2,
+					     phy_data2);
+		he_mu->ru_ch1[3] = FIELD_GET(IWL_RX_PHY_DATA3_HE_MU_EXT_CH1_RU3,
+					     phy_data3);
 	}
 
-	if (FIELD_GET(IWL_RX_HE_SIGB_COMMON2_CH2_CRC_OK, sigb2) &&
+	if (FIELD_GET(IWL_RX_PHY_DATA4_HE_MU_EXT_CH2_CRC_OK, phy_data4) &&
 	    (rate_n_flags & RATE_MCS_CHAN_WIDTH_MSK) != RATE_MCS_CHAN_WIDTH_20) {
 		he_mu->flags1 |=
 			cpu_to_le16(IEEE80211_RADIOTAP_HE_MU_FLAGS1_CH2_RU_KNOWN |
 				    IEEE80211_RADIOTAP_HE_MU_FLAGS1_CH2_CTR_26T_RU_KNOWN);
 
 		he_mu->flags2 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_SIGB_COMMON2_CH2_CTR_RU,
-						   sigb2),
+			le16_encode_bits(FIELD_GET(IWL_RX_PHY_DATA4_HE_MU_EXT_CH2_CTR_RU,
+						   phy_data4),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_CH2_CTR_26T_RU);
 
-		he_mu->ru_ch2[0] = FIELD_GET(IWL_RX_HE_SIGB_COMMON0_CH2_RU0,
-					     sigb0);
-		he_mu->ru_ch2[1] = FIELD_GET(IWL_RX_HE_SIGB_COMMON1_CH2_RU1,
-					     sigb1);
-		he_mu->ru_ch2[2] = FIELD_GET(IWL_RX_HE_SIGB_COMMON0_CH2_RU2,
-					     sigb0);
-		he_mu->ru_ch2[3] = FIELD_GET(IWL_RX_HE_SIGB_COMMON1_CH2_RU3,
-					     sigb1);
+		he_mu->ru_ch2[0] = FIELD_GET(IWL_RX_PHY_DATA2_HE_MU_EXT_CH2_RU0,
+					     phy_data2);
+		he_mu->ru_ch2[1] = FIELD_GET(IWL_RX_PHY_DATA3_HE_MU_EXT_CH2_RU1,
+					     phy_data3);
+		he_mu->ru_ch2[2] = FIELD_GET(IWL_RX_PHY_DATA2_HE_MU_EXT_CH2_RU2,
+					     phy_data2);
+		he_mu->ru_ch2[3] = FIELD_GET(IWL_RX_PHY_DATA3_HE_MU_EXT_CH2_RU3,
+					     phy_data3);
 	}
 }
 
 static void
-iwl_mvm_decode_he_phy_ru_alloc(u64 he_phy_data, u32 rate_n_flags,
+iwl_mvm_decode_he_phy_ru_alloc(struct iwl_mvm_rx_phy_data *phy_data,
+			       u32 rate_n_flags,
 			       struct ieee80211_radiotap_he *he,
 			       struct ieee80211_radiotap_he_mu *he_mu,
 			       struct ieee80211_rx_status *rx_status)
@@ -937,7 +934,7 @@ iwl_mvm_decode_he_phy_ru_alloc(u64 he_phy_data, u32 rate_n_flags,
 	 * happen though as management frames where we need
 	 * the TSF/timers are not be transmitted in HE-MU.
 	 */
-	u8 ru = FIELD_GET(IWL_RX_HE_PHY_RU_ALLOC_MASK, he_phy_data);
+	u8 ru = le32_get_bits(phy_data->d1, IWL_RX_PHY_DATA1_HE_RU_ALLOC_MASK);
 	u8 offs = 0;
 
 	rx_status->bw = RATE_INFO_BW_HE_RU;
@@ -976,7 +973,7 @@ iwl_mvm_decode_he_phy_ru_alloc(u64 he_phy_data, u32 rate_n_flags,
 				      IEEE80211_RADIOTAP_HE_DATA2_RU_OFFSET);
 	he->data2 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_KNOWN |
 				 IEEE80211_RADIOTAP_HE_DATA2_RU_OFFSET_KNOWN);
-	if (he_phy_data & IWL_RX_HE_PHY_RU_ALLOC_SEC80)
+	if (phy_data->d1 & cpu_to_le32(IWL_RX_PHY_DATA1_HE_RU_ALLOC_SEC80))
 		he->data2 |=
 			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_SEC);
 
@@ -996,106 +993,125 @@ iwl_mvm_decode_he_phy_ru_alloc(u64 he_phy_data, u32 rate_n_flags,
 }
 
 static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
-				       struct iwl_rx_mpdu_desc *desc,
+				       struct iwl_mvm_rx_phy_data *phy_data,
 				       struct ieee80211_radiotap_he *he,
 				       struct ieee80211_radiotap_he_mu *he_mu,
 				       struct ieee80211_rx_status *rx_status,
-				       u64 he_phy_data, u32 rate_n_flags,
-				       int queue)
+				       u32 rate_n_flags, int queue)
 {
-	u32 he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
-	bool sigb_data;
-	u16 d1known = IEEE80211_RADIOTAP_HE_DATA1_LDPC_XSYMSEG_KNOWN |
-		      IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN |
-		      IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE_KNOWN |
-		      IEEE80211_RADIOTAP_HE_DATA1_DOPPLER_KNOWN |
-		      IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN;
-	u16 d2known = IEEE80211_RADIOTAP_HE_DATA2_PRE_FEC_PAD_KNOWN |
-		      IEEE80211_RADIOTAP_HE_DATA2_PE_DISAMBIG_KNOWN |
-		      IEEE80211_RADIOTAP_HE_DATA2_TXOP_KNOWN;
-
-	he->data1 |= cpu_to_le16(d1known);
-	he->data2 |= cpu_to_le16(d2known);
-	he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_BSS_COLOR_MASK,
-						he_phy_data),
-				      IEEE80211_RADIOTAP_HE_DATA3_BSS_COLOR);
-	he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_UPLINK,
-						he_phy_data),
-				      IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
-	he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_LDPC_EXT_SYM,
-						he_phy_data),
-				      IEEE80211_RADIOTAP_HE_DATA3_LDPC_XSYMSEG);
-	he->data4 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SPATIAL_REUSE_MASK,
-						he_phy_data),
-				      IEEE80211_RADIOTAP_HE_DATA4_SU_MU_SPTL_REUSE);
-	he->data5 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_PRE_FEC_PAD_MASK,
-						he_phy_data),
-				      IEEE80211_RADIOTAP_HE_DATA5_PRE_FEC_PAD);
-	he->data5 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_PE_DISAMBIG,
-						he_phy_data),
-				      IEEE80211_RADIOTAP_HE_DATA5_PE_DISAMBIG);
-	he->data6 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_TXOP_DUR_MASK,
-						he_phy_data),
-				      IEEE80211_RADIOTAP_HE_DATA6_TXOP);
-	he->data6 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_DOPPLER,
-						he_phy_data),
-				      IEEE80211_RADIOTAP_HE_DATA6_DOPPLER);
-
-	switch (he_type) {
-	case RATE_MCS_HE_TYPE_MU:
+	enum iwl_rx_phy_info_type info_type;
+
+	info_type = le32_get_bits(phy_data->d1, IWL_RX_PHY_DATA1_INFO_TYPE_MASK);
+
+	switch (info_type) {
+	case IWL_RX_PHY_INFO_TYPE_NONE:
+	case IWL_RX_PHY_INFO_TYPE_CCK:
+	case IWL_RX_PHY_INFO_TYPE_OFDM_LGCY:
+		return;
+	case IWL_RX_PHY_INFO_TYPE_HT:
+	case IWL_RX_PHY_INFO_TYPE_VHT_SU:
+	case IWL_RX_PHY_INFO_TYPE_VHT_MU:
+		/* TODO: we have LSIG-LEN, where do we put it? */
+		return;
+	case IWL_RX_PHY_INFO_TYPE_HE_TB_EXT:
+		he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE_KNOWN |
+					 IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE2_KNOWN |
+					 IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE3_KNOWN |
+					 IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE4_KNOWN);
+		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE1),
+					      IEEE80211_RADIOTAP_HE_DATA4_TB_SPTL_REUSE1);
+		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE2),
+					      IEEE80211_RADIOTAP_HE_DATA4_TB_SPTL_REUSE2);
+		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE3),
+					      IEEE80211_RADIOTAP_HE_DATA4_TB_SPTL_REUSE3);
+		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE4),
+					      IEEE80211_RADIOTAP_HE_DATA4_TB_SPTL_REUSE4);
+		/* fall through */
+	case IWL_RX_PHY_INFO_TYPE_HE_SU:
+	case IWL_RX_PHY_INFO_TYPE_HE_MU:
+	case IWL_RX_PHY_INFO_TYPE_HE_MU_EXT:
+	case IWL_RX_PHY_INFO_TYPE_HE_TB:
+		/* HE common */
+		he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_LDPC_XSYMSEG_KNOWN |
+					 IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN |
+					 IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE_KNOWN |
+					 IEEE80211_RADIOTAP_HE_DATA1_DOPPLER_KNOWN |
+					 IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN);
+		he->data2 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRE_FEC_PAD_KNOWN |
+					 IEEE80211_RADIOTAP_HE_DATA2_PE_DISAMBIG_KNOWN |
+					 IEEE80211_RADIOTAP_HE_DATA2_TXOP_KNOWN |
+					 IEEE80211_RADIOTAP_HE_DATA2_NUM_LTF_SYMS_KNOWN);
+		he->data3 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA0_HE_BSS_COLOR_MASK),
+					      IEEE80211_RADIOTAP_HE_DATA3_BSS_COLOR);
+		he->data3 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA0_HE_UPLINK),
+					      IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
+		he->data3 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA0_HE_LDPC_EXT_SYM),
+					      IEEE80211_RADIOTAP_HE_DATA3_LDPC_XSYMSEG);
+		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA0_HE_SPATIAL_REUSE_MASK),
+					      IEEE80211_RADIOTAP_HE_DATA4_SU_MU_SPTL_REUSE);
+		he->data5 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA0_HE_PRE_FEC_PAD_MASK),
+					      IEEE80211_RADIOTAP_HE_DATA5_PRE_FEC_PAD);
+		he->data5 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA0_HE_PE_DISAMBIG),
+					      IEEE80211_RADIOTAP_HE_DATA5_PE_DISAMBIG);
+		he->data5 |= le16_encode_bits(le32_get_bits(phy_data->d1,
+							    IWL_RX_PHY_DATA1_HE_LTF_NUM_MASK),
+					      IEEE80211_RADIOTAP_HE_DATA5_NUM_LTF_SYMS);
+		he->data6 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA0_HE_TXOP_DUR_MASK),
+					      IEEE80211_RADIOTAP_HE_DATA6_TXOP);
+		he->data6 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA0_HE_DOPPLER),
+					      IEEE80211_RADIOTAP_HE_DATA6_DOPPLER);
+		break;
+	}
+
+	switch (info_type) {
+	case IWL_RX_PHY_INFO_TYPE_HE_MU_EXT:
 		he_mu->flags1 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_DCM,
-						   he_phy_data),
+			le16_encode_bits(le16_get_bits(phy_data->d4,
+						       IWL_RX_PHY_DATA4_HE_MU_EXT_SIGB_DCM),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_DCM);
 		he_mu->flags1 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_MCS_MASK,
-						   he_phy_data),
+			le16_encode_bits(le16_get_bits(phy_data->d4,
+						       IWL_RX_PHY_DATA4_HE_MU_EXT_SIGB_MCS_MASK),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_MCS);
 		he_mu->flags2 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIBG_SYM_OR_USER_NUM_MASK,
-						  he_phy_data),
-					IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_SYMS_USERS);
+			le16_encode_bits(le16_get_bits(phy_data->d4,
+						       IWL_RX_PHY_DATA4_HE_MU_EXT_PREAMBLE_PUNC_TYPE_MASK),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW);
+		iwl_mvm_decode_he_mu_ext(mvm, phy_data, rate_n_flags, he_mu);
+		/* fall through */
+	case IWL_RX_PHY_INFO_TYPE_HE_MU:
 		he_mu->flags2 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_COMPRESSION,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_COMP);
+			le16_encode_bits(le32_get_bits(phy_data->d1,
+						       IWL_RX_PHY_DATA1_HE_MU_SIBG_SYM_OR_USER_NUM_MASK),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_SYMS_USERS);
 		he_mu->flags2 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_PREAMBLE_PUNC_TYPE_MASK,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW);
-
-		sigb_data = FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK,
-				      he_phy_data) ==
-				IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO;
-		if (sigb_data)
-			iwl_mvm_decode_he_sigb(mvm, desc, rate_n_flags, he_mu);
+			le16_encode_bits(le32_get_bits(phy_data->d1,
+						       IWL_RX_PHY_DATA1_HE_MU_SIGB_COMPRESSION),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_COMP);
 		/* fall through */
-	case RATE_MCS_HE_TYPE_TRIG:
-		he->data2 |=
-			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_NUM_LTF_SYMS_KNOWN);
-		he->data5 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_HE_LTF_NUM_MASK,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_DATA5_NUM_LTF_SYMS);
-		break;
-	case RATE_MCS_HE_TYPE_SU:
-	case RATE_MCS_HE_TYPE_EXT_SU:
-		he->data1 |=
-			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BEAM_CHANGE_KNOWN);
-		he->data3 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_BEAM_CHNG,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_DATA3_BEAM_CHANGE);
-		break;
-	}
-
-	switch (FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK, he_phy_data)) {
-	case IWL_RX_HE_PHY_INFO_TYPE_MU:
-	case IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO:
-	case IWL_RX_HE_PHY_INFO_TYPE_TB:
-		iwl_mvm_decode_he_phy_ru_alloc(he_phy_data, rate_n_flags,
+	case IWL_RX_PHY_INFO_TYPE_HE_TB:
+	case IWL_RX_PHY_INFO_TYPE_HE_TB_EXT:
+		iwl_mvm_decode_he_phy_ru_alloc(phy_data, rate_n_flags,
 					       he, he_mu, rx_status);
 		break;
+	case IWL_RX_PHY_INFO_TYPE_HE_SU:
+		he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BEAM_CHANGE_KNOWN);
+		he->data3 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA0_HE_BEAM_CHNG),
+					      IEEE80211_RADIOTAP_HE_DATA3_BEAM_CHANGE);
+		break;
 	default:
 		/* nothing */
 		break;
@@ -1107,9 +1123,6 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 			  u32 rate_n_flags, u16 phy_info, int queue)
 {
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
-	/* this is invalid e.g. because puncture type doesn't allow 0b11 */
-#define HE_PHY_DATA_INVAL ((u64)-1)
-	u64 he_phy_data = HE_PHY_DATA_INVAL;
 	struct ieee80211_radiotap_he *he = NULL;
 	struct ieee80211_radiotap_he_mu *he_mu = NULL;
 	u32 he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
@@ -1131,54 +1144,66 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 				      IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW_KNOWN),
 	};
 	unsigned int radiotap_len = 0;
+	struct iwl_mvm_rx_phy_data phy_data = {
+		.d4 = desc->phy_data4,
+	};
+	enum iwl_rx_phy_info_type info_type = IWL_RX_PHY_INFO_TYPE_NONE;
+
+	if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
+		phy_data.d0 = desc->v3.phy_data0;
+		phy_data.d1 = desc->v3.phy_data1;
+		phy_data.d2 = desc->v3.phy_data2;
+		phy_data.d3 = desc->v3.phy_data3;
+	} else {
+		phy_data.d0 = desc->v1.phy_data0;
+		phy_data.d1 = desc->v1.phy_data1;
+		phy_data.d2 = desc->v1.phy_data2;
+		phy_data.d3 = desc->v1.phy_data3;
+	}
+
+	if (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD)
+		info_type = le32_get_bits(phy_data.d1,
+					  IWL_RX_PHY_DATA1_INFO_TYPE_MASK);
 
 	he = skb_put_data(skb, &known, sizeof(known));
 	radiotap_len += sizeof(known);
 	rx_status->flag |= RX_FLAG_RADIOTAP_HE;
 
-	if (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD) {
-		if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
-			he_phy_data = le64_to_cpu(desc->v3.he_phy_data);
-		else
-			he_phy_data = le64_to_cpu(desc->v1.he_phy_data);
-
-		if (he_type == RATE_MCS_HE_TYPE_MU) {
-			he_mu = skb_put_data(skb, &mu_known, sizeof(mu_known));
-			radiotap_len += sizeof(mu_known);
-			rx_status->flag |= RX_FLAG_RADIOTAP_HE_MU;
-		}
+	if (info_type == IWL_RX_PHY_INFO_TYPE_HE_MU ||
+	    info_type == IWL_RX_PHY_INFO_TYPE_HE_MU_EXT) {
+		he_mu = skb_put_data(skb, &mu_known, sizeof(mu_known));
+		radiotap_len += sizeof(mu_known);
+		rx_status->flag |= RX_FLAG_RADIOTAP_HE_MU;
 	}
 
 	/* temporarily hide the radiotap data */
 	__skb_pull(skb, radiotap_len);
 
-	if (he_phy_data != HE_PHY_DATA_INVAL &&
-	    he_type == RATE_MCS_HE_TYPE_SU) {
+	if (info_type == IWL_RX_PHY_INFO_TYPE_HE_SU) {
 		/* report the AMPDU-EOF bit on single frames */
 		if (!queue && !(phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
 			rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
 			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
-			if (FIELD_GET(IWL_RX_HE_PHY_DELIM_EOF, he_phy_data))
+			if (phy_data.d0 & cpu_to_le32(IWL_RX_PHY_DATA0_HE_DELIM_EOF))
 				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
 		}
 	}
 
-	if (he_phy_data != HE_PHY_DATA_INVAL)
-		iwl_mvm_decode_he_phy_data(mvm, desc, he, he_mu, rx_status,
-					   he_phy_data, rate_n_flags, queue);
+	if (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD)
+		iwl_mvm_decode_he_phy_data(mvm, &phy_data, he, he_mu, rx_status,
+					   rate_n_flags, queue);
 
 	/* update aggregation data for monitor sake on default queue */
-	if (!queue && (phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
+	if (!queue && (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD) &&
+	    (phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
 		bool toggle_bit = phy_info & IWL_RX_MPDU_PHY_AMPDU_TOGGLE;
 
 		/* toggle is switched whenever new aggregation starts */
 		if (toggle_bit != mvm->ampdu_toggle &&
-		    he_phy_data != HE_PHY_DATA_INVAL &&
 		    (he_type == RATE_MCS_HE_TYPE_MU ||
 		     he_type == RATE_MCS_HE_TYPE_SU)) {
 			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
-			if (FIELD_GET(IWL_RX_HE_PHY_DELIM_EOF,
-				      he_phy_data))
+			if (phy_data.d0 & cpu_to_le32(IWL_RX_PHY_DATA0_HE_DELIM_EOF))
 				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
 		}
 	}
@@ -1261,44 +1286,8 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 		break;
 	}
 
-	he->data5 |= le16_encode_bits(ltf, IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE);
-
-	if (he_type == RATE_MCS_HE_TYPE_SU ||
-	    he_type == RATE_MCS_HE_TYPE_EXT_SU) {
-		u16 val;
-
-		/* LTF syms correspond to streams */
-		he->data2 |=
-			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_NUM_LTF_SYMS_KNOWN);
-		switch (rx_status->nss) {
-		case 1:
-			val = 0;
-			break;
-		case 2:
-			val = 1;
-			break;
-		case 3:
-		case 4:
-			val = 2;
-			break;
-		case 5:
-		case 6:
-			val = 3;
-			break;
-		case 7:
-		case 8:
-			val = 4;
-			break;
-		default:
-			WARN_ONCE(1, "invalid nss: %d\n",
-				  rx_status->nss);
-			val = 0;
-		}
-
-		he->data5 |=
-			le16_encode_bits(val,
-					 IEEE80211_RADIOTAP_HE_DATA5_NUM_LTF_SYMS);
-	}
+	he->data5 |= le16_encode_bits(ltf,
+				      IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE);
 }
 
 void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
-- 
2.19.1

