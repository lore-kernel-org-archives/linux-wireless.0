Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367071;
	b=WkrVa4C6GT+Zil5Lp/L10NZeJ9mGsrFJ/Vg045CS3sM3QDORtVhl7sy5of9YGSbYCE6j
	 vYD6w28ChqsL3mO7wZ0ZitkwfRU3aK9DfOXAlt2BH2DH6TqT3BjSSNAqCK3438T2XFgBj
	 YKS+trMaOlCs4Vp7KKcQZqlIVXwH5nsd2TXbC9Guct4EKDNC+h+yq+ubRrJQs2kDdT8OM
	 Amfo5K0efxF88tTEsMNOPeJmcsaxO2xkKufpCkebpsxHQ7Pph4reSRQSn3IXSKpL3arRR
	 h7dC1+gs+ZE4TddGg1Qyd5rNGvdIjALiMRgWxYXCyW1TNKokof2ww0X+hJzEFZJVyaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367071;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=tMEN4NFmjFh8EFrRU1u7kKanxQbvOMiCE+gc9wyYef8=;
	b=h2Ghn+66scwuoR5WKY9CzEZdRnr/srqKwye9PgxJ3ys3IUfmxnnERJP7oP/qM2FbtQIr
	 Y9ZeakF4+M2yY4JS6FrYcefaFY8REhh5iwvPBxlLreHUy3uZZmSS3oso0P4hGjOlSxnTr
	 kvxjQGY+RtXqmgDsj55lqxrdKD2on+VBx4HsQHUBvoAHEckgroBPdX17GqoUC8YbMj2dj
	 dQlNIDEYDV0lJaJpStSVCB0Xzha9fOHaZLNxloEdjCWcL9fly5yx48ub2YqQD/2Ra54nJ
	 a6ydH7e+d5Ubc3SsZVISGoh161IdXnjEDmoIw2UtYrSiJsrmki13/XWRh5ICFPUN6ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="e/sBQBtz";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OEXsxAZy;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88317606A336
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88317606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=e/sBQBtz;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OEXsxAZy
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBGKqE3130275
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=tMEN4NFmjFh
	8EFrRU1u7kKanxQbvOMiCE+gc9wyYef8=; b=e/sBQBtz+QJGnJD7Q4PH48vUs6x
	0+LYlBH9Wo9OmaWL5+69TwYpe6hbEYmAVsQ7h6w2m2+RSYQvoqI1ygOSgN695KMm
	ih02606SgxFYRwDq2PLYufc/Qqgah25owlm4pinI2H7+pyVmo0zHpzu/pyY9Z1yK
	CtQHEQRjDzinrIkfkOBvS9xRbJtQ4IhiAfTJdq3B06CTuhJF7I8/hKQ0awrkksDe
	uHcErshZxF+GNtccmSvt+Lhljs0kAR+zmnZNASOugY33D9cDHuSDKw5cAZQ2bYlX
	oRnhKWVO0QWqzYybzC3jE9rlR6AiLIRa3xOA+bpLt0mc/V7VKMJpbt9ExNQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qk6dq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:09 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd60a365440so527884a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367068; x=1793971868; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tMEN4NFmjFh8EFrRU1u7kKanxQbvOMiCE+gc9wyYef8=;
        b=OEXsxAZy2D8kZBlJPBAAr65OiuglH/8bob8bgzX9wN1O6fGvFb6bWijzUu741DbpP6
         VHqUqHQjlkbfIhKfb8SG3ApetGz+wt8z89vIvFHu2Qc070Z+9775exjbVXkLOWS5JeRC
         PXtOvvTJX344AUxawkMJKW8Xt7GCl8cvpTPBhLW3D/J/842ranIysYsEcqcyjIOLKC3I
         GmD7ryyhqyFAi2EULNmQqeiZZQdgmlHDSEhocB43sgIrgbpdHyqGYRHc6d4v+Vy7VgAy
         lVgGmeluVj0UKOR4ZpH4v6XlnKQo2g0AWex13+9px7Fx+HdIZl2VY2gDzFYEEragCDT/
         WABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367068; x=1793971868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tMEN4NFmjFh8EFrRU1u7kKanxQbvOMiCE+gc9wyYef8=;
        b=qD/6r5jyo+UFu6Mlu0pcOpYSISfirvInnPXze+n2CyMAgVt+fN8fJWQB66yy94J8MU
         YV5DTQiINp3KlREbAS+Na7smTosaWa3m2m3qlOyhjBAp70+5YYhbdRiGlua5rFgAPqJa
         Z0oNEqfTEnTZ7ip9lxhCZD7Vof/oCHHbmHrxtef0z7FljvI7Cf5KHJSkcgQ9h9e0iisq
         3Ndl25MXVb0nZoX3dVMHHhDNzs8+7ftYRa7yK5DfOX9Ozi0lxOhrEnVCQXMqw1Pr50Iz
         3lO41gjN8SC6+LXt938A6UXPUiwgZiOuvOOJTjCdoW/q88n1qcQ1q95sCQMLNfvQPEXO
         pA0Q==
