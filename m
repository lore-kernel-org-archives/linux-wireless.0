Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E75385D91
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 01:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789695479; cv=none; b=qjwpji/bF4XzK9DE7WIWjJW9KAq3SLSbQvry+jQt4E8y3483bFsQoAbBjK+4y2cGMfhVqabjObkh2a+SgJKbpaPorUSLxYRnVjgUaijI9jpRWiR1KVmdl+4/HePtOzd5acFutCWZEbARCfbSEoekhi4MWVlU8eE7Noz/VArOm3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789695479; c=relaxed/simple;
	bh=9ZG234MIhyUXnFuyTHJeFMAzudGi5s2QQcIoK/SBIWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g66AEJx1zpSv/2/21LuyXUsAj00D3MmIUIKDcrqjUOMilpiEcxRBYnkzYnhV7AC7Mrx+PzgzE/cTAYj7OJneIvDCar/9Higusm4HgHk3oJhKjigLn4wPx2Ec+SG2d5yPPpSw/CyYgVP8hFcSJqvBkdnQqD8p0S0Ns6EvU+TCYFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GfJbG0/J; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZvX0ainN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GfJbG0/J";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZvX0ainN"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I03B6o144521
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 01:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	i4iJs6VxQgQlwW5ktJb9eYE+rPDMrUQn6RUi2NUqv3E=; b=GfJbG0/JuPAW/Xb+
	pCWAl9vnGxpGoUIg+DBak0FW+INiArcIp+8o6jA9q0+fbzKhoD5mLsAlVyGL5ie2
	IWgMCZDu1nPetNeAS3CtLix6L/kljpVTyi6V+gSMjNf0m0iYLvwz12KNu7/9PZ9d
	v7/rl8evI22PWdcWPlyVgA0y+6Ix+/6ZT7bCtWZOdiJPdUSFuFTJO/+6QgDUtmzc
	l8R2JYM2H2b1FdCywolQ+lQqSOVtDyU96vo2d3SR9fGb7XXV7ovOrPFo/yKZdF5o
	VbvJ9gWK1SDnLhuamHCuKBqGGZXzqHrvceAxjwp9cwyqeAV0F10/BelPCyYuwgHs
	Ew6xMw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4grtdpr9fp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 01:37:56 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39deda201bcso499504a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 18:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789695476; x=1790300276; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i4iJs6VxQgQlwW5ktJb9eYE+rPDMrUQn6RUi2NUqv3E=;
        b=ZvX0ainN3XB4UFnJS7SKkymsmKn6lGBb7erGHauDLI+9aoc3IYd1q+zCwb0tTckG+S
         IeCKuLwN/YPdU1Lr/fnIFFHEdTMYKg7E3bNF/VC+9CN9LQIFDQga4gTYg7MdICchNj1V
         79JxDXR09+AT8X2EHTleluMH9MGcLZOF6DUnd5Kuc0CIn5ritV5aFOWGMPthI0k8ii85
         H+eF9qGDh4hoEDT2D18Rhhxvf00CtQRezlJ078/gjGhTi8lvaI419VRpMInH6Sf0GXWa
         UvCjeKi92lUg8DiQoTFKXwaGwc/duRenj3iwS3IkzYfGNjGwIcN24YVftChNsxIhtQhG
         Tx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789695476; x=1790300276;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i4iJs6VxQgQlwW5ktJb9eYE+rPDMrUQn6RUi2NUqv3E=;
        b=p4UvOgt5SFOJHW8bAstwVV9NEm7LDNp+CF2NZZEp2k27bBlABEiQD1Ixgh7Payq2i5
         +z32q9WGOQS8lKSdjzqVDZu5KJ6+hZSvswVcJ1im/Bdx9lot0SV1i3No5qO9l1MZ0d5D
         Wjkz7+yOHC9BFBbA6C58EuIfo19PDoTtaizSxRVWzeXGiQxey0MeMiOWHFRbInFvLe0K
         KcpZmx9edhNjbbm8CGVAbYUMUFlEyaFEGZ/x9bAZmpGfA44e2TDAYAgjBVTzAtXedeCG
         u/tDZLxZhx2KDjKTNsTGpZwlyBhk8ULhG/aROqOhsmZ7HQyDCbrcGQkg7zZ/l0khoUlz
         v4Jg==
X-Gm-Message-State: AFuF++ltxj5odSmecrz7pf13B9FN/RLzMIxDntCBV+apqckbOsKeBldP
	xGgSjA4lZhguCy3s43xukAFmGtZqKJXlZ7xgZzQwHJFEWGgWrC9OGIFPjGXKIS2lmnS+dItb/OF
	DyM5BEhrOJ/Z9bOmvkMv9ly6uPGCSbMP4K8vm04J/LdwqfFqu1tBi1LZtECZQHAU/MWtgJg==
