Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8C949B209
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455119; cv=none; b=JaxwLfNAyMvjySCOlGQAP+kIykrjJK10bY8xoSzvybmyK8TemDZAN6FhZWHi2ftfzycXlcK9aHRf+YUWVvcCYKUkP/kE/EkOWVsuFjnbSOsleN7sZhz0gts7VreEGSHgdUi9DIiLHwWtC1Viabyhs+iMonhL1FMSFjh9TuscmJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455119; c=relaxed/simple;
	bh=pAZVsA+P+j0LnyQWbBrAEL0IyJYTrbyYbkG4AZMi2NA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iyMFdd2VBxVvcR633Uq2rsxNAkZmgWgHdEGC5OeuntBRTxHm1es9PJQ8wUF1MUiIBewLxZ8exdtn/8AgkNUVnn778AqfPpEufEs8t/nvJhKfmTkopBjkbGB1/Dg6ye6c1sMGOnyu1GKdel5douCgyWN7O/KkeoxJs6khcRnCzLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VqqNyFXN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DSi6tBkG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VqqNyFXN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DSi6tBkG"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KN0K1845879
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:25:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aMm5VSqiHcH9DwnpPnRIkeDas/kbOfg9nUPZTTqULnA=; b=VqqNyFXN1L7IKuJ2
	z8zc5sue5Gos/U6fGcNuwIfIBOIDAyNnNUcJdxHkr4UcYWFzXSeBbQR8EOoKCtQm
	G25jQviSLzuHCHkNvfHl04IxFnzxsvSMP18zDwt9hXX7UJ6UsJz0XxIham7PnOte
	awyTOwGc5V8p6c1sBHcUvZB+wUIemNRbu6QuKLQkFKCyoYzTIm3qhROn4rLKQXbF
	YGbVDqnlpEc8PLczRpWOgsUmXt4FIh9t9xzlxa0bMaH/A/Kvx5EuRse3bXJ/UgOF
	XXD1qxCW3WQ+Kw2Q7zICxx4fkY14E0ifXJJxVrz6i5CLO8D3khnCyRKwBU8x2bQS
	furcyg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe3jhpw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:25:17 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e60bb65626so6988725ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 03:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791455116; x=1792059916; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aMm5VSqiHcH9DwnpPnRIkeDas/kbOfg9nUPZTTqULnA=;
        b=DSi6tBkGPvzUoi2ACVJN6m3J09vnCAYUdfcX+DFqNo7hsZCrYDKHt3lpSEERUShTJU
         /KKsxc3DblcjIX6A/YXur3nW1TkWK5yDj5PJQDkxseOm4/OFTYOhjMI/ONWgi4Z2HiYv
         iZi+BIPBRLwK4ma4aPoCBr5m4FMRA5Lx9Vnqxs7Ns5fiMIOdEno8jRyrUf6ur/cldyGc
         0O8nl3q6+L0Vi/lIbYNEwGjHB+YI4Au2cP1NKFc5IMkucg1hbc6z0yJSGxcbuaXIZIgC
         4jM1GyTz1C1aBCxh/FVa+viwl5iecsXfUJiwTTMXGz2upI/saSopVqhhkdNhg1W0Z/ho
         4dDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455116; x=1792059916;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aMm5VSqiHcH9DwnpPnRIkeDas/kbOfg9nUPZTTqULnA=;
        b=UfQ4L19ObQRNgf7/KEGoyvKJctiuOR567jeUMcQPtcKtbwH+Lrj/kfLCkxjjmsEncS
         AtfkwNl9cypHCLQbKaJb9W9uIoS+InCWs+7Huerum+fPVJlyK/wGzsMRSzVEop3Vrka1
         eRebDYmMxr9mYgpzhqUcIlDNX3fT1hnFu8bItN+93vMo5IFRXD9fkHQJPzDs6KyXNR7O
         gu2oaL5E/cmrCYexwYjGo1Qdi1D8sR/rPquWIo9cFr5b0M8zRjm8uDeyIj0F/bNYkzV1
         ErpdVbsasnNH3U9zyisK7rxjQaUcMi81CsWl3JHmkXV4GDn22DIYvGKvfAEJKBsSXsfh
         u+0A==
