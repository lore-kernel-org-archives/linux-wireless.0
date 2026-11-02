Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793603646;
	b=m+1+bp9vJnlVdbpC33AG5u9cg+Mqpp3wZg82YB6HL2sQRJOgZDHusECvPovLGjPT5p6c
	 Z83EDvCI8wzD2LgLMFVW9gkdPuyg2zSlnYTVULqvBGWk/yXJj8wq3iNqUvEs1ni+ffHip
	 8IBLeDImpkpKYvPrvUzZ108yeFVFN5VtqHmk1mb3JUDMAayYwqVHF5VmP1qG/Kn3perps
	 eZTjBFRJPL1ZS+YJgAxATeSliOUt6BEs8rM3z9YXSI4XPaEtjHzzQju3Go7obqN3PDcjW
	 giSDKJ3hvKiGrEbA4t/LpFS1k4W2fAcrXZEcOe8CRC1acH/1vEgV7jzkZA1I+x3BXHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793603646;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=STBsifDRh0Wop1/8BVxqcSX5YT3lhc62OfRZbkhPUAg=;
	b=FSAnBjcvZg9QqhKrJauutqwaduC4rUrdkgTYeh73KHRv1LOUkLEj7ZsM/BUJcaMkRd6r
	 tj+U+PU85QCs67Zuh6CmrnyNoY2HLdr8Cszr5WhozH/8f9hruLR0YbU/PXB6QFje9nMzQ
	 LBLte3CH7EbUZm9xzdxC83z7EGH9KSTetbnvXAve53EDbk/YY1hWExL4IGFfJcjhwg7ah
	 T7AsHC28MuNhx64rRkCYGY2k5yRgTTDAz81MC0THhAuwlYeiuhLRQlt8c9Lg+jHpKJ4S3
	 eWnKiPoTgbHuhKQenqqwi9p1pEOR7ARPv2HWZK5eU4sGK+TU992ohA0fOu+9/GKrSyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hsppKOwq;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cAFdM7Uh;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239BD606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 07:14:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 239BD606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hsppKOwq;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cAFdM7Uh
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A23vIqC3769143
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 07:14:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	STBsifDRh0Wop1/8BVxqcSX5YT3lhc62OfRZbkhPUAg=; b=hsppKOwqp1u+UC4z
	AGGBX7baZQAsdluNVdcg57eiYgzscdXDpa9qPFj7RjLhNhHaZI2MFHwbT2+ORDWp
	auEz2W1oUE0xNsm1oYxm3JZU1YzQr1NdZn94Uvgrfo9xAvYTpmfX8yBIF2V1OsVE
	5vJncsUmgKVpC9lE4RjDPkGvjyS3mNmM3/XPoHVLxljgB+GHLotEWlo47rMThcX6
	nNpt9bqeDS7udaRkAI/yH8ktPKCB0ssjA3eTx9qkwdW5OToqepApPD8LBwazPxm6
	n9rus3/qoVfl0hs92ZvGHxnAeMNEQCFmyb0H3d7CEp/NT6Mw4TGXMSxHOljhWGKH
	uoUXOw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn79rwrcb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 07:14:05 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36a1e2485fdso7459830eec.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 23:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793603644; x=1794208444; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=STBsifDRh0Wop1/8BVxqcSX5YT3lhc62OfRZbkhPUAg=;
        b=cAFdM7UhtGfxkq1jA+Aew/iTz2dYuY7a+K8kq2S9J6cpVSoAVuxJ9lksx9owrU4tQM
         O7kH36/vpjSUHVaKZLzaKCHCO3O4OUYjx6WzBYodwqQGhv6S6JtJZuNh2lVhendiP6qE
         yGhv38uJ6vSmglXOT+dIuoQ89VDOSOdFOUVPoZSFVgTgcsjQuy3WZIgsoH4BwBVjqLYJ
         T7B7wr56I2Sh39tx0omqVmcehtArfKpeY+afHaL3dI/gGDWT+X1O02iimbusRaaeAXbF
         yw4O+VZdhgSM7ZQAn6zmrb0xsC7JP8d9EHduiL3o0LRE3fhfxWVVMQdJvIrsrJlD9+NA
         aTjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793603644; x=1794208444;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=STBsifDRh0Wop1/8BVxqcSX5YT3lhc62OfRZbkhPUAg=;
        b=pApOmOIzJwWPdwTmrtNcbpoXzIKa17fb5DL70s1Vn5MtN4RpkjJpIcEIeYLcxuz0ec
         Dm/KWvSX5CJM2woDx+kjJSTNF/sRyYsx3y0pKnxQXWhaFzjfxg9TPrBMySIE9s526h28
         9QAZhy+e0iWENDJ54W95mb/1j+pYFupsKsS3GcfDss6PKL7Ig552QnbdiQXoZdOV/s6n
         WTsD7A+C8ZKhLQo4U18Cm3lEV8v4ebjRsx5qylvkor8/SoV8VK7Ve8m+yNzMhLIijTJz
         Gr/KIHzdqWPaz1aNK9E7+OAdDK1FqfZnGp0oQFMMwnfkL2iG04aBfUIoLU3TxAH8VQ3P
         l0jw==
