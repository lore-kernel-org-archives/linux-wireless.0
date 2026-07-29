Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9DF2459E5
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785287138; cv=none; b=bpaDzIMImlHIQVfJswTF6GrIOOWoO10bprmw4qSIG3AbUVuTBu6rmpjfxnPRXi8J2B4Iu9p1UegYlKl2hcaw+3u3URZ74F4KJaRDwYX+J9WQKk1Wt6tgFCBvslcGeL5+ut+NlMLGtlB0qnH3mTbGVi+aqOP308k58VXBMcF2nXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785287138; c=relaxed/simple;
	bh=rtsd5Eu05gTWl9eJA3CFTXLHvsxmuN60s29cbVTL3q8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HgTbHNSNj4IYYVKpdaT+yeBN2SDwHBaD6eQUGED7iMl2n4Vplk9VyjwTMVngfV33jWpWPZ9Eiy/vaLS78FB7je6eQlljG5covydByqAUSlDNSBVxAtME1CG0bfg1TnQt+MOuag1mctkUkwQMYA5ma+8fmptrviwKZqWPlXh3ajE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MoYixZJc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YX4BQUzE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MoYixZJc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YX4BQUzE"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SL2ojo909471
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TNT5GXQJAMiAcSilkiUxETqrPzWUif0/ef1SRCtWtiA=; b=MoYixZJcNOUlMLG0
	qidxHT/azZIonZAFdAIexGA63m/Q7sNbsnT8fSexQCkWhthLONVU8GBfYI+6oy22
	G8mCHaRqw/7xczbSSbrb6l64nMjdIaD6Ztb5XF1txSsaGH7fIa7zc5OPHrHFSNoV
	2xALjOkJ7Grj1lALSEA7jSUsIe0KQ+rsBT4LPUPf/66FLGn1YgrKFNVQBMPX/o3Z
	1NzwrHBnB2LIsAELcrnPxRAChLl62lljCdK26BK5DIzh/CXsrf9hP8Z5GsHpqn+K
	FS0I895Gp8Dy8N6xOv/Q3jL8qGQPmjVq1XYPFrs+0fpCh3NhuzNq3q/ieRSG7u9p
	B199XQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpvxxk4nv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:05:36 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ce7dfd33ffso6207475ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 18:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785287135; x=1785891935; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TNT5GXQJAMiAcSilkiUxETqrPzWUif0/ef1SRCtWtiA=;
        b=YX4BQUzEQKj/uTU78VSNNUR/wKljFclaeLhdH6+E/kmgTx0rQ/SJGxyMNmyaoKwOTN
         hpFERWwcMWuIrSYYMCv8olA4Brywy8r+a/vkVbX0UCO7RW5+InMLfagv5nHvnjKyBXZ8
         6vcREZlCvlHzF6iPLVFrpSPhE2DE+eCNajjIQXsHug4UX64/doK3H0YZ8uH4O7Jr5zc4
         jtipAqwqME0hxyESZZB1+FFCg7eA3Boc6/eR/uZ9jnoYsBmJpPPBV6iFxuxwwHmZX+2H
         pSpnl/KvvcBsB4c3394znY6UJwrWrwl1c7HubjttulBJ+plnnbVIWVX1Pz1CI0jQjDnl
         2srQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785287135; x=1785891935;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TNT5GXQJAMiAcSilkiUxETqrPzWUif0/ef1SRCtWtiA=;
        b=pC5dhVFQ4hwzabtLmLOr5d0sZhbQfLzP/UAO9WsF6jMUqln+EfANhfNhZ/+n44FoU5
         tQIR2cK3AG2BgrgXrrx2R0XIECEBjKz5E2oU6lijqUHMgRFA87SSpJx+7gCWFMIkkxrM
         0PNideWOL/0Xjp94pM8rBzKfMDRGGkbxoGOiEJOc7MKZlm/3NzcjVAWIUEqcK859JbEQ
         iMj7c51Enfl92N9NoTFLfceHZVig54MOHLtFsbc5ggL+RormqMqZqTg0Cyu11gxns703
         vNTBu64iM6hwjBWCEj7n0e6/Ctm3KRRwlh5KPwWVuRQQ/1KGTTeTIxd0H7pzwRdlOk2e
         KvaA==
X-Forwarded-Encrypted: i=1; AHgh+Rr0WGNpK/4gckSzl/WSprTKPu+dG/DlbB7x1kdPq8pSBbh1Iz9DYL1nEaxs36LE698LS9DxYYRHop/00/2prg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4hZJFoGA4WKaitRB7cmrX6hx8pzHuE53zC3U+txhXO+EX3Ya7
	9Zd7FXbxIAz9AJr6nS7LqSA0m5mrKqeKAKc/cHh+MxJlF6CMYyBZxhPeEHe+x8fXIeJ+2mpRCHm
	55o6jJqD8nqElmkhn8tuRHGCRCd10I+q52P6N+3Hr25dnwb65Sw6Lo4YzKwQXe71G05uYaA==
X-Gm-Gg: AR+sD10xxR64o3DFQ2Ot6vr/sUg7puGQ6FyNucXAwnfPemooT5rNjri//YGAoUZKdp1
	zPMBaVGbsQkppexsX/KY0j3WBpP/ZMW891S+061hOFMMIkVSSQSlAYBnfBKMRAvJeK/5NlPes8n
	VrCymN73Q540aGwQD5ERQ8FDUcb2Iq3a7sjcDHtQ3l6CzZ64vl6lg33lTq+n0/gPFA80BlS0RC6
	q3URC/tR+9JgMeUPIU4jYtrGignFNjbgE5CCyQkAVuK0yeFbCZfyNaiBzusDcsUOVp1tYUvhPsQ
	32oPOkfSnJljwODJsFfGAJAayuaW5+fWu6jhLZAoJDkAnHKFDw1z2dbTqrIIVrXxTvebCG2GwF9
	Jgqcd4MQXaXNjUxYATVPkK0NAS1jwVvtqJQB2ordiABfm41+Uvd+zzT8=
