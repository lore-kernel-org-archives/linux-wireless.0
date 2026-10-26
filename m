Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792992643;
	b=JmcZ8k/5OdHCIV7siQi4+JYIHZlpJiQ/6UBV5+DFwINlq7b/HQSDI03SpO1Hodd3iaWI
	 LxWcQR4wLE52Z8hZoTypUIlfz3lUSZFVo3mEJRAAvQD9MJdsuZL6nTNtVo9saHkRjKV2h
	 vXbHRpIzPfSI8UESsonxfIXNi4jAeb1cBl9y0I9Ac4MrjZSJyzkztx8adCjzFWaxjMABx
	 ByGJaj9wbswSPq5Rt0kItyZTKG8Cv55MW+c3VTfOr537J07ItaYJ0IhxlJaWUWw7EStQ2
	 egh3lYX91xVaNkS+ni1d+AQAQi3DMkhl4OcMR8YdkuVqiY92STWMaLKobH8Yfsdpb/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992643;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=RSTZyb5+uiWzqJVObvhjIHn8jGxooKwz09y219ms2cE=;
	b=CY7vHaOZfJ3HKMug+BmRkl3MoSdtHoHfuxWTQntJn7kXjfCS7Ihh5nyFnd9h+89o9Ygq
	 zS5reVT4UPDX3L7b1vXp8tUygYBzvGANs8ViUMRVXY8Wt56VCFLwMXVECr7d/dCX5+UWl
	 KE+N6+hJGYMsEh32MgM4jn122SZn+jJ3rY9/hf8rdruJUv7o/8ZabJgk4QBsTNOIQKW5g
	 l8LeIHCj2DdrpOHqR3GyKcc0l/oxJEvclETTzxWX2rKyh4GsBI+JO/0Mb4Sbtuy19+53F
	 gHl2JjE2m6d2VPFZQJTrWURQWcsFzD/XK2Flhs7IFwXLwmvxam417Rxx54K3p8SPw4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=G6yDbX9c;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=doQ1VI0d;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ADF606A31B
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:30:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80ADF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=G6yDbX9c;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=doQ1VI0d
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69Q4aV622222637
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=RSTZyb5+uiWzqJVObvhjIHn8jGxooKwz09y
	219ms2cE=; b=G6yDbX9cxSPMI7yM7QijxKmWIRc5a22+2XKP/PP2ogC73noKMJC
	KtCGLxxKVSgAD4UO4n/mqbIvOGuZgqwptDTO1x8VMaAaAMsosRSLERylYkJCQ8EK
	au8c/AocnyRrCUC19A5PeGOQ4qND6dUmBB6J+wIq4qYmUDL4sTlDQQLLbf3kFiYa
	YCtHELfcmoex0XvCog3w5XqLIMYYT3PsBK/eSvzyfaoNgcpRDbLfsNcJmNts5iAL
	R8wYEEz8ACTp1sufXGQTWVcr9k/oB96dHfwCjrTEQW4qJ3VV5AGHJXyuZlb+Fz6K
	K2cXibkjh8QGrBD53QC/C0c/dPXEQqk5vmQ==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hhvdd8nfp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:30:41 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3548cdfd2fbso4575490eec.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792992640; x=1793597440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RSTZyb5+uiWzqJVObvhjIHn8jGxooKwz09y219ms2cE=;
        b=doQ1VI0dre53twnEUNSeN1ALjSaSkK/gtKr9rc4IQ2HiGYJGKROdfKLRPCNvzh54c4
         TU5Wkx6Lg+JMd7scvdHYSYjooHoDUf82VYkpX2pniHq/XnCaMh75B2IQh3jvqOs5iYw2
         U59lmWbuo8PYVAQzaZC1X+/dG/OxmYgzeeP7RNnMV4/jc+rKU50R+IM5CxUXdU1Es+nk
         +/LRpYLS13e7V7VGpyQzk7VB0yEIwjOB1warxKhleU1tF2+ye9YUnVhziT8YrNSCK82t
         PukTMAauuRY9B35nzOObblH/i5UhjpnMKvmpnprHg7O4mBCjyOXLMx+yJo5xqQrLUP/i
         jCZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792992640; x=1793597440;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RSTZyb5+uiWzqJVObvhjIHn8jGxooKwz09y219ms2cE=;
        b=aB8iSHKLOR7WrGKu5Ssd9xx5PgzEAgdVn+cY03VQegSZCk7zrfnmvGOhHRkhW+thol
         5P1cuRA7F4eiEMEkezgVTI7UfifHrbWcHGicDnu1C4FCu0c6V23ksNziW70XtbKwam8d
         IfoErlwmvVqtDJzKZJiNzLMgt1sXZynMTGd6zBR89ikZwbrfVxKf4T5+mJ/Z1QsfLWqh
         pB50F/uAvueLD5vgUp6I62teTWVqyp4T+QICBwZPMrZIrTJ4H2B5iyNkuUFbERFQT2UI
         EXQ3fuoXWDU+1FfwDYv0ayl7z+ePl6wdOBrd/741m1VeZ6CaUWapylMK+mAoFC5VFaIe
         BKHg==
