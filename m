Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367061;
	b=mwcYGDSApETnN2d1HVb5RfPc0z7k/1vLp/Z/otp5nNmdLiYKp2QXYaWyDJqZ/XBVzoS3
	 EuUeelBYTssKwdP7+cXGoKAxGCxcoj5mQWgltY1WPadeNad4fIuA1LxKpjJCFiUWAz96W
	 t9t0xmO732ni7+ase5jTiYHtJyZOKQqvYtNCfT6e1opR+Sge8UwnRoEcSApfTcDvZb5YE
	 33pBPK/59pv+d1YvDGKV3Rd3IXzLLcdHKqDm+lV0ejWnLICQnkmXCZSOcAa2W18D4diF3
	 DAebuFVG+hHmFmP9RZLAQayUjsfhUVi6bYwhBpe7j7OytDQjRGEDnyyhHG92j6tc0bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367061;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=WfnVWL+SYdPqpnFWi06vHvSuEbhz7XZg/CIKV+g2oJc=;
	b=HIHu7+rNdo9hF7Gy19Egl3fJMI27qTisAOwh8ctuSRGJstlr1typ6v/0n8SfCkmnlaB5
	 8sR3Wh8MUeSRwoHi57+uztLJjF/ujQJLiHMdA1cvZUldRxi2EzzJ7CyKaFoaqpVYI0S2j
	 Odi7uLu/qu5dBJY2hHTJd1sfohnbmQcAlfFIo7g8tkhHTyZqGV1urgkipuAKtOMuRsPuX
	 9d68aBYCczR95NcKkT6dYVE0+kqLn3QWZ9MELF67/9tMZvrSCs9Wi8XUp6ruDaygTPSqV
	 7bk8yKjWCs3t7v0SEkYk6DPuOT7wllOQmNVEpfU0E1ADS7gYB4+dPbn9CErlNBoRb2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HnY09Exm;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Y3VwsQrc;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97539606A32E
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97539606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HnY09Exm;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Y3VwsQrc
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBG9q43719582
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=WfnVWL+SYdP
	qpnFWi06vHvSuEbhz7XZg/CIKV+g2oJc=; b=HnY09ExmpTuv5UImti/VlVNrneO
	BKz9tk3KLPfVhsUnune2/Ri8VC0712OG1Bw3PUnRQBv9QZzKI7OKmbs/QebDLkis
	T0iGl33ENttrUsgiSBrJL96a/UHGwUD6uKUC2fCKzp0cgXmy+1P2r6JNUYYMDudW
	Rsp+i8nv56M0NjbzdxVkhiIfc0vm1X9qRI1gm7xbGrEzJuovBvMZYBQZ8JJHyhvN
	Yk9nu/nzzJBsOTjYkjpW9aAjB5TRBCmae43lwW9XVNcVHB2HcR9D3JXU+L6o71g7
	/kEJQwnQXkV79GpbgFWW4OekBUROsZORP0F1VGs4/R5FdNCklyhY4U46r1A==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qu6rg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:51 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ad91787a1aso563881a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367051; x=1793971851; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WfnVWL+SYdPqpnFWi06vHvSuEbhz7XZg/CIKV+g2oJc=;
        b=Y3VwsQrcpC8r2jjo80BCDvmsIYKjYavpqyguXqF8Hrqtyf9altHAkpzbVPqk2+nNsN
         hr1Hg5gktk02UYwHWnMEwdkMk06OIxZ5VeF53cBjNtID4swcvu4dokvgeF5gRO9Qtyni
         bYw98JLQhIN1HnKQv96gQCSGDGtSdqm4D+8yjmnbC2wKx8e/Pdi8S7lhnLESQ2d3Jd/c
         aWXJocN5/YhEWp6U+cRxRM11nOEdS+brm9tpl1TfaiZjIYHLLrEpL2AeU6ehGR5xfwfx
         afaDIRJCChG7cFcU11ZJ+LOV3IR/TjI29/9w59Gbv5hGtNhkxwdE9Y6Cemrcu+CBxuUo
         bF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367051; x=1793971851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WfnVWL+SYdPqpnFWi06vHvSuEbhz7XZg/CIKV+g2oJc=;
        b=BYxTooJGqdZI7ZmbuNm+NK/9ktV2RvBKfPmPoDH0i+X60q1WozP5rtDmsg2SVKx1xD
         QS9aWtoASNyxWXkf8prZX5HBGWGj4Z9cGYZWBFlheCok3ohJOW5JBYYmvqqLjwusNFl+
         +Dl1Tw9RctEcad0doBvRbP1t8lcwjzFWcCL+HfRP1cLh8J/5tO72mmG1Y10jrXIDp+p1
         9PfXySxb9BqaxFjve4PA5WaOuKe16LDnO6d0/qO9MjDHHZV0Hk9ZyQa7Fqr8ouUxm/hv
         7e27RMSt7i5bo4EhibSCt+JzzU97bIz4Wc/B8qJkHDRuZrkmBRBnI9kTZLaIpJ3XtVCV
         HgUg==
