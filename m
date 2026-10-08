Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A982B38D402
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 16:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791476638; cv=none; b=f7UM+tX29WCagegUoPVkGn8etozZCtfxuPOE/LcS02VRM9J1JRhN9Dktr1JjksOIAs6qe8bhkpQWipWQU7ymctRYLqY4BZagOlwC5MFEWtjQHuC9etTS7pbEF+PPELa+O5aCHfG0FYlK1Gv1rCsSJcOc5SNhEBIkwgNxacr+n5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791476638; c=relaxed/simple;
	bh=q/slvV18pWvYnxQ3ggCZNxeVmOtkuXwVwf21DctUYk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bn1A+/2RZ7T6VtmWe2v0WRWwLQazKarTQitvKAFOf5fME4XqFoLZwdlG8Kc3xgjJ3t5jg/AzFNN8tONngUXuCWaFPzp71sT9LQuTm1RWlfzxKc7x990bn9XEay8CFBX/mAmb8tjRkLJTvHhiF8y5ZDeagH68T58ErUDqffe8kcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S3ktvv0k; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=O/gTwd9F; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S3ktvv0k";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="O/gTwd9F"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698EVXx91685154
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 16:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MKNDWG+xPvadUx2M61Ah5llef0LaBAxJ2rlM1bN6Bmo=; b=S3ktvv0kLw4DCV+Y
	fE8ir90dF6sLDVUqey00+QeZ27bSZmH6dDPLQNULii2EuLg2dYEKMlA7Yan3Ecl4
	eQ1Hxus/SLRvcDKexq0vHAYQO4P4Ga4baTm9rByoBXlGk/EfWGbw+ldxIplvonWj
	u8RWb3bXS/e8+XxL/eh4fRuSpkajFX3az1U+/68K0etObFvFrpd26SShI4M1E55t
	xqJkdX7leTooKSO1PNvJLvDIS3qtXW9s1XdjWCGTjH5p6V7BEzatTTwCKKk53Cil
	WVMKYRWOIEDfqF2xn88gATMTBh9caHyWbRPyHnmBfi8GnzF27owKzv4+Q/sAgSHS
	rZTLEw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe33nfb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 16:23:56 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso10283952eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 09:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791476636; x=1792081436; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MKNDWG+xPvadUx2M61Ah5llef0LaBAxJ2rlM1bN6Bmo=;
        b=O/gTwd9F+3MulXjqCdsMZUHJ/8yTNX4JOu/stD28VD04teGNJ/bUNUdWSEDWXtWsb6
         +LR5393GIlPTx0kMXtHK6LaJUbKIX9PKJjmeFLMNqln33abo6whmy0G4ELI6pB8NHilf
         pPbOuMDm5pjTlz2M38ex+w9x6Yam+ugh2uEJP1G2p34gsEDxVSM838x004/ayDXVnNQn
         iZOjoAVWyoRWdkTMTsqMFFjFRWcSm8nuoSP+gw7auEMFDpAjWmGicUKGZf68aJQtie5O
         lWWp2i5BKnFYNdUPMpRTVT7WsjwWo/flpztB1Gixlpwfih/ZJ0tSe64TPA1PFIsqm7NE
         NHBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791476636; x=1792081436;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MKNDWG+xPvadUx2M61Ah5llef0LaBAxJ2rlM1bN6Bmo=;
        b=sn+DNvLClRE8s9mL+vm2fHOyIk4OEEScYesQezBm1er9+qh7DlfFscsrOZD6LwUR8I
         jSW/6HzSa/SUpgfJK9mjE5kP6VyXCkjOv+jTZTloUZ8rG6j08QAYAIdh39aWhgz+XNyk
         1/045lubjrWmg93fJSiAGe/zUitg21HU8FJ+5pq7cNSb5Rmkq6x2J7rlrzxXbLLPtKaA
         7dY6qVI+ZXDDhiBu21H3td67w21UvNm52f3Dq9GvdWXWdMC/bm6tUeHfb3Q1ew+3XTj4
         wS6uJdkxvv1sz8xSVc96I4j+1H8SYEjiMagLaFS9+FoxPgIOepc85JBo/G4kxoLLloq2
         +j7Q==
