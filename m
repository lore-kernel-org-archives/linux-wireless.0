Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B7E3382DA
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 14:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557123; cv=none; b=aj1BWSLPvHtkPRg1vsinHXp4n+r46sGdZQzafhy6HwdND7H3eYVk9fpSnM0ou8MVtZ6FuP71HCrSgBYL7qdVrdH4Dyt0V6AziBiv3dAmZHbJBxwtIkHUABaZVAmNmOhj+he+BNvwzIbIpJA8W/8NYGX8/Ss+SbjEC2WEgL79w1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557123; c=relaxed/simple;
	bh=3M1iJ31pHBF1CZqNyY7pxqgdicxYGWt8HawVhs52VXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=blinFIxd9QOakb2hWfBwS/6mOBo8TKT4hJkP4zX9Yh1cteW1sh9LABLjY2kKiaAvjAmemloXFz6873R48LetbV+Rv1U9oJFGVQ4nh3HOaCrkW8tzYrFEecOpq8wyLkWJ0wa379/cDK1c9thVIGb4h9zrDVQveIp/dj3+pygmm4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IikOdLpY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SIwJVdjX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IikOdLpY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SIwJVdjX"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699DKZiu1061108
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 14:45:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fF0XFpFenZbIc/Er1V55JyxWsHMotKBuTpeuIL22FsI=; b=IikOdLpYuSsGUZmZ
	A8gPH5ms9LeZSRP3WGtlQSZW32lYme/ggWnT0zUvKiSJhP6B17DqeUR4sg0T+fge
	WFMHHk7VZz52+CEjfDH13IqVYU9O0bKfiuayyEgyD09RxxDHZNXWve09JTu48aBV
	T6/64vM2jx8CcnupapZRgs2S84Xyvd/AeVxN/gcmSnLCOY6pFq/66rMte4Buq6rz
	uD863wyso7o/7iTr9D4jXE3rpj9BgRmXRGY5a7A1swGSnLgVouz8Slgfot0l9AXS
	GWKb0tpgeofTnfiSmmXaGI7ccVyD85kWGeCFB0Jd1/6W2Y49lwC6KVm3di+/ouP3
	Lo27hg==
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com [74.125.224.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6fxk41wp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 14:45:21 +0000 (GMT)
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-66c70f5abc2so6850366d50.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 07:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791557121; x=1792161921; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fF0XFpFenZbIc/Er1V55JyxWsHMotKBuTpeuIL22FsI=;
        b=SIwJVdjXBm5L9i2aYMCj/yihoKGPtqQ9VA418ywVajAcO+TO6jKjaK/nC8dWaclPCf
         x5FmuutNX9ZohiwE8DBFruDOiBpfzKg9fZL4c2E0gUHpS26yPmZTOO2ku55j/4LihE/i
         lFN5XLd9+db3HelAV0RXLXojobI16HGh+SZArRZfAApPBlLWJ2ZJGxaNIf/d5VYH0PPK
         AYTJFH7AkeSxNV2Acs/EEMz8dkshk/qAd56PYQHccuRV2E5mb8aEQSqBUEA0eorZzDOB
         SuHJTB5mWT4V43KW8rLwygJ7ZBt60ftZS19BXaRw04o3e+8a8s4IHFdy5HM0Ar13aPTm
         ATuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791557121; x=1792161921;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fF0XFpFenZbIc/Er1V55JyxWsHMotKBuTpeuIL22FsI=;
        b=vVEg6HictkM3L2tNKmyMLrEWmMKjLm4Pc36Uhaayw5APP/KKsGRbqZdvJ73tbDp0N2
         w/YPZ31M0ckJqjSLXIEXbzN+tIe2lzvqInYW+KEBGUB0+BDHDrAQlUsKiHnYDjAk3fiT
         RtTh3s4+Q6aQRXNrXFtanYgri60y2XwfruaVEuIzpTMgzUH6zJmaa9Jm1hkGtHuUTBwW
         s1Ya4K7jBh5vBBwC9AQ1iodrg26fIymW4OiFwz98nXk+sCqRZWVM6GbjyuAsuaUpcMe1
         SiISf1xiXZicBbKfY52dn3w2rc0AQH3vZzZahg92NTWQKNkJEV/ZzGlonth0k+WbLj+s
         Jm6g==
X-Forwarded-Encrypted: i=1; AKwUvByw5hSM620mu84EEXLNIy0O/CuVN8zGGR6l4jSCf6kfSg7pJ5WlU68XByPe2vCIBZCeScWvFCqHuFgTLmSnHg==@vger.kernel.org
X-Gm-Message-State: AFq9FYL4JZOlGXBbPPDOL+jW4XTLePLKttoLPwkMuZ1K5OoKx0udceUD
	bZcIx3wRF16T3Nvoo7ns53vpM4sKVMWP8ZLNURnrBAwouXHG+qnfuY8fbyQbMnvp7kJtie+b36S
	A64V2IrfhvG0W+m2ZojUElSj+kv3ki4uzYajdgpYZy9750OynVZWDhYd20Uk7NIDTnFn+Zw==
X-Gm-Gg: AYBFou0CyxDa0+52243sudGBh5SAT3RiUoNCxwQUTtgm6ZIVYnE9kFek/WsrRZ0lQkv
	HCZvA7k0DdYdjSK8nx/B2DaXrCzfywg9O0GtIG2tWwOlRNbpPYsWUmlJ2+t0iaoCNQz/HaET7nR
	avKIJLqglSnNi1qTfUlmRosVH+3xnesjgoU0TQRMeBNSsyb1sYaO/FiBvYCPDbIKL2ugY78Tsnr
	sgRa15dmjnIdy/QeF/g5Nu5Co9WC/CNGIpIlSgtLSbKdXT+x72u6LqR9XGlfZenCTCRYwzCAfjS
	frO/h0GCi/Ds2Gjq1xTSyrTfbu4Lnly1JVG99wV1a0cWiZVmD+FbVoa1zNd/VDakHAeYLBc8Ip7
	ESz91AaIeeHkctcWM5SBriU3lK4Jr+6dk0AhPO7W5xY+9HYXHC7iPZ7jnc5Wm
X-Received: by 2002:a05:690e:b4d:b0:677:cf4d:a932 with SMTP id 956f58d0204a3-67936a08e59mr668006d50.63.1791557120584;
        Fri, 09 Oct 2026 07:45:20 -0700 (PDT)
X-Received: by 2002:a05:690e:b4d:b0:677:cf4d:a932 with SMTP id 956f58d0204a3-67936a08e59mr667995d50.63.1791557119750;
        Fri, 09 Oct 2026 07:45:19 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-679356deec5sm882429d50.20.2026.10.09.07.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 07:45:19 -0700 (PDT)
Message-ID: <0a30b3a0-6428-46ae-8e78-50cab4d32591@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 07:45:17 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 ath-next] wifi: ath12k: Add EHT capabilities to scan
 probe frame