X-Forwarded-Encrypted: i=1; AKwUvBzyfs5x98t52fBEbx8/dPn70LryP9ELx0Ldo/YgTK3j4wUfzLlPL5YtOUEIF06OPBaAZXikHnJF4wusaBgNwQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z93xl5u0MWStGc8coZssHUHmoMYiG987BRBnzkDD+He+euEKG40
	Qwrz1zOA7mO3mMGLWSmI+Rx5bPCTgp1h4hGQqIHvXxWerE1wOp+K40t11utx4j7HqddS6R9FBtb
	2HynlMfads5YT4R/mmEnNxmB7D2LGQqnRVhHijZGUJ3af0xwo8y+RHcvG5ZWrBFpv8YH2Cw==
X-Gm-Gg: AYBFou3jw+CH9Hs1xbtP7P7LIn5O6XSIVKAixXFAT4cOpftBqGNRPDwyXmSWg9t83KP
	efiOarEp0SyaDzFSGg8bOQQqAnVegwmhNWWV6TYy75VAl5LwwnC++mJ4JK5ahdjz2+wltiW6WLw
	nOf+mmV2vsXKJpazzca8PRXi8P32kIAerdjGVRFodXMLFS6c5f+HwJffnGcBrdRbaUnpyTNq5Wk
	8alhlYbeuf8kd7eD6gsh6toZN77MHhk5INuWztJrnHg8XMOtYdoSmWlIdZ7HNHkifGQoAhpklD/
	mfT1MYiLVWD1qFHIuiQwibmcz5dXl/8i8hAgF9uSYpZDbI0I6ZRHRTnQMWuOrn/mASPlEZ2FD2L
	SkyXzWEqEq3cfU6FHy0RiTIBBhpOBH9+KPXiMO/G9yDLi4XlBkCp9i7t4zdQFiiucvTLF0CJPjb
	dM
X-Received: by 2002:a05:693c:880e:10b0:369:987f:d15e with SMTP id 5a478bee46e88-36a4221b055mr14782216eec.2.1793603644234;
        Sun, 01 Nov 2026 23:14:04 -0800 (PST)
X-Received: by 2002:a05:693c:880e:10b0:369:987f:d15e with SMTP id 5a478bee46e88-36a4221b055mr14782164eec.2.1793603643375;
        Sun, 01 Nov 2026 23:14:03 -0800 (PST)
Received: from [10.152.204.131] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af1dfsm36299529eec.7.2026.11.01.23.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 23:14:02 -0800 (PST)
Message-ID: <904cabf1-b803-457d-8a89-d80bed639de5@oss.qualcomm.com>
Date: Mon, 2 Nov 2026 12:43:57 +0530
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] wifi: ath12k: rely on page_pool APIs for buffer
 allocation
To: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Ripan Deuri <quic_rdeuri@quicinc.com>,
        P Praneesh
 <quic_ppranees@quicinc.com>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20261008-ath12k-pp-v1-0-68f888cd7eec@oss.qualcomm.com>
 <20261008-ath12k-pp-v1-3-68f888cd7eec@oss.qualcomm.com>
Content-Language: en-US
From: Praneesh P <praneesh.p@oss.qualcomm.com>
In-Reply-To: <20261008-ath12k-pp-v1-3-68f888cd7eec@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: o0OVMJIG2iHiyjt4W-eKZwyEWWD5xX3j
X-Authority-Analysis: v=2.4 cv=Wtq+otfv c=1 sm=1 tr=0 ts=6ae8383d cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=-srEPthScLmXCGoj88AA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAyOCBTYWx0ZWRfX4w7UK7ZEFnu1
 ZwHpsrxAxFkc/02Sf86ndH/hWhu+WxqCsk5nRLQ97tP2vBFAEQqT/u/ngTDt/BcQ2nLL01+bBhZ
 ie2poUuLqy9uEm1fe9MJ70VgtCiINl8=
