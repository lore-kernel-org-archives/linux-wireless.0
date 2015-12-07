Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34795 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbbLGVFE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 16:05:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Beni Lev <beni.lev@intel.com>,
	Anatol Pomozov <anatol.pomozov@gmail.com>,
	Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH 3/4] ieee80211: add FTM Parameters IE and extended capability
Date: Mon,  7 Dec 2015 22:04:52 +0100
Message-Id: <1449522293-13710-4-git-send-email-johannes@sipsolutions.net> (sfid-20151207_220519_833411_E8C1A111)
In-Reply-To: <1449522293-13710-1-git-send-email-johannes@sipsolutions.net>
References: <1449522293-13710-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

For FTM usage, this patch adds values and definitions for the FTM
Parameters IE, see IEEE 802.11 8.4.2.166 Fine Timing Measurement
Parameters element (in mc Draft only right now.)

Also add the extended capability bit for it.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 85 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 452c0b0d2f32..8262dc2a90ab 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2079,6 +2079,12 @@ enum ieee80211_tdls_actioncode {
 #define WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED	BIT(5)
 #define WLAN_EXT_CAPA8_OPMODE_NOTIF	BIT(6)
 
+/*
+ * Fine Timing Measurement Initiator - bit 71 of @WLAN_EID_EXT_CAPABILITY
+ * information element
+ */
+#define WLAN_EXT_CAPA9_FTM_INITIATOR	BIT(7)
+
 /* TDLS specific payload type in the LLC/SNAP header */
 #define WLAN_TDLS_SNAP_RFTYPE	0x2
 
@@ -2319,6 +2325,85 @@ struct ieee80211_tspec_ie {
 	__le16 medium_time;
 } __packed;
 
+enum ieee80211_ftm_status_indication {
+	IEEE80211_FTM_STATUS_IND_RESERVED = 0,
+	IEEE80211_FTM_STATUS_IND_SUCCESS,
+	IEEE80211_FTM_STATUS_IND_INCAPABLE,
+	IEEE80211_FTM_STATUS_IND_FAILED,
+};
+
+enum ieee80211_ftm_burst_duration {
+	IEEE80211_FTM_BURST_DUR_250_USEC = 2,
+	IEEE80211_FTM_BURST_DUR_500_USEC = 3,
+	IEEE80211_FTM_BURST_DUR_1_MSEC   = 4,
+	IEEE80211_FTM_BURST_DUR_2_MSEC   = 5,
+	IEEE80211_FTM_BURST_DUR_4_MSEC   = 6,
+	IEEE80211_FTM_BURST_DUR_8_MSEC   = 7,
+	IEEE80211_FTM_BURST_DUR_16_MSEC  = 8,
+	IEEE80211_FTM_BURST_DUR_32_MSEC  = 9,
+	IEEE80211_FTM_BURST_DUR_64_MSEC  = 10,
+	IEEE80211_FTM_BURST_DUR_128_MSEC = 11,
+	IEEE80211_FTM_BURST_DUR_NO_PREF  = 15,
+};
+
+enum ieee80211_ftm_format_and_bw {
+	IEEE80211_FTM_FORMAT_BW_NO_PREF           = 0,
+	IEEE80211_FTM_FORMAT_BW_NON_HT_5          = 4,
+	IEEE80211_FTM_FORMAT_BW_NON_HT_10         = 6,
+	IEEE80211_FTM_FORMAT_BW_NON_HT_20         = 8,
+	IEEE80211_FTM_FORMAT_BW_HT_20             = 9,
+	IEEE80211_FTM_FORMAT_BW_VHT_20            = 10,
+	IEEE80211_FTM_FORMAT_BW_HT_40             = 11,
+	IEEE80211_FTM_FORMAT_BW_VHT_40            = 12,
+	IEEE80211_FTM_FORMAT_BW_VHT_80            = 13,
+	IEEE80211_FTM_FORMAT_BW_VHT_80_80         = 14,
+	IEEE80211_FTM_FORMAT_BW_VHT_TWO_RF_LO_160 = 15,
+	IEEE80211_FTM_FORMAT_BW_VHT_ONE_RF_LO_160 = 16,
+	IEEE80211_FTM_FORMAT_BW_DMG_2160          = 31,
+};
+
+/**
+ * struct ieee80211_ftm_params_ie - IEEE802.11 spec definition
+ *
+ * struct defined according to spec's Figure 8-569 - "Fine Timing
+ * Measurement Parameters element format", and Figure 8-570 - "Fine Timing
+ * Measurement Parameters field format"
+ * Note: Spec refers to Draft 802.11REVmc_D4.3 (Oct. 2015)
+ */
+struct ieee80211_ftm_params_ie {
+	u8 element_id;
+	u8 len;
+	u8 status_info;
+	u8 burst_info;
+	u8 min_delta_ftm;
+	__le16 partial_tsf_timer;
+	u8 data1;
+	u8 data2;
+	__le16 burst_period;
+} __packed;
+
+#define IEEE80211_FTM_PARAMS_STATUS_IND_MASK 0x03
+#define IEEE80211_FTM_PARAMS_STATUS_IND_SHIFT 0
+#define IEEE80211_FTM_PARAMS_STATUS_VALUE_MASK 0x7C
+#define IEEE80211_FTM_PARAMS_STATUS_VALUE_SHIFT 2
+
+#define IEEE80211_FTM_PARAMS_BURST_EXPONENT_MASK 0x0F
+#define IEEE80211_FTM_PARAMS_BURST_EXPONENT_SHIFT 0
+#define IEEE80211_FTM_PARAMS_BURST_DURATION_MASK 0xF0
+#define IEEE80211_FTM_PARAMS_BURST_DURATION_SHIFT 4
+
+#define IEEE80211_FTM_PARAMS_DATA1_PARTIAL_TSF_TIMER_NP_MASK 0x01
+#define IEEE80211_FTM_PARAMS_DATA1_PARTIAL_TSF_TIMER_NP_SHIFT 0
+#define IEEE80211_FTM_PARAMS_DATA1_ASAP_CAPABLE_MASK 0x02
+#define IEEE80211_FTM_PARAMS_DATA1_ASAP_CAPABLE_SHIFT 1
+#define IEEE80211_FTM_PARAMS_DATA1_ASAP_MASK 0x04
+#define IEEE80211_FTM_PARAMS_DATA1_ASAP_SHIFT 2
+#define IEEE80211_FTM_PARAMS_DATA1_FTMS_PER_BURST_MASK 0xF8
+#define IEEE80211_FTM_PARAMS_DATA1_FTMS_PER_BURST_SHIFT 3
+
+#define IEEE80211_FTM_PARAMS_DATA2_FORMAT_AND_BW_MASK 0xFC
+#define IEEE80211_FTM_PARAMS_DATA2_FORMAT_AND_BW_SHIFT 2
+
 /**
  * ieee80211_get_qos_ctl - get pointer to qos control bytes
  * @hdr: the frame
-- 
2.6.2

