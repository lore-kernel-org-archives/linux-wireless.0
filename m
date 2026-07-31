Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5C13B6370
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 23:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785539207; cv=none; b=Cz5EVSbzK4fDDh8NKx6P1mmPtNGBgVybVVGvGMIDHfFRkqy2T+6Kq+2wl9L7RM9HjRh19zkBrHS+3B9/Don8KHmAiMUvWP1hhZjopd2BYX3HwlcKIGIRQyHxramqr70kqJRAIy2N/Q5X3T5KDlCSE+wVzja5opsXaWsOgngMb8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785539207; c=relaxed/simple;
	bh=+p8w7mchGyzmIeE1JbXU5M3SPt4L2Luq0jH2toCtWl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bR2BAGl/7eTHZlP+SebIdJlRqdqrmqhQntcSk8rA8fB+v3xKgsEL5hBWwJkjWkdQ3lSntlUPB2wFDlaOKdgWAO4+R98181CoYHQAFc0mVCwtoJRNdbiBoOd2Amyxm7ombhta7dalrpjDnimF+56LdDIHQSCCv6ICvgbN8M5Tu+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kZKgMv1X; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=c4PwNQTX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kZKgMv1X";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="c4PwNQTX"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VM0XKT956471
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 23:06:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	U7tpd0S2YwULBAdlt+aVaG0rTF0GEY2FTOIPMSdKP60=; b=kZKgMv1XSSOQ7puU
	XbSnkuVRS+Ih44Nrdk/1d0zPjix3f0k5HTSa3wl8P3IDafmm8djhKlqaqWcI8Upe
	BNZrLQeme0UmZAqhcf6xlH3+TJkw/3alfRyJIXiIVTguYT2CnRocBmd/Mop6P/m1
	gxEbW1UAUtESgNhhZ50atSytTUVR2ZBOFysbUnOrwK7inx5U5JDuUoISm11KDG14
	z7zOBkeXZpMx6dR25Zs1Cw/O8RZgtm5oOUniwBFRQbfZFknocGc5bHTfrCca8o5q
	lJKsrDcRP1v4zfGRQMRZ6EHyX4x3xX0OxryBbOkCbqejovMbZZ5gDohupcW2nKA4
	al4cRg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frtyqjx9n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 23:06:44 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e7b87ce77so3701216a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785539204; x=1786144004; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U7tpd0S2YwULBAdlt+aVaG0rTF0GEY2FTOIPMSdKP60=;
        b=c4PwNQTX+ljR6vgRK9CxwA7Q7zRKraNu0bpNy3MlPTM93p1XxPgvv6dKdUVlpEL/19
         1mJJZ55k6lC01kmAYnVScNU8LAPqn2Kqhfq30pza5k/gYStpIxtiw7MwUKtYnkPG9JiE
         pLPVRbg4IO0VcNDNfvw6E4rjqIpPlcXRcbauOEJ7FXMOXnLTtRWfLRStPak9S3E7Ir2x
         LobNvQfZG8+BMECv9db/0eLEiGqmDWVNiqiBh7+AdxvT8yFUasaDMfSO1iDRzb+e5y1Q
         QoWZFPyGfEoR+UWyb3enCKLz6hR0S4EGzfGDFFl8oDSQQdmAi9aqKSg3j8KRVRgjjO9O
         kAVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785539204; x=1786144004;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U7tpd0S2YwULBAdlt+aVaG0rTF0GEY2FTOIPMSdKP60=;
        b=P3wrr8lR0d1kIdefZ6fcIKs7Jat+7Ea8Pmem/A5zW4ncRnR2Mhxntkxw45xXSTiZaV
         4ZMQ5HbjGQRtWoFG+UlGAqTDG1lu/s20srq8OkmDXqK4XCkSr7Ub8V3OtluL76tDlKqL
         GMjsWl6KkS7KeSzfqZXnFmD4KccH52hAmyg7kKXFRV3B4PbH1pE0t/JBLwsJV7ODqIYR
         3y41If/doIFJTpVvjgsu4Fb2XcbeiITvA6mpr6JsmlnoF4toaGtSNfkWRdfOOQBwjFfD
         CBnPABIGLU9gxL7yh+lfbMORK0h3hPHoKohOvru6GajdAZHf2+9zP3pizeqExklOl7nf
         OlJg==
