Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FFE36F8F2
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 11:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784631909; cv=none; b=dsmXHyRFx7K6ij+eOHl4GzeB8vIu0jioJEjVAfBDqPT3MVgBUubm7h5Ro+Y2WfMFdj7abuFM61Msa/WOHFOZb+anFPYezIDKZWa8cQxpoNpD4xq96Etu7hYJa2iVXffcB7RWuvRHxKsd87JhpT/I5yd3Kjheg+BqqUUDpxU3qLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784631909; c=relaxed/simple;
	bh=y9xSPLtqQJAu6TESSFZY59gvuQ7OqSXyTNtJCtBluVU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rdHhNBfpNQ2cYXwZU1Sc7dfVHFKHQFSWkFhzcyPHOnMnJbdeNkxvrg7NNwXc4/mLWi+p+P49LM+kQtqcVEIZnBeCtWWX4uuOTwoKUoO3ueV7Kgpg3DuhgXzk7llCcOvLtiUWQZDDX7WW1lbid4Oy4CUTFPKGszqv/ikgt+JHCZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=awukk4i0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LUSroZTf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="awukk4i0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LUSroZTf"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LARS3J1455582
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 11:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=OrmPyelbu4twgnEe/79SbA2Xgw5GVHqyb1V
	HCIYacxo=; b=awukk4i0QndzOY1MRK9KGcPqWUqvsNkPLRECHcU+JraWgx/9xDn
	dfYBpaTUI97nKyPkcsNGk9e5Ga9SHF2dbtQNMaOx8ai/m1FuAMlVkBOxxTBXY+Jt
	AQRxAjonh9Le63XmqeTmAeTs7I53/gOhGF1bd0/Q1m8i3CauU1wGIvtkCwm4AZPd
	5CvMBA63FocfLaCYI8bvS1R0YK+hcAI/hCTSyqByrnaJlswX7nn97SA0XDGwTM8z
	1xVNaus4CuRH9jCs5bUWrhZGeyFJBmFM47f8e7QhJ/kAveWtVQR2uq7zqkaHyBWJ
	wnfasEIT2es0SGtqOVEsPkrq+QAfC61hOvQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj1duhv6p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 11:05:07 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb5cc1e139bso2348644a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 04:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784631906; x=1785236706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OrmPyelbu4twgnEe/79SbA2Xgw5GVHqyb1VHCIYacxo=;
        b=LUSroZTfwq1Kr67oev7CGwb75ZcUTK4Z1N9nGTiIH3ptq5XZhqtX24IYNoATykMcSj
         r82bzcJyEw6PG9GdYJlBGLZDNy4vRrsjIJLBJFduchD6AIT8/FO80ZYl9/VAg19xvSyM
         8ekZ70RWOilWU3CW0n2omEdzWa3dcAaQYs2qPXlsIexvlQfsszaD00KIuWpHDrIBi0MF
         E0j55dBu7HQZKqzwnwFWGVDY0fJlHqcTAKVK7OVtaLvbQ48vg941sFCJbsyxjqX4xhQq
         +3ISZJbACG1jFXyl2SogjM+cioa0czpmo4L6zCl7ZRPdcIdHBjoQB15tJ6IhaN4wERtx
         jFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784631906; x=1785236706;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OrmPyelbu4twgnEe/79SbA2Xgw5GVHqyb1VHCIYacxo=;
        b=ZIRrjGtZBUMpUa9+kPB5dTig84Fs6thVxbzrY+6DrGIvh4eGdWqulWnH/LLeleCqNA
         ByvWiksMT5X3IMjMnDilvxfBBN0TgxyoTkmqJZri25pQyumnMod8qIb1f51QYh3w1BYz
         GeDwFz1JNxObTLCYf1q2Qe+T39giLrpeanmB8qv0Zk4breEUtdV+KjUD0uGHKAsv4bBi
         wPlSv5yZlD5Qzs8fg3MptbF1q8f0X+cN/TFHscYZ31k1I/2RtctMGARAVx6rbgHxHK8H
         O9elStLqpkNJMIRE43TIZ/PKIqDu6nT4SV/duNefoHEnd5+8chOy1I2JVlw+bp7f1Rp6
         G+PA==
