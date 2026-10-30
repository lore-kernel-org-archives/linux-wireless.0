Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367061;
	b=yBNun5aNcV0YJBoyTXFgmhM61kgyb0yjrSd7cpd20fPMWJtlQ3td0OxEElWeqsc1Oz4f
	 5YZCnd+35f2qFMoo4V7kaqJwYAk9uY7JN2uTa3tSeOgAM2mSvSbZfSsVDXVPmEWiPTOKp
	 Rk0+TcY5QXVbQvjT4n8ukPb+H2AP77PmZY72ISQNZa+kute7NMQbYyWD8XK8G02ZBFbZN
	 pWBWCAikhYyCJNEAvtfuceBazwj2wMLdJP8vM5YE4qU/Kd97N3fa7U5URaXMjOXFepfNY
	 OFkbqI7y0TcXAS+idgD/qtK8rLNJ69H3RxQ/66vAnfgeS3YuMkhvo86kUTl1vmrAP6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367061;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=mrapMG9sDw1QE+TlqIEYVqRpYnmyJi5k+Ml+13/DIGk=;
	b=dRIFJTpE4NXJI0k+ITbxifnOAf8i3CAZYC/AuzICS5lTIjcDAw36Er3xw3u9Z7tTeELF
	 fSQCDHwTOYoh+Ig1GEHCqoqqtQS3CQPVxxn5GnwmuM1pHZrX7DqV29Qd1eXdWPpuiNz5e
	 I3jSbn/TV4lQuR2Vsb3RyUlMrHcOFpCs0tegfixw6o8sCUNUFkOpOcQ+5n8CsmSuHOUP3
	 MB1MQ/bCk1oqYrXgrB1mca+feC6L+Z+Ueu7k8vOEdn9iZLFsANoYRYX+LPcoYfyj5ZYR2
	 kIywbKZ4HPiFa5YWzah+IuvuaWVXV1lB3qTjqN5any6yucswiiUkdbKosfOxlTzsNeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="HM/iNSJ7";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="FIs+az/A";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808E8606A31E
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 808E8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HM/iNSJ7;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FIs+az/A
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBGWAe3679093
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=mrapMG9sDw1
	QE+TlqIEYVqRpYnmyJi5k+Ml+13/DIGk=; b=HM/iNSJ7OtRHqdGl2PXMbI7xXh7
	rJ8c3vCioXD279ZzCtdIkrBP7qnUvnE77WghQNkDQPnpT6q8HWSNKJJWTRv3xtsv
	YOc0ZbOikoFPqdGvxpcNYqi5PYxo2vzDjkm2Kog4X6o4cE6Wr4R1IguRkvBbaRsL
	A8ZifFZg8sqGUnyQpvzYrIRjWJVVU83OpQPmcyhG5npnr11bss9430YvDyQNc61r
	0EAQUNMVC8DRSXWcUgXWDgDbg4hY6aUwFDYIpjN7qYm+cErLpYgzNpb72RdHz7A3
	BSRrn5IHP9YQZYzLSIAQzRL0X5uLu7ok/ibXwKHFe4wxs6k6p4d1mqeeZeg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qk7ya-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:59 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ad7030e886so828884a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367058; x=1793971858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mrapMG9sDw1QE+TlqIEYVqRpYnmyJi5k+Ml+13/DIGk=;
        b=FIs+az/AXF0Z51RA3AGBuW/5RYDGLFNyj8pVkrdr170ZlCbqTPTYjDr5b9L7ebktme
         1r54afIKd06+Cl6C0XEiPrPwneXRsVqXPBD1LzOO+iFBHdTtIujXpBGyRBlt3colGP7S
         aSDeeOup8pUAXmpfqNldtsCgFgcXqFtSmZs47OuE7L+wIgJei1hMRtV70ZWFPs3RpFMc
         NxpixuapuMOa3P5tgTv80oPECgrAQV97Hke/Vf7ekNINleKdY71RluPwOQddW2t42x9p
         Yqs3d6on5XwvkQbUP6PG99FzHR9JaCfIBmUj9KGzuSh9YQA09cdBe38oMyq5ojXbsgzn
         zQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367058; x=1793971858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mrapMG9sDw1QE+TlqIEYVqRpYnmyJi5k+Ml+13/DIGk=;
        b=bdlh3S6mBiPnlQlNqYZLNmpuXf29TS1VF01lNZ8UzAl0YQJyAb3zQOMyhf6AYQO/+r
         n+m3aHeZ4RU/c24bTTeeAaCnZVdvu8SpU82NDIn2CM9iJtpuXb1k9GKTyN/93AeWVirj
         W2EDwC0p0TGKPN48f+UhE1PMAbocx4ngcTAQtxGKeQhy9c9TIpiG4KegVCLEGXKiMjjd
         x4LRCClgR0jrAodFJ0kleHWXwfu0FEkEXhY0JkjSR1B7chgbx/XcEjFWBdIAk1NjWZag
         hXxS+024GOzwVRbp3cX+BhctDm8hBKpRlUCEOhJOywW1k+vychgPdX6qEG2QL0Hsll0G
         10rA==
