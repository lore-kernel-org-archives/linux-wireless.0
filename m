Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367051;
	b=rPPTUzrLirnBxnpkbFesrPx4HyczGTQsqMWBVWyZcry88F8uKe62O6sQxMF5J7F5k1Eg
	 zfXLVIr2f+Lia3luqoWcUHZwevvkiiSdNOzND2wcSbZCNh3eFOsP5BPcFuB2UAvdSnu8t
	 Otjv/1Ccgux6hJ8cXH5jbWZEdxaHP5Snrc6rRxgY5RZXsdhF0JW7kdj5bE99091dymDu1
	 Sd/ePEpAqo8MucnMkBOcAZy1Yyp76dpf/xWQ2WGMxZqtb2di31egq1fsoJAluZFyvkPUS
	 xsDk9/ObnCHqnduWvK+CUkXeF6+MDnTfCENcWzXMwdAtOKXbg+7IOLsi7WQw/C69F8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367051;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=X6DN2CZyjX6AvHsxZnR9D5lONSNbgymzzOUSTXtdwU8=;
	b=YVHIdqexZ8/CpI9CsR0aOSqGFeyX//OIbAk0k1yCy2yRTSrXcHNSNXLJeUAfgRcxjXw/
	 aZmOWLBxAVtek7pJtAVAIKq07bCgLoNyLQ0X6M06ooHbpxj8V0AoEqSpaC5IoXdqhnCrc
	 uRGdhrbHJvIsVGvhqmjAm7h0UwfZl6rVSpdLTh1B/AxL2YpIc0MUlwTtt1//Il6sW9meC
	 ++vNerOkaYUFJoRAIid936FXiOPgDKaaqS8idCRuxMpuKGeP2IIoVoMvNal5UE4shetl7
	 jLK52qKN+/FzfOHFICPxfmmzVjc2ouoRS0EUfszvAQGmrI6gfKz6itufTVU3dnOU7HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cIM2VAJo;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="XtSiPO/8";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D66606A31E
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75D66606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cIM2VAJo;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XtSiPO/8
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBG3HX3142127
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=X6DN2CZyjX6
	AvHsxZnR9D5lONSNbgymzzOUSTXtdwU8=; b=cIM2VAJoKlfWRDYcpAyRI4MMkzn
	HGMHMrIzo26OVRCBn3ura1LwFADaz4kbDzr4sH1c730Q6BhgdEBMUSG6zPwWRhJB
	o3H1436lJQUQ/tP9ZJbGw8OzHZFGLpDVBTHu846x69D7sQEsquwcRHCN/C9w2D5z
	QfOOPqqsR+2hUfIrcK+KBE4VUwxjaJ6HW5CGjNR2/Fi18VsX8Csd7IVCB9EfnnET
	Q+qxhsVmC81smWEwoCDin/C5Uugjb/wc+GZ+vULUwJZnYD0511g8lXK04lgghnWV
	9DNk1zhjK2WXcIYxgFzEzQiPZYB+7/vM4pBJKM6kHRPQ+xkYk+tmk312cXA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qk6w2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:49 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3adc5b185bfso770624a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367048; x=1793971848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X6DN2CZyjX6AvHsxZnR9D5lONSNbgymzzOUSTXtdwU8=;
        b=XtSiPO/824TNCbCFruSyJXFpfVIyxbLTRct0+NthMBSVe8VIJHqYzVIJGxdCdeBeRj
         2D+cmhXMXZZKDAZXEPaPmE+4hI38sglhWSzdx9AoGC/Hljn6hAcTez69iHkRRxKlmUKo
         KgZnNXMpO2I/uTyKG9yQmUUhJ+HDGJl6Q/+g86marZvj6Ba0+c7jw2Y0lTQeC0RY14/j
         9r+mZ7pV5QHqVECe92RHLrgGQ4q0DKStOZV1317Ma8IIPoSxXw/8O9atPKGsRKDUU27O
         Vp9bdptIQYU0aK2O3lWhoobY7qin5TH8OqtgnFjB8BdZVKr5RkXd8MHSRSFVvNDb6aSm
         rMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367048; x=1793971848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X6DN2CZyjX6AvHsxZnR9D5lONSNbgymzzOUSTXtdwU8=;
        b=lrjoslPR6R4i1yRZTKTuSOn9GkJjsvlZD7tgVvxcY2dw99X7uGiTeNr9jzhVJFbwmH
         KKKhEGPAq6A6HyyPtgFpu7SDLTaRTAO39D/MecCSIicWSGLrW//lWYu+8hWf2iYr0E4X
         zuJOrym7kBvkEIbFhj/nly41us6vWJWGYFNMU4RxVbShI4BdYYBTXePHKvS+4aueE4ur
         SX+oGZzNC0OuJ0/hnmHmUDuQLxTl/+TBELM3JhMuI4PF6lLzAGNAShQmz8xXOdFhG5gN
         ZFjj/CITrs+SYHcp5ktWjrkU4A4jegQImeEzpnkDtGhKxkhyX1jg63DG7yTyH8jxrRzm
         6VYQ==
