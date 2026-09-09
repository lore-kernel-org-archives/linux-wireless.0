Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B0F2741B6
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 05:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788931847; cv=none; b=QqWNSEnluwPwAJKayJJhMkNE8qPZTujM9xVV9A/X7dQkPwgrB5lopMwdKsQB/owgXBoAzmqLVHpNSESLrbl8JLv3FifwYPdhEQa61GyXyH1lKY9rrmR6+wB9gL0EH4WB1J0Evn1N+bwgfFI0LDGl9FXO+ooCN211DKIFfmp6rRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788931847; c=relaxed/simple;
	bh=ujnN/sAIf72vxVEkpjeZYGnyWp4W0F2uM5MVk1nSLCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=co+34UxBYHWAAN7zz2Mk9KDQMamhT/SNC9oF62QjEwLwKlYsfuKPQ6c+s9wk5zcPq5R8tzol+qHBBBAsZsVOpouLL2yKLtONIppaX6slSoLYwsvPaorx5+Lv7WRvM2lJYzyzHWfMIafcTkHxKK/l95EwA/Z5m7gDjOnN94MiiY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pnii6YVD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=guxwlNaz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pnii6YVD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="guxwlNaz"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6893p0HU3771184
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 05:30:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	28mAXJkgQBElGoPGawNKKV0hbSPv3nmnTLTFUMINKVU=; b=pnii6YVDyStQHVvs
	ML27+6xSC873SG3O2F7Yap4F14W4VjG0Eq2dlyIbmyki8KCEBtASYrtVO2etPonJ
	OUV8ptkukVPVUB10nz8SgpVFq1AhklvSDwzMgPLP73dyV2y0Qlgy81SKzqFlKR/N
	4N+AQ9wbT0DoYpeY/wy7PgnZZ7l1Aul0HbP4YzLCtVl8UHP1dynU7Q+HaIQ0BhG7
	3Uk0GtYzJZAhRs0pemEdDtuxPnFc2Fy2xzqo1zCwiEau75bIQ/PxTEdKvwTEn3ej
	JvS+p9Tavo2mNOJUGFYFuA9Rc5sCsn3KuRcTwWbqy88Vu/HnWUWii+ZsaVPzAw1D
	I1GmTw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjywr09qt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 05:30:43 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39533bb224cso2950875a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 22:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788931843; x=1789536643; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=28mAXJkgQBElGoPGawNKKV0hbSPv3nmnTLTFUMINKVU=;
        b=guxwlNazb5/yR6DDJthnSjh/ttHHeLj4KZcx/O9l20LRf2fwUFqidxLN3JXKFfE/Y4
         BL/6XIABG6s+upb8esb3UMDi/+77r5JVA0YyWpi6/PB1XTPMy9ZLF8DjHNHKeTmzlHWH
         +/KCrQOnPISXX+wQGVTUJOPCl5crrA+OefwQjWUmG7i0V2/QLwTrnXNNdVPAIDke/INo
         4PhpIi5AsGEJnI4xlkTTbTDUE2oxa154EWjQjxrxFAiUMaICTc7Zp0+3GBdfbNm52spk
         cu/bleF5ANT9FNE31VHiwfJSA+Qx3bsJmEgdITCJMRYmGDPs3uX9zw/6NJwLYeKcxcZO
         e7Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788931843; x=1789536643;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=28mAXJkgQBElGoPGawNKKV0hbSPv3nmnTLTFUMINKVU=;
        b=ZSOjleEjFZF7JGiuk/SSuOufd89/QL0rlHT5vRtPSbK+EcCzrjY68FEoxmO59lCXHd
         4wWvTcW2z4xfsPBZ/aTiY9r7uJxv7+wUpz69VEjaJu0bUhKP6FWA9QDfvfvnX7OrUdL2
         d/ucfncgvtt7tWPdtdMVoCLJjyAGRYxCGipKHaYt7/2ZXbIqgqpVBHebnCX9E5na0cha
         MIyRAvFvmVwFE22yS2EBie1WT8osd5PQkN6N0qy2/4GR2w7FcnaH6YsKmFN1IMjqQL4r
         Y/uX4jSWL1hLCNFXE7vCFPDb59pgTc2TKYsayUmEOfdcNJPjqXAiq/oIxcfsNuifZC16
         6B8w==
X-Gm-Message-State: AFuF++nOf0SBOA8y5R+pFVm2fH1Zr8znlcvrkd91tYA54WuQVqdmQbkR
	tmNj8Flfu6UtHsxm4MMs5qq5LK73fQy4wnhBXdJJoUfLd9LSMtpOeBylGk/dTBpbAJYsipDmMVG
	27sWWe33qCdCL+m0UJAloD1gIpK79VFjHcauaGsSK5GI3yVa+jkfx1L5+9lI7Jds/5QQ4cQ==