X-Gm-Message-State: AFq9FYLNHydHQaW1RbsK2VRvGluzH/aKFuhsxJq5iS+8rkLBxj8cMo1z
	5joyXL1UVfEgW6ZkKo2LK7vL469WooJgCRKrH17fgoz0TX/+l8VkbjxIQYpSfbsMheCNMMOeRGp
	GyWBLxyzpyx+ZfLvXByPM4QnfDbYgQdO0Qxz1Tl5HBgifKRHiJymUhxoIBSSCXsLbnJPwyQ==
X-Gm-Gg: AYBFou10mmGYK342Q5ZsLhUWUc867rSI6ycLIK09UJL0cFzPZEyILgDwDlGKWn1Mybo
	iEYIfUVNdzem7f+CFXpSz4jmmCThmmBPKwR2sEyrlRpQtuKclJQO6rcVhU6UkRzt16Zvg1Y9sdg
	gne+ekXnsrM4Y5th1Y6x6Lc5uGMYuYBVWvYbpHf2o8hmdx+Jg3NOB0Oojg+QMqx4rHN+5OtpJML
	OuFrg5OoaCOZqt27awOJAshaNynXJ9mD8/jpNj26/UKBNyR7HA6+ptQsCvqrSBvWLHgb5HNaLYC
	n3Bqg6QL0xdH3HrrnuIv8cTrO114z2kA+/HFa2qr3cNgh+WDi+uLHykeOuFr/OG0H/PmTo0DW/B
	sIm8vzPs+FlE02vIBhTBjFnv7sK97Z9ARipESaGpp2kKpLJsVjhwLsYbWE+De+NTCgldZ+1TPLt
	8hVtts25rVVQ==
X-Received: by 2002:a17:90b:53ce:b0:3ac:7c52:fae5 with SMTP id 98e67ed59e1d1-3ae89835706mr1847697a91.50.1793367058090;
        Fri, 30 Oct 2026 06:30:58 -0700 (PDT)
X-Received: by 2002:a17:90b:53ce:b0:3ac:7c52:fae5 with SMTP id 98e67ed59e1d1-3ae89835706mr1847662a91.50.1793367057463;
        Fri, 30 Oct 2026 06:30:57 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:30:57 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 10/16] wifi: nl80211/cfg80211: add support for NDP initiation in offload mode
Date: Fri, 30 Oct 2026 19:00:06 +0530
Message-Id: <20261030133012.3009774-11-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX9HrxO9Btcudy
 EDZtfcerMKvgSWSRBgZYZpNY5Oq/Lby2sXCKHIhVavUgiURWbOiGFH1aVgBxA8AGysypxLpzTuJ
 x0Tr8/RK2Q6p/+iVUP/QwSe7h4pZIpbSjs1Erj/NoTrsdegafvGezIRpIYpXJD+euJnR+/n4IZy
 x1SyO6bu8y3hc6eWIkTdMXp8tUxgRrdW73uXlIHfaFHIF7hS2DrhoGB+fNEyPivjdIYZmssManS
 ooaYFh389pzDvhTpE+Z81wTorq5Pkv/iC98ZiMYGPsIuFeM97uEShYd6JQCGkFzgLou5RCI6wha
 co2T9q6x87RNCfpSpBElqAgbSN3PK7lOF57RVXV2lTodxNBk2k1YOIAIJHjDB/9s/K/iNqMd42q
 KHY1tzfUkMYHr8V5Am1lMlJbmtkc8hEPeX8WagTyNScJNf7I1QYtXN0JeORIb4FKPKIvl3wH90c
 VwPE7Um3S3N6Gu4mlfA==
