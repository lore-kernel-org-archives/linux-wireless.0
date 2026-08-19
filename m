Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA893CB8E9
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123368; cv=none; b=hyJ7YLKCxjYrd9TVtVGkDbsnB7jpJme78EQ2luldLqdIyqIMiaw7EWoT5DPMu6zm8EMAZ2aLK3Y0UOwxW6anzjgMpL8zwaSFVx0rNdutliq5gNZfwnqZIAIlLXAPPU8Qv5D97J4AgIymfTusfNhuuXK2eg+exducfzyT1Miptmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123368; c=relaxed/simple;
	bh=R5fr17pmWl4KuIayvIb32zG6mAizzcP2Nb3Inzqdtvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ct89uOTimx2RnXDTUy6cT4S3OXnIL2lzIzT0f5/hFasIalCm1zOpLDUh82KOvmaCjIzGc8hgYx3lnZBEAjv/F/2wgEU49J0S1q7FKRpJg5hQ5HSieStx6xXbacwRAvhG4xI08Q9JedFfszSlAxMsAY75w7kGYp40G/sP1X2LgYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=l9u9jB3i; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Gg7AUKAd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="l9u9jB3i";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Gg7AUKAd"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J6ZBYa3691153
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:09:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XNnwH1hGX8rEgkp3J32YIZzjmBJxbYypVuzgelon71E=; b=l9u9jB3i04i6UueJ
	kZGBuiuKogkjSwVpsiOjfU6ukRu+2H1jn59SuuGJ+5h6YX1/5LvNiRrNxxeYH8PO
	5DOYuOl+3JgAw5eIXJhf4uDDq8ka33xv36/7yB1NO8gvNY/S+AhNe2wnwOQwg4Bt
	BYjzfcu92gmJZmS2kgbJXddZSwBUX9XulRVl1DOD7rN0bmG8PqeAiZD9r4sHB5hj
	wWHNCzMvBs6HIXnHgZIPAOWKWOy/imYjoK+Qny/5lspGwX0fr2zwd+6eMi1h9+x+
	GufZazKzJ4Qgu0wLCLxLdOvU2F8uJUGFoObSezwnwH4CZNfpAbRqwHdnZd/OIzQV
	oMDMQQ==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfk9vmh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:09:25 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca6bd8a190cso824944a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 00:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787123365; x=1787728165; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XNnwH1hGX8rEgkp3J32YIZzjmBJxbYypVuzgelon71E=;
        b=Gg7AUKAdPtHuOAZSFggGQ7P4YcttlRT5st52DSPf0dEWNkdP7G2dM1NhvRL62DLHN9
         12eS4EpJhrRgu/FTTxr40OH6VZB6ah1ZAUH2AZLvrVv12E3jo0PeZBax1hkmnbbt4wDZ
         ApNMTKdKi/poVQGT4KahM1Bo7QOSq2NM1N6Hjib4tJt7Js9frMNN2aAt2XuLQNog66VP
         w+MVYwSAdVs9LMMtUClJHpR8TILKnnHzo3XyEbcq9ScWtEmY/dIhygxvJt3Qw7UYMBVG
         ZoIECRqt/tQl3P6Ltl80M9liM9ibeWI8I+kA1GHm8TyYjQ8nm5Te09Wria+qseDAxIwl
         P59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787123365; x=1787728165;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XNnwH1hGX8rEgkp3J32YIZzjmBJxbYypVuzgelon71E=;
        b=EbnnKOlT68quoZV+TNfUUwLLxuTZ1V3tOYyqywyipYKirUYb0io9ME0HCEopKrDRsF
         WK0ca0sPq+kRwKb4p+qKdF7MTSteQ9Jf7MSY+YP9r17MA60tfKSOrVgkNtRMeMdkNPlp
         r6Eqzazf9i0oeXH/lmJve+I5Bfe/nsJUVWWPxMA9a1WRR58eAdUyHz6f7PIvCIFeUhfb
         k3FGQEwKjGjofyLmC8qMU10UV1PPdQurabkWKAaumq6pUqQCsRSnURQNHRvB9t0M4csu
         pDR+i1QEQ8Garg+d25MM4vkY2B2TKFZA2p0lhUKJxSw8m9Trfleh+H8dMcRYPHw4q76o
         QxHQ==
X-Gm-Message-State: AOJu0YyojKqZiPXHYvy/6+LtKlzltcLpLnj0/NpisT8Rdx3vSk2WhREe
	E/k7Bse7Ch1kZl8djng95TcQMlO9FKTSpcgpq7LNJI8k88DipHEEGO3d/BPWLYhxFRwOUz85cRq
	mhQvOJduTthnoq6KU6VtOLBwsxyxeRAhtKwg+tDxFHcNWU7WsFlBW7fS8Lx4v87AZPurtwg==
