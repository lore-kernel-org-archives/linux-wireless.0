Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB66492E34
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 03:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788925529; cv=none; b=InFen3RN/yJswXTxfq2akRyVXxjsD6JfT3dSdD9iXY5kp2+LnKmmBARZlixWn5qVWU9kyIgBmX9RUkMyVCYR9ujWiW06JnaYyIwDdTDpYs44LlB+BUWZYu6LfmG4LcAw14z3+TYN/Fl+zLTgbdh9bNHb15oihCiPsdRb4HIVPlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788925529; c=relaxed/simple;
	bh=Krqc63OwEFzBdIxrvaZ2UhIOgbaqVF4TBrugP8v03N0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aqPgA8tolgMVnfemkvjYIBDdGgxGKmG0GXNfG3HtgDd6qcp9aX2KZkDa5Ih2IjUFe0rPZBUHl2nIMM4v446qM3DuPyynv7GKAALStaU9WmHz3e+d9LDmlQIofpZJhZ3BcJc1iykizOpxcnBwrQ+Y6wj38ojEzGAccZazmVzOtWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JdWM7vxZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Yw+5wVDq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JdWM7vxZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Yw+5wVDq"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688MgE03129712
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 03:45:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jtVRqrPF+O3AyewW8EHJ1UpFlY7nySOnDXChI0Lp3ls=; b=JdWM7vxZG/GZcbcV
	Xltz9NboCqsGh8E1O3uqD5d9wmcS13mOy7IzZ10aKF+06XmQ8B3upomEN5LRxp8n
	q8oje76v2/DHmGCtRyG9WiXYw7BHzbq4GkrT/jDl8+gq1KVxh+idartutSx8r2w7
	3NK4Ob/A8vY+BGhdh9PzPp7nAjpR7BlJ3xdTRGWIX06aCh6NZ8/FyvtTP48n3Olp
	Ypvi3Dpp0r3Vtq7crc86fd1i5nPjj6Vm4am72uPzKsGwcvImEWum8cyEV21HXzda
	XqeNGnLWznZUUrkoOutFj5G5Wqdm3RFB4QW6nWVxUPtnZfbFT1GIkMipYe2eySqn
	5wM6cw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjntpjgft-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 03:45:26 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f57e31b6eso2081768a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 20:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788925526; x=1789530326; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jtVRqrPF+O3AyewW8EHJ1UpFlY7nySOnDXChI0Lp3ls=;
        b=Yw+5wVDqQEPHGLDPB1P98N/RawOZzRFV1v6/CS3q37VRcyLbJ6r66dWQXlbevz/qBl
         vBwnwE9BPRYeaXpThbgePOffpSpC2c+7LSrxGELYKlnD2Mw7DMclMkrT84YI/8eO9uAW
         kUboNEIVv1jqfjpR5sN3QQcgP8X/JvYkPB4vQRAGkhzZvGO194A3jLkC4Cn+TI45pT4q
         dnsa6Q9V4iICAyQsyrm5YwijHHRKSnKSo+frImgXj2tAKKW0BXzoVRJzNK+HmUAjskBj
         lufRs5KCE9SpRIrRSCEVe/R+gHjCk9VXJkBCUaXtoowEMHUikc5g151FM3cMTT6XoqB2
         9pBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788925526; x=1789530326;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jtVRqrPF+O3AyewW8EHJ1UpFlY7nySOnDXChI0Lp3ls=;
        b=GLFYwl4TuvGJMKg3dmjkl/T7bYw2p6k+hkwA4iC0cR2AAUxeiDdWhR2jU89OReieEz
         m/vHsWsIYIEggLdFEfD7k4GG9f2D1cdwDd/pasf9MO/DPoE2msoiWFr6ukcL8kNNXGwU
         Ag2viDq7vNSubK8JTdDBpQcZhunEiVpbXaaLwizDFq7tPvi+n6dIS+IF2wBOJGQHO1Ac
         4fizQ08j8jRQxnCd3Lb9x+rZFMruUe0doB1dIu4X5bOLCRJDNG82IKasIJmJNCsGUSty
         DtLeklyPDvvQF7Tzx5gI0rtw5tVF7ydHfo+Z7v1hIdOSrdXU1AWzfxxuyhsEATv3kjrH
         nRRg==
