Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1695B1F8691
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 00:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784852124; cv=none; b=rsmF5Pm3efgsiyFifz2A+zrYM1RAjVAzuRorqLJs4NKI4w0yzlpy3yiBS9u7iJnyGiu9Rf+fC7itTo3sbn6+2imcm+gEBnzrKAw5oIhqYTRTQojrAAWE/4pOsKduECKtzN/LBIe0fUeXnlYfG3mS2lLCCZdQIr0+ipSn4IcicaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784852124; c=relaxed/simple;
	bh=+WK3WMlcrIF9nBJi2SCvX+AmpH4ouzUtcxN9tGxdeGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CrDAObnmY6yR0FAqZbYuLNZvn69Drtl65bq1Q+XI2WoRPe8vrTb4M0C7osI8w6cLlWJ5rvtROejKl002ID2Ao0YIlJJ8EvekEuf5OnVn4gkMLPJsC/xJX0wEJznSK70CM8XIhiz4gpXQpVxCiCDHRqvp3YbJyNC1j7y6yh1z/xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=b0LSwza2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XZBa4rqw; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="b0LSwza2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XZBa4rqw"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NLeDmF814630
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 00:15:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	m7QsKN0giofAKW5YvchjOEMo+riIGTGsBgW/mogRrEo=; b=b0LSwza2Xm8RiLdm
	WAm0BZ0jQifYvOUe+VZMmpR7PxI1CoDakaacB9B3T+Q4Rd/R+1e8Ob9oSsuxdt84
	VfGoHGuTOo2sLBX8fHb8TPlxVLC4yf1nIR2ONY2xS6RuZ9dR9LEiy4tWMgDoZsvw
	AynLB1xF9OX7bl7ssNKSat86cDpZNwGjYaeFhtUSkfcruqZJ1bpWR3rJm0b6AiNa
	QA0F5SFRcCh3Rvv0X1htxcOT0cX3RsAFfWcFzrGrdkkzM49mIjBflTCgFMNMDrsx
	GNUf+nd9NErmpWaHlmd+IXDNb6bpXvVOUmL5sI07wNI5yIKfl07UNCO8gikuoDF0
	dnMXMA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkqajsbdk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 00:15:22 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb6cf425e86so1684246a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 17:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784852121; x=1785456921; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m7QsKN0giofAKW5YvchjOEMo+riIGTGsBgW/mogRrEo=;
        b=XZBa4rqwvuGLlogCWoHw4S0vktXZgNE4d21HgQKOCYwE2eGdMi2tpJH1TLf2D8wc05
         HhkispoO5q5nsG8NuQXtloc2chQijPaRXLhqfBmIUGlAxImjBKTQKEqgR8eENj8YNCpM
         45Z96h8MYlASw0m+OA46X3m5ru5b9poeEmxmSrkQvxYMmWhymdf44Vf38q8hHFDu+nm+
         8RDchJS9xbWcpF1gIWLeTQanlvLzS/dwoCe0bxHqGWMgd1rfEcaUyjWS3la4kjPKSXhX
         rPnSABSy0kNyd09i5w0XtoVGWnIK5Uki+HKatz7++UwSA+EFbiA61y4Alfztz4SLjeif
         TlNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784852121; x=1785456921;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m7QsKN0giofAKW5YvchjOEMo+riIGTGsBgW/mogRrEo=;
        b=tJfZnA5qy6qX/y24I1Ii6o4gzKkTqA2jTPxotZv9QgVQKbzLt0WyPNshcuH3A91pyj
         q+I7t7kqo6NNG8g3mO/5cNMEPz6ghloFqM5ZTjQgpWef6wmZWlqJWsh7z8LemlTOg/U1
         zZuZyAza6Sw6anXYfmTYWAAlJ/Mxa6LkxoyjzWR/TXkF9LVnRJv8w9fz3WChx7bHbQ2Y
         RrxjjkAi5T0iIlEHcE0N20utdF7b5TBD5Yxuq/uOp7OX3/Mm5hU859zAomHSi0DnR0PG
         eFhRg8vhneiu0g6ULJkxTbPq92XA70FcfKxQw7PyV0wiaceDxVgOC55FQhYjNODhVF8f
         Zzgg==
