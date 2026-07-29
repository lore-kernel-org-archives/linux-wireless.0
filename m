Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E482620DE
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785287138; cv=none; b=TMuiHmowQrGi4gUWMsMDDN1Qs84Zpizo8sUuk/Lj2QVz/pp1gNfs5D5tOTxz0HilTuGM5WdqmRl6AIeKvsgd2wFAJfy6VDLcJxUYoN3mG8gIFqIysE1Y5p3SypK7RNEHg7Z7284rUY+dwVmilkjBH4+uLRD/pZGfoUhXV+aI+Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785287138; c=relaxed/simple;
	bh=sKzNszAqX0VVzSvbZMWX0RX1ihCY64pCtcvl4yCI5kQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b5dbfsVV1krBxX6bFXfXiLRJtkVxct67Aufa7LYxmhrE3qqCHxBkKjLeRKILvef5Uv4sTu8Hzlwm0QBpacNboS/+DoMqjfw03T/ANESO0NUXOEIN/nvVDKaSycXvLmTchHo5qhDWc68e4TrJnofO6BnrcPJQj92vm/tLNjAj/yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CxEtqH6n; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ap5k1MlT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CxEtqH6n";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ap5k1MlT"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SL2suQ3724479
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	R7OCiOhUvbS8MmL9dYvzzL3m6qD2Zu/mwC+MTVmjD4g=; b=CxEtqH6n9hiyd44x
	EQGqVmBZKFsPX04IOP1SV9UL9cS/ATROLB6TyA1XKjJRB8P9jt95+cKa6oQiSw1s
	uMqHxlNACwVs5STz4UBnE2+bwMI7QGt0Hb4AOC04MvZS2trqlfRyPAlXrjongcjq
	ah9G0tBAccVMgtkTMcP11al+8a8sJ+h5xeeUVmPwdlkrg3H2spTqK3+QveV3DrHK
	n4iCgpQul7tydTvpK6khE7Pgc50U8Fa/WSqb8iRSQdnjbjeWgGZ4BVjHgE92qWHb
	BZL0Uy5mX8VhXMnRhA70jC2LD6M7mVrC6bnjDQPElLa7Hn0TrhGl5qTn1Dnlp08j
	SVXzSA==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpvd3k9v8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:05:36 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-848860def2cso460072b3a.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 18:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785287136; x=1785891936; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R7OCiOhUvbS8MmL9dYvzzL3m6qD2Zu/mwC+MTVmjD4g=;
        b=Ap5k1MlTS+b/RGBnh2yoeh6y/XeLcq4/KbNO38IZrFYUwHlGhhco8BtZOsu/Hg0lD9
         JHXwABFmsq1X14blfDnXXYFoqGxnZgDYIlTkGuvLtWYvqbkabwV3OqY0kFoixpZseNQC
         AEZTg8V+1EeIo6G7V9250z7z0tdTsVZQ3kG8p5knFEnYOCFiYVdDwrs8u9kxRX3f8PIx
         GIdr7oaI36A2a7j2SGBgzI4vzGTVLnRol+ALVaX81rLV5kufgo2dBM/ZOwtIm/J/K3Gq
         KRWF3n88QJ+H8NaMYlVmCTcWPR88RXkG80vlj7c8x0woDSosD7hcwQDZF1C9wLc9vZq0
         H+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785287136; x=1785891936;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R7OCiOhUvbS8MmL9dYvzzL3m6qD2Zu/mwC+MTVmjD4g=;
        b=nfrn5pTRrG/yIJ1P7mGKEU+vOthtN/j/X7yAVbMpcDnzd2OPOFtcqL9GfqsVrmC3mH
         cgzl3pnafeD5HjiHaTPmmAz/E3AYqx78+viweBhelmvly8zizdEIWWHg0de6B4Bj3A+z
         yEinsirjL7XHIeOCuKyuNcJNGVf7hkp1sMbeXEMrdRca75BeoSlHV+IkMcznRnC9lpgb
         bKODWce/nEUvQM2PleQzhbkF5MtfLlhbPE85aYKQv1FaV+AW3XGXLwQCR7p623sTdDbn
         Qg0o21e+X2vxGj+J28/OHFe3GPg2kmfDEBOqP66mS80oiVMNzPdhWAQOjVjbUbtYRwrG
         187A==
X-Forwarded-Encrypted: i=1; AHgh+Rq6qd1zHJlvwflQ8pkzVvf+Y3KtwGl7vd2MuAxxzG2yB/5Xzvedo5lP92dAdP7Mu9qIeU/M1NcYWPFlOFOQsw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5+hHuHaPTA/POWSGEV4UWvt/voih98raQvTv8SZWnxQIvqj+e
	WjoDtN+EmQo5GZamYRiU+bKvMx/25WmzXLlBci1+DeE3N+so9YO3N8/HPXylhFAo8gzONCoiwdf
	kBVdim21CsM2W99va5XMy4Bb+iEs57fSGsHSz5tQTJirrYqRu3g2Usvyd6UOHQvo7KUR/Aw==
X-Gm-Gg: AR+sD125Jt6Y9pX2HB3VVBoPkYPLlEc+0m3naPoFf/3riLMd38fiklqTz0A1pAgcqHo
	2TJe753Zv/oBdT+OJFRSDkSWQL41ly0i37wn44igrlCJgwBLVR53GUsrK1AVtNY/4d2h5PP89WY
	jPUrOwDU6GEa5eMsrTitHW/aWxgzdOtXThKbBP2vucRKQGQ0YzVJsriY96l7vzo/TBpap8MbmIg
	OqHEAf1OhsDO3pfxQynRctPhhGUq5RZenEEAYWsj/dhAApJyLxijhbJePYLNKI0v3J1Swd/JbFN
	v3dTz4CB724tSdTk4KuX6KXtd4C1NPKNgsa+ba5mpWtvmWy+KxrNiR1ToFCgr+eAWV/9DAjsz8k
	RRUln6wXa5ZGFqiMa7ra9eOgQCmqcuKjH9WnQ6pKdN8/k6clOc+NwouM=
