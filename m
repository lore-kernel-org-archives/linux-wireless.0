Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC75499F3C
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974084; cv=none; b=GIR7OArPWEqMHun9iifU6GiRjri12OPIpvc4VGOcBg6Uw02yurlqcbsvXwUT9kDaO7O06iJhdiWuJNfTVcKh78fwdLV6Y/XrLinRY48AqiSx9HlMG4gCSeQkWpmupwp157jxSlRYE2lrIRUYoeu37IPFHzUO/7ZsywNFi4VRHmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974084; c=relaxed/simple;
	bh=Fuyu/3hICcydXIExzzPKgCSPPQf8y+/8NCE4VJweDA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sBvvql6vL2xYQhuFUcL9tNznSi5XGDj7a9hJ9iyekP4dU5qOjJEz2grNaAkA3SJ82HJhoOjR7b+8gC8Ndf5fIi7aA0TwOCo9uBoG4zE7DzfU0JDYagY8makkppRib3ZZG7mc8INHX4Cmvfn4ixPZFhvyGFshRzZcLhVBHIMnskY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NBjmCW9m; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=K9NAjKPc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NBjmCW9m";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="K9NAjKPc"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E686ER2515949
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=/GDOFz1VvmR
	0CmuIsPfkE2YyLHLFmJ5BKPKV1BM0UFs=; b=NBjmCW9mdjY4XkiHvc2NaXzRV53
	m7FcjNLNkQhvJ2ObBywiXRU6HtWUTUrvX7jO/Y+4KKQHGto0ThOA2eHW9gjfuHA3
	7xHXDSJxZQ/ixKevsSlNy/apGPudnaowSo6u2RM6fel8Cvbr4CjhhAkTLR3tSbf+
	SehR+6yEuiPemEPs2NLrl5P0isT0Hbd5ZibTjNmzUcKVMRKbkM4SttsNOQy5hmRB
	lQCB/sVn524JeJ+JeDMVPFtZ5k+iItqrl3PRZVSppgKTQoiHaQaYDxonMbLQp7xJ
	j2Me278gdTXyFPhb7n7pwWdoq+/GKqv98+8d6emC/itJKL7DTZDJS8fZfbg==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha47093b1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:42 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3552883bd19so6545230eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974081; x=1792578881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/GDOFz1VvmR0CmuIsPfkE2YyLHLFmJ5BKPKV1BM0UFs=;
        b=K9NAjKPcOxTarGHJvEPpWhyh702ptJLGLfNaULTaU9MRqvtCup0huPJaFgYrPTAOhT
         0362iVHY2yekFe/XyrC+6p7dZu2D2nyRh7jFSrREVinu1wj3V5pOJc+exOTH+ZhZJGR6
         NHOceWuVStocd+wbreKpLP1qH7UhEMk1lVZOE+7sFDy5LbKytOp3iIJH8Zw6yc16iPtr
         VyhX0jR4tgjzK11KtWziwC4TGvEU0GEE3VLO37mp7CKAJqk38/46YWg5IWTB9ajIbm5z
         SXvgTQs8I37vXNgPPXVqlIvsq2jdp++Ke7d6Fhymxmn0iIyDo82KSsHVYbiRIqtDKTw7
         JZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974081; x=1792578881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/GDOFz1VvmR0CmuIsPfkE2YyLHLFmJ5BKPKV1BM0UFs=;
        b=v12mjUYBdnIzdwC79juOw2I3I16GuzXe0nQx5vK1yx/EYDBbXij8bwsgruBYQET4+K
         m81IEMCgyQwF2rUzyX+KACsPrJE3hVa7bMaLRAVQCZ1m3y9ZWs2qrBaNTIzb0OcUwnZB
         X0srCxSLdD9oRAROrZMeX+qLJAWvZwT8T+WcRNaMqM6rMj8kVQK12q9OibuNL69zmawt
         zZMS1dNineicAZEBnoSrWsCpSwhplEX8oVDpWdORosy624NPkelkwxPg2mjnn1LTw7cV
         VFSOHALgx3VS+jTNKWFGBLzp0StZmaTDYsFG/tWe1Bt+ahjmGIaEBD+bEGWigcwXTKwV
         TVng==
