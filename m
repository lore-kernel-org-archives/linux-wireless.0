Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCCF45DF63
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 09:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791796763; cv=none; b=DPLHy3fRdgONwmrQIo/hZYpu9b2tswWu4qLFus4NQWnJq/3FloLZqewQXbBOT8dNIm/jB+yyYMm0nEI/1xAHK6/OUr6kqWCSIXBmbF5EeAbMA1WeZE/fVRN9L2mEL9uTNy5kqQHbeeu98EBGpmDeLJjHJcWBQx3rCSZTFcGHySc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791796763; c=relaxed/simple;
	bh=11xjznJLhzmdrLSrivVj3/diuS2NBX+bVNFX2kgWzBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KXGawgoBD3uj/1D5l4V81QH7GPOL6nUaTP1hU0CDLOrnrw9dylvM65wvxlSx9uStEMAcwqEDGj4aO4dzOIru6FQqWNm/zu2ywKKg03PkCHENhFHzmF6DyJVJFFEUc+zkKYCxPhLUhqYnpNMze/6ifij6FQtHLx1rttM8Z42scns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FDF8cyaL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Vm6Y14iV; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FDF8cyaL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Vm6Y14iV"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C8KgSE1192659
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 09:19:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MSynGqQTU/luENBZy9D+KhOkObSWqGqhy0Au8QslHf4=; b=FDF8cyaL9gi0JgXW
	Fqm3EJd1ooGWC2vkCABgBM2h5pvPRzaTMIlBff+aUAihrmfd0Z7KpfMJelvom3qx
	MEWZptF0ogtNSfsDUHc/hVHEyBZL2OJT2JsKTaQmRGWeDWKb/Z1Oq+uY7ug1m/uV
	R0gkgw4kaw34sR7LrZbrm56u6nSrSFT2j6+UcsqgO4DYlcRSmWHeObkOl+r4xzAl
	d8WZ3lLvTJe0Av+e+q/f4Rbqdp0Sf1vjEmhwpuxPSo6MvX01Vrc6lNPl4G4lqDjX
	rK9J2wcBD+4yt0I7skg2S/fWZe9bcDIST35gmfXu/P8UiybZgmUWivQmN6vaPqwp
	BDLbrw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7e4edpqx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 09:19:21 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so1283165a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 02:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791796761; x=1792401561; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MSynGqQTU/luENBZy9D+KhOkObSWqGqhy0Au8QslHf4=;
        b=Vm6Y14iVbLn7WhHawLetba2umV1U8mvtPTWTZ++8wb3JmnqUpGmnazSrHKiDvSblGQ
         sUDSPoU83E/Y8Y8AioIJNkUTPj4ewcSuDwAxNSCxetaDoIOOpJptyyyCrJ8DIncDUnrj
         PaL0XnrEk7eHzxyCvtRaTuDLq8PcPRYzd+MkYJoWpUmb4KTXBp1IsayaNGd+MC5eY0sl
         yZ3N7D6LdGIT7oEtpqligaxm8Gd9K0lwyMAbuBgv602qpIXOqSc/4eCVWFKKutONYREn
         HHJHcLFKkD+ueUQsHxI1PZ2jWiI0KhV/S8Wo+Wb8Ji0isU7MRZoBLYO8RX4tz9B1eulK
         DF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791796761; x=1792401561;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MSynGqQTU/luENBZy9D+KhOkObSWqGqhy0Au8QslHf4=;
        b=xOB6iG9gJfnVgJ+eMHIh8ucbtF0WNViHhgPGTGVKo1+XILvgfEe/O+q69iqmtBSmjM
         wFpaCWCZPQkqXhc3llDCvlmwOhyOLXyik7Ik5z+7LvG3pkE3VI0gadXET3xMnwOg2mLe
         23cCuhpuW+sq21d2tY8BeOiNZiW7FPvUH0nZChYakO8u7jaKtJVIzSvNIIUPpaN7fAqx
         YFEiRElRVVCv/In264dTD9vm37HA3KGjIfCjbVex2NJroEuub5HyXWV16ck1rqBei+r0
         IozniZbgRIFM12Ydzo4W6jhUsVsjPwklrApm7x50UureXVOFeZMJZ8yESU/9odxAgRNQ
         1b0Q==
X-Gm-Message-State: AFq9FYKT/y4Esz4jgC8nFyp8o7KU68Tyx/yF7uUvaEIyEbCGesQtpxva
	xuQJJk1fqfuz8yJ6NoKbObC9M4nfJUrLKkVPSHxqT+UtMwHGeDpIlWWKnVYO0veorOsKApNTlnp
	FTn0pI0/Hht5cY8Rzp/7nktJUCkPUZ/aK7u8hyK9tquFyBTKaRM3vmUxASlTE7YCA0BMD3A==
