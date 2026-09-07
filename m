Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F163743CE42
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813231; cv=none; b=HsPJg8ZXb7XBu4+nOBSDEU4inA52ZuqEvyI3cVJjTnu8rwSQPO8s9OzI/1yOQfbI6uMBOE/1nddTCfCYT8X/+v9B1x0216DkIkT/vt2yL+aylndmdScJte6Z0S+SQAuNXvJwFfg5/yenldPdXUHn19oX3lH9wmoKO9/sIDal8SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813231; c=relaxed/simple;
	bh=86w9hu+WJ1z3hy9Or+mlRGtKjgaxVht0KJsSe0k3fEg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G/wQewBxYP+o5F90753XJgJeuvbXPfr2dXwvutI2snt/xaJbzM4/rNRiktO9YJA0Xo+KTepdebNxubJBOhjgbhkb5dn9FDr1PPDJMHWYHKdzjlrPfcww5GJX/88D2IJ8rYyCDI7GxuFN9XWZOXCgJoXtHnz+9O/nNCzWrYwEuwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RAVSusNU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ihQU8Mzt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RAVSusNU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ihQU8Mzt"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687H9eWZ4065039
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 20:33:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gofo4g5PMnVYPHJH99bL1SwGrtDr+P/qsI5BTGGqohw=; b=RAVSusNUGqWXGM24
	HXFfHQS0H6iLEF2X3JaSi5NtkAfaOD/wCk32AQbYBtjiqEShavXWh/YEjt9oJ/4M
	55a8JsB1m5mJsCB9l3G3GjctySL9GZ+JckPHVOFEG7XnqpVxD4EMR2zNu5m3lMeE
	CQ83XH89MZuXpY7G/ZjKrrDLC9BM3k+0PWyz21WSVUJgx4NZxCkcN39rqE1y97hK
	dIxKv7xGU2HVnrWi2b0+knt7OTlqX5j2gCFS9B1hIbCr9oGWufb6B+SzoRZfrq3l
	PrQLe6ySXkdHhZ1RNaDaaRcYapqMX4tpOcS3vgla0AvhcbciX3rJFWSXWhoe1rDU
	E3u1bw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gj077gtkh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:33:48 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3968dfff779so5337630a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788813228; x=1789418028; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gofo4g5PMnVYPHJH99bL1SwGrtDr+P/qsI5BTGGqohw=;
        b=ihQU8MztNpQ5CWHSj9SaMdxQCZIBVBdOBkwnTVqaw+DK4Cyge3kAFsjPQjFObhNJnH
         sCdKWPXELq6EJtjHFcM6M+CSuDO3Soy2LLsOPy7UD1ZbvvFm5lzAaU4L8FJhiB1qDPK5
         CrQveQX3Ml0NzR1KIWSQTqISloRHRiKgntxXrr9AYvkCNm0J1mvvYY+WtLbJG2vbWY4L
         ZuJi+YI06HlpC6qbJYfOu9+rk4UuVhJte7PDL31IPkaM0mCfVm88F52CmFPsw422Decr
         Pb5iX800ql/5rfQj0tnTPuCNdTDkcqWdnHgnDZFGHWP85fyCNzUVw5Iy46WqF8QoxWgw
         qwlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788813228; x=1789418028;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gofo4g5PMnVYPHJH99bL1SwGrtDr+P/qsI5BTGGqohw=;
        b=Icyk6rgCOI6mlGdcF0dkF+ZWswr51iExo/NjmRz1Gu7xFAQOHyoSjxsUdg4qe2IIM1
         2XkcnHjM1pr/WnhPbhBme78jjv60VyTxTxRBJqFTkhbuIqB0ml+bgLbUnwN6KGI3Si1E
         nhG3j56iomMcgwlz+fTobobzz/U4KUaHDPLjRPATs0iQy7EpJfribwmXjgF2H+NKgPUd
         phV0B10O7w1XP4HdGhlFXeaXBa4gm1BhGuLt9Ct/9ak24rP7t1hgY2RhL0UWg2ISAqLs
         zK/eI/Bk5j3ChUYHH0UtXs9smrYEQC6kW1cUOXum2i4kw43jelDRShU1NgzuH0/jiSe2
         UqnQ==
