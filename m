Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8376431714F
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 02:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784945604; cv=none; b=DNOXNrC4SlFq+bcveAkFyv7nru0mtg3HmH++/LqEXmZJSq0sHP8lmNMrVeicuwwbcmXmdwi769zciJIFTTft84hNsmnuSz6d5m/PauDg3IlxYt/nAKXaWU7rUPdnjGSMxISe5vIqvD0I4NB2jtFiRmeW/Zr3hF4E3Xd9cBuB8Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784945604; c=relaxed/simple;
	bh=gqFhHONCY835sFD+IlJg8lm7TPRM1xtPR+yr1UzAvdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FfXXJfJ8mCSUICrNmbaACKWaD+tqBMl1u5+rGRrA83/5TUMFB4isj7Y5ng47oFmmlz5Mz+wQL0qOm3U+7MdlY3YWU84vZNkWDWV1tO5JpGzQpG/hCgENakSu4KosY0iNB7jKIwa4ytw52i9NSPxMp4K2YvJ/WexlGRri8Vw0BSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gD5LoPJB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Hy6lFsbz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gD5LoPJB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Hy6lFsbz"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66P28mc2938298
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 02:13:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jE1kcn50NdHtg9rHOHQYVIhR5o62mSnqkk6OEOynRdQ=; b=gD5LoPJBajjzddWH
	O/x61VH99kfrYFCQTu30i1qZOxuri0ck4+BFAJwGiMFV2eHtygUdMcYLPiZfwyVi
	yEHqU4gbahDfU7Wgklffan9oOlPu8CxsrVC4a1cC+3S/QFy9kkLmb+BcZeD2aaGg
	Xd5kMKfY3CXmqIf3mamAQ/huDroEWHLzc31lhQvJ8LEoEIae3AdQuH8tXkrrqSaz
	J+pV6r84QayfR3mV4QL08RSW3TALz6QSYi3dMoeJhz6ioq4xAvn1BHMYSs7Fn0K2
	HvB0PGJwnxFWIbOJsNFBw5aI/8GQjBHy7vFT13IGMDvJRfIGM0RMle53t6jlF9EU
	G8GsKg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmm3s80a0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 02:13:22 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38dbf293831so2219398a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 19:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784945602; x=1785550402; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jE1kcn50NdHtg9rHOHQYVIhR5o62mSnqkk6OEOynRdQ=;
        b=Hy6lFsbzthckX5ZKA0cVaLSHyuoAqVG4QloTS+5h+O0I1w/tiJgPnDzGrVt+5pX/pV
         iEnP1SifgS14FkCL3fqcuqeJlcxaezYS+a7AMeW3UWPcVcg3+yi8sr2XQgA7mkXbJqwx
         Aw6sznG/IFs0fD6JNmVeA0mGg5ZIN2AIrikwZLOsZx7yNIlZmObBSM/xJy957vB5R/wJ
         UXq1sMMgMZjjzeegTZ+ETaRU4adpYaMRw2DbPyXOHAUcsCsjo7G64iTRBjU57FKTwL/h
         kFiyCkgKz1yN6lmNpGUByVz/Ne79y2obp3FtKyb4n1ziMJ6vVTymlThqHM4bIjK80TNV
         NhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784945602; x=1785550402;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jE1kcn50NdHtg9rHOHQYVIhR5o62mSnqkk6OEOynRdQ=;
        b=DXsn2nePTYh0gu2DTdzPYgmLdUdbXkAMTUIHZ+ekpFyZ4RfiU+2dMeazcsHcrwwBjk
         02RQnRLkt2TQLgty1dph98t9S+RyOtHYPhmllZpjPfESI0Ih1f9OIVwCF7ycQSBNEtGK
         w82ftvcd/0PsGtrLXtQjjrSSR11YYZmtm9hKmOEGyG5o+YYagnThqCBCrTQwbrP8XA/h
         lfAvQOuZIHelIO2D8hrf6DQVE2mXIUG6Yyun8EieUiJzntV3xK9RDWB9PRsaWCh0CC1B
         Apq5Qx1gRATGGyhgmAuKHrTiiuWL5ZGvmjZZHdt5B30P6TIORhN2JT/3BCPCLgQCkf7P
         PDWA==
X-Gm-Message-State: AOJu0YxX1j8WL+AWmgiACs2B180JHMZkweTsKY0qRJWL7NGYK7FEO9Tq
	bDgpdLBXxgm0t5rBE0FCR5F2zSf7qGu5vvEz054W+UQuw71OTt99DGsfD/9TlcMnwAE7VaYPq1v
	y/8Obu5gn8bBbUv9Nxz6zJ2etTxexmKScroBccMDXzRDC7PC99UonK6+w2/dvyWyZvgR8FA==
