Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF8F4825CB
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 20:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791578514; cv=none; b=po3KDPU212AWbeiWfjchk14P2ICTQKtJ4Ezizl3H9iiMwFHn6ZoAGRM/ruX4iOo0oy7D/xy8ufZ4Ude6L5KDER3TzN/xaPnrSSpU102f9QNd0T/bpk5FZ8Bq0+dEQiMLf79eYwJuEiPwdS72M1YtU9xXCv1R9rDMUN60aBKjUuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791578514; c=relaxed/simple;
	bh=OfMcIlAJ9KY+YWFfROZpbfbMcXUXR2BQ+P+AmB7pVMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u/K6Jy+qFTv7ZWegHuN0FQ40xC6KveyupCmzcoI7Haxmio/Lz58r+ck171i/fCs1Wc7THIHTTLzUpMgqhAEF54bM6tzrqJ/ka0LN1EOUGE99KCUV7TUB1Jq8ssKY2aUT0YKIO34mri44rbNNKiFbrs7ZEBKcj/8KPFFxeGEOk8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lCWoVPT6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e+ry913r; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lCWoVPT6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e+ry913r"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699K1T7K2619671
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 20:41:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VxDtk3DnzXemCG0lxELeWTGbDr6igrYifPXgFdP+uBY=; b=lCWoVPT6wrVhFFKW
	p9MuYpPOZX/tAI9AlwLq1RFQ+hzMAKsH/kpj4ncGb28S12W4qtXiTXjO3bM0X19Q
	o+zQO1TttDU9D1Mbxq2bPHyj5yM3EQS0MynREG/etT45uMY7txuiGLTIFLVuXDC3
	II5taTfkeJRRvM2XyNeM57OlcS2emg2WWbNTNrGHjchDTJd9JREDQ7Q0djjBqkxu
	lHVaCM6P9MGpL7A2VpKEYxcYRz/+NQIvKfKIpKUR3Tv7VvkFffWb4xVYaHOz2osb
	MHM3bsbns5pnH3PRqcI1Sm4SaBO4p3YgGldP8v2hHRzsWOSNRZ9AMcioxdDVkaLp
	GhhzKg==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h74t8rkr8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 20:41:51 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3548cdfd2fbso118019eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 13:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791578511; x=1792183311; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VxDtk3DnzXemCG0lxELeWTGbDr6igrYifPXgFdP+uBY=;
        b=e+ry913rsehgZBaN9f85qHnONABXHlppjqLLuGP420wQWyQ2UI7eLDOCbb/myasKF9
         EtfPNX0xrvJKF4IgotBv38391TMo+IE71+XgXDyHyHK8RUE+BcEud6ZPMzlGi5gWyUua
         ux3+N1qm/gEHDFODHeNHpZu2pK96potcU1PQKxGFrKLLPNVv9r9hKgIaA4uL5glIjSra
         gtessT4OSPdTc3fNkoRqHWuNJPDcDjBaWf7JKBlvi8iHlIBFuqdjPWdWYrw4xo+fk1xP
         xQwtBGDczse4tULmEQzqB3kqvAduOyAtrVLimbG2RBIi12/tvZCb3Y/zfUfEMtXi6dyY
         RtEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791578511; x=1792183311;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VxDtk3DnzXemCG0lxELeWTGbDr6igrYifPXgFdP+uBY=;
        b=11IxFYAozyKU8iU3qiwxWfsfkE9fOebxdZUo3EJJvdiRY0sSTfcQ1DKFoi1UwW33l9
         O5s99IPlY3HkUYl74C2m/hDJV5Q7J24Th3ZPhO8+N9fv8FQFAQBdgyT99tUYir2JE+IU
         x/u8+uSTgIUvsE3zNSrIXnbFT2gubZXMM+/md6IcYpopbEnkZbBdDyZTYs2izkccRUHO
         C7mMhS3P8Le9v3JQcxkrQJ8kqy93w4AI4aFkd/m/tY+FlASa3Ye7E42P12+JqbtKFl4o
         KRN7s/TvyyRQPh01I2dzrBvbSDsCY1G8njeKECUuyFmFHTpB1j4TMMnRCf5wKiwsqvxO
         CYaA==
