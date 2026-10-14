Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B54F1A9F90
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974070; cv=none; b=gL79X2xJAvZ48gyf252XWVUHRKUIAbXxibcJkJWAdfHNu3lhx7/YYKZvLJCw6HvbLIHiCfS2Q1TPj3KQYdUxcNcJxRRJTBunxf7betlaEDeor6CKHsnrzjteedafl/jgkouh2qrODQg25ReMJFO5dkHSLLfIZa2QcjdruvX5Anc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974070; c=relaxed/simple;
	bh=GVF30wj26Pm9wT8TKROCDqUKkVRPlPR2uPWQQg+CjXQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Cy4wfTHT+hiR7R4uJdAdcNax6/vxO/DnBPvJecIAF8nSCp8H2qb0mEAV1tUwcCOCnSFDUrflhT1Lz1kBUILd9K1WAuERdlTmqhkS6fEPqqqVSMdDu4MLVL/83sWX6gxgi3pxCZj5fEkzbnjsYr5nOmFZ3v9vq1TuZ48FgxfH0U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=adJOYaXU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kiAnY+yS; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="adJOYaXU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kiAnY+yS"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E5wsfX3951538
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=TZowNlIC9pF
	Bd7wWNadVw7HngfIliJMs7Iq2Vb7eLVk=; b=adJOYaXUNu9RE0BVYPhnu/aoj9b
	B3I24g4INWdCJGfzr9L3T3TLH1eSXX3jgvJ8MxmXGSKAVsjO0qsoomhLCYpnPPPo
	5X0Jr19T/0v7kzL6lfK7EG2qCbqZ4n6XDyUqli1ps7zhNeM8QG6MkXAZUVBwc9ZQ
	sfftRSx+yoq3gkC+vDaV4nDiPFOEJAc8KNIrvFMY2lz7dvI+jHtGj9qmBq4Zi7RO
	1mLS6cZIl6XIbcZQQcHZjKv6nqS/FJ9XgTUjSqpVDOjggNP5tKvyGPwhvmmmT60B
	y21mcuFgIWVs67QKXNDRsqthkkiFMKzX5RCGZ6HEdu9fTAnyatly+hKSXhQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha42p155v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:27 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-35c3c370b17so3447667eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974067; x=1792578867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TZowNlIC9pFBd7wWNadVw7HngfIliJMs7Iq2Vb7eLVk=;
        b=kiAnY+yScIs0HLfle9ZvXUARZ4RE7RqGjPWxNKdARuvmHOe5+kqdqV/pjnmacL+YE9
         rhtZbbK82CLQfAr1+XFIDhefvkBap83vkSp91lzf1wnXTcin6db0Bwn8fMaaelJkar8D
         heFsVbJCA1fUbY5UKiCdPEnmY7YpS9jEyFTSYq/iEy+jXJZz7qvoQQmfHFsZhaeohxjx
         vqSueybWxBn1TodSOeL3IgFi91wLpcM/Z0WWzLgOKwRoWdcrLSojlcbNaKJifAJcOAyA
         Ar77J/o8JgdpwISK8zFlCBi74genJM3tx23bL0gOJ1ScOnYDI83ZWTkoDWRr7r/RnG5g
         Gyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974067; x=1792578867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TZowNlIC9pFBd7wWNadVw7HngfIliJMs7Iq2Vb7eLVk=;
        b=MERQ7VX3gNZtlfqiYlmxedrDhHr68KqngtAcV3aYPgVBQ6lp551WTYlYFVpuPb41tP
         P6xgbIQoTXn5E3pkzxKFEDYCOQ5zxZW3dHvOBpQyGIpL38BUT5z1yc/+Ab6llWWA1Ch8
         qR3xaMRRze6GHAUR0J3pPUgt9dlQeG6Swnuzc4eZLZ5HFnK0rbdSBb3URrQOaWxc22sk
         V128ungPdQcp7sZbtX6Un7HMqBRIjIkVrr6Abc/YeY0GZaY5prgL4GNt/4NV3S2daFIl
         v/Y4AgP15itrAoZJIu9uL+7lSIk1HIpxccmHHqMYW74Dap4hYuYVsz4Rw3qFVBjDAWiU
         cyAQ==
