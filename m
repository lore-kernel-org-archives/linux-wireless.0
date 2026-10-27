Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793125772;
	b=efjlm7bAKgY0ZgKZVKPFM1K5CHiBF/FypXQ5Y2zo9YYDQdGorstz/Ygfi2rTV6AYb0BY
	 +k0ayujMzFe18KQWAwAtpEanx5aWWOBgZs3+ueu1SgJv9eEUwEwyvKveaVlvfwnIXwGhm
	 CwlPI8cqBAJmd7o0A1lNxReYX4qhwuK2OdocsWRk2gjl8O/2BC+43/OBevPBXnyExm9Ol
	 ByT7fUxs1hWPGI0uit05jE+/zl2h30w1Sd9+gjmapRIiWqdwhZSBYL3sTtdqAx90TY1Ag
	 qBdGnBuofvgOe44tmwxWhMj4UZ28C20UvuWI3f/SnCYT6SxDHBPUb5ty6GbZRY0hVEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793125772;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=PqLkIufQPtFaogpRWn+QjK4zZ4JekDLRMB+hfurWJXI=;
	b=yrHsT2XX41VUfleSYpb+2DjlKh9BlRPIwiNywn07d9HYqMfrV66dA/kqm+UkEUQI8m6Y
	 b5mITrbmOrKVv0blLSdEHU7T/P1DCI0blTIDWSkYmAhNO8O32g81Bm5trYDgfWpqhp32m
	 rhIOYd6m5T6PuyAZKLmLPd6pAKXoxQcP2kEv4OtUJst66bUv31VNIF8zf+m0dIhB9gTSE
	 djBqu58HqmslTbX1ht+Eah9M1rw/F+iYvZ2tdjTRSjWttb+vHlS848vVYmUo/GusJ5f48
	 Y9tkEg2u4+MkPfTCDuyqpT2sq7Sqi54RVbL2AOkqxsjL/NCRO0c/Ulre63xLwNTMBpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Pum+jOci;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hVxStZ9+;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77676606A31D
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:29:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77676606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Pum+jOci;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hVxStZ9+
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69RIIDon3486476
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PqLkIufQPtFaogpRWn+QjK4zZ4JekDLRMB+hfurWJXI=; b=Pum+jOciu3R7fVsS
	4TJb0W5bYs2wH/pLEU35a3fE+qbDbQA7SZl/Z994Vxl8D2bTWeBAp/asbvF0Banl
	PU7jj2rfOtXHTDanQSXPCS55pr4QpCPOz1LXiUNLB4H8sglmAL4UtawS9bxYdPpA
	Q/QOJQnDSMcQ4+MtWaFbtC70vPQgK+CmTUU9GneelIwWUFf3HGBKpXeBFoGgg8WF
	LTQs+0rILYZIWpvaqwNNzuUkie1zWJFVwkz9MJ6wGwdTKSDmUZC5Vd1ACAt34Nq5
	s0GLyBVJDgqkArrIe8ok4Cl4/63daDdiPSvfQLpyf0elRyqLVKziduVqMZdxHyKs
	Lejutw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjjbtbv1e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:29:30 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36a1e2485fdso295039eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 11:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793125769; x=1793730569; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PqLkIufQPtFaogpRWn+QjK4zZ4JekDLRMB+hfurWJXI=;
        b=hVxStZ9+Np1rIJ4GsIAnPb4fAp97FgRbeaAJjQ3SS3PKU1r61Djt/OXgXJuCWHyJBQ
         oF6BJMmV+BKe6cKF+WL+Pq0eQdVK5JRO/je/STcAC5gtNDWQ8ZPChr28HtreCLHZiAU6
         9sscLYjR7XEU5EQ8FojKIHEElvIwfVWJsFbo7ibA+j/G/V/DwRUg6M9PL8UZdWGkrUtF
         WYrKmpvFBpcXp8c+8alkSM9GMvdv2T4hxQBl++LnTT7D6tfFL1ydjslNDS/7VYhvVFQJ
         7xy/fQmO8n3jsugRGyho8CpMYyKzLbvAiqEoq9MWjTIdzZnuNZCuDKEbSy86J1HM0nsg
         vhPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793125769; x=1793730569;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PqLkIufQPtFaogpRWn+QjK4zZ4JekDLRMB+hfurWJXI=;
        b=LLPwZsaH5QRM/jgC+tMvzlXimjUKoftV6xtTCHu4PXnJNShXzBWmNfKHuWYDd0lmtW
         FxoiZQmcyxvuJupU5xUHfnPzn1cH2bHUVNFQmmAYDQ5EG/Ua22Wseen6s1wVC51NIxJd
         HqAC74A2ySW6jJIRUmMi5ooHZdGF3NiC9MxHtXwH2zPRSPleoyTtT/BgR9dh9RpYfw3I
         TqYvqkH+QdtYYTSERQBTJhXlR9qSIYNPBflV4qGX0itxDqCgV3jhteBZBuYl/KbZ2MAI
         Je407TQ+No0sL5niUtdg1xIlEXb9Xsq0Sgm/zc1OnHid2gLGjimmKka2J55vYvyEInzb
         xHKw==
