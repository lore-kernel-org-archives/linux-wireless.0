Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D14434EEE5
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 15:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787152434; cv=none; b=ca/gOPYtAkyWuANJYF9xeQtXmHSJQDEu+65NzjBiCMAWhiMT6k+DXmN0uRdR1AHwXfHTuNVV4sS49i4n6LIYtIaxAqG7NHv4sq7We8PtpS9wqhOnbENQIaHUKTZ04OomuYW8XA4TabbLCTcHTr2GtvRD1VfCpShcGJ2SopVBmUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787152434; c=relaxed/simple;
	bh=vWMg2hCqGSnSAaXqT2UQMJMCn8y+R+7Gf0lPzT1vuK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OXPRy3jM61NMRc7QtLjzcPLzcQlOxVuOFbCAYk1dkW4JxKNDpfymlf61IQAzEBfHGuS/sZ4XeOzg3SJpQoIXhc7J88yirWU3LifD0efyCfLo3acc6M1ty3tpQtWlyKnMQECaVZi5LxCVZi7mp/4r+GX1HXO5/KeZPeMa1nz4zCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V7trA4Ys; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CQBr+/En; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V7trA4Ys";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CQBr+/En"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JF22LB538739
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 15:13:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Up1DH71ObPvN6KNXio6TFpjBxIEqcMT3urllRxgcTi4=; b=V7trA4Ys/FEYHxN1
	EV+p9zegQnb5Lr4chKElUW2QQ8jwQmjJAs3l+k6H9jakgqibaQgrxc702o7KjVN5
	2hyQxoGnTWFCnntyoOq9BM+/22BqaD4NhgnOVj2rJaL/pP4K6DQClB7kr/RfSyvG
	STgO0gyg1A8yv1Td4HRWS5GC/cGEXpr/pUuycgfPR47BNXGuv/Sgt2ILRx8WDFbx
	KmRIH0EsH/SHqwbhS7z3hUAzDo9GXfTn/t48VJczYPWxi6GPxOIOCXj1XYPn5VY5
	AOdFrxyv8UCuLh7V5URaP20a4Pgm6Zt+16YHSsZG8K/A04xPKRv8FwngTFihgfa8
	zx96AQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5es581vs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 15:13:51 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cce14a21faso17453325ad.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 08:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787152430; x=1787757230; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Up1DH71ObPvN6KNXio6TFpjBxIEqcMT3urllRxgcTi4=;
        b=CQBr+/EnepzN3KMQUOes9SclWRYM0+2o+FvzBsYZzDbv2WtvypxJ2crbOI00Dym6bJ
         2MUaZmVaIMILqTWaw30NJ5Jcmv7jHYo78B4zXzeuHJn3ZWtqaPP4I5D7QHzBkKU5iSjU
         T/nE6yn92e0npkLwR+HKywWomx65ProFFYSHrX5QydlgnVpxuG9YWWtwR6uLqni8W5gb
         AxTvlqnqQKh1K54ai0cV4U4gH1bmOKA9PwewpZ1CDZCWi1E49SX5VqXKcdyKYjaKJFK0
         WA3LLDrRE3iYJpJHSKaYup4aqCa8uDvknnVTtUSRRV2rNItxEWUAxWgcg23zOfVAa63h
         /lnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787152430; x=1787757230;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Up1DH71ObPvN6KNXio6TFpjBxIEqcMT3urllRxgcTi4=;
        b=H9G4a1Vu1ra5+Mujd8K6ddsgqcVfeBYP+wEz9kSGaSpXykjJZTmLPToxXWgNXRYy3G
         ubER1erRnc59hJ09JnV0i5EIGmaJI3eLr0W2Sx6XL3Ly4x8mmSfTPCIDq3uQLOfk6l16
         qLbJ+I+3elH7sqA4YNqE/6P2adbKEkMInojIePrBCKElD6Z36WEriTwD7jtGJPq4iTfW
         eAZib3KzbqCsjVn7CxQHMScLrZCfQFzh+h5v1hGglFo/9eBp2NHZ5QpwByLvhRxj/PSh
         HAE8wpIyG+A+ojmrMMXb1WwWJfkMzSFIs3j+vfa+thnGGM+EfqaO78ONAXmnumFznILF
         WNlA==
X-Gm-Message-State: AFuF++mFNaYb6lU6bFPkuprxWmjW8ZptGuMINf1rA5UzkUSAdJIJR5vr
	/Os5khu0Beg1xnl7+fgQyRt++msP3MO02DWmXlEjoG1fAefRI3uwDgLWO90pFcrzi/3i+v7xM0t
	9JvbG6ijrVNAIkxudFnkyfx5BYk0dylFusMpUhQx/vWpliazLQpBoC6NJXIaFMcrhA7heGg==
