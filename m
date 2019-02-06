Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624A9C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26EBD2080D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbfBFLTc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:19:32 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55792 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728996AbfBFLTc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:19:32 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLD0-0001ED-6h; Wed, 06 Feb 2019 13:17:38 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:20 +0200
Message-Id: <20190206111721.29283-15-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206111721.29283-1-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/15] mac80211: update HE IEs to D3.3
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Liad Kaufman <liad.kaufman@intel.com>

Update element names and new fields according to D3.3 of
the HE spec.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/mac.h   | 26 ++++++++-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 58 +++++++------------
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 40 +++++++++++++
 include/linux/ieee80211.h                     | 22 ++++---
 net/mac80211/debugfs_sta.c                    | 35 +++++++----
 5 files changed, 125 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
index 7a3f7b7e6358..941c50477003 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2017        Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -29,7 +29,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2017        Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -433,6 +433,28 @@ struct iwl_he_backoff_conf {
 	__le16 mu_time;
 } __packed; /* AC_QOS_DOT11AX_API_S */
 
+/**
+ * enum iwl_he_pkt_ext_constellations - PPE constellation indices
+ * @IWL_HE_PKT_EXT_BPSK: BPSK
+ * @IWL_HE_PKT_EXT_QPSK:  QPSK
+ * @IWL_HE_PKT_EXT_16QAM: 16-QAM
+ * @IWL_HE_PKT_EXT_64QAM: 64-QAM
+ * @IWL_HE_PKT_EXT_256QAM: 256-QAM
+ * @IWL_HE_PKT_EXT_1024QAM: 1024-QAM
+ * @IWL_HE_PKT_EXT_RESERVED: reserved value
+ * @IWL_HE_PKT_EXT_NONE: not defined
+ */
+enum iwl_he_pkt_ext_constellations {
+	IWL_HE_PKT_EXT_BPSK = 0,
+	IWL_HE_PKT_EXT_QPSK,
+	IWL_HE_PKT_EXT_16QAM,
+	IWL_HE_PKT_EXT_64QAM,
+	IWL_HE_PKT_EXT_256QAM,
+	IWL_HE_PKT_EXT_1024QAM,
+	IWL_HE_PKT_EXT_RESERVED,
+	IWL_HE_PKT_EXT_NONE,
+};
+
 #define MAX_HE_SUPP_NSS	2
 #define MAX_HE_CHANNEL_BW_INDX	4
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index d9afedc3d1d9..e1178b09c4d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -479,7 +479,6 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
 				.mac_cap_info[2] =
 					IEEE80211_HE_MAC_CAP2_32BIT_BA_BITMAP |
-					IEEE80211_HE_MAC_CAP2_MU_CASCADING |
 					IEEE80211_HE_MAC_CAP2_ACK_EN,
 				.mac_cap_info[3] =
 					IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
@@ -490,7 +489,9 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 				.mac_cap_info[5] =
 					IEEE80211_HE_MAC_CAP5_MULTI_TID_AGG_TX_QOS_B40 |
 					IEEE80211_HE_MAC_CAP5_MULTI_TID_AGG_TX_QOS_B41 |
-					IEEE80211_HE_MAC_CAP5_UL_2x996_TONE_RU,
+					IEEE80211_HE_MAC_CAP5_UL_2x996_TONE_RU |
+					IEEE80211_HE_MAC_CAP5_HE_DYNAMIC_SM_PS |
+					IEEE80211_HE_MAC_CAP5_HT_VHT_TRIG_FRAME_RX,
 				.phy_cap_info[0] =
 					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_IN_2G |
 					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G |
@@ -498,18 +499,13 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 				.phy_cap_info[1] =
 					IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_MASK |
 					IEEE80211_HE_PHY_CAP1_DEVICE_CLASS_A |
-					IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD |
-					IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS,
+					IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD,
 				.phy_cap_info[2] =
-					IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US |
-					IEEE80211_HE_PHY_CAP2_STBC_TX_UNDER_80MHZ |
-					IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ |
-					IEEE80211_HE_PHY_CAP2_UL_MU_FULL_MU_MIMO |
-					IEEE80211_HE_PHY_CAP2_UL_MU_PARTIAL_MU_MIMO,
+					IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US,
 				.phy_cap_info[3] =
-					IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_BPSK |
+					IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_NO_DCM |
 					IEEE80211_HE_PHY_CAP3_DCM_MAX_TX_NSS_1 |
-					IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_BPSK |
+					IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_NO_DCM |
 					IEEE80211_HE_PHY_CAP3_DCM_MAX_RX_NSS_1,
 				.phy_cap_info[4] =
 					IEEE80211_HE_PHY_CAP4_SU_BEAMFORMEE |
