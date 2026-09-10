Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E304A68A7
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 15:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789052847; cv=none; b=LrDqRdAyGNQwoPJSpOe/zTjfVT9EUjro2J+Hy86AVcTzXdVCzM381R/RTFCcruikZY/W0KlRzb6IfoLG7JfNmnFgYFnsxum0QlbXr4KMqFEkESyReDnBChfe1SICNWy1R4P8yTLoev1zgzzsgPOGJbw9EL6MD6aigcP+QejGEBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789052847; c=relaxed/simple;
	bh=wKGPNvbmfP/sb+FFj88jmK6UKoFy1VjgTXRbGoZ2KXw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TKaCDzTWciJdJgjjNxp6ktzq6uE5yBRtFbQ2CKYKZKrV9VvTrEPM9EjVoI1Lz+fzfhrDv78rynnCFmGQdeWEM/41omGWygZPMlykRF0+37K8lBIdHVmRDIEjZgtCCg7hytpVsmV0XhZiYlYtGBq4D1rrdvV15m5nkT6Lba7vljc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eDiQ3rGN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WqDq9Sx/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eDiQ3rGN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WqDq9Sx/"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AF4mYj1652887
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 15:07:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	opUYukIe/FPNtsIS7kDh9vfDAQXoVQv5BN4rJ4BTz6s=; b=eDiQ3rGNS4YBBL+L
	O0FT8h0/0VKHl3cwb6mEW5AZZLOiTV0k/iy36CkbPyuhVDvlwmszbyxyKWoyHl9x
	7YMqUu5acqbPPG4T/QS9ei1cdPeOsPUWABIghiSzlmfjmntIFXSB4dZqwzAuEx6R
	HZe414Lge4JmOhYwSstGvBcii2jl6UF1iycphMr7I95dYDSvJ1zrJCycpvFF1KEj
	ZZS8lPvar09XW7Nlit7KuYWy/21B+YyN/u7QLYYF/rD78i0Gx+cuHMAR/A89P84q
	YlrSSVzflNrXyMXHkh3X7pSTBk0eDYj51X1jHVLhCNBFpUTbCD6Pg5m6HDj0HM+6
	I0r8dA==
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkrcjt13k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 15:07:19 +0000 (GMT)
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-8546e211940so117064947b3.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789052839; x=1789657639; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=opUYukIe/FPNtsIS7kDh9vfDAQXoVQv5BN4rJ4BTz6s=;
        b=WqDq9Sx/Wkfj/ZvEOahgW1qn+NeUTF5PlaKTEEgTcVykA9mmdsvbdevrNF8UXnujQq
         Ach/Bf1uAAlQ/qrjJtd6fzoZrzV4rtqNWU/puFS+zPbNNdOCwhRkW0DUfIqsY0lBtYH/
         Tay0Gafx6pfpre267IJZ/4M0AYskpYc67fnHvxrE+NAczKzc4x2QiyMRKT/CmTthMVLa
         aWWPtS4EMyI8KjdUDxgGxW5GAPl/boOTNevhPCdQ9Pe3DAam5lnL0uexpQLqxO4xqwKZ
         L62LbczfFZlxVvGlHcN32ko9S9W4flcoKEJk3lydZ/2Bj0XxW3hzGGBRl7JGgDINwzJm
         Twnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789052839; x=1789657639;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=opUYukIe/FPNtsIS7kDh9vfDAQXoVQv5BN4rJ4BTz6s=;
        b=TLECnS0tWuPFnAgTMLdrox1ReJjmOMYa7fJg5glxqoP2bXcu9XTB7WI8mXYclJavWK
         LaHp2Rsgr2k1n3CWJ+WnwfyMz7A4bAItjvLSmuJH5mLjDC3yM55eiX9QQS5CziKB0f6W
         hDIOMItZaa0ewro3IvLYVWex9jIjeyJ6MbkKnMyC0o6gX1UqpZIxtkZQYPE8yVL0Ym3P
         yrZvnrMC+Bh2s30iufZ1Tm8QdNWyoFUZoG2UuhIQIdXZog/4UctAlb/jbiDI134M1WK5
         TsX4Npnzx05TY0WloBKEOfGDVVotktYOLIl6/QT7IGfmRuZQpnJvvcEaWDp18unbcEND
         D1sQ==
X-Forwarded-Encrypted: i=1; AKwUvBz9eVEvOW8WBw4SHg+mS5kHYlcwd652G3/C3hZ01PRyC4Cl9beeHD0HpN4oDfKw4DItD8fJ+y0G7mxAXMnZoA==@vger.kernel.org
X-Gm-Message-State: AFuF++l53RlzS7yv+WsxKYKILp3uh/XkHo5VnRIJGLPii8zVTZvh/HSJ
	IkpNZdtuX1tFVWnAGVLteextd7VITqae0qcBJfVW1hZaCaTIbFEQ15j3cxt7+C/lDx79tPFm3Hw
	60/Jt/EaxgPvK/5Ji4y9s0q2o0UGB83tYTzHFcPkmT0Q8ucfHFN2R6rOIu1ihv/j8IN1rtw==
X-Gm-Gg: AYBFou0juRvr3kRabi+qE0tx/cXjCVyI+2mpRof/ak7WOtcnfL1zD7HOOXd46n8rwZ4
	QopRyuCfOdB5R04bfXZCHjV4CSTVSciKcCPi5e/vRzmjpQ/9QzgrRaC9IlPyRxy7/HWzPxYfOR/
	wUovB+JDvLj80uH6eyfpUnDjVQRPay/+hIm7RhdYNMKvGsviLaW3o6jwZjkRTcMthu+bADFlPsr
	GXnM/sBVlp17oDGbYWjgUQP7+Ba/K60bcdh2T5dIVs24t8Oz0phNlF+S6SwYtmHmyyeAv6x+Jfq
	OEeyvLay499UsPQQJtYb3yPYu0yPlMMtfKGhLflcy7weCzQW/tGXLGYDOjiqtDGvnK8oV3/9Gru
	ZABXXKsAfW0X19pcaDkfrqGn/wkxpOBClauDycmJi60w7379yzVXTAKs=
