Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EE0FBE1
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 03:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785123441; cv=none; b=jn5mID21Z+vzLBPkK3gUtLjgfWjEk5nqmPjIgSHiTE9AH1tjicgtfdfZtP8jgTYDt5uDCPXQrG/1OIfmKxV+TsxVQrSdxL7uuoNAmBPlWNcQL2GhmaroCKmk3gXgimi9OL1hfLBfSPxqD7jQvTGoGtZd6VCmJlWnSIoQbktL3g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785123441; c=relaxed/simple;
	bh=J+vNtkLNS8J/3MFmi+bgoiTtCADVOLX6jxsijYOyQig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X8J3eDf9DCnhTeBbiAPAPwmh7km4GRRP0JFDwSNRVle+rjSms3IYMK37Vq9Pmo53HF8L9Z3+FS+Xa7riY8R+itA1TCSHboHLYVO8RykdRSIzAuRZVX0zf7G4caeY7zfvjuwdyL3LPJta/QxDlPqEKIRG0gmg22OEFeUPzzCC2OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PHw+12pi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=O6btJvz+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PHw+12pi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="O6btJvz+"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1g3ud2138758
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 03:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+z5V9MsYQEKUqO8SvZh2XP3MD4HqMBatOdE/2JdRgJ4=; b=PHw+12pin5aoPWba
	JNuhkL74FJT+9HGrZcnmgBm/0rG20umYILcys8Z2LLOryLo+8E7xVAqcqgEyCPdR
	V3VE4sABjWlfHV9aFaYnbJtaxQuU0Jh8+9s6Xzo1DAHWROSvXk3uxpHUwXsTXbqw
	rEOfLBzBju5aMKHBUgvWg45RHk4JxEA8nwYRbDRLcpG4rsKTXmNaCKsqUPkazbES
	MGek4PgJ0kTrXvHRKrPmG/ISiFEGAXhnUGX+cDNO7AKgHzI4UyiT1kqqy9lqIsF8
	/w/Pu0oVF9GduuuA8tdG8gFjV0VrdvYhstFExZcLLzsLQ2xez3xGWgZwErBFzp2o
	6Yjt9g==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmnh7vakj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 03:37:19 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb711c88f2eso1383302a12.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 20:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785123438; x=1785728238; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+z5V9MsYQEKUqO8SvZh2XP3MD4HqMBatOdE/2JdRgJ4=;
        b=O6btJvz+fhBqWK+raQtds7vdtYb6aEEBhaI8gevG9Wg0IdMAUjoqddWMGqMylw3I60
         QCCaPZCIbkUTHaUHEJnH46aqH8HpaCrELBKAAkQPdD0P+xPijh88szxZGg4J73ajIdK2
         ju9kReFUQK0AMSLKfBiLRpbwnAxPWEEBXE9Mfn9baa4igM8wIDSnRwHHTMM9h+jxkNB7
         ez6ubNxHRX5I3X+BW1iLvuQkI2seHovhMTyKRKcXuj75pSlqDjZntq3kqtPNIFMHHIBW
         KlCytn1Blj+HnRMtaXxIm2g+DsKB+ldpb403njcp1Iro7+TLli1FhSljUU8/mNv7m/CH
         G4gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785123438; x=1785728238;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+z5V9MsYQEKUqO8SvZh2XP3MD4HqMBatOdE/2JdRgJ4=;
        b=BwNqoB3xkNMHJLSviOKnUg0I1rKzO/9uvNh0wXkWNjEK1+CwQaRcLQkZVRXXSYE9yE
         0IWCw07T4ujWGNv3r4ZaOm2H6bIEQcH7/+rzBuR+EQNc9nFJKOWkkbkM6stnHFpyDNp0
         wg72mAft8fOhPSYS1uA6SyTgquRSl+Rn2OYajn5ON8711/u1VWbDI23WwhKTPggpkmG+
         sbmL+MnUHHVVYIiFrukr2Yc2GOFyjnLbd6+pOHmEC3/zCFGZKJHgvu3Opq3ixFJOKTkv
         Bydc+eUBCyDvilFClU4gDDCByg3+kmA2lwNAs5aONW4D6vqqA1bOkekirJqEKNyBAYt2
         TkFw==
X-Gm-Message-State: AOJu0Yzz2QDMHvDFtuANpPLSR0TsE9UM/7Ph97Eh8z80GgDFJKMhrk7/
	FgvZVKwosylouZKQBl8QvHWVr5vaiJcbSCJk53yJsARstEnwCBnunDz/cajz28f14rZTT9PL7Jp
	C6y7xrrxnT9OE7LFF/qI3CM+dY155bYLr5ddyu6uLoVj7MePQMRq2vuN4N0VSOkAyBM7HKg==