@@ -517,16 +513,8 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 					IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_UNDER_80MHZ_8,
 				.phy_cap_info[5] =
 					IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_UNDER_80MHZ_2 |
-					IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_ABOVE_80MHZ_2 |
-					IEEE80211_HE_PHY_CAP5_NG16_SU_FEEDBACK |
-					IEEE80211_HE_PHY_CAP5_NG16_MU_FEEDBACK,
+					IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_ABOVE_80MHZ_2,
 				.phy_cap_info[6] =
-					IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_42_SU |
-					IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_75_MU |
-					IEEE80211_HE_PHY_CAP6_TRIG_SU_BEAMFORMER_FB |
-					IEEE80211_HE_PHY_CAP6_TRIG_MU_BEAMFORMER_FB |
-					IEEE80211_HE_PHY_CAP6_TRIG_CQI_FB |
-					IEEE80211_HE_PHY_CAP6_PARTIAL_BANDWIDTH_DL_MUMIMO |
 					IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT,
 				.phy_cap_info[7] =
 					IEEE80211_HE_PHY_CAP7_POWER_BOOST_FACTOR_AR |
@@ -537,11 +525,12 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 					IEEE80211_HE_PHY_CAP8_20MHZ_IN_40MHZ_HE_PPDU_IN_2G |
 					IEEE80211_HE_PHY_CAP8_20MHZ_IN_160MHZ_HE_PPDU |
 					IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU |
-					IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_160_OR_80P80_MHZ,
+					IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_2x996,
 				.phy_cap_info[9] =
 					IEEE80211_HE_PHY_CAP9_NON_TRIGGERED_CQI_FEEDBACK |
 					IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_COMP_SIGB |
-					IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB,
+					IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB |
+					IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_RESERVED,
 			},
 			/*
 			 * Set default Tx/Rx HE MCS NSS Support field.
@@ -576,28 +565,26 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
 				.mac_cap_info[2] =
 					IEEE80211_HE_MAC_CAP2_BSR |
-					IEEE80211_HE_MAC_CAP2_MU_CASCADING |
 					IEEE80211_HE_MAC_CAP2_ACK_EN,
 				.mac_cap_info[3] =
 					IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
 					IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2,
 				.mac_cap_info[4] =
 					IEEE80211_HE_MAC_CAP4_AMDSU_IN_AMPDU,
+				.mac_cap_info[5] =
+					IEEE80211_HE_MAC_CAP5_UL_2x996_TONE_RU,
 				.phy_cap_info[0] =
 					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_IN_2G |
 					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G |
 					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G,
 				.phy_cap_info[1] =
-					IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD |
-					IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS,
+					IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD,
 				.phy_cap_info[2] =
-					IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US |
-					IEEE80211_HE_PHY_CAP2_STBC_TX_UNDER_80MHZ |
-					IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ,
+					IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US,
 				.phy_cap_info[3] =
-					IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_BPSK |
+					IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_NO_DCM |
 					IEEE80211_HE_PHY_CAP3_DCM_MAX_TX_NSS_1 |
-					IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_BPSK |
+					IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_NO_DCM |
 					IEEE80211_HE_PHY_CAP3_DCM_MAX_RX_NSS_1,
 				.phy_cap_info[4] =
 					IEEE80211_HE_PHY_CAP4_SU_BEAMFORMEE |
@@ -605,12 +592,8 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 					IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_UNDER_80MHZ_8,
 				.phy_cap_info[5] =
 					IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_UNDER_80MHZ_2 |
-					IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_ABOVE_80MHZ_2 |
-					IEEE80211_HE_PHY_CAP5_NG16_SU_FEEDBACK |
-					IEEE80211_HE_PHY_CAP5_NG16_MU_FEEDBACK,
+					IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_ABOVE_80MHZ_2,
 				.phy_cap_info[6] =
-					IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_42_SU |
-					IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_75_MU |
 					IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT,
 				.phy_cap_info[7] =
 					IEEE80211_HE_PHY_CAP7_HE_SU_MU_PPDU_4XLTF_AND_08_US_GI |
@@ -620,10 +603,11 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 					IEEE80211_HE_PHY_CAP8_20MHZ_IN_40MHZ_HE_PPDU_IN_2G |
 					IEEE80211_HE_PHY_CAP8_20MHZ_IN_160MHZ_HE_PPDU |
 					IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU |
-					IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_160_OR_80P80_MHZ,
+					IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_2x996,
 				.phy_cap_info[9] =
 					IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_COMP_SIGB |
-					IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB,
+					IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB |
+					IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_RESERVED,
 			},
 			/*
 			 * Set default Tx/Rx HE MCS NSS Support field.
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 97dc464379d2..47d65adfa3e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2076,6 +2076,46 @@ static void iwl_mvm_cfg_he_sta(struct iwl_mvm *mvm,
 		}
 
 		flags |= STA_CTXT_HE_PACKET_EXT;
+	} else if ((sta->he_cap.he_cap_elem.phy_cap_info[9] &
+		    IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_MASK) !=
+		  IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_RESERVED) {
+		int low_th = -1;
+		int high_th = -1;
+
+		/* Take the PPE thresholds from the nominal padding info */
+		switch (sta->he_cap.he_cap_elem.phy_cap_info[9] &
+			IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_MASK) {
+		case IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_0US:
+			low_th = IWL_HE_PKT_EXT_NONE;
+			high_th = IWL_HE_PKT_EXT_NONE;
+			break;
+		case IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_8US:
+			low_th = IWL_HE_PKT_EXT_BPSK;
+			high_th = IWL_HE_PKT_EXT_NONE;
+			break;
+		case IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_16US:
+			low_th = IWL_HE_PKT_EXT_NONE;
+			high_th = IWL_HE_PKT_EXT_BPSK;
+			break;
+		}
+
+		/* Set the PPE thresholds accordingly */
+		if (low_th >= 0 && high_th >= 0) {
+			u8 ***pkt_ext_qam =
+				(void *)sta_ctxt_cmd.pkt_ext.pkt_ext_qam_th;
+
+			for (i = 0; i < MAX_HE_SUPP_NSS; i++) {
+				u8 bw;
+
+				for (bw = 0; bw < MAX_HE_CHANNEL_BW_INDX;
+				     bw++) {
+					pkt_ext_qam[i][bw][0] = low_th;
+					pkt_ext_qam[i][bw][1] = high_th;
+				}
+			}
+
+			flags |= STA_CTXT_HE_PACKET_EXT;
+		}
 	}
 	rcu_read_unlock();
 
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ab3bf6f08f67..57e855581709 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1803,6 +1803,9 @@ int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
 #define IEEE80211_HE_MAC_CAP5_SUBCHAN_SELECVITE_TRANSMISSION	0x04
 #define IEEE80211_HE_MAC_CAP5_UL_2x996_TONE_RU			0x08
 #define IEEE80211_HE_MAC_CAP5_OM_CTRL_UL_MU_DATA_DIS_RX		0x10
