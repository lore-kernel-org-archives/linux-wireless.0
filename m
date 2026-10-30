Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367077;
	b=L/M6hT640/Y/+X/cD7SDskrbMnOh7pmxh06sqnDJu1wFRDeI/wnSxOVhhUmZHy5Zkq+6
	 yzYSGsK5SKlRIiieJZ1RXMtWiZoU9sDuNDjcZCXPq3YzeqezNY6r53NnIgB93PxUfLpyK
	 wS5+5/xPnwbp2degmtqQkso9/4QqzhfC5FX1f5Y8WpSUpZxAVcC+rBbYD0PWK0pyYXJqI
	 NW9XJVc5AZHbAga4Uf8P3XDSVOuox/sy3YLuH8bGU6m1c6Lub3Kypk9x1miE+K9/JDg0O
	 Tqbh2LPMW7yKWjzySvhM7sTWN32NlwnXhpXjVKQOzGbC94ZrEb9PqgkPPJGMS9AgPfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367077;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=YbKVz9GwLYeeEfhn7NvgXf3SHykGnCWzO+01JoTTvQ4=;
	b=us0NOCWvCs/FrP21U3lXzVc9SU76bmHxQMXPXa3hea0AlybQEwtOuZpYNrX13BTwBmav
	 Y8rLrbwcRTeavf9Lsw9WCVvTMXE09lrhjgrcIF7Um07Tn9fjgAFZ84XCj1yz6/C5iIYve
	 KoOZi7l1qIpWVUAcQxwUjF/OEevx2gxPGyWbTI1VIrY8JtNvdgx+0S4WLYxMvNfL/chVm
	 p+A+thK7Rt0gERlnOjDAaUg01Wc2lMjpDW+eKBaSLGiZskpguoGsCqeTd3h1Hr9DhnC8c
	 HG6KybkBxIt4EQ5uSeuTC4w1FY1nyMDfCstAaHvRLKGLlUftHcBic9Ldvofz+fltJZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=QePK1eEE;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XZVZY14e;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244A2606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 244A2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=QePK1eEE;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XZVZY14e
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBG3oK4116535
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=YbKVz9GwLYe
	eEfhn7NvgXf3SHykGnCWzO+01JoTTvQ4=; b=QePK1eEENKlXNKR1NN6t2ZTjkwo
	JEtha0FxgRaVy5wbHl9PxQ4tP7cPDJOTHo2J0GQ6ukHniATmmDOyw10p2IGLhzSy
	yJ63UeWKLxgWmpbGoWhH6dMkJN3QQpIUO7TPUXRf67racxiy1s8+y6Cc2ydgSwKE
	cFznv/2x6Pcvp0bkJSucmTBOAi0uqyhPMlN5cJuE0E4qmildaFw3Ff6Fv11bYyNs
	U22fQapqWi36Td3q1rcBlkvMzim2PP77SSszgWTDWq/RFFTxclzEBbxIxkiSZw1n
	v42gnnhrDZxc5YpAMyMz08wSDvyoy+BNNSysQKMnlWS86jRuon01MNZXgFg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6rkat3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:14 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3acc98e3b3cso650111a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367074; x=1793971874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YbKVz9GwLYeeEfhn7NvgXf3SHykGnCWzO+01JoTTvQ4=;
        b=XZVZY14en5O6+dkvsPdSuSAGVH2VpmDBUoXXHB2cPEj0n++BvkX6gHZx3sbqeppNuX
         aqyZ3XcaeJ6np/i64Qh0PHeq655HffEOZ+HHTvcSGTd58QllBIyfnGXyB7x5VImPy+Fl
         kEd2pGsmgPl9tYhpVhfvBOkVadAA5xooFe/Pq8ycVB2rcgE8hHUoikyG8EI0eTQ4GWqv
         MC/0kWZkYdvgmSokya5vMaBY9d7m5ba8su+JmU9xo7vQA9ZuEnBq8ESTnlx3bNe7VgZY
         dcGOS/8iDL68EQaXmRYasDVKdjMu9mgu4crpjxmDBF86PkCOTZ+1B+axB9kZx9vRSZJX
         +8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367074; x=1793971874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YbKVz9GwLYeeEfhn7NvgXf3SHykGnCWzO+01JoTTvQ4=;
        b=xRgEYbfgVbOrkqqlVtJM28J5xWKRcn16ZQt8lV960YlOOE3py5TYotcbSOWMZocgx9
         SZWWihMauax5J0nFZNr/9gRNoq8r6kRtYmCHdZBcRiiUrvW6JGfZUk92p4BYPMZuMBQv
         kFIicgXn/RxzuMotUn8Au1uLN5x5/MkThaKmxMspgIDoj1vbm2FCsjYeMIgbOh2jqMjm
         1aw0zV2dhGPePs+YS+cfpUWrXvITz+BzaPN1hZLC4jx+SSz7vCuHpm2G6huoTMu2QfJJ
         DdKY+1NreSrYI6rDKY2sgAUdTn6w/QxH12Yr1sIESUsqq1t6gml5yawOWBCPzrukVNFD
         Ws1w==
