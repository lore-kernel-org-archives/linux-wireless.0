Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900231;
	b=WtHvzhHq827BX3XHLd7Rl3uMSQR/6r3R+h5LcSOAf3JnKtMpwFF5XhvG8V2ucxKIIBle
	 XiWQG9wEPNCbumuAzik/1yDH6DFoCbHu/hlMdA6rrOv2vvGQ6lau0aDUVWmHOBGaHmYSJ
	 ysD4cAys18/O3Z8M08yC1a74q5nMKare74IC02JO1EI4oOmJ5UuNJJjGHIKoP0O7wWT3T
	 06smyHaEpKVhwrg+ouDzxDG58hJM42ny641YZiVfuZ3i1rBgsSaATnqVh5tBK7068vB5u
	 LXA/7808XZMaCYLB7e2Q8XKar+BdQNUJXFIEv6tO3mua03gAs0fkj0r948Ky+GL+Vtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900231;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=VgYh4ixCnIjb0rEr5p1qolrzFm3xYIHBCGByIyBm0kE=;
	b=Kx+zmAgqvWbzvzD3OplvXHgpF5jyNHtn4Bm3xsPFJaLpLSIbQSODZUK0y0Axe5r7lP9Y
	 ABWMIU5FPlHDS52KlM/Npzbccein7FMjbonUQbHhTqs8jWdrccmwAr4oeqGQDKnPloi/Z
	 97kSdHut4QuWN1XAiz0FUAv9/UjSr/5InykGNHHVFakBrjMbdAZvrF74JdiF3BI75TqTh
	 N2X53iFeqcR5eoCiJenAGHAOhFX7jkagW7ltYStOWf5biEtOOLRbn4+1NvBDJK4YPtyVX
	 r1dYG6aOoWfdXwqYqeoghMZUU4gQ3Xk8fQA3+x04RwHwm+1A14VTjCIIhPKIzOHoxbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kTSpYcHc;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TSQ7I+AQ;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BAA606A32D
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:37:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33BAA606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kTSpYcHc;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TSQ7I+AQ
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5EQEp91008808
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 17:37:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VgYh4ixCnIjb0rEr5p1qolrzFm3xYIHBCGByIyBm0kE=; b=kTSpYcHc1eF6HoUn
	XmCKZCKwstUxtyGwh6SmeL6oyoKtVD38v8i9Rr4+SRYSUIOWzL9DnvKFEsLlp5Ta
	lwM1kRBCCEaQylxNO2cziZJsPgoXpmwGN0teX4XFZBx/nIgW+rvSOECnvgUXrXcs
	rjNUmqxL36zWgn/k58c7eg2W8uCorc5RbbahAa7IGnlJTzaFKNQFm0ic4BMd4WYH
	MHQwRuxze2XC3eMVZT4C4J+p4pedr/hh9S8756HwSm4zI0LyDG/2k6lWP2ItJqfT
	Xl3H+g92/tjsCuUIQVEknVESVToTxv8TxYxDU8U1hIcRfeFSsUPNVe8d2QspBdIe
	p0vkWQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrm9v2wwe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 17:37:10 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-351788121cfso3754647eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 09:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793900230; x=1794505030; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VgYh4ixCnIjb0rEr5p1qolrzFm3xYIHBCGByIyBm0kE=;
        b=TSQ7I+AQQiKKsnPSJnFyUzBgcJ5duAAUeiWc6n4kCvW9Bc7UbXtgCQtUjoyw28UG0a
         ZI8yizsLt2NkxwHKtzv9hhQKiHrHz5wqtNYCGck2k2tzyOsB40gOowMW4P26qzZxX52P
         y7nBsFcOYqB17R+WYt+Juf/Uvd8tiS9irzfwYqLLtwwErbZYnZyT9OJ+octD9hHJ3Wqf
         5qwtOkq+XbOamGBGkdhbpX2ksUE3pTXADyrtRbElqR6DRfyk21s9m4Iw4yZjXYFdHvYm
         01efQyYoxmM65uAZclRiZJE3iBdq2ZpdIUsBvKB2ZmbWEtk82deTxTs7PdV8c2Ip0jJs
         0v1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793900230; x=1794505030;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VgYh4ixCnIjb0rEr5p1qolrzFm3xYIHBCGByIyBm0kE=;
        b=0gJPuG7kt0wTO1oVlc4C1VQlkooNXqiL2A+ed9Pm9YzXF/rkSP2PMpaMc+EzS2mwvW
         TRDlfkZSzyZDCzIOBIz5xhDFkdV35d9TfGunHXYPVbNEytUbkCv0cET4I+tfOMUgJoEY
         Si35nhvQy0iCRNkm/oyVcLAmfUvOZPCVE/2iZJJJco6vypZM98zkRVhnYgvgeUbNUEqf
         UCpVRbEgCwFX6IJi2+ntWd/Aw4Jxsg5gOsav3kDJ37j5cubXrQweDGpf4sKDgkhaMzpl
         DP4T3nTovkEGeodCjMx5DfZENoeL8jBlv5Pbdw+ajRtF8y1x+3F3U5R5grccykNWIGY9
         g43A==
