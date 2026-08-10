Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87213346A18
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 20:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393010; cv=none; b=GlVxRYH5C9B1qCBlQOMqHl28fEkoDZqlzMSO4nIoJfW7D63bfBgzI43khe171WAvUSWSIsnnumqxusfrpkBfnwSvJuftqh+ouN8J98i25KiJKGZsQeQlzEb3YmqZZT3jCa5mqEjlOp8HDtMuR8FR6SWd6km6YS4cr9l6Lp5AaDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393010; c=relaxed/simple;
	bh=3KWG4OyWMOULijeJPIDiZkmjDjImg+klixT1WGBDtYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LYa5Vwwss5MOgsC3qAHNQCnVHjIDs+I/4SdBSEC3HhSLSfqoolPUEu6pNUF2an9ks1bLH5gPRVs4Kgv9IkPgdXB/nSc8XijB1K0LDjflpwIDxulGRAvU9XbtKZ9KBh/2O7stVObyQ446wYWvaxC//biVIwZwXv/92nwPgSUNUKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RMknXtKy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=irKAJ/lU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RMknXtKy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="irKAJ/lU"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AJlRoA3160351
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 20:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	l3pZzwbmIUvK0GnbdPPPfTPLqkbhmh1kIPOQVT4Oh9A=; b=RMknXtKygk23Idck
	xFCmosi1YaXYj0FbvBdn3Pg0lOgMVOmgaqZToUeotxGPvrAQpS+VHmtEUNGCgPV0
	BDvLNNMc5th+NcUFU/yB5Ix3+4v6XxKgI2+xxUqrz/6+G41E5RmvEF9YsL54gk5l
	yh6uk4xP6SrwGaRe9nkA2zAbiO7BubUBo2kCHHc8LcZHvDSsLQXJwsE5S1k1Zgt+
	QPrkRyJYuIeWTefbtf10YP/44dregOMxE5sO9/QhBVPqxbR1oaIv94sxY2LoJ6nr
	hSx/ifldB4BQ4nbbkGcJZBMK3NvtSr/hDvpcBgumq9AxgkB8DwxydJxY+0rfI/jx
	/Dmlug==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fy8v3ujer-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 20:16:48 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ccb687f82eso38351915ad.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 13:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786393008; x=1786997808; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l3pZzwbmIUvK0GnbdPPPfTPLqkbhmh1kIPOQVT4Oh9A=;
        b=irKAJ/lU/77swRugCLTwLzMh/qscUxVia3sXBS5IftXCrsRBiqibP1jsMcEntJKxBC
         0XxzzctanvuQg2UMOTxAFTagwISGGUFZ5bGjN13PVIR4MkwONdQqE1wAr18pIyNhJuXR
         XxjdEqDMOqNbgAzRpPtrJOmrPZrtA6JcleA56Hwa75lXWzJKTxcrEMx1GlaHjunOvFHA
         PkI/pVsBMEWGWMaBwM3LzuqjTuF4fa1Cq2TKeZAU1M3j0Prwj8NOxslBv3RO7l7HIKnN
         LubWvQaStqZr43EYsnlIxu2n1ZpRLBSAfGL+iBMlDYmniYLvAgKVUrkkiWfXXMrBhVbJ
         xseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786393008; x=1786997808;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l3pZzwbmIUvK0GnbdPPPfTPLqkbhmh1kIPOQVT4Oh9A=;
        b=pfPG994Mfx/1xEBa8GCrP/P/ThF4WI3VWANSr01pT2SfZIiII/1fpS3IDkTYhpp+p9
         CtpFpRYE9LFhCVGkh35KCKNYZiYJ5+eaDJG0HWYJso8NRpWL7ZoId+XNG29etJ+F+1yF
         WRg9cDof6vSntnSc0cA9i8LYX9GOPGVrjZFgdZXCtvjVVjaHbuMpIcHPxs3hRYYGmwwr
         KflhnxGDaouSZ3LviVf1YOTXKxPdHqxEBtEvyE0dzX3iv5N8CgP2eVzWwnPfdblFbO2d
         IeFCY8hG9g3MhxU16dV0DsNwO+sOAhEOVWRryZcsj468r7cxh/nkrPUmoVXRU69jlRXk
         m+0g==
