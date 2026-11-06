Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793942451;
	b=AsljnlazzYgqF/0YY++C4rk/U4gAQfc0LXM31VJXg0qYp7AtPbXura2v659B30SbdljQ
	 CG3wkUEpP4VkkMUGjsSuvMJFLc9QNfrpcW0H3DZjFCUCojH6k5VnqT81JgClh6pJyIfWn
	 +eb1Jc5/Wb3PhC4+8Sku2XUcmChVH3Ku9ksmtnj2itXVnX9NvkglufmrFdZCDD5iptirE
	 tyA6dEkGdB9WHUzvy4I1TNifXqBO63uatYcOVmLfikHkh4znNzrykFEbZ6qzNptsoVP75
	 lxGFbfWmi2LlLw7h6iBndtiL3R5QtBGPg7nG6G/2Gzz7LuKEgGEIWZHtMV5qMjJ+J5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793942451;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=s5r+/GLirXNpsiw8EpW1qS4uEOkcFuBUgn6AOzlYOS8=;
	b=uttyHaw3Ynm7vFRzdsXtuUMIcWbfVJ9t2z28TIAlGXIduqA/swps+Eob6AXXaNKofKGy
	 1M/bOFj1M5SC28S3e5UHcwYxxT5GbqpubA+EUoZrgf295DY4HMiO3fD+Rgs+BMAjBF4XX
	 kwZysgJbeFbcAxZ2RURls8LZawRI4ys0kkBOTJiRA4MgWdadR38dCVnu204yzSftsBvAY
	 aXFEFPLdVSswyIeTHSTy/vJyqweYiHmgzn4VDE9fIWUiFwQAdICLyNN1fLDPN7pih7ikB
	 9pSnTlaXzCsAKpigZJuHWCOL6QXVMOzEu1xfDRze6JfYfwBTFhD3KqTLEJ4OxrQEGrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ehX4aPGW;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=d2Nv7X9R;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62BD606A31B
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 05:20:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A62BD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ehX4aPGW;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=d2Nv7X9R
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6400aq3439421
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 05:20:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	s5r+/GLirXNpsiw8EpW1qS4uEOkcFuBUgn6AOzlYOS8=; b=ehX4aPGWJA4S1X26
	cEDcWAEDBtkHRQBFnGnSdpcDPltUjxyKCDOFthte90TZ/C2v+I4/VEDNAcTWgHB6
	tFBpjeAVrUyL+2hI9tHjPkzniOJmtduxrTim9/km9aLXxNkosdZ+F4/s+w8+nEq2
	oIOKPHGw1KjWEYH+bcqteuJan+jUMK6bdzmrh4PTvJnjisPn8ypgDTkM/orHVhik
	1Qz2qJRxWYf7CanYaBitOh5DxJTH4MDjKE4TaxFTeoqO+p/UFjB0r0pVAW6/bmr8
	7ooHnCO3ZnVsaFmIY3nhyY+vwesTGDupda0BSZRoC7TX31aNCW8w07hMIEb4LOux
	VARBlQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pas251-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 05:20:49 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e9995cea88so3469865ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 21:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793942448; x=1794547248; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s5r+/GLirXNpsiw8EpW1qS4uEOkcFuBUgn6AOzlYOS8=;
        b=d2Nv7X9Rq6nqvAiXPSZ4FwaUxrNXWtT0bOSxUb+obA3eI58i8Wsvw8ZcvNcfdvGX1T
         rytfZRCCrR7J1fabDJ1+RR6RCEmyPx3CLlX4Z6nZq7s5BJhMc2BM6BszikCNeZbGJZ8y
         mqjuyxoSNRVJODt/T7TL7D7s/7zXZMLDJT1PqdWMTniqHxjk1BjuzIhMcsRPtzUQzyF2
         qUA3tDOK1tuDAEMcO9XJjjJ7Yii6m5cpvf/re5wiYKJbRQBxGAwbnEwVVsJ7X4i9KqfX
         Kgsf7ClUIj0u0WQ6J+bxq0J0ixCd0wskpSpmNLH3onUCbfOyhwksNRTVXVT0IDdXgscm
         CWuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793942448; x=1794547248;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s5r+/GLirXNpsiw8EpW1qS4uEOkcFuBUgn6AOzlYOS8=;
        b=0O5LYQXhNrPoyG5lvrJ04Y+DZ+vsC+tUuUyda0A56ecfrijQb3ZljwPhC+SFJaqkge
         t9Te5IBzkqDrHudB9lWzjaqtSi1pxX86PXqfa4Yiq0SMa+XvX45Ti+6y3cf//45Kow0V
         IOo5WAV+HPfLRkTjITqUegk+glMFxD5IJbLa5vSC9oW/9VoG/CftmgoainyTGjAKwUEF
         WtLyEGa3X4ctTqpJ1pPoSZ2xfA3/TY0hnpj5z8qmOs69buifZ6UP7UEdD7EwxXbI9Y6f
         w8vdhi64NK1fIKWAdAi327LInyXwopkcj4vXgFJK2f2xAER2yY27XGzEN5fX0rvFy8DW
         AGrQ==
X-Gm-Message-State: APuU4Z8vUG5MYDo6fWsb3lo8uQE+0axBZ61ubX0jcxrDcY+bWnr5nDDU
	egZ4J2niZZd1PqnBr2USXLuxhmMrXmFnA2yUh3VPf1TGJNwF0GmExfA6qL/R6zrYKJ5+3UKdiOc
	Y+3AnSKvsRVqkE1Cx+572FSN6/BTNiTsBA44vU7le10g0qQhyBBQIQlsUOTfOtEwy5JGNcQ==