X-Gm-Gg: AYBFou2u+WI1DjIMUEc+bUEWT1NyzNEvx7JsCYFVDZsFi0BKeSw6/gNFAJhBKIGbMnq
	zrrzNqpRGjMJIpWmeJYwc7VdKzudwHfF64URppiPj+lhP6G8XQQlZfcFux9w/r701q1b8dEKdI9
	7Y/c6jjqsB+yks/QitJBnek4m+a0BR+0aNTGp19tN2N41Bz7bZ/RUKmvhF2SWesTWu2dyl7fSSa
	NgH8KvhJOeXx6COSfIuONUhv8Th1Jzv1cHgM+69V0dy2UiBxYeSlMh0kzWJDpop5jnhii+dO4VE
	A2uLp7k9zTDcPsUKyiE/v5WINGOs7JdDeQCFyLJJwNjaKkNgTi4CKSY4QE8dCrvOkIO2AM6wrla
	xOptwzg+Af0xxXVWe1EDqJMhkDsMtQ9meAA==
X-Received: by 2002:a17:90b:2681:b0:3ab:189b:6981 with SMTP id 98e67ed59e1d1-3ab3a92f9f3mr6893550a91.48.1791796760961;
        Mon, 12 Oct 2026 02:19:20 -0700 (PDT)
X-Received: by 2002:a17:90b:2681:b0:3ab:189b:6981 with SMTP id 98e67ed59e1d1-3ab3a92f9f3mr6893528a91.48.1791796760309;
        Mon, 12 Oct 2026 02:19:20 -0700 (PDT)
Received: from [10.152.193.243] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38b9633fsm19721794a91.6.2026.10.12.02.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 02:19:19 -0700 (PDT)
Message-ID: <154151a7-f999-4ab7-b1b2-628f56ac3fff@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 14:49:15 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2] wifi: ath12k: Fix NAPI resource leaks in AHB
 external IRQ paths
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
 <ad47c905-7865-4283-99ba-e246ae44d25b@oss.qualcomm.com>
 <2d52c324-59e3-411a-8012-e530426eed3a@oss.qualcomm.com>
 <a3b513c2-24e1-4f4f-bf40-6494ebf2bb99@oss.qualcomm.com>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <a3b513c2-24e1-4f4f-bf40-6494ebf2bb99@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAzNiBTYWx0ZWRfX+UX072BW1VpS
 HF4mP6tHqDiopZxsZKKsmq0exkdXdjjVRe27foftYoLtT6IqwcLBpmafwT1yiC5hkWqjVaqndsO
 GUIrqXl9ZOdhj0wX68+asIhjDXTV/giOkkEpu4ybNKdYExRhTCqLqRh4BG+Nw1v8vdduB3vVfFF
 M0woxPm94ZsueOsFwXwudGtUIcrk6sxa6EmF7LxddiY8rLpU5Zk08LEUfKcUZRVa2sCzaWweWih
 dqz7Qd0UxSVUGWmUmXAb6uJUk2nMm+jR5SHIS4/FMT+kcAUpepWkNIPgbdgYqvDNZLPSqcqgXPC
 XlyznFN9bZtjeDGmlCuSEzmuPXG60HFwxHGHCnn1RpMhpOSBSUcYw75opUKDhYMrbBwEIs/28lD
 4AHj9GAudWK/sSIxVhCTwxlpwnFrmCBi1m8OzSfWloLi0nToaFW7tw8BlJQIIdrG4j1cBdEBOyv
 d01e2e93WDc22MYT7Ww==
X-Proofpoint-ORIG-GUID: tbLMMJuRaRnvAYz34yhrVHphIqlWYrAA
X-Proofpoint-GUID: tbLMMJuRaRnvAYz34yhrVHphIqlWYrAA
X-Authority-Analysis: v=2.4 cv=W5utxhWk c=1 sm=1 tr=0 ts=6acca619 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=qnt-ocGMDwAMB1C66_4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAzNiBTYWx0ZWRfX5qY/H+f3UtsT
 429VIH5CE/PBK45M4zQt5EEd9tw44Ql5qOt5aQFYioMwrURthbv7AAPu/Spbz0xyZtwtPxBTVu0
 n1Hc78WaJQIvUkC31FV9wJkKmT/GZfI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_03,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 phishscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120036



