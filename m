Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C6354779
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791479820; cv=none; b=G/hv/zNZYbYjp4OMh/x/uAHYCmDAAHTEsRO6RGKZbE7J4jk3OQ5y7BCY8qPGcaPLO2SBWf3ke291+wYSUV9U16HCS1JIRDEtW8tqhhLzF5B5WG8omnkdhdmHgM6WpWUt5tqo6Ko1mJINobni97edVOAlNoswxI986bmQX92LGaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791479820; c=relaxed/simple;
	bh=J5b4L3NVScIB6PnKN7Cv/Qkhtff8PDOm/hgVbHonK8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u/OMP9XVSaD3aQPlLxHrgupa/jgQdBA7lIiNCphTAvY3rT/0IfiiiSflNGu73NRDsXzcs77A3FoJwXCYmqg2/Dy9eaTPZJMH+rFQG23C+AeGb0z+5IT3CGZSjcYW+829+4cKh98TEXVGimhHPyTbtdyu4Bjy8FY4usyoxJnBF6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bwyoza1N; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=K+/wU0hN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bwyoza1N";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="K+/wU0hN"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698EW2HW2535815
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 17:16:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MYc0K7zn31TjZNQfuMEltaFhrqgcm0b0cHM1bc1hY94=; b=bwyoza1NbOBHxpM6
	qSvLLRr8Yj+mTPa7WQ+snUF7GxMe3FaohVdletRvlA4M6iPRxtjUjbdkAFsRNI/V
	YqHG52WG5foijAtbOvbZbLk+yq/iLD/3R/aXRSe14PBuLrpZgYejX+1HH4vEk40A
	BJAN27yCE8XM06dtngMmZ/EUKG1hXQOd7QlBPcCPc4WPN0KPhFHh9idlEXN6lMmT
	87XERVecPYUcSmtHUN8brg7W/PQMM7/oQ3c8rqqMTW4xpTZ56Hb1b/0RYCKfmVsJ
	u1bJ3OJQ0OjD445KHsYN/jYJneTJQnw56PR2/iOrqwZ961WqJYlC+eFkZRC7lG7r
	CKHevw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe53yhj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 17:16:58 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc4ac5feaa4so4389993a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791479817; x=1792084617; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MYc0K7zn31TjZNQfuMEltaFhrqgcm0b0cHM1bc1hY94=;
        b=K+/wU0hNzSGxez2lPJZPzyFu1K8rEWgGB2gZ+6Tm1Q0rvZJ94ettOHGxL/mDiyeVNn
         qkRkWs2CgQnI2mm5eu8VnG9m8fEXQpSbxgYFGbuHGLrn51GXu2sgEiy0cOgTrTG2o+8t
         ZeKsQPk5hNdHVDhxQQoSXLFxPFPsBDnKQwQs6OY1demFe6OMNMvM2/O+IBdO8wWFaV+y
         2nU3zeSfNrZHCjjTn4zPkcHBsv5v96hEq7jor8vnr3IREnfy+cz6acPhJyZzMRT6cYVb
         ZUi9EoA33EREh8QmALkA+Vv4kHOF8umpXj81c2CjnLjJY6yVqJWjB5MoQOZVUe1eqEj3
         At1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791479817; x=1792084617;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MYc0K7zn31TjZNQfuMEltaFhrqgcm0b0cHM1bc1hY94=;
        b=bnMPdbNx1J6CL23FEW4Y+/HKpW+kRxi1+GAo/LtC2u01/60H6TaSgRsey9GHdFYOMk
         RayJz/7kN0Q/rS3PMUCPlXOFf1lZ+sy0a4fGFUJV7fY00LWfzV2zb5o1cbZaGa6vfCXb
         RvDRk6w+SDqm8NFxMn1qnjs+gvn5THe7tUZ60Sh/rrhFttEZoHEdB63rWN6njGrS723p
         RHfgk+MHapqjWdqHa6jK9kepYbGVA0MLwLgaI7F7oF+bMT/KhbrA4ajlgrSKofIFXb8v
         0FDySMcgh6mBf7D3RaK27vlzS1dKQQUdAl/1F+Eev4GLxkdFmJlscg+qZb5sI+IA7e7I
         xwyA==
X-Gm-Message-State: AFuF++ljITi+luAwfbWE1mR75jf951fReSu0kPeEaMIITMd4UA1xrB80
	VxL5squ2XUzJGEFMTV7Sm1nwbT8fwv3sQdK5o6+1APl/J5kyCfk78okBWBbGnrj2Y9hYqbtSMI0
	QN3qt+J8wzMNfsOdkduvWPSHk9+GxhuriMNBSzUv3msKgiwPqvDz/UCWquDln3GSv5WDFLw==
