Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96AC3537F5
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 17:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785518860; cv=none; b=BUCCfNGiOfFm0OCf51kfYI9JT3H7L785Jcl0QgwFM73yhWrTVJBEEtIuCLvbVu8g0w/vMwlt724e+XUhzHJapIOQbNj9afKOdPZzNRMF0qtzHU8azGmNWNhkmt/zF1PWZtW95ew1fsfKz5Zge5abFOiyeGWpEg6Lu5YpDHAxfoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785518860; c=relaxed/simple;
	bh=WUd0g+ZLryFm697X4UAQZfCvGmI4/Tm+Rqb4V392aX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EZanKbs0LMg6IyPJRCzMU3Na/DkYW2CMXzIzHivN7UbvWEmCEGUYuTwpxwpDnfUKkEIqgm4E3zl2Wk6YHr0upMWN31J2u8gX47if4LdTSjVcfHj6yBo6QwmhKP5f7TPGpx/t6Gr3+FrUiP9A5KAkLqjM051YNgXfEY+qEZ5ZInE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mbNMMUF0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BtAXlSt9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mbNMMUF0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BtAXlSt9"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFO1Rw106209
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 17:27:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	e+UYXtQeeCRS2jLc24ad5pjLwNM3de+m/SGkFAVHwpU=; b=mbNMMUF0l+wAPdbl
	e4IKUGRwE/fgSmROFnxeF/rdQTjFzRSJ/uWsgx6eIiRZC+s9TEiY2loDFBPhY+bt
	uXAYjGwH/vVHpe4OpQK/tJJz3fUCOVm4bejHCLnDa+N3wKvqLSinvJ183esUSNe8
	XZPWbJSnD1u4HjK9znfvfp3SHzNH5VFHbczPsnGfiIBwejdowBNUrU5hN/1qwV2G
	9giM5na3yMzqBxaKQ3bHWv+hFVbM2RW/mz15TfiPhzryyjy1lvhZrnm6dEQ+7pOD
	GqHXDoG6/KLdSGJw5kpQsQHOxw4beTkd5W6tm+kqL2C+TkF4er2Y5K+Yvb10lYnF
	ktsy0Q==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fru2u1hwg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 17:27:38 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cfbf3e4a63so32578945ad.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 10:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785518858; x=1786123658; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e+UYXtQeeCRS2jLc24ad5pjLwNM3de+m/SGkFAVHwpU=;
        b=BtAXlSt9nvu9YDErRXJ/wkY4jmuKqIN5/uOy98+RFZwJFqNht6DV4bbsgqI3G0hD5a
         IPtjGtO3BDR5iwLvNvWo5XTzEGWAnM4pqEj4gy1gPM7gPA9LDgxXOwWO7vGalMtS41ZE
         /AFYAFFQWkKAGi/bUIB78UVgVq4dc9KNSuY1AsCKXWLzdegwKLFlbcAesnrFm/TtFaUt
         KjVoLv5JdnsNIBisBRg9GBJ9y53Pu91IyU5IfkA46vlRBImYz1IyMiAPkTAM8h3G/E8V
         XkiUJAuvbont2RZjKv1xNjHwFXAX8D1u/Xmmz5i3SIeGPF6LmqfrhQsTbvgFWfXHB0vX
         z3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785518858; x=1786123658;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e+UYXtQeeCRS2jLc24ad5pjLwNM3de+m/SGkFAVHwpU=;
        b=ErpmFdyXHL59eh4mpDTdQE8oZtuLZA7SNmwC6tqZpz1Oo1PIoyP/HtqBxLtP+maazh
         MJ9MheyEvVqbn9UcaT/8SkZpsjndjlMeGUPorQYEwNkTvgLOzD6K6O5nTbPR9UOlB/fR
         NT7LJSQ7nWsOjVm1v3sCZ5FU8R3KUDAD3sM5BfUXBDhHBRqLtkcwTf7meO1dSW5VAYmN
         mQUBAsj2hAQjbkRsqQ3e9YvrO2zTrt/w3lPe/2zlpeX39CS57klxj9LWfcg1ERnlf7sI
         CRVPNggMuUcNSgRBmy5OxOWHGpvUSSUOIiglLMYwO6BpWAnpoHf+OKEzGTtmZDo47CWW
         SbYQ==
X-Forwarded-Encrypted: i=1; AHgh+RrJs8NjFAzldo5IINeiCMHT91Yw4qn/SrcLq43zvNg4jKRVUIhWXhyVoU+okuWP9O7NUKyQ4jjNOqTXEtQEsg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyrGbnWEUne06yV7KMn66GBgy/7phxIjpeO1ESfCduznEsYzHcI
	qsMAS2ZxdyvHavKCxlMea1qLB8pdHO6nVfLmLBL6+ECiUB/RSgvqKhwhr2u9KjjVb/eYEHZWdgu
	nPkqbkdysZtqUvOWBv7GPAjuY/m/cDMayGRZTbvIj5W9ZkiIJd4sK5Z8XsUjLk78ec8vDag==