X-Gm-Gg: AR+sD102X3yiFGFWcDfC9SFv45RXj5g1fF7ygtAWUv/D3Pi3qZ+NdcBApQW+PLepnxE
	KOgwNpBNrCbXcDa/fZRNqoowr9G8rlPAPqgreaF0XvO6vBElvnvdsjHG+GrMbDLk4jLX5p/pLnY
	C1boGYZtz9mzcVQyzRPgOV35ioytXjj/S2AqO29sxo+7E6ZaYWtb4iFCoREHeuCdylmhYMZH5m4
	6V0iIuRVNu8yzU0d/EIibYhShAxPGqCUaq5cQynCIb54sxGEUbYDx0I6LBveZ3Ytl+EPAuIyYNz
	x7ObWgvPS+VqZU0YAC+YFkmifeUYt6/xEejpkQGkEESYLP5VGk+p8LtlffY0XcReKtwURJfzfP8
	FQK3hCrP1ynSG05fQecO3ChilksSmKC/Q0CLCe9w2rz5WFny1OekXw1L/sQ==
X-Received: by 2002:a17:90b:584f:b0:38e:79f:76c6 with SMTP id 98e67ed59e1d1-38f29641ae1mr751212a91.24.1784945602017;
        Fri, 24 Jul 2026 19:13:22 -0700 (PDT)
X-Received: by 2002:a17:90b:584f:b0:38e:79f:76c6 with SMTP id 98e67ed59e1d1-38f29641ae1mr751195a91.24.1784945601609;
        Fri, 24 Jul 2026 19:13:21 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d130262d2sm27398246c88.7.2026.07.24.19.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 19:13:20 -0700 (PDT)
Message-ID: <b6903572-52cc-4c41-b9cf-5845e387c176@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 19:13:19 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: ZhaoJinming <zhaojinming@uniontech.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260723013818.393470-1-zhaojinming@uniontech.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260723013818.393470-1-zhaojinming@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI1MDAxNyBTYWx0ZWRfX1OH6wz8rUzvP
 warI3icMscNttmEk7oYifa0zsLCvp0yyaQsNBkz2goQMJlwTuNHOR4MYhNsJTJEW4iKHYeDeMEd
 e01RQSl98oiqL57x6WybfZ0xkcsNok4NbGIDdueaTXDcKOR8kxSDPvO0iTT9ozatVs4wBFm7VSS
 +wdaoyyQkyMoX3+KsloMuhm++x7guGk3gJO4f4+BUrzOaj3fHQfFbry4CgNKGTM+kgFYcHakq7x
 uFYrEXeMQSbZboHFpXP6P0iMC34+8n5uyNgUrjfrwsK0JU8fQc3afe+n2rowTTk3uae3C3gb9Em
 MljEQ72jroYHkf9UOaz3UJlYxKSmu3ixtLG/M1urYnpjmg65lMXMuTQDnCjDwh5VaX02dUP8Rze
 7WKPcIUpul5VN/bzT5e90mS8budgjLdLY8GbB3INojZwYRqNowHzXu0ffRiCRFVeB/RiBoTgCES
 mAjucPPmuMapmwRDu7w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI1MDAxNyBTYWx0ZWRfX8YQWXll5v17M
 1UaR9F0DnfUDNWHXaCiR8fcuVVZuyujCe9S5H2zyGWoVcw0GntJFOKkpmnVulJc/6RHlsJrIqRI
 fNdPERdJPiktwRSmk03G+cqSQGw7Mac=
X-Proofpoint-ORIG-GUID: vB47DQKJtr7H1PwC2QY6s1ZsD-h2vnZa
X-Proofpoint-GUID: vB47DQKJtr7H1PwC2QY6s1ZsD-h2vnZa
X-Authority-Analysis: v=2.4 cv=KanidwYD c=1 sm=1 tr=0 ts=6a641bc2 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=puE-CX9gChH9hliuQHEA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607250017

On 7/22/2026 6:38 PM, ZhaoJinming wrote:
> @@ -585,9 +598,7 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
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
> @@ -600,11 +611,23 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)

my review agent noted in inconsistency between this logic and the CE IRQ logic

just above here, after the platform_get_irq_byname() in the prior chunk, is
the assignment:
			ab->irq_num[irq_idx] = irq;

that assignment takes place before the request_irq() function is called and
error checked

in the CE IRQ logic (see below) the assignment doesn't take place until after
the request_irq() function is called and error checked. so consider relocating
that assignment to after the if block below
>  			if (ret) {
>  				ath11k_err(ab, "failed request_irq for %d\n",
>  					   irq);
> +				irq_grp->num_irq = j;
> +				ath11k_ahb_free_ext_irq_grp(ab, irq_grp);
> +				goto err_request_irq;
>  			}

so assign here?

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

note here the assignment takes place only when request_irq() is successful

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