X-Gm-Message-State: AFq9FYJsLdlLoZImWsWlpBZX+8vBHBNVgpD0OtT8EIHxyzyWS2k0/HgL
	zYeRIwSXirnU1Od1+o5x2IgJzCd+FFb1Xw5WPylFqOPAYxkoXzx2wkjRBrds30Wf+QdMU6nUzbK
	Ey3sdBQ8Y+jwWuWtKHLE1zkcB/VxhX6zeJ1ngOPqvM+u9YDJbpbQlgufJwos3l+q0X0wjww==
X-Gm-Gg: AYBFou2cjr5qR3pHe9s9fp1Nu8kcWu7Y4X2oeuTR6alZ+Uv2hLNancs4cheYozX6deV
	QfH8YN39ZZdYZRU9uTq/6c1YbLp/tPsPqYl5VfyAJMy/fIFNxSqiP4HGrSNCzIY1ee83sGsAELx
	yjeq5iIQHgCrCsrpOTb7OKfTenaSbVFKHf0WajDXlrqQO1kpgNCxv5Rpp/gMhxZzyAdrnSEQXcq
	JQFCC+9hOOc0fRw3fY2mCI1lOeSlEguPr8u3e2wzbJd/f1u5oqSARWoeBAB4KCZkFhTUajJjYzs
	4hJH5WQowyjfuQZSt8MTwKm9i6GNeO2DNYUKtqkU0blx6yLvDjApTlHTL8dgf8TQApEgGoH3H6w
	fEPc7daYUr9EGv0nmnpCQF5UzoIxzR3poy8HjVSYL2YUQtS2wGi/u0Hw8O7RkgRcjE0HvyMiE7R
	LTL3O78GQmYQ==
X-Received: by 2002:a17:90b:4986:b0:3a7:da33:ff2d with SMTP id 98e67ed59e1d1-3ae89849d1amr1853252a91.48.1793367073938;
        Fri, 30 Oct 2026 06:31:13 -0700 (PDT)
X-Received: by 2002:a17:90b:4986:b0:3a7:da33:ff2d with SMTP id 98e67ed59e1d1-3ae89849d1amr1853220a91.48.1793367073319;
        Fri, 30 Oct 2026 06:31:13 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:31:12 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 16/16] wifi: nl80211/cfg80211: pass Instant Communication frequency for NAN offload
Date: Fri, 30 Oct 2026 19:00:12 +0530
Message-Id: <20261030133012.3009774-17-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261030133012.3009774-1-shivani.baranwal@oss.qualcomm.com>
References: <20261030133012.3009774-1-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: ReCjUO1vqS8rpxoFnS75fk9afECF1d3e
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX/DZZW4tplehh
 ZeSCoChgRGThIffJZU+4T9yW7iPt0w1B6OdQlZsM79OKTcx5v+uC0rRsnTHtKWWNRvAMh9v9Fko
 KVPqsXJAmOvG9aKiBh7kmLD82821NC8=
