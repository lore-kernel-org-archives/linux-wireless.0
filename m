Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5555D49B1E5
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 07:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792049920; cv=none; b=NOd7DX20Bzrtl4ctTXoSkQvr6nezWiTg/oZeUbkm3cb4fF6y6dTxJvvTmWlJsTywo2txwewgC6FNpWCxPLSKA0yuiPvmQh8TNkpD5OtG4HrTDJV2VzTvn/M7uhqxtztKBeiI91l02vmLsS9SvG5munc3v7S1XTvkavlDrat6UiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792049920; c=relaxed/simple;
	bh=ApZFJkjaNlT/TsCEe2d8dQaEOVgyQLshFJC22PAsFRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RsoHOTYIyoaMKSFr0nMrECDxrZFBAmFx7eolYFXUMseNFHq3UEJwefnmNoqdi+35tnioF3IlqX/eX7cb1sLRl/xc5TcNhUeb4oyUjaBm6xONIb7h8ZDgi8UcF2iY7TmpyNjtwKAAV+Nk357KNaE3hxx52f1kajTBi55bi4JeVF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nn3iLmtP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AdGEPp2F; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nn3iLmtP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AdGEPp2F"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F6imOp1672287
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 07:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Csz5ueyJ+/67ymuGuUM7rGGJRT/TQU1rQbsBSidkGiM=; b=nn3iLmtPP36d1A/G
	GkhCDVglIPixP5GPIwE3+2EbJI6nx0mtFoPY2/YeudLGulEmVXa83PvTUTjh3KQ8
	VcOmIl+YVKQPx7vEQYQqW6KgEBBBEyIkGlcssyuQSNTBOum4eN42Lw0cdS8W6on0
	shue6VMgrY9ybywlggKqxHbIM2eUi/UFU0CZLIQ0xGzwoFjmpiFrx0Az9nDQ3yU9
	XQI+GtrvLeqAFN+DyuMvzD1VvURy7N17VaAuR2B5GB5tQlmKZmebgTQMBhxOVmWT
	wmUEHMMuDn07Di2Qo0o7rFTHdiU9pEaw3lpws/PsgpwCNbqGxAiqGrR+mygrbdDR
	caKRhg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hacrhb5vy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 07:38:36 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e60bb65626so54046765ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 00:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792049916; x=1792654716; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Csz5ueyJ+/67ymuGuUM7rGGJRT/TQU1rQbsBSidkGiM=;
        b=AdGEPp2FzhXS1afd1L1+fTtCAKWKkO8bqLfqg8+b86Vwx31SnYqlJEEL7N4UDzgjog
         9V7QCkAxd1YbPpfcA0Ul7s42L7RlB6Y8Sh8Xg2diMzAS7VECVdWp4mHJA+406sxUn+8+
         1NidrBoyuBr0fylNmb/fX/AD9qPVaiHcbEEQgN4ICdmREBnfMpDbEduOWrzgpV6aza6/
         Z8SbeGgUBq2uv7uswqiBh14BMHj95AzSRWR7ey+DPaJJpqHlYcGbhSCWcH4afNOYcW9O
         ilC1auKL9/BpotMaVTYH4rovpLp+h/CbwK9ujk7+35LbqJ4+4Q86h2CQaTK2JAd2ike2
         on2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792049916; x=1792654716;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Csz5ueyJ+/67ymuGuUM7rGGJRT/TQU1rQbsBSidkGiM=;
        b=D4a5ASfLvybJ3ivzh0lg0fmYeC6UItotJ6eT2sl0aMUzo1RcKZw8i2UGYrdzV2QXrX
         Y7h6wKYq4BV3gEKeFK0mKQSdBXXD88F8CNL8OXROJO2vNeBNGGgmHt+wHAV/cG/L2HXd
         7EQd6XyQEhp8L02jm0Ht93aDxfmUIlC5S5SWGjGLLVTyzedYSFhOWe1UUrUprrROfGLu
         MBAOsVPfHYI9clWdRQVg+fxjVdlTjNedsemuU4Kn3xJ5OpGX9tswGDl2zG/5fsS4M9dK
         MgZMY82VKsOCnAhxaIKLk9Yco2jOyPP8RSaFeqM2dgHLyb8jfeKzc4YXcOMSDQ4FARmX
         X7uA==
X-Forwarded-Encrypted: i=1; AKwUvBxOnyZcTunwqWoZPkuv8rG/87NQhMw1zHRkirSKW3kWfs+vpUJn4DmgXEwSDvqgtObZ7IOqjSnyh/Md9AWfkA==@vger.kernel.org
X-Gm-Message-State: AFq9FYL92En8c675CXN++ELVrFOf+AARnv8zKmJN2BS0xhaJsxnP5OL5
	1GwUXNB/4yAV+A42JZI3eWxTlJu+2fc4wy/q8KtgrlI/XHe9EsJTmbdx5DJITcGpCJ4KfU8iVoy
	d8ARkZj1gLYNaVWk3ur7hok5iPsF2C7gXBbNWfpftiVdqFc8+Qd6zXcRBZNBOzYO+GkbQvQ==
