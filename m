Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E597E2C032E
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 08:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785746290; cv=none; b=sxbdz7k/tiGwhPjCgu2kc32+XqqqOiJykOTtR2lmTv584CCkfdZYG068zPC+5XhotJm1CFIGS5k9tMSKJRK1KeVhPoXQLJCZbb5JNWtdw5ONTAVoMExRlKjfJJu14xXxjxpw/Ce8LwszSZ3coKPhVgU2hb9iEnltrAO5MJ0yb5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785746290; c=relaxed/simple;
	bh=FzSemK/gyIt6iINGKsWpvpb1R41nZVfiuTVPZezhF9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qHKNJr5AGOPs6K9EUDI+EaMrzOEFBpxCdIh7Wr3pRpvp4gnN7a4MY+LYDCqmI7ZdIes6WeQY9pP7XchVLK2HJB/T7qSbzmTHpYVN3gOzqxep4lyjslInacHmYRyS0Fq9ZkNhYyWOGXV653KolDwTDZBNhDVlqESA6XDjDHDEzCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hnKoq4Dr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DofLFPZ9; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hnKoq4Dr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DofLFPZ9"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6736EvIi005475
	for <linux-wireless@vger.kernel.org>; Mon, 3 Aug 2026 08:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DS5uMq/V/wG19vF/mEvQNvyxbB0WznTmF9aYgYlRHF4=; b=hnKoq4DrqfEor8Q5
	+sxVFYJpbP/hJERB6lHZI7gdRAq/VpMAxHtxKH3YTppbJZwT4DyTw3BjfHzZfYF1
	HovlZ9RnOBoD2TuAI8NvvpM3HjDCdGy7jiW4yPr2lyw2lhC0Dd6xzapIJMT2RFyl
	fxS8iw5hXAu9LFZSf+2R85ga6UL3nP9QNpxZNlf+vJINDvsrb1Hfk4GkX/tusteK
	rn2ZNMIc49KJ4ukgSyUModZc37mumXRkYW0VQBV5h4qiI8t/O43zXPeoRLIFXPX/
	TJrLv67Fkwg9Qm8ea2VHGFsp2A9mDz8DbQEkjKMzh8/lj2B9U+uLvRV6ZzD3YfsO
	f83PcQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ftnj78j83-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 08:38:07 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-ca8aee88725so4849518a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 01:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785746287; x=1786351087; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DS5uMq/V/wG19vF/mEvQNvyxbB0WznTmF9aYgYlRHF4=;
        b=DofLFPZ9lGohFAB67jemxr5OGC1+eVSih14r5pterBdz/s+o3b4RHn+W8ZeRb5nGap
         ScgRLbwGrEC4jbEbvBli3GsFQD6rd0qPoT1602uGGRLSSavtOAoOXzmf9BJpjWUBY0cv
         egAiGwNfdzBbbscIBE/eEzLpDcZ6DMxHS4Qg5kcYJiS9hfahzAg6nIZK++wsqNY15+hA
         c6hrPr0JxHxmGFf52hzu0vImpk3McSTgviLQCo8oT6GNuZMcXxE80l4dF9V1808xXSC2
         BVCnoLPK5mTxMun3Xks118DNHOm8T6iAq+EZOP86/KluDo2P2NP8ROo5in1PXbcnnHP7
         3tHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785746287; x=1786351087;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DS5uMq/V/wG19vF/mEvQNvyxbB0WznTmF9aYgYlRHF4=;
        b=FxIwAg5AAzHPZ5Btai4ZYUc95H0zeHY6cL5yiJEm0gwixSOAv1hKaE+Uemq67rC0oE
         VmbEy9twTyKrX+dU8sfyX7QpzoLilGGaYV/Xf/LGwpx2v2ufpb7EHJy36qEFslD6fsj7
         dEzO0QO5Q2d7Bliwu6N+RwAwAQIsqZNYXeGIii2yMkGustLXHHZhaQs6ePsEY5gfT6xM
         6ZKjlYu2P6aFqiGMrQf3eflK239N45YROrukSjQQYz5971EBTed8ptnmYw3Qwra0w3j9
         oeyF0yfh2Sk1O1FGWgDRNnIQi0IwGQTdsFtdEdEZ64ZKtCPidJlANEgMjp8cjjSLtJVg
         viuA==