X-Gm-Gg: AR+sD121hMWyRGj5iWhIPtBbNiqzxFzOtyP59qGGTvypuuRO9B9XztC4tfHxJuoNX0I
	NVMHASbb5VX1a+PRyf7DbAyNCY5TG8+mi1GKMX+9/tZZX6RpQXLmLzNcSfuIzkniRHtXkZHU/Ek
	47u25soRpYIbO5oCwvl8TsOXeMBMRhzMhwqaOsyqIv5/tBGxEu8nPZ4qd3/gH5nEtapyuV6ZFOQ
	se6no5BA0YVwFOiVCjgVakodrkLkEETBQSyRvp/djBvqLOctpGevXQ8b95FKnn6ja2J17TSpdRJ
	2ZppCfIRAmPy4E3mFiJJ6Pb5lDc9l9eAIv6NKYvRBXL5YRh8Lgm44QscAoenq6Xsgizy4Uwflqy
	3ujNq6ea07MTYjbp6e7dU37ZH4QSol3JikNOXGn/1
X-Received: by 2002:a05:6a21:e8c:b0:398:7ed3:a001 with SMTP id adf61e73a8af0-3cd00db9bf9mr5658494637.2.1787123364761;
        Wed, 19 Aug 2026 00:09:24 -0700 (PDT)
X-Received: by 2002:a05:6a21:e8c:b0:398:7ed3:a001 with SMTP id adf61e73a8af0-3cd00db9bf9mr5658423637.2.1787123364343;
        Wed, 19 Aug 2026 00:09:24 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bf1970e4sm3692560eec.30.2026.08.19.00.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 00:09:24 -0700 (PDT)
Message-ID: <65b0de31-7bce-4ef7-af43-7f298d867bc9@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 12:39:20 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/3] wifi: ath12k: align QMI memory to 64 KB
 boundary
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260730-ath12k-align-qmi-memory-v1-0-0fef98dda614@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730-ath12k-align-qmi-memory-v1-0-0fef98dda614@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: w7xZ0YWUiNKFytBhbIwk2e-hxvkoCFTb
X-Proofpoint-ORIG-GUID: w7xZ0YWUiNKFytBhbIwk2e-hxvkoCFTb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA1MiBTYWx0ZWRfX1Dwi657wfPWk
 WBxnPg4ZWFo9FZbU6pNvp5jXvHu9khrZkP7myiV7UIKAOeZ4JoZBe9+HBhWQq7dEeN4bS77OUNE
 e0UGAlIZayORqccbbpdj5+bBtSGzVUjZerbfHcBtd/rdsZGrabmggmCd5XzhRX3ytmaP+hSg1//
 QgRjo/5pO85HI/l3b0LZHHUxE9c8tw+QzRCCk/zjDC7zmM6Iz7SUz3qeBRgM+KP0vvaeyK2zzSq
 wxVgXrvTaLX3ApXzUq6lbdHBUAAuUOoSbEo1Lh4te1mIg5RK2IAAbAbeSkK45ODCWf8bONspEIg
 m8MzI/q128Tx/7BsNjeQMcQIlLQSgfg8ZSw0WzS8kK4GlDwuwelwffO4W/Lwg9uHiaxNxyx1yLb
 ExbhKzpNE8yIx3+LM1cqaIMRjypJknxxqUgiJUmO8fM2xvGdclxD/OKbCA0XLuCjOh3YhHD/m1r
 qDc4712yAjTP/we2zXA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA1MiBTYWx0ZWRfX6+28wRGmLAHq
 IRSlENKdGwUoNxHmQjbt+K0yxoufYwd6Dy1GcM+qCrDnsLLbu5/KHtpebZBjXIokr31VVk9G8rN
 4C3E41a4GaSAK5RiUTX8vYAj3PvGySI=
X-Authority-Analysis: v=2.4 cv=fvfsol4f c=1 sm=1 tr=0 ts=6a8556a5 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=Cs6eFApatLD2xG4hVi0A:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190052

On 7/30/2026 11:47 AM, Baochen Qiang wrote:
> Firmware requests the QMI memory to be 64 KB aligned, or crash
> may happen. Fix it by manually aligning to that boundary.
> 
> ---
> Baochen Qiang (3):
>        wifi: ath12k: use per-device max QMI chunk size
>        wifi: ath12k: clear chunk paddr and size in ath12k_qmi_free_target_mem_chunk()
>        wifi: ath12k: align QMI target memory to 64 KB
> 
>   drivers/net/wireless/ath/ath12k/hw.h       |   1 +
>   drivers/net/wireless/ath/ath12k/qmi.c      | 102 +++++++++++++++++++++--------
>   drivers/net/wireless/ath/ath12k/qmi.h      |   4 ++
>   drivers/net/wireless/ath/ath12k/wifi7/hw.c |   7 ++
>   4 files changed, 87 insertions(+), 27 deletions(-)
> ---
> base-commit: 4fa10e991f77b4c929d1959900a6ed422b9e2ac5
> change-id: 20260710-ath12k-align-qmi-memory-a7c87d626ef4
> 

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
