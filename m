Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE4E479871
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 12:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018192; cv=none; b=fWkIMgVh0ezjmmyGiJb9milRLEo3NujAIDNvL0bclNgBt/Dmf8eI1Vqz7ZpDbBKftasy/bXDdT1Hl+se4EdoUl0FxXmDT6Fbjof3CBra7f0CRJOWUUkuElM5IAoVJa7LbETaib6p6uccxnxfrGmCI8cM53xR3IRahOdF/qcrsV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018192; c=relaxed/simple;
	bh=12qURBaXe+VHVvlbhm3Cu4vyINZGxaOnV/zbqdV3a/E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X2AH2qmU6tO1Ml/fhCF4ahGDsORsidYIxG8I94ATbg4YJ//4CWX9iXcCUOd9x0OOMffvNYgIYiej68pexrbiez94WTrChwT4nC9dRZ3ZENXidFmphnx92zD6IsOsdCYJYDrSN3b86O3wbd4bx3iT0vl+eYvN+x+/txwYU2OtFVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LoPbtMRW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YMROOK9t; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LoPbtMRW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YMROOK9t"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769neto1625703
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 12:09:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=YwGMP9ynsxK
	lI/ohrLuFqx2UZfFwtRO5rMgbVYv71W8=; b=LoPbtMRWuGcUseC2MWLYnGj6PsT
	OQfvwrns69I12tsNNhlOyrOVjEzF8RyUg+Ftxsg8G1EUY82yEqlhBG7Fw9IgDZdb
	VWnaXVKk/d2l31aAs3cqS/DxcA/83dxOxTNjLYMGUPBrim5XOPe3HvVsI00iLb9n
	PoCHX5pAjeb+HjZMpQYZlEP+DgCKitorFOKwBdEmZvBmUJ7cYJmuUcMUWguwZtUj
	JKAmBKaKkNu1KYQg9DROTCUGMicfsFr+T36KxhJCw2XO6g2HASgj+NAu8+x9jjN7
	15YvrmzercG6mcffV3oefW5NZAgOcw9/14aXuMV8NJoYiQmptR4CXwKU+nQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvntnh77y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 12:09:50 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cc5faecf01so40701695ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 05:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786018184; x=1786622984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YwGMP9ynsxKlI/ohrLuFqx2UZfFwtRO5rMgbVYv71W8=;
        b=YMROOK9tNqrU+0daj1sSehZNB9aoatgOg4UB2BRE/ptIk1zKJO3MvQOJu/pxzFibAo
         OOUoJNwg2yT9HW8cXOiJ7mtfzXsm0tNhjWYNwUog5kVF3KCt8q+rpxkuK0p3huNGA1ij
         35AJEF9gvzufaqB1e4ONEoat3/qXJaWgYEQtu9BK5oho2bPnspSpKevDkLbxcGi7U67W
         fMZGBJZUyTuydkGu2tY30Z0YyUn/vCJKyrGN3cKKU9/KQTW2t6oYQS3Iu28O6726RTYM
         P3+grCzPvzoEZuYEBaPW/YvXdLSO7BJs5n916EKv/V+nD3c9jgsfEuo5mMLYSRuYb87a
         duxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786018184; x=1786622984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YwGMP9ynsxKlI/ohrLuFqx2UZfFwtRO5rMgbVYv71W8=;
        b=Ndmizgw9iAQZyf6kAhaK7X9B+9sVnAsUXZsPDmR6LJCzP4WNYadIr33qX8+kT+UcrB
         ytiW+fPBeRs2Z6sWj0dVt6gywsO/Y3d/85WP7OxQsbO8JOFySfzJN7gl7lvmpa2sGXsj
         ptV87FOFdZW0KpchFgGzZ28J8i7Ja1dN8RfgzBKrDLhSXjaQJtHuew826rZKSm8yvVm8
         eN+rUTfS4kJHeg83ZvJinPXhZdPLE5R0FZ0rleOdcFvIboAiePmdsCWK78NkxYkku5WW
         dTNUjIaf8Le4FjQkXGnApNEr4F8NO2/l0KeYDkkT8riOlHAyYiMHLY37N+kGYAqmG9fj
         jZtw==
X-Gm-Message-State: AOJu0YwV3PbGu5pkZcnYTkCGK8UU+KP5FEGaclMH7+fGykQIxp9YYgzB
	hozGlpNMu1j4PB+sAPljiT+hBd8HYEqHndhIInVvyXskXVdEP4nBmZMAYGTAGQYmg2J7eTOlqNY
	Fub+zdep+/j/QKUcN6Y0y48O+PmHwzFRTOde8Yzs3DoC3BnRaV7JKdj3Stc4VMi0B3L0YKQ==
X-Gm-Gg: AR+sD10BFzTpyjtDduNSXprMDIbZRad43Duey6Y6I5aSHb9VwC7Of6s0nZj/DYh8BcO
	HIq1xHsFdnH4IFIu0jog6P7cPYmzfhWKvFiuTItOPCmJQBq8nGC4gJ2gI4ze5bMOrTNdkb7qG0r
	1obvNnQMaklfa8uMfq6e2Nzb2rPuB80vbk0Q1rZDKJCKbQG4r+tfZXTz9Jl7HsVCm6bwNGTn9IW
	3zMXm+rpVclOH+dGMTyyKW5CmjPG/xbnkzEdjvcnKK5laOm4Ie2UNVS4rm+ItOeWL9vhiKmkje+
	zKKdGwoNHXij5mnaMoz2J8Gkzq1YUkOsq5Dewq+tM7L89tlwiGYb/wSWis4S+adveNpN+Nzq95H
	aDL7uoljhrNxPvDPlBxdhzTf+Iy2E+EqH95L7myL1QvEVwWslgkdh
