Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DE23D1AAA
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787125406; cv=none; b=BSfo3UssSr8u9hPA/gfYPtY1Qycdjd9+rgsFKvUWWsjZTO0T51jw2Z2+ogulwUu9CN9QXB0vqhaBU4Cz3a06PIeOX9rBVTGBXO8Opp3f7ikTZqTFmT4QLyN/mr1puNFDD2WMpIjdq6oYhHdtqhLK+EiqGkIE5BNmapparFX/OuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787125406; c=relaxed/simple;
	bh=tmUpB0Wq/51qKCr60INcYrYFuUUazp/3lBkH2oTTF+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hGIhN58v8z2CX9vpMg8D/rUkEcSfQnlEEIEUL8WOkGhSCz3NXYCtEDSPVi1fx4iCeGagGFFaYoEMi3tzpTVLUcxN5pb51eT1NOj+XGabNpWi+q1mOhCaWWomZuv+NI7e77jOpKV/yCZiP8IA/k5ZsDEmBV//AxLKibKagQM/uFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GTZHdq18; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JTIY10V9; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GTZHdq18";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JTIY10V9"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J6ZJSE3495509
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:43:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+komlKcq5f1mW0dY2GaEuMSAW6/rcfAJ7ejyYXJCejI=; b=GTZHdq185BXXM/oY
	zit1s0iEoX9wBqcCK1FtVjqGvHorxFh1xffufGgIGMEbM9/cf/7LUf/3ODYi6Uwj
	2aAWkTjbEDlJpSUs4szG8PSMDQZpN3wPzbDV9kC4dF2c3I+DJ9v4bO31sR/EsJNM
	YXhrc9bPLaJ2u3Q1V8+QcAwX6rLXcVMup7ER1nzh5CuHRft4erSYTbdkHXS9Y2QQ
	sKx+U9df8jNY99Q5kMYmOgzUAfODptFXmg71t6dXnUMyCvIwA6oMSjf43qsRFzcz
	1n25midJfevS1sU7M/+sECFMmYGUlBhKWOgugqZPpEBqrJTQuGCyfNSka8kS7n1+
	PIRhPw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfjj2m3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:43:23 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51bfd1772d8so1262301cf.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 00:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787125403; x=1787730203; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+komlKcq5f1mW0dY2GaEuMSAW6/rcfAJ7ejyYXJCejI=;
        b=JTIY10V9KKJWpnOKOEDfFn1t8ggt2iFiDttOPiL17uZFS6CYzi5u1EWVMFBSzG8Hyh
         3KvZP7yLIUI9HMyA563Fmjv66qQ3iiDzarPPVvRfZpNS/YTJuCShLdaatiR64ngF4Hpp
         nS6pBFttBZ55S13qj9RztOA3p57IWPRsO4IeeX4wdIciBYHtjzcyotaHyGZ36zTrW6Uy
         hJ2FHry++IFkkpj30NxPPsefzmT/jCZnuaKS01YQTWTGSP0O8lZdiFEUypeNJNWJtciF
         XAlrQVVfjH7IhkW/7Dw9HxxP8SkmRblfvr/28LFP63wyeCFPVNaFrXdoPb9cyK+0aUfv
         +aQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787125403; x=1787730203;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+komlKcq5f1mW0dY2GaEuMSAW6/rcfAJ7ejyYXJCejI=;
        b=gJgQxPic7Ax4rMnZ43/cF4sjnlkPAvn7eHF9uPe8YNk4ccw5F19xd0AdVrLrSXeZPf
         XdiMX1hqHQnBgClHoel+MTeXBZ5Lhj+Yl1HDEzFh2sFQPWuPMTkJRgbIKrap/YXsM1yk
         RE18VLAukK1ziqVWObfO/FW8xnR6YYSpuxTmOMBM3rDKrWZuyYnEBqtvadJ+mVJ9xXek
         mDFN+3RRVzadQltInrcpTunXcBlbGrLjRVi3uBzUuR0LjyYxZ3yv7jGR4dW1RI3E1DtS
         luPeFvCH6gEDeUMjnHTvvIkFiiceQGEOE5Ykc1AdSpvcNv61xFYc4mSzA8/4BgSkclGt
         qRaw==
X-Forwarded-Encrypted: i=1; AHgh+Rp4uHx6tMja9f5Zblumh05V4b5J13TcQaY1t3BkEqW1uBOD9uAPgHJZ8d8j5lO/1Y6td9qrExx2Wruwq5XDPw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3vatZTI2d/pN78HdI8TsZ+iBfkcvEK5ETNCUoHsb8LccOApIA
	ujkQoQ7v/B5SQCCZ2cPqaDjYWM8YH2S2DHzoVBTdz6L9kXz0CDKS7dpa7wjmCieLDpVzQBledWZ
	w3rH+0I6uy5nbGkAPrO9bVeksnZIZU2uYfh44V1ZwsncdTLitBgZFczhWdu5ZvyVsjXnjXg==
