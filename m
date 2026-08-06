Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4ACD43B483
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010859; cv=none; b=MtrJU6Zw8G6AxrYIsAH+pmVzjXnAEdPOYe4qfJZHfw6VewmbIgV2loAlctuRI792Iw9PHC+NqOl1qDfvyJfPz2HPK9vkSRkGYWL8JIFgf+PILb7C36rcdABtq59rUo/rXJQUuLiMTt93VO+wViJTBQI674qmdu6NIq+nBFchCYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010859; c=relaxed/simple;
	bh=/TwAVGkgOaClOFz6W73nRnXap4STtJwwigCK+O/Yx5M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CIt65fqW/1goqbAYkW7fDq0Q+5XA4KtmZ0/elVzKaSl8ePumDuLgPFEjpDp1bkyU4mPzSFOFczHwdHHF0OElGXZ4b815kdrU0mbv7Eu2w9qnM2APCIhBrNMVMjild10sCROo/GIzpYQPhmDaQqC+R/XxVBB0BHtIA6ZqaFABgXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CjI/S44A; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PPkfRbmx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CjI/S44A";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PPkfRbmx"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769ns5j1876736
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:07:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=F9NgGZc76LN
	UHikIUHtgwQ2SJJPhwF2P8xwlxp+fmjs=; b=CjI/S44ATALsLoexzZ2tCxhEjW1
	t1honXpvDfO51PRwj0A65PnkivJ6LccKC7ver63hyW40Arx9n3M2CaP/5K/Sidq7
	60xgbrdPVBcjceqS6CkV7Ueq2M/sJonkYLLHLkkceHZqpcWUVfUB16ahJ2BB/46R
	YqrfbUHunSubTgyO1fQa/p6cqJjX7K527AFxr+5/P93qaYWKS8vOwT8uNM/gnChS
	Pw9nRJYovdeoB+zKn05vfBFpeIMcl829ly4+QXynPFS6LSrRdnytiMonmY2A5Qdp
	yUGPtl+kVgmRhzKQBNLy9rD2hH1PcatB3MER1WRuuS1Xb+bInBuRfz1wabw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvjuchfrs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:07:27 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb733fc5024so2770557a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786010847; x=1786615647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F9NgGZc76LNUHikIUHtgwQ2SJJPhwF2P8xwlxp+fmjs=;
        b=PPkfRbmxflxRosIlFyeGLof/oz4BHC3Wc4euoVtbb4eaO+2msoSBbzihp/wql/Q7w1
         w4A/6ds7tdoneWM+2ns4vNHVdWMSBA2oNlxHfW0mLO5YrijO9jwwqDQFmWcIA72mZwfa
         qOJpR2AVOXZnCVcVy8tKJVZo4DvKeWncMPpc0KTCKFH5hO9+5NOD8HltxY1u003c22oi
         Sx2/Q7+gyGCTh6tw5z1yd5zoZdJJJXgcv3rmyAWrSaF7cRQM/dr6ftnLkoO+amPOaak4
         4i8kzg0Fr5hxcXZMFAHKgaNTcCdcTJbyoZQIiporlKJH1PyQj99lPp2aQW5ooVp/lwfW
         uTMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786010847; x=1786615647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F9NgGZc76LNUHikIUHtgwQ2SJJPhwF2P8xwlxp+fmjs=;
        b=hMHI18dvGZuYfnfe8me8c8nirP+rxsTlgF9mXtTG0mvokoI4wG5/X3biEmfRWc6xxw
         PcOBOyuJMqmQLPHMyVO5KlCppXadFsk7Sjtmr7w/daMWLupKltoGqkpHfidG/US8P/qw
         F2lyO5KzF4wxDhupmbphol3DyfcGzsK2p1XTekUPdJuRQAKViH5V9KZYRtMG7bd6dvTl
         jKkefNrDAEtbJDPj1FyPj6p39aAuJvadgPfJdj2TyujmYif4vdv7dVg73gaAJQLk/FPb
         2JY9PesypHXpwRK90X5vO0VHFgnUJismWipq2Kh+dldGE8Op5GnxyspOs3BCer6KxLkO
         KvoQ==
