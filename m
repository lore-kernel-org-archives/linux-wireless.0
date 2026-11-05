Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900205;
	b=eMX4djEOSTo7wxP4cLf4oQ3TCFfZMnvIqhvuiYKkey5lLsxsSL/lQ0WG/6E/YUNQq++v
	 02q9rJtwSPcyR+JxJTi2EAXY6AOJ2BkGFL2Fthv8YQj4NiPtN+fa/stBvZAnCdqrWkXPF
	 20Si6HA5xcWvw+/u1kNtNuG63Q9F5/T4RL0558PDJyKtqp7Q4mo2Bt5JK/KaT+o0fBfXD
	 8/YTfQ79AQJmnW6SKjC+4B4AR6H0nTelwj/VXe3yOvJcklCbnDi+jZPS4QwFSlwKY+Ssv
	 k3KRXS9AQETumxkvdZ2QlEqTtCCkVhmIy+4Pv625+6AOYp4nR/w/VaPio6CWIB+nCBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900205;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=APYTMa5wqJKDsloYf8WsHxudYGdEST/0iGIISjyttOo=;
	b=vGyvUQCdrJW8ClZP3250JFv10SnzSSCYeVxC59tZBQNZXCn3PwQgl4SbdW6DwZ1iz9nO
	 pcVwqIR7cwFO6B/2UXw59YLHryeElN5UpVXo+d/BbFuWS/NkMPnmnzwyL7069HdX08N5V
	 HZtOKy8HSzeC4vmK/iTEYJ+j+7+Ora18o7rcyanyUMqTn5mQK5G1jpEoiua/FSoHPYSF4
	 SOOaZJRbPfN1aIBMZ+R/pezcj9RbYdg4OAireit2YXKsw7a7UxXOuh/qlVbitvct0QIOa
	 uBvtgzAdFNlGkUCYsLtGmKgjHSCbJDrpsNp+yNcywFJoKl9FMZjKRYlwI0og3j1VAzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UzPQOUZP;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UyPGfyvl;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE963606A326
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:36:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE963606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UzPQOUZP;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UyPGfyvl
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5EQJgh2004738
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 17:36:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	APYTMa5wqJKDsloYf8WsHxudYGdEST/0iGIISjyttOo=; b=UzPQOUZPwBpiyKHo
	t82syey/EgfxUzie7LDcWi15iHRW/ub2HFhNxz2RjPuqLVcVapvM28nu19iW9Adi
	0f5l6+OQ+2PhupRbUxxqzHl94xVTEfE2qKbtWsMcSmWTYbBbCt3eIYgXU0h4clw9
	QD2De06sEP+0DxNPk2UYHdp1rJ9JXPXcRuq/ms3FQFNdf07MHhHzj2hstZdidsaf
	CkkTUUaA4nGz/R4cljmCGX4FZhiIMGhI0aS43/zNcfX9JpasYmB4FRad0s9BdT17
	80Yjtmfudz9oEG9k47CWX13jnhdWrlRBSZ1V7i9ZnsOUDJw3E2z/1h3F9weAg5Ed
	d5tjbg==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrqpd1ysb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 17:36:44 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-147be78cd56so301538c88.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 09:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793900203; x=1794505003; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=APYTMa5wqJKDsloYf8WsHxudYGdEST/0iGIISjyttOo=;
        b=UyPGfyvlNetP2SU2xYMvkm9D1/YODYee7Aqbf873zjnuF291rjRVei3EqFDuxAWwxQ
         +o8itJZEn7YW/B6IzwsGjpn8M32lrZRAvXxJnit3zAnNwiQQyVNyAFhC0cvHs65ldfq7
         rMZaK6n6cejvOujv1x8tBzOFhGSAPTsEHmk/kW5W1Y8bqEPbBeGMWSjwznjVUNDtKyLS
         Op4uBmWIb8nHYAdpU/TBTCBe7Bqhk/i1H9JYD6rXinBUdjjG7sVlpPYPjflRVtXIxhIi
         wSm/YJUuZZKB/LTfEVv6c+o4kEmV1oYizwjcJUBj99ENjCGG7woP0Ht2Ci/vakWwwnUX
         mCOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793900203; x=1794505003;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=APYTMa5wqJKDsloYf8WsHxudYGdEST/0iGIISjyttOo=;
        b=H+OqGHQ/ezWqeKKm7pGnKUPW45QMGmXjhOTT1WbZ5GHjmXrdebugXaIdCVqcG9a3Fg
         AfVadadqzmG1oOxsBhDyRBMpW/oVXoKvbWH7XuOkvIzkLjAalzUrbX4UWKvsH7znmcv9
         pLK6MVU0BBOttCJfjupcz237w/J+8zoWhc3hmP17pP7bX8TTzZjXFfDkdigc8MaVlWVv
         8qaor7PuEO9AfmHI1uIOcDCrGRf59oJc+6eCjaaLyAPH3JSamlZE5KJtBHODgRYuGd/O
         JQdmC0htkgP6opbstewq0isS3iE3Ij0GzLT3gC6IQwWBlK0qRWNPHb24BBR5FdPnyLoP
         +75w==
X-Gm-Message-State: APuU4Z9JuBIJR+THk+mTotDvuK7wLe6nrwnRzJ7aAVkC30tGUEjFOTdV
	X206YsC+4tChK0HmyAiBPxncF415c7dozq2TMYw+uNYCR7CSF+bsMDsf8hkdSLYLd+CBKepsByT
	F2G3xZrIvScYAbU7V4V8rqQdqjlJaSJA2ZfbaXPrRiq+P+ypIl7+13KLWjsSuGiO0Cwy9WWnSWh
	+fRg==