X-Forwarded-Encrypted: i=1; AKwUvBwCGc5NYoDdSHDir0J4u924rTbKg/qmnA+4+41iFxHLFzAGqNdApjgF+d1+8gPxDRnBy8f1NaawF9q1zrRncw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKmhMnaPQ+b28caRGqk5B9wzD1e3ld9nD5Xd8G83ES/nAkAIS/U
	ZSuRAdq1SUP9t6kuuMU+LlO2tAOnp6OPG//pFYmrwG+AH+zeBrI5q3Oq/n37bLa/gmxU+zNRURT
	EFjjSI/lcfkeCMY/ghBLrVDwiAvzWUtBVjTvSZaYion3LQ1CG3/CJmgAYhbweiu6Y48adlLrhqI
	zzAsWi
X-Gm-Gg: AYBFou3B8gp5XuAK7303oiL0nJKk2cIweVS/BFiucaZ6/03pP0jvvrjN8e+8BzMpzoB
	86HGWAYtsoCbV6tHpH9RoNYm41F7o8xBilNRwVbtvGP5YsopmTksNKYBejt6AUJL5XcCrxO10Fo
	3AmS91mG2+Q5fbZlt1wZEz9LXxhkzkraK5fNpJrNOwH/XStsCaATQbcMxUtkA1q/YKfPGxQ0gfz
	0U3Rtqch100LazQZhzOPFMMwV8N6gpcFTXiVKx4PIcIGFkMTEWCUp9mz9MyhM+TBXRg6QtMARt+
	9NMK++pjebYGrUVfA3y677oBkzytqbKoLw31fgdqb8Wi72gHJL3hYQldn1Yx8p2nDK6HT3jxm7O
	XRbsrUAOqpisIkWvTyLM1ls2XPDfmGNmqVlw=
X-Received: by 2002:a05:693c:8944:10b0:36a:713:a76b with SMTP id 5a478bee46e88-36a0713b22bmr374389eec.6.1792992639980;
        Sun, 25 Oct 2026 22:30:39 -0700 (PDT)
X-Received: by 2002:a05:693c:8944:10b0:36a:713:a76b with SMTP id 5a478bee46e88-36a0713b22bmr374352eec.6.1792992639401;
        Sun, 25 Oct 2026 22:30:39 -0700 (PDT)
Received: from hu-hongchen-sha.qualcomm.com ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a03bea5d4sm2982718eec.6.2026.10.25.22.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:30:37 -0700 (PDT)
From: Hongcheng Zhang <hongcheng.zhang@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org (open list:MAC80211),
        linux-kernel@vger.kernel.org (open list)
