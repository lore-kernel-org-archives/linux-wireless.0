Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916AD343893
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 10:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789641873; cv=none; b=XwMZJmjzM3t7uU3IX/tyazia6J3vVtbLbZI/CBiGY3fQz9zn22vIa34JxFSPFTijLcmcnE5Zzbkv99Pm9AeEohcxPJEJC8+9JDnfrrC2XgvzVp5Q26BcjWW1iAZWqAwUk0n1dVPTwl9Io8+HLc5sIWFYTf6hYxAhX5QcrejDzpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789641873; c=relaxed/simple;
	bh=nLcJCiskvc5lQjgAwBGs0X2pvtgrhay2JDyabo7c4mE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZruwO45U9onUSFjY4YvmsZh+QQlzBRa7XEeJFzgW3RAnjUwA/sT1G66zspc/vDzmbG0ZnR3R5GerFdOH5e6LaWH0bDTImgWZ9V5+3HMvSgiGqxGMzzohwFr8Cj2Om5CTBSm2AEOG7KY6P5gUPXfwB3lDCTrxXHbRbRfbLjMC3p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YhboDrhA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Zok2NpXo; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YhboDrhA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Zok2NpXo"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H9Zfxs577160
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 10:44:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	iCYEospgVDPAAQl+7gboh+7Q+HFKYksIuEIvjVZidQY=; b=YhboDrhAqLfk8mIO
	MtS2Ph9BkObPRR6lODo4+zBwlQrENDp4KVJBDE3lu3C1+iaPYh2f5FI7/w5R/Z4g
	W2U8INKwzf5nTrm+ZQ2Rs9ataC8nSuyz8HS/wAmK6sTKteOfrXxyWJvhNnEQXALF
	J5m86FRmjz12Lr7zieB2Hmc/9pylWtzvE89VswlpZ3pL93O3jmyRUVaNWgOd10SC
	BbJr9vpUOXy7art02T3Vvw8/FUdQxzuzT9ioCFEaGctQQA8RBEbHcNoLUzrm72E8
	c1uj99xuHpDGwq8lGMFeFDdXvrWF0FKV6nLqNTsibceLMu1C2+mPaD1KdoOISUT6
	0O7OTw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gr8uw1gqx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 10:44:31 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc132709c76so953015a12.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 03:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789641871; x=1790246671; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iCYEospgVDPAAQl+7gboh+7Q+HFKYksIuEIvjVZidQY=;
        b=Zok2NpXoNqvIBUjAXsvpj5HwdfwRRUWPhKrPkhpeyv27rm0Ne9yjOeODK0br5zvQTL
         EP/7C0FYJAgai0fjEU3LQ5bYihMVAS0NaNwDOXj5VUU2S8KscZj8XBNjqwgNusPHc2Xx
         fn067Edc26wbuSqWMqHeAEo00MKsAlMX/bhtoHZljI2DhriR88uddgKwQV3lOnZIPCbZ
         b1s41Tzt27jDQk4XGOUUsbf9i3Y4u5CFmosHpuk+GA5mM51PC612bBT7tXtwhwjlFUno
         PxdKqlX84+MOaH2SIJstUUR1w0BTrWbVcctIRDixQopH/lCD3itJgyxZrd+OVtPIVheS
         YDQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789641871; x=1790246671;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iCYEospgVDPAAQl+7gboh+7Q+HFKYksIuEIvjVZidQY=;
        b=gHF2aM2MGqhJtT1Icrqw8OqDnAoW4jtfiwFfzfRaa7lIPqUu4Ti9zHzJkbZkc4p6C2
         0f77pjhvctlgHykvllg7c057x7tldJ5wW+HzSMO7ladNo2rGk3zhTwjDiWj4uKpKt/k7
         tYjuhsO5GxAA4EGOkJI5l5Di2RsAOrnl4L60sif8IkmfCMUTIW7CuK0XszAxjD4EeAKE
         cW28Y+o7dlwb4Wjb162ohmvc2aSgphFSMX/gUDt776kRsYFyH69EpElRRJHYKW0V7KJO
         KRnFv6kYwqXSIB/pmvPzqWLN0aUDkK7OPmZw4K0if4UDHzRt8LRuZmhuAFmUZ9kvnsjF
         l9iQ==
