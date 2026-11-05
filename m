Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907659;
	b=HC5HdhdFNdoZOqHPkBzJ9O5D8vGo3rH4bDPEg9a63Jtu4L9nwtCdzkl1BEtrqJL4QuqL
	 hwIncrapcruuU1aySan3PGAOne0UWpO0GX95uiQ/OybaeAhFtG38+QQMyNrl2MDEO424T
	 /t61tePkGy4aXLHiMQB/2tjI0/+fEeGM/FKRiTO8UZKg6qs6ZfPjbOQog4WZeE2UbZxj5
	 KAJywGUyDcqqZIlmpNI6yHQ625mm+x+X3LR9c7Y5R1pNAZQGcoWld3/8pSHtpbinKgE9S
	 8RM4hniMhRGb+HOUTgesHWfjqoMZpGBZNpRtROYdy1k5aX1IlR87k0R5MW9YIJrPDdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907659;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=qMOncR0UoevAZucFiHIuWkcdcZlD/liB3Dpz3ZsMqk0=;
	b=oXQL1GQhJnGzCsamLPHnJAidBuvoSNp4q/9p32LP37E04aaUGo6rnyyFjkQ8qZ7Qonrj
	 cfFlZttUI5Ojdht5lySoaoCmVkV+E6L51tv0wsp5LfX1KWYrwAbtRWrXHrF38hdIWSmuN
	 t4wbEr9epk1BsnvSuXSLJnxiMM3+WysAYQGym6HtJhJeuY5AaZVTtvINpa+xzHgH0jaCh
	 h7SqhJ7Vm0LKArVmCnsZX3A5j6KYSQiIdjezsOJWsRKjCnItLHFXH54jvPM1Hg34ZKYsc
	 NEms8eC5ImRu/fcwWr8DjTdrBF8+yUZ+3wN6MHNSFpmjBvfRCEuwzkgqnBpIpVfUW/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=T6BYMOiF;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=L6h5Yr9f;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7EA60818F1
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A7EA60818F1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=T6BYMOiF;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=L6h5Yr9f
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5HeMkW1440027
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qMOncR0UoevAZucFiHIuWkcdcZlD/liB3Dpz3ZsMqk0=; b=T6BYMOiFhKkxLHo6
	Dkpih88+idVGaCXcxDcCa2pviBgfvKEJT41K4bEnet7ADK8yzpCwlgCoLn/8eaTC
	0c9LRofEIf9F99hcxMhwx5c5LFW5sCHY+pW93OOc4YYGbTp3QmlR0iCNQH7xi94n
	5CnBzGmU2tJDML0uxNqZVRAp7c2BO1L/Wbz/5gUvW6l7Z6TDwOtXYk0E8msQn+Qz
	rBDlqM9lszTu+bvjXVKIkXpwIgLSCJrYKgDKY7NSriXYA2m72yvuStM5xz/ldN/J
	yk92rNwMCVajL8XLADa53sxwyf5DWfTjYheLJIwqduVrSG2FB4yQN23PRzJ8KcqR
	CMW/Lg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrm9v3fjx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:57 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3552883bd19so4078976eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907657; x=1794512457; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qMOncR0UoevAZucFiHIuWkcdcZlD/liB3Dpz3ZsMqk0=;
        b=L6h5Yr9f8sFasPvagPhFElvVByfAWrER00QHOdLW0EDVu0FJmu18mev4L2rBwxqgov
         bGRvuAy4meNaECKRtDLaReyL6ZU9i5s+sEgMxNF4LxiYtki8xrgN3pW4b8HNNyCPVx12
         T5i27vyQBe+SJMallK4QFa7oxLrHoTPewmR64hUNsPfqWCR+/zZW7DJPkybq8t/yHuJe
         SpK6sigFbTM8YGnaa2jMNN5y6Aj8KpjhGovSLJ9dzpE+xxW5kiBDy+ECvmgJ99F5zkW6
         MExZY06K04gnUU2zpQ5zE6+rld3r/WkLrwgBFu3M0skOJlaBNqGNqhcnUXtv15TO0cFL
         GWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907657; x=1794512457;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qMOncR0UoevAZucFiHIuWkcdcZlD/liB3Dpz3ZsMqk0=;
        b=HfluErBy1ZvRIMsBj1/hSVIT//p5hZAu1KhdO83VDs81rsdBO3uGyflIGcjBIkXclF
         cWSZaIjInGl1G+EL9pR+CKdYCnVLMOcojkQKn8BgnIC8uDELByLC+RB7usbuoAVhTs4e
         +IUQyYdr5lPwKEjDl3kD5/DKZBycKSPnA/f+Hm1o6Bt9XJkcqPzZMdZkDZfJ4mI1UwWb
         hTSvCrGuc5Jts7UjkJhzEcsMrMWqYLAICCTwF6gogTDStCC+nv8vhglei6iRpW0G0Yf/
         CkknDaO0slyEHoobODNTs1k+Y7pR2pCxmqrzHtG/FozZrBKs+gTe3M0ibPWH0c9aom3R
         4PFw==
