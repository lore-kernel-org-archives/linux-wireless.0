Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2898F43CE44
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010873; cv=none; b=kdtw6LnIqd+Ol6Hjoz68UNAQzq9suniItXLlfQnRQo/PCyFL1Uu7AWdkMLHag3nzkaoaT5zqKi5oDsUu/bzVggyoI+QZKRHQ/XsgGWOHrUqhjcM0P+fGaHogd2oPPc3r0eER0FUEX2BZ4ujzgS/y7k5O1sPRzsvFgs4kTF2cAv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010873; c=relaxed/simple;
	bh=dmLcNqpwaTTw3J4bPmH0ozGrdD2cE5lZcumPOk/buMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=obQDiztaHBHK+2ivktR0TNz2hUBbUUjyS79cYZHJ3Y6+ucp98eTBWCmvi81HO8X4d/P7IraGgXkc2x6CnCT35j3fsLKBwlyfXZ6gSV73oBgJV9I/oHoS63n0KzhHIULadd9kmOHNPcAro7pHV3kXWlKuWdKx+nuxCX4NPUZwVUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LL5AlIlo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QJtJpYFG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LL5AlIlo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QJtJpYFG"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769o4gw1581636
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=8D0xqCaj1qh
	JnCgSAj5wvNviOsbNbNACQ6aFLfQJJu4=; b=LL5AlIloCHPBy1V9E2uc6ik4Fio
	TDIRDemnapTj9gew9WuQjpZM+eugIO4fp9rAg+At/0df2JmpO+e13vccPjOa20O0
	ioLYDMI4cJ5pRzhBUMPOIrZTibDx3mrDQdwOBP7Qepzw3g5UjJNr+BstsQdxAaEo
	gICvAI5s1KQIcrocMlK/UwzfIoaQwXJuI0n7XCd114KYsrWIeb4cgIIPBZCqw24n
	CVn8bbc5t86b3BHYwZeUxhDG5/VEuslATQRLj9rOnC4Jgj0Hjir/OvUUtyuHXg2/
	hU1JYIO4p21iT0XBJvEA9qP6TZfwM+/TTlMgvIfWnaGsImDnvrNe2zi8BTQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvmrjh0dv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:07:43 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-ca124bf0189so692181a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786010862; x=1786615662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8D0xqCaj1qhJnCgSAj5wvNviOsbNbNACQ6aFLfQJJu4=;
        b=QJtJpYFGmiY1rq7K22PJyHEFEpuIRd6MvEkaNnK7yOciQNIqf3D+yco9YuOT2LTFN/
         zU3BLVdaCmRW5dHi1OC7tLIPKCxym9j9bJ+8MdoOuZ9ZTAW2qLCWIEm2lUI1qsz2B5WG
         Lr84hMxgv2nFVAy8UbTwvHwUoCkzQSOtlK49Nv7ESQk6FpJ8Dj5KTDPRnxDK0RDM/JRM
         EA/SRgNwc+GCUUMjvP/93jNAJIVHfGe94iLXuCM1MH5SJ1ZIgLouPkcNdgq0NV5TLH2U
         5vUZffVRO9qj6joh+8EC3WeF36cHOdqo6ragAiqijeG6sDbagiC5OpFYevkp5fXhtXMD
         Sanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786010862; x=1786615662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8D0xqCaj1qhJnCgSAj5wvNviOsbNbNACQ6aFLfQJJu4=;
        b=Yf2R0ccHmZHoIngzw2WfMR1QhTUAl7LZUjeMCVmR90s7zdiGU0tgL2LS/1NRGukVwM
         JR9m4OCSj+zDtpnbzenMiZh5X9iSHpWchC7kGBtS0GZ5vzb36zqmlD+tRr6jdAVqXOx0
         Cj1vJUQ2L9BcGtZc07h5DRu8UrT5zxDmOv2lOcf5qcL8ccGoSSH4K84CADUcJPYRFD0M
         IjQH3w9jNGE24ufsfDLJlxzrHODpnKkn7RE6TON+MvFmdnJMWdXBmzbVO18XXUKYQZ7m
         knvJio+hEhc9yQBW20Y8BtvY2s/iZXh8m58q760oQsatEU14qdgXiXXXUQd09Q+E0lpt
         kI1A==