Cc: Hongcheng Zhang <hongcheng.zhang@oss.qualcomm.com>
Subject: [PATCH wireless-next] wifi: mac80211: preserve disabled subchannel bitmap in 6 GHz CSA validation
Date: Mon, 26 Oct 2026 11:00:11 +0530
Message-Id: <20261026053012.1668561-1-hongcheng.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
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
X-Proofpoint-ORIG-GUID: Dzy7lFG6jYybjB0UeQVPV97MHR7D730v
X-Proofpoint-GUID: Dzy7lFG6jYybjB0UeQVPV97MHR7D730v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDAyMSBTYWx0ZWRfX+ROwoViMpeh4
 /tD1MWyL0uFI0Q4VRWs1VTwK+0HjBkXgmplK6B9pZIXIwc499dG7cuBZi2EyrXdqqMvJRpmQpnN
 8umGD3c+aVrTgjFCPqmckp3f5I0FDU5bzEoX/H0iCzYnm+TiGNaXesE2tsve6J/PAyMzVvzaaE1
 ohQUmoAfguE9fufJ71aY4q1pdzMx4TG30aFp6soHBs1G+PNkwqPxK62jB+Au6J8zvbGP3o9I77C
 ZOkRAVCiPV2hywVJcGBPT+okNkn3l/N0aqIZFW9tl0cDjUY56bPpc7dzZmGaKMQiL+AIfh90TuV
 SAd2fGQ26y1NZO4cbkRQ3o/rH1uYpKlcTaHtRCtPLfgFxDnEnAWayM5XYYEtul8sEvxJMicC14p
 R7OTEAl/ENzbdrpzkx5jBlJUVYqbrjXNci6zQ7MUivHwiRYkKoamN0XFWgKL2fSNk1cirgEslKr
 tNqU8EiOTYcyvk6h05A==
X-Authority-Analysis: v=2.4 cv=N8+8hG9B c=1 sm=1 tr=0 ts=6adee581 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=AOFKImNPUqAlGEO73toA:9 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDAyMSBTYWx0ZWRfX+uBnYEE4kxsV
 he3JwlvrShvvp34L/nrv6I+BvfUxJM3HFT5tdY+NWCR2Bb3dpDUZ7YGMVnyIPuojR6EUQRbbhtK
 T2VTH8pQV5CxZ2CLOIcDTsrDFNTdDNM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260021

During 6 GHz Channel Switch Announcement (CSA) handling, mac80211
parses the disabled subchannel bitmap from the Bandwidth Indication
element into the new channel definition.

The channel definition is subsequently validated by reconstructing a
local EHT operation element and passing it to
ieee80211_chandef_he_6ghz_oper(). However, the reconstructed element
does not include the disabled subchannel bitmap or its presence flag.
Consequently, ieee80211_chandef_he_6ghz_oper() overwrites the parsed
puncturing configuration with zero.

Preserve the parsed puncturing configuration by carrying the disabled
subchannel bitmap presence flag into the reconstructed EHT operation
element and populating its bitmap from the channel definition.

Signed-off-by: Hongcheng Zhang <hongcheng.zhang@oss.qualcomm.com>
---
 net/mac80211/spectmgmt.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index f5e4970869b6..5d26291e7569 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -152,7 +152,12 @@ validate_chandef_by_6ghz_he_eht_oper(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_he_6ghz_oper *_6ghz_oper =
 				(struct ieee80211_he_6ghz_oper *)he->optional;
 	DEFINE_RAW_FLEX(struct ieee80211_eht_operation, eht, optional,
-			sizeof(struct ieee80211_eht_operation_info));
+			sizeof(struct ieee80211_eht_operation_info) +
+			/*
+			 * Additional space for the optional
+			 * Disabled Subchannel Bitmap
+			 */
+			sizeof(u16));
 	struct ieee80211_eht_operation_info *_oper_info =
 			(struct ieee80211_eht_operation_info *)eht->optional;
 	const struct ieee80211_eht_operation *eht_oper;
@@ -207,6 +212,13 @@ validate_chandef_by_6ghz_he_eht_oper(struct ieee80211_sub_if_data *sdata,
 		eht_oper = NULL;
 	} else {
 		eht->params = IEEE80211_EHT_OPER_INFO_PRESENT;
+
+		if (chandef->punctured) {
+			eht->params |=
+				IEEE80211_EHT_OPER_DISABLED_SUBCHANNEL_BITMAP_PRESENT;
+			put_unaligned_le16(chandef->punctured, _oper_info->optional);
+		}
+
 		_oper_info->control = _6ghz_oper->control;
 		_oper_info->ccfs0 = _6ghz_oper->ccfs0;
 		_oper_info->ccfs1 = _6ghz_oper->ccfs1;

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.34.1

