Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73903D9DCE
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217723; cv=none; b=p2jz1kr+taD/nmldK+f1O66eeFPedXXF7JLIQIAJlntUL6idUd80BrBMsvOwbVYHUNjTjJuzuxRBuhJaCB8OiQQZFl3jZOC9aUF5ZuSFWSgLJKb6/ny+fLcHLPRCNIYsh8uFKKxSgX6C+pDkZFpP2eQaD63oNcyyq0hHAD5YsYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217723; c=relaxed/simple;
	bh=zbyBR0/Jr9XStvE0BaDp0KlvS9RInzUSbblgN86wdg4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=INY/Ltvkumz3yTM4zfuP7lKF4x6KRRFtxW+C5xMajcKAWG1GqY6JfoRHqi/3WwwHzL61+OrT3DsXFOii/ODeBdubcCqyJfGwjBZEkx9pEU+cNwW/gIH0C7FEgyEUSHbcyKc1iuzia3dNAEQpb/HVB2gs7njb0TpGPJK2lUpaC9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Or8N0oBY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bbBUZsTN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Or8N0oBY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bbBUZsTN"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O2JxQj1994630
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	N3zlRvBjmBzkNQjO8objmY5TsdSrJG/Xb50VUn46oCk=; b=Or8N0oBYDHG1kKgk
	mHLprfW34FPs8cQgFV5jCUHBNt0E1jHuypiHmxr9JUa1j1iqRwuqBwKFwRtnLJ/4
	wHeNOmsy1+sRojxev8Sh23av4cGJfsxAOr+5CtDsvJFTcFRkL1ZzhcwdXZeDONsh
	/RjoGH+GIOy6reCgjx5Bnl36mBld6XmDNpWX84copJVhRAyUHCZ1kGxL3LFobYNJ
	mt+kNnIUCcUZ/0F/K3oT81Z20X0Fn3CcJo+t7kBaP5GLExm+gPnCXZHySfuP9Oi5
	ZGXf113c0iIxL2r04UA+d5xxAI54BnRwgcy/VRUM8Cyw0OAAsbvlh1sr/G0Vc4Id
	h7B5xg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvstug9me-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:01 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33310847fcaso2831073eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 19:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790217720; x=1790822520; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N3zlRvBjmBzkNQjO8objmY5TsdSrJG/Xb50VUn46oCk=;
        b=bbBUZsTNfjecDTBVesGmfLvBvK/Qv8mN6z58NtMScgaqCn3rZkgtSdWUAROpkjJj1A
         uT4nZ2mok8IICz5hnq824hafSIQnFHmcsNgY/KiDqLmDkgiA8VauJcnCYPosZpLx+CW9
         BxMSnWvXvM5gxfy8+6FEUyRE97kSdDqVzyzdDr3QMMftO+EC/SZhwa7S+uZ9vS1an7LP
         6R0oVBJZlNeK8jYvBylEDcoMb1LvJz8nCSMCg7rOhzsrc+qTB8LTfBaiQTdOguOEQKJc
         tC7rbZASvvCPYPKdjt+lvfR8sekDmdF3j4VGCqLsAmeE3SsQrE2ki9dMiPGLTdIuqW5B
         18ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217720; x=1790822520;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N3zlRvBjmBzkNQjO8objmY5TsdSrJG/Xb50VUn46oCk=;
        b=s6+t/vfjcXWedU7ti5+sRT8q6zRMODG16poI1YQuUY/zAT3rqmrpORsliiUFfyOaFs
         4WcUYRh8MN7d8AYhFY9BQ9POYArvmQR5q8McQ0viIoTrscESARMiJJ+6yMAX0izxxZeO
         Z1REFFulaZhjEG4G+6Z2+JnHSS6vVkIn1VphDjGEQ2KnwAJffOhY/9i7ym5iI6Gu0/HV
         nwbbSf+g2fswVxBE5CktBO+Xl5nsICDoEDrH+n/BmF2aEz/n/pJTtijbdesy999NAO9N
         YLSqbAoCNCd+8ZCbNF5nKa4Gvju7uLp3GhMS3yApfQGQIGt4PiGYMA6gp8U6GMKlDj+B
         BaKQ==
X-Gm-Message-State: AFuF++k6g8i3cydbNYTJlt2ZB5Tv181KBDrmeRhrTG+0feMwWv2WhrF/
	wOeAdYRp2wV3L9GSBIXIWfqtV19Da8yNQSYl7UIdwMpjLjRdZxBns8Uz3ku2lUJL7+hg0pfYKYb
	/pDeW09ee9Vup4HbongycyGraEd1YXVk3erwHDvMWkJMSjBtl/Je+PrhjoNmTm+Iy/igXB6z/ku
	LX
