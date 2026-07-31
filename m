Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC8F3ABD8F
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 07:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785483042; cv=none; b=HhQBvSFirn7pRJCO9RscWihZ+Soq9dszumzKBrzFu+WFOcOVEUNM8E9CJzkcNYgqoousIbuKy6jUp5cttdSaKUQoMINCnv90BkNDI/w/6BZm5qPkAR7RWNxtIsDprAt91HYLkZ80MY8XUyp9NoyrSgIXjFya5ESk+9YXkHviVF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785483042; c=relaxed/simple;
	bh=ws230jDp6Le67PM370HntSHPb6BWySaE7hpPdaRTbpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lx+cpJNnq2tUQI2ZrV3kexKhGgxI1+tFrpILWbOUjO9P6RSSv+Ki6y4uChpHJbgIi+iangFK0ozG2gNV0lGI+7ztINJZWem64vrc+G9E8yZQRICew0mF3VQEehMi+NRtb8HkrJQRquyUpeHuRWCufGqDPNGr9h/zp67ZvtSRwAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=i0qsr+6N; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QY1KkUoV; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="i0qsr+6N";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QY1KkUoV"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V67FDQ2960557
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 07:30:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jukmAepEItxoJN8i97/lVV56EabbQ+hdagvD7H46HpA=; b=i0qsr+6NL1EB7Hsy
	/zCmShLgoc3aq6iwEs8yk0f05xuqDds3rsYebsILRNXDIqZLKe004GSvhfnHo4PD
	zKElQ0MoQnWSkA7YTW6lXeXzsPekQJbLEanFL64L/Kz3FwBgP0gpIAifs7xJF7/Q
	H7tKFKQbROGft1mZ+YKKIPXfUbCbigb1O1W595B2lgnmA37w+V6b6e9EKQGl/Wf5
	sx8JEyDYMtttqSc/UMdY2I2Z4D8p6hpIdfLGcZ3IvYYAvT/Sj3GLQ8OpUfUXOekQ
	fvsaB0lTY6EzTFtcB0M8jFvunGg5gJpCA/LM/VUM2zYpATpxeUwU+jOHxmmYRR3D
	T/BphA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frp5kg9jn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 07:30:40 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc88e22f92so13889515ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 00:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785483040; x=1786087840; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jukmAepEItxoJN8i97/lVV56EabbQ+hdagvD7H46HpA=;
        b=QY1KkUoVdBIjGLvZ1GnkdWdqh4CzMO6LALT/5MCslVzbLMpJn9BPOx1kIBMEokvlXA
         G3c0C6K3AIDBgowSaFttH3Ls0nDLpbNyK+jyzEQPIwM89fXDB+N3E7vcvDIUdS9VL86+
         XOzdXmpanUx5Jka9Fny9IxthOXwF8paaaTvW+8e/DGIondNsxC9JoF/p3oPBXebTXekf
         +d3sZ0C+AgTm+VabkXudWtpSA45hg1u1i6loJbGCU6/lwUqgsjrAVCnXepxF1pevMclE
         hCUq0jIVuRWvoWrYGAZtUwZvVRSt8is9NfAHLO4U5s3iIw60vE3LGhdpurPJ7De1P+O4
         9Rkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785483040; x=1786087840;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jukmAepEItxoJN8i97/lVV56EabbQ+hdagvD7H46HpA=;
        b=EiKvUeOFZIWCUFysbp9ZXpRQbn79uXgTQNjVIYlecFVuZuKd26HNdsMdEFox2h2i0N
         Wd3z0JNTd7W0Ck6+/EVuCdJTFYTx88V5erNFHc2OT9GOgm9/T67dl7bgxBNMPYQfzA63
         AovHd2OGozyUe7jpgDezIFiB0GGWy2r8bAXWcEWAhjNcgKebGdxjckT9j+9V1SNvUemP
         h+KPXNIzxJDGfMivq9NwGXVBpDC7x3UsSW5QhLoLykuO2JcAaNu1GuNke8ru/vGEjFsq
         BAfAevphsKs6kR+CmJPHxPS9XaK5dhk0dw/LEK9QfQwsaPlN4hMyBEvY4wRhaBCJivRh
         TAfw==
X-Gm-Message-State: AOJu0YyKiApMZaLHk6uRrjECa5vCbZ76pauypR5UufgWEd8AESg7+Cz0
	YmMQSc8m3fsGerVag3TFdj5FmFISwb6d/K6WF67pmoUIgTt4b+68eWH3mjvPZd738RbQ/JygZR2
	XU25LyyRLzgTTAwzYtLsAAQ/eoeb+ijzeYOgnPjBzT3nCo5R3tbUbTcpXgm2vQWmjBDcD/A==