X-Proofpoint-ORIG-GUID: zUgTOvj5BpB1X_yy1_vHQCpYOie90uhM
X-Authority-Analysis: v=2.4 cv=IeoSymqa c=1 sm=1 tr=0 ts=6ae49c13 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=VNVH6czGhNIpz8ALsXYA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX8A1dEIZgG+yO
 S9+3/Xpe8aVX+kVb2TKtQ/7ufEwGJ+CQLOX6gDkJkMYzjRmNt1SQ40p+oZkjSkdIi9IUDE6vnf3
 ugjkglzzZfJkg6hKv7QO3Mp4P3LaBQA=
X-Proofpoint-GUID: zUgTOvj5BpB1X_yy1_vHQCpYOie90uhM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300053

Add NL80211_CMD_NAN_NDP_INITIATE to allow userspace to initiate a NAN
Data Path session when NDP management is offloaded to firmware. Add the
corresponding parameter structure, nl80211 policy, command handler, and
driver callback. Reject the request if the driver has not advertised
NDP offload capability or if security material is provided without
secure NAN support.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       |  50 +++++++++++
 include/uapi/linux/nl80211.h |  83 +++++++++++++++++++
 net/wireless/nl80211.c       | 156 +++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  16 ++++
 net/wireless/trace.h         |  22 +++++
 5 files changed, 327 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5d3f5cd8bed5..e5e58495d05c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4337,6 +4337,50 @@ struct cfg80211_nan_peer_sched {
 	struct cfg80211_nan_peer_map maps[CFG80211_NAN_MAX_PEER_MAPS];
 };
 