X-Gm-Gg: AR+sD13Kf+6XGoRzYduLmbaiYhpkPdk+WucfOMtcOvFO2UhEqOKkqmFJspp1Yd3qJ2f
	y9kWeq0ztETZjaFtIRxQcl9MXCPfs5uqFuVDQ+Rgva1J0zRwKY2dfNMFoldqvnPy71Z+tYrD0Cr
	2QdnvcO2HHxfyCHACUti3VWGUwEqOEE1LOM5n7oq1mWSCH+smoVP6xTs4NVokS/QbHUZzAfTKrD
	CO0hHTiWB0AMz49XM4djT25fiDRR8qef4gcyDhVroOEcj3InTeHo3VmOl/qOvnhcnABEmufiHuj
	WVsdceiTh7VvL3tyOKwOW2qXGZ1ePoGTxfldmY3PH2HPXyRvOO1Mnzk11/ImwzdgoWir/4jxuAa
	gER0od4htw9wF/sOHcpu8HD9/lPy6ZYry6jsxlCpk9mmVxz7zmW12YzSncgzW
X-Received: by 2002:a17:902:e843:b0:2c9:e961:d256 with SMTP id d9443c01a7336-2d0523b7dddmr7626885ad.27.1785518858110;
        Fri, 31 Jul 2026 10:27:38 -0700 (PDT)
X-Received: by 2002:a17:902:e843:b0:2c9:e961:d256 with SMTP id d9443c01a7336-2d0523b7dddmr7626635ad.27.1785518857592;
        Fri, 31 Jul 2026 10:27:37 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b0ea002sm8396045ad.49.2026.07.31.10.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 10:27:37 -0700 (PDT)
Message-ID: <440d1bf6-4b6e-4c87-b80d-4e6dc1a65639@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 10:27:36 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] ath12k: NULL deref in ath12k_mac_op_hw_scan() when a scan
 is requested during firmware recovery (IPQ5332 + QCN9274)
To: Kamil Bienkiewicz <perceivalpercy@gmail.com>,
        linux-wireless@vger.kernel.org, Jeff Johnson <jjohnson@kernel.org>
Cc: ath12k@lists.infradead.org
References: <20260731094141.2410630-1-perceivalpercy@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260731094141.2410630-1-perceivalpercy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: ySfROcIWXYFZbTWE024iSRiGMOl5OeEd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEzNCBTYWx0ZWRfX+ACAc/2RpQ+j
 02IjG9pjXDqhChvRRwl0T70JOLY4mo90UKZYMZizMEe0MI2BxtUzIfem36xNCyKxRKT9qckHwY7
 o8kTY23HO2CPFsuF/PBcHZ5QpxqZ03U5kClS1iGSclnW70ZNh2JUJ0B8jepvCB03jM1zQQoK6Fn
 TdZPAh3oGYLWrFRzwjuTJTk2Z5zPC9Hjk0SEZ7nZpQfPUCb6HGRQHIqtw5uZHF+PmIC/OY50Vq6
 OfDGhj+BQ71foZ8p9eiIz+7f9bJHwZeaIudWangb0FsR49npLoD1DeN2WCLP5vGpPbalunCjq94
 BwVa9agYVEm7v+44ReFMVtB6JlBBmBeK2mE2vgMIN3WbiKGxcVbKqgHsc9wcHSSb0cXr1axpVHR
 sCm5aQ1nSIl6T71RndsRF/O9BGlou+eKq8gLTunkZtfzZuDEHACFp9WQ0kTCEuKzP/9p3mAjUU7
 0qMgYIE3248PCO2PT8A==
X-Proofpoint-GUID: ySfROcIWXYFZbTWE024iSRiGMOl5OeEd
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEzNCBTYWx0ZWRfX1I4qZkGMwwzJ
 8twPW3/tUWnnU1+Kqf7Mv6RavKyOA7DuSaRxQCkrBbW95jhly+8tw3Waa3K0dXDLqMX8TlOC1zC
 j2k69vB+2HKZsPZmhumDRoGre9ZIHIg=
X-Authority-Analysis: v=2.4 cv=b+uCJNGx c=1 sm=1 tr=0 ts=6a6cdb0a cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=sTRtGAPE7L7RgN1B:21 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=TK4Lw8CIhuz7GhaftzcA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310134

On 7/31/2026 2:41 AM, Kamil Bienkiewicz wrote:
> Hi,
> 
> A scan request that arrives while the device is recovering from a firmware
> crash oopses the kernel in ath12k_mac_op_hw_scan(). Because the oops reboots
> the AP and the same firmware crash tends to recur on the next boot, this
> presents as a boot loop rather than a one-off crash.
> 
> Hardware:  GL.iNet GL-BE9300 (Flint 3) - IPQ5332 (ath12k_wifi7 AHB, 2.4 GHz)
>            + QCN9274 (ath12k_wifi7_pci, 5/6 GHz)
> Kernel:    6.18.39, OpenWrt build, ath12k as out-of-tree module (Tainted: O)

Unless you reproduce this with the upstream kernel you should be reporting
this to the OpenWrt team, not here.

If you reproduce with the upstream kernel, see:
https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k/bugreport.html

/jeff

