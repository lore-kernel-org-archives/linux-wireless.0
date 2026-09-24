Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56913D1CB4
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217705; cv=none; b=eTZWCJ/D+OMtHIZhDrdz/X+vlIkxBE3Xe47HGzzmgLHPz5wObtWA3EIXtt1EwEduPQY7bZevN/LwhGC90KK82hYkpYW/grRwomcKlicZWyotGH1r1EkzNw0pQeZI8R0XVZH3iIF3z2jZffPSQsCwfTxO+7PxEWUFC3Mw859Qto8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217705; c=relaxed/simple;
	bh=A5JcIqBFxQ0+a5/+IVFf55NYSny4vDEgxMVzcOHWaHw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gOFQVj/FfdMaSAJmPsguZvE8fqORt4Fma+Sd3xwnEqYWDx12DR4yZeKt8EGhwklwPlqtPQHoUHZzSDREfBh6KPWfp+/zjzH/g11pBnSqPX1kNBAfms4UdEqG1kR5PymD6kaUL24NSqgGtjqSHq8pSI+wH9ZZ7rVJKwjEUpK78c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VRy946jA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kgFp55cb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VRy946jA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kgFp55cb"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O2JvZ8999844
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ODyR1rthMpA1mqS2BL6bd97tNxqZN2OWPjCXhXyDeWQ=; b=VRy946jAk4C009Z0
	w2GESdysnp+1Ngh9OUwSHxuOpIZibdyiopIhoed9iwUrV4zqScaXvlt36gn0KB1H
	vClo8JqizlTQp55GcsnEG1rNVDe7Cmvb0+/3Y1EHcrvV2YeVQlHujWgvqTeKVqsQ
	KtCYWo6DxuAhGS7wIpFg8WreJTywPYpm2xNcc53ZWgFmq+4g3zvHAyRYLvO0NEXk
	TLEFyoTrNZOyEtE5JFvHLQTK/EiagT/9zK+hlPa1tXHZypE8YEnzJe4QeGsUY9zo
	SCWU/sTBqywUKBfJdXipS9w0ibtVDeoJxYPnrwMiMlt0sEVfSK6VICKVChLviAUR
	ptWFRg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvbwmbwm6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:38 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3286d2bac04so1873044eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 19:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790217698; x=1790822498; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ODyR1rthMpA1mqS2BL6bd97tNxqZN2OWPjCXhXyDeWQ=;
        b=kgFp55cbEiOpgTCiCSJC8V1MYJemjfePcCn8GUtbsXO4pEEZMVrxPm8u++/FwPhMOT
         trw8IUK0Dzov8S6pXqq1j3jewoh7/BDhmiqFhwFvT+HX6OvHMod517VaQo+p4U+Odif/
         ajoUKTVf8x0UlzAOyg/wfwvxXf78+wLr0Gh3gRWLeASjS/xHD8VEtum2I9nJqoifo65x
         egWPVuQj0kROCAJKGOq0p8LrP3KqlG8UcGoTdP4sz/hSTCkf613i4sRYMLeI4D995zqF
         8gigO6AtniplJi3IuIeTXDGs3snS/WwZrHQGQT2hV86PhjnP8BWcT5kPCHEneTAnIl/U
         WKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217698; x=1790822498;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ODyR1rthMpA1mqS2BL6bd97tNxqZN2OWPjCXhXyDeWQ=;
        b=Io/ZwQrOWgGL5W28U4/UymuJ4+QcJmuk3Cl3YfIqYyOnwH0ql7bP3bAzENHgTEcZ9T
         K5aeWDyZQWrWJzJ7+Ics/XFOoN/su35idFWqW/rKbNFG203lWV4W+C4zEvxK3dEW14j2
         Baxv3d1FZ1zPnNzX9nBBl51HrFhIn7Rr2M9MN7eS81KHb/dWsQyblpViQSRZS2GnzI8N
         c4ohfGe9feeDvbO9UTesvljeTTi39NUPTOkaynnXzlzE38hoAJ25hRfrKLq2oJT6HhLf
         oLDJWXYlrgnt0VX1VmK10t1h2dohfN8a4ARb3uwxPH/d9izu8qX8JLc5MZJIohEZDRUb
         cuQg==
X-Gm-Message-State: AFuF++k+MG1Xuu77ths3uXpPKoMaJWoP4OwoOkdLZz30/XVaE25DIZLK
	L/rHFwrynhtxRbLVP7OtnCeWtOxVx67MlCNv/DdoD7PVuoAJ1brqLMfzREeCN0bIAuC4CLcbMKE
	UQTBZxNwKtpO6xNzdrXyIa8VDRa5NKRMZo19T20U5YGOfXHZG1wBRohceEXu4OqEwSfzd5pvse4
	me
