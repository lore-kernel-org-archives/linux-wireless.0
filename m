Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECC04343F6
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 07:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784619664; cv=none; b=Ehu7d8HFnwuvS1p7wdNLz0oahXmpOoiRylfjbGOoIWTr004xLGiDJ8IVaG1CHDwxKJAOTSqO/SLW4rV9JhpK6UQwXE+rpsmm127EqxMnIlpvnikol7Ybxs7RzdYR9AVWS75lVZsYRS6jzmDcRp5rW1IQ+410LY2gF9E1xZ3Diqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784619664; c=relaxed/simple;
	bh=AGCSHhzNWPhx56WFUP0NFupamjbwzH52rSwHHYx7zlw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g1iXG5eFoOw+IvgSuwbxiLBPUCqKu+C75lwKv+5NcfDYaQWBwzOSUInAFD4hbX/oUGmowtSIWA62eM7+qYFdnLSXYRyoJ0YvB7bNQ04KJxVkel7Ni/g2AJukHpmKJK+RKFTi7v+jap5yL8dxT7JncJWP4L0sR1AEl/h4W6QBdrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=j73ce9Bd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WbacIvhV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="j73ce9Bd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WbacIvhV"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66L61O1Y3978346
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 07:41:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	R5u/F8c1Z6uNv+y3K8dxZbgvRMHAOcVf9LRk7KX6thM=; b=j73ce9BdE8wIZNnD
	eOl+BQ2TQ7bAhWE7Ob2vEjBLWYp+81BWg+eMbcHmq7uNjtTHuMqw+vBHF2fFnYZy
	FJFXcDlJnMPTY8AZELYgsH2tNHPelWSjy+lPmAVid34A3WDsMXxkdInr6QlsCQBB
	pTyfk2Mb42Qnmw3xcdBN9I06QE4014Pb9EcS8IqfZK4geE1WSCcPvOQE1K5R4dj2
	+2b6H1euqETYnRuFfCyTkml43ZOqklHZbEXpkISG+sDTpxYVC+O9PsvEEgjjOK7z
	Mf2MjvPPgDq/M3xeJ6RpMBezCwKTSnCGoPBeOl1fXtLvU6TcQS8tlrYVhHgWlL9k
	tplpMw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhqv4328r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 07:41:01 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cacd6d37edso149462445ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 00:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784619661; x=1785224461; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R5u/F8c1Z6uNv+y3K8dxZbgvRMHAOcVf9LRk7KX6thM=;
        b=WbacIvhV0c7qeH6vx41HPrt5Dzg6ELCMlSvbxXyrul8FzEcUJ8IabtpvxRfmGzuA7r
         UU2w0/GJigalaBKrStT8HL/N+zcs0fQwgX73wICD1YN2GVHrd0YswAqDwFnF4GNL3Ak6
         KM2yPKkt2LEKtihpz1ttU2k80J6vJkwOWEdeFYX803RZoLqeSVRu46SPRvwTMiSvbpwN
         zpY9FcdoO83KeOKma5oEfiyvsHQqJr4H3ebT4QqVyjgdx3GeR75lA0Nvl6hjjSQl+tuy
         cV0zyWQpzjwKUCvVl5bG+bnIgrCBvhcNih5da30pj/awxM/lqKPEnQGGDJ5jzyJffEEg
         KqSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784619661; x=1785224461;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R5u/F8c1Z6uNv+y3K8dxZbgvRMHAOcVf9LRk7KX6thM=;
        b=EfYN+2LjSyc80ywX1LVLf3BxvNDZoBMi0vbtuQJ4jJlOUqvG1G3Lxxg5gnqClGOtTA
         LUPo6jEoynec2YuLDa6Qx6nfifpxVszN3D4o0QK3/9PFOm6Mp2FCno3lQR2ST1Qfpmvr
         2V22Glsb1Nt2m2hlwq9zQsVugAXksXH7n+vftU6Ug5d7jKwGfLzeExYmolq6xMe0aW/M
         cxNaRJEThwODtWnu6Q3cgvXH/FaaRLFiTmO0Bbrg6cn7h2eYxh4YDVlS6g6ayK7DZf/S
         uDLqQTos6yt7U7hlz66N1RDhQqyc+lugPS2YZexqGzbmtgR5XeHl2Wqyq/ZIrvKkjzdk
         uYaQ==
