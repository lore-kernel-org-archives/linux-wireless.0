Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45284 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727479AbeHaMh6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:37:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ido Yariv <idox.yariv@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:03 +0300
Message-Id: <20180831083130.15525-2-luca@coelho.fi> (sfid-20180831_103151_219549_87A63D5A)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 01/28] mac80211: Add he_capa debugfs entry
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <idox.yariv@intel.com>

Export HE capabilities information via debugfs, similar to HT & VHT.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/debugfs_sta.c | 325 +++++++++++++++++++++++++++++++++++++
 1 file changed, 325 insertions(+)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 4105081dc1df..de66f685a107 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -4,6 +4,7 @@
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -487,12 +488,335 @@ static ssize_t sta_vht_capa_read(struct file *file, char __user *userbuf,
 			p += scnprintf(p, sizeof(buf)+buf-p,
 				       "MCS TX highest: %d Mbps\n",
 				       le16_to_cpu(vhtc->vht_mcs.tx_highest));
+#undef PFLAG
 	}
 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
 }
 STA_OPS(vht_capa);
 
+static ssize_t sta_he_capa_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	char *buf, *p;
+	size_t buf_sz = PAGE_SIZE;
+	struct sta_info *sta = file->private_data;
+	struct ieee80211_sta_he_cap *hec = &sta->sta.he_cap;
+	struct ieee80211_he_mcs_nss_supp *nss = &hec->he_mcs_nss_supp;
+	u8 ppe_size;
+	u8 *cap;
+	int i;
+	ssize_t ret;
+
+	buf = kmalloc(buf_sz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	p = buf;
+
+	p += scnprintf(p, buf_sz + buf - p, "HE %ssupported\n",
+		       hec->has_he ? "" : "not ");
+	if (!hec->has_he)
+		goto out;
+
+	cap = hec->he_cap_elem.mac_cap_info;
+	p += scnprintf(p, buf_sz + buf - p,
+		       "MAC-CAP: %#.2x %#.2x %#.2x %#.2x %#.2x\n",
+		       cap[0], cap[1], cap[2], cap[3], cap[4]);
+
+#define PRINT(fmt, ...)							\
+	p += scnprintf(p, buf_sz + buf - p, "\t\t" fmt "\n",		\
+		       ##__VA_ARGS__)
+
+#define PFLAG(t, n, a, b)						\
+	do {								\
+		if (cap[n] & IEEE80211_HE_##t##_CAP##n##_##a)		\
+			PRINT("%s", b);					\
+	} while (0)
+
+#define PFLAG_RANGE(t, i, n, s, m, off, fmt)				\
+	do {								\
+		u8 msk = IEEE80211_HE_##t##_CAP##i##_##n##_MASK;	\
+		u8 idx = ((cap[i] & msk) >> (ffs(msk) - 1)) + off;	\
+		PRINT(fmt, (s << idx) + (m * idx));			\
+	} while (0)
+
+#define PFLAG_RANGE_DEFAULT(t, i, n, s, m, off, fmt, a, b)		\
+	do {								\
+		if (cap[i] == IEEE80211_HE_##t ##_CAP##i##_##n##_##a) {	\
+			PRINT("%s", b);					\
+			break;						\
+		}							\
+		PFLAG_RANGE(t, i, n, s, m, off, fmt);			\
+	} while (0)
+
+	PFLAG(MAC, 0, HTC_HE, "HTC-HE");
+	PFLAG(MAC, 0, TWT_REQ, "TWT-REQ");
+	PFLAG(MAC, 0, TWT_RES, "TWT-RES");
+	PFLAG_RANGE_DEFAULT(MAC, 0, DYNAMIC_FRAG, 0, 1, 0,
+			    "DYNAMIC-FRAG-LEVEL-%d", NOT_SUPP, "NOT-SUPP");
+	PFLAG_RANGE_DEFAULT(MAC, 0, MAX_NUM_FRAG_MSDU, 1, 0, 0,
+			    "MAX-NUM-FRAG-MSDU-%d", UNLIMITED, "UNLIMITED");
+
+	PFLAG_RANGE_DEFAULT(MAC, 1, MIN_FRAG_SIZE, 128, 0, -1,
+			    "MIN-FRAG-SIZE-%d", UNLIMITED, "UNLIMITED");
+	PFLAG_RANGE_DEFAULT(MAC, 1, TF_MAC_PAD_DUR, 0, 8, 0,
+			    "TF-MAC-PAD-DUR-%dUS", MASK, "UNKNOWN");
+	PFLAG_RANGE(MAC, 1, MULTI_TID_AGG_QOS, 0, 1, 1, "MULTI-TID-AGG-QOS-%d");
+
+	if (cap[0] & IEEE80211_HE_MAC_CAP0_HTC_HE) {
+		switch (((cap[2] << 1) | (cap[1] >> 7)) & 0x3) {
+		case 0:
+			PRINT("LINK-ADAPTATION-NO-FEEDBACK");
+			break;
+		case 1:
+			PRINT("LINK-ADAPTATION-RESERVED");
+			break;
+		case 2:
+			PRINT("LINK-ADAPTATION-UNSOLICITED-FEEDBACK");
+			break;
+		case 3:
+			PRINT("LINK-ADAPTATION-BOTH");
+			break;
+		}
+	}
+
+	PFLAG(MAC, 2, ALL_ACK, "ALL-ACK");
+	PFLAG(MAC, 2, UL_MU_RESP_SCHED, "UL-MU-RESP-SCHED");
+	PFLAG(MAC, 2, BSR, "BSR");
+	PFLAG(MAC, 2, BCAST_TWT, "BCAST-TWT");
+	PFLAG(MAC, 2, 32BIT_BA_BITMAP, "32BIT-BA-BITMAP");
+	PFLAG(MAC, 2, MU_CASCADING, "MU-CASCADING");
+	PFLAG(MAC, 2, ACK_EN, "ACK-EN");
+
+	PFLAG(MAC, 3, GRP_ADDR_MULTI_STA_BA_DL_MU,
+	      "GRP-ADDR-MULTI-STA-BA-DL-MU");
+	PFLAG(MAC, 3, OMI_CONTROL, "OMI-CONTROL");
+	PFLAG(MAC, 3, OFDMA_RA, "OFDMA-RA");
+
+	switch (cap[3] & IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_MASK) {
+	case IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_USE_VHT:
+		PRINT("MAX-A-AMPDU-LEN-EXP-USE-VHT");
+		break;
+	case IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_VHT_1:
+		PRINT("MAX-A-AMPDU-LEN-EXP-VHT-1");
+		break;
+	case IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_VHT_2:
+		PRINT("MAX-A-AMPDU-LEN-EXP-VHT-2");
+		break;
+	case IEEE80211_HE_MAC_CAP3_MAX_A_AMPDU_LEN_EXP_RESERVED:
+		PRINT("MAX-A-AMPDU-LEN-EXP-RESERVED");
+		break;
+	}
+
+	PFLAG(MAC, 3, A_AMSDU_FRAG, "A-AMSDU-FRAG");
+	PFLAG(MAC, 3, FLEX_TWT_SCHED, "FLEX-TWT-SCHED");
+	PFLAG(MAC, 3, RX_CTRL_FRAME_TO_MULTIBSS, "RX-CTRL-FRAME-TO-MULTIBSS");
+
+	PFLAG(MAC, 4, BSRP_BQRP_A_MPDU_AGG, "BSRP-BQRP-A-MPDU-AGG");
+	PFLAG(MAC, 4, QTP, "QTP");
+	PFLAG(MAC, 4, BQR, "BQR");
+	PFLAG(MAC, 4, SR_RESP, "SR-RESP");
+	PFLAG(MAC, 4, NDP_FB_REP, "NDP-FB-REP");
+	PFLAG(MAC, 4, OPS, "OPS");
+	PFLAG(MAC, 4, AMDSU_IN_AMPDU, "AMSDU-IN-AMPDU");
+
+	cap = hec->he_cap_elem.phy_cap_info;
+	p += scnprintf(p, buf_sz + buf - p,
+		       "PHY CAP: %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x %#.2x\n",
+		       cap[0], cap[1], cap[2], cap[3], cap[4], cap[5], cap[6],
+		       cap[7], cap[8]);
+
+	PFLAG(PHY, 0, DUAL_BAND, "DUAL-BAND");
+
+	PFLAG(PHY, 0, CHANNEL_WIDTH_SET_40MHZ_IN_2G,
+	      "CHANNEL-WIDTH-SET-40MHZ-IN-2G");
+	PFLAG(PHY, 0, CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G,
+	      "CHANNEL-WIDTH-SET-40MHZ-80MHZ-IN-5G");
+	PFLAG(PHY, 0, CHANNEL_WIDTH_SET_160MHZ_IN_5G,
+	      "CHANNEL-WIDTH-SET-160MHZ-IN-5G");
+	PFLAG(PHY, 0, CHANNEL_WIDTH_SET_80PLUS80_MHZ_IN_5G,
+	      "CHANNEL-WIDTH-SET-80PLUS80-MHZ-IN-5G");
+	PFLAG(PHY, 0, CHANNEL_WIDTH_SET_RU_MAPPING_IN_2G,
+	      "CHANNEL-WIDTH-SET-RU-MAPPING-IN-2G");
+	PFLAG(PHY, 0, CHANNEL_WIDTH_SET_RU_MAPPING_IN_5G,
+	      "CHANNEL-WIDTH-SET-RU-MAPPING-IN-5G");
+
+	switch (cap[1] & IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_MASK) {
+	case IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_80MHZ_ONLY_SECOND_20MHZ:
+		PRINT("PREAMBLE-PUNC-RX-80MHZ-ONLY-SECOND-20MHZ");
+		break;
+	case IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_80MHZ_ONLY_SECOND_40MHZ:
+		PRINT("PREAMBLE-PUNC-RX-80MHZ-ONLY-SECOND-40MHZ");
+		break;
+	case IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_160MHZ_ONLY_SECOND_20MHZ:
+		PRINT("PREAMBLE-PUNC-RX-160MHZ-ONLY-SECOND-20MHZ");
+		break;
+	case IEEE80211_HE_PHY_CAP1_PREAMBLE_PUNC_RX_160MHZ_ONLY_SECOND_40MHZ:
+		PRINT("PREAMBLE-PUNC-RX-160MHZ-ONLY-SECOND-40MHZ");
+		break;
+	}
+
+	PFLAG(PHY, 1, DEVICE_CLASS_A,
+	      "IEEE80211-HE-PHY-CAP1-DEVICE-CLASS-A");
+	PFLAG(PHY, 1, LDPC_CODING_IN_PAYLOAD,
+	      "LDPC-CODING-IN-PAYLOAD");
+	PFLAG(PHY, 1, HE_LTF_AND_GI_FOR_HE_PPDUS_0_8US,
+	      "HY-CAP1-HE-LTF-AND-GI-FOR-HE-PPDUS-0-8US");
+	PRINT("MIDAMBLE-RX-MAX-NSTS-%d", ((cap[2] << 1) | (cap[1] >> 7)) & 0x3);
+
+	PFLAG(PHY, 2, NDP_4x_LTF_AND_3_2US, "NDP-4X-LTF-AND-3-2US");
+	PFLAG(PHY, 2, STBC_TX_UNDER_80MHZ, "STBC-TX-UNDER-80MHZ");
+	PFLAG(PHY, 2, STBC_RX_UNDER_80MHZ, "STBC-RX-UNDER-80MHZ");
+	PFLAG(PHY, 2, DOPPLER_TX, "DOPPLER-TX");
+	PFLAG(PHY, 2, DOPPLER_RX, "DOPPLER-RX");
+	PFLAG(PHY, 2, UL_MU_FULL_MU_MIMO, "UL-MU-FULL-MU-MIMO");
+	PFLAG(PHY, 2, UL_MU_PARTIAL_MU_MIMO, "UL-MU-PARTIAL-MU-MIMO");
+
+	switch (cap[3] & IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_MASK) {
+	case IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_NO_DCM:
+		PRINT("DCM-MAX-CONST-TX-NO-DCM");
+		break;
+	case IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_BPSK:
+		PRINT("DCM-MAX-CONST-TX-BPSK");
+		break;
+	case IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_QPSK:
+		PRINT("DCM-MAX-CONST-TX-QPSK");
+		break;
+	case IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_16_QAM:
+		PRINT("DCM-MAX-CONST-TX-16-QAM");
+		break;
+	}
+
+	PFLAG(PHY, 3, DCM_MAX_TX_NSS_1, "DCM-MAX-TX-NSS-1");
+	PFLAG(PHY, 3, DCM_MAX_TX_NSS_2, "DCM-MAX-TX-NSS-2");
+
+	switch (cap[3] & IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_MASK) {
+	case IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_NO_DCM:
+		PRINT("DCM-MAX-CONST-RX-NO-DCM");
+		break;
+	case IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_BPSK:
+		PRINT("DCM-MAX-CONST-RX-BPSK");
+		break;
+	case IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_QPSK:
+		PRINT("DCM-MAX-CONST-RX-QPSK");
+		break;
+	case IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_16_QAM:
+		PRINT("DCM-MAX-CONST-RX-16-QAM");
+		break;
+	}
+
+	PFLAG(PHY, 3, DCM_MAX_RX_NSS_1, "DCM-MAX-RX-NSS-1");
+	PFLAG(PHY, 3, DCM_MAX_RX_NSS_2, "DCM-MAX-RX-NSS-2");
+	PFLAG(PHY, 3, RX_HE_MU_PPDU_FROM_NON_AP_STA,
+	      "RX-HE-MU-PPDU-FROM-NON-AP-STA");
+	PFLAG(PHY, 3, SU_BEAMFORMER, "SU-BEAMFORMER");
+
+	PFLAG(PHY, 4, SU_BEAMFORMEE, "SU-BEAMFORMEE");
+	PFLAG(PHY, 4, MU_BEAMFORMER, "MU-BEAMFORMER");
+
+	PFLAG_RANGE(PHY, 4, BEAMFORMEE_MAX_STS_UNDER_80MHZ, 0, 1, 4,
+		    "BEAMFORMEE-MAX-STS-UNDER-%d");
+	PFLAG_RANGE(PHY, 4, BEAMFORMEE_MAX_STS_ABOVE_80MHZ, 0, 1, 4,
+		    "BEAMFORMEE-MAX-STS-ABOVE-%d");
+
+	PFLAG_RANGE(PHY, 5, BEAMFORMEE_NUM_SND_DIM_UNDER_80MHZ, 0, 1, 1,
+		    "NUM-SND-DIM-UNDER-80MHZ-%d");
+	PFLAG_RANGE(PHY, 5, BEAMFORMEE_NUM_SND_DIM_ABOVE_80MHZ, 0, 1, 1,
+		    "NUM-SND-DIM-ABOVE-80MHZ-%d");
+	PFLAG(PHY, 5, NG16_SU_FEEDBACK, "NG16-SU-FEEDBACK");
+	PFLAG(PHY, 5, NG16_MU_FEEDBACK, "NG16-MU-FEEDBACK");
+
+	PFLAG(PHY, 6, CODEBOOK_SIZE_42_SU, "CODEBOOK-SIZE-42-SU");
+	PFLAG(PHY, 6, CODEBOOK_SIZE_75_MU, "CODEBOOK-SIZE-75-MU");
+	PFLAG(PHY, 6, TRIG_SU_BEAMFORMER_FB, "TRIG-SU-BEAMFORMER-FB");
+	PFLAG(PHY, 6, TRIG_MU_BEAMFORMER_FB, "TRIG-MU-BEAMFORMER-FB");
+	PFLAG(PHY, 6, TRIG_CQI_FB, "TRIG-CQI-FB");
+	PFLAG(PHY, 6, PARTIAL_BW_EXT_RANGE, "PARTIAL-BW-EXT-RANGE");
+	PFLAG(PHY, 6, PARTIAL_BANDWIDTH_DL_MUMIMO,
+	      "PARTIAL-BANDWIDTH-DL-MUMIMO");
+	PFLAG(PHY, 6, PPE_THRESHOLD_PRESENT, "PPE-THRESHOLD-PRESENT");
+
+	PFLAG(PHY, 7, SRP_BASED_SR, "SRP-BASED-SR");
+	PFLAG(PHY, 7, POWER_BOOST_FACTOR_AR, "POWER-BOOST-FACTOR-AR");
+	PFLAG(PHY, 7, HE_SU_MU_PPDU_4XLTF_AND_08_US_GI,
+	      "HE-SU-MU-PPDU-4XLTF-AND-08-US-GI");
+	PFLAG_RANGE(PHY, 7, MAX_NC, 0, 1, 1, "MAX-NC-%d");
+	PFLAG(PHY, 7, STBC_TX_ABOVE_80MHZ, "STBC-TX-ABOVE-80MHZ");
+	PFLAG(PHY, 7, STBC_RX_ABOVE_80MHZ, "STBC-RX-ABOVE-80MHZ");
+
+	PFLAG(PHY, 8, HE_ER_SU_PPDU_4XLTF_AND_08_US_GI,
+	      "HE-ER-SU-PPDU-4XLTF-AND-08-US-GI");
+	PFLAG(PHY, 8, 20MHZ_IN_40MHZ_HE_PPDU_IN_2G,
+	      "20MHZ-IN-40MHZ-HE-PPDU-IN-2G");
+	PFLAG(PHY, 8, 20MHZ_IN_160MHZ_HE_PPDU, "20MHZ-IN-160MHZ-HE-PPDU");
+	PFLAG(PHY, 8, 80MHZ_IN_160MHZ_HE_PPDU, "80MHZ-IN-160MHZ-HE-PPDU");
+	PFLAG(PHY, 8, HE_ER_SU_1XLTF_AND_08_US_GI,
+	      "HE-ER-SU-1XLTF-AND-08-US-GI");
+	PFLAG(PHY, 8, MIDAMBLE_RX_2X_AND_1XLTF, "MIDAMBLE-RX-2X-AND-1XLTF");
+
+#undef PFLAG_RANGE_DEFAULT
+#undef PFLAG_RANGE
+#undef PFLAG
+
+#define PRINT_NSS_SUPP(f, n)						\
+	do {								\
+		int i;							\
+		u16 v = le16_to_cpu(nss->f);				\
+		p += scnprintf(p, buf_sz + buf - p, n ": %#.4x\n", v);	\
+		for (i = 0; i < 8; i += 2) {				\
+			switch ((v >> i) & 0x3) {			\
+			case 0:						\
+				PRINT(n "-%d-SUPPORT-0-7", i / 2);	\
+				break;					\
+			case 1:						\
+				PRINT(n "-%d-SUPPORT-0-9", i / 2);	\
+				break;					\
+			case 2:						\
+				PRINT(n "-%d-SUPPORT-0-11", i / 2);	\
+				break;					\
+			case 3:						\
+				PRINT(n "-%d-NOT-SUPPORTED", i / 2);	\
+				break;					\
+			}						\
+		}							\
+	} while (0)
+
+	PRINT_NSS_SUPP(rx_mcs_80, "RX-MCS-80");
+	PRINT_NSS_SUPP(tx_mcs_80, "TX-MCS-80");
+
+	if (cap[0] & IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G) {
+		PRINT_NSS_SUPP(rx_mcs_160, "RX-MCS-160");
+		PRINT_NSS_SUPP(tx_mcs_160, "TX-MCS-160");
+	}
+
+	if (cap[0] &
+	    IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_80PLUS80_MHZ_IN_5G) {
+		PRINT_NSS_SUPP(rx_mcs_80p80, "RX-MCS-80P80");
+		PRINT_NSS_SUPP(tx_mcs_80p80, "TX-MCS-80P80");
+	}
+
+#undef PRINT_NSS_SUPP
+#undef PRINT
+
+	if (!(cap[6] & IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT))
+		goto out;
+
+	p += scnprintf(p, buf_sz + buf - p, "PPE-THRESHOLDS: %#.2x",
+		       hec->ppe_thres[0]);
+
+	ppe_size = ieee80211_he_ppe_size(hec->ppe_thres[0], cap);
+	for (i = 1; i < ppe_size; i++) {
+		p += scnprintf(p, buf_sz + buf - p, " %#.2x",
+			       hec->ppe_thres[i]);
+	}
+	p += scnprintf(p, buf_sz + buf - p, "\n");
+
+out:
+	ret = simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+	kfree(buf);
+	return ret;
+}
+STA_OPS(he_capa);
 
 #define DEBUGFS_ADD(name) \
 	debugfs_create_file(#name, 0400, \
@@ -538,6 +862,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(agg_status);
 	DEBUGFS_ADD(ht_capa);
 	DEBUGFS_ADD(vht_capa);
+	DEBUGFS_ADD(he_capa);
 
 	DEBUGFS_ADD_COUNTER(rx_duplicates, rx_stats.num_duplicates);
 	DEBUGFS_ADD_COUNTER(rx_fragments, rx_stats.fragments);
-- 
2.18.0