X-Gm-Gg: AR+sD13jGvx55NM2GEovPUXQLs8EpqyY5aAbSd1Lb1JFpMHyF604zC6PmqBKzDeUYPU
	kuGPdt0GVFT/X2gfcTeW7vs1OHg+CVrx7lYhGcSzUXW1VYA4qSUaDq0hiWM9lpv6QQiWCs0HFPN
	aTmA1vI/l2PPyLxpR7bPRCqAvZxIjvUkF/wGWQ38s/gNRKlgVsYekjUj6We1V0HJ5TSE8nitwlm
	Ouw0LKl0JMmiIn9iwVY0FNm/DW5p4Cl6Z9GM4FVnI4KTBy/SnhozjK3OIn4ZNSYN2GXIjByyrtg
	E55nwivDnV8kAjdhTSqF+ifnAY88w7oveUfkK6PQCyy4q0sWhu4q5Dmjr95k5tuQ3B94deiJBEy
	6Env8tBd9SbSo9XUybZUcuIUA7Ujr8aa5LD2CvBiXkWVc
X-Received: by 2002:a17:902:f64c:b0:2c6:8d95:fd7e with SMTP id d9443c01a7336-2d5fc8fae7dmr70485945ad.6.1787152430245;
        Wed, 19 Aug 2026 08:13:50 -0700 (PDT)
X-Received: by 2002:a17:902:f64c:b0:2c6:8d95:fd7e with SMTP id d9443c01a7336-2d5fc8fae7dmr70485145ad.6.1787152429691;
        Wed, 19 Aug 2026 08:13:49 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bef77bfcsm7089834eec.9.2026.08.19.08.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 08:13:49 -0700 (PDT)
Message-ID: <626c5a99-9327-4ea0-a504-9f55b26db7d2@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 20:43:43 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: Fix IRQ cleanup on PCI IRQ
 configuration failure
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20260819110215.2485514-1-aaradhana.sahu@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260819110215.2485514-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: kfIb_mI3MayGTEfi35MCn_0PSldqo9Ir
X-Proofpoint-GUID: kfIb_mI3MayGTEfi35MCn_0PSldqo9Ir
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDExOCBTYWx0ZWRfX0sSw1ETcmCST
 xwsQDqVy8rKbfPb4Ac0gZwgUphNh1OZJLjCWLj2sdDCm9blocjSEAtAD12Ti2JGQq6AUEeGLioZ
 d7WnqFbA4a0zX+TObB0usTcMmA0Hzac=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDExOCBTYWx0ZWRfX7wpD5b5XsLi2
 GH7TSE8BZ2T8sxoen7S0LzBUgGUIAhbTnoBRramXu8lMeYzOefiUUAvYRyM31UWkLXchM2vNCtV
 urTHkd5AQK1N2/8WIl3GCW0rdHCgsv3wj7jLd55iFYYy9kWBqUlyUdOMX/bIQEKi3VKsILa9z4j
 6HQSISAwdc0rONvzeysarSXTMDOsJOoNbHc8bM4rbsfhUzAJeevfRXAbO3SnGHB0USLK/mGKXCw
 Xz6DETxDNc1y7tyOnX3saiJgZcFY+Pjk/rMTGp9VSnjGd8xixNAL5npINh5EEDU/bIt2UVs3r29
 09nZzs9/ObB2uL+K1o0sFNVB6xj5zIS4cmLLxIXGr2QA2Uz0rAJoDvSzFPBF2qvgb87vO/Cjepf
 rWPvZqYDP51aDVEVVZMvP7vmoIWgG3G4JO7JVGFWY23nxORbkaNG1hsvt7r5Y2TksWO5Ccd3NvL
 pl7DhFi1Ej8wzIkiXug==
X-Authority-Analysis: v=2.4 cv=Oc+oyBTY c=1 sm=1 tr=0 ts=6a85c82f cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=JJR71pI42961Z5K6J_YA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_04,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608190118

On 8/19/2026 4:32 PM, Aaradhana Sahu wrote:
> Free partially allocated IRQ resources when PCI IRQ configuration fails.
> 
> The first patch frees previously requested CE IRQs if CE IRQ configuration
> fails.
> 
> The second patch frees previously requested external IRQs, stores the IRQ
> number only after request_irq() succeeds, and cleans up allocated
> resources on failure.
> 
> ---
> v2:
>    -Used ath12k_pci_free_ce_irq() in the external IRQ config failure path.
> ---
> 
> Aaradhana Sahu (2):
>    wifi: ath12k: Free allocated CE IRQs on request_irq() failure
>    wifi: ath12k: Free allocated external IRQs on request_irq() failure
> 
>   drivers/net/wireless/ath/ath12k/pci.c | 55 ++++++++++++++++-----------
>   1 file changed, 32 insertions(+), 23 deletions(-)
> 
> 
> base-commit: e07447e654476262558bee570f4cf456e2b32565

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
