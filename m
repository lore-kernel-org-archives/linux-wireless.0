Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667E44EB864
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974080; cv=none; b=GwyWHHwWuXkgMpnRi6lJyYLbf/px/tLuxQAvGSDwDnhuS48AgI2IZCi9kh/msV6lRUBgyZyQXumpY8qYzMhIwMeSHV1BZ1rtV0d/sv0RFGggnkiQofFqzJ7sBOUJGPkH36KQmMKla8CpkU4pvQ/joMI0P0BGfTQDfEmMqoCIqP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974080; c=relaxed/simple;
	bh=v4bpLIFJX5SHz7O38lgS1lUC+/gae1E7ggZpcsEB3lA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lqx+FOoyU1yV4wxSyFEUkNVm/po4LqM51tUb+0vNfv6ZzX/62IEOAh3hwN82A8m3tCJIfgN2yjgJII2UelgKF2Tp3YglnZ9nv5NW8SSB5ugTVJWxZwsJ5o/YhL2bhF3NNXfNL+hthwUAaZT8ugJazSQp518uIVfuAswOgqYsUTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ivl+bwuL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gkIZg9+l; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ivl+bwuL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gkIZg9+l"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E7LTNU2874770
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=6Bpa/6M2eMw
	ZYNKN0eeHbMXs/bBDfg/kDKK2df2xFsk=; b=ivl+bwuLhVsMxPkp4efLmc5TWJY
	TJsk6Yyl6nEtFzys4KBb2Ua0xb/QMS7vE5e6Iy4xwpEPoawejeQ+hM4aYZovT/mv
	V1BM9oD4GJG/AxHZ+iIGrUH05P9IsF3SEUwzMU5pYlzS4YB5MB0smB0Uv/NgqpGq
	zTuGYPKzZyhkBvVTM2ZLvcqXSOgYhArwM5cNNgDwINB/a6W/+wnW+nmeDpXbVMq7
	s4VR+eF3GSzEB5IFlQ1R9tRBClvpcz1srPJZxwO6BLPW7y6fspN4ugqbUU7fdO53
	0rSnWli3Wq3ugruXOyVEXCe1b3AC16FKddZf4kk6fEJx9FxSAPna9xiTFcQ==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9yphj3ed-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:37 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3510d0baf63so2649670eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974076; x=1792578876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6Bpa/6M2eMwZYNKN0eeHbMXs/bBDfg/kDKK2df2xFsk=;
        b=gkIZg9+lelWIyds2Ceoluk8Y5U1d/3iopMGRPlUd8ijmxqZP3bNmPBR8PiIC8xIwCl
         w3UY/q9p0tEcNJOxWQZQ7LBXnHEVWJdeBPK4w8/74tT6MfxZLZYg/rHsO3G6KD5UoZmB
         0/tfo9iRmwiSAKCkH3PNMxLWOkNEYRz3FU+xZYjT6lmmdtrjB8WvZ444ht+ESmB6xpv1
         VKOLQ+IWcLFIVzvl1OUwDD0RRS/8MQ9Wu+i0+8OCXtHJ1MEIM/46moRbncLHYv05O950
         qU26peW7JfUXzgakFqel0UH81Z5pcXz8jSeehTboOviY3tF+G5RB1970VGBluqw56cfB
         n9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974076; x=1792578876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6Bpa/6M2eMwZYNKN0eeHbMXs/bBDfg/kDKK2df2xFsk=;
        b=Qp6Ltcj7Vkejl319SVC/gvEBNf2OjBPSO1L/XixpVJdq/rrOoszKfZox4/doxkDbiD
         jNJ3PJgmDxWKz6gjmacsrITVpCedCnE6ZOHasjXSLDL1NuJf61zZaNZkUd1CLaL9Scn3
         6PwZg41/AxgRzsoiJcuJwEouj8u3RfdLlhbafSTccT2DyxUQZkXZedh/me1lX8G9cn7T
         CD94RnORt6NTdFdvm55YJWTndMft7Ge2DCAizeEE9/bSrCE0580qurMyPfL1L+ctoVTc
         B4v2cvvs7nfB0397uF+z8vWStgZsltHH4PDRCntssoRK4iJzlsQ8PAlb9HYdzZmI1djr
         6/lQ==
X-Gm-Message-State: AFq9FYLRPaOMgyjHuUa3brXik620SRYYlOn1mftqQ/WyI4CrpqlJv1U6
	/sqx0o6Y4iR4PHd490vgAOcu4/AXglYoY428S4QPO1cjrefAOriVYJrMvFeKHEdGL5J3nY+/Csy
	VV18Onx8g8QJzxDERHgockrrV3LAEto+Ox8a0jTdwFkeiSV6avTQGO+AZ4/A19ShOynny2Alfc9
	KnIA==