X-Gm-Message-State: AFq9FYL4Cq017VxmAVLf+yAJjmQTVG41Z3+FUUQfzYeFaKIZcVIO0Q4p
	UxxpWWcl5XyPC5UwXbuUJmatzFJBTOTIc3p8yUBOCBKKH+PCUPgx05Tbf2FlmY7We1HYSa6RTia
	pOi+fPIe9qAENZyNZrplcIeDggOi6bHfbddKiKmI3xZ19XvBXHvbqlvpNCBxL4KMhqtmxT+tz8z
	fPpw==
X-Gm-Gg: AYBFou2PhD9MKQ5Nvv6Rb7iQaFkr6IdERJ22iRyMOX/h+522U7jUMlpM4VV1tgv4Gl/
	LipzzHm110SDSdlOgWSSYqGyid/u4dIkjS42A6VoX329wL01vt9NJNGGulSwKD8fwlzM4c5YUnL
	IC3YdefLmA+jv5nx8CuXpdq72J5ivKj3ItW2L44DzSDoT5Gc7p2fNYxX6iUO/IMfo2J4ux3OGSI
	eofdxY8mfZ1QXRpWoZrgZddExD0pKTjTM5GLpOGXph0hQT5aqoFO1+KBwP6wPBSW7+dkOYtgel2
	ZViAF/3rieR7MqZcdlde2g42wWYYD5W+TFTVe2mBAuea8+hhnx552ECDRzSyXwW1gkUDR+6Yn2x
	rd7oZMWz0gt/S0sfPHIj4xDgWAiTEww7CYspykONd7zLmMQrIfz3OkVpECfCiFlA2F56Ymld1DJ
	cDsyzeSLjCHg==
X-Received: by 2002:a17:90b:17c5:b0:3ab:413:49b1 with SMTP id 98e67ed59e1d1-3ae897c0a0dmr2053069a91.48.1793367048072;
        Fri, 30 Oct 2026 06:30:48 -0700 (PDT)
X-Received: by 2002:a17:90b:17c5:b0:3ab:413:49b1 with SMTP id 98e67ed59e1d1-3ae897c0a0dmr2053042a91.48.1793367047456;
        Fri, 30 Oct 2026 06:30:47 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:30:47 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 06/16] wifi: nl80211/cfg80211: add support for request-based NAN ranging
Date: Fri, 30 Oct 2026 19:00:02 +0530
Message-Id: <20261030133012.3009774-7-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-GUID: ouajWRVp5lPa-oftvQ3MVyx8niAoGYg3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX3QTQ8Se9zQLT
 s2H6tPnY2nc8wb9besJ33yAo0cfsHFyDydnnASQo+ggacgEv27vISO+Zr6qFykwSd2ELidhoXbo
 MUk/8GVPjeFAts6jobv9AtG7ztYX+O4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX/uaY4SLgtNgW
 lzdWx83ip3yhslVurifp7rMgK6EO0cOCcKFRcRY28mWxto7XAv/BxtHkPDfGADxFQ2V19O/vKfP
 IK/vMSfYHTIpA28lrDtK5VMbeeRYpGy16uPdPm/nzh6jbbzcRJ1cv2dmyVDG5q/RI3QPw7y3kxT
 pTob9CvZQJiwT96PbTW1mQZoRfBYMkG3CSgm6WNeS+AxS+dUMZlJ6GN9a4UK/R5g2UxNxghH95W
 qwlI8U/R4cB59+LOtR9794YhvlqIM4k70MdMvfSmwGmA43ic/zQOPViWmpRBOcpuzunk5lcxqGs
 LRkLBjMjQJyXbZZvR1zkeBwHPONCqdzhcJ32v4uJ+3TMAtRWwqI7bgCtkxUz6KEGl22usHcXMKL
 3tGPjZINY8NcKqqATQPSiu/EUd2Rp82UFK9u9+JpZukUcMOhJciSDK8wIlbZRjaXYXGnXIodvrx
 lD0HdfptX8QK7svCntQ==