X-Gm-Gg: AYBFou3lK1229aYrl7w25jo87UbgMQWeXvR5eUmjF0TNaKtqErdfBkzKPE2Wv2oMKyf
	yg8V1NH5xEC8TEsrEzaB0uK0XyRdfFFg2fz415J9aUYxMVhLpN8xi2QASRJmOIpEN1lKpMX8Blr
	ZhX2vO84IVsxo9no9gpaeaPvlY4oj/pRjlbQtXV63uk53gPXCuW5DUAOy6JQOIuaIPspAzeHvFI
	EDTpRG8ZBrBrsADa02ADSxoJAyKUtHlDjbaUEh3ueKFdii7jlESudFZBg5MRH0FesHt+oChOk0T
	9/fyv/xOdGH0DelmGYB0VUJS7oVpn3SY4vJoTrjfmg4pf/wH+x1YaBVf/Uuhsgm9hkmh675pPnB
	Hu2lK1YJBVxZp5hy/K7nLQZB+2BEEEF0wA1Vq+7P2nvs=
X-Received: by 2002:a05:6a21:140a:b0:3de:5360:ebc6 with SMTP id adf61e73a8af0-3e164d03ebemr2748637.50.1791479817374;
        Thu, 08 Oct 2026 10:16:57 -0700 (PDT)
X-Received: by 2002:a05:6a21:140a:b0:3de:5360:ebc6 with SMTP id adf61e73a8af0-3e164d03ebemr2720637.50.1791479816816;
        Thu, 08 Oct 2026 10:16:56 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3a782fd59sm118501a12.12.2026.10.08.10.16.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 10:16:56 -0700 (PDT)
Message-ID: <ad47c905-7865-4283-99ba-e246ae44d25b@oss.qualcomm.com>
Date: Thu, 8 Oct 2026 22:46:52 +0530
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
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: glbrr6tL4cStLyK2FXCTQyGa_xDoGA1i
X-Authority-Analysis: v=2.4 cv=E4dYNqdl c=1 sm=1 tr=0 ts=6ac7d00a cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=35ZLj8hBI3EEynJP_B0A:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA2OCBTYWx0ZWRfXw8o9e3vv40e4
 lBz99Djzz4u2pjSK/xITCp9bJtXxrSqDlqjiEUSCdj/CVT1FsG8igWZ/gdxXb8sHTcBXqerXtCE
 6tB4Ag4+QmPxSLYsm6EHQ+TXhjvobEc=
X-Proofpoint-GUID: glbrr6tL4cStLyK2FXCTQyGa_xDoGA1i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA2OCBTYWx0ZWRfX0z1RVhZEwsV4
 Zy8X3E9KLlE2SHfweR9WBxAWLe+EY7cYOT3XmCn518darS2q1KhmqmYjJu+MFjtlHG6c2LwHowC
 G/7CEssM0Q8r5jAol36g09j9hSRoevNk91hIYiow27lPJ6ThQ71veqjDmlvCeTPErRueIrawDGS
 h8bHRW/A8Wywx61SaK7sMAMoUO1X8qylXfWMhg+Yxj908JzrvOLG476Fk84kazfbzVTOGnfq3hv
 IuB9Sip1yW6A+qUKC9d2+zzpYU8j6mfQOb98EYCCDxrEAlYgaBElC09UUK6TSR2uXM9jr/bIEZt
 2oW/SMNumRS5grsXrPyS7MVl5XW7xCgFb8kBeUGvHLZHyvRIdsXvyj4aXyyWhwuFVeU3wAvgqhJ
 cVhDSBqmPoq4wn3j2nP0+RDMyVWwl/AEBQILxi6tYiP/AIPt3gzbf87nY06ZUdQlaAgmSWS+e0/
 fedJiqqdGsa0YIcf5kg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_05,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 phishscore=0 spamscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080068

