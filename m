Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801335;
	b=n18t0fJ0ZbWaJRDGvvgQN9iqguxGZhde4ZUaHutamzHXQGEGmzOu4N3lBuUa+hEJk1No
	 xQ4suGKYeA8NlCGqoyGrDWe3wRKVyEdVP9ao6YQGITVvzrT0Y5M9yWUHYTKgZhewmQAF0
	 N78/dCVvrHqoKbEYR7isBpYZeszCJXUrC2sHivvHjFj4WiAc8NguZYHbxEm7LrIYAEU9R
	 kOFBSogzpe0PmxjtB62PVoM2Cm+XlHXjKHf1+EabNVftMtK2aN3WZk6WTBWnS8+hBZDAo
	 3d66K3OsKsI9iMJDuc+DoY/YbFEVhRCB8JHt8SLZBIlv2DhglNDnW/qTW0YIfukdcJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801335;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=i+X/nIg7Kl1NLT3cyQDdj+/n6Eh9J2E9gTlg4zspLoY=;
	b=KIYNrZO80NFOtQ2BgpoK6hbv2oG35SHMzOjS6yOGLy1pkdiI0BtsSvDZcmG+ojWYmJAe
	 khhObJ9w0HsPNY1LLumqWEnPhgiUD1omkvkpW910087XAWC5d38a0v3x4Z7Fl6UzAFHLz
	 tMpVEjK6H0mm9lv8VYy6beWUuacihkKD6j97k0HcCAswxfDogyHxLekMGkK2chLnKMEdv
	 x0qrXI3FSpQxwRPsyJZkQDJQPcDKpjRu59X9LmwP2rNY3e2dt+9nvYbBfcxXB4gKMRA8Z
	 qkqIyHeZlXniqLTDRgg3awdJBYal/DLXczQy2S7FMjHJ8tIJplJGonNUgyQDkiXUkBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VdQXrOEe;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fUvF2lwj;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF56B606A33D
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 14:08:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF56B606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VdQXrOEe;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fUvF2lwj
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A4Ba56u2310421
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 14:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=i+X/nIg7Kl1NLT3cyQDdj+/n
	6Eh9J2E9gTlg4zspLoY=; b=VdQXrOEewZVdCoYa/Al0u6Q7FBGMKILB78CII0mt
	AD6u0ddjAVUbTfThKihS5w5rS6ycNjNwnvMHyF3G9Paad0/0Eoo2KE4SvK4I5i7Y
	4aBtIHSe/9J0vdzkclBF4/U2xXLRIXEdtnkTYXMHIduqJ88+ImXVQXH05WnNE4Mr
	2YMmATZinKEgANyPMoIC2KwfHmu3HRZNxso6jXuCg9tHBwWo2rmVkaLZOnYZfbif
	xYp3/9mV75SfdE3nVUfxYLQkPe4eqnK4FvA7z0gmpFOI2oalHxQZFr+9qorQLwY+
	+E19xRnoeGSrSdaQxp+G9hqabUUBriS+rUoUc9BmYPTeng==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqn8mv6k3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 14:08:53 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5c83124d530so578446e0c.2
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 06:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793801333; x=1794406133; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i+X/nIg7Kl1NLT3cyQDdj+/n6Eh9J2E9gTlg4zspLoY=;
        b=fUvF2lwjy3U89hxABWmTHfDhTIjUHSgF0XwjScU4TV0H6Jjus0kGrez/axp0GJVC6q
         6Ic95ELprTWdtlCadGZxHPDDV+9SoGrrOFSFHzcldH9j+qw67G8dwe0xtmx5mi9z9Vwq
         lb+SI7UTFhEHCmxHawV3Yvw0D/3t1Z3MC0HxyeGgaTpZcs198PFp3VueLdkI9E2RCK6j
         5yIalA/7xzi5E4cHz2QvqGR0IPkeO+SqDfC7kOwXlAT2pGneTpOtiy2q+Y6pL5Wlt0He
         KvbnRWZ890aF+r8SBm7iLcNrt0oeuotAbDGGWXOdtqo8QxLac1kzRVqqgzCCY6A0Zqzc
         qrpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793801333; x=1794406133;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i+X/nIg7Kl1NLT3cyQDdj+/n6Eh9J2E9gTlg4zspLoY=;
        b=CWKPAEhcJox+GlDyW5OmdRXtEh6uDnQsK+kiJ+3ZeMkdtw7tJODs44/i8jGjWyAabo
         tU5CyhI0l9muNMdgUPWmvmJh5qxwLRlyinZQiEJ18PIcWVlSU+TJ+IiQRlk086BgHUYZ
         dlPubLZlShgxkxaU0J2hoaYSGZGM8jjKhYbcWmIttGIDAa+lD7MV2nb6luU7JaxHg2iW
         EcxS39He/xbzc3gIi4S6damYlbtsykZONZI7IVcQiM0urcuSRNJ9icDWLclUjhTK+TU5
         +/Pbp+NYIMUbtXKGYDYHC5z9QE9vyZDc7k2CHWrgy+ufYmrQSDz9b0BYghni4R6qBYJD
         nC6Q==
