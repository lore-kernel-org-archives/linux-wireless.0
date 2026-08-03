Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A971217F33
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 02:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785722520; cv=none; b=dApcQ6fTxNTmGy63xvAniB8YMnbryMdkl5QR8HAJk1R3p+YTQocB1GBJ4rz64+KcVRmSmVbunVEE4IsD4chVVVIUOym6kP4oRdZUzviZXD+HswPAnecRoHaMHQ2+DDn6ZOVIXnSYvL6y+Nszgt+jEglqY6XaZLimabshGGvUhGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785722520; c=relaxed/simple;
	bh=LIZXI9ZyQ/OCUxSP05t/6WL42LpDg4roaXy89ItFceY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gq8Y2BYZqLCPOgMcQ5sZPC/EIj5Qpvic7ZHXGLUEJ0yMpQUhdQfuRvQfWVookLFqTx4h0o0c/jasZCInK9o7aObzFsoRQRoa9lgVbA+hzen/FrWDtJzRTw4Qy66KmFUN6lQI9pG4kh2xqAu1MPouOMwAMn5STyE73g0JtjyNxZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GhINNymt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IsVdZJEt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GhINNymt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IsVdZJEt"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672LWl2F2878802
	for <linux-wireless@vger.kernel.org>; Mon, 3 Aug 2026 02:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+7RjX/m9QZtxkWfjOdvYYFL7PaaKqNCynQAQMzIlVF0=; b=GhINNymtcdIZCjZt
	93iFN41CchVFD7zlOxExfC5yBdJJ/53AJ7QZVePd976MqLy4GeOwKNI4n1iDmlaF
	rcXg4qUzm8Wd0gGR6hC4woaNgqPGaWoWSmS2pdsJ0Lk3wYig/wa961nA7XXdI3Ui
	/aAxlKD2L3og7LQm8TtYAJ98o40fGnLZD6l7T6UaEZfYAJMC3+D2KerypbHirG4o
	LtMiOsjGokWVJmOR1c+6Prlars2p4Ix6SDDZD+NOrar84muggCQfjkyf9PFOcqHt
	ByckHo4jdqh8y6PYPo+PHmYiJKraqOfN/UwIdHsPGnqsHWKQPlDfj86GP3Ft8a2m
	OKPuEg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fs8vtc60p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 02:01:57 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38f5ac7354dso5262160a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 19:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785722517; x=1786327317; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+7RjX/m9QZtxkWfjOdvYYFL7PaaKqNCynQAQMzIlVF0=;
        b=IsVdZJEtALzSOgIxuqMH+JtgPyutY5X6Dz9Ww6HqBp3gxVoAd7EWtKjz9XjdUDNYol
         1EvCSRMCBfN3IjmkBbHHjsAccz6uyGQ1yCzb9e9MdGrFJ726+W6uyh2R/rvolwIhGo13
         4V7j36j8/vwWWb7x4KqgXXavbEob3YlzB8tqDecQADVrMqNPGycza3gK/U8BovB6SZnm
         XUcAluyyC0wKPZtlfv+54hsK8SHX+qSBUsBoKIHa2lBPOkgpYCoQRfqi16HFUbetfLVe
         KhMb7uoGXV+1hpNOVA5NvulBLGmhK4j0aoHQZWHQwS43vYhFuwuxb9YBXHN78Uct7UB/
         /CWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785722517; x=1786327317;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+7RjX/m9QZtxkWfjOdvYYFL7PaaKqNCynQAQMzIlVF0=;
        b=dTBk0TawqOuGpGKl5b2cuxrpGAZgA2PbNCGDtBG6/Og6jH2YUg1qewjCk8VLZa+b5j
         4JTtBES6laqy61mJkq572cWhRE4lsHtzQ3Io4IBIESewqNEq0p2ZN2LADebyBxUgujOI
         hKzZDuAc9wLGrbRXy2mEd/6sEWQkQYtBaH+rMkFfq4if70GlDMUzZtc7lU0Kyy7TtUtY
         /ilS31xZcKqJZXqBhn/IX7Gx81k5ikZsAP7ClhE/5F8avbBsHKyGknmGY8WsPekU3Rw+
         8xEC6Ceq7EgatmsyP98afUu3IiWnpYczr4IDRIk47fx3WSVbJSU11aB5n1SNhKntUv+x
         ddRQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp1OrFKKi0MiJfAouUb8kisCoHZJWRptx5wPNdNLqA3i8nlz8s4SUeDFHY1UCOSMynlNXlli/IeBp5PdX+CWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwU6kA3j1JpzmJF7zNRFe2SCTVIDonEhxxkAT8zDk5CUQLIiScm
	Y8Q+2BH4kNyuc2nU4i5g21TqX4mByYL32USnKIPbKNy6CC+D9i602m2xjQPYx1/tad4Sz3ztyUk
	dYxS5v5C9xtnmOn/phGp3qjDBkqSA6g7sWq/tSty8CVaUEh9G21agEknvq7czJcevkLouFg==
