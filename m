Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A04389116
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 12:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018195; cv=none; b=t72uZB1McPgUam9HgRJRGyGyeBHxrI3X9c5F0WXAfZdz3bTTPyVN9VkzCQ60LCMHhcwfYkd4ZFT/pJsLN29SqJ2qZCD5VjRr9RLUb3ZBDgBnYmNG//TBSTVntea84+mT+sxg5wWfUPUU1wml8JANKEbxauv6jxVd3mBGaLWYBrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018195; c=relaxed/simple;
	bh=/TwAVGkgOaClOFz6W73nRnXap4STtJwwigCK+O/Yx5M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WErQ0tuC+KtS9hcMK/ohnHC/KB3RGsXKNucWC5nMl98+CW9hRGxHnTZ8QSnBN7LGTrmTAFjCL9tPMVGoWIa0iFVvNe9FmVevEqbOQkfpKx4/kTlpyUNZilH/MzC3PnLrfJxBbhRHz4HA5LFCi0uNzET6tKtF7OCBQNZIRwKDwZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VQC/pnVQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d42eLMQH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VQC/pnVQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d42eLMQH"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676Bwxv93037523
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 12:09:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=F9NgGZc76LN
	UHikIUHtgwQ2SJJPhwF2P8xwlxp+fmjs=; b=VQC/pnVQ4NjGCofxW51CHiZeZOv
	60Wq14b5J058cOlogrSBAHXJoPRhkPP+6qKPI3/xj2Jpkc1FBW9Z73s0vPS67Eat
	tyJH+Wcoo6HwSE//5ZvvzZ6dkyq/ivzb4L6lL5nT7UnzDnhIUa4z96ZWD1H4QovK
	pHxyunIFvd5z7JPzE7jHmPO1Z3eJLxMwrL0ENBfUbqmPjHMONQyUormnwG2lb+El
	R9eYjb3an1ukegDXi3IlyzNnxZp1haXM88u2xIvVGwruIZyI9K6sfq5VEbsMe/u6
	xomus5XH10NBl/wkHUnAm1cdEcfgEKzyb9JMLKT3IN8Xrs4ok1X1+xvMGMg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvsvd01j6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 12:09:53 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso2645621a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 05:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786018191; x=1786622991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F9NgGZc76LNUHikIUHtgwQ2SJJPhwF2P8xwlxp+fmjs=;
        b=d42eLMQHsXAkUVF+p9bFFezYl0QVFwtdXgYXguN0WFYxJj93RGFlFZvSO7P8Wwkfy8
         PLLwzzb4vKhSCLZ84g5gL/92VKdhzjCQcDlElcqShUu0tD6pzs40hFGyIc2BNl6iOHlV
         PMU9EDCak/0A1eYsr6uhjtORx4sn+Uvc1Cm/BOIMCYTs0CnF3/LILgzejy3XUzSapwyC
         NnbxjMYxHW66NIyNOGINUeadwTUvsDYgRvcF2ScDdPBH2NLnP059k9t5CGOoFIgR3rWs
         KuS8zZl/GYPE2svgGMOFk3TvlerlewWGo+Tx2zxg/XXd5yHnFNxoRfvTl2yuUuDpgCor
         Weiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786018191; x=1786622991;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F9NgGZc76LNUHikIUHtgwQ2SJJPhwF2P8xwlxp+fmjs=;
        b=CK7nPhBXevQNYUlMhAsE6Z6+e0s0Pq+GmFbt+wdzPGP33KsIUtCYqX6VXXyNafJJB5
         y9tYDGEVlG0jwSHMzYGKgrAJYZWQeTUCVrbafSYABiElJ12caraVi5THe5iQfjD4jzzg
         dMWL07fq6L+ADqGuoBpUHejsSe2lYFRx1Yea2FePO230EcDefWhj7tHQuSgPcQMdWP6O
         rXAxsdLsNicPGC2deOz6UW+ZguRnzFARSC7m8tKnkKavxRE3cu4CB+1nvD9/il/Q1NgL
         pOV0pX1psWdTYXj95COdtmFoi6wmcju2nFI3mOp2YcsHQCTgjJ0pZkjMShm7V/1DD5Yg
         Cpug==
