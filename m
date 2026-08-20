Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19983AAF57
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787204904; cv=none; b=OSQiR/4aWXGrQJHd7yE2lypKUYXVijzIbyCCFweSroGwX3kYgJUPtTDl0yHV9Z+4NltOyuPppZxDEDy6zBrRazo2/jhVmXovAImmxCug1WK19h7anQ2Zyj5JSMu5KvXAYnEPQOCsmH2mwCQ+bAwwR//3tZNrh1qeGe2KZR9Fy8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787204904; c=relaxed/simple;
	bh=SztkqyJAZi9rXvleyd7YtRo87iFq/Ch0hkapU5Bs8D0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=trPGj83tRgE1hcOM1pB+fs2c5Up14DKBlCovplzV2gV8md+P0mFgU9XUge+8B9+mcFtjISJCLQFpQoPqNFORox074BZJry7PpFNf2p6BxfSboFwr0G5Nx7m1tM1AA/nPQmW7avSn9NdMS/vqHuHWhTKdsaic2d53DtsfS8fs5pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZwND/ZZ1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PWJ/JCJu; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZwND/ZZ1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PWJ/JCJu"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JL8WDX1440195
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=usIhDXNMfu5
	0PPG0W9yN2mbSyklvwcQZEXUGI2Y4qbI=; b=ZwND/ZZ1wyPLgz+vd3FVdh4lrmu
	9w2L2SMGKzWrqqB9VkL1HLR4LPsSR59LpcMJWJAglnuydnD9rQHhSwGKWwVVHaTp
	uz4aPeNvXtNRjSWBzPqHydM0FHUEK51FKsCblVUAa8zBGotHnpPmxg3Wy/dorq0d
	WJRBsdRI9QeERJekxcG21zPSjGS6/j5Za/BPQDDsfJSQMJAqjknkcfc5X+ekOq3h
	iFM/UxQl0g1AUaA1ATpJj3ASG127HczrHQzKp6APQO2b4zU5nEmIbBQ+tRLokT7x
	oLvxf6Vusxt3iMKgRoXsb5j6KsQBgz5lCn+7QAo6amHMrsqCeCj7Q53Xjmg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5daa3tqf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:22 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3931cd2e4cbso2414793a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 22:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787204901; x=1787809701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=usIhDXNMfu50PPG0W9yN2mbSyklvwcQZEXUGI2Y4qbI=;
        b=PWJ/JCJuF4zYs0pxw3WnhlReWVIVHC5zgR+ohT+bK3LPnMaC53XPVBfKefAxDTs3S2
         +GUnAz/4CX8stj2Rx/J+A2q4BiyLWgk3XnpTKbKgwhSLmCEGOYh7MW7xaVpVb4yM/YZm
         Gi1tUbgefXhHi3OA9nwW6bsrEzvZhvTaI6MQAIcZ4oe16ciq6itmeL0t9TSRKAFrKN+n
         RmHhqFANfIYBIZg67GH01IdCw9uzakMIsdWl8OisIQK7F7ThiJA9uslJmul1FO+dMCrc
         skxEHsp7CSCDkIu9M0hVkCPFJlw66jnQx1BSjhy5UTRTwXfg1QVaRkZ1t/3Xytmg+ETV
         RW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787204901; x=1787809701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=usIhDXNMfu50PPG0W9yN2mbSyklvwcQZEXUGI2Y4qbI=;
        b=OAnhPBmVDiSC06kmtpz+rWiIvffz5os+exoamq4xRo64znceg+KchkIYzD6NRz9NTO
         sKmp5FikdVUMq2mgyrFEkcfGqtsdro2sMgrc6+ruwkAadeNFli+l31vAN8bYsILs+/AF
         q+Syirioxi1KIBeFasEPHEGjx4N2GNxfgFG92Vb8q2QMZDbe7QuXipf5RcFpZ1T05k6u
         Xzjmou9njdHVuODO0lAjF+bkjtjTblVb5cpx2M6vMStclBYuz+ba2DOFrq9z58bw2T08
         GMexZl4Ur5UMyDGF+H86poQEz6jbrohragTL4UECrBVIuJof6VvLAPJkd8t4RSVJeSbC
         3qHg==
X-Gm-Message-State: AFuF++kvvPk8afNXqGuQoxGo0ns8RkBBbTUGr+9z0bYStqNMuzbAbCkr
	fCSx4+Yx3If6giMiaQbSn+i6Ul0U0RMyasQbrc7sl+AB5AJwHLL4uXASMqJXOPw5erre/uXVSLF
	qC8tTBNfMj9CVVMjQXgB0TN8xyuuW7cyYdqKgl4WbucvdihYlaZhN20otKU+ln5yRb2YyYw==
X-Gm-Gg: AR+sD103ZYwLqSNZmEyIgjvJCvIxLDIMyWIjwtXUC7C69gUwos1jV/n2Aucy5xXvWLD
	lFq2ovP96vOmJOmn0V0IkM4w7Bv7r+mtW8u7poQXY1b3HH9Q/uWFrTABssa6Xt2ulSzxMhfmprz
	ihcH4LYXvS/Hc9Eaew8NPlVgMnNGcjG9GxSusmOAxds1vF6x+sJtGRoi1f4/yOF6mgmDbXUSiWj
	XBeQ7l5wnZGP3tVoXpSw33abrL87ylTLE1OIVt4t89bxvVwO73DJK4LSNVlPTT9zwRfmjo5YidU
	6GCYpS3y3wRbzAS1vtRqgoMqVrcYRZw9tenGAmorApkowQNHAAx6oUmObdtSzysv0i8MrkxjUlQ
	fmzmMAV8gH/icPpDIktbOSmFwcxSa0ZRTcViPdPCwzy8dcE0nG+7RkXCzzHPZH+9SynftG88rQ7
	B4+uj3KI9FIpbESHsn9Lu2A48=
