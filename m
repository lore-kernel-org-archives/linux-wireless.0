Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D91435202E
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 02:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784861517; cv=none; b=fmmI4O/95XMseie2iRNIGIYCOXwT+ES70LJVURRki7jT+qSjm+OgBHyAjVVafdCJ9PnxK7aNACfK9s7U/0aJUfbqw5PRnnXnACmSLcJ6Ef32r2uV8cOx3aqtKRt0nmaTHzjs+TtB8i5Ile3tPxH5tG4Fuah/zbZ72FpHX29BoxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784861517; c=relaxed/simple;
	bh=4C0WSTRxKkpn40nMHNa2UfNdp2Q7so5kUT8EsAnTLsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qVokxN7Y7vN83ES3V4WXDDm2RwQh1mGlfEIGDbjwzaPBJjW86pc6Q1hdp9x05rbob6Wf17KJ6U9wHuURTKJm1arC6Sn4PfeJjCIvC+i3OWz2EJaLkiQvBmADWLmSvlgOh2U/9HMOF0jZqvfwxp/xpKjdTEZzOeCtuExJsNgnldA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LmmsTV24; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IAPflS1h; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LmmsTV24";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IAPflS1h"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O2iJxi2004257
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 02:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Dfeu4PiLTHOP46s0cp6yzqgG0LolKcw3ZEXTPQR4oxA=; b=LmmsTV24G5eFiOAE
	QATax2/Wnoni3AWK4efRowB+e9icQzu1v4hmBUAWiaj+zMHAybbhGpdZjmJ9qrvE
	32GQaXcv4bLn81ohewT8c2DGQZJAL+O9x1av4sg0sVTF2ZJK+a9ReLM7ixYq0pPP
	0kXrw0RPHP2fm38vW8bT+zJRHz0R3OFngmVElygMiRHvhMoqlsBtYJZEPWNJPiuR
	ZdSZNG+2hIauJreNQYW5Q8aZB8SnTMLcGazzuFFnLlK1iP0UTn4qtl0I7S5/aSF9
	ehcRl6RWF8jYSHin/3fTJtbUtrIpaAQWras7X/DJ9DUptRqRihAPn0ucPH60AveG
	C75Kjg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkqa09q88-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 02:51:48 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38dde0df80bso2022361a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 19:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784861508; x=1785466308; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dfeu4PiLTHOP46s0cp6yzqgG0LolKcw3ZEXTPQR4oxA=;
        b=IAPflS1hw0S/W9jULiXpslL4L4Loi/YGkfHZWkrVSEviPrvAOtPNW+G3CuEyD13Nle
         +/s0yiQ0ZlkH4PzcPyMZFV1xfq4FAvBafMjYRJRAkEW8ndwMVMH3Dv/sGN+L++8qKuYM
         mmGvOrh78mwJxu99SKt+6IKRvoxPEJitJGKM0vmtobqdZnFvfxlW9y6sfNkaULAvoq69
         o2XPArKRzD/HiGBRtfY6fUOUpTLbk19qmF9HLj1b7ZQARdvAKf8fQ2UmxdQBc8yrPtgp
         9bom1BUJWQiwzVvMjac6HGdFw5Qx4CvXU4VX5/BN3UNIvWjiPtBnyaBJNePAiGj1SBbr
         LEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784861508; x=1785466308;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dfeu4PiLTHOP46s0cp6yzqgG0LolKcw3ZEXTPQR4oxA=;
        b=JHLQP0yzFhJwNLxOcPXKpogIgVf+ZbHPpkawjR9O4AymhK/KcIbSuq8qN4C/spBhXx
         uQlL3conGyn7y5MO5U5bbKk0Dpk8sOumZxFlEB3YcHs1f9ydL6ND7mWui09Qqu8b8Pre
         08GFf42KTwBNSRQxDwXiSTvS3nFrqJtGJpBEWgVD2tbc0ZrjI09y35clwGfPkBtfdmvV
         ivlkx/W8SOLIYoZZs4WGr0mioPIpi5DwUhY+DKqM3bZWQBX/KCaXVO55XlovNliU1KM9
         xwtCp1sP9o4P7uwDuw7ddtDJgTCXI1+GVdhbL0xtabrBKJJEqUm5L2nm1pmuJrACerue
         JT+g==