X-Proofpoint-GUID: o0OVMJIG2iHiyjt4W-eKZwyEWWD5xX3j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAyOCBTYWx0ZWRfX/nEyVuIRPrKN
 t7f1WdUypNRzb0nrFOJXN/oZhgjt53sJyMnJc2pXj01tOjjus88pwpzFVlSXuJBEKrTbi/LLJHj
 8ck6xi3QeAyjLj9/AvMMHLqvGmZuDgSedMD8Nn9Zqx/OtnenTHQ1i8Wy/3AxBPmXyqcrt1RXd9B
 ERuFX2F7QP3WSaV142qifhSoodyihOZR9lDsHQ843Irdpzk3fSbfAXFaHEKwyQb6jEvN6J1SUAV
 ET+H468Y+5ZRI6yeljYgeZi/rc5/fAQ70Gk1Y3pVO6RAU9ZTBvA64oVZZ5peFxp8QdgqtyHLSmd
 RTUwUjJDFLiqPERaHAX/JuR3ilYgnv2LF4y3LH/YHrgWdkIpEQc9O21TUckrD3p7B8XtpxB0XUA
 I9L1V5FZQsVMw9wWme+OdD+PJIRAomc9eGhVc7gGxKlbGpCgyYwfAIYvCH1FXx6B9UMESvt/Xu7
 cXfpfYP+6ER2O0Xc0dQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020028