X-Gm-Message-State: AFq9FYKo9vmksNA6cZhcOx6p6X96Rwq6GyRv1FMaD/qDSJMrQ/j0QjKx
	DnIZndZ5+nIKHvjB+8Qyy2k+D6qcNdGbMzfiVLQnhfPvjdOA1UGGib3Zguw9+ir8HkIgiOzKOTa
	TKoqxuXx1FbprznBhi/VjXuAdts2h/8NuLVSH7QbX+OXFUP5Xe8NThlNwmHpn8BXKhPrTcmYJV4
	kT0w==
X-Gm-Gg: AYBFou222KhR3txrMewf/Bl1EGrz2lTzA6SOZvYY6nm1B8KxE3tdeNRLmMURvIXxycG
	tecnv8wKhncVyQKlvTMZ9bL2qKInDN5jjSQM6g/Tr2P1ohJVgYHDzmewE8W0YAJ9u1JBG0dsSpM
	mmUFJ2vlfjc10fY/9dbpi/v7jBTjOvGNw5Dt4icZHptOijK7rUi8QyLLozZ7HLT/BTE+9d7N1hK
	UaU78UXa0LSMF56PozyRWeQK9KoF9q7FR374MkhgA2cjKJx/LZeNOyZBRHTi83AYlbSFLu3NPui
	AJb2lFhKOyj6XNmib6IMjsx9//U6Z4tfilxLyDTYA6wBhqxZTENLaDjaBlhkAcGwfRnhi8I2s/4
	FAEyqjEodMJHw4eWk5WiEqtixelc2Ka3VYkWWkV45Z41NDMI8C5QtwiQDRgEalNfT1FxwGJQc+Z
	WnJ/u6el38nw==
X-Received: by 2002:a17:90b:134f:b0:3a5:c08:4c41 with SMTP id 98e67ed59e1d1-3ae897db69bmr1719767a91.50.1793367067997;
        Fri, 30 Oct 2026 06:31:07 -0700 (PDT)
X-Received: by 2002:a17:90b:134f:b0:3a5:c08:4c41 with SMTP id 98e67ed59e1d1-3ae897db69bmr1719717a91.50.1793367066952;
        Fri, 30 Oct 2026 06:31:06 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:31:06 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 14/16] wifi: nl80211/cfg80211: add support for NDP confirm indication
Date: Fri, 30 Oct 2026 19:00:10 +0530
Message-Id: <20261030133012.3009774-15-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: aMrgQ-Cwsfq_OdtICAW6Mbjtv_Pjpxrk
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX3aTin7cdJ7nP
 k3VwtU9D1J4kt00fD411d4OpgVRinarM44v9zIfb61ktyuRNN47G2P8+nkTDNKZMTVEIDRAttMN
 g1j1YVQDze3BiKYBhW13BmKDUx5hqB0=
X-Authority-Analysis: v=2.4 cv=DfSCOftW c=1 sm=1 tr=0 ts=6ae49c1d cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=g2rSZhvOyYkLztQbP8cA:9 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: aMrgQ-Cwsfq_OdtICAW6Mbjtv_Pjpxrk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX0Cry/G0vqimf
 3fMwUWuL9GWs+BfYL1R+risbuHLDI/qfIq7jzy/2vy7Tuj/lRbAx5U14hfg2c44qlS5eTYfWGJ3
 3kisck22JfoPnFlFKDTkKeN1KxDgb5o8do7rt+YmBvxOHjceCIQjXi5YUAqGczVjY/lCbxfBBaF
 5LJRPuIMnthIwc2v/NgvIKaEnjx/mcQ5QDr1autrtdAAVVx20gSAynWiL2G9CxEOHTl/3hGnkFZ
 vSYPinB2V4qQUjnV/ujdwa8Ozjs5JgYA1n3kuyKeOPhPH4hAjL1RTBcbSlbrNtBb7izp3QT/oNe
 jc6+Xi4ygazq5HcjEVldA5VLqu/KU1dpWz+CM7TrYarUK+IJ3SLckwHd5WnaB2LRmKFgM6Tk+iG
 ZqPqUw4sdYzFMx5fZhPYyt8fRSR8m9I5MkqQlPTh69rrrEmHnMaBshOlBnmucrdela2u8rnXjfQ
 XUTHUClAX7PF7+CYvAg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 adultscore=0 priorityscore=1501 spamscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300053