X-Gm-Gg: AR+sD12waS6WzgxkN10wxvPgARcIOLCz7UtrDzYuqejl7AVyvwNLjLxauDVm/+OoITv
	PaMwBplGmzqTCzBdGz44aCves387vUlhuZk8HcOtnfHUoP5JvnRndHCGh+H4AD5i71mDKvewCrt
	Oh226Mk7TyYySRgpePr96g2v3gKgCvdqvxwyxQchm0Qvu5Ncqt3cVmOSN9QW0+htqIjBPqnJa7Y
	owfIO3mJ7v1xsl1iXx+G/dnyW5gav4CcgsMWYutNa7nUIDLz6ir42AKY7zYMcQEv1HGlr4sBOjd
	+LtAmsIPPVoNZw7+wHBK8pU/Phaws6cfeGFtcU+lr1kgRjplWEG0Ne6btCbVlIx8FKIuzNaElde
	A8TG4bfO4vJoAwtSzSfFdCFaY+c/tjM8=
X-Received: by 2002:a05:6a20:a122:b0:3c6:3c5b:f2e3 with SMTP id adf61e73a8af0-3c67da4ba64mr6941919637.33.1785123438127;
        Sun, 26 Jul 2026 20:37:18 -0700 (PDT)
X-Received: by 2002:a05:6a20:a122:b0:3c6:3c5b:f2e3 with SMTP id adf61e73a8af0-3c67da4ba64mr6941903637.33.1785123437718;
        Sun, 26 Jul 2026 20:37:17 -0700 (PDT)
Received: from [10.231.194.200] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbbb6632810sm2561724a12.13.2026.07.26.20.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 20:37:17 -0700 (PDT)
Message-ID: <9cd654f0-3157-4c88-be68-8979753db282@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 11:37:14 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: add MultiPD support for AHB
 platforms
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: B2U9Ylv3BwKyAiWl7Ks6QDsvccsRF_iG
X-Proofpoint-GUID: B2U9Ylv3BwKyAiWl7Ks6QDsvccsRF_iG
X-Authority-Analysis: v=2.4 cv=f/54wuyM c=1 sm=1 tr=0 ts=6a66d26f cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=1E4GKdcwGqwKInFrMcEA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDAzMiBTYWx0ZWRfX/S0zpIAZMUlR
 1zPELPqBqt1tgBO6kCdl96kh9IHOfzb3edbu1JDvWsEbIVi6v6hRccfxfUKfWNngaZdoXxl4AdF
 0YE7CNSkQOlHezySyrrradzF37nYol1jWm5lq+uY2Ui7SN9CIPnNg9Urmbj/KHDjKgbTOrxOZIR
 dUF5iTi/UJiqwJjAOqKnxNUf7JQ1uhRpLLZ9gpluZyVKgTZQfwQClrp0Txppk7sb4jPnf1/EF+h
 x9seHVgzA0cVjgZoDfvJNVHeOvXVQ1h7Nk/oYm7xsWh3Sz4ml8mozxAAjQuJmqGYbiqMSNsm5Wy
 qgQk8TqTHZJzvOTjnndgOU1xh4BxWgeZE/Fd0LsswlZgIH8c1LkYhIcoBC5EBNvRTaFvFNubKjQ
 kRFGlIKqwVK/2QWdSBnoOYo71keAvEK8Uvq59aKmm9YMtSI2TSzlCj5oI1jIA10jtkkYyYOcbhu
 98D9xQUZUdMW4+e4J/w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDAzMiBTYWx0ZWRfX49Ygn7KVMZIs
 nWOKScb4Yb0ZQIpw5Bb4UR/XhQGp56HhiFO/ZvNj9R83Wtcd1IAjWWRdz8/F7WlmTPKybVoEEJs
 Ml1Nei93GnCDzbsUXp1crIwHwMmMzx8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270032



On 7/21/2026 2:50 PM, Aaradhana Sahu wrote:
> On AHB-based MultiPD platforms, multiple UserPDs can share a common
> RootPD. Each UserPD requires its own firmware image and PASID, while
> RootPD resources and services are shared across all UserPDs.
> Add the required infrastructure in ath12k AHB to support MultiPD
> platforms.
> 
> The first patch introduces a platform descriptor to keep
> platform-specific configuration in one place and provide userPD
> mapping support.
> 
> The second patch moves RootPD-related information into a shared
> structure so RootPD operations such as boot and notifier registration
> are performed only once and remain active while any UserPD is still
> running.
> 
> Aaradhana Sahu (2):
>   wifi: ath12k: add AHB platform descriptor support
>   wifi: ath12k: Share RootPD state across UserPDs to avoid duplicate
>     operations
> 
>  drivers/net/wireless/ath/ath12k/ahb.c       | 209 ++++++++++++++++----
>  drivers/net/wireless/ath/ath12k/ahb.h       |  34 +++-
>  drivers/net/wireless/ath/ath12k/hw.h        |   1 -
>  drivers/net/wireless/ath/ath12k/wifi7/ahb.c |  90 +++++++--
>  4 files changed, 271 insertions(+), 63 deletions(-)
> 
> 
> base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
