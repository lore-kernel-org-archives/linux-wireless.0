Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF99B31AAA3
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 03:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784260334; cv=none; b=ZC37RyA2YdkXt+BfzKrFLyscbEX7thCo+CuVQJaLybRiUh9Qu12t/LdPx/ijubBcMFTZcxNn0HheaAPTLszONk5n7BXyw2yvW9ck+f6cSelWrhC62N6YHs0rsHEq6NI6AG/mUIqHQK1R3FXsoMnDuGHcjVH0G/6yHJrC4PDbDyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784260334; c=relaxed/simple;
	bh=oE9pMj6SGS+6xwngKO40IvVPeL+glKSS26aoUR9MphU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YaoJeNeUTxYSZaLDHdKqT/8PfJ6spt7LZrHMM8aluCriqPg9f7JVRmtbFEWqOM7YCERPhmd66YNagubKW24MG/46E4ukkDIaG8W7AfPgebs/k6V5To7Y7doXoW1sFxBhAz17AIVfT2mnaFvMZnm5QTHxgyTD4QUiAHFTlrOCXa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=d36uEv1E; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=itF4wu9F; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="d36uEv1E";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="itF4wu9F"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66H33j4G469378
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 03:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eRfFbQSTVRjImeGnvr7MhoODIgLAI9+WzZ3nMX5R2Ds=; b=d36uEv1E9y3S9YxT
	4s1lYBgLMdPmWoDW5X2LD5jo5ELkN+YyvLohATfW8xem+v7LKUCWnRY7yx0Y0SMz
	jOTjA6AiG3s3y8RIv4eUD64jD2YSZ7aFi853OdaMqsIcZ6pmmLstS/1/a1oKjISz
	0Qij4HGrBS7XcatAT6CT0rVjtgRMz2QDfRUQXJUt1DQ7Q8rBVp0Nvj1Y+vJlDcSW
	Cj17wCrBWLgdcNMT57+sVq/PIXr+D9oba3XmHjvH7iMe+3hd3V1B1lIqB/EApnMk
	czrCYF7xhEhTjIyD9ghjEX6UB5dFrgmuCkM7wstHPbELi0TEuSDbwyP5eEo4wS+P
	U12LNQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ff2f2tbbj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 03:52:10 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-384419c6c74so9388699a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 20:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784260329; x=1784865129; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eRfFbQSTVRjImeGnvr7MhoODIgLAI9+WzZ3nMX5R2Ds=;
        b=itF4wu9FKuqx7laUX26H80Aemuyz5kWVKjuSdhGXfxmc5RhKQflkNjnZfDyqb9kB7f
         FebFZ1CPV50KsZXxBVFoa0/zRW/5PCHL2N+nHAfQuV13eUeDlw9qANOqPFGIXGzb32v9
         HfinPiIsSkvTSgvQChKcpSn/tcAnP6DNX3g9tgdZVZ6TfWJAt5zSn8U+uo+xZ/v02WR+
         XlKeW6dmG86Yz5wdXkg37jTWWx18Ssm8k0yelGs8gQB9N6jgzacOy/qmOdD03bz+YgbA
         3jqlQBViISbuzg7LPgzG96J/hN45ft9tGNk3I60UYqNrjYsTxlgB1QlzM9WHhZ8LngqU
         NExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784260329; x=1784865129;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eRfFbQSTVRjImeGnvr7MhoODIgLAI9+WzZ3nMX5R2Ds=;
        b=Jy4wWgoPV3uZC4O+5bACETYu3NbBidWMJulICPKcgmyiON9Poxz0QgPyW9aaUTfX0/
         +EmBuSX3gsPfXLV8QzgWazuOI64edThKl4Wf+u+56P1tJ/H4o5Jfw9FPep1Vqt4+q6ED
         6Tb40raSOeSDoAhx9VnL5DXiu4zue/xmnyGB0fD/zBegvlwileSdIRDPVnWa3tYE60D7
         IYCeKSHUe86unjIAGziXaoOTEbGaFNNLksq+V93kegQvQ8sDRvqz4gJNYcoONmcqCgfq
         nOGwFRrNbL76HqtFs9UOiXcl2Qj7LtlroD69D/7TwTzU9cbqkctDhDMm/RrXgUFQz2Ad
         CIig==
X-Gm-Message-State: AOJu0Yy7KfO+UJvUnsgyj1H6zE1i65aKjoH7Ua4Ykbn55DcBlB4j1spK
	CWOJ8VLMinC8rujYPEqjf0lVKgKtg2T25EiKuMG/+AekylWVEnaazPrgFqWmEDocxQrXZBI16fo
	l7XhA4+VuGfND3aBExzY6aAFQ12hr8GA654C8s1euBTr/Dw7m5IlXaezlTUtWEUOwdnXk2IPXXv
	m7mg==
