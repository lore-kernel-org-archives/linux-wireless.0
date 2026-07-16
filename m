Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044E73AE6E5
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 17:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784222545; cv=none; b=S4QwsZ4WeHleUEIhC7dB1vycNG7mtaspqzDX3Yo6IztNvTn78/Ykej64mFCptHS2+Q2FQ/dzNLQAIp9gTSCzk1Km0hX9y0Ytm9OEw3EC1c5DzQaTphMQPOvJtK/2Yg95AE5cHN8GK8VNDHEMqNcJlFRaFUB2rt/qa8Jyq5DmmGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784222545; c=relaxed/simple;
	bh=Sfg3jH0UTIrgYU9/0unxDo09tpclglyzty17sunV6dI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FsuHOwVKLDwVv32WfahYqEMa0MvcSQPnjT6IZBwaZLP1Vf7N2ffELDW2/VG1O62vWo2LbNMSLf28q4vw67PDpSePZ2lIZ1Jozrj2HcZlmC5z7f5UhMIjfuTEGX8m8s7l0n2kItrS9ILs1k8HqRMv5bjEpiyu7IiptaqDVKF9JCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Vf99CgNN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GbNcvMqU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Vf99CgNN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GbNcvMqU"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GGTPaS3412846
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 17:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HdigXa7u/9/qM5dZQc/0RHIs0kDasDxkAbhkgLWMwW0=; b=Vf99CgNNQ8NRclie
	DDaakprN6lpMS5YhlgXmxX51iDhthdL9f3DHej3t8Q1j7GY8BrEJhzguxmpKX0bL
	QGnwwqb+9W/mcAAk3t4BaBlPQ+JEZRVaKWCyKIozTbauc9QoPtOW64nDReciDmKj
	vjflNL8wjXbRHItrGsfMqFAG1XL3qchJzsXWZmJQyCVMT2f4gIYxXvJp0dGs9LAT
	wQu2jeKOtRk6/rb44UxvLHeaxuOJ6UexqrER7yEw7dfhH/IYswiMHISXzhKg03y0
	DF8C2KiF8GCduodS9c92u45bvFgK871Ix5X+0wdy/C/wpY7UVOHgAg/3522vhbyI
	Rsm4Ww==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4feu10ajrp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 17:22:22 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38dd87656d3so5819256a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 10:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784222541; x=1784827341; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HdigXa7u/9/qM5dZQc/0RHIs0kDasDxkAbhkgLWMwW0=;
        b=GbNcvMqUVsF0Fv4VIqQzPwXtlZnF1Zp1xWvqX1wMW/LKlAaRDOJ4syZLD2S4vGO0F5
         txc9yYD9T+NZkNKsz622gu1igll3agVS6yEysrAFxZDkgCVFpqVSLIKMdPmtC9i6Xeno
         1LinZZJugCNNA8afA/Jv9ZMZZDPjCf/u9ghX6fM4Q3g0/V1tVweFn+icewhq/DhGO8tq
         JjQjgtJ8PG3wnNRzKiOt7b5L0sT/3/k2t3Vbrkjn1qkm0oYgmmg4GdFb8XEzncBIO8FJ
         65Ei4JbehLYY7Rtf/20W79LzXI58EBsoumRQzm8NYhzUR04R9NnlBlr74k7Aii59UB2g
         xGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784222541; x=1784827341;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HdigXa7u/9/qM5dZQc/0RHIs0kDasDxkAbhkgLWMwW0=;
        b=a9nQE0OXfhO4YTkeeK12jBwsSaKU0xQ0V4adfWk7y1Akv2gm6zN/+122pH45MXO111
         uaXshG/mwKHWz7M6Z7uQPVGp1f+lsS9kkvVhmJu/w8wAAhXfWJsGR1RRLMy8G27i7jqv
         oaeYexikWHWC+oCF7PzLXN8Gj4rWMRCMJ48rwGTrZ5rlFUdrPTHJYNiXZT+IAP7+cpRK
         jSr2H2pEnKmKAGLW4iNv8YfLcUWvtAiYYkhPDLHHzAAZEfr/4Xp+/aUKGIvipllnU84A
         E3yybTPp8BsQCSjlsAL5ZBFID2XipN1JWMaJoLyEAXJeTEE6DouZfhZ5GB7PKE6gkppI
         Jd8g==
X-Forwarded-Encrypted: i=1; AHgh+RpXbtmXVATudWjdwiUmQSEBKtdK2oGtfMOZg0kdvgFd52HuJORLmGrFCXlae/jyR2VfinEIJyonwDaKYntRMg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKeIkSAAuNJnxWF7l2FjCVWUTeDsGD2yI8FTCY5h1kCMMT2A62
	XC9UJEtNgPUd4fpCgPWBVoj/rJ2/6eo7XW5GdBsu7UEIwQ2tZIpwn2rMwPljPxaenV5Kdmxtw4u
	45PcpImFeKFkizfRdyDepuSwhtqhJu1XsRoXvxQabeOG3TqKKh+gsFEVzzhMyhlyE0a3m4Q==