Add NL80211_CMD_NAN_NDP_CONFIRM event to notify userspace when NDP
setup completes. Add the corresponding parameter structure and event
function so the driver can report the accept/reject status and, if
accepted, the responder NDI address.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 45 ++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 24 ++++++++++++
 net/wireless/nl80211.c       | 75 ++++++++++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index cb9431ab1637..885a89b85794 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4477,6 +4477,37 @@ struct cfg80211_nan_ndp_request_params {
 	bool ndpe;
 };
 
+/**
+ * struct cfg80211_nan_ndp_confirm_params - NAN NDP confirm event parameters
+ *
+ * Sent to userspace after the driver completes NDP setup.
+ *
+ * @peer_nmi: peer NMI address
+ * @ndp_id: NDP ID
+ * @init_ndi: initiator NDI MAC address
+ * @resp_ndi: responder NDI MAC address (valid when @accepted is true)
+ * @accepted: if true, NDP was accepted; if false, rejected
+ * @reason: rejection reason (valid when @accepted is false)
+ * @ssi: response service-specific info (may be NULL)
+ * @ssi_len: length of @ssi
+ * @ipv6_intf_id: peer's IPv6 link-local interface identifier
+ *	(%NL80211_NAN_NDP_IPV6_INTF_ID_LEN bytes,
+ *	valid when @ipv6_intf_id_set is true)
+ * @ipv6_intf_id_set: if true, @ipv6_intf_id is valid
+ */
+struct cfg80211_nan_ndp_confirm_params {
+	const u8 *peer_nmi;
+	u8 ndp_id;
+	const u8 *init_ndi;
+	const u8 *resp_ndi;
+	bool accepted;
+	u8 reason;
+	const u8 *ssi;
+	u8 ssi_len;
+	u8 ipv6_intf_id[NL80211_NAN_NDP_IPV6_INTF_ID_LEN];
+	bool ipv6_intf_id_set;
+};
+
 /**
  * enum cfg80211_nan_conf_changes - indicates changed fields in NAN
  * configuration
@@ -11373,6 +11404,20 @@ void cfg80211_nan_ndp_request(struct wireless_dev *wdev,
 			      struct cfg80211_nan_ndp_request_params *params,
 			      gfp_t gfp);
 
+/**
+ * cfg80211_nan_ndp_confirm - notify userspace that NDP setup is complete
+ * @wdev: the wireless device reporting the event
+ * @params: NDP confirm parameters
+ * @gfp: allocation flags
+ *
+ * Notify userspace that NAN Data Path setup is complete. Includes the
+ * accept/reject status and, if accepted, the responder NDI. Only valid
+ * when %WIPHY_NAN_FLAGS_OFFLOAD_NDP is set.
+ */
+void cfg80211_nan_ndp_confirm(struct wireless_dev *wdev,
+			      struct cfg80211_nan_ndp_confirm_params *params,
+			      gfp_t gfp);
+
 /**
  * cfg80211_incumbent_signal_notify - Notify userspace of incumbent signal detection
  * @wiphy: the wiphy to use
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 767e5cf18196..46af2b57466a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1488,6 +1488,12 @@
  *	%NL80211_ATTR_MAC (peer NMI) and %NL80211_ATTR_NAN_NDP nested with
  *	all parsed NDP request parameters. Userspace must ensure the NDI
  *	interface is ready before calling %NL80211_CMD_NAN_NDP_RESPOND.
+ * @NL80211_CMD_NAN_NDP_CONFIRM: Notification sent to userspace after
+ *	the driver completes NDP setup and installs data path keys. Carries
+ *	%NL80211_ATTR_MAC (peer NMI) and %NL80211_ATTR_NAN_NDP nested with
+ *	the NDP confirm parameters including %NL80211_NAN_NDP_ATTR_RESP_NDI.
+ *	Userspace should call %NL80211_CMD_NEW_STATION on the NDI interface
+ *	to add the peer NDI station.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1775,6 +1781,7 @@ enum nl80211_commands {
 	NL80211_CMD_NAN_NDP_RESPOND,
 	NL80211_CMD_NAN_NDP_TERMINATE,
 	NL80211_CMD_NAN_NDP_REQUEST,
+	NL80211_CMD_NAN_NDP_CONFIRM,
 
 	/* add new commands above here */
 