+/**
+ * struct cfg80211_nan_ndp_initiate - NAN NDP initiate parameters
+ *
+ * @peer_nmi: peer NMI address
+ * @publish_id: publisher's service instance ID
+ * @service_id: NAN service ID (%NL80211_NAN_FUNC_SERVICE_ID_LEN bytes)
+ * @init_ndi: initiator NDI MAC address. The corresponding
+ *	%NL80211_IFTYPE_NAN_DATA interface must exist.
+ * @ssi: service-specific info (may be NULL)
+ * @ssi_len: length of @ssi
+ * @cipher_suite: NAN cipher suite ID, 0 for open NDP
+ * @pmk: NAN Data Path PMK (%NL80211_NAN_NDP_PMK_LEN bytes,
+ *	valid when @pmk_set is true)
+ * @pmk_set: if true, @pmk contains a valid PMK
+ * @pmkid: PMKID (%NL80211_NAN_NDP_PMKID_LEN bytes,
+ *	valid when @pmkid_set is true)
+ * @pmkid_set: if true, @pmkid contains a valid PMKID
+ * @gtk_required: if true, GTK protection is required
+ * @gtk_cipher: GTK cipher suite ID (valid when @gtk_required is true)
+ * @ipv6_intf_id: IPv6 link-local interface identifier
+ *	(%NL80211_NAN_NDP_IPV6_INTF_ID_LEN bytes,
+ *	valid when @ipv6_intf_id_set is true)
+ * @ipv6_intf_id_set: if true, @ipv6_intf_id is valid
+ * @ndpe: if true, use NDPE attribute instead of NDP attribute
+ */
+struct cfg80211_nan_ndp_initiate {
+	const u8 *peer_nmi;
+	u8 publish_id;
+	u8 service_id[NL80211_NAN_FUNC_SERVICE_ID_LEN];
+	const u8 *init_ndi;
+	const u8 *ssi;
+	u8 ssi_len;
+	u32 cipher_suite;
+	u8 pmk[NL80211_NAN_NDP_PMK_LEN];
+	bool pmk_set;
+	u8 pmkid[NL80211_NAN_NDP_PMKID_LEN];
+	bool pmkid_set;
+	bool gtk_required;
+	u32 gtk_cipher;
+	u8 ipv6_intf_id[NL80211_NAN_NDP_IPV6_INTF_ID_LEN];
+	bool ipv6_intf_id_set;
+	bool ndpe;
+};
+
 /**
  * enum cfg80211_nan_conf_changes - indicates changed fields in NAN
  * configuration
@@ -5315,6 +5359,9 @@ struct mgmt_frame_regs {
  *	not included become evacuable again. All provided channels are
  *	guaranteed by cfg80211 to belong to the current local schedule.
  *
+ * @nan_ndp_initiate: Initiate a NAN Data Path session as the initiator.
+ *	Only valid if the driver has set %WIPHY_NAN_FLAGS_OFFLOAD_NDP.
+ *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
  *
  * @get_txq_stats: Get TXQ stats for interface or phy. If wdev is %NULL, this
@@ -5722,6 +5769,9 @@ struct cfg80211_ops {
 	int	(*nan_set_non_evac_channels)(struct wiphy *wiphy,
 					     struct wireless_dev *wdev,
 					     struct cfg80211_nan_non_evac_channels *channels);
+	int     (*nan_ndp_initiate)(struct wiphy *wiphy,
+				    struct wireless_dev *wdev,
+				    struct cfg80211_nan_ndp_initiate *params);
 	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    const bool enabled);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 154d76dbcb1c..4831da4fd253 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1468,6 +1468,13 @@
  *	and multiple can be nested in %NL80211_ATTR_MLO_LINKS but then the
  *	update isn't atomic if any failures happen.
  *	Only supported with %NL80211_EXT_FEATURE_UPDATE_BEACON.
+ *
+ * @NL80211_CMD_NAN_NDP_INITIATE: Initiate NAN Data Path (NDP) setup
+ *	as the initiator. Requires %WIPHY_NAN_FLAGS_OFFLOAD_NDP. The NDI
+ *	interface specified in %NL80211_NAN_NDP_ATTR_INIT_NDI must already
+ *	exist as a %NL80211_IFTYPE_NAN_DATA interface. Carries
+ *	%NL80211_ATTR_NAN_NDP nested with %NL80211_NAN_NDP_ATTR_* fields.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1750,6 +1757,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_UPDATE_BEACON,
 
+	NL80211_CMD_NAN_NDP_INITIATE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -3243,6 +3252,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_ASSOC_PROTECTED_TWT: Enable protected TWT for the association,
  *	requires protected TWT support (flag attribute)
  *
+ * @NL80211_ATTR_NAN_NDP: nested attribute carrying NAN Data Path parameters.
+ *	See &enum nl80211_nan_ndp_attributes.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3850,6 +3862,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_ASSOC_PROTECTED_TWT,
 
+	NL80211_ATTR_NAN_NDP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -8046,6 +8060,75 @@ enum nl80211_nan_conf_attributes {
 	NL80211_NAN_CONF_ATTR_MAX = NUM_NL80211_NAN_CONF_ATTR - 1,
 };
 
+#define NL80211_NAN_NDP_PMKID_LEN		16
+#define NL80211_NAN_NDP_IPV6_INTF_ID_LEN	8
+
+/**
+ * enum nl80211_nan_ndp_attributes - NAN Data Path attributes
+ *
+ * Nested attributes used within %NL80211_ATTR_NAN_NDP for NDP setup
+ * commands and events.
+ *
+ * @__NL80211_NAN_NDP_ATTR_INVALID: Invalid.
+ * @NL80211_NAN_NDP_ATTR_ID: (u8) NDP ID (1-255). Allocated by the
+ *	initiator and echoed in all subsequent NDP messages.
+ * @NL80211_NAN_NDP_ATTR_PUBLISH_ID: (u8) Publisher's service instance
+ *	ID. Present in %NL80211_CMD_NAN_NDP_INITIATE and
+ *	%NL80211_CMD_NAN_NDP_REQUEST. Used to match the NDP to a service.
+ * @NL80211_NAN_NDP_ATTR_SERVICE_ID: binary (%NL80211_NAN_FUNC_SERVICE_ID_LEN
+ *	bytes). NAN service ID derived from the service name.
+ * @NL80211_NAN_NDP_ATTR_INIT_NDI: (%ETH_ALEN bytes) Initiator NDI MAC
+ *	address. The corresponding %NL80211_IFTYPE_NAN_DATA interface must
+ *	exist.
+ * @NL80211_NAN_NDP_ATTR_RESP_NDI: (%ETH_ALEN bytes) Responder NDI MAC
+ *	address. Present in %NL80211_CMD_NAN_NDP_RESPOND (if accepting) and
+ *	%NL80211_CMD_NAN_NDP_CONFIRM. The corresponding
+ *	%NL80211_IFTYPE_NAN_DATA interface must exist.
+ * @NL80211_NAN_NDP_ATTR_SSI: binary. Service-specific info carried in
+ *	the NDP setup frames.
+ * @NL80211_NAN_NDP_ATTR_CIPHER_SUITE: (u32) NAN cipher suite ID. 0 for
+ *	open (no security). See the Wi-Fi Aware Specification for values.
+ * @NL80211_NAN_NDP_ATTR_PMK: binary (%NL80211_NAN_NDP_PMK_LEN bytes).
+ *	NAN Data Path PMK.
+ *	The driver uses this to compute the PMKID and derive the PTK.
+ *	Requires %NL80211_EXT_FEATURE_SECURE_NAN.
+ * @NL80211_NAN_NDP_ATTR_PMKID: binary (%NL80211_NAN_NDP_PMKID_LEN bytes).
+ *	PMKID from the peer's SCIA attribute. Present in
+ *	%NL80211_CMD_NAN_NDP_REQUEST to allow userspace to look up a cached PMK.
+ * @NL80211_NAN_NDP_ATTR_GTK_REQUIRED: flag. GTK/IGTK/BIGTK protection
+ *	required for group-addressed NDP frames.
+ * @NL80211_NAN_NDP_ATTR_GTK_CIPHER: (u32) GTK cipher suite ID. Required
+ *	if %NL80211_NAN_NDP_ATTR_GTK_REQUIRED is set.
+ * @NL80211_NAN_NDP_ATTR_IPV6_INTF_ID: binary (%NL80211_NAN_NDP_IPV6_INTF_ID_LEN
+ *	bytes). IPv6 link-local
+ *	interface identifier. Included as NDPE TLV type 0 when present.
+ * @NL80211_NAN_NDP_ATTR_NDPE: flag. Use NDPE attribute instead of NDP
+ *	attribute when peer supports NDPE.
+ * @__NL80211_NAN_NDP_ATTR_LAST: Internal.
+ * @NL80211_NAN_NDP_ATTR_MAX: Highest NDP attribute.
+ */
+enum nl80211_nan_ndp_attributes {
+	__NL80211_NAN_NDP_ATTR_INVALID,
+
+	NL80211_NAN_NDP_ATTR_ID,
+	NL80211_NAN_NDP_ATTR_PUBLISH_ID,
+	NL80211_NAN_NDP_ATTR_SERVICE_ID,
+	NL80211_NAN_NDP_ATTR_INIT_NDI,
+	NL80211_NAN_NDP_ATTR_RESP_NDI,
+	NL80211_NAN_NDP_ATTR_SSI,
+	NL80211_NAN_NDP_ATTR_CIPHER_SUITE,
+	NL80211_NAN_NDP_ATTR_PMK,
+	NL80211_NAN_NDP_ATTR_PMKID,
+	NL80211_NAN_NDP_ATTR_GTK_REQUIRED,
+	NL80211_NAN_NDP_ATTR_GTK_CIPHER,
+	NL80211_NAN_NDP_ATTR_IPV6_INTF_ID,
+	NL80211_NAN_NDP_ATTR_NDPE,
+
+	/* keep last */
+	__NL80211_NAN_NDP_ATTR_LAST,
+	NL80211_NAN_NDP_ATTR_MAX = __NL80211_NAN_NDP_ATTR_LAST - 1,
+};
+
 /**
  * enum nl80211_external_auth_action - Action to perform with external
  *     authentication request. Used by NL80211_ATTR_EXTERNAL_AUTH_ACTION.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6188102ade33..5ee053f53143 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -772,6 +772,30 @@ nl80211_nan_peer_map_policy[NL80211_NAN_PEER_MAP_ATTR_MAX + 1] = {
 		NLA_POLICY_EXACT_LEN(CFG80211_NAN_SCHED_NUM_TIME_SLOTS),
 };
 
+static const struct nla_policy
+nl80211_nan_ndp_policy[NL80211_NAN_NDP_ATTR_MAX + 1] = {
+	[NL80211_NAN_NDP_ATTR_ID] = NLA_POLICY_RANGE(NLA_U8, 1, 255),
+	[NL80211_NAN_NDP_ATTR_PUBLISH_ID] = { .type = NLA_U8 },
+	[NL80211_NAN_NDP_ATTR_SERVICE_ID] =
+		NLA_POLICY_EXACT_LEN(NL80211_NAN_FUNC_SERVICE_ID_LEN),
+	[NL80211_NAN_NDP_ATTR_INIT_NDI] = NLA_POLICY_EXACT_LEN(ETH_ALEN),
+	[NL80211_NAN_NDP_ATTR_RESP_NDI] = NLA_POLICY_EXACT_LEN(ETH_ALEN),
+	[NL80211_NAN_NDP_ATTR_SSI] = {
+		.type = NLA_BINARY,
+		.len = NL80211_NAN_FUNC_SERVICE_SPEC_INFO_MAX_LEN
+	},
+	[NL80211_NAN_NDP_ATTR_CIPHER_SUITE] = { .type = NLA_U32 },
+	[NL80211_NAN_NDP_ATTR_PMK] =
+		NLA_POLICY_EXACT_LEN(NL80211_NAN_NDP_PMK_LEN),
+	[NL80211_NAN_NDP_ATTR_PMKID] =
+		NLA_POLICY_EXACT_LEN(NL80211_NAN_NDP_PMKID_LEN),
+	[NL80211_NAN_NDP_ATTR_GTK_REQUIRED] = { .type = NLA_FLAG },
+	[NL80211_NAN_NDP_ATTR_GTK_CIPHER] = { .type = NLA_U32 },
+	[NL80211_NAN_NDP_ATTR_IPV6_INTF_ID] =
+		NLA_POLICY_EXACT_LEN(NL80211_NAN_NDP_IPV6_INTF_ID_LEN),
+	[NL80211_NAN_NDP_ATTR_NDPE] = { .type = NLA_FLAG },
+};
+
 static const struct nla_policy
 nl80211_nan_conf_policy[NL80211_NAN_CONF_ATTR_MAX + 1] = {
 	[NL80211_NAN_CONF_CLUSTER_ID] =
@@ -1196,6 +1220,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NAN_MAX_CHAN_SWITCH_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_NAN_PEER_MAPS] =
 		NLA_POLICY_NESTED_ARRAY(nl80211_nan_peer_map_policy),
+	[NL80211_ATTR_NAN_NDP] = NLA_POLICY_NESTED(nl80211_nan_ndp_policy),
 	[NL80211_ATTR_NPCA_PRIMARY_FREQ] = { .type = NLA_U32 },
 	[NL80211_ATTR_NPCA_PUNCT_BITMAP] =
 		NLA_POLICY_FULL_RANGE(NLA_U32, &nl80211_punct_bitmap_range),
@@ -18490,6 +18515,131 @@ static int nl80211_nan_set_peer_sched(struct sk_buff *skb,
 	return rdev_nan_set_peer_sched(rdev, wdev, &sched);
 }
 
+static int nl80211_nan_ndp_initiate(struct sk_buff *skb,
+				    struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	struct nlattr *tb[NL80211_NAN_NDP_ATTR_MAX + 1];
+	struct cfg80211_nan_ndp_initiate params = {};
+	int err;
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NDP initiate requires NAN interface");
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
+			       "NDP initiate requires peer NMI and NDP params");
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
+	if (!tb[NL80211_NAN_NDP_ATTR_INIT_NDI] ||
+	    !tb[NL80211_NAN_NDP_ATTR_PUBLISH_ID] ||
+	    !tb[NL80211_NAN_NDP_ATTR_SERVICE_ID]) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NDP initiate requires INIT_NDI, PUBLISH_ID and SERVICE_ID");
+		return -EINVAL;
+	}
+
+	params.peer_nmi = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	params.init_ndi = nla_data(tb[NL80211_NAN_NDP_ATTR_INIT_NDI]);
+	params.publish_id = nla_get_u8(tb[NL80211_NAN_NDP_ATTR_PUBLISH_ID]);
+	memcpy(params.service_id,
+	       nla_data(tb[NL80211_NAN_NDP_ATTR_SERVICE_ID]),
+	       NL80211_NAN_FUNC_SERVICE_ID_LEN);
+
+	if (tb[NL80211_NAN_NDP_ATTR_SSI]) {
+		params.ssi = nla_data(tb[NL80211_NAN_NDP_ATTR_SSI]);
+		params.ssi_len = nla_len(tb[NL80211_NAN_NDP_ATTR_SSI]);
+	}
+
+	if (tb[NL80211_NAN_NDP_ATTR_CIPHER_SUITE])
+		params.cipher_suite =
+			nla_get_u32(tb[NL80211_NAN_NDP_ATTR_CIPHER_SUITE]);
+
+	if (tb[NL80211_NAN_NDP_ATTR_PMK]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_SECURE_NAN)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_NAN_NDP_ATTR_PMK],
+					    "PMK requires SECURE_NAN feature");
+			return -EOPNOTSUPP;
+		}
+		memcpy(params.pmk,
+		       nla_data(tb[NL80211_NAN_NDP_ATTR_PMK]),
+		       NL80211_NAN_NDP_PMK_LEN);
+		params.pmk_set = true;
+	}
+
+	if (tb[NL80211_NAN_NDP_ATTR_PMKID]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_SECURE_NAN)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_NAN_NDP_ATTR_PMKID],
+					    "PMKID requires SECURE_NAN feature");
+			return -EOPNOTSUPP;
+		}
+		memcpy(params.pmkid,
+		       nla_data(tb[NL80211_NAN_NDP_ATTR_PMKID]),
+		       NL80211_NAN_NDP_PMKID_LEN);
+		params.pmkid_set = true;
+	}
+
+	if (tb[NL80211_NAN_NDP_ATTR_GTK_REQUIRED]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_SECURE_NAN)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_NAN_NDP_ATTR_GTK_REQUIRED],
+					    "GTK_REQUIRED requires SECURE_NAN feature");
+			return -EOPNOTSUPP;
+		}
+
+		if (!tb[NL80211_NAN_NDP_ATTR_GTK_CIPHER]) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_NAN_NDP_ATTR_GTK_REQUIRED],
+					    "GTK_CIPHER is required when GTK_REQUIRED is set");
+			return -EINVAL;
+		}
+
+		params.gtk_required = true;
+		params.gtk_cipher =
+			nla_get_u32(tb[NL80211_NAN_NDP_ATTR_GTK_CIPHER]);
+	} else if (tb[NL80211_NAN_NDP_ATTR_GTK_CIPHER]) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[NL80211_NAN_NDP_ATTR_GTK_CIPHER],
+				    "GTK_CIPHER requires GTK_REQUIRED");
+		return -EINVAL;
+	}
+
+	if (tb[NL80211_NAN_NDP_ATTR_IPV6_INTF_ID]) {
+		memcpy(params.ipv6_intf_id,
+		       nla_data(tb[NL80211_NAN_NDP_ATTR_IPV6_INTF_ID]),
+		       NL80211_NAN_NDP_IPV6_INTF_ID_LEN);
+		params.ipv6_intf_id_set = true;
+	}
+
+	params.ndpe = nla_get_flag(tb[NL80211_NAN_NDP_ATTR_NDPE]);
+
+	return rdev_nan_ndp_initiate(rdev, wdev, &params);
+}
+
 static bool nl80211_nan_is_sched_empty(struct cfg80211_nan_local_sched *sched)
 {
 	if (!sched->n_channels)
@@ -21642,6 +21792,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
 					 NL80211_FLAG_NO_WIPHY_MTX),
 	},
+	{
+		.cmd = NL80211_CMD_NAN_NDP_INITIATE,
+		.doit = nl80211_nan_ndp_initiate,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 7b8440c1f697..df8ec338e59d 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1189,6 +1189,22 @@ static inline void rdev_stop_pd(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int
+rdev_nan_ndp_initiate(struct cfg80211_registered_device *rdev,
+		      struct wireless_dev *wdev,
+		      struct cfg80211_nan_ndp_initiate *params)
+{
+	int ret;
+
+	if (!rdev->ops->nan_ndp_initiate)
+		return -EOPNOTSUPP;
+
+	trace_rdev_nan_ndp_initiate(&rdev->wiphy, wdev, params);
+	ret = rdev->ops->nan_ndp_initiate(&rdev->wiphy, wdev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int rdev_set_mac_acl(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev,
 				   struct cfg80211_acl_data *params)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 31000ffebe43..0da1c159315b 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2552,6 +2552,28 @@ TRACE_EVENT(rdev_nan_set_non_evac_channels,
 				__entry->n_channels, sizeof(u32)))
 );
 
+TRACE_EVENT(rdev_nan_ndp_initiate,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_nan_ndp_initiate *params),
+	TP_ARGS(wiphy, wdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__array(u8, peer_nmi, ETH_ALEN)
+		__field(u8, publish_id)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		memcpy(__entry->peer_nmi, params->peer_nmi, ETH_ALEN);
+		__entry->publish_id = params->publish_id;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
+		  ", peer: %pM, publish_id: %u",
+		  WIPHY_PR_ARG, WDEV_PR_ARG,
+		  __entry->peer_nmi, __entry->publish_id)
+);
+
 TRACE_EVENT(rdev_set_mac_acl,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 struct cfg80211_acl_data *params),
-- 
2.34.1

