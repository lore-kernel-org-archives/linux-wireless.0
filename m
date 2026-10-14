Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DBB355803
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974095; cv=none; b=fHGiEZuEUdeRyLeMehzsaeLH5s1r8gQR5SKTzgSPCXLizhQz3u7DA/scBf2VGCu2FMcytC6ubuwbciGGN0HTcjexNdJCk4nPcU1lICyCkUms+3/qvtHF0OvJc+r7k66MhMU8+OExVh17ENwDCeloon8P57f+lUY2G7+W4pGoBO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974095; c=relaxed/simple;
	bh=LWuUUdUArDyoHCBtzCeWXvX9efALqi4ZpTSNVpXb2uo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ll70QB9lpXOiPyF2ZMjHrdgQGZF7hPUChPxlLedCRS+DQ1GQfftSJdBzet7zWzY/N7gB6umzvhSCoNuzRAtT+CmnplS2Eg8/wml4kWh2i4dAKSfFDzZ3f8aSh4INvlARMVuIBIZjmx9jsKYb8wzGrerSmc++VV7oIVWJC6dArEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SIvj4KDG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=I04Ho3NN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SIvj4KDG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="I04Ho3NN"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E9eBW33696130
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=FU0xLyS5MYe
	xOlH1iaHmsHwxwdWQgGStwCJ6ivu3jBM=; b=SIvj4KDGr/nzRXc4g3evqZNw3ss
	40hXf6HzsvNy1gAMStkT241GyyfJsE3kZ2wTFy3Ew6SWPzJeUcE0dsFPHptUH8MA
	P+pteZ7oBCJqezUeFMrMhfIS2faJ7bcXIXVGrm055eKufEm884mgwthWzgEwLm2t
	VwCVuwdiV9h8Pr3Qjv14uRX3IpEd4kUZqPs38b5vDlsc820Yf66DeUDkOPxpv5SZ
	hsS+FZnbOcdDY7Fj363KMO9Wz3WAXKRQt8cYmN6TbefAk4wwkqimaB8NnQayOjd4
	JDqvNpX8ZM/kJFM8QBWo7+HaXbwoplDjgbGlddYVo0ZYbvliomj2s4V1FvA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha7aeg6ug-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:52 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-35cbea41088so1349191eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974092; x=1792578892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FU0xLyS5MYexOlH1iaHmsHwxwdWQgGStwCJ6ivu3jBM=;
        b=I04Ho3NN0dPKznfUTv5Endku0PbX9FRjFTklmiWNV26s0vfTKcC3xRyTeOn1LVgDZB
         mbUH+qMUkJYPxFKrz1jSMHcBqqNYw+m5kCGzxdqof8+OMATX29Se+iZ3IywrLUzAew/a
         K68SDxBwSpnGQ4p3fNFFFCHaGSP4sfnUPWykiGZzGmBRYLSVkBuSYp1XfdnRlTouRR4f
         cngUl7lTjoR/eHRKnZEvP1FkzecTnf5PTIjn/uNLMmdIoGR6pNg/v3vhKChWgM5bUlg9
         xjlloquQcc9xY1ke6aiRFVA5oS3ub8RibBU0iYrFZPsWef3Nha2UKfvqEJGH+tMsiovZ
         5Bww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974092; x=1792578892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FU0xLyS5MYexOlH1iaHmsHwxwdWQgGStwCJ6ivu3jBM=;
        b=SPq2MJktPh+BUyfcm/WJP3Yc7AbTDbznJQjVTgN6dWdnbh82CX18odTYd8MbOgzRN1
         smejSWHhu1xWGbML35+4wEL4NwlYazHN3ZWPkzjve2VjCiPQz8BNOxqzREsSgops351w
         SYngBPbfxSaW8V6CrI7rpAHKa52ep9sj9F4m3qir09FlzG0uv5prisbqsi2ih2zTeTvH
         HSdZFmb61KDcuAuC6ijzJ0+pdYozvfwovZh5G/rsVHVJO3hlaAGwDCJjVu2PZ1a1IsNZ
         2XlQ7u+48WPTwsF0N31tVdX5qiLL6YpNaHC08ztfrIUUHPMh8pyNDdZPFfU4YeuumF0e
         HYTw==
X-Gm-Message-State: AFq9FYLdd8/iVAUaK21Az3RBdBdliLHdXA9kcIvsTPl+667WkDUSB2iE
	NyTrnb3xIRh6O82/MFMdxSiLU8MuvSwCpvwROLbVVxx5zXjVmqqN+Pc1670vb+DOk1zbIeshchz
	fZWVSlB27biRFOl5zWiZvLLzwglErWWTCDpOTRqOORvLUM2OrMlEM+3YAKRcF7XnUXEGoRQ==
