Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA29C4BCAA3
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811331; cv=none; b=NjEC6SZ+YjaZ9QKkoppOPuxUxaIV6RODkfUIUnOE3XaxmYF4ZHlzUdF/H2uGNjGSWR8fwUJ0ZG2Znpq9TI4pNDjWFb6GaU3lI5f3EopSrR3V2DC+TedjmrRP2TSwpjorSyBYNSf1UJV/HNq8vtTK4bpIqypQonoQGQfuJtOem+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811331; c=relaxed/simple;
	bh=ds4dWSodscTZAOTg4J6+pn9fF/Ehqb34/MRIzBSQmkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aGT0IEXPXv7YEIU57TJUqlpzmSKbuam3+JsqS/iSx/yd+NlwqTl2Gb2SkIwqcrHFxctj3IXSeKMbquUIhLA2/CYgKAJDs9ikOR7l+M6s0byMICLnxvMJa7awetPjnbTMVr5JxrpHK5kywQNbchl0IBpS5utD1rrZjFkPRCiTSgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BA2oeTSf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Rdp9CL1n; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BA2oeTSf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Rdp9CL1n"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N9DmPQ3567738
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=r4cMbFiKIB8
	ZkelKo41tKpaulI1Ihv9gr1+2sghJ0kw=; b=BA2oeTSfhCjboG7MYMIBJV6bWig
	MujE5tCUIxmCJaKx61nwokH3QDwzYydBwY8DuwGaoDZx6BuvTCI4rtkDIvPuAc+d
	p1s1eTNOFJvOd1HQl+ZEPwhgNWpiSksBBiouV+h1VeBxDATEwo1xKQH15e3cSWJI
	RTJJB6I8Pn5hqhJyYT13C6FoRIcHg7vWhEkYBU/h9ovLQAABTU50QeTFVm43LNty
	iwaO3y4ElWnr2gCkruUAcQjqDyWbYHGtkUIUmXqxJcORkr+S6w/U8nQE1lFIMu9K
	gLSA1q7gaaaabSbcqBN6eX5ZKXH8tQS1ZHeoZTqe0xcFsL+n5TcCA06SUYA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkg520ua0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:28 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cc86a9ef97so15579285ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 05:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784811327; x=1785416127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r4cMbFiKIB8ZkelKo41tKpaulI1Ihv9gr1+2sghJ0kw=;
        b=Rdp9CL1nzNBVLKx2VDPNPt3QB3RggSLj0EylabNnnROOnMGZHic/IvsbX0AXs0zVBO
         KNQ3vUZRwEUu0sktLN15azT2YHtab9J98wOQz6L+xk5w7+EeWhTxnVuDKsXHxTRr+CYj
         e/1Okj1IwR9wzYgzysGUfyhvA9mZFlsxc1/IJNsQc9mpIa9ynG5g8AA8MvwKNtWVQDBy
         CQGj8vt08bVNQHvd6Mgs//HCmWcf468Sak3LtixjWwUVBkOJA2/VT2VilSz/9ihDb7dm
         G6YCJBe8O8c44OLpMjwGNNkW8bw7C/2nAyOEKzi98fbn7oO9YO8ByG5sY25dPDWgs7dE
         mvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784811327; x=1785416127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r4cMbFiKIB8ZkelKo41tKpaulI1Ihv9gr1+2sghJ0kw=;
        b=edxvZJ3gBUfvG9NXGPeJ6zXWH841tIU0A0Ly9Emwf0fumguybV3qyie385ILu5o+hU
         HsiEeHO9zkyMyCe0pV/bCUQpx9mPNIU/Y2XqPXZOGwCOP+LYPxt0b2f3YHANC2iD3K/r
         wRnqCjl/iTHuRF6xEPge9l5aDvx7m9Q5d3V0Yad6ZwQQPFapNavztZBE1TzUFnfqmmxS
         /dQ+8AJbTgtP/E6ZovSg5gHG2CbsD1fIRYEa5/H62dSSTef2qctzi4Z/d9Pxn0IRq/Hb
         kCLdp0KcSpPpOhye5f6sG5SReUCZZj5omLTdnVQjlPnnyPM9I7PpHMGxBaeseW9DJhGP
         AJoQ==
X-Gm-Message-State: AOJu0YxkWekkaDDMc6K5g2WoW+5x5cymW4fk66QK5mhyrZ/iGIaXvs43
	7TmYE5i9u14X5TK9i3YDW027SqKxx0JMKjz5SbR5rPkVt19WoyAiWoO2vvF73CNs8i4jExKWugU
	Wk6KyecI0Ty+/7E3eZ1xuOC81YtqUvDcVKARQVgn8ltgJsqxQvArcwsCCnI47wqCV+fMQNg==
