Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951972;
	b=rQK6pOllrCcQTc0lIRQk8FocVSNq+u5zgifx00cKigaQH+r6QXaHeZ5Yd75EqYFHYn36
	 l77hH/+cnCh7W+So37dKeNyuJWBtZC92yUguBbQDlvE9QK+4peaauZPC8x7c7ZD7PCCHu
	 QZucdrTp1L0LVthKrg3gwMXdQelWrxAMr3X3whGnBb7BlksrHMSKWXxINNzEr+GbGaN7a
	 C+5Rh4FX5ccjvmGZuGJsDa5rctDToIXS0JjA0vJLloKD3sP5SHr0yIYDYgd8nVSjUwudu
	 TQyxDu//Nsm2QV9CQYlmGJPGc4Mdlp4PqHHho2hMHs4Utwc5sHTJlp1tjKoAMWo03yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951972;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=cL8DXAIT7yDv2BubEmDmdY3I/Rf9BQoPZisaiNGNqS8=;
	b=tI/3N2Lx+WuiMkKg7U7c6MC9Z/zOBGcSiI4EPyIqAGk6gnsjuWqiM7trllfaQJan70a0
	 xcEwx8lAxjK1duHcVzaL7kdPekNcpsg2TRwOwC6svYx28kmsu3fyN/7xW99MQjKiAqQvl
	 l8kWzKRdjpMxrHmwrUCZO9hfdy4VmK2VBc/UQ0qK6j83P3DooEeXuftUCZSzoOhVF+yYB
	 j4+pnKQYxvmqweRiPt2bfTlCVzYLEbUZU+//8CBJlsppLuv+6shOUdmINnyAiz+gKT3qr
	 sCeI/fueU9cyXa1MsuyMYGXOtTjbeU7SbKntTRU3p8WN8dkyiCgbV5noYEYKARRq76Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=NQeu+2QC;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OuLp8sk7;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE97606A337
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:59:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BE97606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=NQeu+2QC;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OuLp8sk7
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67R6fc3243860
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 07:59:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cL8DXAIT7yDv2BubEmDmdY3I/Rf9BQoPZisaiNGNqS8=; b=NQeu+2QCx+Xxp89H
	oxEizQOObwut40jHWI7/JZw0sdfNzvCc7IhvfjfXImB0cSqzbbKS48Nw7jYPZgfJ
	8+OZ0apxnOdqRUZSWQyDC9Oyn+kkNyYvD+66vF8cZmmNm9CDmNfI6dOnbSY4LIzG
	Q1DX9589FrtON38nTtV4cH+iMmhvrDRTp1lY2OI+U4BrYyVlA5TaRWZZezUAhKV2
	wLd108Ygy4CfnHTLEm6tJd8ftZpfTmeYQ1RhzNxDzLEfDZI4k5KMnb9A2PMs97cR
	jzrXYKo0sEh4n2pQAr6KUK1gzXVQXClKQrGNr/Imw1MHsTOGRDxa7owy3wJAVr2Y
	IhC3WA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pa1phk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:59:31 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b0a13ae043so639385a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793951971; x=1794556771; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cL8DXAIT7yDv2BubEmDmdY3I/Rf9BQoPZisaiNGNqS8=;
        b=OuLp8sk7hD3B57B35hh3/dvE7/zBHx5nISOdtj/At/c+DuP+8iIDjq7Y2B8sNnWc2g
         1FunZ3FFT3yAr9Mi+LkPZPUKNToex6TvCdv1nNpRXWwrBUV1fjVH5PfpQR8OdzLl3sSO
         mPHCo05MAglN4kx6L16ho01R1PCqM46yR0Gg5WQbGUXvI4Hie2R/EsbNLYexYw+dvr+/
         eUUK02cr0eOnpTWx9Jaez5Lz1CZV2V7dLbJ2FHAlSvNv6vEtwo5c6rEloDCExeCM421k
         VKsSsxFkIyC5GPZB2zsOh4Wp5gcx/IpYs5gOkTGFxcuxU4jrTn8VC8y6K63NS3KZyFEX
         QJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951971; x=1794556771;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cL8DXAIT7yDv2BubEmDmdY3I/Rf9BQoPZisaiNGNqS8=;
        b=zdli+0PwrAQfP/imj2TSrTMwzrTYTsuf/MAJlzpmyk3bYNtzkrdFV50/QsPnOJAbd7
         /B8lkXhyB4WB9fb9M1bzkguh37saamxSDS23O5HqoLpx+wWRN0DBS9Pe8idVCgKIGR0/
         qcNHmyKs7BErJaZ1f0RqAxCfnrha0QuuAg0OrLWKMtbi1h12Ikp+lunUkQeDoKJ0OhAI
         zXhbHuxqEtFjcSMY7tWl9qWLzJQ/xDwrDHH69YmO2bQ2eOSSLB3G4Xrv47VktnQshSWh
         qoPpAVxRb6HTgboETlq6G/Y42ecktGcMVKW5ItOsAu6fj22yE9LDTia24cACZn+ZugBP
         uegw==
