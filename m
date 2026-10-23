Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738936;
	b=mRv9btd0QVItnl59JCYMHb0cbQD9gR95zWDs9Rn9oomttOmBeJM/G34jmyWs8czzmQOr
	 LNzEd9snF84Uh5GFxbY7V3nns60/UArLfhZJ+QDfd2RhhQK4IkK0aYOKMUTJHt0iLc7e6
	 pKdyn5Hz1QZuhBSmBVD/1Pt4HEDFysQZB7ScHB4TYZDNldLloWa2zM3dFCoyVE784VmTZ
	 T2McOUzIJYjozTGiabfHHCUpX/1mb8SAx3UqOZ54TGsoZB/YZ7y0RDVBlUrISqbySc8+W
	 HiBES4CRSfeFwvCK6cmLagYJAwhrQdHkvItHbVCC9KrksReN2/UIrQhVEyuYoR3JWtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738936;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=UYyU8dza59LzeIk7p98sajZ/7kGqJMFs9Tw/nO1ZWKU=;
	b=ESoXe6aWoM5+lYX38psZhwLk8Qz8TK0KzDpbhuYDVEEZSJ+MCkIYaZbgKK5Z1F6JeGwL
	 JXKnZ8aL0Oxi4IB3Kd5gY0FNLCwaa+M3CtMN9xOAuKnJ87DUVqWBu4QHxe1IZq56r5K5v
	 c2sTWzp6jNC/jBbSNTv4QWoSeLfIX65TGFLAaGoGqVKvNxswIZ2x3sq4N9O4RcnuQ5+uk
	 XMkWolWXqdN9af0XQkiXzahm/JKZ0Gn4B0MA1BFM9g3oArAzC+1yiIyEzoAQi7aIK/Mp5
	 JgecqbqCwnsRcE6nPX7Kmo2iEU2BN/lxTDHKjafhEqKZIFQpZEizdwaZar7+OmTZHHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oKk0c5K9;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="W/PKEIU1";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4389E606AC92
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4389E606AC92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oKk0c5K9;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=W/PKEIU1
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1FmSY4008255
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UYyU8dza59LzeIk7p98sajZ/7kGqJMFs9Tw/nO1ZWKU=; b=oKk0c5K9CTS6MWcB
	uGpmgNrpK2ZpAp8fPf0KP0nt/WdcO8gBvQ+jdVWHV3aRAKiRDqJedfa30en8I4tZ
	VPx8KrSw4ywMU1rxLf2EGmHA7KzhTgCwGO9ens/U96SDXq7rz/SC+xJ9ewhHBac2
	YtGR2OfA8stWhXFzKG197MXVZhb8zCU1Bzr7QRpz5bdf6wRaeSpRC42A9lDZrKTc
	dz7926Y2pTTbchPOax79XU3QvGfJtef+As0fgZjUExC88RVGt0tsgFQDOb5wPXId
	BN8SAMDRcx792542lgG0dDjFS+MaCcooUKyI/cX9ocSxMEHaIpTI32Nin22VKclA
	DWKgmQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfsmasv1h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:15 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e9501034c4so10170105ad.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792738935; x=1793343735; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UYyU8dza59LzeIk7p98sajZ/7kGqJMFs9Tw/nO1ZWKU=;
        b=W/PKEIU1LedZt3ea+MJbuG6AcUZtEfDP3sD3o9uoNZ32PQrUTQuzw8Ea4fPYAvI7rU
         4R3TPGhkEbNvepHeC8JkG+/lnj2z27cIv/CN0d2KZMP32ySnobfxIDPtyyIW7OXEQJMm
         tITxgvX41/s9nnGVVZR67iYCTbkv5c4CQLKoM7OCoI/mCiYn4A01Yu9NR22n4td6u26h
         PJLWP186FWuYAqj2XWUWt9CFQydwCh2ADI3UngZeAQwJBhnlE41MoV4bosDmu8i0vEHj
         ahtDH3FbcSlfa+OoWLHwqFChbw4JJ9kymJ2GAoMRslSp7z1Vi0IPwrnikDakzrFRzY4k
         rM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738935; x=1793343735;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UYyU8dza59LzeIk7p98sajZ/7kGqJMFs9Tw/nO1ZWKU=;
        b=bLZGPQqpLcniaT/AaD2orz5l2/r7jeHyBfBLryXqRoib9BIM2XBBPXCa7pmXwQC3GD
         VJjTrC+zbM+8gz5gYx3bvHM+tBnJiH9cIVwv+wp7dSNOJg6DIPSM7GVNJLkkTJSyzVu7
         dY5id+82nsOgA0wUNH4ik3N19FB9Dvo2sAzoet+O+Cd4bcysBs0+Y3OLvN8cdizfTt6q
         QVvRcRPDfa0OXN2766UpvmKrBAMf1Br6g2YpQ/7dNHlUWEkEa1zIFbeTInAyRxkYPCcB
         3KcxAIBxVD8e7Kwz/qIeuzUP0VcUcHliNqCXYDe/8dNPksJid0D9vZ5O0jpB/OJCVncH
         ltcw==
