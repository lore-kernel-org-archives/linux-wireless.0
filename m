Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABEB3F327D
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 15:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784735507; cv=none; b=SY10BsljtiAPIsLTypdGhF9RPuW13K7g/X0Rj5sBhMHNeghFXdC6GyUou1mCxAysoPElen2rUBYO4mt4OdKF6rTj43R6h1aL6K7Q4mw4PW9axmzMfATcNKhDHi0RIFr+91XxlhHX4BzoXf0DKWQemmdlRBOGgAI4qOK6KAqYhgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784735507; c=relaxed/simple;
	bh=g0RQ1VseOu8D8mX8OMGBRzcOkCsTj/6FhNtlImfHfPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IhVqYhvV5UcR86R7TyKYdiqzLyKKRICQANKJASO6vYx24rN/K8x1MUyEtNlLmL2Ofr0gx/lrGA6yDIUoNd3CO0eRwa6v5Erm3n5AsxeARscAY2cOoz5PyIrn5LGow2BqE/YimlN2jVzJmMls9KKcFWl5rS1QRp0zWZbEJFo2Fsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UXD4in6l; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VUBTmvk0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UXD4in6l";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VUBTmvk0"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MFY02g1146397
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 15:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hOS8C9O2mpDSWwcI2U+Die3+r9YuIRHaNSGUW96C7PU=; b=UXD4in6lEx65asPm
	4IOzpayhTLQ0PJAfzip4L2A1hYHhdMy+4AXS34TJkQr1ptkgob8lqPuPFd0IBa0G
	Awf0peLgEYF9hncGxu8Tx+vggFPcE7rK8w6eYxthHV2+vQFPfREC9L6o4GlUmUne
	Wy6aCMkCXk8c8XEjf6D4wasmul7r4duMeFmpJPZgv6DyLQPxi92eUcddLrL1+ZHs
	rJ8NkgleV8u76dlkzHo4ko4ubT2uD2F8mRjp2+Kik5eKBQtu0VguAGVxlW7rbKVj
	1wssL+hD0alBP8JS5A40Z0YkERo94/7ugJa57xOr5GgEAvT5b+skLXT/9zBto2cn
	FnySQA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fjntn30gd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 15:51:43 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb711c88f2eso2565690a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784735503; x=1785340303; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hOS8C9O2mpDSWwcI2U+Die3+r9YuIRHaNSGUW96C7PU=;
        b=VUBTmvk0r4+lynetOPS3fSaTPhfYvOZoV9jNo10SbToUM020r3Ew7I3SosnCyxqNTM
         NRy/PKPPAj0+7Rad44bOPKLKXC6In3U6K97L0Y0foWaUn71krBdkwxkSPt0M2GVZNDUG
         5/G4jKl9f/GsCfrlMXnhUeqWzd5jyCnUzWNcjZxL8RnAyAjhsr3AIt1XDM+QWEelVxVC
         kDeMjN+GBHJ2mfOUJRB8KEjT7RPJzz9DvGCCfl/LeyED7/CcESJ0Jo1qDiy5GasK048U
         +ovS6jXn0OJA2sJpaV2tTIPPB662Z6bamhMzxQfmAI+95ZBxFBMYdCwrDSQk4Qh/gs/x
         kl3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784735503; x=1785340303;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hOS8C9O2mpDSWwcI2U+Die3+r9YuIRHaNSGUW96C7PU=;
        b=G/QfZg8iRcof6XC9keReR2zNfBDglwfITTHsI5HJk4wcm+RRmtd5e+vtH48vWq+P0P
         FllpyKIq5eQ1Vo2Jbu6mmBrLMfmztPdoUAPdM9HXvOIQ7qde/mlYpyhr5R9GjZvtvdsH
         M5ZnOHw6NhWxUIrW7RwWOXWpmEqbZpbSRWDUsp543xrttcMOXS9IqJFHLbFGxy4UX2b0
         CfIRXhbCKnLq4zTCMSi2+DDfcTxYtuPNkQAonoQLkt6nW03ITlivFu+CelYNVDMEMkY3
         LiyfajummhHePpA7ZQybzzBKXxoLJogCHDDSGvnyeQ84mBtgP4IRczXB8cSgRIHuf0oP
         M6iA==
X-Forwarded-Encrypted: i=1; AHgh+RqLNoR2whVQcIx0CJATIIKSA48smUSRK6I2O6Qnlxs3yk9wiLyt+I3sjM63yJQIFUE52O8x0uzuudacH+dMNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/M7eTbMk9/TjcsBgcuTs7N5ALY3OPnd3DhgERfgtMmWJNcpY3
	wN0lm51+w0S0fOjJp4NOxVIAd2xymcb54RIQKm/P+KBr9tIHkrcnKp7pTrMNQ8BiNXYGWKu6EkB
	AygPQZvPyI/z1uNEVi26KXWqCFYQr0KNTz1DfEQtZmC08N0vqHi+vfqznTlFY0L0eh747ew==
