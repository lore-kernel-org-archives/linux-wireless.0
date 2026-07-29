Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB6945516A
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338985; cv=none; b=IanQS4YWV+/m5loyAJ3IHtV0ecQQhxDBIwYA9qxihtf7r2aRPL+vcDPfXD50I/mL9+Gw28V0QQB9td7VKSu3mXUuGxBcwTuM1J1d9k/xHM53JmTLm+Y0cfsmAP0dXDAN7yoh0wBs3B3Rhq+8yBdHj19M0K88YemrGZehJb0cma8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338985; c=relaxed/simple;
	bh=mk3TGbNeaL6r12Uh7V610viMEyrr0wgIegnCtSOhKEw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZrAfSX2QvsBKoFwq2dZCTRTMBW9SzRalaz2rQxO5H/ykS0z8nh2ZKsWvSDHXLMGQ+EBafauLuU+CuNJHeS/QUtmqnyXrlR/b0nX+rOcYJrPMQA0zR1IFyXGthmO6JnqeP6M/+4DHEV98jXWGQ9FRWGn47e4RNq8oo6lcrDV4HIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ekq+x5+P; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FPgNpG8M; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ekq+x5+P";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FPgNpG8M"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TF2lVo2357177
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:29:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OI/t43mfQ0qzruQ5TObcMZyGLP55nw3pV4Y1yJ3MdnM=; b=ekq+x5+PkVIAKXk5
	Ok9wOh+zzBtq5i5G3kTcLafs32k/PasA0bYyP1KXpWGiC1+xMz2aFe3oRZyztt9G
	0xJ8WswWonSQ7YN9RFfJiA5IC+GpMUFOoynZcZfmqQBZPcVtYcRB0SjeGGeNpeKT
	BSLCjy6p9BwiXkNP7/kpFub9IRvswg/xoBg4ydVBzQlNM2tPXrJXWQ1/WDAxku8o
	9N965dY/TJCNDylEUSVcUPhlbwcZRuY0YW5D2N0PSR4VQJl2jiCclPvNostA93vv
	BnuCjYZWU7HpRoBxtahMWeCl2rSLWTJseFVCzoIV0mp7ekHMyhtZA1H6aPI5DVo4
	oMit+A==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqhe99039-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:29:43 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e7621655eso1800717a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785338983; x=1785943783; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OI/t43mfQ0qzruQ5TObcMZyGLP55nw3pV4Y1yJ3MdnM=;
        b=FPgNpG8M+9x3/wHLg0kvl1t2OISu9fVBe3Im8KnrdWEjZbeWSpdemerRI0aDAmcUYL
         u+gBs6rNkKfAB0djiaJT7v3dPc4MXJl3ee6vLfpAbwddOskvOlbDikXVUGWeARiYyzgo
         S6Sw2lWgS27oM/u49Wg+Dc+mbitC/hNmFTpYibZfMoOOMOMaY10lruAj1+W9MzThg7x/
         bYIimM7L0V1vl5QFwY47IEZ1eW/uC6bXvKy7dd4II/ZU3FCaIxlvZJeQX5ZCpFzjeZbF
         myPxiSIBW2VJu+IoJRi+21tijCEu7Q9wBZXeafopT05u/cTvcnwjoYsgz4TGFWUcOLnR
         otyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785338983; x=1785943783;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OI/t43mfQ0qzruQ5TObcMZyGLP55nw3pV4Y1yJ3MdnM=;
        b=tKW3A4AAHmyLpZdMUrT3GPIgW5R45PsNPzib1ysca8EABPXEo7DEWN1htI5rkKG/Vo
         Bl2d1x9iDzsLmVyyUD32XKgeeddyNajhIyTPDMZ2yavsoa85Lf5hLpw57MQ/W7rUcijB
         R9fPdRAvm5ORQcqQYDFTryZYecm3/EcqOUI0zgEJjknjY3A8VAaLCgU2C/54Pb7cqsFb
         gPSs1R/H0aqKfl+0SWK7MpHEmLUnGSgdk9PbZFicllZvuCz3qwGz2gWqA9fgbpuAXExx
         Yvogjfo70qO4srx64J7ZgnaYu36Psil4Wqb/+U0lAiibDC5C+6azfS/IdXokJ/tXSCtm
         xhHQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp30P4cNxszDmoE2S9pRuJJIJyLzm7St6PyZvPwqkaoZDmD0YJDYgcPybjoxp4eon5hWG4AEmMcg7uRi4YmMw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhI8mo4A6obKtrVk693AxCvNeBEe/3s/Q2m9GQCw94vVn3rA1u
	AoQyV2E0VXa58wRRGolhLHQLEwJJ1PAgRsae/cT7SphoVaqlqLl+ZCG2hBFIXDb2Xm6gFQjH9bA
	jKdodkajX5Cov6SqnsV1CgpwZM0jhqoIUaZV+DUhZscwTLE84orCNWaFqzwqVQqxQNubPWw==
