Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367065;
	b=OoIIL7NpcsOxiuVHQOinP/NgDN3ddLG7YlxstbBCXDE0t75EOhyRxkHInAO9aqfITXKi
	 CbJnDJC1nlqz7EjfYrdzrmR8k8utfBf78cXE/v8vgQGR2DITudiD0i7cFbUzXcrRq6pMH
	 x4StfPcg2POl36pE/GdKL7aGwC+gfhtpdaq/p/VVe/VIdxNP+2tw+ftoRQkR20knPc5eH
	 XCuQc+MLQ2r8i50bxTtxTC8ZPYYghkb8jei4ZBuNU89dx4FjBZSc+WX/8dcHHD5FzC1C0
	 MrrEHy1RUPgMxRmPXHT1a5L1gN+2c0dGEFSRb8yyfioqTxmJ7jHCHRUqbQY6sNBW/hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367065;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=9vfx0yY4/SkW+fCHolYc/mbhEWkzY3HcgTgNRLlRQWU=;
	b=id/uES8e2zVT8Nfxk39JNxgPyIq41RXIW1XwXBy9gGmdlCptLE9bATA0G2tkgpHHWXw6
	 h8GcYW/ZYQotrH5gza2fxpwjJeMHzi5g8L8g6I8HP9TLRVEbKm/Koo2Lnu6S/VPPYCeOh
	 gxjfqPdhvaKRVbJ4N0iqGtgHJ5VsmsMxdLNF9BxfsMlfK494VEpA30pv9Lv8LZ92mMAFf
	 5OssAMHnS/DfE/UU7i1FuwLUWsGoke1spysi967JyVNkVsIbxL+SFwC2dV5RtZwHp36Ym
	 NHAwmviOL/pfxGGKQq0HutiFpA8IIe6qbfSk6hMf2z/P4s0W8W8qcoZ+klQHV6nRu4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=pxLuo7Tr;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Q+C48gK2;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30333606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30333606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=pxLuo7Tr;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Q+C48gK2
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBG1hS2071574
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=9vfx0yY4/Sk
	W+fCHolYc/mbhEWkzY3HcgTgNRLlRQWU=; b=pxLuo7TrznNrOqkS+RIugpRVsvr
	cwW2+hcrfzIaToUKp71EzB3S0PhTHJhJdlWI613GmuuJmsB7fv5xbOVfEuhZj4O4
	pcGYFgloqAgH0FRHjbaqBTGZVeGk0GlViScGBix0SV+6RtFWTkWpghIs7sAYTgfG
	hyqB6RAVZkh+qgs6MK0zZwm5ONwZP/4rPK/OSIPBBI5NXDqW+zGJ5J4BvPwm7p9+
	mWemGWKeQDEWwIhR6BdMSjOWgQwXzKgAhJm0mX8oeOVELw4tj9oI4IsZJLPutQ5n
	74z4G3n7KLlJsJYMNtdq5XIuxhuUusSUY+QuiqBw5f+VdM7JxPb42FiZxlg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6p392g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:03 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ade5b3ae97so645346a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367063; x=1793971863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9vfx0yY4/SkW+fCHolYc/mbhEWkzY3HcgTgNRLlRQWU=;
        b=Q+C48gK2M6Pn3+RMeJSQJDmgjcjPWcDJN9G9uCFegO/VLG2vUrWlxqzbEkv5oGaoCj
         KR/cFZIM2woHArEt/TY5XoEBZxY5F5PrLS52czht7jYHimQ4jHdUlXiuQErWaGucSd7c
         7DnG3npekxHe76t00PIJxGMRktT02HNWbplR6cY9f/b36Tzp1Xl6h91PnIRO9DeEiSPf
         4jxgby2DjR6gaGiSOhWipyHRf/D1CK150FMDylM8fpjzU9f99OFQVRGMi5vzJUS8HjzY
         bVm2PGQqJBq77KUkIYe/76jsWpxDx0BwYuHFAX2TD+bAzlwYo6RT4/BIi/OFQLPYthLd
         fjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367063; x=1793971863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9vfx0yY4/SkW+fCHolYc/mbhEWkzY3HcgTgNRLlRQWU=;
        b=coskqQA3vXFOZSxRzbE18CUdAt4kNH3JXg4r6iBlQID4ZfJqayEZlBcRb1F6igfbaj
         hyIWUBNs3Kay0rmY3RqNR5UsPz3wMRFGwwMRNMMbubQGg3ONpV9iiOcmLR6uUJEN89MH
         3o9d8C7qF6T5n/S6eNECqq0qbXwrVIlmB91xdf1VxLRUMoGJ56e3CYQNigzzntzRGthD
         IKtpMcFHEy+hDz/5IGJ9mGOGBKkJDRIpBNJeJEyNg+2WXoSbrwztHTGn9VqNliK869gI
         IO0i8DlGKDFiWGojsR0kZOtq9f3BuwVLt9jMuk+k+bwQ6YMtGMMy+2h39AI0p2ivoKnd
         FjRA==
