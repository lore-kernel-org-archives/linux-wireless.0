Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D8530274D
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 13:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786022708; cv=none; b=LvTqweLez22JAHVuQcSBVgr2cviexieObBj1pXHTMOzj24hLhcpQ7+0vgUFndvUFJqjtB05oOt55W69ZpTLbB6ECAc9W2LRkk7rVW66efpj4xQnPo1cLfJJAZDVHNHn/P2J/9SR3Ya93ARyvI8r9jrOq1wo3UZHa4sIERiwLVd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786022708; c=relaxed/simple;
	bh=dmLcNqpwaTTw3J4bPmH0ozGrdD2cE5lZcumPOk/buMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ev+4JXEeJmYkzbhovetf6PURVG4EIc6BAgbmUAtovl4hChnyyazDGTmCD91+djijDT8jOejAmsETLUZi+wQlZ/C+KIRtTJ+oeOhDnAhZ0o1nw4IuEkLeMb4KAxApj6JAl4L3PAalA9AX3VTAaglcv8TE6tQIPb8sxEVFTyUv8/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pkSxIwQJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ox6qb9dk; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pkSxIwQJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ox6qb9dk"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nrHX1228396
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 13:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=8D0xqCaj1qh
	JnCgSAj5wvNviOsbNbNACQ6aFLfQJJu4=; b=pkSxIwQJnxI/t7nCIlbu7+Kk6D+
	xvit1kFx8XxcBQCBPDDKvPmW7BSvLO684Qtgmg4scLEqfBI9hZv6GOz997tDfym8
	OX1I7v6XY8fq627y1OC3IwTlqX4zT6Ovx27ZXhvj0JNVW9+5vWbtd/kYEmIdRNjf
	gVXsLASc+lRVw2ZwneGFrCYgKI4V1BCpURp5pVrIcYdqXfOMIH03DCUAqKJzHMd0
	jdPDMZW4XYo7QdiA/LD4lQlqCG1nDr4dcRZrN6Q55vp7xVcbYFlj33bM4xk9dGXu
	k9HuYCAwXl/+lVdCIJHirdZ50ELpRjsJ3cdUi6sO70X0y+GQPYyNS70ZZqQ==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvqduh5t3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 13:25:04 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-848860def2cso2587802b3a.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 06:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786022703; x=1786627503; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8D0xqCaj1qhJnCgSAj5wvNviOsbNbNACQ6aFLfQJJu4=;
        b=Ox6qb9dkM9sfin758JvZdjASwpuITKeAyru2V/ilOAb1+GD4RZ5kL1IrQH2e0bIXVz
         ERYPdzp/VkpHBKvyyr3f+Jre+SKQyNK7cGlQpixWgRQ3gLFctTUnJZsv//YRHLG6j7gp
         9p7Pf4BtyKzzGuBADK+CbX9P1DgcpziENZTFU5uLS1Nn8CFDbvKa+1gz6OoGW37woyg7
         zGjab/Q+esgfJZnK9jaWqx3pIARFoxYL3M3+4Mn+d+n3bwRUN6G0K1HMWMzYHsMQiEff
         SWHr9JUxUQupFG1NOdh/DNMMf2x/JtvjbtNoTBIRm7B5Q5wupE2NKlg/Jp2KsL0l2/lZ
         9dkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786022703; x=1786627503;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8D0xqCaj1qhJnCgSAj5wvNviOsbNbNACQ6aFLfQJJu4=;
        b=Lh8pXjEnx8vMhSJSA0F5Ldd93NzC4o7CesCDZxzMKJyqiKb/vNroMob3QkrjobShI9
         gx0tgxfH5uJ4Oe3G22uYOzxQwluuD3WUmSBD6QTwj606IQzgRgSmIAZqHrKIQBswov9T
         /MHyNtc+zbqN/LVUhtnTlSQ1hPtcNzvX7BFIUn7Ly1Wh1ea1laLNblvVrppfGy5fy5JK
         cw3slOTvYYSgl2wdS1g61JlyURV3UnOGwibk2R7pYSvG/C0FE02nHLyhdtVzrDGrDueK
         6mxzep3Ghz3+0/ZpprIe8vvews00fzIqRM7/COv6atGMmV4CV0vRytuPwCMft1h8ecch
         SSqA==
