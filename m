Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E35033D512
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 01:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791510824; cv=none; b=O9V7ioSlkGCjQZSNi5e3LLvGeWranxwApEj6yB0x+Dk+Z01aLRF+oJA8yf8GbHSskWEKZa+1UUmLrtzeLuD8nbp87kAcy3579PrOmG7Fxj5KVxGz/l5KK6g1sJFFv/1eL3CfDkkn1uQsIQK5a0HgNTp43l6GfsYl5szBaDNQSKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791510824; c=relaxed/simple;
	bh=nVTCf9Sr/vq0ORJbBuTYbOI5ril/AeAbJy/T92yigrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n2WVMOMHiP9N0KJau+9QHay0swwY9hVYcoJEJtpgwD0DSu8uEuHUHbpR6Fah5ULEpb+AkMOodp6PIZHSjSsxvj4uv8j4ChdAchDOoaVeoQHTYK5SOKX8MFVvD9AdfsiSenxkzDZ5kcnnPEJ47c8VBH59GrGl87Ttg4lgpom5sEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hYoriRDp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J6hUA6hx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hYoriRDp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J6hUA6hx"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6990PaQn089102
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 01:53:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	RVmBYDxULmgBexd3mljS1XdVWxhKoPuBecD0X+dypus=; b=hYoriRDpkv7cDPRY
	qji4J6LUI724hUWhFWHG0bwl4XXTLcuQVl9OQkpiyy/xbsAowdPhvpdxf2GIxiq0
	V0x8bQpGTufaZEZtXmgjqtvqNxA3o3tq0PcI8VpK1mLZbl0GqasppaAdyLeYNn5X
	UcBc7XK8QXABAyl11m84hJSOiTZg91cFYqLZ1vBW57FiqS/9ojSJGLOubEqBxWtZ
	8c/FTyxdy768AXUS3PenFTFtsW86wYJL55SNoVhV1WXfdmX0KGrYq5D7D8VemXRb
	gOOWg2odUzAKMxecBo5YifCdnhx1pGOeq5CDUxZMrsnujI8+3MMQcBF357auJVsj
	JhZxvw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6b9kjk8p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 01:53:40 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc4216aee8fso6251652a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 18:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791510820; x=1792115620; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RVmBYDxULmgBexd3mljS1XdVWxhKoPuBecD0X+dypus=;
        b=J6hUA6hxGPD8iLuRLZS9/zQHQyesH5lpQdsJmMzrireKv87fygG+KmyhqldTevnc5E
         E+oHuQqU7IWCIE6MbPCRU80KeNmenSTJLP2n4NeINkIKYSF6BqB0LK/KYRzTXNRiIrbl
         xuQzq5+QMuZUH/q8ncwQ+zZaAxCpzDlo15VjPoki6ByyDqkD3CKtr1SL7FHOgfFTbvtY
         2L1k0efjjviRrginIXoIeGis9F/NDLgZcX4UZmxv0xPsnnJp4ofv2849QXHB9d/xgSIe
         MWEdtZAewHpe8t+OT5pFj77nISmmkS7pv33/tXZiBaqroFus/duVL/714m/o9y4TaGXB
         a/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791510820; x=1792115620;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RVmBYDxULmgBexd3mljS1XdVWxhKoPuBecD0X+dypus=;
        b=scNa3P99fkvxdDj7Jm/y+mXpS39tDN3lNlFZ9Wo9ZlCrEJ+VeOIXQVXmbiN4vl5NKN
         UG/hdHCCWq3g0NQD1xjLSl6mZ6WcxUKHQ/oZywM1qFtzXIfLP6lXCTvOhzkSzhl2K6x/
         jtqU143MOYA5dRJQNRH3JE4Vy9eRCZklfqJuz4h+HnjjRHmDUIA8ovOff68YgBctn414
         +PfEGgmBt/3fRgPG+ZdJj0JNUl29f/ClWvtlGEhH/iCvBIFs3rtBH3Xr7A/3AKvZQ3ry
         W87PPbKuYB2BMB0JvWHL8FBbO9j28aU8DR1XVThbDa0EQ5upkukq0VCjl3VmzrOGtRgH
         41TA==
X-Gm-Message-State: AFq9FYIqvZBx0gIv9aAAomaSnHP6tdRYRqvAoMY0TxDIVm+DzTmMqVw1
	a/9x1kF27YGCOg1mDSD8Xzn1lB7uCVipaZktE0qUwaYXBmaPdLTJ3A3InjB8mnhvBcicSn9fqrW
	v8EtJkOCGYkQgmEdmJDsXD/n/pxHXh6XJSAIIV+hooIdb26uVw1T4NEsRsU9Wk8vU9cAHBw==