X-Forwarded-Encrypted: i=1; AHgh+RqBCdJgDg9bMTgWPTXE8eiSd14rOjVw6UQrCEHMrrsyXQIFkIiEoaWjzGfAKna5cDEgqUxxwvA9CTAg+bpHkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIDvAsso7wBYCq7X58Dx+UDaacCkNzRIKseOijafI8gUcK91/B
	ITlICoZeK4+u45r2tBFOsEj3/kCih0EsX2mb4iHAZMoShZFIbSw/LcqG/Le4XtzwmKwciQDl2/D
	Lzp+mpqJ+Al91apMPQ6LHttV3p8WE0EjMHwFXtQapctytahDq1mBulFQvCtXQuBukRMhqeg==
X-Gm-Gg: AR+sD13gCNRwealgZZjZkTYXiuY7gz7iVXhBhAgRx8f5nkM0E/rwmJkWMlVKDwdrYl8
	bHMXmJMym2caaYQEBJJARwO8fXUIkZz9Oltgfl7oJArIVSB5eBY6hKSzprJl/AtO3EdO1fhIRJb
	9OkqpWllfCmFXoegEtumoVdty1VlDasft3lGFE+jQrTnjhoxN32Y/qKJdI/Rz6Fw84zWJzDVxDR
	ojh5Y6otTx8DChiczLzrJIR2jgURHWD2C/sPqJN8qOU1gLFeixrcxdXvRDVpYm2CYDrRqHFQOiX
	v9AluamuwKB5c9P5x53efIPpF5iyrYY2WDXwQcxjuKM50aBov2rTWdZwrTrU9aLJAQWkPE5wBTz
	wQ9SdeYv2gyswtktUxTQKaTuK3Mfhgde4QgUbPj2AoCC+BfW4bXXNjzfSUG7FsZPEpZQy0F3RqQ
	==
X-Received: by 2002:a05:6a20:4394:b0:3c3:bd32:4587 with SMTP id adf61e73a8af0-3c92a8a6b1bmr9375845637.44.1785746286750;
        Mon, 03 Aug 2026 01:38:06 -0700 (PDT)
X-Received: by 2002:a05:6a20:4394:b0:3c3:bd32:4587 with SMTP id adf61e73a8af0-3c92a8a6b1bmr9375825637.44.1785746286352;
        Mon, 03 Aug 2026 01:38:06 -0700 (PDT)
Received: from [10.133.33.236] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe39ebb342sm3302604a12.30.2026.08.03.01.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 01:38:05 -0700 (PDT)
Message-ID: <65ea2bb2-3396-4db5-8321-857a42cfa9e4@oss.qualcomm.com>
Date: Mon, 3 Aug 2026 16:38:02 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath12k: fix frequency range for
 single-pdev devices
To: Shenghan Gao <gsh20040816@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260715065218.41232-1-gsh20040816@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260715065218.41232-1-gsh20040816@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: PBiJ1kSrRNyObzgjQeKPYiBBGLeNmA8C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA3NiBTYWx0ZWRfX5uYw+6ZlxgoD
 ZHrxBkb1sbKn8jupNgUqK9g+eKJoMXAq/uvH4biI7gIsykhO3LImem1ynJl0tFRUQxSEoGItlEF
 2e3rq5PzyIliuu0fgEOt5xwdVc/zEdsdSXd48Qt00JEazStdpbLZnnUo5Fbcw6kgOTVH9x8G1KR
 fNU3VfayH17CzjKYGgk4eJtAO3mt16Mod1NQfKxM000CVYkMwRv6uS7NzrOMxOhzr//lEM8YOuM
 MtQPswNqYEp9LR6bijMYy055JYhiQFCiVi5kV/pQGU8fe55p7n+U0b/x33rc/1UJOtFiK8nLwpO
 zr/YDGglG7U3n781w+3MsavloDgFY/Mfe+aqbfDqR9mnvswKcbEDRe/qru2vlR+6EpHw84TaOOE
 61kuSZlWKrgP3ZVh1+LUrBQIHxgQgjbUfkXOgKl9ScXN/qjlgcbYX4t0ZueI2D//y2OxqwwF7RR
 VCepeKQzziIdOo89ndg==