X-Gm-Message-State: AFuF++nRHsx8f0mbmImgad8ezRDOiqmAmEzVSeylHwqxuYvQtcVcP0vO
	sjhBE8h+5afCnHsxdDuS6bHlTGhugd5GW/T4/9LHq9UYAe/Aw19tZ3twWLnQVU1w5FQCGXkTQHr
	HqQX3ceNtuh7cwXuVNfWQ7dkM55h4RLaP78JuH3fRMNMc882vdTQ1ZyQw2YpAqeJXX644We8xsQ
	LOkw==
X-Gm-Gg: AYBFou0DMvY6JawuWMMCAYM0TBr0eCl9SxBJE6VRifv2MtGE2wMjNTYCNr0rA4DIQf3
	60TFHxKxG5iifp0cb6vXaF0PSTNGdm+XXN8MD66Z4WWfJhkg0/wAZvTa4I6LHakzRllrhTbP+Ee
	4iYe9o1ntmdbPJdcqYXQC/wFmJnR/h3lwfdwV7idijfdHh48//6mwhcvuL8WVcB59fI3Uh2mVvV
	oOSRVKkAZj8ie3msYOT1KMM9+B4W/CyOaDC2K9Y9cn01LVT6Wbde+7kkPYh1yFmW0sH+1gh8IX5
	YY2Ae2SECw/PG8uh/nEwlwoHMuu8q4Zq732ZbyDuwsJTpHEpmGD1/M69c6NSrsHxpDDhZljPvEB
	ielfqSEldOR+idMte7cHwqWLqshcjpPK9AH2g4ZiW9LJzgspgO0Ix8pmxWIY=
X-Received: by 2002:a17:90b:4c44:b0:38e:97f0:aa4b with SMTP id 98e67ed59e1d1-39b261cdb38mr46502131a91.13.1788925525947;
        Tue, 08 Sep 2026 20:45:25 -0700 (PDT)
X-Received: by 2002:a17:90b:4c44:b0:38e:97f0:aa4b with SMTP id 98e67ed59e1d1-39b261cdb38mr46502050a91.13.1788925525387;
        Tue, 08 Sep 2026 20:45:25 -0700 (PDT)
Received: from [10.133.33.87] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c397b1sm34969205a91.8.2026.09.08.20.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 20:45:25 -0700 (PDT)
Message-ID: <aba5d600-0d8d-44ca-9367-7cdc145e9732@oss.qualcomm.com>
Date: Wed, 9 Sep 2026 11:45:22 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: fix stale skb pointers after
 aligned TX payload shift
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260818-ath12k-uaf-for-aligned-tx-v1-1-d6ae195b15e7@oss.qualcomm.com>
 <4ed6651c-b1d2-458d-a210-5cc72954b48e@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <4ed6651c-b1d2-458d-a210-5cc72954b48e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDAzOSBTYWx0ZWRfXyKVmlIpupInG
 BHFaVA1P2gCKYL/SgM1boyT7MfZd6qWJMZ8N5ECpdPqqAGZxdq14CiJteB+MOyC9Vsa0At3hGtB
 yyWMAt/yfIJrKklCL/FtMBe6QwNT/CO2VSHtLWj8gXhRsR3Si6Jo5KGjY8t1cGWVc41VKmFgD44
 yEjCU+vxmdIIAOy3NlJwxx1W/NIgLLUhii31uR46Arq55vUZGztHz9J4txiGgwwF5SqJf5nfLRF
 pfAQfBFj+QPGcqQBVkMoapzoJtHeNrxWeXULnkc7XC71GjdYB41Fq/vppe0SddIB+EwLhG9f+2f
 Wk5p444hpAUQ2x5sjHpq4aRKTyoG1BeH3fP24C0yvMj0Es5Tv9nZ+Xa0b4B1Ibbnvrz7DNpsr2O
 ehzFil7efPOwTKOpay+dfTKf0HEgrGWfApzmCvFeq6LsLBBiSEH0PeJmPIlp/lB3wWyhShMnl4Q
 mZR+kAaEKVuj7+aZf3g==
