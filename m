Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CB0331A63
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974082; cv=none; b=TDaBsuGMVlfbbNuhdNJ8Sl1yn1DxXJ70xuS/XMjH2DHZic6i4hod0rp4WPdJbsU/3t+oxB44dWtuBJ3xf5EDPJDa7NpXZOo2TTB8L7Gkms14VayLN/uvEm57nQV01UJu2p4ysazL0Oo0KnhqgjTAeReXxAX1NhmKc5xZdw6SUi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974082; c=relaxed/simple;
	bh=MnTUV/Jz6j6e3g6+IEbmh7HDPF8DvOI5YuJGi73Ghvw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u8i+jaaEBa03O7aBL+Wo9HnqcY+x7t8XfquyqadZIqxV0AcEcXMOhbmZkK3VBf8QMylYR7Pm/fgTt3/eBifgSfTgjCTVsGmK/e5HrbsMrp+DWwF+3vsFg5iTFoaVMzUTauWyXIq4YKJbgul98bBNUDCe788un8KNv5V6oE2uJBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=K1wO9vhu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=N6I0OGma; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="K1wO9vhu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="N6I0OGma"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E68GZU2516033
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=QM2RHEkzAZR
	MTFC4Og9lQILAJ1gU36HGUXKTbnW3sBo=; b=K1wO9vhuvUHM3b6L9uWJ9gVQ2h6
	jiDPrNdHFjbqWv6kK5T8v9RWMF9Hc10/XEr9CWTOMLkq43u3HVE9+7qSNq022O55
	CKdg2HmE8eNnwuvjYAS5xRpvsuoooC+gZFtniXAoYGomZbKlF8J9O0g2C5E81Oc2
	06bPh/gyqii/WHcHq3qanSkEwQ6X0/koMyugZGIR3UmJq/9OmwPSYMEDoNnDvBbQ
	EhDnQ8BkP2pHL02saV5uwKxaK7mnr6taRU2BMS1hLpFOwacNv/jn6oraVvyg2L2C
	dL+2aevlTz4KMl4foRGcwhvOxt0bLHW7AJ9GOxUyBnDn3PE1DG0W/W2dlQA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha47093an-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:39 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3552883bd19so6545133eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974078; x=1792578878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QM2RHEkzAZRMTFC4Og9lQILAJ1gU36HGUXKTbnW3sBo=;
        b=N6I0OGmas4g5siVNbaSMqvz8+PmVX1m0cxcsq6MK4FeNOTRt/3hCqh2bcsbvVvF1hV
         pR/EkO133ku35e1e+Nc16o1WLSJUin3nR5LCmwwScuL3oIsdttz/po29Xm7pZDdvBvQU
         GNrmVfTfbD11SMGFA+Ev9eKPn0iidq/osiiM0mN3Aecb2kPvGdMWQZrVBDgkkgyq+udO
         OI6uB+/XyiwoF7sGC22SNR1QS+w3Xd/2ew9pJUUA+DGoYpetBAATnFXTGXxYPIcw8qp4
         ep0yQXvR04YO4iK36weBbTrtGGrcTP7nxFWNmqkXaiz2MKzMfqix3fl7V3AbEaPZIwbv
         3XIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974078; x=1792578878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QM2RHEkzAZRMTFC4Og9lQILAJ1gU36HGUXKTbnW3sBo=;
        b=AZFWk5p7HHFYxJ93Hokxx6kV9ECwwJ2dRDMG107DJ8W3MaOwu3nSL+I55P3QlwyrfN
         GOBvSdBm60IgM1O8IlhZT1VT0u2kaSpEBHfU/imDXfsAuhUcvRpNBa8Lj8qYy4vf4jPu
         9R+nIb1o2uOn00+Efu2n186sOqC4XVkBR0TZmL1uPxsb/qvYlyBWNemP7HG2oMQSLeY9
         a6XUrEVcRrmqpWMx6KXtORJw51ZIyIxdilrwiYTDa9EGDWIQLqCRoocWZtdnwhugUVd+
         Ghar1Nm/G/jeIIqcbO1wzisffu1iPMQ+CAW2K30asy9im7gjfe1kS0yDUptz6jTdJKnK
         3fqg==