X-Gm-Message-State: AFq9FYJ/wvBSwPhGC8phsqm6E/F2rgC9QfxlP4BOGG04OB3169Uiq27J
	EjPlBT04TVffuh2o6/8ncdOh75jE6mntgO83pXYJOz3MR0XZV6kAd3X7U3jCEcys5bk8Z4Aunh3
	8nfsYjexaEaCv9WXcx4BDZFSFA8xvEpSDfCwTcaVIatcFhe3voKOyavrVdX1XAIOtBNhsvA==
X-Gm-Gg: AYBFou2pxWjEPjmx+AB+JfS2GwvxhepmisOhoP8h32OZCVgfmLEujUfhhCOBYl0b6Mb
	6xXXWT+d0bKrTSxu/vKoIf/8SzbfVdzFisjQi96OU3Izwn74Tj11YDJs0LTNg6MvQDGkwTZkbxc
	zL4QUBlO47PyfKbvBpmYEID50Y+zzjm/OBwyv0tT3BbwvVCmpzMHaI/0WdBUNEPW8C2b+0ZAbjH
	/BfD457rs1J9LMlRLsqfNaTkJzu71d/jVQsFOsKOqlWgeHCVsG4K/HVstZ0uns6SaHRLR0kK4gm
	JWW4bu/IOqNV8571KRmI1IRRGFxRghTMlmSa6Zce7Pti5DJvr+hME9kXpjRogGldNHECquKb7iv
	8y5q5I+zdwgy7FOjEargTkGVbXRNGfzcF+ZoOH2C3wJIAQhwnbY7SO0xcaoDxuJgvUG5uDr+MND
	3uEWc9q4ZRSpe2pPfafPIDoQ==
X-Received: by 2002:a17:902:f690:b0:2e8:3cab:3af1 with SMTP id d9443c01a7336-2ea7d0e1aa8mr12883665ad.23.1792738934497;
        Fri, 23 Oct 2026 00:02:14 -0700 (PDT)
X-Received: by 2002:a17:902:f690:b0:2e8:3cab:3af1 with SMTP id d9443c01a7336-2ea7d0e1aa8mr12883465ad.23.1792738934047;
        Fri, 23 Oct 2026 00:02:14 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8a6dcdsm399751a12.18.2026.10.23.00.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:02:13 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 12:31:17 +0530
Subject: [PATCH ath-next v3 14/17] wifi: ath12k: store and use MSI data per
 CE and DP interrupt group for QCN6432
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
Message-Id: <20261023-mpp-bringup-v3-14-19f3fcbf7b5f@oss.qualcomm.com>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
In-Reply-To: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=V7LoQuni c=1 sm=1 tr=0 ts=6adb0677 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=JOiqKhmsGJDeROXOrEsA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfXzZkePMWbKkfx
 RTOd2jDLNflOrM4CS37v32U74en1cI2cnyY9aKrdXKCoaaxDUIoY+nKEG4bz4MhgIOYf6ZpwSQM
 pgEiMUHRLvLFb0kgnv2wCXUfF6W1AnI=
X-Proofpoint-GUID: Y_oi5zSPgjlxReatMNNmOD0RqMf3Pi4f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfXwnKWWEn0AdWu
 2frrFkGOCCjVnEEAl/qIo55n/GxkrgoZw6EA0dO5ltksfVKaM0mT8wVHsYBhgN1iM9zC6xam/P3
 Y50wR2zHKicTUA21cyz4cbsU5yJ/ygTTND/QpiasKxPBBdqAj+U1pjz1iuodcD4K4Wfc/wnbxYr
 FUJPJTUVEjPyzaX6xZpsNWZmBfNZUU+BdUjboDkOAKuzoqicGKHxfhIPiGe/+tw4+ib42uIhOZU
 Dn6DqqDkYwgjVDTBm5TM7yKx7jKa7mFShW27X1a6v+qrFxaRg/SsaptmLfxBkqCAWKUf++MMJp+
 EvQyZXIBBAnBjncORpxozPLZloAYSdFl1KUhNNV+GuYUlFmJQM17x7CkEsSFr/a2McNP8R4QLrv
 KAjY6z9d+tNklqt2rllZrjFi3ElWePlOGoM8sPb2U9mo5KIrlQG8GqJnPKv72a3gv8m8LBdSvhd
 hsXaHkSb7021MCsQeww==
X-Proofpoint-ORIG-GUID: Y_oi5zSPgjlxReatMNNmOD0RqMf3Pi4f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230027

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

