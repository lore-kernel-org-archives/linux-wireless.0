Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B941E3D5656
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217720; cv=none; b=doKA6ii8pdFfYRr8sJaQRD844GB08rtbcFwlQIerBWWs039vNaE/Kt+kCoTvkzY1n1rz7r+ZzuqfUe9eGXaZDxljDj/0us1OOObq5B0MrE1j0srJbRtbAArcYFns9F6Df/zart8iru1/T5zZ2C6YBUyr6XZJkx6SWQ9OQYOpnnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217720; c=relaxed/simple;
	bh=xGsLNyQlQoDV+Ub/zZp7BYFxqifILtCYTg9z7VysFrc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bkXx5u7j4B9+klD3GAdYwBmwz+3PJSR1JuhVCijP861b+7suX4GBqoxCeCqU50zuzkmrmCog3A4ii37R1VTDLKDxehKL2OVTJl/WwFvHem0mRVfMpyHQgNSUfvt/Fr7/a02DM63ZAhB3K+7UX14fFf++zz+xZ0u+Zm78ooVROEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZR/5+r0a; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Y4EMzOCK; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZR/5+r0a";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Y4EMzOCK"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O2K6Oo1851862
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	R2A5S7dXBn8f2uUVD7ehSB6YipngkdXNcYQ7ZXaa4CA=; b=ZR/5+r0aoSNOdZ+I
	7vy/9oswEnWZTd70OnS8d74cYf4NdDzgpWRaxBOl2uwycxHj6Bmx2NY7Jwx5uedR
	uFSuJEaZ7ygeisnMAYMA8FTsr3G95C5+SN517w12Jhz8NirMOgCbCBt/DJ14qjvY
	7l8U6A8z0q6CfeOO0Fj2OZJQ+Uj6LQmq5m2XrmjwsurggG0r54zgoI3sSjJL9/xG
	L+r1jFvRAQexrbNs5cSXvU6sPWFj4YHqX/R14KhJjw8/UB7W7WIjoJpKJRcu4/db
	rodtwJCxXItBP/RoBEst4/tj+pxAbbMgqEjAzSgC5NDPkV473tTJhP2vByeIa8XZ
	y5rmXg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvfjxtx1u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:57 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-313d1015161so355449eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 19:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790217717; x=1790822517; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R2A5S7dXBn8f2uUVD7ehSB6YipngkdXNcYQ7ZXaa4CA=;
        b=Y4EMzOCKvyy4QyxDFJcg2KBWICQcrMQKxME3hvCcA3mkpgu/m2wafpb2vL5jwzFTk7
         L6afB3fY0hA3mrL1J9QSPiDxsV/ZwO0NWqBno8lR0fY3Zg3Rud7o7JrIAoO9w6m8UIAe
         StxAov33eA7YuMVq8JakQx8KmTGpR9bAvyVKpASxhlt43bhpSy1QsQBBflDJVOMdmzLy
         to5TMo+Zx8AiEcuYQ6GN7IoVfygtQazcRSP3vBhITahQZjlw+qbo61Y3Ctfqo968JMVT
         4YzWnbiucctpQsJ+Rb/d8mDcWJu+uOYjUE1OT7NNOzHeom9u4HULxH5XqyoMqWGGFsV7
         /dTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217717; x=1790822517;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R2A5S7dXBn8f2uUVD7ehSB6YipngkdXNcYQ7ZXaa4CA=;
        b=SELq0LvH+eejyAJfD6gIqLhHgiY8KOUPMdTPc9Sy0Q5gxFHCwCoxVgSE/PRpS89qgP
         0ehd9r6+lF9GJokFlqZ9uva9zqzaMBltmLm/1MOnDgK8Efe3xrBgPNp2T5WY5wmcJndE
         Xr6ODJOT3aPGFrYLHpwaUJ/NQRPZbiMmgOzu5MMQ1uhKxnFlU5b+bZo/qX4c9bp16K80
         4jj70u/0zk6prfwQDtEvzQiDQk/AwGK0nYBakxgA6C6osOxhJ6UUdcQZIcUdJArsv5ki
         a+FizHbKuoxHLsm21KbWpQ0KffX+Aph6FNxWFCwyUvNBvpAzqHlrMf5XZBLQtDziVzTJ
         YnGg==
X-Gm-Message-State: AFuF++nujlRvV7CAwH2nWNTXNOpT1jTfvS82J/SESb/efzhbcayzIxnQ
	mVBnu21cXDrrJLiImTldboXuVWlRqM2ubQDdu5L961viBKr4+dg5nb8RDnUdklIzl/ZQHcxGICJ
	1/QUAa2v8MQdrU8qnQEinv/doVjnvh47zB4S6wyT9rC4U8E+YP7UCpH6gBungGJ3an/Cp3sQPbC
	AF
