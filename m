Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793952006;
	b=I+ltZsHUVYx9/ecOKIOBGNsRnm/Zxm63aOcbnT43K6vucnhPuuykkz3YN/td0en65lQ0
	 jfLJDyP5AhPUG7uQrEbQU0OmjzN2gNH10rF3ehIAoFh5B0Dc3+RLQzt2hc55l8KJvk79s
	 PM9U8jhxx6st2yHNYR/qjhgvLlsXuG4B4J0Q8pHPzypcJXF7eMznGaRcAYdzWKCY0jiHw
	 QLJEduXO84ikcWLZIM+tAb4XJWMvvYVEQ+NJGbw3DFKtipQs4STLHSJaTWXlfP/dSpJrh
	 6kssPa5sZd/inIWIkbdRyXBczWByt4SI2TY0t0Q5O04bOiU3E4PSdVzz4tnh9PJQ9zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793952006;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=qMOncR0UoevAZucFiHIuWkcdcZlD/liB3Dpz3ZsMqk0=;
	b=ikluNFdyftAhMwDia56C+zh9rCz/WPEzAyWuRozBgKn1sDTr+wLK6FBV7B/oWNy7ExPW
	 PQX4f/VDebEeCesgtnTiPPhkj05Dgbe1oVqUrwM8BEWlHwVbhn45d8fO8LDfoXPAbxWwg
	 ZrUOdXtZgXlidaT/Vm8t2Gbtsp/AH38ui5+F3gwrN9NlftA0jE5NBkxskosVu0sydbjPq
	 3hNU8czw8NfPFVEx6GkmvegY+v9kJxgsKlaOp+8p0VE934x7ZAFlSEXJeoPyG/3hQck2z
	 7Qdq6ymPmzLON7n/6bDz2xKXmNOFiS2GLAHMEdPNBiv0CigAtB8QIAd7rqGAwCcgC3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=N2aR6UFK;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=My4voQ4G;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A126060A2600
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:00:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A126060A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=N2aR6UFK;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=My4voQ4G
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RUTq2730753
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 08:00:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qMOncR0UoevAZucFiHIuWkcdcZlD/liB3Dpz3ZsMqk0=; b=N2aR6UFKBc8gvoh+
	IJ+t5DhcWhL1LIJddtns1E+aKbc1YK3ZglbkUMFGWlSWF1yN2iBwl5exy2i8yoYd
	NhC52zY+lIGhLm5Ao06l/nJuZVUHu/7J3FdSHX/6ViWarvU9JY324JSIy3g2fXWj
	8mtPZcfOEAabcMdYs6lAzecEPH9eSpsgnybbXbHNQYWQ9YPAgwmuEjx/FfrQLT39
	S1T+e1zi7ccW4tew3Hgv4cZMSy6hEH9aLJLDT7272AKSDjNW0m2HLujJRaOSkpis
	St4/74H0PuCVxVgCwQgG0lEb0v8C6VI99FUZ1JE1Knn509GpH2sL7OCdo+2Rq1sP
	I6sV1A==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3p9hpmk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 08:00:04 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b08364cdc7so505183a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 00:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793952003; x=1794556803; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qMOncR0UoevAZucFiHIuWkcdcZlD/liB3Dpz3ZsMqk0=;
        b=My4voQ4GpPNVXl0ivdl/HytgYBs0xGQ+CD2rjXO6ZJ++sfqPS5HwO+X9nEYoSy23SR
         eI/N8mQzs/LMYNOCR99y1zghKwKhxmtAwCNzY3nEKT97r/MIDZzR0mc+sm06IuIniMEo
         LBpVbUoi3ULlNS9lVR2msJagJRBW+U6ONMWZmvWwZmhXvaCj0v1fMPTmy6d2zY965h/h
         ay+VdDJNlQp0Y6H9DAkYQbNaQVmil5r7cs/s8bY9u8MmDQ5UCMVJMpUb01S0tw5NhBJ3
         LO4/ho5VhidcDcobEnD7+QgA4cW9pC1OCC4JbHyZSZ7kCDNG9gxFB3mfYpcCG90aLBJ6
         gPVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793952003; x=1794556803;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qMOncR0UoevAZucFiHIuWkcdcZlD/liB3Dpz3ZsMqk0=;
        b=XsLu91DDr/DtCVwPfRG1p2o5pPX8qV95HM6QuH6t6+GjNmZO/Dojx263FSMkJEtH57
         KV6LHnfG+pC32nSle5JSZbob/2NW1AV/e+oq+V9YZdk6BMWRMqmZ0KKsmAZYqmvl5x2G
         dWHKVpRrtoRcmGdoKLmZBLEYqhBRVCvEDTFGz2CFFpLUUu3dswXiLZ2QCRIJ41/HSxlj
         PqMWN33sClIGragPNWhnc5YhBsX0w/MYJAG3Tvo8yGQRvVrvsZHofTlKHBPDsNwUQ6kW
         dHtiBQCgrr5NtFrAfnvOBCnH/gSRKShlQcqFZMFbsUl4B2pfqPtEoQikzNwAHg9qNI7i
         A4WQ==
