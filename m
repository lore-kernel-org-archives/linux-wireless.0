Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFF33B42FA
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120976; cv=none; b=UgtwywyT0S8ez+vqQP5DbJTlSvBUw9m1VCrOCqL4X1kp3lq9CDpI3JaIpFeeDbbxJWImGrnlJy7uGbx6l85wN0kvjt4NE9vufDSFz+Cr9dnV8ZPyMX5TyZr4dIWurUScghxzWUOXA+I8BEjtTkuFTc5EuMlVIQifrb5YCcRaWJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120976; c=relaxed/simple;
	bh=5GtUpasBb7+e1V5vQfs1cJLRArknloYK0iYT1nRYXHs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DLbc2dVcnPAjceC/eFiSQfQW7A/Di0ys1D+Op+VHAkJrlsyUwa9p4KtVK/XaVraUJsLsWFt8v+ZpfvaWx2Jf64ao6O6xXdefbYsh8tyDTSBtedqfyuYCr0ALBP45zrp7pR3VvNkE8gIXoWRSG5c0zWlKMi3LJT24NaoRvvwY9Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AHS9v6IB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TM9hVniX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AHS9v6IB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TM9hVniX"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69G2ZusO405956
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UYyU8dza59LzeIk7p98sajZ/7kGqJMFs9Tw/nO1ZWKU=; b=AHS9v6IB3IaQ0++Y
	4FgCfLf00lSxGcC3jhJHfnIaW77kMAPBb7tM9qAl/JCfX8JGCH3tVg5Ojl+OrAVZ
	5ZVzXaWh9xv7Yv2rqc9hOiGH6tta/9D16gluQM7W4aLS8Z4NcttjSxljaEny4Q4P
	YmJ7h3zFkU80BJuB7jB3T7xFhz7sZQW+kNJKEQnrhuFN2QxfEvuZ5bJJgKtZGn1v
	OGhRibPRXQBYF2O8UzNjlBlqsgZoaeRPzj/vJfaDjjOElFLAMqgBRycUr1W/Oqmu
	RLvZS08WKxEmxADSf6H0BHoMz6QvEqdNBQQ+8iu+dUbXwk/fkp03HYUPHj+GDz5Z
	PUfiJg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb3sa1s12-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:54 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35c5aef2a74so6885152eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792120974; x=1792725774; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UYyU8dza59LzeIk7p98sajZ/7kGqJMFs9Tw/nO1ZWKU=;
        b=TM9hVniX/FJjrUjZOk7cIgwkXgur9kVHo2uBvt0BXalx1DXBjhVbqizlzB4JnnsG2q
         lot70uh7v7oBnDoIGD2iBnBXqWUQhOfS/ovbzq8Z4AZLPO45y/d72usPJ5nGS5wBHkqZ
         RRPshdLi9uKTTdCJ8YEJVGBwFCAbm5Brlvgg+9xdRH0+7XvoX0hoVRx5OqzH2dIBrL4W
         4TcldlmA8BN7JtGua6i+LdJWNVvkoePN+m+IrIi9mT2LFqBwtR08VfV1yY609MQfMImK
         jJwvSHOsE+GXa8SFKapuNIz7pe5u55G1Zf48xXZdBi67oBPunHtZPWiaAZllboquN59V
         5/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120974; x=1792725774;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UYyU8dza59LzeIk7p98sajZ/7kGqJMFs9Tw/nO1ZWKU=;
        b=rT24wj81/JPSnhe/DVMVJC3s9YBExFnvaIkp1zZntM3/fL73UR04UffG6tWQOJlhb5
         7/jW5n6BRkWVd9tR2dVt8jjUTW5/2726waqOVeI0Fhmt6hl4yG2Tp2f9GnFnnlNpznXg
         gE5hDctw/ykjLCmr98AHTSvDJVr5MuJh/gsf7+a8v/oWbMx0/suuQw4YNNWq57uoLdHu
         +hEcPMeYgQFR8HZwysvuj2dnZAXLMcEbk+S9bYnGcSch4JKd0FV3yfPskp09upLwVS3k
         7GG6KA3tE6BgqEJZGCBhuY+Uhno5jgLMgv3GKI2dGQQKaRlm6CxYjbg/1ZoOeU/yA4wH
         Wz6w==
X-Gm-Message-State: AFq9FYKfoos01jNZ5C+iimqI/0muUsVlDl3Lcg15Bf4qcecQSt4DpVlU
	E5OBXH/0he/qisfGEQ9xPKk60m9c16UFoJEHpYWPmTFuS6Ojl/aSd1Ur1u3GR3C9CoT9EIF6mDQ
	jHDkUilawOJjfQ+TUNbeVSz6bSBmDGyTvK6gxg8cTCFVxlspLPejGAqfJeYwlLKs1RvBWCA==
