Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD245457E4B
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 08:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791795550; cv=none; b=WRTk2TRZoPkLPeVs+8bs3RGgtqbgcEMmqmODiOJ7DZDHYjp2s2pJlyTGF4WWrgPTbTpgHj6zxvtxz3FyXogP9BW+kfi+UeCHtpIU+LI9Vp6UruvJFZXsnM5H+EIBhViRl6pnaPVJkwfHXDTaYZTs1iGFTjkBCiFsNGobkoE0o7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791795550; c=relaxed/simple;
	bh=LwbPgFn8S0aNZ+nVOt7uWhEHCHPo9BR+3a9V+NDb6yM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oBh6v37JAVSfwanCts5Yez3dDD7eQmGDLHafqX9EszwfriefMomRj3XzQh7w52kNcNtPfKKWlboE8o/byyagd2b/RZkf8hZheXBbhuJlCBD35OD0fOMei0hi1EXCQVKirnn1OovtjFPTPSkk9RNhRoFMxqBlsEnqDTeqwX+zUig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ri8kbeyk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kosA6ma8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ri8kbeyk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kosA6ma8"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C8KwAC312856
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 08:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ll0qihtjv0p7a6Ls/L2RxJXgO9wEDOARy2uDIpE3nF0=; b=Ri8kbeykUzzNe7wT
	ayRtyxjHpxjuLf66mqUnXMzGqDpa/rgp+TvSnjD+coQW1STKdXIsFe280Fsp/C/R
	/zQ7YFlnWh3Ma4mDZ98lRoSRSANynikZpqCpJ0inyUZnH89GU7EJbyRDvLHSFhKx
	Ghf9UbVg4p2H1V12c+EnY8NDXSPr9tN1urhShguKaSgj5dfyCIbccHO6uYHPoov3
	tCzgxSQPXhzf+CzJpyljYDGQOcPWFSb9oFaA2dqeThKVtC9VeY9vo5Y+/skZq4V2
	rxg6svBO3VrAQd0e7N23xfnAz7wxXiEVen1iseHyb4uhu7LZ546Jde/PJ0veoCPD
	vxmIXA==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7ehjnram-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 08:59:08 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-359d11365bfso3162667eec.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 01:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791795548; x=1792400348; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ll0qihtjv0p7a6Ls/L2RxJXgO9wEDOARy2uDIpE3nF0=;
        b=kosA6ma8/+fsdWnUmGz20pVlnVtwLwfuI5SsRLjqIPv7ONUO6EHJeOMBY+z52QP1VJ
         pdR8HcErfcK/XtC6t6N+CSPXlU9vbdswBsNQ/aSUDTlWtXp+Sarefb4v5vro9LRMO31m
         FvXFpLaSZgNYGzyoGcPBjwfaAEGikh5Orkt6LnYKfP/6UgUsBRtssm+TKdsWKIOfKr3T
         ITQoLo6dik5PsHXO3xIpFu/P+gBEFG3TC3FklTK68iZIe+yTYZgD8hRo6zxJIBP19GGX
         /QW1MtIMW5CuIcAqrjjgx9OkI50cIyUAc9ISNqxrcQvZHSavvgZ4rkH0i7hZyAbmP78R
         UBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791795548; x=1792400348;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ll0qihtjv0p7a6Ls/L2RxJXgO9wEDOARy2uDIpE3nF0=;
        b=XMLbx01KWIyGTlnluiyHZlDNjIRv7b+TYzrRcm6f04Erb4yjiF+O0CMyF+S0kpQ5sU
         bZW6z8ofgIIwMvqH/TdKBMMNjcS/iWCg5sJPrUWaXzmxFmrk5EV1VJjAz1RMWVK6zMjX
         o2AGk5nsiW7hqK5ycjNLIUALtOi8RNsshwjuugUtzuh3jIqSrMNbkzGZdbd+Y85SeFe2
         Axf6GuELozMNFrkmx6iQRoXAESDTJptM3IHMRJFMjmrBW79XXif7ye55R2c+J1Ykr6GF
         hPWxmJL8trINVFlj015vvjyMU4x1Ts9Mu+4icwxjRUajBbY5jud4ou+y+IqkZQjD7Rh7
         COfw==