X-Gm-Message-State: APuU4Z8vV9VjN6dWcm2n4wLfsSZ5DlZOBtPIB0uejebRhHt9eHP6OKVW
	jiT12uL7icMQMjso1jKdfhJkT1rd50Ju1VXPFJ2SFQaY7ORSDTZyRkd7m58SVb6xenp9MzzCUvH
	voizKqN7jOTa6EvCodJDCKieX+b3XOC+HBdKp952OAZ8JVWIbuNTJTQS17zM65FALHmj8
X-Gm-Gg: AYBFou37ONXRoeEpr6feE1s/VtP3s6gZS9uhR4f3okaBEm4uqEbvReNHave5LJHGh6e
	Ksm/hGn6aFCwyGLoxRdN9VjMzaNiz6c80RFkxzH1e5oiAPOnMpxLTFWOHYKgsr3DxVwkXlnsxhW
	8QajSbilmCnfi8xkrCA+DFvUs/bFpfIahWQHbecKrsDud8pOzTUO91CpCgEmKW93++p4I+8VSBq
	pCWaGYPsWnOsv5vJM7yZBXdD5/bnK5e55j6qwiq4Abe65CrAgRpXZltQV0sa3HdNj5xKkDDGd5q
	WUJqKHBI0gQnvvAZSLuCCzGy+sFU+/vLzwTJVdHZvoJhdchRWfcXnHrB5dZ9+ThTtU3lSTl5yva
	KZiyOmTtm8sZH0csbEeBDYloZLKLUIAU+cg7tUC2D536BhFVoeNNTarjxAaenCYDsxClzFmfBEA
	REueXft9dy3TrlA2Q81EcuUGOVOwHyD0q3ignDJY4Yd4I7d/fPGYYkYKBspWfkv2eMVFEm6D0=
X-Received: by 2002:a17:90b:2d0e:b0:3ab:1e1c:837f with SMTP id 98e67ed59e1d1-3b0db6feba5mr1575014a91.47.1793951970472;
        Thu, 05 Nov 2026 23:59:30 -0800 (PST)
X-Received: by 2002:a17:90b:2d0e:b0:3ab:1e1c:837f with SMTP id 98e67ed59e1d1-3b0db6feba5mr1574995a91.47.1793951969723;
        Thu, 05 Nov 2026 23:59:29 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:59:29 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:39 +0530
Subject: [PATCH wireless-next v4 02/21] wifi: nl80211/cfg80211: define
 interfaces for SMD setup and STA update
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-smd-v4-2-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=PLeaavqC c=1 sm=1 tr=0 ts=6aed88e3 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=VlmDqvKmGZdUKtkEw48A:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX0Tf4L124m9m0
 +Hq/l7cP6lUmcmSKe7RkNSo6zNYacz1UDOw39N0TqIIl7sKoFpRJJzEDZ20J4rXtux0Bk0OJDh9
 //r37qKPbWR/lGMyeiCC5tb76Wv8E5A=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX4zBttH4AloHY
 3y06qiu0S78+w7nF+znIxgAtwcJjbbiQC1dVCKtWRtvJg1nFaXX/XrcHNqVxN0Sqs+SItRPqn5b
 dSEySFbSC8BYZys3iSCxIZrmEkc9mPpbyVGRNBzXoYgUr/D4KfhZ1SLMgoDx9m1mTRlltbcro3d
 8yHepNQZZ1+VZxzFRj4V2s5cGDV+l4CcODmkNItmusY1yLpoY8+NWnbg+MMhElx1yrNwxWQELbP
 zq/OD8kAyCuYpFuQKA4IQdU3J1i4NmyzZmw34R9e5oysp92qSF4IkdR2kdxd1tC6kitrCdl/ZRi
 bOi6SZqts7F+kMzWqzhJYATVbwFDrhqD2fV/dC0NlnhnHMScw9vJ3pDNKjo4viuXPwT/EsTFOFY
 9gAVwi9xMpcIRQuSqY3VDX0isrRtpWXOiPi0ejAZYoOHZY1JHKpzm+0GGM/4XMP0my8JnW/iIA0
 iNSXslnvGs/DlZYUnIg==
