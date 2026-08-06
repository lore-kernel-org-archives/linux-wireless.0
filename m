Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FF91A9F83
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 13:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786022692; cv=none; b=dgzhQhUevjR3yjdpSWvd3m2NdsoUBbe13hJwtQrf3IEEwQimMjZpeu0gUo6AcaCZO1Z0JXDOf8vdnAz8pbx0p0LXSJvBBnhcYr+uyysJ4CD9KUmfulfP9EtrBJyvaFikl6ALCHLUw9tbGCflcsraVhmcVAyh2QpOUg3L5QuQghY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786022692; c=relaxed/simple;
	bh=/TwAVGkgOaClOFz6W73nRnXap4STtJwwigCK+O/Yx5M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tgzKfAvRlyYBrlSFB6LgStk+lrrK2tWy7x/cSreqexDElqfg5mXGn+Z1UFOFbbe1j+yAVZ9M/hLLGST8CLeOMnb5Yf+NZHIw3Y4IXFLZBOw1Wl5Yyi56v4JbOx8IndYAvd87IIIyzRaa5pB5Wmx+dVD7t84Yc5/fX7No4klxd88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LLtXywaQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JQVf5Nfj; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LLtXywaQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JQVf5Nfj"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769ndSH1227614
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 13:24:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=F9NgGZc76LN
	UHikIUHtgwQ2SJJPhwF2P8xwlxp+fmjs=; b=LLtXywaQDYrCb5BxyJM3qiSJmaQ
	XsILKGW8utbScoP2K2jkpbxW49NZUpo4rClGQvoaI03Qse+sOs+CqrUh9TzZ+WKD
	+AFZ6hT7obEpdMoRZMq92TEIOi98JiX7v34U2fp54zgtOtXkVZxrtvR3ZEnTm8gb
	TrlFIyjldxNIdIwOwL1Ok2aIOZmE2BdXtFJnt/GFgki0YEn1MRxjsfjt3MpTSViS
	2alqtSaTnolZyDEuPFUSgtzuDJzgRp1jRQORMuGCSWWnVtqRqPobmmnn4vCiOkQS
	gAbzCCFZ7SsYert9qKZKQz4tLxqR8OwJ4cKyk/I635wQlAjWMr8tSQzpFNQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvqduh5r4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 13:24:47 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84a67b16217so3650052b3a.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 06:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786022687; x=1786627487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F9NgGZc76LNUHikIUHtgwQ2SJJPhwF2P8xwlxp+fmjs=;
        b=JQVf5Nfjr55bdtOmR+OTGg/kTdU1Bx79iSjmyTlpNX4y2tPQlyFBvcySvBHoQlSXe0
         MB06IZSSO5TgWM/7b+o20Ms2bhGQqsfTxp16zro4pXenoPerZwtAQTEmwmdzSL45posn
         eQFy0dviYjuCbRrGxQmPWrMxP4OqtpzT4ScqX2DS+Mr23re+V7lN4zH91n2mn0J3iTAB
         lJm2w/jbBXO1b3zhH6hOiyo4BXFZLCfWQeq7fGvLcb0Fa7y2/v86epGAVCsoEtLr5rTr
         eutmABYeGHvGaExpC+m/+SL70uh6DstofEj6D4Vs8B/zTQym+aR4xT4isOKg5GowSpfA
         ZNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786022687; x=1786627487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F9NgGZc76LNUHikIUHtgwQ2SJJPhwF2P8xwlxp+fmjs=;
        b=dITE3ovSZ6AEHvg8qWuQ/iTOtaizKDXvlVCPQ1DRS9AJyoNyJPJmMgxev920/P7Nva
         SfMOBVfRfnBO3QSqsHCn7XjrrIPkB/OzUt9+Nr6IOcVnoBXiQNpFsOZJ4JerkaCYpXga
         cIxsbXdH0vGw2Ji6xtSxQi3tvtY6/wXRe6wX0dOAdd3dbJG8syeAE2nRA3ZMBdw3tgKy
         SCPABTYmiYD4PiKAshJTfI0LfkEWi8BuFMRDfHb2BZzdJixnIZ6vp2IqYZJdY0RPzz4d
         Gw2/UJmAAMY2LYuzf/Hweigy4XDE6o7f5zvAfLQi6AWBgPsPory2GSx7G/KseY2TPhp2
         LplQ==