X-Authority-Analysis: v=2.4 cv=N+AZ0W9B c=1 sm=1 tr=0 ts=6aa0d656 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=J9Uu1coqdBZi-UK5pMMA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: giSHQ2JnZ2X4Na13K68Rt5fWPAKN7ADb
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDAzOSBTYWx0ZWRfX4lbot5XOcrQ3
 6z6xMOrPg+4uz5WurdCuxxtDfVqYaeKZ+EfgTyiVlElKEMlAirwpopJgGfiJEPJ86Yc/MW9p4sw
 t7gY03VYHWq0rBm+9MMw1PCTtk1GGRM=
X-Proofpoint-GUID: giSHQ2JnZ2X4Na13K68Rt5fWPAKN7ADb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609090039



On 9/9/2026 4:55 AM, Jeff Johnson wrote:
> On 8/17/2026 6:44 PM, Baochen Qiang wrote:
>> ath12k_wifi7_dp_tx() caches hdr, eth, and skb_cb from the skb before
>> calling ath12k_dp_tx_align_payload(). That function may shift skb->data
>> in place (when headroom or tailroom is sufficient) or reallocate the
>> buffer entirely via skb_realloc_headroom(), freeing the original skb.
>> In either case hdr, eth, and skb_cb are left pointing into stale memory.
>>
>> After alignment, only hdr is refreshed, leaving eth and skb_cb stale.
>> skb_cb is written immediately after (storing DMA addresses), and eth is
>> re-read on every TCL ring retry via the tcl_ring_sel goto, so both
>> accesses are use-after-free or stale-pointer bugs depending on which
>> alignment path was taken.
>>
>> Refresh eth (conditionally, to preserve the encap-mode distinction) and
>> skb_cb alongside hdr after ath12k_dp_tx_align_payload() returns, so all
>> three point into the live skb for all subsequent accesses.
>>
>> Issue found during code review, compile tested only.
>>
>> Fixes: 38055789d151 ("wifi: ath12k: use 128 bytes aligned iova in transmit path for WCN7850")
>> Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
>> index d2749de44553..6b8430260238 100644
>> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
>> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
>> @@ -251,10 +251,15 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
>>  			goto map;
>>  		}
>>  
>> -		/* hdr is pointing to a wrong place after alignment,
>> -		 * so refresh it for later use.
>> +		/*
>> +		 * The payload may have been shifted or even the entire buffer may have
>> +		 * been reallocated for alignment. In that case, hdr, eth and skb_cb
>> +		 * are stale pointers. Refresh them now for later dereference.
>>  		 */
>>  		hdr = (void *)skb->data;
>> +		if (eth)
>> +			eth = (struct ethhdr *)skb->data;
>> +		skb_cb = ATH12K_SKB_CB(skb);
> 
> My review agent notes there is an additional issue possible if alignment
> causes a new skb to be allocated. If there are any error returns beyond this
> point then the caller will double free the original skb instead of freeing the
> new skb. this is because the caller doesn't know the original skb was replaced.

Yeah, indeed the issue is true. I guess we need to pass &skb instead to
ath12k_wifi7_dp_tx() and replace it with the new one.

> 
> So I'm taking this patch as-is since it fixes issues when the buffer is
> shifted, but we need an additional fix to correctly handle when the original
> skb is freed and there is a subsequent error return.

agree, it is a different issue hence deserves a separate patch. Do you want me to submit
it or you will do it yourself?

> 
>>  	}
>>  map:
>>  	ti.paddr = dma_map_single(dp->dev, skb->data, skb->len, DMA_TO_DEVICE);
>>
>> ---
>> base-commit: 4fa10e991f77b4c929d1959900a6ed422b9e2ac5
>> change-id: 20260811-ath12k-uaf-for-aligned-tx-a068d34b1548
>>
>> Best regards,
> 