X-Forwarded-Encrypted: i=1; AHgh+Rol1JkHEuXbRGpJmsirBQGI5jY8B2d4aHoPc0WEmn1t3o9RLwyyspZbZoLAVagc2tBORCZXvigdpQUX6uqbMA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4Iuu/41tQzwt9AiZiRo5wSe1JCkkmyl9n3SSbQzH+ctllobqA
	cYi3dyRIRj8Szp+LZnR8kzHQgPmd5JKikL5yOBwu/Z1HYHTjuxDXWTu7+KmdgnZrD/WKJjngHAK
	6hEX6SoJPTX0/CH04Y7eOlHRC+RpkUFsfqPKFxIDytfu0gXc5YpyAEH5phpqHDg4sayV+bA==
X-Gm-Gg: AR+sD1237kbsXspaLDf3MYE4PAg78L5Ryhe253Dk5NcFv95AR6k6AEEBit59WT/wK94
	eTd1O5/3ljzKxg2Ov/XjLHtmLbrOI0k+IXWtS68e1c1+6Zz3daM5rUIa+fiTh/Hj8sDMtd1WbXM
	+Az9cZThiS0kOUrC8l7uoHgvBeUeFzDT8/odxtAD+V6LQbZCg2e+uFsJIZLVw3/GgwfyY5+nE9g
	+kwPd89aLjJrY28a3wLocEho3EjeUqmxN0MKRX6o3SyVQz9H/Z+V2/h7opETkacgZJL596+ygVL
	EscKqDj4YY2edEwfrNuTzOS9skSt9mZ9HcK3/unMNkPQF4x8qNz5H0oFrI6G18bGBRlMukxW8st
	1uub6b0PhnuygMbImmWfbMxagw6J6kiFsudvAZInXR1Ytb8qZtK+AwY63YVc=
X-Received: by 2002:a17:90b:1c86:b0:38d:ef48:b04 with SMTP id 98e67ed59e1d1-38fbc4249efmr1421274a91.10.1785539203837;
        Fri, 31 Jul 2026 16:06:43 -0700 (PDT)
X-Received: by 2002:a17:90b:1c86:b0:38d:ef48:b04 with SMTP id 98e67ed59e1d1-38fbc4249efmr1421253a91.10.1785539203358;
        Fri, 31 Jul 2026 16:06:43 -0700 (PDT)
Received: from [192.168.1.9] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab4e44bcsm9419228c88.12.2026.07.31.16.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 16:06:42 -0700 (PDT)
Message-ID: <f105a3df-6769-4a61-ba37-a6b874a918b6@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 16:06:41 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH ath-current 3/3] wifi: ath11k: unregister PM
 notifier on QMI init failure path
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
 <20260730030948.147892-4-miaoqing.pan@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260730030948.147892-4-miaoqing.pan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDE3MyBTYWx0ZWRfX0e3hzIsB0d/B
 kFgXyJJ/8INfTMF4fXD28L5mc4tyok4ryNamc/mb+XlG9ydtLWoOKZA/PFxCAxmeK9E2gCIFpj2
 3Xh6a5itvNN7LRG5dz1/9MuLx7f1Vpk1vAoDx/ReekcaRPupVryG6WcdfC5OxVhNoryPBokNwLK
 oaaATYZvGTX3P+DzGdBuNFmA4rMkkl0PtLvzN8Ajhk63iFivnGYiwLSlOD1h456zqLYrHStzbXw
 9tfq7hhqxmGmEaYo2QDEuJHaE65DP6JtCPmNIaC1gwG20UoWA7q8fj3SxoZN7RiU7Gf3aCgdYT7
 c+XKC0yUUBulalNkrwgxIiuBwY3mSDay/YBDQPF3eyhDbARFBGm0C7965OfhfK/mU7FXUs29NpS
 BrLWcVRbgH2kiZsSSeJSxp4saRGJYxm1fmPjTibeY/iuhLUsRLMnfQOt2eHkryFb3NYVWkh4PCS
 qYWDOLht/NLd7D9XxEQ==
