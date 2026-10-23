Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792753466;
	b=GSZn0mYvZqwG2bNqsvg6R7nkrCzXFHhj3kFX8V5+cZFShSHvFKGJbpOiv0l455GjN+jj
	 gn06FSsrA6z92b//iHsLPQC8OjoZhyva6PQ6o+AyF6zDFz5k4dsO3QP/lYYCL5c8QpqAh
	 Az+ST9GJ4AhJUlbP1rW1Hs+RYYPsf2ta0o98XzOc/GCKxvARkw/RmCprQRxSmOr1pba76
	 3kECuHcCs3PFANK6Dc2oT+zMFO6jmfiJxPT+5jgHU7+MxUh/Ya1BKKB87K6YpwIXJ6AFs
	 EYOz12BujxRGGKw/H6AQe0ZwcwANuojXf34vWuwp8m0XMICng538insqqcEe8zFtWmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792753466;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=oh/QdS08xJfzEXWANCAEwRTXrhSArUWUrXvKqVaiqaw=;
	b=NNpmEguO/Zq7AyqYNMM6aRgakVO0w0bPf+bfq4RAczMOegaz5sDpulQLd0IW7Sl8GbjL
	 r2jsjriHnhBmVQv9ro1XS+JhcJeHnVkwwZe7DPUCfn75jGmmZVKs1Ll0aG9pSyPvaznii
	 BDWGJRA+9uiOw21ctTXYj2pcyMjcRjL4C0Q3EBlXDenoveD+SKqmnFcZ8qPdydFXyWZr8
	 Xblxt0EIzNgxZlbC/+8MCfLBqBiMvM5RGSXyw6QLqeYI08/0u405gJUYiLwtCnfLsfIbS
	 HA3cIdmLSidF7LzpgSJuA64RofkKiVjPS3CfOOpRm2x1YElY0EUF6RFMgpdzhTCc5Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=iMu3X0qS;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Ul0T6g5t;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C96606A320
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 11:04:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6C96606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=iMu3X0qS;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Ul0T6g5t
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAAZEb2509079
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 11:04:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oh/QdS08xJfzEXWANCAEwRTXrhSArUWUrXvKqVaiqaw=; b=iMu3X0qSt5TaM3nW
	0oozGAtXDxhSbVtLh68cJA2UWMOEtoO84ClDNwE8ExLD+DEBXllUtfLQ/z14Rs9s
	e/mAFtKdSbp6xLWlePsoZnsOerr+ieCU1VaR9zu20Iwhtdo9YQnH67mmdLuy/YWj
	YAMLinphnYN2qFt+mHLZvZzoNKODmkeZwUwBNgFopU9anhdk1M9QfjjAwiDMnMvr
	QifsgW4yw2pFApPHj96dprUM8PAQvUKL6IACuWW6/SC/aT+WYoiOPWkQD4Xh4mi4
	T2RxTxR6EV1UgschO3NPQS9y+I9wqmFEf9gc4C43F3/++fiZo0sM7mnzpzxEZEV+
	hxbdig==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfsykasms-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 11:04:24 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3adc5b185bfso843995a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 04:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792753464; x=1793358264; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oh/QdS08xJfzEXWANCAEwRTXrhSArUWUrXvKqVaiqaw=;
        b=Ul0T6g5t5N/gQM4D+x4FWsDR7HJGpBDDP81KMPbNyXT/4OTZQ4lHhDJ31WBBr0eWz/
         dudlP+gtpcN9Dr1/mSzZ8zTachgIaxFQVoM/rYOhoYxYfh+9FpJytcTHztJvXNk3fulC
         jE/r8ncalxNtm7JgrIdZceNzX8Fqq0buIx7ehFrMyuWabFu72Uq56x97onvH/UNccvfC
         2QuL1HpKu4ZtXFYOoRVLX3cZie79aWL0LKmcwA/yl2KSoTPZTh0HqI0cqe9xMlEASr9s
         2XgWX9qL/m97j7gWHiRJ/lPN7tfEPNVa6cGJvjc7fbsfNg1SzcmUJ8jZiI/d4FSJe8Hm
         QZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792753464; x=1793358264;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oh/QdS08xJfzEXWANCAEwRTXrhSArUWUrXvKqVaiqaw=;
        b=YY8wAhdQPXuFwkTPA7M9y2GF0eX3mM2B4s/0+qIkF3pF51tEOk6jaLSCqet66+jzTm
         GWtwS6PULUB9EMXLax7ih0CD9z6Ntqsb0hiBrg6oPacv9Hgs0Nt+dJKm9dHCdQf6JKDo
         RUFArAq4bmW7X7tRChMnRzJ2BoQwFPg7MfX2DsKP2z+7Jff18YOaixjL1LMVCAfJ7XLz
         JikKkgI1FJTbgrgFHYm3XwVuFULimapyGn2md53kjDbQNpGmw6M+NQPXIy7PqGinmf+y
         b0KZS4tXTt2XlSNg2ezx/u0+6S1KoIy1IHUEE+BQZ6PNSn0aBCu3TTspPi3xb8qmzFXt
         TKxg==