X-Gm-Message-State: AOJu0Yz0fCnHULlXCvZgKHXaIxyZKB1QuSYDIUgB55hFjiD0HTi/1jer
	+YwkIKq7lylwCrVnVYab7wFueGdmPq0YNmN8X/7QVQCTYLDeuEfRBBjCtJByh9H0bYpXH1rHraM
	93JwRYvz43C8XlQ4lX069xBhjHpRyR9snvtd2uq0SPAFYGWCyBDMpIwMDuK5ATfBWR5G3Xg==
X-Gm-Gg: AR+sD10Bet503Gc3al9l8B2oBNj8RBvnDzVidNd6kiuiql+M7Iy1dAnzUUuHgRC3M9j
	bM9EBZK7A3yylO4P15zDo3wk3AJPR7FDxSF4IKrxRQ148ZmAY9n6FLhH23Og5mjqkgZrZO4B6Gx
	XLWuAdLOvdZ4/Xn6tFrpYW8a2vLWfs3bqPMhWgu5hN7UguA/pEWuLnsf66AcAZIkZzn2gcDlVTO
	VmbWXHU4WgeNYiliapHz8134+U7nC0tvJgHua8VrN/kx8StAI1Qm7aXWyRon1Pza03C2T+02wJP
	jIDOQC9viLEZXcOo+3qZZEeyMc6N4MeKhrNTrVzA4e32O0IPDXT6SHQ9kHme+yKP+civQliR7YU
	ZoEt+EOpMkr+/ph+nRZuvRLyYew4eOGiZJKtr+UnEoXOuVrsWYnm5igVIPlur7Ft1mj7z8l3G
X-Received: by 2002:a17:90b:2d10:b0:380:9504:9780 with SMTP id 98e67ed59e1d1-38ec6631fe3mr5645246a91.29.1784861507409;
        Thu, 23 Jul 2026 19:51:47 -0700 (PDT)
X-Received: by 2002:a17:90b:2d10:b0:380:9504:9780 with SMTP id 98e67ed59e1d1-38ec6631fe3mr5645222a91.29.1784861506940;
        Thu, 23 Jul 2026 19:51:46 -0700 (PDT)
Received: from [10.133.33.45] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f03aed0f0sm700164a91.8.2026.07.23.19.51.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 19:51:46 -0700 (PDT)
Message-ID: <36d63752-0d93-412c-96c8-546c972e6b7b@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 10:51:43 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath12k: restore country code during resume
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Stian Knudsen <stian@pokerfj.es>, Jeff Johnson <jjohnson@kernel.org>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <df37460e-f8ba-4e11-b412-4aa8b17cd32e@oss.qualcomm.com>
 <20260720120913.100604-1-stian@pokerfj.es>
 <bacea060-bae5-4136-841c-49db5b561b51@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <bacea060-bae5-4136-841c-49db5b561b51@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: UrkYor-Z4l37kvOnR-XGlXxDvHxJj_KP
X-Proofpoint-GUID: UrkYor-Z4l37kvOnR-XGlXxDvHxJj_KP
X-Authority-Analysis: v=2.4 cv=e/k2j6p/ c=1 sm=1 tr=0 ts=6a62d344 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=8lpEDrwlwfmWvIhY3bAA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDAyNCBTYWx0ZWRfX+MfKfHNbOIUs
 TphkY//+xvPa/F6RDGWYie/3dF5Ha7n8C2skdGDRi810Pdqop9DADzQ/aB5KyQSCqlmQH9JSSIB
 oB2+9A5ME66hfmofqYJz8WoN2jxfjrJdjPAiq77CNPWNdejk2YOLt09W3vmBq6PG88gn+UnZHBv
 1PIwMUWRkTzNPR4YL/dxoi39Eh6OniiTIxsj0ZajsylWzSz9QR9PGDwwuMIsip9/L2ZvLp3PV31
 iu1aEan8gSmVEm6qcvUMgaN03dv6eLFPi7+7XBm9uYJvxU2K/Bv6Jcx5oobJO0Fc1Pe4fIbkmHd
 0V2GsWS7mzGTToWAH1DFJ5uEsHCEk8hyObDa2n9i0XKUDpU1K2ORJqvUtJGrRXK8WXi2VeeyLkb
 W5DGVSeJxEBKWvZsrRdpG+GHZUfothD8RG85KAY2/qDj3WC5x7lKXP0JyD+GErg9JWoBLcmn2l0
 BVyjRhRrmvQzot6X1KA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDAyNCBTYWx0ZWRfX8qAzJSAEEXHi
 QxRoezElSmUIWNvNfolAEyIGQvUzuFGMsxSA83JMnedDI5aM6WvJTFQtUCLoxNS7GItlPeTMEZt
 5w/crpTCduj3LjQrDoE5TNlZ6HWD8QE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_07,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607240024