X-Received: by 2002:a05:6a21:a85:b0:3c6:5723:5356 with SMTP id adf61e73a8af0-3c8ba63cf5dmr5963976637.73.1785287135729;
        Tue, 28 Jul 2026 18:05:35 -0700 (PDT)
X-Received: by 2002:a05:6a21:a85:b0:3c6:5723:5356 with SMTP id adf61e73a8af0-3c8ba63cf5dmr5963939637.73.1785287135320;
        Tue, 28 Jul 2026 18:05:35 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b67063sm3699381eec.9.2026.07.28.18.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 18:05:33 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Tue, 28 Jul 2026 18:05:29 -0700
Subject: [PATCH ath-next 2/2] wifi: ath11k: fix stride mismatch in
 mac_phy_caps_parse()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-mac_phy_caps_parse-stride-mismatch-v1-2-27a9c1a3fbd0@oss.qualcomm.com>
References: <20260728-mac_phy_caps_parse-stride-mismatch-v1-0-27a9c1a3fbd0@oss.qualcomm.com>
In-Reply-To: <20260728-mac_phy_caps_parse-stride-mismatch-v1-0-27a9c1a3fbd0@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAwNSBTYWx0ZWRfX2itm2qIN1xlC
 DjyWPPqGzxfvSQILG3sPjYEsXCPRErwHwoZ5FnlreGmmdMScP4Gc0LnqX8tXB3ViVgs3YES+nbh
 iYQORDCORaSxxqw4vHMDHqHBVq1sP5Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAwNSBTYWx0ZWRfX9vyTWxUSFF58
 Vka2nyaicgjiuARcXzN91xqQkbLy+nm+NIZr6+L12sWpOetIE35Qui6dC2A63L7YH/C1TLqO8j5
 VJekMMEeFbni69yXFs57Umi4b4yJ4Uub/vfF1j+3C+Xqq7iXjPYy1e6IkDbvP4OeWezODGpekBf
 rEF85yZUlZS9jBqFOFe6/KEhUxxNY21qpCUsgOJr2J4/xWnvoQZ3b7Q6B4j298iipMDH+FrFMU+
 2gd5rmjhDuPAUtgeChoiqVJ4uH5gxP5JrMLzZHntLl+gzAhobbr6Xhv/0YZcSirFQkquw2MzPIn
 +dwI/7qlCbJsNM2td0XbSL/RKXoRYM1mQFfl1OeA2c8ZpmnrZtms6PKBoyJviU1br7IndTDQYlh
 2v0skMR9XXtIEsFgBP1xO2keHtTCJz7s6NNvEHbBCpcsWEZdqKTTVj5VYORKpMrOKVrG6//4dPr
 AhObl83RhZ2StELP1CQ==
X-Authority-Analysis: v=2.4 cv=SqegLvO0 c=1 sm=1 tr=0 ts=6a6951e0 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=y0DE-vWUm0S5MY-z67AA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-ORIG-GUID: VxkJHeqskJ8kklZhJURrDEJGFex-9uv2
X-Proofpoint-GUID: VxkJHeqskJ8kklZhJURrDEJGFex-9uv2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_06,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290005

Currently, in ath11k_wmi_tlv_mac_phy_caps_parse(), kcalloc() sizes the
mac_phy_caps buffer as tot_phy_id * len, where len is clamped to
min(firmware_len, sizeof(struct wmi_mac_phy_capabilities)). The subsequent
memcpy() destination advances by sizeof(full struct) per slot via C
pointer arithmetic, not by the clamped len. When firmware sends short
TLVs, the second and later slots are written past the end of the
allocation.

The reader in ath11k_pull_mac_phy_cap_svc_ready_ext() also indexes the
buffer with full-struct pointer arithmetic, so the allocation must match
that stride.

Fix by using kzalloc_objs(), which derives the element size from the
pointer type, making allocation size and pointer stride provably
consistent regardless of what len the firmware provides.

Compile tested only.

Fixes: 5b90fc760db5 ("ath11k: fix wmi service ready ext tlv parsing")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 2d2c6d7a4a3b..f80e9b4a8a39 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4800,14 +4800,16 @@ static int ath11k_wmi_tlv_mac_phy_caps_parse(struct ath11k_base *soc,
 	if (svc_rdy_ext->n_mac_phy_caps >= svc_rdy_ext->tot_phy_id)
 		return -ENOBUFS;
 
-	len = min_t(u16, len, sizeof(struct wmi_mac_phy_capabilities));
 	if (!svc_rdy_ext->n_mac_phy_caps) {
-		svc_rdy_ext->mac_phy_caps = kcalloc(svc_rdy_ext->tot_phy_id,
-						    len, GFP_ATOMIC);
+		svc_rdy_ext->mac_phy_caps =
+			kzalloc_objs(*svc_rdy_ext->mac_phy_caps,
+				     svc_rdy_ext->tot_phy_id,
+				     GFP_ATOMIC);
 		if (!svc_rdy_ext->mac_phy_caps)
 			return -ENOMEM;
 	}
 
+	len = min_t(u16, len, sizeof(struct wmi_mac_phy_capabilities));
 	memcpy(svc_rdy_ext->mac_phy_caps + svc_rdy_ext->n_mac_phy_caps, ptr, len);
 	svc_rdy_ext->n_mac_phy_caps++;
 	return 0;

-- 
2.43.0

