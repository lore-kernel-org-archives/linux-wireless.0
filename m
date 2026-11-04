Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754665;
	b=qh1v3/iJUEjgUB+cRB2lWxDHJ6No4AvyvFz8r007Mv7XMFUUcLCmqLORpAohgBJSCH19
	 cag2x5GWI+nVNJkUJnLUtSbv8E1xY7NfKbGOdGgVL44xb4CJ9WKj0w99kouQ64Fv7OuaW
	 Qb5e4u4tHqG+KsrqEjlq65ZYTzwLxSSrQA+bU2zqcvuM5FFMrbZVf+TxxVRYxUosoc8Ka
	 yxRkumLN5KmIEgPNSyHQJM5ZMsNZ8/51dzB9T7Y3HwXYspuqHEytXZYCydKFTjHI2cftH
	 D9JWJ+HlshEOsJ1/rDhiMlsXXX4gS5xC0PVYgV3RGqdBqRCa9orfegr26JuZh9m4leQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754665;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=SscCVk8nxupD4V6Cfhds03G/OUwDOCK2+kQxVAgWW28=;
	b=Ob6oRyWjoQoqGhKybnSebYboxgbeGbe490WcKrsHCPWAjVDFh58Hv39lpultlj4SSMaJ
	 FVb32nXCnYlkGRBCQQ3Aq9oRxD8mv09nlp1/yHBt5ttbsxWx+eyrBOAfCk7viArH7W/GJ
	 QsTfVkFRHzHBgAuQmYpGC1oforDOjhAsMh/k4pdOFa/QyU9xNPSZ2Nez18vctH4+UR8aV
	 a0WQeBM3jjH75N6LUeGKqRVYIeJU6KBW/vVc3A6iKw3iEcZnv5aBX6XWVbOENa94zNwyw
	 NrgAW285x5SajFCIsRDheKbsa7L1UyXXx4BnntOci175DXC3F0QbkiBHQ3uEY8hY8Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Cd8Khx4q;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=GoRbKoco;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB91606A32E
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:10:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AB91606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Cd8Khx4q;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=GoRbKoco
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RPSt230670
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:10:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SscCVk8nxupD4V6Cfhds03G/OUwDOCK2+kQxVAgWW28=; b=Cd8Khx4qNrWJpfG5
	HiXrDUPoMsmGnfls6Xiw5qX/mM2QRKgvoIZiSEkeQw1gHBHlQSodEY2RqvU6SKL1
	yKx42ZkHG3vShctw9cDp9wbt1J7VyDhO3R4XZqJYL0b2meAVlYvVGA281MTfq7H0
	H5M+AjAY+rCsgkTZpuVCOUOkSw6ZopUP5yJ5Ih/OfBmHXmDI0ReQToo7DnXTWWak
	XrnX0F9zCB6pbLzc8c/32J2ZpM4Ho2IP+KKSpWZNjtMQaV3oaumuTaWjVxHklUvp
	jZd6Ooe/tGUb2+2pL2lRK2orVl2tueiZ+nkc1pfjOkv4URN165u2nXFDQMZ89Lfe
	LBzg+Q==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqhypjdwb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:10:57 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33713e5e6daso157193eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754656; x=1794359456; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SscCVk8nxupD4V6Cfhds03G/OUwDOCK2+kQxVAgWW28=;
        b=GoRbKocoieElckuiEqT7leql2h9ZjEllQy+3P2aXrVVZ1rSGK2blkWoXn/zZJ9oMpB
         /z5NkuZnW4A17NyRFXIJzqmjxQSGb8qONYszW822j32HX+RXWSAV/kzvW1DRFrYJjC58
         5HFQT0gsqerMJQhzlUHbxmm2Vz2Y5Turj5senwcaUa8sVGCTuOT3ymwHpZx2yzVDpqIY
         2+PfzHWP+/RH2cmfpY5TqKZkCZ35Q4HlNiSmOvJy+3hxM8sAUnIiVECIoHm3owLQU01P
         JBgwu78RKdTC/oBnqvfwwR5HS6ulMlkS+qHuRg1szQmMkbqJuJLZNWV3yzRlkwM93T4v
         D8qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754656; x=1794359456;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SscCVk8nxupD4V6Cfhds03G/OUwDOCK2+kQxVAgWW28=;
        b=X4BQP8nPVtyHOjVMBPcugB+J4QLOmQh6/pdQVBT7WG1xQOabpckpfihw+smgi9U7yN
         xnMxXaXv3mSk1YqaJ44MCNkjDTAutyN7tvGNhfPhruaNnPfxnSbODQAvJ8uBL4VIvCoh
         c+a2us2FIBl/PNoqCmxBEijKV0TNv2h1NLhj6E5cpNyYyeydsnTSPKPc0uc3qy8DNM1s
         CvlGFeotubTjH5s2IAnOC8pyXVW2ecs6FlxJokWyEADW4mE9u3vH64iUxYTTJ7kN9Utb
         L0V+dxSeXfo8GL1gl+r0+g7pUDecB4zncF+nt0NLOQU8I0Sm3nK+2lYAi4GKRqiqHdm7
         uXNA==
