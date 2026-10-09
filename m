Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5D339B94F
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 03:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791517121; cv=none; b=TN+TLtgkMm7pUexPVBifv0HLJ5UEt2gGGvAO+FoUq//XVXqpjx0XhOew93dalvCP1gJELZP7Y6WIGJQ7/eU916u/BcjIMv348p3zPNZG26jv8UBdy6FqgsFnWa2moUSDM4EvJEHomlieapxajGoPEaZiLGAHtifrviEJLw+M6A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791517121; c=relaxed/simple;
	bh=/4CwUQtCuAj6SnLXhC2h/25oUcSBtfzCNuRxF8Z/eDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TsGy3TIVCGdkMLsHI0rI5r7iUyZ2zfy2Z5qTvLpnN2sIQTe373Krw6nvOT2zOC8mRA75J1y+nGWrG3vzZlgupwbCQTHtM9xSNectQ0d5pvQLh0oV6OR3jIhlRzyfV1ssrcwxMh+RJtEDcGixWF4wOgRQPQKjZiQ+Jyv0hl/no9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oD9ooEr3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=as1WK2//; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oD9ooEr3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="as1WK2//"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6993HhTJ452241
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 03:38:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xHiDjV2z2nC3iW+RoZ7ZflGg3VrbNf1FWrGfvymicZk=; b=oD9ooEr3LacX78wA
	Tus3NYLBUEx1A7UifeuGG9suKY7jEL2hncthcoUCo5FwQKAX/KlQgo7c2XObINSz
	nYXubymasqlZfCC0BIla6okzKZePR4jdoQvGQd89rEGhVHV33Ivrw/52ipugiDtH
	QQaT3yavuLHUFz8VkcTVuN9uni8qUT6WC+wd9MDLZLwzosy3I/5IqnErjP42JnxW
	UwjQrJk+lsfg8GEiJMQZWhOpYZ++3+5t7s+pDeGXeqKt7wP9y8e7eHrWz03mG0hm
	LghkopeKgU91+Yy9HnDjoFIa01mIJawwAmLR/IN16sbE7iHUupNl9TrJ1VygzqMw
	00ALLg==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6b9kjw6e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 03:38:35 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1663fb7e005so1558719c88.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 20:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791517114; x=1792121914; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xHiDjV2z2nC3iW+RoZ7ZflGg3VrbNf1FWrGfvymicZk=;
        b=as1WK2//LCdRdlGSraVl7qRF7LBuzpoUpocYfoDmk/RMJEsG31JPvD5cQ96SHSkMBU
         qBxSHdKMJsbW53QjszK4w4CbnAAtfmrHJBMwo+bK1gZYaeochhrf89pGdkTy6MjHMSjD
         pHE3UUg0io/wD879F1v/Z1CSXn8alG5/j5HvbMHc1T7dNDMeDrVdSsQekq7xXwKUhcvO
         ZsxEc7BFcX0G3HSHmPe99x7d73bjukFQiPVxw4yfwCBlsgXqD/lWdGyuZIyJ8ujMQd4d
         k6aumuvTXkSGHI4O3NiruPQUVMYBxKCllGHAeKSTSoF9Km2TGHDq+fVEyrmRD2GEAzdQ
         7wJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791517114; x=1792121914;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xHiDjV2z2nC3iW+RoZ7ZflGg3VrbNf1FWrGfvymicZk=;
        b=lNz8fwOG99LxcxySN5V2me/nXhkcUXiAKvPdHfDO3BEDpql1GM2Ktq4SO1JsnFq7k3
         +n9Hz9ztPMQcZuPUhbQ2THwFFCtLZrS+yWRd3n/GOFFD0Jgv15ucZQj1gd2R7VqPKezO
         BMTc4QtoUerpbRDquzUBnFUMTFiWnRfoCRPEaK83JnWMW9RngBgKVeDdaTTpGHX9XeER
         uKHFWnDHcw5n/otvvhF/DYOM8cfArfuq+NTu1DZSzyfuXYcZN6y7Q7eDteFFyBW/yRBe
         u/YIxO5M14q+2hPT/zlPNW1YgeI9XiVlPLySIqOgQ2+kXIzvkYt/yJd0gL+J9fGK4iNH
         KedA==
X-Gm-Message-State: AFuF++mPVm9kRS/jfw3wANhWgL0vUL9FZPQ0kLYUWoY2Uggtwwi+lJ7z
	AA+RcnHTThd//gE5HYRyITq1HH1Zgez4UAk7NBl/ShmVp2mYZfmzFulhpiCPvCThXUKKrI6V69+
	aZuWRp6gNfcVlXd8bGzZ89DZFDr/LVK1t00JOvG/9lvuby5jzD68jdUVss4ap3ZFSyG/lZg==
