Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UPPERCASE_50_75,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A90C43444
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 906422080F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbeLNUaA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:30:00 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41980 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730876AbeLNU36 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:29:58 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5r-0002RG-SY; Fri, 14 Dec 2018 22:29:56 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:34 +0200
Message-Id: <20181214202945.32375-8-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/18] iwlwifi: split HE capabilities between AP and STA
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

HE capabilities differ between AP and STA.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 289 ++++++++++++------
 1 file changed, 188 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 96e101d79662..173ade96f119 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -465,101 +465,184 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 	vht_cap->vht_mcs.tx_mcs_map = vht_cap->vht_mcs.rx_mcs_map;
 }
 
-static struct ieee80211_sband_iftype_data iwl_he_capa = {
-	.types_mask = BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP),
-	.he_cap = {
-		.has_he = true,
-		.he_cap_elem = {
-			.mac_cap_info[0] =
-				IEEE80211_HE_MAC_CAP0_HTC_HE |
-				IEEE80211_HE_MAC_CAP0_TWT_REQ,
-			.mac_cap_info[1] =
-				IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
-				IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
-			.mac_cap_info[2] =
-				IEEE80211_HE_MAC_CAP2_32BIT_BA_BITMAP |
-				IEEE80211_HE_MAC_CAP2_MU_CASCADING |
-				IEEE80211_HE_MAC_CAP2_ACK_EN,
-			.mac_cap_info[3] =
-				IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
-				IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2,
-			.mac_cap_info[4] =
-				IEEE80211_HE_MAC_CAP4_AMDSU_IN_AMPDU |
-				IEEE80211_HE_MAC_CAP4_MULTI_TID_AGG_TX_QOS_B39,
-			.mac_cap_info[5] =
-				IEEE80211_HE_MAC_CAP5_MULTI_TID_AGG_TX_QOS_B40 |
-				IEEE80211_HE_MAC_CAP5_MULTI_TID_AGG_TX_QOS_B41 |
-				IEEE80211_HE_MAC_CAP5_UL_2x996_TONE_RU,
-			.phy_cap_info[0] =
-				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_IN_2G |
-				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G |
-				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G,
-			.phy_cap_info[1] =
-				IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_MASK |
-				IEEE80211_HE_PHY_CAP1_DEVICE_CLASS_A |
-				IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD |
-				IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS,
-			.phy_cap_info[2] =
-				IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US |
-				IEEE80211_HE_PHY_CAP2_STBC_TX_UNDER_80MHZ |
-				IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ |
-				IEEE80211_HE_PHY_CAP2_UL_MU_FULL_MU_MIMO |
-				IEEE80211_HE_PHY_CAP2_UL_MU_PARTIAL_MU_MIMO,
-			.phy_cap_info[3] =
-				IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_BPSK |
-				IEEE80211_HE_PHY_CAP3_DCM_MAX_TX_NSS_1 |
-				IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_BPSK |
-				IEEE80211_HE_PHY_CAP3_DCM_MAX_RX_NSS_1,
-			.phy_cap_info[4] =
-				IEEE80211_HE_PHY_CAP4_SU_BEAMFORMEE |
-				IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_ABOVE_80MHZ_8 |
-				IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_UNDER_80MHZ_8,
-			.phy_cap_info[5] =
-				IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_UNDER_80MHZ_2 |
-				IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_ABOVE_80MHZ_2 |
-				IEEE80211_HE_PHY_CAP5_NG16_SU_FEEDBACK |
-				IEEE80211_HE_PHY_CAP5_NG16_MU_FEEDBACK,
-			.phy_cap_info[6] =
-				IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_42_SU |
-				IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_75_MU |
-				IEEE80211_HE_PHY_CAP6_TRIG_SU_BEAMFORMER_FB |
-				IEEE80211_HE_PHY_CAP6_TRIG_MU_BEAMFORMER_FB |
-				IEEE80211_HE_PHY_CAP6_TRIG_CQI_FB |
-				IEEE80211_HE_PHY_CAP6_PARTIAL_BANDWIDTH_DL_MUMIMO |
-				IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT,
-			.phy_cap_info[7] =
-				IEEE80211_HE_PHY_CAP7_POWER_BOOST_FACTOR_AR |
-				IEEE80211_HE_PHY_CAP7_HE_SU_MU_PPDU_4XLTF_AND_08_US_GI |
-				IEEE80211_HE_PHY_CAP7_MAX_NC_1,
-			.phy_cap_info[8] =
-				IEEE80211_HE_PHY_CAP8_HE_ER_SU_PPDU_4XLTF_AND_08_US_GI |
-				IEEE80211_HE_PHY_CAP8_20MHZ_IN_40MHZ_HE_PPDU_IN_2G |
-				IEEE80211_HE_PHY_CAP8_20MHZ_IN_160MHZ_HE_PPDU |
-				IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU |
-				IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_160_OR_80P80_MHZ,
-			.phy_cap_info[9] =
-				IEEE80211_HE_PHY_CAP9_NON_TRIGGERED_CQI_FEEDBACK |
-				IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_COMP_SIGB |
-				IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB,
+static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
+	{
+		.types_mask = BIT(NL80211_IFTYPE_STATION),
+		.he_cap = {
+			.has_he = true,
+			.he_cap_elem = {
+				.mac_cap_info[0] =
+					IEEE80211_HE_MAC_CAP0_HTC_HE |
+					IEEE80211_HE_MAC_CAP0_TWT_REQ,
+				.mac_cap_info[1] =
+					IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
+					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
+				.mac_cap_info[2] =
+					IEEE80211_HE_MAC_CAP2_32BIT_BA_BITMAP |
+					IEEE80211_HE_MAC_CAP2_MU_CASCADING |
+					IEEE80211_HE_MAC_CAP2_ACK_EN,
+				.mac_cap_info[3] =
+					IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
+					IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2,
+				.mac_cap_info[4] =
+					IEEE80211_HE_MAC_CAP4_AMDSU_IN_AMPDU |
+					IEEE80211_HE_MAC_CAP4_MULTI_TID_AGG_TX_QOS_B39,
+				.mac_cap_info[5] =
+					IEEE80211_HE_MAC_CAP5_MULTI_TID_AGG_TX_QOS_B40 |
+					IEEE80211_HE_MAC_CAP5_MULTI_TID_AGG_TX_QOS_B41 |
+					IEEE80211_HE_MAC_CAP5_UL_2x996_TONE_RU,
+				.phy_cap_info[0] =
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_IN_2G |
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G |
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G,
+				.phy_cap_info[1] =
+					IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_MASK |
+					IEEE80211_HE_PHY_CAP1_DEVICE_CLASS_A |
+					IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD |
+					IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS,
+				.phy_cap_info[2] =
+					IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US |
+					IEEE80211_HE_PHY_CAP2_STBC_TX_UNDER_80MHZ |
+					IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ |
+					IEEE80211_HE_PHY_CAP2_UL_MU_FULL_MU_MIMO |
+					IEEE80211_HE_PHY_CAP2_UL_MU_PARTIAL_MU_MIMO,
+				.phy_cap_info[3] =
+					IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_BPSK |
+					IEEE80211_HE_PHY_CAP3_DCM_MAX_TX_NSS_1 |
+					IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_BPSK |
+					IEEE80211_HE_PHY_CAP3_DCM_MAX_RX_NSS_1,
+				.phy_cap_info[4] =
+					IEEE80211_HE_PHY_CAP4_SU_BEAMFORMEE |
+					IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_ABOVE_80MHZ_8 |
+					IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_UNDER_80MHZ_8,
+				.phy_cap_info[5] =
+					IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_UNDER_80MHZ_2 |
+					IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_ABOVE_80MHZ_2 |
+					IEEE80211_HE_PHY_CAP5_NG16_SU_FEEDBACK |
+					IEEE80211_HE_PHY_CAP5_NG16_MU_FEEDBACK,
+				.phy_cap_info[6] =
+					IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_42_SU |
+					IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_75_MU |
+					IEEE80211_HE_PHY_CAP6_TRIG_SU_BEAMFORMER_FB |
+					IEEE80211_HE_PHY_CAP6_TRIG_MU_BEAMFORMER_FB |
+					IEEE80211_HE_PHY_CAP6_TRIG_CQI_FB |
+					IEEE80211_HE_PHY_CAP6_PARTIAL_BANDWIDTH_DL_MUMIMO |
+					IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT,
+				.phy_cap_info[7] =
+					IEEE80211_HE_PHY_CAP7_POWER_BOOST_FACTOR_AR |
+					IEEE80211_HE_PHY_CAP7_HE_SU_MU_PPDU_4XLTF_AND_08_US_GI |
+					IEEE80211_HE_PHY_CAP7_MAX_NC_1,
+				.phy_cap_info[8] =
+					IEEE80211_HE_PHY_CAP8_HE_ER_SU_PPDU_4XLTF_AND_08_US_GI |
+					IEEE80211_HE_PHY_CAP8_20MHZ_IN_40MHZ_HE_PPDU_IN_2G |
+					IEEE80211_HE_PHY_CAP8_20MHZ_IN_160MHZ_HE_PPDU |
+					IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU |
+					IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_160_OR_80P80_MHZ,
+				.phy_cap_info[9] =
+					IEEE80211_HE_PHY_CAP9_NON_TRIGGERED_CQI_FEEDBACK |
+					IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_COMP_SIGB |
+					IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB,
+			},
+			/*
+			 * Set default Tx/Rx HE MCS NSS Support field.
+			 * Indicate support for up to 2 spatial streams and all
+			 * MCS, without any special cases
+			 */
+			.he_mcs_nss_supp = {
+				.rx_mcs_80 = cpu_to_le16(0xfffa),
+				.tx_mcs_80 = cpu_to_le16(0xfffa),
+				.rx_mcs_160 = cpu_to_le16(0xfffa),
+				.tx_mcs_160 = cpu_to_le16(0xfffa),
+				.rx_mcs_80p80 = cpu_to_le16(0xffff),
+				.tx_mcs_80p80 = cpu_to_le16(0xffff),
+			},
+			/*
+			 * Set default PPE thresholds, with PPET16 set to 0,
+			 * PPET8 set to 7
+			 */
+			.ppe_thres = {0x61, 0x1c, 0xc7, 0x71},
 		},
-		/*
-		 * Set default Tx/Rx HE MCS NSS Support field. Indicate support
-		 * for up to 2 spatial streams and all MCS, without any special
-		 * cases
-		 */
-		.he_mcs_nss_supp = {
-			.rx_mcs_80 = cpu_to_le16(0xfffa),
-			.tx_mcs_80 = cpu_to_le16(0xfffa),
-			.rx_mcs_160 = cpu_to_le16(0xfffa),
-			.tx_mcs_160 = cpu_to_le16(0xfffa),
-			.rx_mcs_80p80 = cpu_to_le16(0xffff),
-			.tx_mcs_80p80 = cpu_to_le16(0xffff),
+	},
+	{
+		.types_mask = BIT(NL80211_IFTYPE_AP),
+		.he_cap = {
+			.has_he = true,
+			.he_cap_elem = {
+				.mac_cap_info[0] =
+					IEEE80211_HE_MAC_CAP0_HTC_HE,
+				.mac_cap_info[1] =
+					IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
+					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
+				.mac_cap_info[2] =
+					IEEE80211_HE_MAC_CAP2_BSR |
+					IEEE80211_HE_MAC_CAP2_MU_CASCADING |
+					IEEE80211_HE_MAC_CAP2_ACK_EN,
+				.mac_cap_info[3] =
+					IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
+					IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2,
+				.mac_cap_info[4] =
+					IEEE80211_HE_MAC_CAP4_AMDSU_IN_AMPDU,
+				.phy_cap_info[0] =
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_IN_2G |
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G |
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G,
+				.phy_cap_info[1] =
+					IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD |
+					IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS,
+				.phy_cap_info[2] =
+					IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US |
+					IEEE80211_HE_PHY_CAP2_STBC_TX_UNDER_80MHZ |
+					IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ,
+				.phy_cap_info[3] =
+					IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_BPSK |
+					IEEE80211_HE_PHY_CAP3_DCM_MAX_TX_NSS_1 |
+					IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_BPSK |
+					IEEE80211_HE_PHY_CAP3_DCM_MAX_RX_NSS_1,
+				.phy_cap_info[4] =
+					IEEE80211_HE_PHY_CAP4_SU_BEAMFORMEE |
+					IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_ABOVE_80MHZ_8 |
+					IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_UNDER_80MHZ_8,
+				.phy_cap_info[5] =
+					IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_UNDER_80MHZ_2 |
+					IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_ABOVE_80MHZ_2 |
+					IEEE80211_HE_PHY_CAP5_NG16_SU_FEEDBACK |
+					IEEE80211_HE_PHY_CAP5_NG16_MU_FEEDBACK,
+				.phy_cap_info[6] =
+					IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_42_SU |
+					IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_75_MU |
+					IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT,
+				.phy_cap_info[7] =
+					IEEE80211_HE_PHY_CAP7_HE_SU_MU_PPDU_4XLTF_AND_08_US_GI |
+					IEEE80211_HE_PHY_CAP7_MAX_NC_1,
+				.phy_cap_info[8] =
+					IEEE80211_HE_PHY_CAP8_HE_ER_SU_PPDU_4XLTF_AND_08_US_GI |
+					IEEE80211_HE_PHY_CAP8_20MHZ_IN_40MHZ_HE_PPDU_IN_2G |
+					IEEE80211_HE_PHY_CAP8_20MHZ_IN_160MHZ_HE_PPDU |
+					IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU |
+					IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_160_OR_80P80_MHZ,
+				.phy_cap_info[9] =
+					IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_COMP_SIGB |
+					IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB,
+			},
+			/*
+			 * Set default Tx/Rx HE MCS NSS Support field.
+			 * Indicate support for up to 2 spatial streams and all
+			 * MCS, without any special cases
+			 */
+			.he_mcs_nss_supp = {
+				.rx_mcs_80 = cpu_to_le16(0xfffa),
+				.tx_mcs_80 = cpu_to_le16(0xfffa),
+				.rx_mcs_160 = cpu_to_le16(0xfffa),
+				.tx_mcs_160 = cpu_to_le16(0xfffa),
+				.rx_mcs_80p80 = cpu_to_le16(0xffff),
+				.tx_mcs_80p80 = cpu_to_le16(0xffff),
+			},
+			/*
+			 * Set default PPE thresholds, with PPET16 set to 0,
+			 * PPET8 set to 7
+			 */
+			.ppe_thres = {0x61, 0x1c, 0xc7, 0x71},
 		},
-		/*
-		 * Set default PPE thresholds, with PPET16 set to 0, PPET8 set
-		 * to 7
-		 */
-		.ppe_thres = {0x61, 0x1c, 0xc7, 0x71},
 	},
 };
 
@@ -568,20 +651,24 @@ static void iwl_init_he_hw_capab(struct ieee80211_supported_band *sband,
 {
 	if (sband->band == NL80211_BAND_2GHZ ||
 	    sband->band == NL80211_BAND_5GHZ)
-		sband->iftype_data = &iwl_he_capa;
+		sband->iftype_data = iwl_he_capa;
 	else
 		return;
 
-	sband->n_iftype_data = 1;
+	sband->n_iftype_data = ARRAY_SIZE(iwl_he_capa);
 
 	/* If not 2x2, we need to indicate 1x1 in the Midamble RX Max NSTS */
 	if ((tx_chains & rx_chains) != ANT_AB) {
-		iwl_he_capa.he_cap.he_cap_elem.phy_cap_info[1] &=
-			~IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS;
-		iwl_he_capa.he_cap.he_cap_elem.phy_cap_info[2] &=
-			~IEEE80211_HE_PHY_CAP2_MIDAMBLE_RX_TX_MAX_NSTS;
-		iwl_he_capa.he_cap.he_cap_elem.phy_cap_info[7] &=
-			~IEEE80211_HE_PHY_CAP7_MAX_NC_MASK;
+		int i;
+
+		for (i = 0; i < sband->n_iftype_data; i++) {
+			iwl_he_capa[i].he_cap.he_cap_elem.phy_cap_info[1] &=
+				~IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS;
+			iwl_he_capa[i].he_cap.he_cap_elem.phy_cap_info[2] &=
+				~IEEE80211_HE_PHY_CAP2_MIDAMBLE_RX_TX_MAX_NSTS;
+			iwl_he_capa[i].he_cap.he_cap_elem.phy_cap_info[7] &=
+				~IEEE80211_HE_PHY_CAP7_MAX_NC_MASK;
+		}
 	}
 }
 
-- 
2.19.2