X-Gm-Gg: AYBFou18FjKyKku9T6BRY6t4BHpxT35NZ/WbUOo7RpCHdAEhTGLsdVcBClmSDi4AC4q
	Gepnj+CaQojtyNd7oCVrYZoHWubJSGXw/ayeFcY3zpef2Eb+m3EcHQzWYxaLpMZzqcR4URYlVaq
	AiX/U0WEvNBvaJyRoOEWtWwiPucssuLuJzWuK5/XD/Xg8L/9+uXtshS1Jm/OlyyfvINccmIsQMq
	1aRKOgTg36cYyTs/zO4NWXHrvCl2N+YyVJFPl+k1qn2Ina9iTJBD1Ql3z6Vnfejwox2NryCCrEm
	hdP0zDDqrbaediEkchayiuRN10Sbg+pVsjf78n2wxqPfP6VTedrO0p2FQYYlHg4ckE39R2ye3GJ
	DDUJRB+/NWQjAizesQ6jlngccGqm1h89I4EkQV7C4tdUj8KHKNPWhpv8nvIyHy4ymPnmwQTVH
X-Received: by 2002:a17:90b:3b48:b0:3a0:2817:1fcf with SMTP id 98e67ed59e1d1-3ab3a90e82cmr527133a91.11.1791510819945;
        Thu, 08 Oct 2026 18:53:39 -0700 (PDT)
X-Received: by 2002:a17:90b:3b48:b0:3a0:2817:1fcf with SMTP id 98e67ed59e1d1-3ab3a90e82cmr527118a91.11.1791510819521;
        Thu, 08 Oct 2026 18:53:39 -0700 (PDT)
Received: from [10.133.33.26] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab3386ba90sm848786a91.1.2026.10.08.18.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 18:53:39 -0700 (PDT)
Message-ID: <b106f056-3384-4576-be23-590e57eaa829@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 09:53:36 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: Configure RXDMA buffer ring
 size per memory profile
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
References: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: l4ELMRfLK8xU6GcK4Q3_q_s4lKIGRrMd
X-Authority-Analysis: v=2.4 cv=U98Hnuru c=1 sm=1 tr=0 ts=6ac84924 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=PJ0sSsB0_FnI-LRpuPcA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDAwNyBTYWx0ZWRfX5XoB+gHC9ozW
 CPKRIBntQne6An3dm+aMWej8EyEOXAzvSPCn1M1U/0YkopU/9uHZCNh+xaWCi8g6BdiO06gSN7R
 RUEqaZ5oRAIRXpNEZyoCJ5FmmEXE9uE=
X-Proofpoint-GUID: l4ELMRfLK8xU6GcK4Q3_q_s4lKIGRrMd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDAwNyBTYWx0ZWRfX8of6I8DHgREB
 3xH6WN77nvVsxIoJ32urnRx4U1pC7mLD7gN8yPTQraLsHRwnbJjH+UZZrHfB2WCe+oqx6rxB9ke
 1ZHUsFoNcN70/tl9WLJnpOddx68r9+j3LHkXdcIQwJpr8b1TxdM0ddKP6pZxh19Ho7J+3RZE3i7
 jH04M7sydU5IP/9eUnHuH6M8kN2k/9f1k2c1mlMJUC0A4lSlKN7W0TGQSPDHhDOtEDA5hai9Eq3
 fVXP9k0JeHNYzIIKuSochnvYLNcGU28cNAd+Fzypu3DAOSKgKx1C2tvXlm/ITxJVDITzkw8PgYX
 5KfP0Hyn2otMaflCBWEA0bqHm8U2JFeYWI17ZsufOAV20PYGXVDIhOwf3xA07y0VshXxiGJMD4r
 IZ0OVgT5c4250J3NXlcuPKwVu1fkJ4ZkjgSRnlpip4QelYgh/xK7qpAuabKPao73oUY0EZxvb70
 WuA0bYX+1491WO0dekA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_01,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090007



On 10/7/2026 5:23 PM, Aaradhana Sahu wrote:
> The RXDMA buffer ring size is currently hardcoded and shared across all
> memory profiles. This makes it difficult to tune the ring size based on
> the requirements of individual profiles.
> 
> This series first makes the RXDMA buffer ring size configurable through
> the memory profile configuration and then increases the ring size for
> the default profile to improve RX traffic handling.
> 
> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
> ---
> Aaradhana Sahu (1):
>       wifi: ath12k: Make RXDMA buffer ring size configurable per memory profile
> 
> Pavankumar Nandeshwar (1):
>       wifi: ath12k: Increase RXDMA buffer ring size for default memory profile
>  
>  drivers/net/wireless/ath/ath12k/core.c  | 2 ++
>  drivers/net/wireless/ath/ath12k/dp.h    | 8 +++++++-
>  drivers/net/wireless/ath/ath12k/dp_rx.c | 2 +-
>  3 files changed, 10 insertions(+), 2 deletions(-)
> ---
> base-commit: a90ebf2176db07c5d91e0a62e15ded1fd50710a0
> change-id: 20261007-mpp_ws-a041d5cfac9a
> 
> 

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

