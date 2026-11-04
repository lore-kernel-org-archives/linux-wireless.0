Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754652;
	b=E3PbyPJZ6BMt75sN9ruQ1mcYv8Yk5q3qAlWVjBqRGDrybYYH/0LUFNkUd7Ux/VrKL9Vq
	 8Iujm0Mri6cLBAqQdpkIXkSNefVarN7iOzWadnwfzprbW73WQ8IukU0ZmsjLDHclw2vPQ
	 fJiFzx4g/VectJJ7odVpo9YGtqAHGusL0nbkuolmyC3V8IJSnJPeYyVGEhdDbuEMxjYVV
	 9buxMjq5d/FijM2p3i7kyqr8tTaTmRE3OmuWuYweaDOssIPt4nr3P1qtRwHPBMf1Noy11
	 z+Hs/HZvUmaB0Bb9KtnsVX23xMldTGuhifbl6QdoU2Zc9xri82yVXAU13K5447LGDTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754652;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=3iz3Cx1junU5AKH67YJX4/Pd0NUTUZq/2Hnk10krITE=;
	b=RwoK3z6vjbwtA4lerxyzEuMtqt+IuJU+RRH/SOq7LM1b1TQGlBgXX8RtIWsYyocTyz87
	 kMKLaZbUfx13XXXFjbaFwllx1EM6yGSpAkBrMcLN4TM/yXjKWBJUYZTXtUDJh0v5A8CRF
	 X3o70aPi/n9POwMJ+76WMU5xd/iRM/VwQQmULFwiw4pSJwoHDPluJn4ZjspDGcqmmgDeX
	 0GsSruPpRFUp3MBio48hGQMYpK8SLGOrp9Vh+mOO6wZ9yI5p9bi55bLdo8u5geKyZdR/R
	 /tmqT2vhJDUoLB/E8r5xt71PGcXQQjzN59A0/e4Oyz2ySnSO1qyqFfSQ+HAkc7sRvSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="NmZ/OYXV";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=RQJ4+1CV;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497AE606A32E
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:10:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 497AE606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=NmZ/OYXV;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=RQJ4+1CV
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40S6Up4071412
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:10:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3iz3Cx1junU5AKH67YJX4/Pd0NUTUZq/2Hnk10krITE=; b=NmZ/OYXV8kl/llRx
	dGrpnN95QBk8Y3ULkyl8OkQpfGrZjNnPR/kW8ZQKbiTA7uSkxeewTwOlgpTRafTE
	mbsZlQ8rKErPtTn+c+3zWRFLiug7OzCzGoNnbA9Vh5pcwZlGhLyKJWjXZmW/u30V
	hqZwL4lLWBPUM/E77uHBIvLpSCNdteihX5t028XhQ+dMZt2DSeibN5g3V0NA/CAp
	Q2Z8FZKLuz0TvMz/1xdLO/887qScbIUUgfhj3vutN0crvsP9uD3TtewkoLGT16ge
	hNd3rCpuGzxB+FT01tsSQWkmPTi9i9qeaOjKb47mDSu1sLr/khm9aH3F89JkoEx3
	iDB04g==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqh2bjm54-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:10:49 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36ca254ca2cso264732eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754649; x=1794359449; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3iz3Cx1junU5AKH67YJX4/Pd0NUTUZq/2Hnk10krITE=;
        b=RQJ4+1CV4D4sejhH4cTzKKBizjMlQRC6Tcjx0y93WVwYaTDGc2uUIGsASmzbzoZwnw
         5rc0i54wI7R/ZHWJ+vKqi/2FF+sEzNCgmEVHdUhwcC5loeTxADaeGjkBuY2S+4xaN98P
         rY3BdHGApiUc4Gs9r8skE/W+bwlUslwbu2CmP95oGkUisiEmGzWNy9OSoU+RMnDXUX2E
         zwQUCqRfzHA9hxSVHtomH3OmX+J9NCwz+MrZzRmxh0MD9wkKFhvVjgH8xZruMCzo7Lez
         nxeA9jLs10VKgeZcYQg9M/k4sIwiVn1IBFzmNJVVmu4+e+9VX6C+frQkarrgh+ft1Mpe
         JimQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754649; x=1794359449;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3iz3Cx1junU5AKH67YJX4/Pd0NUTUZq/2Hnk10krITE=;
        b=juu/8aHcwkkhBUIH9GtACMD7mIhT8j7yxRlibQA1MbPAnweKG9x7NcYBIZcoJokzp7
         0tJR87PlBgbYfB5kP0QyP8T1LrM4OJxAk78rckPfz/pV2ZCGR6sRzNIthI+aD6SEFdFh
         C8ckhcSgwMbKsSXuDmJ/8shNdJVViIWMxB53yICyMd9JpG0RAmBM7B/D/FEsIbOvpV4T
         fkIWl3KhgnOoxY+c1S6PHQVAskJ16+gwYpBHg6x6ArE6rSz2X1vuobzARhJ1EIilqVv0
         Xceb+Pbd/LrUzJw27ChF0gNLEugUT26nOrkgdFFVAPtyGqnG6lzkhvll+h1CC0dUy9Sg
         t2uw==
