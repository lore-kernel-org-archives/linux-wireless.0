Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBD4353A85
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 13:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465391; cv=none; b=nk5mFWOEhTBVyLmr6ngx07t/pMv3o310Lk7VG83nc+EakJ+bfIjV+1jjGJNFxFGmLpj1k6HibPDAHxOjX1UVdN0jPGZznKSS4/nnuQYc3wG4GeULudAl9a9VpYQyarm/JRZX/7Fs866TNxK6FyQWWRbPOgxiBgsgg2WgBOok9lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465391; c=relaxed/simple;
	bh=HfydEUCKBwFqP9P7Nvht/dkC4HZWfOr4Fg37U17Y0eU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=trXnxg3S0YD+mLteDu1b7VxTRWkL+rIEZUWXVipgjwnp/XtMd2Q57379urHJ9CeXuTUKufnMPx2LveeaNim23miKcSdhXek6Tv90FkL92Up2ygqQwePm9ScDEXgRyMp0eyYO7TaDEGP3sYmOPHjSj6Q6Be89FO06d7Llz3k38XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dLeJT7rd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HtZLfj5K; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dLeJT7rd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HtZLfj5K"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698BJwmg1881908
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 13:16:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rR04Wx2mH8a29cfVx5n0UxzburOUkMVF+wdpj3Q5H8E=; b=dLeJT7rdIe5V/eIC
	mPIvCYv6h44HzZBr5BMfwMJl9lvzaUoP3F1JK1nhoSamF/mNF5vru1JxLX4PWwB0
	4w2FTDAVeclIXmJyt7lxfRAzl3z797BDcD8+b938MDK8olms6ZbZvS0ovgWe5u2c
	vgU3lqknXPXjkczpGESj1Q3pxmqu4uBAWNcq1frx3oHvODMeYQhB8JDRT07gJTLz
	dVxUkSjnukXxBHvtqvOZdnN/Om1T/Qc74uCaDSOwhHOM4dcH+i9hw34Ut9l94BrX
	EVot9OCkXcHj/U6+nuLtYi05NNrKct91epoAnZ8m13gv6pcZoKo8Ns+muo1oIwsU
	XmcxAA==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe2u15r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 13:16:29 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5d88f5414dbso1087058e0c.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 06:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791465389; x=1792070189; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rR04Wx2mH8a29cfVx5n0UxzburOUkMVF+wdpj3Q5H8E=;
        b=HtZLfj5K1MJKeU01CLFbhVmHKc9H2Y09ZkfXzQXW3EGh1sllWpdCTtoBu5YxlKWbyF
         GUEoWytHZ27n/NPU+nfLH4udVdIFh+2gA+focgoCqIxuW/YojTOwVm8w9jDp9SDC1PBn
         MZN4rwbCtLWGan8Dwxfi9o1X3607byrbizW9gOZwuPrcF3wLfr85SKTAdBwBhqlnYsjw
         +2IUtnOXghMog1v5mHNAKKrkTkEB62S0CN1zx5EgGY33/6WXeiHIlfa2A7un2rbdDsES
         GBh+hguwMhrZLvLe45RvwV1rhJeWDNnqBBVRxtaDlS2HNaRuTmcYimdWNa0WMuIa5WfX
         KNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791465389; x=1792070189;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rR04Wx2mH8a29cfVx5n0UxzburOUkMVF+wdpj3Q5H8E=;
        b=mUpPsMEWrtjZBiR803xoIUKDE3VHptHyO6Js1D0VZ1zqUGez1FxA5UJn17O8emi+xZ
         QKVHqCGoa2x27GwfSxzB8eEGFjHxXhGffhBda5hGqrUgmUM1/c85RDbpjQnbAvbO8mxV
         4F22BQaQ5cQ31ygixyZxG26IGxQb6x2PEezSaBWbSV7KXT0+FVxol3RZ0NzoGAIM1A6f
         3CwgPUTwfgT3lLTe1ckrRsKCtBcmL1tNABZVzo33hp1d2SEzlzUrjTcvHpxUditpxF8l
         ZIpKoQ6+KEN7vgE2ArtmT5Cn1mebELotnYWRMQVbsmDiQA42/SNulpmmEdW1wXIIzmu/
         ZO+w==
X-Forwarded-Encrypted: i=1; AKwUvBwEI7bxu/rKeF6wfzZaWA0ZwbBqKZra69hlIZElbzru4K+RSsG0AyLidDFleUUh8wflZG+o+GCmTp08PsWAsg==@vger.kernel.org
X-Gm-Message-State: AFq9FYIsKz/GLbks+e4s3DNpfDjWVAQhrat/TLFuIXMvW+QAYOVS3StZ
	yTQbAicgl5BgGVsR7Ffkth+/b7Pwbzo0amvKOhnHK/wONVl60kU+sdP6eDTxLdRQM98iNSaOOA2
	9+WUQVPCsx5AnoJOWaJyIelgorb02BfmvcjZDHzCI6egozMxReRQu/RImSYaqbh+7SMegAQ==
