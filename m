Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CC4394E80
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 17:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786642796; cv=none; b=q9i7RBwpQ5gL6/FKV6GJ0o7nrbsckN3LV8BgLLnNrxc34hG4xYX3g11INTzOvAPwcwu9F56/5U4T7eyrgs4yXrtXekObVHmQbte/Lm1F4xnuG2JyO/z2G0hrgEBpSM3B6qdHczFidZc0WrcEbdP2igXjGCat/c7hfJ8ptikTF7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786642796; c=relaxed/simple;
	bh=xLF00iTls/RAYDJtyGsB8K+5w9HGYHEA2gaF0Z64x94=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=oujYpu/SAuF5BWkrOKh8V+zey/dV5qkMEHjGKGQ0BxDaUKXQ1osJseUfxLtHDaJwgl9zIzdMHVCb6BzQLj4LD1oAcbaVG2VOC0Bv9abJIRQrGLu8n8W5yp+i1sNpQ7qRhzldyel5NshF0jLK2hy7pikSd4uWNtj8xtnrDfJ+27E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mpI1sGF2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Vt1NAgQe; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mpI1sGF2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Vt1NAgQe"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67DH8Ksq3052591
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 17:39:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=j12qxXFZRgGvMYL4VwSD37
	77CSO2qlK7lXA+b2yjqMo=; b=mpI1sGF27CCpiYRPc82qaYKuDzlF50D/MUPpZo
	gqf3Tio78xBdjTpbzAs7fuVb3znmGXiAZTZOwou3eFmOqj6fATmOeNqjPlqSZf+h
	Ks2sQNbiGv5gUMJDAU/REAe0E1b68jTZIV1E5HMrMpEC5OxMG3jr0VnQhm1QNYNc
	Az3YnUs4YRbmWKwWYerHm3kdvmY+leR/Sr053peii6H/YlOuxP+Hqv2S/ntyw9Qd
	qczMl+Uli136ZEZ3U9qDWeLv/KEA9v9rzXmvHBaT5GcD04SdTToqKAoeClvtBpUa
	LoL671+5oAeziKzBrai8HIWXgykeiiWp+O2QvYoDocigApKQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g1j2f04nr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 17:39:53 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cacd6d37edso2429635ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 10:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786642793; x=1787247593; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=j12qxXFZRgGvMYL4VwSD3777CSO2qlK7lXA+b2yjqMo=;
        b=Vt1NAgQepxy0bZqF04pwnkugztQHj6HUimh9V0lWrBTvhaax8YVpci1csVwfirKvhL
         YXhoEoz+2R9KuGTueERSWh0seH+N3xwrkN5MV1AA1PHOe5aLKr6Sj5p6iiqSb36wXBTn
         zw0PBzQahO5amm2AecVDe62uw7Vac3F/Qfad8ZrlnoG3Wo+xE94I37tSQR7/XPYwRQiz
         4ReBc6qLd+Xo5/RVtTxKbJWngOkvJrX+7EaboQyEt2n9qetYbMPZCptvW+02h5a9TkLI
         ivH8aI89S1IjwasNOskPjwDDjr++B6F3g9p052ERW7Zuo6BPiPf22yhX3qEuPN8kk76m
         GxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786642793; x=1787247593;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=j12qxXFZRgGvMYL4VwSD3777CSO2qlK7lXA+b2yjqMo=;
        b=RYRDKLyJZ8twLtM1NK7cZfsnBNI/xaEpwTO9SUeGIcHyjv5mr2fIyayOGczJkXl8VE
         Ys1fSaiuTPmyqqACAP0MOpIobGsvqpP343zxyeSqUUXRUkehWqnjrr/QhQV5fegY7kOK
         T2BDPrN9KspwW/P9lH15aI7NvVXUtXIUf0VM/D/11rcTAlguyfbXT3v2QlQz0wBa+FH2
         OZiZ+dqpsDsijI10Inl5ZigKctkNjpNL7wzQyDS+1JxuFoh7V/zzBMXWCLI+GYvwe8js
         BSjbrYeuUL7xg2Db6Y897e9TpsMGpSC6l3efGc7ckGnO/2ctppQI4QwQubDxHBrgZEkj
         0skA==