X-Forwarded-Encrypted: i=1; AKwUvBzsqePxm6sdWBXtBij9WeSargkR4STEAo1BEGAprKxK3vLd1lc4Q6Q3XnSDd5B2YKpIEyuTK7C9sMmpzubdBA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+oYzHvuyXDJ2oLIf253TowNa5DyFznFqhjSmjGnkAMy4VNUpVL
	Uv/DSVRt0JPvZfZy2j8WEBdRQuUzIGAp9kP8h51JA8up1FvojEhMjHnR2ddHq+zne5W1lulEFxV
	TAGb57aEYxAzPxkM6dPHrij1Dmx3cSh7qxwXJK3oKG8Hr9LZmEZxzq0H1SH+HjrU4RAW/0Q==
X-Gm-Gg: AYBFou17asurC7sFy/uiGB9pjRaxbBRmvhwnIXyWgY0uMCuJWJWbmUliJdtxMh+LePp
	02fwt1fQNrdyC/R1LPS6TCsVnedUyd0/RhkKxqsCJ7sfr5xR1XloFtsjKi1UFISyb/xzEsJXvre
	rvLz8QSrWwNugqBNjiFZ9i1XbXZ/NqOObavnec7WeavHJ7kv+IeDMnrul+8ezwtWlH3W7SruBdr
	UwqRncz7J0oiKbhhbgBiM8arZoz5kZiKfets6JUR+Q4o3esfsDDNTz8dxU9UtlrDLDttYyANodc
	7LNYBwCLRxN5GSoDsTnkoQslUksl4PZ40beJlDeBv5Z8oQnACwOHhXT01c3fLzWFC27NhQmeboG
	q4UAghPNZXycVuQe1bcbtFuDZk0OLIsC0XMJ7Tq7gk9Am/uGuq1Uj1RZIFtBsQZkMQ2djLWXda/
	m1StiZq5Y5vPYsDsUAjfRc+ZT2d5VJOAPibALw
X-Received: by 2002:a05:693c:414f:20b0:369:e930:6bc4 with SMTP id 5a478bee46e88-36a423f6f4amr22540050eec.30.1793754648858;
        Tue, 03 Nov 2026 17:10:48 -0800 (PST)
X-Received: by 2002:a05:693c:414f:20b0:369:e930:6bc4 with SMTP id 5a478bee46e88-36a423f6f4amr22540010eec.30.1793754648180;
        Tue, 03 Nov 2026 17:10:48 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:47 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 17:10:45 -0800
Subject: [PATCH ath-next v3 02/13] wifi: ath12k: ng: add high-priority REO
 command ring
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-reo-cmd-b4-posting-v3-2-861adf04b516@oss.qualcomm.com>
References: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
In-Reply-To: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Ripan Deuri <quic_rdeuri@quicinc.com>,
        Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        ath12k-review@oss.qualcomm.com
