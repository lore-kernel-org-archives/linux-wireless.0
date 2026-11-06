Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951975;
	b=dfOsz8eNaYkEfxo6/tdZr8TZcE34FrQuXF9Y4ITHISyJF9EHrrm3Cz6x5GBee+hJ1RxK
	 7QEp3P14NzWexNpi+qbpSPdwzvvQUrRlSdd53LUktzzH6TYCgbkRn4GwUDzNQUfSiWyvE
	 NgfkFQNDYyTygj+x6kcQpIDwxUcYw5dxrOa4ocKk08j7pWmT803jKELjcHR+ezRSxSAys
	 15S0eTqrvZ2Q9/ioJv9iAIj+XW4glvbq+gaJFvtdoZ8Qc5vl3jjCmqrSjqMan/SpSZVYX
	 7ehl82YdDoEHiLcPG0RhvyIZ34zppTaKOAkIQlsIEQAFC7VrH5RXDcAfn+e1S9Oe8uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951975;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=XOOBmwb2awLC5YZHeWolkoldTxdZw54DrdIDJ8KDPFc=;
	b=XfmIn4EuZfPLEUEC4ia9sG9dJfoXUL6ogMqlnACW6gxoRsjCToTZaDvI8tfk7IPL6BEu
	 0+7fdTajz9Ob4rTtHu2wKJxbG0ST+MmRTbYF8w0QZrJsQWqQSRoQas783wDWApRec4VxU
	 HDm22E56Fr7jZ+HN5p/yzyesGT1phf4OkD8Px5HK1A1BwDqGjLUjCHeh1/nJRD0XWo1sF
	 UtRSQRa7Ran9ZmrGrisvJW7s8GUwhdo+cF7h7n3P/WztP1Lcoegrgl4Wnd45xmjLL8uQd
	 xibEhMuU3lsOaFp2hlp6HRf45z6TWEOP2mRoyPY8IuHXUnDWpgwNxLvIRvtktTT1hlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZYfRhtjh;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=W7rpUogM;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C521A606EE8F
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C521A606EE8F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZYfRhtjh;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=W7rpUogM
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RQUG3301565
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 07:59:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XOOBmwb2awLC5YZHeWolkoldTxdZw54DrdIDJ8KDPFc=; b=ZYfRhtjhbs4t2V8r
	+hxuG7frC1LQ6NCNO9yIgFUpkJnYfd42kjsI9H3kj0MUZQ+Qs9jO2u192Wf02RAS
	oWc5BHmP+d7iuL1gQp/OKFPZ1djIfRyM1HHOSnAsmQvJNJu12f3zAODsYqu6n72T
	7vSJX9ZSOkNxIzYTpx5VwUCoY7LtfCjpC6l08v9K0jM2JOZ/fGu4/tH1pXebXfi7
	6HwoS0H5chdYkP5zeJTUp6yyka8GcOvpf5zokmy9MSAuUrh4TBVlYIqrjhwjMAVa
	dZP1VHImLu8Nb7akKb2XBxs7c3gFA0V1r9YG2v77lTelWR0v7tIIRUGcuOqONAmI
	Le1Wdw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pa1s9f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:59:33 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ad30487d55so722455a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793951973; x=1794556773; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XOOBmwb2awLC5YZHeWolkoldTxdZw54DrdIDJ8KDPFc=;
        b=W7rpUogMxcQpqc8XcH3056v+4ZsiVnO1ZcwF51+7UKOf4+apBL5mDKY/mOm7nNq9Bk
         +tQQ2G8/kJkRoz0xeh9OodVbRF9HdVXpUP19j7mMgsr6aIlOu90DldDEEKc/vvQCZM1K
         tT7C/7oWgo73mAkrRBfms5TKGKTBEp39NDEzhEU+k3e3xyyUI8vkMGRKZPncJdvJwpWU
         N/oS+TdNBFJibA560AS4yOqlOtw12HJtiKbZg2cB+wRKH7MaN5kljiPzFNHBl9V3jo6w
         TIxoG5SILMpKxq5fuIWJaKc/j9X1MZM4YhZNX40Otuv6a56TPWZkW4pO2BJGOte7K9Zv
         SOVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951973; x=1794556773;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XOOBmwb2awLC5YZHeWolkoldTxdZw54DrdIDJ8KDPFc=;
        b=u1z6trl5IFwZlEpRazZOSsTz0BnF5exgCOwJ9uDnRkJbiV+mBvlAsyIPPCfJJEBaz5
         saKprnKAjFy1ZSNmH6Au433pArapC1cvo09nPHGq0gPZ+/ss0A1u4lGw6kLcGnC+UfEe
         pyuVoQNttUB2Ffdh84qOBjEhcQ/vefwpl62rGR2Qj0+SU9pva0Nheh5ZS102XLXIbwOO
         1SzJhEvUaclcZyw93qwUW1VV27TJw0JNHYkD5MGl/cAjeKqJ/NgwSvi5Bgr6gEN9rHO2
         aJKyMprZsXZbxGySvYaJn1uCSPOClwN+CCmOtvA5XI71RJcpGZakv16dYna6F8brG43d
         z9OA==