X-Gm-Gg: AYBFou2G6BeGbdTAIrUrOG0T4ZoHxwUIa5VSlxhUpufkdASWzKSy5n7J8FvSO/HlWvN
	aPhbmjwf9WDN0LrfEtviRwG+6T+cWo27RBq/KdmJtNcW0oEa/anQHm7bJzjmTtElwgkGdFJPCz9
	8lsIvOBDXwR9FDlo1sLwjI0x1IchSxxaEumwN9dchpkCdlER6KFb6QUg6PlisUHsDysQOofg+Oe
	bRqr4N//+y0wnYPsde8aPBjtSGmpI6fEEV0BrFt5BWJAQBJmR+hJ/pdxIk9HqRGlspvSrXPWv0j
	TTliPAy+it2Uxp2KLGzY97Bg1PqJflAYthFx15+jObZmDupMPwtQGI/kuY7MWMUgU/rtIUw7h9D
	A0IYV0m4jqR8Q0YOOo7Nlfix464zMalgu8XEUyztGQ3z+Mu7O+gK77gOlJrcYYuJkjATdeeE=
X-Received: by 2002:a17:903:2c08:b0:2e3:1e9e:fd80 with SMTP id d9443c01a7336-2e8404bbec7mr113398945ad.7.1792049915658;
        Thu, 15 Oct 2026 00:38:35 -0700 (PDT)
X-Received: by 2002:a17:903:2c08:b0:2e3:1e9e:fd80 with SMTP id d9443c01a7336-2e8404bbec7mr113398745ad.7.1792049915162;
        Thu, 15 Oct 2026 00:38:35 -0700 (PDT)
Received: from [10.133.33.32] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421a1de9sm79321965ad.26.2026.10.15.00.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 00:38:34 -0700 (PDT)
Message-ID: <bc760367-4896-4626-8f5b-1bc3ef6cba22@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 15:38:30 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6.y 2/2] wifi: ath12k: copy M3 firmware when reusing the
 buffer
To: Artem Dinaburg <artem@trailofbits.com>, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20261012165925.32575-1-artem@trailofbits.com>
 <20261012165925.32575-3-artem@trailofbits.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261012165925.32575-3-artem@trailofbits.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: fiNazYBNM6PAiD008ThSijnkIxf1OMpt
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAzMCBTYWx0ZWRfX8dq5t3F/+uaf
 zRbQ8pKFGdbflZm6g5fAvsvnU3tnsiFhV/ah7isfIqQLugVLUbTUabv3gsiFHM2kDYx7ANbSWXU
 gBvrysib8tOypx75fyaLFCeoMgYc2pI=
X-Proofpoint-GUID: fiNazYBNM6PAiD008ThSijnkIxf1OMpt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAzMCBTYWx0ZWRfX+N6pxkJNr5bW
 hEZ0lcDdnnNlVUY5KkJacyAKMEWfRf9xGsM6DWp1eoAIowNkdDWPzHqMdGzn9d481xiwvXAWNWB
 SRsc6ZEwoxV8soVPiBwcTuN3x/yesQ5t5/BS7fKJoHU4GjhWPqRfIwFQha6tCuwMG+WJYORa0vi
 oi6JfYLqOpZLyxc2csolPTa/ctxne0SoTwUOZUzqIyAKzoAKr/wmn/1wBKkSP+3SXTB4vht6nfv
 aBViTX4S345XJ3065e3dG1jqNyn5PsLwrZkI+Znf+ZEqqJxSCP+ifYpstBLjIBgMSg4rpcgy0vD
 vSeIihCrFFN2ji/oMoOjD3MNOYdvsxNz4HbqAuiE6cjwsbLyEiIoFqfL39+zeP2AAxe08Z6wW6o
 XLQDpOVAg73Tf3jHngabSE63b393JZtaRKWsHM0i2BjgAfin5cAopNpQbUMgxEZwXJ+DtLbCk4E
 vnTJOmpafllzRTnu2Qw==
X-Authority-Analysis: v=2.4 cv=SYZi5fRu c=1 sm=1 tr=0 ts=6ad082fc cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=rP-kOlJ0AAAA:8 a=EUspDBNiAAAA:8 a=cZfKjUfnoN_5-lsrkKoA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22 a=A60uPr_FG5abr3nATN9e:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150030



On 10/13/2026 12:59 AM, Artem Dinaburg wrote:
> This fixes my 6.6.y backport of upstream commit 05090ae82f44 ("wifi:
> ath12k: check M3 buffer size as well whey trying to reuse it"). There is
> no corresponding upstream commit, because upstream never had this bug.
> 
> When the existing M3 buffer is large enough for the new m3.bin, my
> backport releases the firmware and returns early. The new image is never
> copied, and m3_mem->size keeps the old length. Upstream instead jumps to
> skip_m3_alloc, which copies the current image into the existing buffer
> and records its length. As a result, after recovery or resume, 6.6.y
> gives the firmware the previous M3 image whenever the new one is the
> same size or smaller. A larger image is reallocated and loaded.
> 
> Replace the early return with the upstream goto skip_m3_alloc. The
> previous patch, a backport of upstream commit 00575bb44b2c ("wifi:
> ath12k: fix reusing m3 memory"), keeps the allocation size in
> total_size. So copying a smaller image no longer changes the size passed
> to dma_free_coherent().
> 
> Fixes: 9a38ba5561d9 ("wifi: ath12k: check M3 buffer size as well whey trying to reuse it")
> Assisted-by: LLM
> Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