X-Authority-Analysis: v=2.4 cv=PIqaavqC c=1 sm=1 tr=0 ts=6ae49c23 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=Xa71DiGtEIgbf1JriuAA:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX3Fo6SRZkOh9T
 9lLHY8D7WhEXNIJRbwkhaVqoIjmErI3KyYn9oR83bST/Qh4kbsok2tkRVOCr+BwbAnfKiQlGtMl
 lgyx6RdtrCtgFKT/m0UANI4FXGt3xoMGzdaLUiuvQHWIvmNiCga+g4ui/K0rzBtXQOcj4M9eXvn
 11Evq7pSgYeWq6yvdZgVqOiUJ6Dl+1LTDTUigmRExOWCdLFYMarAG5R23gOlQFNY0f3v7RZUB/W
 OFzzGMnL5jP0C7A6G/Ovf02nwdtu9hzQwjAI27Wf+kQ09xZBWp+i2FE5yWkQahxfnV0+9AJ7Epc
 Z40RoQTkbAaJrMM7/J5n6pTtpes9qPConkfRE/xo9i0fYVbZiWgI/jx4L5hmCWSQ+n2QPowc31S
 sWLFUHm2MdsHphpvwunEPP7Au/tTBDRbnySSyNLgbdR9mPdaQzNCTcG5SKHK3xMBlwj6vKBdxTq
 dJRmkqfhs9zVb6KXyow==
X-Proofpoint-GUID: ReCjUO1vqS8rpxoFnS75fk9afECF1d3e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 adultscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610300053