X-Proofpoint-ORIG-GUID: ouajWRVp5lPa-oftvQ3MVyx8niAoGYg3
X-Authority-Analysis: v=2.4 cv=TpVzFzXh c=1 sm=1 tr=0 ts=6ae49c09 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=ZsUDbAycufZmAt45gsIA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 suspectscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300053

From: Kavita Kavita <kavita.kavita@oss.qualcomm.com>

Extend the peer measurement framework with a NAN FTM request type
to allow userspace (e.g., wpa_supplicant) to initiate a NAN Ranging
Request in offload mode.

Extend the nl80211 parser to handle NAN-specific FTM parameters and
validate the request type so the driver/firmware can identify and
trigger the NAN Ranging Session on behalf of userspace. Reject the
request if it is a NAN Ranging Request and the interface is not a
NAN interface, as mandated by the Wi-Fi Aware Specification, or if
the driver does not advertise NAN ranging capability.

Signed-off-by: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       |  10 ++-
 include/uapi/linux/nl80211.h |  11 ++++
 net/wireless/nl80211.c       |   5 +-
 net/wireless/nl80211.h       |   3 +
 net/wireless/pmsr.c          | 120 ++++++++++++++++++++++++++++++++++-
 5 files changed, 146 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 30269e370caf..ff898c04ae01 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4729,6 +4729,8 @@ struct cfg80211_pmsr_result {
  *		 @trigger_based or @non_trigger_based is set.
  * @rsta: Operate as the RSTA in the measurement. Only valid if @lmr_feedback
  *	and either @trigger_based or @non_trigger_based is set.
+ *	Also valid when @range_report is set and @request_type is
+ *	%NL80211_PMSR_FTM_REQ_TYPE_NAN.
  * @bss_color: the bss color of the responder. Optional. Set to zero to
  *	indicate the driver should set the BSS color. Only valid if
  *	@non_trigger_based or @trigger_based is set.
@@ -4774,6 +4776,10 @@ struct cfg80211_pmsr_result {
  *	provide ranging services to a peer (e.g. in RSTA role) but does
  *	not report the measurement results to userspace. Only valid when
  *	@request_type is %NL80211_PMSR_FTM_REQ_TYPE_PD.
+ * @range_report: a NAN Ranging Report is required after the FTM session.
+ *	Only valid for a NAN RSTA request.
+ * @min_delta_ftm: NAN Min Delta FTM value in units of 100 microseconds.
+ *	Zero indicates no preference.
  *
  * See also nl80211 for the respective attribute documentation.
  */
@@ -4790,6 +4796,7 @@ struct cfg80211_pmsr_ftm_request_peer {
 	   rsta:1;
 	u8 num_bursts_exp;
 	u8 burst_duration;
+	u8 min_delta_ftm;
 	u8 ftms_per_burst;
 	u8 ftmr_retries;
 	u8 bss_color;
@@ -4802,7 +4809,8 @@ struct cfg80211_pmsr_ftm_request_peer {
 	u32 num_measurements;
 	u64 ingress_distance;
 	u64 egress_distance;
-	u8 pd_suppress_range_results:1;
+	u8 pd_suppress_range_results:1,
+	   range_report:1;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 793015750f3f..ab35ff8082ad 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -8219,12 +8219,16 @@ enum nl80211_peer_measurement_resp {
  * @NL80211_PMSR_FTM_REQ_TYPE_PD: peer-to-peer ranging as defined in the
  *	Wi-Fi Alliance specification "Proximity Ranging (PR) Implementation
  *	Consideration Draft 1.9 Rev 1"
+ * @NL80211_PMSR_FTM_REQ_TYPE_NAN: NAN ranging between two NAN devices as
+ *	defined in the "Wi-Fi Aware Specification v4.0, clause 8".
+ *	Must be issued on a %NL80211_IFTYPE_NAN interface.
  * @NUM_NL80211_PMSR_FTM_REQ_TYPE: internal
  * @NL80211_PMSR_FTM_REQ_TYPE_MAX: highest request type value
  */
 enum nl80211_peer_measurement_ftm_req_type {
 	NL80211_PMSR_FTM_REQ_TYPE_INFRA,
 	NL80211_PMSR_FTM_REQ_TYPE_PD,
+	NL80211_PMSR_FTM_REQ_TYPE_NAN,
 
 	/* keep last */
 	NUM_NL80211_PMSR_FTM_REQ_TYPE,
@@ -8592,6 +8596,11 @@ enum nl80211_peer_measurement_ftm_type_capa {
  *	but results are not reported to userspace, regardless of ranging role
  *	or type. Only valid when %NL80211_PMSR_PEER_ATTR_REQ_TYPE is set to
  *	%NL80211_PMSR_FTM_REQ_TYPE_PD.
+ * @NL80211_PMSR_FTM_REQ_ATTR_RANGE_REPORT: Flag indicating that a NAN
+ *	Ranging Report is required after the FTM session. Only valid for a NAN
+ *	RSTA request.
+ * @NL80211_PMSR_FTM_REQ_ATTR_MIN_DELTA_FTM: NAN Min Delta FTM value in units
+ *	of 100 microseconds (u8, 0-63). A value of 0 indicates no preference.
  *
  * @NUM_NL80211_PMSR_FTM_REQ_ATTR: internal
  * @NL80211_PMSR_FTM_REQ_ATTR_MAX: highest attribute number
@@ -8622,6 +8631,8 @@ enum nl80211_peer_measurement_ftm_req {
 	NL80211_PMSR_FTM_REQ_ATTR_INGRESS,
 	NL80211_PMSR_FTM_REQ_ATTR_EGRESS,
 	NL80211_PMSR_FTM_REQ_ATTR_PD_SUPPRESS_RESULTS,
+	NL80211_PMSR_FTM_REQ_ATTR_RANGE_REPORT,
+	NL80211_PMSR_FTM_REQ_ATTR_MIN_DELTA_FTM,
 
 	/* keep last */
 	NUM_NL80211_PMSR_FTM_REQ_ATTR,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 059194e512b0..58db809c2e00 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -557,7 +557,7 @@ nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
 					     .len = U8_MAX },
 };
 
-static const struct nla_policy
+const struct nla_policy
 nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
 	[NL80211_PMSR_FTM_REQ_ATTR_ASAP] = { .type = NLA_FLAG },
 	[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE] =
@@ -589,6 +589,9 @@ nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
 	[NL80211_PMSR_FTM_REQ_ATTR_INGRESS] = { .type = NLA_U64 },
 	[NL80211_PMSR_FTM_REQ_ATTR_EGRESS] = { .type = NLA_U64 },
 	[NL80211_PMSR_FTM_REQ_ATTR_PD_SUPPRESS_RESULTS] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_REQ_ATTR_RANGE_REPORT] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_REQ_ATTR_MIN_DELTA_FTM] =
+		NLA_POLICY_MAX(NLA_U8, 63),
 };
 
 static const struct nla_policy
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index bdb065d14054..31a2c2eb6276 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -126,6 +126,9 @@ void cfg80211_free_coalesce(struct cfg80211_coalesce *coalesce);
 /* peer measurement */
 int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info);
 
+extern const struct nla_policy
+nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1];
+
 void nl80211_mlo_reconf_add_done(struct net_device *dev,
 				 struct cfg80211_mlo_reconf_done_data *data);
 
diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 97449bcb9a22..bcf5390174e4 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -306,11 +306,108 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
+static int pmsr_parse_ftm_nan(struct cfg80211_registered_device *rdev,
+			      struct nlattr *ftmreq,
+			      struct cfg80211_pmsr_request_peer *out,
+			      struct genl_info *info)
+{
+	const struct cfg80211_pmsr_capabilities *capa = rdev->wiphy.pmsr_capa;
+	struct nlattr *tb[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1];
+	int err;
+
+	err = nla_parse_nested(tb, NL80211_PMSR_FTM_REQ_ATTR_MAX, ftmreq,
+			       nl80211_pmsr_ftm_req_attr_policy,
+			       info->extack);
+	if (err)
+		return err;
+
+	out->ftm.requested = true;
+
+	/* NAN ranging requires ASAP; reject if not set by userspace */
+	out->ftm.asap = nla_get_flag(tb[NL80211_PMSR_FTM_REQ_ATTR_ASAP]);
+	if (!out->ftm.asap) {
+		NL_SET_ERR_MSG(info->extack,
+			       "FTM: NAN ranging requires ASAP mode");
+		return -EINVAL;
+	}
+	if (!capa->ftm.asap) {
+		NL_SET_ERR_MSG(info->extack,
+			       "FTM: NAN ASAP mode is not supported by device");
+		return -EOPNOTSUPP;
+	}
+
+	/* NAN ranging requires single burst (num_bursts_exp must be 0) */
+	if (!tb[NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP] ||
+	    nla_get_u8(tb[NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP]) != 0) {
+		NL_SET_ERR_MSG(info->extack,
+			       "FTM: NAN ranging requires single burst");
+		return -EINVAL;
+	}
+
+	out->ftm.rsta = !!tb[NL80211_PMSR_FTM_REQ_ATTR_RSTA];
+	out->ftm.range_report =
+		!!tb[NL80211_PMSR_FTM_REQ_ATTR_RANGE_REPORT];
+	if (out->ftm.range_report && !out->ftm.rsta) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[NL80211_PMSR_FTM_REQ_ATTR_RANGE_REPORT],
+				    "FTM: range report is valid only for NAN RSTA");
+		return -EINVAL;
+	}
+
+	if (tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE]) {
+		out->ftm.preamble =
+			nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE]);
+		if (!(capa->ftm.preambles & BIT(out->ftm.preamble))) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE],
+					    "FTM: unsupported preamble for NAN ranging");
+			return -EINVAL;
+		}
+	}
+
+	if (tb[NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST]) {
+		out->ftm.ftms_per_burst =
+			nla_get_u8(tb[NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST]);
+		if (out->ftm.ftms_per_burst > 31) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST],
+					    "FTM: NAN FTMs per burst exceeds limit of 31");
+			return -EINVAL;
+		}
+		if (capa->ftm.max_ftms_per_burst &&
+		    out->ftm.ftms_per_burst > capa->ftm.max_ftms_per_burst) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST],
+					    "FTM: FTMs per burst exceeds device limit");
+			return -EINVAL;
+		}
+	}
+
+	if (tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION])
+		out->ftm.burst_duration =
+			nla_get_u8(tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION]);
+
+	if (tb[NL80211_PMSR_FTM_REQ_ATTR_MIN_DELTA_FTM])
+		out->ftm.min_delta_ftm =
+			nla_get_u8(tb[NL80211_PMSR_FTM_REQ_ATTR_MIN_DELTA_FTM]);
+
+	if (tb[NL80211_PMSR_FTM_REQ_ATTR_INGRESS])
+		out->ftm.ingress_distance =
+			nla_get_u64(tb[NL80211_PMSR_FTM_REQ_ATTR_INGRESS]);
+
+	if (tb[NL80211_PMSR_FTM_REQ_ATTR_EGRESS])
+		out->ftm.egress_distance =
+			nla_get_u64(tb[NL80211_PMSR_FTM_REQ_ATTR_EGRESS]);
+
+	return 0;
+}
+
 static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 			   struct nlattr *peer,
 			   struct cfg80211_pmsr_request_peer *out,
 			   struct genl_info *info)
 {
+	struct wireless_dev *wdev = info->user_ptr[1];
 	struct nlattr *tb[NL80211_PMSR_PEER_ATTR_MAX + 1];
 	struct nlattr *req[NL80211_PMSR_REQ_ATTR_MAX + 1];
 	bool have_measurement_type = false;
@@ -344,6 +441,22 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 				    "FTM: PD request type not supported by device");
 		return -EINVAL;
 	}