X-Gm-Message-State: AFuF++mGXutF/ggsyhQEiGaXwPk+w19XfuXVosjRPDNmVtz6dtybpMtv
	ScY73zyST2y8XWilNIE6JenmY/bFvhVjzi6KrYaNiv3+CdQ6k+zNMhswl0FwoS1qiEBp+hveJ62
	M+Eq6BaQoLoqTt+6LNDRxGqxTtNR8QXagpcwIdDslYicjJqT86q2H6GBbQZoFTSWjGYKKgA==
X-Gm-Gg: AYBFou1l7/+KfKpiZ91kZjaB7GAjZ+BRuY2ZKClbmsJkvG+IeSaBd3FU9LlX+nmTf1d
	LbWX5qZjV7T4bLtsrtN2WQspgMOYSWzwKNokIW+hZ4HFzqlBcFnOZzV9A1b88AHJ4nsz6cQ3eX5
	NnYW3YfOR9qMul+lz3l1asiSL/JHUf6HGL5DqPP33QxxS4qdHzn3PmpsiyEJ73UqQ9d41S0/cab
	dTbNVRrQeIFzcCq/W9cuEua5Ur5oAG+H4YeY+uQUewQfWjjc/obKyGLIDeIqqJcB3T/4scS0w7L
	sCyanSGD2YkFkt4WWDXbG1gBt3celBj9QArXtUM10wjBy/8Qle3nw4iHgsM8vRVplL1XmA1+7HH
	JAujVnilNEIPTx7+BNnUJf/YaOHhPnuVlrQ5viaP+iHw=
X-Received: by 2002:a05:7300:c00d:10b0:341:c6ca:1df3 with SMTP id 5a478bee46e88-3515dd78d9fmr7858772eec.14.1791476628565;
        Thu, 08 Oct 2026 09:23:48 -0700 (PDT)
X-Received: by 2002:a05:7300:c00d:10b0:341:c6ca:1df3 with SMTP id 5a478bee46e88-3515dd78d9fmr7856538eec.14.1791476593913;
        Thu, 08 Oct 2026 09:23:13 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3515abb7117sm18325678eec.3.2026.10.08.09.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 09:23:13 -0700 (PDT)
Message-ID: <cf9dbfc5-5787-4a69-ad04-153afdec1cb4@oss.qualcomm.com>
Date: Thu, 8 Oct 2026 21:53:09 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 1/2] wifi: ath12k: Make RXDMA buffer ring size
 configurable per memory profile
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
 <20261007-mpp_ws-v1-1-739b1fb87d24@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261007-mpp_ws-v1-1-739b1fb87d24@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA2NSBTYWx0ZWRfX8+ipuXtgQ4mN
 lCT4z49HYFBZ0fvJR47VfmpPL1i2If2azz50Dl8/+hbPHaTAQDoB9w5V70qXoOqyjGgcJ+gwtYk
 O7mfVVcNQpI+Sqcz6VtEKbUieCNpdlh2ss2Y6XMLaAtQ/Glw2ApDInHXN1AIe1WPl/braQ4jJVd
 OgchI3Fxin0t9GldvGvIGzgBKTCIvcQBNU2K9bKbXFK3bgKTdBVaVnhZIF+6mKJQgX+Xq8CjPTz
 M1w6Cv8hlQ6/s3fNrR6aeR6PhLaqw42TkEuxI/jMjuWZb4fkqDMZqZOVss+9v7zELUXPIOALgCh
 gaNn2OQN2SEIJ8YYC71Je0t6U7qiN3MKZJnOqD+Hj36Y57iOR9alD6ZtGzb9MS6u+5uBZhmxFGm
 ZQr78r1WJYjnTSOeW1ELfDvfZdxY8rqHoNYfW70Q3X82r9dzU5TMS7hJds6VBT92MPEih35zzYW
 uI+IFRnNSBQkjxNmBWw==
X-Proofpoint-ORIG-GUID: udTMcZK2MwVBcwF_vJOfUXnv7SIIkWnN
X-Proofpoint-GUID: udTMcZK2MwVBcwF_vJOfUXnv7SIIkWnN
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA2NSBTYWx0ZWRfXzfKMxGL9T+xU
 gBm2Oft3YZfJXItJug2OL6RT02Rv1FLNDRZGhIAn9c3MY+aFYgErWyhXoN5j9INubCfO9mj82V3
 AaKf2koxdBA3oNNt1wj4ftHWIqg7fD4=
X-Authority-Analysis: v=2.4 cv=KcdHIgYD c=1 sm=1 tr=0 ts=6ac7c39c cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=tr3Ra7ay5OclNWw_GIwA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_05,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080065