X-Gm-Message-State: AOJu0Yxmx4BILuq0CLPxQ5CQ8t4kO9ZpPbWkUnC3Tic4cFJuIftTUybR
	ODdyO2ddRB2JOWjId0ZkFHP7UUz6BW5blI0p0IL3kpsIDgxfHtsTcOKk9QXT/6MdfIuCxmONd4X
	HJ5nE0msTrB3oCtueShYAzqKz/QZG1LNTlYPUq2c4RmvQnI/GGs5/n2JeNunXEUW3/4SZKZvU16
	CHOg==
X-Gm-Gg: AR+sD130pS0XDt7K01GxGfPAPZ19zUZTFbK8uTicyMkYcuPaNMouJtBlZCOBL59FH0N
	rBSDt2TleE9frZLkjE0sFTUoX2nMbosz/yHhwCRu05kvYJ5RwIhj2li7dXVAnGwiLXYG+Vmixg/
	bH+ebcJfIc/jIwWMGjW9mkj1bmsBGa+jXfAuxfGNZhIlHuzc1vyJmPWQbq/qeMhUozIcfRKqWjk
	TRXlvS5gqPpa67XiHHba8psvOJ0lHl2G0Bd6oTtBMoueI4DfIaySuVNNjo3rJeXm/5mzLiz4LCw
	s7rjkLHnAfQ+pWrsCCc/kRfrvUX84ddDnLmQ3eQiQra6/3KDJH0JqoCCRk9RP6qL1brvyAJhe7t
	zfrG1jo8MuDsx2FNYb+PvLHX+vGMcazgXII+7KzttXBJ9245hDBP1
X-Received: by 2002:a05:6a00:3026:b0:847:770f:da4c with SMTP id d2e1a72fcca58-84f2e04663emr16464775b3a.16.1786022703500;
        Thu, 06 Aug 2026 06:25:03 -0700 (PDT)
X-Received: by 2002:a05:6a00:3026:b0:847:770f:da4c with SMTP id d2e1a72fcca58-84f2e04663emr16464711b3a.16.1786022702969;
        Thu, 06 Aug 2026 06:25:02 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f456b785dsm1411637b3a.36.2026.08.06.06.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 06:25:02 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 6/8] wifi: ath12k: track per-ring RX sent-to-stack count
Date: Thu,  6 Aug 2026 18:54:25 +0530
Message-Id: <20260806132427.3704828-7-pardeep.kaur@oss.qualcomm.com>
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
X-Proofpoint-GUID: KotWq5QHSI4_ASaisx8-kTBxDnIKyXpC
X-Proofpoint-ORIG-GUID: KotWq5QHSI4_ASaisx8-kTBxDnIKyXpC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX0OZ1d95nPYLp
 ytHACIDtfUp//NgTiumal8ZXNhgbTpHTrrtX/OxHSr7EsVcQpu+aOZPTVqpE5X7Q+7BHwjBqQSD
 1MWh2bPXlr0dIilKsx3Jshix0kqIT1sPPmJ2F/pWhEDAUEaZaCc6McnY0h0mxsh6jURBQLusey9
 kTR80WLP5AA1vkWwZBVCPS08lGUob9V0haWsf2HuuxR7gCdvOxSFzQbnw0Pi6YTfn0/C7BTe19G
 Ri/g4LjVPtrr3aeOuCSyEgFuW36s52sAKQngwy/PHze97Z1GMcOi4nBLGHez0CDamhofCKYkgmb
 zH8gDrwP7l6Zose7j7MZUKpG4VcUU7b1FDl6mgEht+OfyVBDBguWgYMM6ULl72bOjWr2ykfbm/5
 qvJIqAT7uiKXcN4d0lNxPtf/yzctMlX4I/PY67/Zixd3AfqwRs70+2lS5/T1kaojIdANdKBhfaP
 bbzbvMy8RP7hj0kwXsQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX8m2fnxylLGs4
 6tjPtxsFDOXn5A0E0x2TjMJ6uEv4UAnCbCthqq5V5JSU7/uSI0Ai7Jowor/+a3459F9vDwQM71X
 t9TQS8HbeLry5t2MuVzRY4aEq+Mlte0=
X-Authority-Analysis: v=2.4 cv=bdtbluPB c=1 sm=1 tr=0 ts=6a748b30 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=Ga8fF9AItmT7q7bL59kA:9 a=2VI0MkxyNR6bbpdq8BZq:22
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

