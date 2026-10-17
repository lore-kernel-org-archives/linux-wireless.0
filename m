Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D937426158B
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 09:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792228629; cv=none; b=swqUrQgvNoqYNvWxMHU62Rr/1Iv+0RN0dZ78Jx5gSruaOGL0oYZOmF3E9+eBqFfvaN5lMjRy17GcdXkDBnsbStbJ5LqcAIkbloldTeEFV+4dNGm//Sn0yFvqf5m94n01hDDQLfRFtxc2CqYSCwUb5gue3bWp5Qj0Azmp5WpScLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792228629; c=relaxed/simple;
	bh=+0fs+1bh9pKq/fSJgUPHzoZncSSNo1KhoUbkiRKzAtI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=GInYYyM6Az/21OjDwaxWpOrSQAyI4w03lvMFUjieasdz3NrqIodvvZILUvuleuFsaWw5bSXHJCkCmXcC44SWblImAs4BsUo+fZ5lyjNs1x1bEkRM7agzrSZAF77nEqMjKtS1MstvverAPWN2CUCoVw+8tWSQY0S9maPldi8kFIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=P1DYyaQV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=S21BPmRI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="P1DYyaQV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="S21BPmRI"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69H6oLt2813566
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 09:17:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=KnPUuj5aMqNNHSNLEaTHlq
	N8sXtrE2/ObeXdIeNsDcI=; b=P1DYyaQVnu4fo0S4SXkzVG7nq8dYcEsfOlxduq
	GkvEMJjZwf4ZjQ3x80ehm46VWyZ2XKyjo/CudfKDmQGb1SBuh4G6brQe/hOCxeRo
	4aDVWxN+y28uAfJwMwYQ1PLZCEMBtJShaTYCmiwYUBJplocJuM+MHvn9SUFsKx+b
	yPkT5rc11XIjpzM9oY51rF3SJa/4sJMQ+miex3cZ7gBSxWI0B2thXf3wHF4GsQOG
	cT103tZ2kUMBDugGv8R1rYUh3cslfcbY3UViK9TdjhAgjr/7PSZR73+3AFgBYGtZ
	N7DNNmcsBDn5LeGcUFjdRdEZ8e0QrRdMdK5w3371Zapdo5EA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hc016gq4g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 09:17:06 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93ca9b53afaso219159685a.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 02:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792228626; x=1792833426; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KnPUuj5aMqNNHSNLEaTHlqN8sXtrE2/ObeXdIeNsDcI=;
        b=S21BPmRI1Y5q+eLRehfD8RmmpI+hSnAvrNQOQrjOpN/VlCilwthcAeNMILjFjeVHkE
         LdUHq1Uj6gVgrIIiEhqaUavjb8/t9omaT9xzgsomaF0WC8nkmUIO5AtDZK/iQrnGfAQF
         VMyrPCTv9ZGwns1IzqlpPID96K1cTrEg6kJImpVirXFq7ugWe9pO/tr3iMIEiq4PZOkX
         Uy/iv8HOnNs0PtAqa3Prb/coWauUZzBIOpOWCA3TvmlNueDYLfLz4MBeuo6EEk2WTSTs
         wlZiUODLwa9Lp/HdKvbL5nxVLWjFPndET8/KmHGNihsGnmGFyWynE8s8v916WwsHJdya
         AbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792228626; x=1792833426;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=KnPUuj5aMqNNHSNLEaTHlqN8sXtrE2/ObeXdIeNsDcI=;
        b=UBauwuyyXfvYsNJqh5nm8Pf2ihWYJgS7K9Tjhv43j1tVyLtaqqqG/7h7rN0DDqppCk
         la7kyr/Xt4+XY/wYQiaePW0fDr+Wc760FEu3xQFUsTG7NYmccXKihtmXH0uXpVeKgP9w
         I9mL45dgs7G57PGkRoSkl8N0NrLREr+7ZxoS67ktzhyv07ptO7nxXgKi/W7fzpHl8qRB
         6ZW3iJ/+8q2jlWyast0GJZtPMdBaMiPWqfD4x8SKFwtq80kruP7hzxO7X0KjVqUh2YY2
         lz1aqsC/oSS39STExmOoS79Dd9PthUW6FtOq0Ubac4+YRdxK40yPPsfj14xUMHQG4dZr
         8Qlg==