+#define IEEE80211_HE_MAC_CAP5_HE_DYNAMIC_SM_PS			0x20
+#define IEEE80211_HE_MAC_CAP5_PUNCTURED_SOUNDING		0x40
+#define IEEE80211_HE_MAC_CAP5_HT_VHT_TRIG_FRAME_RX		0x80
 
 /* 802.11ax HE PHY capabilities */
 #define IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_IN_2G		0x02
@@ -1926,11 +1929,11 @@ int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
 #define IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU			0x08
 #define IEEE80211_HE_PHY_CAP8_HE_ER_SU_1XLTF_AND_08_US_GI		0x10
 #define IEEE80211_HE_PHY_CAP8_MIDAMBLE_RX_TX_2X_AND_1XLTF		0x20
-#define IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_20MHZ				0x00
-#define IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_40MHZ				0x40
-#define IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_80MHZ				0x80
-#define IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_160_OR_80P80_MHZ		0xc0
-#define IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_MASK				0xc0
+#define IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_242				0x00
+#define IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_484				0x40
+#define IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_996				0x80
+#define IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_2x996				0xc0
+#define IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_MASK				0xc0
 
 #define IEEE80211_HE_PHY_CAP9_LONGER_THAN_16_SIGB_OFDM_SYM		0x01
 #define IEEE80211_HE_PHY_CAP9_NON_TRIGGERED_CQI_FEEDBACK		0x02
@@ -1938,6 +1941,11 @@ int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
 #define IEEE80211_HE_PHY_CAP9_RX_1024_QAM_LESS_THAN_242_TONE_RU		0x08
 #define IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_COMP_SIGB	0x10
 #define IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB	0x20
+#define IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_0US			0x00
+#define IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_8US			0x40
+#define IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_16US			0x80
+#define IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_RESERVED		0xc0
+#define IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_MASK			0xc0
 
 /* 802.11ax HE TX/RX MCS NSS Support  */
 #define IEEE80211_TX_RX_MCS_NSS_SUPP_HIGHEST_MCS_POS			(3)