On 10/1/2026 10:24 AM, Aaradhana Sahu wrote:
> Currently, NAPI instances and their associated netdevs allocated for AHB
> external IRQ groups are not released when external IRQ configuration
> fails. They are also not freed when arch_init() fails after
> ath12k_ahb_config_irq() succeeds during probe, or when the driver is
> unloaded.
> 
> Fix this by adding a common cleanup helper to release the NAPI instances
> and associated netdevs. Call it from the external IRQ configuration error
> path, probe error path, and driver cleanup path.
> 
> Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1
> 
> Fixes: 6cee30f0da75 ("wifi: ath12k: add AHB driver support for IPQ5332")
> Fixes: 614c23e24ee8 ("wifi: ath12k: Support arch-specific DP device allocation")
> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
> ---
> v2:
>    -Remove unnecessary irq_grp->napi_ndev NULL check.
> ---
>   drivers/net/wireless/ath/ath12k/ahb.c | 41 ++++++++++++++++++++++++---
>   1 file changed, 37 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
> index 85360365aa4b..9b77632bd1bf 100644
> --- a/drivers/net/wireless/ath/ath12k/ahb.c
> +++ b/drivers/net/wireless/ath/ath12k/ahb.c
> @@ -191,6 +191,26 @@ static void __ath12k_ahb_ext_irq_disable(struct ath12k_base *ab)
>   	}
>   }
>   
> +static void ath12k_ahb_free_napi_for_group(struct ath12k_ext_irq_grp *irq_grp)
> +{
> +	netif_napi_del(&irq_grp->napi);
> +	free_netdev(irq_grp->napi_ndev);
> +	irq_grp->napi_ndev = NULL;
> +}
> +
> +static void ath12k_ahb_free_napi(struct ath12k_base *ab, int num_ext_irq_grp)
> +{
> +	int i;
> +
> +	for (i = 0; i < num_ext_irq_grp; i++)
> +		ath12k_ahb_free_napi_for_group(&ab->ext_irq_grp[i]);
> +}
> +
> +static void ath12k_ahb_free_ext_napi(struct ath12k_base *ab)
> +{
> +	ath12k_ahb_free_napi(ab, ATH12K_EXT_IRQ_GRP_NUM_MAX);
> +}
> +
>   static void ath12k_ahb_ext_grp_enable(struct ath12k_ext_irq_grp *irq_grp)
>   {
>   	int i;
> @@ -622,8 +642,10 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
>   		irq_grp->grp_id = i;
>   
>   		irq_grp->napi_ndev = alloc_netdev_dummy(0);
> -		if (!irq_grp->napi_ndev)
> -			return -ENOMEM;
> +		if (!irq_grp->napi_ndev) {
> +			ret = -ENOMEM;
> +			goto free_napi_ndev;
> +		}
>   
>   		netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
>   			       ath12k_ahb_ext_grp_napi_poll);
> @@ -675,12 +697,19 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)


platform_get_irq_byname() can return a negative error code. Should we 
handle that explicitly before calling devm_request_irq()?

Something like:

  irq = platform_get_irq_byname(ab->pdev, irq_name[irq_idx]);
   if (irq < 0) {
	ath12k_warn(ab, "failed to retrieve irq number for %s\n", 
irq_name[irq_idx]);
         ret = irq;
         ath12k_ahb_free_napi_for_group(irq_grp);
         goto free_napi_ndev;
   }


>   					       ath12k_ahb_ext_interrupt_handler,
>   					       IRQF_TRIGGER_RISING,
>   					       irq_name[irq_idx], irq_grp);
> -			if (ret)
> +			if (ret) {
>   				ath12k_warn(ab, "failed request_irq for %d\n", irq);
> +				ath12k_ahb_free_napi_for_group(irq_grp);
> +				goto free_napi_ndev;
> +			}
>   		}
>   	}
>   
>   	return 0;
> +
> +free_napi_ndev:
> +	ath12k_ahb_free_napi(ab, i);
> +	return ret;
>   }
>   
>   static int ath12k_ahb_config_irq(struct ath12k_base *ab)
> @@ -1353,7 +1382,7 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
>   	ret = ab_ahb->device_family_ops->arch_init(ab);
>   	if (ret) {
>   		ath12k_err(ab, "AHB arch_init failed %d\n", ret);
> -		goto err_rproc_deconfigure;
> +		goto err_free_irq;
>   	}
>   
>   	ret = ath12k_core_init(ab);
> @@ -1367,6 +1396,9 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
>   err_deinit_arch:
>   	ab_ahb->device_family_ops->arch_deinit(ab);
>   
> +err_free_irq:
> +	ath12k_ahb_free_ext_napi(ab);
> +
>   err_rproc_deconfigure:
>   	mutex_lock(&ath12k_rproc_info_lock);
>   	ath12k_ahb_deconfigure_rproc(ab);
> @@ -1409,6 +1441,7 @@ static void ath12k_ahb_free_resources(struct ath12k_base *ab)
>   	struct platform_device *pdev = ab->pdev;
>   	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
>   
> +	ath12k_ahb_free_ext_napi(ab);
>   	ath12k_hal_srng_deinit(ab);
>   	ath12k_ce_free_pipes(ab);
>   	ath12k_ahb_resource_deinit(ab);
> 
> base-commit: b64812cb6cec118f6c59a4ec2bd4848db17f6bb2


-- 
Ramesh