X-Forwarded-Encrypted: i=1; AKwUvBxToQGTQq6HKoz9eYV+6G6r7zjvgPCAOv4pyEMaW8RrFMCnuzghUKUcfihAJJHQq5ko/YgrGijKRcpVS6STAw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9HYRFTmKjbWFenA8UBmTuMPHZ9GrnZbJHjV0Fwem9hLFnL1uPZ
	YK8Tz+qzAf+7wYaNPjpYcYCQPLoZ6rUkExHjMcshikiJErSS+ksMFKRII1bGt7uElwYWQlRnjtO
	1Os/hiJPMVRSr00o/CM40PhZuPYQbIu4IKRJlfvs5smpYnQwlyimbyDV8qLbBHCk4Nkd6Sw==
X-Gm-Gg: AYBFou1ZsVOxgkTi7/U1ZotQL2U+9VBFJ2gBDoJrIE1BMijtDUNtHmuOp9MEG2DE41j
	RGD1tL5b39umsc47QgHwSYPGtFfgpaJrwbQMUqzZIAnEYYcMn8ai3sxrrUWkvSy0YyE8rWDk6eG
	gVxlYU8ubnDuY6x45Zl/4nXyhMu7+bunqDuRsgkhj6MX0RlDWQM18QM3NmVeHw9sFbuHSZPykbd
	+dE0FwQ5/7gBKG0n4DCnbWUK42lANgsW7ENXnyPstyIdkXAdKguZIxpiFuJ/8QiKOVxU/3iozZg
	Ut9dNylfM3WPhuDvzG2z/oL1dXXwDAQwYE4dumU+XbNGF0RjtBOWZbbbXIf2M5AjVFb/m6T5Pzl
	jnFZEDK9SToG+6v726ElWSrJHJEMRT5g88fG/Q1/VZc/26aI9tYfAkLlxsh8e5InKkHkDhdPaiL
	PLXeeQa+1T+s/K1ZxywVX0avDgqdmYdG3gP0MUjfS1jFhHX6rqxsswLtMFgx/R
X-Received: by 2002:a05:6122:1d4d:b0:5e5:1be6:e12c with SMTP id 71dfb90a1353d-5ec68997250mr7860217e0c.21.1793801332834;
        Wed, 04 Nov 2026 06:08:52 -0800 (PST)
X-Received: by 2002:a05:6122:1d4d:b0:5e5:1be6:e12c with SMTP id 71dfb90a1353d-5ec68997250mr7860169e0c.21.1793801332221;
        Wed, 04 Nov 2026 06:08:52 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bff38cf643sm390539e87.70.2026.11.04.06.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 06:08:51 -0800 (PST)
Date: Wed, 4 Nov 2026 16:08:49 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
Cc: Josh Boyer <jwboyer@kernel.org>,
        "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "Dreyfuss, Haim" <haim.dreyfuss@intel.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        "Yang, You-Sheng" <vicamo.yang@canonical.com>,
        "Hutchings, Ben" <ben@decadent.org.uk>,
        "kyle@infradead.org" <kyle@infradead.org>,
        "Damary, Guy" <guy.damary@intel.com>
