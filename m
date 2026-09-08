Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911D0598C11
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887445; cv=none; b=MMrL36dxcvHQss/lmuG2tqux0nhLEDYoAe6tqvvLwjg0gchKTDZE5acnFi9hhpmneZR+CiErnAX0GjQpv8K5yWBavQ/hSX6H+OeDYkcXMQYMsXAMDKsmxUc48l+94BevFf7VkOPgqyPcitiWw+IuTE76bSFJwlsWX3sXoF4IVIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887445; c=relaxed/simple;
	bh=86w9hu+WJ1z3hy9Or+mlRGtKjgaxVht0KJsSe0k3fEg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n4Jnnz/OSdSPUwfm7x7UmbXhLnsGZqQ97RaqhmsRCeKldjXi2xatympdjA4fIpUAx7rRnOKhw0BXYudzf3iL5HqjD+Io/4aCckNmy6rZA06/W+CxbaNZM7CxsQHrKsDwKqxiLivq37N3sw5F/kKumvI0lsH4X2Ncw0Qju+jtq/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lDmBDhD3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ijg5W9PL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lDmBDhD3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ijg5W9PL"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Fdi3I3757633
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 17:10:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gofo4g5PMnVYPHJH99bL1SwGrtDr+P/qsI5BTGGqohw=; b=lDmBDhD3x1HVS0Ea
	WZzEzbmWoiNAAEd5vM2fLL603eQUaD4k1DVPUtcjwUgRn9afPjQZl1tZ4D90TXJm
	Q4JdEGhBaYqLy62kcdkUvlFNkuZP0Snhp6Fa3a8h54Qz26mpEKP/NLms28/XiOgk
	yEcHVcvu/veKn4/2KPYmNQgvMWc0iSvh/OfbhHlQwcoo8esRqah5F9QeekzlCqdi
	UmhK4aoGhf9vyzWg7JcPbPJXq8x/bfJV/q5UXtSgvypGxEH4j1lombyZIbTsyS3O
	f3n3ZmLvfp9UqnaPz+N4PlEmGt6c2V4Th6pXutIWwxL4CBGmfL79tWygPqvIAaH5
	W50shQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjcv7jy40-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:10:42 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc489e7a701so2106072a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788887441; x=1789492241; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gofo4g5PMnVYPHJH99bL1SwGrtDr+P/qsI5BTGGqohw=;
        b=Ijg5W9PLW1LdS9M4s9DaQhIu+91t5XluqW24cLlsihLVVbT0YBkgTounCu1b7VROlF
         r5vxtwz7KLDbCOt7BTN1zY0XnV6UZgnQywKkgVOURw6Kiflr2uRPNgAMLYZ+vA1lj66c
         ZPMvODOL+txQ/XXvvvxIyKmRruuCua59o3w5a9JLYFHTWqBg50xW0nW6f4wC/Q3gpHmp
         OpUvVqAPOR5SvzxWN/5Z3Gswh2CNfhWtxsk0pQkb6bDaJUvX3SwBXWldlvWrs+6sHDGu
         4zuTKazY0J5vZi9YbuWbZBZfOPYGcaUaAyvSGv6WV30kje2jbyBHQu136QpdUEwSaeOR
         RRsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887441; x=1789492241;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gofo4g5PMnVYPHJH99bL1SwGrtDr+P/qsI5BTGGqohw=;
        b=e7Fibr4gnv5Rzu/bk3pQ4t7q0c1WPyPndK5IobhtVQE/n+xMPQWwWeZUG/I+yXcaQI
         26d0mt4MtIfBnX0GaYkNGXO7eWnWv2WYPF4Z91oWuwHv31xdY70dvqf6seKPhLaFSe8H
         9XdtqEOibmL5WA80vEJJEX4haNr3EOr4DbtHINZfBp+5bVDtKtvsX9W9ybA20pvWIzky
         EitE7zcg/RUgxiZ+nA9qrrCWx3C2R49+zNj6/YFoUbo7P/OQir09vF5gQ5mkKIPqwb+H
         AdemTLbudwcCztEyWeZsbxNNd/S7p6ysKS45CIRccrVRPwfATP11EtiwtCqWxkazOBs/
         w7Pw==
X-Forwarded-Encrypted: i=1; AKwUvBwRUX7TCTfGEd1ToGjM8gc+Bsi1RHATKLd5/EP0eE74vm7SaM7csUmh8t1NnjkfUmtz+hPi2NtbrKWJOeFTXg==@vger.kernel.org
X-Gm-Message-State: AFuF++mKwO/0Mc+42m1B9ZqkGwHcM7GA7zgu2sUWJM9m6Ih8phHKgbRQ
	p6R2i6xll3d7vEnKMNnmwVtxAz0n6HcoLVav41njtijFTcvjlWM4Au3i+SHPptBwtCDnfFOrpsp
	X++2if6tbHL0nFCgIdqqCjV7z/XEgn+ca04ACjMSWOmNP7SKN4EELpfAlwCnbpEP4T0YU