X-Gm-Message-State: AFq9FYIinz7gICpGu9hPtCtlK0cs18LB67QqqkLKdtF15Fo+pGmA7Dxn
	SQLqWfmAkT1C70P+smeFStqCuEFHxvR6Z4jE3OgCm5LEesKqTrmixBWBQvVshAiviugZw+rnpld
	aX8BvD9sJQRGNpweAGoV2d3+SgWFUXxR8zSFyw0UBjbrWoS+yMnSqe/yqq8iVCwlsZbgqzNxTg+
	pcLg==
X-Gm-Gg: AYBFou2H24KCU61L2kCuJWvwOlcLGsPkR9kAZw3TW7pefqkIwtDJM+p9dOTfpNB7rIh
	EzvBswMkAwuZpiNNBOCrpjHZYBG29zU/hti05fjEzGTSiqQ65j4PmGkKJxyBFU/TZTGE2hOtQ2V
	TMzlWaPtW5XES+7ErMkFEVPcSYEUP3SY4WKpt40xiQSWZvf/9VNO4KvBYaLvuoJ5vbwqv+JoK7T
	KWWRfJ/KTNCy5SA1Pe51jgVjcMd06HzyIFLJLkuHlMCS01Lqc4HKy6eQVEOGh3JfhoDgwl1CUZY
	Jth50qKNb9sT4VC6Ae9QX9DM3zpm9teb/i72Ewhkxa65IDSubt+zhharzO9nuiKLNW/Gc/Aqtbp
	q4dYdkWqAhV8MDzghZ93CDLxpxw/uvQzSPzh1
X-Received: by 2002:a05:701b:2806:b0:169:3706:d61b with SMTP id a92af1059eb24-16a5dbfddfdmr20693069c88.16.1791974066543;
        Wed, 14 Oct 2026 03:34:26 -0700 (PDT)
X-Received: by 2002:a05:701b:2806:b0:169:3706:d61b with SMTP id a92af1059eb24-16a5dbfddfdmr20693004c88.16.1791974065520;
        Wed, 14 Oct 2026 03:34:25 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:25 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 02/15] wifi: nl80211/cfg80211: extend NAN function for discovery offload
Date: Wed, 14 Oct 2026 16:03:46 +0530
Message-Id: <20261014103359.1508345-3-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX94ATdt6r2o01
 7Unu6GHUakOH459QsC9BqpGuIEM8F9Qst+t1ooIWuNtQbHx+Sd/adCNn9a6/FgXliZpEUOX4CDC
 BbnOsodqltqlUKRr6ReX04m6TXaJ4mI=
X-Proofpoint-ORIG-GUID: lv96h4l1vZIkd_Qki1Hzek9WY1R-EF0c
X-Authority-Analysis: v=2.4 cv=aeb0Dhot c=1 sm=1 tr=0 ts=6acf5ab3 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=7W_7OWkrhyr2tHN1iDYA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX82qMPvt6/BS9
 jIj15o38BysF+9KpwfC+2ANuiUlUIonQO1q+TYrXLLrlba4N/6KbHlRU6hq13VRQd4eQrACPPb7
 TFDaxe7cllyYSOyMGCc6RwoQBfWvDRNgO4P5O9cvPywp9scBT4sA68cOa6Se7zyfD2cW8Sh0Elv
 qEVr0+zRznoaeNC8tXIZaUEhswQlbvFowkRmUPMzY1l+yA9ntu1DesbW3mXX8Q+HRynjHIMtQUA
 dcT3PWIZxl6sNXgkf9tT7oQdJb378NHFlh9SXDl0DaaJ9XltqMj65EBKdR2wxlR5lWB1sou/ckE
 avL7Wq6AHeNkdIV0Ws13WgH5hVuEjboCYSx6bKWsFKLK9vbJHOlDMZhLrF/B2NcsYkF7k5C1FyR
 u+G6VoQ08zo9J8ApDQPFG4apJmWPiBxIoiWkB7lx1rDhPdR43maZgAJU6xGeo2j++Sj9sfZtfoo
 1O2mOSNdeOxeCz6ixPQ==