X-Received: by 2002:a05:690c:7:b0:85e:688f:3c52 with SMTP id 00721157ae682-871290a4c74mr157112707b3.33.1789052839137;
        Thu, 10 Sep 2026 08:07:19 -0700 (PDT)
X-Received: by 2002:a05:690c:7:b0:85e:688f:3c52 with SMTP id 00721157ae682-871290a4c74mr157112047b3.33.1789052838568;
        Thu, 10 Sep 2026 08:07:18 -0700 (PDT)
Received: from [192.168.1.20] (163.sub-97-215-3.myvzw.com. [97.215.3.163])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-88486e2da28sm173237b3.20.2026.09.10.08.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 08:07:18 -0700 (PDT)
Message-ID: <2fbf61e9-d6f1-4033-b42f-c10811b85880@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 08:07:15 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] wifi: ath10k: Add missing validation in debugfs
 mem_value and reg_value
To: Rivaldi Hormat <rivaldihormat@gmail.com>, linux-wireless@vger.kernel.org
Cc: kvalo@kernel.org, ath10k@lists.infradead.org
References: <20260910080659.20831-1-rivaldihormat@gmail.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260910080659.20831-1-rivaldihormat@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE4MiBTYWx0ZWRfXwWAgNyj6VPzY
 AfCV8KXiPplAV/+1p7lbQgvKf8MIJmQenZet+raLxSEEgdA2CgF0OTTLpmD1leEn6ChgKq2B1B4
 8pbO1NG/SE8wlmlcyTiKb3HbfA4+44A=
X-Proofpoint-GUID: _gmncOUOXr5nZ4B8RwsCj9dstcvH-DNU
X-Authority-Analysis: v=2.4 cv=aef0Dhot c=1 sm=1 tr=0 ts=6aa2c7a7 cx=c_pps
 a=72HoHk1woDtn7btP4rdmlg==:117 a=7QqFuFOOHQR3GLhHC5mhXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=J-SKrIC2Fr2eh99-tBcA:9 a=QEXdDO2ut3YA:10
 a=kA6IBgd4cpdPkAWqgNAz:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE4MiBTYWx0ZWRfX956+9FQEb1OK
 CK1kIOD4blevQWiu7cvm7JvwlxhFnWjFwnvok4qWxU1+wIx2SU8V/pr8kn1W2gNkVnhX8K1VBJD
 a7T/ZUL69yIaGo4NZ+WzMOXdpoJW3IAW60+diVOEdzeyc3jHA9yVPR5DdirAiA4D/oSAFypNRpf
 thRYRdPVQPB5ERlpL+MNHc/gxKFQBIAwjB+fHiliUl/1lhG77iWrd7GfEvmEcLTPJEgLweH0jqY
 gldY3aZnDudGp7lvyjYLlm3KfoCmApe0lelY5GSobN+wyqq1F0AAiMRtl7FDMeJ1RXSNKWu9KBp
 gOOcw1LjRI3I1QdUguKlogaPaLJPBX1xbVzPlH7DFoX+jjVx8ms02Gk/MEXN3uKr34YtB3md2eA
 dbU0psXqC1IVqYURIRj8zjRJvXk7QJf6KhR0vTUIgJt4B8C6c6+IEm2MJq98c6/kmYkrBgGL+m8
 FrVyWLz1/MFaYG5R7eg==
X-Proofpoint-ORIG-GUID: _gmncOUOXr5nZ4B8RwsCj9dstcvH-DNU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100182

On 9/10/2026 1:06 AM, Rivaldi Hormat wrote:

where is your commit text?

please review all of:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html
https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath10k/submittingpatches.html

> Signed-off-by: Rivaldi Hormat <rivaldihormat@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/debug.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index fb61e53ff..50e017021 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -729,6 +729,13 @@ static ssize_t ath10k_reg_value_write(struct file *file,
>  
>  	reg_addr = ar->debug.reg_addr;
>  
> +	/* FIX: Validate register address */

avoid comments that just restate code

> +	if (reg_addr > ar->hw_params.reg_size) {
> +		ath10k_warn(ar, "Invalid register address 0x%08x\n", reg_addr);
> +		ret = -EINVAL;
> +		goto exit;
> +	}
> +
>  	ret = kstrtou32_from_user(user_buf, count, 0, &reg_val);
>  	if (ret)
>  		goto exit;
> @@ -819,6 +826,19 @@ static ssize_t ath10k_mem_value_write(struct file *file,
>  
>  	mutex_lock(&ar->conf_mutex);
>  
> +	/* FIX: Validate address against memory size */
> +	if (*ppos > ar->hw_params.mem_size) {
> +		ath10k_warn(ar, "Invalid address 0x%08x for mem_value\n", (u32)*ppos);
> +		return -EINVAL;
> +	}
> +
> +	/* FIX: Validate size against remaining memory */
> +	if (count > ar->hw_params.mem_size - *ppos) {
> +		ath10k_warn(ar, "Invalid size %zu for mem_value at 0x%08x\n",
> +			    count, (u32)*ppos);
> +		return -EINVAL;
> +	}
> +
>  	buf = vmalloc(count);
>  	if (!buf) {
>  		ret = -ENOMEM;