X-Received: by 2002:a17:90b:4a46:b0:37f:e326:6557 with SMTP id 98e67ed59e1d1-3958083fc60mr18558739a91.4.1787204901431;
        Wed, 19 Aug 2026 22:48:21 -0700 (PDT)
X-Received: by 2002:a17:90b:4a46:b0:37f:e326:6557 with SMTP id 98e67ed59e1d1-3958083fc60mr18558659a91.4.1787204900954;
        Wed, 19 Aug 2026 22:48:20 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fbf3dc2sm5440931a91.17.2026.08.19.22.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 22:48:20 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com, quic_periyasa@quicinc.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 3/7] wifi: ath12k: convert DP_RXDMA_MONITOR_BUF_RING_SIZE to inline helper
Date: Thu, 20 Aug 2026 11:18:00 +0530
Message-Id: <20260820054804.3222296-4-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=fv3sol4f c=1 sm=1 tr=0 ts=6a869526 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=cZMQY5532DquS9h7jwgA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: L3RHPNgfoY9qAjS0KdAXi1kUPSyn-ts-
X-Proofpoint-ORIG-GUID: L3RHPNgfoY9qAjS0KdAXi1kUPSyn-ts-
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfX3yzQfffecmwq
 Y8XMY7Grdaq3MqW7cf+5l/9YbGsxZip+A7GAihw7jtzvO5jHhsu64DODylaZ3vZzC6vrYOnlf50
 wF8FPbI9AyUJivLYKmtc+tL/9/8EBKQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfX3wO2AHcjFuwF
 7cdyuz6c9+xZUQS+Ex7dKxNdsH6uLJGOWCQfoQA/Wgu79CN+QfjgW7bB6bFG0bIcWyvcBWOfV0k
 WWKdMV8xVgGPythLESrukWJ7TKjxgezaohC87qRgkrG4rVKGd7Vz9dM+OWbl4+Aitw7/qbZhAan
 yWXBneP4/NKckSxEQoPaL93D/cKNYMHb50tNFfNU/ywwv+hwahBJhYtwaxcgJY3uoaKE9Qxal+J
 4zsN35Cff2CWH/7h/qK+/gkf7gD39oRi+8o/eW2OrS+de+eWMKzalOYfaUhbbsjXRhPNg5Nw/N+
 dkNe4FVM1wBOyXjeBizL6CWQwyccWl0H9wPryUsD512nWPLo6JiRR+C8rm2/KaPDZJhl8todbgH
 6nToXu2PpfpZXUUr06ibyArHVv87IyA5ckvpXaFfwqgrt+VXHk6gnWKNYGxpG7XmAvTqDSTwXs4
 0t/nUVsOkPnb4N0IeQQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608200040

Replace DP_RXDMA_MONITOR_BUF_RING_SIZE macro with
ath12k_dp_rxdma_monitor_buf_ring_size() static inline helper. Pass the DP
profile parameters explicitly to improve type safety and make the interface
explicit.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp.h    | 8 ++++++--
 drivers/net/wireless/ath/ath12k/dp_rx.c | 4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 6540b3453cc6..9081655eae77 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -216,8 +216,6 @@ struct ath12k_pdev_dp {
 #define DP_RXDMA_REFILL_RING_SIZE	2048
 #define DP_RXDMA_ERR_DST_RING_SIZE	1024
 #define DP_RXDMA_MON_STATUS_RING_SIZE	1024
-#define DP_RXDMA_MONITOR_BUF_RING_SIZE(ab) \
-	((ab)->profile_param->dp_params.rxdma_monitor_buf_ring_size)
 #define DP_RXDMA_MONITOR_DST_RING_SIZE(ab) \
 	((ab)->profile_param->dp_params.rxdma_monitor_dst_ring_size)
 #define DP_RXDMA_MONITOR_DESC_RING_SIZE	4096
@@ -692,6 +690,12 @@ ath12k_dp_tx_comp_ring_size(const struct ath12k_dp_profile_params *p)
 	return p->tx_comp_ring_size;
 }
 
+static inline u32
+ath12k_dp_rxdma_monitor_buf_ring_size(const struct ath12k_dp_profile_params *p)
+{
+	return p->rxdma_monitor_buf_ring_size;
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 8fa0e90b4531..efc419d41d21 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1692,6 +1692,8 @@ int ath12k_dp_rx_htt_setup(struct ath12k_base *ab)
 
 int ath12k_dp_rx_alloc(struct ath12k_base *ab)
 {
+	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
+	u32 monitor_buf_ring_size = ath12k_dp_rxdma_monitor_buf_ring_size(dp_params);
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	struct dp_srng *srng;
 	int i, ret;
@@ -1736,7 +1738,7 @@ int ath12k_dp_rx_alloc(struct ath12k_base *ab)
 		ret = ath12k_dp_srng_setup(ab,
 					   &dp->rxdma_mon_buf_ring.refill_buf_ring,
 					   HAL_RXDMA_MONITOR_BUF, 0, 0,
-					   DP_RXDMA_MONITOR_BUF_RING_SIZE(ab));
+					   monitor_buf_ring_size);
 		if (ret) {
 			ath12k_warn(ab, "failed to setup HAL_RXDMA_MONITOR_BUF\n");
 			return ret;
-- 
2.34.1

