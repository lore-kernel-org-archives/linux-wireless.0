Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE9D3F077C
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785404042; cv=none; b=IOwzoIvf8Fp4siNEk4HwkcGSqLSdAc2NnNlpGqSQVy7z371k7B0WrdQ/l3uw3ZI4pfog7Q0+5jD5+inOTEt+7XYoAHnRBabxIyLkq1Khw0iIPGSDbP9t5o9ptR0BXaoDfut8YpDM2U+rFDMpl0tklsu747nDlM5NSEMoZ5m+KZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785404042; c=relaxed/simple;
	bh=UhTBfnQS8cA2GPBi+FeqGZY6d8NuD/cQ8gl6nCxgS/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oknfnU9ZBVV/u+2gwleA7oNPUG4+gV1ttKg0CWsPP10dba4lBZc4y76RoGC/m8FiAgCnKZT5qDCfSbReLbms5C/CRrcLmxbDfg+WseV/3c8mDUcEPwR2T/9nN5kceUoWEVKWUNRYPAFYbyViv442EBwV79MODZ/8RG1QlnMoGPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c+kORpkz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PI0BlCSa; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c+kORpkz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PI0BlCSa"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U8xien490703
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:33:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zAnGl1yQ6HSH/lR+AcnuDHk24BuAb/i+djMLcJ2t8A8=; b=c+kORpkzdQZBC3Rc
	CnRGLdPAhNcqEx62UHmDI+kWH/x2x3PkcQxVO8Debvz9exY2E3Aipypn/B6ZWRZ1
	sJHEI1x9fQsSqLhKnxUHM/j431PzXM8qrbqwhHHTLDkW+Hz8dXM17Yl9VOVoYNiz
	UezGH6y6XA7suQm6xcXSdAYE4ewx/qw/2qY3lMTR47P185kSLVHLDOZz831nVh+L
	WrWmpJC6AuhKszeanc/L3A/sdlNCM8fCYVDNwKIWIj+/IoF9T4qcIw/brlkhpdhF
	td2yuciCcCZRhPce6nhzurcNjdlQnEFWip2JEqqThmne/1xrsEIYVGGpw0/JC2du
	0KPhqQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr3kf05m3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:33:59 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dd87656d3so843056a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 02:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785404038; x=1786008838; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zAnGl1yQ6HSH/lR+AcnuDHk24BuAb/i+djMLcJ2t8A8=;
        b=PI0BlCSase98gPbNF8VNokmXWrG45HP8Y1nV5paMv9EplqA6gbLv8andM49wXC3mhd
         CBrCGJG8ADcGwgK2V4icUYKNuHQOLrjdTKO39yBIE4NbRmpY2ynifEITrTyF9DLFop7k
         hbFocQagOa9ZgbtrBpDuIe7qtUMi8EBLGGU4VX0w8VWoYm7UWcC88AaJHM4pnI5YkCyH
         Su7faPFhj5FYS0vSxwOg1qNrnn6xwrH02opZLLO+fWUKorEQHwrt+0c1eIJl+lR8AYJw
         UDB4EY6gI5jevmibh7e4ptpXojiZJfc5U6WeKnwaIVusZDK7jBEYcCRajm8nPaRAJRHU
         ZsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785404038; x=1786008838;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zAnGl1yQ6HSH/lR+AcnuDHk24BuAb/i+djMLcJ2t8A8=;
        b=q6zKzKOys6TRRnJTxVi5ZyyswRoHziNIp/XuvBbGDUdXWZ8nzwIDMUE3i4yoT2/pSU
         FUj2l2/owB4cJXatcOWeQs3hxJWXRDfGZC/s9Wwbx0R3eHFEIanjpOig3mULjpWXbAYY
         6o9IYn8D2kaEA/3/p2eziLY3XRP2F4B/py34HMlOzR5WzNvL0Fkln74vsvLe5QjCBHj9
         xDsVLJqhPIqvRfWz4nCs6BCQYXESAFiRTRK7faih5pIQd+JvjDhwSY/5Ymztfs7cdv+c
         KXY8EZZcVSfZiU+0i5nzQ/IMySOFt2/T2924XwMqslzshZwV5XAEaWPe2TnXY2rMdV96
         wacw==