X-Gm-Gg: AYBFou3FKPtqFsgcfIN+jkn2hfOMm/rMr3Ha47KyE+9yCh8jStUX3i2rqblECy27lm3
	urIPwGjc/JVfXVxdkoYHGSpRcynZHdKbH4l7HwnmLiS9ZpFjBkl9/q4I9XC2iZgR1faZaqcdkyS
	4l+inC1UG7bqrYb0mTouaF6mk7Jh7ydHg1fIUtTzZOokNWLeH/+z2CpF5Q87gHBpL3eYeNDfs7a
	l6zebz+MUcF4Nby5bJaCot+YeC+lojzYsgsPDBIAq0daElo/xhrCz9AmchnFIZdHnbF141iu5cD
	RKXPoT9yiyIJ8tZZ4w355i1rICP0uuTACXTDIJrmbVc39UeIK3ARA3x9VFkIab6wM1rqKyh3drs
	JLM0+D43pcBPckKYvMZ7dLOa6oxm3dB5d4zEC
X-Received: by 2002:a05:7300:8a1d:b0:351:35b3:c5b6 with SMTP id 5a478bee46e88-3537e0fbed7mr24083001eec.27.1791974075925;
        Wed, 14 Oct 2026 03:34:35 -0700 (PDT)
X-Received: by 2002:a05:7300:8a1d:b0:351:35b3:c5b6 with SMTP id 5a478bee46e88-3537e0fbed7mr24082956eec.27.1791974075269;
        Wed, 14 Oct 2026 03:34:35 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:34 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 06/15] wifi: nl80211/cfg80211: add support for request-based NAN ranging
Date: Wed, 14 Oct 2026 16:03:50 +0530
Message-Id: <20261014103359.1508345-7-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-GUID: Y0kM5RmOV9cR9b9nBoCOxfH5yeFo_vb1
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfXw9R/pFT7GymD
 N/aF0aweKwwwv7VgCS9iwYccAnLRLWfBk0c+CDSXTe2yRTT907A85nJUiN44fw6hWVweFijRMEd
 MEWokOOHD9s7zmUS+Go6hA3O474tLCY=
X-Proofpoint-ORIG-GUID: Y0kM5RmOV9cR9b9nBoCOxfH5yeFo_vb1
X-Authority-Analysis: v=2.4 cv=Uv72pOwB c=1 sm=1 tr=0 ts=6acf5abd cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=ZsUDbAycufZmAt45gsIA:9 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX99Y5JSkPb30R
 WJBqUcpNOt6/e/uBJscnTqzlyXPx0vUe4j9N/SWm5FEAAeUMinKlzVd2GP7EuxMmEDBfWmC090/
 7Tr92Ll4wpaPHGHSlNfqeiPS5xyrOzITmHxFGyAvORt6gcuNQSy9lb9AOKGLXQAPwHOIbmb/q/m
 dv+6MMLauBiFeTWf2Hj/vzYyAhEvKvLUFLZR7tnkQZoc7Z1aUjX/0Uu0aLbU9qaPET8cqa3Z/i/
 N0g79fhJw6ZARBStzCiIAmfKjE7crfHYhGl+UoUrg/u91Gescz/SPFJG1LKv5sYGqmSp5MW2j3n
 yPmiYxjmgX/2js8rLHeiCQW8iMdVULG9uOUGaqdtALiGq1GhKVTMyY33TXs4WVXGaILNjKX8RxN
 z+dzwasxb58DOwpEefgp9VHbjPdM33anlpU6f+XHwZTl5i9lOVySoQIdO2RIFdyKA6CJkDU7hcr
 Oz4oft7CVMwhk2yL97Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 priorityscore=1501
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140041

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
index 124480276b6b..59f921c578c2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4726,6 +4726,8 @@ struct cfg80211_pmsr_result {
  *		 @trigger_based or @non_trigger_based is set.
  * @rsta: Operate as the RSTA in the measurement. Only valid if @lmr_feedback
  *	and either @trigger_based or @non_trigger_based is set.
+ *	Also valid when @range_report is set and @request_type is
+ *	%NL80211_PMSR_FTM_REQ_TYPE_NAN.
  * @bss_color: the bss color of the responder. Optional. Set to zero to
  *	indicate the driver should set the BSS color. Only valid if
  *	@non_trigger_based or @trigger_based is set.
@@ -4771,6 +4773,10 @@ struct cfg80211_pmsr_result {
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
@@ -4787,6 +4793,7 @@ struct cfg80211_pmsr_ftm_request_peer {
 	   rsta:1;
 	u8 num_bursts_exp;
 	u8 burst_duration;
+	u8 min_delta_ftm;
 	u8 ftms_per_burst;
 	u8 ftmr_retries;
 	u8 bss_color;
@@ -4799,7 +4806,8 @@ struct cfg80211_pmsr_ftm_request_peer {
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
index 18da5cd456ef..412d4e599046 100644
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