X-Gm-Message-State: AFuF++n2dGEp7Yn4Gij71DeI+TyOMTRM33sW6qRUWiy0AoUNKE4iR/vL
	vRrFPUHo2frUQmliQibUyDZgaeIaDIXLjh7ramaAwiimQFFiFyTMjn9b7v/EhCH2LA6Zp9zjhf1
	CMtgz7WhqP8x0emlkKIzvg0uGdG6FtvxF2kEP2/ZJdS0/WDyzQqGyRE2KBLM5tCZuWoDY+w==
X-Gm-Gg: AYBFou2MA0eGREXjXXVNAVkkdr55TcRVPkGHdTkEJoDB3nbFwE4ZKSPPIHcN6pod2oW
	MiFFhwGcD6ouFJ8ctV4bfqDnfTdZTUSeiVhAyK8n/yjl1rREygHDL3woSFYm+7pPZSpDTIfnZTH
	7stMpViuSYFJMM0LhB7IMFMErDIopgGS3pAyxky67RandgJ+p84+n+k6saSldgs2eWUxheuixQr
	nh/titRIAD1GWQ78aUkYSXdoys0HlDVSHJfObu1hc9dTx44GZzOx031PH+mB+cFYGXMF0Za2syC
	0yjIuMSuHVhRy6dNlYrwEghZCYeX1gMBxJWA7SmvejqPYgngjk4o0vxTvMP6nnewyeNSrJmOibv
	UIDb9RDDVPIHH5g1BtOpazMwXjh6ciklhpSgwZ0Rm+N0Ig/k=
X-Received: by 2002:a05:6a20:d10f:b0:3d3:aec2:4dc9 with SMTP id adf61e73a8af0-3dd5f72b353mr17153723637.21.1789641871094;
        Thu, 17 Sep 2026 03:44:31 -0700 (PDT)
X-Received: by 2002:a05:6a20:d10f:b0:3d3:aec2:4dc9 with SMTP id adf61e73a8af0-3dd5f72b353mr17153666637.21.1789641870660;
        Thu, 17 Sep 2026 03:44:30 -0700 (PDT)
Received: from [10.152.209.53] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144c9f0da19sm186695c88.7.2026.09.17.03.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 03:44:30 -0700 (PDT)
Message-ID: <1da678cc-d2f3-46d2-9cb1-1c3ed2a8f0a3@oss.qualcomm.com>
Date: Thu, 17 Sep 2026 16:14:26 +0530
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
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 7-iDwJNCZSR_TiSLMzdWze9blSYymX_Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDE0OSBTYWx0ZWRfX4v6skQiXdg5w
 9/vnV7miLQ5HxAVWiFBhTogOkhAisQAn9hYsyNr+US7knRjCTnAPh0rDZ7dZ1yBhH4AJBVdj3He
 ehHG3TjcbjNFKPRRzTRzAeSp2kjRiEiuXYyQXe2Yc2qbcS2WvWV7wcJogVlCSiT3dDx8Ie0hsmj
 Fum8eOT6n/cFBU6KlMOLwWF79Fv8D9f70vG97kHzzeExOx7NYxh/7fCrLmS3Bvi30b25k8i4wNh
 xLUvygco6B84QmqcqDdRBgipPYiz7y1TyFrr1478YOiroR1tCG+754nyC/MeRLlUJjY8zfMUa1n
 2rHQpFKpEZNweIY3z7ZwSZ4whGUUyHYjy/E6vT7jmTb9Rb/JrBNY0ZLaDETVt+TuI/E211D9iHX
 9Rkg3F3SExbei1Pd1hq+G52xoShBB508VgugnH9t/sNaMHgpSFaactGZ9tI2GHE/N7wrcLLGJz+
 MrXV/RJYAsDWjDSaV3w==
X-Proofpoint-GUID: 7-iDwJNCZSR_TiSLMzdWze9blSYymX_Y
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDE0OSBTYWx0ZWRfX/ywAYixXtiUU
 71/sFl5mXUWW9CkLijdbHRm09fl2zVH4Zzy35Q1+rBr8huzjr/kHgnXi4KP6NLR8/7NITjMewTX
 JdHrc5c9h7uLXbLsZ9cXxAltYlf2e4A=
X-Authority-Analysis: v=2.4 cv=dMUzC+Zb c=1 sm=1 tr=0 ts=6aabc48f cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=jeZ2dEGWif2cJ8v1hNMA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_02,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609170149



On 9/16/2026 11:33 AM, Kang Yang wrote:
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

Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>