X-Forwarded-Encrypted: i=1; AKwUvBybtnnHq7374sFwZ6Cnac79NU4m9khAX3PghRnD409EJRIMF+uyFtvJ1hWxI0chuKeNrppCHwuzHPjICWh59g==@vger.kernel.org
X-Gm-Message-State: APuU4Z9RSVZIujgqFnYlawjTrFvZXkQa/iwGh0yZ4Ypdnk+oScABpWl8
	XkXcsBMR2QULl6MeV2ycCGr2Y2k5hohic9o6DTCscn/WfxtaaLgp5iJfw3rOiwENOPboSJD+Evp
	IO9a/l47+hzWEhZmVwLSIwMKynWFRfbU7hAcaQedi4vUNf2Yc5k3K0IZcUHaB05slM3u0cg==
X-Gm-Gg: AYBFou2mS0aTv3EsUY4fXBghT0afGZZ71J+EPYRdygrTqrVqdBISudUHmKaZtnIUUlu
	ysgH9LLg+R7Wry+Jo3E55Z0ffX1QztaCjk6GNOzinaJ/AKTMkxCOhcDM76pCnHIm7moztx7b24u
	gKoXVX5ryQQShdgc6mHSJibef6QmeGtLjRpG7y5ieVRlBsRGiiEl5NL50dzz8G3SoydizBOt1Ne
	CFGSSN5VgqSXIP16/oLOj6p3kGYCMzfskRx32pW0raLTnyQa26W1ou9dKHhM1CXYhHxkPEFC+yi
	+EjIcAWqeQD02Cn9xyVgzqZGiRpixseZMn/nudVQm1Q3AWKQ9E2YqaUwcioTOQ5R/5ttnUOB/2W
	MkMS8euwGKs1INBfG56F8IjHPKqQkm2ae/OIoH/K5BC8cR/kDT0XqWCxASB8uxcyP3/39kdltnU
	ANs2X2FQqdkoYlxK1446zXugU7bp7TIlqTNPgG
X-Received: by 2002:a05:693c:630c:b0:36c:a360:9c42 with SMTP id 5a478bee46e88-36ca360cda7mr1486107eec.31.1793754656141;
        Tue, 03 Nov 2026 17:10:56 -0800 (PST)
X-Received: by 2002:a05:693c:630c:b0:36c:a360:9c42 with SMTP id 5a478bee46e88-36ca360cda7mr1486068eec.31.1793754655599;
        Tue, 03 Nov 2026 17:10:55 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:55 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 17:10:52 -0800
Subject: [PATCH ath-next v3 09/13] wifi: ath12k: ng: add REO queue
 descriptor helpers
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-reo-cmd-b4-posting-v3-9-861adf04b516@oss.qualcomm.com>
References: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
In-Reply-To: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Ripan Deuri <quic_rdeuri@quicinc.com>,
        Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        ath12k-review@oss.qualcomm.com
