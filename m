Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EED1B4138
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787117611; cv=none; b=AlQKBMWozA2bjUCXXFr9UbKANSUugDBAfxfU4vn6MPVsf5PkSAdyQDBKZeFeU2C8UPue/dCH0PzvGBM7QjTV7YQNeR4OFB1KY3lIroDmzN2PABNmlqR8OmtqULKt2vDU7TCKa6ufI81Ewt/bRdSLoPDED+Kov6nOp1g/zejIzIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787117611; c=relaxed/simple;
	bh=oM+5O+De8HM2drsn7Evo5vABvSfZCO668B30L/AVHeY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YJM/GKWyujwNheRjCl5OgV0Bl7jqS+H8NalImkCEWkw/SkHcq6+NYqj/7oIlrDL2BZXF3KBcp/5FNi9NhSDpz0eubxVTW8REahA+kDXxy2ANZa5R2QYI18pFHwUVdmXTynyRv8q+Ep1BqHR2vcLQOne4qnRXZ6rT+wCKjao3XFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ajgY6QB2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=j3T5UzXW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ajgY6QB2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="j3T5UzXW"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J5IHxe2285460
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=+Jl+qZ1wHSW
	vkymy30nUvtpy1FLQdNzxtXxhzWo2UWQ=; b=ajgY6QB2hywWiMV/l5a2HrLqLuD
	SRb4MPOgT/CEOd+CbBvdKg0id4XGrSFJ78Y6kDLJxAKIOckeD94wm0q7kMuNGkXN
	VIPy+5osR+ClZ0x7XXQkTB+OHMMVA8HVNBIlRsbKuDXGGSvuEF8KdZNlfeSKCWT1
	ZlUX+NtGfSL3akG2CHydOVhPGm+V7zXEhzxdBtlpkpV/XnmubYyHStoA/XwHQP65
	WBcAbBs7GOGm1M3ru7YtraK+/xYPob7a1Z1Ilh3eBFmbnAKSnCpkp7OQkuVewHB7
	yWPgm0A25URXNNrnx0mcc4Nbw0FTd90O72Li40D9LuAogYuNG9SEPXL0DZw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfk9fy5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:28 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38fa7b09921so1197599a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 22:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787117608; x=1787722408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Jl+qZ1wHSWvkymy30nUvtpy1FLQdNzxtXxhzWo2UWQ=;
        b=j3T5UzXWySh2orWB1XcKvUosnchzRe9ILMM1ondXJInS+5xgiJwKq9Wdm89e7VEHTp
         3GAky6/UNF4BZr8hOYkn+f//Rfmpuj7vMw2/Kgc/5bqyXb9vzLDuadNyvJU+AIs2MYW8
         6neXScpDks2DLXdQAoQN8iw1Uv6ilFx1rLBV5JYYFsalGbvpRl+EtQgdgz+z3JKKgfbr
         vnwkm8k23VLmC7HdOQNnNFpqQCuW1zeefVdQnPPm+BU8ET83VzvQj6MYKhVoO4sdOjSA
         c3Df5hR0ArqCLsUUsXEQAMfs2XafLByvY1OmJthtyP+Peoogm5k6ZZKdNE13WHBu6LEl
         9gkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787117608; x=1787722408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Jl+qZ1wHSWvkymy30nUvtpy1FLQdNzxtXxhzWo2UWQ=;
        b=lTbUsnBByv9ErKox4V2/0uEO7wm6SDVzSFAOl7qdbru4Ocabsm3uRyMv3cMMlcfuVU
         70lfo+rYTqbXqXHnOfBqFDwPewvYV9tZrNJYRmuwo+GWGoa/clbdRdnjAsQQ0OyGjoaM
         EsL+2ufXdbQnEVrmlg9SoY3AOgC8OWz/I40N6QyP6ThIA/nFgum6/e5+mZiL6ae7WS4z
         iPBE6D2YC2wGULi1gSrQF+8J8V/VbPEXXydmupcqxyBdCj5UbLsctj8RVs5nWh4DqL8A
         8ltctkkVRKgeU8jtZ0rolq+Pjiwt9r8PvlYPRVLkPDZrahydRVSpGVIB/Vzm0UByaggQ
         557Q==
X-Gm-Message-State: AOJu0YxlsZeCV+B4YXcqeoJ8T63TySW4T25kEGezat6iLQNQf7dbiAkr
	Y4+I+ZWQkAKj8MoCnZb+KaN3k1wMA1nrFoZGN5Zl/LB1+hANAlX5aqGyjgdIkCgEgcCJ77fdm9z
	/gx13LREBO8iamOGEsdUNhEqOOQUzuTYHI5TFHn6oifQX7JDlVmfz/ChjIkQi0/Kf/+La+PuQN6
	EgtQ==