Cc: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfXxi0TLIzbm0E2
 t9ShVITFwkc1eSbP38CF79S/xtBMIhx6wwkV74ATj2S8QBsGySye+w7GPlDNPefzgr2QyJLFRw6
 00Q5hSExQMFvVImsJ0SuyLjlJzPfcgE=
X-Authority-Analysis: v=2.4 cv=Xs1vqlF9 c=1 sm=1 tr=0 ts=6aea861a cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=ATb32olPAYJCz0g8maoA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: _LjCFG8fYh9e5roVmgDLAbZLCOn9QA-c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX2khUeWdgUYX1
 fLPOA9+sW2OQgOH4mt7xtTI+PEr1xnzUecMflHrihNDQE4o/CgKsLzpwsz0BWP3vr7a8NcZ+gbp
 n241Iybx9bKhogxjGe8UHBXhVKRl64Os7X6LtT7uX1ryBS0CAul6USha0PkF5bLvh9u+KAEf5De
 JirOz97mOOhtzDZ3dhbhOUtPU00iSPcJPl03i5V64L8AMpt6pM7d9vRA5AERpC7kPIj9bBGAr2k
 9Nz77KvcCRpr69rgq6IRVa4iMJP6EcbffhYzpQ9SKaQ6W01p7ScPJlXGSDkdwdUGi3ollT/Z/ID
 iUn1ch9CpZi/AwBOqpjTTyYtj6+7YXOCD1wXeQA4DC4EQhh5w6ciUin6THSp+iLQHkJ9kgz3oJm
 qsNP/s9HDjU1ZqppX84R7+I20xb9IKGrAj+vZ6ShyNqUkR5Lyxp4loox3yOyJ0dSU5P6RtrTRce
 dZcQiGp01OKKuV+5jkg==
X-Proofpoint-GUID: _LjCFG8fYh9e5roVmgDLAbZLCOn9QA-c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 clxscore=1011 suspectscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040004

REO commands currently share one ring, so latency-sensitive queue
statistics and update requests can wait behind normal command traffic.

Wi-Fi 8 hardware provides a second REO command ring for priority traffic.
Represent it as ring index 1 of the existing HAL_REO_CMD type, allocate
and initialize it in the Wi-Fi 8 datapath, and expose a separate
high-priority send callback. Reserve a distinct command-number range so
completions from both command rings remain unambiguous.

The existing REO command ring and common send callback are unchanged.
Only Wi-Fi 8 installs the high-priority callback and allocates the
additional ring.

Tested-on: Compilation only, M=drivers/net/wireless/ath/ath12k

Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_rx.h       |   4 +
 drivers/net/wireless/ath/ath12k/wifi8/dp.c    |   2 +
 drivers/net/wireless/ath/ath12k/wifi8/dp.h    |   1 +
 drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c | 109 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h |  13 +++
 drivers/net/wireless/ath/ath12k/wifi8/hal.c   |  13 ++-
 drivers/net/wireless/ath/ath12k/wifi8/hal.h   |   3 +
 7 files changed, 142 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index d369d68620ed..3a369dfc8ea5 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -11,6 +11,8 @@
 
 #define DP_MAX_NWIFI_HDR_LEN	30
 