X-Gm-Gg: AfdE7clwk+n6hJq2yC/ntjH1XgYgRZRTez7KPhdam1VRZt6vWRy80sQZIbNrvKeht8g
	mOqCCTNHR2gyUfwWmpk5IaQLwNMotAltSBt0RZjtmpv5SI1jMDAeXikk9YjsLz9ju7iYFwsX6mJ
	d3bkRmnRvMDIEKkRM+1/fSboSyP9EsqyFMcu4j5omFTG90Wx8IJg07VjJnEbzIDIM86VC1FQu4A
	FeeKFP/1E/yPZAixjxQH2Og/Fkz90P985hKhdjOXctPunnNM2KHGvtPlxMfHNkuVGbSk0BYxMfq
	u4NEA5go5wbgjbD4Is9yAlOTCXg1j36sIxYvwXdLRNHa1sBMyVi+HVDWW+iQrojd5//jR9g6GSB
	8E9S2Ge/jkbmq6UkjrDkF+lo5t8zc111iZgpImF9H
X-Received: by 2002:a17:90b:2692:b0:38e:79f:76ad with SMTP id 98e67ed59e1d1-38e4b52efd9mr821518a91.23.1784260329423;
        Thu, 16 Jul 2026 20:52:09 -0700 (PDT)
X-Received: by 2002:a17:90b:2692:b0:38e:79f:76ad with SMTP id 98e67ed59e1d1-38e4b52efd9mr821493a91.23.1784260329013;
        Thu, 16 Jul 2026 20:52:09 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a20b1f3sm1640072eec.26.2026.07.16.20.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 20:52:08 -0700 (PDT)
Message-ID: <428bfacf-1ab0-4c7d-ae5e-6311c7ac0882@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 09:21:57 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath11k: Avoid buffer overread in
 ath11k_wmi_tlv_op_rx()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260716-ath11k_wmi_tlv_op_rx-overread-v1-1-0b972b3f1368@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260716-ath11k_wmi_tlv_op_rx-overread-v1-1-0b972b3f1368@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 8Bu3tyAFdznZezz43pIlwDbtdRHJCdN0
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDAzMiBTYWx0ZWRfXwgBejBxpw1C9
 xk56Dzk/exM9FnGqRTWtSC9b9X8MZcvpdYi7Az5WRaUFJGpvNU2grUrmbo4eOe0b+U13fsCjBAR
 pGBw2aGn030PTqFw21ArLbajLiU4rJU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDAzMiBTYWx0ZWRfX+9OXqj1n1aS4
 aV9apdsnVtr5NnDxhr8hsoQX7a7nSbZxwK9iQC+Otr9tf8WfwTPlZqJYIZWP/VqXNU5MRsaXNKH
 049iFgDXvYKLjht7kqkHJ6xoWnTR++Gvn8+oTJytP3qybarfLRJUQzqBeZaXQWUjvPqF0gv8fg3
 +YWtCLy3KM0+EZfEcomqeQCibI2Gt/ko58w1EM2fCURaoTGoOkc2WsPIgeIrE66pFe/Gto+/q8S
 bP74m88TgquEa+BRiauz4LrkdQNrnBqmYW5/U7bxz9UnIZruXaA9Z4qCNS8O2KjkIUP5PHP6ar9
 NY2AE+sBf/gPMVX4IeM4ofRrKqPpCar8F8FayO+fnUZPHUOKjCwUlqXoRGWxSQgizwHUemzgTtd
 4HjYMV0HO/ureuEq1SOFv9ASTavp1sI4wjI0O/5qm6UnKo02jG+gugz7o3Q6FLOVjkXFqlbJEEg
 oRdr3p9dpgNmpRUJ+3w==
X-Authority-Analysis: v=2.4 cv=NcTWEWD4 c=1 sm=1 tr=0 ts=6a59a6ea cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=Lj7BFKMBFr4BX5uBSNYA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: 8Bu3tyAFdznZezz43pIlwDbtdRHJCdN0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_01,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 phishscore=0 bulkscore=0 spamscore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607170032

On 7/17/2026 1:31 AM, Jeff Johnson wrote:
> Currently, in ath11k_wmi_tlv_op_rx(), the firmware buffer is read
> without first verifying that the buffer has enough data to hold a
> header. This could result in a buffer overread.
> 
> Add an upfront length check before dereferencing skb->data as a
> wmi_cmd_hdr. The check is placed before the trace_ath11k_wmi_event()
> call to preserve the existing trace semantics (tracing the full raw
> WMI event including the header), unlike the analogous ath12k fix which
> could use skb_pull_data() directly.
> 
> Compile tested only.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