X-Gm-Message-State: AFq9FYJCb9fPfr4tZUYjmhlLg3Yd8f+4VsNeY4sKGl+rQzu/+MVp2F/v
	cVdTRkWNAKWzhRPS3KMdjqTS9OGsD6uMhQbAcB9sAAnE4NxPRtkD5aU6rchimpjRjBelbP5K/r6
	PA3eEH3sBVIUuh4tvWiX82lwPFPs7QmFdcVE7Yhb2J7KbwM/KC5cDKhKwDpgC8OUJ76RrFA==
X-Gm-Gg: AYBFou0JIG9M4g9EkuWcHoIkMdMNzAXh2IFOoBRjlgEptt57SLi5L/CuMxmKZ36wwNl
	aoGPrXGLO6FFYBdPVFEZcoHbEbUXiLyyOY4KsNabzAOF8ssZ1QwRphuxaraN5xFqU00sK6EUR8O
	ujvy15RZasSAxjF5Cn4Qx6FAvCzRyAls+wSGCMcFlP+j54aUNVyb9hey7cq1BML/gyIkAcnUcTv
	2kU9vuA8cyekZaI0uqb6TVcB9PD9uV04/vPdyeWiFxVOEGuov0Q5v/EflGYOP0L34Z7W0MQEs04
	ZVwxc0Aa48pi3zsBSjIEJvhh3UtyWdwm5aP+CQ+PDGJxB/LG92VVC4wc+AQFLEYEtuYiLKr2NNg
	V3oUepzlsw25iSHwP86Z3yIxXhwSV5L4pfKGr2/P5D9LlOZkFMxkUoSCgUk0P49r3HTVtfJG1mP
	wEJ03GC4Rrtw==
X-Received: by 2002:a17:90b:548f:b0:3ad:677f:567f with SMTP id 98e67ed59e1d1-3ae897c8b96mr1368382a91.40.1793367062558;
        Fri, 30 Oct 2026 06:31:02 -0700 (PDT)
X-Received: by 2002:a17:90b:548f:b0:3ad:677f:567f with SMTP id 98e67ed59e1d1-3ae897c8b96mr1368367a91.40.1793367061988;
        Fri, 30 Oct 2026 06:31:01 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:31:01 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 12/16] wifi: nl80211/cfg80211: add support for NDP termination in offload mode
Date: Fri, 30 Oct 2026 19:00:08 +0530
Message-Id: <20261030133012.3009774-13-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX5wvqg7Hof4Pf
 ZNFgSnZMMEgSy8z/GCRjsUsIjF3VwBlMhDKya/aDIXoskNGW0kV9YFPT4jEw5Avx03FL14k8the
 P1yHtFMAKFz1WqOJ2vHyuYIiwKt8tc846ba7vWCFCVHIotu514xlQoWM4BvqBb9rzFuIJAaDPcp
 Fl0DAQdt3xv2efvC3Iv6VKQbXblUDUXbq0mL4hcVrswULf1mDUJ6OkehG9HtS2lPqYiS0dZM7SO
 Lo8Z19nUCFPAUdqq/5cxgXBxAoOxTwsIGy4xPzAOtppDf3Ttkgn9JhVPx4j5E3LseVvHRbj5hg7
 iA66w+qp2PKnbfWc503Kuv+EQjaSQPr392CIzvD1ncFqLWqLnT+qW8b+mcLPXtDzHDwmynYqkRj
 7ylBxMgbU7JP7FHgWx2IWUD5zSY/Ie53S0D7I0zYflozsvKwhlFhUgYp8lRNTtB7GhTIqpkd9SD
 H0hWkmx7aK0V1h/QurA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX0214Tub2WBf0
 ZF0PU+hzTcpfIz07HOBb8oOYCAfKZB8jCqvFKeln9vlfs0a8CMgmCqj/tTXVguzdsz72J/C+109
 hPOG+qtxwTNoMI91PJdEoiNE+D/2M10=
