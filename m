Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339773AA4EB
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 05:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785218223; cv=none; b=U4Wkcd4eBu6BQGUj4bsZqGDdhdTydffC+HbOyQO4YP51FbqMR1Ao95dXF3WtrgO+uJk1WYYK/OPaRZfFaj2EtGPkHLLOzk3Hz7+5qxjY1WLTV2OwOP1mFHAx7KQzEDIgLYogPYr1iuxHiG7eOieurnEAmOziEFSpjrcyMZRvP6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785218223; c=relaxed/simple;
	bh=2blZB1jV12eZ/5s7gEzk8tvSAxwkiIstgao6aHPqp2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=coZe/3eub+uhFeXq4vC6IXh6IZDucLcswrWZOE0OvjTK2+GMCZPdKphHKTTbMojr7a/AIqK3rKXYIPc6CXVLs45Tq/PQeV14sQtWJ6nNYurAk5DLy5lC6E9Ke0k2ymHEg0brc+5VrSrbWALjDdIzuyUV2wQisAtBgCAStCCLQ4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=M2J7ZNOj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GyVVt95y; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="M2J7ZNOj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GyVVt95y"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66S3akCs1673385
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 05:57:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	F+odnqadZBL3FcgD3fTy4z7A88GEP8qiW9be37JO80U=; b=M2J7ZNOjbhORguU/
	/IABY3powGCGKcXMlgHwuH63ep/j4C8mL2b+lpeUUI1LO8I+SZdfZsOu3P0njWrG
	QbJvEeCcTi1IWGD1J3GFFwwLl9HEOIq7oEL9vaxDXW5Pex0+NCnRDZW0zoOlQp35
	fMwrPLQ9QDBsWk8haEGr6eXHN26qqXJwfz4cxNWTt+EUmMv1pcwuKMzns2K5033P
	EmGkKkBt+E+oFb98OLgHqIdOuwyZSVi4DkmBqmeF8/pG+vzyxntgW9J51xP9HG8N
	w5hfT2C6Kx0ewwDNBzSMPAHV5DRyqUTT7an1zX8k8tZeTwtqrxbi6HPROoHL09WF
	9An0Aw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpbrstksb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 05:57:00 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d001671a54so29234035ad.2
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 22:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785218220; x=1785823020; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F+odnqadZBL3FcgD3fTy4z7A88GEP8qiW9be37JO80U=;
        b=GyVVt95yfbpf9sovznAeNqEj/fArAVhIII1Xc1+Pp9AOCBIO7DVRZX7yvz2yiBfpbG
         NIRO+AFouZz2SDVuXdvLbNE0mLeJkUfv8PqIlqfm8uWrGLB8VeeC7JJ3NecI2d5LbtVJ
         zGskDohCIEL2t6FxP3UvGrTRe684perRcrJ/fzSu2rjqSDqHUqfZIkYLRk9a0njpDpwP
         pit+HBegtbRim8Z/p2TNo8FgqL8SzeoS8x7MyW1CVXiaMeX6HHqZH8SiRi8VLEJm4Tdf
         NvAJ7+eou0HuLtcY3qeJrVHraPot65BgZfNhtowyCI/btdOeXZD8XVWWMsOHaLLeHbbQ
         qsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785218220; x=1785823020;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F+odnqadZBL3FcgD3fTy4z7A88GEP8qiW9be37JO80U=;
        b=VF7bEzHRZSdoXaE70XV/vxwd68RjMNRwBZUfTGUDrUrBt2HhmXw9402tHYHO1q8o2I
         H5I8EzBL3VC9k7Sbf7VYCZx2ZDwoNWaiPNvo+QqqSGtp8o8H/k8/frNBM2ALS7dfsmOB
         Qz3zzisZEh+mgWjnpo0q3Q/xrZRz8GSnQ9tyiRVSG9FhJyexzDef4UGR35ju47W+T2F+
         q8mrKzauAOxskfznb5b05jzKoTTxDmQ6QfFCPGSKaSjc3ypcwP+wBAYiAEln/S1BOnD6
         za3HdtU4RYkWKohZp/timE0yZEC/vyuAvVOw+XeD5fiAgLlX1sHb5k6aI8Jl9rEzifaA
         89/g==
X-Gm-Message-State: AOJu0Yzet+WJp0f4OTciflqBdqRV08Muiwn4lMckicaR5kA+Ys/jYdyx
	tjp68L1N4lv1LPCTKnMAeL/aJ/rHIbwwI9p6bZxMB5Uk4hf0xF927CtvAeF8W1kX4tdZZVAuf/V
	rMXRyNuYCEzYGNZl3enp3sch46FXcsh2uoRN1nMxUEY33G1GI063+vsy/OCHpYOAIgdtUtQ==
