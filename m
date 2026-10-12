Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCD942C50D
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 06:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791786957; cv=none; b=K+rg/juKGkgrZZ9L+pXI0NSPJjtyL789q5etODfViFSaGPDSWdlTzBufkck5w6bUloD0wTcURBvX5nxVQqIY8c5NTNtq/5qtEFfCTwjA9oEvohPlLEr5BOJAOiV3XgcbUlFCtuUfyY125UcJKLIy5yb7Wbv5SMSlr93gl2CysrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791786957; c=relaxed/simple;
	bh=TpUKn0T5iD20cHm0jadghUzCJSWmj1sCkgBwlzdioGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rMk/H2bjlFuTkMokWx989ITTXlaqMiIS6XQ6Jx/Uw1Hz1RbRg8nrv9rBVZACOnBRP/awiCeMOlsejJrh4OOt3E8pvT2GW8i36b1Hn6PYIxDo/91P088qhQuEkuwW2wT2ccBMYF/M0bJOA6m0J9gZxR5c6xIZGIzWbcLZ4HGjO7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=l8ei1Fia; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ezBM9TC+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="l8ei1Fia";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ezBM9TC+"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C55p2G302995
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 06:35:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rzyqoTq4mNCNhxu5pCLCT/tmkpUXAonKXvViWSHkRHU=; b=l8ei1FiaGV90CWdq
	1yBrvg4hcMswHo0mrit1Y5EZckj7Nk53VjHgFVF/VvJZN65HoPn9S9O0qnsNP6ub
	dH48YyDzBmwh6yRjNO0dqxNbuNeHYSKXSU/5TUVIuX6c5H5cgTos1LAYrWxFMTdj
	wNpMKzzsY/FOXAjCkTwVYURn0oScbgNe7fjvQleHQ9L6qg8pLnJsvwGor7kKD/Aa
	RNyKijoGitPcLPkQNTAokaJCZJRzQle+eAb+cTjxGdSTuOTo2uuH5rbqiEOFcq8A
	i+d2by3EzoT3CnYPXWTLy96+tT+mJSUXP3ssPe8Lfm8zZm7z0bNl/UMuGCHpqMQ7
	2pzQnA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h8j6dhbg5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 06:35:55 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3a470ead068so1231802a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 23:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791786954; x=1792391754; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rzyqoTq4mNCNhxu5pCLCT/tmkpUXAonKXvViWSHkRHU=;
        b=ezBM9TC+h3cXfhSKX5Ny83sf86rOSW23r/Mq3YR7M6CepLJqaDtjVnNutZz34y/bA2
         Ool82qJY1RrbhDBiroXFo8Dq2OrS+OjA6aPBY+Ifg49xDc6VsNn8kx5qkq85XgcC6qSX
         Ttd27yTN9adDKv6AizordWrwo3DTjFNZXIFQKgg/trA0CaAs2JsZ8OBTgbc4jE2ZDB9+
         9nJ0akyyZ5oJc5I3BySCtwjKlg0Wjg7uNJ4o0KViLjBWUMwr037nWnTHzSCMwrkFL3aS
         kUQykrJAc12Jz1YijlZHV/EJPbV5uY6e5tk8xKR84+t3ZQNBx+UcN4UtDlQtimGRTLLc
         R2Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791786954; x=1792391754;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rzyqoTq4mNCNhxu5pCLCT/tmkpUXAonKXvViWSHkRHU=;
        b=mAyKY4I+160LqbRrKkUXKZDkisD6Dedgl0XCx5LmotUA6ovUoTE1trQb4KaMHTy//8
         BBaMbX+tkoFCYHQiohrZHBzJJT/OXF+ndRSUmbVZfNIzy4PqTcpToba2wDWSRP8X5sZN
         RRIJhKk3h+o5+rSKzmW3836WJHH65i1qHc6zmv9KOzr2a4aP9BlXOXXDd5cGq+jfLbZ1
         DiyjvF1hE08H2yIpzkP07Z/9z9U9Jy+yh7FdHoyzzA4X5Fk8hQf+rHk0Y9YdZh+S4Nuf
         IWkHG0jFnEUpXpGyz+8apGL0l/H3SBH13fPaKMELrRNTbPNQ01e6e1zQz26ZMwS5R5ls
         xpnA==
X-Gm-Message-State: AFq9FYLptctTMDSkbdzBoQY2WkgBaN7B7xJUtLP5tqooCglaxpsV6avr
	mpmptp2GepKmFbam5jkxI43nK9IB81xCLRQHy/rsu0JBRKOmqsJN8Xv/8qBIJpTwRJPLTMTQoq+
	PBEDobQmRPSpSg8I6Yf0WiF636lwiPRBA5ov5nJ7OmjtwxLPkwHgxmYTuZEeXjgWLQPDsrQ==
