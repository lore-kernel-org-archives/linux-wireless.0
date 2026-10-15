Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0878D3C345D
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043657; cv=none; b=NOMl9sY3gzvKO3kQZm3kYDQjte4ip79RB+b/hB48D2PlFLOJ9BBh/6aj9frb1f8kH3Z8LzGisVpTjGD00cLdxzkV+lpEppz2pTfnDiU2Tf5TDi3uN+Rhm4ATVQ7OdiR2M+IVu2mzKpEgyIgwmLP1MKnjy4/OujCdGUjKlLIoj9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043657; c=relaxed/simple;
	bh=JdbVAHjt0wfriUKnX/9hghr+ij5t04gGBIU4SgDnS18=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bkHLclbbrwYKaMSrBINn3Fhq/6qor6zNZ9YUA3uj6Hso/EsmhD0bcfc79HyiPAAvcB4RHiEOS6e0IE23it8/BYHG7+gqp9luUylfMDj+Gxn/xW0SsjrstcFqLQvOE5S4/6DrmH7Lr/ect2qcxulvGNi3m2SmA++vGmQoop7VEvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=es4i1p06; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NhSDOLu+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="es4i1p06";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NhSDOLu+"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EM8RaP500302
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=2IHdaB5tukL+SGpjAgWM2U8+XAfoU2eBIda
	q4WWMhv0=; b=es4i1p06vgDlKQxNForeXPtLPzshZErKDPaZHQO3VXrdJD1+06L
	oJ2du2ajHOb2hNpRkEnLnvG/TkmhUJSNBsFeaIMo8i24nfWCt1HzZ4yXjHcLljzs
	0MwdmDuQJ0wEcHjNK2q6YdeWlFtIDyEZMg/TXM9V3WU0cLfKYQjHH4ym79+sMciL
	3TH16TLKgYAcCiPpTYclnSpTrcljzVWaE4H8dpN1XN2XUoNF2VZHlFqNPEg/qZ6A
	adYoNIU6MsVG9/T49Kjxz5lffsf2F9DHMpLVDYMflNPi5YEBdZGGISe/QdYdnDuS
	ZYM252cYomEEFz3stQmvijlRSnKzKHCsX8g==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4haagf3djt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:54:14 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ab2cb8d5dbso5964851a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 22:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792043653; x=1792648453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2IHdaB5tukL+SGpjAgWM2U8+XAfoU2eBIdaq4WWMhv0=;
        b=NhSDOLu+mr+RC1RPpB+j2BoIN/ajwmsANUTyUA3aXfCbdi21Ky0zYY1tdB2DV6cT/E
         uOM/orDKYyBKR3bBjGW1VIrBoWG6xabT1BI1CUHP5ZwlWDWoN8A51WaZjuDAzVj2zkkC
         /3fLgTrW04PTTqae1ofHSs3b8k55YB4eLhMHzrekngWJFVgZ6eWJ/4naShf8gqqFeSKO
         +mHaCTQ5DIloJ1VKO5L+ayWfU+in9kZX93wpRhGFWg7iZlNxg4mgbehkxIGGwU5HYn51
         KzqU2o15HVubU5wPWFY6P3Z9v3oYefxgMmTFAzH8dRjZwHX1sL6ve6M50XhFiageauHc
         WfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792043653; x=1792648453;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2IHdaB5tukL+SGpjAgWM2U8+XAfoU2eBIdaq4WWMhv0=;
        b=YJo4ra9BunlmqtvjrfhjAXs6sNkREPMNtbMf1498BseeGVh8Bq1O0GlFo9B2VnDyM6
         65lVX0LWX8gOad3w9x6hmqCl2OxLjDyxSKsCq3jSUMo6YeAHFM82JyvuetMicpmfSZR8
         XgZ3yv0evWwXEbWT1vL4NgA6U+TUs/ZxI5FKfgcHOq9701Pjb94vzt9jzqOErPB+W02i
         NZtaSZTiqQN+xG7vG9HFlXRLiL8wfvqIyO8HInUQcr38UU/kkvsw7JU46103FnOaU9E0
         QHmneq7QqXWfq3TY4IohYbIfuhX5mD0YCx6wY5+q5mqScovGnAAbHtmDo6TYi81UFAjh
         5QHA==
X-Gm-Message-State: AFq9FYIJf7dLHiPauZRaHOiHGEIPFSbqB8U1iZIlyzMnuiyaN07TcNe7
	F/9seMnfoODoHh/sn78rAtiU9zdcOy6bkZBkoQ7w81q0WxQbdzix9724MMKd5Z7ymJ708Zw0RPR
	fS3Ceq+W+7Q2S8UAiSJS8oSj8+mYms8eUgXFQ5aTpbYfZ0PNKasM2JgavarF9cSsl2MLFUQ==