X-Forwarded-Encrypted: i=1; AKwUvByTQuej8+m6EW9ohzWV8+JFQgM18U9pmMMvVUt4EbfOaMdfyN+dpdKwMr/Tyq7WywvKInX0EPvUdC+HmHeS7A==@vger.kernel.org
X-Gm-Message-State: AFq9FYIX97mBee4i7C7QdqsW1JTpHG8IDvL6PH92hH+LLsYW1XAGnM+o
	OYvgQF6Q024T+qoPkbNBk+B1R28HGVtnToqXl6vUlwGDoWv3qi1Kz7Xzkfpa0dHOCGDfLN3On4f
	HW6VfWUcqpzbHKZlR+z70/746wD5/45QGLsgwEGzyKOqbvBZLF1YvjoQHsbRXztpPamQSCw==
X-Gm-Gg: AYBFou26Ympe2eAlFpoTA9IWV7NBdnNamruBtVARXeF13v9FNNz+es6mltuJ7MOmFPM
	Uz7B4jk9S3oNwibK/Jjro4BV+mNuCFhgDHvVM28YvOo3JoO4Ri9mLUjf+7IUe6y5u/p/pHulXhe
	29i+1YpofD7gnaZLBdXq85zcqLxDwVjjHsYJMdbUFQiZQO5PBejTteW3QZpp6Lstnp9/O2MeZNn
	tAqol2phLi8qlp3GSbJOylwWMSfT6oy8XwwdSEgQ9gOe/oDnG3OKDkYEDxIh8xKJMshIz1c2s1s
	TnFJOUdnX9gsVM+n0FWwILBP5p52hk/3am3qg+teDYV+qmVHrr5uqab6RKDGVxwerBaz6SylQvu
	5K/gLmRBpDDFSiA==
X-Received: by 2002:a05:620a:3715:b0:93f:e53:a55c with SMTP id af79cd13be357-93f29e15e23mr358544585a.78.1792228625736;
        Sat, 17 Oct 2026 02:17:05 -0700 (PDT)
X-Received: by 2002:a05:620a:3715:b0:93f:e53:a55c with SMTP id af79cd13be357-93f29e15e23mr358540485a.78.1792228625090;
        Sat, 17 Oct 2026 02:17:05 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c8a81587sm235189965e9.1.2026.10.17.02.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 02:17:04 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Sat, 17 Oct 2026 11:16:29 +0200
Subject: [PATCH ath-current] wifi: ath12k: fix DMA direction for
 re-injected Rx buffers
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261017-ath12k-fix-dma-mapping-for-reinject-packets-v1-1-b94860e18ba4@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2NQQ6CQAwAv0J6tgm7gge/YjzUUqASyqa7GhPC3
 91wnMPM7JDFVTLcmx1cvpp1swrh0gDPZJOgDpUhtvEW2tAhlTnEBUf94bASrpSS2oTj5uii9hY
 umIgXKRmj0OvaMfXEDLWYXKp33h5QQ8gfd7ECz+P4AzYMKaOKAAAA
X-Change-ID: 20261014-ath12k-fix-dma-mapping-for-reinject-packets-2eab34ca5acc
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE3MDAzNiBTYWx0ZWRfX4ojILeukZIH/
 2ZzLNmaCD5U20V9h4vpGJCyJEBEs0UJ0Ttk7HZTLCIS27T6fP/YpTpjChzYritE/ha4tQ2mtalF
 mAt+vBCOg3c6y2L+tsBI/H6FzdGIAwU=
