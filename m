Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34EB3FD941
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786373113; cv=none; b=F+v/mfpEit5ijxf1w9mWnlHu5x4gWE7TYM3f+8NihA1PF1ovgFfZMIaftSoJHskp2y9wjV6FqGAwV3Z/rp1xZl3eVkVIjITymWiLBWCirCv+CVZyGz213TmvV7cRk9hgrXqJUPFXdOVl6zDDVqcmJyBqAxgRzwABXWCK+g0Ytr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786373113; c=relaxed/simple;
	bh=2zlzV7mFwLXPIwdVhJ3wMgJWgDCjS5W4SsSWhfpu6Ps=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rEL3DOSceOK++g0ANIju9n1BhFJC2cRl3EVLj649jFROF969eF2XV9BqBhBKheXuWush3Ruko3lc21d+lfQv1S7ej/ITxTcG6w9hxidqJ3pn6ElqBk25FD3BY+8uKPQzaeOuaoS7LzOdCPYsQxsi0eEqytW6UbAeDVxa7BTSkbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ezHTsuou; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ioms3Rab; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ezHTsuou";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ioms3Rab"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACjFEQ1650912
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=nN23UYXuMIW
	N30eL3QTIWDdE+NArLTWZ45CYHM8qis4=; b=ezHTsuouuu23K6V+vfCFUgyGEtq
	rPbW9bX/ehdY06lEKd3IvMSObg7b8AhF786TQ39g5kyo9XbY+ODxkT5cGW9/6jDl
	AjxktgcM1e0MvNbwLIwVmvG3abxIQmLIVXW6tokkfvUiHAzSt5nLlWFrywSAHHcR
	KpLx6nXkejOF4ymcdK6neDs1OWG1tjNq37ftpGItbU3q1ZWUogRGdEjJPvkNi7ND
	d/bylAP7vlx54O1KYTb8g/OXJBeMSAyjllel6OvnFn8EXraqOF/1o34GjMJq7jr2
	sfv7ovLqTU1nu5vL72jfS0+d+ysaUgblSjNL65luZVYzgf1xUcvI9vHdfGA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fy8vhj22k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:10 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so2672358a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 07:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786373109; x=1786977909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nN23UYXuMIWN30eL3QTIWDdE+NArLTWZ45CYHM8qis4=;
        b=Ioms3RabhQXeE9PCFAVZ3NjFErZ7u6fnoSSCcrt6tMAVj412S4cy/iZTZ+hO2HSE/Z
         myL0VcYN9VxRl2Ewd93HlyFPOgbifjruz447dMi9qJ98gW0ZfeUL9njLKb/wZyo0gUpI
         7CAOmTJ7o7XpH9Imnz4+yaefd2i3RB5R723FyO9udn0fipgPiEajXB6OLLffUeySzrth
         ByR6D4P2G0tLCR8wXw5IrPSsHezbCbhRRMxena9Wpbs1UfxHED4xt2X8g7dq38UCoZ5m
         qlHUnIQj9oAk63LxvALSF13PGxRWmPA54zTfmIY8ijFNz1F2V7VJq8ATmygtolBZw8uY
         Jl3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786373109; x=1786977909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nN23UYXuMIWN30eL3QTIWDdE+NArLTWZ45CYHM8qis4=;
        b=cxPw+a1BaUvesm2N0h+g7isQvZIQYkVXTKdpGIX7z+EihsUNGuYj4JvWdWto4J2WBU
         gGQ6/RMDdlFJM2ZNsiJtM/sQLDbe9MaRDAYNG4ZotTDGq6g+yFOr1WedYaEjKL1xiTKX
         AyQKNOJ+mhm6qu/g+Com1zlHU5DHnuP+zlSc5ZBNuVn8o99508AwK6ZMuy+sQZLuxigk
         6Ak1LE+M05pEMFkQQX0RWVRzGbwwRqWoUzuYMO6y3+lM05tPRGpk8Yr4QCTdrnRIqpvB
         SWFzggIdCsKBkiuOQLr0tu3ASYvCOqxpHoBtf+uT6Emao79NYZz07Zeh8ypckz7hJWLk
         5y3Q==
X-Gm-Message-State: AOJu0YwC77ucDaaEP1qChLCXOxiFVrIN4nQc5FD5QmhqxdIPKo6S4Xw0
	1fHU5s6mb9z15nym319e9CvRo8DEhNd7lDNi9OchlqcGPV4pRRWkD/VNGelxX261YrJdKwXmcQE
	1tp4Q4AnFgtRUhCy7sxRdtU+rC/YB70ezwaG4KAXIcCMvXi5H4LVg0Itp2dCd1nb38RY+fg==
X-Gm-Gg: AR+sD117SEsJ6RIyQdKzLdXjPkEQuHLiyyZOLBfIjJ9hZny3nTkw3Ba4YyVNMpRMzhH
	IGSNs7f4gt96hlSE1QP8KRMEiT4SKzS7z0WXCR/89QReiAuJ8T/ijzmqFBG8kAq208123chkA7Z
	gtGvFyKLVNtlIXj/c3azfNnMPmFrsAUHSMSCPHcdu2gN39aSAwajSGQvMH+OIJPftTOqQbQ82MQ
	akFQGp9c8W0Fb7l0Fo5im4ZhwZZ7uGqjSCEqNuV9+2IqoF05xHp02Jost1d55/AYA5Ykwd4idg9
	NBMlTfddo/E2YkUOmTIcPTwPDYZ2HlpnNt4aNUIFtBBQWHSVQTWiRfaRq35ZD8d+2SCntoyhD1w
	DJWsEd0X7uYbQg42je4EdWTJoYDUmOTEWR8WtwLrBnPWgSN8+v4jM