+struct hal_reo_status;
+
 struct ath12k_reoq_buf {
 	void *vaddr;
 	dma_addr_t paddr_aligned;
@@ -61,6 +63,8 @@ struct ath12k_dp_rx_reo_cmd {
 	int cmd_num;
 	void (*handler)(struct ath12k_dp *dp, void *ctx,
 			enum hal_reo_cmd_status status);
+	void (*status_handler)(struct ath12k_dp *dp, void *ctx,
+			       struct hal_reo_status *status);
 };
 
 #define ATH12K_DP_RX_FRAGMENT_TIMEOUT_MS (2 * HZ)
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp.c b/drivers/net/wireless/ath/ath12k/wifi8/dp.c
index ff44b8be9534..dee73473cea9 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp.c
@@ -245,6 +245,8 @@ static int ath12k_wifi8_dp_umac_init(struct ath12k_dp *dp)
 	INIT_LIST_HEAD(&dp->reo_cmd_list);
 	INIT_LIST_HEAD(&dp->reo_cmd_cache_flush_list);
 	INIT_LIST_HEAD(&dp->reo_cmd_update_rx_queue_list);
+	spin_lock_init(&dp->reo_cmd_lock);
+	spin_lock_init(&dp->reo_rxq_flush_lock);
 	INIT_LIST_HEAD(&dp->tqm_cmd_list);
 	spin_lock_init(&dp->tqm_cmd_lock);
 	atomic_set(&dp->tqm_cmd_num, 0);
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp.h b/drivers/net/wireless/ath/ath12k/wifi8/dp.h
index 4b773dca0483..3d1ce8f31ee8 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp.h
@@ -42,6 +42,7 @@ struct ath12k_dp_wifi8 {
 	struct dp_srng tx_exception;
 	struct dp_srng tcl_cmd_ring;
 	struct dp_srng tcl_status_ring;
+	struct dp_srng reo_high_prio_cmd_ring;
 	struct dp_rxdma_ring wbm_refill_ring[DP_WBM_REFILL_RING_MAX];
 	struct dp_rxdma_ring wbm_idle_ring;
 	struct dp_srng tqm_cmd_ring;
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
index ca82f9ac0e44..0eea810f68fe 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
@@ -15,6 +15,8 @@
 #include "hw.h"
 #include "../hal.h"
 
+#define ATH12K_WIFI8_REO_CMD_HIGHPRI_START_NUM	(DP_REO_CMD_RING_SIZE + 1)
+
 /* Wi-Fi 8 uses cookie-conversion: the chip writes the SW descriptor VA
  * directly into buf_addr_info[63:0] of the REO destination ring entry.
  * info0 holds VA[31:0], info1[7:0] holds VA[39:32].
@@ -48,6 +50,99 @@ ath12k_wifi8_get_sw_desc(struct ath12k_dp *dp, const struct hal_reo_dest_ring *d
 	return ath12k_dp_get_rx_desc(dp, cookie);
 }
 
+static int ath12k_wifi8_dp_reo_cmd_send_ring(struct ath12k_base *ab,
+					     struct hal_srng *cmd_ring,
+					     void *data, size_t len,
+					     enum hal_reo_cmd_type type,
+					     struct ath12k_hal_reo_cmd *cmd,
+					     void (*cb)(struct ath12k_dp *dp, void *ctx,
+							struct hal_reo_status *status))
+{
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_dp_rx_reo_cmd *dp_cmd;
+	int cmd_num;
+	struct ath12k_dp *central_dp = ath12k_get_central_dp(dp);
+	struct ath12k_base *central_ab = central_dp->ab;
+
+	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &central_ab->dev_flags) ||
+	    test_bit(ATH12K_FLAG_RECOVERY, &central_ab->dev_flags))
+		return -ESHUTDOWN;
+
+	if (!cb) {
+		dp_cmd = NULL;
+	} else {
+		if (WARN_ON(len > sizeof(dp_cmd->data)))
+			return -EINVAL;
+
+		dp_cmd = kzalloc_obj(*dp_cmd, GFP_ATOMIC);
+		if (!dp_cmd)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&dp_cmd->list);
+		memcpy(&dp_cmd->data, data, len);
+		dp_cmd->status_handler = cb;
+	}
+
+	cmd_num = ath12k_wifi8_hal_reo_cmd_send(central_ab, cmd_ring, type, cmd);
+	if (cmd_num < 0) {
+		kfree(dp_cmd);
+		return cmd_num;
+	}
+
+	if (cmd_num == 0) {
+		kfree(dp_cmd);
+		return -EINVAL;
+	}
+
+	if (!dp_cmd)
+		return 0;
+
+	dp_cmd->cmd_num = cmd_num;
+
+	spin_lock_bh(&central_dp->reo_cmd_lock);
+	list_add_tail(&dp_cmd->list, &central_dp->reo_cmd_list);
+	spin_unlock_bh(&central_dp->reo_cmd_lock);
+
+	return 0;
+}
+
+int ath12k_wifi8_dp_reo_cmd_send(struct ath12k_base *ab,
+				 void *data, size_t len,
+				 enum hal_reo_cmd_type type,
+				 struct ath12k_hal_reo_cmd *cmd,
+				 void (*cb)(struct ath12k_dp *dp, void *ctx,
+					    struct hal_reo_status *status))
+{
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_dp *central_dp = ath12k_get_central_dp(dp);
+	struct hal_srng *cmd_ring;
+
+	cmd_ring = &central_dp->ab->hal.srng_list[central_dp->reo_cmd_ring.ring_id];
+
+	return ath12k_wifi8_dp_reo_cmd_send_ring(ab, cmd_ring, data, len,
+						 type, cmd, cb);
+}
+
+int ath12k_wifi8_dp_reo_cmd_send_highprio(struct ath12k_base *ab,
+					  void *data, size_t len,
+					  enum hal_reo_cmd_type type,
+					  struct ath12k_hal_reo_cmd *cmd,
+					  void (*cb)(struct ath12k_dp *dp, void *ctx,
+						     struct hal_reo_status *status))
+{
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_dp *central_dp = ath12k_get_central_dp(dp);
+	struct ath12k_dp_wifi8 *dp_wifi8 = ath12k_get_dp_wifi8(central_dp);
+	struct hal_srng *cmd_ring;
+	u32 ring_id;
+
+	ring_id = dp_wifi8->reo_high_prio_cmd_ring.ring_id;
+	cmd_ring = &central_dp->ab->hal.srng_list[ring_id];
+
+	return ath12k_wifi8_dp_reo_cmd_send_ring(ab, cmd_ring, data, len,
+						 type, cmd, cb);
+}
+
 /**
  * ath12k_wifi8_rx_spd_buf_alloc - allocate per-ring SPD scratch-pad arrays
  * @dp_hw_grp_wifi8: Wi-Fi 8 hardware-group private data
@@ -915,6 +1010,7 @@ int ath12k_wifi8_dp_rx_ring_setup(struct ath12k_base *ab)
 {
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	struct ath12k_dp_wifi8 *dp_wifi8 = ath12k_get_dp_wifi8(dp);
+	struct hal_srng *srng;
 	int i, ret;
 
 	ret = ath12k_dp_rx_pdev_reo_setup(ab);
@@ -949,6 +1045,17 @@ int ath12k_wifi8_dp_rx_ring_setup(struct ath12k_base *ab)
 
 	ath12k_wifi8_dp_wbm_idle_ring_buf_setup(ab, &dp_wifi8->wbm_idle_ring);
 
+	ret = ath12k_dp_srng_setup(ab, &dp_wifi8->reo_high_prio_cmd_ring,
+				   HAL_REO_CMD, 1, 0, DP_REO_CMD_RING_SIZE);
+	if (ret) {
+		ath12k_warn(ab, "failed to set up reo_high_prio_cmd ring :%d\n", ret);
+		goto err_wbm_refill_cleanup;
+	}
+
+	srng = &ab->hal.srng_list[dp_wifi8->reo_high_prio_cmd_ring.ring_id];
+	ath12k_wifi8_hal_reo_init_cmd_ring_offset(ab, srng,
+						  ATH12K_WIFI8_REO_CMD_HIGHPRI_START_NUM);
+
 	return 0;
 
 err_wbm_refill_cleanup:
@@ -964,6 +1071,8 @@ int ath12k_wifi8_dp_rx_ring_free(struct ath12k_base *ab)
 	struct ath12k_dp_wifi8 *dp_wifi8 = ath12k_get_dp_wifi8(dp);
 	int i;
 
+	ath12k_dp_srng_cleanup(ab, &dp_wifi8->reo_high_prio_cmd_ring);
+
 	for (i = 0; i < DP_WBM_REFILL_RING_MAX; i++)
 		ath12k_dp_srng_cleanup(ab, &dp_wifi8->wbm_refill_ring[i].refill_buf_ring);
 
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h
index 9ef1474b1a7e..a05ab2f4495c 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h
@@ -11,6 +11,7 @@
 #include "hal_desc.h"
 
 struct ath12k_dp_hw_group_wifi8;
+struct hal_reo_status;
 
 struct hal_rx_mpdu_desc_info {
 	union {
@@ -146,6 +147,18 @@ int ath12k_wifi8_dp_pdev_alloc(struct ath12k_base *ab);
 void ath12k_wifi8_dp_pdev_free(struct ath12k_base *ab);
 void ath12k_wifi8_dp_wbm_idle_ring_buf_setup(struct ath12k_base *ab,
 					     struct dp_rxdma_ring *rx_ring);
+int ath12k_wifi8_dp_reo_cmd_send(struct ath12k_base *ab,
+				 void *data, size_t len,
+				 enum hal_reo_cmd_type type,
+				 struct ath12k_hal_reo_cmd *cmd,
+				 void (*cb)(struct ath12k_dp *dp, void *ctx,
+					    struct hal_reo_status *status));
+int ath12k_wifi8_dp_reo_cmd_send_highprio(struct ath12k_base *ab,
+					  void *data, size_t len,
+					  enum hal_reo_cmd_type type,
+					  struct ath12k_hal_reo_cmd *cmd,
+					  void (*cb)(struct ath12k_dp *dp, void *ctx,
+						     struct hal_reo_status *status));
 int ath12k_wifi8_dp_rx_ring_setup(struct ath12k_base *ab);
 int ath12k_wifi8_dp_rx_ring_free(struct ath12k_base *ab);
 int ath12k_wifi8_dp_rxdma_ring_sel_config_qcn9625(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal.c b/drivers/net/wireless/ath/ath12k/wifi8/hal.c
index 036c04cbbf16..af51ee3cd7e7 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal.c
@@ -565,13 +565,14 @@ void ath12k_wifi8_hal_set_link_desc_addr(struct hal_wbm_link_desc *desc,
 		le32_encode_bits(cookie, BUFFER_ADDR_INFO1_SW_COOKIE);
 }
 
-void ath12k_wifi8_hal_reo_init_cmd_ring(struct ath12k_base *ab,
-					struct hal_srng *srng)
+void ath12k_wifi8_hal_reo_init_cmd_ring_offset(struct ath12k_base *ab,
+					       struct hal_srng *srng,
+					       u16 cmd_num)
 {
 	struct hal_srng_params params;
 	struct hal_tlv_64_hdr *tlv;
 	struct hal_reo_get_queue_stats *desc;
-	int i, cmd_num = 1;
+	int i;
 	int entry_size;
 	u8 *entry;
 
@@ -589,6 +590,12 @@ void ath12k_wifi8_hal_reo_init_cmd_ring(struct ath12k_base *ab,
 	}
 }
 
+void ath12k_wifi8_hal_reo_init_cmd_ring(struct ath12k_base *ab,
+					struct hal_srng *srng)
+{
+	ath12k_wifi8_hal_reo_init_cmd_ring_offset(ab, srng, 1);
+}
+
 #define HAL_RDI_MAPPING_MAX	32
 
 int ath12k_wifi8_hal_get_rdi_source_cfg(struct ath12k_base *ab, int source)
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal.h b/drivers/net/wireless/ath/ath12k/wifi8/hal.h
index d30ee1242122..fc5df78be051 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal.h
@@ -1045,6 +1045,9 @@ void ath12k_wifi8_hal_set_link_desc_addr(struct hal_wbm_link_desc *desc,
 					 u32 cookie, dma_addr_t paddr, u8 rbm);
 void ath12k_wifi8_hal_reo_init_cmd_ring(struct ath12k_base *ab,
 					struct hal_srng *srng);
+void ath12k_wifi8_hal_reo_init_cmd_ring_offset(struct ath12k_base *ab,
+					       struct hal_srng *srng,
+					       u16 cmd_num);
 int ath12k_wifi8_hal_get_rdi_source_cfg(struct ath12k_base *ab, int source);
 void ath12k_wifi8_hal_hw_ase_init(struct ath12k_base *ab,
 				  struct ath12k_hal_ast_param *ast_param);

-- 
2.43.0