X-Gm-Message-State: AOJu0Yzmf1B0oYwiAi/HvpKm3tPgaMgil0a1ZUVp9hhbbCbO34oZumkY
	kwCN8Az+SQ2Hm6BoOywy4P2C9h5sLW1Lj/U8IdlcoBM7ovUva49cgrwKnEeJiouF2vpUOMdsF7T
	9vLdZE68gzK9tnFPfUmKX7YZBFBSoG/wIaUUw9w5c3R3tYNRLaKEvwulLZ4a1NMMLBX36pw==
X-Gm-Gg: AR+sD11azb8Fgfo12Nv7HAAODBJMouDwPy5WyK3OWFYax+sefPxU084hQG2809QyNTa
	4SUgjGB0af+0qgrr7hvln4Y13HlFE1CmwRnKo9BZUGgixahI2wELTMSKpd2S4/+ZOwCHlebOMyr
	zxd/KgpHqzGspPatjS5o7X4F9EKtl8/yh1CYgyugb+uWoaTiWjW0ETapOBGYOF3lvHSHo/El/OI
	jHlt/ibbU/jVXDDIqx8GZ8Dkir8N7MklppQU9oC/XH5iFnN0cEG3x0pFHXC2kVM4g7wPPq1aRzn
	SQwSKdLcGWoB1MqshmKucxmy51H2vd2sCL0kpotnnkU3RB4aw1r8D53KlgwoNSimiZKflb0a6Wq
	TwWiNhGipry4xHnsoXUoms5EJixBvuSCBmldOwAinBUYRYK/xohB/
X-Received: by 2002:a17:903:184c:b0:2c6:a772:7e43 with SMTP id d9443c01a7336-2d0caa040e3mr173970125ad.18.1786010846755;
        Thu, 06 Aug 2026 03:07:26 -0700 (PDT)
X-Received: by 2002:a17:903:184c:b0:2c6:a772:7e43 with SMTP id d9443c01a7336-2d0caa040e3mr173969475ad.18.1786010846339;
        Thu, 06 Aug 2026 03:07:26 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0b6fbf2c6sm24027115ad.34.2026.08.06.03.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:07:25 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 3/8] wifi: ath12k: add TCL ring TX buffer allocation failure counter
Date: Thu,  6 Aug 2026 15:36:57 +0530
Message-Id: <20260806100702.3479326-4-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX8947cS1un7aY
 AaP4zR1kUgX0pzRp2FTsoLBMXQCx6ihglo7d70HAqLsxy3OPaIKCdBGjchQaaoF3Z1v6V9SyMw8
 mZh9iRixpHltbYwsqgFfBcDUY/LOnPM=
X-Proofpoint-GUID: Yg15VWXhZ9TCRlVqnxHLGmiHqeCQxd2S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX5I5viXs5Euvd
 OKz3YNTvdmrNf1hvSBpOhYI/7R/dFyqEifeAJKgvXuN1wZdx5yKYjkHRGlrk9DhIl9fFDWJ7xcR
 HvY5hahPjlaOhezCMh2I4zWh3ApL174Pv1nb9WRUBtBNkbj9yrhkrTYB5ISP6Zp8uU+MNMZEeMr
 LK40ZwjZ/8ESRWkGJi4Zxtny4Pe78ACQACFUJdF785QbDU5wvZMx7XFxoEMX5VSPhhw3qVG5oaH
 BFxn+2L8dvoNZmB1Pq7YYKXqUK0eLHhT4GmVn1opWwIFD9XcuUZ3SHSiaySktCvuK6OBaZc9hZ2
 Ar3UAJbB0RxOCQ2d6lrv51CNANSOPG+JZmxJofwsTxDYUxKMYsgThwdyf5epnqqpLbyRf8EaAdd
 lvrYO9Uk/MLmporQPZ9buJ/alTpv0detbL6eeDNJ3kKK6FtZlxuYfXfeaj8RjUfY/HNMnGqR+Ds
 2oFk5cQ2A6NzL5ljb1w==
X-Authority-Analysis: v=2.4 cv=Mo1iLWae c=1 sm=1 tr=0 ts=6a745cdf cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=vo2QL9yUnAtzEB9pKL0A:9 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: Yg15VWXhZ9TCRlVqnxHLGmiHqeCQxd2S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060079

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
index d46a3d14f018..f572aa581d11 100644
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

