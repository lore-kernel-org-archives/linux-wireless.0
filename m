Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367068;
	b=d6WsK/F6/fZWXupI+BzjHWTLS0kjphMaf1rQlYuiL6pXp0qQ/L3zWcRqM9vLRod775Dn
	 JzUb9tck7GZ+ZPqIZ3fH4WTLR4I+A9RUvqYwJ74fsCKhHY2j2OSW9cUf24WhehtsE031w
	 0x8ui4ofjK14pEttNCV4hsKV8GVP7KBHzg1nsK1Et3tqD9/Yk/vsvV2mH5EcnCBSSpljx
	 BYMKbWpgKHutAQeBZ0cYNzgGYIk8HdGpUdkLvDlzJuTHqMfWVz+Ak8rJEyoa78zlpON3E
	 Z1oJYP0kLCADNWNBJ4xJSFKkZVMqbOMRAIKIbGfGNOn00J/JWybTjY1IQcd9CRAz01g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367068;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=yfxtCOk9lgPl+pMM2GgwwBpesmOT2HMtQX2QXIbrUDI=;
	b=vSJreo2CyCiboMiIRSSwQlBxyhwoVVK83vhav7Z1h8P3On68IzNE64Qo7DOqecYw0oTh
	 fe5hFzUn+veSL+bm8bvOo48ZFRTV8Y+KDJLAGIbq2W7UoewT37padeIiMlv3Q96GgiA7O
	 UFnCCLr+zoSakky80ieOGt8xnlsbnqMUU83NTNQT+QztBE6c6jkOzRpTapQUYzO6S6ZCB
	 k5mJG9DT6jPdSY/6DV6KpocioBIT/CvOsp852R3hxDggD6f01opt6ji/YaplMc1aaPaQA
	 stLWx6OZQN2uogOtAgF0MMwZswtaS2s7fZVz5KL5s53/FOCkmrY1URYvJ6R5R8i0bBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UhkgJ+4X;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DYS80ted;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B01606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6B01606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UhkgJ+4X;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DYS80ted
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBG1hU2071574
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=yfxtCOk9lgP
	l+pMM2GgwwBpesmOT2HMtQX2QXIbrUDI=; b=UhkgJ+4XdmbH/exnc5S7s1IWJ/X
	L+PsH1mzdwHwxpP7CQMO9clW/x8Y74Voy2T7l7A+XmAVbHKg5FxuZ0sW9Rpq4Gm7
	UE8qN71qAUR/Yt2V+xMsUJ+h5Q2Tp3+Uj0BnRA40DVNOXXvJ5LYskPOSNl8W9wPA
	5KhFG6peAOdAHOTpD2/5qn82D0cG9Qsq9sxxBSxix2TccrWKBPkJJm1FkqR9Jwag
	POESCSBWwpCpsUJzTjylHx1ZrSkvAtGhuJh11C2XDin+8dtonZB0GM7gW1WduFX+
	0FQ3EyFK2Mvu/5XN1YktWeVspM17EYMQXo9nhX5cDwEsTFdRSW3BAtJSjvQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6p3932-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:06 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ada6ccd402so749269a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367066; x=1793971866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yfxtCOk9lgPl+pMM2GgwwBpesmOT2HMtQX2QXIbrUDI=;
        b=DYS80tedZHUowSuxwTQqal9q4ORl6A0R2ucQIVDAiVUm6JV39WWgVOWR/n4ZJuAOp4
         hXnYCxnNXYyr9QOHW3+wk/ni2fcAHLB3VkXzr9mUOb2c0qFxr6tDvVzQ0t8R2gEEcOu2
         fvqyBEB45tqPl6DaHpoZcu+TW+xOb8kY2FqEUfuSnv05Oqf6e1nYEiKtykZ24SbHxk77
         TISLTRteVHR3yl+eK3mXHMp97C5pudoLoJG9mkeGr+FN1LUrWi6qUrqLxsHADlyJ3UfD
         g/24MiMsvCcLW1ujZ1Ns/hARy+Pj+QS6zbzC0BIUZYHTxS8M7uQOTf4i55Wd/KnuHAWq
         RvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367066; x=1793971866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yfxtCOk9lgPl+pMM2GgwwBpesmOT2HMtQX2QXIbrUDI=;
        b=jtMUEOnFzp2ELWa2UMkib0oONvPLMPLSKsQPKhPH8lC4Yl9lWMvGUZfkSrBZSPt8WP
         XVXXBf5hkiO6UuRW8k0lBu2KyxAyJCUxECc4EWi+T2M2rwEST7SZNEx4PYFVDtjuywjG
         gEU+sr2q7k9wBAzkuexCxKisROBypC3AQDR5d44KmOHYRJcyJ4uC/1m+Fi9zVTVwQ1hz
         aT1+j5BAa1J1I3WoZ65Xa3eBBOmO89sj0hHOGQ1aIne8BEiUAiqTlRGxlDjxxt1DdR3t
         r5ToIKDpDs6WPg8wk8XKVOKfMjqr5BOcknfNCpValDfBIss4E0c8qiOnANUp6vCprDeV
         hnJw==