X-Gm-Message-State: AOJu0Yzr+o+mNuw0XQB/6fbS4sZlrFMKKTEaJ8+WViTkoxia4wwBDLAs
	gabKQs4wE85kSLQP/iPYYN7ADTqh2xty3Peej99zLqUOjjLnLNcwAGBu6R9rm193Vq9nimM/R2Q
	57YPJBm5QVzujENVasQ1zV3Xxr8ahgL3pxQ2Jy9KYWMmb3BbS6dtcfva1VhNPJqFpHmr7Zw==
X-Gm-Gg: AR+sD12g9622p2DpzZ/twCBFjIoJnOAXEofQGoE4B+Pae8AkHiley9o5Ky5JHnYDHpO
	4UBnvU4cbgv1h8kHJbQvTAH8Ou6iZ/cQnd00q7cS/3L8Mzq2jSure/fKqobgUP1HJo8Ki699q4b
	3p6E7TbvL+dL/nnSegZh8b2qtQ4dl9XkRmMMAfmY20X8z9Ld1goBSm1G7G/8b8NwvqjXVL4lShy
	tHcqQy7zMBAX+++QgpE8P0vUs8TvREsSY9iMxtPf2yfuTvmd33P3ivgTQa5DzGSskHq40o1Yzjd
	1GgT9e6QIPePl45bcQ6p+WlgV2Qode5WPRRhMqqgUgCMrLZzBKFGw9d14l3kwSZNv9+oP+IPK+e
	I2JXXuudDgdn72j4oSRhjgjgklXdKAxPOYuF7KkGoISwZPd5qUiWDrpObI43W
X-Received: by 2002:a17:903:388d:b0:2c9:df1b:e948 with SMTP id d9443c01a7336-2d2ffda1b1cmr51859685ad.4.1786393008062;
        Mon, 10 Aug 2026 13:16:48 -0700 (PDT)
X-Received: by 2002:a17:903:388d:b0:2c9:df1b:e948 with SMTP id d9443c01a7336-2d2ffda1b1cmr51858745ad.4.1786393007491;
        Mon, 10 Aug 2026 13:16:47 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315be86fc7bsm46628323eec.1.2026.08.10.13.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 13:16:46 -0700 (PDT)
Message-ID: <b2e6be36-b95d-4872-830f-03abeb23ff13@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 13:16:45 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v3 5/8] wifi: ath12k: add WBM RX error drop
 statistics
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>
References: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
 <20260810144444.2033607-6-pardeep.kaur@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260810144444.2033607-6-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Pib3GgmLxg3j29RDSPH5PCjumEYVhIYF
X-Proofpoint-ORIG-GUID: Pib3GgmLxg3j29RDSPH5PCjumEYVhIYF
X-Authority-Analysis: v=2.4 cv=c+mbhx9l c=1 sm=1 tr=0 ts=6a7a31b0 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=Dy4GOBJf9M4JPyKkigQA:9 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDE3MiBTYWx0ZWRfX5Gg1BykFXjo/
 YjUn9YtROaXfq2QLfD1pdLvmjutt5bJTB07BNhX/hStikBLc86faCN7a0zrNkZX1P5oHojV5Dmm
 sZO6/a0uDkcyJdRK9LlIQZJHrZNaKjTK4UThl36lKjnqgyILluTTTTPEb9vwAPeJjVn2hK5t7/Y
 CgMaJj0JusxK2L6kfagJrTHCP0wpFP7gLMrIsnpGYZg+aK8wl4drc/6prZdXq4Gsp2jR8k4Kp3M
 KnzsDOB0opsgt07e8onx5LBh3RZnO6T5Din2qiV9iLj4mpi+Jp9C1kD8g9R6ExY3E7WFzVbHg9Z
 K2hBk14eK/7SZL+DBo9ojkTZ+aXWL8tzK2qjMMG1eK/Vn9bJ70IPok/nWqTEBqOBWJ98HAVOGWc
 o1rdAUcCDdB/8IAyusoNroQRRe7sEg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDE3MiBTYWx0ZWRfXz+jT10ChRU3T
 i1v73XQMwNMtghWl0jcxUlX8dCfNvRADE346hFkQSPfd+NwXmsp9A+X0d15BHNzwggWrelrY1oV
 mteX257OemtiGUnbILqFweQBdtpPBq0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_05,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 classifier=typeunknown authscore=0 authtc=
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.22.0-2606150000 definitions=main-2608100172

