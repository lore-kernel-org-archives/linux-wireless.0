Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44472F3621
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 19:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785267867; cv=none; b=J2g1XRBsj0r8b701nN2OGeyAKbvtxOB3fy+vzLkSiZMZE3P4/r8s3UeJTWox94DHTRW7okBLDc6RpR+eFlUkchtq/MU8gmSMe4tYNMkqRp/m6njnw10fs72eYKtfZKnykdyC20G6rpLYee1YcY1zlIaWTRR/6Wujo3knUv+noR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785267867; c=relaxed/simple;
	bh=/vEqmXEmT9E+qPdDPV3pVewlBR909zkS9pFdqGUTrMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pohJu1I3LWJpvjdf7QdT0+Z3Nc90qyHbu72VFytVofqzS59iDka2nVC6+toN77uWd61hggLDAeLkP8csGxQUDST6P03fwtsbL8KMEsC5Fz8Lo1x5k3sl/cwQcemryRBdBA646B4t+zV6GX8LAOQLewh6VSL7PumBIQzoUgH3hEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=D5dSFC9y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HYsnowut; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="D5dSFC9y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HYsnowut"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SICBWZ3579091
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 19:44:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XPvePTDHKcOsP9LlpMw4Cj7J+B5jRL4roPsl2f0SPTg=; b=D5dSFC9yGUnYSSEi
	rJ8Hj+SyIq5ogItCOaW0zhYrcdgAejSPP3cnX3KYgO36oIA3Id9Vr+WDlm/MJSov
	v0SvjVIsRQYiIi9ZMAvn++yMsJVYn5jLGCvpLLs4wXH5AgEz86N4eB4LDIKdUErp
	XpmSUC4OSOXtER5oKwSsnByTdmD76WdrmnzrnjsX1fDktkK9NsrQYTGSjEDB/WQC
	LK/cXVZY1xBzCwmAMVCzeNr3QDkQc/iFCo6KCScEXtUjoMykdwa4nYF5VPZFqkbp
	dfVO3aTUGXm4MCbriN2wpbZhEQmpFM+If3kPN2pwOnqTr8ujIhc+6roZPgwdVDXF
	4pDnng==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpuygafk2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 19:44:24 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84c4cd31b51so1575835b3a.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 12:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785267864; x=1785872664; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XPvePTDHKcOsP9LlpMw4Cj7J+B5jRL4roPsl2f0SPTg=;
        b=HYsnowutm+7Wu6OCjFo0rk6UomvH1hqTeHDeGRiI1idSndKMpki2panupF6gtEplr9
         TJeabH46dvLMoQyCeBfXGdqvtKD9/PoexhS2Cuzyp3t3GZ/EJ5gNTtMyylczNU0fiE2W
         40vMMlpLIVfpsw8FPdyus5MI3G5nvISbd9IWXgEWaLfljjptveibFgFyM6qpEtcyJjOj
         DD/1h6fLoqFvw48ujQzk39yq2EyHisq3F6f76CJo13l2fqj0u4IicPkNM3ItH3c+1p2p
         OmqMTld1H05/AiN1VqttIRTG1hI9vO+9lJXZRqGXbzhHxAWLHOcO4IELIa8unhrOIGoN
         lNmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785267864; x=1785872664;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XPvePTDHKcOsP9LlpMw4Cj7J+B5jRL4roPsl2f0SPTg=;
        b=I+zsCY8uAO6IatCceI7j+Vc5kdDZLX1+G9pM1S/2l4s3v6PQnM+K3wJ44n9cI4GRlI
         MaXxgaQlG+EwJOfWc6WjuEb8Wu6UTn/kGbKsMp29EJSQRzweFpkcL6e4dTLDC58j+qeg
         MUByNToZJxA8yuC8xiNfKQ/20jkM+gpn1uordjRYdOTyhwp/q1AqKY/ZckHwLrvXwblB
         GClpALJ5rsv0BIO1Po3ohtAShl2kogtP9RYh+yf+4sih7kRTHhlnrvSogb/uW9UPMcv7
         pcQxPalwfOjGXTxLw0GPdMDJNnlavV8xKzxlf5fnzbbonBC+eoXYBhv33lCuw0hQPMgY
         vlZA==
X-Gm-Message-State: AOJu0YypgL/6BPT1BvM7mHfRZ0v5tSWEvBSlM4hM0gqLECf/qotTb4vf
	+jLpjAkTm6LDOHLuNsL9Eyvtzde6L6hj5Di2TxlxmXFaa0ewWZI2LPwmATLTBFIM8kMC8ViQuGl
	0azK7/04283JC3ns3ZPX0zu/zFiQ/5vMjo55V5VrUMrhistGFZTvHBqdFTltRor97VevTpg==