Cc: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX2YjK98iDLfMa
 Bc2FmDrQ7iGDInfDlP5BqTjJWpVEXdwZnuPpEpDUk3bkkanNEVTcFzdfrBqn2UJxcbGjBBLjq8p
 SJfF9QxdnyOUAMTheF9rDuLU1cfq1LE=
X-Proofpoint-ORIG-GUID: nQ1WuERUvMpC2myGht0LRF38xt_atR3Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX07L3c5Oga+vR
 vP8uNSIMcg3dPiHUi+k4R2XDlROC5u8i1R/0V9HOAsEwgYHt0CLqKC82aXZlAd3ChZdLcR4TNPi
 p8bPPbcXOJzEXhvrbGEFTGL16jgIZDIqm7SqGNRNpff9mM3RlRYsxvMUJyn0dmcx7NWkTbmxgUw
 lrYRiuqTrLdbjFQ+r4GBM+ualphJsh/ZJXtJBOWdctaiQvH6QG/VhHUCs0fXnw+HDkPr7NirSOD
 uZIz3XEJT8tWTno4lDExxUpTUNvrp0+c5hbwdfH/l5r9rbJqip4fy0otUmt3Ad4jhBpJGivqPkk
 ho0gLUni6qA9Y79DlWVEPemixl1tJmEGSOnJOnY7xvfkNSWYpno7h15DjzowmzzydXH1MVyvo/m
 GrMO6Dsd6uXABc/g9DvTFmgyU8lSBb+D09RTxgTPztGQfWD7o0fdC8I5iWhKqLCKSMeG4/nnsH8
 yLHcttzEpmcEyO6QpqA==
X-Proofpoint-GUID: nQ1WuERUvMpC2myGht0LRF38xt_atR3Z
X-Authority-Analysis: v=2.4 cv=T94Z3PKQ c=1 sm=1 tr=0 ts=6aea8621 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=kPHT7MsD_7d9QQ_0F_YA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040004

Wi-Fi 8 RX TID setup needs host-created REO queue descriptors so the
common datapath can program per-TID reorder state without relying on the
Wi-Fi 7 descriptor layout.

Add helpers to size, initialize, and release Wi-Fi 8 REO queue
descriptors. Keep non-QoS queues simple and allocate extension
descriptors only for QoS TIDs that can use a larger reorder window.

Tested-on: Compilation only, M=drivers/net/wireless/ath/ath12k
Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h |  98 +++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c   | 106 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h   |  15 ++++
 3 files changed, 219 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h b/drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h