X-Received: by 2002:a17:90b:528c:b0:380:9f17:6df3 with SMTP id 98e67ed59e1d1-3903c5448dcmr15063977a91.4.1786018184495;
        Thu, 06 Aug 2026 05:09:44 -0700 (PDT)
X-Received: by 2002:a17:90b:528c:b0:380:9f17:6df3 with SMTP id 98e67ed59e1d1-3903c5448dcmr15063903a91.4.1786018184003;
        Thu, 06 Aug 2026 05:09:44 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085db4a6csm1469079a91.3.2026.08.06.05.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:09:43 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 1/8] wifi: ath12k: fix out-of-bounds access on TX stats arrays
Date: Thu,  6 Aug 2026 17:39:20 +0530
Message-Id: <20260806120927.3607733-2-pardeep.kaur@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA5NSBTYWx0ZWRfX4Qv3uWZTXfCA
 2F2FocFLVSNI3jcIAno/G62m5+NOvpCeNNqS+QgiZl3px0t/SA6vxqIWYvWvfOV7nEwbBK5Xz+N
 mu5KcEB5pZINRLkJr1tcRID+37t1DkI8uN+AWe6OZZTYga/DbnLoemEm2bh5XWTzkFeT0LqAQ1y
 p3Z4gV9MOapi727BKrMpixK9ncMlBpv4a6K1Bt4lrCsrdpHM/iWK3wnlt+Tjj/hTTCSYovBmd2t
 rw0RKkZ8gzea6l6FKNVbS3Fq99r7WiosLqwgSYQcg8HotwG8q1Kex/uD2a99iU1RC1XfIjsdboV
 WcnqwQ5fal5qm3U2cwosxWsC4clbI4wEtMi/vhMEtI4UIzDpGxWIXm8XrsvD08KmsAosfH2hKLb
 y7J5hQqdCdaw4JUCLTgVe6nTxkym9w+nadeUVxfOxe6CqmqrTp3J9icfIjkrCqrsRJfMCvxEaG3
 YYE4M0h5ub4pkZMQ2FA==
X-Proofpoint-ORIG-GUID: IZO0c8CIoXUk9HsWCUfJj4sJli2sWDO4
X-Proofpoint-GUID: IZO0c8CIoXUk9HsWCUfJj4sJli2sWDO4
X-Authority-Analysis: v=2.4 cv=LpKiDHdc c=1 sm=1 tr=0 ts=6a74798e cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=QbJcohpuGl3nbjs-xDYA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA5NSBTYWx0ZWRfX/Md0Gra74P6a
 SiB/AQEVfKsw/KFSR+F7b3XrEYXj4nKgiWRqzNfvdGuwKAdeCPF1ai693r1lDFBfuUX85a77EcB
 PMlAiN21/WSMvYBgP5P60G3P5ROcwZc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060095

From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

The fw_tx_status[], tx_wbm_rel_source[], and tqm_rel_reason[] arrays
are indexed directly by values read from hardware without bounds checks.
Values at or beyond MAX_FW_TX_STATUS, HAL_WBM_REL_SRC_MODULE_MAX, or
MAX_TQM_RELEASE_REASON respectively would write past the end of the
arrays causing memory corruption.

Add bounds checks using likely() and WARN_ON_ONCE() before incrementing
each counter, consistent with the existing pattern used elsewhere in
the ath12k codebase.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Fixes: c5c62287e690 ("wifi: ath12k: Add device dp stats support")
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 587d58eeccfa..632230e77802 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -582,7 +582,10 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 
 	wbm_status = le32_get_bits(status_desc->info0,
 				   HTT_TX_WBM_COMP_INFO0_STATUS);
-	dp->device_stats.fw_tx_status[wbm_status]++;
+	if (likely(wbm_status < MAX_FW_TX_STATUS))
+		dp->device_stats.fw_tx_status[wbm_status]++;
+	else
+		WARN_ON_ONCE(1);
 
 	switch (wbm_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
@@ -984,11 +987,17 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
 		/* Find the HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE value */
 		buf_rel_source = le32_get_bits(tx_status->info0,
 					       HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE);
-		dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
+		if (likely(buf_rel_source < HAL_WBM_REL_SRC_MODULE_MAX))
+			dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
+		else
+			WARN_ON_ONCE(1);
 
 		rel_status = le32_get_bits(tx_status->info0,
 					   HAL_WBM_COMPL_TX_INFO0_TQM_RELEASE_REASON);
-		dp->device_stats.tqm_rel_reason[rel_status]++;
+		if (likely(rel_status < MAX_TQM_RELEASE_REASON))
+			dp->device_stats.tqm_rel_reason[rel_status]++;
+		else
+			WARN_ON_ONCE(1);
 
 		/* Release descriptor as soon as extracting necessary info
 		 * to reduce contention
base-commit: 691e5e43b2aa
--
2.34.1