X-Gm-Gg: AR+sD13r/XEODe45JAp+cNG5h2GzVpX4GwtaCAPho4YntGjy2EiZiv1KkiJW6EPHr4D
	Grdk4VEc5Qg33DOvR8HZZ3pdzcWyi5A1FEqmZktFLC794rWIJaVhSOTLeWmlj/Ky5HF7HbkfwdY
	b/84dYkBYpB4Zg2mmYxL/1bOjFLaQyvs41qMeWLu5q9I7PCl0iLiXo8qUVqv7+AC+dlg/a2Q6GW
	w33laMcYkJS0F7VdjhyOotjyQa8CaPcrKGsF6epYbnRHFzlhN+HbIQcIs1sKwN0gjYx0ZdpdgBN
	Ofht4i8B/Ivho0avGbI6n4Epmbvm97lQpusuYnj6+Z9ytzpa4bIhNAoF21wLpZ30LxF3Uz+wijs
	cbPidgi8fKliHmXpXef4VrT1lyQJ1T+0G64+2zOkTMyHng/gmITcX8fK6ZG4v
X-Received: by 2002:a05:6a20:2d07:b0:3c4:3112:45 with SMTP id adf61e73a8af0-3c431120182mr4018438637.1.1784735502580;
        Wed, 22 Jul 2026 08:51:42 -0700 (PDT)
X-Received: by 2002:a05:6a20:2d07:b0:3c4:3112:45 with SMTP id adf61e73a8af0-3c431120182mr4018400637.1.1784735502119;
        Wed, 22 Jul 2026 08:51:42 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e088d3fsm10913111eec.25.2026.07.22.08.51.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 08:51:41 -0700 (PDT)
Message-ID: <0833afbd-4a25-4e7d-8e77-ab9fac9d36cf@oss.qualcomm.com>
Date: Wed, 22 Jul 2026 08:51:37 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: pull-request: ath-next-20260721
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>
References: <f73b76bb-dc27-42d0-8e47-b617eec766a6@oss.qualcomm.com>
 <67b88a3cc68473a1ee9d2816c4b5fe07c378434f.camel@sipsolutions.net>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <67b88a3cc68473a1ee9d2816c4b5fe07c378434f.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=AJsSZ1gA c=1 sm=1 tr=0 ts=6a60e70f cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=XsDMgvtJpxJmlFumrWkA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: bi-WQZVE24VMjs9ygYPZCOAEcjRvHy1f
X-Proofpoint-ORIG-GUID: bi-WQZVE24VMjs9ygYPZCOAEcjRvHy1f
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDE1NiBTYWx0ZWRfX73Fdbz6PlaAP
 pyAU5RiIH2vCDpW3qTyW5I19J5Ay7CioSS+K1D/mnYKaQbdo+LeOB3SmsW/6DrFcfGuOtxQkhX6
 /p0kxptsbPuO6EvtxWozowu9Yd9cN8U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDE1NiBTYWx0ZWRfX2zohDaLARpWY
 kSizDQ4CSKhw8GqnOpgufyu8xNfwcp/KpRBHFBigaYLCt5OgMzv22vxtliyKggBknmRAe/KaFcD
 2veq4l7IDqHa3EnjjR9wJxQcsyt3Hm+9uTFELWDN9TI6Nfbq98Z5euSViqNs8rQ76lk061hl/Dp
 TRLj7Pp4IPThK5fWPxjpYu+5kjzw/gXSArkBqn/hm8IZnRBFHG/e87Sq7F9YlBfLnySB7KFsshO
 trnh+NxEhHfqLudTdW2PtF7apIWE7bX20knzbdXzZeUTxUeMpuUAg5tAn9juHWJ6gnj8TNBFhZE
 uhTCXRxsZX6QaebYF1HRVe+A3w2qdhv7HMjNF50fASePNxNH2J9MRxbN6HEX/7iakeVLwO3+fEv
 ZsJhXibclTWnwWR4T9QSQZOAQictBc+N96+ZVW5afRwBedCeysWXYlzrIzGox2dJvpS93h22bkn
 MbHlzkCLog3Sq9M7W6w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220156

On 7/22/2026 7:08 AM, Johannes Berg wrote:
> On Tue, 2026-07-21 at 16:46 -0700, Jeff Johnson wrote:
>>
>> ----------------------------------------------------------------
>>
>> NOTE TO UPSTREAM MAINTAINERS
>> This PR includes the merge of an immutable branch from the qcom tree
>> https://lore.kernel.org/all/178362521364.2422497.1305957434056184382.b4-ty@kernel.org/
> 
> That's annoying, it added a kernel-doc warning that now shows up on our
> output... I guess we need to ignore that.
> 
>> New warnings added:
>> Warning: drivers/firmware/qcom/qcom_scm.c:1055 No description found for return value of 'qcom_scm_is_pas_available'
>> Warning: drivers/firmware/qcom/qcom_scm.c:1055 No description found for return value of 'qcom_scm_is_pas_available'
>> Per-file breakdown:
>>      2 drivers/firmware/qcom/qcom_scm.c