X-Gm-Gg: AfdE7cm1Xcu/yL6LAu7Zp0QDNyh5keMJXSWM2CggquiHI7dsbnIBUog3HGbrXOZUFiT
	uU/gHCI37bxhTwpJnumFsE+m12rSxj+AhLCdafSPxn8Jrch4VO5G5vYQID5jSsH5K77mSubDvDz
	Bpn5YdM7ZMfXwy7IRNDEhYGjwuTfeaZaDGKdEHrVivJa8GYSw5SlNhZKkijYOHoExO/4kb1L0PV
	6D0R6Jlj8i7pmvav+DCUxEarvLJAxrFB3dvKVTb6fgmipcm4IlTDh3fd4dDaVShDr+OuoNFBGVC
	PD8RZPJpoN1aob6eCF2POJbVYKXJJ3M5vWszJ7LqZ88+GHNUJpqcBnPbXyOfaDR1RS0d3BHHwhz
	p0ELX6kab9V29JBQxjCADdLUZ5/oM/0C99Raeftpnq4q/
X-Received: by 2002:a17:90b:2b44:b0:38d:ee84:b1ff with SMTP id 98e67ed59e1d1-38e2a0f1b39mr7511856a91.40.1784222541611;
        Thu, 16 Jul 2026 10:22:21 -0700 (PDT)
X-Received: by 2002:a17:90b:2b44:b0:38d:ee84:b1ff with SMTP id 98e67ed59e1d1-38e2a0f1b39mr7511814a91.40.1784222541049;
        Thu, 16 Jul 2026 10:22:21 -0700 (PDT)
Received: from [192.168.11.102] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6f0dcdsm11848627eec.31.2026.07.16.10.22.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 10:22:20 -0700 (PDT)
Message-ID: <4a3a6ebc-67b0-4120-b19b-10208c6cc6d1@oss.qualcomm.com>
Date: Thu, 16 Jul 2026 22:52:16 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath12k: Constify struct ath12k_dp_arch_ops
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <969d732e2c6f169e1aa5e89c7e01743a1adb55df.1784010931.git.christophe.jaillet@wanadoo.fr>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <969d732e2c6f169e1aa5e89c7e01743a1adb55df.1784010931.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 5Ve0SzmsIelcR_quLGto6bBwOkEQ0s3c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDE3NiBTYWx0ZWRfX62UkjPFE4ImJ
 YvT3xo2DWEvFADBjSQnK3dn68n6a23GyF2SzvUVioVXwoEFwKqXZIpm1QtMPBqEN5RdmrScSpRi
 LL8eCMS9Z6DcnL5Mcq+/dFwlOPpLvBpeG2EKT38SFe0x/0UyfQ4SCBHcU0sohKQfZ86iRJa+ww6
 ZdJRqsncFXQ11e7wRxInkJbyn6oh4956NDaJq6q3yf7O2vr1CBl2XTktgNiyX0Vjw1Uq/ooCHH2
 jA3FE+csvwi8MxBNRnMIqOUTznNCkkD3Hv3KO8E0eWWELjgPXGO3usFvxu88C6+BqG6zUbSPSp/
 aOH5CqdoXYsfWNOTv58KAMVLydxb2+fbLbcMJ8PDKfpihD7aas9UEZYfhaA+AORtr0kwsZlWt6D
 Ds1KIvNCz09jzsuduACpC0EJxreQlWPEJAOWapicrmPnMI4teH3HrjK8yK4NUczJ43CeeA2mE0K
 +Gj3UL0AwHr/h8TKM6g==
X-Proofpoint-GUID: 5Ve0SzmsIelcR_quLGto6bBwOkEQ0s3c
X-Authority-Analysis: v=2.4 cv=BPODalQG c=1 sm=1 tr=0 ts=6a59134e cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=riUHQTvyFV0r_oIck2EA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDE3NiBTYWx0ZWRfX5SN3Z9dige0X
 3dKmbxLICa1bX4S3cTA/fJRNFeCS/d5Ola29auuVgK5hDVIN8DRbcGDoGr4JZyz7XvVfeZkTNYs
 5VidHrLLy9p3zBIlhnFyveh4R4O3HWE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_06,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607160176

On 7/14/2026 2:09 PM, Christophe JAILLET wrote:
> 'struct ath12k_dp_arch_ops' is not modified in this driver.
> 
> Constifying this structure moves some data to a read-only section, so
> increases overall security, especially when the structure holds some
> function pointers.
> 
> On a x86_64, with allmodconfig, as an example:
> Before:
> ======
>     text	   data	    bss	    dec	    hex	filename
>     6318	   3384	      0	   9702	   25e6	drivers/net/wireless/ath/ath12k/wifi7/dp.o
> 
> After:
> =====
>     text	   data	    bss	    dec	    hex	filename
>     6478	   3224	      0	   9702	   25e6	drivers/net/wireless/ath/ath12k/wifi7/dp.o
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