X-Received: by 2002:a17:90b:2649:b0:38f:5869:387b with SMTP id 98e67ed59e1d1-392cc937909mr2366391a91.9.1786373109195;
        Mon, 10 Aug 2026 07:45:09 -0700 (PDT)
X-Received: by 2002:a17:90b:2649:b0:38f:5869:387b with SMTP id 98e67ed59e1d1-392cc937909mr2366331a91.9.1786373108725;
        Mon, 10 Aug 2026 07:45:08 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm12797317a91.2.2026.08.10.07.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:45:08 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v3 6/8] wifi: ath12k: track per-ring RX sent-to-stack count
Date: Mon, 10 Aug 2026 20:14:42 +0530
Message-Id: <20260810144444.2033607-7-pardeep.kaur@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=MMtQXsZl c=1 sm=1 tr=0 ts=6a79e3f6 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=Ga8fF9AItmT7q7bL59kA:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: mbU8T5W4U-2F2vctR4JS2H5Uvb_2Wv73
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfXx4JFZPDNGxtA
 GjEJShg94J54NmH2tCog0EE8l5TjBLejDwuEbn0dvsOzE3UVxJWBLP+rwTfvKdml/dGXD2uoysk
 cyodVU92hjBCqM8RoMaZgeIdM3I0PK/wjxPtIqFY6qYVtc+ZprmpZu9JWJvr4ZhCBEMIZESeXW+
 BhPzbenLyYFZBkNrOZxbbowIs3qmf+OYfneJbDydtsX3B8ksViBmQLvd0P+BR5B5Yvscs/rMZHe
 zqrekq7ttnOvMDBE9cZCwh+bxwM/R6n4bnGikKp8hUwApd3r1FjUr9i5D3/yjSL5AE5JfFhVM2a
 n/b0NEYB8+0FvxlonPeGO6pT8ANbVgu5+B4BP/aM+mPU4VKxTmc/Qw/B/RIMi9Av/6W7j33hcfh
 1t7GTcADwA9311jx2AWG5g0GMeEOKw2SaHllP5Hbc/4LJb8GwcCz0HM+4N5V6wos7oFiyBOnvKL
 euc5pXU/0m2m/C1NOpA==
X-Proofpoint-GUID: mbU8T5W4U-2F2vctR4JS2H5Uvb_2Wv73
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfX+BSetZ4XMy1m
 rUIvwloaB0Bw8Rjs7O0HAR5c/qL8qM2DNbT7gmsBy2FD+OpueZBKY8EBBL1z68FVcDRfpxLVmJn
 8JjkoUnV6NW0e67m/6IGB/Vjl3EW840=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_03,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100126

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

The device DP stats provide visibility into RX errors and drops but
lack a counter for successfully delivered packets. Without this, it is
difficult to correlate REO ring activity with actual stack delivery
during debugging or performance analysis.

Add sent_to_stack[DP_REO_DST_RING_MAX][ATH12K_MAX_DEVICES] to
ath12k_device_dp_stats to track successful deliveries per REO ring per
device. The counter is attributed to the ring owner's dp and indexed by
partner_dp->device_id, keeping it in the same debugfs file as reo_rx[]
for direct comparison in MLO configurations.

Increment the counter just before each MSDU is handed off to the stack
via ath12k_dp_rx_deliver_msdu(). Add a likely()/WARN_ON_ONCE() bounds
check on ring_id before indexing sent_to_stack[], consistent with all
other new stat arrays in this series.

Expose the per-ring per-device counts in the device_dp_stats debugfs
file under a new 'REO sent to stack' section.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c     | 10 ++++++++++
 drivers/net/wireless/ath/ath12k/dp.h          |  1 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c |  5 ++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index 34c605b609cb..55e3b411d108 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1122,6 +1122,16 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 		len += scnprintf(buf + len, size - len, "%s: %u\n",
 				 wbm_rx_drop[i], device_stats->wbm_err.drop[i]);
 
+	len += scnprintf(buf + len, size - len, "\nREO sent to stack\n");
+	for (i = 0; i < DP_REO_DST_RING_MAX; i++) {
+		len += scnprintf(buf + len, size - len, "ring%d:", i);
+		for (j = 0; j < ab->ag->num_devices; j++)
+			len += scnprintf(buf + len, size - len,
+					 "\t%d:%u", j,
+					 device_stats->sent_to_stack[i][j]);
+		len += scnprintf(buf + len, size - len, "\n");
+	}
+
 	len += scnprintf(buf + len, size - len, "\nHAL REO errors:\n");
 
 	for (i = 0; i < DP_REO_DST_RING_MAX; i++)
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 9b57b2170b60..5cfe2096c633 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -458,6 +458,7 @@ struct ath12k_device_dp_stats {
 	u32 tx_enqueued[DP_TCL_NUM_RING_MAX];
 	u32 tx_completed[DP_TCL_NUM_RING_MAX];
 	u32 reo_excep_msdu_buf_type;
+	u32 sent_to_stack[DP_REO_DST_RING_MAX][ATH12K_MAX_DEVICES];
 };
 
 struct ath12k_dp {
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index b203513d63cc..60489cfd4e54 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -651,7 +651,10 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 			dev_kfree_skb_any(msdu);
 			continue;
 		}
-
+		if (likely(ring_id < DP_REO_DST_RING_MAX))
+			dp->device_stats.sent_to_stack[ring_id][partner_dp->device_id]++;
+		else
+			WARN_ON_ONCE(1);
 		ath12k_dp_rx_deliver_msdu(dp_pdev, napi, msdu, &rx_info);
 	}
 
-- 
2.34.1