On 10/7/2026 2:53 PM, Aaradhana Sahu wrote:
> Currently, the RXDMA buffer ring size is hardcoded to 4096 and shared
> across all memory profiles. This prevents individual profiles from tuning
> the ring size based on their memory and performance requirements.
> 
> Add the RXDMA buffer ring size to the memory profile configuration and
> implement ath12k_dp_rxdma_buf_ring_size() static inline function to
> access the configured value. This allows different memory profiles to
> select an appropriate ring size based on available system resources.
> 
> The function follows the pattern established in the previous patch for

Previous patch? Did you forget to add a reference?

Or maybe we can just say:
"The function follows the existing pattern of DP ring size helpers, 
taking struct ..."

TBH, I'd prefer to drop this paragraph entirely since it's already 
apparent from the code.


> other DP profile parameters, taking struct ath12k_dp_profile_params
> pointer as argument.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1
> 
> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath12k/core.c  | 2 ++
>   drivers/net/wireless/ath/ath12k/dp.h    | 8 +++++++-
>   drivers/net/wireless/ath/ath12k/dp_rx.c | 2 +-
>   3 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
> index e527b59ecba5..764e646d0090 100644
> --- a/drivers/net/wireless/ath/ath12k/core.c
> +++ b/drivers/net/wireless/ath/ath12k/core.c
> @@ -54,6 +54,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
>   			.num_pool_tx_desc = 32768,
>   			.rx_desc_count = 12288,
>   			.rx_release_ring_size = 16384,
> +			.rxdma_buf_ring_size = 4096,
>   		},
>   	},
>   [ATH12K_QMI_MEMORY_MODE_LOW_512_M] = {
> @@ -68,6 +69,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
>   			.num_pool_tx_desc = 16384,
>   			.rx_desc_count = 6144,
>   			.rx_release_ring_size = 8192,
> +			.rxdma_buf_ring_size = 4096,
>   		},
>   	},
>   };
> diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
> index c53eac20b989..108e27dd5797 100644
> --- a/drivers/net/wireless/ath/ath12k/dp.h
> +++ b/drivers/net/wireless/ath/ath12k/dp.h
> @@ -31,6 +31,7 @@ struct ath12k_dp_profile_params {
>   	u32 num_pool_tx_desc;
>   	u32 rx_desc_count;
>   	u32 rx_release_ring_size;
> +	u32 rxdma_buf_ring_size;
>   };
>   
>   #define DP_MON_PURGE_TIMEOUT_MS     100
> @@ -210,7 +211,6 @@ struct ath12k_pdev_dp {
>   #define DP_REO_EXCEPTION_RING_SIZE	128
>   #define DP_REO_CMD_RING_SIZE		256
>   #define DP_REO_STATUS_RING_SIZE		2048
> -#define DP_RXDMA_BUF_RING_SIZE		4096
>   #define DP_RX_MAC_BUF_RING_SIZE		4096
>   #define DP_RXDMA_REFILL_RING_SIZE	2048
>   #define DP_RXDMA_ERR_DST_RING_SIZE	1024
> @@ -730,6 +730,12 @@ ath12k_dp_rx_release_ring_size(const struct ath12k_dp_profile_params *p)
>   	return p->rx_release_ring_size;
>   }
>   
> +static inline u32
> +ath12k_dp_rxdma_buf_ring_size(const struct ath12k_dp_profile_params *p)
> +{
> +	return p->rxdma_buf_ring_size;
> +}
> +
>   void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
>   void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
>   int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
> diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
> index cfaf26ae2720..36be543b7c50 100644
> --- a/drivers/net/wireless/ath/ath12k/dp_rx.c
> +++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
> @@ -1699,7 +1699,7 @@ int ath12k_dp_rx_alloc(struct ath12k_base *ab)
>   	ret = ath12k_dp_srng_setup(ab,
>   				   &dp->rx_refill_buf_ring.refill_buf_ring,
>   				   HAL_RXDMA_BUF, 0, 0,
> -				   DP_RXDMA_BUF_RING_SIZE);
> +				   ath12k_dp_rxdma_buf_ring_size(dp_params));
>   	if (ret) {
>   		ath12k_warn(ab, "failed to setup rx_refill_buf_ring\n");
>   		return ret;
> 


-- 
Ramesh