X-Gm-Message-State: APuU4Z+MKx8c2UYIS2LEE1Z/tg4pplRHYPFsLTt0nHcW3Wblx+8wGCpV
	IKoa5hg8TQK0HmXH/6mVgnPIB7F5Q3CKnXh9kdtK7lBP3OFk0O1dsQSjX/Glas6HMAR7MOd1aIe
	R+ZeWR8uhOscSKbSe6NkowOevGalhuT6Upwdymud1a69gk3DRkee3TS/x5FaAYHE3idYc
X-Gm-Gg: AYBFou0rE4nOnGWYuCSkuFKqjbiUT1683Ox4ZsgneAhtt90Cm/w4l/MFr6o4zTimMfE
	I24XDkYyWRvBxnM3lWKWM/+aD4c6YHN7AHBxtX5pVlwPEMAtiik66n/9AC8kFF/29z6Znnri6bJ
	y3hPxpLdgECWmM9QLsJR9HG8bSKmZzCSCLdHJGvwv3CKr8weXGfTe1d4BJHvnKCNy5BaXSFFdpq
	c5ywCrX/Klm2P3riZaNJwcgoEAuZum4Pyb1ksM/ORLH8PkrfiytNCYovrAgXAzKKo2H2YSsSXl1
	5V/tF2JSK2s2tp19suSxMNvTpeq2N3gs587ZLO8aFgUW4y26Ni846CVdAp0yrzK5+AGk8RWqZxT
	D9/dgLpx2EQlXypTop2ZuPY6keib9bZx9nQKSj1CtuncF2D1WNhi80Ub9i/IhAqTtEb8BRbZoxM
	bff6S9PBWaGFeVlLuQHGuLLg/dihLgwVxMGR5v2/+QlXZR94hIvw/VNOSW/8HCvmJxfNkWVGI=
X-Received: by 2002:a17:90b:1802:b0:3ac:80dc:f407 with SMTP id 98e67ed59e1d1-3b0db71871fmr1620478a91.60.1793952003349;
        Fri, 06 Nov 2026 00:00:03 -0800 (PST)
X-Received: by 2002:a17:90b:1802:b0:3ac:80dc:f407 with SMTP id 98e67ed59e1d1-3b0db71871fmr1620453a91.60.1793952002799;
        Fri, 06 Nov 2026 00:00:02 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.06.00.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 00:00:02 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:53 +0530
Subject: [PATCH wireless-next v4 16/21] wifi: mac80211: send BlockAck
 policy in AMPDU action
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
Message-Id: <20261106-smd-v4-16-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: J-Mon8XpB2QdxoGlOgu-wp1VKl0h0EMb
X-Proofpoint-GUID: J-Mon8XpB2QdxoGlOgu-wp1VKl0h0EMb
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX/AVD8W2lS3/Z
 G9xvlGLza9Sh1ecRvh13yTYXOKaNTTYt44Jo5V68GosWltb2FObF3joEdWlAMztREs0UZc0Gcn9
 jLywNTvZUp2e90St0dHpslzDwTuoMS4=
X-Authority-Analysis: v=2.4 cv=XvNvqlF9 c=1 sm=1 tr=0 ts=6aed8904 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=nliDdBWBufQ-nTcFh1oA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX/hrrD1JryB5W
 Wi20Blj+kTTGFzBD7Hsdhu6J3fndT6inHl8KjTF0nUtMb2StE3qa9lDuq7vE7xfGmBf6oc4+f/0
 cyf20LwUhc/lUFKz5ksiisqmqKWNaqfDT5EGXa2Kf7JwEesrq3AdAQvENxq2KeiVCOgVqpHio4t
 n+k9Axn7pV2fqbcn9ktXcLEMEpgmIdhiXE2wyjLBJKamnrORJ8sJN9zvpAdFdCxQ8F5RuKBqQwc
 w3uxyUAoxVfUfO+mCv4ZyS5n4QA2vuVIJ36MbRG6WR03t2QWG9RJ2HQ2sxzTcYcXAB7EYv2mpdT
 3SZ985FM1GOQbLTMZQqIN9P+O4kzyAkPCbIxInrOGrMVi3jexOhpLKc5FSAxZ9+4Bum8uXD6Z+2
 ndRR7WX6PJzRehaSSfBqV2qeIClaH2ctiL26P4LsVV4pOLz7OyLqG25GbmYMKFRcCpW9WHIEaso
 bOzlzheRWHjkjJetJzA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