X-Gm-Gg: AYBFou304tfboITM+6ASvebgcjoaTCEp+4GDaddFMoo78ImFuPU/bXaGXCiw+E6pzS+
	yiotkqE6gEyQK8wnX8S27nIpV0IM4EvPnu2ruYn/ZA7kWBL6DbZwtSJNPIU8FG3R2eIHB4u5Bgg
	cfPYn8ZxyjhfSgMO/fxTCiGvcGelACF1hs/uLb1/7mzHeO5rIx6f1qe1g0R/GZpw+aFtgmB84Qh
	UxXNK/dkMxLktf2HnJtlR7tXDSX+JgJ4DLgFuGv42G3AOieOTkBkUqtZvgppDH9L3Ya1pwjAutk
	coQ+2DKmynOL4MRVYUKFSdwklJYOPVs4H93aEPfY3LPUsD7ADn7FQHbw+gkOyU6jJWvdaJQGbZp
	32TQBawtdTgfs/ddBgILll+c+Vhw+C8EOTUXRZleLh3svpdn/B+MTdLaZqOd8xiCluFG/DqU8um
	kZzZDbr8x537toODBW2+NgSw==
X-Received: by 2002:a05:693c:821a:b0:35c:813a:1c81 with SMTP id 5a478bee46e88-35c813a23b6mr14072757eec.18.1792120973542;
        Thu, 15 Oct 2026 20:22:53 -0700 (PDT)
X-Received: by 2002:a05:693c:821a:b0:35c:813a:1c81 with SMTP id 5a478bee46e88-35c813a23b6mr14072720eec.18.1792120972992;
        Thu, 15 Oct 2026 20:22:52 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819be413sm2256698eec.13.2026.10.15.20.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:22:52 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 08:51:51 +0530
Subject: [PATCH ath-next v2 14/17] wifi: ath12k: store and use MSI data per
 CE and DP interrupt group for QCN6432
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mpp-bringup-v2-14-f510c33bfcf5@oss.qualcomm.com>
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
In-Reply-To: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX6PsvlKNfUQtD
 uJ1+BCLRYFwggY5IZ/HARTqjVuA/dpOp3KXKTjtUopiwtJu0hpIIDMDWNMruc49Gwmw+BUfhYLl
 U1LWJkIhDAxu1PkNlJAInSIVwzXZlOY=
X-Proofpoint-ORIG-GUID: RYqILd9KZkaK4pDcdU5B6DsPUrfiBi3Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX49x8exsqA4tE
 3BrUrIStZ17kFv3iAW+UAvzZo4f0OQXXzVlyilb0GQwrjmiyfx1ALcYMlVxZeYXI6gohjeeT6Nx
 zpKLG4Un+tDdwDQiSUjZ7Lz+6MY78ZRbV9MbFMn48S2ctTt3i8z+VabJU+apT9zzF9kdErbbA0e
 qH5Jxv/aesI3Ls+NhXZ1/2WZDZ7pFtgkSPfDtUYu0fH5U5Kg1Z3HfplSpoiowa2+ryrQg3gCtd+
 /TcYXITcoYVE+6EjUFM4VBaW0tOQ30vIs0AOMbsDtr+IdCo4nqhQkqHQJOcgs3bdWGX057CnCmH
 FfDRPoGgGd/AZlzHG3NB0zUwGzNrEr7yqmwXYAWK6WoKzRMedBmbc5TTTWioAv02lGmns/5LUSe
 wuMxUtJ/ioE0S0qjjlmZftWaYEqoYUWB5iSsNV7K7mFVZ6OsOxbxmiqCMJkrt+VF/8QF/ngd8eG
 mW4T+0WRAGA1YsCuzOA==
X-Proofpoint-GUID: RYqILd9KZkaK4pDcdU5B6DsPUrfiBi3Q
X-Authority-Analysis: v=2.4 cv=AN0XGc5Z c=1 sm=1 tr=0 ts=6ad1988e cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=JOiqKhmsGJDeROXOrEsA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160012

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
index 13097cdf2794..b6d306fd3b99 100644
--- a/drivers/net/wireless/ath/ath12k/pcic.c
+++ b/drivers/net/wireless/ath/ath12k/pcic.c
@@ -275,6 +275,7 @@ static int ath12k_pcic_ext_irq_config(struct ath12k_base *ab,
 			}
 
 			ab->irq_num[irq_idx] = desc->irq;
+			ab->msi.dp_msi_data[i] = desc->msg.data;
 			disable_irq_nosync(ab->irq_num[irq_idx]);
 		}
 
@@ -318,6 +319,7 @@ static int ath12k_pcic_ce_irq_config(struct ath12k_base *ab,
 		}
 
 		ab->irq_num[irq_idx] = desc->irq;
+		ab->msi.ce_msi_data[i] = desc->msg.data;
 		ath12k_pcic_ce_irq_disable(ab, i);
 		vec_idx = (vec_idx + 1) % num_msi;
 

-- 
2.34.1