X-Gm-Message-State: AOJu0Yxy5spoQ2tIEkHmp8xX3O+7XcOnwVPCZcAzGnQdMah6qKkNW/n3
	odWpJEAUlXAl5iuvVvSomvimqspUvkIGyKJCxw5qsHkria590FonwJOcV2IzspGYnadfUSEJMPn
	mrFwU7wgelr0efVkmfI0FGeZbULxTXfjukVc2elG4MWBbkdGsyT/S/3dNcLCQJeMvWwax9w==
X-Gm-Gg: AR+sD12A97eXbCqbKIj0amMmdWSPkv66hAC02LiaLdoMcPpOjtDAHRTA8uyOT8pdMtn
	+NxRb4t/aqrmj5PO7acBy+IoRmq/QOcQaRzBjrgBV5Nx8521pqUySyJ9B96hIvFlD318xoUit2j
	JfPKfD8MGzmhX83+0Z16LItIsePZJwXz4oh/J49lnpZb1zTiDHGd+/t/KW5AI2oiatjyAcZCNyL
	0AK8GGGKFd+ecsi4uaLpNmfj1MKAYEgPh9QK9RSMq32pVsgaZQAw1TOTPTx0KDyMDqshUPRdIlg
	TGSWxquW+vQ3XsOmw59ffs19rNT3YZbtcJxhdX+0GJEjBnmfYleBcMJ6TdN5RY22UUA/Bl8qNkd
	KiprwuDZe9j1PHRtqfvFSD4RTd3Jld2Jm2YSI5icbTEp21tBJNMi/BAiU5w==
X-Received: by 2002:a05:6a21:a8b:b0:3c3:e411:418a with SMTP id adf61e73a8af0-3c44b28858bmr5934670637.70.1784852121512;
        Thu, 23 Jul 2026 17:15:21 -0700 (PDT)
X-Received: by 2002:a05:6a21:a8b:b0:3c3:e411:418a with SMTP id adf61e73a8af0-3c44b28858bmr5934638637.70.1784852121103;
        Thu, 23 Jul 2026 17:15:21 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d130cc5ebsm25688668c88.12.2026.07.23.17.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 17:15:20 -0700 (PDT)
Message-ID: <bacea060-bae5-4136-841c-49db5b561b51@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 17:15:18 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath12k: restore country code during resume
To: Stian Knudsen <stian@pokerfj.es>, Jeff Johnson <jjohnson@kernel.org>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
References: <df37460e-f8ba-4e11-b412-4aa8b17cd32e@oss.qualcomm.com>
 <20260720120913.100604-1-stian@pokerfj.es>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260720120913.100604-1-stian@pokerfj.es>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=WNZPmHsR c=1 sm=1 tr=0 ts=6a62ae9a cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-SOlkNUPErW3LcS7OYoA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDAwMCBTYWx0ZWRfXxjd0m0yJU0jl
 1SmiwUpTjNVIWY1bB6h3oLuMzMtihyeWe8w0G7NGD6+OGI1KPBUYavn6jCezmijwHIRhbmR8j8V
 98OH+0AWzE58ToZwZ4c+Ezea33LbM02VDhZoRoAV8RjeJ0E5lAqCqBLPpKxJQTgX91SZEvLlWHV
 XHLCaMZNLQqYXjCRoLWIobqYPIf6ldr7owmeogPHyNtBe6Xn45JmSoKEj4OaoZHcyZK6cSdSs+q
 G2HjIo+uWZONCtpJpCGW95ncACpOw8aIoQn0OaIlWnBqh7vq3tkh47KC3bHYBi1s1vo6MCkBR4l
 VH5rBm4JH2H/1VdHS4DbBncVxbBHkd0BMOD5npjM7ywELQ/v1NFN8IxeWzYPLCfyPGsLG2Jdzoi
 qYS1B9NAVP11k6tmakvb9m1o0lfocMqzskJ7kETKRNnw087BHsxjsXhOiU9yYbc1AC2nP/F+16q
 loSUMpNcHvq2UNzlCLQ==
