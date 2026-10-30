Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367074;
	b=CyRdtR/d6v82Qcy//nkT0DYeqdHF8J9w6zEA3Oj0oOPilm3jElKHJhHdMu9x+FzDKgFU
	 K+eUHXbeWoiyMmr6o8nrgHgmiRErjf7ErWoJrQcGgNT7ppxfmrlfIfLLLiy9OMMpyjQc1
	 Un6bk/m4kHnOVtp2iISXMBZgRAnr3FECGi7NMT3vHu6ucB1bxMaCXFwgHRG98ZYLaHn73
	 eMSzk4YKDfPT8ViwgklyuctJ+/hCtWbNoncZynn/URkB5/xWIp9/Iu/1hfHjGk+bzMhVN
	 BEgRdk9d4D4eOoVIZhORI7PlpJyCyOCkPygBoH1N74jM/AOrY4wdIAzcxN/3OHAJ6IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367074;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=T61nBzQPZVyh2SXfnYJ/cxNIBseig7ivQO/6U8EUrTw=;
	b=WgRrIjBB2wAz+gpr3ZGarHi4i/K4IbK/kRThzJMfvX4u3iSdopVSN2AEcx50j7Bqpnyn
	 Ft7ukDnMm2qd5z6SQ3Y0BqmtGBiCenp6aj1Vgn/nePgczLXjMYgcCst05baZqh3D0QjLw
	 baFOGV6CwyEIKIW/nOii6O57+0/1rUzFe173Vs4mLlBL0SKUMZe/iMhofXNzUxfgpHpqH
	 oFraleyhr7KxBhwXNhN5fO8wbj3/oz1NpxkJw4phS1zyuhc7aHG02Ca97NLqL67yETJdI
	 /4jYYVz3HKnifGisiPelGoId7ih8g3VFamgldkwlck8xAkV2xaG+mcotNC5675SaPqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gbhnTmpv;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=jHpKDLPs;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8D1606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D8D1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gbhnTmpv;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=jHpKDLPs
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBG49c3142133
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=T61nBzQPZVy
	h2SXfnYJ/cxNIBseig7ivQO/6U8EUrTw=; b=gbhnTmpvqpQAkUT1OM3sEIZ918s
	e1ZFrsQoiEH3kZAyb7XnRKwxpCAJnHcSiBzjn77gVu+/34LGbYJ1WoKGUBMpBUST
	LaN837U1yRSDZgWwsUkDZI2mK+rN8hV5ipTVbvvLbFBVSIqxPdKajBy0EkZrhZo8
	3BRtIfXyXmMK7XW09eXtfmE4MitSyfvZQ8mnaqu4B+tg/Yg60Xneys5zlygwEOug
	Lr4u/wgN2nySzDkFkF3Mj4se6RVRV4fhUEaEDHXGpgHEYXmtfb5JjH9mXnrOnczW
	9duXPNU3gpby0zTfD/1pOKNTLDPUbN1aaxvIeW2QrQ9HEXwhUZCT/FzIG5w==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qk6yh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:12 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ae59682799so661597a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367072; x=1793971872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T61nBzQPZVyh2SXfnYJ/cxNIBseig7ivQO/6U8EUrTw=;
        b=jHpKDLPs2Oi7mXJs1p9kej+XezUX4ws0v0xiHX0FgJSw9lwn04gqvZg1/7A3qHDlNZ
         e00DS1R2IiXCeiqj2Snw5gVnpysyRHtva1/4TpVvcSnKv9Ma3o/foZyQr5Fuc+BI939F
         eEeiinXhgDBhfUuGniF8hVahNrS76J5IdIaGubXRRDemo7q7k3JNdEGZHOBw/Ytl8ivl
         B6L4v4tVfx99ySwZuAW/PEdxUlIlWGx8jSVWrvLM+iH5/f00khOWT/oQ+Ep9RCjzGfWh
         hqCacbmBXdSg1wjusX385T4rJvzZiy8sSKYgi7xLe5yRgAcLGa/FKBlUQu+gQGKqCgTA
         m4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367072; x=1793971872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T61nBzQPZVyh2SXfnYJ/cxNIBseig7ivQO/6U8EUrTw=;
        b=2TUpPhdPV5WRCYWNDVRtwehSGvcg58LywOMij/2hB8929KVHCnY6yss3dvKDDvYOka
         2PMGGUrgOdekgTgNzxIKjbrUtpV7zk2yZI+hOwg63msGcMKxoSrqQptBAKTZ/Auwt1/L
         RiK7Vp8huktItll2JnAKaNDXRC2UkuurOiLl25ZgGJL9/I6lpwHe4WVuIXmjhtUAMsaG
         C6qM867zI+AP3iotsNIxy7a2Ad9Sp7fsVSTFiiY6Exuu7rVmScMjjcMApZ/sOwhSExQV
         pMFylcay/1hB1Njmyh551SS7jaYlU4oqspMSFos81nvwPB171B9iDFr3Jt1mstT1C4O1
         MfpQ==