X-Gm-Gg: AYBFou1x3mcWHVtgQEVWwyvrHyCPrz7MqCpMuG6hOmn0y9xbkm9UEeuJK7NvJXvLtE/
	8kAAZsLj/J4Wdrt1m+hV8cnwyfR2t36zXSKKSi7jDO4Eyl8GrR9pDBpxeUjxOHDCaaZ46n7YsiV
	Cpy/xh9TbsBeniJ9YNY3U7o+3+iDwk3yqyX0EvjFaAwtYDyTkjGJRfjnui9uoj5x0wZPV7VBPn2
	0Ftktw9yj4wOZzTVjsG+UzntZHrFWOewZReJtPlk6tFYmfVfYBO8rAKjOLgF4a4+3ttVxC79Ll1
	uoD/DbnIGPnX2ueBDUZAZ/uQh3C3KthiNqudhMpA+XfBkUjq+OuqDVDfoTUday6XeSGWeArlb6j
	0rpzTvFvVWwp6MPjxHobB2yae3ynGdeQaKg==
X-Received: by 2002:a05:7022:b052:20b0:14d:444b:1ae5 with SMTP id a92af1059eb24-16a6260178bmr871197c88.33.1791517114205;
        Thu, 08 Oct 2026 20:38:34 -0700 (PDT)
X-Received: by 2002:a05:7022:b052:20b0:14d:444b:1ae5 with SMTP id a92af1059eb24-16a6260178bmr871165c88.33.1791517113525;
        Thu, 08 Oct 2026 20:38:33 -0700 (PDT)
Received: from [10.152.193.243] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a42407e7sm2284833c88.15.2026.10.08.20.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 20:38:33 -0700 (PDT)
Message-ID: <2d52c324-59e3-411a-8012-e530426eed3a@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 09:08:29 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2] wifi: ath12k: Fix NAPI resource leaks in AHB
 external IRQ paths
To: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
 <ad47c905-7865-4283-99ba-e246ae44d25b@oss.qualcomm.com>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <ad47c905-7865-4283-99ba-e246ae44d25b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: odHtvS6GI3hCnM4TD2izAC-npv_0Y49y
X-Authority-Analysis: v=2.4 cv=U98Hnuru c=1 sm=1 tr=0 ts=6ac861bb cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=T0alG8a80v0CmeRluKIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDAxNCBTYWx0ZWRfXxkMcqcW7QmCo
 mwXx0eHx6I4hyLjIskxxHSxKb7HJ7HpSVJqok/je5KudMTzqyBva+i654JGYlf5Unvs1uFhCmMw
 WOS/ZVlIu454K3+wG+RMVHpkwJJ+5bs=
X-Proofpoint-GUID: odHtvS6GI3hCnM4TD2izAC-npv_0Y49y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDAxNCBTYWx0ZWRfX14x4HVyD2TM/
 qYAE1gHx+CV2W3fMVeSWz4xUxQNJndv+hoohGjduqTfk+/2j5qJU9LKnJSyhTCmgoQ2KfZWslKk
 PkaCuZvEchlEhDJqCIoDizZUJ04usQUoWUZl0moq/3otMPEWzB1BYBL3VWMSt8NMPHDV1LCLRI7
 rWKeqlwlRYaYn46AYIh9QLa4lUUrBK818y/czbXpCWtTMJ3DrcOFTkLfTpXKskmAHCyojKtzkLk
 NlKTcuX+4/kfIC2MhTsc83krl3Ie8StaYJZT9eDVYik/OjYueFRqiiIzM68j78yh4NMZSv+qkeh
 lk48vTc+F23OhrFZ8qprjvR0ZYVgmL+u059J43PA69UGOVHhiwkyplCbDa/mC0DsZILRQ4ZrLv+
 HdlmrVAf1XPw4A9l2J+nsr/wk0/7p4joQ7ChdMzJR8mwLuaUdpB+xhKBpDrGxE6Ye5Wi3SdPNjN
 E0QJBQTvPCAP4QH1pBw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_02,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090014