X-Gm-Gg: AYBFou03WjkyvHZfCQHuumLNxHX+DjZSxCg+Yoe+iuEilCFfZoyeo5iF1q0ZlzSuuuE
	zAUUlsY5QJmbzIs+HD0Jil2sDudZJRDTiDeG1vMkmzEnvVzPffOxpKv8j6jn2SwCof6+vxsfLCO
	vs52ZS422TzUI9vGcMgij6fJlVIRrH3clujedWFs2RLuOWnZ736EYyIL7GiXrTlrx7aWxCEYqKt
	FfpyDsJwsntVeSMG1phMQh9HLXeVBF8MnZbuqkfQ94lCZW2xNueS/BAjcqdN2wQNUF2dcowbCfL
	B06lXl8oj3uV1HiHy2CMmkaT8rOoHyNDShvd/Zrv8kfyXhCrTchKX8EFQ1bR0Zs8mgFEw7ETenC
	JV7MXkc5U0FVJA7adkV2J2RxW+w29J6tBtjeHDLxGdcjot30Urz49LgOL560NP2M0d7rq7wTObN
	l2jA0hn1Iwu1nO4N8oxUHuxzV1bKhdFHkULvV1b4aIGWEb
X-Received: by 2002:a17:90b:2891:b0:3a6:f1d2:57f3 with SMTP id 98e67ed59e1d1-3b0db6ee368mr1285352a91.58.1793942448510;
        Thu, 05 Nov 2026 21:20:48 -0800 (PST)
X-Received: by 2002:a17:90b:2891:b0:3a6:f1d2:57f3 with SMTP id 98e67ed59e1d1-3b0db6ee368mr1285334a91.58.1793942448014;
        Thu, 05 Nov 2026 21:20:48 -0800 (PST)
Received: from [10.133.33.112] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0d7c8ff96sm1769378a91.13.2026.11.05.21.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 21:20:47 -0800 (PST)
Message-ID: <4d530236-bc44-4d01-9589-08bf715d8eb9@oss.qualcomm.com>
Date: Fri, 6 Nov 2026 13:20:44 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: Fix HE BA mode and extend
 buffer size for EHT
To: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, Paulson Raja L <lraja@qti.qualcomm.com>
References: <20261106-eht-ba-window-v1-0-622f2272e582@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261106-eht-ba-window-v1-0-622f2272e582@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAyMCBTYWx0ZWRfX0J2yDsD1Sh1T
 qyBD/B9FZzWXONscWLoilAfF4tmM/b9eXNc64j3MrDrbgl+OVv9SNb3DP84ZuQNlXZZbUCKhkCi
 USotsb35l0sNWS2p0qXdw8mzxikYfsm51hm+zeKchuM1iBSqn958PoiNXftthqvA0a9Y1cup72Z
 yxkUtLfL0ZJgtgop1YpzGSd30eh7RmElFNdtuTztTBvfX7mDu5ZcJ9Uu9YVVJ93QKTMUfJ91qyw
 Zw3cc28FXRXQBGPWb1qTNKwmmJIu+vlnPxfD0SCHMtQiSsAB/0aaMMWZzI3u6blqaAYzUfM3e/x
 Jy5peR6nErWmQTQl//z/VXSPhyF9S0J5Bn6WXWNzwWC/nXzhSnlGIAgky3E7KX2bEkIsn1HAfG2
 vw9ay1Y6qnYw2TNy1oCcCqqjmtUfF/t1cAltkCi0qWSnFJW7/QatCQo43WYdqw6p3+3O0ReJw77
 XMPpccoTVeYuQhtGlEQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAyMCBTYWx0ZWRfX97t8qfNMLrK+
 znFmMdMWZWxrujClOmBdFSa884kTFS0m4AoofKNrRBjcpGDLnzxUYC6HSnQByJy9el5dQSwlZgE
 0dHK9hGI2QWGBoBhOwXTTc5Uo73UIgY=
X-Proofpoint-GUID: iPXchE8cUMcPPHkNnStkBkvqNyZgXji7
X-Authority-Analysis: v=2.4 cv=P4ivFSAu c=1 sm=1 tr=0 ts=6aed63b1 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=qSRq8I4OGtnwRW6ma38A:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: iPXchE8cUMcPPHkNnStkBkvqNyZgXji7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_01,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060020



On 11/6/2026 12:57 PM, Rameshkumar Sundaram wrote:
> This series addresses two related issues with Block Acknowledgement (BA)
> configuration for HE and EHT capable links.
> 
> Patch 1 fixes a bug where WMI_VDEV_PARAM_BA_MODE was never configured
> for HE in AP mode. The existing code placed the BA mode configuration
> inside the he_oper.params check, but mac80211 does not populate
> he_oper.params for AP mode, so HE AP links never had BA mode set.
> 
> Patch 2 builds on the fix by enabling 1024-entry BA buffers for EHT
> capable links. IEEE 802.11be extends the maximum BA buffer size from 256
> (HE) to 1024 MPDUs; without this patch, EHT-capable links were limited
> to 256.
> 
> Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
> ---
> Paulson Raja L (1):
>       wifi: ath12k: Extend BA buffer size to 1024 for EHT capable links
> 
> Rameshkumar Sundaram (1):
>       wifi: ath12k: Fix HE BA mode configuration for AP mode
> 
>  drivers/net/wireless/ath/ath12k/mac.c | 41 ++++++++++++++++++++---------------
>  drivers/net/wireless/ath/ath12k/wmi.h |  1 +
>  2 files changed, 25 insertions(+), 17 deletions(-)
> ---
> base-commit: b9acb873d035fccc8824164246535ea6fc95c71a
> change-id: 20261106-eht-ba-window-5c2df1a8e910
> 

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