X-Gm-Gg: AR+sD10C4NOh5riOKeOCNjoGFEzX1F9sHqobyXLO4+mmVhUj8+x/GmHPF/iUh8qGtd7
	xZBUWJ5ZG7QBFtg2yb6vm2axtJV+cAtOgz/OT6Nt9F3MNNUVJWGlgkEFXGu5DACM+J/z016x4ef
	YxGknx8teuVRsZarqYX3KtBcndoWfPgKLxw/z2v77wQVJ4wyGJ+RJ6Ez0HzC/QDF82FLJkyk09N
	YB0UKjw7h3D1GMYI1WbXwqd8zgJy+ig40beD7J+kYM3pm7H+Zd1w+YGcuUWt4h0IWlmbUZX0dVj
	QK+rsArsYthX5Ro7X9iO9O5pQGbSPCMnBUT1K14mM1DF56MvE+69tdPaFkXrUAf+SmGD2HTfpp4
	h6FZcLt8iQefjUhOwEzMeBp2aDMxH49DjsaOXgSeLdreKYhyZ3hHxVcGLFejo4HQGdt/P2kUqbA
	==
X-Received: by 2002:a17:902:f78c:b0:2cc:d807:369c with SMTP id d9443c01a7336-2d046ef5899mr10209545ad.45.1785483039607;
        Fri, 31 Jul 2026 00:30:39 -0700 (PDT)
X-Received: by 2002:a17:902:f78c:b0:2cc:d807:369c with SMTP id d9443c01a7336-2d046ef5899mr10209155ad.45.1785483039005;
        Fri, 31 Jul 2026 00:30:39 -0700 (PDT)
Received: from [10.133.33.123] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae60139sm1872645ad.29.2026.07.31.00.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 00:30:38 -0700 (PDT)
Message-ID: <e7aa133a-0d06-48f6-90e0-1255972bd462@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 15:30:33 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath11k: Fix possible memory leak in
 ath11k_dp_srng_setup()
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>, jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260727105532.118164-1-nihaal@cse.iitm.ac.in>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260727105532.118164-1-nihaal@cse.iitm.ac.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA1MiBTYWx0ZWRfX6mWnRC8acLw4
 nYfC4An4PWYVG56NLDthj1h60G3hYJP5iyJa9Pwav24s2Bi/1Fj6JmzYp9xhGUg2GKD1YEWaJgx
 c80CYx1gfn26vbBpZSrfmEmRpfQKTjo=
X-Proofpoint-GUID: xN0eIwIpU3Il9AKJmOCkLF5anxg82cGg
X-Proofpoint-ORIG-GUID: xN0eIwIpU3Il9AKJmOCkLF5anxg82cGg
X-Authority-Analysis: v=2.4 cv=c/Obhx9l c=1 sm=1 tr=0 ts=6a6c4f20 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=45AEqwlmaGsIJYzuV-UA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA1MiBTYWx0ZWRfX0XHI0fTgSlzL
 Y4nEdoAFGecufycFs6BdyKige3G2NAXmI91vDROa5mJ5CJpF8z2oPo/7gNhSRWufezuvvDI6tct
 j4j5ysE0D2dP8ckW3oIaAxPmsxZjvEvU0OfyQUNkUmdQWGC7mfUb4+0bcF/ZaQl3ppDVz/oSIdP
 Lvf67jFxAsPYu9opGRWkTb5BbNAW0TrnPHUROV7dLUqzHfuftcowRblK6PKykyK2H6gLWM4vTGy
 dD/d0i51CQXt5aNQnocu4YYf7p4dgvCsmLZo2JD9yARRRCglSlUoNye5YreLvxp62xcJNuglFOS
 +JIv+bNyfsYKm2TDmA7IFfgK2qLB+ML5U6NKXial2mBecuxUsCXMLiAthYDQKVeBlXqObJTx3R4
 b56E/J5sEMd+oQocWLsOUJs271jB9tLkzHQKwsefP1Bv7LIkVkFQpJtMtb+Z7Dh5p71l1Ph3VNs
 kOh0bYrOiJjnylJb3ag==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607310052



On 7/27/2026 6:55 PM, Abdun Nihaal wrote:
> In ath11k_dp_srng_setup(), the memory allocated for
> ring->vaddr_unaligned is not freed when ath11k_hal_srng_setup() fails.
> Fix that by calling ath11k_dp_srng_cleanup() in that error path.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Cc: stable@vger.kernel.org
> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
> ---
> Compile tested only. Issue found using static analysis.

this info is useful hence can be put in commit mesage

> 
>  drivers/net/wireless/ath/ath11k/dp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
> index f389b97acbdd..c3a16da1cba7 100644
> --- a/drivers/net/wireless/ath/ath11k/dp.c
> +++ b/drivers/net/wireless/ath/ath11k/dp.c
> @@ -324,6 +324,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
>  
>  	ret = ath11k_hal_srng_setup(ab, type, ring_num, mac_id, &params);
>  	if (ret < 0) {
> +		ath11k_dp_srng_cleanup(ab, ring);
>  		ath11k_warn(ab, "failed to setup srng: %d ring_id %d\n",
>  			    ret, ring_num);
>  		return ret;

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