X-Gm-Gg: AYBFou3lneojs3SeEyUDI2+AvuJPNo/1ScUKbr14YUU1aMbJWV6OVLpfvgj/on4r61D
	7mrRcQzPPeN/iusx5i5LUmnbJThA7PvMK4BuLab1SUCkeEcaEunU+fHybzXDq+cVIGMAzOdrSlS
	HCiJCD+yWxJ6uVKWpTDctKjonrpTSQfVYr2iVhjgrFYABbOg3xBJGsY6yYmXj1gB9y/fZxQ2dLz
	ANCmVZ5ekqgLVzDURezSrSCaTO715yU6+/7ZVkwY7SkfD+ESNlHNFQGR6FrUfh49u5gp7+/XkEb
	qbrgktLSUjbMt60aCRxhguc1VnE88pyjB81HiERGzyaRYqBtaRxYFCLdtIqdM7soKFfdIUXfse+
	0PxxozBZKQpga1GqbqjPDlzUaSgvw6tL92ZIyES5z/svqs7AkqcfcsSkyiGHXwDmbGlpdRHm+bn
	NvlHufsg3kVDlAH1tDGr+1tw==
X-Received: by 2002:a05:7301:4208:b0:33c:2457:bdb2 with SMTP id 5a478bee46e88-33ffe74cd9emr649866eec.6.1790217720250;
        Wed, 23 Sep 2026 19:42:00 -0700 (PDT)
X-Received: by 2002:a05:7301:4208:b0:33c:2457:bdb2 with SMTP id 5a478bee46e88-33ffe74cd9emr649849eec.6.1790217719424;
        Wed, 23 Sep 2026 19:41:59 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96258351sm9692263eec.12.2026.09.23.19.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:41:58 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 08:10:46 +0530
Subject: [PATCH wireless-next v2 09/16] wifi: mac80211: Define layouts for
 SMD BSS Transition context
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-smd-v2-9-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
In-Reply-To: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfXx7bHNW9A5Mku
 LGgaNCLUScOALq7dr9FxS1MlFh+2uk0RdnFSt5TIRWJc4gWTWVZ3CD3NrXvii4QqcUlRiGJW7OZ
 a5/CV2DB6V4faoSCEASQFy6YwQv4jw8=
X-Proofpoint-ORIG-GUID: TsgiBbOvFQ8-sw2EsTjMfC29ZLWlnxMF
X-Proofpoint-GUID: TsgiBbOvFQ8-sw2EsTjMfC29ZLWlnxMF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfXzuJnsAGwB6Vy
 SPkDb2Kvp1AFh7iH1UhYgElVNU0ma/LaXHb2mri4vkL5hVDdpY779ggUMtrEyPkenWFZ5Od1RXQ
 fXKMhd9aGIF8pa/cbuNGGu0Fm6Lv2oqxhGKrhyE6TdzcrV0QfAiGEkpfASZS5Ay/1xx9RpIpVic
 MxmJn4E9FXf7KYh/3KwFmPMo8T12XuzXrO6mUrAvB0+Xkg2fddk/JsFCiYUEL2Qm+A3fvAJ/W0K
 reC39ZnkbeqRtUTsw3O4St0bfydogT3fuf35Il0ySL34ri5UI9xQcWSpM/YelqKL/g9IqmAu106
 dS9YVVTwNm2zoIbYYFej4i8yhM6S5pb1QnXuyKz29GzFNl8kshhPvpn1R6TZvelYXBkF0nO7Yk+
 oNADntCW3qsswIXVsD9FAicPHvN+HlMOiQGzI6ePiFRm3p6Lbs9HSmR5KW5oCylHXRh13CSDL2p
 pj0m9F0iMtn5qw4aigw==
X-Authority-Analysis: v=2.4 cv=cKp1IVeN c=1 sm=1 tr=0 ts=6ab48df9 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=Q3cHp_LDBd8SisU_aE8A:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 impostorscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240012

IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.9, defines the context
data to be transported during SMD BSS Transition (ST) laid out in
subclause 37.16. The station's context data is attached to the ST
Preparation or Execution Request action frames so that userspace
receives the context along with the relevant frame.

Define the context data: per-TID sequence numbers (SN) in downlink (DL)
and uplink (UL) directions, packet number (PN) in DL, per-TID packet
numbers in UL, and per-TID BlockAck session parameters in DL and UL;
along with this, define an optional driver context. This data is used by
drivers to report the context along with the frame SKB.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/linux/ieee80211-uhr.h | 86 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index c3f87d4c8bec..e6aaef9ae9e6 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -649,6 +649,92 @@ struct ieee80211_uhr_mode_change_tuple {
 	u8 variable[];
 } __packed;
 
