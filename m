Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59844 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751413AbdBOODB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 09:03:01 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 5/5] cfg80211: add support for HE MCSs
Date: Wed, 15 Feb 2017 15:02:56 +0100
Message-Id: <20170215140256.19455-5-johannes@sipsolutions.net> (sfid-20170215_150304_091083_D3B8A7A3)
In-Reply-To: <20170215140256.19455-1-johannes@sipsolutions.net>
References: <20170215140256.19455-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support for the HE MCSs in cfg80211 and also add userspace
API to nl80211 to send rate information out.

The bandwidth calculation is somewhat approximate to avoid all
the big tables that are otherwise necessary.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 15 +++++++--
 include/uapi/linux/nl80211.h | 42 +++++++++++++++++++++++
 net/wireless/nl80211.c       | 16 +++++++++
 net/wireless/util.c          | 80 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 151 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 86c12f85fb53..48af8d6b4fc7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -986,12 +986,14 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
  * @RATE_INFO_FLAGS_VHT_MCS: mcs field filled with VHT MCS
  * @RATE_INFO_FLAGS_SHORT_GI: 400ns guard interval
  * @RATE_INFO_FLAGS_60G: 60GHz MCS
+ * @RATE_INFO_FLAGS_HE_MCS: HE MCS information
  */
 enum rate_info_flags {
 	RATE_INFO_FLAGS_MCS			= BIT(0),
 	RATE_INFO_FLAGS_VHT_MCS			= BIT(1),
 	RATE_INFO_FLAGS_SHORT_GI		= BIT(2),
 	RATE_INFO_FLAGS_60G			= BIT(3),
+	RATE_INFO_FLAGS_HE_MCS			= BIT(4),
 };
 
 /**
@@ -1005,6 +1007,7 @@ enum rate_info_flags {
  * @RATE_INFO_BW_40: 40 MHz bandwidth
  * @RATE_INFO_BW_80: 80 MHz bandwidth
  * @RATE_INFO_BW_160: 160 MHz bandwidth
+ * @RATE_INFO_BW_HE_RU: bandwidth determined by HE RU allocation
  */
 enum rate_info_bw {
 	RATE_INFO_BW_5,
@@ -1013,6 +1016,7 @@ enum rate_info_bw {
 	RATE_INFO_BW_40,
 	RATE_INFO_BW_80,
 	RATE_INFO_BW_160,
+	RATE_INFO_BW_HE_RU,
 };
 
 /**
@@ -1021,10 +1025,14 @@ enum rate_info_bw {
  * Information about a receiving or transmitting bitrate
  *
  * @flags: bitflag of flags from &enum rate_info_flags
- * @mcs: mcs index if struct describes a 802.11n bitrate
+ * @mcs: mcs index if struct describes an HT/VHT/HE rate
  * @legacy: bitrate in 100kbit/s for 802.11abg
- * @nss: number of streams (VHT only)
+ * @nss: number of streams (VHT & HE only)
  * @bw: bandwidth (from &enum rate_info_bw)
+ * @he_gi: HE guard interval (from &enum nl80211_he_gi)
+ * @he_dcm: HE DCM value
+ * @he_ru_alloc: HE RU allocation (from &enum nl80211_he_ru_alloc,
+ *	only valid if bw is %RATE_INFO_BW_HE_RU)
  */
 struct rate_info {
 	u8 flags;
@@ -1032,6 +1040,9 @@ struct rate_info {
 	u16 legacy;
 	u8 nss;
 	u8 bw;
+	u8 he_gi;
+	u8 he_dcm;
+	u8 he_ru_alloc;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9a499b15cfbc..f2b577dbaca0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2598,6 +2598,36 @@ struct nl80211_sta_flag_update {
 } __attribute__((packed));
 
 /**
+ * enum nl80211_he_gi - HE guard interval
+ * @NL80211_RATE_INFO_HE_GI_0_8: 0.8 usec
+ * @NL80211_RATE_INFO_HE_GI_1_6: 1.6 usec
+ * @NL80211_RATE_INFO_HE_GI_3_2: 3.2 usec
+ */
+enum nl80211_he_gi {
+	NL80211_RATE_INFO_HE_GI_0_8,
+	NL80211_RATE_INFO_HE_GI_1_6,
+	NL80211_RATE_INFO_HE_GI_3_2,
+};
+
+/**
+ * @enum nl80211_he_ru_alloc - HE RU allocation values
+ * @NL80211_RATE_INFO_HE_RU_ALLOC_26: 26-tone RU allocation
+ * @NL80211_RATE_INFO_HE_RU_ALLOC_52: 52-tone RU allocation
+ * @NL80211_RATE_INFO_HE_RU_ALLOC_106: 106-tone RU allocation
+ * @NL80211_RATE_INFO_HE_RU_ALLOC_242: 242-tone RU allocation
+ * @NL80211_RATE_INFO_HE_RU_ALLOC_484: 484-tone RU allocation
+ * @NL80211_RATE_INFO_HE_RU_ALLOC_969: 969-tone RU allocation
+ */
+enum nl80211_he_ru_alloc {
+	NL80211_RATE_INFO_HE_RU_ALLOC_26,
+	NL80211_RATE_INFO_HE_RU_ALLOC_52,
+	NL80211_RATE_INFO_HE_RU_ALLOC_106,
+	NL80211_RATE_INFO_HE_RU_ALLOC_242,
+	NL80211_RATE_INFO_HE_RU_ALLOC_484,
+	NL80211_RATE_INFO_HE_RU_ALLOC_969,
+};
+
+/**
  * enum nl80211_rate_info - bitrate information
  *
  * These attribute types are used with %NL80211_STA_INFO_TXRATE
@@ -2629,6 +2659,13 @@ struct nl80211_sta_flag_update {
  * @NL80211_RATE_INFO_5_MHZ_WIDTH: 5 MHz width - note that this is
  *	a legacy rate and will be reported as the actual bitrate, i.e.
  *	a quarter of the base (20 MHz) rate
+ * @NL80211_RATE_INFO_HE_MCS: HE MCS index (u8, 0-11)
+ * @NL80211_RATE_INFO_HE_NSS: HE NSS value (u8, 1-8)
+ * @NL80211_RATE_INFO_HE_GI: HE guard interval identifier
+ *	(u8, see &enum nl80211_he_gi)
+ * @NL80211_RATE_INFO_HE_DCM: HE DCM value (u8, 0/1)
+ * @NL80211_RATE_INFO_RU_ALLOC: HE RU allocation, if not present then
+ *	non-OFDMA was used (u8, see &enum nl80211_he_ru_alloc)
  * @__NL80211_RATE_INFO_AFTER_LAST: internal use
  */
 enum nl80211_rate_info {
@@ -2645,6 +2682,11 @@ enum nl80211_rate_info {
 	NL80211_RATE_INFO_160_MHZ_WIDTH,
 	NL80211_RATE_INFO_10_MHZ_WIDTH,
 	NL80211_RATE_INFO_5_MHZ_WIDTH,
+	NL80211_RATE_INFO_HE_MCS,
+	NL80211_RATE_INFO_HE_NSS,
+	NL80211_RATE_INFO_HE_GI,
+	NL80211_RATE_INFO_HE_DCM,
+	NL80211_RATE_INFO_HE_RU_ALLOC,
 
 	/* keep last */
 	__NL80211_RATE_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d516527fcb8e..e779733143b8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4204,6 +4204,9 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
 	case RATE_INFO_BW_160:
 		rate_flg = NL80211_RATE_INFO_160_MHZ_WIDTH;
 		break;
+	case RATE_INFO_BW_HE_RU:
+		rate_flg = 0;
+		WARN_ON(!(info->flags & RATE_INFO_FLAGS_HE_MCS));
 	}
 
 	if (rate_flg && nla_put_flag(msg, rate_flg))
@@ -4223,6 +4226,19 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
 		if (info->flags & RATE_INFO_FLAGS_SHORT_GI &&
 		    nla_put_flag(msg, NL80211_RATE_INFO_SHORT_GI))
 			return false;
+	} else if (info->flags & RATE_INFO_FLAGS_HE_MCS) {
+		if (nla_put_u8(msg, NL80211_RATE_INFO_HE_MCS, info->mcs))
+			return false;
+		if (nla_put_u8(msg, NL80211_RATE_INFO_HE_NSS, info->nss))
+			return false;
+		if (nla_put_u8(msg, NL80211_RATE_INFO_HE_GI, info->he_gi))
+			return false;
+		if (nla_put_u8(msg, NL80211_RATE_INFO_HE_DCM, info->he_dcm))
+			return false;
+		if (info->bw == RATE_INFO_BW_HE_RU &&
+		    nla_put_u8(msg, NL80211_RATE_INFO_HE_RU_ALLOC,
+			       info->he_ru_alloc))
+			return false;
 	}
 
 	nla_nest_end(msg, rate);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index bc676d9b7e80..967fc20e10f2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1258,6 +1258,84 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
 	return (bitrate + 50000) / 100000;
 }
 
+static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
+{
+#define SCALE 2048
+	u16 mcs_divisors[12] = {
+		34133, /* 16.666666... */
+		17067, /*  8.333333... */
+		11378, /*  5.555555... */
+		 8533, /*  4.166666... */
+		 5689, /*  2.777777... */
+		 4267, /*  2.083333... */
+		 3923, /*  1.851851... */
+		 3413, /*  1.666666... */
+		 2844, /*  1.388888... */
+		 2560, /*  1.250000... */
+		 2276, /*  1.111111... */
+		 2048, /*  1.000000... */
+	};
+	u32 rates_160M[3] = { 960777777, 907400000, 816666666 };
+	u32 rates_969[3] =  { 480388888, 453700000, 408333333 };
+	u32 rates_484[3] =  { 229411111, 216666666, 195000000 };
+	u32 rates_242[3] =  { 114711111, 108333333,  97500000 };
+	u32 rates_106[3] =  {  40000000,  37777777,  34000000 };
+	u32 rates_52[3]  =  {  18820000,  17777777,  16000000 };
+	u32 rates_26[3]  =  {   9411111,   8888888,   8000000 };
+	u64 tmp;
+	u32 result;
+
+	if (WARN_ON_ONCE(rate->mcs > 11))
+		return 0;
+
+	if (WARN_ON_ONCE(rate->he_gi > NL80211_RATE_INFO_HE_GI_3_2))
+		return 0;
+	if (WARN_ON_ONCE(rate->he_ru_alloc > NL80211_RATE_INFO_HE_RU_ALLOC_969))
+		return 0;
+	if (WARN_ON_ONCE(rate->nss < 1 || rate->nss > 8))
+		return 0;
+
+	if (rate->bw == RATE_INFO_BW_160)
+		result = rates_160M[rate->he_gi];
+	else if (rate->bw == RATE_INFO_BW_80 ||
+		 (rate->bw == RATE_INFO_BW_HE_RU &&
+		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_969))
+		result = rates_969[rate->he_gi];
+	else if (rate->bw == RATE_INFO_BW_40 ||
+		 (rate->bw == RATE_INFO_BW_HE_RU &&
+		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_484))
+		result = rates_484[rate->he_gi];
+	else if (rate->bw == RATE_INFO_BW_20 ||
+		 (rate->bw == RATE_INFO_BW_HE_RU &&
+		  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_242))
+		result = rates_242[rate->he_gi];
+	else if (rate->bw == RATE_INFO_BW_HE_RU &&
+		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_106)
+		result = rates_106[rate->he_gi];
+	else if (rate->bw == RATE_INFO_BW_HE_RU &&
+		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_52)
+		result = rates_52[rate->he_gi];
+	else if (rate->bw == RATE_INFO_BW_HE_RU &&
+		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_26)
+		result = rates_26[rate->he_gi];
+	else if (WARN(1, "invalid HE MCS: bw:%d, ru:%d\n",
+		      rate->bw, rate->he_ru_alloc))
+		result = 0;
+
+	/* now scale to the appropriate MCS */
+	tmp = result;
+	tmp *= SCALE;
+	do_div(tmp, mcs_divisors[rate->mcs]);
+	result = tmp;
+
+	/* and take MCS, DCM into account */
+	result = (result / 8) * rate->nss;
+	if (rate->he_dcm)
+		result /= 2;
+
+	return result;
+}
+
 u32 cfg80211_calculate_bitrate(struct rate_info *rate)
 {
 	if (rate->flags & RATE_INFO_FLAGS_MCS)
@@ -1266,6 +1344,8 @@ u32 cfg80211_calculate_bitrate(struct rate_info *rate)
 		return cfg80211_calculate_bitrate_60g(rate);
 	if (rate->flags & RATE_INFO_FLAGS_VHT_MCS)
 		return cfg80211_calculate_bitrate_vht(rate);
+	if (rate->flags & RATE_INFO_FLAGS_HE_MCS)
+		return cfg80211_calculate_bitrate_he(rate);
 
 	return rate->legacy;
 }
-- 
2.9.3