X-Forwarded-Encrypted: i=1; AKwUvBzRSWxbTXmmDt6/XwYkpT9SpccA9E/sTuIKB24VShMULMvX5CiAQKG/DAqa6xaBzZfNT3ddmEYBV3aKGOiMbA==@vger.kernel.org
X-Gm-Message-State: AFq9FYICjBjXvDs042ew6t9nUWSG2YaxnCaGRNuOteo8Rhjf8FcR7dYp
	btzDroz5Ll8lgcwLLfqC6+cJqNuxlCt7FIX/AKCC+Ds+iXD1hj1GrE7sPFp/ptyG4On8n+7xT+U
	0tw8tONz41wi6fkOgCiQaopojmDmbTHJ5p/8ajYcQUK5GXnZPGBwsvtIG/lmrO6sDWjLyd2TZtT
	/MkA==
X-Gm-Gg: AYBFou2q0fOHMU6G3kC9tTffNnO2oFSTGlFpAE4lq7ZGmobNyFyo49GG/4NwXsXpB+q
	1aZGVbcRpd6+lsxTmlLDraWJfGmWRI7/LUYeJQ6htt3ZXH4Dv1PFbiY/PLcqdnt3lra2IxzQjWq
	PZ83UAqpVq2ImIMeQTsW8vJuSxmpPQiMQs4xXhJ7AGjsuQN7KWvmyX55SL2Vfo5WHBUxogz/Rvz
	NyqXovyY0dyyyGyM7HuSi/eAvCkODR8plvCjxuwE32w/m5iN1NEgIkyauMSutYPVbI7GyymgkWw
	7jsEWwiJt4bZbuwD1vjfskwW1Gs8fioix7xPjkRFRuEKeht8+URiMPv9WSqxtczLl4BTr73vF2r
	wFx+I3De5X9dajOIxfljJzcnRFJTW3R02AFVkJIeVbXUAutkxjR0/270mQqFf0ur7C8FKXaL0
X-Received: by 2002:a17:90a:e7cc:b0:3ac:aa8d:19ee with SMTP id 98e67ed59e1d1-3adce072ec7mr1631678a91.38.1792753464043;
        Fri, 23 Oct 2026 04:04:24 -0700 (PDT)
X-Received: by 2002:a17:90a:e7cc:b0:3ac:aa8d:19ee with SMTP id 98e67ed59e1d1-3adce072ec7mr1631641a91.38.1792753463298;
        Fri, 23 Oct 2026 04:04:23 -0700 (PDT)
Received: from [10.133.33.125] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba89f984sm650235a12.16.2026.10.23.04.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 04:04:22 -0700 (PDT)
Message-ID: <2467a07c-e215-4cfa-82ac-22214a144dae@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 19:04:19 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2] wifi: ath12k: fix DMA direction for
 re-injected Rx buffers
To: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <quic_bqiang@quicinc.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20261023-ath12k-fix-dma-mapping-for-reinject-packets-v2-1-9f436a26dd72@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261023-ath12k-fix-dma-mapping-for-reinject-packets-v2-1-9f436a26dd72@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA0MiBTYWx0ZWRfX/GECm+Xiws3v
 f3l/Tw9unKI5fTjWw/i+Dtr+YopauGJSrmjrij77birXqNGMeSla7lL4TE10oSrlfWluyNhzqaU
 PwrBfzcLxenCZsgN9ryGRjSQUvad8Dq7N79KEpOSSagOlahssrM0gxZFUPzCtsRhP3ghGjQsL3c
 BZik6A0aKIkqab19zaolAOJjOmhqXEUKOqIC3vXz9PeriLYhzbsY77YntJLdrUcusY00980hCwc
 XKkW+LfEySy4sSrwGgmppY78H5zThHF0LXpz3RG916IaI2HMjcbaoT0biYxOs/TS0HAp35rGwdZ
 xQDRQTRRmEHxeIgPDWm2ntBUkyz3oxBfwev8JCjENNh1Hn8oIxbGpCalQm1Su80xHujXHPMlseB
 BJBloC5wk4W1OgM51PvJDmm5Cdm7EsTEUmIj/Q8T1Ge6fRLB9KMISXz2tvBBY9nrigUUyywz33F
 OUk/U3CojeFeQ5hGqDA==
X-Proofpoint-ORIG-GUID: CQKEAbW7uijocpMurUeqY0aTJr_KUPOR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA0MiBTYWx0ZWRfXxKmuN2m+C0B7
 zRN81O/sNGqNwiyTYXW5gKTvd1OhjqMC0KoC0IYEfqhO3NQ6PA+K0ZDSKu9lL9u7C2Bk1FVoqkB
 dAhWhX5lAs9jGh+XaqxBppCLALwdG4Y=
X-Proofpoint-GUID: CQKEAbW7uijocpMurUeqY0aTJr_KUPOR
X-Authority-Analysis: v=2.4 cv=GLKdgeNK c=1 sm=1 tr=0 ts=6adb3f38 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=ibqxR-RKkZcGmlNDQqMA:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230042



On 10/23/2026 5:25 PM, Lorenzo Bianconi wrote:

> @@ -983,8 +980,8 @@ static int ath12k_wifi7_dp_rx_h_defrag_reo_reinject(struct ath12k_dp *dp,
>  	list_add_tail(&desc_info->list, &dp->rx_desc_free_list);
>  	spin_unlock_bh(&dp->rx_desc_lock);
>  err_unmap_dma:
> -	dma_unmap_single(dp->dev, buf_paddr, defrag_skb->len + skb_tailroom(defrag_skb),
> -			 DMA_TO_DEVICE);
> +	ath12k_dp_unmap_rx_buf(dp, defrag_skb);

buf_paddr has not been updated to skb_cb->paddr when we reach here. v1 has

rxcb->paddr = buf_paddr;

before jumping, so v1 is good.