X-Gm-Message-State: AFq9FYKrNpj7kCrQ5N0uH4hF14PZEQdQTtjPHgdqSYyzqT4A+9+dOAeB
	jr+/VCF4jrzkUG8OU9JB/0BpRWp175iS1AagU1GSIyN28CyiRuuWk/bolq7oGF2O0R1XHNemt6h
	SPk70exZG/um2GOowofpyqxYgOgRpi0dH94tf3hpF1J5LW35TJ1YxNdqhkmVcHHq1InLCgw==
X-Gm-Gg: AYBFou1PZXOaEdGp2x0kZF6hYqPsO5JYUtjh9W5m+uHpJoD58Ko99Ti5xnjINW1rrmX
	Brw4qXCCZpWxREy81x7W+5e3UYUlxQos0FusDJ8JoGEh1viNalfJaD6B5sKqzdn+cPHovc5GYhR
	HMF8jFUJJSfhKrdWnCfbPZ+HBVAGq4JmUfL+MUNbSARNwbUgvhw53r66QSYP/nAZLFSgy/KquUD
	2NvEkfli/Fj9+YmrGxs139P6gzBXEInGp+po44k4vYtrJO8qxGCW4udNAgGE672BjgSTm8eZ8QM
	/eCsndChF6WP9UzU6Zx8pTNlFpBVmlg/PgcKCkyhGKcE5T8GNYswRmAXTBwLCDZle0gZc1OM5DY
	sz/kw6REL2LRJJL9qdmVse7tOWETlMcZvG1tewdl/OsPtGJb+Fkmm3Jl8yQ==
X-Received: by 2002:a05:7300:fb0e:b0:367:68c:860d with SMTP id 5a478bee46e88-36a203fda47mr326469eec.29.1793125768838;
        Tue, 27 Oct 2026 11:29:28 -0700 (PDT)
X-Received: by 2002:a05:7300:fb0e:b0:367:68c:860d with SMTP id 5a478bee46e88-36a203fda47mr326430eec.29.1793125768171;
        Tue, 27 Oct 2026 11:29:28 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d845ddsm35584312eec.11.2026.10.27.11.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 11:29:27 -0700 (PDT)
Message-ID: <d3f34291-bed2-4ddd-af2f-fd994a2d409f@oss.qualcomm.com>
Date: Tue, 27 Oct 2026 11:29:26 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: fix IRQ disable imbalance in AHB
 ext interrupt handler
To: Karthikeyan Periyasamy <karthikeyan.periyasamy@oss.qualcomm.com>,
        P Praneesh <praneesh.p@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20261015084445.3045925-1-praneesh.p@oss.qualcomm.com>
 <5e64ab52-c8b3-4b42-81b1-dea844bea6d9@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <5e64ab52-c8b3-4b42-81b1-dea844bea6d9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA3MiBTYWx0ZWRfXwr6avP/yP425
 zSUifZrm9QaS4QJoSM4+QhUEj1+a9Wovrq+cfl3tXhy/mAynWLrdGzuoM173GuUp2KHQH2KTfXU
 /QXeNLRLuaPV5ftNs/VuEF4ZnRP+aqU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA3MiBTYWx0ZWRfX1kF25JFeTviM
 zxOQX9C+94KOPym5XBO6L3XzamwUAH4/VXpbh6aX8g/gQz2bjguuodMKsgnFOoSP0cxB7gONXUV
 r+Sc7k0wqFojXPi7p+SksrJ/Dy/WK9aqem1E0YgFN2cR2+aKmB2gTIFEYRB+DloxiXW7rsASLoX
 sMHq3nhWLwvlNXp15Q7XzwvywS9kA8RlG7qg/QH0VvB4c7gjQu6ihQKug907C/F8ggZNAABVKpD
 WfSdrJsOkVMlHg1Yw4loEPn+2va3WqXFzpvnzxWHJVhu5eokTy/y69U1JX8HpOa3pcuIHdW5rsR
 JHBIJd3+YdjId6IcU2dmAKaZ5BBDh635mEgboh5XteHwl+GR3wsN+TZ7ObQMHpdop8v0QJeW0jy
 vQ5/ivdQgET2T4ksuu1UOrI6vk+UpU5a0fviTnNQMV3PHtVbnaIJVZUC/ryA2iQOJSirxT9g9qB
 cM2Se4neT+mBjZT1c4w==