X-Gm-Message-State: AOJu0Yx9+XzBHTaFjG1Q8BwV4A+8NNHqd339Bcirst4pq/sdZIkQF/Su
	bJNcnBuuAZMQWmvXauK5fUupj81xe3coDdlusTQWkawmLDMcb1gFxZS0ehFdJgCFgw1BO3/ul0O
	46HpPDW7GCRd8swHuBEbYEf4w1cfkPJMh5r9T7t32EWB7hiQz8yhXdDv7UopAsgA7ZYtO6OBgI3
	D8lQ==
X-Gm-Gg: AR+sD10qPBUiHxaTq/UT18ma+WR/Fpopm3gDb8vyLz+/31q5anjTp93oNJFyc3QToeG
	sOqQgcqfyqz2hE7iiFJdRkB00ZV9QoadR5oEZcaFWcB3Jdq0rEbn02ow0bFuhInvUJJNZ35hcCG
	OfIz3tfqJzb1S8m2arAsiD0iroDCQR14UGwAhOxwSu+ANKTJKuKu3Gin+zOvh4eIAH9SUsZ07tl
	C0HcX/kqK7WFuXAeVR3uIz0Ip7MpIJdSYP4tPDOU3xJanKlR8B28F9YklVlY66F5b+Rqkit+TN7
	/sGytpw/PWdhhImZgJ/N3bAF0f+6B0c7G1YKMM3rqDn9M14a6nHcylQslrDndJdeeIuu+qqPK/J
	nkDRxmqsfzT4ZWc6SNP4zD2IvKRLNuMne3eSIMR8M0n+nIyN0BpzC
X-Received: by 2002:a17:90a:d443:b0:38e:7168:281 with SMTP id 98e67ed59e1d1-3903c594637mr16075478a91.10.1786018191344;
        Thu, 06 Aug 2026 05:09:51 -0700 (PDT)
X-Received: by 2002:a17:90a:d443:b0:38e:7168:281 with SMTP id 98e67ed59e1d1-3903c594637mr16075375a91.10.1786018190858;
        Thu, 06 Aug 2026 05:09:50 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085db4a6csm1469079a91.3.2026.08.06.05.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:09:50 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 3/8] wifi: ath12k: add TCL ring TX buffer allocation failure counter
Date: Thu,  6 Aug 2026 17:39:22 +0530
Message-Id: <20260806120927.3607733-4-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806120927.3607733-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806120927.3607733-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA5NSBTYWx0ZWRfX4QL9GD4gbb40
 NH291txOhFYbr8fz+G2a4ckdhWXfB8ZxVfuqoSby56ksQzi20uK7Jjlv3DbTyRkKH8plX1PgcqG
 +1QN3S1DeSB2yqNgYVOb47K1IyYjWDQ=
X-Authority-Analysis: v=2.4 cv=WbY8rUhX c=1 sm=1 tr=0 ts=6a747991 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=vo2QL9yUnAtzEB9pKL0A:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: jdSTe7oDvh5r1K30WC_E6ddVgtsy5J14
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA5NSBTYWx0ZWRfX57rOCgwdaqdw
 O09Y75RWuIml5cH8Wt8jaCnhwZnMqVkAl8WNT0opVqbALSss8SR+aTSi5uDUF2bWh1MMvHPoVCd
 HoZoofl/KfKzrv2eF6+hZVsjR1g1Z46JxJc60GzwgEcsYhNdVliqKBiBxSdUsh2yiWkG525fj+8
 aWPhHO3YMtajO61fnwDN5czKMOTf/Y+CAqCHfzVBMZNGONk2nYxAyZ2aaEYXxItYErPikQGA6Ck
 c7pH6ckDaWQgCsnDx23OKxHVLuxxGd6FgfCQCLVUieq50N5jK6u3ydQLJ2D7zU3loKlzY8Bd4DQ
 uCoXux2PbA2JG5V1auHz4R/Fhcu3hk3nC+h3QAaXluvjOtEoSzItjuVMwnYyRhP16vhb0HZYftc
 7jH/84zXfcRjoq5wIVyjZPoeV16cqX4iWx0dVL/vQ+UJWgeVeUwNLnLmw0pKVBwOrBPsDRXMRx/
 E4OqtOJIVIJD6x7pnHg==
X-Proofpoint-GUID: jdSTe7oDvh5r1K30WC_E6ddVgtsy5J14
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 spamscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060095

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