X-Forwarded-Encrypted: i=1; AHgh+RrnIOQc0nDxQCJLvoQTSU7SLYwfD4cLMpWibhw71kP6yMsguQ1Wbc13lkQnLCfzvhbV/UlHozlWRbVaAw5T9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxnvSuSdmKTJXPT2dJA405mGL2gc3ggepnmn+G4mCyEC60eM+vW
	QyvLBzvd0IAUfHaGFg1dhTSksO4cSbhkD4Pv5k3K7oDQIDWQj+AEAukVcFa9FpieNoIEOleWvK2
	o+1xQo59IwkxLf0NE05T64bZWOGEnTEAux0Qz71Y91zEYWABZE2y9m1EGRe9chsStHoM9fg==
X-Gm-Gg: AR+sD11vuUGxI61k0EZZfjEqyTeBQqUlhzMK8qTqpyMDSykdessXADeh92Brb5WRj/o
	Y1zOjYfskzPGLR2uYomfySh9FHRwFo7F4/0K+GOEy304wEEmaDaH5ORSGjy4D5X4iFCxMjDDccA
	E0BPmHFzkuOMHFVtefmyezl7ykPoFCgwKMtbQIqtiBEnPlKPgTOJlM/zRnChv7F0DRSHipDK+TH
	pUFaK/u/gRoYd3Lj3DyYZlqskXhsLU2UwkEJTYz/GG2E+7G+UE0zs5wrx05u0hqyE6JOW0cGCu8
	CBfMKfG+nm8bJrEya6VF2heUafG0BityLQq6sZgHHn8kliMiaV8Vo5ETH8rt8WWTNC+HDz9kpXL
	MU0NN+B7ZJmfQl4VzZZZ/yPFfKCWY7oDuNOKGYjjnA9m2fpgLI/vaNK/cbJXTsDW1KdqYOKfUWn
	jZ1ZxEU1erI1tzLYTDuYDyOHdwrccK
X-Received: by 2002:a17:902:fda4:b0:2c9:df1b:e948 with SMTP id d9443c01a7336-2d37d539ed2mr95986105ad.4.1786642792723;
        Thu, 13 Aug 2026 10:39:52 -0700 (PDT)
X-Received: by 2002:a17:902:fda4:b0:2c9:df1b:e948 with SMTP id d9443c01a7336-2d37d539ed2mr95985545ad.4.1786642792300;
        Thu, 13 Aug 2026 10:39:52 -0700 (PDT)
Received: from hu-ramess-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebf732166sm16226182eec.18.2026.08.13.10.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 10:39:51 -0700 (PDT)
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Date: Thu, 13 Aug 2026 23:09:20 +0530
Subject: [PATCH] wifi: ath12k: fix DMA unwind for ext MSDU descriptor retry
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-ext-msdu-fix-v1-1-c5e80ccd061a@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAEcBfmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDC0Nj3dSKEt3c4pRS3bTMCl2D1GSzJONU8+Rki2QloJaColSgMNi46Nj
 aWgBQT3XBXgAAAA==
X-Change-ID: 20260813-ext-msdu-fix-0ec6b3e7cc8c
To: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        P Praneesh <praneesh.p@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786642789; l=2381;
 i=rameshkumar.sundaram@oss.qualcomm.com; s=20250120;
 h=from:subject:message-id; bh=xLF00iTls/RAYDJtyGsB8K+5w9HGYHEA2gaF0Z64x94=;
 b=vZigJ8jkaHcN14L0GFihC0RjISUC1ncumALNfutBXs/Lw6kwxIzozUpCKghha3M2e64KuHWqh
 3J6MHUr37tODbU+ZKl/4ROqC96b+KbsqQxJT1rK+uOZbC635sb7INv+
X-Developer-Key: i=rameshkumar.sundaram@oss.qualcomm.com; a=ed25519;
 pk=CbWiiM4JikGBEWI7HtrEEE/Hwkk7TTcob0SwaFdAwKo=