X-Gm-Message-State: AFq9FYLzIS15a+6z9slJsBt8lEy3lg1Z2MtxggjIfzMo3TLlL6WbNpIE
	9p+pZinHcjUK/qRszKPGANfNB2RcMtw0kEmO/dYEK75GinzNWK/S8TodMcVq05BYlP8qp78w/wi
	VEhMvIKpsjtbz9Cm4umRV4dS14vrYY6TD/4QPqmocDwKAQoq7Cg/OEWPlPNdG5bG87mKSrg==
X-Gm-Gg: AYBFou0YSb27NYcLMEEs2z/ON7SrKflEIeWNNM2JO4q0KXoFNhHIsdgwZt3gQ9oTY7m
	THxnJhRFPnQtKBf049lN3HKbok3ojLHzsNk4zKX87psv4otrMmjNhOW9Cp7pjnwhocRNxjiMQD2
	nwaIORyv6YS8fzcv+Cq3YsS+OK6Tn/dqynRKtswqLXOEJjz74B3qdxBvaqwr0I0nx8pbzGslTSs
	UgLNmUlwVPspTnO3Hh8atulT3Kag7HOEBdgbj4bTXmAV6sl9ZD4WoZKiYvrbBuyQJIV0wxulQSa
	V9tchAoY7N/TccHQY3ZPgsOhqg40eiHsKfGa3q4fXkCXAtrFGt+0d/mTzec+fAu+5AeCwYojgBA
	1D+7CbCoLqKWVKqjuuj9aLXmDNGcTLFWngrWz
X-Received: by 2002:a05:7301:9f0e:b0:353:417e:aad3 with SMTP id 5a478bee46e88-3537e069fa1mr29111789eec.33.1791974081126;
        Wed, 14 Oct 2026 03:34:41 -0700 (PDT)
X-Received: by 2002:a05:7301:9f0e:b0:353:417e:aad3 with SMTP id 5a478bee46e88-3537e069fa1mr29111739eec.33.1791974080430;
        Wed, 14 Oct 2026 03:34:40 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:39 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 08/15] wifi: nl80211/cfg80211: add ranging results to NAN match event
Date: Wed, 14 Oct 2026 16:03:52 +0530
Message-Id: <20261014103359.1508345-9-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX5hx/Tquw4/iB
 5eb0kH/u8elOHp74vErrgWwBSlfdfZ/TMgyjyvSHpNW/4kuqkEnHH8q2qcCcFzJtY/t6Pcs1XK5
 4IAgHz+ZI3wVX4DnIB/exsLFukHuL7Z8Ap4rtFW8YSpwLP46JZyfICe2LutxVvuoNqmh8YZxx2I
 iD8N2tYrcseeK65Ja8y5V+7ufUBzB3LmpM4ckAkEPk1JIW9P13jFJpaUurQMSTws5M4tlvLhlrG
 X6rv3J+RRzQgSzduzaxnkLow1n4chmCV0EVr4meJUwQeOV02VmkuYYc03PMP9YCNxIoIrlQjiKi
 skPelDyTrb/P3GIZgXwEwD7odkLsc5iaBkm5590OctGse0KJPVsz1+nEJIc4Ho+nrqNJjkoVNlq
 +fRCts3aZvO13zrAIvmYp2+wARPgS1Gr7SRvd0MYZZdNKSnQ2y0Mksd42yMsZvUy2nSYCP9IgZi
 dvxNVkWpmM9Hdkj51ig==
X-Proofpoint-GUID: 1iUpr8E8i0BVt9GowEMTdw0-6jasAwhS
X-Authority-Analysis: v=2.4 cv=P6avFSAu c=1 sm=1 tr=0 ts=6acf5ac2 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=mzMiRbF8k9lrUvxFUHUA:9 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: 1iUpr8E8i0BVt9GowEMTdw0-6jasAwhS
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX3Ld2t6NRB/gr
 h0evkfxet8YTw84HBNE4I2ZO19ftZC6Qi0GoAgsZ43YIvD4sgtuGTVsq5N5MkYNa+U6AC+YtNXi
 yjV6dONykOm6B2DiXc5qW1+7MycStZE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 clxscore=1011 impostorscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140041

From: Kavita Kavita <kavita.kavita@oss.qualcomm.com>

Extend cfg80211_nan_match_params with ranging_indication and
ranging_measurement fields to allow the driver/firmware to report
NAN Ranging results as part of the NAN Service Match indication
in offload mode.

Add the corresponding attributes NL80211_NAN_MATCH_RANGING_INDICATION
and NL80211_NAN_MATCH_RANGING_MEASUREMENT and serialize them in
cfg80211_nan_match() so that userspace (e.g., wpa_supplicant) can
receive the NAN Ranging Report along with the NAN Service Match event.

