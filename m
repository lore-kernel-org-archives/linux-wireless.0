Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E02337CD59
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787117604; cv=none; b=QviKYQB7FB2PCWLoLXoQUl84AqiSTMze+T4Fn0wFQjyOfHyBCoXPn7R72zIfc/wG3sW+VfaoCVM8sRhLaOc766wrX+iQjcOMF3hllxJcnHkN1U8RZFgL/W5Ycoe+lnQ0fVSAhde3oi3/9+Ttlwvnw5U9BKEf0Fdd9Vc96MbZLdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787117604; c=relaxed/simple;
	bh=OQWt/UVHwqtolnO1TnQGK3J21l6YfY/LleHFXUxoP/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fqMnbranpMtq+W3lflLoprQeQAgAbYAcIGy6tcK2cEY9JKfZl1a+AikGUbDwSqlfmf23dBoCl1n0FB/77VbrbCW36JGzpuO4RodtumcAT2ERE5ZL9EHRdQo/OGyLOrjiE69w+bE7QSw64930iSmay1E+fbo+FkweyLtsAh5+scA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eZeCZd5M; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GMTDqQe8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eZeCZd5M";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GMTDqQe8"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J5ISLC3499127
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=P/+Zy6EjiwF
	FGtfKs/1otK9rXi7W051TWzFmkxKv0e4=; b=eZeCZd5MuBlAImSWnXdwH+TaRAl
	5tPoFZZ4JMT8aM3gXlfkV8HobdcbHpScc+QUsnqNZd3bTbozJsKntbMOiw7X2V/S
	D3mnNjnFMTUTXlQ+sgP5rtGepoueoDlG6ys1Dc02mpVASmg6QmT7gFvb/T4rfT1j
	ZdUcb0I/hlrBxWPvkDueK5gXLtkXkR5c+JzIlQDBsW1GePmbsUcvsrmWVzi5fb+y
	Jdb+i7QFwbEYjN8F+rYKjmiTFtQKc8xRVNMf2LiwTdGC1uB6h4fLKRU1CI4jJsha
	1AvCkJ3jw6HQ9Pugn+lT68u5SkpGhfn5NzQLmeJd/w/MG8q95fWoHB/FASg==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yftsgnh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:22 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb5cc1e139bso383879a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 22:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787117601; x=1787722401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P/+Zy6EjiwFFGtfKs/1otK9rXi7W051TWzFmkxKv0e4=;
        b=GMTDqQe8vP8kmi5CH/fr9zqQDC9j+sZgiEH6qrP/Jhah4ldchL+jsbN9Jak65rJEm0
         GTS5aGI9ufsmVvT6vQupFwlxNiYVgKPR3OX2ILolheRGt0GPApDksy4jPuchHQavFnhA
         xki52ftpoAVQ3BWe9f56Sz7TCVrFyNEXqeA4TRO95xTnk8xawl7ay4MOf1gD23XMV4mC
         ulPR1W3LB7xO3AvD9Jl/F0RXIFhKIlJvVR3BSV2H4wN0hoQz3Zu3dwXQZ/tLyIqNoPa8
         Z48kj6ORtJdKWbNo2xSZWhQozX287Qj97W+hbIUnVBrZnNe/HZ/ooW6jpQ4MjQzGy/Jx
         /K3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787117601; x=1787722401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P/+Zy6EjiwFFGtfKs/1otK9rXi7W051TWzFmkxKv0e4=;
        b=kxxLzECeFkqBZSl4rx55sBxzIW3e2aCSarmstLDwtfur7aJwdaRVQ7ntxTu2kbOedt
         wgj9/YWDMFg/BSqNApyy+FWH30+u+IvXQhPwTQpsa1G/O/KxpLuTW6PTlkjKiQftwaL9
         kU8EUbYWc1FoP66BnapJcfPPCSI/wqi8Mgt+POmXPjt0XzycQ7YIb4NbGuJRcdDI+8w7
         7gX/zkBaxqGhE9P/GCT9Vxsx7nXpMEEbdJ2KuG52unwmKfAk49LceM/w9mrSUpbeyr3L
         rOkNl5NQ9YWOMa6aEir0gz2eIetGmKq2bHGAkIK9cugPn/c3xFVj2I+1m8rj0rKRoEVw
         IrxA==
X-Gm-Message-State: AOJu0YywLxul/TPCNQ7B8jRCSWaHNB+26H9ajEY7wwtEAEsA2X+ij1Dg
	5OcgSh12KswyGocFspw54fagQpapQN/Odq+FS17k2c+JN6s7alrIcqGwvy+f6FybL3YkoodQZAk
	9vv1cNzALGMtezsP7GVCSwiHJQPpJoZtmMZc+PoVfNUwYw1/mlsDlmqWwjR+cdtOwpTcixw==
