Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFA81A9F90
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974090; cv=none; b=lkeFQfNBrpIuCSxmZ8qV5HGomL/NPTqxl1ENXncTe/gxr/Jya6lA5l4qYUlwmGiIal3Gl1IWf4V96wRrRF/5qolhUR6I9tKiCa4UZUayCtFlPX/4Arc/PYqc7LqqkcIkyr5esmBQa0GJZ3C0SpfWTOhvSB5lmaIkZyCO+/expYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974090; c=relaxed/simple;
	bh=ojzOJAYWTM36O9EcXyBl2FZdBi37uS13nstIy5DMz+0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RWv1U/zONOz+2GBaI+lM0cXqQQAZUBKRtY+yO/yjZXQ53Ub9fNmXT5fg9/wKCt9j07r1F1czyD1AovsGYRIjNtXAfGbCMb2w0//PhMMjdTZx/2WRzBkIjxOUZ2bGhLy8xUUf0MRhyjVuPQ6e532sLBBFkRa92Y/tiGEgh7ZFih0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=j0GcWf/z; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bOtvBQu5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="j0GcWf/z";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bOtvBQu5"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E9eB8X3696121
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=N89VJiT6zij
	quXpaMXNm+ZtC2GwcDssuVYO3pc6k5bw=; b=j0GcWf/zciZvI+V24MH8IMf3Al0
	b3g7wPndzntm7vcSxftO5rbgAzm61L0vEonN7+elNNNNb4ctYWWdH0zVjHaOESr9
	GogFXdrzsJfVupw3ahgM7/txaa/cu9E8rLgEQG2TN6GPkWo2LFSP30QnmYqshGLS
	nMtC1mlqdHDz/9YKCTIQrfqJ5jWyTnn5zPOlQGn5nzB0MTg7imWzJnog69eFJIeh
	TCVUnDMsN7ecTjapPNJzH0YXTr4Ov+5T9C0RJ/CHvV9B/6hhZ3lXBd5wMR30dd6n
	LH7SKRWIzTIA6oKBdxvoluODsGs54JPsKxXqY6s8VjrtK4KZiSuHN2BnaSQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha7aeg6tn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:47 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-341eff9e381so11028905eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974087; x=1792578887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N89VJiT6zijquXpaMXNm+ZtC2GwcDssuVYO3pc6k5bw=;
        b=bOtvBQu5iEISdzzyBDQsu1HRpRG1dM4WBACJDRTROE8VxMEtE5Vc3ql9CrYiZs6+aX
         iNTjDJH+q1Y8HeI4Qc30WF7owKe0nOxP01BPkDNdjCZVLps3gs9GxD0vqs7hx4rmWw4t
         3lXvu2rYjQs5YDzP1bEiML5x2Nfig3l8vqHTMXQ8ruEay4K0tcfYYdohAW8LEEnuaKmH
         mlAtG2NAKEB8UAe17ujyfwcWuIi0ohtMyjfdmWg6e4fAggJbtm7vfeJQ5GzMXDbZ6cIH
         SBvfbqVyvrflq37zqP+/6QKLCaGy1c+SXzQRF22kDWeCCjzbU2I+cJth8tbp5dNDGkI+
         QdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974087; x=1792578887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N89VJiT6zijquXpaMXNm+ZtC2GwcDssuVYO3pc6k5bw=;
        b=V+cC4KtkolOU733ZVu6RPT9iALs6UVnC2qSoFkfknm+JWZjDY5Q4Ufslo4Znp6oizz
         XdO9xEbRejoBRp9PJ/Vm2OT64OEbdI3CBajw6ZxBK6Mwplco0OgeL1iexKbaoUxG6P7t
         /zRS0dGoe54Iq81HXPGFahkbGztvGFn2phNy46tQPKHXDqh6bvHAYMnxPvrKcYix0Q9f
         palb7ajvlpheXAYIRjUOJ9omhlW9Bmsn38Yltmv+sofkmJKAP9MChTMnuur/u1WIOQEI
         GZrnlCpclSv5BnsTm0tgdU34AMZNLOfBsT2or1WCcaLwAr3ZCbUQ/P94r+AohQgvV9KN
         TlNw==
X-Gm-Message-State: AFq9FYJe7guTGnahXF8atPDLUgXoeqPUGeF1+RVP7igkQj+vO+QEiLl5
	I9F66hLzCQIKxLqhCUqt0xy5zGRJ9D9EhSZ+7foYdtQY33WmvIA1lOykirFJNWGOsGa9qFwx5q2
	HWorkHqvep+tAMHazDJigHH853A1+h3VDXb5nCncokE1SqSeeUjJ+RBp/gMiiPAqQFigaA2Nu8N
	O2uw==
X-Gm-Gg: AYBFou31DsEHuAltykLEdvu8kVLMIPCKltyMB+DkNX2GuPjUWtzO5qX5dazOJuoXnCL
	L809Hplls74ocpflEqr2qs6QlhFGSgHQzPObtG3MZOFM/FwM3v5HUbFnO43ag3O8GpQf+CAdtKP
	WdlSoDMPxGOEfR9kTyHydIUOd5x1luih8IhRZ6nFDrFl3oSrrYYWllIDSECh4sJJUUuhCJ/hhWc
	QAOQr23cV7SnngB/vFxgCIMhJfJWWsHN8dRpU8MO3LH4A76PZfmHxa2IURKXhr34nLqGwFcsJ6G
	iYz4xrcrMgPeWeZqs7yCm0Uxh7Pg8WCL4LjUpgqN37Et4RFr1HahcrI6/GTee5P7nHVLcPuODWf
	y/f6JBzXgdVGOP/i3GbfNE6OtspgPEFtRPdDx