X-Proofpoint-ORIG-GUID: IyKbM3Me_I4Za1F6UmkA1W-CfLKARqW8
X-Proofpoint-GUID: IyKbM3Me_I4Za1F6UmkA1W-CfLKARqW8
X-Authority-Analysis: v=2.4 cv=TL3Q2Fla c=1 sm=1 tr=0 ts=6ae49c17 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=GPKjGL8azLyuGJ6F-ngA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610300053

Add NL80211_CMD_NAN_NDP_TERMINATE to allow userspace to tear down an
established NDP session when NDP management is offloaded to firmware.
Add the corresponding parameter structure, nl80211 policy, command
handler, and driver callback. Reject the request if the driver has not
advertised NDP offload capability.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 20 +++++++++++++
 include/uapi/linux/nl80211.h |  5 ++++
 net/wireless/nl80211.c       | 58 ++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 16 ++++++++++
 net/wireless/trace.h         | 24 +++++++++++++++
 5 files changed, 123 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5312eb8f83ac..49091633ef4a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4424,6 +4424,21 @@ struct cfg80211_nan_ndp_respond {
 	bool ndpe;
 };
 
+/**
+ * struct cfg80211_nan_ndp_terminate - NAN NDP terminate parameters
+ *
+ * @peer_nmi: peer NMI address
+ * @ndp_id: NDP ID to terminate
+ * @init_ndi: initiator NDI MAC address
+ * @reason: termination reason code
+ */
+struct cfg80211_nan_ndp_terminate {
+	const u8 *peer_nmi;
+	u8 ndp_id;
+	const u8 *init_ndi;
+	u8 reason;
+};
+
 /**
  * enum cfg80211_nan_conf_changes - indicates changed fields in NAN
  * configuration
@@ -5406,6 +5421,8 @@ struct mgmt_frame_regs {
  *	Only valid if the driver has set %WIPHY_NAN_FLAGS_OFFLOAD_NDP.
  * @nan_ndp_respond: Respond to an incoming NDP request as the responder.
  *	Only valid if the driver has set %WIPHY_NAN_FLAGS_OFFLOAD_NDP.
+ * @nan_ndp_terminate: Terminate an established NDP session.
+ *	Only valid if the driver has set %WIPHY_NAN_FLAGS_OFFLOAD_NDP.
  *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
  *
@@ -5820,6 +5837,9 @@ struct cfg80211_ops {
 	int	(*nan_ndp_respond)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev,
 				   struct cfg80211_nan_ndp_respond *params);
+	int	(*nan_ndp_terminate)(struct wiphy *wiphy,
+				     struct wireless_dev *wdev,
+				     struct cfg80211_nan_ndp_terminate *params);
 	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    const bool enabled);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index a9785b628f3e..7e735731ccd5 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1479,6 +1479,10 @@
  *	interface specified in %NL80211_NAN_NDP_ATTR_RESP_NDI must already
  *	exist as a %NL80211_IFTYPE_NAN_DATA interface. Carries
  *	%NL80211_ATTR_NAN_NDP nested with %NL80211_NAN_NDP_ATTR_* fields.
+ * @NL80211_CMD_NAN_NDP_TERMINATE: Terminate an established NDP.
+ *	Requires %WIPHY_NAN_FLAGS_OFFLOAD_NDP. Carries %NL80211_ATTR_NAN_NDP
+ *	nested with %NL80211_NAN_NDP_ATTR_ID, %NL80211_NAN_NDP_ATTR_INIT_NDI
+ *	and optionally %NL80211_NAN_NDP_ATTR_REASON.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1764,6 +1768,7 @@ enum nl80211_commands {
 
 	NL80211_CMD_NAN_NDP_INITIATE,
 	NL80211_CMD_NAN_NDP_RESPOND,
+	NL80211_CMD_NAN_NDP_TERMINATE,
 
 	/* add new commands above here */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2511175c70f3..754c753f905a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18763,6 +18763,58 @@ static int nl80211_nan_ndp_respond(struct sk_buff *skb,
 	return rdev_nan_ndp_respond(rdev, wdev, &params);
 }
 