X-Gm-Message-State: AFq9FYKv2L7kdeFBkTuBgzuZ52t9pXAYgHmqi1J+6Nmui6D52G6oIW+g
	d+RmWT7K9apIofa8bt4ORAgBUFq0WN69JQJ857+yH5vUyrA65YW0QFMKwMgCPmvA5/egQOsPIMM
	IPwgZSt/5vWvT/+Q8ETJX4l1NiW5N/tIGuWej4S4bhIA94EmRlZYvzJsfevAcrpKWkjDjchqoH/
	pWyg==
X-Gm-Gg: AYBFou0uroLoTD0LMePR51taNcawJEWi88hMef0x4Egf+RY2T2+IwtT8dCZpjDWjv3h
	OewoLpwAD2a7hSrjHXpQHUdUHyc1e5OffAOLgsPBlk+2riZqf1RuMrGNDholj1Nr5Va6ze0yncC
	IUSBjm5n1yLLSdPjFCUDL8/liHGCFsx+uhoaaNqh/8+MblpP646U5G+yXrWeqGXoMGaoJQCp484
	/F9+TlY53CH5CGMMR9MghlQzdFsbKvoTERZyZe2fG+pW+l2NbrX8jhZ1OfBb2Llv0+BOTgwkMDr
	lX1xuBs1Zd5nhYTyxXYZavyXOz/kGAgYrCpFd+N2te1s1Sptzuy0RbVcwrLdo2+bGn6H+ebTJnH
	uI1nISyZ4Qee/o6kuEbpErpVsyJ/6VFPP56j40NpJtJIVB3n9ANVQHDQXsspHMHEid5hRI4U8J9
	EAsdhDuZ8u3jDLZqLFWoSdpA==
X-Received: by 2002:a17:902:ef01:b0:2e6:e9a:eb48 with SMTP id d9443c01a7336-2e7ffe98eabmr15026085ad.41.1791455116344;
        Thu, 08 Oct 2026 03:25:16 -0700 (PDT)
X-Received: by 2002:a17:902:ef01:b0:2e6:e9a:eb48 with SMTP id d9443c01a7336-2e7ffe98eabmr15025765ad.41.1791455115576;
        Thu, 08 Oct 2026 03:25:15 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe39csm22081655ad.16.2026.10.08.03.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:25:14 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:54:10 +0530
Subject: [PATCH ath-next 14/17] wifi: ath12k: store and use MSI data per CE
 and DP interrupt group for QCN6432
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-mpp_bringup-v1-14-2c5797b5e4ac@oss.qualcomm.com>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
In-Reply-To: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX5/l9rEZJSubV
 dAzDbu1Y6rKGmiR0X6mKT9OXTagV8vQLat+aP6zYJQUwhg3XHAtr2sQ2X119BrnB0OkuoZfRtxQ
 +iHvfbVcYvmPkBcjeAgEImevDGWtS8w=
X-Proofpoint-ORIG-GUID: G3KTui_iQ0QGaZ__ENYi5XiOIV0zqpKQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfXwvAR6OgZAh2J
 FRIZiLBV3PvDbTxQ/NCLE3c6BZ4QSqT4TPsV7AyCMB1suZoRmnrDs2pvaflUTFMocdknIr4NZuj
 8zWAdVP+iFLr2mcmiZ/xaxVayGhnO33XF1RQciEpui7BR+rtR3Pg/UcdVe8Oful7i9Kydd3r5rE
 27EJzJRq8Q2FLC5FPr9ASr3mtezERBjl/XK4BjWd2M6YUJogxBUoA4aq90VV4MmR0lZfGiYePWt
 a5d/25MXsyowsbMi8OhkTDMBlanq58W/4PRt1ef5rqkiOeyednGNqYHspQ+/ykG0T+0eyUFJAL+
 ZpGB0IDP+p5Cm9zJ1bt6ozajYNEgWmaGCnamhyM7LGoyjM8GQlbGL5riHSsZjcGnCOAwMxm8Oo4
 CzA2WJbFejSafYbhlTn5JR0KlGFqxhCvsGuRBmJSKdgecCmAxXxm78MRyYhnMep69/LhVo/9n9h
 IzhfWkmd2Qta6ywRcag==