On 10/8/2026 6:46 PM, Lorenzo Bianconi wrote:
> Convert the Rx refill buffers to the page_pool API instead of allocating
> an skb with dev_alloc_skb() and mapping it with dma_map_single(). The pool
> handles the DMA mapping and buffer recycling.
>
> Add a page_pool to struct dp_rxdma_ring, created in
> ath12k_dp_rxdma_ring_buf_setup() and destroyed in
> ath12k_dp_rxdma_ring_buf_cleanup().
>
> Update ath12k_dp_unmap_rx_buf() to sync page_pool buffers for the CPU
> instead of unmapping them, and guard the teardown paths
> (ath12k_dp_cc_cleanup(), ath12k_dp_h_msdu_buffer_type()) against
> page_pool buffers. In the re-inject path, sync an already mapped
> page_pool buffer for the device instead of mapping it again, and fill the
> descriptor with the DMA address stored in the rxcb.
>
> The monitor, CE and TX paths are left unchanged.
>
> This is just preliminary support: the goal is to use a single page to map
> two separated fragments of 2048B.
>
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath12k/Kconfig       |   1 +
>   drivers/net/wireless/ath/ath12k/dp.h          |   1 +
>   drivers/net/wireless/ath/ath12k/dp_rx.c       | 101 ++++++++++++++++++--------
>   drivers/net/wireless/ath/ath12k/dp_rx.h       |  32 ++++++--
>   drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c |  34 ++++++---
>   5 files changed, 121 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath12k/Kconfig b/drivers/net/wireless/ath/ath12k/Kconfig
> index 0d5d1c55bfc1..13985daffaee 100644
> --- a/drivers/net/wireless/ath/ath12k/Kconfig
> +++ b/drivers/net/wireless/ath/ath12k/Kconfig
> @@ -7,6 +7,7 @@ config ATH12K
>   	select QRTR
>   	select QRTR_MHI
>   	select PCI_PWRCTRL_PWRSEQ if HAVE_PWRCTRL
> +	select PAGE_POOL
>   	help
>   	  Enable support for Qualcomm Technologies Wi-Fi 7 (IEEE
>   	  802.11be) family of chipsets, for example WCN7850 and
> diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
> index c53eac20b989..599ce3c45c7a 100644
> --- a/drivers/net/wireless/ath/ath12k/dp.h
> +++ b/drivers/net/wireless/ath/ath12k/dp.h
> @@ -59,6 +59,7 @@ struct dp_rxdma_mon_ring {
>   
>   struct dp_rxdma_ring {
>   	struct dp_srng refill_buf_ring;
> +	struct page_pool *page_pool;
>   	int bufs_max;
>   };
>   
> diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
> index cfaf26ae2720..de9ea84323df 100644
> --- a/drivers/net/wireless/ath/ath12k/dp_rx.c
> +++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
> @@ -68,6 +68,31 @@ static void ath12k_dp_rx_enqueue_free(struct ath12k_dp *dp,
>   	spin_unlock_bh(&dp->rx_desc_lock);
>   }
>   
> +static struct sk_buff *ath12k_dp_rx_build_skb(struct ath12k_dp *dp,
> +					      struct dp_rxdma_ring *rx_ring)
> +{
> +	struct sk_buff *skb;
> +	struct page *page;
> +
> +	if (!rx_ring->page_pool)
> +		return NULL;
> +
> +	page = page_pool_dev_alloc_pages(rx_ring->page_pool);
> +	if (!page)
> +		return NULL;
> +
> +	skb = build_skb(page_address(page), PAGE_SIZE);
> +	if (!skb) {
> +		page_pool_put_full_page(rx_ring->page_pool, page, false);
> +		return NULL;
> +	}
> +
> +	ATH12K_SKB_RXCB(skb)->paddr = page_pool_get_dma_addr(page);
> +	skb_mark_for_recycle(skb);
> +
> +	return skb;
> +}
> +
>   /* Returns number of Rx buffers replenished */
>   int ath12k_dp_rx_bufs_replenish(struct ath12k_dp *dp,
>   				struct dp_rxdma_ring *rx_ring,
> @@ -81,7 +106,6 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_dp *dp,
>   	int num_free;
>   	int num_remain;
>   	u32 cookie;
> -	dma_addr_t paddr;
>   	struct ath12k_rx_desc_info *rx_desc;
>   	enum hal_rx_buf_return_buf_manager mgr = dp->hal->hal_params->rx_buf_rbm;
>   
> @@ -114,51 +138,33 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_dp *dp,
>   	}
>   
>   	while (num_remain > 0) {
> -		skb = dev_alloc_skb(DP_RX_BUFFER_SIZE +
> -				    DP_RX_BUFFER_ALIGN_SIZE);
> +		skb = ath12k_dp_rx_build_skb(dp, rx_ring);
>   		if (!skb)
>   			break;
>   
> -		if (!IS_ALIGNED((unsigned long)skb->data,
> -				DP_RX_BUFFER_ALIGN_SIZE)) {
> -			skb_pull(skb,
> -				 PTR_ALIGN(skb->data, DP_RX_BUFFER_ALIGN_SIZE) -
> -				 skb->data);
> -		}
> -
> -		paddr = dma_map_single(dp->dev, skb->data,
> -				       skb->len + skb_tailroom(skb),
> -				       DMA_FROM_DEVICE);
> -		if (dma_mapping_error(dp->dev, paddr))
> -			goto fail_free_skb;
> -
>   		rx_desc = list_first_entry_or_null(used_list,
>   						   struct ath12k_rx_desc_info,
>   						   list);
>   		if (!rx_desc)
> -			goto fail_dma_unmap;
> -
> -		rx_desc->skb = skb;
> -		cookie = rx_desc->cookie;
> +			goto fail_free_skb;
>   
>   		desc = ath12k_hal_srng_src_get_next_entry(ab, srng);
>   		if (!desc)
> -			goto fail_dma_unmap;
> +			goto fail_free_skb;
>   
> -		list_del(&rx_desc->list);
> -		ATH12K_SKB_RXCB(skb)->paddr = paddr;
> +		rx_desc->skb = skb;
> +		cookie = rx_desc->cookie;
>   
> +		list_del(&rx_desc->list);
>   		num_remain--;
>   
> -		ath12k_hal_rx_buf_addr_info_set(dp->hal, desc, paddr, cookie,
> -						mgr);
> +		ath12k_hal_rx_buf_addr_info_set(dp->hal, desc,
> +						ATH12K_SKB_RXCB(skb)->paddr,
> +						cookie, mgr);
>   	}
>   
>   	goto out;
>   
> -fail_dma_unmap:
> -	dma_unmap_single(dp->dev, paddr, skb->len + skb_tailroom(skb),
> -			 DMA_FROM_DEVICE);
>   fail_free_skb:
>   	dev_kfree_skb_any(skb);
>   out:
> @@ -196,12 +202,21 @@ static int ath12k_dp_rxdma_mon_buf_ring_free(struct ath12k_base *ab,
>   	return 0;
>   }
>   
> +static void ath12k_dp_rxdma_ring_buf_cleanup(struct dp_rxdma_ring *rx_ring)
> +{
> +	if (rx_ring->page_pool) {
> +		page_pool_destroy(rx_ring->page_pool);
> +		rx_ring->page_pool = NULL;
> +	}
> +}
> +
>   static int ath12k_dp_rxdma_buf_free(struct ath12k_base *ab)
>   {
>   	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
>   	int i;
>   
>   	ath12k_dp_rxdma_mon_buf_ring_free(ab, &dp->rxdma_mon_buf_ring);
> +	ath12k_dp_rxdma_ring_buf_cleanup(&dp->rx_refill_buf_ring);
>   
>   	if (ab->hw_params->rxdma1_enable)
>   		return 0;
> @@ -236,11 +251,28 @@ static int ath12k_dp_rxdma_mon_ring_buf_setup(struct ath12k_base *ab,
>   static int ath12k_dp_rxdma_ring_buf_setup(struct ath12k_base *ab,
>   					  struct dp_rxdma_ring *rx_ring)
>   {
> +	struct page_pool_params pp_params = {
> +		.order = 0,
> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> +		.nid = NUMA_NO_NODE,
> +		.dma_dir = DMA_BIDIRECTIONAL,
> +		.max_len = PAGE_SIZE,
> +		.dev = ab->dev,
> +		.offset = 0,
> +	};
Did you observe any improvement when increasing the pool size from the 
default 1K
to the RXDMA ring size? Also, is there any specific reason for using the 
default pool size?
>   	LIST_HEAD(list);
>   
>   	rx_ring->bufs_max = rx_ring->refill_buf_ring.size /
>   			ath12k_hal_srng_get_entrysize(ab, HAL_RXDMA_BUF);
>   
> +	rx_ring->page_pool = page_pool_create(&pp_params);
> +	if (IS_ERR(rx_ring->page_pool)) {
> +		int err = PTR_ERR(rx_ring->page_pool);
> +
> +		rx_ring->page_pool = NULL;
> +		return err;
> +	}
> +
>   	ath12k_dp_rx_bufs_replenish(ath12k_ab_to_dp(ab), rx_ring, &list, 0);
>   
>   	return 0;
> @@ -263,10 +295,13 @@ static int ath12k_dp_rxdma_buf_setup(struct ath12k_base *ab)
>   		ret = ath12k_dp_rxdma_mon_ring_buf_setup(ab,
>   							 &dp->rxdma_mon_buf_ring,
>   							 HAL_RXDMA_MONITOR_BUF);
> -		if (ret)
> +		if (ret) {
>   			ath12k_warn(ab,
>   				    "failed to setup HAL_RXDMA_MONITOR_BUF\n");
> -		return ret;
> +			goto error;
> +		}
> +
> +		return 0;
>   	}
>   
>   	for (i = 0; i < ab->hw_params->num_rxdma_per_pdev; i++) {
> @@ -276,11 +311,15 @@ static int ath12k_dp_rxdma_buf_setup(struct ath12k_base *ab)
>   		if (ret) {
>   			ath12k_warn(ab,
>   				    "failed to setup HAL_RXDMA_MONITOR_STATUS\n");
> -			return ret;
> +			goto error;
>   		}
>   	}
>   
>   	return 0;
> +error:
> +	ath12k_dp_rxdma_ring_buf_cleanup(&dp->rx_refill_buf_ring);
> +
> +	return ret;
>   }
>   
>   static void ath12k_dp_rx_pdev_srng_free(struct ath12k *ar)
> diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
> index c3715c99054f..a1113f8b7399 100644
> --- a/drivers/net/wireless/ath/ath12k/dp_rx.h
> +++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
> @@ -6,6 +6,7 @@
>   #ifndef ATH12K_DP_RX_H
>   #define ATH12K_DP_RX_H
>   
> +#include <net/page_pool/helpers.h>
>   #include "core.h"
>   #include "debug.h"
>   
> @@ -187,15 +188,32 @@ void ath12k_dp_extract_rx_desc_data(struct ath12k_hal *hal,
>   	hal->ops->extract_rx_desc_data(rx_info, rx_desc, ldesc);
>   }
>   
> -static inline void ath12k_dp_unmap_rx_buf(struct ath12k_dp *dp,
> -					  struct sk_buff *skb)
> +static inline bool ath12k_skb_from_page_pool(struct sk_buff *skb)
>   {
> -	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(skb);
> -	enum dma_data_direction dir;
> +	if (!skb->head_frag || !skb->pp_recycle)
> +		return false;
>   
> -	dir = rxcb->reinjected ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
> -	dma_unmap_single(dp->dev, rxcb->paddr, skb->len + skb_tailroom(skb),
> -			 dir);
> +	return page_pool_page_is_pp(virt_to_head_page(skb->head));
> +}
> +
> +static inline void ath12k_dp_unmap_rx_buf(struct ath12k_dp *dp, struct sk_buff *skb)
> +{
> +	if (likely(ath12k_skb_from_page_pool(skb))) {
> +		struct dp_rxdma_ring *rx_ring = &dp->rx_refill_buf_ring;
> +		struct page *page = virt_to_head_page(skb->data);
> +		int offset = (void *)skb->data - page_address(page);
> +
> +		page_pool_dma_sync_for_cpu(rx_ring->page_pool, page,
> +					   offset,
> +					   skb->len + skb_tailroom(skb));
> +	} else {
> +		struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(skb);
> +		enum dma_data_direction dir;
> +
> +		dir = rxcb->reinjected ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
> +		dma_unmap_single(dp->dev, rxcb->paddr,
> +				 skb->len + skb_tailroom(skb), dir);
> +	}
>   }
>   
>   void ath12k_dp_rx_h_undecap(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu,
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
> index 9cd9c0bb07db..d1703c736d49 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
> @@ -902,14 +902,26 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
>   	/* change msdu len in hal rx desc */
>   	ath12k_dp_rxdesc_set_msdu_len(hal, rx_desc, defrag_skb->len - hal_rx_desc_sz);
>   
> -	buf_paddr = dma_map_single(dp->dev, defrag_skb->data,
> -				   defrag_skb->len + skb_tailroom(defrag_skb),
> -				   DMA_BIDIRECTIONAL);
> -	if (dma_mapping_error(dp->dev, buf_paddr))
> -		return -ENOMEM;
> +	if (ath12k_skb_from_page_pool(defrag_skb)) {
> +		struct dp_rxdma_ring *rx_ring;
> +
> +		rx_ring = &dp->rx_refill_buf_ring;
> +		dma_sync_single_for_device(dp->dev,
> +					   ATH12K_SKB_RXCB(defrag_skb)->paddr,
> +					   defrag_skb->len +
> +					   skb_tailroom(defrag_skb),
> +					   rx_ring->page_pool->p.dma_dir);
> +	} else {
> +		buf_paddr = dma_map_single(dp->dev, defrag_skb->data,
> +					   defrag_skb->len +
> +					   skb_tailroom(defrag_skb),
> +					   DMA_BIDIRECTIONAL);
> +		if (dma_mapping_error(dp->dev, buf_paddr))
> +			return -ENOMEM;
>   
> +		rxcb->paddr = buf_paddr;
> +	}
>   	rxcb->reinjected = true;
> -	rxcb->paddr = buf_paddr;
>   
>   	spin_lock_bh(&dp->rx_desc_lock);
>   	desc_info = list_first_entry_or_null(&dp->rx_desc_free_list,
> @@ -928,8 +940,8 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
>   	list_del(&desc_info->list);
>   	spin_unlock_bh(&dp->rx_desc_lock);
>   
> -	ath12k_wifi7_hal_rx_buf_addr_info_set(&msdu0->buf_addr_info, buf_paddr,
> -					      desc_info->cookie,
> +	ath12k_wifi7_hal_rx_buf_addr_info_set(&msdu0->buf_addr_info,
> +					      rxcb->paddr, desc_info->cookie,
>   					      HAL_RX_BUF_RBM_SW3_BM);
>   
>   	/* Fill mpdu details into reo entrance ring */
> @@ -994,8 +1006,10 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
>   	list_add_tail(&desc_info->list, &dp->rx_desc_free_list);
>   	spin_unlock_bh(&dp->rx_desc_lock);
>   err_unmap_dma:
> -	dma_unmap_single(dp->dev, buf_paddr, defrag_skb->len + skb_tailroom(defrag_skb),
> -			 DMA_BIDIRECTIONAL);
> +	if (!ath12k_skb_from_page_pool(defrag_skb))
> +		dma_unmap_single(dp->dev, ATH12K_SKB_RXCB(defrag_skb)->paddr,
> +				 defrag_skb->len + skb_tailroom(defrag_skb),
> +				 DMA_BIDIRECTIONAL);
>   	return ret;
>   }
>   
>