+
+	if (out->ftm.request_type == NL80211_PMSR_FTM_REQ_TYPE_NAN) {
+		if (!rdev->wiphy.pmsr_capa->ftm.type.nan_support) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_PMSR_PEER_ATTR_REQ_TYPE],
+					    "FTM: NAN ranging not supported by device");
+			return -EOPNOTSUPP;
+		}
+		if (wdev->iftype != NL80211_IFTYPE_NAN) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_PMSR_PEER_ATTR_REQ_TYPE],
+					    "FTM: NAN ranging requires a NAN interface");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	/* reuse info->attrs */
 	memset(info->attrs, 0, sizeof(*info->attrs) * (NL80211_ATTR_MAX + 1));
 	err = nla_parse_nested_deprecated(info->attrs, NL80211_ATTR_MAX,
@@ -390,7 +503,12 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 
 		switch (nla_type(treq)) {
 		case NL80211_PMSR_TYPE_FTM:
-			err = pmsr_parse_ftm(rdev, treq, out, info);
+			if (out->ftm.request_type ==
+			    NL80211_PMSR_FTM_REQ_TYPE_NAN)
+				err = pmsr_parse_ftm_nan(rdev, treq,
+							 out, info);
+			else
+				err = pmsr_parse_ftm(rdev, treq, out, info);
 			break;
 		default:
 			NL_SET_ERR_MSG_ATTR(info->extack, treq,
-- 
2.34.1

