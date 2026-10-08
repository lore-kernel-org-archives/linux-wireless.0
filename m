Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EEC3B71D6
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 13:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465396; cv=none; b=LL0CZUmOSrwwtLjPPY53PcRRDNvmH/qLUheudAT005I/MRkYgP+3X0UVpogMdnIzR2DhCId+XWYHdMR2ZwqKHp1K/o/UmQTshZ0L94A/R+vTtus9m0ePNiAvmNszdKIfR/uafV3++wTpRqxGVFBDDx9w5HWn8DPVp2oDD5uIS3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465396; c=relaxed/simple;
	bh=eDEdulXniA4y66PCUmNjFpqxEMhY5nsiIa5puMLEC5s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dek+hqyJeei+5M8qtJeJ5PSSgGarlrKPxHNyTL15wu0qXgQ+awK1zAd1tyRWmbvCc13yVa75odkJZ5kzbJ4/xh5mla7sM2VgwG6vhzpQ7KQd9SjkbfavN7D9X0WyqxNoTbwCaTZD2w71Fql9MKEXlRcAAcURKHP9y0WNCtTVDu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TCkJRFhI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WULuADDh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TCkJRFhI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WULuADDh"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698CXMnB2763184
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 13:16:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	C5Iqq+539NbNLhX/V3buU/n4i1mDEyjrAaiCEdRrr0s=; b=TCkJRFhILIiqEHtp
	X3EsA4PsPTImskFHNi0WBJgPZbrT40UY/nQ0BH2FTM1d32gDFgQNOS526gTxwuc9
	gwoyAy93SGE5Tqj2eNmAk5dHRMWOv0u89axtwHouipkA1oRv4e3czz1weA91UUnm
	bu+EAYSM2OO63fuThK6dXE4tnGPWRDECAKXKa9prdT8ptZAAfVvMXaS7X+f7EooV
	O4wmbg9ysSRVk60FDNq/0YDS8LiLUMkjqmp1sZHc3aXxxvgwxy4lMtnKtkgrnUP7
	8wUsVIlSWLBO4n3O19KWqSyBgv4XSMFHtaoFN9MQ3fDCJcmdX2U3khE6Y2tdDyAP
	NFS3wg==
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com [209.85.222.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6b9kg580-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 13:16:33 +0000 (GMT)
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-98087b0c5deso3767922241.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 06:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791465393; x=1792070193; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C5Iqq+539NbNLhX/V3buU/n4i1mDEyjrAaiCEdRrr0s=;
        b=WULuADDhNrt+aDPOwtlCVl1dILyrxTRTFsM4M+PYh8V74Xggbf73xPF8XhcH/bIj/z
         /vmY26WfWROFoQMhfPtik/o4QarwrJxgv5kPPz4BfeYxkNPno/ZB4hnxj06gSjBt2qXT
         79oIDltk6EvPp1rUV9z7kZwKFH50TWkEk1rWb3IPDdN4tcIB+lMcYDDaqEx+kUu4grDL
         i8BlyvBP19wS2B5kM5d1k/y0Xc+lc1lfdpCSotrgWYWI6130eGb+BI4ui8n06Alt3lTF
         gOYFGxNaFnwfg7NFHmHiSShtx6KMbrCl3d/S2to8nyWmr3ccIoMFOaVhsYR80pp7mBBv
         CJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791465393; x=1792070193;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C5Iqq+539NbNLhX/V3buU/n4i1mDEyjrAaiCEdRrr0s=;
        b=wpudhzbeCIkanVM4wyTv3rmdD14+UZ8h12WMjfbqGS0dRoe7BkdPjRzXK5/GEvI0+p
         Cz5LrWjJCpRbdDPMrDTsZpQfIvFKUPvLvYBIA3wjD0KwQnGs29YX5N8r22+sSmxWIb6i
         1vhaISHGIeMc3XlEheW8iWOPDm6RSQ3G82mdkZGor9hXa1sbVy1FeP1qnj8HMWZ6Mxtw
         QW8NMEKvn/GQ4q1PjNyCfEndTM6woUOhUDzzPeJmhpGse6Sc0O7NryYrQ2udC0Nkoj77
         C91hh2df6L49S7sSIM/IGuFmEgReKcrZPdoKCtlwJx1oNuEIIkgkgGBXUs8+hhhIIM5t
         gPww==
X-Forwarded-Encrypted: i=1; AKwUvBwRCQnGnOpdZoZuBcB4QFBRJr+8wk75rixBwI2AlIiNrNWP/sHpOw/ajLT8UpOqC1Z70DG2Q6HhsCY1f/wKLw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKxFcNiy6kyE9jYT+yIckOc7J5yqSkWtbmqumwqnrm+vz6jmAQD
	/LNL7GEI5JmH5Ay1u/+VdndisyctAospexxj9Rzy3yPdMH6qGMVYI0mQ0NSIX1EUBo0lf2ojEje
	R8um5/pbdTcwcKaM5UdgIwZ0LeBywKS4LvJ/SUahcrgoAy5KDMaSdwI0GPlJKQ2ZyxeuWvw==
X-Gm-Gg: AYBFou0UnWykDcpDYt9VpkbwoPtIq5SdpvW542HEqYeNAkeEB0mjQIPrSwYQst2e7dl
	lxKTtFPgVdwLD86MHGsP5V6IU+4WuVQYMBIq4hDXB7jOfip37dGvlppwe5QwFG99JD8+Mpowck2
	4YrkjQcSjaO5iJYo8t7wKQPfVvSxRvanX3pZvVopTKDDXx15AraDq46e3vTuKgbexr7TbYh+7V3
	+G+quyqrmBzZsStxLmgDyIbrcPUZnYhmKkaj7WTsgeyCjtzjrVb+QxwFnJmtRSeEYqOdI5GKU4y
	h6k3iP2IWJW+EId5suHFPTaa8EZBjzq7M3UNTWRk9nLeRidfM/i23ZICbQBiYJWGOYVKebEPHqq
	AHiBgFU/mdk4SpQ==
X-Received: by 2002:a05:6122:ca6:b0:5d6:36d0:d212 with SMTP id 71dfb90a1353d-5e6d0064f31mr2295137e0c.3.1791465392754;
        Thu, 08 Oct 2026 06:16:32 -0700 (PDT)
X-Received: by 2002:a05:6122:ca6:b0:5d6:36d0:d212 with SMTP id 71dfb90a1353d-5e6d0064f31mr2295107e0c.3.1791465392122;
        Thu, 08 Oct 2026 06:16:32 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71c0b60fsm11414674f8f.8.2026.10.08.06.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 06:16:29 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:16:00 +0200
Subject: [PATCH 3/3] wifi: ath12k: rely on page_pool APIs for buffer
 allocation
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-ath12k-pp-v1-3-68f888cd7eec@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: TWkRpsKTv7ssdY_dyKwNeaDrGkMLww_K
X-Authority-Analysis: v=2.4 cv=U98Hnuru c=1 sm=1 tr=0 ts=6ac797b1 cx=c_pps
 a=R6oCqFB+Yf/t2GF8e0/dFg==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=5xX5sZLfjk1LizbPsLcA:9 a=QEXdDO2ut3YA:10
 a=TD8TdBvy0hsOASGTdmB-:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA1MiBTYWx0ZWRfX1RpUadOqmEe3
 PPF9IVtFo7uDjJFlNuLZaSW9O7+pbE50jpTjGwcS3IM6uGm3v8kzA/Q3Ca/CKp41zr0JXgxcXoS
 Thter/F2IbO9nHgpBcdmd6b9vrH7ZdI=
X-Proofpoint-GUID: TWkRpsKTv7ssdY_dyKwNeaDrGkMLww_K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA1MiBTYWx0ZWRfX0RKmt+eoKZK3
 TKX7uRevkyoP3bqpEOzUDyVH++TgtzYGQYP7A9KT5z08BrhniSz930A8UBU5ZoJ7sUXl37swDnw
 AgWgYOQKA5dJbRW2KuJR74EQNQTkCkLmZES50WZzkj+4rNfUBHvTZ83rjEUCvB46XK7tCLXXDu6
 4iiHNWA7FOg0d9oT7y5A7xyOwWVyUQ3AEyBgjqPFVz8Xe6uckz3m24so1eVDw3YJ9VkECVoEX2v
 7zW/D3FL/h9t6Kc+Phcc4YdQnkO9CdGGhZIRlzisbDiZ4TEmG0xpvgXyzP9BXn41Z/QpCUbt91/
 EJs63EGjNLIeG5YVD5OAV9G2tcAU6MF3HUqelVek/IY4bP2WBBNN8RUVuRV3OdHAQgigy1Ugmiz
 kFQ4FxXfTZF0/4sLnYl6G1lWLqWcq+aj21pcBoaKfbuXpM6T27I/Z1np836nQmYoG8ZTEY7NgKA
 zqWuV4uRYJ+GLoHBdFQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_04,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 clxscore=1011 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080052

Convert the Rx refill buffers to the page_pool API instead of allocating
an skb with dev_alloc_skb() and mapping it with dma_map_single(). The pool
handles the DMA mapping and buffer recycling.

Add a page_pool to struct dp_rxdma_ring, created in
ath12k_dp_rxdma_ring_buf_setup() and destroyed in
ath12k_dp_rxdma_ring_buf_cleanup().

Update ath12k_dp_unmap_rx_buf() to sync page_pool buffers for the CPU
instead of unmapping them, and guard the teardown paths
(ath12k_dp_cc_cleanup(), ath12k_dp_h_msdu_buffer_type()) against
page_pool buffers. In the re-inject path, sync an already mapped
page_pool buffer for the device instead of mapping it again, and fill the
descriptor with the DMA address stored in the rxcb.

The monitor, CE and TX paths are left unchanged.

This is just preliminary support: the goal is to use a single page to map
two separated fragments of 2048B.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/Kconfig       |   1 +
 drivers/net/wireless/ath/ath12k/dp.h          |   1 +
 drivers/net/wireless/ath/ath12k/dp_rx.c       | 101 ++++++++++++++++++--------
 drivers/net/wireless/ath/ath12k/dp_rx.h       |  32 ++++++--
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c |  34 ++++++---
 5 files changed, 121 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/Kconfig b/drivers/net/wireless/ath/ath12k/Kconfig
index 0d5d1c55bfc1..13985daffaee 100644
--- a/drivers/net/wireless/ath/ath12k/Kconfig
+++ b/drivers/net/wireless/ath/ath12k/Kconfig
@@ -7,6 +7,7 @@ config ATH12K
 	select QRTR
 	select QRTR_MHI
 	select PCI_PWRCTRL_PWRSEQ if HAVE_PWRCTRL
+	select PAGE_POOL
 	help
 	  Enable support for Qualcomm Technologies Wi-Fi 7 (IEEE
 	  802.11be) family of chipsets, for example WCN7850 and
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index c53eac20b989..599ce3c45c7a 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -59,6 +59,7 @@ struct dp_rxdma_mon_ring {
 
 struct dp_rxdma_ring {
 	struct dp_srng refill_buf_ring;
+	struct page_pool *page_pool;
 	int bufs_max;
 };
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index cfaf26ae2720..de9ea84323df 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -68,6 +68,31 @@ static void ath12k_dp_rx_enqueue_free(struct ath12k_dp *dp,
 	spin_unlock_bh(&dp->rx_desc_lock);
 }
 
+static struct sk_buff *ath12k_dp_rx_build_skb(struct ath12k_dp *dp,
+					      struct dp_rxdma_ring *rx_ring)
+{
+	struct sk_buff *skb;
+	struct page *page;
+
+	if (!rx_ring->page_pool)
+		return NULL;
+
+	page = page_pool_dev_alloc_pages(rx_ring->page_pool);
+	if (!page)
+		return NULL;
+
+	skb = build_skb(page_address(page), PAGE_SIZE);
+	if (!skb) {
+		page_pool_put_full_page(rx_ring->page_pool, page, false);
+		return NULL;
+	}
+
+	ATH12K_SKB_RXCB(skb)->paddr = page_pool_get_dma_addr(page);
+	skb_mark_for_recycle(skb);
+
+	return skb;
+}
+
 /* Returns number of Rx buffers replenished */
 int ath12k_dp_rx_bufs_replenish(struct ath12k_dp *dp,
 				struct dp_rxdma_ring *rx_ring,
@@ -81,7 +106,6 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_dp *dp,
 	int num_free;
 	int num_remain;
 	u32 cookie;
-	dma_addr_t paddr;
 	struct ath12k_rx_desc_info *rx_desc;
 	enum hal_rx_buf_return_buf_manager mgr = dp->hal->hal_params->rx_buf_rbm;
 
@@ -114,51 +138,33 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_dp *dp,
 	}
 
 	while (num_remain > 0) {
-		skb = dev_alloc_skb(DP_RX_BUFFER_SIZE +
-				    DP_RX_BUFFER_ALIGN_SIZE);
+		skb = ath12k_dp_rx_build_skb(dp, rx_ring);
 		if (!skb)
 			break;
 
-		if (!IS_ALIGNED((unsigned long)skb->data,
-				DP_RX_BUFFER_ALIGN_SIZE)) {
-			skb_pull(skb,
-				 PTR_ALIGN(skb->data, DP_RX_BUFFER_ALIGN_SIZE) -
-				 skb->data);
-		}
-
-		paddr = dma_map_single(dp->dev, skb->data,
-				       skb->len + skb_tailroom(skb),
-				       DMA_FROM_DEVICE);
-		if (dma_mapping_error(dp->dev, paddr))
-			goto fail_free_skb;
-
 		rx_desc = list_first_entry_or_null(used_list,
 						   struct ath12k_rx_desc_info,
 						   list);
 		if (!rx_desc)
-			goto fail_dma_unmap;
-
-		rx_desc->skb = skb;
-		cookie = rx_desc->cookie;
+			goto fail_free_skb;
 
 		desc = ath12k_hal_srng_src_get_next_entry(ab, srng);
 		if (!desc)
-			goto fail_dma_unmap;
+			goto fail_free_skb;
 
-		list_del(&rx_desc->list);
-		ATH12K_SKB_RXCB(skb)->paddr = paddr;
+		rx_desc->skb = skb;
+		cookie = rx_desc->cookie;
 
+		list_del(&rx_desc->list);
 		num_remain--;
 
-		ath12k_hal_rx_buf_addr_info_set(dp->hal, desc, paddr, cookie,
-						mgr);
+		ath12k_hal_rx_buf_addr_info_set(dp->hal, desc,
+						ATH12K_SKB_RXCB(skb)->paddr,
+						cookie, mgr);
 	}
 
 	goto out;
 
-fail_dma_unmap:
-	dma_unmap_single(dp->dev, paddr, skb->len + skb_tailroom(skb),
-			 DMA_FROM_DEVICE);
 fail_free_skb:
 	dev_kfree_skb_any(skb);
 out:
@@ -196,12 +202,21 @@ static int ath12k_dp_rxdma_mon_buf_ring_free(struct ath12k_base *ab,
 	return 0;
 }
 
+static void ath12k_dp_rxdma_ring_buf_cleanup(struct dp_rxdma_ring *rx_ring)
+{
+	if (rx_ring->page_pool) {
+		page_pool_destroy(rx_ring->page_pool);
+		rx_ring->page_pool = NULL;
+	}
+}
+
 static int ath12k_dp_rxdma_buf_free(struct ath12k_base *ab)
 {
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	int i;
 
 	ath12k_dp_rxdma_mon_buf_ring_free(ab, &dp->rxdma_mon_buf_ring);
+	ath12k_dp_rxdma_ring_buf_cleanup(&dp->rx_refill_buf_ring);
 
 	if (ab->hw_params->rxdma1_enable)
 		return 0;
@@ -236,11 +251,28 @@ static int ath12k_dp_rxdma_mon_ring_buf_setup(struct ath12k_base *ab,
 static int ath12k_dp_rxdma_ring_buf_setup(struct ath12k_base *ab,
 					  struct dp_rxdma_ring *rx_ring)
 {
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
+		.nid = NUMA_NO_NODE,
+		.dma_dir = DMA_BIDIRECTIONAL,
+		.max_len = PAGE_SIZE,
+		.dev = ab->dev,
+		.offset = 0,
+	};
 	LIST_HEAD(list);
 
 	rx_ring->bufs_max = rx_ring->refill_buf_ring.size /
 			ath12k_hal_srng_get_entrysize(ab, HAL_RXDMA_BUF);
 
+	rx_ring->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(rx_ring->page_pool)) {
+		int err = PTR_ERR(rx_ring->page_pool);
+
+		rx_ring->page_pool = NULL;
+		return err;
+	}
+
 	ath12k_dp_rx_bufs_replenish(ath12k_ab_to_dp(ab), rx_ring, &list, 0);
 
 	return 0;
@@ -263,10 +295,13 @@ static int ath12k_dp_rxdma_buf_setup(struct ath12k_base *ab)
 		ret = ath12k_dp_rxdma_mon_ring_buf_setup(ab,
 							 &dp->rxdma_mon_buf_ring,
 							 HAL_RXDMA_MONITOR_BUF);
-		if (ret)
+		if (ret) {
 			ath12k_warn(ab,
 				    "failed to setup HAL_RXDMA_MONITOR_BUF\n");
-		return ret;
+			goto error;
+		}
+
+		return 0;
 	}
 
 	for (i = 0; i < ab->hw_params->num_rxdma_per_pdev; i++) {
@@ -276,11 +311,15 @@ static int ath12k_dp_rxdma_buf_setup(struct ath12k_base *ab)
 		if (ret) {
 			ath12k_warn(ab,
 				    "failed to setup HAL_RXDMA_MONITOR_STATUS\n");
-			return ret;
+			goto error;
 		}
 	}
 
 	return 0;
+error:
+	ath12k_dp_rxdma_ring_buf_cleanup(&dp->rx_refill_buf_ring);
+
+	return ret;
 }
 
 static void ath12k_dp_rx_pdev_srng_free(struct ath12k *ar)
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index c3715c99054f..a1113f8b7399 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -6,6 +6,7 @@
 #ifndef ATH12K_DP_RX_H
 #define ATH12K_DP_RX_H
 
+#include <net/page_pool/helpers.h>
 #include "core.h"
 #include "debug.h"
 
@@ -187,15 +188,32 @@ void ath12k_dp_extract_rx_desc_data(struct ath12k_hal *hal,
 	hal->ops->extract_rx_desc_data(rx_info, rx_desc, ldesc);
 }
 
-static inline void ath12k_dp_unmap_rx_buf(struct ath12k_dp *dp,
-					  struct sk_buff *skb)
+static inline bool ath12k_skb_from_page_pool(struct sk_buff *skb)
 {
-	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(skb);
-	enum dma_data_direction dir;
+	if (!skb->head_frag || !skb->pp_recycle)
+		return false;
 
-	dir = rxcb->reinjected ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
-	dma_unmap_single(dp->dev, rxcb->paddr, skb->len + skb_tailroom(skb),
-			 dir);
+	return page_pool_page_is_pp(virt_to_head_page(skb->head));
+}
+
+static inline void ath12k_dp_unmap_rx_buf(struct ath12k_dp *dp, struct sk_buff *skb)
+{
+	if (likely(ath12k_skb_from_page_pool(skb))) {
+		struct dp_rxdma_ring *rx_ring = &dp->rx_refill_buf_ring;
+		struct page *page = virt_to_head_page(skb->data);
+		int offset = (void *)skb->data - page_address(page);
+
+		page_pool_dma_sync_for_cpu(rx_ring->page_pool, page,
+					   offset,
+					   skb->len + skb_tailroom(skb));
+	} else {
+		struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(skb);
+		enum dma_data_direction dir;
+
+		dir = rxcb->reinjected ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
+		dma_unmap_single(dp->dev, rxcb->paddr,
+				 skb->len + skb_tailroom(skb), dir);
+	}
 }
 
 void ath12k_dp_rx_h_undecap(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 9cd9c0bb07db..d1703c736d49 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -902,14 +902,26 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 	/* change msdu len in hal rx desc */
 	ath12k_dp_rxdesc_set_msdu_len(hal, rx_desc, defrag_skb->len - hal_rx_desc_sz);
 
-	buf_paddr = dma_map_single(dp->dev, defrag_skb->data,
-				   defrag_skb->len + skb_tailroom(defrag_skb),
-				   DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(dp->dev, buf_paddr))
-		return -ENOMEM;
+	if (ath12k_skb_from_page_pool(defrag_skb)) {
+		struct dp_rxdma_ring *rx_ring;
+
+		rx_ring = &dp->rx_refill_buf_ring;
+		dma_sync_single_for_device(dp->dev,
+					   ATH12K_SKB_RXCB(defrag_skb)->paddr,
+					   defrag_skb->len +
+					   skb_tailroom(defrag_skb),
+					   rx_ring->page_pool->p.dma_dir);
+	} else {
+		buf_paddr = dma_map_single(dp->dev, defrag_skb->data,
+					   defrag_skb->len +
+					   skb_tailroom(defrag_skb),
+					   DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(dp->dev, buf_paddr))
+			return -ENOMEM;
 
+		rxcb->paddr = buf_paddr;
+	}
 	rxcb->reinjected = true;
-	rxcb->paddr = buf_paddr;
 
 	spin_lock_bh(&dp->rx_desc_lock);
 	desc_info = list_first_entry_or_null(&dp->rx_desc_free_list,
@@ -928,8 +940,8 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 	list_del(&desc_info->list);
 	spin_unlock_bh(&dp->rx_desc_lock);
 
-	ath12k_wifi7_hal_rx_buf_addr_info_set(&msdu0->buf_addr_info, buf_paddr,
-					      desc_info->cookie,
+	ath12k_wifi7_hal_rx_buf_addr_info_set(&msdu0->buf_addr_info,
+					      rxcb->paddr, desc_info->cookie,
 					      HAL_RX_BUF_RBM_SW3_BM);
 
 	/* Fill mpdu details into reo entrance ring */
@@ -994,8 +1006,10 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
 	list_add_tail(&desc_info->list, &dp->rx_desc_free_list);
 	spin_unlock_bh(&dp->rx_desc_lock);
 err_unmap_dma:
-	dma_unmap_single(dp->dev, buf_paddr, defrag_skb->len + skb_tailroom(defrag_skb),
-			 DMA_BIDIRECTIONAL);
+	if (!ath12k_skb_from_page_pool(defrag_skb))
+		dma_unmap_single(dp->dev, ATH12K_SKB_RXCB(defrag_skb)->paddr,
+				 defrag_skb->len + skb_tailroom(defrag_skb),
+				 DMA_BIDIRECTIONAL);
 	return ret;
 }
 

-- 
2.56.0