X-Gm-Message-State: AFq9FYJrO3j5lnAybeSm2UuHTHdC4wMRyROvvtMVWxcz/uMeRXvnzFzY
	tnZd9db/so2vqvfc5DIjxqXc4vgayLip/EYoBxD58dDNA0f6xMAaxkH71n9/GZNb1Dh6m2gD60J
	dBoLfKT8vbKQJofL/MmAWF5v8XypNPcF7DPQCQ2bxUkdBId67jGRRZ3wBbivta2xUViJ1fQ==
X-Gm-Gg: AYBFou0ZuCngFu/F3Rs4SWkM39MMh+JjctHdwvcfyKFF9pFcPrpdKiXJgI1KmrX6gol
	Rjnq1n8jt1yrvCzQn0NL7NL03VXkYA0PCXKKEVH8odAnAanLNvF3bjsWMuu45pInBUtSJ7Oux3y
	37f0FY27pV9MDGEUIvbDmLAakF6VRoHCkehf6zHveSGqRQ7hoZw2LnFKraeVxCQO5bghDUUco7i
	td57FllYiEmYhkNS+Z0aDMbwQHh7v9GRDGLYblHOzS19curuULtRiP15uggYo3uMsZXWDBRR/jq
	ugCPyefjdR7U7qr8+wTeax6hMhgoLF4mTCL9pOEUioPUQVZfNFtYZjR47VNTH+hm7e2BrdDethO
	oHb3Lh22FkHA8lWnhntIckId2vpAVo+Neg6QrSlOYrrz115+fwu0wO17UGHiqtwzW6TkYSz5bXg
	qGK2EuiWePng==
X-Received: by 2002:a17:90b:3c4e:b0:3ac:9925:72ae with SMTP id 98e67ed59e1d1-3ae89766636mr1692237a91.31.1793367050389;
        Fri, 30 Oct 2026 06:30:50 -0700 (PDT)
X-Received: by 2002:a17:90b:3c4e:b0:3ac:9925:72ae with SMTP id 98e67ed59e1d1-3ae89766636mr1692201a91.31.1793367049731;
        Fri, 30 Oct 2026 06:30:49 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:30:49 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 07/16] wifi: nl80211/cfg80211: add support for discovery-based NAN ranging
Date: Fri, 30 Oct 2026 19:00:03 +0530
Message-Id: <20261030133012.3009774-8-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-GUID: ZV1bWsomQd2YvtFlVpbAMlPDrNVJRH_W
X-Proofpoint-ORIG-GUID: ZV1bWsomQd2YvtFlVpbAMlPDrNVJRH_W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfXxJnPGzNK2SLq
 JRStAHiXkLBqpVEyEh8nU6BNlI1MRpeAhW9/mK5fE9QQKJQGZbWwkq4ouWuCNk9kk9rQp6ofXuN
 2BNWM5WCpeHQyoEackQL3WU8NqXFr62DtHnhY2beTyyPsCD5FJRpmLpbZXwEA9GhS97hgYJmrPM
 t5NY5DrviKEOJxSSDM6wCtHPC3ILrbfjojsr0YQwVfanfNg7q+OSy3PA+kezexH9jszZNPWHS3F
 5dPYGOYMVrJy1rwIuam12Zc8Tb7tthRwIDBEvwf3xAoJiwgZxToT47SyMP+0zBUywczhNkAqhVO
 mOQQaXiwfspav8SARkCK/elfABGuvQn29gfDOkhOa9ZFLY5HwaP6uqvSK843+0ceeZd+Dm3JCYg
 ovXvZCfwp39gWYQDxnR1NxP+5TAgyM75DZloWJm05PH8ACjd6nyY+77MTpCzzbFkmXSmSpck3Mh
 f/mHp/Gz7CcB+is5zhw==
X-Authority-Analysis: v=2.4 cv=dPgzC+Zb c=1 sm=1 tr=0 ts=6ae49c0b cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=n5cb5sDjdK1EdKB_5o0A:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX4JmLrm+/EYnI
 t1BW9DTXAuuSRhuubtIxiVQMePHIGjv88SZHelNV7THzWkTaHYvKhdC2t1cWJy2aZ8EaDVkGu54
 CPUw17V2WsW4LEp7E62AZF+/EL5kZ4M=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300053

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
index ff898c04ae01..08cbd231bf47 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4410,6 +4410,19 @@ struct cfg80211_nan_func_filter {
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
@@ -4445,6 +4458,14 @@ struct cfg80211_nan_func {
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
index 58db809c2e00..28c02cf395a1 100644
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
@@ -17691,6 +17700,100 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
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

