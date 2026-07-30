Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892AF3FBEB0
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785404159; cv=none; b=KfRLB+o8+TSfOnlsErBAQI5mcRRWiByK3L4hD1RqAc6AoFHDmfa/bPeAZg12J+lH2Xmf4FcEUv/QbIK2M1v3xrLerz0Ru9imyoPI74Xv2BxvGkpvRRjrp1BCfgNjEjX+QulXQwoaNOzF4t1MFKyxk6LPrY6AhhKVM+bOu1MghM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785404159; c=relaxed/simple;
	bh=onfFpSMnWjwfftBGyBnbh01n9qpUxRduWRMmHEedmrs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bhyz0ftsMUtZAuPXx4J0aIG4nn5I0zb+UA/wyluniJUBqvbURbda9Z+lOQWoP9fW5/l906ta1tA7mxirNEonlwdBNEExqAJm2frsVf8gyh7gtsXAGyYugqFUTapPNBWQoBX3ttAg+ftAf2+qgSgB5Mxg83F8XafM8c602XbDMDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c/be2Z6q; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KY0ippH1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c/be2Z6q";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KY0ippH1"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U9KjFq577461
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:35:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	G35MmUBxX/bkuMicDAituMu7OjFQoQv2kuSnE8AfJkk=; b=c/be2Z6qkivzga0a
	5ooVF5UBii1Xt4aESBwA23Ks6MvGE5lyUP4NV3Aeszrt15XmayB2p4lwX9SeJoky
	4DFSNfbEVJA7V/VQulx5dc2FCV8Q5WPjQaZM75hRsXD4LY+LxI8dLMW7uldmLBHH
	NMWF6IkSib/U2i7dUJJy0Fn5q8d9juQtd7O73p4vX6E4sjIyKBcEfKVigh0r2vu2
	v+6FsfSKk4gAiMUfzGKtIBeqd0SICcDeMuxwTpviUSIheKBAtnALUXQ3ET+9+DBi
	ciqWLvbwGs+oX+ykp/mUbGNVv2Xdb1Q7deZMGIG7v1vJy3vH8jlafi8CgDHcIHLY
	n/mK8A==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr3w602fc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:35:57 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84a251c2e3eso893946b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 02:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785404157; x=1786008957; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G35MmUBxX/bkuMicDAituMu7OjFQoQv2kuSnE8AfJkk=;
        b=KY0ippH1Kw9hZ39FkD5hsQDaeaIJlwGlBYvvKZfh3ompP8ZvcsOzHHc6/A1K7bDV/H
         Cvbm5NTFMo19K3vQhObe+Xp0h9vr4Np503tTFrJwY2wc0ttvAVrD9rDQPWSZBToXLkk7
         sl+P6ngrtbj0Nv06yZ4DwUGMoOykonrI6RdEW9luSCqMWNNoeNRr4rQAK9SaXVAA5gVo
         169djiC0mKE06pphBq4NXYP4NX0Tdwbm1aPfZ0hJXaRrgtq4vdFIFJ2kwxIKKAVfWOy1
         gvEGLmtSjmv2+XYCUMygIYVpjWUQA3kyrzskbKvpilLj6jMHrtfDxfLUsmobanbl1b5T
         7EDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785404157; x=1786008957;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G35MmUBxX/bkuMicDAituMu7OjFQoQv2kuSnE8AfJkk=;
        b=nVLIuO1oP7UQrDZzl3uz8YEw5AFaC+3tAJlbukF0vAP5Smlk3ts/ZBNgFtw0CvZBUl
         yJY2+i1leox6fIX6IjEBP9udDftETpeRAzSwMmUIEw7/ej8l/Y5GAR+8AROhxs4a1QPB
         lXtNKMFbh5534x4FcrV3g5hcoI31sVP7TM+LkZFaiNHs2IwmEkE9oAE6mhSJhygbz3Ml
         pJ2c5nZGqF9GRi92VIHcbvdpZ1K76qEMoPaQ2ww2bWBjuX+OPHlTegZZ5UvGWZc6ixdk
         2Me607nuhx+MuBdNx9HiPTtZ0MeRQeOgxf1pgDwgn6VbN7lr8yfsrcFey0NnI/FXrpUx
         kVuA==
X-Forwarded-Encrypted: i=1; AHgh+Rqf1kN3kUL6Hh9mQQqCDSEIvDdzg6ZdTlPqof2c2W7OWHe1iUR6OJ2KzCGKaT1khiVd1/qZImTJgLmCDSVgww==@vger.kernel.org
X-Gm-Message-State: AOJu0YxY4fjWdbigD82qpFV05FzWX230WGADJWm3zTuKukG2PYHu7+sy
	6ykxNd6y7eyjGCZOIbhiT+8/FSZceEiPFklL2XLOuodepeTo5VQF7ydjEI81EJPjxsds4FOQlB4
	2h6iKNvHzhyMwQcoIZU69UT57Xyq/V0+tgGnJjvn5BkZHTzfo3R5FD+KJg3o7Qy6e//pgFQ==