X-Gm-Message-State: AFuF++n790mpP5M5NdU8e+CTUVkgVJIp3zuxuAMmlaR27O7YXe6BVaMP
	ia6wiq/ZA4WiVvl8Pig/cy4mEHieL2R8wxQMcE0vYMWumX8r9xEtxfGcaW5tV5KTX+8tNN/tPJx
	eITsqPVPIqViqeVBMm48ZHz7ojFun+NBh5AQLDU8DxvkB92uPzxM9YYiAKxLUXCA8rQNGfQ==
X-Gm-Gg: AYBFou3yYU1PmzHVuzghGrYHMP5wAHhdJJi772ihtuuf+WWp6BO0F4qn17rcnszCBfI
	ai2P/AF0E+lGyJJWcT2eXHc7UssP3toUQYSXM5/c6WkNmSlqyA2RuDKUXuSq+YG7Pf3KybH7hiI
	vyWbXRfC2wv031YGQQTmKZJj5db9C0R0j2mbAkbM2Yw6yaJ0ZGWygasV48d3rRxvRa77AGrMMuB
	fJdqIcHeqrRnTs2H5bdm9fGg76CkSJO79flaFy5W76BBE8l2J3kq3GusDbBSNl351JHSXHiF01m
	isG28yPyRncWZufP2FPOPbN6NjFYic8QxJf81hdmLR8BLwNsMDTvlRgCm2aqtYUvSwSl/eZKOAM
	rdgaHEhzDITQrcGhVep2GWvP1F2gge2V6NdFYFFIFpbdrKW0+aIU6TY0S+Q==
X-Received: by 2002:a05:701b:280e:b0:143:2719:f800 with SMTP id a92af1059eb24-16a633863c2mr3726063c88.40.1791578510102;
        Fri, 09 Oct 2026 13:41:50 -0700 (PDT)
X-Received: by 2002:a05:701b:280e:b0:143:2719:f800 with SMTP id a92af1059eb24-16a633863c2mr3726030c88.40.1791578509427;
        Fri, 09 Oct 2026 13:41:49 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a31f6be0sm17297788c88.13.2026.10.09.13.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 13:41:48 -0700 (PDT)
Message-ID: <a3b513c2-24e1-4f4f-bf40-6494ebf2bb99@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 13:41:47 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2] wifi: ath12k: Fix NAPI resource leaks in AHB
 external IRQ paths
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
 <ad47c905-7865-4283-99ba-e246ae44d25b@oss.qualcomm.com>
 <2d52c324-59e3-411a-8012-e530426eed3a@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <2d52c324-59e3-411a-8012-e530426eed3a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=dZcVTnXe c=1 sm=1 tr=0 ts=6ac9518f cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=-w-nq0dITT5uSUeCWPEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: sTDpEWVHEJaSV4ro5MldmoGz7Q4oGdqS
X-Proofpoint-ORIG-GUID: sTDpEWVHEJaSV4ro5MldmoGz7Q4oGdqS
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA4MiBTYWx0ZWRfX9YFkwC85dcDw
 JwaxOIShNGZg1vE74b4UHWiCFbb7ONwFYljiO1p1cc5uIB8S9npzoxZtnnipva3ZeZyOacXgRTJ
 nLdimolf1WQQHGbbDK0jA3n3T7WhQbw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA4MiBTYWx0ZWRfX8rc0lV9/03/L
 Z4nhMs7WqstlN9VNfSIdLP8w+kmSqtPiQtVDexPr6LqFDWO8xxPZudy1NGTLHJ9P5lAlFl92mj/
 UR+aoA6YaVmYipGXPIVEcQL1FQlS3HUrc1Vf70Avae8bWOjDFQZqw2WrQcXru0V8okApJl9iwKN
 54onouKifqDCT41DU9Rpse0ezBVJ4Ayn+i8JrTuFe5573Pxjl89MpFu2g9zSsmrdw1z0RJrs77Y
 Weo/DgvvhWta5rXWfhNIC4hzSP1iuiRXO+iKz3mhn/6AnmK83DzQ9dAatzY/SowABGRTmAsVJWO
 BlNVUmqStYGp9ztlkJ6+xfDn7bIT7tOg20278rPNcXRIi2oISkzMIFtXjWQjKsQe2QLPiItWLaa
 KwFWwg45Gqhinuy8kRHXi1RofUZC4BMVLZVAUREL24hIU2Np9dojHMqzXaUN4Pz/8vLRXr7UAz/
 6h4uy5ZqYejAStTl8aw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_06,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 spamscore=0 malwarescore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610090082