X-Gm-Gg: AYBFou3IqHAhMq4ZUt/+EQ07S5udX9byRmGlxBRjQG4yZufHKVBQSiuj/rm/tEuxYYv
	w1glQ3vCe4/lT3Ot100n9zHfEgJvos+ieSbbZ/ZwnJTLoXaM+Anx2mprgd7kjsMAJI6zOvuVrao
	SGDH0tFH7lJXfFqVtLcE4LFamIYnhPcrFsihtdPADnKRPdWQc9aP1Q/AJYsC9yuW9w1RdUiuIX4
	ihETbjsXwnaG3r+xxm4ExhqYyc1H+PfZQ6c+dzC+JKN6JvHr6NnMfbyZHwzCUBILlPiZCqhL3/u
	qmaDyP1G4X5FBTaQf3gRfGasPGOjXrGEI21cqCfLBAOoLc4cWtCgtESPDkHjB5SGgmE7xw734j8
	ZqT/IPh02xV1IaSN2pisa6SrINXrLIVyVAd46wX6EmlhJcO5hp8tURdLkgLBz0FYSxoslozwFjg
	nk55v4Rw62EcBMr7QTetpm9Q==
X-Received: by 2002:a05:6a21:2983:b0:3cc:8f53:26c0 with SMTP id adf61e73a8af0-3da3a03ccf1mr51872762637.17.1788887441220;
        Tue, 08 Sep 2026 10:10:41 -0700 (PDT)
X-Received: by 2002:a05:6a21:2983:b0:3cc:8f53:26c0 with SMTP id adf61e73a8af0-3da3a03ccf1mr51872684637.17.1788887440767;
        Tue, 08 Sep 2026 10:10:40 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm31773675eec.4.2026.09.08.10.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:10:38 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
To: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH RESEND wireless-next 09/18] wifi: mac80211: Send BlockAck policy in AMPDU action
Date: Tue,  8 Sep 2026 22:39:37 +0530
Message-Id: <20260908-smd-v1-9-9fd2d876a1fb@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.3
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=CMEamxrD c=1 sm=1 tr=0 ts=6aa04192 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=poGJry9enlaRV4ryzAsA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfXw9B9IfdUex6P
 0QgbMVi+KH9u/TO7yaWehYkaQGtr4R7juw0g5mVqghi8sqIi/dsnmbwfGP0VU9Zz00x5L0YEFE6
 VTaSn/00SXo+vNYnJpIXesnp6ZnVW68=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX9pj2L6/JFBit
 YktKWzyf+8Qr+QYRZMu54T+otv3SrkpN0o4GgVSQJQQbTqVgVwm3su3yPISTFIFEXXYFeADlcUx
 Lrtp/XrJExwSZCraIxV0Cnf3M/9UcSqCupzf5gR1MggtzDcrgNRIWzcW8w0rffWqlbgSe3AYg5Z
 Z+WKdxMK7eOedscyhpmVsUNuUMlE+VlmNzHfGKpdAQ+j7404ArczsDf1hhjnv6ydJeLGlvZIhq1
 /7GTfbEOpFXqw5me6cz/LFLdVtTAjyHRayiYzzz4U22LD3YclqOx2AVu1bYn6+DuJ30SvoV95Cz
 4JFEKv50vKXNqiRvlRM9zRKQ8zOWqRqMrQR4RRJxGsBLGmEcpAFCwLAK+2ixtxmVoOzRNBMNGDq
 DI9RawCENVfLy5n09c3m9E8g5ilTmnb2Mv3e2VgnWsUC8sF7hk4MGahwkHBfUK5LhJlkPNymYsI
 GQp6RsWI5skRow8d/fA==
X-Proofpoint-ORIG-GUID: 5p5fMNG2ZPXJpogAVA7bqipNS0W0U8qn
X-Proofpoint-GUID: 5p5fMNG2ZPXJpogAVA7bqipNS0W0U8qn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080185

While sending AMPDU action hints to wireless drivers, mac80211 does not
currently send the BlockAck policy extracted from ADDBA frames. Send the
BlockAck policy as well so that drivers have complete information about
the negotiation. Policy is valid only for IEEE80211_AMPDU_RX_START.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/mac80211.h | 15 +++++++++++++++
 net/mac80211/agg-rx.c  |  1 +
 net/mac80211/trace.h   |  8 +++++---
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9b5fa6d6281b..32b9b7cd1685 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3964,6 +3964,19 @@ enum ieee80211_ampdu_mlme_action {
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
@@ -3976,6 +3989,7 @@ enum ieee80211_ampdu_mlme_action {
  * @buf_size: reorder buffer size  (number of subframes). Valid only when the
  *	action is set to %IEEE80211_AMPDU_RX_START or
  *	%IEEE80211_AMPDU_TX_OPERATIONAL
+ * @policy: BlockAck policy of type &enum ieee80211_ba_policy
  * @amsdu: indicates the peer's ability to receive A-MSDU within A-MPDU.
  *	valid when the action is set to %IEEE80211_AMPDU_TX_OPERATIONAL
  * @timeout: BA session timeout. Valid only when the action is set to
@@ -3987,6 +4001,7 @@ struct ieee80211_ampdu_params {
 	u16 tid;
 	u16 ssn;
 	u16 buf_size;
+	enum ieee80211_ba_policy policy;
 	bool amsdu;
 	u16 timeout;
 };
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 9629e00069a1..2d67fd883146 100644
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
index 294a8a44a125..63838a6d5d07 100644
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