X-Gm-Message-State: AOJu0YwxB77ExAo5D3kBvQYIZFwykpyZ4yNBPiI36vmjHY5NzF3ee3vy
	iyHQ07HCJt9I6k5BgvDqgjpTMSsUFW0HwjZeV/GT5fXMzjh9X6gD1SLZeV0KvUjBg6/V9vzXzjk
	sDBUkLH2ZKykWw2Yb1KK36TxAFyTYhACWIko6HnG6Hf910byRg8T99LO/ZFaPPk/tMWJN/pMOgV
	W4Lw==
X-Gm-Gg: AfdE7clNzzBTX0KeU39QgvowpncHaURy6bTG0D8mcVWBQ4z6MdLAy95d3db00+HkPjP
	ELy5inU8jpIRGpUZDJJfxIJRIOf9zM8I26UwRaCWJmSdMumtLvK3d505biYBu4uvpqbp/w4sSSy
	lotLL4Yt5iGDogWxB/HwMrKc1FLgRGhx06ty0ijDN6XM570BZjuvuxobWI0HNLCUHCQFFBirUTK
	8Xo+Rp+AeJafkhh0JqCCWWeL8unaXPqiCXnEZoQMV2Tr6NMy+SjmQAiB8AFCTjlFwjvpRnabkIF
	FEOWxU+jkpB+PkrRHSnCm3SkU/UkRhjPzz2IM05rjIXV7nPM85dfrw0Pi3xFBQ8bTXZn//AuBW1
	8B0XN66mB0hoApIfsG0l8fOvUceDvHowN0Oe6GGYle5mchezKXQkFeM7NHZBwj2hi1t9oR2DGpd
	ZrpvmUpf1iGhsq3IUNNjTBPFB8Vw7YTcq6
X-Received: by 2002:a05:6a20:158d:b0:3ba:f5c7:6bc3 with SMTP id adf61e73a8af0-3c3ad6777e5mr18827052637.10.1784631905990;
        Tue, 21 Jul 2026 04:05:05 -0700 (PDT)
X-Received: by 2002:a05:6a20:158d:b0:3ba:f5c7:6bc3 with SMTP id adf61e73a8af0-3c3ad6777e5mr18827016637.10.1784631905369;
        Tue, 21 Jul 2026 04:05:05 -0700 (PDT)
Received: from hu-pnandesh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429f9d444sm53595591eec.6.2026.07.21.04.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 04:05:04 -0700 (PDT)
From: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next] wifi: ath12k: Use different RX release ring sizes as per memory profiles
Date: Tue, 21 Jul 2026 16:34:59 +0530
Message-Id: <20260721110459.2203038-1-pavankumar.nandeshwar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ZSJaFptRD5pE20d0gVBc1oChAzoSAGc3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDExNyBTYWx0ZWRfX9957adShFs/y
 On57SpvP6mgLJowr5LYJ6PvkKwPXoH8/vwQcmQNOpZPQgzSZUhCXOpyBoLwx0K6l7lbFa9LjhPN
 S03WCDVkHQP7oHGK6ZigNKk9LyrHCA4keL8y2PI03jAJSpSdsDHLEaoAzuSkTRzAm2dTPs04fUc
 24HZCEKVWdPPXdwzmTD+Opv8dYkayU1/6Gx9RpiMvMlKku+8eKv42dLQAANhTXgJ9cjj5RMESx+
 j2Sj+dHiQnsyro3LbNwSepYxRMiI5eGfs+QsI9ePlm3UFyFw0EnDvlT0DuCGhSJNiiExJvBS5Ku
 5PoaWZWDDg6uNROTXOcq9Z2zlifqh/vkusAggz/G9SCakbc6zfjZ1WSP/QOmNHbnrrAkzB8ULCr
 PeKmKB14lhot5hGC6rjkstnNjM9wTefTuFQBvNAsGWf5PmRO77G0UIErwvPYMMSUjmaJw+QJzEf
 fkqshBYMV+wQQ7vUv8w==
X-Authority-Analysis: v=2.4 cv=I9JVgtgg c=1 sm=1 tr=0 ts=6a5f5263 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=F2ceSjyJtutaWC8X_kUA:9 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: ZSJaFptRD5pE20d0gVBc1oChAzoSAGc3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDExNyBTYWx0ZWRfXwcYwoi+Ivl45
 1wTCfHO9RK4WS/oDl+5pVzAk5PSbgnCsQwrsv2rTWXC4rcej7YDzftKcz4CluVLTaw8y62Xih8/
 x72uR3oPNo0qwx2hKLCEciooiKE9L0I=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_01,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 spamscore=0 clxscore=1011 suspectscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210117