X-Proofpoint-GUID: lv96h4l1vZIkd_Qki1Hzek9WY1R-EF0c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140041

Extend NAN service function definitions with SDEA control field,
pairing capability, cipher suite, GTK, and ND-PMK attributes needed
when the driver hosts the NAN Discovery Engine.

Introduce WIPHY_NAN_FLAGS_OFFLOAD_NDP for drivers that handle NAN
Data Path setup autonomously.

Add parsing support in cfg80211 for the new attributes, gating
security-related attributes on NL80211_EXT_FEATURE_SECURE_NAN and
the SDEA Data Path bit on WIPHY_NAN_FLAGS_OFFLOAD_NDP.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 27 ++++++++++
 include/uapi/linux/nl80211.h | 46 +++++++++++++++++
 net/wireless/nl80211.c       | 98 ++++++++++++++++++++++++++++++++++++
 net/wireless/util.c          |  1 +
 4 files changed, 172 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f773856c1818..a795bda484a2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4392,6 +4392,21 @@ struct cfg80211_nan_func_filter {
  * @num_tx_filters: length of &tx_filters.
  * @instance_id: driver allocated id of the function.
  * @cookie: unique NAN function identifier.
+ * @sdea_ctrl: SDEA control field bitmask as defined in Wi-Fi Aware
+ *	specification Table 9-297. Bit 2: Data Path Required. Bit 6:
+ *	Security Required. Bit 10: GTK Required. The Security Required and
+ *	GTK Required bits require %NL80211_EXT_FEATURE_SECURE_NAN.
+ * @pairing_bootstrap_methods: bitmap of supported NAN pairing
+ *	bootstrapping methods per the Wi-Fi Aware Specification Table 9-321.
+ * @csids: array of u32 NAN Cipher Suite ID (CSID) selectors supported by
+ *	this service. See the Wi-Fi Aware Specification for cipher suite values.
+ * @num_csids: number of entries in @csids.
+ * @nd_pmk: pre-shared NAN Data Path PMK (%NL80211_NAN_NDP_PMK_LEN bytes).
+ * @nd_pmk_set: if true, @nd_pmk contains a valid pre-shared ND-PMK.
+ * @pairing_setup: if true, this service supports NAN pairing setup.
+ * @pairing_cache: if true, this service supports NAN pairing caching.
+ * @pairing_verify: if true, this service supports NAN pairing
+ *	verification using a cached NPK.
  */
 struct cfg80211_nan_func {
 	enum nl80211_nan_function_type type;
@@ -4418,6 +4433,15 @@ struct cfg80211_nan_func {
 	u8 num_rx_filters;
 	u8 instance_id;
 	u64 cookie;
+	u16 sdea_ctrl;
+	u16 pairing_bootstrap_methods;
+	u32 *csids;
+	u8 num_csids;
+	u8 nd_pmk[NL80211_NAN_NDP_PMK_LEN];
+	bool nd_pmk_set;
+	bool pairing_setup;
+	bool pairing_cache;
+	bool pairing_verify;
 };
 
 /**
@@ -6348,11 +6372,14 @@ struct wiphy_radio {
  * @WIPHY_NAN_FLAGS_USERSPACE_DE: Device doesn't support DE offload.
  * @WIPHY_NAN_FLAGS_INSTANT_COMM: Device can switch to Instant Communication
  *     (IC) mode. Can only be set along with %WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC.
+ * @WIPHY_NAN_FLAGS_OFFLOAD_NDP: Driver handles NAN Data Path (NDP) handshake
+ *	frames and data path key installation autonomously.
  */
 enum wiphy_nan_flags {
 	WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC = BIT(0),
 	WIPHY_NAN_FLAGS_USERSPACE_DE   = BIT(1),
 	WIPHY_NAN_FLAGS_INSTANT_COMM = BIT(2),
+	WIPHY_NAN_FLAGS_OFFLOAD_NDP = BIT(3),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b56a96f57bec..d610b3f8ab96 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7715,6 +7715,8 @@ enum nl80211_nan_func_term_reason {
 #define NL80211_NAN_FUNC_SERVICE_SPEC_INFO_MAX_LEN 0xff
 #define NL80211_NAN_FUNC_SRF_MAX_LEN 0xff
 
+#define NL80211_NAN_NDP_PMK_LEN 32
+
 /**
  * enum nl80211_nan_func_attributes - NAN function attributes
  * @__NL80211_NAN_FUNC_INVALID: invalid
@@ -7753,6 +7755,26 @@ enum nl80211_nan_func_term_reason {
  *	Its type is u8 and it cannot be 0.
  * @NL80211_NAN_FUNC_TERM_REASON: NAN function termination reason.
  *	See &enum nl80211_nan_func_term_reason.
+ * @NL80211_NAN_FUNC_SDEA_CTRL: u16 Service Descriptor Extension Attribute
+ *	(SDEA) control field bitmask as defined in the Wi-Fi Aware Specification
+ *	Table 9-297. See &enum nl80211_nan_func_sdea_ctrl_flags for the
+ *	relevant bit definitions. The Security Required and GTK Required bits
+ *	require %NL80211_EXT_FEATURE_SECURE_NAN.
+ * @NL80211_NAN_FUNC_PAIRING_BOOTSTRAP_METHODS: u16 bitmap of supported
+ *	NAN pairing bootstrapping methods as defined in Wi-Fi Aware
+ *	specification Table 9-321. Each bit corresponds to one method.
+ * @NL80211_NAN_FUNC_CSIDS: a set of u32 NAN Cipher Suite ID (CSID)
+ *	selectors supported by this service. Requires
+ *	%NL80211_EXT_FEATURE_SECURE_NAN.
+ * @NL80211_NAN_FUNC_PAIRING_SETUP: flag attribute. This service supports
+ *	NAN pairing setup (new pairing).
+ * @NL80211_NAN_FUNC_PAIRING_CACHE: flag attribute. This service supports
+ *	NAN pairing caching (NPK caching).
+ * @NL80211_NAN_FUNC_PAIRING_VERIFY: flag attribute. This service supports
+ *	NAN pairing verification using a cached NPK.
+ * @NL80211_NAN_FUNC_ND_PMK: %NL80211_NAN_NDP_PMK_LEN-byte pre-shared NAN
+ *	Data Path PMK (ND-PMK).
+ *	Requires %NL80211_EXT_FEATURE_SECURE_NAN.
  *
  * @NUM_NL80211_NAN_FUNC_ATTR: internal
  * @NL80211_NAN_FUNC_ATTR_MAX: highest NAN function attribute
@@ -7775,12 +7797,36 @@ enum nl80211_nan_func_attributes {
 	NL80211_NAN_FUNC_TX_MATCH_FILTER,
 	NL80211_NAN_FUNC_INSTANCE_ID,
 	NL80211_NAN_FUNC_TERM_REASON,
+	NL80211_NAN_FUNC_SDEA_CTRL,
+	NL80211_NAN_FUNC_PAIRING_BOOTSTRAP_METHODS,
+	NL80211_NAN_FUNC_CSIDS,
+	NL80211_NAN_FUNC_PAIRING_SETUP,
+	NL80211_NAN_FUNC_PAIRING_CACHE,
+	NL80211_NAN_FUNC_PAIRING_VERIFY,
+	NL80211_NAN_FUNC_ND_PMK,
 
 	/* keep last */
 	NUM_NL80211_NAN_FUNC_ATTR,
 	NL80211_NAN_FUNC_ATTR_MAX = NUM_NL80211_NAN_FUNC_ATTR - 1
 };
 
+/**
+ * enum nl80211_nan_func_sdea_ctrl_flags - NAN SDEA control field bit flags
+ *
+ * Bit definitions for the u16 SDEA control field carried in
+ * %NL80211_NAN_FUNC_SDEA_CTRL, as specified in the Wi-Fi Aware
+ * Specification Table 9-297.
+ *
+ * @NL80211_NAN_FUNC_SDEA_CTRL_DATAPATH_REQUIRED: bit 2 - Data Path Required.
+ * @NL80211_NAN_FUNC_SDEA_CTRL_SECURITY_REQUIRED: bit 6 - Security Required.
+ * @NL80211_NAN_FUNC_SDEA_CTRL_GTK_REQUIRED: bit 10 - GTK Required.
+ */
+enum nl80211_nan_func_sdea_ctrl_flags {
+	NL80211_NAN_FUNC_SDEA_CTRL_DATAPATH_REQUIRED	= 1 << 2,
+	NL80211_NAN_FUNC_SDEA_CTRL_SECURITY_REQUIRED	= 1 << 6,
+	NL80211_NAN_FUNC_SDEA_CTRL_GTK_REQUIRED		= 1 << 10,
+};
+
 /**
  * enum nl80211_nan_srf_attributes - NAN Service Response filter attributes
  * @__NL80211_NAN_SRF_INVALID: invalid
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 77b75367de27..52e7c30a4ce3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1334,6 +1334,15 @@ nl80211_nan_func_policy[NL80211_NAN_FUNC_ATTR_MAX + 1] = {
 	[NL80211_NAN_FUNC_TX_MATCH_FILTER] = { .type = NLA_NESTED },
 	[NL80211_NAN_FUNC_INSTANCE_ID] = { .type = NLA_U8 },
 	[NL80211_NAN_FUNC_TERM_REASON] = { .type = NLA_U8 },
+	[NL80211_NAN_FUNC_SDEA_CTRL] = { .type = NLA_U16 },
+	[NL80211_NAN_FUNC_PAIRING_BOOTSTRAP_METHODS] = { .type = NLA_U16 },
+	[NL80211_NAN_FUNC_CSIDS] = { .type = NLA_BINARY,
+				     .len = U8_MAX * sizeof(u32) },
+	[NL80211_NAN_FUNC_ND_PMK] =
+		NLA_POLICY_EXACT_LEN(NL80211_NAN_NDP_PMK_LEN),
+	[NL80211_NAN_FUNC_PAIRING_SETUP] = { .type = NLA_FLAG },
+	[NL80211_NAN_FUNC_PAIRING_CACHE] = { .type = NLA_FLAG },
+	[NL80211_NAN_FUNC_PAIRING_VERIFY] = { .type = NLA_FLAG },
 };
 
 /* policy for Service Response Filter attributes */
@@ -17564,6 +17573,95 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 			goto out;
 	}
 
+	if (tb[NL80211_NAN_FUNC_SDEA_CTRL]) {
+		u16 sdea = nla_get_u16(tb[NL80211_NAN_FUNC_SDEA_CTRL]);
+
+		if ((sdea & NL80211_NAN_FUNC_SDEA_CTRL_SECURITY_REQUIRED) &&
+		    !(sdea & NL80211_NAN_FUNC_SDEA_CTRL_DATAPATH_REQUIRED)) {
+			NL_SET_ERR_MSG(info->extack,
+				       "SDEA Security Required requires Data Path Required");
+			err = -EINVAL;
+			goto out;
+		}
+
+		if ((sdea & (NL80211_NAN_FUNC_SDEA_CTRL_SECURITY_REQUIRED |
+			     NL80211_NAN_FUNC_SDEA_CTRL_GTK_REQUIRED)) &&
+		    !wiphy_ext_feature_isset(wdev->wiphy,
+					     NL80211_EXT_FEATURE_SECURE_NAN)) {
+			NL_SET_ERR_MSG(info->extack,
+				       "SDEA security bits require SECURE_NAN");
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+
+		if ((sdea & NL80211_NAN_FUNC_SDEA_CTRL_DATAPATH_REQUIRED) &&
+		    !(wdev->wiphy->nan_capa.flags &
+		      WIPHY_NAN_FLAGS_OFFLOAD_NDP)) {
+			NL_SET_ERR_MSG(info->extack,
+				       "SDEA Data Path bit requires OFFLOAD_NDP");
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+		func->sdea_ctrl = sdea;
+	}
+
+	if (tb[NL80211_NAN_FUNC_PAIRING_BOOTSTRAP_METHODS] ||
+	    tb[NL80211_NAN_FUNC_PAIRING_SETUP] ||
+	    tb[NL80211_NAN_FUNC_PAIRING_CACHE] ||
+	    tb[NL80211_NAN_FUNC_PAIRING_VERIFY] ||
+	    tb[NL80211_NAN_FUNC_CSIDS] ||
+	    tb[NL80211_NAN_FUNC_ND_PMK]) {
+		if (!wiphy_ext_feature_isset(wdev->wiphy,
+					     NL80211_EXT_FEATURE_SECURE_NAN)) {
+			NL_SET_ERR_MSG(info->extack,
+				       "Security attributes require SECURE_NAN");
+			err = -EINVAL;
+			goto out;
+		}
+
+		if (tb[NL80211_NAN_FUNC_PAIRING_BOOTSTRAP_METHODS])
+			func->pairing_bootstrap_methods =
+				nla_get_u16(tb[NL80211_NAN_FUNC_PAIRING_BOOTSTRAP_METHODS]);
+
+		func->pairing_setup =
+			nla_get_flag(tb[NL80211_NAN_FUNC_PAIRING_SETUP]);
+		func->pairing_cache =
+			nla_get_flag(tb[NL80211_NAN_FUNC_PAIRING_CACHE]);
+		func->pairing_verify =
+			nla_get_flag(tb[NL80211_NAN_FUNC_PAIRING_VERIFY]);
+
+		if (tb[NL80211_NAN_FUNC_CSIDS]) {
+			int len = nla_len(tb[NL80211_NAN_FUNC_CSIDS]);
+			int n = len / sizeof(u32);
+
+			if (len % sizeof(u32)) {
+				NL_SET_ERR_MSG_ATTR(info->extack,
+						    tb[NL80211_NAN_FUNC_CSIDS],
+						    "CSIDs must be an array of u32 values");
+				err = -EINVAL;
+				goto out;
+			}
+
+			if (n > 0) {
+				func->csids =
+					kmemdup(nla_data(tb[NL80211_NAN_FUNC_CSIDS]),
+						len, GFP_KERNEL);
+				if (!func->csids) {
+					err = -ENOMEM;
+					goto out;
+				}
+				func->num_csids = n;
+			}
+		}
+
+		if (tb[NL80211_NAN_FUNC_ND_PMK]) {
+			memcpy(func->nd_pmk,
+			       nla_data(tb[NL80211_NAN_FUNC_ND_PMK]),
+			       sizeof(func->nd_pmk));
+			func->nd_pmk_set = true;
+		}
+	}
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg) {
 		err = -ENOMEM;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 9d5456defc90..38fd97e8fac7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -2820,6 +2820,7 @@ void cfg80211_free_nan_func(struct cfg80211_nan_func *f)
 	kfree(f->serv_spec_info);
 	kfree(f->srf_bf);
 	kfree(f->srf_macs);
+	kfree(f->csids);
 	for (i = 0; i < f->num_rx_filters; i++)
 		kfree(f->rx_filters[i].filter);
 
-- 
2.34.1