X-Gm-Gg: AYBFou1rPSQoDRXEtcVbPdppqwxtq3f8uvwmA0pqCVr+AGs/spRTFS97VoJCEbLAsCB
	zTyHFLqbtUNbm2FtHJd7JICICCbyQwrqmHGTS02ZxjmS+BYxI0+dE/9RJl3gRIotje24vDKYZZy
	7Zkto2czZNtL7DmHBkG25EKNJkPyth+4Ak5YrIdDMfXDqPRkIU5iDCtuUcc73ru9HpnynxF9NkH
	iPd8UH0WjiWCvVBbTL3rguwibGpi+8Aelk/aSlk1SmQHCaXXd/GPG36B+W8GU/qdJnecpU931/L
	OPVfhh0hna4kjGvhxaUx7SZ/rdTU15MG1j0XrIcxBZC6P8G7TxlpaHhIQmk4OgDgxWKNcn0p/g9
	gPAJNykUCYXKo+bf/JYxy3Ag3qywO9lazo20DimSD4yfzGGiS4vKJqheV5Mz/4iYU3+Kbie1UVw
	J3OOVBZ8FeHwSV8w==
X-Received: by 2002:a17:90b:258f:b0:3a6:f1d2:57f3 with SMTP id 98e67ed59e1d1-3ab3a8d974emr15234299a91.58.1792043652989;
        Wed, 14 Oct 2026 22:54:12 -0700 (PDT)
X-Received: by 2002:a17:90b:258f:b0:3a6:f1d2:57f3 with SMTP id 98e67ed59e1d1-3ab3a8d974emr15234283a91.58.1792043652364;
        Wed, 14 Oct 2026 22:54:12 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac9449ae48sm2734448a91.13.2026.10.14.22.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 22:54:11 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Aishwarya R <aishwarya.r@oss.qualcomm.com>,
        Arun Vikas T <arun.t@oss.qualcomm.com>
Subject: [PATCH RFC wireless-next 1/7] wifi: nl80211: add QoS Management UAPI
Date: Thu, 15 Oct 2026 11:24:06 +0530
Message-Id: <20261015055406.680511-1-aishwarya.r@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfXz1gXisgomxb1
 ld/nMDFuf8W/ZKLu80ExO9DMJ5GB6umwQmqxZor9JpH+g9d1ndAo4XIzyODON9yqb1SBkFaBKPl
 kGl16f2V7qgw5Kb86LhN5j/2m6UOwXBE+4BZ1ApwgiK5Hwiid4xFSTqk3mA/XU+3xlq/PWVosIf
 c2gpMxel+weOvFTMHS7yHvtGrrev13HMfWA93XEgplu3s5Je2E+yTX7FB7Os2CU5BDT5qu2EgkM
 6pVFjAdz8JWQIn+czB0tyPTVMEsrWI4GvDY/eq3h2raOTVHhYM7ftL0ixdtl5I3nq4cFCCwtare
 +znYFwkTrQXf9zR4EXPGOvyUDogNAZfTzn27gTpkcNTEvcwUOTHNR2Jc+CFMUTNh3LVCicB/rSg
 hfUdbHnFlOQUjvkM/QCu5BRQLG3tSQaH18CxxkdEGZusUNxXBJMdW1Yz9ys6KlAcbCCJ9g3jihH
 4AsyewPGfBPMp2kyo6w==
X-Proofpoint-GUID: agOhwMPjoxqyzkgcEZ6IOBG6DemV_mUf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX52g6GMSqwjAz
 f5W6/6KXyMPThD8aNXU81ALtFiS+UWvg3MM2NniM7vk2YvQAiuEY5A/5V9D22SkDWCPi44rkXB7
 enP1IO7+Am3vh/2qFpFB1kmYgwkek0U=
X-Proofpoint-ORIG-GUID: agOhwMPjoxqyzkgcEZ6IOBG6DemV_mUf
X-Authority-Analysis: v=2.4 cv=V/noQuni c=1 sm=1 tr=0 ts=6ad06a86 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=BHmDPy62uHH8tM3u7LoA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150023

Add the UAPI definitions and nested netlink policies used by the generic
QoS Management (QM) framework.

Introduce protocol identifiers for Stream Classification Service (SCS)
and Mirrored Stream Classification Service (MSCS), request operation
types, QoS characteristics direction encoding, response status codes,
and the NL80211_CMD_QOS_MGMT command.

The NL80211_ATTR_QOS_MGMT payload contains the protocol selector and
nested descriptor, SCS TCLAS and QoS attributes, and MSCS-specific
attributes. The corresponding nl80211 policies validate the attribute types
and ranges before parsing.

The SCS and MSCS procedures are specified in 11.25.2 and 11.25.3,
IEEE Std 802.11-2024. The SCS Descriptor and MSCS Descriptor elements are
specified in 9.4.2.120 and 9.4.2.242, IEEE Std 802.11-2024, respectively.
The TCLAS element and TCLAS Processing element are specified in 9.4.2.29
and 9.4.2.31, IEEE Std 802.11-2024. The QoS Characteristics element is
specified in 9.4.2.326, IEEE Std 802.11be-2024.

Co-developed-by: Arun Vikas T <arun.t@oss.qualcomm.com>
Signed-off-by: Arun Vikas T <arun.t@oss.qualcomm.com>
Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 344 +++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |  88 +++++++++
 2 files changed, 432 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b56a96f57bec..4106fe662945 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1468,6 +1468,10 @@
  *	and multiple can be nested in %NL80211_ATTR_MLO_LINKS but then the
  *	update isn't atomic if any failures happen.
  *	Only supported with %NL80211_EXT_FEATURE_UPDATE_BEACON.