:(

I run kernel-doc on the patches I process, but since I didn't directly process
that series I didn't see it.

Bjorn/Sumit: looks like there are a lot of those that need cleaning up...
% scripts/kernel-doc -Wall -Werror -none drivers/firmware/qcom/qcom_scm.c
Warning: drivers/firmware/qcom/qcom_scm.c:317 No description found for return value of 'qcom_scm_call'
Warning: drivers/firmware/qcom/qcom_scm.c:343 No description found for return value of 'qcom_scm_call_atomic'
Warning: drivers/firmware/qcom/qcom_scm.c:440 No description found for return value of 'qcom_scm_set_warm_boot_addr'
Warning: drivers/firmware/qcom/qcom_scm.c:453 No description found for return value of 'qcom_scm_set_cold_boot_addr'
Warning: drivers/firmware/qcom/qcom_scm.c:1055 No description found for return value of 'qcom_scm_is_pas_available'
Warning: drivers/firmware/qcom/qcom_scm.c:1147 No description found for return value of 'qcom_scm_restore_sec_cfg_available'
Warning: drivers/firmware/qcom/qcom_scm.c:1325 No description found for return value of 'qcom_scm_assign_mem'
Warning: drivers/firmware/qcom/qcom_scm.c:1396 No description found for return value of 'qcom_scm_ocmem_lock_available'
Warning: drivers/firmware/qcom/qcom_scm.c:1413 No description found for return value of 'qcom_scm_ocmem_lock'
Warning: drivers/firmware/qcom/qcom_scm.c:1437 No description found for return value of 'qcom_scm_ocmem_unlock'
Warning: drivers/firmware/qcom/qcom_scm.c:1767 No description found for return value of 'qcom_scm_hdcp_available'
Warning: drivers/firmware/qcom/qcom_scm.c:1792 No description found for return value of 'qcom_scm_hdcp_req'
Warning: drivers/firmware/qcom/qcom_scm.c:2526 No description found for return value of 'qcom_scm_is_available'
Warning: drivers/firmware/qcom/qcom_scm.c:317 No description found for return value of 'qcom_scm_call'
Warning: drivers/firmware/qcom/qcom_scm.c:343 No description found for return value of 'qcom_scm_call_atomic'
Warning: drivers/firmware/qcom/qcom_scm.c:440 No description found for return value of 'qcom_scm_set_warm_boot_addr'
Warning: drivers/firmware/qcom/qcom_scm.c:453 No description found for return value of 'qcom_scm_set_cold_boot_addr'
Warning: drivers/firmware/qcom/qcom_scm.c:1055 No description found for return value of 'qcom_scm_is_pas_available'
Warning: drivers/firmware/qcom/qcom_scm.c:1147 No description found for return value of 'qcom_scm_restore_sec_cfg_available'
Warning: drivers/firmware/qcom/qcom_scm.c:1325 No description found for return value of 'qcom_scm_assign_mem'
Warning: drivers/firmware/qcom/qcom_scm.c:1396 No description found for return value of 'qcom_scm_ocmem_lock_available'
Warning: drivers/firmware/qcom/qcom_scm.c:1413 No description found for return value of 'qcom_scm_ocmem_lock'
Warning: drivers/firmware/qcom/qcom_scm.c:1437 No description found for return value of 'qcom_scm_ocmem_unlock'
Warning: drivers/firmware/qcom/qcom_scm.c:1767 No description found for return value of 'qcom_scm_hdcp_available'
Warning: drivers/firmware/qcom/qcom_scm.c:1792 No description found for return value of 'qcom_scm_hdcp_req'
Warning: drivers/firmware/qcom/qcom_scm.c:2526 No description found for return value of 'qcom_scm_is_available'
26 warnings as errors

> 
> I also get two fixes tag reports:
> 
>> Commit: b127f79a4933 ("wifi: ath12k: Correctly copy the hint BSSID in WMI scan request")
>> 	Fixes tag: Fixes: f40abb4788a2 ("ath12k: New driver for Qualcomm 11be hw family")
>> 	Has these problem(s):
>> 		- Target SHA1 does not exist
>> Commit: fde37c064641 ("wifi: ath12k: Set IEEE80211_OFFLOAD_ENCAP_4ADDR after tx_encap_type vdev param")
>> 	Fixes tag: Fixes: 729cad3c3c9e ("wifi: ath12k: Add 4-address mode support for eth offload")
>> 	Has these problem(s):
>> 		- empty lines surround the Fixes tag
> 
> Note that the first of those ... the commit exists, but not in the right
> tree. It's in some ath12k-bringup-start tag in your tree, but not in
> mainline, got a different sha1 there. So checking locally is confusing.

Let me rewrite those and send another PR

> 
> johannes