X-Gm-Gg: AYBFou2+0d9spDnxd/DqD487a5llkCwVFvLzwvuisLNiuXBbd4jt6VRpbwphyClcpP8
	+T5M84OhaU31TKtk0PtthJSV61WN13NNf1TDWJ/qBY72bLxjtd3GpOwVtmpBdIdc5+SlJSWDqRz
	IiYjVi8uUewf4c+fJQpdiErHvtT1pg42BoP1REaUuNMo0IZIeFppuRilJr9MC0AkZSvtNeWbxQ2
	4dAxNVkVbn98/XBf18qspuUlwNtbcL5Tk60qcL1E5eCDmEGiHrn8ogdTqa9oRzLvZ0MI2ta3iyE
	KXftwWzm+4Rp/dMjnCnUJGlJsGCgc9l366mrfhzparNhTUj6BLYWMudSx62Y39uwR9kgNk8mqB8
	FjVfftFE7+Xx2ToyL8W8FkVkDCXh9dmQ=
X-Received: by 2002:a17:90b:2ccb:b0:3ab:1af3:a0d with SMTP id 98e67ed59e1d1-3ab3ac63ba3mr6483759a91.33.1791786954466;
        Sun, 11 Oct 2026 23:35:54 -0700 (PDT)
X-Received: by 2002:a17:90b:2ccb:b0:3ab:1af3:a0d with SMTP id 98e67ed59e1d1-3ab3ac63ba3mr6483750a91.33.1791786953913;
        Sun, 11 Oct 2026 23:35:53 -0700 (PDT)
Received: from [10.231.194.200] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab3972cc05sm6748715a91.3.2026.10.11.23.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 23:35:53 -0700 (PDT)
Message-ID: <cc107d66-df4b-4a77-b0d2-2106a02620ca@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 14:35:50 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2] wifi: ath12k: Fix NAPI resource leaks in AHB
 external IRQ paths
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAyNiBTYWx0ZWRfX2vdf8HaVx6Ph
 xTYdW9yLb3JbkoEd5Z3t+isVBU/bFlCd1kWCpcYmNWDcOCjdtX/yymJ2/TiZJ7za5Zu7Xb7KYch
 hvM5fiNPo49MIP0455bCo4Ofn6WbVXPrdQRGQM6JREIgbdLOT6Uf0q8Nh0L6GSwlzYF3h6pkkvU
 zEtZD1MV5sVvylvYrc1SpEVwt6MFYLPLPrz8Gq8iLcmpJsfmomOrWpAOWKlqbThxNeHNWUahfni
 Fs8n8F3aW8+XhDvW+X1CNCox168/tFuvIi7bEEREELrfi6mEomQ1wSxpC+gzQgF6RVpXg14TuzR
 Hh5lxQ/FaG2HoIHwgRr+1UN8K0B1VAhBfAjyHaDbzPGOS5k7ZeLJ2T3rqqU4fjjyHygpVPytuO2
 4XCTDkay2wk/SfumWvAdkBdNlIH+Bdnn5UApa4JW2QQaojSoQmUbEW2vyKX7Y5LipmgwO8f+OsR
 6wvxvTq3g84UBcUa50A==
X-Authority-Analysis: v=2.4 cv=aK5lOr9m c=1 sm=1 tr=0 ts=6acc7fcb cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=3Kn9n7x3DtEw6PE7aXgA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: 9kF2TwU3ZlVa_ebASPXLBwLRyb62WzoI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAyNiBTYWx0ZWRfX88FCbNuTjQO9
 Epu8Bhr49AO/JgJpQPtNnAnOLdYX2ZwPBxUZxkTKIYcLmCK4PSo5UyjVxu6SKk39F4kT2NGsgh9
 TNL3mT/Y0oSVQ+cx4bsa5JwLF3ryUzs=
X-Proofpoint-ORIG-GUID: 9kF2TwU3ZlVa_ebASPXLBwLRyb62WzoI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_02,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 impostorscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120026



On 10/1/2026 12:54 PM, Aaradhana Sahu wrote:
> Currently, NAPI instances and their associated netdevs allocated for AHB
> external IRQ groups are not released when external IRQ configuration
> fails. They are also not freed when arch_init() fails after
> ath12k_ahb_config_irq() succeeds during probe, or when the driver is
> unloaded.
> 
> Fix this by adding a common cleanup helper to release the NAPI instances
> and associated netdevs. Call it from the external IRQ configuration error
> path, probe error path, and driver cleanup path.
> 
> Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1
> 
> Fixes: 6cee30f0da75 ("wifi: ath12k: add AHB driver support for IPQ5332")
> Fixes: 614c23e24ee8 ("wifi: ath12k: Support arch-specific DP device allocation")
> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