X-Proofpoint-GUID: PngSnOFzs5mkUSgtViiW_69PCyMbainw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE3MDAzNiBTYWx0ZWRfX/ZeBl+m2Nyyl
 detTIe+2riMGdFP6INdV0Q1J/XDZunVUDAXqV/Ukxq9tGmtLo0il7jTyHCD0DFglhFQI9J6T0AD
 AIEAUDgu/SHZUYajFh/FavKarIchtNF8RgEq68K4c2OsN3g19yR1/1lEYeI4LVqZ13y6EdQ+/l5
 QuJEkqJ3aomRSZB7cvCQXIUMAp/2FMI/gChoczjKQVKLYRDyUju08P7erkLXdpBemsajBmz7egY
 uFKGfeKYZ83gc5orvgkD1AOFwVCSwKpZVrIbZi0yFtPpg4vAumxsaxeBmVwROSnpKjz7gL/J119
 uAsuQwX7bgGudTrEaH5Y9GvPWAdrJKvGK7owrYtPvJp55BC4567vf9/WTmASbVtncvIIvifwkfO
 2z2JxGFqx7qRKnN7QClkMm105OjBLpwX/5cF7u//sP1+WqLpEd4JTvW9sxoV9Gqw3sta1k6kZuE
 kTi+w+Jf5x4Vfn1x/OA==
X-Authority-Analysis: v=2.4 cv=COm/zhrD c=1 sm=1 tr=0 ts=6ad33d12 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=rRFOUk4aQ60LmtyAjc4A:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: PngSnOFzs5mkUSgtViiW_69PCyMbainw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-17_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610170036

Defragmented MPDUs that are re-injected into the REO are mapped with
DMA_TO_DEVICE, but all the Rx reap and teardown paths unmap them with
DMA_FROM_DEVICE. The DMA API requires the unmap direction to match the
map direction, so this violates the contract.

The mapping actually spans both directions, since the host has written
the buffer before the REO reads it and the buffer is read back by the
host afterwards, so DMA_BIDIRECTIONAL is the correct choice.

Add a 'reinjected' flag to struct ath12k_skb_rxcb and a common
ath12k_dp_unmap_rx_buf() helper that selects DMA_BIDIRECTIONAL for
re-injected buffers and DMA_FROM_DEVICE otherwise, then use it in all the
Rx reap and cleanup paths. Map and unmap the re-injected buffer with
DMA_BIDIRECTIONAL consistently.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 33322e3ef074 ("wifi: ath12k: change DMA direction while mapping reinjected packets")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.h         |  1 +
 drivers/net/wireless/ath/ath12k/dp.c           |  6 ++--
 drivers/net/wireless/ath/ath12k/dp_mon.c       |  8 ++++--
 drivers/net/wireless/ath/ath12k/dp_rx.c        |  4 +--
 drivers/net/wireless/ath/ath12k/dp_rx.h        | 11 ++++++++
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c | 17 +++--------
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c  | 39 +++++++++-----------------
 7 files changed, 38 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 93fd227b4d19..7b34a530b245 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -149,6 +149,7 @@ struct ath12k_skb_rxcb {
 	u8 tid;
 	u16 peer_id;
 	bool is_end_of_ppdu;
+	bool reinjected;
 };
 
 enum ath12k_hw_rev {
diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index f9b37d75956d..bca719b30281 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -5,6 +5,7 @@
  */
 
 #include "core.h"
+#include "dp_rx.h"
 #include "dp_tx.h"
 #include "hif.h"
 #include "hal.h"
@@ -998,10 +999,7 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 				if (!skb)
 					continue;
 
-				dma_unmap_single(ab->dev,
-						 ATH12K_SKB_RXCB(skb)->paddr,
-						 skb->len + skb_tailroom(skb),
-						 DMA_FROM_DEVICE);
+				ath12k_dp_unmap_rx_buf(dp, skb);
 				dev_kfree_skb_any(skb);
 			}
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 7d5be77b081f..9225a3e23e14 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -5,6 +5,7 @@
  */
 
 #include "dp_mon.h"
+#include "dp_rx.h"
 #include "debug.h"
 #include "dp_tx.h"
 #include "peer.h"
@@ -68,6 +69,7 @@ struct sk_buff
 	if (*buf_id < 0)
 		goto fail_dma_unmap;
 
+	ATH12K_SKB_RXCB(skb)->reinjected = false;
 	ATH12K_SKB_RXCB(skb)->paddr = paddr;
 	return skb;
 