X-Gm-Message-State: AFq9FYLP9uYbEyXO2r2xWRHt8yKorUif/WOTufK1KcdIgG6cQ++okM/M
	0GFXdQQBAFx3+WNVK29BH31nQqhqMbhQxbTPLrYmpp69UYUlXLf3bB5QAAdxFy157gD3KIA9HIU
	QBBIiBDBtTefdufojxQCYwYZVEuuh7ttJOUDFMriYQg3IhPMgctoVtaErlxlVpVG5W8VlMw==
X-Gm-Gg: AYBFou0rbPBxXC4Z4ehGgOEZF+2UJTk3kPdt26ohY6FO2+N9MpJ1d9T5X9n7UhOc7Ue
	c0t6n1D9xKks1134XSwSvWzptwEAM/3JzaFz3C1ZPaa2bpq6XpVM44Pp1v0bqIgOsINw6njNVBG
	JhkYR7aDJxbyjVTJxxFjoVwSldCK3VZk+btm/8qnGkJ/xG4lDrDsBxH0eH87sKIFZwEOv9f7lSb
	AJx+qvPZ6QcWxbix++o1Daonsm5mTMa73NlqZkdxLJwnU3GZWjsEUFzU7USaqQPfSMPW9jjjPuV
	Vn2k40sM56rpoUqPU/JC9jZ4AOxuLrEC0DvqJoFbpH54a1O0N++EHIAE9cimCxkhqZNdSq3imul
	SCEDFTrxlgA95NRHsaG5X8f1Rf2BADxJZ27oO5RZ6MmJuViVLHeFOyjvyoF0WFLZnEXvDz0C/J3
	a2tzdzQd0Feg==
X-Received: by 2002:a17:90b:4b8a:b0:3ac:1c76:61c3 with SMTP id 98e67ed59e1d1-3ae8974656dmr1761411a91.27.1793367065264;
        Fri, 30 Oct 2026 06:31:05 -0700 (PDT)
X-Received: by 2002:a17:90b:4b8a:b0:3ac:1c76:61c3 with SMTP id 98e67ed59e1d1-3ae8974656dmr1761376a91.27.1793367064614;
        Fri, 30 Oct 2026 06:31:04 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:31:04 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 13/16] wifi: nl80211/cfg80211: add support for NDP request indication