X-Gm-Message-State: AFq9FYJOIM/w2+7iAYnTdeO7POhUUtopc1VzIYQeju1mVJFdyE93S7Sm
	PImgJkM4s6NApn8S9RQlrpJcjcfuUUAQn5GwrJToLFHqRqsMSuhyAw9pV6P9QuKT1LLuGIz08Sy
	E3m9bRvDQLy9koUnH1eU37elrRC7XvW8vClTZFX/QK3dRWPeGx7oM/37BM9EwN3tKXCDRKZ+CVB
	FDng==
X-Gm-Gg: AYBFou0Po43C+13kdmwwLph0gY0P95QCLN06BY4bwgi2cdAtyIZGiQbZDWWtfxpc7lr
	DxWYJI9YeZvBKsBbqK/HcyktmRaXEJjG1c7lwq2ivKRiQOQXtVaekGXFPFNln+G6qTxg9k6Gmqp
	jKuXVT6drAE5L2o2LpctgbD+9H6cA7+Qk8mzZsJIiXK+r0BbedC6kKHgPN58RkCOcc57B0lHH1m
	KN3iu8Girw77RcoxX8npyGNnrieGrarVijvI8e55Ba2pqwM5kzLtkB8JDE9tqLVAlgxualWNWVR
	ViNeih8I3qkSkI/++Ia1Vtv1vpEO1dolQtEIvSFM3NeQ9CJlXv/+jPCdeM9IIRh9C0tAc2A3P7J
	SFhRGSoSHRDoHVtwQ8Tdb2MZQ+aJDxRIBezxL1P9loeMouqYvX6o9FF78CatFRJbaoIDPSPGtik
	QTxPTA5qcs9Q==
X-Received: by 2002:a17:90b:2e4f:b0:3ac:9a5e:9ce9 with SMTP id 98e67ed59e1d1-3ae897f3440mr1965615a91.29.1793367071568;
        Fri, 30 Oct 2026 06:31:11 -0700 (PDT)
X-Received: by 2002:a17:90b:2e4f:b0:3ac:9a5e:9ce9 with SMTP id 98e67ed59e1d1-3ae897f3440mr1965581a91.29.1793367070872;
        Fri, 30 Oct 2026 06:31:10 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:31:09 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 15/16] wifi: nl80211/cfg80211: add support for NDP terminated indication
Date: Fri, 30 Oct 2026 19:00:11 +0530
Message-Id: <20261030133012.3009774-16-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-GUID: pxrREPjJWA1PfNarE3ar4Hda1tTr0YRf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfXyhAo4byrQNNv
 V/Duvcxw/KSRArTDxZ6Gn5xmmG2Nj5MhqBVHLrrC1ArQ78J8njAewji1L1YLYh8+A6zPP+3f6dT
 Z/x3mjjOVm6uTSQ9jRxv3adm6+3/I8A=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX093hIfHz1XlY
 dAmt9F/SOi/QtNJJB57I1WwAqXNv3qdzc9FyZC8zUhWmsohI/36ZB/qWqyC3JHBLlIODHhZ4gh+
 wrAaRngh3RS56D3JvQar4nSNrQGrbHypurEfmN0iw9RvZB6Boh0EQwIiIZgSKjcS4fnLxtewGF8
 cKtZddPtL2f0X71ST8n+QNEQZ3pYnyE4Oagr5m3JT2bvDdsXPPyxkbJhoIn7M1Y1/wfZLVKDhn5
 4hKRa762ou3dX4pGczOc88Df3jRWKYQbu2x5G3VB/3YfAwCPVXOFUQGr9Y6lJBtibUROat9UFMX
 td8O7+tkd1LXgzgJmJGTsBS60TYqzDm4gaLVG6yW7O72bZOKU2dLaY2ob55Hzzn8aIBtCECrq1/
 XEzmjz9DdkY0AH3clSVl2Po6tPa1jbkWvpEqoXCU9odn6t6rva2Lkg3TWbHNuXPIjsGRU/wRdMn
 7YJKu1obQhr0HK/VPiQ==
X-Proofpoint-ORIG-GUID: pxrREPjJWA1PfNarE3ar4Hda1tTr0YRf
X-Authority-Analysis: v=2.4 cv=TpVzFzXh c=1 sm=1 tr=0 ts=6ae49c20 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=SXNX8jZLs4P-37pDPesA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 suspectscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300053