X-Gm-Message-State: AOJu0YwZOHzAdPFgZW41MJ0Az5CqwHCM7VGdkII76fCGYUWTNMhFAM3g
	KNuoEPx0R88yqI7sNv4zvoha9UDLdOPQNwgQNQkVT7an+lfkJa6Sb03uShqBLGOYb50wyY/Al8W
	rz48rlQIjrUkU7mHue6XVYhVh4Rf8ad16zKinqKCLQTvJM9qm/QCDVgaJHmHEbgk3HhFoIQ==
X-Gm-Gg: AR+sD11gz8VBcBjC2m//VK7yx628Vzv8nj4Xt4q6AAWenUMb8IhvLwlouCB3RlRhwYh
	O/9W/B2QU5uPU6zy1AxZylh94n10r1M8qRYiTj2bNDu8IPc9ra9Jva1rmLmYyTc6GTN0oKhoL9f
	mXWJWzBQkqMEO08ozVvVU/CcuDM3S+jjr7/KXhQ0EzBkHsFIOknekIklQX0T7ypO5RdYyZPzTUM
	R5Ux9LV15kTdD+PdE61ITLFwEY+5Qu1jVB/6WY4Kd4r+Q4AvmEF9APN3Puvsp0feDWfNuSccWUd
	XHYC/GeT7bxAVznkP9IOW1z2nD66tPE1SGXz+uwwxKjEQQajAlux+AIRyYylyNPJC9XMKVqk0eO
	5447Y+qkYw3HBm182DqDl+f8qUdUR0K9ud8UVtctuImsLKNCjdTB2
X-Received: by 2002:a17:903:38c4:b0:2ce:a6a4:451b with SMTP id d9443c01a7336-2d0f1c130bamr65827915ad.11.1786010862334;
        Thu, 06 Aug 2026 03:07:42 -0700 (PDT)
X-Received: by 2002:a17:903:38c4:b0:2ce:a6a4:451b with SMTP id d9443c01a7336-2d0f1c130bamr65827485ad.11.1786010861910;
        Thu, 06 Aug 2026 03:07:41 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0b6fbf2c6sm24027115ad.34.2026.08.06.03.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:07:41 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 6/8] wifi: ath12k: track per-ring RX sent-to-stack count
Date: Thu,  6 Aug 2026 15:37:00 +0530
Message-Id: <20260806100702.3479326-7-pardeep.kaur@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=VNPtWdPX c=1 sm=1 tr=0 ts=6a745cef cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=Ga8fF9AItmT7q7bL59kA:9 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: na5sHoJt8cfACG09PGZA-NBWW_i9d1wF
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfXx9IF8UoiMm9d
 sDwvM2UQ2emqPRWDrtjVpKRyi25dKQ3ljZKG4x0ulxQzTFLIHMprVTGCHsD3TW5YNAP3EMN6thV
 WvzmWyPIa53IkiWzzFHTLPD5QYz5RlY=
X-Proofpoint-GUID: na5sHoJt8cfACG09PGZA-NBWW_i9d1wF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX4qD5OK77uZcV
 ZfWjwY+r9aNsnzy6yMf0KB8uJdcZ98+7ajH7pD/iDDVPcS1WdpR/RSycpgkuBis8FcyfbrPURcP
 n900DfFxX08/WwaNT76ayx0VsF3jM/43/+YD3T9s++bGTis75gJzqMwJA9rLlT7LPyfswHxnuUC
 t8deNSUueh9AWtBqWRSUpmWeJsuQksJ3D3jQaBc+7oBvXeXNqSBAdbMG4nf95idYaMdz5v6lHAO
 1VSAOGqZ+9VocKXJxFQMQMJt8VUvpP58ivD2KNcKlmTo1u8QXXLXMdu5BYiv/7389hJE5DXFYHS
 qt88j1cw8NcjlI9WIxMmHoNaenF2P0xwmi+cdQHg9vABhQS0adsn1EXeZYA9+OthEDpss5q/5vZ
 oy5H9N8wG4YefYTqRS6Q0lSDJOI+4FRbpMHa6n6g+9LhH51jZdgWueHFTrvKaAAAekf4P3b+sgd
 +Qus9v6XWxJq3WhFTyw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060079

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
index f9653fb7b038..216a1af22898 100644
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

