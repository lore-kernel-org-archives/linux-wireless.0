Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3C443DA2E
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813208; cv=none; b=uPgjHDdV/Sf4yepzE+DbhOIAhvSCrLDSvM+IJeqJ0Ifb/o8MTbXRpLHkc4ykhbQX4dADQDv2dX5YCDhAvb4Du46gE8gHAYvVZFq2HbiJ790RqCAJgJg1a3rtKmT/22KrWUBg6ur75Pj8oN9yJA5K+3zQBAZI6cjZYwFsA3Jp0ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813208; c=relaxed/simple;
	bh=BdDhSKqvE4bR6i94Z4PzJjpFNgCG9vS4dOfg0BJDMsA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SsZ8rCn22noZ/1/qXmHz5yRWzDQhdtbinM8W3lyVHYTNSH8KCOLWmNiVwEcL9KXExWY1lvb27bAUHc9sN6e37zjEkGgGSIh8M3pwWpqv/iJtYTYxrBGb4ZR+BhHtfEYwHfdSPoHNAPaLk1Hil1DmLIZBWgaEZToqQa0Bhp7TlUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iRY5eD/v; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Os+LXN6S; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iRY5eD/v";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Os+LXN6S"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687H85rv838247
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 20:33:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VQNR1mlZBEy+Xn7d0FfH0MwnsJQZNZ8utWBVHbu9Dpk=; b=iRY5eD/vXoH7sv8P
	k8JzvCxHSs9P+RfQUWcXUBDFagdmKTDSCzC4PTpuSp0UQXIgR+tINCzlXBWZAJvD
	9r5K3FQvYY7rJ+FmCl9Gxy5+6pDtaCMIx8aQc5780VQOi0HEUka/11YzUMKwCih5
	E6ZRNxwR5j5tGBIZqWfzzSKywD7HKs6CoG5fnwjEMpGSuATYrUOHmnnqLy1gbDpH
	IVwJ72CbXWr0Jgn76pcpqY0r8Dj1hWA6ZuW7s+B2UhJLkHd8hCJENRSyCRa0QViP
	EBmvQ9UnwaTZAA0Hc8MP0z6MZQIZ9K5Wqc5nmoIkxVyg+fQ6oBDB78WqDgU0oZZV
	ckUvrQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghssg2hya-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:33:25 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-385d2703b64so4864105a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788813204; x=1789418004; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VQNR1mlZBEy+Xn7d0FfH0MwnsJQZNZ8utWBVHbu9Dpk=;
        b=Os+LXN6Sq5wxv1TuQZ3x5Jp7deX4vskpiGI4WGmJtjuqmOJRA/A9Tzz0IhdOkd9IN+
         uSoe4yZ79cunFphkwFnt+WtL9B86tfe6Us+NLZg5CK0b9EV6F57hJ9Lo+pNuPVfz/HQF
         dZusoC9AvmN1+rwuwBZrehavQ9w4Ko2pyi4KeBczrubkoGM45UIw/YTUS+nls3N39Eis
         NEfe9d05SMDGKSEqyYSj/0dQMAgo3Jkg2X/DlQni/LjMriT4tqDFfd5ew+FNdMdYoM3O
         cYanoJrcv7LaqOfbXGE14p5dNwLZJjBpZ96bdV7qco+nsOozkdyMo6tJwIrXks4rlLHx
         1Eow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788813204; x=1789418004;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VQNR1mlZBEy+Xn7d0FfH0MwnsJQZNZ8utWBVHbu9Dpk=;
        b=rkQKNO5t6mcGLUWmUjZ5k8ikcykN6d4gtjEVWke3ykfP1Zut4Asc3q/tYt2q8JH5TW
         w/KBLhdxVCJMlewPmNcQzxaeXzdby8uXuV+S1FgIRdS4suRXX1wMQhGM8O6r6rSKP0Ci
         pP7q9O8g7NbQej1VEteXU57iT/ld5irg1B2GjChiTBywqe3MmWnm5cHYvFcRP0YRwBGC
         u2XhbSL9v0mVYc/RGHvPGZkOpDWFcIoyLdaglVWp93VtbpX+BcB8otS1plp2XZSquiRA
         H5JHrez8bc1E5uaZJZbY94vttEM3exFCZkgD0wB98uAJ7jFRv+7NMuZ5cB5XuEAZKJlo
         qK5g==
X-Forwarded-Encrypted: i=1; AKwUvBzM+R2NKFeTa4Mujn3Bnp8fVp724gP/bxbX013Fmt4oRZ9Iej6DoA8YTVsSmSEEeMQkXBgwHJN5ZgPz725VVQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lGOZBMZwvVh1/8J6aPY08yly/mbHVDlGGt664wkDJ2P2Z7aKKv
	Bf93D28DiJiN7ckP5+ruK4xmjC17ANKCB+a1d+7Ha0aOCXg8SpNeNInt0aerUpbFXN/EgNFaNm+
	FGbbrTVkMm/+QGhYatYzCY8XeFBzEUe38v2tfZWroxmEDlhuiZAih8VEy6iQ4INfvJMu6
