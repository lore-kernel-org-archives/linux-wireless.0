Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367038;
	b=E2VcaNtJiY1pJNp/OzQX7BLTg1K4JTqEaEMCAEFtcdIpR5EcpfKxL2TaXxUVfj29lvAf
	 U0XT65aWyyuRvcMbhwxT6eRotX6PgkJCHEub2TpFwsIH9P6tdQ8leGMDXm5e1BCgFTL4E
	 6cZsvUEQmSIgTvGLvVhrQ+8FQzSjTWjqI/JHKeBAeUV25OCAS0HdLOb8gZduZCSAwjafY
	 6CxhCycG8dXWDL0Lb+rOAndM5VSo6zJ/qoW87H6hlF6nFChRO7PCUS66x+byaIF+o1P6P
	 sgHsnCWlDZZ8SdNXJl5GrTkvBBaPEs9mw4BmWtLXNY+BzqUGV+4IDY1KFhxU6FzkB3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367038;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=VA/xsbwS9xK03WEAI9DooGFyk0lAILSAUIHA5CarXVA=;
	b=ccRkoxOyt2PfaZp+mmcCSb9vhadaZcX+MPbRiWLeiRE2i/jnqJPKdjktIp7dbfL0OID9
	 yvskb+dhZ9IlqKKXZ75nqTCiG7fAFQ7c+hT57luho/KxzACT3Uz6BCtLvjOwWGsLZdrDW
	 uNfJovkU/ERxHusSbFxn8Jp/MtYOHbSlcYarvwC01Sz+zS7gtaZDqHV0j0Dz+pRUqiVR4
	 oTmAVdotVMxXZYU8W6KM5nFdbqEqZkCxoxlli9HsR1iVXxVemg4JPsYu18Qi0gMfJGEEQ
	 Uyp3GpBI8tj29sjH5IRhAWs5r5Xo8otkWj7Ct+U7FkiQ2TEPiRIhS/qPJx8xD3dBP3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=S0bSiYTa;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="JK/qzhjs";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74C0606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E74C0606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=S0bSiYTa;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JK/qzhjs
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBGXOU3679136
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=VA/xsbwS9xK
	03WEAI9DooGFyk0lAILSAUIHA5CarXVA=; b=S0bSiYTaUe1w/7Ej608LtNtfKDL
	ffcowY7U6+cUrKno2wSL9AORRPp3/sEB9ndJBfb+GNYn+jhGoP4xM9h33rFzLagn
	m5aRfS978RQFw4kejV6S2XIy7eggyF516lMcB0o9OlfIKhn6CjBZBU7IwC/+URNh
	b/KQ5SkS+gJzBSxJBImjNPZvp+mbCdR4cWRy+r5aC+JdvCS9Pz+++w6vGQQnKfPq
	TxesyowfBk2FrdBI/MCRNEJaqlrPwWNaEK0GnTjYj+hWrUCrV64dMtNKj83WEtTZ
	fubun4INJrFBKeooieVm4BkL54n3x0yDyApE4pHRqsKjBY6KE+T0S/0to/Q==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qk7vs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:36 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3adc5b185bfso770419a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367036; x=1793971836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VA/xsbwS9xK03WEAI9DooGFyk0lAILSAUIHA5CarXVA=;
        b=JK/qzhjsbXVhNVsRL1f8zBN2Ii6EHcgRa4/LCc/UDJttwFQuPT4P/t2knlWDtnP4bb
         kJCzTwxbuBIzvOC54eHuwMtegOlryzsscfRyAfxGooorGA+etSC4Glq7SPNhbTte3H/u
         JPs51ucD4LbUWkUBg3x1HQeWekX/3Y8JBk2TNrnwefL6PYX50MpJLP7jnkuMDKpVJYPQ
         qjtzrzhcJ08RlLlLjEqQb/sZLdlkfD8dNM2JH38eSvJHDjipWC1e8zyfG3khU/RNqR+s
         xNxgeURuElS/76yW3og9+fTALZDMebGATyoGirXmOHuWz5a8Gd85Ru0Mwf8LDZYTqEFE
         Sf0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367036; x=1793971836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VA/xsbwS9xK03WEAI9DooGFyk0lAILSAUIHA5CarXVA=;
        b=ykZOLzy0AiOAeAh3fs1GR25xeikDFUEtyzM3W1EDTOy1HhExWSMUuthSYwiqBRCjHP
         X/ThxNfi4uNuhk/BeBmlC99pWHKu1wh/dNcj+vxsAmoreTJw21yhGSBUTEMGzeKjdiiQ
         l6pWEWif5FtOC7jrwe3ud/Q84a8sSRlEme5iotT1tHnDxZRaFM+kdjz6xFDcOUo8eJFV
         77KGMwJifL90mBfRk69QmKj8D8OD8e8suQGbL5Jbiy8GJjK0Mvkk+hDh+OhMUs3VUABQ
         TXl2io6Xpz3JdG10TE43KZPWjYnOH5cZaJmtkVhU6GFv+FwQm+GHw8NEnvFr6M4sqLjg
         NKnQ==