Date: Fri, 30 Oct 2026 19:00:09 +0530
Message-Id: <20261030133012.3009774-14-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX5SN6qqFXndkO
 HTSYH3Wf2mBa/x1FNfschX8EK1QWYbYPCVA/QcyA2gAb2BpoDRocNlkfJLNjGOeh+eX2fW5v8iC
 1BDumqVLCsT800xNQDD4dio5ARL7bRIn9js4YIKlkUtMMruVjQOyMJaXs6UM3e08/slESgRcS2Y
 CbCd/y7pRhP7nkyXEHKP46MRMhyEXnv/AED4AabecqlZDXXcsALd+m0zKHn6/BoG9f54Kym5Ew8
 RFwut4u/rXK7TE00uSkn1jeuUXI7FBHyueJeLlen8de/4CfzVxN3/+GQuf64Ca0mTHevyWnOSnf
 Vwc8LtsXMsgXDxWcwVitsM0dKKrZLhYEVWejSO9DuPoosuDYMXjYa72QRhQ1so+616TDo+IZRPU
 Hpk4/tXfi3mu16WFlyNXPrwEIR4cPkclFc+0ijstG3mRcx0R5CuZC4/R3dSf571iVjyZLidNtD5
 Hofm3MGlio/KGARp/EQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfXzTWzD2B/wEmg
 TMIEvJWA3USVVyV/kyX0VdNKTrVHr3co/hP7Bk91l0ezQeNr4CoPKst6Bd0T9FpZe5mM+lnW2zC
 wLkVP5EFad8ri9hi6tEekvJDqG6eVzA=
X-Proofpoint-ORIG-GUID: l0IpElfUoAAYct4ysLyFs9zv_8GzSQUX
X-Proofpoint-GUID: l0IpElfUoAAYct4ysLyFs9zv_8GzSQUX
X-Authority-Analysis: v=2.4 cv=TL3Q2Fla c=1 sm=1 tr=0 ts=6ae49c1a cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=Q-RXIXx9LWi5T1gvJX8A:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610300053

Add NL80211_CMD_NAN_NDP_REQUEST event to notify userspace when the
driver receives an incoming NDP request from a peer. Add the
corresponding parameter structure and event function so the driver
can report the request parameters to userspace for accept/reject
decision.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 51 +++++++++++++++++++++++
 include/uapi/linux/nl80211.h |  6 +++
 net/wireless/nl80211.c       | 79 ++++++++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 49091633ef4a..cb9431ab1637 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4439,6 +4439,44 @@ struct cfg80211_nan_ndp_terminate {
 	u8 reason;
 };
 