@@ -8126,6 +8133,8 @@ enum nl80211_nan_conf_attributes {
  *	rejected.
  * @NL80211_NAN_NDP_ATTR_REASON: (u8) Termination or rejection reason
  *	code (enum nan_reason from the Wi-Fi Aware Specification).
+ * @NL80211_NAN_NDP_ATTR_STATUS: (u8) NDP status in
+ *	%NL80211_CMD_NAN_NDP_CONFIRM, see &enum nl80211_nan_ndp_status.
  * @__NL80211_NAN_NDP_ATTR_LAST: Internal.
  * @NL80211_NAN_NDP_ATTR_MAX: Highest NDP attribute.
  */
@@ -8147,12 +8156,27 @@ enum nl80211_nan_ndp_attributes {
 	NL80211_NAN_NDP_ATTR_NDPE,
 	NL80211_NAN_NDP_ATTR_ACCEPT,
 	NL80211_NAN_NDP_ATTR_REASON,
+	NL80211_NAN_NDP_ATTR_STATUS,
 
 	/* keep last */
 	__NL80211_NAN_NDP_ATTR_LAST,
 	NL80211_NAN_NDP_ATTR_MAX = __NL80211_NAN_NDP_ATTR_LAST - 1,
 };
 
+/**
+ * enum nl80211_nan_ndp_status - NAN Data Path setup status
+ *
+ * Values for %NL80211_NAN_NDP_ATTR_STATUS reported in
+ * %NL80211_CMD_NAN_NDP_CONFIRM.
+ *
+ * @NL80211_NAN_NDP_STATUS_ACCEPTED: NDP setup was accepted by the peer.
+ * @NL80211_NAN_NDP_STATUS_REJECTED: NDP setup was rejected by the peer.
+ */
+enum nl80211_nan_ndp_status {
+	NL80211_NAN_NDP_STATUS_ACCEPTED,
+	NL80211_NAN_NDP_STATUS_REJECTED,
+};
+
 /**
  * enum nl80211_external_auth_action - Action to perform with external
  *     authentication request. Used by NL80211_ATTR_EXTERNAL_AUTH_ACTION.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 36c32c434b44..be26d6e19290 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -796,6 +796,7 @@ nl80211_nan_ndp_policy[NL80211_NAN_NDP_ATTR_MAX + 1] = {
 	[NL80211_NAN_NDP_ATTR_NDPE] = { .type = NLA_FLAG },
 	[NL80211_NAN_NDP_ATTR_ACCEPT] = { .type = NLA_FLAG },
 	[NL80211_NAN_NDP_ATTR_REASON] = { .type = NLA_U8 },
+	[NL80211_NAN_NDP_ATTR_STATUS] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
@@ -18894,6 +18895,80 @@ void cfg80211_nan_ndp_request(struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL(cfg80211_nan_ndp_request);
 
+void cfg80211_nan_ndp_confirm(struct wireless_dev *wdev,
+			      struct cfg80211_nan_ndp_confirm_params *params,
+			      gfp_t gfp)
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
+	if (WARN_ON_ONCE(params->accepted && !params->resp_ndi))
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NAN_NDP_CONFIRM);
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
+	    nla_put_u8(msg, NL80211_NAN_NDP_ATTR_STATUS,
+		       params->accepted ? NL80211_NAN_NDP_STATUS_ACCEPTED :
+					   NL80211_NAN_NDP_STATUS_REJECTED))
+		goto nla_put_failure;
+
+	if (params->accepted && params->resp_ndi &&
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_RESP_NDI, ETH_ALEN,
+		    params->resp_ndi))
+		goto nla_put_failure;
+
+	if (!params->accepted &&
+	    nla_put_u8(msg, NL80211_NAN_NDP_ATTR_REASON, params->reason))
+		goto nla_put_failure;
+
+	if (params->ssi && params->ssi_len &&
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_SSI, params->ssi_len,
+		    params->ssi))
+		goto nla_put_failure;
+
+	if (params->ipv6_intf_id_set &&
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_IPV6_INTF_ID,
+		    NL80211_NAN_NDP_IPV6_INTF_ID_LEN, params->ipv6_intf_id))
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
+EXPORT_SYMBOL(cfg80211_nan_ndp_confirm);
+
 static bool nl80211_nan_is_sched_empty(struct cfg80211_nan_local_sched *sched)
 {
 	if (!sched->n_channels)
-- 
2.34.1

