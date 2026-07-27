Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19B639A4A4
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 03:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785123740; cv=none; b=Xh5YOkt7mlrfj1w/LBGwIKLDADCW9MAeav6NP8gr26RoO6QAIZOFvE2l5I6AW7VlqsaPX4fjQUwDiq7gS5cr4aJOFDEME063gGWKbNoRc0N2w//ZOfR5WYbXJzJCOn+5X3it+I8Z6q/63ZfxHv892WZE2mD12BhShnNlveUfZmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785123740; c=relaxed/simple;
	bh=ZtkXinFU6yZoTmHOK89ib3Zn/KZmJdJ1dKDeorTdh8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GOj+YGtrJwaMujbHuMJyovvR410pscNJKiaugVsaRPCKZfyjGWZDyuUZEOj0/NUzICwRLTVPxUFVzwHdBvihwrumC8qDcQoKef43WVPUALmMDODL3nftfedymCD1RrX4BMjtUueYNnp9wnznBs0Tl/ysVW1binz3x3a3a8m1jPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZGdpYUJc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Jq1VSdwl; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZGdpYUJc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Jq1VSdwl"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1fj3w2381447
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 03:42:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZugYL0Re6FLYLg+SfCPuv2uALiGqd6hDKlaxGiHPCHk=; b=ZGdpYUJc9v5CW8D6
	wlLEAw8ZD14SwBmGbfrm9eVXnKDHkT4LBsfMpt+khS3xkZ1+xFb1XIS7KUqXnGk0
	J6+V87xDTXkFxtnoWeVszUcL7DwHxa5Ens0PmRP1hOvQyuNQEONRy9xDgZhV5xCx
	pEHynCb9K16uFa6FBwtfvTd4AoXAMG0NMelnzRG9+o6J5t1nfNF2nT6U+iIU6wyp
	PhYWADhjYLcRMlNVWM9+nOWaBq+xlUbZEVyV9Qt7iny2tmaPyt4/70ekY/gxFHaO
	wLi2ZJnrZgw/F5kjS9dGFXXGrVYCerr4ZQ04c1KYr5zBsDDaF/uuT1tuc+qpOdF0
	vQnpMw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmn7vcb2m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 03:42:17 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cc5faecf01so49845485ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 20:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785123736; x=1785728536; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZugYL0Re6FLYLg+SfCPuv2uALiGqd6hDKlaxGiHPCHk=;
        b=Jq1VSdwlT2hHEsKOodlh2K8Zu/xMKMmSIuIAUrSYUl1F/84t6kPEAb3DFnC972w8sa
         qCaJiUcQLdIuJurgQq/0YWBNRSO+c4/sFoXqt9vYDbVK05GgrCpYEdTxkABBYgxOle3n
         BdbxhDgsweOv6++i6ToN3ddu0n477rtxnKaK4NM0F2QgLnVLqLp8Boa0OLkkdfmOAJ90
         HPfeVzIbdOlgdWoZT+QsztIW0knA7EVzdMyvtUZIbRTMsswVXeFb8eben9EA7JZ03AbV
         l88I0oxdc/zQtWvWfaVYQHt4dxa4WfiDEVrclp0YujxA8Xa5nivRxUoj47XV958ZSwFv
         vlcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785123736; x=1785728536;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZugYL0Re6FLYLg+SfCPuv2uALiGqd6hDKlaxGiHPCHk=;
        b=TbAyK1zJPguFXyEXMqBaV6wDFJPJ6ueI60TaW7GpAcQhZSoo2mGigZM4wWWfh4b3kC
         8FyeKOQGLRHPC11mscH0RSvjttcMI9IGiSxQAcrDXTa1ynVxscWRosW2VPwamy8DC3LM
         EAfn2I7RjUdA6j29VG9w3o6SfPiIKLqqy+FtOKNSxGZgYRqF/PYsfSvT91AkzioN1JE1
         fYDMwteTt2jXr4KlA0HDbGDYP7Y3S3WSXRiFD3Em7kj99e189gMPpz7TYpVukeV9bgC8
         N857EQd9tv9NF9MNrHANzdqLi5YWmH4oMOom6sGxmawQoZ+AxLJRCHHAEOWIIVQ8fvx6
         FPXg==
X-Gm-Message-State: AOJu0YwHnKzwsZnALjQEhQlUpMXgq8dr6H6V9otcTZtgcLfo1xYHqE5b
	S+pFb6F1wA2u6gahhQvLbGemX8KPe/B7Wf5n6ePhtnH+neH8xcQeyvC/+KdfB3+r+r8DZNCj5N3
	os3aMn7Gjgy5eXbvuL88nWBhwDxoybPxmZwidDcu5TkrAB6/9Q+ErzXpCYbZP6+Dr0K1ymw==