X-Gm-Gg: AR+sD1016RZ3Zq/xrKI4jTmVQEF6F2snORsFksQV3nGnxxsPJBkLPY4NJ1LRjERlpod
	MtwuQNJRmq3VY0RU36sLpxJi8/vCRn48bw/rz6Mpvj4liSjYk6e4Enohzoi6b86wwl/O6CEUOa4
	a5W8gOmNzOlYk1QMUFZ7e+cFZCEQlsDvrm3cOptl7ieBQzLZUgPn3tsKjqxZ7CmYK5mi5QvngxC
	jPACSZKjAcTVA5yOksrO8d+jX/C+1x/DYLtH1nbLGZjVGGJHyT1gUqzkFvEz4NnS0f6ZwILuhg1
	86EioRD6QHsRLhcQOsIxh5AhclSmgiLWUImnFwfKhl0k3pmOIFqCTYAhRxAv9flwv+jm5ruWv2g
	FIlBX4PnlECx6akCBaZ+mrgikXLz+aPMQCJUsuWWTnZdhbyxACLKDR5pxmt5SyJP9T0qRz6wwVQ
	==
X-Received: by 2002:a17:903:2a88:b0:2c9:ae0b:61e3 with SMTP id d9443c01a7336-2d015b145bcmr11801095ad.2.1785218219799;
        Mon, 27 Jul 2026 22:56:59 -0700 (PDT)
X-Received: by 2002:a17:903:2a88:b0:2c9:ae0b:61e3 with SMTP id d9443c01a7336-2d015b145bcmr11800865ad.2.1785218219347;
        Mon, 27 Jul 2026 22:56:59 -0700 (PDT)
Received: from [10.133.33.251] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bc347sm45843315ad.40.2026.07.27.22.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 22:56:59 -0700 (PDT)
Message-ID: <1e19adf8-d3cd-47c8-a986-05faae7af3c5@oss.qualcomm.com>
Date: Tue, 28 Jul 2026 13:56:55 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: ZhaoJinming <zhaojinming@uniontech.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260728031335.3818736-1-zhaojinming@uniontech.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260728031335.3818736-1-zhaojinming@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDA1MiBTYWx0ZWRfX4jEKoHTxWzBK
 VMkHb8+UOIwZoAZmwYY2FOVi/1BkIwjWlLS/zovaGEv4qYzgasXSjVRnOi5x1kCctN8JTX9/yVD
 8q4A2fWeaTPfbb/0shhTTNQw+/oIgbiHuBACJYfpvSwKFqcaChD9UMGNdjpvaUZAVn5U7UHH+dn
 UBZEDGfsdJ+5wdhMGGRN1W0eRRJx2mncMuDgcXGAH1udPhL9od2VTgRsTOSnoduZf6o824EG9Do
 F5aNrJNtLpjW/8FoNxTx9jIW9q/qoHWdTfPCDBX1fw4G4U5qAe5d3rb/JAtO0eGJzOZMBzYOpOu
 qMZeTFDpTh2fvLu9StVj585Vsu9xEg9KdJ0WO/y7Ha/Sj2nTLu49B5ZhN/MNm2g2Rko8meFWzXI
 d83mzwyc4I3C74AIyhy05dCaVB4hdrUuteKsFqKfcviRX7cJrgb9YQp3vZoA5Gc5fYRSQ2YxKYe
 y08FN3dFa8Gvu0KM1aQ==
X-Proofpoint-ORIG-GUID: rPN8G6F4PwvyymVMNdFjS8j6riBF0Jec
X-Proofpoint-GUID: rPN8G6F4PwvyymVMNdFjS8j6riBF0Jec
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a6844ac cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=iHwBjlyiAAAA:8 a=X7nvTDC9Kz5FJV0lFOkA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22 a=uNSKXYNwxGiU6LD0JREI:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDA1MiBTYWx0ZWRfX1zsDlXJFrEUR
 VbDOX7YGLm6CYiWJhoR8acYPXowX5Wk0eHInkFTHYD/iR0pKNdYmNobHXIoThC5KbO40InLmgwy
 qdVWVf0qA58zo7LapV8Vx1CtnBinxbE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_01,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 phishscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607280052