On 10/10/2026 2:11 AM, Jeff Johnson wrote:
> On 10/8/2026 8:38 PM, Aaradhana Sahu wrote:
>> On 10/8/2026 10:46 PM, Rameshkumar Sundaram wrote:
>>> On 10/1/2026 10:24 AM, Aaradhana Sahu wrote:
> 
>>>> @@ -622,8 +642,10 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
>>>>           irq_grp->grp_id = i;
>>>>             irq_grp->napi_ndev = alloc_netdev_dummy(0);
>>>> -        if (!irq_grp->napi_ndev)
>>>> -            return -ENOMEM;
>>>> +        if (!irq_grp->napi_ndev) {
>>>> +            ret = -ENOMEM;
>>>> +            goto free_napi_ndev;
>>>> +        }
>>>>             netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
>>>>                      ath12k_ahb_ext_grp_napi_poll);
>>>> @@ -675,12 +697,19 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
>>>
>>>
>>> platform_get_irq_byname() can return a negative error code. Should we handle that explicitly before calling devm_request_irq()?
>>>
>>> Something like:
>>>
>>>  irq = platform_get_irq_byname(ab->pdev, irq_name[irq_idx]);
>>>   if (irq < 0) {
>>>     ath12k_warn(ab, "failed to retrieve irq number for %s\n", irq_name[irq_idx]);
>>>         ret = irq;
>>>         ath12k_ahb_free_napi_for_group(irq_grp);
>>>         goto free_napi_ndev;
>>>   }
>>>
>>
>> You're right, thanks for pointing this out. This patch focuses on fixing the NAPI resource leaks.
>> Since handling the IRQ retrieval error is an existing issue, would it be okay to address it in a
>> separate patch?
> 
> Yes, please handle as a separate patch.
> 
> My review agent notes:
> 
> There are three platform_get_irq_byname() call sites in ahb.c:
> 
>   ┌──────┬────────────────────────────────┬─────────────────────────────────┐
>   │ Line │            Location            │      Checks return value?       │
>   ├──────┼────────────────────────────────┼─────────────────────────────────┤
>   │ 692  │ ext IRQ loop                   │ No                              │
>   │      │ (ath12k_ahb_config_ext_irq)    │                                 │
>   ├──────┼────────────────────────────────┼─────────────────────────────────┤
>   │ 730  │ CE IRQ loop                    │ No                              │
>   │      │ (ath12k_ahb_config_irq)        │                                 │
>   ├──────┼────────────────────────────────┼─────────────────────────────────┤
>   │      │                                │ Yes — if                        │
>   │ 819  │ userpd IRQ                     │ (ab_ahb->userpd_irq_num[i] < 0) │
>   │      │                                │  return ...                     │
>   └──────┴────────────────────────────────┴─────────────────────────────────┘
> 
> So the driver is already inconsistent: userpd checks, CE and ext don't.
> 
> That said, the ext and CE sites aren't silently broken — devm_request_irq()
> with a negative IRQ number hits irq_to_desc(), gets NULL, and returns -EINVAL,
> which the existing if (ret) check catches. The practical impact is a
> confusing error message ("failed request_irq") when the real failure was
> platform_get_irq_byname() itself.
> 
> And further suggest it should be a separate patch. The reasons:
> 
> 1. This bug is pre-existing at both line 692 and line 730 — it wasn't
> introduced by the NAPI leak patch. Adding the check to only line 692 (as the
> reviewer suggests) leaves line 730 unfixed and makes the code more
> inconsistent than before.
> 2. A correct fix needs to cover both sites together, with a consistent error
> message and error-path handling.
> 3. This patch already has a well-defined scope (NAPI cleanup). Adding
> unrelated error-handling hygiene muddies the Fixes: attribution and makes it
> harder to backport.

Thanks for the clarification. I'll address the IRQ retrieval error handling in a
separate patch.
>>
>>>
>>>>                              ath12k_ahb_ext_interrupt_handler,
>>>>                              IRQF_TRIGGER_RISING,
>>>>                              irq_name[irq_idx], irq_grp);
>>>> -            if (ret)
>>>> +            if (ret) {
>>>>                   ath12k_warn(ab, "failed request_irq for %d\n", irq);
>>>> +                ath12k_ahb_free_napi_for_group(irq_grp);
>>>> +                goto free_napi_ndev;
>>>> +            }
>>>>           }
>>>>       }
>>>>         return 0;
>>>> +
>>>> +free_napi_ndev:
>>>> +    ath12k_ahb_free_napi(ab, i);
>>>> +    return ret;
>>>>   }
>>>>     static int ath12k_ahb_config_irq(struct ath12k_base *ab)