While sending AMPDU action hints to drivers, mac80211 does not include
the BlockAck policy extracted from ADDBA frames. Drivers may require the
complete set of BlockAck negotiation parameters for certain use cases,
such as SMD BSS Transition, where the complete BlockAck context needs to
be transported as part of the transition.

Include the BlockAck policy as well in AMPDU action so that drivers have
the required information about the negotiation. Since the policy is
extracted from the received ADDBA Request, it is valid only for
IEEE80211_AMPDU_RX_START.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/mac80211.h | 15 +++++++++++++++
 net/mac80211/agg-rx.c  |  1 +
 net/mac80211/trace.h   |  8 +++++---
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 96acdb9ae8f0..2a595126b1e3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3979,6 +3979,19 @@ enum ieee80211_ampdu_mlme_action {
 #define IEEE80211_AMPDU_TX_START_IMMEDIATE 1
 #define IEEE80211_AMPDU_TX_START_DELAY_ADDBA 2
 
+/**
+ * enum ieee80211_ba_policy - BlockAck Policy
+ *
+ * @IEEE80211_BLOCKACK_DELAYED: Block ACK sent to the BAR sender in next TXOP
+ * @IEEE80211_BLOCKACK_IMMEDIATE: Block ACK sent to the BAR sender immediately
+ *
+ * This field is valid only for %IEEE80211_AMPDU_RX_START.
+ */
+enum ieee80211_ba_policy {
+	IEEE80211_BLOCKACK_DELAYED,
+	IEEE80211_BLOCKACK_IMMEDIATE,
+};
+
 /**
  * struct ieee80211_ampdu_params - AMPDU action parameters
  *
@@ -3991,6 +4004,7 @@ enum ieee80211_ampdu_mlme_action {
  * @buf_size: reorder buffer size  (number of subframes). Valid only when the
  *	action is set to %IEEE80211_AMPDU_RX_START or
  *	%IEEE80211_AMPDU_TX_OPERATIONAL
+ * @policy: BlockAck policy of type &enum ieee80211_ba_policy
  * @amsdu: indicates the peer's ability to receive A-MSDU within A-MPDU.
  *	valid when the action is set to %IEEE80211_AMPDU_TX_OPERATIONAL
  * @timeout: BA session timeout. Valid only when the action is set to
@@ -4002,6 +4016,7 @@ struct ieee80211_ampdu_params {
 	u16 tid;
 	u16 ssn;
 	u16 buf_size;
+	enum ieee80211_ba_policy policy;
 	bool amsdu;
 	u16 timeout;
 };
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 01d6703767c6..d08b4b5b33ff 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -289,6 +289,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 		.amsdu = false,
 		.timeout = timeout,
 		.ssn = start_seq_num,
+		.policy = ba_policy,
 	};
 	int i, ret = -EOPNOTSUPP;
 	u16 status = WLAN_STATUS_REQUEST_DECLINED;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 83b06e9f72ac..1a45ed66242c 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -116,6 +116,7 @@
 				__field(u16, ssn)					\
 				__field(u16, buf_size)					\
 				__field(bool, amsdu)					\
+				__field(u8, policy)					\
 				__field(u16, timeout)					\
 				__field(u16, action)
 #define AMPDU_ACTION_ASSIGN	STA_NAMED_ASSIGN(params->sta);				\
@@ -123,12 +124,13 @@
 				__entry->ssn = params->ssn;				\
 				__entry->buf_size = params->buf_size;			\
 				__entry->amsdu = params->amsdu;				\
+				__entry->policy = params->policy;			\
 				__entry->timeout = params->timeout;			\
 				__entry->action = params->action;
-#define AMPDU_ACTION_PR_FMT	STA_PR_FMT " tid %d, ssn %d, buf_size %u, amsdu %d, timeout %d action %d"
+#define AMPDU_ACTION_PR_FMT	STA_PR_FMT " tid %d, ssn %d, buf_size %u, amsdu %d, policy=%u, timeout %d action %d"
 #define AMPDU_ACTION_PR_ARG	STA_PR_ARG, __entry->tid, __entry->ssn,			\
-				__entry->buf_size, __entry->amsdu, __entry->timeout,	\
-				__entry->action
+				__entry->buf_size, __entry->amsdu, __entry->policy,	\
+				__entry->timeout, __entry->action
 
 /*
  * Tracing for driver callbacks.

-- 
2.34.1