X-Gm-Message-State: APuU4Z/Op/HLoOMifbMGjVBr3W4UNg7N8zklMDqfJT58HnDJ9qCLFeYH
	9wU6xm8ONgEDXA5zhtxEm2IL8w9bDLaPkeFW0StIPRDeogKaeoQqy21gtLteqjpl/NSqFdSjhZe
	yCETkKrvAeu5z37qe2ppLVhV/NgePdMhne1yeY0PTtfhn5E5Jh4mFuIVVwI6GMbjs4gaonA==
X-Gm-Gg: AYBFou3BY3oWlnmYZlwlYHCUyl09vR14I78DreUiPzRPq77LzVpy23rwbf1xjnjA187
	kOsAxKZzb1ip43BZVXPeGlJuJKdywK8B7RcZjJimMku7sx8f4jjkaesTKPWjXujBI/qoYf2dR+i
	QVy2nMu48Qz1Ngy4tYRHcYAdjZ0fGLljWF4FVqTqW4jwawqsOgGuGpRQFGy1cfIZ0S+k/ZW9+QF
	LAr2CLcxTJVJOO+Xpl/FMG3lkfpmngl7ayYLqaIAZPE4ZyLMlUwrkPts1LeswD1EYXh2h3ewiDV
	XqVr2tLUZLTZgw1lyDsdgPxM5CfYjjOb9/H3mvQgmwWWG8SmPIe3ratsSbm0Wls72ZKezAm9le7
	wuiuosA9wj/Gm1/fURb5zG+TP5rlwNgH1GqULCv86IVTlflhLQraDGX/sps/rxBUwBU8+ixjo0V
	eIwVcME+REnCSqMpM=
X-Received: by 2002:a05:693c:41dc:10b0:351:2958:1740 with SMTP id 5a478bee46e88-36a42445a8amr29719435eec.37.1793900229507;
        Thu, 05 Nov 2026 09:37:09 -0800 (PST)
X-Received: by 2002:a05:693c:41dc:10b0:351:2958:1740 with SMTP id 5a478bee46e88-36a42445a8amr29719382eec.37.1793900228538;
        Thu, 05 Nov 2026 09:37:08 -0800 (PST)
Received: from [192.168.11.102] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca3981ff0sm22087653eec.24.2026.11.05.09.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 09:37:07 -0800 (PST)
Message-ID: <b780a16d-8302-4f54-968d-e411bf12942c@oss.qualcomm.com>
Date: Thu, 5 Nov 2026 23:07:03 +0530
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
Subject: Re: [PATCH] wifi: ath12k: Fix potential SRNG configuration leak on
 init failure