+/**
+ * struct cfg80211_nan_ndp_request_params - NAN NDP request event parameters
+ *
+ * Sent to userspace when the driver receives a NDP Request frame.
+ *
+ * @peer_nmi: peer NMI address
+ * @ndp_id: NDP ID from the received frame
+ * @init_ndi: initiator NDI MAC from the received frame
+ * @publish_id: publisher's service instance ID
+ * @ssi: service-specific info (may be NULL)
+ * @ssi_len: length of @ssi
+ * @cipher_suite: initiator's cipher suite ID
+ * @pmkid: PMKID from the peer's SCIA (%NL80211_NAN_NDP_PMKID_LEN bytes,
+ *	valid when @pmkid_set is true)
+ * @pmkid_set: if true, @pmkid is valid
+ * @gtk_required: if true, initiator requires GTK protection
+ * @ipv6_intf_id: initiator's IPv6 link-local interface identifier
+ *	(%NL80211_NAN_NDP_IPV6_INTF_ID_LEN bytes,
+ *	valid when @ipv6_intf_id_set is true)
+ * @ipv6_intf_id_set: if true, @ipv6_intf_id is valid
+ * @ndpe: if true, use NDPE attribute instead of NDP attribute
+ */
+struct cfg80211_nan_ndp_request_params {
+	const u8 *peer_nmi;
+	u8 ndp_id;
+	const u8 *init_ndi;
+	u8 publish_id;
+	const u8 *ssi;
+	u8 ssi_len;
+	u32 cipher_suite;
+	u8 pmkid[NL80211_NAN_NDP_PMKID_LEN];
+	bool pmkid_set;
+	bool gtk_required;
+	u8 ipv6_intf_id[NL80211_NAN_NDP_IPV6_INTF_ID_LEN];
+	bool ipv6_intf_id_set;
+	bool ndpe;
+};
+
 /**
  * enum cfg80211_nan_conf_changes - indicates changed fields in NAN
  * configuration
@@ -11322,6 +11360,19 @@ cfg80211_s1g_get_primary_sibling(struct wiphy *wiphy,
 }
 
 
+/**
+ * cfg80211_nan_ndp_request - notify userspace of a received NDP request
+ * @wdev: the wireless device reporting the event
+ * @params: NDP request parameters parsed from the received frame
+ * @gfp: allocation flags
+ *
+ * Notify userspace that a NAN Data Path request was received from a peer.
+ * Only valid when %WIPHY_NAN_FLAGS_OFFLOAD_NDP is set.
+ */
+void cfg80211_nan_ndp_request(struct wireless_dev *wdev,
+			      struct cfg80211_nan_ndp_request_params *params,
+			      gfp_t gfp);
+
 /**
  * cfg80211_incumbent_signal_notify - Notify userspace of incumbent signal detection
  * @wiphy: the wiphy to use
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7e735731ccd5..767e5cf18196 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1483,6 +1483,11 @@
  *	Requires %WIPHY_NAN_FLAGS_OFFLOAD_NDP. Carries %NL80211_ATTR_NAN_NDP
  *	nested with %NL80211_NAN_NDP_ATTR_ID, %NL80211_NAN_NDP_ATTR_INIT_NDI
  *	and optionally %NL80211_NAN_NDP_ATTR_REASON.
+ * @NL80211_CMD_NAN_NDP_REQUEST: Notification sent to userspace when
+ *	the driver receives a NDP Request frame from a peer. Carries
+ *	%NL80211_ATTR_MAC (peer NMI) and %NL80211_ATTR_NAN_NDP nested with
+ *	all parsed NDP request parameters. Userspace must ensure the NDI
+ *	interface is ready before calling %NL80211_CMD_NAN_NDP_RESPOND.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1769,6 +1774,7 @@ enum nl80211_commands {
 	NL80211_CMD_NAN_NDP_INITIATE,
 	NL80211_CMD_NAN_NDP_RESPOND,
 	NL80211_CMD_NAN_NDP_TERMINATE,
+	NL80211_CMD_NAN_NDP_REQUEST,
 
 	/* add new commands above here */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 754c753f905a..36c32c434b44 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18815,6 +18815,85 @@ static int nl80211_nan_ndp_terminate(struct sk_buff *skb,
 	return rdev_nan_ndp_terminate(rdev, wdev, &params);
 }
 
+void cfg80211_nan_ndp_request(struct wireless_dev *wdev,
+			      struct cfg80211_nan_ndp_request_params *params,
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
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NAN_NDP_REQUEST);
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
+	    nla_put_u8(msg, NL80211_NAN_NDP_ATTR_PUBLISH_ID,
+		       params->publish_id))
+		goto nla_put_failure;
+
+	if (params->ssi && params->ssi_len &&
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_SSI, params->ssi_len,
+		    params->ssi))
+		goto nla_put_failure;
+
+	if (params->cipher_suite &&
+	    nla_put_u32(msg, NL80211_NAN_NDP_ATTR_CIPHER_SUITE,
+			params->cipher_suite))
+		goto nla_put_failure;
+
+	if (params->pmkid_set &&
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_PMKID,
+		    NL80211_NAN_NDP_PMKID_LEN, params->pmkid))
+		goto nla_put_failure;
+
+	if (params->gtk_required &&
+	    nla_put_flag(msg, NL80211_NAN_NDP_ATTR_GTK_REQUIRED))
+		goto nla_put_failure;
+
+	if (params->ipv6_intf_id_set &&
+	    nla_put(msg, NL80211_NAN_NDP_ATTR_IPV6_INTF_ID,
+		    NL80211_NAN_NDP_IPV6_INTF_ID_LEN, params->ipv6_intf_id))
+		goto nla_put_failure;
+
+	if (params->ndpe &&
+	    nla_put_flag(msg, NL80211_NAN_NDP_ATTR_NDPE))
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
+EXPORT_SYMBOL(cfg80211_nan_ndp_request);
+
 static bool nl80211_nan_is_sched_empty(struct cfg80211_nan_local_sched *sched)
 {
 	if (!sched->n_channels)
-- 
2.34.1