X-Gm-Gg: AR+sD10Dux4cc+XQ7Uso33mmRaVjMH7HOhDhJ/kezJ2RPkeHkc8a8sdFDGhOwrfisax
	x9PRAGqDOur0UVinKtzbmRI1fCSTaxodpaPLpnvHdcqYpGHzkNNj5gBF3bZiZQiwjP0ppO2RQoi
	yF57v8UsSbPywjlH7W3foQ+muaaRbwq8joYYDqaxJHDJgMw37huTsqyoy3TiEv/aXfMrdvaUENS
	VXET4LU0ap+Vl267nBKI2oFfJ6FxDuMW+GgxD4yHKjC+LyzOtcnqpPB34HLSeyOKLuZ2zFiIpZN
	3HInaRMmc8w86vY7hJkrMYORGL+BWYGizLrnGXdSNBkY8nM3Jore5KZeSfMQMmhWbzKP8M/CbVQ
	w/WPLDy53xWw7Kqrgv5uHdzGOcAczRUI=
X-Received: by 2002:a17:903:1448:b0:2ca:b1f6:b0c5 with SMTP id d9443c01a7336-2cfde8778bbmr63741985ad.38.1785123736377;
        Sun, 26 Jul 2026 20:42:16 -0700 (PDT)
X-Received: by 2002:a17:903:1448:b0:2ca:b1f6:b0c5 with SMTP id d9443c01a7336-2cfde8778bbmr63741735ad.38.1785123735945;
        Sun, 26 Jul 2026 20:42:15 -0700 (PDT)
Received: from [10.231.194.200] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde59bb40sm26819585ad.9.2026.07.26.20.42.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 20:42:15 -0700 (PDT)
Message-ID: <1733e77b-8bc5-4c64-92a9-6f0c36f7d35c@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 11:42:12 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: Cleanup ath12k_firmware_mode
 enumeration
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260725-consolidate-firmware_mode-v1-0-aedff0ce0ba5@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260725-consolidate-firmware_mode-v1-0-aedff0ce0ba5@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=GKk41ONK c=1 sm=1 tr=0 ts=6a66d399 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=G7SgPBRoAAAA:8 a=EUspDBNiAAAA:8 a=eh02q243s9NmsOQtZLkA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22 a=2rYB-OeQH5pmQqQB7sEg:22
X-Proofpoint-GUID: 4Qs9wyBX0bdLrnCf_UXEEav4R4PvvXGU
X-Proofpoint-ORIG-GUID: 4Qs9wyBX0bdLrnCf_UXEEav4R4PvvXGU
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDAzMyBTYWx0ZWRfX+g9m1BkWrh7F
 T9l5fK8NCfJomER/Y0qiaGnhyeDCe9msX4hEmEHODLDdaGul5T5EYSRG9Xfwslop7WwSC5Yg6rI
 uEeKDpP/iNw+1RYJr1ObmBXH2WEVULo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDAzMyBTYWx0ZWRfX0WSM4L7OxLtV
 2MZQQYRRZeyg51JYToQPOsepBvvbdRuaKB8b0LHZyichr66gLpme6Y9PV9idU14l6QyA7mUNTat
 b60FARTkSRVUi0LLO5cGsrCnq75E9pi5hdYuz2st+zZPXz0r3HSJfGUFfsTF9RqTy0l1h2uE1Sp
 2wGKi6pJyazkDjTU8AX3meZUATdOpUti8cjyEwwo7BJ4VHOB2Jk879fSRS2bovhFXFz97OaFi7q
 CstcNMrk+SWeIrrMyN6omhi4ECXbDj/KfdTGW3x4Uo4MO1fPaCVNWkXY4qnRGfwz+2JSVs0t3mt
 64O6uuXG/w5CgqouOyrp6iYOHYY/d4WiEWcphHwf5mtgo5LRDvYdreYsro/8myP3lE4vcJ4dU3D
 VbYiqTpjPrRyVsiEHDPVSYqz8zITcVwdrN1I7o5AqUAbm91Lx5orEEPaczyxIn72Y+9+Yn0N8jA
 NfMJxROobLiO7KJR1eg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270033



On 7/26/2026 2:11 AM, Jeff Johnson wrote:
> This series inspired by [1] for ath11k, but takes a more comprehensive
> approach.
> 
> [1] https://lore.kernel.org/all/TYZPR01MB55561DF4543A0265B47A58CDC9C92@TYZPR01MB5556.apcprd01.prod.exchangelabs.com/
> 
> ---
> Jeff Johnson (2):
>       wifi: ath12k: move firmware_mode enum to qmi.h
>       wifi: ath12k: rename firmware_mode enum members to use QMI namespace
> 
>  drivers/net/wireless/ath/ath12k/core.c |  5 +++--
>  drivers/net/wireless/ath/ath12k/core.h | 10 +---------
>  drivers/net/wireless/ath/ath12k/mac.c  |  2 +-
>  drivers/net/wireless/ath/ath12k/pci.c  |  3 ++-
>  drivers/net/wireless/ath/ath12k/qmi.c  |  8 ++++----
>  drivers/net/wireless/ath/ath12k/qmi.h  | 14 ++++++++++++--
>  6 files changed, 23 insertions(+), 19 deletions(-)
> ---
> base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af
> change-id: 20260717-consolidate-firmware_mode-93c215fdb29c
> 
> 

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
