Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D96331A63
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974072; cv=none; b=AcNnJk3G4GAl3gOXhfEG+kEl139orvRaUXmxKGrsIXhjKbDg64w/E6/dVhcPa5C3+kT1valixABtFY3GvxuWXoKejYVjI+11bh/Qfhcf/o1k1vJxi1kxL0grsgiDyOnCIsBYLJr0ZQJQpiPR2IKLBhBSkkrZfeDnURq/2Nq2h5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974072; c=relaxed/simple;
	bh=3sYVX19CW/RvyvM0L5jeRsCkLH/4Y/xvl5T7rJrbWKc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iBanApPWSp5steJRJHK2TywvRxhUONMwFBuv+HvRjMOR+87NHHob3UxNowat5+uXVdT+sX8/VDEyKiBY5jowZ7UxiE3A57F6bJqiFoyP0O0KQiDHH+5uTcdvohr40L6Vm7GyxdB1P1tcUp7JHx5FfrfLbkeUlLcIUhmDOtV2vG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Q1uDVdnI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XlJD7SKO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Q1uDVdnI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XlJD7SKO"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E7QQVs2874030
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=3LJ58gy36nZ
	i5+S2SZ9uoz/5touzuOvmd+gsNBp/lmA=; b=Q1uDVdnIx9dfY6XIt1syVaB+WpR
	wsiuLbMGmNMSDWjXG+h7BSA06HYVwSyhZIPK2Q6C+TmCz23ritUxhig/4OhLR+O1
	VZ/VqYUBfInOpEhVqxUt5gRLT5vsYgHLLnQV8GSwb09vdEO+01ehKR1E0jNkzvmn
	pVIU2ZQXJj8RrxuRK1P7TvpTDDVMvZzxgNP2jkmDeuf6IZsuz4kqAcmdcG8wa/wG
	BWEGn8SfELCwartPgeeq71OJOTTtLfByWnSTFehZsBlqETb/qGWrKZMRJ+otQi7b
	zx65h5+Cd8XoggDjRdyx9R+ZEuVyZb9YkdJEuqkEruwvF0UFcZXr+2yj3lw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9yphj3dp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:29 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30c0d568830so8265038eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974069; x=1792578869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3LJ58gy36nZi5+S2SZ9uoz/5touzuOvmd+gsNBp/lmA=;
        b=XlJD7SKOhzkud/Rtcysv0pYZmh8v8x0GY/CBFRbqDXBZKXTMYq4OM9RRcEWpVYQe5h
         178bpxmHPkmVf9QM8jvh3UYnNB3HcwwLZjzs5IZh9lwxy4pA3mby1YEHr282+n4sLCz2
         oW3IdiY++6MY9+3KOfsdArqTQ57RjBwmGmVFKkNIsoTQURY2321v5iAo/6IWQxgwrkKB
         HqrwdzJkZKzDBwVbG9keCh4ky7sp43b1NpwKFLx7MQRXmGv60KoQeB1uFF5ZcSx8LWog
         9XHChUk5dCHMPPnfBctwQcbLm926SEXup6MGo+bK6nhPf6bysJTy+um/LvogtE3bVWwg
         N4Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974069; x=1792578869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3LJ58gy36nZi5+S2SZ9uoz/5touzuOvmd+gsNBp/lmA=;
        b=EkhJs+hU3otNPhF7jdVQL7Hcwpub2of7d9BaWXo0kb80eOTBvzQzBxQX0s8ewmevKu
         ebNXWWvRQcg4/24cANn6yjj/CcVfVpI8UfpVqGezwQWXb0oFQNRlu9wpuzVdG4lQmTDT
         xq4NvWo1T4eyxHh9Da1r65NSgwnq2DDblxWhDNxo2pgMW+kpl7/KecLq9dTr5zhdyNtO
         n7POWc2Aiz1wqqhJevhexDAKlvao4lkMaiRJ4YuvzHJa5xbAFMPOT5WPgP80WIUCvc6S
         gfrx7bTAxR9TWLVy0fsQPg0MuLg+Z0UrEdX2p17/21pmzy//C42rkxLTr5PdXJBePY+N
         sb8A==