On 7/28/2026 11:13 AM, ZhaoJinming wrote:
> In ath11k_ahb_config_irq(), when a CE request_irq() fails, the function
> returns the error immediately without freeing the CE IRQs that were
> successfully registered in previous loop iterations. The probe error
> path does not call ath11k_ahb_free_irq() either, so the previously
> registered CE IRQ handlers remain attached to the interrupt lines and
> are never released.
> 
> In ath11k_ahb_config_ext_irq(), when an external request_irq() fails,
> the error is only logged and the loop continues. The function then
> returns 0 indicating success, leaving the device in a partially
> configured state where some external IRQs are not registered. This
> causes enable_irq()/disable_irq()/free_irq() to be called on
> unregistered IRQs during runtime and remove/shutdown, triggering
> WARN_ON(!desc->action), and missing interrupt handlers lead to data
> loss.
> 
> Additionally, if alloc_netdev_dummy() fails for a later IRQ group, the
> function returns -ENOMEM without freeing the ext IRQs and napi_ndev
> that were successfully set up for earlier groups.
> 
> Fix all three issues: propagate the error up to the caller and unwind
> all successfully registered IRQs and allocated resources on failure.
> Also move ab->irq_num[irq_idx] assignment after request_irq() succeeds
> in the ext IRQ path to match the CE IRQ path and avoid storing a stale
> IRQ number on failure.
> 
> Link: https://lore.kernel.org/all/b6903572-52cc-4c41-b9cf-5845e387c176@oss.qualcomm.com/

this is not the right way to track old versions. If want to do that the right place is in
the changelog.

Note if you use b4 tool this tracking burden can be done automatically.

> Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
> ---
> 
> Changes in v7:
> - Resend in a new thread. No content changes from v6.

I mean here.