X-Gm-Gg: AYBFou2RxUGyzABm8X/SJL5FYbZJs/4e4sTZXO6M3AS0FyifzmVN3mcZ1XgTYmvhgZ1
	qYLtW0HdhBtkE17F0oDvV+x0/IPC98qgEC8Kc+8IPc0tmoN10NQo7oZaGZG6Mw+TqrLgtOcEEvc
	Vy8qML6xc3Ji9FRnE1Xfe0Q77ovmxdLUCrsKWLWL9QZp3zEzipq7wqCtXTJBC/jbWor0i9WrB6V
	Z1AZDV05EIQ4wiRGFGN+WxhHS1nP+kJofIeDS6jHFT2iH2/rdwQfbHAFlglqKLEEgXmlTxtaVAz
	IwWq6WGCzpT8xNeEXmrojSE7M7KagmBs4ellBhnx9kktSR+6pfDWwN6YbIZYm7ohbirrNHqWesk
	ujRx2IIvrdC7vmBRzeAN7aMOYZZOFjHvbVr6tchUGi/ngVcfwTrGIpOkbSsd/RFtx5oozeTbsqp
	e419op4JkhqN2X0z7VFN0S+g==
X-Received: by 2002:a17:90b:35cf:b0:398:9beb:a2bc with SMTP id 98e67ed59e1d1-39b0881d765mr33799973a91.30.1788813204297;
        Mon, 07 Sep 2026 13:33:24 -0700 (PDT)
X-Received: by 2002:a17:90b:35cf:b0:398:9beb:a2bc with SMTP id 98e67ed59e1d1-39b0881d765mr33799937a91.30.1788813203786;
        Mon, 07 Sep 2026 13:33:23 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm47841297eec.16.2026.09.07.13.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:33:22 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Tue, 08 Sep 2026 01:59:12 +0530
Subject: [PATCH wireless-next 03/18] wifi: nl80211: Add kernel interfaces
 for Seamless Mobility Domain setup
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-smd-v1-3-65ad4ab30fbd@oss.qualcomm.com>
References: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
In-Reply-To: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX5EzOeCzHj3lt
 g8VYKS5SlVY/4Yd04zC27LTYtkRCh2oCop1Vv/YhobzvquykACnVX6i0z2ZDKuze3gCUgPGnzrH
 f6PPHy08dFEe4XPej2Olmq0Dza7s9tFSo9zrd2L0dh3G3TSlN/EktMvOINvyBGzJFBcPm9zTxz7
 YyRlKUuUJfNcUj/fl6g1XsBa+6sNsUMwcb7I8LOaKcOmtUEXO/O8mpIFKsZ16zz5kGsjCpLGcZq
 plNkuU539zjCH+XZJFccqehrJjppo5aCJtS+8iDUYPUHx7V6UaNHMEtPyF2vFEZH74QSrqxoncG
 9Xdv8b+AYth9ip19vJUjZOolx0ws/dis0Xr21xczRCEszGO5URc8rzX8b4TPxAl1vb0nJksjAcv
 wZL3b5Qawg5f1X7euDMO2GnTg1QakRsRnD8Vk9VQG6jK8ypUDoAwEZu0h2hcMRzAFAUpjg9ofHS
 On+86u8upYy/r7xmVNw==
X-Authority-Analysis: v=2.4 cv=MrJiLWae c=1 sm=1 tr=0 ts=6a9f1f95 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=WqWJlBuMtEtNw8dGTc8A:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: CSCHpyNq_SNlV-yg1iTMQNpvgnnzdFuI
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX5O3etsgmN0oF
 cXOvXAQbkwyvo1E79opfaRdaiWBCVzJg2OytXjEX5zSk/vZcrCB+jcM8T9yKmVsJccNJzQmkJNJ
 uz0YZgloYHg/zy6VQJ5iKJXGlP7yc0Q=
X-Proofpoint-GUID: CSCHpyNq_SNlV-yg1iTMQNpvgnnzdFuI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070226

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
index d9ce185b0ef1..f5c8dbe5f26a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3185,6 +3185,12 @@ enum nl80211_commands {
  *	The aggregated message always precedes the per-link messages for the
  *	same station within a dump sequence.
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
@@ -3785,6 +3791,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_STA_DUMP_LINK_STATS,
 
+	NL80211_ATTR_SMD_PARAMS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -9118,4 +9126,91 @@ enum nl80211_nan_peer_map_attrs {
 
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
index e585da1d79c9..22d71f32815f 100644
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
@@ -1097,6 +1112,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NPCA_PUNCT_BITMAP] =
 		NLA_POLICY_FULL_RANGE(NLA_U32, &nl80211_punct_bitmap_range),
 	[NL80211_ATTR_STA_DUMP_LINK_STATS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_SMD_PARAMS] =
+		NLA_POLICY_NESTED(nl80211_smd_params_policy),
 };
 
 /* policy for the key attributes */

-- 
2.34.1

