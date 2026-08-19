Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F0F3A83A8
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787117592; cv=none; b=JcU5AuX3SUB3MQYbn2lrt5TBuISdtIpI+cRC2F+PMeuPb19QwFQ0K1JnjMRgH5gVTMN/pmYSp3oDDEBTVe47FyBc7wv1R7gWz5mcZ8tWJ7x875B4ECFH1ww0dArDV6v9ALTlyeW31p0JKJHTUxFhYMJphyu5+aPOlgmQuN6ZiS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787117592; c=relaxed/simple;
	bh=GrAVKFk9b8+Omhi+eJPRkC4+9zTLOxA/E0XxtSKuhc4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ao7JvmttKWkP8Geow2C0OtmmS+1hqDkdpZfTpbP21/152RuQYqTQaq5VzDCV8SoV/x4arFwEbf3n8LvAO1AwkQNhKruriSRcvbroO3cSG6Vnfbnz6GApmqRBstBMSjVcBNvJudENQnIoP60gOm6Ti43YLKYuDQdXs+j8g3qWxcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=o6C7kcBm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ccWgtCGY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="o6C7kcBm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ccWgtCGY"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J5HvlZ2554943
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=CDc+pb3v6Mf
	SQtwl3l04JeLhGdo7Yuk7Oq1L+GHXJBo=; b=o6C7kcBmV6zl491SjbMeKbn39Xu
	6VV8I7jqnVCMyM8sBCyKVrHClGqNugO94wHGeLpIi3KRMyDa/ULG+osC2VcXhToa
	ia5brpNpNqTiwPplVNpSWCZfxrjD/4ZgNWlISUsUz0PfyqmjfmYiYaRTzvlupdyt
	XPYU7MIevBRmaBksx2xrMCc3PwagdxL+z4w3fR2iwavtldmwwt0xvLrcy+f1qcg/
	S+KGpnF8kaT4qKfQ493/+8G9lSiegcexgLXtBQEU0gCPRqfQWIXQXRRErDt9XFZc
	8Cefd4R74h7EcDRFAuXRRAbxbUtlBFy59XZFojf8NR6JmIM6axj6zDPFcHg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfm1g8t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:10 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb5cc1e13f8so429496a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 22:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787117589; x=1787722389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CDc+pb3v6MfSQtwl3l04JeLhGdo7Yuk7Oq1L+GHXJBo=;
        b=ccWgtCGYi9+tZHS4V95iqPsxxpxDS2ndTKLEG201GaAuKjsF0Ci0T/f4e14Ubw3n7W
         rcDSIls1JEWMB0l24X53lU6GAkHWuH6kcjCKhct/9zJBDJdJ7OjeUAM+8OxP2IdG247B
         orhj4VByy2aSrAWlKoGCdvV77rZVVQaozH7cY9imq3FNYU8MtZAtzz9Dmaeh72vuWFHl
         LhkoJcy4PrRXf1hH5L2Lm5fnBFwFobUVEnGaXNd8tNCj1LJi9DtdGIm/+BwuSYupVtL5
         xk33oxGmbrOSOVcN8n5BZJEXQ1zbw+GjMrKlSQ/yXAjfwRGQYzE867Un72f/w+lANrRQ
         lQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787117589; x=1787722389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CDc+pb3v6MfSQtwl3l04JeLhGdo7Yuk7Oq1L+GHXJBo=;
        b=XFOIk8uL/vVV/sEop5oWVeBNeWvTXqO39WeMy3zY4zyZGWBnWRAIDrYMqKLM18FGkX
         CHhwHUa5h30tZ8HqGFaQ0XcAeMqQjqRqRpYEWiYe/hDcZ56gPxqr1Rn/6C2Tou4P4Z/X
         j9fiFwaUgU9dNCcNnHrn+dNWaVd0egSddM3tcLXmQZ1omQIE/9KTJVJbwmZK62qo/1Vm
         IGorQTeg1/oadgdRAbBeuYBTajsvtXv3VV0LJmWg32ZAtPNPnht+45Tvkol7H7XL6I+K
         KQTOmcfAOcu5UBAlhrgYtc6V8ksGmkxl5A2Ih+bAuDt1NEjQMQxei0B014fkz7cpLJzz
         1LgQ==
X-Gm-Message-State: AOJu0YzkChuF/OSETZIWVpRQqnYP+c3UYXE/hndndIL7aF7uMgHQrnr3
	xO24YKuSyZoBXltnnz4fD2T3vWb0+VCVcPIQ+oD5H85cgsGuND4WF68O2Njne6W74BMZYhOc91m
	b0WYHC6tKZHUONRv48udzqrQmGp/qNlS1NQF1gaHe2p2KyiDli2aysO+2thqJkKikYf2cMA==
X-Gm-Gg: AR+sD10RCSuB+iRgOr2O9bw2ErZ2ItFkYSuZG12r7+IzErg/c9HM2f0dNLhTkhvgQja
	CHsJvxHrXTKw+/H7OCeguYdi5eqSFPqrVXU3nHQ1Kq0imIsrf125nbjLUUalX8IEOuqz8QoCt0w
	2tDoLn4O+w5W5M0WiowLxz0LAOsTW+FH/MU/ccaFdnXBda8OLXoVGYEmlB9pfTD6r3lfrvWaSgq
	crpRdJxCYUPtVFWnR0YFvXcBV6XgTrI/e+/UW16pP2EqSCDNpuohhrsAM/M5zyNLJISaoZcXRUe
	RXra4XHBhgLduuqzF3TaFx/WjDzEeTr/IDKGrI9bQzUtsJoURc2IX1Zbgp+M93lErpeThwIzSyx
	FDIT0DJnxEyXjlgwio7mp4CljuXvsO/MiYIWjmtIKhNshPT1u64aa
