Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3229C3542D4
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 05:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784870894; cv=none; b=iUAjBCX+wmdhcPVqtqzqbd04Id9mwBON2spt7L4O5PeEQ4fMF89rRD0soXZYY+iRFFi9OLxyDF5hwV+HbVZuLrge2i+CB9HSLmaursJ+O7V13DPIBQ8KUx7kbzwLUcHCBjveBMqelKiJ6bwVERoqaTnMj8j7o37EGmJJ0FPzLZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784870894; c=relaxed/simple;
	bh=USCZ9/rVHT+JsR5dvu0BI0FFU8fqnAPGg4iAe5/Wm7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rWqv2wR0aNAwbC4fLAik+TN5shec/Lx4WJ1/1J5hrxFYn3rp3WReQMGLTG7awFH775AeVfRHfPfAIZkhsWJFx8jVxjtZXgxqriGZqf8vbif1zkXSrPEGXXGTDn5lrGIFAUKSXnYOzcRncH6fgmf20y9B4MRSJ/nSkRu7tMXdOTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QoTtO3bC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CKUBWSPn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QoTtO3bC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CKUBWSPn"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O4lJTQ2276380
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 05:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LFjNu1XAKmuN7VKnJSfcxCrzh/BqLfdCpDY+znNSwRk=; b=QoTtO3bCnT420dz5
	C7SF5pA+1l5WwhrUtkbhKUryEVoQsoQbfOXJMUkzARozMW19QCLOSIEDjrGHGRvk
	fumDZaePvFE+OVr27zov9MssxvbrzuG519/K6J7Y6LA2dibjM5K+uh+M5hFMa6Ku
	y1VcvTujZlS55OBO9Vks9LmH/HoM+kRpFDTXDKroc/0Mm6Ju10Lzyh6UE7fqQ9kr
	VEyi4cofXsB52ayUQXQtsPR7TephJ2GQMvvQbpg8KvAFUGXlSxBVFTX0e3NmsQfG
	Z0NPGXXnczICRPThZcQs0xQKglHUEe8rhiO8yF7t2ZcQR7CmcQkW6SorJmiJj1TM
	2YCNjA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkqa0a5rh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 05:28:12 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84240683a82so62716b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 22:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784870892; x=1785475692; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LFjNu1XAKmuN7VKnJSfcxCrzh/BqLfdCpDY+znNSwRk=;
        b=CKUBWSPnuoSmpo5HFmxBU6o1KKRkCmAwaNvWCHGLlEZvgUrmoIpWtu/fvQ49rfMSGe
         Bd6RId0mpeo0Xsxb8AwgVbW5vFdJbwlQcH5c0C8PNK/+6ui0Qxr4bn3Ot8fA2cNytGti
         VqZZQ97bcPqxMjZPJu4y0VEuqVaikq9Jn7NYKo3k5STQqpIaT8NTj8XBIG0AMH1JUouw
         Z4Q4v8P6m5mUqJ+XKpmKZD4OBWTTHwKycIxhCf4kPbAoxzfv11CHhTb7dNQ1Z89W557U
         NVJzKWnlbziBNBMFXQdeZcWv3JOIIyWJCJV49xSl1wMswXABtpM9iMC/2bLAUcBJDhA5
         bHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784870892; x=1785475692;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LFjNu1XAKmuN7VKnJSfcxCrzh/BqLfdCpDY+znNSwRk=;
        b=EL85s+1GoSxfkC5O0DgqzMO44MuRDx3kKeLK2qrgKwv1GJxG8A8T3ZZ5/wKZLu+/sk
         KsQt+wr3Gge6Za/zISIeJIBugOpzy1yZLpntiN0VllvdqNM1m2YwUzg9v7/POhapPdRx
         7yygcQ2d0DohBso6PyUenHe4DOnAx6tNJ46Y5JWAfo3USI3OW1svHc18aSyHIecCRyyw
         hi2NKn1JeXw29dqmU26Rv0HUpUEGKaLGd0tlubctYhTl5IA0Ju+cv1esh/WHkk2Pjmwi
         DIQldw4GuiC5AVi+dLfP4Z6TO0X2DxVtG0Z/pscYIpdHcarqAUaIupOrNHYZAM02cdHp
         MsaA==
X-Gm-Message-State: AOJu0YweHUprnQai5u/379y7n4diYtEqbWf8gksddpWKxqHjwb7CsI71
	i+CW6Jmyn7Gqa67oxo+T5GBNqMGTxCeQETb9Ab73NWl+qyHbO1eCjyHlShXFZopUwUJZ1i64ujA
	h5Qdg55e/GybDHvfTslDCDm6Oy4jJu6H6PCahn0oQ9rMWsnGXSEfAYB8iAlM5H4tUwqMHzw==