Send ranging info to userspace only if ranging_indication is non-zero.
ranging_indication is a bitmask with four valid combinations:
- bit 0 set: continuous ranging
- bit 1 set: ingress condition met
- bit 2 set: egress condition met
- bit 1 and bit 2 set: both ingress and egress conditions met

Leave validation of the combination to userspace (e.g., wpa_supplicant).

Signed-off-by: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h | 11 ++++++++++-
 net/wireless/nl80211.c       | 11 +++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6ac4e2e22881..aadfed50b4e2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -10635,6 +10635,8 @@ void cfg80211_free_nan_func(struct cfg80211_nan_func *f);
  *	Only valid when @rssi_valid is true.
  * @rssi_valid: if true, @rssi contains a valid RSSI measurement.
  * @cookie: unique identifier of the corresponding function
+ * @ranging_indication: bitmap indicating the type of ranging performed.
+ * @ranging_measurement: distance to the peer in millimetres.
  */
 struct cfg80211_nan_match_params {
 	enum nl80211_nan_function_type type;
@@ -10657,6 +10659,8 @@ struct cfg80211_nan_match_params {
 	s32 rssi;
 	bool rssi_valid;
 	u64 cookie;
+	u8 ranging_indication;
+	s32 ranging_measurement;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1e640a03e73d..af2b3a12572e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7888,7 +7888,8 @@ enum nl80211_nan_srf_attributes {
  *	See &enum nl80211_nan_func_attributes.
  * @NL80211_NAN_MATCH_SDEA_CTRL: u16 SDEA control field from the peer's
  *	Service Descriptor Extension Attribute. Bit 2 indicates Data Path
- *	Required, bit 6 Security Required, bit 10 GTK Required.
+ *	Required, bit 6 Security Required, bit 7 Ranging Required, bit 10
+ *	GTK Required.
  * @NL80211_NAN_MATCH_BOOTSTRAP_METHODS: u16 bitmap of the peer's
  *	supported NAN pairing bootstrapping methods per the Wi-Fi Aware
  *	Specification Table 9-321.
@@ -7907,6 +7908,12 @@ enum nl80211_nan_srf_attributes {
  * @NL80211_NAN_MATCH_RSSI: s32 attribute. Received signal strength in dBm
  *	at the time of the match. Only present when the driver provides a
  *	valid RSSI measurement.
+ * @NL80211_NAN_MATCH_RANGING_INDICATION: u8 attribute. Bitmap indicating
+ *	the type of ranging performed: bit 0: continuous ranging,
+ *	bit 1: ingress condition met, bit 2: egress condition met,
+ *	bit 1 and bit 2: both conditions met. Only present when non-zero.
+ * @NL80211_NAN_MATCH_RANGING_MEASUREMENT: s32 attribute. Distance to
+ *	the peer in millimetres measured via FTM.
  *
  * @NUM_NL80211_NAN_MATCH_ATTR: internal
  * @NL80211_NAN_MATCH_ATTR_MAX: highest NAN match attribute
@@ -7924,6 +7931,8 @@ enum nl80211_nan_match_attributes {
 	NL80211_NAN_MATCH_EXTRA_INFO,
 	NL80211_NAN_MATCH_IES,
 	NL80211_NAN_MATCH_RSSI,
+	NL80211_NAN_MATCH_RANGING_INDICATION,
+	NL80211_NAN_MATCH_RANGING_MEASUREMENT,
 
 	/* keep last */
 	NUM_NL80211_NAN_MATCH_ATTR,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e480f556ce62..3147eeab84da 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18017,6 +18017,17 @@ void cfg80211_nan_match(struct wireless_dev *wdev,
 	    nla_put_s32(msg, NL80211_NAN_MATCH_RSSI, match->rssi))
 		goto nla_put_failure;
 
+	/* report ranging info only if ranging was indicated */
+	if (match->ranging_indication) {
+		if (nla_put_u8(msg, NL80211_NAN_MATCH_RANGING_INDICATION,
+			       match->ranging_indication))
+			goto nla_put_failure;
+
+		if (nla_put_s32(msg, NL80211_NAN_MATCH_RANGING_MEASUREMENT,
+				match->ranging_measurement))
+			goto nla_put_failure;
+	}
+
 	nla_nest_end(msg, match_attr);
 	genlmsg_end(msg, hdr);
 
-- 
2.34.1

