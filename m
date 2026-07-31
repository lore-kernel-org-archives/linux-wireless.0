Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C86D331EA8
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487927; cv=none; b=tTUYuUb+3pRHyL3zg2nD7z3DBx/LzzI6sYEUJDSvC64Bg/roUInaGuOaQHM9op8AxTmF8H8TwMQ40DnPJ0LmaR09aZKWEejlKTxlBU3A6MMVqT8JW4nL0ssLmWpX5TXNPmGqUivhpfZ2rQiK+3dWVNRVgieTrnP4f3oKuvuzPnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487927; c=relaxed/simple;
	bh=zJKGh3/4zvdTnjbAcx7/fhi26dqXzT1UA4ffJVHIs0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RZyIdvUmiqXrGIT92BB/VC+azmufxz6F186cUYpR6SAbKEMBAIPbXwLOjtfBsomiJxsqDwFkTt/222zAYbA/lJ11kd8nQ8lv94My0qlDjTrYpOR2vX3Q+h+iHxP3NOWynDi8RY1gOP/K9WINFYLtFnjylndmqIQW/yL/+4J9DtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iYbSb7jv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FJZ/s/0x; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iYbSb7jv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FJZ/s/0x"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V8mnEH3993345
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xl5ePMbIiG1ItJgNEqxcqTd1coZwPOYQkPqbXF90I1k=; b=iYbSb7jv2lru7ndh
	MWbpopBtz3bGkecfvT7UYVukzwjqm38O5poQtf/zoy8HNVTsWPGp9S0t4sAF4h+/
	2nQX+H+9AK8F93RTRjDbrEQrHbADH0y5/fVSfMG9LSJwRIk8znT73/88sS1NJrDW
	Xn3TAD68ia7It+ZnpqfQXhOJL91OQ6Fc+9KW/HKTC6Xl+dsg9JZ5K+DKTSeO8JpU
	xCr3IscLoGAFpbCO41dbNQLOv519ycep48GIAwx6LYfM38u8B57UO8LOsjMlqaAZ
	PaJ7MV9txUWU2UcRhrHEZmJsEZJ2UlOQSg7wTo+paxRucQBCLZT/J9z4EtJLvlDW
	ry99bg==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frrhar0dm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:52:05 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84e13b57b2cso1135483b3a.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785487925; x=1786092725; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xl5ePMbIiG1ItJgNEqxcqTd1coZwPOYQkPqbXF90I1k=;
        b=FJZ/s/0xJKjTKQW6CerWSPLAoSAL3Bi82ywv1ZM8/2jV1xu8p3nUxirlurIzTS34Tr
         uI3YC35zjn2ENvn09mkPFTLVWxZQwC8ajEzeUtShndHpWEr0w0J+JI888BJuQlg83IYu
         viZPayhiMU4myDo9GZUJSRWeKJ2eMAUwsO9fzK/w8CRfQ0TvRsw6TuuQNxkwgYwvHQ8f
         ZqqzRDwEBWbILMyRjbfA39pGkXjdcTNA1CkkwhY3NCNXUDg+FFjl7Knxu2/qo8ByNMiK
         lnSwLidqEhFFYGGKHk/UvzyYn4GbUxu8MLwMju8ng7x8mC0hC6D6RvrPrZTsQ+aHxvYu
         ZZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487925; x=1786092725;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xl5ePMbIiG1ItJgNEqxcqTd1coZwPOYQkPqbXF90I1k=;
        b=K/9HwYMr4U4fBsNDu8gK4WmbVYbjWqTO3bllTr+lT4mwXXjey2TwfMdCW8Jf5tnY5/
         hLCQcC9w9CbqFB40W9wkqVebmSYqoEVJ/jJxbHIKVgiOfVtJXDaoIP9wUJ4+tPWPFZoR
         vo7NBWoJGrjw0o3y8Sa9UAcjYfcI1usPJvM3prviYUfSxBwuUYBjHAI8T50/qXuPeUnC
         KcNYt6dnsr+q0Hk/McYqSjf+yBHqBIa60DT+u7lS+JaT6jtRXuKdAkhjr6zK22udZEgc
         nAwgdR8uSGOuCcQYFg05Rohy966rVQFzXBkZ/1tGVoSM+vo/34mppTXnuU+a9zpuDvdC
         fi3A==
X-Forwarded-Encrypted: i=1; AHgh+RoxUlPcBeeofTOR4nDjlMk1ROYxiwqLle0MD7jC2gOgy+9sDRI8TULCHmvgGhwGbbIgpVa106CZeexmNkPHVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwTR2i0U9FT98xOETwF5T7gHvImaRKPQct/+Oaf9IUYsCQLqwly
	KHVPUrh+UPnbgCaxH5qWIXJEEaWzZsBTzRBFuPjHTZMOkvG3iU0/MHrxrkyHoGmPyzwVRoXDm3O
	sPqYCSigceYwgxiN8LFK9tpJ20v1uMMud1+mqK7IxaIjoR8IH873ZyYQUAIVrZQWfzjhhjA==