On 7/24/2026 8:15 AM, Jeff Johnson wrote:
> On 7/20/2026 5:09 AM, Stian Knudsen wrote:
>> The country code configured before suspend is lost after resume:
>> the device is powered down in suspend_late and powered back up in
>> resume_early, so firmware reboots with its default regulatory
>> settings and the previously set country code is no longer applied.
>>
>> On WCN7850 the firmware comes back in the world regulatory domain
>> (country 00) and takes ~7 seconds to rediscover the country code
>> from AP beacons, part of a ~16 second total delay before wifi
>> reconnects after resume.
>>
>> Restore it by resending WMI_SET_CURRENT_COUNTRY_CMDID during resume
>> if a country code was set before suspend, i.e. when ar->alpha2 is
>> valid. This follows the same approach as ath11k commit 7f0343b7b871
>> ("wifi: ath11k: restore country code during resume").
>>
>> Note that only single_pdev_only devices support suspend/resume (see
>> ath12k_core_continue_suspend_resume()), so handling the first and
>> only pdev is sufficient.
>>
>> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
>>
>> Fixes: 8d5f4da8d70b ("wifi: ath12k: support suspend/resume")
>> Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
>> Link: https://lore.kernel.org/r/-_iDJ_M5RrqACWB0qmtleg@pokerfj.es
>> Signed-off-by: Stian Knudsen <stian@pokerfj.es>
>> ---
>> v2:
>> - Add Fixes tag, per Baochen's review comment.
>> - Link to v1: https://lore.kernel.org/r/20260717130254.36732-1-stian@pokerfj.es
>> ---
>>  drivers/net/wireless/ath/ath12k/core.c | 21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
>> --- a/drivers/net/wireless/ath/ath12k/core.c
>> +++ b/drivers/net/wireless/ath/ath12k/core.c
>> @@ -197,6 +197,7 @@ EXPORT_SYMBOL(ath12k_core_resume_early);
>>
>>  int ath12k_core_resume(struct ath12k_base *ab)
>>  {
>> +	struct ath12k *ar;
>>  	long time_left;
>>  	int ret;
>>
>> @@ -211,6 +212,26 @@ int ath12k_core_resume(struct ath12k_base *ab)
>>  		return -ETIMEDOUT;
>>  	}
>>
>> +	/* So far only single_pdev_only devices can reach here,
>> +	 * so it is valid to handle the first, and the only, pdev.
>> +	 */
>> +	ar = ab->pdevs[0].ar;
>> +	if (ab->hw_params->current_cc_support &&
>> +	    ar->alpha2[0] != 0 && ar->alpha2[1] != 0) {
>> +		struct wmi_set_current_country_arg arg = {};
>> +
>> +		memcpy(&arg.alpha2, ar->alpha2, 2);
>> +
>> +		reinit_completion(&ar->regd_update_completed);
>> +
>> +		ret = ath12k_wmi_send_set_current_country_cmd(ar, &arg);
>> +		if (ret) {
>> +			ath12k_warn(ab, "failed to set country code during resume: %d\n",
>> +				    ret);
>> +			return ret;
>> +		}
> 
> Baochen, can you remind me why we don't need to wait for completion here?
> (the ath11k change doesn't wait)

Technically we will wait, but asynchronously instead of synchronously. It works in a way:

1. reinit completion
2. send new cc to firmware, proceed with no sync wait.
3. in reg channel list event host process reg rules, queue regd update work and signals
completion.
4. regd update work calls ath12k_regd_update() where we wait for the completion.

But I am feeling this is not a good design. As you can see, ath12k_regd_update() is
reachable via the regd update work, which is queued in reg chan list event. However it is
the event itself signals the completion. That means ath12k_regd_update() never blocks, the
whole reinit-wait thing is a no-ops.

> 
> If that is legit, perhaps we should document it with a comment since
> reinit_completion() without waiting for it seems strange
> 
>> +	}
>> +
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL(ath12k_core_resume);
>> --
>> 2.50.0
> 

