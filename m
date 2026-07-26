Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5444563B9
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 16:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785081636; cv=none; b=Zw7in2aEpWexvtaHR1iXE6KV6JtIbnc6nXJm1r+diRDQj7P8OBNjLKT8IZu7Ys1bQFFvaXEPQyW1AKyyVDdaEkJcb3hYCZYnnesm7MOCterSDfjhdqGfgfDb82fqFj+Xkt94cjAVciR+Z21ZbMkL6fQyVw2PaJrGa3CyjjEoA+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785081636; c=relaxed/simple;
	bh=R4LWi30MtvZv64MHyL6higy9x3nwzqZ3OZ16hyG8UP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lBHYafe2fKbvRugtzILCRbUZpyI46a4wRU1mSzdh407uWsYP+PpMz6JvI7H87hql5W7VkFmfeF/4lj1vyXxAyORp/CD9xhhoaFkLbhOTWjGt77r5WjoaNlVT7oj9JX/Rwu5jO2ZvQzYkMjzmItkXLFUbCDDCAXr1vAbqTZl+MA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Jw3vwd3j; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JMiy+efO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Jw3vwd3j";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JMiy+efO"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QE2tq8993288
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 16:00:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jeLaR9Pb53WBH02Eg6y9/hRQC5tvdNBAcvDEKa/9DhU=; b=Jw3vwd3jGwFwJ+zy
	ys/qrQZmQz32JZyVHCPXCj5jd8QO4y6ocBbP5jWXkGR6bijMNJLW9Txsm2AVmDvg
	2wVWoeuwx6r6g0V3wXlEEIK/9xVGMqRfN8XEKANCb9+qDXQ6InrgjWHJ5oiMLcUs
	1e2uCgXI8w73MMhxqSgqm4TepxpYyzP6MQDb14ZmIIhDDlPGi9cYDh+9N7qvJy6s
	fLuH7PB8zlRNMregIhxmENGHPQ6/GFYjHeTP3qUPgPzG67MdS36IotE2aQI6FdTj
	R8QbGXXMUO7QXZFN6nSUrFHbR58y5RxpPiYPYOch9bJ5MWa8qL/Yj5gcl+H6lVDM
	hVel7g==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fngysrfjt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 16:00:34 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb711c88f2eso1188088a12.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 09:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785081634; x=1785686434; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jeLaR9Pb53WBH02Eg6y9/hRQC5tvdNBAcvDEKa/9DhU=;
        b=JMiy+efOjNo1MWxhMeZ9D16pRCDDBSD7eQRIn8hvYrEzj3J3GAKHCZ0DBfqU+UxWNJ
         pwlr85gn6KfgCR0s9tWcDFmShe9jz8iOSDtsM5Q+8x6yRVgfF5z2JzzVRleb1TrYpBft
         y7C5kcgtl0CsVaRDE2EP0L65rec2xWQhFx3OjvEX5F+UnBFXrE5RFJwxNCU1YAkvKtg7
         EFJUwh+AZB5wDxFhBBnZ2p649RySi64ekKI8XqfYty4+jqlKQlnxQkqyIIyXjATsVwQZ
         BA163nVBsdfx+Z2FQJx0qF+zaRm9pUu+bKXewsHrTSf/vBswKKpc4NnJL4UIvx1wn9Zi
         EGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785081634; x=1785686434;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jeLaR9Pb53WBH02Eg6y9/hRQC5tvdNBAcvDEKa/9DhU=;
        b=mJhK4VDUUIV3P9jFmbUSZ6+X5Y/GxUXN9EPTKbE2P9sk9XqLqGN5Yy4nGZ3fMLJ+eg
         /UrZSTH6s0JXUUHjGjYJ3qTRZ7OECU15UkfJ1KeNYdOrBEyJd2cBi9gVUZ6AKULET2Fi
         3fNQ3I1l2mWdC4LL5m1kmBiKJXsND6kNrAxDIUzA8zCWdYiVFyL0wWHOVKdSXOAJENAx
         /4aZbzXbAcljAgtc0KMA/gJd7gTMq1IyGBvOeoxbkRcrzh8HnnfKSyR3mwOemq1rEIkS
         8eICJGo+rv6y59+/gEMkP+ipDw3ANeqkzmtzgW1yq1gpJsIu1g2xrXAW5VmYZBiyW0+U
         xVPw==
X-Gm-Message-State: AOJu0YwkyQAPpF3e99SqqtYG8p8VcLIsi3i+5HJFMWd1VhNmWUcv6xh8
	JtGXfxwHOl4NfBXsKLYPW7PgDjK819fycmSqcUw+/aaxosC/2la2JGY3aH13n2vYs7FHgKc7H2A
	kS/jg26ClhNwJM9tX45/7IL5dep0b03k7JZLX56Dr8B6auB2Zv8TzpRQ70l5OwfF92QJbzoLCzD
	w7PA==
