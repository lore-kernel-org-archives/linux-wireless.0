Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793776557;
	b=U3fGp7E1m7TrKkRf7smk74Wpap43gC3vT+A8Op4uD/6kKUhuS3QkLEckFllrfDjqJppD
	 dWUd3Zev22XJEVKBfo08+drARJ/oZnt5mXULTKOUbnqsyKMlZl8f6JM0bN7zod6d87KeY
	 QFA9E5XIoWWgMhNCF2qNRs6D8V3F/9tt0IbXplBMVFI0jd0qoTeYw3YO6DCpYRt1E1OL0
	 u4Z9O2XDPSaCn7Uiusv1RMqcvLFhvfJtOXk5bX3zL+/WjVJyAN9vNBKxhiJuJYjg984f+
	 4xr7jXecKkpoWsI2IHLKp3blGtRh8jMM+w+Mio8kqnqrcO75Js3qzNEsRAnOeat5hsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793776557;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=O+iTB2sWcEPdjLUfuDanELNYMg3s5WE5cPIFIy2cSUE=;
	b=zDGR39p+MvWOstPivcXhxZm60dRmHiM+pqDkTIOoAAT2EK1uiarLp+TGyrC+JCIfDB4D
	 gTh4OSWkJAlPrDDr8PmoXIqhad5df3ASK4+K0f3vPgEPI9otr/SF0n8mj5PsJCeD9X36x
	 exSzF0fPRauf+ZZI8UPiScupni0jvZaQyiZ53loSvpYqrJqmM9xuGRF0wYOpge3bFoHMI
	 7Qm+YTdissS5V1bh4lFqFf3/Jz6rdAHSw/L4T33x3GAEKr+/xXAFayXOIzJiJk6RYQVO2
	 K9PlHBPKeOYLRxz3tSSQ13kTdAmAgHxk1d8gHeG2a0d/nYdKFETdkLwFHKcwBilY0jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=guQVGrwx;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ftSZ8sha;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF721606A32C
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 07:15:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF721606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=guQVGrwx;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ftSZ8sha
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A4772TG222114
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 07:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	O+iTB2sWcEPdjLUfuDanELNYMg3s5WE5cPIFIy2cSUE=; b=guQVGrwxqr3g3k9q
	HPN8kLpq1G+oRg5fOfkBHVmzFiXk6V5dtaWw83j274PtCzRs8ZOK4oN80lHN9NWf
	6dEsKVX0OWLm7bfntOJ2I3exFjhbH9jnVsBJhiRJUfrI5/tdOlPzpVVfUJN0IU92
	z/9f2/9uSd6XWUSfa4kszrGOAq6zpwqUIBFAMd8wLfc3nj+MtuOt+PwkggqfPKef
	M/3VaauG/WroWIOBagsApvmCLSRlE7o0AC+OMiiKvEwfGE1+FLUPm271Ln05sp0U
	25y+TXYNlyt2xIDDFCry9C921LHok5TIEIPuC5Jik2f3HuHXOYnh1jciTHgRUcWa
	ocDu8A==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqjubkaj1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 07:15:55 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ab926c236aso463005a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 23:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793776555; x=1794381355; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=O+iTB2sWcEPdjLUfuDanELNYMg3s5WE5cPIFIy2cSUE=;
        b=ftSZ8sha5HR5FJCz4/LW/7WBHppiMS+IUkWeIqmyj9VQ4vOzTure2smzGggSQEkHKn
         rDfQ/mDkYMuCJ17wqdLIoNljlp574XGbQzuRUEV4KV22WsPgc861tcDoLNt3eGjdrcpQ
         R+zBFC0diYVhVrEDu0HjOW21D8uoS/Ittay9epl9FX2SBLVMUG/b/I25+rZH82vvnAsb
         BW6+XUKK3q/ZAlwpQinRz8mKFl2UCJjMVj0xq1KFZLNP7N16vUZRim1wm5arcaVeNXQh
         Ix6R6+W0LlDc66RnB5A67Xsvaw94U1t8K6KoQalu9CI5N/T43q0iPxvIPZjoknOABUK0
         xKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793776555; x=1794381355;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O+iTB2sWcEPdjLUfuDanELNYMg3s5WE5cPIFIy2cSUE=;
        b=Rq5CioEJaFu6eTVc05r2fQ7TwZRRe7UcJLv1oh3q/FLoKxJ46UNdfqTXIZT+7llf0/
         rYXPH3NAWjlUr/zD66EJMd7xpl204OtUflICpMSEVJRkiZuS33QxqxGfORDt7SSWhXCY
         ZD2nNQC7k7HMd2t2FFmc8Ory+PufRZPHj+HVhHPuXLsA1uviXHeigPztqmYyYSKnQM6N
         y1si+SmAUoP4tEJoapByQfgY5m/cZidDpDWR2uMYHshOqQ8qOBjc9RmmSEPo7kVQiWEy
         Lew9c9srOFRiTT4c6WIAdp4vvyW+C3Qppt1jvgLbWcYyTy85NOcBNS29AzrPob1aY+Ky
         WdxQ==
X-Gm-Message-State: APuU4Z9ZlTPo11CuU7kc/0H8g67BM0w2xW9oe6vUhsdePKcjCXOfneLV
	enTCEHewlAYcLX4PWKf0JKiCUuH0Ft6szbBSXC2ezLIQoOfy1ioGoHZElq82JxNMLr7XKgLw9SG
	yzJgMAAO1U4/dEJnERfHDSk+CVJMjBSzMighONzuODp+zP01CaFdVBnvoLb38Q8aSpM+fpQ==