To: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261104-db9e3c75b3-wifi-ath12k-1@mail.sdu.edu.cn>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261104-db9e3c75b3-wifi-ath12k-1@mail.sdu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3MCBTYWx0ZWRfX/Nk+m2lxK7Ly
 2sQmh6qFZuE/ZLz4nh8YZx871OUqMJFxYQCd4anhV3KERioICCWU+2wAoyycZrDyqkGEUwVntgj
 B5otuNiBH7rDO9jxqWMH3rZS6jzb6U8=
X-Authority-Analysis: v=2.4 cv=KrHYSmWN c=1 sm=1 tr=0 ts=6aecbec6 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=9PK0hdjxVsNkJ1tq3w0A:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3MCBTYWx0ZWRfX4UxOqNoinb+R
 o6dYFHxDBWCc9tQIJCOo1ldE2ZHxCKZE4umicA4dSwhkIAHyYP8IfbnM+0olW5lOYGCkt5Q4e/W
 9Kmc+HUzHs8nXoWVFY/B7tRW3gYOF7wnjQ32GrQvBr07Qn0K/TonEHBTYN2TvjqRiXvkT3VTQIf
 dxqUbiatrMWMXu+DrmAj1C+XjVpGmGFmUlGyeDFyeuWbWP+mWuwo20ugg8ZkIdXSZbjYJUDBf74
 qBe3W5b5/W4rTfsrqPkjFxSxLU8h1tfYcmCTpUb8PM9BEdLeFfuwodCRmK269z7BRPr937mW4Te
 Np474irY5QVaQez5nZd7M2UScViH11VlPgZXfx8Pr5C+qGzyJrMjLvleKA3dlSLOfns/Oa1pH8M
 U34ER0pa70GyPu4bFYCqDc7ZmN9dJbhd2Ro7alRH+x2IwPsDdG7GYU5UPc4XCwsDA7PGRinmcLW
 aFkUo5XsPGBmh/ZJahQ==
X-Proofpoint-GUID: nm1-QwbbvRxw8cga9edT9BEF_LsFQrow
X-Proofpoint-ORIG-GUID: nm1-QwbbvRxw8cga9edT9BEF_LsFQrow
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_04,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050070

On 11/4/2026 8:03 AM, Guangshuo Li wrote:
> If either DMA pointer-buffer allocation fails after the SRNG
> configuration is copied, HAL initialization returns without freeing
> the copy. Its callers skip HAL deinitialization on this error.
> 
> Free the configuration on both allocation failure paths and clear
> its pointer before returning.
> 
> This issue was found by our static analysis tool under development.
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
> ---
> Validation: x86-64 Clang W=1 changed-object builds passed with
> allmodconfig and allyesconfig. No hardware/kernel runtime test or full
> linked-kernel build.
> OpenAI Codex assisted with source review, patch implementation and
> commit-message drafting. The submitter has reviewed the changes.
> 
>   drivers/net/wireless/ath/ath12k/hal.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless/ath/ath12k/hal.c
> index c0c3d2f047ef..8dafbe44df38 100644
> --- a/drivers/net/wireless/ath/ath12k/hal.c
> +++ b/drivers/net/wireless/ath/ath12k/hal.c
> @@ -744,7 +744,7 @@ int ath12k_hal_srng_init(struct ath12k_base *ab)
>   
>   	ret = ath12k_hal_alloc_cont_rdp(hal);
>   	if (ret)
> -		goto err_hal;
> +		goto err_free_config;
>   
>   	ret = ath12k_hal_alloc_cont_wrp(hal);
>   	if (ret)
> @@ -756,7 +756,9 @@ int ath12k_hal_srng_init(struct ath12k_base *ab)
>   
>   err_free_cont_rdp:
>   	ath12k_hal_free_cont_rdp(hal);
> -
> +err_free_config:
> +	kfree(hal->srng_config);
> +	hal->srng_config = NULL;
>   err_hal:
>   	return ret;
>   }
> 
> base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
> 


Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
