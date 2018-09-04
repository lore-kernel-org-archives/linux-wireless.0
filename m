Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46450 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726208AbeIDQFv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 12:05:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  4 Sep 2018 14:40:49 +0300
Message-Id: <20180904114055.1429-4-luca@coelho.fi> (sfid-20180904_134134_325079_9853F26E)
In-Reply-To: <20180904114055.1429-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
 <20180904114055.1429-1-luca@coelho.fi>
Subject: [PATCH v2 3/9] wireless: align to draft 11ax D3.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

Align to new 11ax draft D3.0.  Change/add new MAC and PHY capabilities
and update drivers' 11ax capabilities and mac80211's debugfs
accordingly.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 51 ++++++++----
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 -
 drivers/net/wireless/mac80211_hwsim.c         | 18 ++---
 include/linux/ieee80211.h                     | 72 ++++++++++-------
 net/mac80211/debugfs_sta.c                    | 77 +++++++++++++------
 5 files changed, 146 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index b4c3a957c102..231af53b7e98 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -476,30 +476,40 @@ static struct ieee80211_sband_iftype_data iwl_he_capa = {
 		.has_he = true,
 		.he_cap_elem = {
 			.mac_cap_info[0] =
-				IEEE80211_HE_MAC_CAP0_HTC_HE,
+				IEEE80211_HE_MAC_CAP0_HTC_HE |
+				IEEE80211_HE_MAC_CAP0_TWT_REQ,
 			.mac_cap_info[1] =
 				IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
-				IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_QOS_8,
+				IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
 			.mac_cap_info[2] =
 				IEEE80211_HE_MAC_CAP2_32BIT_BA_BITMAP |
+				IEEE80211_HE_MAC_CAP2_MU_CASCADING |
 				IEEE80211_HE_MAC_CAP2_ACK_EN,
 			.mac_cap_info[3] =
-				IEEE80211_HE_MAC_CAP3_GRP_ADDR_MULTI_STA_BA_DL_MU |
-				IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_VHT_2,
-			.mac_cap_info[4] = IEEE80211_HE_MAC_CAP4_AMDSU_IN_AMPDU,
+				IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
+				IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2,
+			.mac_cap_info[4] =
+				IEEE80211_HE_MAC_CAP4_AMDSU_IN_AMPDU |
+				IEEE80211_HE_MAC_CAP4_MULTI_TID_AGG_TX_QOS_B39,
+			.mac_cap_info[5] =
+				IEEE80211_HE_MAC_CAP5_MULTI_TID_AGG_TX_QOS_B40 |
+				IEEE80211_HE_MAC_CAP5_MULTI_TID_AGG_TX_QOS_B41 |
+				IEEE80211_HE_MAC_CAP5_UL_2x996_TONE_RU,
 			.phy_cap_info[0] =
-				IEEE80211_HE_PHY_CAP0_DUAL_BAND |
 				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_IN_2G |
 				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G |
 				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G,
 			.phy_cap_info[1] =
+				IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_MASK |
 				IEEE80211_HE_PHY_CAP1_DEVICE_CLASS_A |
 				IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD |
-				IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_MAX_NSTS,
+				IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS,
 			.phy_cap_info[2] =
 				IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US |
 				IEEE80211_HE_PHY_CAP2_STBC_TX_UNDER_80MHZ |
-				IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ,
+				IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ |
+				IEEE80211_HE_PHY_CAP2_UL_MU_FULL_MU_MIMO |
+				IEEE80211_HE_PHY_CAP2_UL_MU_PARTIAL_MU_MIMO,
 			.phy_cap_info[3] =
 				IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_BPSK |
 				IEEE80211_HE_PHY_CAP3_DCM_MAX_TX_NSS_1 |
@@ -511,18 +521,31 @@ static struct ieee80211_sband_iftype_data iwl_he_capa = {
 				IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_UNDER_80MHZ_8,
 			.phy_cap_info[5] =
 				IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_UNDER_80MHZ_2 |
-				IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_ABOVE_80MHZ_2,
+				IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_ABOVE_80MHZ_2 |
+				IEEE80211_HE_PHY_CAP5_NG16_SU_FEEDBACK |
+				IEEE80211_HE_PHY_CAP5_NG16_MU_FEEDBACK,
 			.phy_cap_info[6] =
+				IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_42_SU |
+				IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_75_MU |
+				IEEE80211_HE_PHY_CAP6_TRIG_SU_BEAMFORMER_FB |
+				IEEE80211_HE_PHY_CAP6_TRIG_MU_BEAMFORMER_FB |
+				IEEE80211_HE_PHY_CAP6_TRIG_CQI_FB |
+				IEEE80211_HE_PHY_CAP6_PARTIAL_BANDWIDTH_DL_MUMIMO |
 				IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT,
 			.phy_cap_info[7] =
 				IEEE80211_HE_PHY_CAP7_POWER_BOOST_FACTOR_AR |
 				IEEE80211_HE_PHY_CAP7_HE_SU_MU_PPDU_4XLTF_AND_08_US_GI |
-				IEEE80211_HE_PHY_CAP7_MAX_NC_7,
+				IEEE80211_HE_PHY_CAP7_MAX_NC_1,
 			.phy_cap_info[8] =
 				IEEE80211_HE_PHY_CAP8_HE_ER_SU_PPDU_4XLTF_AND_08_US_GI |
 				IEEE80211_HE_PHY_CAP8_20MHZ_IN_40MHZ_HE_PPDU_IN_2G |
 				IEEE80211_HE_PHY_CAP8_20MHZ_IN_160MHZ_HE_PPDU |
-				IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU,
+				IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU |
+				IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_160_OR_80P80_MHZ,
+			.phy_cap_info[9] =
+				IEEE80211_HE_PHY_CAP9_NON_TRIGGERED_CQI_FEEDBACK |
+				IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_COMP_SIGB |
+				IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB,
 		},
 		/*
 		 * Set default Tx/Rx HE MCS NSS Support field. Indicate support
@@ -559,9 +582,11 @@ static void iwl_init_he_hw_capab(struct ieee80211_supported_band *sband,
 	/* If not 2x2, we need to indicate 1x1 in the Midamble RX Max NSTS */
 	if ((tx_chains & rx_chains) != ANT_AB) {
 		iwl_he_capa.he_cap.he_cap_elem.phy_cap_info[1] &=
-			~IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_MAX_NSTS;
+			~IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS;
 		iwl_he_capa.he_cap.he_cap_elem.phy_cap_info[2] &=
-			~IEEE80211_HE_PHY_CAP2_MIDAMBLE_RX_MAX_NSTS;
+			~IEEE80211_HE_PHY_CAP2_MIDAMBLE_RX_TX_MAX_NSTS;
+		iwl_he_capa.he_cap.he_cap_elem.phy_cap_info[7] &=
+			~IEEE80211_HE_PHY_CAP7_MAX_NC_MASK;
 	}
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index b15b0d84bb7e..d46f3fbea46e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1978,10 +1978,6 @@ static void iwl_mvm_cfg_he_sta(struct iwl_mvm *mvm,
 			sta_ctxt_cmd.htc_flags |=
 				cpu_to_le32(IWL_HE_HTC_LINK_ADAP_BOTH);
 	}
-	if (sta->he_cap.he_cap_elem.mac_cap_info[2] &
-	    IEEE80211_HE_MAC_CAP2_UL_MU_RESP_SCHED)
-		sta_ctxt_cmd.htc_flags |=
-			cpu_to_le32(IWL_HE_HTC_UL_MU_RESP_SCHED);
 	if (sta->he_cap.he_cap_elem.mac_cap_info[2] & IEEE80211_HE_MAC_CAP2_BSR)
 		sta_ctxt_cmd.htc_flags |= cpu_to_le32(IWL_HE_HTC_BSR_SUPP);
 	if (sta->he_cap.he_cap_elem.mac_cap_info[3] &
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 998dfac0fcff..e33abf01fd3a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2008, Jouni Malinen <j@w1.fi>
  * Copyright (c) 2011, Javier Lopez <jlopex@gmail.com>
  * Copyright (c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -2528,23 +2529,20 @@ static const struct ieee80211_sband_iftype_data he_capa_2ghz = {
 				IEEE80211_HE_MAC_CAP0_HTC_HE,
 			.mac_cap_info[1] =
 				IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
-				IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_QOS_8,
+				IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
 			.mac_cap_info[2] =
 				IEEE80211_HE_MAC_CAP2_BSR |
 				IEEE80211_HE_MAC_CAP2_MU_CASCADING |
 				IEEE80211_HE_MAC_CAP2_ACK_EN,
 			.mac_cap_info[3] =
-				IEEE80211_HE_MAC_CAP3_GRP_ADDR_MULTI_STA_BA_DL_MU |
 				IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
-				IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_VHT_2,
+				IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2,
 			.mac_cap_info[4] = IEEE80211_HE_MAC_CAP4_AMDSU_IN_AMPDU,
-			.phy_cap_info[0] =
-				IEEE80211_HE_PHY_CAP0_DUAL_BAND,
 			.phy_cap_info[1] =
 				IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_MASK |
 				IEEE80211_HE_PHY_CAP1_DEVICE_CLASS_A |
 				IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD |
-				IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_MAX_NSTS,
+				IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS,
 			.phy_cap_info[2] =
 				IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US |
 				IEEE80211_HE_PHY_CAP2_STBC_TX_UNDER_80MHZ |
@@ -2578,18 +2576,16 @@ static const struct ieee80211_sband_iftype_data he_capa_5ghz = {
 				IEEE80211_HE_MAC_CAP0_HTC_HE,
 			.mac_cap_info[1] =
 				IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
-				IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_QOS_8,
+				IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
 			.mac_cap_info[2] =
 				IEEE80211_HE_MAC_CAP2_BSR |
 				IEEE80211_HE_MAC_CAP2_MU_CASCADING |
 				IEEE80211_HE_MAC_CAP2_ACK_EN,
 			.mac_cap_info[3] =
-				IEEE80211_HE_MAC_CAP3_GRP_ADDR_MULTI_STA_BA_DL_MU |
 				IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
-				IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_VHT_2,
+				IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2,
 			.mac_cap_info[4] = IEEE80211_HE_MAC_CAP4_AMDSU_IN_AMPDU,
 			.phy_cap_info[0] =
-				IEEE80211_HE_PHY_CAP0_DUAL_BAND |
 				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G |
 				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G |
 				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_80PLUS80_MHZ_IN_5G,
@@ -2597,7 +2593,7 @@ static const struct ieee80211_sband_iftype_data he_capa_5ghz = {
 				IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_MASK |
 				IEEE80211_HE_PHY_CAP1_DEVICE_CLASS_A |
 				IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD |
-				IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_MAX_NSTS,
+				IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS,
 			.phy_cap_info[2] =
 				IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US |
 				IEEE80211_HE_PHY_CAP2_STBC_TX_UNDER_80MHZ |
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 280600a10111..c4809ad8ab46 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1555,11 +1555,11 @@ struct ieee80211_vht_operation {
  * struct ieee80211_he_cap_elem - HE capabilities element
  *
  * This structure is the "HE capabilities element" fixed fields as
- * described in P802.11ax_D2.0 section 9.4.2.237.2 and 9.4.2.237.3
+ * described in P802.11ax_D3.0 section 9.4.2.237.2 and 9.4.2.237.3
  */
 struct ieee80211_he_cap_elem {
-	u8 mac_cap_info[5];
-	u8 phy_cap_info[9];
+	u8 mac_cap_info[6];
+	u8 phy_cap_info[11];
 } __packed;
 
 #define IEEE80211_TX_RX_MCS_NSS_DESC_MAX_LEN	5
@@ -1738,15 +1738,15 @@ int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
 #define IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_8US		0x04
 #define IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US		0x08
 #define IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_MASK		0x0c
-#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_QOS_1		0x00
-#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_QOS_2		0x10
-#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_QOS_3		0x20
-#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_QOS_4		0x30
-#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_QOS_5		0x40
-#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_QOS_6		0x50
-#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_QOS_7		0x60
-#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_QOS_8		0x70
-#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_QOS_MASK		0x70
+#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_1		0x00
+#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_2		0x10
+#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_3		0x20
+#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_4		0x30
+#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_5		0x40
+#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_6		0x50
+#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_7		0x60
+#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8		0x70
+#define IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_MASK		0x70
 
 /* Link adaptation is split between byte HE_MAC_CAP1 and
  * HE_MAC_CAP2. It should be set only if IEEE80211_HE_MAC_CAP0_HTC_HE
@@ -1760,14 +1760,13 @@ int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
 
 #define IEEE80211_HE_MAC_CAP2_LINK_ADAPTATION			0x01
 #define IEEE80211_HE_MAC_CAP2_ALL_ACK				0x02
-#define IEEE80211_HE_MAC_CAP2_UL_MU_RESP_SCHED			0x04
+#define IEEE80211_HE_MAC_CAP2_TRS				0x04
 #define IEEE80211_HE_MAC_CAP2_BSR				0x08
 #define IEEE80211_HE_MAC_CAP2_BCAST_TWT				0x10
 #define IEEE80211_HE_MAC_CAP2_32BIT_BA_BITMAP			0x20
 #define IEEE80211_HE_MAC_CAP2_MU_CASCADING			0x40
 #define IEEE80211_HE_MAC_CAP2_ACK_EN				0x80
 
-#define IEEE80211_HE_MAC_CAP3_GRP_ADDR_MULTI_STA_BA_DL_MU	0x01
 #define IEEE80211_HE_MAC_CAP3_OMI_CONTROL			0x02
 #define IEEE80211_HE_MAC_CAP3_OFDMA_RA				0x04
 
@@ -1775,25 +1774,34 @@ int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
  * A-MDPU Length Exponent field in the HT capabilities, VHT capabilities and the
  * same field in the HE capabilities.
  */
-#define IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_USE_VHT	0x00
-#define IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_VHT_1		0x08
-#define IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_VHT_2		0x10
-#define IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_RESERVED	0x18
-#define IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_MASK		0x18
-#define IEEE80211_HE_MAC_CAP3_A_AMSDU_FRAG			0x20
+#define IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_USE_VHT	0x00
+#define IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_1		0x08
+#define IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2		0x10
+#define IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_RESERVED	0x18
+#define IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_MASK		0x18
+#define IEEE80211_HE_MAC_CAP3_AMSDU_FRAG			0x20
 #define IEEE80211_HE_MAC_CAP3_FLEX_TWT_SCHED			0x40
 #define IEEE80211_HE_MAC_CAP3_RX_CTRL_FRAME_TO_MULTIBSS		0x80
 
 #define IEEE80211_HE_MAC_CAP4_BSRP_BQRP_A_MPDU_AGG		0x01
 #define IEEE80211_HE_MAC_CAP4_QTP				0x02
 #define IEEE80211_HE_MAC_CAP4_BQR				0x04
-#define IEEE80211_HE_MAC_CAP4_SR_RESP				0x08
+#define IEEE80211_HE_MAC_CAP4_SRP_RESP				0x08
 #define IEEE80211_HE_MAC_CAP4_NDP_FB_REP			0x10
 #define IEEE80211_HE_MAC_CAP4_OPS				0x20
 #define IEEE80211_HE_MAC_CAP4_AMDSU_IN_AMPDU			0x40
+/* Multi TID agg TX is split between byte #4 and #5
+ * The value is a combination of B39,B40,B41
+ */
+#define IEEE80211_HE_MAC_CAP4_MULTI_TID_AGG_TX_QOS_B39		0x80
+
+#define IEEE80211_HE_MAC_CAP5_MULTI_TID_AGG_TX_QOS_B40		0x01
+#define IEEE80211_HE_MAC_CAP5_MULTI_TID_AGG_TX_QOS_B41		0x02
+#define IEEE80211_HE_MAC_CAP5_SUBCHAN_SELECVITE_TRANSMISSION	0x04
+#define IEEE80211_HE_MAC_CAP5_UL_2x996_TONE_RU			0x08
+#define IEEE80211_HE_MAC_CAP5_OM_CTRL_UL_MU_DATA_DIS_RX		0x10
 
 /* 802.11ax HE PHY capabilities */
-#define IEEE80211_HE_PHY_CAP0_DUAL_BAND					0x01
 #define IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_IN_2G		0x02
 #define IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G	0x04
 #define IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G		0x08
@@ -1810,10 +1818,10 @@ int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
 #define IEEE80211_HE_PHY_CAP1_DEVICE_CLASS_A				0x10
 #define IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD			0x20
 #define IEEE80211_HE_PHY_CAP1_HE_LTF_AND_GI_FOR_HE_PPDUS_0_8US		0x40
-/* Midamble RX Max NSTS is split between byte #2 and byte #3 */
-#define IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_MAX_NSTS			0x80
+/* Midamble RX/TX Max NSTS is split between byte #2 and byte #3 */
+#define IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS			0x80
 
-#define IEEE80211_HE_PHY_CAP2_MIDAMBLE_RX_MAX_NSTS			0x01
+#define IEEE80211_HE_PHY_CAP2_MIDAMBLE_RX_TX_MAX_NSTS			0x01
 #define IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US			0x02
 #define IEEE80211_HE_PHY_CAP2_STBC_TX_UNDER_80MHZ			0x04
 #define IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ			0x08
@@ -1914,7 +1922,19 @@ int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
 #define IEEE80211_HE_PHY_CAP8_20MHZ_IN_160MHZ_HE_PPDU			0x04
 #define IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU			0x08
 #define IEEE80211_HE_PHY_CAP8_HE_ER_SU_1XLTF_AND_08_US_GI		0x10
-#define IEEE80211_HE_PHY_CAP8_MIDAMBLE_RX_2X_AND_1XLTF			0x20
+#define IEEE80211_HE_PHY_CAP8_MIDAMBLE_RX_TX_2X_AND_1XLTF		0x20
+#define IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_20MHZ				0x00
+#define IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_40MHZ				0x40
+#define IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_80MHZ				0x80
+#define IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_160_OR_80P80_MHZ		0xc0
+#define IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_MASK				0xc0
+
+#define IEEE80211_HE_PHY_CAP9_LONGER_THAN_16_SIGB_OFDM_SYM		0x01
+#define IEEE80211_HE_PHY_CAP9_NON_TRIGGERED_CQI_FEEDBACK		0x02
+#define IEEE80211_HE_PHY_CAP9_TX_1024_QAM_LESS_THAN_242_TONE_RU		0x04
+#define IEEE80211_HE_PHY_CAP9_RX_1024_QAM_LESS_THAN_242_TONE_RU		0x08
+#define IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_COMP_SIGB	0x10
+#define IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB	0x20
 
 /* 802.11ax HE TX/RX MCS NSS Support  */
 #define IEEE80211_TX_RX_MCS_NSS_SUPP_HIGHEST_MCS_POS			(3)
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 95124978947f..af5185a836e5 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -522,8 +522,8 @@ static ssize_t sta_he_capa_read(struct file *file, char __user *userbuf,
 
 	cap = hec->he_cap_elem.mac_cap_info;
 	p += scnprintf(p, buf_sz + buf - p,
-		       "MAC-CAP: %#.2x %#.2x %#.2x %#.2x %#.2x\n",
-		       cap[0], cap[1], cap[2], cap[3], cap[4]);
+		       "MAC-CAP: %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x\n",
+		       cap[0], cap[1], cap[2], cap[3], cap[4], cap[5]);
 
 #define PRINT(fmt, ...)							\
 	p += scnprintf(p, buf_sz + buf - p, "\t\t" fmt "\n",		\
@@ -563,7 +563,8 @@ static ssize_t sta_he_capa_read(struct file *file, char __user *userbuf,
 			    "MIN-FRAG-SIZE-%d", UNLIMITED, "UNLIMITED");
 	PFLAG_RANGE_DEFAULT(MAC, 1, TF_MAC_PAD_DUR, 0, 8, 0,
 			    "TF-MAC-PAD-DUR-%dUS", MASK, "UNKNOWN");
-	PFLAG_RANGE(MAC, 1, MULTI_TID_AGG_QOS, 0, 1, 1, "MULTI-TID-AGG-QOS-%d");
+	PFLAG_RANGE(MAC, 1, MULTI_TID_AGG_RX_QOS, 0, 1, 1,
+		    "MULTI-TID-AGG-RX-QOS-%d");
 
 	if (cap[0] & IEEE80211_HE_MAC_CAP0_HTC_HE) {
 		switch (((cap[2] << 1) | (cap[1] >> 7)) & 0x3) {
@@ -583,52 +584,55 @@ static ssize_t sta_he_capa_read(struct file *file, char __user *userbuf,
 	}
 
 	PFLAG(MAC, 2, ALL_ACK, "ALL-ACK");
-	PFLAG(MAC, 2, UL_MU_RESP_SCHED, "UL-MU-RESP-SCHED");
+	PFLAG(MAC, 2, TRS, "TRS");
 	PFLAG(MAC, 2, BSR, "BSR");
 	PFLAG(MAC, 2, BCAST_TWT, "BCAST-TWT");
 	PFLAG(MAC, 2, 32BIT_BA_BITMAP, "32BIT-BA-BITMAP");
 	PFLAG(MAC, 2, MU_CASCADING, "MU-CASCADING");
 	PFLAG(MAC, 2, ACK_EN, "ACK-EN");
 
-	PFLAG(MAC, 3, GRP_ADDR_MULTI_STA_BA_DL_MU,
-	      "GRP-ADDR-MULTI-STA-BA-DL-MU");
 	PFLAG(MAC, 3, OMI_CONTROL, "OMI-CONTROL");
 	PFLAG(MAC, 3, OFDMA_RA, "OFDMA-RA");
 
-	switch (cap[3] & IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_MASK) {
-	case IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_USE_VHT:
-		PRINT("MAX-A-AMPDU-LEN-EXP-USE-VHT");
+	switch (cap[3] & IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_MASK) {
+	case IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_USE_VHT:
+		PRINT("MAX-AMPDU-LEN-EXP-USE-VHT");
 		break;
-	case IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_VHT_1:
-		PRINT("MAX-A-AMPDU-LEN-EXP-VHT-1");
+	case IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_1:
+		PRINT("MAX-AMPDU-LEN-EXP-VHT-1");
 		break;
-	case IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_VHT_2:
-		PRINT("MAX-A-AMPDU-LEN-EXP-VHT-2");
+	case IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2:
+		PRINT("MAX-AMPDU-LEN-EXP-VHT-2");
 		break;
-	case IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_RESERVED:
-		PRINT("MAX-A-AMPDU-LEN-EXP-RESERVED");
+	case IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_RESERVED:
+		PRINT("MAX-AMPDU-LEN-EXP-RESERVED");
 		break;
 	}
 
-	PFLAG(MAC, 3, A_AMSDU_FRAG, "A-AMSDU-FRAG");
+	PFLAG(MAC, 3, AMSDU_FRAG, "AMSDU-FRAG");
 	PFLAG(MAC, 3, FLEX_TWT_SCHED, "FLEX-TWT-SCHED");
 	PFLAG(MAC, 3, RX_CTRL_FRAME_TO_MULTIBSS, "RX-CTRL-FRAME-TO-MULTIBSS");
 
 	PFLAG(MAC, 4, BSRP_BQRP_A_MPDU_AGG, "BSRP-BQRP-A-MPDU-AGG");
 	PFLAG(MAC, 4, QTP, "QTP");
 	PFLAG(MAC, 4, BQR, "BQR");
-	PFLAG(MAC, 4, SR_RESP, "SR-RESP");
+	PFLAG(MAC, 4, SRP_RESP, "SRP-RESP");
 	PFLAG(MAC, 4, NDP_FB_REP, "NDP-FB-REP");
 	PFLAG(MAC, 4, OPS, "OPS");
 	PFLAG(MAC, 4, AMDSU_IN_AMPDU, "AMSDU-IN-AMPDU");
 
+	PRINT("MULTI-TID-AGG-TX-QOS-%d", ((cap[5] << 1) | (cap[4] >> 7)) & 0x7);
+
+	PFLAG(MAC, 5, SUBCHAN_SELECVITE_TRANSMISSION,
+	      "SUBCHAN-SELECVITE-TRANSMISSION");
+	PFLAG(MAC, 5, UL_2x996_TONE_RU, "UL-2x996-TONE-RU");
+	PFLAG(MAC, 5, OM_CTRL_UL_MU_DATA_DIS_RX, "OM-CTRL-UL-MU-DATA-DIS-RX");
+
 	cap = hec->he_cap_elem.phy_cap_info;
 	p += scnprintf(p, buf_sz + buf - p,
-		       "PHY CAP: %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x\n",
+		       "PHY CAP: %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x\n",
 		       cap[0], cap[1], cap[2], cap[3], cap[4], cap[5], cap[6],
-		       cap[7], cap[8]);
-
-	PFLAG(PHY, 0, DUAL_BAND, "DUAL-BAND");
+		       cap[7], cap[8], cap[9], cap[10]);
 
 	PFLAG(PHY, 0, CHANNEL_WIDTH_SET_40MHZ_IN_2G,
 	      "CHANNEL-WIDTH-SET-40MHZ-IN-2G");
@@ -754,7 +758,36 @@ static ssize_t sta_he_capa_read(struct file *file, char __user *userbuf,
 	PFLAG(PHY, 8, 80MHZ_IN_160MHZ_HE_PPDU, "80MHZ-IN-160MHZ-HE-PPDU");
 	PFLAG(PHY, 8, HE_ER_SU_1XLTF_AND_08_US_GI,
 	      "HE-ER-SU-1XLTF-AND-08-US-GI");
-	PFLAG(PHY, 8, MIDAMBLE_RX_2X_AND_1XLTF, "MIDAMBLE-RX-2X-AND-1XLTF");
+	PFLAG(PHY, 8, MIDAMBLE_RX_TX_2X_AND_1XLTF,
+	      "MIDAMBLE-RX-TX-2X-AND-1XLTF");
+
+	switch (cap[8] & IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_MASK) {
+	case IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_20MHZ:
+		PRINT("DDCM-MAX-BW-20MHZ");
+		break;
+	case IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_40MHZ:
+		PRINT("DCM-MAX-BW-40MHZ");
+		break;
+	case IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_80MHZ:
+		PRINT("DCM-MAX-BW-80MHZ");
+		break;
+	case IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_160_OR_80P80_MHZ:
+		PRINT("DCM-MAX-BW-160-OR-80P80-MHZ");
+		break;
+	}
+
+	PFLAG(PHY, 9, LONGER_THAN_16_SIGB_OFDM_SYM,
+	      "LONGER-THAN-16-SIGB-OFDM-SYM");
+	PFLAG(PHY, 9, NON_TRIGGERED_CQI_FEEDBACK,
+	      "NON-TRIGGERED-CQI-FEEDBACK");
+	PFLAG(PHY, 9, TX_1024_QAM_LESS_THAN_242_TONE_RU,
+	      "TX-1024-QAM-LESS-THAN-242-TONE-RU");
+	PFLAG(PHY, 9, RX_1024_QAM_LESS_THAN_242_TONE_RU,
+	      "RX-1024-QAM-LESS-THAN-242-TONE-RU");
+	PFLAG(PHY, 9, RX_FULL_BW_SU_USING_MU_WITH_COMP_SIGB,
+	      "RX-FULL-BW-SU-USING-MU-WITH-COMP-SIGB");
+	PFLAG(PHY, 9, RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB,
+	      "RX-FULL-BW-SU-USING-MU-WITH-NON-COMP-SIGB");
 
 #undef PFLAG_RANGE_DEFAULT
 #undef PFLAG_RANGE
-- 
2.18.0
