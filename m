Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367043;
	b=dg3ufOOjxtRKIa0dRqEWoALJttPR3nN8WIZETTEF0+E8yXdA+Is4zLlsDrXLY2HMHDk3
	 q+AJMXlm1/9uvBqYECNuTxp5bbSCWc4jEUV0qzGBW4e2KCvPs5wlZXmLrrp6HYCxq/nZ9
	 08B6DqWGXsNRt7391TliLr8JV3rMMF8fe6UjaAKRfRBjUMyT0Z/mGf9p6V7r12SSCyGFA
	 62tfGTqzpBEp/rnkZx1zZsO9PlokdEfEkZqfiy810C+RiFXk0mHp/iOZ/efK1lGAz5cJw
	 a+nYGX9biuMjWre4cJ7AyTVaJ8ITeAsALpMgiHLnHUhj6UDYlLq5ICPJPEi1BhzInSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367043;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=rPyInSdtwHFm8J8lRv+0ueGJMWPT9x7I5KlIa89a4VA=;
	b=1JiMm9EQbnlXJJCFBpOvda/H/y1dyjzLWbFEXpYZVjv6gDVgyasKDz0A5zRD0X0WC8+K
	 14ygZSx2VLAF/6pYqrt2Z6W5Kp/h2/8aM9oZy1mzfRcHnHTA+q8whp6Muv1zfgZ0a+p0S
	 eCVqdD6HOghB9GPvBSXfxCRKljaDv0u2Ew7NoAIt3o9STsg6E+1ImKBAurrHAeh2+1Wxu
	 ak1Ie+nsJggRglpECagmY+OEtmXYh5IQck8Z6P7SB2UxO7hHpG2Xah4J30NfvGx7ApCro
	 E+qbzWMGJ4yOfWroDtVX5HKLaVT8xz9KoW0qxpsd4cOcwph9pD5OnsktqLJjWroDPfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LdUEH4+O;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=jOtI2G4u;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540EA606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 540EA606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LdUEH4+O;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=jOtI2G4u
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBGKxQ3130272
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=rPyInSdtwHF
	m8J8lRv+0ueGJMWPT9x7I5KlIa89a4VA=; b=LdUEH4+OE5yiwPwSZJZrnaqBnju
	vR1780YDlwtsTOkxE/3ctDHD0VYNcjw6+WdjKn3HKiExOTpeBroAl8t/aGIzXfDv
	UOXbTQQCtJQNu+GussZiCogy4wjIg7/5IrTEVR63bQESLEFsJIh5Vn90i7Ky5F7s
	CBA7FnM3GfGGhsT/AhTU4kyeHkPvIQU26U/AQrUrFD2L/x9ZN86GtHyy1So9Dz8N
	JbzshhON/fT8my5qM2w/v/Aq7XmBRTTUnczu4HiE9YZ2W6of+er2gJNPAYnxIIT/
	4tywBzlTADALlfMDnmnpDFw9/nJyPyP1eG6Xfu+8Ls9HyzDXSIRExoWR/dA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qk6aa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:42 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ae73921fd1so663027a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367041; x=1793971841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rPyInSdtwHFm8J8lRv+0ueGJMWPT9x7I5KlIa89a4VA=;
        b=jOtI2G4ueki0NiD9s7Pa7oRAWYd83/PzpCryxAm6tIFf8o0/mkh1mQXIH88UfcgKtH
         2SdejIQHKAie/x92OrprHO46365mz9SUGNysjwQsW3WflSlZi9CdOaRXQ9pw5/N0FwI0
         D8KZCWLwX1/BkVxlyy0cAw6s5tWv5pkQH9iLcE0sMQaCDOOdH+acr9SxehvnNDYayFgF
         BWJWSbSIqwnfManYFBUYRloXn5kMBJNTrdls/4OIQAkRXxW9ukMkGbg8OgQaoS1vQFrN
         0C1qVyXGekzCIW8ucIAIWv6Nw46aO9+gHzBNOGCGHidF1DDNT1igXqm7ATOZtmM0MQWK
         fbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367041; x=1793971841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rPyInSdtwHFm8J8lRv+0ueGJMWPT9x7I5KlIa89a4VA=;
        b=hDTZhhPvY8H1SAJVqL2TS4/s/Q/+9HfUJOX+1ZHM48etKVKNd9u8yv5FlNNqzzmfBI
         /8Eisgvl4Xwa+/wOkbtjoIwtsGMhkU5ABX8H4pySoRYNK1Xyre6zo5ZMbbPeH5zwKFb2
         mN0Bvm8LPkC3xk6/DF9zdc4b5vqacos3qBXb4j+m3v+cxPcz1GSvEVlrMaqc74eZHXbw
         u8pfTxTfa6WLedWakZ6Za3rqqLnt+oljSE4RsW2T/10tMNsAxsjoWgwEClxiXQmB8O03
         md83+aBhWvx1ZvdI93YE7RXPCsQaxLhKqrACbFmepDoleVBZeP6mdicVVBH7UFsPqd6D
         Q8Gg==