X-Gm-Gg: AYBFou220uZvb4iAmu6YuGvE1pc5rl9Xxvclfb9QnFV/TAlzB2p/3/WbCCEZpv7gMDz
	w1jPY5bi+c/sLUtNmP3ucs05GjbnEhmFFvfIpR4KzVqm8hlnT8bym5hAg1sDC21YWos8RncrjJb
	T4HKtO54u5WrhTsGynYnn+78z3bpuAAtq7jVCKlOwmiDWRLgVf/tbSsQfdDIJwHayF7UNXnn949
	Tcyj7/RI4H9EKqs+0Ahx3tAhe300pFc3AwmFPGDN5kgpyXSh8Xp/kf04DeVIjmKOD+leJC5yoCg
	p6fCrguGvJPlYMCYTrkgOcSKi4ADCSscSFgE9bz8yqhzJdOEZ469Z7x5kOBxHqYG1C0qJd1TUID
	P0YTlKtQaheMpmH38g9/lYx2jh9TXXNcmPQfgxeklKQKkTmTRD0u9spY=
X-Received: by 2002:a17:90a:fc47:b0:398:9c0c:7c72 with SMTP id 98e67ed59e1d1-39b2627fe24mr46062841a91.25.1788931843070;
        Tue, 08 Sep 2026 22:30:43 -0700 (PDT)
X-Received: by 2002:a17:90a:fc47:b0:398:9c0c:7c72 with SMTP id 98e67ed59e1d1-39b2627fe24mr46062791a91.25.1788931842592;
        Tue, 08 Sep 2026 22:30:42 -0700 (PDT)
Received: from [192.168.1.20] (163.sub-97-215-3.myvzw.com. [97.215.3.163])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339bdf26c5sm42457453eec.27.2026.09.08.22.30.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 22:30:41 -0700 (PDT)
Message-ID: <83dfc5e5-6715-4e31-8c25-0a6de9a5ded8@oss.qualcomm.com>
Date: Tue, 8 Sep 2026 22:30:40 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: fix stale skb pointers after
 aligned TX payload shift
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260818-ath12k-uaf-for-aligned-tx-v1-1-d6ae195b15e7@oss.qualcomm.com>
 <4ed6651c-b1d2-458d-a210-5cc72954b48e@oss.qualcomm.com>
 <aba5d600-0d8d-44ca-9367-7cdc145e9732@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <aba5d600-0d8d-44ca-9367-7cdc145e9732@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=a4YAM0SF c=1 sm=1 tr=0 ts=6aa0ef03 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=7QqFuFOOHQR3GLhHC5mhXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=f6GMtpyFpLIfDJgts9gA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDA1OSBTYWx0ZWRfX5VZRu2b94K+s
 n4D9UQ3pPdwf+SjhX6oFdrtlHSMMOHFPr+/xkpOX39dGj6GGlY2Ebd6F/aqxCwt9W3LJSPUGh6V
 6C6gvq4BuYDmzRKgMuYiTwr/Ooq9vNqIa0+mCDesCiT/dhBUKaovOdeOkcDymywWogVG1hIyZQz
 polEBLyw9kfYQ2x2J2i0rNyKofyaf//Yy8f6EhyeoEzk9Bxbqxi3lQ8X+xRPS7fRfckNh8ANo1d
 +7ttu17uogbdS1g1EwJn8nCtBq7zE2YR17YW7gVUoB1bHkz15hyOA857JtJC+MX1kTlmDu9eoRR
 ASgvk4AYDu3Z+fnAXf1KWTiOCD9tFajCrrOW+WZ9Rb3IvgaTmaJfwDMhCCB73LH6LEUdjbQCP9J
 hZkSrw+5Z0vRN1jCleMVAehqoig1XCe9qhJFfDeCzyhXDowqspFk9MdJIsHz7QIRn8cRMD0lRD6
 k3T+LPiqabUcB6lnKvA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDA1OSBTYWx0ZWRfX83Ws1xQ2nzZq
 gALrJigzZP7YqDj1mNa4yLxMbnzeiKeSrxi6/RYXjUnxnCpqqc6+O6yaQCcNC3/jrpCkbyC2VEn
 8nQ8w2WCKixvrgkzZHMJm24e1NtnIQI=
X-Proofpoint-ORIG-GUID: QL7LrW0EFWDyQvDoEHnxHit1-RxN9WZD
X-Proofpoint-GUID: QL7LrW0EFWDyQvDoEHnxHit1-RxN9WZD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 clxscore=1015 spamscore=0 adultscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090059

On 9/8/2026 8:45 PM, Baochen Qiang wrote:
> On 9/9/2026 4:55 AM, Jeff Johnson wrote:
>> On 8/17/2026 6:44 PM, Baochen Qiang wrote:
>> So I'm taking this patch as-is since it fixes issues when the buffer is
>> shifted, but we need an additional fix to correctly handle when the original
>> skb is freed and there is a subsequent error return.
> 
> agree, it is a different issue hence deserves a separate patch. Do you want me to submit
> it or you will do it yourself?

I'd like you to do so. I'm buried.