+static int nl80211_nan_ndp_terminate(struct sk_buff *skb,
+				     struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	struct nlattr *tb[NL80211_NAN_NDP_ATTR_MAX + 1];
+	struct cfg80211_nan_ndp_terminate params = {};
+	int err;
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NDP terminate requires NAN interface");
+		return -EOPNOTSUPP;
+	}
+
+	if (!(rdev->wiphy.nan_capa.flags & WIPHY_NAN_FLAGS_OFFLOAD_NDP)) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NAN NDP offload not supported by driver");
+		return -EOPNOTSUPP;
+	}
+
+	if (!info->attrs[NL80211_ATTR_MAC] ||
+	    !info->attrs[NL80211_ATTR_NAN_NDP]) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NDP terminate requires peer NMI and NDP params");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, NL80211_NAN_NDP_ATTR_MAX,
+			       info->attrs[NL80211_ATTR_NAN_NDP],
+			       nl80211_nan_ndp_policy,
+			       info->extack);
+	if (err)
+		return err;
+
+	if (!tb[NL80211_NAN_NDP_ATTR_ID] ||
+	    !tb[NL80211_NAN_NDP_ATTR_INIT_NDI]) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NDP terminate requires NDP ID and INIT_NDI");
+		return -EINVAL;
+	}
+
+	params.peer_nmi = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	params.ndp_id = nla_get_u8(tb[NL80211_NAN_NDP_ATTR_ID]);
+	params.init_ndi = nla_data(tb[NL80211_NAN_NDP_ATTR_INIT_NDI]);
+
+	if (tb[NL80211_NAN_NDP_ATTR_REASON])
+		params.reason = nla_get_u8(tb[NL80211_NAN_NDP_ATTR_REASON]);
+
+	return rdev_nan_ndp_terminate(rdev, wdev, &params);
+}
+
 static bool nl80211_nan_is_sched_empty(struct cfg80211_nan_local_sched *sched)
 {
 	if (!sched->n_channels)
@@ -21927,6 +21979,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
 	},
+	{
+		.cmd = NL80211_CMD_NAN_NDP_TERMINATE,
+		.doit = nl80211_nan_ndp_terminate,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index d65dd39a1bcb..8bcc999be166 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1221,6 +1221,22 @@ rdev_nan_ndp_respond(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_nan_ndp_terminate(struct cfg80211_registered_device *rdev,
+		       struct wireless_dev *wdev,
+		       struct cfg80211_nan_ndp_terminate *params)
+{
+	int ret;
+
+	if (!rdev->ops->nan_ndp_terminate)
+		return -EOPNOTSUPP;
+
+	trace_rdev_nan_ndp_terminate(&rdev->wiphy, wdev, params);
+	ret = rdev->ops->nan_ndp_terminate(&rdev->wiphy, wdev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int rdev_set_mac_acl(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev,
 				   struct cfg80211_acl_data *params)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index f937941c6076..fbe3eb69cd14 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2598,6 +2598,30 @@ TRACE_EVENT(rdev_nan_ndp_respond,
 		  __entry->peer_nmi, __entry->ndp_id, __entry->accept)
 );
 
+TRACE_EVENT(rdev_nan_ndp_terminate,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_nan_ndp_terminate *params),
+	TP_ARGS(wiphy, wdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__array(u8, peer_nmi, ETH_ALEN)
+		__field(u8, ndp_id)
+		__field(u8, reason)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		memcpy(__entry->peer_nmi, params->peer_nmi, ETH_ALEN);
+		__entry->ndp_id = params->ndp_id;
+		__entry->reason = params->reason;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
+		  ", peer: %pM, ndp_id: %u, reason: %u",
+		  WIPHY_PR_ARG, WDEV_PR_ARG,
+		  __entry->peer_nmi, __entry->ndp_id, __entry->reason)
+);
+
 TRACE_EVENT(rdev_set_mac_acl,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 struct cfg80211_acl_data *params),
-- 
2.34.1