index e2947dd112ce..a7db304a197c 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h
@@ -1108,10 +1108,22 @@ struct hal_uniform_tqm_cmd_hdr {
 #define HAL_TQM_MSDU_RBM_OVERRIDE			GENMASK(23, 20)
 #define HAL_TQM_MSDU_RESERVED_4				GENMASK(31, 24)
 
+#define HAL_DESC_REO_OWNED		4
+#define HAL_DESC_REO_QUEUE_DESC		8
+#define HAL_DESC_REO_QUEUE_EXT_DESC	10
+
+#define HAL_DESC_HDR_INFO0_OWNER	GENMASK(3, 0)
+#define HAL_DESC_HDR_INFO0_BUF_TYPE	GENMASK(7, 4)
+#define HAL_DESC_HDR_INFO0_DBG_RESERVED	GENMASK(31, 8)
+
 struct hal_desc_header {
 	__le32 info0;
 } __packed;
 
+struct hal_rx_mpdu_link_ptr {
+	struct ath12k_buffer_addr addr_info;
+} __packed;
+
 /* Per-MSDU entry within a Wi-Fi 8 link descriptor. */
 struct hal_rx_msdu_details {
 	struct ath12k_buffer_addr buf_addr_info;
@@ -1596,6 +1608,92 @@ struct hal_tqm2sw_completion_ring {
 	__le32 info4;
 } __packed;
 
+struct hal_rx_reo_queue_ext {
+	struct hal_desc_header desc_hdr;
+	__le32 rsvd;
+	struct hal_rx_mpdu_link_ptr mpdu_link[31];
+} __packed;
+
+#define HAL_RX_REO_QUEUE_INFO0_VLD					BIT(0)
+#define HAL_RX_REO_QUEUE_INFO0_ASSOCIATED_LINK_DESCRIPTOR_COUNTER	GENMASK(2, 1)
+#define HAL_RX_REO_QUEUE_INFO0_LINK_LIST_TIMER_IDX			GENMASK(8, 5)
+#define HAL_RX_REO_QUEUE_INFO0_RTY					BIT(10)
+#define HAL_RX_REO_QUEUE_INFO0_BA_WINDOW_SIZE				GENMASK(22, 13)
+#define HAL_RX_REO_QUEUE_INFO0_PN_CHECK_NEEDED				BIT(23)
+#define HAL_RX_REO_QUEUE_INFO0_PN_SIZE					GENMASK(28, 27)
+#define HAL_RX_REO_QUEUE_INFO0_IGNORE_AMPDU_FLAG			BIT(29)
+
+#define HAL_RX_REO_QUEUE_INFO1_SVLD					BIT(0)
+#define HAL_RX_REO_QUEUE_INFO1_SSN					GENMASK(12, 1)
+
+#define HAL_RX_REO_QUEUE_INFO2_STATS_ID					GENMASK(10, 0)
+
+struct hal_rx_reo_queue {
+	struct hal_desc_header desc_hdr;
+	__le16 receive_queue_number;
+	__le16 rsvd0;
+	__le32 info0;
+	__le16 info1;
+	__le16 rsvd1;
+	__le32 pn_31_0;
+	__le16 pn_47_32;
+	__le16 rsvd2;
+	__le32 rsvd3[2];
+	__le32 last_rx_enqueue_timestamp;
+	__le32 last_rx_dequeue_timestamp;
+	__le32 ptr_to_next_aging_queue_31_0;
+	__le32 rsvd4;
+	__le32 ptr_to_previous_aging_queue_31_0;
+	__le16 rsvd5;
+	__le16 info2;
+	__le32 rx_bitmap_31_0;
+	__le32 rx_bitmap_63_32;
+	__le32 rx_bitmap_95_64;
+	__le32 rx_bitmap_127_96;
+	__le32 rx_bitmap_159_128;
+	__le32 rx_bitmap_191_160;
+	__le32 rx_bitmap_223_192;
+	__le32 rx_bitmap_255_224;
+	__le32 rx_bitmap_287_256;
+	__le32 rsvd6;
+	__le16 rsvd7;
+	__le16 duplicate_count;
+	__le32 rsvd8;
+	__le32 mpdu_frames_processed_count;
+	__le32 msdu_frames_processed_count;
+	__le32 total_processed_byte_count;
+	__le16 rsvd9;
+	__le16 hole_count;
+	__le16 aging_drop_mpdu_count;
+	__le16 rsvd10;
+	__le32 sawf_dropped_msdu_frames_processed_cnt;
+	__le32 rx_bitmap_319_288;
+	__le32 rx_bitmap_351_320;
+	__le32 rx_bitmap_383_352;
+	__le32 rx_bitmap_415_384;
+	__le32 rx_bitmap_447_416;
+	__le32 rx_bitmap_479_448;
+	__le32 rx_bitmap_511_480;
+	__le32 rx_bitmap_543_512;
+	__le32 rx_bitmap_575_544;
+	__le32 rx_bitmap_607_576;
+	__le32 rx_bitmap_639_608;
+	__le32 rx_bitmap_671_640;
+	__le32 rx_bitmap_703_672;
+	__le32 rx_bitmap_735_704;
+	__le32 rx_bitmap_767_736;
+	__le32 rx_bitmap_799_768;
+	__le32 rx_bitmap_831_800;
+	__le32 rx_bitmap_863_832;
+	__le32 rx_bitmap_895_864;
+	__le32 rx_bitmap_927_896;
+	__le32 rx_bitmap_959_928;
+	__le32 rx_bitmap_991_960;
+	__le32 rx_bitmap_1023_992;
+	__le32 rsvd11[9];
+	struct hal_rx_reo_queue_ext ext_desc[];
+};
+
 #define HAL_TX_MSDU_EXT_INFO0_BUF_PTR_LO	GENMASK(31, 0)
 
 #define HAL_TX_MSDU_EXT_INFO1_BUF_PTR_HI	GENMASK(7, 0)
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
index 12a37c395bb0..ad00c182c2bd 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
@@ -9,6 +9,26 @@
 #include "hal_rx.h"
 #include "hal.h"
 
+static void ath12k_wifi8_hal_reo_set_desc_hdr(struct hal_desc_header *hdr,
+					      u8 owner, u8 buffer_type,
+					      u32 magic)
+{
+	hdr->info0 = le32_encode_bits(owner, HAL_DESC_HDR_INFO0_OWNER) |
+		     le32_encode_bits(buffer_type, HAL_DESC_HDR_INFO0_BUF_TYPE) |
+		     le32_encode_bits(magic, HAL_DESC_HDR_INFO0_DBG_RESERVED);
+}
+
+static u32 ath12k_wifi8_hal_reo_num_ext_desc(u32 ba_window_size)
+{
+	if (ba_window_size <= 217)
+		return 1;
+
+	if (ba_window_size <= 434)
+		return 2;
+
+	return REO_QUEUE_EXT_DESC_MAX;
+}
+
 static void ath12k_wifi8_reo_dest_ring_ctrl_setup(struct ath12k_base *ab,
 						  u32 start, u32 end, u32 reg_add)
 {
@@ -886,3 +906,89 @@ void ath12k_wifi8_hal_reo_update_rx_reo_queue_status(struct ath12k_base *ab,
 
 	ath12k_wifi8_hal_reo_status_hdr_parse(desc, status);
 }
+
+u32 ath12k_wifi8_hal_reo_qdesc_size(u32 ba_window_size, u8 tid)
+{
+	u32 num_ext_desc = ath12k_wifi8_hal_reo_num_ext_desc(ba_window_size);
+
+	if (tid != HAL_DESC_REO_NON_QOS_TID)
+		num_ext_desc = REO_QUEUE_EXT_DESC_MAX;
+
+	return sizeof(struct hal_rx_reo_queue) +
+	       num_ext_desc * sizeof(struct hal_rx_reo_queue_ext);
+}
+
+void ath12k_wifi8_hal_reo_qdesc_setup(struct hal_rx_reo_queue *qdesc,
+				      int tid, u32 ba_window_size,
+				      u32 start_seq, enum hal_pn_type type)
+{
+	static const u32 reo_queue_desc_magic[REO_QUEUE_EXT_DESC_MAX] = {
+		REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_1,
+		REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_2,
+		REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_3,
+		REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_4,
+		REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_5,
+	};
+	struct hal_rx_reo_queue_ext *ext_desc;
+	u32 num_ext_desc;
+	int i;
+
+	ath12k_wifi8_hal_reo_set_desc_hdr(&qdesc->desc_hdr,
+					  HAL_DESC_REO_OWNED,
+					  HAL_DESC_REO_QUEUE_DESC,
+					  REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_0);
+
+	qdesc->receive_queue_number = cpu_to_le16(tid);
+
+	qdesc->info0 =
+		le32_encode_bits(1, HAL_RX_REO_QUEUE_INFO0_VLD) |
+		le32_encode_bits(1, HAL_RX_REO_QUEUE_INFO0_ASSOCIATED_LINK_DESCRIPTOR_COUNTER) |
+		le32_encode_bits(ath12k_tid_to_ac(tid), HAL_RX_REO_QUEUE_INFO0_LINK_LIST_TIMER_IDX);
+
+	if (ba_window_size < 1)
+		ba_window_size = 1;
+
+	if (ba_window_size == 1 && tid != HAL_DESC_REO_NON_QOS_TID)
+		ba_window_size++;
+
+	if (ba_window_size == 1)
+		qdesc->info0 |= le32_encode_bits(1, HAL_RX_REO_QUEUE_INFO0_RTY);
+
+	qdesc->info0 |= le32_encode_bits(ba_window_size - 1,
+					 HAL_RX_REO_QUEUE_INFO0_BA_WINDOW_SIZE);
+
+	switch (type) {
+	case HAL_PN_TYPE_NONE:
+	case HAL_PN_TYPE_WAPI_EVEN:
+	case HAL_PN_TYPE_WAPI_UNEVEN:
+		break;
+	case HAL_PN_TYPE_WPA:
+		qdesc->info0 |=
+			le32_encode_bits(1, HAL_RX_REO_QUEUE_INFO0_PN_CHECK_NEEDED) |
+			le32_encode_bits(HAL_RX_REO_QUEUE_PN_SIZE_48,
+					 HAL_RX_REO_QUEUE_INFO0_PN_SIZE);
+		break;
+	}
+
+	qdesc->info0 |= le32_encode_bits(1,
+					 HAL_RX_REO_QUEUE_INFO0_IGNORE_AMPDU_FLAG);
+
+	qdesc->info1 = le16_encode_bits(0, HAL_RX_REO_QUEUE_INFO1_SVLD);
+
+	if (start_seq <= 0xfff)
+		qdesc->info1 = le16_encode_bits(start_seq,
+						HAL_RX_REO_QUEUE_INFO1_SSN);
+
+	if (tid == HAL_DESC_REO_NON_QOS_TID)
+		return;
+
+	ext_desc = qdesc->ext_desc;
+	num_ext_desc = REO_QUEUE_EXT_DESC_MAX;
+
+	memset(ext_desc, 0, num_ext_desc * sizeof(*ext_desc));
+	for (i = 0; i < num_ext_desc; i++)
+		ath12k_wifi8_hal_reo_set_desc_hdr(&ext_desc[i].desc_hdr,
+						  HAL_DESC_REO_OWNED,
+						  HAL_DESC_REO_QUEUE_EXT_DESC,
+						  reo_queue_desc_magic[i]);
+}
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
index 430b0f07563f..94732f82f614 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
@@ -7,6 +7,9 @@
 #ifndef ATH12K_HAL_RX_H
 #define ATH12K_HAL_RX_H
 
+#include "hal_desc.h"
+#include "hal.h"
+
 #define HAL_REO_CMD_FLG_NEED_STATUS		BIT(0)
 #define HAL_REO_CMD_FLG_STATS_CLEAR		BIT(1)
 #define HAL_REO_CMD_FLG_FLUSH_BLOCK_LATER	BIT(2)
@@ -84,6 +87,14 @@
 /* 8 buffers for max-size SG MPDU + 1 entry to confirm termination */
 #define HAL_REO_SG_TERMINATION_MIN_ENTRIES 9
 
+#define REO_QUEUE_EXT_DESC_MAX 5
+#define REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_0 0xDDBEEF
+#define REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_1 0xADBEEF
+#define REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_2 0xBDBEEF
+#define REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_3 0xCDBEEF
+#define REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_4 0xEDBEEF
+#define REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_5 0xFDBEEF
+
 struct ath12k_hal_rx_cmd_ring_param {
 	u32 mac_addr_31_0;
 	u32 mac_addr_47_32:16,
@@ -142,4 +153,8 @@ void ath12k_wifi8_hal_reo_desc_thresh_reached_status(struct ath12k_base *ab,
 void ath12k_wifi8_hal_reo_update_rx_reo_queue_status(struct ath12k_base *ab,
 						     struct hal_tlv_64_hdr *tlv,
 						     struct hal_reo_status *status);
+u32 ath12k_wifi8_hal_reo_qdesc_size(u32 ba_window_size, u8 tid);
+void ath12k_wifi8_hal_reo_qdesc_setup(struct hal_rx_reo_queue *qdesc,
+				      int tid, u32 ba_window_size,
+				      u32 start_seq, enum hal_pn_type type);
 #endif

-- 
2.43.0

