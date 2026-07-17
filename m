Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5F4311958
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 03:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784260078; cv=none; b=r0pjQ1UG5Z9WMsTu8wh15uepwAJICsHlk9KU7A8+HbQfctNnMBiI+3wY5vs2f+pTlW160NHZemUjE1GgI8XKTWZzISjwehd4wQtwTXHkus1NNuqA4DD1i1VQa6pfvoAfd7/tZab7mevJ2PgTOXOmqc20pFxkudVPY+autaufC8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784260078; c=relaxed/simple;
	bh=0snn6cffv7wwX2nM6H0iFGJQFCyMxq1fGbpv8LGBCuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g1K2qf1cH2WTA8t2Qg9MvJS1CNQeNzCsGMdecNO+6oVL1EZlrvmRiZVHqz92ZgMbPHg70Xqym5B0vGsdV0gq5QHnPG+iSADbn9p9px1bDNAgV7TDx9ARwQRoalT1nPpnO0RkK6r//E5oB0GV81JDOGo8nwaB95K2xDNqZl1EIPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=djgK6yiP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EbuMtnaQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="djgK6yiP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EbuMtnaQ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66H34TnH183554
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 03:47:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	s2XQqwVkMap4lirEXwZf+U9qWwV6X1eZsLJriPQiJ0o=; b=djgK6yiPQtG5YWDJ
	7AZ1h1D/gAz7IT1hoYSv3cVabVEFky7nTtGAoJZhvdMAmcJmN1vUgRRDc60M8Ywv
	iEGtBByIFvXPhio1mib8ngDG+FZkEetl0gucZLcbX2aYAvgu7MAYaLeoNDMu271x
	hokmtYfnzKmQGIUpwoiEXGdeMXhN15xI5HYgc6ghFSweEHgVwGxBZ3g7s3rgQ5RR
	/vupyzijXc77xii9QMfsQ/VWONduAjtWb3fdqMg1anqsuT2d28eyLns0dbGYtfEf
	HM8+LkbpZcaNQWe1GUBhXs6RxFCFBvzExttTIJP0/ML6vMVxtHTNaEG9jLjwcWYV
	TbAIKQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ff1m9jh8p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 03:47:55 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84a251c2e3eso1046082b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 20:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784260075; x=1784864875; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s2XQqwVkMap4lirEXwZf+U9qWwV6X1eZsLJriPQiJ0o=;
        b=EbuMtnaQ2BbfjsRZfrS1bFk1WFnrKfjCglkkjkLUpKXukeQsd3idM0b0x7CjTvKtpV
         wrgCgXNnvysUxZW7ij5pfext4IKXf32zX7CBt/uakX99viGWvLbOr+vBrOphCR0gKEZv
         EHFmezhkro9qYNh2+bmrjHism38GCxWHlZyiDpOP4jNxqs5wz/C00U0iGXkLRFrWj22t
         AlwWBTAKTHN5guh8hxzg/Oc8ggO3dUjJx4jI4Kr/MJ+5QRnJEDShzn1IlMzMc43dkIIK
         KIoGuTYBmDPtU2blV6m2P6INvTQ7dz/lrwwYduahwIUvfrU7sx2TzWmsJPZJwTsFMLU4
         +0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784260075; x=1784864875;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s2XQqwVkMap4lirEXwZf+U9qWwV6X1eZsLJriPQiJ0o=;
        b=ENbJiXq8FtywJIkpckfGUa6HWJOeEKuMDgVtJPAGZmpCOFcfV8Dqj1E8hgzAAOAIVD
         5fsGhEZ5qFqoAWM2CjxDtShy7lLM6l0Opw8fl48q4p+49YZD2QKJLolLik8z1hKwNEz3
         hb0dyEnIn9JhojeNQC/5NE5afqZUk4DAVJagQG5K+fR6iHiWIigGE9JXRpdG5AemYE90
         FL03X6P4xUxjJAaPJzL0aPqmpOHQI27Gtd+ig36Pgf431E69VHkjRhDA0JR7qxDyYF6K
         ctLHIz9VgREIIdathCM7V8YAMbQrnElWBLPATpO9bdDCJCRU1Ko/xFbk9Uiqi3YQXN5m
         BC1A==