X-Gm-Gg: AR+sD11DND85EMlC9IrbSlQfgyVC/Jl8ZdvozRWpHrKplwBS2INiloNX/EGjbHXdeQr
	Kjnmr9h2BkcnBMKbcvQtzwco8WTuXrmfXkKL2T/ioCvJhhxr3E4/XtlB9KAu847XlRQ5h/qUJVc
	vEs1qwBfYWt4rrnl7rhxKtCz1FXrCS9aO9hORnr6Bjk4uGFUbEpKdjuucgiPL5Hc1WnRLZNZ7jf
	LtjGsyqZIbD9Q4EGTW5ZX45ctgJqmKsAcnPjercScS4GUivRy8O+Y02jUEy4Q5/nbC/JgbvHPOR
	lPAbAHgkLIAwHit6pNLKPYCOvIPJaQqysR7danDaG2PLxDu5uowd3s6rv2oxthAQZk0pGo4nBxm
	RsPm7GpXMF7hEQfCkZ1P8s5P6Rw4xQaVpK4Q5HmZHBqZN
X-Received: by 2002:a05:6a20:20c3:b0:3c3:6c34:f9ea with SMTP id adf61e73a8af0-3c8ba641f19mr4413713637.39.1785267863748;
        Tue, 28 Jul 2026 12:44:23 -0700 (PDT)
X-Received: by 2002:a05:6a20:20c3:b0:3c3:6c34:f9ea with SMTP id adf61e73a8af0-3c8ba641f19mr4413687637.39.1785267863352;
        Tue, 28 Jul 2026 12:44:23 -0700 (PDT)
Received: from [192.168.11.107] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7265010esm1596288c88.6.2026.07.28.12.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 12:44:22 -0700 (PDT)
Message-ID: <103fa619-0164-4600-bb2d-3339540a61ae@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 01:14:19 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: add MultiPD support for AHB
 platforms
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: RfiPnYWM34uAvnDj1GuqXlIASMlJ-11S
X-Proofpoint-ORIG-GUID: RfiPnYWM34uAvnDj1GuqXlIASMlJ-11S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDE2OSBTYWx0ZWRfXwHGhC4D7uzFv
 v3g/sRp/LeptR2c4CNfbM8qmnrACIS77A2NTgzSt6FVbYutGbYWyYNiRy6TT3Gkc0/Ynj8zkyl1
 6QVSWwrmmCBccL1ADlns+I5V0HyU4sIDfAUt9ethduJ9YVB9NmvJGaGVAceZi9xLzT1sEeIKxdz
 5X5MX1+KmUocdZBtkHTtM5+enY0FCBL0fw3VCZ3phm1CLSGNWqysKuIj2inMikON+2/8EdUPRqO
 a3bg8b0jod5j6UIn4s66o0nGDYc5+qyEFn7zQM2TuomyNzMxi3w/ToV09rqQ/cEfvi+ICX0JH4k
 +fCj5llI9jAE/4nG5lyxfBkFel2higmcWTzqEB4+UGGIdfB/eJD2yGmOl5paowXqjZQme9OKK/k
 +QdocZHK6BLltklcPSmJxBWyIdP1RVKBvFqr5B0CYsN7HoSV5lC1CncFVfHsD7uhHnlJnEyxf1w
 t96g/E9VbhxPkNRIZxg==
X-Authority-Analysis: v=2.4 cv=aoWCzyZV c=1 sm=1 tr=0 ts=6a690698 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=1E4GKdcwGqwKInFrMcEA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDE2OSBTYWx0ZWRfX7PksPW8b27gu
 Ho3YltOFBYSP4n/L74IN+AGpw6uLi0/Btg6Rburdi1vsDsbupqgucGVFmik8qdFqkw8jAE7WrGy
 rTEEqGUYCIkc8TfObeiBbTZKLYNWQZ0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_05,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280169

On 7/21/2026 12:20 PM, Aaradhana Sahu wrote:
> On AHB-based MultiPD platforms, multiple UserPDs can share a common
> RootPD. Each UserPD requires its own firmware image and PASID, while
> RootPD resources and services are shared across all UserPDs.
> Add the required infrastructure in ath12k AHB to support MultiPD
> platforms.
> 
> The first patch introduces a platform descriptor to keep
> platform-specific configuration in one place and provide userPD
> mapping support.
> 
> The second patch moves RootPD-related information into a shared
> structure so RootPD operations such as boot and notifier registration
> are performed only once and remain active while any UserPD is still
> running.
> 
> Aaradhana Sahu (2):
>    wifi: ath12k: add AHB platform descriptor support
>    wifi: ath12k: Share RootPD state across UserPDs to avoid duplicate
>      operations
> 
>   drivers/net/wireless/ath/ath12k/ahb.c       | 209 ++++++++++++++++----
>   drivers/net/wireless/ath/ath12k/ahb.h       |  34 +++-
>   drivers/net/wireless/ath/ath12k/hw.h        |   1 -
>   drivers/net/wireless/ath/ath12k/wifi7/ahb.c |  90 +++++++--
>   4 files changed, 271 insertions(+), 63 deletions(-)
> 
> 
> base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