X-Gm-Gg: AYBFou3cYDGO7oQq8Z51suJAKk9LziuzxWNdW1nmzngDR1wp7QojZkZ8A+pRqIe8U4v
	0EXDEppgpoS0qWFInzzvk/8GYgEDVPUWdQwZq9PW23DzfrT5uT5eLpehbJMVdWcxL3CmENEKBub
	hfrOwEgLBjekbx4WeiN86YjGm8v9dvbui9TXNfNBxCMMTm7UXq56f8v+ne9ZQF2tXmvK52JVsAO
	VMbVz6EjV3WM06379yuBIjqnygOFd5Qzn/lJ1QYpP7tWosbfabq+1g4Oj1O/I6x7x1aD8uYdpBo
	YKMHJECHtYj6XKcAyZ+Sqxs2sCVQcBU76JxN4ighndk80rajcgLhcJRnVaRfLAzl23l6gw5K+XY
	SR6RuCdi/0NP++LWdeQJ54aULugo9V2PZzlQO9AnAdf4xL0PwEjxqYNQTGlfb9lVfbSdpJ918tD
	sDQ8DMH9eFQJKIg5iNj3TxwA==
X-Received: by 2002:a05:7300:c019:10b0:33b:c24c:47cd with SMTP id 5a478bee46e88-340035bf9d9mr822558eec.16.1790217698030;
        Wed, 23 Sep 2026 19:41:38 -0700 (PDT)
X-Received: by 2002:a05:7300:c019:10b0:33b:c24c:47cd with SMTP id 5a478bee46e88-340035bf9d9mr822530eec.16.1790217697377;
        Wed, 23 Sep 2026 19:41:37 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96258351sm9692263eec.12.2026.09.23.19.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:41:36 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 08:10:39 +0530
Subject: [PATCH wireless-next v2 02/16] wifi: nl80211: Add kernel
 interfaces for Seamless Mobility Domain setup
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-smd-v2-2-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
In-Reply-To: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX4K4MtsOpIt1g
 /b4boKN/XRDC7yNqby6vJKXR+2zFT4BvFFqHugzA6wBASg3UuD2OlLlsjf8QahqiZGEn4THticZ
 bgQOp7HungSDUWWo51iZPSpxo2Qrw78=
X-Authority-Analysis: v=2.4 cv=R/6WitRX c=1 sm=1 tr=0 ts=6ab48de2 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=WqWJlBuMtEtNw8dGTc8A:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: nHvcmNFV_LJSSEqifn8DOybbE7RycuJZ
X-Proofpoint-ORIG-GUID: nHvcmNFV_LJSSEqifn8DOybbE7RycuJZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX68I+ItFQKfRf
 TKwUZiVCBNbE5AGYWOx4UQ5fwKPcUTaH6IWZRVJZhVMYy8eqIESWlyG7KHBv1C8GrOu6hPUMYyx
 GkBEF4XcgwZ6bz9WjgF2V4+D5L4DPjGw2kmC6IFuKQNyujaV611GYu0313IoavDJx4pAIn7dIuR
 dACdjbKRDsjsjXgfnG+/Znjs3d0B+Xyx86zBLFo+AKbLFBeBAC6uiZLixnBAAtAdUAIKudtphXi
 vM/0bqMx0m9jMbHNGKK6jOvgrog6GBWvIJ6WYe9tHoQ+a1IZKtML6hKgttJTyZz7SZfgvFIhwrF
 L5FfArbq9MWNpvN0RPoa3WwKBp95JytnODCJG42Xl0fIQKdevkLaoz3cwIv5Q65Cdz89zwDeBKd
 kzZDZ0AphBQzrSJg7+/cF36R7za06FTEvgchfzF/s3kFvxcZNxZ98/767mFt39yyDR3wPfesmW8
 g1+Aggs6JCtMEaQAocg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 malwarescore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240012

From: Aditya Sathish <asathish@qti.qualcomm.com>

An AP MLD managed by an SMD-ME must advertise its SMD parameters in
Beacon and Probe Response frames so that an SMD-capable non-AP MLD can
negotiate SMD during association and may choose to later perform SMD BSS
Transition. Add nl80211 kernel interfaces for userspace to configure
these parameters in nl80211_start_ap() so that the driver and lower
layers can be configured with appropriate parameters.

Signed-off-by: Aditya Sathish <asathish@qti.qualcomm.com>
Co-developed-by: Rohan Dutta <drohan@qti.qualcomm.com>
Signed-off-by: Rohan Dutta <drohan@qti.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/linux/ieee80211-uhr.h |  4 ++
 include/uapi/linux/nl80211.h  | 95 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c        | 17 ++++++++
 3 files changed, 116 insertions(+)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index 19e9260d0db8..c3f87d4c8bec 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -589,6 +589,10 @@ ieee80211_uhr_dbe_cap(const struct ieee80211_uhr_cap *cap)
 #define IEEE80211_SMD_INFO_CAPA_TYPE			0x10
 #define IEEE80211_SMD_INFO_CAPA_PTK_PER_AP_MLD		0x20
 