X-Gm-Message-State: AOJu0YwiCGqguF3l3xXG1cwFxoyDnIlU4xsavbh0DoYV/fEsIaSU3n6S
	l3BncWOwt536Pnq3UCqA65AUPmVZxjsJkCtscmpO1T6x/ykSXiVz3+Vq1+fBN9oNM33jo2PP0pt
	v5CxHYajW7w8zxLYSqF1PteLsRcwwphBD0X97W4b2r9sNAPAtUMDNNPMeLlxxumzzg5mqKrJQJe
	2MBg==
X-Gm-Gg: AR+sD119AClUEE1ds6L2UUgn3g9iuQyee+7tk86GeO06m7JGuJ1jLHy/S5De5vvNXlc
	0BYV99w4YtfrEG9ZDfCrTgpGXNEKwlA7sDb5U7g3mReXZpeuTfMvvbuFwaXwLojvw1RGwit4lVm
	kULtKMlFo2Ej1GxghbqqCS4AZdYjIZy8HfZUsXTNcalJBvWeYQ4sRNS3b79LCNiPHzM2fBLgBbR
	uW74ZZ/Ywga1TY0mO9hQO8IrZ5mtNLaJiGzjrVkEYWC/is2gHurGdn4vh/hctQM6c1zodxv8+ED
	Q41rvlaiGtsRUcls1NTb5h33MiYBg+5V/yLU/Yls+N6SjXJnzSM6iDg5Jo6k1j5DamYxHWWV2X/
	C+Jz+KorAs+xl1Fdi81cDCpWergXx4BBvUkcWZZO5
X-Received: by 2002:a17:90b:4d8e:b0:387:df8f:1406 with SMTP id 98e67ed59e1d1-38f9c04002emr1506891a91.39.1785404038487;
        Thu, 30 Jul 2026 02:33:58 -0700 (PDT)
X-Received: by 2002:a17:90b:4d8e:b0:387:df8f:1406 with SMTP id 98e67ed59e1d1-38f9c04002emr1506877a91.39.1785404038044;
        Thu, 30 Jul 2026 02:33:58 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7265010esm19576966c88.6.2026.07.30.02.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 02:33:57 -0700 (PDT)
Message-ID: <e36a964f-de77-41d1-8730-9a5e796dcd47@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 15:03:37 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: ZhaoJinming <zhaojinming@uniontech.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260729020005.219253-1-zhaojinming@uniontech.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260729020005.219253-1-zhaojinming@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA3MCBTYWx0ZWRfX/SjXQl4OvCan
 aep1tvGFprNDJbZoJOONgWQKXfPHAzP7MgTx8Hfvl4aqXlaZ8pvRHWAUbFTUKBU/jvS/b0bC5YO
 21DsjvkrHog6IyHsJUALeQmvjWnBuKhfPuqJQs/D/5kY8MjfLJZtDP8QsdovgUaLw5O8kgU0lSp
 m2n1wR7LJvuTVRvk5E8eyTq8OxiCdtIbVAbb654P3QpBgsPnOdMonQB0ti4CoofUH/plAUkhOgt
 wutlEIAV+7+vOajd5+JIRAyQWCcBYT5qg/kn5jUjtz4kmitWZyKOS120Pi8p3YYUDoDXw+FDzOO
 jb3hN9Gr2GlPLpmQVXVI9W1GqDyS5MM14qrcLCxxj7VnabwWuPXRnxrYE8nhU+LZkfJGJEkT8XU
 0Ko+E4WU6M78LJoxYhyA8FO4dORCUmUkwwQIdi61p+Op21cBI55wE2vE9PY9HfIcTGOfAqN8la7
 kche1gXR4oFmGNr0JHA==
X-Authority-Analysis: v=2.4 cv=O7UJeh9W c=1 sm=1 tr=0 ts=6a6b1a87 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=iHwBjlyiAAAA:8 a=EUspDBNiAAAA:8 a=t70t56v2sCmPkK01i0IA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22 a=uNSKXYNwxGiU6LD0JREI:22
X-Proofpoint-ORIG-GUID: 0fwdS7jd_U-QO3T7lTWoSxNJPC2ZO6Za
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA3MCBTYWx0ZWRfX9j7KokTB+yn0
 XQmamXiu26RBjMZskjrbhXEBtv6jH31UOhhWZkf3BcUdGoOiAezM+GGo0hmU18lKSW8Ibi54DYX
 XFwFOObbGlAbvtJza2gBCaLkoA/OzHI=
X-Proofpoint-GUID: 0fwdS7jd_U-QO3T7lTWoSxNJPC2ZO6Za
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_02,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300070

On 7/29/2026 7:30 AM, ZhaoJinming wrote:
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
> Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>


Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