X-Gm-Gg: AR+sD13vrb3rWG3HzHxGO1UOmVBs3SMJI5l1pcjuYbDNhowNcsGPOEWA2BsaW4jerZ0
	wqdF1x+cL2hlbBVzp48iQ04XHWQt6CV9bWty7Vs4tDVVYh3UjJKuK1y1qDI50bn5h+oOmR+5Fto
	GcijVnUvP8Szu0H2HQ8ELoi0daaTckafO6tdw3eJLKBgusj0f/hxgcequ1paq4CbwASe2pM/afz
	oBuEolHvO3rOeEJgAl5kgyxcPS0QldmWHzEUhCCnvQHwCEsSWGaXaC6uWPNvp/JzKrdwEWFuKzH
	zF332A+Hw6vtoEy7v+qgvd0LTF5IpXI/atCOSreD8CRkFhQLxs7++8b5YA7SowQ8FcQhA9qxUTe
	UWpWeLpwvo26EY2AuHdj8koH2
X-Received: by 2002:a05:622a:588:b0:50f:a53b:9d5 with SMTP id d75a77b69052e-52dd5771811mr17503391cf.2.1787125403074;
        Wed, 19 Aug 2026 00:43:23 -0700 (PDT)
X-Received: by 2002:a05:622a:588:b0:50f:a53b:9d5 with SMTP id d75a77b69052e-52dd5771811mr17503211cf.2.1787125402645;
        Wed, 19 Aug 2026 00:43:22 -0700 (PDT)
Received: from [192.168.120.193] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c243c27693dsm38948566b.60.2026.08.19.00.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 00:43:21 -0700 (PDT)
Message-ID: <7334cace-49e2-4a8e-aae2-6541c62f5b5a@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 09:43:19 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: wmi: Complete regulatory update
 for dropped events
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260818-topic-wifi_reg_fix-v1-1-18c7c289e528@oss.qualcomm.com>
 <f4f1e338-1206-46a1-bbfd-79fb768dc382@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <f4f1e338-1206-46a1-bbfd-79fb768dc382@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA1NyBTYWx0ZWRfXxvJXKnQucvS8
 K9eVN0QtQUaogUF81UH9IgV1/N6KPj02jOAxb1L6tC7LV5zLwpV82G+VSs0HheDQleCsr2F0eQZ
 GqisABOB/CbvB6QhxFYSsfi/cIFl6dB+G2y+tMwO6tJZccgLcPxunxhuUoGm6z3AZquZl1rTrSW
 JQrSsduCg2Qd7ASOrOzkw1gETvzPb/X4+yPqJF9IXrKM976q+WeM6xtRmonLOeQn1iG+94PJ0oT
 tSemSYzP+aitPMjeuMJc9ENR22BHog9n7Sd7zXw2yzLEeSoo2En5LoWt+Ixt3/FWCN2hw9RhWWB
 rZ+22anece1CrEAMHNAf6RjPfki1jIUivMKEZL3WK6H3OMl3hYjgVMVl7I+sZwbdxq2gn4xdtaP
 wveVtEnNj+Bhu0WCucqCCOZ1y14gBz+2929siWzCQvqed0YjWnX0EUTBmOSvclJmJlTj1ikPi6p
 7KBfPxr5xFUhBxLQ5Hw==
X-Proofpoint-GUID: 5Ck_fZ7TeEtao0zBMe2o87DGFb8cnoUU
X-Proofpoint-ORIG-GUID: 5Ck_fZ7TeEtao0zBMe2o87DGFb8cnoUU
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA1NyBTYWx0ZWRfXxO53oV95fVP4
 /rWBRqCuI+YDiMSLZ/leYEcJ1POTHTRpx4/bcWg6f2Y6ACc202up/g0P4JJG+zBKXJYtbr4Brao
 +nfaD8DYVROEYd/4x1Rxn7zItHC51hw=
X-Authority-Analysis: v=2.4 cv=Sb7HsPRu c=1 sm=1 tr=0 ts=6a855e9b cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=f9ODZV7ehGsSn-uyBzwA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190057

On 8/19/26 3:50 AM, Baochen Qiang wrote:
> 
> 
> On 8/18/2026 10:57 PM, Konrad Dybcio wrote:
>> From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>>
>> If ath12k_reg_validate_reg_info() returns STATUS_FALLBACK/DROP (which
>> are not fatal), the code then jumps to mem_free with pdev_idx still set
>> to 255, making the following completion never take place.

[...]

> there is a similar patch [1] as part of a series [2]:
> 
> [1]
> https://lore.kernel.org/all/20260729-ath12k-regd-wait-timeout-v1-1-504aa6e7e93c@oss.qualcomm.com/
> [2]
> https://lore.kernel.org/all/20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com/

Ah, sorry.. I tried searching for whether you guys handled it but
I didn't find that series. Let's go with your patches.

Konrad