X-Gm-Gg: AYBFou3exKlL0ca03fiw0osEk9tiUroLpmo9pS9xzZ44AGIqW61fqIEesqAv09To5VY
	B7U3crK0yq0OcC3/P/hKts3BYVH7aKvthudZKusbIKDrurhU79agHjKuwwiBFiXAs3lPZe4PoQs
	poWPe/150HPOk5mkMW1itXTjlcH7U1ZhBBBBqgQPmHYNdroM/iD4Dup/oPvS3m9ijJy+wSWyTE3
	PkQghtnMDOEIKetOk/5hOkb+uoL4NNBBphKRRpeOgQGPft3ZB4TFy+9Jvlha0NGztyu2UMoDQlS
	OeUgx/EoTh6uUD6lSj76oPHcc/qmagZxgtyNhQWWgGWGnuKc08SWtcjs2ancb2rVKjr4BFD/qoZ
	M8knpa7OaUxIje2RXX8WTSqBO6LMmRQVY9V5+ShZ4Yefax/xbhJ7aJdKWmVZGeWKwS64Y33rjdy
	t6Uza2ljsINGQlhEM=
X-Received: by 2002:a05:701b:4182:20b0:1a5:52f6:db9a with SMTP id a92af1059eb24-1ac5ca23c29mr31173031c88.22.1793900203179;
        Thu, 05 Nov 2026 09:36:43 -0800 (PST)
X-Received: by 2002:a05:701b:4182:20b0:1a5:52f6:db9a with SMTP id a92af1059eb24-1ac5ca23c29mr31173001c88.22.1793900202497;
        Thu, 05 Nov 2026 09:36:42 -0800 (PST)
Received: from [192.168.11.102] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c1c283sm18824490c88.4.2026.11.05.09.36.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 09:36:41 -0800 (PST)
Message-ID: <263ba263-c59e-4d43-a745-cd7faed3c681@oss.qualcomm.com>
Date: Thu, 5 Nov 2026 23:06:37 +0530
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
Subject: Re: [PATCH] wifi: ath11k: Fix potential SRNG configuration leak on
 init failure
To: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261104-db9e3c75b3-wifi-ath11k-1@mail.sdu.edu.cn>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261104-db9e3c75b3-wifi-ath11k-1@mail.sdu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3MCBTYWx0ZWRfX6wDcBi0Sk0eW
 LQhk+4tyGPUbMQxu50Tb+8NbI1YK+U74EaV5aj5yrkTcOFzHoMw8uja+02+lRd2a7jtOfLg/LOV
 rfXeEEt2F1Z9XJybehwjZf/NYZ8vhws=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3MCBTYWx0ZWRfX1CC1nCYe9hH9
 80vsSfANn6cn5jLASQFUe3095Oml5JVIHXZ1eCSlCQTqhtSBJyaAy4UmBxD4V2FWUvyQms/8vw2
 TIxjRuaWA0qh1vIj/b3TNC+PZCB4dP9XLjJPlSxgcYctjaYWY+lWFF/ml7K61qFjkpYRch7RCDh
 X78/YCtgqBjEuO05CxDrunlp5E4qctSM6UUk8XfXvZpZTBmQoNgonNTWbdvTLzkftxj5EUPAQbg
 LW5MRtb8Ym8fgP4NkvP0LnMON4X5j7CF4mKq3Yeh9PSyA7dWvYq7JWrCtb6NEtBlcHSkvUVH2MZ
 IhMd2ag35YiDi31TU5pKUrQtzU+gMyTi6kB4MZSJkdUYpSoIAFqfBCK4NLJQk5pfTDCRWO5gEf7
 OHS6x18l9djIYNT3ckl3lYg0UD1BnM8w3zUn9D7VAHUz7U1B9vS2k1I2G9RFt8Pnr0QmI6RvUfF
 ada0rgE3qg6n04oQqBw==
X-Proofpoint-ORIG-GUID: CaA6pD3i-iSa28dxqZR-M77ChY1TA3hD
X-Proofpoint-GUID: CaA6pD3i-iSa28dxqZR-M77ChY1TA3hD
X-Authority-Analysis: v=2.4 cv=Y5JtIReN c=1 sm=1 tr=0 ts=6aecbeac cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=Rv8SPUj7cjXdj5bJQ3UA:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_04,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 spamscore=0
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
> Fixes: f7eb4b04ce6f ("ath11k: hal: create hw_srng_config dynamically")
> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
> ---
> Validation: x86-64 Clang W=1 changed-object builds passed with
> allmodconfig and allyesconfig. No hardware/kernel runtime test or full
> linked-kernel build.
> OpenAI Codex assisted with source review, patch implementation and
> commit-message drafting. The submitter has reviewed the changes.
> 
>   drivers/net/wireless/ath/ath11k/hal.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/hal.c b/drivers/net/wireless/ath/ath11k/hal.c
> index 98bd9e3f0aae..8a4e5042d89a 100644
> --- a/drivers/net/wireless/ath/ath11k/hal.c
> +++ b/drivers/net/wireless/ath/ath11k/hal.c
> @@ -1351,7 +1351,7 @@ int ath11k_hal_srng_init(struct ath11k_base *ab)
>   
>   	ret = ath11k_hal_alloc_cont_rdp(ab);
>   	if (ret)
> -		goto err_hal;
> +		goto err_free_config;
>   
>   	ret = ath11k_hal_alloc_cont_wrp(ab);
>   	if (ret)
> @@ -1363,7 +1363,9 @@ int ath11k_hal_srng_init(struct ath11k_base *ab)
>   
>   err_free_cont_rdp:
>   	ath11k_hal_free_cont_rdp(ab);
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
