Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AB4403AFD
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786373125; cv=none; b=J+Ok9lmO5g7eUWaKJ5O5Wq++eUetNG4OYjsnHsY9X6t9fjFl4HyTacYML/lnOzy9tDvoPzMZbFAMiCmboDEMxkDb0AcJznqPbDUZSMRLYXyy/A8KknMGbu81Ax6urt9cVqOGRCIxjrIM3M0Dz3rzJ2QfI6bCDyW+80LXF6Opa+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786373125; c=relaxed/simple;
	bh=faS/HyNDl19D/jAc3laHZO8WrHmCAX3sEu7QI1Ry4GM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ol5v2xc0olOrq022H7aOdn9UgPzf+xSg9oWT9M86ulIHcCfoT/6Qvqj5Jf2EhpeWdDuREMSl0gF5xw3l11wRLhUC+Hku79a7u/GPLMjohmuJ08+H6zLAhsHadcj3PxXr8yWU8iE6fwQAi3dykL4qPXojJbY3UNllGw1fRGX6Swc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UpdVbQi+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jQlwZQ/D; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UpdVbQi+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jQlwZQ/D"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACjoHY398981
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=h3V8Tl5Znh1
	yQfGva/IB+DLL7AbXu+gndyFgeBKeWSQ=; b=UpdVbQi+PGR5YO9tjdNZxS/ixNb
	JcebA8a2xI8wZL6q2UwKpKed5Be7ZH2gBnzpR/emYmk8pS4AMOLOXq18I0dNZe/y
	HdxvDMy7OEGqU+h55bx4KjGG8CCVJ53DYd8GyaTNtGoHFugdHWCFTHA5g4oo71/X
	HVXGbWXZ/Zveuw/YbY1WuUrMxL5QTpFIs+H8JI7k5Eec2EfVD7rA9yn26FP1cvbD
	NSnz091Zpkw+zD1Gfd9NvOr+T2Vf2Xugc8kGIcd/PMQGmN7nTWAnMk0VhXKX1yiX
	4sMwFnns8VWOPHFyFE9Q/Y98S7o7s/g51SwPJyiFCrZYsMrvj1AKqPZFbSQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fycges54b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:22 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e6d253330so2309362a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 07:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786373121; x=1786977921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h3V8Tl5Znh1yQfGva/IB+DLL7AbXu+gndyFgeBKeWSQ=;
        b=jQlwZQ/DqMoP5hrDJXQVT52p4WXgp2O1xKS6FtryIpyLVH/zq3mTsdFWUI0MpeQ3W9
         V4TYQ6a/F4wMhINr8m6Ob4nMFD1UGlHQHCzczhEVqlL8CMFUGT2QFkSfZdlqWECo8DwE
         GmwAmSzDibThpjWqcZbiBeqUAM9r2xxcsCH8ds5JwjTwawoyzJlXy0X+0ZH7MZu1z68Y
         /fNM9WxEhjuJjO/HvdhDO68W+i4q0A3oM4IN9N7zZMbr2zPMOw2HdVpZKB0LwMgSmLyv
         kVaNCjjs4e57tvgV2P8CeeUGHI3sgmlTMQ4sa7Hu/hycFd0tjZpp8obYxTI4QTXO/K+/
         JlUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786373121; x=1786977921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h3V8Tl5Znh1yQfGva/IB+DLL7AbXu+gndyFgeBKeWSQ=;
        b=qfBBpLcY9fCqHp7ik75LMQMDqbs1EMB5AGPMNOZ7ZqzYe4+T56jArRUWbUYe7P9Wmw
         GFBd96G2zOFEAyuwQf36Rr/gn3VvJBaSi5sYwzhMGbv/N0fvqkmUapBkjJiKl1PJj2Hx
         eqSIrwV2Zkzz4+j4hQoclty6n6PIBXKZveNyse42GPCL+euJvJ1fp2cQkJv4n/A6iubJ
         IxHiIaVRMRN3yR3DbpARW9DHscXfrOnrvPkUfT2j8MDoMDtXAEDVNoKNsmW3+BH+wGPU
         Y2MzW+2Q9+Z+S9kNXy1ev9BQbgXc++0J/nmEzjG0dXMOZrdU6olPUo4Vj44PyQlxuLua
         SF5A==
X-Gm-Message-State: AOJu0Yw+grsKl1v+rXqx8Ge9kZO3pNWZAdGPOqTGW5/+zSu/KeTYXx8L
	KcQeFsBUS7SeRmRKMVsnKW/mZwDFySOKKKRVu0kU9Fou1SWN+crIuDYBmrsdU+0/PYYA/gxEweq
	TYtqNe1AR9eFcfr2piXn3BqnewsahCgJTPRNffUYTpgmh580zHVa3OXFFidykhIBE0Qvrd79FjX
	QCug==
X-Gm-Gg: AR+sD12VnxhdRPfyh1Vf2zD+RZwcfwILex7cehHbTHqs0FRb42fcynzkVOeAQiGogWU
	Lo2koGWPqzkLcLICWBzjAxJFmW2VAbvSzLkAfIb5ysXfvZdj6ryoN+6XRA6zJTzD192aWuXJOMr
	OjG/uEIPNvnibGywNyFjq2s82bKygu4TzHYHji/lfPQDNicIXzT8eNJrGiUs5GmOXZdYp9vRKWd
	9LsQaRjHPYnMZx9WU9XDgEyXZk4kB2M4HLxUTlzO7+Wnmro2SwrkILPI+0TnUM2EzS1N2/5X//V
	W4LnuPLrkcN3ypG3qWEdFFZxi7TJoNhKhjvDdzvcEvo93cHg7JUmwd8hGONfYE4PeJSBpNJ8Cpi
	++TX0C28DjzEcXTjGZslxdnODo5JuVFAPDcDSZerOMcZiLAn/RKci