X-Gm-Message-State: AOJu0YxwgYn90hSrTnrUKx9CD6yQKCfkcXRUoPKzTEPlHumqhpnCMDSf
	l1b8fgGaMBKH7DaJjpzJGZqNmINsP0UJ6/fJSuW9Q1mmhEbw5Jd73dOmQCgrHUDJ27quK4ME1PM
	/tXnmq6a7SYalNb0UXbW1BJP4ilDXNCPxJwsN3S0QDAqtm32Cor1XyhO+7eN3OuaDs00HOg==
X-Gm-Gg: AR+sD12ocrb12tw+5JG6MB9U5UmG1QdOf4htAXIkfFYikYHhJUAeE24fcswuh5rTDRU
	Ak6Hp+21q61kw/Gmi3ry6JbSRv5G4TMI5HysxkY6IIsR7VkjzUHQOPXZVg8K36urQzlJAl9sVAb
	fmTlaaPChv9ZFiGacgRJ9m+tt8/Em2NLH3MELxUCjnrh/M3uLfRmpRjSquCEv/1fX1nt8ezjsVZ
	IWBQO0RykTMQHFzM+a+W+/DvtaRUIzhMiiu9yFiSLfxScVwA43o8/TDyKcFHbZnW519652PH1cF
	A4dRQ8t99EsTk9vKLmXvERGCOk6I0xzekO5+jpeAYAHwdg59wHgZPIpznqt0udS5oRM6sna4l9J
	Fh3EEjQHOKKqmzgIG09qKNKCInXzZj7y12Nicc8ipKxC38qmbfidR
X-Received: by 2002:a05:6a00:2c95:b0:84c:3900:95d4 with SMTP id d2e1a72fcca58-84f2e0149fcmr17254669b3a.11.1786022687213;
        Thu, 06 Aug 2026 06:24:47 -0700 (PDT)
X-Received: by 2002:a05:6a00:2c95:b0:84c:3900:95d4 with SMTP id d2e1a72fcca58-84f2e0149fcmr17254595b3a.11.1786022686614;
        Thu, 06 Aug 2026 06:24:46 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f456b785dsm1411637b3a.36.2026.08.06.06.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 06:24:45 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 3/8] wifi: ath12k: add TCL ring TX buffer allocation failure counter
Date: Thu,  6 Aug 2026 18:54:22 +0530
Message-Id: <20260806132427.3704828-4-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: rPwNHDV9JO2MyH_41nII9iM8cOCmAzmr
X-Proofpoint-ORIG-GUID: rPwNHDV9JO2MyH_41nII9iM8cOCmAzmr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX+h2PTV+ZbxYi
 hNgfctImtQijw0ywVx9XO5VBhFck2sZsFqsrh4RZsV5NP91Fm2KxDkdBtL3TNYfd/0hQ1Pkn7MD
 hLxHTkO0fbQp7CbMTP8dogUOVdaamOKhAjJrjj5iRmxFMPw7rC2d00NF29Hx7I2DFxzZ2iUDSCs
 2YiFWLWfmMjS2o/dti1nL8Htt+3d/t+aQqATvIjHYlrixSCd4zOAXZWdfPJPBDczSXiSg8XKHP4
 L3zYllFOyWBQ5y+zGg9aILBXz3UZotR8w8Yrkr+bklXFzHARkCMOdN4dVcNsXIRqfz2th9TxG6u
 UKbDBeEwJgohdIEJoT0S37frynK5E8tLqXHJv7WScAUT4U9UDlZHA+1wcVxmSrta787zjOIk5c3
 T+NBNmlrItFt1AcsweJ3QSE5VZVYb6UT3KWGV40nNkMPIFIQngXy+7FsOPUuWcBzR/vHo8YGpKf
 bCP6zvDiIvPOHSIWYsA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX3ZcnRDU1NiBD
 65DXC5K684tgTTPabG8S2/7+wiIo47pAcs9CTEolG1NtQtTIVMb+DOzfgqIhn7REjD90R1q8RBQ
 e3bGbmq8ATzIeNCYUSbx4lvVYacAqBE=
X-Authority-Analysis: v=2.4 cv=bdtbluPB c=1 sm=1 tr=0 ts=6a748b1f cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=vo2QL9yUnAtzEB9pKL0A:9 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060105

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