X-Gm-Gg: AR+sD11mZHlhjNQ7DNZoacX2Q8/eQt/pcGVl2Nw5p9jCTFBTeUFFEcszJJAxQ8hDJcq
	gChDmMp3HWgv0wF/6BwvHrqKq6Axfga0W7/4S2jCyRt9ksSf9DRHIIrdjpZYRUn5hyEUmgPHHPN
	T7ZYMnk23HQQWlAnuyBu0ODxRybQptVERrgWxju/ysunXO00R+rig8JBz6QXRlQA0ZHXMQUHonb
	RZ4ZEElxofpz9muqwHh8QWB9KTvCJ7wXYR7cXCR3t4q2RzAkgT4Pyyc3HCCe59fduHiKnRjQQ7t
	fzQNkh8MM5zQ8efCjJqzxLIjr8ExOba/nkkFep1HV0DCNmQ5qUeh35iiJb/nP+k+7M/FMNVLOX6
	UEYXjB3pa+2MdTC/uafO5eWi/TUhC+yZ9w6ny5LRZOoK7tD0dgI+P
X-Received: by 2002:a17:90a:d60d:b0:390:8361:a532 with SMTP id 98e67ed59e1d1-39580bc9ad4mr4225690a91.7.1787117607786;
        Tue, 18 Aug 2026 22:33:27 -0700 (PDT)
X-Received: by 2002:a17:90a:d60d:b0:390:8361:a532 with SMTP id 98e67ed59e1d1-39580bc9ad4mr4225600a91.7.1787117607354;
        Tue, 18 Aug 2026 22:33:27 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f4c9918sm404261a91.0.2026.08.18.22.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 22:33:26 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v4 8/8] wifi: ath12k: add WBM SW desc fallback counter
Date: Wed, 19 Aug 2026 11:02:47 +0530
Message-Id: <20260819053247.1420393-9-pardeep.kaur@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=PoGjqQM3 c=1 sm=1 tr=0 ts=6a854028 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=7LnAo4KMM85IVg6JStIA:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfXyjAVLINMbx5F
 FG7H8Vpcb0UapO8W2HHxXXip7q9xte8mRtEEKs1P9PvF67BMls7yvQ9HuaezmI/tGpXVdaV+HWB
 7bmiy19ICYstPfz4u2JesI6I29DiVderc+hIJIch5fTRXSr6lPojhQcLrn4dhKV6qv2fzqkbksD
 KDpcJi9J08U2Jlb1324XDQN1MhMomGpbhC0OrliErd3xsc1WgdD1WNlZmvhvc3iTnDmeL3viKpx
 mZnnIRXJ/G+D68HLWy3v3V3+zs+cK479juP9cY4sXABza5x1ovUu91EjDOwiO2I2Poxqwtj5lEo
 rXhI5ymzJV9jlx0TOCER7oODBG0DOULdkDVU9pzNoTEuzp71TolmbAtL1Fzg4qNSzfcxaAEdp5A
 pjObDPLkIJNbF74NoBvsbM7cCrYDyHyUn2+0AIA7LPwk9qsm6FRKKEu3bAXUEM6QGbELzmHF10V
 YVKIndIBSUZbFrFeB8g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX2gUNQecJpC35
 5FWe88jFCbiperPx9tvLmpr2UEt8i1WDF1Qr1TnSPDTcmuJ40sIhqyrNRukFl9cP3f+DDAHIP7y
 3yDjTcDVeozwuKRx8rU4CHRdT4CPlkc=
X-Proofpoint-GUID: nd3USwKLgGZ8GMY2UH8uXkSoty1ubDOo
X-Proofpoint-ORIG-GUID: nd3USwKLgGZ8GMY2UH8uXkSoty1ubDOo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_01,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190039

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
index 5d6710f1160c..12791e267d1a 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1132,6 +1132,10 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 		len += scnprintf(buf + len, size - len, "\n");
 	}
 
+	len += scnprintf(buf + len, size - len,
+			 "\nWBM SW desc fallback (HW CC not done): %u\n",
+			 device_stats->wbm_err.sw_desc_fallback);
+
 	len += scnprintf(buf + len, size - len, "\nHAL REO errors:\n");
 
 	for (i = 0; i < DP_REO_DST_RING_MAX; i++)
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
index 5325d271fd6a..25fd8bf7858f 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -1968,6 +1968,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 
 		/* retry manual desc retrieval if hw cc is not done */
 		if (!desc_info) {
+			dp->device_stats.wbm_err.sw_desc_fallback++;
 			desc_info = ath12k_dp_get_rx_desc(dp, err_info.cookie);
 			if (!desc_info) {
 				dp->device_stats.wbm_err.drop[WBM_ERR_DROP_GET_SW_DESC]++;
-- 
2.34.1

