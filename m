Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951984;
	b=cL0M+WW4T3YVg282cedilirhdWg/kwJ7JOhsPL+I0ktLAkknsEPLe5KZ8VXGPSApufUO
	 9o9dGUO/YftCNUxuCoasNLN/rmv7Ni0xrUAUE2BFmnvYNZCdRLPQYskS/OV3Ux4Qdim8E
	 omyl95Cpeffb8XudZWGpO1/0sEjg4EDibDI7hrw3+ShBlUtay6WxZ5ja/wVYc3b2csQjf
	 BHJHiLRJqmZQe+tTHbOAO7aoGKO9XXklPW7vi5+MYqJEdmiGcpnUZW8V/LxL/HsoHiYlf
	 051+p29BVCLvTqrFpUL2M8MSxwWxIP9kVTqJwsmEmEI2dgIJA80hk18iPXN1PrfQdtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951984;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=1CaoxN6zt5X6m83tcmfk7NC3MrRn/dsQA8uQ6GrxsYo=;
	b=GwmnrbHJKQxvc6JmleDEmvYJQ4412IBqb68MzJ3IwO9U3iUT68cN8cT/Ml37Zj9e/TrG
	 m84W08sbDjGZmzOWWDlTunEcHDHcc+yJ83LWKu96yrLGWu5+BjXRyUdBO68V6PwU4Ri9f
	 HTPhmA/AqCoTs1sTHbx/0PGZ3MRR+hQVN+9AAHYSOfbKO2HLcWiJj7coizOicQ3MwrvZG
	 n8/q4Ky9zwnWLFF2P3ohDfj2J/+5a95T+DlhaO28lG/EBAnGONd3J7c2fm2id9YX4v5rg
	 myIxmDFKB8e+xCcJqOksi5yWDWzjOBqnR5yVvvADuZpC1ZZNrsRoCPIDUA7VrGnt4PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=d8rwDRIK;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NKdoao2m;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B72606D830
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:59:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4B72606D830
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=d8rwDRIK;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NKdoao2m
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RR5Q3907032
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 07:59:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1CaoxN6zt5X6m83tcmfk7NC3MrRn/dsQA8uQ6GrxsYo=; b=d8rwDRIKQtogKg+N
	6mTzDmu4vpuTXbcUxKwUmRp4/lGB0x6sLLk/tFvMdbvHH+JTJOlaxnnCPqgt3N9b
	EH7PyYyIherK+oUgKhiQSIknMu3iJju9E/y8h1ElhoqwDpSd6YD3OoTwMEfudt1g
	aUmCWes1yFLHIWhvWMdy2Xtt+DfLJdGFxdLdKjujqFeYRCaXV8WiueB7UtRAz6x9
	WbPa12ZEeWTy34oDqD8JKT1lzEqDjexvWMiMOuyicvLkCvKyWCX3Oy6z51+Pba47
	5aDzVfjq6pFXbfTwjeiE+DuEZFr5MDT/QaLOhC9ke87tF2oxnKL1Qz4vtZhEqp5b
	RP0AsA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pasqja-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:59:42 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3acc98e3b3cso343645a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793951982; x=1794556782; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1CaoxN6zt5X6m83tcmfk7NC3MrRn/dsQA8uQ6GrxsYo=;
        b=NKdoao2mF/ApdylFvDff16tVS3DNBPlUvYPVSGgj2LSpSoZrPWi2hk6l37t9jwFgNs
         d7XENG7z1/64CNcQGWoEDT8kBjyrzAorUeJ5D90iJ/JzUCyDu4T4atGcxHiRIVLfBJ3v
         euh7H0QmFJ594E6pvQOW0i87hzKZQnM35fXTLEdgMtoSKwEyFOlERzEFQoFAGrsyK5JD
         leFeETQ2Mq22SuQXxtZB4e2jQ4YFS5i0EYQmki0XxQzunyX0/XTzNBAIXvwHLDMDpm/A
         3k0eg/stw2XqHUdMOI7uBBSp4VqjmIRxaPEa7vq6zsHLA4gByKSQaHNAxMi4+YG9WIjL
         8OqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951982; x=1794556782;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1CaoxN6zt5X6m83tcmfk7NC3MrRn/dsQA8uQ6GrxsYo=;
        b=jF7TpRgO1gyGlP9M4jh2NpEoopcXPuUZdxo98IVcbsztzO1I+jAoRHgYVyGnm4bAtP
         Tvv4kSujf5rQ+CdbV7v6+Aif2uZzBmllqjei16zxJhbXZdererml2iNCQX/xYaeOOd+6
         2zWtlrDq7np81L/Lkf/hFII5mhzWyNNATc4LMvAD2rM7vvAJ7mBs9wUljRXundTC1tbY
         M1WWc2vF7AjEiwXBkyAmh1tmRi4sP4oeUzdDtrWhTIG+MR49mQ+Ogc6VMek84ih4U1jA
         vEwb28ZnTf1Oc5eKYIFXUsAfJ3MKS1GuoEwLcU3xbeChvW92yYvUX0lC2UCbK8s7O73f
         OI7g==
X-Gm-Message-State: APuU4Z82bTlLOVVhN994K3RfhCImxJLr8uADTFM9hb6R5a8n/htwBiHI
	8HEIBhcM+j7YcRVrM7X5YeulhC0c+y6vu8EFy4S8S+gVXh2b2SmhfyaDNB8mwizNTll9ATeqN+f
	7mHr8RU8V9RzpFhj8l1QFPxhwAECLUCVHEtxfTEN3fYZ2d+1P9M627W2R+zeqXK4zeFhzhnXobn
	4y