X-Forwarded-Encrypted: i=1; AKwUvBxulzGEufLKQyOAv3ua4q0VcuvpPHu9Wq2KwpC4sXbVaK4Vhr7IJc1Lorys/8SFwAnCXMFFfrJazIIROStPKw==@vger.kernel.org
X-Gm-Message-State: AFuF++kGRmo428iSCg3r2zs9+Je4pI3I5rkq+MCziXJ1jlcLb/ZWct6p
	4RZER4ji4VvirxQNQrYsCFvj/xRyblucChhPc7EAHPA0phCtsLbDGE5RGWJgDikXQoUhtWH6AQs
	ysUqrFHxdS+aVGSGsHvqPDfEVlqYVi0K9h3ZRcHzRBWHVO+xTiDoxo95I/g73OgdpeEc9
X-Gm-Gg: AYBFou0+P4eit8vc1ByaDG0Z/HaswJ1Dfzuuc1mxuQvfrrKM0V/bpP/97iHrkspbx73
	yIn9Qjr37mdKiwvjqJ3HAvoZKm/+evAa3GtgkFabsCViz40KpXWMzr3cv2COLbd7KN9alPZ2CXx
	wcAK0U+7j6QzPYawTxoIGeCrd/HNjf/Yd8GudDNH4yG11SoPHXEZZi7o7hBH6jE1qZ/xRQ637wj
	9GKdrMCbX+83iU6EPK9opzx1BYcOqENpp43iAof8/gLlJJLrhdJzO+NIz41mWFq09+kkcexQZTS
	4H5k+sp8Pl+zmEwmrvHHINwY7Rx/FEM5/QX0C8t4zZoUaishsklcwNxCYWIZGBAIkwVewffHTvL
	2Dk4SFhjgxvF0HjzlL+rbpyFrxyTh2/aelRlZG2wm68A8iCLzFiMKg7IIpF1nYL63Tw5vM0JMZN
	izL/O1KfPsA34iTtERxAW1tg==
X-Received: by 2002:a17:90a:f945:b0:395:8124:ac53 with SMTP id 98e67ed59e1d1-39b8bd31191mr2581264a91.6.1788813227985;
        Mon, 07 Sep 2026 13:33:47 -0700 (PDT)
X-Received: by 2002:a17:90a:f945:b0:395:8124:ac53 with SMTP id 98e67ed59e1d1-39b8bd31191mr2581239a91.6.1788813227557;
        Mon, 07 Sep 2026 13:33:47 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm47841297eec.16.2026.09.07.13.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:33:46 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Tue, 08 Sep 2026 01:59:18 +0530
Subject: [PATCH wireless-next 09/18] wifi: mac80211: Send BlockAck policy
 in AMPDU action
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-smd-v1-9-65ad4ab30fbd@oss.qualcomm.com>
References: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
In-Reply-To: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX5O9uyDYcyU7h
 F7KHy1I4vSwEJvKtM/lt/zGoZN3UTIROYzlf7zrye+6PD2KTuYm/dSJx7w9UcH3EgQKaCoaMCbM
 gEh/O2gGGbToED1IFyIVSap+15lE3F3KRpdKW0RTRLp9qDUXZpQ10JwqurhfllJLdd3+n01gyWZ
 4RAbRHq38KNMtdc93GueTdDjBuPzy7ZITXqVUNDHKx+Pe8h7z0yUU339us7rTd/12g1LHkm3yfv
 Q4ZbaNGlzm7YRAtTqm1YFnQwo+3b4wQcD85RmtJLwNJg4aWFKPh5/W6Vmk1tA4t0k4lUwN96wjq
 uyi6HDCCOBcL6fMWdd0n6+5JC7RVUYhyZ4v7vThFMCkmfEY7l6HQ+2wauw+1KM5c9IC77SNksWI
 2STO/HfVGPEp35zwwR8GxMkwm00WYo5lvFN26fH/N45/SqZNgY1PWwRzibcCPPeAHN+Xuk0CizQ
 0GHnbwZ9xrFBpudJ6Vg==
X-Authority-Analysis: v=2.4 cv=Xbe5Co55 c=1 sm=1 tr=0 ts=6a9f1fac cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=poGJry9enlaRV4ryzAsA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: sFVhqSzFUCm-n-Zrsb9gq0W4XFzIEuXL
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX6m8yNF9XMwiy
 eXRpyD/Sly/QcAvIvPnCiDOKl7jFrk+N57FjPvWlkXMmpt1tanwn8tuDKWBY5ukduBab+lPVGVX
 gCn9kJAo5q3XDNi7U8P1wQxkHlfdCHw=
X-Proofpoint-GUID: sFVhqSzFUCm-n-Zrsb9gq0W4XFzIEuXL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070226

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