X-Gm-Message-State: AOJu0YxKnPhiZZHVEX+e7EPhYGR99wHWMvYmjw5q5hmOX7l2uxtCDSF5
	uA3SOocBK+Y2D1FM8f39vfPHApMv4CfcgfJ6CYtTfXDDZJK+L9B5UfTJW+4QRSX/MvnGsF8TrsG
	XePlPHTM9rk9cC22qbXPhD2ZruxTTIdbO6ZYAMXO0Y9I61Sx5q0yerVvTfVudUd8+Y2qQyAkU93
	FMww==
X-Gm-Gg: AfdE7ckxk9tWhsH98DpJ7zaMLmxq0LebNjPwvQWhwCQkT/C5Bb9q6D9+UiwHyAtJrkr
	uKtdYgFG/FBo3vvKfM8X9iRUgYQ/FPmMDX8+l9+6lnr5bWw34ea87ve/BSGSwDVcehB+ZnoLKmr
	XM4zEyjZDzm+s3W9gGZrSho/GQeBzzM1iX4gYCvgj1q9YR6CprjrqWVTdXRqe4JybWKEpHvqw9S
	RCtaMfS8thBXDlFRA5/lUAjFCmF6+REaRww/hOAG75I7DvejdWFGkD3fwg+1Upz1OngOSGXnAiP
	xvE9MJp6HBlV3LKQrurHuIXbCD4e6cn8KTlvkInb4ETudxvggVQzGV1HCTIJjj+B2xhkKXt8vap
	rdMg4RfBNFAwecw62omdMZdaaQq3NVXncW89VVW73HlirR2k2M/twxKcmUpbYyrvIsCoKGUHL
X-Received: by 2002:a17:903:3b8f:b0:2cc:d192:50b8 with SMTP id d9443c01a7336-2cf34a31907mr193526555ad.47.1784619660925;
        Tue, 21 Jul 2026 00:41:00 -0700 (PDT)
X-Received: by 2002:a17:903:3b8f:b0:2cc:d192:50b8 with SMTP id d9443c01a7336-2cf34a31907mr193526385ad.47.1784619660474;
        Tue, 21 Jul 2026 00:41:00 -0700 (PDT)
Received: from [10.133.33.82] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3448dac2sm70879125ad.3.2026.07.21.00.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 00:41:00 -0700 (PDT)
Message-ID: <6ef27e6d-4313-4655-b166-987185e67ae3@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 15:40:57 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: ZhaoJinming <zhaojinming@uniontech.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <181b5ee0-f002-4f5e-93ff-49b6aa0a6e61@oss.qualcomm.com>
 <20260721072128.142668-1-zhaojinming@uniontech.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260721072128.142668-1-zhaojinming@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Nyn9AtKAKiog98wTuIxkDid5gSoYu7bv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDA3OSBTYWx0ZWRfXyJYGj4IFUUFO
 SqHeZPt1IhOeMAIY3ONCccdzPVmQqViqaLzHuOh1vzZKK9iX1p2NN1b42tYIjSvIELBRFtnQXe4
 uG2Y04+zlai4w7/WuvTf4Gbj9VdcGI+cFU8GCC0F0K2Ts2jnTMZLei+L9K78iLaMWuvW8w4tOcd
 MqPbvNvE/CL5OBLbZGfcPyEbRwHG+34qupgjsZ1FLC4qjbnTfdPwz8AgP6+bMAOCdp08w2py7P+
 m8hlfa/waEs371u2AgHX01XZS2p52+LW/tvS82uCzyZsaNIccsv6bW6JflYL5a2Gduh0VIGeofS
 W4x1As9Nh5/kNPqf4fgZLDw367qj+1UzwAQPI4lBMPrv8u77CjLWhHYBD366P1WSduGTR9erfg8
 zKAA+l0Z8ouHpREbzPljBHOwPSzvFTay3oZuCKMeYk62JhKowjWbuQ49ROHLZEnJB21jlxlYgb4
 fqfPit+97rByyIaOQsg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDA3OSBTYWx0ZWRfX3zGbG7mZ0IBt
 dGCKIrBViQXpyTPuHvkmdTQeT3iqTaEQ0uPxj0lvvYcYoSL6kic9MM+9hJGSksCcr2yJg742ggJ
 Joa6uN7e9pQYxh9cxdxGJBilRP6f1u0=
X-Authority-Analysis: v=2.4 cv=daawG3Xe c=1 sm=1 tr=0 ts=6a5f228d cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=iHwBjlyiAAAA:8 a=EUspDBNiAAAA:8 a=oLTilD6pKAFhNrx_43MA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=uNSKXYNwxGiU6LD0JREI:22
X-Proofpoint-GUID: Nyn9AtKAKiog98wTuIxkDid5gSoYu7bv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 clxscore=1015 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210079



On 7/21/2026 3:21 PM, ZhaoJinming wrote:
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

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

