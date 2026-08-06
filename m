Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642A0367B98
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 13:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786022719; cv=none; b=OtSqsi39qn034PyWFI1lCyno9/5nNxzwtURXJ88FBQ9tUjpmGAkNpBKGxYi73d/qQhVRv8QG4cT7TPrSwsmloH8DlbSUHMBJHy/try6glrA8CyNoxGwg8x6EAkGycZX9bDDqf3pHXA90im3If287HXzfEM3WYezClIWSt5ERY1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786022719; c=relaxed/simple;
	bh=5R0o7JFdqMZT0nInBj+pnct0Yrk2mbMMG3WHPWsgUGE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tOnP8qe/XDQbf/Zx50x+soSHlKPgW2BPTLvkHHtnsSo3EE/i6D68fbu/kpT31CjSRbe2YeNcSZKnI238tPlpRW+X4VceCaSUPo5LwPB0VI53uIFgpx2F4ocGaKGBYq/i0SmHTxpvhv8r6tzAZb91BZNUIrZI6TlinwV7vsu4yxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Z5MxNv7c; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=M5CiR5hN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Z5MxNv7c";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="M5CiR5hN"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nrq31278074
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 13:25:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=f+ExpY11XrG
	NkqspeKakk5KKiupmYq5hGJ+hWgPI7D8=; b=Z5MxNv7c0Wku1IAN7MwObvR2Grc
	bxj2nS3kLY6fp3Qyha4xAHb24QPJO/duCk265kYRDB5+n49/Vpg8r/Fi82Qaqu/H
	UIQarglhmFGo1AXKYSvDrwAPclKubxfUkP+ZIhpEDf+s+hjv9mB/G6TWKLe8NZaa
	COOYRarAT4R5iz60wfCQ6Msy2UoctVHUnRY3dxvlanZV06GFt6p4bLxsNqHZc0qP
	rFbCLxJitMBGZQrCvo33lLtX5vBxzytARsx5PKqgY3caL/m0ItSY8f6LU18Q5Xt+
	GyR7/M20sDnnxKRDFzKzwkVQABjkeAqexVNF0YOMV25WPJPXRoCnm6xtO6Q==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvjuejcxy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 13:25:11 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cab3e9cd922so1449099a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 06:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786022711; x=1786627511; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f+ExpY11XrGNkqspeKakk5KKiupmYq5hGJ+hWgPI7D8=;
        b=M5CiR5hNyqrg5HNJvuCUD3h6j2vPf671D3bn0JY580a33EzG8p/yyN7qoRMZmg0kLW
         PRW5AW/xTdPg60M/uRfLkuCG+RLrAlay5UokXgTRhAr0G1I+rrUNBSy7mw4iJ+eHF+X2
         Bi65n82b/u7J3yTv/JFewUKcyta6a9yRb5Zo6u9MGtFkTK4X+t3To5yAjyB9+4YLng/h
         /cmZYI+U/t7PmTtQ+3pOgX/kL9dW40d205J3x8ytCaavQQld/qtwNsUfJtOV41kFBtds
         ntJ1MinL1YJLFYkuzVjgYlnTTgEt1o9Bzm2KR0Quq7Mi4vfqvI7NP2uf6NbPyRnKyNtg
         C83w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786022711; x=1786627511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f+ExpY11XrGNkqspeKakk5KKiupmYq5hGJ+hWgPI7D8=;
        b=fQe2YQbtPm9rAb/g7K97LSzvIWQ//nX6pgUoq+U4TjbC1xLJGljqr+KW/8hC2d8wnr
         FMseShrzW7LyFdQ85OqF0Rs2dP17Ck8GbC3/Wr+DAaID47ZF94ETEkuG1ODIhfjsd5Jx
         GvnLKa5RQj5rvKLEw6Igm7L6zDCURkKhcu3ek9PqNmhGpEj1TCankYDNnRd/3Zc1xrXa
         MzyK2sKPfy3uxYWEXIsd+KD83Ashq2vVcA8G5wwnbJ3sE/RDvPRpg/fDPqZS9amLQV0j
         ZcAzT6Tn2KHHM6itDcZwe4NEJgfTF2OHA455dAQSIpxDtN/ET1hE9mbhlpa9Jc+BTTjl
         g3Ww==