To: Gaole Zhang <gaole.zhang@oss.qualcomm.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, baochen.qiang@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com
Cc: gaolez@qti.qualcomm.com, miaoqing.pan@oss.qualcomm.com,
        hangtian.zhu@oss.qualcomm.com
References: <20261009095538.2718979-1-gaole.zhang@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261009095538.2718979-1-gaole.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=fKesTpae c=1 sm=1 tr=0 ts=6ac8fe01 cx=c_pps
 a=J+5FMm3BkXb42VdG8aMU9w==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=CFmcTCT05xe6HR7D4UoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=Epx66wHExT0cjJnnR-oj:22
X-Proofpoint-GUID: A0n11SqayUEAh8hcu2YII10Keb0cbnUK
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA1OCBTYWx0ZWRfXz5TfXLzIUice
 Ul/dD5HRsfMEIx71Pd2Mp6HgOg8H5IENLP+KvcFTf5/P0Y5Gdi5XugWvzWplqEqqM6/NA5su27S
 YFH7bm1KTyooul2C2hIxVBVqTaOG16w=
X-Proofpoint-ORIG-GUID: A0n11SqayUEAh8hcu2YII10Keb0cbnUK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA1OCBTYWx0ZWRfX45in9LsagkqZ
 mF7F9N9PQaD9KWQtjnG0cSlpdMFDkcuuwsOekgm16xCfWXgefq6oTmgDBiE98u3OYtNAaxKbKlC
 FQ5DTckZybjTisvxV/sjtDxfRkju3T0D90PFIxzdqkyjEbi0qqfO4Nv9X4ih4w2LU1xOVwgsydq
 3+VDtGYE6XY0awIztYkYKPCz0HzbeP+JouKpxlU+sMXbliOEAUGIsBjky2DTr6XQ7quyfTBre2E
 s5jLHjRe6hK4v0SmlBPua0E3YroQjpmP554Pa2f4Fx49XlJMhlWqg7YefY07WdGOwZQyY8OQ8aT
 r+rQ5FvFNstnXJU35hTYHwKlSUBceySAEU0rW0jfkzPYPBgl+37Qz58+iVOA8CiURcOiW2dS6SG
 0YS8O1rHLzZn6I1oYjPyWQHAheicwJ6PtNg0rvrjxc09TkxUWmzJdEfrOYfwLXvdcYb5c655v3h
 tdxD9UrHrHZzGzdREjg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_04,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 clxscore=1015 suspectscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090058

On 10/9/2026 2:55 AM, Gaole Zhang wrote:
> diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
> index a98fc6e0699d..e7373a523dc3 100644
> --- a/drivers/net/wireless/ath/ath12k/core.h
> +++ b/drivers/net/wireless/ath/ath12k/core.h
> @@ -1394,6 +1394,12 @@ static inline struct ath12k *ath12k_ah_to_ar(struct ath12k_hw *ah, u8 radio_idx)
>  	return &ah->radio[radio_idx];
>  }
>  
> +static inline bool ath12k_is_11be_enabled(struct ath12k_base *ab)
> +{
> +	return test_bit(WMI_TLV_SERVICE_11BE, ab->wmi_ab.svc_map) &&
> +	       !ath12k_acpi_get_disable_11be(ab);
> +}

my review agent notes:
### Style: `ath12k_is_11be_enabled` placement** — `core.h:70`

The new inline is placed between `ath12k_ah_to_ar` and `ath12k_ar_to_ah`.
These two are a natural pair.  Move `ath12k_is_11be_enabled` after
`ath12k_ar_to_ah` to avoid splitting that pair.

No need to repost just for this. If the reviewers are otherwise ok with this
version then I'll fix this in my 'pending' branch

> +
>  static inline struct ath12k_hw *ath12k_ar_to_ah(struct ath12k *ar)
>  {
>  	return ar->ah;