X-Authority-Analysis: v=2.4 cv=IIuXmQvG c=1 sm=1 tr=0 ts=6ac76f8d cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=JOiqKhmsGJDeROXOrEsA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: G3KTui_iQ0QGaZ__ENYi5XiOIV0zqpKQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080041

From: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>

Store MSI data values for each interrupt vector during configuration
and use them for ring setup on hybrid devices. Hybrid devices require
explicit MSI data values rather than calculated offsets.

Add ce_msi_data and dp_msi_data arrays to store values captured from
MSI descriptors. Use stored values for ring configuration on QCN6432,
ensuring hardware uses exact platform MSI allocated values.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
Co-developed-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/ce.c   | 7 ++++++-
 drivers/net/wireless/ath/ath12k/core.h | 2 ++
 drivers/net/wireless/ath/ath12k/dp.c   | 9 +++++++--
 drivers/net/wireless/ath/ath12k/pcic.c | 2 ++
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ce.c b/drivers/net/wireless/ath/ath12k/ce.c
index c99e915e3885..cc8ed8451a2f 100644
--- a/drivers/net/wireless/ath/ath12k/ce.c
+++ b/drivers/net/wireless/ath/ath12k/ce.c
@@ -270,7 +270,12 @@ static void ath12k_ce_srng_msi_ring_params_setup(struct ath12k_base *ab, u32 ce_
 
 	ring_params->msi_addr = addr_lo;
 	ring_params->msi_addr |= (dma_addr_t)(((u64)addr_hi) << 32);
-	ring_params->msi_data = (msi_data_idx % msi_data_count) + msi_data_start;
+
+	if (ab->hw_params->hybrid_bus_type)
+		ring_params->msi_data = ab->msi.ce_msi_data[ce_id];
+	else
+		ring_params->msi_data = (msi_data_idx % msi_data_count) + msi_data_start;
+
 	ring_params->flags |= HAL_SRNG_FLAGS_MSI_INTR;
 }
 
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index bbbde9f05ea9..575139555dd7 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -1172,6 +1172,8 @@ struct ath12k_base {
 		u32 ep_base_data;
 		u32 addr_lo;
 		u32 addr_hi;
+		u32 ce_msi_data[CE_COUNT_MAX];
+		u32 dp_msi_data[ATH12K_EXT_IRQ_GRP_NUM_MAX];
 	} msi;
 
 	/* must be last */
diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 6cf254b2d2a7..0f0800388935 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -225,8 +225,13 @@ static void ath12k_dp_srng_msi_setup(struct ath12k_base *ab,
 
 	ring_params->msi_addr = addr_lo;
 	ring_params->msi_addr |= (dma_addr_t)(((u64)addr_hi) << 32);
-	ring_params->msi_data = (msi_group_number % msi_data_count)
-		+ msi_data_start;
+
+	if (ab->hw_params->hybrid_bus_type)
+		ring_params->msi_data = ab->msi.dp_msi_data[msi_group_number];
+	else
+		ring_params->msi_data = (msi_group_number % msi_data_count)
+			+ msi_data_start;
+
 	ring_params->flags |= HAL_SRNG_FLAGS_MSI_INTR;
 }
 
diff --git a/drivers/net/wireless/ath/ath12k/pcic.c b/drivers/net/wireless/ath/ath12k/pcic.c
index 06178b4f20d1..9fa727115f8d 100644
--- a/drivers/net/wireless/ath/ath12k/pcic.c
+++ b/drivers/net/wireless/ath/ath12k/pcic.c
@@ -274,6 +274,7 @@ static int ath12k_pcic_ext_irq_config(struct ath12k_base *ab,
 			}
 
 			ab->irq_num[irq_idx] = desc->irq;
+			ab->msi.dp_msi_data[i] = desc->msg.data;
 			disable_irq_nosync(ab->irq_num[irq_idx]);
 		}
 
@@ -317,6 +318,7 @@ static int ath12k_pcic_ce_irq_config(struct ath12k_base *ab,
 		}
 
 		ab->irq_num[irq_idx] = desc->irq;
+		ab->msi.ce_msi_data[i] = desc->msg.data;
 		ath12k_pcic_ce_irq_disable(ab, i);
 		vec_idx = (vec_idx + 1) % num_msi;
 

-- 
2.34.1

