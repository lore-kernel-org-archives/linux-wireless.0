Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DC03E00BE
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 09:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785921970; cv=none; b=R9gY1X6yGKoU0Yg+0C4ue16lLlQ8kdFFbvHw78ZgwDJYDJxvkYUBv8h913t5oxmECoV3n5HUgESvZgoHG84zivT6+SHxBmc+o/CuLXLQTU/VSscTWqysMOgDDOf1Lhm5X2M39R6U9pHtRsoZGrweprtc5L/cd0HHrumC5/cTn+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785921970; c=relaxed/simple;
	bh=q72eiVW5fb39U4DlLYgqTBH7NOmmkRbT+insWxEbJaY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=gnRN1tAtdt1g83w+RgHXMQ6E2L57e8DeFw/59Fl2ndvu+uupsTfqCAmN5R94TE7tLxgTMD1WMLv/FmPWXB5or2wE2nzDBw/Z10pNz8//JD2qwv/oRhRsMwGzsUxD2A4c3pGke/F84HA7XLo7gv3W9uzcECXoyOx+MG9oE+cb6MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hsljXa7H; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KaxcF6fd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hsljXa7H";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KaxcF6fd"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6758deK12669688
	for <linux-wireless@vger.kernel.org>; Wed, 5 Aug 2026 09:26:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Y4qZYpQC1XWFGqaozkfNsC
	OJvHOVv91TYsi4n1Ezf8s=; b=hsljXa7HHZlTVSWsFwFhih6Sb2MRQwNLoVhwXl
	69fdLNhPiUbtLdAAq+zdUGRXcTW7RBqnMn8MyakGo8qmw/crCR7I7TAEA/cBrxbE
	RJuekxVeWO6bLimBnljqZ2QOXxFoOT1EgCbRTLzJ6axgQXz74gYDgkxPMaQvAxzO
	bBeA3RLN0i8h7BPznfFJfcrkqmpho6lp09303rRD2J9uN/d+6r79l7QwEOBuKn07
	5ecca8PZYyECRbyLMg850clol2FIsjyTLmR6ktsW8/cFTyAxasAewquiIoUIdnQy
	inObYnG6KXOBelrj7ZIKKEUYgEeviLfMEtvRBukDSLjelpWQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fum3qbu6m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 09:26:07 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cab041eced3so1177775a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 02:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785921967; x=1786526767; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Y4qZYpQC1XWFGqaozkfNsCOJvHOVv91TYsi4n1Ezf8s=;
        b=KaxcF6fdaPutQct9pdN5CrT6P4IoJsZb38Qq170ah4ukxJqZ2cNia//3jAiabAlzEB
         /uWHhuTA01ExoA7zK/oQ39cIpnMEPJrHoQfBZyqO8Kq9G6Gc6slC5QjQHPgKq6Fv+CAR
         HASvTOlUFncsn9feOmUhDYWxL61JPXEWGatQi/U6MIlOl6suM2OBDUiOMiNmlVhnyefZ
         Gr28rm5XXlMPMTl5JaZDaUc8np7su42CePSGimlnxEZbqquwVMcuijkrC002SdLG5VwP
         C971HDjYiQmvGYSJFlzf0tO7B3HrIJRZL3mFrCVev7qjqFxGt6dM0sTVbiGozlqxp7dD
         goIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785921967; x=1786526767;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Y4qZYpQC1XWFGqaozkfNsCOJvHOVv91TYsi4n1Ezf8s=;
        b=TWoCkhfSdlkqayHOWGhiY0DBAuk43JaYAEC/id5mY6xzjiv0bh+O+p2xTK7UqeglBN
         NZKyExg3NgCdfbjDzTDs6nsuq0Dd7ajg6/gX4HZ/2w6orUXc+AMVEE/9ohSBG18qwtQF
         4MySwY4YqipdhDngTeCcQkTJ5c/tit48PqzmVaT5Qw2yLMg75tue1Uo5kUfA4jYLbEMW
         kOadXJLaYyrIy/j4/o17123r7OBdDTHd+XowQ21WZASkCROhqNGRa5nXkcy7SKadeEFT
         cvv91BqaVmrK+n6SGm0YZpyc6KOlw3LhglL5KtHqhS/irnBENDMk/HQ9hXhdPDUcE3lR
         7ing==
X-Gm-Message-State: AOJu0YwSv+27hIJt9zPsvaLUAKCslHGx9b/ui0wCTbL1hqGISCvBjOH1
	WnPrG7o95JUJdR1ExhG1dI28O1l3pTI+mUJWGj/UNFo9qjNaJySBEKMBD2tTA6nc1Qa8JGT9DAa
	H8xx3MhwC68cNypYqGgOhNUIlgFFJFlpAEnB5redIRaYWvQO4D+RP8sQLCi93CPOG6KwM6cGxH2
	P3Ag==