X-Gm-Message-State: AFq9FYJAe6JGRBWeLQxzxikDh8LfI/8DK3dn+Jkxa4S2WON+B/vt9e8f
	ZXWFf6h/CQPfGG6NgEXrPVUivMvNiF1nfP27fmCZ9Ie1vp6Lrod9IfxHTq7fbsJEabLgGyBJd7b
	RAaPHWfc1VXUkHSN9s5uBTXM11O6VXjVxeUOAfA7lYvX56vaag5/C7d/FOU+VUPW2wWMcF0Jzwc
	RCOQ==
X-Gm-Gg: AYBFou0ulQ2Rad3ixNVvweQEx52L8b1TAuBrP/EaJY3Q0ndZeQpZCrS+fLV9mWkp0nQ
	S/sufmrHYdfeL74GrFBtEAjRf2G+/C+DTR+K0f6SOJqlv30NgIFFwkvIwcMgF7kyNNU/WUDT/JV
	Hgn0+wnbFkynwGB1ujiWD4bEbfJwAON+cM/SQKLn5BCYNPtqCd7bXDzKv8Dmf+QlxsoaYXlegEp
	6CMrHsggXU/7J21mPOiSiG/wolfQh2Qhe5kCqft3uRewpmYg8wIBsXUpLPDt+HSOjIULXueR1U6
	EEk8BOlYpyjc53UwQd8j5EyyPtYv+lWV7kbX7NBlzHaoHBN3+q9nYx82+pXvt5mqqA5PnFJsGxx
	oaqgGbDdWelULVV/u82trFNDtEX95NhF6P/hwjr096b+Uq77fZzJLWgmdIiPguKVgtPjkHybH0J
	xRV+39Q2y1dQ==
X-Received: by 2002:a17:90b:1c07:b0:3a8:cb54:e135 with SMTP id 98e67ed59e1d1-3ae897c9501mr1943320a91.19.1793367040956;
        Fri, 30 Oct 2026 06:30:40 -0700 (PDT)
X-Received: by 2002:a17:90b:1c07:b0:3a8:cb54:e135 with SMTP id 98e67ed59e1d1-3ae897c9501mr1943290a91.19.1793367040424;
        Fri, 30 Oct 2026 06:30:40 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:30:39 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 03/16] wifi: nl80211/cfg80211: extend NAN match indication for discovery offload
Date: Fri, 30 Oct 2026 18:59:59 +0530
Message-Id: <20261030133012.3009774-4-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: cfRJaHrdO4AB-Yy2tk1hr9X8kjKSpFuf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX7DZNpVEyRkWa
 WjGTojmyG5rsgen8Vtsdvedb7Gd/6OBRU99b2eJLNWR5ULs7cr2O2Ht77sxCsS4aL0CxdPeKQlJ
 XKcb+JiQDpBJWd8yNypbVCxGgHTXZPQ=
