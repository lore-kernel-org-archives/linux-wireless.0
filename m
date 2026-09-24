Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3E73246F4
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236114; cv=none; b=H8ooCknSrzxAqS0MZHRdPH2Nf4cE426BEKW58JLOqM/imLdPnKvopJhmhb0X9MZRObgEOEGwDyhkonJ5RVlG2IUntpIdEPbRvBSC88oCXp1qSyQz998xVL/AwiIRsY26Hdiey0Sqhr8sV8pzGPwsr9q92OOhcv6ZnhMnomi6+O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236114; c=relaxed/simple;
	bh=Dd7RNohOwDDuSLouPBUZSo0fv39D9E98cUE331RZxYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pKcu/Ezc6PyBhLHHDSCUPn9C2hHekPOS1yC++8ArhJ8CCOsDIq2C8s2vLA1QQeFkAr0b10J+Hq4QQYiJe37vrRUMBsjLA2KtNSI06zie3JUNN0OA9sl8qQgeKYxN2NZNbba6ZJIEX1eaxyC9hL2rLET0SsuwTJ0Nl/nIUYeWgyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PeZKLpD6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AbLr3vvf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PeZKLpD6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AbLr3vvf"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5eMbP1278341
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:48:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EaIKrQHZiqFFd9rA8t4qGOJUScvKNGixCmmrdQXDnG0=; b=PeZKLpD67JjgLuyP
	ezx+uHI/TOvIE0hoQ1tCdyQAWpJLjN0y9YJk2R/GBNvDLt87wnkVOSvnpmoTYO83
	S/U3QUPUsKvyZyV1m/CyJT++uTxISIo+cg3aZ7nhESOhsrZEOyF+/U0DnGxuAYwk
	O9YoCFbRG4qNFNplj869qZWGjjSXR4OvhQ9C39WuknIksTTEGBURHBoyJdQyNh1S
	OJn5VdpWKb9U66AUPT5yEmNyLqlD4C0QdaHO99qq8G163TUJkDDG1LAiTkqn5Ad4
	xQPewaK338cavzZG7QcqedGGn6DofieOZYR7RZcFheXVpO9IKXrZuNp5jjMVevAJ
	TbiSMg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvhsb392f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:48:31 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39d8646b10eso1420013a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 00:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790236110; x=1790840910; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EaIKrQHZiqFFd9rA8t4qGOJUScvKNGixCmmrdQXDnG0=;
        b=AbLr3vvfSkEFxjQXCGpDSHFM6w50UlIpLw+Fn4MSu6UlaJX/7KV1ciXHM4Wvh6Dp52
         FafbEBai/9jeBaOCtB6dMsQIix5p6b7e78wFSLwTIvLDvdkG3pMilj4Ouo/ESRAsxe3i
         NV3sjuzROZdBCy1kfA/xeECqLnnBjGA8lWv9VlVWUc635B+3Q3GhuTgu+JUB6ZC1LCjP
         Ygai0xFbyMEzZ4xl8ADhyljFE4TqvgNVcwaMwvkpi4rdQJAqaV/YGOIMXmDZES1JHAX9
         ZqjM0H9FGooWSfR/+fpFfhN01IQOsvgUFY5P0MRv+xhYf6+69B8Sjdf2naXgNVT9LEK3
         U6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790236110; x=1790840910;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EaIKrQHZiqFFd9rA8t4qGOJUScvKNGixCmmrdQXDnG0=;
        b=hWKeIEUgC5ivdZavUlMGKDe/qtyMBBP0GcyBnYmmvc7wCn4WUmz6/Dr9gEugNM825E
         6kDn/KIik+6f9rglM1tXcOfl7dYczBCNwCq41GAoPz/uTsAosjqEx9+Bcr3+QPjpW9HK
         Op9LthvOA0cA9QjyHD1qOtIFzVFVhv9s8nOnXPM5YK9mK+V05oLF8mrILZ5Rd9uNWKLw
         4ymxN8fcc3r5LguU4lAHfW+lgyEnODgzA0S9t0HWkC1iZ1lGtQMzMSplZYf+m7kRuSte
         7SOpRoEdcOhKOiZTqE15uCRV8AxRQTKuUEJSp26GOoqvHaNKNf4XXo9QS/xZgQZ6fexg
         jbRw==
X-Gm-Message-State: AFuF++kNQSlIkcvrDRrO3CXhR8InokxEInDBYWAoMrJ0iLeZgc1pyrBm
	Kqbh6/kAz/OepVS8HYLc6bbsAs3GHQ9SZ5YNYzjmWzIGxhWWPuVC8y3NFE6bj57YgqZ6zoQEtqE
	C7ZoXzYD6edKNUUhoyyfnt+hfiUh18CbIWwzuumh1ZkDeqL0SGbHshLyNfx69BNfujJTgwg==