X-Gm-Gg: AR+sD13knK32XUVSAongGui5JF7X1nU0baKApEeY/2jFxNEdGsfB6zPuV6bl8EKEzD9
	w4KOsZcGDaVQGq0xK85/qh6yDxkk72aHp4AflJoE9DcuZbGcxkHuw/7Q9ntap9enSC/LWvbBMQ6
	C6USRVBqlVylyhJ9guVaN/vA/yDwBm70ymGQr3GF47Rni6gQFbA0k/Od/dv0VOixYQEacqmuxZA
	N7Yd8cLAG2S0ghXIdfcqwTBpqk//WLfk8ZUbb//zvTDYDG57crxkRRRNKsBllqqnmqMysAbwpVb
	GgJZ2qQlhSUSBVi/btIXQ+YbAQJQL/fF3uILjYAgPBzMcpXMM+dg8JOLOaCpMqlxpZFjLrbP60p
	ZGfdA4ppPoW03z45MnEIhT2D54QAgFgaDnCy/qOKmwvNuLjKikYKHsGSxriZDFGMGPlvWtH69Wu
	rFIF3lBT3lyfPFJXRVNzNAcvhXug7NFWof
X-Received: by 2002:a05:6a20:6a03:b0:398:8870:b58f with SMTP id adf61e73a8af0-3cb85de7ddbmr6408652637.14.1785921967013;
        Wed, 05 Aug 2026 02:26:07 -0700 (PDT)
X-Received: by 2002:a05:6a20:6a03:b0:398:8870:b58f with SMTP id adf61e73a8af0-3cb85de7ddbmr6408603637.14.1785921966541;
        Wed, 05 Aug 2026 02:26:06 -0700 (PDT)
Received: from hu-mdharane-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fca2e8ae2sm12113885c88.0.2026.08.05.02.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 02:26:06 -0700 (PDT)
From: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
Date: Wed, 05 Aug 2026 14:56:02 +0530
Subject: [PATCH wireless-next] wifi: nl80211: add support to configure 6
 GHz non-HT duplicate transmission
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260805-dup-beacon-v1-1-68574869c896@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAKkBc2oC/yWMSwqDQBAFryK9TkMrGkOuErLQmad2CKNM+wPx7
 pkky6KoOsgQFUb37KCIVU3HkCC/ZOSGJvRg9YmpkOIqN6nYLxO3aNwYWLzUJfIKrqspBVNEp/t
 v9qBNI94w44B9pudf29K+4ObvkM7zA17p/st9AAAA
X-Change-ID: 20260805-dup-beacon-0d074e15ecf7
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
X-Mailer: b4 0.16-dev-5ef6c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA3MyBTYWx0ZWRfX2qEya5s4HjmP
 qGBme4e6Kd3UIGKgVEXAgnHWZUaRrt+oa5s9uKoLvEDke9g1WSvI+wXxmQtqjHgbKXzpGof1w4P
 vGUF7ZWRVMzR3b+WSDGTRBUxH5da+rtLnmFeu+cfCaCxPcv+iqVDFjVuhtEgbCMeTBxgWqTcROl
 vWuP1hV7ooPKGvhiopv+rj1t+r6JKLvt0W82kHIzbCv1YHppBcLXOV8obR4uOomdXNZhIvTnfqZ
 kGHvO51bH8pZPfBpIUUDh6TpYvnBa/CR/pInju734gaTfO/mlij5alScJZQmyVxHHQT8aYDSyPA
 KwPux/e6s5LXz/yFnTWss1TWqATxTHJ04/VwJ0nlKizJ67NTVRN1krEZaCWFUZlW2HE40caRNSy
 /3NUgjFqtHSBSWPK1IE+gdefW5cGrZOlHaAFch4uU6bX3sU2NmXzbCX9yZY+Pd7F8bJvLgR2k5+
 tUpx8DtAuHvjcOcvvcA==
X-Proofpoint-GUID: dANMdkrpsr-t0xlXKteCAtmwVt_Z2dFj
X-Authority-Analysis: v=2.4 cv=LsiiDHdc c=1 sm=1 tr=0 ts=6a7301b0 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=lxZXDpucRaSZJ1MObIwA:9
 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: dANMdkrpsr-t0xlXKteCAtmwVt_Z2dFj
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA3MyBTYWx0ZWRfX0AwGcQLK8kal
 ocHo7509WRgR5e1gilAv4PHBb0VOJ7P3s0USmC8qsTqD0A+pct6txrhWbk6pRThc8+UAhhd/JNM
 nuP0NjwAYo1ctWFSjhwUK3P2HqW6uZM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_03,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050073

As per IEEE Std 802.11-2024, subclause 26.17.2.2, a 6 GHz AP can transmit
a Beacon frame using a non-HT duplicate PPDU, so that stations scanning
only PSC channels can discover it. Currently, there is no mechanism
to request the driver to transmit non-HT duplicate Beacon frames.