X-Gm-Gg: AR+sD13e/mDdoDKWPGKWBQ6xILwZkcKSmQpcJo4CbVLS+nDh3xz3vVtynLz8k274bk5
	Yhc3OatIUYP2v+1NDAO6RgWdoap1QHb81OBpvVxlZZMIrmohqsHZHilr/4GKTb3Dmf03WdQ5NAv
	3SyfMo7YR1iYF72PBVTfL7LW3lsqLGvbkT+0zFqWmUcnURkZv4dkwHsq4N3O/u2uiODtj82l2Bw
	O3AQ9A/08I4Jsw7TOy0zwWxog5ZkbYN+IOUQMW7mu+XNTN5BzE0fxZccY3Bq16gdAzA5vXb1fye
	pr/ma/3Sy6KK0+Ucnkfj9/KAnB73CcaupnEv6ubfn5M/QQ+ZfKIqQ9ohQe5VUYAH0kW9ccKFzer
	P6AS0HJsGMpmou3651FgqgRbCR9TyPA3m2SvBMreSuQgbwQFXEM3vOCoOiA==
X-Received: by 2002:a05:6a21:9991:b0:3c0:9c19:65a0 with SMTP id adf61e73a8af0-3c67e01ee1bmr5230263637.72.1785081633872;
        Sun, 26 Jul 2026 09:00:33 -0700 (PDT)
X-Received: by 2002:a05:6a21:9991:b0:3c0:9c19:65a0 with SMTP id adf61e73a8af0-3c67e01ee1bmr5230231637.72.1785081633402;
        Sun, 26 Jul 2026 09:00:33 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc3e878esm22480579eec.3.2026.07.26.09.00.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 09:00:32 -0700 (PDT)
Message-ID: <49f52ca6-d2a5-41d4-9952-794dae91e32f@oss.qualcomm.com>
Date: Sun, 26 Jul 2026 09:00:31 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 5/8] wifi: ath12k: add WBM RX error drop
 statistics
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>
References: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
 <20260723125448.922361-6-pardeep.kaur@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260723125448.922361-6-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE2MiBTYWx0ZWRfX7TNcR/Xngac1
 UdMW3WS1QRuQF2FRwy2nBUDEw44ELfrHjE8rCNQ4INBuGtq2G5QTR4ra0dnWxvpaNKw/vruNbOF
 Drln16iMz9LIpeQNjD7EBTl+0AV5TgDTeWsG89bE8z36KOIuDiqGKFQsbwJ3QarbJ4iLerBq6Ek
 48pi1PNEm7SaSA7YGZM3LrIaop2r3yi6egxXpeEeNl7lwJ4nlncN7YPFbmGJGZCVr825QmtIdQ/
 xgi5QdeR60a9bKMlj5p01sZ3aCE1gJDE5JHe+oVA4L5X+DPrvtjMm/6hmI0Y91aQ5doWdq2yiDU
 z2qSPoNnAwcMNNDgzCY35SdLHXm3bQA659bvfGSDF6+l39/TvThOIVBoOT1wY0YNLRiD1k+hFxb
 Z/kj4oehplvj3JgJY8A8bRUNNGn1QTiRBFXvh+we3H+JZGa/mmno5UGZos7PhgIxPa+VrgQkQda
 dm48KQfR+3oK/8HV9EA==
X-Proofpoint-GUID: xni4mOo0KdWe4CYO1EwFMV2FwnNDpysc
X-Authority-Analysis: v=2.4 cv=DNG/JSNb c=1 sm=1 tr=0 ts=6a662f22 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=szo79jg_E3-Az3Xz7uEA:9 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE2MiBTYWx0ZWRfX0Mol2aca1L7W
 P2TekM2VWMGU4BLb7xiMH2HsexQlp8SDteBtqRQLNuCBT3UC1vjR2eXpYnbv9RXeYf7BSK7cYKf
 MkNqFAyIsu/JyVhdin3iAO8y6gvYZNg=
X-Proofpoint-ORIG-GUID: xni4mOo0KdWe4CYO1EwFMV2FwnNDpysc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 bulkscore=0 adultscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607260162

On 7/23/2026 5:54 AM, Pardeep Kaur wrote:
> @@ -1961,7 +1983,8 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
>  		device_id = desc_info->device_id;
>  		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
>  		if (unlikely(!partner_dp)) {
> -			dev_kfree_skb_any(msdu);
> +			ath12k_wifi7_dp_rx_wbm_err_free_skb(dp, msdu,
> +							    WBM_ERR_DROP_NULL_PRTNR_DP);
>  
>  			/* In any case continuation bit is set
>  			 * in the previous record, cleanup scatter_msdu_list

My review agent flagged that between the blob above and the blob below is the
following code that drops an skb without accounting:

		if (err_info.push_reason !=
		    HAL_REO_DEST_RING_PUSH_REASON_ERR_DETECTED) {
			dev_kfree_skb_any(msdu);
			continue;
		}

Should this be counted?

> @@ -2007,7 +2030,8 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
>  		hw_link_id = ath12k_dp_rx_get_msdu_src_link(partner_dp->hal,
>  							    msdu_data);
>  		if (hw_link_id >= ATH12K_GROUP_MAX_RADIO) {
> -			dev_kfree_skb_any(msdu);
> +			ath12k_wifi7_dp_rx_wbm_err_free_skb(dp, msdu,
> +							    WBM_ERR_DROP_INV_HW_ID);
>  
>  			/* In any case continuation bit is set
>  			 * in the previous record, cleanup scatter_msdu_list
