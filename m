Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15801352022
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 01:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141584; cv=none; b=MLIQCoGkjCYP6j6ievmnFPhDuEW/eMeIw0MbIQxvg+zIBgzVQAJGDgTqYwsd4o0Mx0AUn75NNBlvWcIYy5prVAePot/k3l+KYFoAjOhHCFPbkCUcinhZznf7KIVNGOJdT/ZdXT5vv0IkCpP0/P2IcRuS0CT4hJmKcqoF7Fp5lU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141584; c=relaxed/simple;
	bh=AGfDsr/pVkS0OEQwOOgN7J1EQurirgN5CnkOpjH3004=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q5OULepmuv6TzsphSZU+C910mLdVphtz4tiZfeZ/PGRL66y/lK0JODS0uN9rduivDTzbs9ARQo6VuSvKW0PXTILO2KxCB16c4No9z8UUtfNeHcPPGGQa+HliR5BE+BQIMKuFb77kryE/imkexpBMmwM1vpyNTEwjFuRU9kIf+U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fceX2KwP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dt0fehA7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fceX2KwP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dt0fehA7"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V1bfD62240887
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 01:59:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fNdgbq+Ke14WYouyaldBldt5vSdQp4sGRK5KqDVJ/0Q=; b=fceX2KwPMT5eQj3v
	XGbRTnLa6XwlTcfQq0ZcEtQnOi8i5LzcZq+co4ehgKYnqSG+MlkIj4G7HHP4/0JV
	/f715sxJ7Wx9ZRPDghQqUoi/cjtpFq4sV2I7E+Ln860Vl81AhGAOrJDU2LmslrSQ
	6RBZjrNFNQXqUU89KArCpPCGxdAeAKKFxrprXEk08R90Wn+YPz9PLMXKyYd8pot5
	O/OQF6ejWukY9KAyisNdV+GDJvuHG9Bofq7eqY66uGcDrfZXvcBbn0EPeWD50D3A
	9VzjxZuAfgUaOxS5L10GyUprR+EtZt9eO4Bu3BKMtvvYmE2W9ZjDbET7FSxdkWUd
	Vtwvog==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gbqhwc5hn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 01:59:41 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc73f47bdcso35385145ad.3
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 18:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788141581; x=1788746381; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fNdgbq+Ke14WYouyaldBldt5vSdQp4sGRK5KqDVJ/0Q=;
        b=dt0fehA7job1BcnZUI+gL4ZhZN+EfVLjORj+hMo+0jMrTZl3Ig9BR4WiATqnEhp9ps
         kYlTL1H9qRSGlmH60CwDx7tRPFQdbq8RbTbVVcbkULs9lIo00sI2gJVJEvKAC5Sq/XQS
         Xx18Gx/VjN+4ucQtO86xkT75J+QTw9eDFiXoniE/lL4mV5095iwguE7bxpQipq/FBIeJ
         oqwYTgHn52ceH4JDybmsyDT0hteLIgyjiDiSULea751plZ4sXlY5XerDeZOMcUYTAJuW
         tixpB7SxuVU0qjq1+9UDVwaZ94Zm+biLDMIiKxkIxcoZnkxEiUdte6vTdl2N7Sjma0hk
         LySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788141581; x=1788746381;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fNdgbq+Ke14WYouyaldBldt5vSdQp4sGRK5KqDVJ/0Q=;
        b=X0W6Oym2LyiKLh5p+SuOybTp2Q2OQe0oVrsnT+eZChl3XJRdDCMhoz0w0FuHZaNmW8
         y+mivAmSu3lwCydCfmNc/QhYtS8iDPIynIPULLjMWQQ1yxxXJXv3ikZy1xszT1e4CWXa
         SUXgCdzNS1I43Ejoqr9GWQ7hM/3a1i+2nzhqrXOXdsRvkRSXDv/yobSSHnGDchlanfbD
         or47lpyf5ZPqldWwuobHIChR6moiswMxsHZasDbmUPumQ46iWSHshW9G6qkHHmx4N+OL
         tUuQNZb1aktYKqW05YKDv+Lha/0YEkVW4+bdcIIGM/oQph3CLKXqTu6MK9UcCySH/apt
         JkMA==
X-Forwarded-Encrypted: i=1; AKwUvBy74aWkLl5VitKQp12a4dqO5lam4bG7npNweBEKchYMZ6jy5BqJuik7BI/nFae5jxRHiFzRC0n3vPmWxABdPA==@vger.kernel.org
X-Gm-Message-State: AFuF++nm/8cmf+/S6FMPXiqnt4aY4p2ExLtxwz7b3IiTMG0cnXeoCOhO
	aCbCjcShVNyQ7ufjLOzQ2itnfyBWpfZ2yHcfU8m+gI5b6jIBoFL8SnGu9smG12qN08uBg0Md+88
	jcxS7KX84IX9DUlVG6ZfA+Yhlfcnq6psR5VkHOcLrLuz+wNbILpvzT33vr9d93HI/a6Ne6w==