In [1], changes were made to parse the Beacon from user-space to set
the non-HT duplicate flag in the kernel. However, it was suggested that
non-HT transmission be part of the Beacon TX rate settings. Hence, add
NL80211_TXRATE_6GHZ_NON_HT_DUP as a flag attribute under
NL80211_ATTR_TX_RATES to let user-space request the driver to transmit
non-HT duplicate Beacons.

Also add validation to reject the Beacon if non-HT duplicate Beacon
transmission is enabled when legacy rates are not configured.

[1]  https://lore.kernel.org/all/1644914581-21682-1-git-send-email-quic_ramess@quicinc.com/

Signed-off-by: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
---
Note: Users(ath11k&ath12k) of this new NL attribute will be posted later
once this gets approved.
---
 include/net/cfg80211.h       |  1 +
 include/uapi/linux/nl80211.h |  4 ++++
 net/wireless/nl80211.c       | 13 +++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 97c16d4ff127..6bc490108303 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -901,6 +901,7 @@ struct cfg80211_bitrate_mask {
 		enum nl80211_eht_gi eht_gi;
 		enum nl80211_he_ltf he_ltf;
 		enum nl80211_eht_ltf eht_ltf;
+		bool nonht_dup_6ghz;
 	} control[NUM_NL80211_BANDS];
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 020387d76412..d8fefefc11a9 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -5900,6 +5900,9 @@ enum nl80211_key_attributes {
  *	see &struct nl80211_txrate_eht
  * @NL80211_TXRATE_EHT_GI: configure EHT GI, (u8, see &enum nl80211_eht_gi)
  * @NL80211_TXRATE_EHT_LTF: configure EHT LTF, (u8, see &enum nl80211_eht_ltf)
+ * @NL80211_TXRATE_6GHZ_NON_HT_DUP: configure 6 GHz non-HT duplicate Beacon
+ *	transmission. This flag is applicable only in Beacon TX rate setting
+ *	and must be accompanied by a non-HT (legacy) Beacon rate.
  * @__NL80211_TXRATE_AFTER_LAST: internal
  * @NL80211_TXRATE_MAX: highest TX rate attribute
  */
@@ -5915,6 +5918,7 @@ enum nl80211_tx_rate_attributes {
 	NL80211_TXRATE_EHT,
 	NL80211_TXRATE_EHT_GI,
 	NL80211_TXRATE_EHT_LTF,
+	NL80211_TXRATE_6GHZ_NON_HT_DUP,
 
 	/* keep last */
 	__NL80211_TXRATE_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 44f2bad08670..cb4752fc38a0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -569,6 +569,7 @@ static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
 	[NL80211_TXRATE_EHT_LTF] = NLA_POLICY_RANGE(NLA_U8,
 						   NL80211_RATE_INFO_EHT_1XLTF,
 						   NL80211_RATE_INFO_EHT_8XLTF),
+	[NL80211_TXRATE_6GHZ_NON_HT_DUP] = { .type = NLA_FLAG },
 
 };
 
@@ -6303,6 +6304,14 @@ static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
 			mask->control[band].eht_ltf =
 				nla_get_u8(tb[NL80211_TXRATE_EHT_LTF]);
 
+		if (tb[NL80211_TXRATE_6GHZ_NON_HT_DUP]) {
+			if (band != NL80211_BAND_6GHZ ||
+			    (wdev->iftype != NL80211_IFTYPE_AP &&
+			     wdev->iftype != NL80211_IFTYPE_P2P_GO))
+				return -EINVAL;
+			mask->control[band].nonht_dup_6ghz = true;
+		}
+
 		if (mask->control[band].legacy == 0) {
 			/* don't allow empty legacy rates if HT, VHT, HE or EHT
 			 * are not even supported.
@@ -6344,6 +6353,7 @@ static int validate_beacon_tx_rate(struct cfg80211_registered_device *rdev,
 {
 	u32 count_ht, count_vht, count_he, count_eht, i;
 	u32 rate = beacon_rate->control[band].legacy;
+	bool nonht_dup = beacon_rate->control[band].nonht_dup_6ghz;
 
 	/* Allow only one rate */
 	if (hweight32(rate) > 1)
@@ -6405,6 +6415,9 @@ static int validate_beacon_tx_rate(struct cfg80211_registered_device *rdev,
 	    (!rate && !count_ht && !count_vht && !count_he && !count_eht))
 		return -EINVAL;
 
+	if (nonht_dup && !rate)
+		return -EINVAL;
+
 	if (rate &&
 	    !wiphy_ext_feature_isset(&rdev->wiphy,
 				     NL80211_EXT_FEATURE_BEACON_RATE_LEGACY))

---
base-commit: 6c5fc504d0d6934132637aa3db4b9b58148eaa78
change-id: 20260805-dup-beacon-0d074e15ecf7

