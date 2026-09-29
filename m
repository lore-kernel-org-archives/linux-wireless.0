Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410621C3F0C
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790690475; cv=none; b=PgdfIrh0bKy2/1n5PX0/i38+6Bf/0+Eu2Fp5qPARGMJpTiLxjPpyN5EST28BGVeek7VaLl4ZN6EbzkHiAisgILvz/gYV/73TU1PDR2pnx89FNfK6plVhhAGb/3kazA9YtJaS6Avtxf+zGlIzJmJBGXfRge4nzLyvi8e0lonN7OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790690475; c=relaxed/simple;
	bh=lmmWkRjWnipZ+vwrOXsJqdklsH9VY9af5iB/DI2jsN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ugpr9ddc+WcVcvdUVspDQ8aGPzP/AKavFoy5wcVsenf8jE3UtBXiS1d9MugtU41qGQ5425aqxyGRdxHopQLHQ7FgU3S1Y3WmnTmCVDvGhGLRmgMf/j1Ryv8X0Rp3k0QmU9tqm05WtHQUKZ8bBxVCG3gLJ24tJv8hq5WHjDEO9Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S19NDNWP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=X4xqhODa; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S19NDNWP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="X4xqhODa"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TCqmlg4151555
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:01:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Yfq9SBz+PoIlJYBWKIwSyYS2FEOm4EgkNy+o5Gu1D34=; b=S19NDNWPaxsY6T1m
	jdUX0b713cA9G3GBCtngAogLYz+d/4v//H6VhZkfmZuBJmx0SzapqPB5zEN9Xlmd
	awBUfZMcGq+6XI/MODbAw9/ImAcyfSL6HsyfCwYMS7POzBVK2wdOThA273El7B3q
	9cYKDntk9yLWcOaPZG0h0Mhz8X05SXGQ/VPH8w1P+czY2LIXl8X3pEkgrdkmTGUM
	IHc/SvxpD7sBTq8TiOpvbvJPdoYkntFdV4srnJIRauCv4Qh3bty7T3nd0+57wqHb
	qJiYzmfVhMB3gRp1ei0Hi0BlD/eW3D/9BVAfrrhS4RUup+dbAjzc5Dw1gGMpjOoe
	NG8DGQ==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gyvwncdt3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:01:13 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-81e61199361so1547907a34.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 07:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790690472; x=1791295272; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yfq9SBz+PoIlJYBWKIwSyYS2FEOm4EgkNy+o5Gu1D34=;
        b=X4xqhODatXcpt5s4MCXgeNKqp3zr0s34kvdY+4i0HVLLcwcCxM70pf3gW+922P2cbk
         HS4nAnCG0lJTh6YPMzVcsqRmlYuuBww7/yMPTQhNm1ITTGtwTha6LMbjdx0HGnFX03C7
         74L26OAKuaRiIlldtrWTtc7t3LICnchzWG5J0J6xumG3D3qj1BcnWshrNkCtZaf7iGUv
         4kHGzrMzI3TKASdB4409Fx4rTt63F97k5BuurpgHN3Vy9BjmooqDGQhGhq1+xVHATSQz
         wrrZgbUOiRGrhbfXN6gnb+KerVEwxonMtSDv09F+ze9SNuHOLtyZV+jkVMDZrQf5T4a5
         0oiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790690472; x=1791295272;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Yfq9SBz+PoIlJYBWKIwSyYS2FEOm4EgkNy+o5Gu1D34=;
        b=HI9YahcVBy/Vpv6gTPwZJi+SUTfmJMgUp1SRFGGYKDkIzX+Rjo44DwOroANuAzeG5r
         5QlS191Q2Zggf4TVXkPEnmpipjOvRoWkmrA0PSjsGjHmztKMJOB7s7Xbmc9uCuNubus6
         xFWMJVbNvMLhCvfv2iB4+ONO24z3uMWz25UUzXepTGRKuhtqX79vDpO7nf0tx1SN0sha
         8afZweCmLV1/UXttmsAcvEuFDSg3r6OcuPulZ5cBUQcpLZm5HtuQVsnXj7EN0xBNayfH
         STpJJxuPZpokQIEhdtY7Re5eUhQRcShZ31+hcGn5rmFFbKBIkscdQareT/Sry4TwHJU7
         Pp5g==