X-Gm-Message-State: AOJu0Yz31id+/rb5Tszby50GO3pSYiSLbK6vSQL6SaiQEgVwZVqN1Fi3
	gTyq2yEoOwuOJP11YEwi0ERdRvlOruTznzNvQhceYt6ZEVz46gZFO2VVvV80fR3JOs68uI2bBIN
	In66ltC4pWYQehSQONCxC1F03pxKQaAbGjshtaEOzOssxVu4Fh7qBSgrUV4RmMQZttsgYfpjrDI
	ZA7w==
X-Gm-Gg: AfdE7ckmvOgg9e0JF83s/erjciyF4I+LBF0K7dvdsJSwC7Clwwq9iFXR131cEfwA4y4
	YXk2dqfj/ol7bR/3X8Lfg+UUYugmTQZ1+ZfIbbKp2myVtwoKDLAWJEsnS2gxUudNWyJIqCaeUEn
	z6qFtH7aYO+wXsGMRjNRheL8qJ5Hg+/TBBBPzeyhkd7hxSdRKZyQkoBywLFBo1B1kA8I2gYAQCi
	/ArFcvcBbZa6VemRVOg2gQqZ+nrT+7AMil9b+xDrdMGBtCDCK6jPE9SmzC8r4ZjsUwpjADJzEzO
	AMYlHAmcHyi0U1HS6mK8qj0W3MTL7oA7rs558ZJVGViv5s/OXIjuoEyZy4fT0EsUCnkwwb+tH2E
	Hp6Nqh2l5dtPZfUjkURoS0kjXmk1g19dhMHU54c5+5Zjoo0ftd4QiAWWI+tytrioCPsW3uUkq
X-Received: by 2002:a05:6a00:1915:b0:842:4982:82f with SMTP id d2e1a72fcca58-84c28544a68mr850977b3a.2.1784260075185;
        Thu, 16 Jul 2026 20:47:55 -0700 (PDT)
X-Received: by 2002:a05:6a00:1915:b0:842:4982:82f with SMTP id d2e1a72fcca58-84c28544a68mr850946b3a.2.1784260074506;
        Thu, 16 Jul 2026 20:47:54 -0700 (PDT)
Received: from [10.133.33.98] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af331e0sm154512b3a.28.2026.07.16.20.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 20:47:53 -0700 (PDT)
Message-ID: <181b5ee0-f002-4f5e-93ff-49b6aa0a6e61@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 11:47:50 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: ZhaoJinming <zhaojinming@uniontech.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <3c67115f-5aea-402a-987b-c3092e0c3386@oss.qualcomm.com>
 <20260716114611.2042584-1-zhaojinming@uniontech.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260716114611.2042584-1-zhaojinming@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=IMIyzAvG c=1 sm=1 tr=0 ts=6a59a5eb cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=iHwBjlyiAAAA:8 a=EUspDBNiAAAA:8 a=jIKljzOPe1CI3Q5AW5wA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22 a=uNSKXYNwxGiU6LD0JREI:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDAzMiBTYWx0ZWRfXwGzZgELt0kv5
 yaAC0mMePeGwcWhcC2j+8EwIN9GfshJCdzkgH3rUA7DqNutBx+Bpsr3YB0uN42qCmHpzReC54QI
 5Rw+xNZNBgB+nWT9YrE8ZRyN7MNgHjqjPVpx7o7bRV1znQQKrpN2R5DyR4qRPDXCi/jHbPBZaEB
 s18mBwklTn6VanDnShOnqxgR+/7+ZOuR/5HrLr/4P6yjKMaJ096LY1oaDrEIXbCagyP9qvUYDIL
 0I9lKj1ewtC+ACTP6bG1LjaemX314Jb9iTTrXIHqEgxX3sFrM7O/mcs+hrGilHtRBCB7vOOJxvc
 w0j6NsTzJTFVitoO+ebvQtrRLggTRgpIDOuQVru3C5lUTF0rNi1yFs7SurCcP/u26EgEu4eXUhR
 1zvUwcEnMUtR0OTGGOc9HodKUakwWcfe/1qgoRQvECiYMUCnB75sUQ0eRd5j1YhCSAk8DqOkFUC
 z7NOg6JHDz5s9AhLoGg==