X-Gm-Gg: AYBFou3MfZklsWP3kF5BDIB6n7ZR3GSlu1XifVgy9d5dkdPIfxOCX0/CIvmKLbt+7Vi
	J2pHibVK0IkIfje/wf5Heg5VZDnOEcqgqqpCGN6FlaCURmo7qlxPHd8Ol8LOxV0SMEDH5zowiZD
	ienNPX9ka+skngWOohUse8TA626BB2acddfif41tqdGK9KJTaZk4iGlsvDk9W7fo9oPTBKqwceW
	8Wafbc1NDaTgqqhqqakOU7Bg8v6fhbNTwI9mWKEDi+6h/NIDmYP/cwK6oZYBwLAK3qokeaJIbGD
	2dv0dckT8GxsG8N60FsfbwdVVtsoRnLH+P7AdSvoOPERPBEl3enKToS0ySZmyE00la2UWmom7aM
	2fOPupFTCQc47ocgU6Ds45e4V0uMAw0UjfvWoN1TFsAFCBWx4/o/cUvJi0W4fpIGlFQ8P9VMx6E
	KC1jb6IjKEe6L5LGjaE0aVcisF5oS/MP+t4Pu4kTSNFDKp
X-Received: by 2002:a17:90b:4a85:b0:3ab:c674:cad1 with SMTP id 98e67ed59e1d1-3ae897994c4mr12728510a91.50.1793776554618;
        Tue, 03 Nov 2026 23:15:54 -0800 (PST)
X-Received: by 2002:a17:90b:4a85:b0:3ab:c674:cad1 with SMTP id 98e67ed59e1d1-3ae897994c4mr12728493a91.50.1793776554082;
        Tue, 03 Nov 2026 23:15:54 -0800 (PST)
Received: from [10.133.33.51] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c896cc6sm7753646a91.9.2026.11.03.23.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 23:15:53 -0800 (PST)
Message-ID: <3980be1b-b769-4127-9820-1ecc6333c6a4@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 15:15:50 +0800
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
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: refactor m3/aux_uc firmware
 memory handling
To: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyOCBTYWx0ZWRfX+gHkQ2vdTrAw
 VOhVU8BhGajjoetA19raFU8Rvlnr94AcUdN9KGJwKp0e1J0dN3DuOfJ3xALJRiV6jCJ2oF8j0jP
 8IdN2tvDFCH11lKiFZQLlyIfi/cWMck=
X-Authority-Analysis: v=2.4 cv=JeUpPkKV c=1 sm=1 tr=0 ts=6aeadbab cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=WH3b8gmyxz3kVt_5t98A:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: uXFO18w0S8RNL0fVA3mxng_3ASlah5PP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyOCBTYWx0ZWRfX4MzUjyOLYCJw
 9UPW+fPtLSSJo92gaMllVBMAq+Yz/SzT7T82nho1kIvd1iZplCCALuNl/ixN7LP7BcmBupyfLha
 Pc7ehw/rac18EQ+om8FXrsecIEEygltB43uKxS2nCVgzK5J2fB7q4UqfJAbJZPLeUXflht552+K
 EA+/5zO5hmQEbU4mmSTd/eQrZz+oJHEY1NqwLXp+PtRa1n4MllooeJgG8CY0kH+vx/FTCcP4R07
 3sjqk+gHY3SY3twi73Z77EPU2HGyTiT8fTQkYly/MvGZBN9SAZRG2kPc+UL6vWMld2i6rkZOukS
 eNPVTMgI0kooGD5JueP44bkaCoRAbKvGv9F8N5DqqWj52NwFwHTmErSH23ewRN+Ss/dey+9qD7K
 SmTViQRCPlDZgsmjsIUOgRwt2+k7ZBwC90mv3czfjxrDbqtMUAKsXcfcjZEfYrsWG6oNZpYqf6q
 dqywnA1pqlg+QpNCGqg==
X-Proofpoint-ORIG-GUID: uXFO18w0S8RNL0fVA3mxng_3ASlah5PP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040028



On 11/4/2026 2:30 PM, Madhavan Ganesan wrote:
> ath12k_qmi_m3_free()/ath12k_qmi_m3_load() and
> ath12k_qmi_aux_uc_free()/ath12k_qmi_aux_uc_load() carry near-identical
> logic for freeing a DMA-coherent firmware memory region and loading
> firmware into it. Factor the shared logic into common helpers.
> 
> Patch 1 is a preparatory, no-functional-change rename of
> struct m3_mem_region to struct ath12k_fw_mem_region, since the type
> is also used for the aux_uc region and the old name no longer
> reflects its purpose.
> 
> Patch 2 refactors the shared free/load logic into
> ath12k_qmi_free_mem_region() and ath12k_qmi_fw_mem_load(), and
> rewires the m3 and aux_uc wrappers to use them.
> 
> ---
> Changes in v2:
> - Addressed the review comments.
>  
> ---
> Madhavan Ganesan (2):
>       wifi: ath12k: rename m3_mem_region to ath12k_fw_mem_region
>       wifi: ath12k: refactor m3 and aux_uc firmware memory handling
>  
>  drivers/net/wireless/ath/ath12k/qmi.c | 168 ++++++++++++----------------------
>  drivers/net/wireless/ath/ath12k/qmi.h |   6 +-
>  2 files changed, 60 insertions(+), 114 deletions(-)
> ---
> base-commit: a2da7677eb9a12e7860814b70a1f6f5b0e347d7d
> change-id: 20261103-m3_and_aux_ucode-8337b881155c
> 
> 

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
