Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EEB3431F5
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 15:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117727; cv=none; b=DLnXZJEtoL/myhQQxZFvyIozrIBgSHNRmDVgakBSfVYIlrV96R7ymbWDOQMSr4d1jyT4z1jgQeGcHtwChLoIbVv7u0eg2IyBtHkXlhP1PBPFfTXp/VC/jRqbtMeQ+lSyNk99q2y36bUWuDAyjI82eaZamTh/l88uk2KtULOWPdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117727; c=relaxed/simple;
	bh=uPv9ATx+Z4YuxS91cSFJpyS+1ld55DpUtJQiV7liAug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=To/yMgif8046/oBzF9s7U+cy3XdohAwhpFFMx6k7mmQEXLkKfimTSQcQ3IjTXwqi2ojK4nsVe7I5bHshaQn2TIkce8dklHH3syEM8Q6TyzO0oTpzgmmxaSuLxTrKXLFUxJTceyTmt/hoVlPZLEGpb+xO6rFB8bLrUMsJ8pDartg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DklM7x5K; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Wj/oHQrY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DklM7x5K";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Wj/oHQrY"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677FRouH1367126
	for <linux-wireless@vger.kernel.org>; Fri, 7 Aug 2026 15:48:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sUYB3yAyXq4csu5GlgZwOub/CvpJeprZIhLCVh66gKI=; b=DklM7x5KpBN1Z2ru
	5YtAAT8aluNm9CGvscVuKFNGGQamby7b2vW59jbO9adDZTZC4LaUCdnxSbSoNwYz
	U+8eBF9I4G/qXd1qDWyah0n08bZnAL4p1QaQiu08USsNNerYmSr5kSH/PvQe4rTj
	9lgjpIUtA42pfKBgYxrThJjoKHTRmyTBQ16sKqzVQHdemf8KA79mfRKt2hfJrfmr
	aUql0LPvYpPXFvZgrJPmlJSSA8AUBIbYGb6rmlKoyTCrz8xqv0yUwN2pXkITrqW7
	CvQD608U6CoSFaQGFqTve3rGBsv+kfA02NI7Yk1HO9lCYhht8KGeEJ+3NI9GpnVK
	av8HMg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fwctp9efk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 15:48:44 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38fa7b09921so5471120a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 08:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786117724; x=1786722524; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sUYB3yAyXq4csu5GlgZwOub/CvpJeprZIhLCVh66gKI=;
        b=Wj/oHQrYoM7N3GI+twxg4bNP3Naqlhi7nQu/L5sjh6juFUvDx9Pw8qHbR4mfpbQb2w
         VpKnbGwFwepKBG2nDY31WD7PtV0gFGKXy/WYDo05NptlcYqV16Ug1YIFyu2QW64U7Rp/
         /9Prirb+kD2c9MDLpaDUWxkmLe0Y4vFjOjZowa2URF6brrD87k+3j/9tNN14JfwWLSY8
         6hmXjUjwqrR1hN0xccZvqFAAQmgHwUquUdtZrhGENDr5dDntLArLbSQFYV2ntWqYJ/fo
         2KDuE9dGqqthdm5u4rzRCMHOLIXbgXBd7Ce9Fov7zC624kkLdPqfJ5bpwl8QET6uTu07
         7tdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786117724; x=1786722524;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sUYB3yAyXq4csu5GlgZwOub/CvpJeprZIhLCVh66gKI=;
        b=na26V4jOPFedxSlho9IQqRtR0tUWMVSYE0V6p9yg/ZTqoEXx7HxDlZyEAbCMuL+2ul
         Y698isMurdo5X3gzZP1eketoZ9EDRsTiJ/coNCWAIwLlog88Y0z8/DBk/rOsbe0hfutM
         +7C/yr+USOxUc656pITe+IK05UwHfUsqyLqMuRI2yXEBRq4VCwfgiMv+GgLw8sc2EAQF
         SpL3zTMmh2uetI2GYxcsmLFTC9QKXDQShCwoOvkG6LiEGvJ26fY1VuCWGwezvG1oHVhK
         yEFTA8pwlL0WGCDjwO0KT/2jxtB8Pnj6adZP1S/aNyHEVs4Ju192aYRsU65oDIJxKQO2
         XMtQ==
X-Forwarded-Encrypted: i=1; AHgh+RoXCTHL/PD9ar70aNmA75gP6oyWR6SwYJO8ad1Zjins91jaeMZEtNOwPPYqJsm1hoRBf0gOuBbSovDLp1Y5TA==@vger.kernel.org
X-Gm-Message-State: AOJu0YySTItRV09aofWRul+7VeL3UlfU1tOkJHCjgACv2pSU18JWzjUR
	hsB0Rmgsm8qk0cZOqT1KrZ7V+8CKmPKdiM8T0BjYkTiYMj6RC9OnVbRY9+TcF2nzFIqpJX/XmWe
	b8/2lmnHgPrOVmmCJHg7oN0BrAvxKyv0fODsNJMlkN4NKB6cv4TPUZgAFfkDgW6bOh+USAw==