Add a NAN configuration attribute for the Instant Communication operating
frequency. Require the frequency when IC is enabled with NAN Discovery
Engine offload while preserving schedule-based standard IC operation.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/nl80211.c       | 28 ++++++++++++++++++++++++++++
 net/wireless/trace.h         | 18 ++++++++++++++----
 4 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 20cf7f580d3f..b543204d93cf 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4203,6 +4203,8 @@ struct cfg80211_nan_band_config {
  *	notifications.
  * @instant_comm: if true, start Instant Communication (IC) as defined in
  *	Chapter 13 of the Wi-Fi Aware Specification v4.0.
+ * @instant_comm_freq: frequency in MHz for Instant Communication when NAN
+ *	Discovery Engine offload is used.
  * @band_cfgs: array of band specific configurations, indexed by
  *	&enum nl80211_band values.
  * @extra_nan_attrs: pointer to additional NAN attributes.
@@ -4219,6 +4221,7 @@ struct cfg80211_nan_conf {
 	u8 discovery_beacon_interval;
 	bool enable_dw_notification;
 	bool instant_comm;
+	u32 instant_comm_freq;
 	struct cfg80211_nan_band_config band_cfgs[NUM_NL80211_BANDS];
 	const u8 *extra_nan_attrs;
 	u16 extra_nan_attrs_len;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 3b105cd56c24..297e4acf80c7 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -8065,7 +8065,12 @@ enum nl80211_nan_band_conf_attributes {
  *	start Instant Communication (IC) as defined in Chapter 13 of the
  *	Wi-Fi Aware Specification v4.0.
  *	%NL80211_NAN_CONF_DISCOVERY_BEACON_INTERVAL must be set as well.
+ *	%NL80211_NAN_CONF_INSTANT_COMM_FREQ must also be set when NAN Discovery
+ *	Engine offload is used.
  *	This is a flag attribute.
+ * @NL80211_NAN_CONF_INSTANT_COMM_FREQ: Frequency in MHz for Instant
+ *	Communication when NAN Discovery Engine offload is used. This is a u32
+ *	attribute and is required when IC is enabled in offload mode.
  * @NUM_NL80211_NAN_CONF_ATTR: Internal.
  * @NL80211_NAN_CONF_ATTR_MAX: Highest NAN configuration attribute.
  *
@@ -8082,6 +8087,7 @@ enum nl80211_nan_conf_attributes {
 	NL80211_NAN_CONF_DISCOVERY_BEACON_INTERVAL,
 	NL80211_NAN_CONF_NOTIFY_DW,
 	NL80211_NAN_CONF_INSTANT_COMM,
+	NL80211_NAN_CONF_INSTANT_COMM_FREQ,
 
 	/* keep last */
 	NUM_NL80211_NAN_CONF_ATTR,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a94ca48bc06e..ea5805a76599 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -817,6 +817,7 @@ nl80211_nan_conf_policy[NL80211_NAN_CONF_ATTR_MAX + 1] = {
 		NLA_POLICY_RANGE(NLA_U8, 50, 200),
 	[NL80211_NAN_CONF_NOTIFY_DW] = { .type = NLA_FLAG },
 	[NL80211_NAN_CONF_INSTANT_COMM] = { .type = NLA_FLAG },
+	[NL80211_NAN_CONF_INSTANT_COMM_FREQ] = { .type = NLA_U32 },
 };
 
 static const struct netlink_range_validation nl80211_punct_bitmap_range = {
@@ -17289,6 +17290,25 @@ static int nl80211_parse_nan_conf(struct wiphy *wiphy,
 			nla_get_flag(attrs[NL80211_NAN_CONF_NOTIFY_DW]);
 
 	conf->instant_comm = nla_get_flag(attrs[NL80211_NAN_CONF_INSTANT_COMM]);
+	if (attrs[NL80211_NAN_CONF_INSTANT_COMM_FREQ]) {
+		conf->instant_comm_freq =
+			nla_get_u32(attrs[NL80211_NAN_CONF_INSTANT_COMM_FREQ]);
+
+		if (!conf->instant_comm) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    attrs[NL80211_NAN_CONF_INSTANT_COMM_FREQ],
+					    "Instant Communication frequency requires Instant Communication");
+			return -EINVAL;
+		}
+
+		if (!conf->instant_comm_freq) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    attrs[NL80211_NAN_CONF_INSTANT_COMM_FREQ],
+					    "Instant Communication frequency must be non-zero");
+			return -EINVAL;
+		}
+	}
+
 	if (conf->instant_comm) {
 		if (!(wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_INSTANT_COMM)) {
 			NL_SET_ERR_MSG_ATTR(info->extack,
@@ -17303,6 +17323,14 @@ static int nl80211_parse_nan_conf(struct wiphy *wiphy,
 					    "Instant Communication requires a discovery beacon interval");
 			return -EINVAL;
 		}
+
+		if (!(wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_USERSPACE_DE) &&
+		    !attrs[NL80211_NAN_CONF_INSTANT_COMM_FREQ]) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    attrs[NL80211_NAN_CONF_INSTANT_COMM],
+					    "Instant Communication offload requires a frequency");
+			return -EINVAL;
+		}
 	}
 
 out:
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index fbe3eb69cd14..3557cbc14a66 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2387,17 +2387,22 @@ TRACE_EVENT(rdev_start_nan,
 		WDEV_ENTRY
 		__field(u8, master_pref)
 		__field(u8, bands)
+		__field(u8, instant_comm)
+		__field(u32, instant_comm_freq)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		WDEV_ASSIGN;
 		__entry->master_pref = conf->master_pref;
 		__entry->bands = conf->bands;
+		__entry->instant_comm = conf->instant_comm;
+		__entry->instant_comm_freq = conf->instant_comm_freq;
 	),
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
-		  ", master preference: %u, bands: 0x%0x",
+		  ", master preference: %u, bands: 0x%0x, IC: %u, IC frequency: %u",
 		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->master_pref,
-		  __entry->bands)
+		  __entry->bands, __entry->instant_comm,
+		  __entry->instant_comm_freq)
 );
 
 TRACE_EVENT(rdev_nan_change_conf,
@@ -2409,6 +2414,8 @@ TRACE_EVENT(rdev_nan_change_conf,
 		WDEV_ENTRY
 		__field(u8, master_pref)
 		__field(u8, bands)
+		__field(u8, instant_comm)
+		__field(u32, instant_comm_freq)
 		__field(u32, changes)
 	),
 	TP_fast_assign(
@@ -2416,12 +2423,15 @@ TRACE_EVENT(rdev_nan_change_conf,
 		WDEV_ASSIGN;
 		__entry->master_pref = conf->master_pref;
 		__entry->bands = conf->bands;
+		__entry->instant_comm = conf->instant_comm;
+		__entry->instant_comm_freq = conf->instant_comm_freq;
 		__entry->changes = changes;
 	),
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
-		  ", master preference: %u, bands: 0x%0x, changes: %x",
+		  ", master preference: %u, bands: 0x%0x, IC: %u, IC frequency: %u, changes: %x",
 		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->master_pref,
-		  __entry->bands, __entry->changes)
+		  __entry->bands, __entry->instant_comm,
+		  __entry->instant_comm_freq, __entry->changes)
 );
 
 DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_nan,
-- 
2.34.1