X-Received: by 2002:a05:701b:2511:b0:17d:7b45:f907 with SMTP id a92af1059eb24-17d7b55507cmr2494367c88.33.1791974086344;
        Wed, 14 Oct 2026 03:34:46 -0700 (PDT)
X-Received: by 2002:a05:701b:2511:b0:17d:7b45:f907 with SMTP id a92af1059eb24-17d7b55507cmr2494334c88.33.1791974085670;
        Wed, 14 Oct 2026 03:34:45 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:45 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 10/15] wifi: nl80211/cfg80211: add support for NDP initiation in offload mode
Date: Wed, 14 Oct 2026 16:03:54 +0530
Message-Id: <20261014103359.1508345-11-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: mDKaPN0YUCLR0EX6t6Jt7q4hRC4ygR90
X-Proofpoint-GUID: mDKaPN0YUCLR0EX6t6Jt7q4hRC4ygR90
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MiBTYWx0ZWRfX+r/FmWnyMpqx
 FIcSlFrCcWaXYbzkSbHqpeeuqy/pqIwCL5LWqyw4IgTUzvV3c9nRBE4ZSIXYTi8appgXeH1W7Tv
 WDvdYBYFLCxLcpUfsaGN+Bl/AZ2CGzI=
X-Authority-Analysis: v=2.4 cv=NctzRGD4 c=1 sm=1 tr=0 ts=6acf5ac7 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=VNVH6czGhNIpz8ALsXYA:9 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MiBTYWx0ZWRfX353HiF5yYf3X
 g8qAOv1j0jaH8v3DMfvL026TYb6K1rYnntCTJizGgwTrnLKZgqJd8MXjYQQct9oOqrdFZp8vHaS
 60UdJUQpaUGqoYn32SOjLc1lv5OU7g5W5WPhazr+mJgK5RtWHwM4DBQz82OJI3v6ed8qJKjTumU
 Ke9PgjtSBFr841ziPN0wVznNnvTXBM+CfO2AHmlK6eF3rCOXh28e1t+ifXt0b+2NysC/ipfjl5X
 2vIP12rhlfkqgtHoTrtxmc6sIyyZIuJmWK33dpMfUA1pQSucUgFr5aP83HIxnmRYVIkaqPzipMf
 qiGl+C2XanzhnHs34+EI389WWGJ+o0/yBBpmE7/ntX++YyDRaSieC65g1g/T6wY6KYW+kPfD9OP
 Z4+iHz9mSCj0a+v9GTlT/S8wjJY4NzYwyEtQBahrhDjQIBWnaaP3Z19qO3HmyvtA0pzWGVwXOte
 y/udKnRFaAefKZMaBhg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 suspectscore=0 lowpriorityscore=0
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140042

Add NL80211_CMD_NAN_NDP_INITIATE to allow userspace to initiate a NAN
Data Path session when NDP management is offloaded to firmware. Add the
corresponding parameter structure, nl80211 policy, command handler, and
driver callback. Reject the request if the driver has not advertised
NDP offload capability or if security material is provided without
secure NAN support.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       |  50 +++++++++++
 include/uapi/linux/nl80211.h |  84 +++++++++++++++++++
 net/wireless/nl80211.c       | 156 +++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  16 ++++
 net/wireless/trace.h         |  22 +++++
 5 files changed, 328 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index aadfed50b4e2..ed1f476c526a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4334,6 +4334,50 @@ struct cfg80211_nan_peer_sched {
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
@@ -5312,6 +5356,9 @@ struct mgmt_frame_regs {
  *	not included become evacuable again. All provided channels are
  *	guaranteed by cfg80211 to belong to the current local schedule.
  *
+ * @nan_ndp_initiate: Initiate a NAN Data Path session as the initiator.
+ *	Only valid if the driver has set %WIPHY_NAN_FLAGS_OFFLOAD_NDP.
+ *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
  *
  * @get_txq_stats: Get TXQ stats for interface or phy. If wdev is %NULL, this
@@ -5719,6 +5766,9 @@ struct cfg80211_ops {
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
index 05ab24b10bf9..02705ce77685 100644
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
@@ -8046,6 +8060,76 @@ enum nl80211_nan_conf_attributes {
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
+ *	PMKID from the peer's
+ *	SCIA attribute. Present in %NL80211_CMD_NAN_NDP_REQUEST to allow
+ *	userspace to look up a cached PMK.
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
index ecab5ca2b690..e0700aa12dbc 100644
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
@@ -18473,6 +18498,131 @@ static int nl80211_nan_set_peer_sched(struct sk_buff *skb,
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
@@ -21625,6 +21775,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
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
index ae15cec9bf8b..dcf2a596a574 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1183,6 +1183,22 @@ static inline void rdev_stop_pd(struct cfg80211_registered_device *rdev,
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