X-Gm-Gg: AYBFou0e54nJ0yqK0RVqrQHU8lcE+cytLODac6vRwgRc4lGSxOlWKH2atxjT8Xl9BPj
	yTP7/i2GDU22d8/bS7DrbX1NCUPLquhB8QegKUuu57BBEKr3p2gxbEuvsENNmgOSySwITdJpseD
	Hf+KCHwIjv0igz07OB5dauqKU+Um1Ksa8yxcCKzGkG8mMRzw+O7VcsiAlB94JlXj57NNgHBQiu2
	drd1fJy3OXtVoubHtZCppUOtZ1X53WTjU3WlmU8CpPdtkNt07D+JMkPpOIrhNwdkjrPcfYVDSql
	v/wMd/jGRbOKSC1HcXZ4iyUdcjPKeIQ0jG5r+2Mlx7UKkqQ0IlCc/BdBOjsiAeEs+JUtAsTXF+S
	Lu761fEu7JM79B2EmVqjFMTZGcRy0dIjVcaHvc7T1WZyYEByEHEteNwtTBi+NvTyg8YDVUgHK
X-Received: by 2002:a17:90b:2681:b0:39d:ee20:1e3b with SMTP id 98e67ed59e1d1-39e54f0e40bmr1974146a91.23.1789695476112;
        Thu, 17 Sep 2026 18:37:56 -0700 (PDT)
X-Received: by 2002:a17:90b:2681:b0:39d:ee20:1e3b with SMTP id 98e67ed59e1d1-39e54f0e40bmr1974102a91.23.1789695475660;
        Thu, 17 Sep 2026 18:37:55 -0700 (PDT)
Received: from [10.133.33.84] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3617443asm9284630a91.9.2026.09.17.18.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 18:37:55 -0700 (PDT)
Message-ID: <91f72bf8-de7c-4ece-bfcd-286da649bc28@oss.qualcomm.com>
Date: Fri, 18 Sep 2026 09:37:55 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/6] wifi: ath12k: fix monitor RX buffer
 lifecycle issues
To: Kang Yang <kang.yang@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDAxOCBTYWx0ZWRfXyMC6xhHuXGha
 fDlkx/p2Km7rv+tqDl6xWzQEq1dWxmYtwRaIuUULteuyfU9dSpxQdkAFDNQbg0dhv7+Bd0mEl5f
 t/p7j27uvpYkQZJuQpjv3lNASO37mXU9/OWV1hgxfgxa+Z38JpHfhkLQO9KejAa3mLeSj4atoEC
 3wf1KYKflNO1wXVJAoiZyvSAbxO0wWpL9zLYKIiKGwrEnMf8AmuU8RK/WB38LHX8M4PPsfIwDRa
 v9KmxxkNnDUdrA2SAGRuGn33SFc6cRwwkmqNYPPYt0U4FKthwyerJoVVNOC2W+PyIl7w/+RDThs
 kYpETXFNY7pGH38IdAUwWuvcdzyr1yAQwKCMB2TcW16y102y7/pd6l80QlSXzoUHCPXTzDFdkf1
 /yeG49pSNpN8wAt0+uX5jFEpw6LmOFN186dV2QZV/IjQAmUsyYFrhYj+8po9tARdZ24ROzQGs93
 c8wFyw9NQstkxRRT1LA==
X-Authority-Analysis: v=2.4 cv=N+e8hG9B c=1 sm=1 tr=0 ts=6aac95f4 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=jeZ2dEGWif2cJ8v1hNMA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDAxOCBTYWx0ZWRfX7G23JtuFPX/R
 3aZfG3weCDU3AstGeNXGdxAWGbv6n9iPzpXrXCVoMD/g/e/6j8cpkwiccZvMa60uMYUUZl9O6tR
 KwAqlHZIDg+AtzdavhB4vmuXiLyPoRo=
X-Proofpoint-ORIG-GUID: FgGoMiIA2tbhAkfdXxeDrA0zO2yDV_IW
X-Proofpoint-GUID: FgGoMiIA2tbhAkfdXxeDrA0zO2yDV_IW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_05,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 spamscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180018



On 9/16/2026 2:03 PM, Kang Yang wrote:
> This series fixes several monitor RX buffer management bugs in the
> monitor destination path.
> 
> The fixes address leaked skb buffers, stale monitor descriptor state,
> object lifetime issues, and incorrect DMA unmap handling observed in
> various error and corner cases.
> 
> Kang Yang (6):
>   wifi: ath12k: fix skb leak on paddr mismatch in wifi7 mon RX pop
>   wifi: ath12k: free pending MSDUs on duplicate mon link descriptor
>   wifi: ath12k: fix stale tail_msdu pointer returned from mpdu_pop
>   wifi: ath12k: place dp_mon_mpdu on stack in mon dst reap loop
>   wifi: ath12k: fix skb leak on monitor PPDU ID wraparound
>   wifi: ath12k: avoid double DMA unmap of held monitor RX buffers
> 
>  drivers/net/wireless/ath/ath12k/dp.c          |  9 +++----
>  drivers/net/wireless/ath/ath12k/dp_mon.c      | 15 ++++++------
>  drivers/net/wireless/ath/ath12k/dp_mon.h      |  2 +-
>  .../net/wireless/ath/ath12k/wifi7/dp_mon.c    | 24 +++++++++----------
>  4 files changed, 24 insertions(+), 26 deletions(-)
> 
> 
> base-commit: c3bace8584ca707e34ba837f65c2e9d566af4c2c

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