X-Gm-Message-State: AFq9FYJiLI/3Ei6hzxiZlXG29bH1V/tvtCnvrRHlePOgxrsFDk1hJ79d
	ytntc+aYoUkJkHxGUQLCUkj4O9NT4naB3e7WeHcah1yfJ7UYgaGlXxzFav1tI3nXxjPWd1zZlsz
	UEuVj1uNEw76E+bgGPi7wkJ9q+DQUjYvMtTjKXOdtlg+sIjJrSPYBbp30gmX+BSAhgozhuw==
X-Gm-Gg: AYBFou3uG9b0UuuQ5pxizgMYPnR/WhOGTSnTN4XTyYXCfbesjWTq3xpuHkAjuHHih+7
	9s29rF78yHiNxV1oreme6QshRhtLfpwX2G0Kd0Yd+bwMOywiYOjwVUuFc5fpiHuiQSgwCzDIDlO
	jhqQHRx9T+tU8uARojEAdmnunVJSgCTVFTWCnkCmbwcx17ldcDsKxcjCdZOR16BhMrnvj1gNu0Q
	VsvBJImRIZtDbjn5DKpDAV1HfSS6JdHEZncJTdfutQ5TkFTXeSu5sT+8JS9nstzv+2RM5XyXXFO
	SgcyyiJpssbEP6R+UwyVkn/Esp0CDHs7OFp+nfXG2n6Fkb5KBiEYIgbmSaHWyoND31XsPTZW5sa
	oOYoIODR3DTqvxR1JwvvNyk+LadHQrDJ77Yb3s69m6VrXca/0h7aDb4Btm/7kPyhmSucdMEPdQ3
	S0WreYF+Xzqg==
X-Received: by 2002:a17:90b:280c:b0:3ac:9669:846b with SMTP id 98e67ed59e1d1-3ae895746f6mr2035268a91.9.1793367035505;
        Fri, 30 Oct 2026 06:30:35 -0700 (PDT)
X-Received: by 2002:a17:90b:280c:b0:3ac:9669:846b with SMTP id 98e67ed59e1d1-3ae895746f6mr2035234a91.9.1793367035014;
        Fri, 30 Oct 2026 06:30:35 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:30:33 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 01/16] wifi: nl80211: reject NAN add-function when Discovery Engine is in userspace
Date: Fri, 30 Oct 2026 18:59:57 +0530
Message-Id: <20261030133012.3009774-2-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX5XPCUYlO6nnk
 T+mYh+r5kJVDRPDa8YS5G/MV3XB+IwOmevx29CypdOKbAmiWCe6f8LXqG67xPtlH45V6VbT1Z6W
 JguqPgE3TQ5d0VUsg0fzk2lDvOi5ykT4sft1+c3XJz588y7Rw9tBc+tCHHBCyZAJwsDXMz+1YW9
 ITj8892eXD/oSztsUqkHW1PD8E3xAnno4MixQ5/2YgwAMV245l1gnZQFQxd2AMPsBzVPFIf9ZKQ
 fL0kb5NWwvTOQ4AmR+6Sj2aO9UFHSMjZB+tBewn/N8SalhDip52rKG8FNd45ewQjTc2NizePPrV
 3kKka+P/b9/CGKKdzcsnxnsb1e0y68MfycKlRrnlrbyrFwG15c8CL/ddZooGIU969Z5qVA7C8/T
 5jvFvNfP9wHY6w6ppogiii8K2OaJsixgUq8TgRQw09HGOVC4I1n9d2EPLtgCVdbVh+wonP4TqSZ
 yGsSZHyGzTFRXO1z6dQ==
X-Proofpoint-ORIG-GUID: LNioz77Rqqat9K6-dYlqSU-GwEDFJAf_
X-Authority-Analysis: v=2.4 cv=IeoSymqa c=1 sm=1 tr=0 ts=6ae49bfc cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=ooLRZxgLdDP5yNw24dUA:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX3MONBpeW4o4c
 Jb8z+C/ox40QgWtsPCM6DaOU2REvTUPv6o02QNt0TlCQkSnh5l/LQtL5dFOYN7Cnv0CIRnjrH4A
 VdSl3EKL19bQrzWg36/3HVSwdqAjIFE=
X-Proofpoint-GUID: LNioz77Rqqat9K6-dYlqSU-GwEDFJAf_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300053

If the driver advertises WIPHY_NAN_FLAGS_USERSPACE_DE, the NAN Discovery
Engine is not offloaded to the driver. Reject the request to add a NAN
function in cfg80211.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 net/wireless/nl80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2fc680382418..dd187990dd08 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17400,6 +17400,12 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 	if (!wdev_running(wdev))
 		return -ENOTCONN;
 
+	if (wdev->wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_USERSPACE_DE) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NAN Discovery Engine is in userspace");
+		return -EOPNOTSUPP;
+	}
+
 	if (!info->attrs[NL80211_ATTR_NAN_FUNC])
 		return -EINVAL;
 
-- 
2.34.1