X-Gm-Gg: AR+sD13OCI1AMRZ16awJzkgbAueHkeHLgBI7eLQp7DzrhtWC8dnjUSvDuSH/r/JDQmf
	wbNNTyZhm3Sh4P/AU7DBY3icItAxnUtPuN3du11b1T0La8uY2CV3fmkvldjWSQM4hZYrIbs2/ZT
	lb6exdXw3foFVhCw5JKNVX9svjoJSBGgL01P44FsmjtGXaw5N629CuZPiquXjrN3nEw4SAiJBDS
	2wNyBFraXFTslxVNQAzW9RWuo6/vYAJeQo5exEXawVnfwAjTtMYdLuGKOWCK0ywzBoR6szLpVRm
	PsW4ae+NuvmaIEnboBDO3PUbAbqOPDWE0HRCo+1MYWFkAH6Al9VqxKtt5NDNylY91atWo1i0y5v
	9m4sQ+giOuibENuGrUlyVEt6yf9jMtivGneVZoae3hof0PgP/r8IEpxaPdj/y
X-Received: by 2002:a17:90b:1811:b0:38e:c7b0:84ad with SMTP id 98e67ed59e1d1-3903bb0ab77mr20591011a91.0.1786117723997;
        Fri, 07 Aug 2026 08:48:43 -0700 (PDT)
X-Received: by 2002:a17:90b:1811:b0:38e:c7b0:84ad with SMTP id 98e67ed59e1d1-3903bb0ab77mr20590968a91.0.1786117723530;
        Fri, 07 Aug 2026 08:48:43 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315be8a6809sm8940612eec.10.2026.08.07.08.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 08:48:43 -0700 (PDT)
Message-ID: <c25b473b-4863-42b5-9a1d-f6349c7553e1@oss.qualcomm.com>
Date: Fri, 7 Aug 2026 08:48:41 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: fix channel list double-free on error paths
To: Linkai Gong <gonglinkai@kylinos.cn>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <6a9196e8-2e2f-43f8-9665-6ebb82b95951@oss.qualcomm.com>
 <20260807025628.1893831-1-gonglinkai@kylinos.cn>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260807025628.1893831-1-gonglinkai@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Fp01OWrq c=1 sm=1 tr=0 ts=6a75fe5d cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=_dKMptamaeDBI9ONEHwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: bXhTSxb4FA8k5fKkVyeZQNtth0CXuhtw
X-Proofpoint-ORIG-GUID: bXhTSxb4FA8k5fKkVyeZQNtth0CXuhtw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDEyMyBTYWx0ZWRfX2n1DtugP4dx/
 rtvBB/gDwfDsHc7RxiNkB3o6U8/oDdFI3qzez9kTMrvrrR/WseOiO0JnE4WhkK4koEcabnObVJV
 JJFQ6Yrr+mAfTHib8elAZ7Ic47v4s8YnT7laCaQbdNtGbPAzBiqAqI2b7qKmq7p9OeIRE7Tskvw
 3uUEvZ89F6hCeaXkkd2YQ08QKD3tEReHEpTrI2kRKFOTaNh4jmqfNYfmRZkYhGWzhT92tiY90IG
 k4c0a7GZd6WySjn7ZZU2dx9B764bfVsnKt8RotbQ2uBFXAyNfbFwQoHhpqrOsa0DtHXayiP9BPK
 jlynF0qYSc+uy6Mu7GOLE568dTW/HslEy2sWzv6wF+Nvx+jkrZj1hn/ywEf70Y8RKnI8OdJlOsA
 EYYz/UlKNZ/7/GBk2B+ymxeMjxHtEGKM+DePYrghsE1my5UFIz3ciOy0ivY1Mpz2urg8w+u8YWm
 zyo4MyiAxnT+b8QoduQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDEyMyBTYWx0ZWRfX94XZb5IC3ubV
 IpacX37h7rMOKuBU6KwZMWpuwfcbJlhP2znkYWSLY4nzLyG3pNOZV8sADnZK/nTnXrK4GpuHD+A
 sXvPF7E1z8bc2ODVy+WZqTZ42dIkKAM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_02,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015 adultscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070123

On 8/6/2026 7:56 PM, Linkai Gong wrote:
> On Thu, Aug 06, 2026 at 18:47:38 -0700, Jeff Johnson wrote:
>> https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k/submittingpatches.html#tested-on-tag
>> Tested-on: tag missing. How was this tested?
> 
> Thanks for the review.
> 
> This issue was found by code review of the error paths in
> ath12k_mac_setup_channels_rates(). I do not have QCN9274/WCN7850
> hardware, so I could not provide a Tested-on tag or reproduce the
> ENOMEM double-free on a device.
> 
> The bug is: after kfree() of sbands[].channels on failure, the
> pointer is left non-NULL (or the wrong band is cleared), and
> ath12k_mac_cleanup_unregister() frees it again.
> 
> I understand Tested-on is required for ath12k. I will follow up
> with a v2 including Tested-on once I can test on QCN9274/WCN7850
> hardware. Meanwhile, any Tested-by from someone with the hardware
> would be appreciated.
It is OK to specify the patch was compiled tested only. I just need that as
part of the commit text so that the level of testing is documented.

The ath10k documentation was clear about this:
For trivial patches it’s ok to skip Tested-on tag but then it should say
“Compile tested only”.

Not sure why that was dropped as part of the ath11k and ath12k documentation
(that predates me becoming a maintainer).

/jeff
