Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367056;
	b=zUrWEuBov+MWKXA2Hpqf0mK4sifBw/uIag9yOPMBOJwU9VThiHAdfLSjpRDnLoIOupd6
	 dTj7HDP7UA6J/uq030OiQFVtLVN+4euiP/7Lso0vvo7Mfq+mHf2ZMW5TXqI/O8zskWNHK
	 8dD0HCAar13LyJYk9sbZFLvp2HGh6eJ4us2RDrFFhC2NFebX+PUmwQ7pa2Rz6E2u1S3xr
	 3mfu3pB9+vN8AazWHoSP7vBcAMMdXqtQEfZbvmE+N99S17LOX1F8VD1uLPkcNDRhWe7G2
	 VK0N+/dwFp7maetpexc2Ge3cchIDSct/h+WotN5cMV76z2+pmeIMlAMSce67GHyBTEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367056;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=TptD9gQUucrq3rB7m6hscb7mb7PVrxRkbFT3QoKmLNs=;
	b=YyoUk38XqDH+QK3D5Fno3Ritx07kJQBQ11rSj4MNqbopBvxOm5D5vQkg4XKJX0wUNCJZ
	 VKrHEbmdzzf3R2mQy0Td5Ly05kF+zvx+uHov3Fktxna2HFgfE6Yo4fTq1CfhUeDlDxoWZ
	 7wcb00XKeh33moRxj3ZPfnw+WIn6fVbEwdgskxT/HNV0vebGQM3f42CmZcarghp0l6f3B
	 r28K6ZiLRrBbCBqu97zZDElFdR9QI574GJeXHClNS05tWmO1D0Pfm6Bee0P5ZltNU7sP/
	 v5xYNGMp2eX6V+hI7oxnAxAKMvqe1pcPDfLonQLN88VZPhvPXw7CM+SrX9Aubd8EJGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ockk0RQl;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VLkEmUiP;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9250606A326
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9250606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ockk0RQl;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VLkEmUiP
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBG9q63719582
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=TptD9gQUucr
	q3rB7m6hscb7mb7PVrxRkbFT3QoKmLNs=; b=ockk0RQl5LynWI8JH4qIpR89KLD
	oI1ZeETtpvOS67JjGEzSkYzwg3gsQDR97v6JRDAT8EGxJhQSWomwR2zxbpmwG2hq
	YOVNvbGrYQRqmwNeEj/LjC4cldmktg1lcvVcYdHpGjpoFyzEGTFhIQo31UNmUtex
	w1EIQLu+IobulDMxusoDSctEfzZW45sy+6mNPy0CtP/8PD4ekCmhluKdj8a75Cjy
	x8Fd2wMfO690ak9YeVU8JzK2qgo1U+lSrS2ZCM4L4m75zrsKqIb4KRqspIo3IGW9
	64hp5XTkFPyjnhTUSw7wxQdVH2FbHwiHh5clTMn9b6aFSo8ghClphvuaqrw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qu6rr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:54 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cdae10aebfdso491907a12.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367053; x=1793971853; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TptD9gQUucrq3rB7m6hscb7mb7PVrxRkbFT3QoKmLNs=;
        b=VLkEmUiPwEHWzIresm87W2Pw7BQGJ9WXY8h17wG9R9qBqH9JLq7MtxYdy/kHXMYTE9
         68ii57a1rs5fA9qYpfdo7WWz1Er30QjRIf1pg1yQHXh/eDt1FfTW+HTXFVkgfMvTWucR
         Dioc8a2tr0auE8Q9RkgotMIEGUAsYuz4AFeLCIt6bYK9KPiHr/ZStiL3ganYWbQRPTnl
         wjlMCfOOuW2bxtog8SjPbb20snmpoxVxSnK4sUtg0UoSx8BkEcCVni13CEdSMJb9mpTb
         DYeFb4gLjspkerVlNNyobaKz2TobzhVzv3ZIFpE5sDGbnemwdYE6VEZewcQaw8uUxESB
         Fe/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367053; x=1793971853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TptD9gQUucrq3rB7m6hscb7mb7PVrxRkbFT3QoKmLNs=;
        b=e/ojnPuXooX2+H2DZyA5Z2aiz4TCsjbGhxirCEzHid49nzHkC2n0nVjbfXh7d0nEKc
         H3aTCNhDKGg4hMzPSGixWe0xpglJr4XsqX0NdGSh9mj47trqtqb9akI+GTbGpSvAg7pX
         hDdzDjblkU6qjT/jzi9VGMSbJRDfm3phlZFknF4hSnicLmaRp9OqLrV4skVmc7YzmQ1c
         quwESpgtHvOFJbJyXvdbzybT7OK5BBzPkIObSk5Gn5Tm+eUlKDZ6NQrY9pvz8o5SbMEu
         zJHe4swNWAld+gVm8q079N4mRYLaHsj7aoVYoyKhp1YotFc20zXFLEvZ4e9wjKMTbv3c
         K0cw==