X-Received: by 2002:a17:90b:37cb:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-3958046ce9cmr4173457a91.0.1787117589247;
        Tue, 18 Aug 2026 22:33:09 -0700 (PDT)
X-Received: by 2002:a17:90b:37cb:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-3958046ce9cmr4173411a91.0.1787117588786;
        Tue, 18 Aug 2026 22:33:08 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f4c9918sm404261a91.0.2026.08.18.22.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 22:33:08 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v4 3/8] wifi: ath12k: add TCL ring TX buffer allocation failure counter
Date: Wed, 19 Aug 2026 11:02:42 +0530
Message-Id: <20260819053247.1420393-4-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
References: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: JRt_ZsLwYvbfCgW3kkVsC8uiPjibEYRm
X-Authority-Analysis: v=2.4 cv=bth8wkai c=1 sm=1 tr=0 ts=6a854016 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=vo2QL9yUnAtzEB9pKL0A:9 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: JRt_ZsLwYvbfCgW3kkVsC8uiPjibEYRm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX0fMUR1UV5ZRX
 khTrfhqvYrXQT7TKPHcEHsLvRFp8Wqlf81ZGLo8wTNgPiTz/sGA8X4M4hsAORKQ4PN/fPRXbRvP
 FuLGbDDEXi4Dlc0kjwZZKdxPAdEbNQegJ2nV1VtPN2z98y/mGcTMYY5E54st5jY2BzITJ5ES9Ql
 SRfx4EcBXQRPrUDeWdC+wJp4BGdN+ezcm2Vy3pyzVW80jUVx2vuzrCaeJFuhUN2S1G6V0pab9nZ
 AggcRCkRof6ZLIKo61EvXgnSEBqWdX/5EMq4MSza85S3SxiNGlgCYtLG+SvMOJc1O3Ja/dBqQaw
 PksIentTUQxFFDGI+hLcP0vgCkyqZ/i7cknBOVZ+LveRAfMyCyWStNFVdRM5d/NSW9Gu0mP2w+h
 DClYO5bpJM88GZZYMBGEYWErdrJeec/NEJtUvMb2xmD/2Psubf/K97IAPZfUhcr7i1SPTO7AR21
 WRiVHfZkmTMrQBXOsnQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX52x6XT+2E5G5
 lCG0PgKt/YjGVnD86GRwl7UittJqhS8/a8o8xCsCoDSLeo/8b/O0Zx2L2XrptTK9RMK57hsjRCw
 NFjGNJdDtQ2HIV3mdcL3NTfJHDvVIAg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_01,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608190039

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

When ath12k_dp_tx_assign_buffer() fails, the TX path returns -ENOMEM
silently with no visibility into which traffic class is affected.
Without a counter, TX descriptor pool exhaustion is invisible during
debugging.

Add txbuf_na[] indexed by pool_id to ath12k_device_dp_tx_err_stats to
track TX descriptor pool allocation failures per traffic class and
increment it on assign failure in the TX path. Expose the per-pool
counts in debugfs under a new 'TX Descriptor Pool Alloc Failures'
section.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c     | 5 +++++
 drivers/net/wireless/ath/ath12k/dp.h          | 2 ++
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 4 +++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index d54995b7adb2..ec49692107a8 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1117,6 +1117,11 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 		len += scnprintf(buf + len, size - len, "ring%d: %u\n",
 				 i, device_stats->tx_err.desc_na[i]);
 
+	len += scnprintf(buf + len, size - len, "\nTX Descriptor Pool Alloc Failures:\n");
+	for (i = 0; i < ATH12K_HW_MAX_QUEUES; i++)
+		len += scnprintf(buf + len, size - len, "pool%d: %u\n",
+				 i, device_stats->tx_err.txbuf_na[i]);
+
 	len += scnprintf(buf + len, size - len,
 			 "\nMisc Transmit Failures: %d\n",
 			 atomic_read(&device_stats->tx_err.misc_fail));
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index bef0f2ba0560..16675210806a 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -429,6 +429,8 @@ struct ath12k_dp_arch_ops {
 struct ath12k_device_dp_tx_err_stats {
 	/* TCL Ring Descriptor unavailable */
 	u32 desc_na[DP_TCL_NUM_RING_MAX];
+	/* TX descriptor pool exhausted (per pool_id / traffic class) */
+	u32 txbuf_na[ATH12K_HW_MAX_QUEUES];
 	/* Other failures during dp_tx due to mem allocation failure
 	 * idr unavailable etc.
 	 */
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index a8afc1cb0712..11048c568331 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -167,8 +167,10 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 	tx_ring = &dp->tx_ring[ti.ring_id];
 
 	tx_desc = ath12k_dp_tx_assign_buffer(dp, pool_id);
-	if (!tx_desc)
+	if (!tx_desc) {
+		dp->device_stats.tx_err.txbuf_na[pool_id]++;
 		return -ENOMEM;
+	}
 
 	dp_link_vif = ath12k_dp_vif_to_dp_link_vif(&ahvif->dp_vif, arvif->link_id);
 
-- 
2.34.1