X-Gm-Gg: AR+sD12gHhchkDtayZGMDiMYg2Yi/JldW++k/Tkx02nR/Xpzw6z19FoeyGSl+04cGVG
	Y1pU3djN8P0d9yTvwu7zDqKsKEEYc2ec/KXyCrdJs1OH2zaRiyZUO4tM/SvwvL782bwY4Avbwoc
	iHWAbURikmDjVvPUkNIsJ3h+WBDuwpO7Wp50MSCkBHXMB64QnXBJ4MGbvhQpCkf9JNiCii/8CPm
	YwWNKZ8dn5CX3qYq35+OyOCchpVIJf83MkiUoFhhtS1gRtMCfJkx0PIhdoTZ0ThTP1WKRWkPzTp
	puGYSyNJ8VB4FfjnJ8QqoX4Bs8zVBQ2rrFzvWHqiFQH2zXnx8bLsoMjjJnZLTs46gNCtSmfbTnL
	VSXWj0LumSyX/zIVOXRJnoVwwFIrcf/8prE9Mrf0kV09q9L+mUWPX
X-Received: by 2002:a17:902:f693:b0:2cc:d192:50b5 with SMTP id d9443c01a7336-2cfa75078dbmr36610195ad.34.1784811327171;
        Thu, 23 Jul 2026 05:55:27 -0700 (PDT)
X-Received: by 2002:a17:902:f693:b0:2cc:d192:50b5 with SMTP id d9443c01a7336-2cfa75078dbmr36608425ad.34.1784811324202;
        Thu, 23 Jul 2026 05:55:24 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f350475sm32998385ad.70.2026.07.23.05.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:55:23 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 8/8] wifi: ath12k: add WBM SW desc fallback counter
Date: Thu, 23 Jul 2026 18:24:48 +0530
Message-Id: <20260723125448.922361-9-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
References: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=DtZmPm/+ c=1 sm=1 tr=0 ts=6a620f40 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=7LnAo4KMM85IVg6JStIA:9 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfX92z04Apx1zdy
 Uz0T/964+hHi/YVElmsVx3vNS+7LEK0+p1TKm3iFy0bfpaULk4Wx6nKWM5hUB0Wwmc00wxxWVvo
 K5rnb6iE09obiq2skQBqzuOmLibssS4=
X-Proofpoint-GUID: Uwu5aOPTPloOAT3-O80MNEIgPRptZmH5
X-Proofpoint-ORIG-GUID: Uwu5aOPTPloOAT3-O80MNEIgPRptZmH5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfX+BUCINX2T4G/
 aGVzojxQAO22F/aI6XUDoeqPz5cWOFbbLW0tGOt5TEkVVjQargirdrBly/AH5TndxD3RVawwEir
 o5DR+0NOXo9ZvBc4s3GX9p1rrH33LZQRGMvnwMQqHUj6sW1uVZqWk2zECr9vB4i5fZI75ucI4XM
 I+DGCmwNRsGL94d5zIbtcICnHrHRhMxq9o+HqWBY7mcpc99pfGtn0vGxWtIL+I/VCr/B5TxOVYB
 ePrNhRH9r9iygEWgJlryjx/AnZWYdY6IJe6nuOKOx4ECfUer4Wt97keLGcNpEOF5QFt/VjTpak2
 uceQK69TRX/1R7w3/N8XguOoq+laliPRY0ujMm3pXIbha7xn8KPu1xineU2UwrRiJpnGlASI7YS
 eq/fiR+3oZf6c2te35gVXxf65rFYX+k+VjjBxnj7F7EXtVFoOANeo7O1Rvl78MABsfVcvBjxgaz
 cfmUXitz35ULc1+Mo5Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230127

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
index 4176c837a6ef..534e7d13e66b 100644
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
 	for (i = 0; i < DP_REO_DST_RING_MAX; i++)
 		len += scnprintf(buf + len, size - len, "ring%d: %u\n",
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 298b65142a0e..af176ee7d89f 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -441,6 +441,7 @@ struct ath12k_device_dp_rx_wbm_err_stats {
 	u32 rxdma_error[HAL_REO_ENTR_RING_RXDMA_ECODE_MAX];
 	u32 reo_error[HAL_REO_DEST_RING_ERROR_CODE_MAX];
 	u32 drop[WBM_ERR_DROP_MAX];
+	u32 sw_desc_fallback;
 };
 
 struct ath12k_device_dp_stats {
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 33c4c89eefb5..9b6d04783c6b 100644
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