Currently, the RX release ring size is hardcoded to 1024 entries via
DP_RX_RELEASE_RING_SIZE. This value was sufficient for older generations,
but is not adequate for Wi-Fi 7 scenarios with higher aggregation,
parallel processing, and increased likelihood of error bursts.

In Wi-Fi 7, a PPDU can carry up to 1024 MPDUs and each MPDU may contain
multiple MSDUs. In error scenarios such as REO out-of-order (OOR) events,
a large number of MSDUs can be pushed to the RX release ring in a short
duration. With multiple PPDUs being processed in parallel (e.g. multi-core
or MLO scenarios), this can lead to significant bursts of descriptors.

Field observations have shown frequent OOR conditions and back-pressure
issues with smaller ring sizes. Increasing the RX release ring size helps
absorb these bursts and avoids back-pressure in the RXDMA/REO pipeline.
Without sufficient ring capacity (e.g. 16K), back-pressure was observed
under stress conditions.

To address this, make the RX release ring size configurable per memory
profile by adding rx_release_ring_size to ath12k_dp_profile_params:

- Default memory profile: 16384 entries
- Low memory profile (512M): 8192 entries

The larger size in the default profile improves robustness under high
traffic and error conditions by reducing the probability of ring overflow
and pipeline stalls. The reduced size in the low memory profile balances
memory usage while still providing sufficient headroom compared to the
previous fixed value.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.c | 2 ++
 drivers/net/wireless/ath/ath12k/core.h | 1 +
 drivers/net/wireless/ath/ath12k/dp.c   | 2 +-
 drivers/net/wireless/ath/ath12k/dp.h   | 3 ++-
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index a9112760185f..6a361f63f145 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -52,6 +52,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
 			.rxdma_monitor_dst_ring_size = 8192,
 			.num_pool_tx_desc = 32768,
 			.rx_desc_count = 12288,
+			.rx_release_ring_size = 16384,
 		},
 	},
 [ATH12K_QMI_MEMORY_MODE_LOW_512_M] = {
@@ -65,6 +66,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
 			.rxdma_monitor_dst_ring_size = 512,
 			.num_pool_tx_desc = 16384,
 			.rx_desc_count = 6144,
+			.rx_release_ring_size = 8192,
 		},
 	},
 };
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index f9fb1399e0b6..1ee8393255c3 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -935,6 +935,7 @@ struct ath12k_dp_profile_params {
 	u32 rxdma_monitor_dst_ring_size;
 	u32 num_pool_tx_desc;
 	u32 rx_desc_count;
+	u32 rx_release_ring_size;
 };
 
 struct ath12k_mem_profile_based_param {
diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index fbc0788b37a0..f9b37d75956d 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -487,7 +487,7 @@ static int ath12k_dp_srng_common_setup(struct ath12k_base *ab)
 
 	ret = ath12k_dp_srng_setup(ab, &dp->rx_rel_ring, HAL_WBM2SW_RELEASE,
 				   HAL_WBM2SW_REL_ERR_RING_NUM, 0,
-				   DP_RX_RELEASE_RING_SIZE);
+				   DP_RX_RELEASE_RING_SIZE(ab));
 	if (ret) {
 		ath12k_warn(ab, "failed to set up rx_rel ring :%d\n", ret);
 		goto err;
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index a94bbc337df4..bef0f2ba0560 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -200,7 +200,8 @@ struct ath12k_pdev_dp {
 #define DP_REO_DST_RING_MAX		8
 #define DP_REO_DST_RING_SIZE		2048
 #define DP_REO_REINJECT_RING_SIZE	32
-#define DP_RX_RELEASE_RING_SIZE		1024
+#define DP_RX_RELEASE_RING_SIZE(ab) \
+	((ab)->profile_param->dp_params.rx_release_ring_size)
 #define DP_REO_EXCEPTION_RING_SIZE	128
 #define DP_REO_CMD_RING_SIZE		256
 #define DP_REO_STATUS_RING_SIZE		2048

base-commit: 612701854b588759c0df3094197d415869ada159
-- 
2.34.1