X-Gm-Gg: AR+sD138RkIuyrIAGV70Xv923PwikLhM0zD0euUDB84KUTghNKr700TM2Xlg3462HT5
	ftwyLcYwem9SqWzWCMmpLG9hjFpTLT2YaI+cwYKuKDwhElzjcy0WAvYx7rMI3+QeVYUG3En0uNQ
	rRHBuHSyG0rVvZ5Zi8j6fxjNxb8IpLxO5R8G3a62iKw3BZH2MepXUfxhZnCz7612rA4NkGYQhqZ
	ztpz+mN88X5PwuApXuBmXH/EZujz+Hni0pbkob0bmLWgKtm0iaWb/gALz768exQUUdS4v070ls5
	BgMUuBcq9Vzjhs1Au+EWasv2G1crIwAxSbEbLFCQhXjXLdq5Ltp+6M4pv3WzIRxmMW7tkE7rkLL
	/CLRhb1R5egaxEGuDbaq2jSxJu38FjrMVedaeTdQnUitFNgkAZBPg/OcPFfuH/lYwNf/Uf/Uatw
	==
X-Received: by 2002:a05:6a00:4fce:b0:847:df4c:40c9 with SMTP id d2e1a72fcca58-84ed719ee7emr1021623b3a.46.1785487925091;
        Fri, 31 Jul 2026 01:52:05 -0700 (PDT)
X-Received: by 2002:a05:6a00:4fce:b0:847:df4c:40c9 with SMTP id d2e1a72fcca58-84ed719ee7emr1021601b3a.46.1785487924655;
        Fri, 31 Jul 2026 01:52:04 -0700 (PDT)
Received: from [10.133.33.123] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc2d7bbdsm162774b3a.47.2026.07.31.01.52.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 01:52:04 -0700 (PDT)
Message-ID: <c07deb05-0422-4c06-af72-755c26ccf2be@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 16:52:01 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH ath-current 0/3] wifi: ath11k: fix QRTR readiness
 related WLAN initialization failures
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: FCFJBHl-QjFrCFrao5Hnw7G4yVxJ2dL5
X-Proofpoint-GUID: FCFJBHl-QjFrCFrao5Hnw7G4yVxJ2dL5
X-Authority-Analysis: v=2.4 cv=DvdmPm/+ c=1 sm=1 tr=0 ts=6a6c6235 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=Jsd1VwQIYPtyK_QoHY8A:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA2MyBTYWx0ZWRfX2C5Ors3cdB2e
 cgGgo24PvOejLpliFvw3TtHEOYtwz+tMWxwJ2cAtjRWAbaf8f1MZT4r8tUPMwBlUuLSoVbHfE4l
 7zk7BMwNiQsWRykv6n7gysgJ0gSNi7Eokj5sTyUcEJbymXEE8SGAHavUFI8m6Z/xaPrZ6/WiX2+
 lwjMSiNPyl8lEURFBDjPl4EF3IXlwB8rimxwz7ZiBa9E7Wnryv4jVHUD0HZQobACtgjSTSDoAQS
 HHCR28m2WxDTuFmgONhkg7ReuJSSGOVTKYPiAZNX7jrJDuVy3mFUQ1wbcTbfcnSZ2+YpAsOuwMD
 lunB8Lu2xKbOXRUjRe5oZ8eUrNdRCW6si5+BbnI4e9UPeANl0jEO+0V3mI44lVJLT1eqG5WKAH7
 VV32L5ncPh/pRRp28hO6+GhPYBmIb66q4RSK0fgHtWMO/+ybnFYiZGV6aBNPLfpx9WS5UAKM1vU
 1saaHUqgVhjJqvpkAww==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA2MyBTYWx0ZWRfX2HdrjT/zEsfz
 /y3mB8JzW0TdTq/2XLMNpYpBEq/6qTbUHr3iZ830kBXSYkyO/EBcS0MkAoNuSwB3pjpVqH7ct2f
 jvS0VnH/tM1DGe4sSy2bDd/sauaWlzE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310063



On 7/30/2026 11:09 AM, Miaoqing Pan wrote:
> On WCN6750 platforms, QRTR SMD may not be available when ath11k starts
> during boot. If QMI messages never arrive, WLAN initialization can stall,
> leaving firmware running but no wireless interface created.
> 
> It also hardens the cleanup path to avoid crashes when deinitializing
> partially initialized devices after QMI setup failures.
> 
> ---
> Miaoqing Pan (3):
>   wifi: ath11k: fix sporadic WLAN initialization failures
>   wifi: ath11k: fix NULL dereference in ahb remove when QMI init
>     incomplete
>   wifi: ath11k: unregister PM notifier on QMI init failure path
> 
>  drivers/net/wireless/ath/ath11k/Kconfig | 3 +++
>  drivers/net/wireless/ath/ath11k/ahb.c   | 8 ++++++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> 
> base-commit: 6776197cc88d0d397084bc47bca7e983017cecc2

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