X-Gm-Message-State: AFq9FYL3fhh7gUBGv4jUHtLU29RIUi49svSumyiNJqyK/XQ9mKn6QeJU
	tRPtOBFPuJA0YI3EZf0v40R75mvcqOIScN4rOlSLqbVNFeMcGIsrS1dh51rgr/bKSRYmDj69woo
	/UBfcFFZCiasEhj/Om1IHOCv+Pk4J4VIiSb5ifrkU2SlfQdhZDAPkNMSeLqRRFwi/IrtVHByP1x
	zbdA==
X-Gm-Gg: AYBFou1d2zIYmDP/cdTwH8VfdzxjHeRpDTagJKsObtgPHg2VdMqS+rfd4MJ6G+9zdtw
	CukgNJefZNGHEuwMcx5dzkCOPEnmo3QyqvKAICnrWkXFhD4xp9XBCMi2hX3tGd4U1Ij93Fpzlbr
	5+nGo/YRyXB22o71k1aAKKT6jGYnoTcHtoJtWNvoi4F6EpPLHInvM4SMHINA+eweGCfzrYBa0u4
	b4OQJW4qXX8AAVCkSHZbfu6Xfh1EPU/OmdqkmYV0i8EASFpit81eMDrQ9N0odDp+nrU7O2VqokO
	mG4u3AzHgoMLs5Ye51jTzwDui2tPmKtFmsxWiQEJOes9RYOg8mEyrfXCLEYWIyO7v5xdBLG3Mc5
	7PsUKOh3lq+IdkQPhXlQZNjkXKd+gGZArrwyT
X-Received: by 2002:a05:693c:4141:20b0:35c:8d1f:5634 with SMTP id 5a478bee46e88-35c8d1f58e8mr6996946eec.12.1791974078361;
        Wed, 14 Oct 2026 03:34:38 -0700 (PDT)
X-Received: by 2002:a05:693c:4141:20b0:35c:8d1f:5634 with SMTP id 5a478bee46e88-35c8d1f58e8mr6996903eec.12.1791974077622;
        Wed, 14 Oct 2026 03:34:37 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:37 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 07/15] wifi: nl80211/cfg80211: add support for discovery-based NAN ranging
Date: Wed, 14 Oct 2026 16:03:51 +0530
Message-Id: <20261014103359.1508345-8-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX2aaxPZgIBl1y
 hYRdbzr6IkODb6fab8AixQryG6pNlMHaAKnV5UypNHdhOwO6f8PxDSpcY/Ox6DHubHVREmTT+Ns
 vHP4DAbokeLtbJaw1gI5aQcTrq2HlGIBosX8YHtNW8sVpVEtwUXXin1YXC49ACK1cMbmeJmGvfl
 Xu33JXbu9+QGatFyWHixTpjIShLVxkDphJBi9ozq1y+9pPe3WQd1ntIMT5Od/wHnFcGtyL9dYuF
 6br1+zUxQ5vgAIiVunVDmNqzGFos/mjYdui6k85R9Rs7uFmtnzVMCqwcwXOdghaH2hPcVm2w82a
 WGZgW3xgHlMaDNTSjCWoNVLLV30+FpQux4WEmBFR5EuojJY7RUyRY/Jgn8r5fVwbck4RGjVLRjN
 b7zhGw+YKR37aK4uzMZyF6lYuBStSNZVnMm10+EpKC4tBdg10RVFTJud/jJ7+zTkRdXlg4BjW0P
 NkrD44aI+cc2fbyEelA==
X-Proofpoint-GUID: OYY0BEaT-gvs69BiG6pWjbXfGJ4DboAt
X-Authority-Analysis: v=2.4 cv=P6avFSAu c=1 sm=1 tr=0 ts=6acf5abf cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=n5cb5sDjdK1EdKB_5o0A:9 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: OYY0BEaT-gvs69BiG6pWjbXfGJ4DboAt
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX0Qy86vmtuqQ5
 SYzFdqXfHnL+pS7j3LwbqPjG4c2FaGYA3vT/7QgpeWflIMPZc/LSPZv+z+Lv9zezTOjJMOiAAFC
 1VBA9s5ho9y+90sfkDlqoI8lbIieeTA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140041