On 10/8/2026 8:38 PM, Aaradhana Sahu wrote:
> On 10/8/2026 10:46 PM, Rameshkumar Sundaram wrote:
>> On 10/1/2026 10:24 AM, Aaradhana Sahu wrote:

>>> @@ -622,8 +642,10 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
>>>           irq_grp->grp_id = i;
>>>             irq_grp->napi_ndev = alloc_netdev_dummy(0);
>>> -        if (!irq_grp->napi_ndev)
>>> -            return -ENOMEM;
>>> +        if (!irq_grp->napi_ndev) {
>>> +            ret = -ENOMEM;
>>> +            goto free_napi_ndev;
>>> +        }
>>>             netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
>>>                      ath12k_ahb_ext_grp_napi_poll);
>>> @@ -675,12 +697,19 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
>>
>>
>> platform_get_irq_byname() can return a negative error code. Should we handle that explicitly before calling devm_request_irq()?
>>
>> Something like:
>>
>>  irq = platform_get_irq_byname(ab->pdev, irq_name[irq_idx]);
>>   if (irq < 0) {
>>     ath12k_warn(ab, "failed to retrieve irq number for %s\n", irq_name[irq_idx]);
>>         ret = irq;
>>         ath12k_ahb_free_napi_for_group(irq_grp);
>>         goto free_napi_ndev;
>>   }
>>
> 
> You're right, thanks for pointing this out. This patch focuses on fixing the NAPI resource leaks.
> Since handling the IRQ retrieval error is an existing issue, would it be okay to address it in a
> separate patch?

Yes, please handle as a separate patch.

My review agent notes:

There are three platform_get_irq_byname() call sites in ahb.c:

  ┌──────┬────────────────────────────────┬─────────────────────────────────┐
  │ Line │            Location            │      Checks return value?       │
  ├──────┼────────────────────────────────┼─────────────────────────────────┤
  │ 692  │ ext IRQ loop                   │ No                              │
  │      │ (ath12k_ahb_config_ext_irq)    │                                 │
  ├──────┼────────────────────────────────┼─────────────────────────────────┤
  │ 730  │ CE IRQ loop                    │ No                              │
  │      │ (ath12k_ahb_config_irq)        │                                 │
  ├──────┼────────────────────────────────┼─────────────────────────────────┤
  │      │                                │ Yes — if                        │
  │ 819  │ userpd IRQ                     │ (ab_ahb->userpd_irq_num[i] < 0) │
  │      │                                │  return ...                     │
  └──────┴────────────────────────────────┴─────────────────────────────────┘

So the driver is already inconsistent: userpd checks, CE and ext don't.

That said, the ext and CE sites aren't silently broken — devm_request_irq()
with a negative IRQ number hits irq_to_desc(), gets NULL, and returns -EINVAL,
which the existing if (ret) check catches. The practical impact is a
confusing error message ("failed request_irq") when the real failure was
platform_get_irq_byname() itself.

And further suggest it should be a separate patch. The reasons:

1. This bug is pre-existing at both line 692 and line 730 — it wasn't
introduced by the NAPI leak patch. Adding the check to only line 692 (as the
reviewer suggests) leaves line 730 unfixed and makes the code more
inconsistent than before.
2. A correct fix needs to cover both sites together, with a consistent error
message and error-path handling.
3. This patch already has a well-defined scope (NAPI cleanup). Adding
unrelated error-handling hygiene muddies the Fixes: attribution and makes it
harder to backport.
> 
>>
>>>                              ath12k_ahb_ext_interrupt_handler,
>>>                              IRQF_TRIGGER_RISING,
>>>                              irq_name[irq_idx], irq_grp);
>>> -            if (ret)
>>> +            if (ret) {
>>>                   ath12k_warn(ab, "failed request_irq for %d\n", irq);
>>> +                ath12k_ahb_free_napi_for_group(irq_grp);
>>> +                goto free_napi_ndev;
>>> +            }
>>>           }
>>>       }
>>>         return 0;
>>> +
>>> +free_napi_ndev:
>>> +    ath12k_ahb_free_napi(ab, i);
>>> +    return ret;
>>>   }
>>>     static int ath12k_ahb_config_irq(struct ath12k_base *ab)