X-Gm-Gg: AYBFou1W3bZE52Mb58G5E8zKWzN8dsrFXJjKSHXTmD1hA/rwDccCQrrnK/8Muc1DzAZ
	pRBrn847fr5pdyPzkKWsaEwTPE2F6AXldT/voTfo0XhHgEwqjPANAXCDfl3MGPormcmrMnrrzRe
	wOJruDRxQmxh3fjGhwpGuLuMC0wMblWbeKLN5B/vakieorWzDZxzg43LrBWetecmK1v0IKEic9g
	kT1fupQ1e+ptL+DvMeyroOjzSOHp4PQq3xz691kKtgClrFVhm2sAFXlVP40uhCZMiJ806Fml2hl
	Mhc753k/f143wV517WT3ZtswNAHoSWSoI4Gxb6i8/dddg3kslT9RS7waIqjeFrvN6VM8Va0zjbB
	ZjFwDfyOAskvXrMAJDM9SXeR9GM+TANMbPMCZ
X-Received: by 2002:a05:7301:6207:b0:341:5da1:7851 with SMTP id 5a478bee46e88-3537df5970cmr23742340eec.12.1791974091406;
        Wed, 14 Oct 2026 03:34:51 -0700 (PDT)
X-Received: by 2002:a05:7301:6207:b0:341:5da1:7851 with SMTP id 5a478bee46e88-3537df5970cmr23742300eec.12.1791974090618;
        Wed, 14 Oct 2026 03:34:50 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:50 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 12/15] wifi: nl80211/cfg80211: add support for NDP termination in offload mode
Date: Wed, 14 Oct 2026 16:03:56 +0530
Message-Id: <20261014103359.1508345-13-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: QQsHUzOKF-bzpcTUlHuKIde1srxZVeR_
X-Proofpoint-GUID: QQsHUzOKF-bzpcTUlHuKIde1srxZVeR_
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MiBTYWx0ZWRfX9+JvmgEOge7M
 7KtMbMV/j7o8GJrG0iajrN6/Caw5T2xNhNlUa9D4GeBe43S2jdMzmTjJKB/5Af98xbAXhQJ0hdQ
 J9krgRdL8eOJ77f+hjz+gstnpxXfFbo=
X-Authority-Analysis: v=2.4 cv=NctzRGD4 c=1 sm=1 tr=0 ts=6acf5acc cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=GPKjGL8azLyuGJ6F-ngA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MiBTYWx0ZWRfXweAuF++IlfA3
 cSK47wji7aJt6kwQmx209rWOa4XO9QDDjPAX9ui7fJMgXytJhTMahaOleGa20hORHIMJiwFiZfT
 fpK0OvNTJKlo8zE8wJ4g4T9G1YwFBfGXxjtdJ435S2J3Wxjxyygtnhg3eUlUCsHwivpcjFnturx
 P44BbmaqXQy3AHLWF3y/yiElc2pxf9nYho+mFBNXlKXFM/5BmXe2ApU7yVims62bbau7vDf0GUQ
 BSfunMJSDgrUyyJSXq+1WKebajMN6GoPmtSxgju1eZ8mvX99EOoXHKb8dRc6ZIUi3YwV/wgawkr
 HH8bE9WnuADOMXLbiBibvAN4OF0s4yOfRsesOoKxA08CWg+7bAqZB2UZ1XE0A9em0wIa6iAhF9T
 eRekJtr1eSh2u7SHmJAbJq2d+Bzdh2XuJ1Wz2WpzRqGf7IFJ5jma1ZKGeYiTrL8M/DNIkquQ0YO
 I9TCL2Zv9lEPB9xar4g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 suspectscore=0 lowpriorityscore=0
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140042

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
index 15b9c88d7ace..a79098623442 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4421,6 +4421,21 @@ struct cfg80211_nan_ndp_respond {
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
@@ -5403,6 +5418,8 @@ struct mgmt_frame_regs {
  *	Only valid if the driver has set %WIPHY_NAN_FLAGS_OFFLOAD_NDP.
  * @nan_ndp_respond: Respond to an incoming NDP request as the responder.
  *	Only valid if the driver has set %WIPHY_NAN_FLAGS_OFFLOAD_NDP.
+ * @nan_ndp_terminate: Terminate an established NDP session.
+ *	Only valid if the driver has set %WIPHY_NAN_FLAGS_OFFLOAD_NDP.
  *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
  *
@@ -5817,6 +5834,9 @@ struct cfg80211_ops {
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
index 9eb96251f0c2..c2b81e2c4366 100644
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
index 7593e69c5b3e..7c2952947a84 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18746,6 +18746,58 @@ static int nl80211_nan_ndp_respond(struct sk_buff *skb,
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
@@ -21910,6 +21962,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
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
index 3fbc5b701768..e4b57983d591 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1215,6 +1215,22 @@ rdev_nan_ndp_respond(struct cfg80211_registered_device *rdev,
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