X-Gm-Gg: AYBFou3dbhePYBjvpY7UVzYc3mlMACZmW7RMCYso1d5WwwdVkQTutOEVfrAN6/3/AHj
	tAuwPOTQHAZxkDlQpgKBnCrVgCx4BNK3TyI2VKB4wrByIJTrRmBjrE/+OdtXk4uWEYELgLWN1a9
	qWawP4XqkFrsqIReIrAPGoehjsMdUdzk54iV5jMoyiM5hSmAgcoORl2mCYPgTlxvOmgw59PMG6p
	JCEk2pgNItAATRynnNAvCERC4BAZnFyOJpH47OPiG+VuNxaOO/JJzKVNw7rq37uSDilYBR9w26S
	noEe7WOcQLX7pUmKTwL0n3uO4f68acfRIkE8GrtlO5Mw+Ta3ptjFqVbRw0AOHSveE/HDkMZHyJS
	qUyRtd4L6k+H3OJFdIZrehaARIN4FTV3BjRdew0182CyFAu70cTq8EuNBdIz0ZpBriIWRb9zr1s
	thdknDwFic0RfeDXt4Ax+S8M/ZaRrH4Eyj1mo1xvPHxgiP0Rg3xJoNmHzWhhf1wRF429XplKs=
X-Received: by 2002:a17:90b:390d:b0:39e:21a7:5df5 with SMTP id 98e67ed59e1d1-3b0db6e4762mr1346188a91.24.1793951981960;
        Thu, 05 Nov 2026 23:59:41 -0800 (PST)
X-Received: by 2002:a17:90b:390d:b0:39e:21a7:5df5 with SMTP id 98e67ed59e1d1-3b0db6e4762mr1346181a91.24.1793951981396;
        Thu, 05 Nov 2026 23:59:41 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:59:41 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:44 +0530
Subject: [PATCH wireless-next v4 07/21] wifi: ieee80211: define API to
 check if frame is class 3
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
Message-Id: <20261106-smd-v4-7-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX6hv8uCFKzERI
 2QQ9PJso4fDc2PHvzM4TFUONNIsrKNLlzpfrp5ZDMQS2rfL2GonvIPqfkPkMQ2xoKpj1H2CznML
 BAKKzyYp6y+fFEtJ6HvvtPsbvBFtplGKfgUtE0ZdU+t56a2Gqto4BdOl3FXshZRFnE2HsGU+apg
 GDJo9/jRciZBt5/0HRAzKS3B+9gADGtakhMMBKTKyLhM6jqSPcHo2/ygI9iGMA2omF++ueEUNqA
 08vO5pRLGWh/Cnd/47cQGMtRPvSptY5d/zPsZD1L3w3PQE2l8U3k0pE+rgJgJ76TWUMhua00qUw
 PCmXdFVMeAaVXUzXaUetFpxUJ4neB8ewUZQJ5LrG0QVX5ADgtjNvmAbZtEWyPXIErJGs7fW7Ras
 XAcv9rmP2jSg2XyGhESQ9TH31Ns5bprczLOjC+5OPqqvhrauucJO/5NREgUkpgRSDvMqAXPCC/X
 ukbrWbVGpXID8bw94Ag==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX+ifzz5SV8kml
 RXBKZjYc9LwsyYzf9wG9j+aBjeKPGSmG63uEbu+cgbntGLY0i79G/S5dGUWRhbM7fffrdS1q8pG
 kyEnZIFY9AUeRoUNltMKAEoLpRpK5Yk=
X-Proofpoint-GUID: ozvtfDK9L46_Zf07MmzifC7FqLaO1e6y
X-Authority-Analysis: v=2.4 cv=P4ivFSAu c=1 sm=1 tr=0 ts=6aed88ee cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=e1lpAkfDEvgZfVEreGkA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: ozvtfDK9L46_Zf07MmzifC7FqLaO1e6y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060031

IEEE Std 802.11-2024, subclause 11.3.3, classifies a list of frames as
class 3 and these frames are expected only if the STAs are at least
authenticated and associated. Define an API to check if a frame is class
3 according to these conditions. This can be used to filter frames in
both TX and RX. The API simply classifies the listed frames as class 3
and does not check if the STAs are in expected states.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/linux/ieee80211.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b2c90c4b262d..3754401f3435 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2940,4 +2940,47 @@ struct ieee80211_cip_cap {
 	u8 v;
 } __packed;
 
+/**
+ * ieee80211_is_class3 - check if this frame @skb is a class 3 frame
+ * @skb: frame to check
+ *
+ * This function checks the frame class simply based on the list defined in
+ * IEEE Std 802.11-2024, subclause 11.3.3. It does not verify whether the frame
+ * is unicast or related STA states.
+ *
+ * Return: %true if it is class3, %false otherwise
+ */
+static inline bool ieee80211_is_class3(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	__le16 fc = mgmt->frame_control;
+	u8 category;
+
+	/* Data frames */
+	if (ieee80211_is_data(fc))
+		return true;
+
+	/* Management frames */
+	if (ieee80211_is_action(fc)) {
+		if (ieee80211_has_protected(fc))
+			return true;
+
+		if (skb->len < IEEE80211_MIN_ACTION_SIZE(category))
+			return false;
+		category = mgmt->u.action.category;
+
+		if (category != WLAN_CATEGORY_PUBLIC &&
+		    category != WLAN_CATEGORY_SELF_PROTECTED &&
+		    category != WLAN_CATEGORY_UNPROT_DMG)
+			return true;
+	}
+
+	/* Control frames */
+	if (ieee80211_is_back(fc) || ieee80211_is_back_req(fc) ||
+	    ieee80211_is_pspoll(fc))
+		return true;
+
+	return false;
+}
+
 #endif /* LINUX_IEEE80211_H */

-- 
2.34.1

