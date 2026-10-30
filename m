Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367040;
	b=LjjIBULslbfaT0n9MsNz5A47QRCrKwu+ME6B29PJKZ8Ewj6TbLV20fxLf7KDOvCVP8lI
	 F65zyBrssZ8QWPgZ8VjsJ3iXI9JTqN6DRg/PSQ7n+tY2BzYYdoNv87Dg0nEkDqQL40MBf
	 5ySIqn6igglMjdQygNUs3BlhXXCGA2ThMyYxi+sxWidWPyh3dqsIGMMVhO9D4H/50SzDf
	 Ak2SzvgqtR4FHWkPrHJJzH9e/Oj6h4fN8bBoglNNFekZJvG1E6pNuitO1EpH5hSb6/pnY
	 7Zp+XEZGtp4HquySdAHJeA9PEHVoIB9HGPPff2PczRXam5bBNmyclVULGY2syuTfIfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367040;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=lOxpMqa8SmbyXnEu47DpvYcWJeACwnSyi56Sp+cTch4=;
	b=I0ycCDmwyPL0YSnUS6Sub+jd80WM0h8SsRsZWK/7nkiotClaWFVrYETYcdwCueNHchhq
	 5t8znouH9/gi5B9+4uO5ImmypHHhZMMGOpxsQ76AWdVZ2loMM4FUun5OzvLGMb6yJZCT1
	 0lywj+QjxsK+or22x0NR+ci5MsVtOBSYFY//zhZyZdNZvh4IMeCQWs2IF/YKSVBJINATP
	 4fyfySLhSjacF8WFGf2U0PWwkXmnjTCe9KPHbgwFzP04h7YiBr1rMeFhpnOX3EtqUUQ5E
	 WJ6juuBxQWnPUVFEUaOt3SC5vmubuS7R+VaD5sO0bYhua6yBz67lyrbQvhL5qlVDb+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=De8h2C9k;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Tp7ePUIB;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62582606A31C
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62582606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=De8h2C9k;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Tp7ePUIB
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBG4IB3089474
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=lOxpMqa8Smb
	yXnEu47DpvYcWJeACwnSyi56Sp+cTch4=; b=De8h2C9kaHq92gYi2GfZCAMJtlY
	hftUYmJ49Q5CULHhLMwMOwSwtW0azToUABNlrYtBPF5QvLSnSNeG6zcCZHUygGEE
	GooYUzVzGNijmyQE01eVPSRTEN9F+b1DuIZxWXFJj7XKPM5OuYgrgXgRFttielh3
	Z1xuw4O9pulxd1eMIVJ7E3SQbXTJ6/3IpxMHiLphE3iLhqojvegMhMlFN2P/v34Y
	Dlb35KnwrJjlNefaTPWImFaR3kTC12L/g8BortNNWkCdsMBuphINBxdPWT2DGNtr
	evDNZFZ7Y2ppTpjjMUziIlDVfE/0eHz5hZKnttmn0ZJfrtc/xwxM06Fnodg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qk8s0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:39 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2eb2437d752so11337795ad.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367039; x=1793971839; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lOxpMqa8SmbyXnEu47DpvYcWJeACwnSyi56Sp+cTch4=;
        b=Tp7ePUIBlrBRSUbdQ1xO2F3ciBf3bkjl4qC4sk8ocOAvhfiBVvN2oEbz19BTUJIoSC
         8CHourTjYYe9BzhJik+gxTEjVEoM1g2r3J5mXQH7CZXeFWmDaRdTAHgJt0Jd9QUJE5Hy
         TxrU9Otebryl4vrOgMNhsM3tMmU2fWUs/a6noy0pO7MKJ74mYzSSffFsdBsg6dLsUzqY
         C/ZM3BbHVCphrRIZi5kXi7PqpsHGfv8IsnDdU5WrGElTis1bWxerrlU7SHatvQrlf7cs
         VABB4RTWP0FK4Zqo7vIdTFer8MUfYUyEdD88+Hevne57SfNyaEWm/9p2u5E1G6A1udX6
         tJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367039; x=1793971839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lOxpMqa8SmbyXnEu47DpvYcWJeACwnSyi56Sp+cTch4=;
        b=MWWdYi6BnWS7ycYglOyDbAKntlJNqWyFDnbIWsmdcRRK5fMJLqBM9bXRlH0raKGDBC
         5ODd+NPiOy70l92JesnzYLbbhE3GtcSaJHTuKXn4N+6QIyOly/S2evUvXBVUCBEvjuoc
         BZYNeV9BN/CbSukEmsJh/MvR1Jy1o1Xzo5BnHmBToGYSN7hBAEHR9DN2XTC85AulVLj+
         0upa8t9UxlOenGFjgXvL9k72xCPomM6rzebenNe13mVJT7vLFGZpRaTOpT6TJS/fboiI
         oOA9iCYN4WDB8pXDIfKnLcIK04GVQlrL1rT+knzh0UIADN7NjZjvz8qqNdFG7b3Je1Lt
         5mDA==