X-Proofpoint-ORIG-GUID: mWyapdlnTOP8WV8slMDOVCjTwgEcZjXv
X-Proofpoint-GUID: mWyapdlnTOP8WV8slMDOVCjTwgEcZjXv
X-Authority-Analysis: v=2.4 cv=XaIcX455 c=1 sm=1 tr=0 ts=6ae0ed8a cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=yjVnOKY9XYp-XMnnHIcA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610270072

On 10/20/2026 10:07 PM, Karthikeyan Periyasamy wrote:
> 
> 
> On 10/15/2026 2:14 PM, P Praneesh wrote:
>> On AHB platforms such as IPQ5332, IRQ group 3 maps multiple hardware
>> rings to a single NAPI instance. Each ring is assigned its own IRQ
>> line, but all IRQs in the group share one napi struct and one poll
>> function.
>>
>> When two IRQs from the same group fire simultaneously on different
>> CPUs, both handlers call ath12k_ahb_ext_grp_disable(), which invokes
>> disable_irq_nosync() for every IRQ in the group. This increments the
>> interrupt controller's disable reference count for each IRQ twice. The
>> single NAPI poll that runs calls ath12k_ahb_ext_grp_enable() once,
>> decrementing each count from 2 to 1. Because the count never reaches 0,
>> all IRQs in the group remain permanently masked by the interrupt
>> controller.
>>
>> With no further interrupts, TX completions stop being reaped from the
>> WBM release ring. The pending TX descriptor count grows until the WBM
>> idle link descriptor pool is exhausted. Once full, TX ring allocation
>> fails and no new packets including management frames can be enqueued.
>> This causes stations to disassociate with reason 34 (DISASSOC_LOW_ACK)
>> and ath12k_mac_flush() to time out:
>> "failed to flush transmit queue, data pkts req N pending N"
>> where N equals ATH12K_NUM_POOL_TX_DESC(ab).
>>
>> Fix this by using napi_schedule_prep() to atomically test-and-set
>> NAPI_STATE_SCHED before disabling IRQs. Only the first CPU to win the
>> atomic operation disables the group and calls __napi_schedule(). Any
>> concurrent handler that loses the race skips the disable entirely,
>> keeping the reference count balanced. Guard the enable_irq() call in
>> the poll routine with the return value of napi_complete_done() to
>> prevent an unbalanced enable if the NAPI instance was re-scheduled
>> before the poll completed.
>>
>> Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.7-00587-QCAHKSWPL_SILICONZ-1
>>
>> Fixes: 6cee30f0da75 ("wifi: ath12k: add AHB driver support for IPQ5332")
>> Signed-off-by: P Praneesh <praneesh.p@oss.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath12k/ahb.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
>> index 2c55aae06dd0..e5bbfca2b2ac 100644
>> --- a/drivers/net/wireless/ath/ath12k/ahb.c
>> +++ b/drivers/net/wireless/ath/ath12k/ahb.c
>> @@ -602,8 +602,8 @@ static int ath12k_ahb_ext_grp_napi_poll(struct napi_struct *napi, int budget)
>>   
>>   	work_done = ath12k_dp_service_srng(dp, irq_grp, budget);
>>   	if (work_done < budget) {
>> -		napi_complete_done(napi, work_done);
>> -		ath12k_ahb_ext_grp_enable(irq_grp);
>> +		if (likely(napi_complete_done(napi, work_done)))
>> +			ath12k_ahb_ext_grp_enable(irq_grp);
>>   	}
>>   
>>   	if (work_done > budget)
>> @@ -619,9 +619,10 @@ static irqreturn_t ath12k_ahb_ext_interrupt_handler(int irq, void *arg)
>>   	/* last interrupt received for this group */
>>   	irq_grp->timestamp = jiffies;
>>   
>> -	ath12k_ahb_ext_grp_disable(irq_grp);
>> -
>> -	napi_schedule(&irq_grp->napi);
>> +	if (napi_schedule_prep(&irq_grp->napi)) {
>> +		ath12k_ahb_ext_grp_disable(irq_grp);
>> +		__napi_schedule(&irq_grp->napi);
>> +	}
>>   
>>   	return IRQ_HANDLED;
>>   }
>>
>> base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
> 
> Reviewed-by: Karthikeyan Periyasamy 
> <karthikeyan.periyasamy@oss.qualcomm.com>
> 
I think you meant...
Reviewed-by: Karthikeyan Periyasamy <karthikeyan.periyasamy@oss.qualcomm.com>

by posting that my tooling will now pick it up.

/jeff