X-Forwarded-Encrypted: i=1; AKwUvBwh0aRTvFnk1ONmNgoE0fBInK9wCPrx5ghkRL1nNzU9eDZFjnrj3N5BCZYOq86I0N9IdS1+gha52J/1PJWNmg==@vger.kernel.org
X-Gm-Message-State: AFuF++m32vgoulzMH2flcvM+g8/D04KfJGHwEL2Tq7LLkoZCgiLWXv+0
	CsfvsEyb+pKBBwraFAa5grMCBhiWYHB7FvxaLb1wx0AXa1vB/eIZ0Ts7j/pARSLzNEj0xWqCoMf
	W9tcbRuss7jcoEGa2551eK7jfuh0YStJiM/KMQRYcuz71KvgaCK3i811s1Z/vgFRJZeBl+w==
X-Gm-Gg: AYBFou1snWxcS2xWQM57zeYXm04515iWqFyh3+wP6c7Nib0FeiZwLv2CynFV78R42dX
	COHZiLZMdXpb5FTjCtTnhrUTtGB+eBJ9+g64dpftZH1umEK8yn6QSp13hAcqER4Tw6yX8W1Wnkn
	thCujQ2fOfE1muMv4UrWWoRL12QY6rtVaWlxgWj39phLxIa3msm09LD9jL4ZDX36KDSEoLD+lmp
	O77DyblMW08Y8zahcuLGx1LOqWbfkt9mQ6PzfzlbsCFZDd7h/wHLqkp8OSy9UHIWvNy1Qa/eIZn
	QOqvS+ZIY5RvY1FKibq5M/NDL7mqYScAAso8m+4iurR84kT1SkExbUq1Oz7jmmOJK/OwEPo2WPX
	Aq/fPqk/kFqrYBH2JOD9iXC5HVOA8vyDgaB+6Z/7BZDAHwFBTRov3m5KME4ht
X-Received: by 2002:a05:6830:91e:b0:81b:b7e3:23b7 with SMTP id 46e09a7af769-81bb7e3269amr7255239a34.31.1790690472307;
        Tue, 29 Sep 2026 07:01:12 -0700 (PDT)
X-Received: by 2002:a05:6830:91e:b0:81b:b7e3:23b7 with SMTP id 46e09a7af769-81bb7e3269amr7255188a34.31.1790690471664;
        Tue, 29 Sep 2026 07:01:11 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-81d583f8a58sm4591309a34.10.2026.09.29.07.01.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 07:01:10 -0700 (PDT)
Message-ID: <f3066128-7880-4396-b9c5-ef4c9821e3be@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 07:01:07 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] wifi: ath11k: avoid IDR mutation during pending mgmt
 TX cleanup
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
        Maharaja Kennadyrajan <quic_mkenna@quicinc.com>,
        Ganesh Sesetti <gseset@codeaurora.org>,
        Miles Hu <milehu@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260926154824.75224-1-yaojiale02@163.com>
 <20260926154824.75224-3-yaojiale02@163.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260926154824.75224-3-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Ek0OYH1nURp9EeJXUJNRRsHuNpPbl1La
X-Authority-Analysis: v=2.4 cv=W42txhWk c=1 sm=1 tr=0 ts=6abbc4a9 cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=Byx-y9mGAAAA:8 a=PbnQRnT-oomjuI1N5UMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA1NSBTYWx0ZWRfX0nWNZfBYnlL7
 KvLoyAClUwzHdYq4WQ5D9rKv8kfOynqEc+hPg1DFVOSMY6jhdDE0lWDS0+s6MZTQ/zBI1JukPLH
 +3zDApbEkT0kwiMFfuD5ZK+SqQy/Isp16dDQnbO3iorIGazbHLPWh+0Fw1VcGjsiSnzOQ+XiZRR
 eWjtyM3gq1YfY0JrbD9mpG1J3XgMgzrgegIs8+1/O6AoDsi5YjTIikBPzekGxtbU6wZ660tVPBq
 8oZTJaJigr3o7uWFATyKUxLKuPG7ZMOLGFLalZggpK1XXJrKLx7mxWaSTv6JUzxuxKCUWMczPIS
 VcEnRSlEIZYXSkm0dcQw0G+M4Lk/7H4oCozdgejsLQAXsYs6HP1Icxb+bLiBCMImMitxsrUGQZg
 AwAMQnCv9/VokkqOCIVx/dWnKOL1kIHPMmPUHEmFcy3hdrnHT/R7UheWevT87JfdFFvTK6LtOte
 vLixVu304RpdZh6GNdg==