X-Gm-Message-State: APuU4Z8B+4cFAWCyZ87lJtYAt+Pjtr+okwzxKkc/8FZuc8db3weGLOYo
	0bOhbGnCjB0sEr+7I/K9ZgOX6Q7klyPq9c9/4w22P9co1dWJTlfcCWGF1FUdgaxGBpmvgy+4wKM
	W2Bsbj9Bq6VsX0GEF7kMVVrHWkdQFdsNilCz751CZgcqWL7ZorF2TyaMI5SKwza8X2LPY
X-Gm-Gg: AYBFou3y27/brz2sF5zp9KdS3EtbsSPpn/GMnIYMQsteKUXQ4pifU3kPjhEM2ANUJGf
	l0b4xePKQ5znCIXhbBLZIAv+hMZHbIsj6mlHbVB86IaXjSSJ2VJF7mfV9QKj0Fr/GnDX9o5oU+H
	Rsgzsapn19YlUlwOgHnCDZEwVTOXxQ5QcTpyg7Y0uVr5Ac31IBBrwnWN9nDjTM78CExsleFYk0u
	z6Smq7zJKf23jYQK5Hhvb6haiF/EWU5cLBUbqDZlLBSWRvPkaybZ5V5pkavrscUTS2QBMYwMSL/
	/Yd8nnizpg6dtBXI3KnJ7SR/oEsJ+6B/QFam22q9sgQEN3tgCEV/8K7OTrGdRhgpQzfHzGs3fDb
	HMFPduF9TFd9OWH5dc5JaRPkfwnwFvu33aVnJYa8ieN1si55xopJcLdAcLXRKDkreI2TMA5U27F
	0hYSErvqgoHgisWSTgFfxsDn8qPzl6n2Kt0N2VIRLOQsIXCmgxhJVEZEMVXbivVH6Hni6yaDE=
X-Received: by 2002:a17:90b:380d:b0:3ab:4f1:4f76 with SMTP id 98e67ed59e1d1-3b0db6d39d4mr1783502a91.24.1793951972576;
        Thu, 05 Nov 2026 23:59:32 -0800 (PST)
X-Received: by 2002:a17:90b:380d:b0:3ab:4f1:4f76 with SMTP id 98e67ed59e1d1-3b0db6d39d4mr1783487a91.24.1793951972045;
        Thu, 05 Nov 2026 23:59:32 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:59:31 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:40 +0530
Subject: [PATCH wireless-next v4 03/21] wifi: nl80211: add SMD BSS
 Transition sub-state STA flags
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
Message-Id: <20261106-smd-v4-3-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX/pvmzvrMeD4f
 EvoVq2BxEg9TbIdpZuzP/7g9S6y0Vf22V0ntL+zNZK1jx9P43Y6pDZaQnShEGg4JUCjHQnpmlXX
 9OkyQiDOS7gkqEfKVQL6WSXXSrzkNjFNlW8CozMxQ6n/euZAExKUPDoKo6T23sdreOhrdLBeyhV
 FonfMDCFWVBxMj6pPu5MkuD7I+oxrhSWOibaync1MyFDyYjG9to30h6D1RhI+jSzd4mnDCM2yQz
 tFAnFBofKtEilN8nYvjesSjeJhCVANkfNiUgDjicPxdls/29vNSDChaEawFlrP5L1afDtMFTJIB
 nKd3gq3EjKf6LBYMplIjknnSxTfDPFgCrf2E7VEFUo8b5wQEAeLL7cerlRAYfg5fVSaJmwM4kIS
 ZCZTYFanTOGRhDvDo+uusj/ncPGVd5WdfrWQ0pg33OnsGI14Jy5CllcloTCv3S+LVtC5341vHDY
 T2hYCINWZyzUJuW/dVQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX+iaN6q6HJMp/
 AYMwyRr+5Y39Jpubm/JIyh8roBLYolaDqLrMyRgZUOfCHcuIoDt4WoPFTX3qJA1j0uShYqioMYj
 5jshY/r525qOGqUZP/vBcbN2dmfskpM=
X-Proofpoint-ORIG-GUID: sNsKutIv0Z4AkhPQVayhUlhkolPpPtNt
X-Authority-Analysis: v=2.4 cv=GpzXaU1C c=1 sm=1 tr=0 ts=6aed88e5 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=b90yJLNE8BgtmlcRjg0A:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: sNsKutIv0Z4AkhPQVayhUlhkolPpPtNt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

IEEE P802.11bn/D2.0, Aug 2026, subclause 11.3.1, defines three new MLD
state sub-states (4a, 4b, 4c) that apply when a non-AP MLD and its
associated SMD-ME are in state 4 and an SMD BSS Transition is
in progress.