X-Authority-Analysis: v=2.4 cv=DfSCOftW c=1 sm=1 tr=0 ts=6ae49c02 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=hKTRxPxM3hmCZmPyJGQA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: cfRJaHrdO4AB-Yy2tk1hr9X8kjKSpFuf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX3wqBWgOgTSU+
 +jUuLSt7IO+BgABVmzX9ctbrOYhJeQyHdXBsYtBvt7GBSm71AdEZUmHp4/RBaBWn0NlGoVLZcFl
 fynzH9LvhvX58up22HBwlVJPqU8l9u3RTluxbdLum2bo35rBujtTW5WcTb2l/Bt5TeGGn+3jh+V
 KkGkVQSFIG6CBCr4rmOX0Zr6sNXYexyhCSqqlPC9DteHA0a0+2/V/YUzeQDD3YS4RMmj9iQ/yi0
 w4iVme6O5PMDAMItPZrGzfcLSqLZQzCaLUC46+La64OKvbOJNmZOOrIfdkmwj9G12QDSirGJ1i9
 JBH/2wJWEvBlSr17JJqdxojpUACYOrZuC5sp3/NtG3ajHxI+FCD0EWdMGJzx1TJzWNCFUXKNCPc
 4XME4tkfYtQBOhn1W5e/V0ThW4vHIjepFuJy/CK4YE6MPEg9RCzmkurI5eQ04BZ0/3cXBqAWEfm
 IHvf5hmZslLZCvsVAxg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 adultscore=0 priorityscore=1501 spamscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300053

Extend the NAN match indication with SDEA control field, pairing
capability, cipher suite, extra service specific info, additional
elements, and RSSI attributes reported by the driver when the NAN
Discovery Engine is offloaded.

Add parsing support in cfg80211 for the new fields in
cfg80211_nan_match_params and serialize them in cfg80211_nan_match().

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 30 ++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 30 ++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 41 ++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5dae55db355a..83b66473f8d1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -10589,6 +10589,23 @@ void cfg80211_free_nan_func(struct cfg80211_nan_func *f);
  * @addr: the MAC address of the peer
  * @info_len: the length of the &info
  * @info: the Service Specific Info from the peer (if any)