X-Gm-Message-State: AFq9FYLyQjgZidlwU7u/E7HQpyo0qpRKAAoUM+1vOWNHTO5ELo1m5pdd
	SdOBZ5dUe598LJrFdvW6DfGewVGj3HwUQEn6du+07QN7JanDyB184pmlVt2VnbFQgELSX0sQvwo
	vqnSACaDdp3Nr2iczS/MjF+oPg4kGtPM3ATZdo4Vnqx/wGwV1xWtE/ilgrqWV7sAd2K1VrA==
X-Gm-Gg: AYBFou2Ki3E6ArabKKjNOpFipvpVO96vCTUF/suWnYQU4gTeMGMPs7BCBTqAHI5Hyjx
	Bgjs2E/PD9V/v8w6eNS6EAmpyNqxUXIH7VO7f/Kk4aN05EpddHbdGoxWg7oc5OaClmjAS6uIYuk
	YoK1/srxUh6ZPWQo1LlyXaqk6yd1Q50HT4LHKTU8VaGIv3YWxtKKQB8cKbplQEl9erKDfBO73YT
	Kw2WiRAx34kEKw9g6PFFs3or3s90Oghdpt5k8YyMccFsGFf9sC+5iSE/8dcnGmrdJYXabchyE3V
	1IfY9++fFeV1JB2pIFGVHNimyHhYPlKP45Aj243rux4e1LXY0q7kTVJsS85ACGLyg8AmJoU9+/c
	b/larqTpZhPjFg6H2x7HhxmtTHXJYwyxXGAth
X-Received: by 2002:a05:7301:da11:b0:359:bd18:aab8 with SMTP id 5a478bee46e88-359bd18ac02mr12619263eec.5.1791974068480;
        Wed, 14 Oct 2026 03:34:28 -0700 (PDT)
X-Received: by 2002:a05:7301:da11:b0:359:bd18:aab8 with SMTP id 5a478bee46e88-359bd18ac02mr12619217eec.5.1791974067841;
        Wed, 14 Oct 2026 03:34:27 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:27 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 03/15] wifi: nl80211/cfg80211: extend NAN match indication for discovery offload
Date: Wed, 14 Oct 2026 16:03:47 +0530
Message-Id: <20261014103359.1508345-4-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-GUID: Aci3L0oW20gIMy64qfPiYN5m7LItF1ag
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfXzLc3kSYXXwKz
 pUeXRpBFvyo13KFHmCxDYIk93Vk6146e1+G+mU5oDa0KvXffRS0sFWUYx4s8AJCB/rubrioGXKN
 LY5j5dZ1aKpx4W5B81hGBW6oI6v+x9M=
X-Proofpoint-ORIG-GUID: Aci3L0oW20gIMy64qfPiYN5m7LItF1ag
X-Authority-Analysis: v=2.4 cv=Uv72pOwB c=1 sm=1 tr=0 ts=6acf5ab5 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=DNbGb1CnGowLVgfw7CoA:9 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfXxa1M2BQdTrL0
 ez3nm9l0duruR/yJpafSeHrLuidxYLgY0nho2mHQrEdbXJzP572r8EOKYvO84soFv/yKUCCNzIz
 yDLW7fZk6hKTIrmeUL5Iz6sDJgAt26wC+e9vEL5CmszG5UWNURXYTPmp5v9c0JQQ37044AgH6ua
 Yrnc+m+kr3/db1Uft07jlnYbmIHgJKpJvvb5580m7pfCpzw7hjtD3YKaOM7ouaPexPIxihWHFaX
 X2TpzytQLxDeqKRlgLDRL8nNhlXVOUBQWd5Idpml/aqHJmDCDFB1Me40zzK20ssBt4cPXGbMKCU
 KfB0jkZVyzRd1Dr3aCRpKOYqmIgk/N/vhN0S0TOSSrtJP37Lr8sITOLpR4y3TnY5OMBgbsrD0VX
 S4MdUJwUz6Ty47kXL2u2n6hPfTYxySViWSBr24YsPw6gaDnij7qQJrGUfV4L6dXh5A2RJksrmLh
 PoQYaGWn/WeiPxB/Ewg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140041

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
index a795bda484a2..d34b2be0edfa 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -10581,6 +10581,23 @@ void cfg80211_free_nan_func(struct cfg80211_nan_func *f);
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
@@ -10590,6 +10607,19 @@ struct cfg80211_nan_match_params {
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
index 52e7c30a4ce3..bd547f4785d0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17861,6 +17861,47 @@ void cfg80211_nan_match(struct wireless_dev *wdev,
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