X-Gm-Gg: AR+sD10uwULT2cGW1uyIDcW2LZhKAK2l5SApRIA5XzVR3BhcMJVVErMJxrp9LV7kPhh
	wWA4jX50rJQO0vAwgPE1l/xXV1alLa/FlMA2DsnfZTFtIA6gBo1H6XthyAh/1nVY4eUlXuwWiPo
	D2ScMFa+kOJCuzZ0bTEBuGR+V9jxeod2zGfXVXUwgI2lz65bI7wOlElHLNT5Tutj7ZKNZfHfHKA
	nFJa+4d/k8W4EAqJgtODA7pyDeDaWRyV3dt0dUTrRArwKFR7ErhdbQocYSFTTRjx0Jb4fifNu+r
	AEeFfjkJF0Adrz9Y1THqG09GOdjK9+UYdmj8NKEQA+9r0otvUUkL/uPx9ZREQysbpNUblUJASfm
	oqqbCfbPiDEmqpKZOtewuJVNPw5jFHn2zJxw+7dUyglP+1DpMxTRG
X-Received: by 2002:a17:90b:1e53:b0:38f:bbc:6a0f with SMTP id 98e67ed59e1d1-39580ecefbemr3897091a91.1.1787117601490;
        Tue, 18 Aug 2026 22:33:21 -0700 (PDT)
X-Received: by 2002:a17:90b:1e53:b0:38f:bbc:6a0f with SMTP id 98e67ed59e1d1-39580ecefbemr3896986a91.1.1787117600661;
        Tue, 18 Aug 2026 22:33:20 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f4c9918sm404261a91.0.2026.08.18.22.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 22:33:20 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v4 6/8] wifi: ath12k: track per-ring RX sent-to-stack count
Date: Wed, 19 Aug 2026 11:02:45 +0530
Message-Id: <20260819053247.1420393-7-pardeep.kaur@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=FIorAeos c=1 sm=1 tr=0 ts=6a854022 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=Ga8fF9AItmT7q7bL59kA:9 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX3xl7vJLKyN/1
 9iJQXpFQmSPAOFaO/8Ht0lXbQkxFCspPAYl8auTahVqDmQhjtgMkeZXKYIrS6ZRQncHTNGTH2hy
 2nxCd1p0+3qSiLJDqYcmChMzmdJqAZc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX2Aylik5bY/PX
 6EBXJZGWIS/etN6NPS1HX3UcxgtcnHdYUhKLBHehTKIo2dn425jxJ+DJ4RQQLgmirIcPVyHUNLy
 /wfaNksahKUoeanjc7hwGijR+qzMeeZaR0uls1jpk6hMZX7cu4Ez2k1CCJBAqOtGi3vwjhjM6uw
 uSFjE7icw46a7JoC++axt40yu1cV3Qh07WsDkZg60JmjnNoLM2CgktmS5YdRfESL+s+ln1qJIbk
 q1Wxlx/4v+56gVjoRFOhHPi0EkrmMWnjCJFi+NbKgaoX579PpD8FLMui63UddiGd1C0s8aEhKOU
 GSKBLLxKhyQXjwJLbmKFZAt9sUwJ+xnq4KO5+c3kC3atAlhp1GvF8jjYqVbHi7l1pnySe40JCY8
 qel/WZyrcnwmjlSvLoL0CnOzR51enqutmBhUBAWp4ThcSANl2a2H9gXj9MhzjuO3lXNfmeWQ7Ch
 wGQootwODMLNRSwxNeA==
X-Proofpoint-GUID: HOnmuu5XRbtIbgRnHnLXBp6K35n1Mjfo
X-Proofpoint-ORIG-GUID: HOnmuu5XRbtIbgRnHnLXBp6K35n1Mjfo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_01,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608190039

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
file under a new 'REO sent to stack:' section.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c     | 10 ++++++++++
 drivers/net/wireless/ath/ath12k/dp.h          |  1 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c |  4 ++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index 935da8d06450..5d5597d80417 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1122,6 +1122,16 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 		len += scnprintf(buf + len, size - len, "%s: %u\n",
 				 wbm_rx_drop[i], device_stats->wbm_err.drop[i]);
 
+	len += scnprintf(buf + len, size - len, "\nREO sent to stack:\n");
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
index abe461886a12..5325d271fd6a 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -651,6 +651,10 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 			dev_kfree_skb_any(msdu);
 			continue;
 		}
+		if (likely(ring_id < DP_REO_DST_RING_MAX))
+			dp->device_stats.sent_to_stack[ring_id][partner_dp->device_id]++;
+		else
+			WARN_ON_ONCE(1);
 		ath12k_dp_rx_deliver_msdu(dp_pdev, napi, msdu, &rx_info);
 	}
 
-- 
2.34.1