+ * @extra_info_len: the length of @extra_info (Extended SSI)
+ * @extra_info: Extended Service Specific Info from the peer (if any)
+ * @ies_len: the length of @ies
+ * @ies: additional elements from the peer's Service Descriptor frame (if any)
+ * @sdea_ctrl: SDEA control field from the peer's SDEA attribute. Bit 2
+ *	indicates Data Path Required, bit 6 Security Required.
+ * @pairing_bootstrap_methods: bitmap of the peer's supported NAN pairing
+ *	bootstrapping methods.
+ * @csids: array of NAN cipher suite IDs advertised by the peer.
+ *	NULL if not present.
+ * @num_csids: number of entries in @csids.
+ * @pairing_setup: if true, the peer supports NAN pairing setup.
+ * @pairing_cache: if true, the peer supports NAN pairing NPK/NIK caching.
+ * @pairing_verify: if true, the peer supports NAN pairing re-verification.
+ * @rssi: received signal strength in dBm at the time of the match.
+ *	Only valid when @rssi_valid is true.
+ * @rssi_valid: if true, @rssi contains a valid RSSI measurement.
  * @cookie: unique identifier of the corresponding function
  */
 struct cfg80211_nan_match_params {
@@ -10598,6 +10615,19 @@ struct cfg80211_nan_match_params {
 	const u8 *addr;
 	u8 info_len;
 	const u8 *info;
+	u8 extra_info_len;
+	const u8 *extra_info;
+	u16 ies_len;
+	const u8 *ies;
+	u16 sdea_ctrl;
+	u16 pairing_bootstrap_methods;
+	const u32 *csids;
+	u8 num_csids;
+	bool pairing_setup;
+	bool pairing_cache;
+	bool pairing_verify;
+	s32 rssi;
+	bool rssi_valid;
 	u64 cookie;
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d610b3f8ab96..fcbf613b19a9 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7863,6 +7863,27 @@ enum nl80211_nan_srf_attributes {
  * @NL80211_NAN_MATCH_FUNC_PEER: the peer function
  *	that caused the match. This is a nested attribute.
  *	See &enum nl80211_nan_func_attributes.
+ * @NL80211_NAN_MATCH_SDEA_CTRL: u16 SDEA control field from the peer's
+ *	Service Descriptor Extension Attribute. Bit 2 indicates Data Path
+ *	Required, bit 6 Security Required, bit 10 GTK Required.
+ * @NL80211_NAN_MATCH_BOOTSTRAP_METHODS: u16 bitmap of the peer's
+ *	supported NAN pairing bootstrapping methods per the Wi-Fi Aware
+ *	Specification Table 9-321.
+ * @NL80211_NAN_MATCH_CIPHER_SUITES: a set of u32 values indicating the NAN
+ *	cipher suite selectors advertised by the peer.
+ * @NL80211_NAN_MATCH_PAIRING_SETUP: flag attribute. Set if the peer
+ *	supports NAN pairing setup.
+ * @NL80211_NAN_MATCH_PAIRING_CACHE: flag attribute. Set if the peer
+ *	supports NAN pairing NPK/NIK caching.
+ * @NL80211_NAN_MATCH_PAIRING_VERIFY: flag attribute. Set if the peer
+ *	supports NAN pairing re-verification.
+ * @NL80211_NAN_MATCH_EXTRA_INFO: binary attribute carrying the peer's
+ *	Extended Service Specific Info (Extended SSI), if present.
+ * @NL80211_NAN_MATCH_IES: binary attribute carrying additional elements from
+ *	the peer's Service Descriptor frame, if present.
+ * @NL80211_NAN_MATCH_RSSI: s32 attribute. Received signal strength in dBm
+ *	at the time of the match. Only present when the driver provides a
+ *	valid RSSI measurement.
  *
  * @NUM_NL80211_NAN_MATCH_ATTR: internal
  * @NL80211_NAN_MATCH_ATTR_MAX: highest NAN match attribute
@@ -7871,6 +7892,15 @@ enum nl80211_nan_match_attributes {
 	__NL80211_NAN_MATCH_INVALID,
 	NL80211_NAN_MATCH_FUNC_LOCAL,
 	NL80211_NAN_MATCH_FUNC_PEER,
+	NL80211_NAN_MATCH_SDEA_CTRL,
+	NL80211_NAN_MATCH_BOOTSTRAP_METHODS,
+	NL80211_NAN_MATCH_CIPHER_SUITES,
+	NL80211_NAN_MATCH_PAIRING_SETUP,
+	NL80211_NAN_MATCH_PAIRING_CACHE,
+	NL80211_NAN_MATCH_PAIRING_VERIFY,
+	NL80211_NAN_MATCH_EXTRA_INFO,
+	NL80211_NAN_MATCH_IES,
+	NL80211_NAN_MATCH_RSSI,
 
 	/* keep last */
 	NUM_NL80211_NAN_MATCH_ATTR,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9900f8b91a83..40966cfe5d86 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17878,6 +17878,47 @@ void cfg80211_nan_match(struct wireless_dev *wdev,
 		goto nla_put_failure;
 
 	nla_nest_end(msg, peer_func_attr);
+
+	if (match->sdea_ctrl &&
+	    nla_put_u16(msg, NL80211_NAN_MATCH_SDEA_CTRL, match->sdea_ctrl))
+		goto nla_put_failure;
+
+	if (match->pairing_bootstrap_methods &&
+	    nla_put_u16(msg, NL80211_NAN_MATCH_BOOTSTRAP_METHODS,
+			match->pairing_bootstrap_methods))
+		goto nla_put_failure;
+
+	if (match->csids && match->num_csids &&
+	    nla_put(msg, NL80211_NAN_MATCH_CIPHER_SUITES,
+		    match->num_csids * sizeof(u32),
+		    match->csids))
+		goto nla_put_failure;
+
+	if (match->pairing_setup &&
+	    nla_put_flag(msg, NL80211_NAN_MATCH_PAIRING_SETUP))
+		goto nla_put_failure;
+
+	if (match->pairing_cache &&
+	    nla_put_flag(msg, NL80211_NAN_MATCH_PAIRING_CACHE))
+		goto nla_put_failure;
+
+	if (match->pairing_verify &&
+	    nla_put_flag(msg, NL80211_NAN_MATCH_PAIRING_VERIFY))
+		goto nla_put_failure;
+
+	if (match->extra_info && match->extra_info_len &&
+	    nla_put(msg, NL80211_NAN_MATCH_EXTRA_INFO, match->extra_info_len,
+		    match->extra_info))
+		goto nla_put_failure;
+
+	if (match->ies && match->ies_len &&
+	    nla_put(msg, NL80211_NAN_MATCH_IES, match->ies_len, match->ies))
+		goto nla_put_failure;
+
+	if (match->rssi_valid &&
+	    nla_put_s32(msg, NL80211_NAN_MATCH_RSSI, match->rssi))
+		goto nla_put_failure;
+
 	nla_nest_end(msg, match_attr);
 	genlmsg_end(msg, hdr);
 
-- 
2.34.1