X-Gm-Gg: AYBFou2tznTOrCzErb0lUu8vuUxTv1Kq9VPu8PINADKFHlXtR1x4ZE8oNJHyPcNpNtS
	FTldwS/H9XlimSW1W1SG5lxNJIO/uX5wPOvmctNObgjSQoIq9DCKcUKU/BneDHL/dGDBh9H5niV
	zp/OJA3zpFtt8qSQLG8t4PF3BSM2CrwZf4hhYSJ6SbEu00AniQK8PSUN5x6OoOzfnW47ZYDFQE3
	BRJaapPvQs8fPSkBPWwDT5EWS5KnKhGFh1UC+bJw5cbL4FDFScxmPUN4r7HnDktOP58nTJwIYov
	PEmZCDmuGpxMIx4V/8PhfH1UOKReR/d5wiLa4d1lM82nFt3YxPLEeElF+VA34x8A1+3GF5WVQ8N
	TjaQdcxo4C7RDNwGoeJ3cRIzsTzj3KbXglgmkeA80MjkvidkGch1QB3Db6iGFdx2zC5w=
X-Received: by 2002:a17:90a:e7ca:b0:39e:6a81:c921 with SMTP id 98e67ed59e1d1-3a09872e6c5mr1430408a91.20.1790236110095;
        Thu, 24 Sep 2026 00:48:30 -0700 (PDT)
X-Received: by 2002:a17:90a:e7ca:b0:39e:6a81:c921 with SMTP id 98e67ed59e1d1-3a09872e6c5mr1430376a91.20.1790236109532;
        Thu, 24 Sep 2026 00:48:29 -0700 (PDT)
Received: from [10.133.33.151] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0974ec5d0sm3627575a91.4.2026.09.24.00.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 00:48:29 -0700 (PDT)
Message-ID: <c55d15c7-cbdd-4301-95c1-650db2a8bc05@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 15:48:26 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/6] wifi: ath12k: fix monitor RX buffer
 lifecycle issues
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
Content-Language: en-US
From: Kang Yang <kang.yang@oss.qualcomm.com>
In-Reply-To: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: DWUibZ4htuIcKjK3ddvQ-xs3tkeLfzDQ
X-Proofpoint-ORIG-GUID: DWUibZ4htuIcKjK3ddvQ-xs3tkeLfzDQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX9ihXrudFyd7i
 shIQqrsc3HwJccSpTz5gEkyUI3g7WwqmtQAbvZ81NZJcCCYxKzX01fXIevIJ2FfooqIcVa1xV81
 07g9WnEA9/zbd8iRg2Tbgp7gXgIfJExM/pz6iWSiFHENQRvj/z6OTuhDw6lRdqepdngWUVRZ/tj
 qYIIHRsdNtwLvMilQUEwWDNrOfQhX9Y+f4zo/3/EMau6utaVKS+ikfIJ4IzqD/neQjw7FfBIHjK
 2L7maRZf4orkfapjcsvT6Dno1eOD8C2OaQJZeu5Y5+28OfYIIW2uau+6BeCGJoHzSkB6DqpRqRa
 I3Gx3/mDJvIUMahXVWrbvNWi9V2L4TdXE1JiAEs2fzHOxN61xCUhtUre/AI7OdE709MWuDKKD8C
 272z8AjvoQdLxlLaeHZqGh3NR+gjAK4p5UfBbrJXEFUuQjTA5vH7p5asircFE6Gh/3tRrjPx67f
 kB4TbIiH6YvAUkxWbZw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX9ter/QrfB/Xc
 r1Gn+7dp1Xha6UyVikFZqQjSbepb21U5XZ5s0m6KrCn7+8cvUbBypkBJEMK2XVqRAHlhSA55Rs8
 WVXYsx81sQCL6o1C1qdbtigbAik7zZs=
X-Authority-Analysis: v=2.4 cv=f7vdl+yM c=1 sm=1 tr=0 ts=6ab4d5cf cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=jeZ2dEGWif2cJ8v1hNMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 bulkscore=0 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240032



On 9/16/2026 2:03 PM, Kang Yang wrote:
> This series fixes several monitor RX buffer management bugs in the
> monitor destination path.
> 
> The fixes address leaked skb buffers, stale monitor descriptor state,
> object lifetime issues, and incorrect DMA unmap handling observed in
> various error and corner cases.
> 
> Kang Yang (6):
>    wifi: ath12k: fix skb leak on paddr mismatch in wifi7 mon RX pop
>    wifi: ath12k: free pending MSDUs on duplicate mon link descriptor
>    wifi: ath12k: fix stale tail_msdu pointer returned from mpdu_pop
>    wifi: ath12k: place dp_mon_mpdu on stack in mon dst reap loop
>    wifi: ath12k: fix skb leak on monitor PPDU ID wraparound
>    wifi: ath12k: avoid double DMA unmap of held monitor RX buffers
> 
>   drivers/net/wireless/ath/ath12k/dp.c          |  9 +++----
>   drivers/net/wireless/ath/ath12k/dp_mon.c      | 15 ++++++------
>   drivers/net/wireless/ath/ath12k/dp_mon.h      |  2 +-
>   .../net/wireless/ath/ath12k/wifi7/dp_mon.c    | 24 +++++++++----------
>   4 files changed, 24 insertions(+), 26 deletions(-)
> 
> 
> base-commit: c3bace8584ca707e34ba837f65c2e9d566af4c2c



Hi，jeff, do you have any comments? 😀