On 8/10/2026 7:44 AM, Pardeep Kaur wrote:
> diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
> index cbda754d8656..34c605b609cb 100644
> --- a/drivers/net/wireless/ath/ath12k/debugfs.c
> +++ b/drivers/net/wireless/ath/ath12k/debugfs.c
> @@ -1071,6 +1071,20 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
>  		[HAL_REO_DEST_RING_ERROR_CODE_PN_ERR_FLAG_SET] = "PN err",
>  		[HAL_REO_DEST_RING_ERROR_CODE_DESC_BLOCKED] = "Desc blocked"};
>  
> +	static const char *wbm_rx_drop[WBM_ERR_DROP_MAX] = {
> +		[WBM_ERR_GET_SW_DESC] = "SW desc error",
> +		[WBM_ERR_DESC_PARSE] = "Desc parse error",
> +		[WBM_ERR_DROP_INV_HW_ID] = "Invalid hw id",
> +		[WBM_ERR_DROP_NULL_PRTNR_DP] = "Null Partner dp",
> +		[WBM_ERR_DROP_NULL_PROC_DP] = "Process Null Partner dp",
> +		[WBM_ERR_DROP_NULL_PDEV] = "Null Pdev",
> +		[WBM_ERR_DROP_NULL_AR] = "Null ar",
> +		[WBM_ERR_DROP_CAC_RUNNING] = "CAC Running",
> +		[WBM_ERR_DROP_SG] = "Scatter Gather",
> +		[WBM_ERR_DROP_INV_NWIFI_HDR] = "Invalid NWifi Hdr len",
> +		[WBM_ERR_DROP_REO_GENERIC]  = "REO Generic",

nit: extra space before =

> +		[WBM_ERR_DROP_RXDMA_GENERIC] = "RXDMA Generic"};
> +
>  	static const char *wbm_rel_src[HAL_WBM_REL_SRC_MODULE_MAX] = {
>  		[HAL_WBM_REL_SRC_MODULE_TQM] = "TQM",
>  		[HAL_WBM_REL_SRC_MODULE_RXDMA] = "Rxdma",...> diff --git a/drivers/net/wireless/ath/ath12k/dp_stats.h
b/drivers/net/wireless/ath/ath12k/dp_stats.h
> new file mode 100644
> index 000000000000..04d3892acff3
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath12k/dp_stats.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: BSD-3-Clause-Clear */
> +/*
> + * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
> + */
> +
> +#ifndef ATH12K_DP_STATS_H
> +#define ATH12K_DP_STATS_H
> +
> +enum ath12k_wbm_err_drop_reason {
> +	WBM_ERR_GET_SW_DESC,
> +	WBM_ERR_DESC_PARSE,

nit: why aren't these two also WBM_ERR_DROP_*
> +	WBM_ERR_DROP_INV_HW_ID,
> +	WBM_ERR_DROP_NULL_PRTNR_DP,
> +	WBM_ERR_DROP_NULL_PROC_DP,
> +	WBM_ERR_DROP_NULL_PDEV,
> +	WBM_ERR_DROP_NULL_AR,
> +	WBM_ERR_DROP_CAC_RUNNING,
> +	WBM_ERR_DROP_SG,
> +	WBM_ERR_DROP_INV_NWIFI_HDR,
> +	WBM_ERR_DROP_REO_GENERIC,
> +	WBM_ERR_DROP_RXDMA_GENERIC,
> +	WBM_ERR_DROP_MAX,
> +};
> +
> +#endif /* ATH12K_DP_STATS_H */