Add the corresponding nl80211 STA flags to track the state changes:
 - NL80211_STA_FLAG_SMD_PREP_TARGET - State 4a: non-AP MLD is prepared
   with target AP MLD
 - NL80211_STA_FLAG_SMD_EXEC_CURRENT - State 4b: ST execution active on
   current AP MLD
 - NL80211_STA_FLAG_SMD_DL_DRAIN - State 4c: DL draining period

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 18 ++++++++++++++++++
 net/wireless/nl80211.c       | 18 ++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index cfc1bcad13f0..81c16ea2fd34 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -366,6 +366,15 @@
  *	the AP MLD. %NL80211_ATTR_SMD_ROAM_STA is also set on the target AP MLD
  *	to indicate that it is part of ST Preparation; drivers must keep these
  *	links in powersave at this point until successful ST Execution.
+ *
+ * When a non-AP MLD undergoes ST, userspace can indicate the current state of
+ * ST at the current AP MLD and target AP MLD using the STA flags
+ * %NL80211_STA_FLAG_SMD_PREP_TARGET, %NL80211_STA_FLAG_SMD_EXEC_CURRENT, and
+ * %NL80211_STA_FLAG_SMD_DL_DRAIN.
+ *	%NL80211_STA_FLAG_SMD_PREP_TARGET can be set in %NL80211_CMD_NEW_STATION
+ *	on the target AP MLD while creating the station entry.
+ *	%NL80211_STA_FLAG_SMD_{EXEC_CURRENT,DL_DRAIN}, on the other hand, can be
+ *	set using %NL80211_CMD_SET_STATION on the current AP MLD.
  */
 
 /**
@@ -4035,6 +4044,12 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_SPP_AMSDU: station supports SPP A-MSDUs
  * @NL80211_STA_FLAG_CIP: station has Control Integrity Protocol (CIP) enabled
  * @NL80211_STA_FLAG_SMD: station has negotiated SMD.
+ * @NL80211_STA_FLAG_SMD_PREP_TARGET: station is prepared at SMD target AP MLD
+ *	(State 4a).
+ * @NL80211_STA_FLAG_SMD_EXEC_CURRENT: current AP MLD is executing SMD BSS
+ *	Transition (State 4b).
+ * @NL80211_STA_FLAG_SMD_DL_DRAIN: current AP MLD is in DL draining period
+ *	(State 4c).
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -4050,6 +4065,9 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_SPP_AMSDU,
 	NL80211_STA_FLAG_CIP,
 	NL80211_STA_FLAG_SMD,
+	NL80211_STA_FLAG_SMD_PREP_TARGET,
+	NL80211_STA_FLAG_SMD_EXEC_CURRENT,
+	NL80211_STA_FLAG_SMD_DL_DRAIN,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b06772ec8ac5..5df145ab4ab1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8025,6 +8025,9 @@ static const struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] = {
 	[NL80211_STA_FLAG_AUTHENTICATED] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_TDLS_PEER] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_SMD] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_SMD_PREP_TARGET] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_SMD_EXEC_CURRENT] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_SMD_DL_DRAIN] = { .type = NLA_FLAG },
 };
 
 static int parse_station_flags(struct genl_info *info,
@@ -8091,7 +8094,11 @@ static int parse_station_flags(struct genl_info *info,
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
-		params->sta_flags_mask = BIT(NL80211_STA_FLAG_SMD);
+		params->sta_flags_mask =
+			BIT(NL80211_STA_FLAG_SMD) |
+			BIT(NL80211_STA_FLAG_SMD_PREP_TARGET) |
+			BIT(NL80211_STA_FLAG_SMD_EXEC_CURRENT) |
+			BIT(NL80211_STA_FLAG_SMD_DL_DRAIN);
 		fallthrough;
 	case NL80211_IFTYPE_P2P_GO:
 		params->sta_flags_mask |= BIT(NL80211_STA_FLAG_AUTHORIZED) |
@@ -9308,7 +9315,7 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 10);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 13);
 
 	switch (statype) {
 	case CFG80211_STA_MESH_PEER_KERNEL:
@@ -9404,7 +9411,10 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 				  BIT(NL80211_STA_FLAG_MFP) |
 				  BIT(NL80211_STA_FLAG_SPP_AMSDU) |
 				  BIT(NL80211_STA_FLAG_CIP) |
-				  BIT(NL80211_STA_FLAG_SMD)))
+				  BIT(NL80211_STA_FLAG_SMD) |
+				  BIT(NL80211_STA_FLAG_SMD_PREP_TARGET) |
+				  BIT(NL80211_STA_FLAG_SMD_EXEC_CURRENT) |
+				  BIT(NL80211_STA_FLAG_SMD_DL_DRAIN)))
 			return -EINVAL;
 
 		/* but authenticated/associated only if driver handles it */
@@ -10128,7 +10138,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 10);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 13);
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:

-- 
2.34.1