Subject: Re: pull request: iwlwifi firmware update 2026-11-04
Message-ID: <mv4f6j2pmxcdbj2ranjmhgogb7pou2qny6phqg444l455bvmq2@ijma66dusr6r>
References: <IA3PR11MB72131346BF3C1FC358A2344FDAA3682@IA3PR11MB721313.namprd11.prod.outlook.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA3PR11MB72131346BF3C1FC358A2344FDAA3682@IA3PR11MB721313.namprd11.prod.outlook.com>
X-Proofpoint-GUID: SKxSpgtdnxyt255WxvO3ZuYadJjb-DDl
X-Proofpoint-ORIG-GUID: SKxSpgtdnxyt255WxvO3ZuYadJjb-DDl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDA1NiBTYWx0ZWRfX7p18uGC7E6wy
 tQM1F4nlqcxbCggKCiOH3SfGa0LI/VnL4/VE9h73z7Xg0+7nrc6tW31htOCFp798Bffi1QZPTlQ
 Sr5skmDvgysVl46V+oCTfMgDaLFMn87YUiGBNGNw92r9hc47shr+SulIY72tG7hLcoscy2ylFWE
 TKY4+dTxMvwA1pK3hAInsIF1FL4uR4TCI9mBuiV03+jt2VkXs3ZKV/9a7Cyd6c6dTqMN4blmhyp
 1FIX4l5gv8v6qadidNN21KHrCf2IQJYQMqAQaLvMtCtwlNkOCJ6gjJgil0a+DJiqNgPhfDWTgsx
 7YJ+ReT7aAsjfNX40cWcartOd97PoPbfHfF0WXzW8clV3i6Dsq1lv31fRt61MnKNPdVAn9XIt7i
 0Xanx7Z44wlvwwE6/xWawC13wp4A/k7XhoUI61ciF93ReB7OkWtJt4fRjgXNCNPUr21RBFaHm+w
 PD6VjRiqdU32TJLeibA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDA1NiBTYWx0ZWRfX6Zaev+pl+pP9
 enYLsA4UlPgxuXK/aNsE2weO2k8NFtLL95qMyyATv23vTFEwW77sDVJbNXQs3Qts5cu7vMFDfcK
 anOywBtI0ERFT2Z93fZG6STdIt1MtBM=
X-Authority-Analysis: v=2.4 cv=HbWB3SE8 c=1 sm=1 tr=0 ts=6aeb3c75 cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=dKIYUFIQmK5j6gWxYHwA:9 a=CjuIK1q_8ugA:10 a=vmgOmaN-Xu0dpDh8OwbV:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_04,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040056

On Wed, Nov 04, 2026 at 07:32:41AM +0000, Korenblit, Miriam Rachel wrote:
> Hi,
> 
> This contains a firmwares for SC/SC2 with WH.
> 
> Please pull or let me know if there are any issues.
> 
> Thanks,
> Miri
> ---
> 
> The following changes since commit 02665d2016e1360cd2135998f36cfa303b5be6e1:
> 
>   Merge branch 'main' into 'main' (2026-11-03 05:36:41 +0000)
> 
> are available in the Git repository at:
> 
>   http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git tags/iwlwifi-fw-2026-11-04
> 
> for you to fetch changes up to 831eb265ef66d3c94f021596b50e832b69b6023c:

lfapply.sh: error: fetched 0f9f4ad5561de009b9656179c11601c3c01230c7 but
the mail asks for 831eb265ef66d3c94f021596b50e832b69b6023c


> 
>   iwlwifi: add Sc2/Wh FW for core24.70-99 release (2026-11-04 09:27:51 +0200)
> 
> ----------------------------------------------------------------
> iwlwifi-fw: 2026-11-04
> 
> ----------------------------------------------------------------
> Miri Korenblit (3):
>       iwlwifi: update Sc/Wh FW for core102
>       iwlwifi: add Sc2/Wh FW for core24.80-41 release
>       iwlwifi: add Sc2/Wh FW for core24.70-99 release
> 
>  WHENCE                                        |  10 +++++++++-
>  intel/iwlwifi/iwlwifi-sc-a0-wh-b0-c102.ucode  | Bin 2214468 -> 2214476 bytes
>  intel/iwlwifi/iwlwifi-sc2-a0-wh-b0-c107.ucode | Bin 0 -> 2268248 bytes
>  intel/iwlwifi/iwlwifi-sc2-a0-wh-b0-c108.ucode | Bin 0 -> 2280432 bytes
>  4 files changed, 9 insertions(+), 1 deletion(-)
>  create mode 100644 intel/iwlwifi/iwlwifi-sc2-a0-wh-b0-c107.ucode
>  create mode 100644 intel/iwlwifi/iwlwifi-sc2-a0-wh-b0-c108.ucode

-- 
With best wishes
Dmitry