X-Gm-Message-State: AFq9FYLtYi/Zad1YcVLfVmHnYpoHxrDZOtLN29f3IMwkyGTIHTKLem90
	3y7mvGGESp9P146aXvcrlZmLwd1wgAJvQsDHF9CxXSkQTGmU0nsoaJc+iTJeXve3S45tjTxMxH+
	PbfjT2Jx5kBGdmew9s2IYJBNFagPh6bg6U3tLHaXtNMBuGq4F7NDlkYDd3paPE2bTgmjGwQ==
X-Gm-Gg: AYBFou2/Y0k95RbslnMPkj5ZRrmLcF0xCqXPFcGd9MMGPfyvpmfFhpUC2iA6nq6y25O
	m55QAk4x3yopsTRYVLN9Vx3MCAD6D0455Tmiz1eDCFWDme4EQdlhnn0ZYRGEMDwc/XjCgpGonwZ
	mZcezjsfYyKrfAnBQAelqlDBTkKIdVYtwOzDfDvY4B/gM0MqNSlsFR/hKd0h/i+zWK+TYrptnCg
	vw65jUZL2e5q78QhadoxR6Hr4IL5hojcLqf7ewnXTu50cALJGuj0fxWjJpqWsBMEg3galK4GDBi
	R1X+d2Vz1zEyb7NYcszCLj5CSlenNa6NpV0YB3tMoznlIJyhOqlky5PeuYn5sEGtc0DiRvpTA8c
	kynikbBHX7QiJ7iB3aUtp7IwWwOYSureVHCq/KRygeZi/duVKWEW6CHs2JUa0DsP6wOIKLlW3s8
	Q8+Lnj4V4aag==
X-Received: by 2002:a17:90b:3c09:b0:3ab:2236:6b3d with SMTP id 98e67ed59e1d1-3ae89814a11mr1759920a91.27.1793367038652;
        Fri, 30 Oct 2026 06:30:38 -0700 (PDT)
X-Received: by 2002:a17:90b:3c09:b0:3ab:2236:6b3d with SMTP id 98e67ed59e1d1-3ae89814a11mr1759876a91.27.1793367037769;
        Fri, 30 Oct 2026 06:30:37 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:30:37 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 02/16] wifi: nl80211/cfg80211: extend NAN function for discovery offload
Date: Fri, 30 Oct 2026 18:59:58 +0530
Message-Id: <20261030133012.3009774-3-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261030133012.3009774-1-shivani.baranwal@oss.qualcomm.com>
References: <20261030133012.3009774-1-shivani.baranwal@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: eHdHxrGBGdClgQKfGU9erX_OGz-rF45g
X-Authority-Analysis: v=2.4 cv=KLzPn1Fo c=1 sm=1 tr=0 ts=6ae49bff cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=7W_7OWkrhyr2tHN1iDYA:9 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfXzUbAu0TuH6B9
 oJvsc18mdZk6fuTuJyr4ORIaU2isQnsaX9r6P6rIadWi8JyZAJROSl5yVEBLc7GqcZPk1y2jEK4
 IBCxocETLhaKr+He7ge3Stp4IzJYVFtMCXu0szdDywzrlR6TX1UkcY8y/X08tAtJAcD7UDcxHNV
 qulB1php7B02i7QmPT9qdtSx6+th93AMcwJ5FyVakNGrCdQ4cXyuMPpf+C7rJTHoNNPW6UDTxrf
 JvsbBSUxPA4rPvfJj8CY4eg17aEEXh2rveah4Cd3fYpGAmO0/XekvSb8w67/PcxBMNMnud9JcMK
 x2iAbVC21bmlY/l5awsDUg/HvoAfJ8CqoSTzWOWpG3Ymk1gcOn2a4b7dhmwbwm1KuyGCVTZO5E3
 kBFkPJ3OIaiw57r2gmRnCAkqwfalmBqKiMijSscaMxo0GLxrVv/vIIsHzzcAY9gPxUXau7WapB+
 c9DTe3gg7Tx5Hu4kvJw==
X-Proofpoint-ORIG-GUID: eHdHxrGBGdClgQKfGU9erX_OGz-rF45g
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX9+u8ZkCQQb17
 XmTct4Xta++9ymmbS3LXRBK3+gfJiOzqSBGBGbt/pwZTFSwGCUQjPJRaimGsAOkIEwkoSfwQHar
 L/AwtP1aHD7hAG15PjjNU4FSPCMtkV4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610300053

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
index 46ba0fb27b14..5dae55db355a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4395,6 +4395,21 @@ struct cfg80211_nan_func_filter {
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
@@ -4421,6 +4436,15 @@ struct cfg80211_nan_func {
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
@@ -6355,11 +6379,14 @@ struct wiphy_radio {
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
index dd187990dd08..9900f8b91a83 100644
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
@@ -17581,6 +17590,95 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
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
index ad0e7b279111..750ddb90739f 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -2874,6 +2874,7 @@ void cfg80211_free_nan_func(struct cfg80211_nan_func *f)
 	kfree(f->serv_spec_info);
 	kfree(f->srf_bf);
 	kfree(f->srf_macs);
+	kfree(f->csids);
 	for (i = 0; i < f->num_rx_filters; i++)
 		kfree(f->rx_filters[i].filter);
 
-- 
2.34.1