X-Authority-Analysis: v=2.4 cv=FeMHAp+6 c=1 sm=1 tr=0 ts=6a7e0169 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=wbETQ5BLc3zoOrHjYAIA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: ehoA1jCbUs9BU-tYGb-JB5vGEglvX4pc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDEyNyBTYWx0ZWRfXwIZ7NQkkG4MH
 jy/juNLULfy/rOzGFDMiexRTIxY4ypr9Gl3EVqEfuPzuJjAw7Fr/x92jZ1j1mXdMU/mnQ7ORRNe
 v1+F0HS5dfjtWnh5bsFg9vpT16IhJFVTb6z8pwUG6ft34eOsoF7UrSXFvmdIU8bLq44NYXvR94g
 qq3qrcxZbLV3wneZBs/ctwoXv18zW89kplXpVjMkAmYDuPBHtLixmghG2VUk+QlhSblcyblBZdm
 sf4ITY/xqzPRHGOpQ3zuGzy8MZNZjPMEVOs/e/AcD808iquZvdA0xGufaGU0VafNjN7v/5Mlg3L
 a9xQo1mXcVuoadGtEJ0eDaYmMsD9iL3PRSZ4R2FX93L4oIher8dgyCDpdnCU5LdSOjzKX0J1WmQ
 m8/dP4NNEL+XIY9gURaJscjP4EvUrQ3UsWbky9g8p4rUixtjX+UGLVKQVwSZmzmL9z4daGaCYDr
 rRm/JyXGPBu1COZOVWw==
X-Proofpoint-ORIG-GUID: ehoA1jCbUs9BU-tYGb-JB5vGEglvX4pc
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDEyNyBTYWx0ZWRfX42h13tjtHDa7
 8t6hIJJMTH7F0MFMCZYXX3VkLygKZJ8sh2PQ6JxFZqFUHyhMUMtU9k3O1JJPFQe1z2BsNKfXJhX
 RaGB0TW2d+pMPJ8HB/zHz4DXP/iyGDo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608130127

ath12k_wifi7_dp_tx() maps the original MSDU into ti.paddr and
stores the address in skb_cb->paddr. When an extended MSDU descriptor
is used, the function later maps the ext descriptor and overwrites
ti.paddr and ti.data_len with the ext-desc DMA address and length.

If TCL ring allocation then fails, the error path first unmaps the
ext-desc DMA address from skb_cb->paddr_ext_desc. It then falls through
to fail_unmap_dma, which uses ti.paddr/ti.data_len for the original
MSDU unmap. At that point ti.paddr still refers to the ext-desc
mapping, so the ext descriptor is unmapped twice and the original MSDU
mapping is left mapped.

Fix the original MSDU unwind to use skb_cb->paddr and skb->len instead
of ti.paddr/ti.data_len. The ti fields cannot be used after the ext
descriptor is mapped because they are intentionally reused for the
buffer submitted to TCL. Also clear skb_cb->paddr_ext_desc after the
ext-desc unmap so a TCL ring retry cannot observe stale ext-desc DMA
state from the previous attempt.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Fixes: 37a068fc9dc4 ("wifi: ath12k: Handle error cases during extended skb allocation")
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 587d58eeccfa..0dcb566fd182 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -449,15 +449,17 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 	return 0;
 
 fail_unmap_dma_ext:
-	if (skb_cb->paddr_ext_desc)
+	if (skb_cb->paddr_ext_desc) {
 		dma_unmap_single(dp->dev, skb_cb->paddr_ext_desc,
 				 skb_ext_desc->len,
 				 DMA_TO_DEVICE);
+		skb_cb->paddr_ext_desc = 0;
+	}
 fail_free_ext_skb:
 	kfree_skb(skb_ext_desc);
 
 fail_unmap_dma:
-	dma_unmap_single(dp->dev, ti.paddr, ti.data_len, DMA_TO_DEVICE);
+	dma_unmap_single(dp->dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
 
 fail_remove_tx_buf:
 	ath12k_dp_tx_release_txbuf(dp, tx_desc, pool_id);

---
base-commit: e07447e654476262558bee570f4cf456e2b32565
change-id: 20260813-ext-msdu-fix-0ec6b3e7cc8c