X-Proofpoint-GUID: Vbq2s9v_QtEXgv1o5Tn3nhNoAP4imbRS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDAwMCBTYWx0ZWRfX0xdqyKUg3Jph
 Ha1/dGs20mn7xaROUwSPMEgnAbhtkt0kylzqnD/8uBxjfIQrnbeIwqPpILxmjOmGiKdsLEN2BpQ
 YYLSOSzzfdDFbRhToYbbFTsDdnx2uI8=
X-Proofpoint-ORIG-GUID: Vbq2s9v_QtEXgv1o5Tn3nhNoAP4imbRS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_07,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240000

On 7/20/2026 5:09 AM, Stian Knudsen wrote:
> The country code configured before suspend is lost after resume:
> the device is powered down in suspend_late and powered back up in
> resume_early, so firmware reboots with its default regulatory
> settings and the previously set country code is no longer applied.
> 
> On WCN7850 the firmware comes back in the world regulatory domain
> (country 00) and takes ~7 seconds to rediscover the country code
> from AP beacons, part of a ~16 second total delay before wifi
> reconnects after resume.
> 
> Restore it by resending WMI_SET_CURRENT_COUNTRY_CMDID during resume
> if a country code was set before suspend, i.e. when ar->alpha2 is
> valid. This follows the same approach as ath11k commit 7f0343b7b871
> ("wifi: ath11k: restore country code during resume").
> 
> Note that only single_pdev_only devices support suspend/resume (see
> ath12k_core_continue_suspend_resume()), so handling the first and
> only pdev is sufficient.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 8d5f4da8d70b ("wifi: ath12k: support suspend/resume")
> Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/-_iDJ_M5RrqACWB0qmtleg@pokerfj.es
> Signed-off-by: Stian Knudsen <stian@pokerfj.es>
> ---
> v2:
> - Add Fixes tag, per Baochen's review comment.
> - Link to v1: https://lore.kernel.org/r/20260717130254.36732-1-stian@pokerfj.es
> ---
>  drivers/net/wireless/ath/ath12k/core.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
> --- a/drivers/net/wireless/ath/ath12k/core.c
> +++ b/drivers/net/wireless/ath/ath12k/core.c
> @@ -197,6 +197,7 @@ EXPORT_SYMBOL(ath12k_core_resume_early);
> 
>  int ath12k_core_resume(struct ath12k_base *ab)
>  {
> +	struct ath12k *ar;
>  	long time_left;
>  	int ret;
> 
> @@ -211,6 +212,26 @@ int ath12k_core_resume(struct ath12k_base *ab)
>  		return -ETIMEDOUT;
>  	}
> 
> +	/* So far only single_pdev_only devices can reach here,
> +	 * so it is valid to handle the first, and the only, pdev.
> +	 */
> +	ar = ab->pdevs[0].ar;
> +	if (ab->hw_params->current_cc_support &&
> +	    ar->alpha2[0] != 0 && ar->alpha2[1] != 0) {
> +		struct wmi_set_current_country_arg arg = {};
> +
> +		memcpy(&arg.alpha2, ar->alpha2, 2);
> +
> +		reinit_completion(&ar->regd_update_completed);
> +
> +		ret = ath12k_wmi_send_set_current_country_cmd(ar, &arg);
> +		if (ret) {
> +			ath12k_warn(ab, "failed to set country code during resume: %d\n",
> +				    ret);
> +			return ret;
> +		}

Baochen, can you remind me why we don't need to wait for completion here?
(the ath11k change doesn't wait)

If that is legit, perhaps we should document it with a comment since
reinit_completion() without waiting for it seems strange

> +	}
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(ath12k_core_resume);
> --
> 2.50.0