+/* IEEE P802.11bn/D2.0, Aug 2026, subclause 9.4.2.363 */
+#define IEEE80211_SMD_INFO_PREP_TIMEOUT_MIN		2 /* in 64 TUs */
+#define IEEE80211_SMD_INFO_NUM_PREP_AP_MAX		7
+
 struct ieee80211_smd_info {
 	u8 id[ETH_ALEN];
 	u8 capa;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d05103889912..1177a511c8cb 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3190,6 +3190,12 @@ enum nl80211_commands {
  *	known station to transmit a frame. This is relevant to know whether
  *	MLD address translation happened or to disable it when sending a frame.
  *
+ * @NL80211_ATTR_SMD_PARAMS: Nested attribute to indicate support for Seamless
+ *	Mobility Domain (SMD); it contains parameters to define capabilities of
+ *	an AP managed by an SMD-ME. Valid if the driver supports
+ *	%NL80211_EXT_FEATURE_SMD.
+ *	Used with %NL80211_CMD_START_AP. See &enum nl80211_smd_params_attrs.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3792,6 +3798,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_FRAME_NO_STA,
 
+	NL80211_ATTR_SMD_PARAMS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -9131,4 +9139,91 @@ enum nl80211_nan_peer_map_attrs {
 
 #define NL80211_NAN_SCHED_NOT_AVAIL_SLOT 0xff
 
+/**
+ * enum nl80211_smd_type - Type of the SMD
+ *
+ * @NL80211_SMD_TYPE_PER_AP_MLD_MAC_SAP: Separate MAC SAP is used per AP MLD.
+ * @NL80211_SMD_TYPE_PER_SMD_MAC_SAP: one MAC SAP is used in the SMD.
+ * @NUM_NL80211_SMD_TYPES: internal.
+ * @NL80211_SMD_TYPE_MAX: Max type of the SMD.
+ *
+ * This value represents the data path models between the non-AP MLD and DS.
+ * DS mapping for the non-AP MLD is updated if
+ * %NL80211_SMD_TYPE_PER_AP_MLD_MAC_SAP is used.
+ *
+ * All AP MLDs within an SMD shall indicate the same SMD type (refer
+ * IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.1.2).
+ */
+enum nl80211_smd_type {
+	NL80211_SMD_TYPE_PER_AP_MLD_MAC_SAP,
+	NL80211_SMD_TYPE_PER_SMD_MAC_SAP,
+
+	NUM_NL80211_SMD_TYPES,
+	NL80211_SMD_TYPE_MAX = NUM_NL80211_SMD_TYPES - 1,
+};
+
+/**
+ * enum nl80211_smd_ptk_mode - PTK Mode used in the SMD
+ *
+ * @NL80211_SMD_PTK_MODE_PER_SMD_PTK: one PTK is used by all AP MLDs in the SMD.
+ * @NL80211_SMD_PTK_MODE_PER_AP_MLD_PTK: Separate PTK is used per AP MLD.
+ * @NUM_NL80211_SMD_PTK_MODES: internal.
+ * @NL80211_SMD_PTK_MODE_MAX: Max type of PTK mode.
+ *
+ * This value represents the security mode of the SMD that dictates the PTK used
+ * in current and target AP MLDs to protect communications with the non-AP MLD
+ * (refer IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.1.3.2)
+ */
+enum nl80211_smd_ptk_mode {
+	NL80211_SMD_PTK_MODE_PER_SMD_PTK,
+	NL80211_SMD_PTK_MODE_PER_AP_MLD_PTK,
+
+	NUM_NL80211_SMD_PTK_MODES,
+	NL80211_SMD_PTK_MODE_MAX = NUM_NL80211_SMD_PTK_MODES - 1,
+};
+
+/**
+ * enum nl80211_smd_params_attrs - SMD Domain parameters
+ *
+ * @NL80211_SMD_PARAMS_ATTR_UNSPEC: Invalid attribute.
+ * @NL80211_SMD_PARAMS_ATTR_IDENTIFIER: Required (binary) attribute of ETH_ALEN
+ *	bytes used to define the unique identifier for the SMD.
+ * @NL80211_SMD_PARAMS_ATTR_TIMEOUT: Required (u16) attribute to define the SMD
+ *	Preparation timeout (in 64 TUs, values 0 and 1 are reserved) for
+ *	the target AP MLD.
+ * @NL80211_SMD_PARAMS_ATTR_DL_DATA_FORWARDING: Flag attribute to indicate that
+ *	the device supports forwarding of buffered DL data packets.
+ * @NL80211_SMD_PARAMS_ATTR_MAX_PEER_APMLDS: Required (u8) attribute to define
+ *	the maximum number of AP MLDs a non-AP MLD can prepare with. Value is
+ *	the maximum number of AP MLDs - 1. A value of 0 means that the non-AP
+ *	MLD can prepare with 1 AP MLD.
+ * @NL80211_SMD_PARAMS_ATTR_TYPE: Required (u8) attribute to indicate the
+ *	SMD Type (&enum nl80211_smd_type).
+ * @NL80211_SMD_PARAMS_ATTR_PTK_MODE: Required (u8) attribute to indicate the
+ *	PTK mode used for protection (&enum nl80211_smd_ptk_mode).
+ * @NL80211_SMD_PARAMS_ATTR_NEIGHBOR_PROBING: Flag attribute to indicate that
+ *	the device supports UHR Neighboring AP Probing.
+ * @__NL80211_SMD_PARAMS_ATTR_LAST: Last attribute, used internally.
+ * @NL80211_SMD_PARAMS_ATTR_MAX: Max attribute.
+ *
+ * Nested attributes carried in %NL80211_ATTR_SMD_PARAMS to define
+ * device capabilities that is part of an SMD (refer IEEE P802.11bn/D2.0,
+ * Aug 2026, subclause 9.4.2.363, Figure 9-aa43 and Figure 9-aa44).
+ *
+ */
+enum nl80211_smd_params_attrs {
+	NL80211_SMD_PARAMS_ATTR_UNSPEC,
+	NL80211_SMD_PARAMS_ATTR_IDENTIFIER,
+	NL80211_SMD_PARAMS_ATTR_TIMEOUT,
+	NL80211_SMD_PARAMS_ATTR_DL_DATA_FORWARDING,
+	NL80211_SMD_PARAMS_ATTR_MAX_PEER_APMLDS,
+	NL80211_SMD_PARAMS_ATTR_TYPE,
+	NL80211_SMD_PARAMS_ATTR_PTK_MODE,
+	NL80211_SMD_PARAMS_ATTR_NEIGHBOR_PROBING,
+
+	/* keep last */
+	__NL80211_SMD_PARAMS_ATTR_LAST,
+	NL80211_SMD_PARAMS_ATTR_MAX = __NL80211_SMD_PARAMS_ATTR_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ab5a14f5fe28..de93b34444b4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -689,6 +689,21 @@ nl80211_nan_conf_policy[NL80211_NAN_CONF_ATTR_MAX + 1] = {
 	[NL80211_NAN_CONF_NOTIFY_DW] = { .type = NLA_FLAG },
 };
 
+static const struct nla_policy
+nl80211_smd_params_policy[NL80211_SMD_PARAMS_ATTR_MAX + 1] = {
+	[NL80211_SMD_PARAMS_ATTR_IDENTIFIER] = NLA_POLICY_ETH_ADDR,
+	[NL80211_SMD_PARAMS_ATTR_TIMEOUT] =
+		NLA_POLICY_MIN(NLA_U16, IEEE80211_SMD_INFO_PREP_TIMEOUT_MIN),
+	[NL80211_SMD_PARAMS_ATTR_DL_DATA_FORWARDING] = { .type = NLA_FLAG },
+	[NL80211_SMD_PARAMS_ATTR_MAX_PEER_APMLDS] =
+		NLA_POLICY_MAX(NLA_U8, IEEE80211_SMD_INFO_NUM_PREP_AP_MAX),
+	[NL80211_SMD_PARAMS_ATTR_TYPE] =
+		NLA_POLICY_MAX(NLA_U8, NL80211_SMD_TYPE_MAX),
+	[NL80211_SMD_PARAMS_ATTR_PTK_MODE] =
+		NLA_POLICY_MAX(NLA_U8, NL80211_SMD_PTK_MODE_MAX),
+	[NL80211_SMD_PARAMS_ATTR_NEIGHBOR_PROBING] = { .type = NLA_FLAG },
+};
+
 static const struct netlink_range_validation nl80211_punct_bitmap_range = {
 	.min = 0,
 	.max = 0xffff,
@@ -1098,6 +1113,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 		NLA_POLICY_FULL_RANGE(NLA_U32, &nl80211_punct_bitmap_range),
 	[NL80211_ATTR_STA_DUMP_LINK_STATS] = { .type = NLA_FLAG },
 	[NL80211_ATTR_FRAME_NO_STA] = { .type = NLA_FLAG },
+	[NL80211_ATTR_SMD_PARAMS] =
+		NLA_POLICY_NESTED(nl80211_smd_params_policy),
 };
 
 /* policy for the key attributes */

-- 
2.34.1