X-Gm-Gg: AR+sD11yXvpj2U2DiEUoIlowAWEGBpfWS6eotgMSjTqo90/oQdj/gStao/Z+T51rU4G
	S1TzwJaT250zTyzFBq5taxYcttLntELU1JHyPieVTF4/7pzEw5+QeK5huKkJVammT0zMhWREyNq
	A4BpUhKqQU3P1lOMWRGg4mlO6eH1BNCknSkKJ3tejFgUivzUrZt72brUbBjRL4T1T2pxFTejuyX
	04xRSg1TYD5yUMZrIzCXuv3HPC2lwlVe6wDt2Ggdd/Is++Yj015VJToGTX3l/23FYbYkE6EdDSD
	FkRb5LwYpaylSebMKQDRi8u7a6YpqEXaudlKyqiUnNJfcvDpvsBRokdntDTzjRXp6Nj1GhXV+Kx
	1+2+RfglLLx6okuyWqYs+H+o25/kny8p2PDOn9N9N
X-Received: by 2002:a05:6a20:6a1d:b0:3bf:aa54:4cbc with SMTP id adf61e73a8af0-3c9015ac62amr1505741637.26.1785404157140;
        Thu, 30 Jul 2026 02:35:57 -0700 (PDT)
X-Received: by 2002:a05:6a20:6a1d:b0:3bf:aa54:4cbc with SMTP id adf61e73a8af0-3c9015ac62amr1505718637.26.1785404156713;
        Thu, 30 Jul 2026 02:35:56 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b88e12sm19367836eec.11.2026.07.30.02.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 02:35:56 -0700 (PDT)
Message-ID: <c4185d14-fbec-4199-8618-8b468ca42118@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 15:05:51 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath11k: fix leak in
 ath11k_service_ready_ext_event()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260727-ath11k_service_ready_ext_event-memleak-v1-1-e8373d27bdd1@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260727-ath11k_service_ready_ext_event-memleak-v1-1-e8373d27bdd1@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA3MCBTYWx0ZWRfX6p+kgg7lKSaz
 LBzLZoSeDIP6YNR0hIkuzYQoFA7V03p/xM24pdyaNIDFIpE+juuCEPBBq7krnrUA40dxuNsmWqL
 I8DCB1YtD+sFJeoypNUNavqaVkq3zmU=
X-Authority-Analysis: v=2.4 cv=b9WCJNGx c=1 sm=1 tr=0 ts=6a6b1afd cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=zvkjD-uMKFsZz_jFwDYA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-GUID: F777FxHM3d1UMIymabx-apWRo57QEHWv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA3MCBTYWx0ZWRfXx0UzdNizI+Lc
 oswvfpQPcRR1zT09hDTJei9wb5dxEsf9Zelxkjbvzo5ho3cTE/wmqLj5+ql4B8jUibzkj0e/T6p
 PghkuAbjxY9co2tDu+sWKfW/2Wxrh2G5Wj8CfATKgND0vfb+/b+AbSdsRycN9bCJ0gLLSQRRDB4
 v7bkDnzRo0o5Y9vDVcDQc/T2QrQlj0ig43+bHUz1Z5SDCTa3IrKOGXzKH7aeMm4TjkiCOUuSx0X
 IGPd1j80gJ3Zm/QcluToHMtiXSPXCiSxVj84fMpKX2bZaNgAGs572xl/Km6H4bSpj2CB7lTsINN
 Uzswf1+fe0c4O1gyZGqCSt0NxO4kxuxewDqaI9F6ndVjlYZf4WsMN9eil60nLHCGz3qw9o8XPrX
 kytgsx0qiveZ99HCqjgsQXV9MeIUm2FjYguEJrExQwYEULPhkfg5pYGzBMPhggdPtcVgwlPvLYt
 0ZM5VTIPsexeQuEM5Lw==
X-Proofpoint-ORIG-GUID: F777FxHM3d1UMIymabx-apWRo57QEHWv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_02,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300070

On 7/28/2026 5:09 AM, Jeff Johnson wrote:
> Currently, during ath11k_service_ready_ext_event() processing,
> svc_rdy_ext.mac_phy_caps can be allocated during TLV parsing. This is a
> temporary allocation that is freed on the success path, but not on the
> error path. If parsing succeeds far enough to allocate mac_phy_caps and
> then fails on a later TLV, the allocation leaks. So free the allocation
> on the error path.
> 
> Compile tested only.
> 
> Fixes: 5b90fc760db5 ("ath11k: fix wmi service ready ext tlv parsing")
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