+/*
+ * Context information carried in SMD BSS Transition (refer IEEE P802.11bn/D2.0,
+ * Aug 2026, subclause 37.16.9.
+ */
+#define IEEE80211_SMD_CTX_NUM_VALID_CTX    8
+
+#define IEEE80211_SMD_CTX_VALID_DL_SN      0
+#define IEEE80211_SMD_CTX_VALID_UL_SN      1
+#define IEEE80211_SMD_CTX_VALID_PN         2
+#define IEEE80211_SMD_CTX_VALID_BA_PARAMS  3
+/* Positions 4 to 7 are reserved */
+
+/*
+ * Data TIDs transported in the context, IEEE P802.11bn/D2.0, Aug 2026,
+ * subclause 9.4.2.364.
+ */
+#define IEEE80211_SMD_CTX_NUM_TIDS 8
+
+#define IEEE80211_SMD_CTX_MAX_PN_LEN 16
+
+/**
+ * struct ieee80211_smd_ctx_ba - BlockAck parameters for DL and UL
+ *
+ * @amsdu_supported: Peer's capability to support A-MSDU within A-MPDU.
+ * @ba_policy: BlockAck policy (0 = delayed BlockAck, 1 = immediate BlockAck)
+ * @buffer_size: Reorder buffer size from ADDBA Request (10-bit, max 1023)
+ * @timeout: BlockAck session timeout
+ * @ext_no_frag: ADDBA Extension fragmentation support
+ * @extfrag_level: ADDBA Extension HE fragmentation level
+ * @ext_buffer_size: ADDBA Extension buffer size; combined with @buffer_size as
+ *	(@ext_buffer_size << 10 | @buffer_size) to get the full reorder
+ *	buffer size
+ */
+struct ieee80211_smd_ctx_ba {
+	bool amsdu_supported;
+	u8 ba_policy;
+	u16 buffer_size;
+	u16 timeout;
+	bool ext_no_frag;
+	u8 extfrag_level;
+	u16 ext_buffer_size;
+};
+
+/**
+ * struct ieee80211_smd_ctx - IEEE 802.11bn SMD Roaming Context (refer
+ *	IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.9)
+ *
+ * @valid_ctx_bmap: Bitmap indicating which context fields are valid;
+ *	bit positions defined by IEEE80211_SMD_CTX_VALID_* constants
+ * @pn_len: Length of PN in bytes; varies by cipher type
+ *	(e.g. CCMP (6), GCMP-256 (16))
+ * @dl: Down-link context data
+ * @dl.valid_tid_bmap: valid DL TIDs for which context is present
+ * @dl.sn: DL SN per-TID to be assigned next
+ * @dl.pn: DL PN to be assigned next
+ * @dl.ba: DL BlockAck parameters per-TID for the BlockAck session
+ * @ul: Up-link context data
+ * @ul.valid_tid_bmap: valid UL TIDs for which context is present
+ * @ul.sn: UL SN per-TID to be checked next
+ * @ul.pn: UL PN per-TID to be checked next
+ * @ul.ba: UL BlockAck parameters per-TID for the BlockAck session
+ * @drv_ctx_size: Number of valid bytes in @drv_ctx.
+ * @drv_ctx: Variable-sized array of driver-specific context, counted by
+ *	@drv_ctx_size. Opaque to the wireless core; interpreted by drivers.
+ */
+struct ieee80211_smd_ctx {
+	DECLARE_BITMAP(valid_ctx_bmap, IEEE80211_SMD_CTX_NUM_VALID_CTX);
+	u8 pn_len;
+
+	struct {
+		DECLARE_BITMAP(valid_tid_bmap, IEEE80211_SMD_CTX_NUM_TIDS);
+		u16 sn[IEEE80211_SMD_CTX_NUM_TIDS];
+		u8 pn[IEEE80211_SMD_CTX_MAX_PN_LEN];
+		struct ieee80211_smd_ctx_ba ba[IEEE80211_SMD_CTX_NUM_TIDS];
+	} dl;
+	struct {
+		DECLARE_BITMAP(valid_tid_bmap, IEEE80211_SMD_CTX_NUM_TIDS);
+		u16 sn[IEEE80211_SMD_CTX_NUM_TIDS];
+		u8 pn[IEEE80211_SMD_CTX_NUM_TIDS][IEEE80211_SMD_CTX_MAX_PN_LEN];
+		struct ieee80211_smd_ctx_ba ba[IEEE80211_SMD_CTX_NUM_TIDS];
+	} ul;
+
+	size_t drv_ctx_size;
+	u8 drv_ctx[] ____cacheline_aligned __counted_by(drv_ctx_size);
+};
+
 static inline int
 ieee80211_uhr_mode_change_tuple_size(const struct ieee80211_uhr_mode_change_tuple *tuple)
 {

-- 
2.34.1