X-Proofpoint-GUID: PBiJ1kSrRNyObzgjQeKPYiBBGLeNmA8C
X-Authority-Analysis: v=2.4 cv=PqSjqQM3 c=1 sm=1 tr=0 ts=6a70536f cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=ptET_oXVa2BxEO8-YBQA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA3NiBTYWx0ZWRfXwce5HAZvweCu
 Z/1L3P+ijcB3mUewEDjJUp0BbTlrVQwenhonlAeRsnEzgDuCBwVORc4uWr03FVYG5EUi4QU+ZAm
 TQidrAVy7pZAN02K1rAC3x3UMRzlo/s=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030076



On 7/15/2026 2:52 PM, Shenghan Gao wrote:
> Commit 0d777aa2ca77 ("wifi: ath12k: fix mac pdev frequency range update")
> made ath12k_regd_update() handle each supported band independently.
> However, it uses WMI band capability values as indices into
> pdev->cap.band[]. Those values are bit flags, while cap.band[] is indexed
> by enum nl80211_band. As a result, the 2.4 GHz lookup reads the
> 5 GHz entry, while the 5 GHz lookup reads the 60 GHz entry.
> 
> Also, the 5 GHz range is skipped whenever the radio supports 6 GHz. This
> is valid when 5 and 6 GHz belong to separate pdevs, but not for single-pdev
> devices such as WCN7850, where the same pdev covers both bands. After a
> regulatory update, 5 GHz is therefore omitted from ar->freq_range and later
> filtered out of the channel list sent to firmware.
> 
> On the tested WCN7850, the 11d regulatory update left the frequency range
> at 2402-2482 MHz and sent 13 channels to firmware. A subsequent 5 GHz scan
> failed with WMI_SCAN_REASON_INTERNAL_FAILURE. With both ranges combined,
> the range is 2402-5835 MHz and 26 channels are sent to firmware.
> 
> Index cap.band[] with NL80211_BAND_* and update 5 GHz for single-pdev
> devices even when 6 GHz is supported.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 0d777aa2ca77 ("wifi: ath12k: fix mac pdev frequency range update")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:GPT-5.6 Sol
> Signed-off-by: Shenghan Gao <gsh20040816@gmail.com>
> ---
> Testing notes:
> 
> - Runtime testing was performed on WCN7850 under the CN regulatory domain.
> - 2.4 and 5 GHz scanning and 5 GHz association were verified.
> - 6 GHz operation was not tested because it is unavailable under the CN
>   regulatory domain.
> - QCC2072 was not tested because the hardware was not available.
> 
>  drivers/net/wireless/ath/ath12k/reg.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/reg.c b/drivers/net/wireless/ath/ath12k/reg.c
> index 89abf2e87ad1..c3bb1df2b1e2 100644
> --- a/drivers/net/wireless/ath/ath12k/reg.c
> +++ b/drivers/net/wireless/ath/ath12k/reg.c
> @@ -300,7 +300,7 @@ int ath12k_regd_update(struct ath12k *ar, bool init)
>  
>  	if (supported_bands & WMI_HOST_WLAN_2GHZ_CAP) {
>  		if (ab->hw_params->single_pdev_only) {
> -			phy_id = ar->pdev->cap.band[WMI_HOST_WLAN_2GHZ_CAP].phy_id;
> +			phy_id = ar->pdev->cap.band[NL80211_BAND_2GHZ].phy_id;
>  			reg_cap = &ab->hal_reg_cap[phy_id];
>  		}
>  
> @@ -310,9 +310,10 @@ int ath12k_regd_update(struct ath12k *ar, bool init)
>  		ath12k_mac_update_freq_range(ar, freq_low, freq_high);
>  	}
>  
> -	if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP && !ar->supports_6ghz) {
> +	if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP &&
> +	    (!ar->supports_6ghz || ab->hw_params->single_pdev_only)) {
>  		if (ab->hw_params->single_pdev_only) {
> -			phy_id = ar->pdev->cap.band[WMI_HOST_WLAN_5GHZ_CAP].phy_id;
> +			phy_id = ar->pdev->cap.band[NL80211_BAND_5GHZ].phy_id;
>  			reg_cap = &ab->hal_reg_cap[phy_id];

seems we should also refresh reg_cap for single-pdev case 6 GHz band?

>  		}
>  
> 
> base-commit: a1a21995c2e1cc2ca6b2226cfe4f5f018370182a