X-Proofpoint-GUID: 2wS1XoUdrDVYV6TEwDNidHMNdMKrLlPW
X-Proofpoint-ORIG-GUID: 2wS1XoUdrDVYV6TEwDNidHMNdMKrLlPW
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDAzMiBTYWx0ZWRfXxmmavn4Dyy07
 HAb2oTR4mG8jdIEtD4NAg79WCiXOOZuIK91W0J+1IWs7uRvtURiZJOx7yCrr6vWJ9pXD0Sp35ue
 +XZA8CgSudz/0YJ3uUKKRQswTTRHnvg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_01,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607170032



On 7/16/2026 7:46 PM, ZhaoJinming wrote:
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
> 
> Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
> ---
> 
> Changes in v3:
> - Extract ath11k_ahb_free_ext_irq_grp() to handle per-group ext IRQ
>   cleanup and refactor ath11k_ahb_free_ext_irq() to use it. Add a NULL
>   check for napi_ndev to avoid potential NULL pointer dereference since
>   free_netdev() does not guard against NULL input.
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
> index f566d699d074..1a9408138d81 100644
> --- a/drivers/net/wireless/ath/ath11k/ahb.c
> +++ b/drivers/net/wireless/ath/ath11k/ahb.c
> @@ -431,36 +431,47 @@ static void ath11k_ahb_init_qmi_ce_config(struct ath11k_base *ab)
>  	ab->qmi.service_ins_id = ab->hw_params.qmi_service_ins_id;
>  }
>  
> -static void ath11k_ahb_free_ext_irq(struct ath11k_base *ab)
> +static void ath11k_ahb_free_ext_irq_grp(struct ath11k_base *ab,
> +				      struct ath11k_ext_irq_grp *irq_grp)
>  {
> -	int i, j;
> +	int j;
>  
> -	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
> -		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
> +	for (j = 0; j < irq_grp->num_irq; j++)
> +		free_irq(ab->irq_num[irq_grp->irqs[j]], irq_grp);
>  
> -		for (j = 0; j < irq_grp->num_irq; j++)
> -			free_irq(ab->irq_num[irq_grp->irqs[j]], irq_grp);
> +	if (!irq_grp->napi_ndev)
> +		return;


irq_grp->napi_ndev can not be NULL in exsiting code, hence this is not reachable. A silent
guard against a state that cannot happen has real downsides, regardless of what it's guarding:

- It documents a code path that doesn't exist. The next person to touch this will assume
the guarded condition is reachable and may build further logic on that false premise,
spreading a phantom case through the code.
- It discourages proving the invariant. The check silently substitutes for the reasoning
"can this actually occur here?" — the exact analysis a reader should do — which invites
less rigorous code over time.
- It hides bugs and delays them. If the invariant is ever broken by a future change, the
silent early return swallows it instead of failing where the root cause is. What should be
an immediate, on-the-spot failure becomes a displaced, delayed symptom that looks
unrelated to its cause and is far harder to debug. If a "can't happen" condition is
genuinely worth asserting, the right tool is a loud warning — never a quiet return that
masks it.

So I'd drop the guard.

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
> @@ -524,20 +535,25 @@ static irqreturn_t ath11k_ahb_ext_interrupt_handler(int irq, void *arg)
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
> @@ -585,9 +601,7 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
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
> @@ -600,11 +614,23 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
>  			if (ret) {
>  				ath11k_err(ab, "failed request_irq for %d\n",
>  					   irq);
> +				irq_grp->num_irq = j;
> +				ath11k_ahb_free_ext_irq_grp(ab, irq_grp);
> +				goto err_request_irq;
>  			}
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
> @@ -629,16 +655,24 @@ static int ath11k_ahb_config_irq(struct ath11k_base *ab)
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

others look good to me. Hence with the sanity guard removed:

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