X-Received: by 2002:a17:903:1a0e:b0:2c9:deec:f564 with SMTP id d9443c01a7336-2d015c12a10mr59129615ad.13.1785287133940;
        Tue, 28 Jul 2026 18:05:33 -0700 (PDT)
X-Received: by 2002:a17:903:1a0e:b0:2c9:deec:f564 with SMTP id d9443c01a7336-2d015c12a10mr59129255ad.13.1785287133453;
        Tue, 28 Jul 2026 18:05:33 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b67063sm3699381eec.9.2026.07.28.18.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 18:05:32 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Tue, 28 Jul 2026 18:05:28 -0700
Subject: [PATCH ath-next 1/2] wifi: ath12k: fix stride mismatch in
 mac_phy_caps_parse()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-mac_phy_caps_parse-stride-mismatch-v1-1-27a9c1a3fbd0@oss.qualcomm.com>
References: <20260728-mac_phy_caps_parse-stride-mismatch-v1-0-27a9c1a3fbd0@oss.qualcomm.com>
In-Reply-To: <20260728-mac_phy_caps_parse-stride-mismatch-v1-0-27a9c1a3fbd0@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAwNSBTYWx0ZWRfX0uHbbVL/gj8I
 s/Y1IuOXrpGJacb9ayOYe4f5Qx25IxIE4rSp0wZs7FXQMbwSqrru1oV2eGdje4e90VSED8zdTlD
 nMxUDSixZrmCQVCBv2c5HU/oBop65wTvWS3HC7Hna5VM6GcxVjYwVwcQMlyNbipDAYqwf813XB1
 YLMreOOfYjJTMgiHwLVHYBSZ4HFkGznIV20Hlo3cDcQg/ag85vkuTCJDtm1lgNJgY7miI2HHi01
 BR88FBCTg0Rstr8+FCErG6Vr9eWj4cNOP30y5ELacqHvotKRq60xe2+rm2cm2lCiHX8ow7bsHas
 IPCLgvAmPfYJjvP3Zbt1Q4+D9smX9YUq7zEJwtBIEy6NYHePY860MvEn9zCIVSGsMLpLUgaYyOS
 kB6jEHZbGGvvJM6kZ2LhnUe+KgGYTrEnYgG20r5SOb8sXNFClONK/X2sEkE01+VAxPptB6Um1Ra
 kofO7TR8msOVtjkhtJw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAwNSBTYWx0ZWRfX5Pm++QlGFtHx
 rABTG/Qd+W0bY+C1ziPfGrN/AduFWlF9Jub8DDUUKZGk6Le+/Lh0tm7jn5Viatw5WV2J9mpfqYL
 U40UGhxuQ//Oe+qNtCta4qKSlMMjQQ4=
X-Proofpoint-GUID: uHGqXmbcI7obp8U1EH06CRfXkfZELMVB
X-Proofpoint-ORIG-GUID: uHGqXmbcI7obp8U1EH06CRfXkfZELMVB
X-Authority-Analysis: v=2.4 cv=PeDPQChd c=1 sm=1 tr=0 ts=6a6951e0 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=TQlc2wDWUpY00yvoUuwA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_06,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290005

Currently, in ath12k_wmi_mac_phy_caps_parse(), kzalloc() sizes the
mac_phy_caps buffer as tot_phy_id * len, where len is clamped to
min(firmware_len, sizeof(struct ath12k_wmi_mac_phy_caps_params)). The
subsequent memcpy() destination advances by sizeof(full struct) per slot
via C pointer arithmetic, not by the clamped len. When firmware sends
short TLVs, the second and later slots are written past the end of the
allocation.

The reader in ath12k_pull_mac_phy_cap_svc_ready_ext() also indexes the
buffer with full-struct pointer arithmetic, so the allocation must match
that stride.

Fix by using kzalloc_objs(), which derives the element size from the
pointer type, making allocation size and pointer stride provably
consistent regardless of what len the firmware provides.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 672eae237ac6..d466baf5e90a 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4765,14 +4765,16 @@ static int ath12k_wmi_mac_phy_caps_parse(struct ath12k_base *soc,
 	if (svc_rdy_ext->n_mac_phy_caps >= svc_rdy_ext->tot_phy_id)
 		return -ENOBUFS;
 
-	len = min_t(u16, len, sizeof(struct ath12k_wmi_mac_phy_caps_params));
 	if (!svc_rdy_ext->n_mac_phy_caps) {
-		svc_rdy_ext->mac_phy_caps = kzalloc((svc_rdy_ext->tot_phy_id) * len,
-						    GFP_ATOMIC);
+		svc_rdy_ext->mac_phy_caps =
+			kzalloc_objs(*svc_rdy_ext->mac_phy_caps,
+				     svc_rdy_ext->tot_phy_id,
+				     GFP_ATOMIC);
 		if (!svc_rdy_ext->mac_phy_caps)
 			return -ENOMEM;
 	}
 
+	len = min_t(u16, len, sizeof(struct ath12k_wmi_mac_phy_caps_params));
 	memcpy(svc_rdy_ext->mac_phy_caps + svc_rdy_ext->n_mac_phy_caps, ptr, len);
 	svc_rdy_ext->n_mac_phy_caps++;
 	return 0;

-- 
2.43.0