+ * @NL80211_CMD_QOS_MGMT: QoS Management configuration for a station. Used
+ *	by userspace to send QoS Management (QM) requests and to receive the
+ *	corresponding status response via %NL80211_ATTR_QOS_MGMT.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1750,6 +1754,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_UPDATE_BEACON,
 
+	NL80211_CMD_QOS_MGMT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -3243,6 +3249,13 @@ enum nl80211_commands {
  * @NL80211_ATTR_ASSOC_PROTECTED_TWT: Enable protected TWT for the association,
  *	requires protected TWT support (flag attribute)
  *
+ * @NL80211_ATTR_QOS_MGMT: Used with %NL80211_CMD_QOS_MGMT to configure
+ *	QoS Management (QM) features for a station. The nested payload is
+ *	described by &enum nl80211_qm_attrs. It contains a nested array of
+ *	&enum nl80211_qm_desc_attrs entries; SCS TCLAS and QoS attributes use
+ *	&enum nl80211_qm_tclas_attrs and &enum nl80211_qm_qos_attrs,
+ *	respectively.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3850,6 +3863,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_ASSOC_PROTECTED_TWT,
 
+	NL80211_ATTR_QOS_MGMT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -9200,4 +9215,333 @@ enum nl80211_nan_peer_map_attrs {
 
 #define NL80211_NAN_SCHED_NOT_AVAIL_SLOT 0xff
 
+#define NL80211_IPADDR_MAX_LEN			16
+#define NL80211_QM_TCLAS_TYPE10_MAX_FILTER_LEN	12
+#define NL80211_QM_TCLAS_TYPE4_FLOW_LABEL_LEN	3
+
+/*
+ * The TCLAS element (reference 9.4.2.29, IEEE Std 802.11-2024) is used by
+ * SCS for traffic classification.
+ */
+/**
+ * enum nl80211_qm_tclas_type4_attrs - TCLAS classifier type 4 attributes
+ *
+ * @NL80211_QM_TCLAS_TYPE4_ATTR_INVALID: Invalid
+ * @NL80211_QM_TCLAS_TYPE4_ATTR_CLASSIFIER_MASK: Classifier mask (u8), see
+ *	&enum nl80211_qm_tclas_type4_mask
+ * @NL80211_QM_TCLAS_TYPE4_ATTR_IP_VERSION: IP version, 4 or 6 (u8)
+ * @NL80211_QM_TCLAS_TYPE4_ATTR_SRC_IP: Source IP address
+ * @NL80211_QM_TCLAS_TYPE4_ATTR_DST_IP: Destination IP address
+ * @NL80211_QM_TCLAS_TYPE4_ATTR_SRC_PORT: Source port (u16)
+ * @NL80211_QM_TCLAS_TYPE4_ATTR_DST_PORT: Destination port (u16)
+ * @NL80211_QM_TCLAS_TYPE4_ATTR_DSCP: DSCP value, 0-63 (u8)
+ * @NL80211_QM_TCLAS_TYPE4_ATTR_PROTOCOL: IP protocol number, IPv4 only (u8)
+ * @NL80211_QM_TCLAS_TYPE4_ATTR_NEXT_HEADER: Next header, IPv6 only (u8)
+ * @NL80211_QM_TCLAS_TYPE4_ATTR_FLOW_LABEL: Flow label, IPv6 only
+ * @__NL80211_QM_TCLAS_TYPE4_ATTR_AFTER_LAST: internal use
+ * @NL80211_QM_TCLAS_TYPE4_ATTR_MAX: highest type 4 attribute number currently
+ *	defined
+ */
+enum nl80211_qm_tclas_type4_attrs {
+	NL80211_QM_TCLAS_TYPE4_ATTR_INVALID,
+	NL80211_QM_TCLAS_TYPE4_ATTR_CLASSIFIER_MASK,
+	NL80211_QM_TCLAS_TYPE4_ATTR_IP_VERSION,
+	NL80211_QM_TCLAS_TYPE4_ATTR_SRC_IP,
+	NL80211_QM_TCLAS_TYPE4_ATTR_DST_IP,
+	NL80211_QM_TCLAS_TYPE4_ATTR_SRC_PORT,
+	NL80211_QM_TCLAS_TYPE4_ATTR_DST_PORT,
+	NL80211_QM_TCLAS_TYPE4_ATTR_DSCP,
+	NL80211_QM_TCLAS_TYPE4_ATTR_PROTOCOL,
+	NL80211_QM_TCLAS_TYPE4_ATTR_NEXT_HEADER,
+	NL80211_QM_TCLAS_TYPE4_ATTR_FLOW_LABEL,
+
+	/* keep last */
+	__NL80211_QM_TCLAS_TYPE4_ATTR_AFTER_LAST,
+	NL80211_QM_TCLAS_TYPE4_ATTR_MAX =
+		__NL80211_QM_TCLAS_TYPE4_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_qm_tclas_type10_attrs - TCLAS classifier type 10 attributes
+ *
+ * @NL80211_QM_TCLAS_TYPE10_ATTR_INVALID: Invalid
+ * @NL80211_QM_TCLAS_TYPE10_ATTR_PROT_INSTANCE: Protocol instance (u8)
+ * @NL80211_QM_TCLAS_TYPE10_ATTR_PROT_NUMBER: Protocol number (u8)
+ * @NL80211_QM_TCLAS_TYPE10_ATTR_FILTER_VALUE: Filter value bytes
+ * @NL80211_QM_TCLAS_TYPE10_ATTR_FILTER_MASK: Filter mask bytes
+ * @__NL80211_QM_TCLAS_TYPE10_ATTR_AFTER_LAST: internal use
+ * @NL80211_QM_TCLAS_TYPE10_ATTR_MAX: highest type 10 attribute number currently
+ *	defined
+ */
+enum nl80211_qm_tclas_type10_attrs {
+	NL80211_QM_TCLAS_TYPE10_ATTR_INVALID,
+	NL80211_QM_TCLAS_TYPE10_ATTR_PROT_INSTANCE,
+	NL80211_QM_TCLAS_TYPE10_ATTR_PROT_NUMBER,
+	NL80211_QM_TCLAS_TYPE10_ATTR_FILTER_VALUE,
+	NL80211_QM_TCLAS_TYPE10_ATTR_FILTER_MASK,
+
+	/* keep last */
+	__NL80211_QM_TCLAS_TYPE10_ATTR_AFTER_LAST,
+	NL80211_QM_TCLAS_TYPE10_ATTR_MAX =
+		__NL80211_QM_TCLAS_TYPE10_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_qm_tclas_attrs - TCLAS element attributes
+ *
+ * @NL80211_QM_TCLAS_ATTR_INVALID: Invalid
+ * @NL80211_QM_TCLAS_ATTR_USER_PRIORITY: User priority, 0-7 (u8)
+ * @NL80211_QM_TCLAS_ATTR_CLASSIFIER_TYPE: Classifier type, 4 or 10 (u8)
+ * @NL80211_QM_TCLAS_ATTR_TYPE4_PARAMS: Nested type 4 classifier params, see
+ *	&enum nl80211_qm_tclas_type4_attrs
+ * @NL80211_QM_TCLAS_ATTR_TYPE10_PARAMS: Nested type 10 classifier params, see
+ *	&enum nl80211_qm_tclas_type10_attrs
+ * @__NL80211_QM_TCLAS_ATTR_AFTER_LAST: internal use
+ * @NL80211_QM_TCLAS_ATTR_MAX: highest TCLAS attribute number currently defined
+ */
+enum nl80211_qm_tclas_attrs {
+	NL80211_QM_TCLAS_ATTR_INVALID,
+	NL80211_QM_TCLAS_ATTR_USER_PRIORITY,
+	NL80211_QM_TCLAS_ATTR_CLASSIFIER_TYPE,
+	NL80211_QM_TCLAS_ATTR_TYPE4_PARAMS,
+	NL80211_QM_TCLAS_ATTR_TYPE10_PARAMS,
+
+	/* keep last */
+	__NL80211_QM_TCLAS_ATTR_AFTER_LAST,
+	NL80211_QM_TCLAS_ATTR_MAX = __NL80211_QM_TCLAS_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_qm_tclas_classifier_type - TCLAS classifier type values sent
+ *	in %NL80211_QM_TCLAS_ATTR_CLASSIFIER_TYPE
+ * @NL80211_QM_TCLAS_CLASSIFIER_TYPE4: Classifier type 4, 5-tuple based;
+ *	reference 9.4.2.29, IEEE Std 802.11-2024.
+ * @NL80211_QM_TCLAS_CLASSIFIER_TYPE10: Classifier type 10, filter based;
+ *	reference 9.4.2.29, IEEE Std 802.11-2024.
+ *
+ * The SCS interface currently supports only classifier types 4 and 10.
+ */
+enum nl80211_qm_tclas_classifier_type {
+	NL80211_QM_TCLAS_CLASSIFIER_TYPE4 = 4,
+	NL80211_QM_TCLAS_CLASSIFIER_TYPE10 = 10,
+};
+
+/**
+ * enum nl80211_qm_tclas_type4_mask - classifier mask bits for TCLAS type 4
+ * @NL80211_QM_TCLAS_TYPE4_MASK_VERSION: IP version field
+ * @NL80211_QM_TCLAS_TYPE4_MASK_SRC_IP: source IP address
+ * @NL80211_QM_TCLAS_TYPE4_MASK_DST_IP: destination IP address
+ * @NL80211_QM_TCLAS_TYPE4_MASK_SRC_PORT: source port
+ * @NL80211_QM_TCLAS_TYPE4_MASK_DST_PORT: destination port
+ * @NL80211_QM_TCLAS_TYPE4_MASK_DSCP: DSCP field
+ * @NL80211_QM_TCLAS_TYPE4_MASK_PROTOCOL: protocol / next-header field
+ * @NL80211_QM_TCLAS_TYPE4_MASK_FLOW_LABEL: IPv6 flow label
+ */
+enum nl80211_qm_tclas_type4_mask {
+	NL80211_QM_TCLAS_TYPE4_MASK_VERSION    = 1 << 0,
+	NL80211_QM_TCLAS_TYPE4_MASK_SRC_IP     = 1 << 1,
+	NL80211_QM_TCLAS_TYPE4_MASK_DST_IP     = 1 << 2,
+	NL80211_QM_TCLAS_TYPE4_MASK_SRC_PORT   = 1 << 3,
+	NL80211_QM_TCLAS_TYPE4_MASK_DST_PORT   = 1 << 4,
+	NL80211_QM_TCLAS_TYPE4_MASK_DSCP       = 1 << 5,
+	NL80211_QM_TCLAS_TYPE4_MASK_PROTOCOL   = 1 << 6,
+	NL80211_QM_TCLAS_TYPE4_MASK_FLOW_LABEL = 1 << 7,
+};
+
+/**
+ * enum nl80211_qm_tclas_processing - TCLAS processing rules
+ *
+ * Processing field values are defined in 9.4.2.31, IEEE Std 802.11-2024.
+ *
+ * @NL80211_QM_TCLAS_PROCESSING_MATCH_ALL: all TCLAS elements must match
+ * @NL80211_QM_TCLAS_PROCESSING_MATCH_ANY: any TCLAS element may match
+ * @NL80211_QM_TCLAS_PROCESSING_MATCH_ALL_EXCEPT_FIRST: all except the first
+ *	must match
+ */
+enum nl80211_qm_tclas_processing {
+	NL80211_QM_TCLAS_PROCESSING_MATCH_ALL = 0,
+	NL80211_QM_TCLAS_PROCESSING_MATCH_ANY = 1,
+	NL80211_QM_TCLAS_PROCESSING_MATCH_ALL_EXCEPT_FIRST = 2,
+};
+
+/**
+ * enum nl80211_qm_qos_attrs - QoS Management QoS attributes
+ *
+ * The QoS Characteristics element is specified in 9.4.2.326,
+ * IEEE Std 802.11be-2024.
+ *
+ * @NL80211_QM_QOS_ATTR_INVALID: Invalid
+ * @NL80211_QM_QOS_ATTR_CONTROL_INFO: QoS characteristics control info (u32)
+ * @NL80211_QM_QOS_ATTR_MIN_SVC_INTERVAL: Minimum service interval, us (u32)
+ * @NL80211_QM_QOS_ATTR_MAX_SVC_INTERVAL: Maximum service interval, us (u32)
+ * @NL80211_QM_QOS_ATTR_MIN_DATA_RATE: Minimum data rate, kbps (u32)
+ * @NL80211_QM_QOS_ATTR_DELAY_BOUND: Delay bound, us (u32)
+ * @NL80211_QM_QOS_ATTR_MAX_MSDU_SIZE: Maximum MSDU size, bytes (u16)
+ * @NL80211_QM_QOS_ATTR_SVC_START_TIME: Service start time, us (u32)
+ * @NL80211_QM_QOS_ATTR_SVC_START_TIME_LINK_ID: Link ID for service start
+ *	time (u8)
+ * @NL80211_QM_QOS_ATTR_MEAN_DATA_RATE: Mean data rate, kbps (u32)
+ * @NL80211_QM_QOS_ATTR_BURST_SIZE: Burst size, bytes (u32)
+ * @NL80211_QM_QOS_ATTR_MSDU_LIFETIME: MSDU lifetime, ms (u16)
+ * @NL80211_QM_QOS_ATTR_MSDU_DELIVERY_INFO: MSDU delivery ratio and count
+ *	exponent (u8)
+ * @NL80211_QM_QOS_ATTR_MEDIUM_TIME: Medium time, 32 us units (u16)
+ * @__NL80211_QM_QOS_ATTR_AFTER_LAST: internal use
+ * @NL80211_QM_QOS_ATTR_MAX: highest QoS attribute number currently defined
+ */
+enum nl80211_qm_qos_attrs {
+	NL80211_QM_QOS_ATTR_INVALID,
+	NL80211_QM_QOS_ATTR_CONTROL_INFO,
+	NL80211_QM_QOS_ATTR_MIN_SVC_INTERVAL,
+	NL80211_QM_QOS_ATTR_MAX_SVC_INTERVAL,
+	NL80211_QM_QOS_ATTR_MIN_DATA_RATE,
+	NL80211_QM_QOS_ATTR_DELAY_BOUND,
+	NL80211_QM_QOS_ATTR_MAX_MSDU_SIZE,
+	NL80211_QM_QOS_ATTR_SVC_START_TIME,
+	NL80211_QM_QOS_ATTR_SVC_START_TIME_LINK_ID,
+	NL80211_QM_QOS_ATTR_MEAN_DATA_RATE,
+	NL80211_QM_QOS_ATTR_BURST_SIZE,
+	NL80211_QM_QOS_ATTR_MSDU_LIFETIME,
+	NL80211_QM_QOS_ATTR_MSDU_DELIVERY_INFO,
+	NL80211_QM_QOS_ATTR_MEDIUM_TIME,
+
+	/* keep last */
+	__NL80211_QM_QOS_ATTR_AFTER_LAST,
+	NL80211_QM_QOS_ATTR_MAX = __NL80211_QM_QOS_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_qm_desc_attrs - QoS Management descriptor attributes
+ *
+ * @NL80211_QM_DESC_ATTR_INVALID: Invalid
+ * @NL80211_QM_DESC_ATTR_QM_ID: Userspace-assigned identifier (u8) used
+ *	to correlate a request descriptor with its response descriptor
+ * @NL80211_QM_DESC_ATTR_REQUEST_TYPE: Request type, see
+ *	&enum nl80211_qm_req_type (u8)
+ * @NL80211_QM_DESC_ATTR_PRIORITY: SCS descriptor priority (u8)
+ * @NL80211_QM_DESC_ATTR_TCLAS_ELEMENTS: Nested array of SCS TCLAS elements,
+ *	see &enum nl80211_qm_tclas_attrs
+ * @NL80211_QM_DESC_ATTR_TCLAS_PROCESSING: SCS TCLAS processing rule (u8),
+ *	see &enum nl80211_qm_tclas_processing
+ * @NL80211_QM_DESC_ATTR_QOS_ATTRIBUTES: Nested SCS QoS attributes, see
+ *	&enum nl80211_qm_qos_attrs
+ * @NL80211_QM_DESC_ATTR_STATUS: Response status for this descriptor (u8),
+ *	see &enum nl80211_qm_status
+ * @NL80211_QM_DESC_ATTR_USER_PRIORITY_BITMAP: MSCS user priority bitmap of
+ *	TID values sent by the non-AP STA (u8)
+ * @NL80211_QM_DESC_ATTR_USER_PRIORITY_LIMIT: MSCS user priority limit sent
+ *	by the non-AP STA (u8)
+ * @NL80211_QM_DESC_ATTR_TCLAS_MASK: MSCS traffic classifier mask with a
+ *	bitmap of parameters to match in an uplink flow for downlink
+ *	prioritization (u8)
+ * @__NL80211_QM_DESC_ATTR_AFTER_LAST: internal use
+ * @NL80211_QM_DESC_ATTR_MAX: highest QoS Management descriptor attribute
+ *	number currently defined
+ */
+enum nl80211_qm_desc_attrs {
+	NL80211_QM_DESC_ATTR_INVALID,
+	NL80211_QM_DESC_ATTR_QM_ID,
+	NL80211_QM_DESC_ATTR_REQUEST_TYPE,
+	NL80211_QM_DESC_ATTR_PRIORITY,
+	NL80211_QM_DESC_ATTR_TCLAS_ELEMENTS,
+	NL80211_QM_DESC_ATTR_TCLAS_PROCESSING,
+	NL80211_QM_DESC_ATTR_QOS_ATTRIBUTES,
+	NL80211_QM_DESC_ATTR_STATUS,
+	NL80211_QM_DESC_ATTR_USER_PRIORITY_BITMAP,
+	NL80211_QM_DESC_ATTR_USER_PRIORITY_LIMIT,
+	NL80211_QM_DESC_ATTR_TCLAS_MASK,
+
+	/* keep last */
+	__NL80211_QM_DESC_ATTR_AFTER_LAST,
+	NL80211_QM_DESC_ATTR_MAX = __NL80211_QM_DESC_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_qm_attrs - QoS Management attributes
+ *
+ * @NL80211_QM_ATTR_INVALID: Invalid
+ * @NL80211_QM_ATTR_MAC_ADDR: Target station MAC address (6 bytes)
+ * @NL80211_QM_ATTR_QM_TYPE: QoS Management protocol type, see
+ *	&enum nl80211_qm_type (u8)
+ * @NL80211_QM_ATTR_DESCRIPTOR_PARAMS: Nested array of QM descriptors, see
+ *	&enum nl80211_qm_desc_attrs
+ * @__NL80211_QM_ATTR_AFTER_LAST: internal use
+ * @NL80211_QM_ATTR_MAX: highest QoS Management attribute number currently
+ *	defined
+ */
+enum nl80211_qm_attrs {
+	NL80211_QM_ATTR_INVALID,
+	NL80211_QM_ATTR_MAC_ADDR,
+	NL80211_QM_ATTR_QM_TYPE,
+	NL80211_QM_ATTR_DESCRIPTOR_PARAMS,
+
+	/* keep last */
+	__NL80211_QM_ATTR_AFTER_LAST,
+	NL80211_QM_ATTR_MAX = __NL80211_QM_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_qm_type - QoS Management protocol types
+ * @NL80211_QM_TYPE_SCS: Stream Classification Service (SCS) protocol,
+ *	reference 11.25.2, IEEE Std 802.11-2024.
+ * @NL80211_QM_TYPE_MSCS: Mirrored Stream Classification Service (MSCS)
+ *	protocol, reference 11.25.3, IEEE Std 802.11-2024.
+ * @NL80211_QM_TYPE_MAX: Maximum value for QoS Management protocol types
+ *
+ * Enumerates the QoS Management protocols supported through the generic
+ * QoS Management (QM) request/response framework.
+ *
+ */
+enum nl80211_qm_type {
+	NL80211_QM_TYPE_SCS,
+	NL80211_QM_TYPE_MSCS,
+	/* Future QM protocols to be added here */
+	NL80211_QM_TYPE_MAX,
+};
+
+/**
+ * enum nl80211_qm_direction - QoS Management descriptor
+ *	traffic direction
+ * @NL80211_QM_DIRECTION_UPLINK: Traffic direction is uplink, from the
+ *	non-AP STA to the AP.
+ * @NL80211_QM_DIRECTION_DOWNLINK: Traffic direction is downlink, from
+ *	the AP to the non-AP STA.
+ * @NL80211_QM_DIRECTION_DIRECT: Direct link traffic between STAs (P2P).
+ *
+ * Encodes the QoS characteristics element direction subfield, denoting
+ * which traffic direction a set of QoS attributes applies to. The QoS
+ * Characteristics element is specified in 9.4.2.326, IEEE Std 802.11be-2024.
+ */
+enum nl80211_qm_direction {
+	NL80211_QM_DIRECTION_UPLINK = 0,
+	NL80211_QM_DIRECTION_DOWNLINK = 1,
+	NL80211_QM_DIRECTION_DIRECT = 2,
+};
+
+/**
+ * enum nl80211_qm_req_type - QoS Management request types
+ * @NL80211_QM_ADD_REQ: Add a new QoS Management configuration
+ * @NL80211_QM_REMOVE_REQ: Remove an existing QoS Management configuration
+ * @NL80211_QM_CHANGE_REQ: Modify an existing QoS Management configuration
+ *
+ * Identifies the operation requested in a QoS Management transaction.
+ * Reference 11.25.2 and 11.25.3, IEEE Std 802.11-2024, for the operation
+ * values.
+ */
+enum nl80211_qm_req_type {
+	NL80211_QM_ADD_REQ,
+	NL80211_QM_REMOVE_REQ,
+	NL80211_QM_CHANGE_REQ,
+};
+
+/**
+ * enum nl80211_qm_status - QoS Management response status codes
+ * @NL80211_QM_STATUS_SUCCESS: request accepted
+ * @NL80211_QM_STATUS_DECLINED: request declined
+ */
+enum nl80211_qm_status {
+	NL80211_QM_STATUS_SUCCESS = 0,
+	NL80211_QM_STATUS_DECLINED = 1,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d790e204aee3..3bf7aa5c9386 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -798,6 +798,93 @@ static const struct netlink_range_validation q_range = {
 	.max = INT_MAX,
 };
 
+static const struct nla_policy
+nl80211_qm_tclas_type4_policy[NL80211_QM_TCLAS_TYPE4_ATTR_MAX + 1] = {
+	[NL80211_QM_TCLAS_TYPE4_ATTR_CLASSIFIER_MASK] = { .type = NLA_U8 },
+	[NL80211_QM_TCLAS_TYPE4_ATTR_IP_VERSION] = { .type = NLA_U8 },
+	[NL80211_QM_TCLAS_TYPE4_ATTR_SRC_IP] = { .type = NLA_BINARY,
+					      .len = NL80211_IPADDR_MAX_LEN },
+	[NL80211_QM_TCLAS_TYPE4_ATTR_DST_IP] = { .type = NLA_BINARY,
+					      .len = NL80211_IPADDR_MAX_LEN },
+	[NL80211_QM_TCLAS_TYPE4_ATTR_SRC_PORT] = { .type = NLA_U16 },
+	[NL80211_QM_TCLAS_TYPE4_ATTR_DST_PORT] = { .type = NLA_U16 },
+	[NL80211_QM_TCLAS_TYPE4_ATTR_DSCP] = NLA_POLICY_MAX(NLA_U8, 63),
+	[NL80211_QM_TCLAS_TYPE4_ATTR_PROTOCOL] = { .type = NLA_U8 },
+	[NL80211_QM_TCLAS_TYPE4_ATTR_NEXT_HEADER] = { .type = NLA_U8 },
+	[NL80211_QM_TCLAS_TYPE4_ATTR_FLOW_LABEL] =
+		NLA_POLICY_EXACT_LEN(NL80211_QM_TCLAS_TYPE4_FLOW_LABEL_LEN),
+};
+
+static const struct nla_policy
+nl80211_qm_tclas_type10_policy[NL80211_QM_TCLAS_TYPE10_ATTR_MAX + 1] = {
+	[NL80211_QM_TCLAS_TYPE10_ATTR_PROT_INSTANCE] = { .type = NLA_U8 },
+	[NL80211_QM_TCLAS_TYPE10_ATTR_PROT_NUMBER] = { .type = NLA_U8 },
+	[NL80211_QM_TCLAS_TYPE10_ATTR_FILTER_VALUE] = {
+			.type = NLA_BINARY,
+			.len = NL80211_QM_TCLAS_TYPE10_MAX_FILTER_LEN },
+	[NL80211_QM_TCLAS_TYPE10_ATTR_FILTER_MASK] = {
+			.type = NLA_BINARY,
+			.len = NL80211_QM_TCLAS_TYPE10_MAX_FILTER_LEN },
+};
+
+static const struct nla_policy
+nl80211_qm_tclas_policy[NL80211_QM_TCLAS_ATTR_MAX + 1] = {
+	[NL80211_QM_TCLAS_ATTR_USER_PRIORITY] =
+			NLA_POLICY_MAX(NLA_U8, IEEE80211_NUM_UPS - 1),
+	[NL80211_QM_TCLAS_ATTR_CLASSIFIER_TYPE] = { .type = NLA_U8 },
+	[NL80211_QM_TCLAS_ATTR_TYPE4_PARAMS] =
+			NLA_POLICY_NESTED(nl80211_qm_tclas_type4_policy),
+	[NL80211_QM_TCLAS_ATTR_TYPE10_PARAMS] =
+			NLA_POLICY_NESTED(nl80211_qm_tclas_type10_policy),
+};
+
+static const struct nla_policy
+nl80211_qm_qos_policy[NL80211_QM_QOS_ATTR_MAX + 1] = {
+	[NL80211_QM_QOS_ATTR_CONTROL_INFO] = { .type = NLA_U32 },
+	[NL80211_QM_QOS_ATTR_MIN_SVC_INTERVAL] = { .type = NLA_U32 },
+	[NL80211_QM_QOS_ATTR_MAX_SVC_INTERVAL] = { .type = NLA_U32 },
+	[NL80211_QM_QOS_ATTR_MIN_DATA_RATE] = { .type = NLA_U32 },
+	[NL80211_QM_QOS_ATTR_DELAY_BOUND] = { .type = NLA_U32 },
+	[NL80211_QM_QOS_ATTR_MAX_MSDU_SIZE] = { .type = NLA_U16 },
+	[NL80211_QM_QOS_ATTR_SVC_START_TIME] = { .type = NLA_U32 },
+	[NL80211_QM_QOS_ATTR_SVC_START_TIME_LINK_ID] =
+			NLA_POLICY_MAX(NLA_U8, IEEE80211_MLD_MAX_NUM_LINKS - 1),
+	[NL80211_QM_QOS_ATTR_MEAN_DATA_RATE] = { .type = NLA_U32 },
+	[NL80211_QM_QOS_ATTR_BURST_SIZE] = { .type = NLA_U32 },
+	[NL80211_QM_QOS_ATTR_MSDU_LIFETIME] = { .type = NLA_U16 },
+	[NL80211_QM_QOS_ATTR_MSDU_DELIVERY_INFO] = { .type = NLA_U8 },
+	[NL80211_QM_QOS_ATTR_MEDIUM_TIME] = { .type = NLA_U16 },
+};
+
+static const struct nla_policy
+nl80211_qm_desc_params_policy[NL80211_QM_DESC_ATTR_MAX + 1] = {
+	[NL80211_QM_DESC_ATTR_QM_ID] = { .type = NLA_U8 },
+	[NL80211_QM_DESC_ATTR_REQUEST_TYPE] =
+		NLA_POLICY_MAX(NLA_U8, NL80211_QM_CHANGE_REQ),
+	[NL80211_QM_DESC_ATTR_PRIORITY] = { .type = NLA_U8 },
+	[NL80211_QM_DESC_ATTR_TCLAS_ELEMENTS] =
+			NLA_POLICY_NESTED_ARRAY(nl80211_qm_tclas_policy),
+	[NL80211_QM_DESC_ATTR_TCLAS_PROCESSING] =
+		NLA_POLICY_MAX(NLA_U8,
+			       NL80211_QM_TCLAS_PROCESSING_MATCH_ALL_EXCEPT_FIRST),
+	[NL80211_QM_DESC_ATTR_QOS_ATTRIBUTES] =
+			NLA_POLICY_NESTED(nl80211_qm_qos_policy),
+	[NL80211_QM_DESC_ATTR_STATUS] = { .type = NLA_REJECT },
+	[NL80211_QM_DESC_ATTR_USER_PRIORITY_BITMAP] = { .type = NLA_U8 },
+	[NL80211_QM_DESC_ATTR_USER_PRIORITY_LIMIT] =
+		NLA_POLICY_MAX(NLA_U8, IEEE80211_NUM_UPS - 1),
+	[NL80211_QM_DESC_ATTR_TCLAS_MASK] = { .type = NLA_U8 },
+};
+
+static const struct nla_policy
+nl80211_qm_policy[NL80211_QM_ATTR_MAX + 1] = {
+	[NL80211_QM_ATTR_MAC_ADDR] = NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN),
+	[NL80211_QM_ATTR_QM_TYPE] = NLA_POLICY_MAX(NLA_U8,
+						   NL80211_QM_TYPE_MAX - 1),
+	[NL80211_QM_ATTR_DESCRIPTOR_PARAMS] =
+			NLA_POLICY_NESTED_ARRAY(nl80211_qm_desc_params_policy),
+};
+
 static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[0] = { .strict_start_type = NL80211_ATTR_HE_OBSS_PD },
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
@@ -1201,6 +1288,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_ASSOC_CIP] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CIP_CAPABILITIES] = { .type = NLA_U8 },
 	[NL80211_ATTR_ASSOC_PROTECTED_TWT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_QOS_MGMT] = NLA_POLICY_NESTED(nl80211_qm_policy),
 };
 
 /* policy for the key attributes */
-- 
2.34.1