From: Kavita Kavita <kavita.kavita@oss.qualcomm.com>

Extend the NAN function configuration with ranging parameters
including ranging interval, ingress/egress Geofence thresholds,
and FTM parameters to allow userspace (e.g., wpa_supplicant) to
configure NAN Ranging as part of NAN Service Discovery in offload
mode.

Add the corresponding nl80211 attributes and parse them in cfg80211
for the NL80211_CMD_NAN_ADD_FUNC command. As mandated by the Wi-Fi
Aware Specification, a NAN device must set the Ranging Required bit
(bit 7) in the SDEA control field to indicate ranging intent, so the
driver/firmware can perform NAN Ranging as part of NAN Service
Discovery.

Signed-off-by: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       |  21 +++++++
 include/uapi/linux/nl80211.h |  23 ++++++++
 net/wireless/nl80211.c       | 103 +++++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 59f921c578c2..6ac4e2e22881 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4407,6 +4407,19 @@ struct cfg80211_nan_func_filter {
  * @pairing_cache: if true, this service supports NAN pairing caching.
  * @pairing_verify: if true, this service supports NAN pairing
  *	verification using a cached NPK.
+ * @ranging_interval: interval in milliseconds between two consecutive
+ *	ranging measurements, or 0 if not specified.
+ * @ingress_distance: inner geofence threshold in millimetres, or 0 if
+ *	not specified.
+ * @egress_distance: outer geofence threshold in millimetres, or 0 if
+ *	not specified.
+ * @ftms_per_burst: number of FTM frames per burst, or 0 if not specified.
+ * @preamble: PHY preamble for FTM frames, see &enum nl80211_preamble,
+ *	or %NL80211_PREAMBLE_LEGACY if not specified.
+ * @chandef_valid: if true, @chandef is valid.
+ * @chandef: channel definition for FTM ranging.
+ * @range_report: if true, a NAN Ranging Report is required after the FTM
+ *	session.
  */
 struct cfg80211_nan_func {
 	enum nl80211_nan_function_type type;
@@ -4442,6 +4455,14 @@ struct cfg80211_nan_func {
 	bool pairing_setup;
 	bool pairing_cache;
 	bool pairing_verify;
+	u32 ranging_interval;
+	u32 ingress_distance;
+	u32 egress_distance;
+	u8 ftms_per_burst;
+	enum nl80211_preamble preamble;
+	bool chandef_valid;
+	struct cfg80211_chan_def chandef;
+	bool range_report;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ab35ff8082ad..1e640a03e73d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7775,6 +7775,20 @@ enum nl80211_nan_func_term_reason {
  * @NL80211_NAN_FUNC_ND_PMK: %NL80211_NAN_NDP_PMK_LEN-byte pre-shared NAN
  *	Data Path PMK (ND-PMK).
  *	Requires %NL80211_EXT_FEATURE_SECURE_NAN.
+ * @NL80211_NAN_FUNC_RANGING_INTERVAL: u32 attribute. Interval in
+ *	milliseconds between two consecutive ranging measurements.
+ * @NL80211_NAN_FUNC_INGRESS_DISTANCE: u32 attribute. Inner geofence
+ *	threshold in millimetres.
+ * @NL80211_NAN_FUNC_EGRESS_DISTANCE: u32 attribute. Outer geofence
+ *	threshold in millimetres.
+ * @NL80211_NAN_FUNC_FTMS_PER_BURST: u8 attribute. Number of FTM
+ *	frames per burst.
+ * @NL80211_NAN_FUNC_PREAMBLE: u32 attribute. PHY preamble type for
+ *	FTM frames (see &enum nl80211_preamble).
+ * @NL80211_NAN_FUNC_CHAN: channel definition for FTM ranging, nested,
+ *	using top-level attributes like %NL80211_ATTR_WIPHY_FREQ etc.
+ * @NL80211_NAN_FUNC_RANGE_REPORT: flag indicating that a NAN Ranging
+ *	Report is required after the FTM session.
  *
  * @NUM_NL80211_NAN_FUNC_ATTR: internal
  * @NL80211_NAN_FUNC_ATTR_MAX: highest NAN function attribute
@@ -7804,6 +7818,13 @@ enum nl80211_nan_func_attributes {
 	NL80211_NAN_FUNC_PAIRING_CACHE,
 	NL80211_NAN_FUNC_PAIRING_VERIFY,
 	NL80211_NAN_FUNC_ND_PMK,
+	NL80211_NAN_FUNC_RANGING_INTERVAL,
+	NL80211_NAN_FUNC_INGRESS_DISTANCE,
+	NL80211_NAN_FUNC_EGRESS_DISTANCE,
+	NL80211_NAN_FUNC_FTMS_PER_BURST,
+	NL80211_NAN_FUNC_PREAMBLE,
+	NL80211_NAN_FUNC_CHAN,
+	NL80211_NAN_FUNC_RANGE_REPORT,
 
 	/* keep last */
 	NUM_NL80211_NAN_FUNC_ATTR,
@@ -7819,11 +7840,13 @@ enum nl80211_nan_func_attributes {
  *
  * @NL80211_NAN_FUNC_SDEA_CTRL_DATAPATH_REQUIRED: bit 2 - Data Path Required.
  * @NL80211_NAN_FUNC_SDEA_CTRL_SECURITY_REQUIRED: bit 6 - Security Required.
+ * @NL80211_NAN_FUNC_SDEA_CTRL_RANGING_REQUIRED: bit 7 - Ranging Required.
  * @NL80211_NAN_FUNC_SDEA_CTRL_GTK_REQUIRED: bit 10 - GTK Required.
  */
 enum nl80211_nan_func_sdea_ctrl_flags {
 	NL80211_NAN_FUNC_SDEA_CTRL_DATAPATH_REQUIRED	= 1 << 2,
 	NL80211_NAN_FUNC_SDEA_CTRL_SECURITY_REQUIRED	= 1 << 6,
+	NL80211_NAN_FUNC_SDEA_CTRL_RANGING_REQUIRED	= 1 << 7,
 	NL80211_NAN_FUNC_SDEA_CTRL_GTK_REQUIRED		= 1 << 10,
 };
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 412d4e599046..e480f556ce62 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1346,6 +1346,15 @@ nl80211_nan_func_policy[NL80211_NAN_FUNC_ATTR_MAX + 1] = {
 	[NL80211_NAN_FUNC_PAIRING_SETUP] = { .type = NLA_FLAG },
 	[NL80211_NAN_FUNC_PAIRING_CACHE] = { .type = NLA_FLAG },
 	[NL80211_NAN_FUNC_PAIRING_VERIFY] = { .type = NLA_FLAG },
+	[NL80211_NAN_FUNC_RANGING_INTERVAL] = { .type = NLA_U32 },
+	[NL80211_NAN_FUNC_INGRESS_DISTANCE] = { .type = NLA_U32 },
+	[NL80211_NAN_FUNC_EGRESS_DISTANCE] = { .type = NLA_U32 },
+	[NL80211_NAN_FUNC_FTMS_PER_BURST] = { .type = NLA_U8 },
+	[NL80211_NAN_FUNC_PREAMBLE] =
+		NLA_POLICY_RANGE(NLA_U32, NL80211_PREAMBLE_LEGACY,
+				 NL80211_PREAMBLE_HE),
+	[NL80211_NAN_FUNC_CHAN] = { .type = NLA_NESTED },
+	[NL80211_NAN_FUNC_RANGE_REPORT] = { .type = NLA_FLAG },
 };
 
 /* policy for Service Response Filter attributes */
@@ -17674,6 +17683,100 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 		}
 	}
 
+	if (tb[NL80211_NAN_FUNC_RANGING_INTERVAL] ||
+	    tb[NL80211_NAN_FUNC_INGRESS_DISTANCE] ||
+	    tb[NL80211_NAN_FUNC_EGRESS_DISTANCE] ||
+	    tb[NL80211_NAN_FUNC_FTMS_PER_BURST] ||
+	    tb[NL80211_NAN_FUNC_PREAMBLE] ||
+	    tb[NL80211_NAN_FUNC_CHAN] ||
+	    tb[NL80211_NAN_FUNC_RANGE_REPORT]) {
+		const struct cfg80211_pmsr_capabilities *pmsr_capa =
+			rdev->wiphy.pmsr_capa;
+
+		/* SDEA Ranging Required bit must be set */
+		if (!(func->sdea_ctrl & NL80211_NAN_FUNC_SDEA_CTRL_RANGING_REQUIRED)) {
+			NL_SET_ERR_MSG(info->extack,
+				       "NAN ranging parameters require SDEA Ranging Required bit");
+			err = -EINVAL;
+			goto out;
+		}
+
+		if (!(wdev->wiphy->nan_capa.flags &
+		      WIPHY_NAN_FLAGS_OFFLOAD_RANGING) ||
+		    !pmsr_capa || !pmsr_capa->ftm.supported) {
+			NL_SET_ERR_MSG(info->extack,
+				       "NAN ranging not supported by device");
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+
+		if (tb[NL80211_NAN_FUNC_RANGING_INTERVAL])
+			func->ranging_interval =
+				nla_get_u32(tb[NL80211_NAN_FUNC_RANGING_INTERVAL]);
+
+		if (tb[NL80211_NAN_FUNC_INGRESS_DISTANCE])
+			func->ingress_distance =
+				nla_get_u32(tb[NL80211_NAN_FUNC_INGRESS_DISTANCE]);
+
+		if (tb[NL80211_NAN_FUNC_EGRESS_DISTANCE])
+			func->egress_distance =
+				nla_get_u32(tb[NL80211_NAN_FUNC_EGRESS_DISTANCE]);
+
+		if (tb[NL80211_NAN_FUNC_FTMS_PER_BURST]) {
+			func->ftms_per_burst =
+				nla_get_u8(tb[NL80211_NAN_FUNC_FTMS_PER_BURST]);
+			if (func->ftms_per_burst > 31) {
+				NL_SET_ERR_MSG_ATTR(info->extack,
+						    tb[NL80211_NAN_FUNC_FTMS_PER_BURST],
+						    "NAN FTMs per burst exceeds limit of 31");
+				err = -EINVAL;
+				goto out;
+			}
+			if (pmsr_capa->ftm.max_ftms_per_burst &&
+			    func->ftms_per_burst > pmsr_capa->ftm.max_ftms_per_burst) {
+				NL_SET_ERR_MSG_ATTR(info->extack,
+						    tb[NL80211_NAN_FUNC_FTMS_PER_BURST],
+						    "NAN FTMs per burst exceeds device limit");
+				err = -EINVAL;
+				goto out;
+			}
+		}
+
+		if (tb[NL80211_NAN_FUNC_PREAMBLE]) {
+			func->preamble =
+				nla_get_u32(tb[NL80211_NAN_FUNC_PREAMBLE]);
+			if (!(pmsr_capa->ftm.preambles & BIT(func->preamble))) {
+				NL_SET_ERR_MSG_ATTR(info->extack,
+						    tb[NL80211_NAN_FUNC_PREAMBLE],
+						    "NAN ranging: unsupported preamble");
+				err = -EINVAL;
+				goto out;
+			}
+		}
+
+		if (tb[NL80211_NAN_FUNC_CHAN]) {
+			/* Reuse info->attrs for chandef parsing; the original contents
+			 * are no longer needed.
+			 */
+			memset(info->attrs, 0,
+			       sizeof(*info->attrs) * (NL80211_ATTR_MAX + 1));
+			err = nla_parse_nested(info->attrs, NL80211_ATTR_MAX,
+					       tb[NL80211_NAN_FUNC_CHAN],
+					       nl80211_policy, info->extack);
+			if (err)
+				goto out;
+			err = nl80211_parse_chandef(rdev, info->extack,
+						    info->attrs,
+						    &func->chandef, false);
+			if (err)
+				goto out;
+			func->chandef_valid = true;
+		}
+
+		func->range_report =
+			nla_get_flag(tb[NL80211_NAN_FUNC_RANGE_REPORT]);
+	}
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg) {
 		err = -ENOMEM;
-- 
2.34.1