> 
> Changes in v6:
> - Move ab->irq_num[irq_idx] = irq after request_irq() succeeds in the
>   ext IRQ path to match the CE IRQ logic and avoid storing a stale IRQ
>   number on failure.
> 
> Changes in v5:
> - Resend as a fresh thread. No content changes from v4.
> 
> Changes in v4:
> - Drop the napi_ndev NULL guard in ath11k_ahb_free_ext_irq_grp() as it
>   is unreachable in all existing call paths. A silent guard against an
>   impossible condition hides bugs instead of exposing them.
> 
> Changes in v3:
> - Extract ath11k_ahb_free_ext_irq_grp() to handle per-group ext IRQ
>   cleanup and refactor ath11k_ahb_free_ext_irq() to use it.
> - On request_irq() failure in ath11k_ahb_config_ext_irq(), immediately
>   clean up the current group via ath11k_ahb_free_ext_irq_grp() before
>   jumping to the error label to unwind earlier groups.
> - Move u32 num_irq declaration before the irq_grp assignment to follow
>   declaration-before-statement ordering.
> - Extract ath11k_ahb_free_ce_irqs() to handle partial/full CE IRQ cleanup
>   and refactor ath11k_ahb_free_irq() to use it, replacing the duplicated
>   err_ce_irq cleanup loop in ath11k_ahb_config_irq().
> 
> Changes in v2:
> - Move `irq_grp` declaration from for-loop body to function scope to fix
>   compile error in err_request_irq error path.
> - Set ret = -ENOMEM before goto err_request_irq on alloc_netdev_dummy()
>   failure to avoid returning uninitialized value.
> - When ath11k_ahb_config_ext_irq() fails, unwind the already-registered
>   CE IRQs via a shared err_ce_irq cleanup path to avoid leaking them.
> 
> diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
> index 1e1dea485760..ec5bf5c9fd79 100644
> --- a/drivers/net/wireless/ath/ath11k/ahb.c
> +++ b/drivers/net/wireless/ath/ath11k/ahb.c
> @@ -431,36 +431,44 @@ static void ath11k_ahb_init_qmi_ce_config(struct ath11k_base *ab)
>  	ab->qmi.service_ins_id = ab->hw_params.qmi_service_ins_id;
>  }
>  
> -static void ath11k_ahb_free_ext_irq(struct ath11k_base *ab)
> +static void ath11k_ahb_free_ext_irq_grp(struct ath11k_base *ab,
> +					struct ath11k_ext_irq_grp *irq_grp)
>  {
> -	int i, j;
> -
> -	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
> -		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
> +	int j;
>  
> -		for (j = 0; j < irq_grp->num_irq; j++)
> -			free_irq(ab->irq_num[irq_grp->irqs[j]], irq_grp);
> +	for (j = 0; j < irq_grp->num_irq; j++)
> +		free_irq(ab->irq_num[irq_grp->irqs[j]], irq_grp);
>  
> -		netif_napi_del(&irq_grp->napi);
> -		free_netdev(irq_grp->napi_ndev);
> -	}
> +	netif_napi_del(&irq_grp->napi);
> +	free_netdev(irq_grp->napi_ndev);
>  }
>  
> -static void ath11k_ahb_free_irq(struct ath11k_base *ab)
> +static void ath11k_ahb_free_ext_irq(struct ath11k_base *ab)
>  {
> -	int irq_idx;
>  	int i;
>  
> -	if (ab->hw_params.hybrid_bus_type)
> -		return ath11k_pcic_free_irq(ab);
> +	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++)
> +		ath11k_ahb_free_ext_irq_grp(ab, &ab->ext_irq_grp[i]);
> +}
>  
> -	for (i = 0; i < ab->hw_params.ce_count; i++) {
> +static void ath11k_ahb_free_ce_irqs(struct ath11k_base *ab, int max_idx)
> +{
> +	int irq_idx, i;
> +
> +	for (i = 0; i < max_idx; i++) {
>  		if (ath11k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
>  			continue;
>  		irq_idx = ATH11K_IRQ_CE0_OFFSET + i;
>  		free_irq(ab->irq_num[irq_idx], &ab->ce.ce_pipe[i]);
>  	}
> +}
> +
> +static void ath11k_ahb_free_irq(struct ath11k_base *ab)
> +{
> +	if (ab->hw_params.hybrid_bus_type)
> +		return ath11k_pcic_free_irq(ab);
>  
> +	ath11k_ahb_free_ce_irqs(ab, ab->hw_params.ce_count);
>  	ath11k_ahb_free_ext_irq(ab);
>  }
>  
> @@ -524,20 +532,25 @@ static irqreturn_t ath11k_ahb_ext_interrupt_handler(int irq, void *arg)
>  static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
>  {
>  	struct ath11k_hw_params *hw = &ab->hw_params;
> +	struct ath11k_ext_irq_grp *irq_grp;
>  	int i, j;
>  	int irq;
>  	int ret;
>  
>  	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
> -		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
>  		u32 num_irq = 0;
>  
> +		irq_grp = &ab->ext_irq_grp[i];
> +
>  		irq_grp->ab = ab;
>  		irq_grp->grp_id = i;
>  
>  		irq_grp->napi_ndev = alloc_netdev_dummy(0);
> -		if (!irq_grp->napi_ndev)
> -			return -ENOMEM;
> +		if (!irq_grp->napi_ndev) {
> +			ret = -ENOMEM;
> +			irq_grp->num_irq = 0;
> +			goto err_request_irq;
> +		}
>  
>  		netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
>  			       ath11k_ahb_ext_grp_napi_poll);
> @@ -585,14 +598,11 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
>  				}
>  			}
>  		}
> -		irq_grp->num_irq = num_irq;
> -
> -		for (j = 0; j < irq_grp->num_irq; j++) {
> +		for (j = 0; j < num_irq; j++) {
>  			int irq_idx = irq_grp->irqs[j];
>  
>  			irq = platform_get_irq_byname(ab->pdev,
>  						      irq_name[irq_idx]);
> -			ab->irq_num[irq_idx] = irq;
>  			irq_set_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
>  			ret = request_irq(irq, ath11k_ahb_ext_interrupt_handler,
>  					  IRQF_TRIGGER_RISING,
> @@ -600,11 +610,24 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
>  			if (ret) {
>  				ath11k_err(ab, "failed request_irq for %d\n",
>  					   irq);
> +				irq_grp->num_irq = j;
> +				ath11k_ahb_free_ext_irq_grp(ab, irq_grp);
> +				goto err_request_irq;
>  			}
> +			ab->irq_num[irq_idx] = irq;
>  		}
> +
> +		irq_grp->num_irq = num_irq;
>  	}
>  
>  	return 0;
> +
> +err_request_irq:
> +	for (i--; i >= 0; i--) {
> +		irq_grp = &ab->ext_irq_grp[i];
> +		ath11k_ahb_free_ext_irq_grp(ab, irq_grp);
> +	}
> +	return ret;
>  }
>  
>  static int ath11k_ahb_config_irq(struct ath11k_base *ab)
> @@ -629,16 +652,24 @@ static int ath11k_ahb_config_irq(struct ath11k_base *ab)
>  		ret = request_irq(irq, ath11k_ahb_ce_interrupt_handler,
>  				  IRQF_TRIGGER_RISING, irq_name[irq_idx],
>  				  ce_pipe);
> -		if (ret)
> +		if (ret) {
> +			ath11k_err(ab, "failed request_irq for %d\n", irq);
> +			ath11k_ahb_free_ce_irqs(ab, i);
>  			return ret;
> +		}
>  
>  		ab->irq_num[irq_idx] = irq;
>  	}
>  
>  	/* Configure external interrupts */
>  	ret = ath11k_ahb_config_ext_irq(ab);
> +	if (ret) {
> +		ath11k_err(ab, "failed to configure ext irq: %d\n", ret);
> +		ath11k_ahb_free_ce_irqs(ab, ab->hw_params.ce_count);
> +		return ret;
> +	}
>  
> -	return ret;
> +	return 0;
>  }
>  
>  static int ath11k_ahb_map_service_to_pipe(struct ath11k_base *ab, u16 service_id,