@@ -561,9 +563,7 @@ ath12k_dp_mon_parse_status_buf(struct ath12k_pdev_dp *dp_pdev,
 		return 0;
 	}
 
-	dma_unmap_single(ab->dev, ATH12K_SKB_RXCB(msdu)->paddr,
-			 msdu->len + skb_tailroom(msdu),
-			 DMA_FROM_DEVICE);
+	ath12k_dp_unmap_rx_buf(dp, msdu);
 
 	offset = packet_info->dma_length + ATH12K_MON_RX_DOT11_OFFSET;
 	if (ath12k_dp_pkt_set_pktlen(msdu, offset)) {
@@ -630,6 +630,7 @@ int ath12k_dp_mon_buf_replenish(struct ath12k_base *ab,
 		if (unlikely(!mon_buf))
 			goto fail_idr_remove;
 
+		ATH12K_SKB_RXCB(skb)->reinjected = false;
 		ATH12K_SKB_RXCB(skb)->paddr = paddr;
 
 		cookie = u32_encode_bits(buf_id, DP_RXDMA_BUF_COOKIE_BUF_ID);
@@ -719,6 +720,7 @@ int ath12k_dp_mon_status_bufs_replenish(struct ath12k_base *ab,
 		if (!desc)
 			goto fail_buf_unassign;
 
+		ATH12K_SKB_RXCB(skb)->reinjected = false;
 		ATH12K_SKB_RXCB(skb)->paddr = paddr;
 
 		num_remain--;
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 8fa0e90b4531..0003cc5a3720 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -138,6 +138,7 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_dp *dp,
 		if (!rx_desc)
 			goto fail_dma_unmap;
 
+		ATH12K_SKB_RXCB(skb)->reinjected = false;
 		rx_desc->skb = skb;
 		cookie = rx_desc->cookie;
 
@@ -185,8 +186,7 @@ static int ath12k_dp_rxdma_mon_buf_ring_free(struct ath12k_base *ab,
 		/* TODO: Understand where internal driver does this dma_unmap
 		 * of rxdma_buffer.
 		 */
-		dma_unmap_single(ab->dev, ATH12K_SKB_RXCB(skb)->paddr,
-				 skb->len + skb_tailroom(skb), DMA_FROM_DEVICE);
+		ath12k_dp_unmap_rx_buf(ath12k_ab_to_dp(ab), skb);
 		dev_kfree_skb_any(skb);
 	}
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index 0660db070e92..d036e61d81b9 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -187,6 +187,17 @@ void ath12k_dp_extract_rx_desc_data(struct ath12k_hal *hal,
 	hal->ops->extract_rx_desc_data(rx_info, rx_desc, ldesc);
 }
 
+static inline void ath12k_dp_unmap_rx_buf(struct ath12k_dp *dp,
+					  struct sk_buff *skb)
+{
+	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(skb);
+	enum dma_data_direction dir;
+
+	dir = rxcb->reinjected ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
+	dma_unmap_single(dp->dev, rxcb->paddr, skb->len + skb_tailroom(skb),
+			 dir);
+}
+
 void ath12k_dp_rx_h_undecap(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu,
 			    enum hal_encrypt_type enctype,
 			    bool decrypted,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index 016b0c38e51e..1e0e089bc1b4 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -2721,10 +2721,7 @@ ath12k_wifi7_dp_rx_mon_mpdu_pop(struct ath12k *ar, int mac_id,
 				continue;
 			}
 			if (!rxcb->unmapped) {
-				dma_unmap_single(ar->ab->dev, rxcb->paddr,
-						 msdu->len +
-						 skb_tailroom(msdu),
-						 DMA_FROM_DEVICE);
+				ath12k_dp_unmap_rx_buf(dp, msdu);
 				rxcb->unmapped = 1;
 			}
 			if (drop_mpdu) {
@@ -3137,9 +3134,7 @@ ath12k_wifi7_dp_rx_reap_mon_status_ring(struct ath12k_base *ab, int mac_id,
 				idr_remove(&rx_ring->bufs_idr, buf_id);
 				spin_unlock_bh(&rx_ring->idr_lock);
 
-				dma_unmap_single(ab->dev, rxcb->paddr,
-						 skb->len + skb_tailroom(skb),
-						 DMA_FROM_DEVICE);
+				ath12k_dp_unmap_rx_buf(dp, skb);
 
 				dev_kfree_skb_any(skb);
 				pmon->buf_state = DP_MON_STATUS_REPLINISH;
@@ -3150,9 +3145,7 @@ ath12k_wifi7_dp_rx_reap_mon_status_ring(struct ath12k_base *ab, int mac_id,
 			idr_remove(&rx_ring->bufs_idr, buf_id);
 			spin_unlock_bh(&rx_ring->idr_lock);
 
-			dma_unmap_single(ab->dev, rxcb->paddr,
-					 skb->len + skb_tailroom(skb),
-					 DMA_FROM_DEVICE);
+			ath12k_dp_unmap_rx_buf(dp, skb);
 
 			if (ath12k_dp_pkt_set_pktlen(skb, RX_MON_STATUS_BUF_SIZE)) {
 				dev_kfree_skb_any(skb);
@@ -3289,9 +3282,7 @@ ath12k_wifi7_dp_mon_srng_process(struct ath12k_pdev_dp *pdev_dp, int *budget,
 		}
 
 		rxcb = ATH12K_SKB_RXCB(skb);
-		dma_unmap_single(ab->dev, rxcb->paddr,
-				 skb->len + skb_tailroom(skb),
-				 DMA_FROM_DEVICE);
+		ath12k_dp_unmap_rx_buf(dp, skb);
 
 		end_reason = u32_get_bits(info0, HAL_MON_DEST_INFO0_END_REASON);
 
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 95d87dd67872..512e36687428 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -729,11 +729,7 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 
 		list_add_tail(&desc_info->list, &rx_desc_used_list[device_id]);
 
-		rxcb = ATH12K_SKB_RXCB(msdu);
-		dma_unmap_single(partner_dp->dev, rxcb->paddr,
-				 msdu->len + skb_tailroom(msdu),
-				 DMA_FROM_DEVICE);
-
+		ath12k_dp_unmap_rx_buf(partner_dp, msdu);
 		num_buffs_reaped[device_id]++;
 		dp->device_stats.reo_rx[ring_id][dp->device_id]++;
 
@@ -749,6 +745,7 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 		msdu_info = &desc->rx_msdu_info;
 		mpdu_info = &desc->rx_mpdu_info;
 
+		rxcb = ATH12K_SKB_RXCB(msdu);
 		rxcb->is_first_msdu = !!(le32_to_cpu(msdu_info->info0) &
 					 RX_MSDU_DESC_INFO0_FIRST_MSDU_IN_MPDU);
 		rxcb->is_last_msdu = !!(le32_to_cpu(msdu_info->info0) &
@@ -846,6 +843,7 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 						    struct ath12k_dp_rx_tid *rx_tid,
 						    struct sk_buff *defrag_skb)
 {
+	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(defrag_skb);
 	struct ath12k_base *ab = dp->ab;
 	struct ath12k_hal *hal = dp->hal;
 	struct hal_rx_desc *rx_desc = (struct hal_rx_desc *)defrag_skb->data;
@@ -894,10 +892,13 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 
 	buf_paddr = dma_map_single(dp->dev, defrag_skb->data,
 				   defrag_skb->len + skb_tailroom(defrag_skb),
-				   DMA_TO_DEVICE);
+				   DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dp->dev, buf_paddr))
 		return -ENOMEM;
 
+	rxcb->reinjected = true;
+	rxcb->paddr = buf_paddr;
+
 	spin_lock_bh(&dp->rx_desc_lock);
 	desc_info = list_first_entry_or_null(&dp->rx_desc_free_list,
 					     struct ath12k_rx_desc_info,
@@ -915,8 +916,6 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 	list_del(&desc_info->list);
 	spin_unlock_bh(&dp->rx_desc_lock);
 
-	ATH12K_SKB_RXCB(defrag_skb)->paddr = buf_paddr;
-
 	ath12k_wifi7_hal_rx_buf_addr_info_set(&msdu0->buf_addr_info, buf_paddr,
 					      desc_info->cookie,
 					      HAL_RX_BUF_RBM_SW3_BM);
@@ -983,8 +982,8 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 	list_add_tail(&desc_info->list, &dp->rx_desc_free_list);
 	spin_unlock_bh(&dp->rx_desc_lock);
 err_unmap_dma:
-	dma_unmap_single(dp->dev, buf_paddr, defrag_skb->len + skb_tailroom(defrag_skb),
-			 DMA_TO_DEVICE);
+	ath12k_dp_unmap_rx_buf(dp, defrag_skb);
+
 	return ret;
 }
 
@@ -1286,7 +1285,6 @@ ath12k_wifi7_dp_process_rx_err_buf(struct ath12k_pdev_dp *dp_pdev,
 	struct ath12k_dp *dp = dp_pdev->dp;
 	struct ath12k_hal *hal = dp->hal;
 	struct sk_buff *msdu;
-	struct ath12k_skb_rxcb *rxcb;
 	struct hal_rx_desc_data rx_info;
 	struct hal_rx_desc *rx_desc;
 	u16 msdu_len;
@@ -1316,11 +1314,7 @@ ath12k_wifi7_dp_process_rx_err_buf(struct ath12k_pdev_dp *dp_pdev,
 	desc_info->skb = NULL;
 
 	list_add_tail(&desc_info->list, used_list);
-
-	rxcb = ATH12K_SKB_RXCB(msdu);
-	dma_unmap_single(dp->dev, rxcb->paddr,
-			 msdu->len + skb_tailroom(msdu),
-			 DMA_FROM_DEVICE);
+	ath12k_dp_unmap_rx_buf(dp, msdu);
 
 	if (drop) {
 		dev_kfree_skb_any(msdu);
@@ -1367,7 +1361,6 @@ static int ath12k_dp_h_msdu_buffer_type(struct ath12k_dp *dp,
 					struct hal_reo_dest_ring *desc)
 {
 	struct ath12k_rx_desc_info *desc_info;
-	struct ath12k_skb_rxcb *rxcb;
 	struct sk_buff *msdu;
 	u64 desc_va;
 
@@ -1398,9 +1391,7 @@ static int ath12k_dp_h_msdu_buffer_type(struct ath12k_dp *dp,
 	msdu = desc_info->skb;
 	desc_info->skb = NULL;
 	list_add_tail(&desc_info->list, list);
-	rxcb = ATH12K_SKB_RXCB(msdu);
-	dma_unmap_single(dp->dev, rxcb->paddr, msdu->len + skb_tailroom(msdu),
-			 DMA_FROM_DEVICE);
+	ath12k_dp_unmap_rx_buf(dp, msdu);
 	dev_kfree_skb_any(msdu);
 
 	return 0;
@@ -1971,12 +1962,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 		}
 
 		list_add_tail(&desc_info->list, &rx_desc_used_list[device_id]);
-
-		rxcb = ATH12K_SKB_RXCB(msdu);
-		dma_unmap_single(partner_dp->dev, rxcb->paddr,
-				 msdu->len + skb_tailroom(msdu),
-				 DMA_FROM_DEVICE);
-
+		ath12k_dp_unmap_rx_buf(partner_dp, msdu);
 		num_buffs_reaped[device_id]++;
 		total_num_buffs_reaped++;
 
@@ -1990,6 +1976,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 		}
 
 		msdu_data = (struct hal_rx_desc *)msdu->data;
+		rxcb = ATH12K_SKB_RXCB(msdu);
 		rxcb->err_rel_src = err_info.err_rel_src;
 		rxcb->err_code = err_info.err_code;
 		rxcb->is_first_msdu = err_info.first_msdu;

---
base-commit: 08a3f02fea636e97a7422d1512f76dacdb5b0887
change-id: 20261014-ath12k-fix-dma-mapping-for-reinject-packets-2eab34ca5acc

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