X-Gm-Message-State: AOJu0YwUEDTUsRwTGg6O0Rp1qrLMH33U+8Y3ZNfNsmVOwikworp3kKGP
	wF58MqjsFjnSvJYR3pVw767wpOPYCLbVriGRYXgZDA6fdEGhn9kK/prRBxIL/agH17IBBngw4oU
	9vfcRqsSojdbRxVuOSqDkflBzf8gSWz0Pj/FvgIwV5Jo4FUSmfIBNLX8d9o7CO25bR6OY/g==
X-Gm-Gg: AR+sD12cUvlTK+wZI9T+zT7X2vWsaPS1Aqt/PzMwXDjHdI+FC4AFnoOCx+ua3/zvvZ5
	8h+BW4rd84uGA5DouFGefm9ESvyL4IPBHft7oYFE7RYXEPzKRxhltKlE3/wO08wYY1bcLcwPd1W
	WzN6g9yUsgdibO4HXsNWqNUZOtJEk0/TDxgep+QpnZmlVAdxemzo8A2AIb4KhT1QCeSYGA/c8Hb
	0eysthf1W7c2QhTl5JnSvkbRmtQJ1SCJEpdRH1ysAyNeegrY6us81Gq/3b2ke1vTfXBJowAAzIb
	xojf9Q0M24hWd11KCWntRHVvOtuJX94WYQvJROGUsVj/y5Mf2mF+/wvyMvok88FMGy1Rg3Q1ohk
	ita+EOnaLCs1M8+GETQqWm8alybRRc9jLny/Jopp5WS2LkeM0TW++
X-Received: by 2002:a05:6a00:2410:b0:847:84a1:9782 with SMTP id d2e1a72fcca58-84f2e075d64mr15835003b3a.26.1786022710670;
        Thu, 06 Aug 2026 06:25:10 -0700 (PDT)
X-Received: by 2002:a05:6a00:2410:b0:847:84a1:9782 with SMTP id d2e1a72fcca58-84f2e075d64mr15834947b3a.26.1786022710138;
        Thu, 06 Aug 2026 06:25:10 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f456b785dsm1411637b3a.36.2026.08.06.06.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 06:25:09 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 8/8] wifi: ath12k: add WBM SW desc fallback counter
Date: Thu,  6 Aug 2026 18:54:27 +0530
Message-Id: <20260806132427.3704828-9-pardeep.kaur@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=aNzAb79m c=1 sm=1 tr=0 ts=6a748b37 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=7LnAo4KMM85IVg6JStIA:9 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: xdT5YjKUF2q9iDr5EoQneQLntQAKQvN_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX9QepjE4ZnXRk
 0StSJGKuDmW+O//F4G5js0k/CJphOPqJhBYUUox4u5eaUZ62/qDtkE2SOni8lwY/iYsnX8TA5/N
 7GYRbxDVvB4H+ZIyvUQnU5I2frfb4+8cxPMtrCQgTwphJHxkeMnpGPO8bhiSYrnh/W8qP1YtleT
 ixL6y3z4r5/0wkSGokYQ8lyTWyI7yegSNCT85dE5xwuyb8221DYIHJeBisuceqtV9Zp/gCNmcx5
 UmAFIyOG1WSPkXfpOboFSrvHiKMrmLCddL/2fTXufeCuSIHtAI0Wlkq/Z1IbHI8krJ83t3AXLRQ
 43+HLso/AGC2mP5BSFLu1WbRs8UK2ulfnYz1BDAE59E2n77anRBWch3+6evk2df3UCgslfdKtJc
 vAiUiDL97R804jgTWjSiwwNvDmg37OMF65KozP8mMqh8BOPyMJ8PkF+IOLN+54+GXYKsEZbUbS/
 J8VZ/Dyzkb+E+jazoPw==
X-Proofpoint-ORIG-GUID: xdT5YjKUF2q9iDr5EoQneQLntQAKQvN_
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX77n2h+FqkFLe
 pd14fLp8ZQsCPA3Y7lU3+o+nP277dQPIsWpu3mH4vUK/E4Biri/wvQeuANCCjgxmMxXFI7zGDXS
 Vw4fpKcYOwfsPt9rNjC6vwrlhcYGGik=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060105

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
index d4ea21aac21e..ed7045a2a380 100644
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