X-Gm-Gg: AR+sD1365nyiC/bFrqhreYQ+dnoK6/siPRNcfQE+BHH5qWspxjQwID6xOYExaXLpoUO
	BFbiTwee5WdgZlKPR05Pkl45wfcKC4vOcryzZfBv0qtArgLKEqD3l3ogEtBsjRMr68xR5Zsiqfx
	B/wxRM2DV+81SnPcV1FMX8AlRhhd0pQ0w+Hl5JgooMvDXQQui0MUS4weqViRShamWlgWI4AxHXz
	vZ3r+JjqM2OTwOyApeKVVC0vTV/EZkHC9qFpDeVRYL4hBOcR9YahfGYA9ynbu8rnlTIMKMkEgwK
	40e9vp4lHmMt4vWkRBwrR/XFAzxjL5p1J8my/D9ko1JwCdoVVi+CPPS6L6Icy/+jCetrj1yhAEI
	CI9E5xY6TCfvTa6szrUmCuLF5pgvmd/x4OT9l6pKzCkWJfyBqFDmRhOXDOZY=
X-Received: by 2002:a17:90b:2750:b0:38e:2c8f:a01a with SMTP id 98e67ed59e1d1-38fbc42c3a1mr6719992a91.11.1785722516761;
        Sun, 02 Aug 2026 19:01:56 -0700 (PDT)
X-Received: by 2002:a17:90b:2750:b0:38e:2c8f:a01a with SMTP id 98e67ed59e1d1-38fbc42c3a1mr6719953a91.11.1785722516255;
        Sun, 02 Aug 2026 19:01:56 -0700 (PDT)
Received: from [192.168.1.9] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e045016sm44332605eec.19.2026.08.02.19.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2026 19:01:55 -0700 (PDT)
Message-ID: <05ff51f9-62d7-44fa-bdc4-1af3de2d5478@oss.qualcomm.com>
Date: Sun, 2 Aug 2026 19:01:54 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: remove unused
 ath12k_dp_rx_h_find_link_peer()
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260803010532.302038-1-miaoqing.pan@oss.qualcomm.com>
 <a990c25f-8f6c-49bd-90cc-9c4d0729fcc4@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <a990c25f-8f6c-49bd-90cc-9c4d0729fcc4@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDAxMyBTYWx0ZWRfXwD/XmDNEQFkP
 npCGNPd2JPW0JNT0+IVyvnQ4xvHSWvZMEBMTf7cbf7jlcI1CqbQsWhHLTL9OUvfmQp4YocPCKA9
 R/OV9eOxLPcnbHdIPJWcgmNLJlp2dCo=
X-Proofpoint-ORIG-GUID: pXqlHMcwQRKy1gvNOaSeBdPCLsrkknC9
X-Proofpoint-GUID: pXqlHMcwQRKy1gvNOaSeBdPCLsrkknC9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDAxMyBTYWx0ZWRfXzKaWVhV0HCR8
 o5NfInS2zpWwXSivjcVitMG1YTQ9FbVJXFWbK2mQE8NClKn4WKnbYuhCzdzj6yoUHVCW9mILCoS
 z+ZWI52WHxeAQox7UO6V5dtDR6YvcqedizpcEJ8AI/+JCyzhtnre6EmBvgczQJsdWJgE5IpzMi1
 R0Mfp93L+IsiK4mJpn1dNOjz0+dD0dEXBK08dEzawD/dERsIY2XikMO76LbJOfKjSqeN0y/yBl5
 dxRbJHs3WAghscesrnIf//uRf+izdu+yGL/JbaFWu9ffkeRUSs005K+Ub92drTzcabNtFACPIqS
 KUCyo54vTxurLvW/J/Q0c8WESBYfSLGMLvWz4LAzHAmJoIS0cNOMKcvTvnk5nu/tNeEUIcUNVrA
 NTe/RqkN6OHfe2wIRV271O+ZblWWs+m75wILCLknoDDJeIPone+3IwWydu/7EKPw0MvR1OZqU6r
 J2lj666WW9IgHONLq3Q==
X-Authority-Analysis: v=2.4 cv=fKMJG5ae c=1 sm=1 tr=0 ts=6a6ff695 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=lxulcXAl9rQatp6SiHsA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 phishscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608030013

On 8/2/2026 6:54 PM, Baochen Qiang wrote:
> 
> 
> On 8/3/2026 9:05 AM, Miaoqing Pan wrote:
>> ath12k_dp_rx_h_find_link_peer() is no longer referenced anywhere,
>> remove the unused helper and its declaration to avoid dead code.
>>
>> Tested-on: QCC2072 hw1.0 PCI CI_WLAN.COL.1.0.c2-00229.1-QCACOLSWPL_V1_TO_SILICON-1
> 
> is it OK to use engineering build in the Tested-on: tag ?
> 

Ideally we should test with upstream firmware, but for this case compile test
would be sufficient.

/jeff