X-Gm-Message-State: AFq9FYIUecckp2FQohle6+HxTzz/gIhyI0kA9kyEnr1gUP8ZcGJXFtf5
	lWZTP+DxdujPKoG1zb45UN6GztsfwT4HBa3PWfW6fmhhUKZ0bvDWVtdC8u4dVy8nMsob5FT00+y
	bTR7zn8Bp06bdWBdVU931mTEom4QLwk22ZtIwnBM7lwF+aZk7MKpboAGFRmztFzMlFdy18Q==
X-Gm-Gg: AYBFou2exyJGlflUaZC0JmEqLaqvXwDQJOe88ZnKAkZ/xfLMVJ2QeTp3xTbBrr2fDeE
	6MsuNe8JWDo8JWhznou6AFAwWhmRqu3EySWayCnRt73+B0vaIToCwzZ7WcZt6MhSdqt0NOcEtHU
	jSwLmPQm/xsgrJO2t4SGZ6iamC3+5i5tY+idlGp2bPn7In1Qs2klGjFq+Q70zYcCnNW8cycWIuO
	yEWiOBB3QTprv/pOM7bmCFTAZ9DbEDYGJQSF4UkJ8oDqY5+LiNVz7eP8clnfRZCjJmdujv/ZfiE
	TDD2fDPVhuDhxNKGiiNnNNtB2Yp+GVU2LtF/6dTKwUtiDXySTTUZPop5Fa9ZNl/8oqnDRM0/oSK
	OfMpqbiyHp3mJRsNrnZzqHB7SC6/bXM1AyjQ41Y2n
X-Received: by 2002:a05:693c:6390:20b0:35a:6a7d:a0f8 with SMTP id 5a478bee46e88-35a6a7da650mr3600157eec.7.1791795547994;
        Mon, 12 Oct 2026 01:59:07 -0700 (PDT)
X-Received: by 2002:a05:693c:6390:20b0:35a:6a7d:a0f8 with SMTP id 5a478bee46e88-35a6a7da650mr3600133eec.7.1791795547386;
        Mon, 12 Oct 2026 01:59:07 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b19c6c7b4sm4978814eec.24.2026.10.12.01.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 01:59:07 -0700 (PDT)
Message-ID: <2e594004-fea0-4814-814d-6a716de018a9@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 14:29:02 +0530
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
        baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAzNSBTYWx0ZWRfXxlbqHh7MEXMt
 5bsr1q9+RXAjZ8p+yoes32WwXEbMAEo70MMCyzgZH9EyR7qhxjMnNseF1hsBQu2So9imzOiiXDs
 e/TJ2c6t/Acvbh4yna4g/zrd2pSoPXtS6BiYKxoU+60LXH4KEy475t79izeclDcLqm3N05nkYUU
 18vS7E24tMvSZBi2/f/6UmGL/ji5t8orPRKwQnFstEnmgjqdX8DiSaPNXT8yPJKaFb+ARqs4Zh3
 I55DH7zjgxDp42UbuhvsmQ4BKNmmHtqfrTRJ4KnY7pA/RLXRcAJYMWL7oKVle6bSd1WKDm90G+O
 2UjgGNVggZw625mQQyxTf4Ph4vTbz8hDpM+IdnLhMoDbWoqOv7Oxr+RJUYlwKvlT5zG6fR7qONl
 brKRR2rY/hPPN1Ta5eyH3Q/xwE6hT2ws5o3ZuyunfFOQ90q8aoqN+hTG2UQi1eOJzqutLFJjB5g
 UK2FCsrjC0ZGDXoDJcQ==
X-Proofpoint-ORIG-GUID: G8xUej7bXpU1BNWxpq4Ws45Fhkhfj4yf
X-Authority-Analysis: v=2.4 cv=MpTHeGae c=1 sm=1 tr=0 ts=6acca15c cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=3Kn9n7x3DtEw6PE7aXgA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: G8xUej7bXpU1BNWxpq4Ws45Fhkhfj4yf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAzNSBTYWx0ZWRfXzPeHEfjVmgKi
 1b9b3nL3EtGjBjMhXp/tFawxrEg7nviXR0tKnijIPBuorg0MeXG14gXJc5Z9NSrd2DW0jdRIR8I
 BiKUTtsszRFoBke/aNqr9If08NVwaLU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_03,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120035

On 10/1/2026 10:24 AM, Aaradhana Sahu wrote:
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
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