X-Proofpoint-ORIG-GUID: -NwIOR_U0yyP3ZtIEc8RLJTHAZUhEzn0
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDE3MyBTYWx0ZWRfX6cpR5YYF6/ZB
 wLiukLT2+L+k9EBso2aFs0w7xyYkYz97i/E6aqRkRNT6e56juLcR6R82R+8a0Oeyps1VD0YfsTw
 DMd74Dw5jSNq1TMkITbrWg3UMCR1wa0=
X-Authority-Analysis: v=2.4 cv=YaGNIQRf c=1 sm=1 tr=0 ts=6a6d2a84 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=8LiCHbkhAqqawgbigPAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: -NwIOR_U0yyP3ZtIEc8RLJTHAZUhEzn0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_07,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310173

On 7/29/2026 8:09 PM, Miaoqing Pan wrote:
> ath11k_core_init() registers a PM notifier before the QMI server
> becomes available. If the QMI server never arrives, the device remove()
> path can take the early-exit path introduced for QMI initialization
> failures, skipping ath11k_core_deinit().

This patch felt wrong to me, so I spent some time with my buddy Claude.

I asked Claude: in the last patch the commit text says "If the QMI server
never arrives, the device remove() path can take the early-exit path
introduced for QMI initialization failures". where is this device remove()
path code? I'm trying to understand why there needs to be a call to
ath11k_core_pm_notifier_unregister() in ath11k_ahb_remove() as well as in
ath11k_core_deinit(). since ath11k_core_pm_notifier_register() is only called
from one place it is logical that ath11k_core_pm_notifier_unregister() should
also be called in one place that is symmetrical. the proposed patch breaks the
init/deinit symmetry.

Claude said:
The symmetry argument is well-founded. Here's the actual structure:

ath11k_core_init() registers the notifier. ath11k_core_deinit() is its
symmetric counterpart and unregisters it. That is the intended 1:1 pairing.

The problem is that both ath11k_ahb_remove() and ath11k_pci_remove() have an
early-exit path for QMI_FAIL that bypasses ath11k_core_deinit() — but still
need to undo what ath11k_core_init() did. So they replicate the unregister
call directly. This is an existing pattern: pci.c:1188 already had
ath11k_core_pm_notifier_unregister() in its QMI_FAIL early-exit before this
patch series.

Patch 3 simply extends that same pattern to ahb.c's early-exit path, which was
missing it.

The symmetry break isn't introduced by this patch — it was already present for
PCI. The fix for the symmetry issue would be to restructure so the early-exit
paths all go through ath11k_core_deinit() (or a new partial-deinit function),
but that's a larger refactor. This patch's approach matches the existing
convention in the tree.

The commit message claim about "the early-exit path introduced for QMI
initialization failures" refers to the QMI_FAIL branch at ahb.c:1301 — the
goto qmi_fail block that skips ath11k_core_deinit().

Thank you, Claude.

So I guess this patch is OK since it is replicating the PCI pattern, but is
there any way to have ath11k_core_deinit() called in those early exit paths so
that we can keep the init/deinit symmetry? It just seems wrong that if
ath11k_core_init() did not return an error that we would have deinit logic
that would skip calling ath11k_core_deinit()

> 
> As a result, the PM notifier remains registered after the ath11k base
> object has been freed. A subsequent suspend or resume event may invoke
> the stale notifier and trigger a use-after-free.
> 
> Fix this by explicitly unregistering the PM notifier in the QMI failure
> cleanup path before releasing ath11k resources.
> 
> Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1
> 
> Fixes: 32d93b51bc7e ("wifi: ath11k: choose default PM policy for hibernation")
> Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath11k/ahb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
> index 7f5f5c8d7c56..bdb8c99f10fa 100644
> --- a/drivers/net/wireless/ath/ath11k/ahb.c
> +++ b/drivers/net/wireless/ath/ath11k/ahb.c
> @@ -1272,6 +1272,7 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
>  		ath11k_ahb_power_down(ab, false);
>  		ath11k_debugfs_soc_destroy(ab);
>  		ath11k_qmi_deinit_service(ab);
> +		ath11k_core_pm_notifier_unregister(ab);
>  		goto qmi_fail;
>  	}
>  