On 10/8/2026 10:46 PM, Rameshkumar Sundaram wrote:
> On 10/1/2026 10:24 AM, Aaradhana Sahu wrote:
>> Currently, NAPI instances and their associated netdevs allocated for AHB
>> external IRQ groups are not released when external IRQ configuration
>> fails. They are also not freed when arch_init() fails after
>> ath12k_ahb_config_irq() succeeds during probe, or when the driver is
>> unloaded.
>>
>> Fix this by adding a common cleanup helper to release the NAPI instances
>> and associated netdevs. Call it from the external IRQ configuration error
>> path, probe error path, and driver cleanup path.
>>
>> Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1
>>
>> Fixes: 6cee30f0da75 ("wifi: ath12k: add AHB driver support for IPQ5332")
>> Fixes: 614c23e24ee8 ("wifi: ath12k: Support arch-specific DP device allocation")
>> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
>> ---
>> v2:
>>    -Remove unnecessary irq_grp->napi_ndev NULL check.
>> ---
>>   drivers/net/wireless/ath/ath12k/ahb.c | 41 ++++++++++++++++++++++++---
>>   1 file changed, 37 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
>> index 85360365aa4b..9b77632bd1bf 100644
>> --- a/drivers/net/wireless/ath/ath12k/ahb.c
>> +++ b/drivers/net/wireless/ath/ath12k/ahb.c
>> @@ -191,6 +191,26 @@ static void __ath12k_ahb_ext_irq_disable(struct ath12k_base *ab)
>>       }
>>   }
>>   +static void ath12k_ahb_free_napi_for_group(struct ath12k_ext_irq_grp *irq_grp)
>> +{
>> +    netif_napi_del(&irq_grp->napi);
>> +    free_netdev(irq_grp->napi_ndev);
>> +    irq_grp->napi_ndev = NULL;
>> +}
>> +
>> +static void ath12k_ahb_free_napi(struct ath12k_base *ab, int num_ext_irq_grp)
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < num_ext_irq_grp; i++)
>> +        ath12k_ahb_free_napi_for_group(&ab->ext_irq_grp[i]);
>> +}
>> +
>> +static void ath12k_ahb_free_ext_napi(struct ath12k_base *ab)
>> +{
>> +    ath12k_ahb_free_napi(ab, ATH12K_EXT_IRQ_GRP_NUM_MAX);
>> +}
>> +
>>   static void ath12k_ahb_ext_grp_enable(struct ath12k_ext_irq_grp *irq_grp)
>>   {
>>       int i;
>> @@ -622,8 +642,10 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
>>           irq_grp->grp_id = i;
>>             irq_grp->napi_ndev = alloc_netdev_dummy(0);
>> -        if (!irq_grp->napi_ndev)
>> -            return -ENOMEM;
>> +        if (!irq_grp->napi_ndev) {
>> +            ret = -ENOMEM;
>> +            goto free_napi_ndev;
>> +        }
>>             netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
>>                      ath12k_ahb_ext_grp_napi_poll);
>> @@ -675,12 +697,19 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
> 
> 
> platform_get_irq_byname() can return a negative error code. Should we handle that explicitly before calling devm_request_irq()?
> 
> Something like:
> 
>  irq = platform_get_irq_byname(ab->pdev, irq_name[irq_idx]);
>   if (irq < 0) {
>     ath12k_warn(ab, "failed to retrieve irq number for %s\n", irq_name[irq_idx]);
>         ret = irq;
>         ath12k_ahb_free_napi_for_group(irq_grp);
>         goto free_napi_ndev;
>   }
> 

You're right, thanks for pointing this out. This patch focuses on fixing the NAPI resource leaks.
Since handling the IRQ retrieval error is an existing issue, would it be okay to address it in a
separate patch?

> 
>>                              ath12k_ahb_ext_interrupt_handler,
>>                              IRQF_TRIGGER_RISING,
>>                              irq_name[irq_idx], irq_grp);
>> -            if (ret)
>> +            if (ret) {
>>                   ath12k_warn(ab, "failed request_irq for %d\n", irq);
>> +                ath12k_ahb_free_napi_for_group(irq_grp);
>> +                goto free_napi_ndev;
>> +            }
>>           }
>>       }
>>         return 0;
>> +
>> +free_napi_ndev:
>> +    ath12k_ahb_free_napi(ab, i);
>> +    return ret;
>>   }
>>     static int ath12k_ahb_config_irq(struct ath12k_base *ab)
>> @@ -1353,7 +1382,7 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
>>       ret = ab_ahb->device_family_ops->arch_init(ab);
>>       if (ret) {
>>           ath12k_err(ab, "AHB arch_init failed %d\n", ret);
>> -        goto err_rproc_deconfigure;
>> +        goto err_free_irq;
>>       }
>>         ret = ath12k_core_init(ab);
>> @@ -1367,6 +1396,9 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
>>   err_deinit_arch:
>>       ab_ahb->device_family_ops->arch_deinit(ab);
>>   +err_free_irq:
>> +    ath12k_ahb_free_ext_napi(ab);
>> +
>>   err_rproc_deconfigure:
>>       mutex_lock(&ath12k_rproc_info_lock);
>>       ath12k_ahb_deconfigure_rproc(ab);
>> @@ -1409,6 +1441,7 @@ static void ath12k_ahb_free_resources(struct ath12k_base *ab)
>>       struct platform_device *pdev = ab->pdev;
>>       struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
>>   +    ath12k_ahb_free_ext_napi(ab);
>>       ath12k_hal_srng_deinit(ab);
>>       ath12k_ce_free_pipes(ab);
>>       ath12k_ahb_resource_deinit(ab);
>>
>> base-commit: b64812cb6cec118f6c59a4ec2bd4848db17f6bb2
> 
> 