X-Proofpoint-GUID: Ek0OYH1nURp9EeJXUJNRRsHuNpPbl1La
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA1NSBTYWx0ZWRfX2oJ7TKS8kG2c
 GJX9gbr2OyTMnIhJIuC9dWs0vHpAdZSgkC0nJr9FGefBjwwgDZHgfDeRbGXYiRYouFkvu7U7grK
 UFX+TmtQCPSbKjryoIVwCrMwqmOLJas=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 malwarescore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609290055

On 9/26/2026 8:48 AM, Jiale Yao wrote:
> ath11k_mac_tx_mgmt_pending_free() is passed as an idr_for_each()
> callback and removes the current entry from txmgmt_idr. This can
> invalidate the radix-tree iterator retained by idr_for_each().
> 
> Both callers destroy the IDR immediately after the walk, so removing
> each entry in the callback is unnecessary. Split skb release from IDR
> removal and let the callback release the supplied skb without updating
> the IDR. The following idr_destroy() tears down the IDR itself.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  drivers/net/wireless/ath/ath11k/mac.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> index ae91b57c8422..696f9dd65ad4 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -6146,18 +6146,11 @@ static void ath11k_mgmt_over_wmi_tx_drop(struct ath11k *ar, struct sk_buff *skb)
>  		wake_up(&ar->txmgmt_empty_waitq);
>  }
>  
> -static void ath11k_mac_tx_mgmt_free(struct ath11k *ar, int buf_id)
> +static void ath11k_mac_tx_mgmt_free_skb(struct ath11k *ar,
> +					struct sk_buff *msdu)
>  {
> -	struct sk_buff *msdu;
>  	struct ieee80211_tx_info *info;
>  
> -	spin_lock_bh(&ar->txmgmt_idr_lock);
> -	msdu = idr_remove(&ar->txmgmt_idr, buf_id);
> -	spin_unlock_bh(&ar->txmgmt_idr_lock);
> -
> -	if (!msdu)
> -		return;
> -
>  	dma_unmap_single(ar->ab->dev, ATH11K_SKB_CB(msdu)->paddr, msdu->len,
>  			 DMA_TO_DEVICE);
>  
> @@ -6167,11 +6160,23 @@ static void ath11k_mac_tx_mgmt_free(struct ath11k *ar, int buf_id)
>  	ath11k_mgmt_over_wmi_tx_drop(ar, msdu);
>  }
>  
> +static void ath11k_mac_tx_mgmt_free(struct ath11k *ar, int buf_id)
> +{
> +	struct sk_buff *msdu;
> +
> +	spin_lock_bh(&ar->txmgmt_idr_lock);
> +	msdu = idr_remove(&ar->txmgmt_idr, buf_id);
> +	spin_unlock_bh(&ar->txmgmt_idr_lock);
> +
> +	if (msdu)
> +		ath11k_mac_tx_mgmt_free_skb(ar, msdu);
> +}
> +
>  int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
>  {
>  	struct ath11k *ar = ctx;
>  
> -	ath11k_mac_tx_mgmt_free(ar, buf_id);
> +	ath11k_mac_tx_mgmt_free_skb(ar, skb);
>  
>  	return 0;
>  }

Just documenting that this has the same potential UAF issue as the ath12k patch:

The ath11k patch makes the same structural change:
ath11k_mac_tx_mgmt_pending_free now calls
ath11k_mac_tx_mgmt_free_skb(ar, skb) instead of ath11k_mac_tx_mgmt_free(ar,
buf_id), so it frees the skb while leaving the IDR entry pointing to it until
idr_destroy() runs.

And we already confirmed that wmi_process_mgmt_tx_comp() in ath11k/wmi.c:6031
holds txmgmt_idr_lock, calls idr_find(), drops the lock, then dereferences the
returned pointer — the same UAF race as in ath12k.

/jeff