X-Received: by 2002:a17:90b:55c8:b0:387:d5bd:6231 with SMTP id 98e67ed59e1d1-3928479c13bmr8221070a91.20.1786373121198;
        Mon, 10 Aug 2026 07:45:21 -0700 (PDT)
X-Received: by 2002:a17:90b:55c8:b0:387:d5bd:6231 with SMTP id 98e67ed59e1d1-3928479c13bmr8221052a91.20.1786373120762;
        Mon, 10 Aug 2026 07:45:20 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm12797317a91.2.2026.08.10.07.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:45:20 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v3 8/8] wifi: ath12k: add WBM SW desc fallback counter
Date: Mon, 10 Aug 2026 20:14:44 +0530
Message-Id: <20260810144444.2033607-9-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
References: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 9NgOQsIJV578oGS3yU8JmCLZI_Itk1Qk
X-Authority-Analysis: v=2.4 cv=R4cz39RX c=1 sm=1 tr=0 ts=6a79e402 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=7LnAo4KMM85IVg6JStIA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: 9NgOQsIJV578oGS3yU8JmCLZI_Itk1Qk
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfX6RcPMmiXaVxz
 ZLj78LNF8UMJc1oYZdJ9vvyZfkrX/JI/E4rj3Cm2zl+w246TttkjgHYopft/+7r+NYp3Wi8VLGf
 W7c0ywZ8qG82K5KzdNYj3AxDD4udgwk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfXxoXtnQ/rwAk6
 KBbhJPhq36Iy/LmYub4iPxRFfQVxSn6yBbaoWlZ8WlE5dXYD62JgkvZu/4dKdWZuCnrMhMDBYhR
 md4geXRJ0dOTNAxu/BiQMJDgL/lM2eFWJbRpeX9eieFhBpE5owlWipC0SZHg9JJtJM/FDjtS9M6
 Qo11RoqCQeGictwGtXutGgjBm5zJ40vPZQ/+aIoHfXqHQsuxDrPyWvicLyGj6OUoex2+gemfMmK
 I6vZvRbfQHWREaxTLGREs31yr4vZz2aKAFC9D0b7XTA1yAQVtx6oJsvGggGqdiy9ZIN7G19Qrqb
 sARSPLZH+STKiKKWE3j32zrzbgrtvhwFUSDLQdR5s75zPiJgArwQED2iMN5lhFtk0+gPv+4u9eC
 VpP/H2NuE1WFW/jNricwIAvKS+pfzSO/HfLeKibjItObxMoYGjYxVvdfG8T0bVR/F9Y1ApgulOi
 XLrioIbadjzybEfdXzg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_03,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100126

From: Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>

When HW CC is not done, the WBM RX error path falls back to
cookie-based descriptor retrieval via ath12k_dp_get_rx_desc(). This
fallback path is taken before knowing whether the retrieval will
succeed, so it is not a drop event and should not be counted in the
drop[] array.

Add a dedicated sw_desc_fallback counter in
ath12k_device_dp_rx_wbm_err_stats to track how often the HW CC
fallback path is taken, distinct from actual packet drops. Expose
the counter in the device_dp_stats debugfs file as a separate line.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c     | 4 ++++
 drivers/net/wireless/ath/ath12k/dp.h          | 1 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 1 +
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index fe513b3489bc..d2d89a7e340d 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1122,6 +1122,10 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 		len += scnprintf(buf + len, size - len, "%s: %u\n",
 				 wbm_rx_drop[i], device_stats->wbm_err.drop[i]);
 
+	len += scnprintf(buf + len, size - len,
+			 "\nWBM SW desc fallback (HW CC not done): %u\n",
+			 device_stats->wbm_err.sw_desc_fallback);
+
 	len += scnprintf(buf + len, size - len, "\nREO sent to stack\n");
 	for (i = 0; i < DP_REO_DST_RING_MAX; i++) {
 		len += scnprintf(buf + len, size - len, "ring%d:", i);
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 5cfe2096c633..289aede6dabb 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -442,6 +442,7 @@ struct ath12k_device_dp_rx_wbm_err_stats {
 	u32 rxdma_error[HAL_REO_ENTR_RING_RXDMA_ECODE_MAX];
 	u32 reo_error[HAL_REO_DEST_RING_ERROR_CODE_MAX];
 	u32 drop[WBM_ERR_DROP_MAX];
+	u32 sw_desc_fallback;
 };
 
 struct ath12k_device_dp_stats {
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 60489cfd4e54..d96d8301565c 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -1968,6 +1968,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 
 		/* retry manual desc retrieval if hw cc is not done */
 		if (!desc_info) {
+			dp->device_stats.wbm_err.sw_desc_fallback++;
 			desc_info = ath12k_dp_get_rx_desc(dp, err_info.cookie);
 			if (!desc_info) {
 				dp->device_stats.wbm_err.drop[WBM_ERR_GET_SW_DESC]++;
-- 
2.34.1