X-Gm-Gg: AYBFou3Nnm7FCcprf5vUXG0Q0xHkpD6NQ/qe1+077grOInFCsyvHem9FmFzRdM3/6aP
	lRuZk0ekIYRgrZtU7DhIz2E18cSJ47n1QdiEGOyTuXKPX3jzZ+0SFnnbcaXUvTW3TmUBiCyb9QA
	xEkiqkbKPyKL8hA/flaMCclr3ANVQcNjjzRY4YVIpNgTT9dYlPsQqvrv+xiY50CWeKW5CnVc7wB
	EjiyZPNOyk+h8YrEo5zha2TdxNlG0Ac1GCdNZvQMZkzVqoHW1bMRLO9O1d0DO9eI5z4S2s2wbZH
	qd6LEm9bP1bQSqUv5YPkDzIRexWEVHStPAMvptTSUrgjxdTd3pgP453TTdEmXLcJ72pW5rwXgQV
	PL3Q+4wrUi3YOspHu4v/4O0KXJiKD5sI=
X-Received: by 2002:a17:902:f70a:b0:2ca:9d5a:8b6c with SMTP id d9443c01a7336-2d93f924498mr2677105ad.5.1788141580938;
        Sun, 30 Aug 2026 18:59:40 -0700 (PDT)
X-Received: by 2002:a17:902:f70a:b0:2ca:9d5a:8b6c with SMTP id d9443c01a7336-2d93f924498mr2676625ad.5.1788141580511;
        Sun, 30 Aug 2026 18:59:40 -0700 (PDT)
Received: from [10.231.194.200] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7598c155fsm27355795ad.80.2026.08.30.18.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Aug 2026 18:59:40 -0700 (PDT)
Message-ID: <4f39d1ba-c41b-4add-9c7a-80d4eab42b73@oss.qualcomm.com>
Date: Mon, 31 Aug 2026 09:59:36 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2 0/3] wifi: ath11k: fix QRTR readiness
 related WLAN initialization failures
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: FQawCjyy3QiVtq2-n1FbJz_zPyhwLLXD
X-Proofpoint-ORIG-GUID: FQawCjyy3QiVtq2-n1FbJz_zPyhwLLXD
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDAxNSBTYWx0ZWRfX4Ne1jUDmhOpY
 Bl7yuyR6GbzwYFuY4cdLww9bX22RFkWvUsvsmbogvmXsjYyMdsE+HmdbCqeDBv9RxQOT2oUlqHT
 qxvRpkkDL6J4EPki7H3gq1XjPXoDMIA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDAxNSBTYWx0ZWRfX2ahripwnpqYJ
 pji8BoPOEWzqWj4iRysQy6koCPohYwvCq/q5+sEbCLPV8GD/9x5kAzgmEte5BCtc0K+RsOGqOHo
 fvYxFj8aLwRNyZoNmR8FkSMII/MQhCOgFjhEonOm9Defs04X80jg3i7zkCU/xMsYCgl0U1Q0sC/
 68WEApukIRz+0FO7YcDoHNHKhy7Fiz3tXgYIt1GBPms98Glv0msCXEVDuFcRwYfxdklfD8P5jNL
 MIAKHTgmH0xVJFN5LMgY3G4pEZwioDWvvfo425JW+7MvrnFHlAyPCxcSphEt5M+A1NdlofeTUxw
 cpYiQJWnDZyGXuWwNLNSrTMELaLf9onhoz4JIW3dvWHugJY+r23FeG7h4BWVoXHwoh0etJYgbDG
 QH1S1JTGqWiFWc3hwkqAfzLEZbwId22Cs9OG5JTsZzZINHdZ/IeA6tg9t7faXOYzdkJ9tAN4e8Q
 ELU5oS7A0HkqgOEqOMQ==
X-Authority-Analysis: v=2.4 cv=YKKvDxGx c=1 sm=1 tr=0 ts=6a94e00d cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=yeVnTpnW9Av9R37Qzj0A:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_01,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310015



On 8/6/2026 6:13 PM, Miaoqing Pan wrote:
> On WCN6750 platforms, QRTR SMD may not be available when ath11k starts
> during boot. If QMI messages never arrive, WLAN initialization can stall,
> leaving firmware running but no wireless interface created.
> 
> It also hardens the cleanup path to avoid crashes when deinitializing
> partially initialized devices after QMI setup failures.
> 
> ---
> v2: Replace the ATH11K_FLAG_QMI_FAIL guard with !ATH11K_FLAG_REGISTERED.
> ---
> Miaoqing Pan (3):
>   wifi: ath11k: fix sporadic WLAN initialization failures
>   wifi: ath11k: fix NULL dereference in ahb remove when QMI init
>     incomplete
>   wifi: ath11k: unregister PM notifier on QMI init failure path
> 
>  drivers/net/wireless/ath/ath11k/Kconfig | 3 +++
>  drivers/net/wireless/ath/ath11k/ahb.c   | 7 +++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> 
> base-commit: 0ece44d394570806e97c8471a50dc9f584516ef6

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