X-Gm-Gg: AYBFou21RkCjtPggknj/2V9Kl77rFBgu24dvznRXAsgtfiPXnrEXIZoe4k1j9KuJBby
	/VLyKTAn+VA/C6DjM3I4tnc1/e25+QL4SKYaIex0WXcE84t4upAnPrXnCK/ktPighKThDhAExbY
	3SNf08rMpQCBEX0mdlQ6GuDxMrCQvCa/8x10Vggrk1QBIuINWqRtiQ1Df4cXN15+zWmxCvhDYno
	3DgTyoEQ+Ed/FE/n5ijdqXr1+9LdY9zA+q7j+Ak0FBOQ0nwHx0jbtGl3yxXdWS2T/sUDqDoIqa3
	LOokhZiB65bi7r8GPBw57J/eZRj4rsBtM0OhFq48m1xNBuI40q+yNdQMyaT57pyvkHsLBfr06o0
	cvwsJIVVKg1s0yQ==
X-Received: by 2002:a05:6122:310c:b0:5d9:82c1:b343 with SMTP id 71dfb90a1353d-5e6cf587159mr2167920e0c.1.1791465388337;
        Thu, 08 Oct 2026 06:16:28 -0700 (PDT)
X-Received: by 2002:a05:6122:310c:b0:5d9:82c1:b343 with SMTP id 71dfb90a1353d-5e6cf587159mr2167884e0c.1.1791465387744;
        Thu, 08 Oct 2026 06:16:27 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71d2eeb6sm11580902f8f.43.2026.10.08.06.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 06:16:26 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:15:59 +0200
Subject: [PATCH 2/3] wifi: ath12k: fix DMA direction for re-injected Rx
 buffers
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-ath12k-pp-v1-2-68f888cd7eec@oss.qualcomm.com>
References: <20261008-ath12k-pp-v1-0-68f888cd7eec@oss.qualcomm.com>
In-Reply-To: <20261008-ath12k-pp-v1-0-68f888cd7eec@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Ripan Deuri <quic_rdeuri@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA1MiBTYWx0ZWRfX1UuLVoae05oN
 MrppQVW9WRMk04WbA5ZEKgU7gsDzlAi5Tk4V5W3TDivZn04X8TovtfoRl7PiV/K+YdL/ImRBp8u
 WGAG/J8FCWZ7/1MyHTI3GREm1zed9ig=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA1MiBTYWx0ZWRfX5FNOLsI/lJyV
 8oF1ra/DC87Mo/7ZRVjOfN56eWqeb8KeD7X0MMzNNAeDr4OvKJ0jp6crXVe3XvTV3jpcPvJ8V8k
 o+CZyJZ/fg9NKVqZDzGCt/Xwjz18aZeqXBvCVriFw2FijdxML9HG6HqM/4CeLdJmA17Lsp803yd
 ITRy06K+tL7XEXD37iEZ9nrSXIimlP+yV0PTURGn1gErDSPTodG00DqpHP9nICC4yUD/7LeFrxM
 YO/pcqoB0lgxYFMKyxBkFmEJtxE2TLF4nkNHDYyXOjnqSEB6W9gZiUtOhQXwaPj9vnn0JmRWJdw
 i11dWVnr8CXfGv2vfgoU6mfdalavaboPV4ozcSUQCI/CmOdTfYDifwldGk8+JAlK+LvU+iGPyj+
 ubDkVktmnMrLckiHJxGyh9Nn1jXbQXYdC2U8t5kqfB6k324GZCLex4NEN9nuSb+kvpC4J1lgFHT
 we/bZfz5rTWNjWmyU/Q==
X-Proofpoint-ORIG-GUID: cirTYFWkt6SEniY5FrDWdepGk-mPpw4x
X-Proofpoint-GUID: cirTYFWkt6SEniY5FrDWdepGk-mPpw4x
X-Authority-Analysis: v=2.4 cv=CIm/zhrD c=1 sm=1 tr=0 ts=6ac797ad cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=uUysdbmPE_KshqraYcwA:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_04,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1011 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080052

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
 drivers/net/wireless/ath/ath12k/dp.c           |  5 +---
 drivers/net/wireless/ath/ath12k/dp_rx.h        | 11 ++++++++
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c |  5 +---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c  | 37 +++++++++-----------------
 5 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 99d71dab7c04..7a219249dc51 100644
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
index 83f9edfabf69..dd3b0dcfa055 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1003,10 +1003,7 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 					continue;
 
 				if (!ATH12K_SKB_RXCB(skb)->unmapped)