Add NL80211_CMD_NAN_NDP_TERMINATED event to notify userspace when an
established NDP is torn down. Add the corresponding parameter structure
and event function so the driver can report the NDP identity and
teardown reason to userspace.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 28 ++++++++++++++++++++
 include/uapi/linux/nl80211.h |  4 +++
 net/wireless/nl80211.c       | 50 ++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 885a89b85794..20cf7f580d3f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4508,6 +4508,21 @@ struct cfg80211_nan_ndp_confirm_params {
 	bool ipv6_intf_id_set;
 };
 
+/**
+ * struct cfg80211_nan_ndp_terminated_params - NAN NDP terminated event
+ *
+ * @peer_nmi: peer NMI address
+ * @ndp_id: NDP ID
+ * @init_ndi: initiator NDI MAC address
+ * @reason: termination reason code
+ */
+struct cfg80211_nan_ndp_terminated_params {
+	const u8 *peer_nmi;
+	u8 ndp_id;
+	const u8 *init_ndi;
+	u8 reason;
+};
+
 /**
  * enum cfg80211_nan_conf_changes - indicates changed fields in NAN
  * configuration
@@ -11418,6 +11433,19 @@ void cfg80211_nan_ndp_confirm(struct wireless_dev *wdev,
 			      struct cfg80211_nan_ndp_confirm_params *params,
 			      gfp_t gfp);
 
+/**
+ * cfg80211_nan_ndp_terminated - notify userspace that an NDP was terminated
+ * @wdev: the wireless device reporting the event
+ * @params: NDP termination parameters
+ * @gfp: allocation flags
+ *
+ * Notify userspace that a NAN Data Path was torn down. Only valid
+ * when %WIPHY_NAN_FLAGS_OFFLOAD_NDP is set.
+ */
+void cfg80211_nan_ndp_terminated(struct wireless_dev *wdev,
+				 struct cfg80211_nan_ndp_terminated_params *params,
+				 gfp_t gfp);
+
 /**
  * cfg80211_incumbent_signal_notify - Notify userspace of incumbent signal detection
  * @wiphy: the wiphy to use
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 46af2b57466a..3b105cd56c24 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1494,6 +1494,9 @@
  *	the NDP confirm parameters including %NL80211_NAN_NDP_ATTR_RESP_NDI.
  *	Userspace should call %NL80211_CMD_NEW_STATION on the NDI interface
  *	to add the peer NDI station.
+ * @NL80211_CMD_NAN_NDP_TERMINATED: Notification sent to userspace
+ *	when an NDP is terminated. Carries %NL80211_ATTR_MAC (peer NMI)
+ *	and %NL80211_ATTR_NAN_NDP nested with the termination parameters.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1782,6 +1785,7 @@ enum nl80211_commands {
 	NL80211_CMD_NAN_NDP_TERMINATE,
 	NL80211_CMD_NAN_NDP_REQUEST,
 	NL80211_CMD_NAN_NDP_CONFIRM,
+	NL80211_CMD_NAN_NDP_TERMINATED,
 
 	/* add new commands above here */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index be26d6e19290..a94ca48bc06e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18969,6 +18969,56 @@ void cfg80211_nan_ndp_confirm(struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL(cfg80211_nan_ndp_confirm);
 
+void cfg80211_nan_ndp_terminated(struct wireless_dev *wdev,
+				 struct cfg80211_nan_ndp_terminated_params *params,
+				 gfp_t gfp)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct nlattr *ndp_attr;
+	struct sk_buff *msg;
+	void *hdr;
+
+	if (WARN_ON(!(wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_OFFLOAD_NDP)))
+		return;
+
+	if (!wdev->owner_nlportid)
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NAN_NDP_TERMINATED);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
+			      NL80211_ATTR_PAD) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, params->peer_nmi))
+		goto nla_put_failure;
+
+	ndp_attr = nla_nest_start(msg, NL80211_ATTR_NAN_NDP);
+	if (!ndp_attr)
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL80211_NAN_NDP_ATTR_ID, params->ndp_id) ||
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_INIT_NDI, ETH_ALEN,
+		    params->init_ndi) ||
+	    nla_put_u8(msg, NL80211_NAN_NDP_ATTR_REASON, params->reason))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, ndp_attr);
+	genlmsg_end(msg, hdr);
+	genlmsg_unicast(wiphy_net(wiphy), msg, wdev->owner_nlportid);
+	return;
+
+nla_put_failure:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_nan_ndp_terminated);
+
 static bool nl80211_nan_is_sched_empty(struct cfg80211_nan_local_sched *sched)
 {
 	if (!sched->n_channels)
-- 
2.34.1