X-Gm-Message-State: AFq9FYLECp9bewUrnesRWtNQGcgemGzwmmlb0t7KOEgWGEEUY32OaQha
	HucKZ/Tp1iR8fZzaRKqARDw9C/Hz1kt98NZoe/fXoOc+7ZPRj9YD77Pvd4vhKeMrYZAzXHSKspi
	B/1pYtWixfXx7JAgO6LIycVD5ifRi4NOXUN90t7WRq+gl4pozRattFvCZKZswPYKAsEIhQw==
X-Gm-Gg: AYBFou0BZAey6Wk6C82XQ+CivrRIXdejhPK3/Qm9vE1mTgpzFvgL7cEiPxuHLJpHdxO
	5M5dWMNp+ep+W1fkz25gNUkkjH0RfiQpsn/xWSSC6PIkFzK7BcIZwWyz96HJnDCBaCjc83TaR84
	Mg262gi11d3LPUZfDERH4bpEaiSCVvugFNZHWwfW7l6MMYWcESlrVPIeCZtmV7O4WpN7BYAHr4X
	F0x8qEODvO2yEogHsL5TFDIm1p7ruWQ8FtloJob7kizYfn731dWv9+SR0LQN/rQJtxwjCiyauVS
	GhPvppHSFiF2s+EWQzsSxNfsErrwl8ONnfQfhaayawZjqVXg2JeS1HrIMGFBZac9TLW2luAgL4R
	aWE0IfK7ZYwttG+OQqrTpf4BU3mekq62YclpMD9J3qb8MD2UnUR9tLXYhByDBSYlKo1Dy79FN0u
	aEdkreK2cX2Q==
X-Received: by 2002:a17:90b:528d:b0:3a0:eec6:b065 with SMTP id 98e67ed59e1d1-3ae896d8027mr1240840a91.13.1793367053286;
        Fri, 30 Oct 2026 06:30:53 -0700 (PDT)
X-Received: by 2002:a17:90b:528d:b0:3a0:eec6:b065 with SMTP id 98e67ed59e1d1-3ae896d8027mr1240818a91.13.1793367052702;
        Fri, 30 Oct 2026 06:30:52 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:30:51 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 08/16] wifi: nl80211/cfg80211: add ranging results to NAN match event
Date: Fri, 30 Oct 2026 19:00:04 +0530
Message-Id: <20261030133012.3009774-9-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-GUID: qbQPUxr11RzSpeuw_4SVjDfcBVTFSTJ-
X-Proofpoint-ORIG-GUID: qbQPUxr11RzSpeuw_4SVjDfcBVTFSTJ-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX2623MbVZXuf0
 zp9jzm4jtsoke3ZoZapEGUijvYQ+UHmF750jP4wRlZfCCaUAUjYuLdOY0a2poE9nG4LzYctTqgS
 kEOHgWQ10wTHGTbi2AstRBlslOFSf2uSwfRAO/u2gtWcHM7wwUFI0Kdbtce93x7/H3kKYz6uiCM
 YOec7Riu83WU0xB8yPkwoOWp2mqVp0CfGquUS/yypyIigml8FrKtJ05w5OunEkus1YBp28gp6iw
 cb82lmxHbojb+BfpVsfFfvZF2H+FDWvFaOdkikze5rqxjHZy4TeedDg9XxYbCRo84W1JezheRk0
 Chncz4QT3lxCaoFy4uQpp12zTMP8C47JsfNAmsFRJKxCz2EatM1YnWXjXh73Fpwttoh90FxFRe+
 f/yLPBqNh8zA/pfGW/u5XUGPOADJlDi371Xn/9dGvV96YzNOIrYIuukWVoovrfviO2OHeMmsAxR
 rzO7zAuwXD2a05EnTAg==
X-Authority-Analysis: v=2.4 cv=dPgzC+Zb c=1 sm=1 tr=0 ts=6ae49c0e cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=mzMiRbF8k9lrUvxFUHUA:9 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX2i+0IcxyGIlt
 weH8CjCw48hiOeaOtrzBbY2kc6kPcUIbFrpXF1ZjbI7HjR96izpbXyuivMQ6t5mh7RF5L1Lsnzn
 7zZ1psLoR4ZW3Bjul6tfRGlcq8MOmn4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300053

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
index 08cbd231bf47..5d3f5cd8bed5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -10643,6 +10643,8 @@ void cfg80211_free_nan_func(struct cfg80211_nan_func *f);
  *	Only valid when @rssi_valid is true.
  * @rssi_valid: if true, @rssi contains a valid RSSI measurement.
  * @cookie: unique identifier of the corresponding function
+ * @ranging_indication: bitmap indicating the type of ranging performed.
+ * @ranging_measurement: distance to the peer in millimetres.
  */
 struct cfg80211_nan_match_params {
 	enum nl80211_nan_function_type type;
@@ -10665,6 +10667,8 @@ struct cfg80211_nan_match_params {
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
index 28c02cf395a1..eb74a9d3eeb0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18034,6 +18034,17 @@ void cfg80211_nan_match(struct wireless_dev *wdev,
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