X-Proofpoint-GUID: dwgkbjqOLjkE9zQv9ynpV11HDxPQqHMv
X-Proofpoint-ORIG-GUID: dwgkbjqOLjkE9zQv9ynpV11HDxPQqHMv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

From: Aditya Sathish <asathish@qti.qualcomm.com>

Define nl80211 and cfg80211 interfaces to support SMD setup for an AP
MLD and the non-AP STA MLD creation upon SMD negotiation.

Allow only APs affiliated to an AP MLD to enable SMD while starting.
STA creation can happen in two ways: typical 802.11 association with SMD
negotiated or via SMD BSS Transition Preparation on the target AP MLD;
the latter should be marked explicitly to inform drivers so that they
can handle ST Execution and datapath switch once the ST procedure is
completed.

Signed-off-by: Aditya Sathish <asathish@qti.qualcomm.com>
Co-developed-by: Rohan Dutta <drohan@qti.qualcomm.com>
Signed-off-by: Rohan Dutta <drohan@qti.qualcomm.com>
Co-developed-by: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>
Signed-off-by: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 15 ++++++++++
 include/uapi/linux/nl80211.h | 10 +++++++
 net/wireless/nl80211.c       | 68 +++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b4f384ade47a..54d549afd8e3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1624,6 +1624,7 @@ struct cfg80211_s1g_short_beacon {
  * @mbssid_config: AP settings for multiple bssid
  * @s1g_long_beacon_period: S1G long beacon period
  * @s1g_short_beacon: S1G short beacon data
+ * @smd: Seamless Mobility Domain (SMD) enabled
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -1656,6 +1657,7 @@ struct cfg80211_ap_settings {
 	struct cfg80211_mbssid_config mbssid_config;
 	u8 s1g_long_beacon_period;
 	struct cfg80211_s1g_short_beacon s1g_short_beacon;
+	bool smd;
 };
 
 
@@ -1880,6 +1882,17 @@ struct cfg80211_ttlm_params {
 	u16 ulink[8];
 };
 
+/**
+ * struct cfg80211_sta_smd_params - SMD parameters for an added station
+ *
+ * @smd_sta: SMD-negotiated STA
+ * @roam_sta: station was created via SMD BSS Transition procedure
+ */
+struct cfg80211_sta_smd_params {
+	bool smd_sta;
+	bool roam_sta;
+};
+
 /**
  * struct station_parameters - station parameters
  *
@@ -1920,6 +1933,7 @@ struct cfg80211_ttlm_params {
  * @link_sta_params: link related params.
  * @epp_peer: EPP peer indication
  * @nmi_mac: MAC address of the NMI station of the NAN peer
+ * @smd_params: SMD params for this station
  */
 struct station_parameters {
 	struct net_device *vlan;
@@ -1948,6 +1962,7 @@ struct station_parameters {
 	struct link_station_parameters link_sta_params;
 	bool epp_peer;
 	const u8 *nmi_mac;
+	struct cfg80211_sta_smd_params smd_params;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 3e71564ce87c..cfc1bcad13f0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -361,6 +361,11 @@
  *	SMD capability in %NL80211_CMD_GET_WIPHY.
  *	%NL80211_CMD_START_AP carries %NL80211_ATTR_SMD_SUPPORT to indicate that
  *	the AP affiliated to an AP MLD is part of an SMD.
+ *	%NL80211_CMD_NEW_STATION carries %NL80211_ATTR_SMD_SUPPORT to indicate
+ *	that the non-AP MLD getting added has successfully negotiated SMD with
+ *	the AP MLD. %NL80211_ATTR_SMD_ROAM_STA is also set on the target AP MLD
+ *	to indicate that it is part of ST Preparation; drivers must keep these
+ *	links in powersave at this point until successful ST Execution.
  */
 
 /**
@@ -3265,6 +3270,8 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_SMD_SUPPORT: Flag attribute to indicate SMD support. Used with
  *	multiple commands to indicate appropriate SMD support (refer DOC).
+ * @NL80211_ATTR_SMD_ROAM_STA: Flag attribute to indicate that the station is
+ *	created as part of SMD BSS Transition and not by typical association.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -3874,6 +3881,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_ASSOC_PROTECTED_TWT,
 
 	NL80211_ATTR_SMD_SUPPORT,
+	NL80211_ATTR_SMD_ROAM_STA,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -4026,6 +4034,7 @@ enum nl80211_iftype {
  *	previously added station into associated state
  * @NL80211_STA_FLAG_SPP_AMSDU: station supports SPP A-MSDUs
  * @NL80211_STA_FLAG_CIP: station has Control Integrity Protocol (CIP) enabled
+ * @NL80211_STA_FLAG_SMD: station has negotiated SMD.
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -4040,6 +4049,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_ASSOCIATED,
 	NL80211_STA_FLAG_SPP_AMSDU,
 	NL80211_STA_FLAG_CIP,
+	NL80211_STA_FLAG_SMD,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 16d00ebed10a..b06772ec8ac5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1202,6 +1202,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_CIP_CAPABILITIES] = { .type = NLA_U8 },
 	[NL80211_ATTR_ASSOC_PROTECTED_TWT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_SMD_SUPPORT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_SMD_ROAM_STA] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -7379,6 +7380,28 @@ static int nl80211_check_npca(struct cfg80211_registered_device *rdev,
 	return -EINVAL;
 }
 
+static int nl80211_validate_smd(struct genl_info *info,
+				struct cfg80211_ap_settings *params)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SMD)) {
+		GENL_SET_ERR_MSG(info, "SMD is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!wdev->valid_links) {
+		GENL_SET_ERR_MSG(info, "SMD is not allowed without MLO");
+		return -EINVAL;
+	}
+
+	params->smd = true;
+
+	return 0;
+}
+
 static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -7661,6 +7684,12 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 
 	/* FIXME: validate MLO/link-id against driver capabilities */
 
+	if (info->attrs[NL80211_ATTR_SMD_SUPPORT]) {
+		err = nl80211_validate_smd(info, params);
+		if (err)
+			goto out;
+	}
+
 	err = rdev_start_ap(rdev, dev, params);
 	if (!err) {
 		wdev->links[link_id].ap.beacon_interval = params->beacon_interval;
@@ -7995,6 +8024,7 @@ static const struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] = {
 	[NL80211_STA_FLAG_MFP] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_AUTHENTICATED] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_TDLS_PEER] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_SMD] = { .type = NLA_FLAG },
 };
 
 static int parse_station_flags(struct genl_info *info,
@@ -8061,11 +8091,13 @@ static int parse_station_flags(struct genl_info *info,
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
+		params->sta_flags_mask = BIT(NL80211_STA_FLAG_SMD);
+		fallthrough;
 	case NL80211_IFTYPE_P2P_GO:
-		params->sta_flags_mask = BIT(NL80211_STA_FLAG_AUTHORIZED) |
-					 BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
-					 BIT(NL80211_STA_FLAG_WME) |
-					 BIT(NL80211_STA_FLAG_MFP);
+		params->sta_flags_mask |= BIT(NL80211_STA_FLAG_AUTHORIZED) |
+					  BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
+					  BIT(NL80211_STA_FLAG_WME) |
+					  BIT(NL80211_STA_FLAG_MFP);
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
@@ -9276,7 +9308,7 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 9);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 10);
 
 	switch (statype) {
 	case CFG80211_STA_MESH_PEER_KERNEL:
@@ -9371,7 +9403,8 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 				  BIT(NL80211_STA_FLAG_WME) |
 				  BIT(NL80211_STA_FLAG_MFP) |
 				  BIT(NL80211_STA_FLAG_SPP_AMSDU) |
-				  BIT(NL80211_STA_FLAG_CIP)))
+				  BIT(NL80211_STA_FLAG_CIP) |
+				  BIT(NL80211_STA_FLAG_SMD)))
 			return -EINVAL;
 
 		/* but authenticated/associated only if driver handles it */
@@ -9633,6 +9666,23 @@ static int nl80211_parse_sta_txpower_setting(struct genl_info *info,
 	return 0;
 }
 
+static int nl80211_parse_sta_smd(struct genl_info *info,
+				 struct station_parameters *params)
+{
+	params->smd_params.smd_sta =
+		!!info->attrs[NL80211_ATTR_SMD_SUPPORT];
+
+	if (!params->smd_params.smd_sta)
+		return 0;
+
+	if (!info->attrs[NL80211_ATTR_MLD_ADDR])
+		return -EINVAL;
+
+	params->smd_params.roam_sta = !!info->attrs[NL80211_ATTR_SMD_ROAM_STA];
+
+	return 0;
+}
+
 static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -10041,6 +10091,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	if (parse_station_flags(info, wdev->iftype, &params))
 		return -EINVAL;
 
+	err = nl80211_parse_sta_smd(info, &params);
+	if (err)
+		return err;
+
 	/* HT/VHT requires QoS, but if we don't have that just ignore HT/VHT
 	 * as userspace might just pass through the capabilities from the IEs
 	 * directly, rather than enforcing this restriction and returning an
@@ -10074,7 +10128,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 9);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 10);
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:

-- 
2.34.1