X-Gm-Gg: AR+sD13GFkWnvLUA5PsRkAIaXSSpx+YyWdNVaZ0dAR6tHP4Nss2XWeH4YdkPhu/zsvT
	w0MunPvfzGODqmmsrYTw682CH4iobdTUmtltt/g6SmdRTo7pMfK3HHBOfoK9l2+/hGDYw9WnDH7
	j3+4k7d/uPX/KDqYCYvEYer9wmstYw3SDGGjxsXZ+xCv4llSshDW2RYBmCBu3kzQXZwx3JXHIka
	qAYy8TfblbnyC4A7lIb6g2ZqYHGTB/Fi4BgcWX2hvCu+RHBeJVDDviPIz87TQGUgm0MRIWGn70f
	neltDBjllZvFRn21oubcwIDUqGWT8F77VQYL6acJodG1l4OCFRZ+8QQZ/Mir2Zieu0wMVPiPfV5
	lGTeSwKmPd58cBz4NtyVzajNXZBYX9mv0FK8QCPop0WIzg0pvuYfiU8YIEevs6PJn1LPMg3L/
X-Received: by 2002:a05:6a00:12ca:b0:845:d2e3:b9c8 with SMTP id d2e1a72fcca58-84e2e8aa3a8mr5755453b3a.28.1784870891711;
        Thu, 23 Jul 2026 22:28:11 -0700 (PDT)
X-Received: by 2002:a05:6a00:12ca:b0:845:d2e3:b9c8 with SMTP id d2e1a72fcca58-84e2e8aa3a8mr5755431b3a.28.1784870891322;
        Thu, 23 Jul 2026 22:28:11 -0700 (PDT)
Received: from [10.133.33.45] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e172984b0sm4081194b3a.27.2026.07.23.22.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 22:28:10 -0700 (PDT)
Message-ID: <4daa2ff3-f6e1-4cab-8c99-9c9fd0e61055@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 13:28:07 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath: Fix buffer overreads in CSA
 switch count event processing
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org
References: <20260723-ath12k_wmi_process_csa_switch_count_event-cleanup-v1-0-c01ef10bc6a3@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260723-ath12k_wmi_process_csa_switch_count_event-cleanup-v1-0-c01ef10bc6a3@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 2bh-YyApZ6HnU9MIWcV9btfRaG_-myqo
X-Proofpoint-GUID: 2bh-YyApZ6HnU9MIWcV9btfRaG_-myqo
X-Authority-Analysis: v=2.4 cv=e/k2j6p/ c=1 sm=1 tr=0 ts=6a62f7ec cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=2apCv5pjgjHDBs81cwIA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA0NyBTYWx0ZWRfX9mQ75DqrnQh3
 itFy3V/HwFpJdnLtmO02By1HTawRgCPnQd96qqBM0agRUNBGhYD5oFCXmXcxJLhkc9nG7860g//
 U0jamPNqJ3zUf97kltzcej1lHB3I9VvAQC4CvFUIdCSmQB0ylfSy8CDU8isVuZb3WjpjwUPylnD
 Kl9Lx/2FFlvP8DVedMrwF6CAnApBeDLZBRq9+0AGMqYWjqmswLHKKJCtD5n2T8BF2/ewa4EWCK0
 iDit6ZRPiDyQ3M43hBf73D91HLccaEIY5Ifzck3GbQILcZJyiD+mP2d3mGuf2YrWGNzhpqd42iW
 vW2oSFGPuXQURbIZs46M3qPJpWw6tQt3oxUkDV8dOsacQeeoD//OEAbK/CRaVmLJS75o564cjzs
 RwbpijYv9Mgh6wn6sOol3qX5Ab3QNnxhh7GI1Mu7hoR1njkekPFuc1M1Rh7K/vyDRc8GW9arFej
 pvaB8qd1WAK2d0ZGWpg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA0NyBTYWx0ZWRfX4N6TguuryuVo
 pRnzuODX1iKpfCP17hSzlAmFT6z8Ku3wjLDD/yDGyxYB5ntCnKvGsA+4F9Jn94qBnRLo8XU77w0
 MyxUmhdcOCdUJXlzJIl61rQJHaTVPE4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607240047



On 7/24/2026 9:31 AM, Jeff Johnson wrote:
> Both ath11k and ath12k fail to properly sanitize the CSA switch count
> event.
> 
> ---
> Jeff Johnson (2):
>       wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()
>       wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()
> 
>  drivers/net/wireless/ath/ath11k/wmi.c | 21 +++++++++++++++++++--
>  drivers/net/wireless/ath/ath12k/wmi.c | 16 ++++++++++++++++
>  2 files changed, 35 insertions(+), 2 deletions(-)
> ---
> base-commit: 0ceb105245b5e57f803bdc0e79dc077fc06ff384
> change-id: 20260716-ath12k_wmi_process_csa_switch_count_event-cleanup-7fb191b7d7d3
> 
> 

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