X-Gm-Gg: AYBFou3LgaLlCS+DFVBK2loA1Z7JI4uu+Sig3flTusq/KEnBUlWqtQM+ChlbESzJdR5
	EM9yrKvYjnYWi0MjFgVrw6Nla1nA6Zb4zGzW38ZR4aDfAiwagFv98vVil1u0kAKfbsLOnD02ZtA
	yr6rnE3RZRaDeeT6bv6dGWjqtWr4vfRNz1eg0kbOGIa52akdesHA2KJqyLnXpMCmJ0E5Ehvy2NU
	WvKhXfK+Vla642RGdfx0pAs+ud4BSXddO6Unf/t13IAV28h3+eeJGOwTBQkZ8vbDa+gLJoEDlnG
	A7fL7j31Ghm16CqXFz4c2omTIUTHyIHPygIRSbOsktlllW9dh0ok05Sur3crxGbouP5oZlF72UA
	AbBvgv0CMnUObAlXtQyzgwBIcM51Tzax8jhSJwiR9N31Z00goAqi0WnlXICTNBm+YDMlNatCfzl
	NcAL5VO+eWfO6LHy3szWCJcw==
X-Received: by 2002:a05:7300:ec0a:b0:33c:14c9:c79d with SMTP id 5a478bee46e88-34004b8b5bamr1063031eec.9.1790217716838;
        Wed, 23 Sep 2026 19:41:56 -0700 (PDT)
X-Received: by 2002:a05:7300:ec0a:b0:33c:14c9:c79d with SMTP id 5a478bee46e88-34004b8b5bamr1063017eec.9.1790217716275;
        Wed, 23 Sep 2026 19:41:56 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96258351sm9692263eec.12.2026.09.23.19.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:41:55 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 08:10:45 +0530
Subject: [PATCH wireless-next v2 08/16] wifi: mac80211: Send BlockAck
 policy in AMPDU action
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-smd-v2-8-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
In-Reply-To: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: Tv4lV1olc0Cdco_45dREInnhQriKRySZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfXyfxVxW9TUTL2
 MaawIQ0mxUffIJE8EYg+4IlT2cAqhgORrkezwR7/ptKFmPg1rEGcpXDeOl7Fhen4boHJJkxoaOv
 rPSWtbwXWtxAEQnIxfeZ+j7j+qI380y/Xzl7gLb3bFtTveNJP4Rnzjletn2kT/415TTkNxdI8Pp
 pUSwrXYqH2b9eE/Djgmh/Qgz3vhlOXgWzIZg3213V3jPdTIzqDQ6JGhSY350dAw1P2+Xdfmu5D6
 oR/v8+cJ1VfWXOEow83KcBC+ulFbP3DjdHWwuFr7dOUs3CPN2rj5aHXLx5dvHwV5PIt1WqPN2Wa
 JO+j0M+Ycy1QdTkvgA/ZoPF1eM++StzUBjBIMXZp3Spkh6L1tMhgS05whnAlsbs50X2X8aBk+xr
 Mq63eKQBGlbCknDv1GLacQkkpiaZ40RIC9RrXUJFAopeHcN/3zZw6aWJ9sDF1X5CFbcdzCwgaFP
 Uy7jVIvRAzLYESKqH/g==
X-Proofpoint-GUID: Tv4lV1olc0Cdco_45dREInnhQriKRySZ
X-Authority-Analysis: v=2.4 cv=NLpAaE6g c=1 sm=1 tr=0 ts=6ab48df5 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=nliDdBWBufQ-nTcFh1oA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX4aUqhBoxzoRq
 Oe+TO3ftafGIQGEz/EobOUNce4CeJll508si/rjRAZPCZ/HCRhbbjfwqgtIbLxSp1H45VAPQbja
 W3DGDcLEykvpvoNzlBwq8RhBRsZMW6M=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240012

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
index 03b75eead766..7bfa421535ca 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3963,6 +3963,19 @@ enum ieee80211_ampdu_mlme_action {
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
@@ -3975,6 +3988,7 @@ enum ieee80211_ampdu_mlme_action {
  * @buf_size: reorder buffer size  (number of subframes). Valid only when the
  *	action is set to %IEEE80211_AMPDU_RX_START or
  *	%IEEE80211_AMPDU_TX_OPERATIONAL
+ * @policy: BlockAck policy of type &enum ieee80211_ba_policy
  * @amsdu: indicates the peer's ability to receive A-MSDU within A-MPDU.
  *	valid when the action is set to %IEEE80211_AMPDU_TX_OPERATIONAL
  * @timeout: BA session timeout. Valid only when the action is set to
@@ -3986,6 +4000,7 @@ struct ieee80211_ampdu_params {
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