-					dma_unmap_single(ab->dev,
-							 ATH12K_SKB_RXCB(skb)->paddr,
-							 skb->len + skb_tailroom(skb),
-							 DMA_FROM_DEVICE);
+					ath12k_dp_unmap_rx_buf(dp, skb);
 				dev_kfree_skb_any(skb);
 			}
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index 82700474548a..c3715c99054f 100644
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
index 1e29c13ad66d..e7d5dfa31361 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -2722,10 +2722,7 @@ ath12k_wifi7_dp_rx_mon_mpdu_pop(struct ath12k *ar, int mac_id,
 				drop_mpdu = true;
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
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 633cb91b9e5d..9cd9c0bb07db 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -741,11 +741,7 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 
 		list_add_tail(&desc_info->list, &rx_desc_used_list[device_id]);
 
-		rxcb = ATH12K_SKB_RXCB(msdu);
-		dma_unmap_single(partner_dp->dev, rxcb->paddr,
-				 msdu->len + skb_tailroom(msdu),
-				 DMA_FROM_DEVICE);
-
+		ath12k_dp_unmap_rx_buf(partner_dp, msdu);
 		num_buffs_reaped[device_id]++;
 		dp->device_stats.reo_rx[ring_id][dp->device_id]++;
 
@@ -761,6 +757,7 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 		msdu_info = &desc->rx_msdu_info;
 		mpdu_info = &desc->rx_mpdu_info;
 
+		rxcb = ATH12K_SKB_RXCB(msdu);
 		rxcb->is_first_msdu = !!(le32_to_cpu(msdu_info->info0) &
 					 RX_MSDU_DESC_INFO0_FIRST_MSDU_IN_MPDU);
 		rxcb->is_last_msdu = !!(le32_to_cpu(msdu_info->info0) &
@@ -858,6 +855,7 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 						    struct ath12k_dp_rx_tid *rx_tid,
 						    struct sk_buff *defrag_skb)
 {
+	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(defrag_skb);
 	struct ath12k_base *ab = dp->ab;
 	struct ath12k_hal *hal = dp->hal;
 	struct hal_rx_desc *rx_desc = (struct hal_rx_desc *)defrag_skb->data;
@@ -906,10 +904,13 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 
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
@@ -927,8 +928,6 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 	list_del(&desc_info->list);
 	spin_unlock_bh(&dp->rx_desc_lock);
 
-	ATH12K_SKB_RXCB(defrag_skb)->paddr = buf_paddr;
-
 	ath12k_wifi7_hal_rx_buf_addr_info_set(&msdu0->buf_addr_info, buf_paddr,
 					      desc_info->cookie,
 					      HAL_RX_BUF_RBM_SW3_BM);
@@ -996,7 +995,7 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 	spin_unlock_bh(&dp->rx_desc_lock);
 err_unmap_dma:
 	dma_unmap_single(dp->dev, buf_paddr, defrag_skb->len + skb_tailroom(defrag_skb),
-			 DMA_TO_DEVICE);
+			 DMA_BIDIRECTIONAL);
 	return ret;
 }
 
@@ -1298,7 +1297,6 @@ ath12k_wifi7_dp_process_rx_err_buf(struct ath12k_pdev_dp *dp_pdev,
 	struct ath12k_dp *dp = dp_pdev->dp;
 	struct ath12k_hal *hal = dp->hal;
 	struct sk_buff *msdu;
-	struct ath12k_skb_rxcb *rxcb;
 	struct hal_rx_desc_data rx_info;
 	struct hal_rx_desc *rx_desc;
 	u16 msdu_len;
@@ -1328,11 +1326,7 @@ ath12k_wifi7_dp_process_rx_err_buf(struct ath12k_pdev_dp *dp_pdev,
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
@@ -1379,7 +1373,6 @@ static int ath12k_dp_h_msdu_buffer_type(struct ath12k_dp *dp,
 					struct hal_reo_dest_ring *desc)
 {
 	struct ath12k_rx_desc_info *desc_info;
-	struct ath12k_skb_rxcb *rxcb;
 	struct sk_buff *msdu;
 	u64 desc_va;
 
@@ -1410,9 +1403,7 @@ static int ath12k_dp_h_msdu_buffer_type(struct ath12k_dp *dp,
 	msdu = desc_info->skb;
 	desc_info->skb = NULL;
 	list_add_tail(&desc_info->list, list);
-	rxcb = ATH12K_SKB_RXCB(msdu);
-	dma_unmap_single(dp->dev, rxcb->paddr, msdu->len + skb_tailroom(msdu),
-			 DMA_FROM_DEVICE);
+	ath12k_dp_unmap_rx_buf(dp, msdu);
 	dev_kfree_skb_any(msdu);
 
 	return 0;
@@ -1998,12 +1989,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
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
 
@@ -2017,6 +2003,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 		}
 
 		msdu_data = (struct hal_rx_desc *)msdu->data;
+		rxcb = ATH12K_SKB_RXCB(msdu);
 		rxcb->err_rel_src = err_info.err_rel_src;
 		rxcb->err_code = err_info.err_code;
 		rxcb->is_first_msdu = err_info.first_msdu;

-- 
2.56.0