X-Gm-Gg: AR+sD13TXN8ILrqd2sYlYp7+0z5g6PYm+9W26g/yGE0C0R29EiJMoEdNmS16UWkb7Ib
	xFnDohga61XKqGr/HycB3SQe3bM0K7Bozbvo1ZBRgycD5WH0wz3jkjQasbGfdsUvzX7sYAUrjE+
	U0PfamC+AgnOIgkGfD7GGGO0/6kkivp8xFdn9Z4UJZvCTWuSwWuSQ22r73n4XtuMMexaSdoL1+1
	CqIS3jNPgsd5Ufro2zJY1gIk+TmNSE05nlASHPtHJER8NIlSiNtbb7IGNpGrSFL8JOXPc0Nsi9M
	Q2K11FWFGveRCURUa7NVU4nL6kbFL1WyCFZHc5ZNpEuODq3WmowG2XJRL06QnLYh0nFk7REd3nX
	+xz3taVB1wPrJrSzv5zSa4vmGIy7dDt4E8vz11cF3jl7kG1Aw9mYdPmLEYleA
X-Received: by 2002:a17:90b:50c3:b0:38e:408:9d7d with SMTP id 98e67ed59e1d1-38f6a4acbe5mr7105056a91.36.1785338983008;
        Wed, 29 Jul 2026 08:29:43 -0700 (PDT)
X-Received: by 2002:a17:90b:50c3:b0:38e:408:9d7d with SMTP id 98e67ed59e1d1-38f6a4acbe5mr7105007a91.36.1785338982417;
        Wed, 29 Jul 2026 08:29:42 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504d2ec2asm13082804eec.21.2026.07.29.08.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 08:29:41 -0700 (PDT)
Message-ID: <a0cc20a1-82c6-48bf-922a-dc7470663574@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 08:29:40 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath: fix stride mismatch in
 mac_phy_caps_parse
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260729-mac_phy_caps_parse-stride-mismatch-v1-0-077a1a0c50d8@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260729-mac_phy_caps_parse-stride-mismatch-v1-0-077a1a0c50d8@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyMyBTYWx0ZWRfX3m+AGYvq2vSK
 qCyrxWCXBcmJuk9YO+L0jVXCsWoRquRyNhe/BvrZZRu+3sp4w97+CoHcHziotozEidX+P/CxODh
 R5UUTIvM5jjHRmH1JR3W/4/RRzG460ncmyOBDlGvPlbT99BeZolazLqFPpiUFyTt4F/GyYIQV2s
 bk00YZ5SKdNGmNxw2PHtffunSC4LNr3LJiFE02C9u/8WMsnCNNy4vi9FT6uvLN/UhOS9EDIvtjc
 EtYi5PAba+FGzj3hjnUocGZ17i17+Zu8TzS2QM2bb+KTwrhzvXNQ4uTxdAQEiAgXAljMsjm9nNr
 ay4rtmrYAkv+T0nsY3ZriKiOTtY56TSVXRhMoEG3G05i4jfVE1jNErDohNuruKaWIApsb3P2Ri5
 WhhNsOFMQvcfRvVEifsLJZwhhj/DSmwhN198Dojtbo7Yoy3/Rs9iI4XGRmKYpblVFLc3LtWDUIh
 3Oo+JDMPeAriD6hdsag==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyMyBTYWx0ZWRfX5f4J/ITE8I46
 2lha5rBTaFGJ/7kMOpTZnH8Gf5IaX4c9TlXqIeqyr7DK0RnIF4jA5hR7gF6U+XOz9yoVJd5d4Er
 z8zZ71J7sE8434fAEuAWUz2oI6dSO4k=
X-Proofpoint-ORIG-GUID: KOLXKF3sgVX5nmxedWmh9FoQ30sV3tke
X-Proofpoint-GUID: KOLXKF3sgVX5nmxedWmh9FoQ30sV3tke
X-Authority-Analysis: v=2.4 cv=EsriaycA c=1 sm=1 tr=0 ts=6a6a1c67 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EYLonMWaFkCW3L4CGEIA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290123

On 7/29/2026 8:26 AM, Jeff Johnson wrote:
> Both ath11k and ath12k have the same issue.
> 
> ---
> Jeff Johnson (2):
>       wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()
>       wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()
> 
>  drivers/net/wireless/ath/ath11k/wmi.c | 8 +++++---
>  drivers/net/wireless/ath/ath12k/wmi.c | 8 +++++---
>  2 files changed, 10 insertions(+), 6 deletions(-)
> ---
> base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af
> change-id: 20260720-mac_phy_caps_parse-stride-mismatch-e7292580f072
> 

<sigh> ignore this repost. invoked the wrong maintainer script...