X-Gm-Message-State: APuU4Z+4Bn18ynnxS7779VU/RAiBgV6zYo0rqE4h4j4RZ79jd1CMQB1p
	EfAzMQ2PTOVrQttfcXobyQgl49LfpL71VmwoeXJICZ/C6lqmixbmq4RLUQbuW4CnJwl0gOhyU3E
	vhgCWoGsT/rgw+iCk1eov7r1aKN/ksgMGe/f3HWSIu2PQ+qR/SFz439SD7LrcasYZHbMh
X-Gm-Gg: AYBFou2g4vEtLATxdWuN6+AGnTfxED4WNPUJYSzo8/dQ+F+8skSrMGIjBqVrBbcl2sy
	xE8FKu0dOC8pc0fhsY7v8hSjLrD7MQOoC8n40Q6mLUtBUBkDmPlainD1NKtSaOwc9DCwMTQmuS3
	y6AVRVEK+BdfJT6ejoWAe34zo0PV+woyA5OSUjBPID0LMUwxeD8+8cQEno6/PRKt3jszuHFMsUJ
	U0xaNYj/jFLqE9McdXSEiafxO1dKCcOhT2xZpHHG0z9dVMuJUhsR+b1zAcbyUsSEykyRJ67WX1R
	XV+WmtJwF5vyOGOqGQV2CxfBwW6juTw9K1ETI1v16FNzBr1o2lJeQQoEULmC9VOZiIFSZm+KuMG
	qts8cSeKLZS6+91dM81M02+44DT6Y25q5nwMoIdCBwU5W8+3JAWYNTyiimpPFV2O3sqCY+CReJN
	CBct5Ge79rqzZogFm1eXsE8YCXsrW8tq+AL+U8HVmQtH1Rj8DO+HzZEtoaJSjl7KfTGMDxDA==
X-Received: by 2002:a05:7300:7f22:b0:369:f18f:34ab with SMTP id 5a478bee46e88-36f75f2e750mr152564eec.11.1793907656735;
        Thu, 05 Nov 2026 11:40:56 -0800 (PST)
X-Received: by 2002:a05:7300:7f22:b0:369:f18f:34ab with SMTP id 5a478bee46e88-36f75f2e750mr152536eec.11.1793907656113;
        Thu, 05 Nov 2026 11:40:56 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:55 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:51 +0530
Subject: [PATCH wireless-next v3 16/21] wifi: mac80211: send BlockAck
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
Message-Id: <20261106-smd-v3-16-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX/nShbWiaKaPV
 nnPf2zJp9108fx8sbSnowLoV9nC8CrYhtUVgy1nO6nfkyr6CpzmW95ckh3oN2D1fCBBxW0gbrTt
 LsSOGVXfzLW9GF+KTfhiZysybzUGov4=
X-Authority-Analysis: v=2.4 cv=KrHYSmWN c=1 sm=1 tr=0 ts=6aecdbc9 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=nliDdBWBufQ-nTcFh1oA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX6EC0SBxbemFZ
 md9IE5aMj6Onrda9kybwebCmI18Kh6SgE9RFgNWOFoBfttAh8IqYRLXJhSTlC6Nxge3xfbgQfRX
 +HQT+1NfFP5zilNf4revBFXTJgY+TE301su830olVJYiHU8ovJyyOTH30NLwc3wMUg0Zyp6KWfZ
 3zLcz+RS3Pk3PytxvEsEqaHTuZoS4+HwAAMlg08UnTCWpeK5/7QwqCeQ/CFlL7PI11VleE6C+LF
 MTwgHQrDKoDj8PAZchTEwo275kWnXoz+hK2u95IYVKwFSq9Q8vZvKQ06ivUr8aOhSwMbdPFHsOB
 sNJeRaNS3GdLy8QDkbSAPHboI7h3fIpM8fBBd8Vn+g4UIkI4gdjHoxiUXgkB2bvD7ZYQmO4Cljo
 Upg09AYlD29So0cawNQhiiDJNKkFL41/gGBAqEPEsqWwVdchGgKLK8tiuCDl12zwH4rTgVmXptk
 33g9TtzfUGGrwKh6c/Q==
X-Proofpoint-GUID: 6VCJlcR_9x5FccIqDgLs9xvKDnYsMew-
X-Proofpoint-ORIG-GUID: 6VCJlcR_9x5FccIqDgLs9xvKDnYsMew-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050078

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