@@ -2016,7 +2024,7 @@ ieee80211_he_ppe_size(u8 ppe_thres_hdr, const u8 *phy_cap_info)
 #define IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK		0x00003ff0
 #define IEEE80211_HE_OPERATION_RTS_THRESHOLD_OFFSET		4
 #define IEEE80211_HE_OPERATION_VHT_OPER_INFO			0x00004000
-#define IEEE80211_HE_OPERATION_CO_LOCATED_BSS			0x00008000
+#define IEEE80211_HE_OPERATION_CO_HOSTED_BSS			0x00008000
 #define IEEE80211_HE_OPERATION_ER_SU_DISABLE			0x00010000
 #define IEEE80211_HE_OPERATION_BSS_COLOR_MASK			0x3f000000
 #define IEEE80211_HE_OPERATION_BSS_COLOR_OFFSET		24
@@ -2046,7 +2054,7 @@ ieee80211_he_oper_size(const u8 *he_oper_ie)
 	he_oper_params = le32_to_cpu(he_oper->he_oper_params);
 	if (he_oper_params & IEEE80211_HE_OPERATION_VHT_OPER_INFO)
 		oper_len += 3;
-	if (he_oper_params & IEEE80211_HE_OPERATION_CO_LOCATED_BSS)
+	if (he_oper_params & IEEE80211_HE_OPERATION_CO_HOSTED_BSS)
 		oper_len++;
 
 	/* Add the first byte (extension ID) to the total length */
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 3aa618dcc58e..8e921281e0d5 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -4,7 +4,7 @@
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2016 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -685,6 +685,9 @@ static ssize_t sta_he_capa_read(struct file *file, char __user *userbuf,
 	      "SUBCHAN-SELECVITE-TRANSMISSION");
 	PFLAG(MAC, 5, UL_2x996_TONE_RU, "UL-2x996-TONE-RU");
 	PFLAG(MAC, 5, OM_CTRL_UL_MU_DATA_DIS_RX, "OM-CTRL-UL-MU-DATA-DIS-RX");
+	PFLAG(MAC, 5, HE_DYNAMIC_SM_PS, "HE-DYNAMIC-SM-PS");
+	PFLAG(MAC, 5, PUNCTURED_SOUNDING, "PUNCTURED-SOUNDING");
+	PFLAG(MAC, 5, HT_VHT_TRIG_FRAME_RX, "HT-VHT-TRIG-FRAME-RX");
 
 	cap = hec->he_cap_elem.phy_cap_info;
 	p += scnprintf(p, buf_sz + buf - p,
@@ -819,18 +822,18 @@ static ssize_t sta_he_capa_read(struct file *file, char __user *userbuf,
 	PFLAG(PHY, 8, MIDAMBLE_RX_TX_2X_AND_1XLTF,
 	      "MIDAMBLE-RX-TX-2X-AND-1XLTF");
 
-	switch (cap[8] & IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_MASK) {
-	case IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_20MHZ:
-		PRINT("DDCM-MAX-BW-20MHZ");
+	switch (cap[8] & IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_MASK) {
+	case IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_242:
+		PRINT("DCM-MAX-RU-242");
 		break;
-	case IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_40MHZ:
-		PRINT("DCM-MAX-BW-40MHZ");
+	case IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_484:
+		PRINT("DCM-MAX-RU-484");
 		break;
-	case IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_80MHZ:
-		PRINT("DCM-MAX-BW-80MHZ");
+	case IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_996:
+		PRINT("DCM-MAX-RU-996");
 		break;
-	case IEEE80211_HE_PHY_CAP8_DCM_MAX_BW_160_OR_80P80_MHZ:
-		PRINT("DCM-MAX-BW-160-OR-80P80-MHZ");
+	case IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_2x996:
+		PRINT("DCM-MAX-RU-2x996");
 		break;
 	}
 
@@ -847,6 +850,18 @@ static ssize_t sta_he_capa_read(struct file *file, char __user *userbuf,
 	PFLAG(PHY, 9, RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB,
 	      "RX-FULL-BW-SU-USING-MU-WITH-NON-COMP-SIGB");
 
+	switch (cap[9] & IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_MASK) {
+	case IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_0US:
+		PRINT("NOMINAL-PACKET-PADDING-0US");
+		break;
+	case IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_8US:
+		PRINT("NOMINAL-PACKET-PADDING-8US");
+		break;
+	case IEEE80211_HE_PHY_CAP9_NOMIMAL_PKT_PADDING_16US:
+		PRINT("NOMINAL-PACKET-PADDING-16US");
+		break;
+	}
+
 #undef PFLAG_RANGE_DEFAULT
 #undef PFLAG_RANGE
 #undef PFLAG
-- 
2.20.1

