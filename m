Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612A8381B1A
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 02:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786415098; cv=none; b=XM4iiIeKhf2lSzsMWgFXrCTcBi4NdjQkD2NqNi9EOtXTuu7ggqduz6YiIMdavijBB5Csv/z5wRSKL+XP7j7nYGQoH95etShyG0IVLkcaLY+S2qdk/xzEPTaB2RW1Ca44ULhOegdrQfvSQzc5aLArniGEbiKlL44H6qE1wNmSq58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786415098; c=relaxed/simple;
	bh=acyPGfylUMzsKpzfgGBSv02dZSe8KVU49lqM2DmPcqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oj8rZqA3knTJf41pDTjM0H3dyksic+HOy1U6KlNzu7gHnE01P/YWqQuHOxWc+rdyXHvz7NWBlHQtSX/2liYalbNwrwWmHhbQjvlJpwdc+Ic6sMoC3WtAufdisfqfWhtKI0Bhu7QtNnb7Ws6EEOjYY51T0O9kfp/G0m8Q1PeRqOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ejlp7fo2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZWs6ulxj; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ejlp7fo2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZWs6ulxj"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AMpiAs4156735
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 02:24:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YXcNHLM8qGDWKTk4CUAODcEzd7LuZQzNNK3A3gJgByw=; b=ejlp7fo2heYmwlTO
	BhG7C+41Q1Whx29+t2+ZTyZ+/fVopS5KuK3sZgjkRDRnVzfX+hxlOphOvX1AUj4L
	Uxme4uQK5man0jm1MfP/WdXxc5n1eQJfGlfzgqbCyXLkmE0HnzHFo9Sq3KESm3tO
	cqDfhu9K9xNbvVRXmah4NyG7UG6Yy+Nbo9egECDSb7iArIjK+1ywKRELWluJmByX
	NyC57vRO3Wov8oacVninuFMoVcdDeRxNRVsMbV38OvjWnIVi1ZP4SxbIHP3Qlzj8
	weKxrEP7cwURQVH8BTn99UvZyNLLHuuXLMZzmgVs01ULxNC8TmYeX3y5rjxrmAoL
	cxoo+Q==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fyhp8jatj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 02:24:52 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e7b87ce77so6378234a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 19:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786415092; x=1787019892; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YXcNHLM8qGDWKTk4CUAODcEzd7LuZQzNNK3A3gJgByw=;
        b=ZWs6ulxjfcRe8aTwNUXZeS291EtIgFmMA/4m+bxGcNXsynEZ8Gl06MtO/MiFtmD8Z9
         GsLlkCRkUMyO1f/9auqW1lU8s/HggVTXM2TJSXQ1bFisOvxrgb3SSKbJ9KYNTEWMFmRn
         PMRouZXsrM1t823L3HUnSskejkNGYnDetiT54skidq+UmdtV4rtgwfYY4VV8xDUh5rYM
         7S3GzPrQCorZR/zQCeoKPo5p5l/3QkEMaifRRRqzwVsvnoOYL91MGriylsaFhqXh6S0l
         B2jWyB0SC9kiRm+u7R1w/avbeAr8XFp15Pjz/se2FrzhhoxZmCZMr07VTNz510a4M5QN
         5zyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786415092; x=1787019892;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YXcNHLM8qGDWKTk4CUAODcEzd7LuZQzNNK3A3gJgByw=;
        b=nr0V7oBenaUKAXpr0B/qSiE8XpiENroOfNxhaXPakDZCDdubPtblh52YClQtVHrP3D
         P6depleb8Yd4uGwT9zZ8OBFRQqKHTPbAw0DKArnk2yXNQsJxnczsnO48B+QZ+p0qmUmW
         KqOekJ0IBUDEWRygol7LlcFxrdbgHZcTIjBtJuhZQBoJypMvbSOmFcb2YS0LDq/zTZsP
         CQ1JEO5OH+JLsIySfOzwPJPw/lfSuBNgDYCp35sNtRIs3FIkdRjtyhy00i1FYA2JqYhK
         IzEecGvLqPGJPZdC0soj+xgpQUQNZ854Jcq+GwAFiiWBlUS/Iak/4djmgatRyPWk/z/j
         BlBw==
X-Forwarded-Encrypted: i=1; AHgh+RoOrA5vkNDvCED0ATtbrRkLk7aVik0WI7yOVmDWfbvnfgajtodlPHOWcNCMWs6wxsCp9TzdJ226wmSzMl1WPA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWAk7EvoZS2BmUsUjj9fL6zmHG2WnZ3U4o+0mp1MTxWNc3vTfs
	a0oGYlgaQdYuMDzn/TTIEsmZuW200VIv9ROTmj1sgRjYRvbDFJE1U1qMUuyKTIPY6EguMN69bP/
	k/9a5h8ETwxxxmBU9a7SBFuOHVK6Sf/Kljcl9QvZ7vcCuBAcmJV9Iq4Q030VGOFovU7d+7A==
X-Gm-Gg: AR+sD12mDMtXp2EJv0fa3E8kGpvU30zTGkx9YpnS13dnOq4jQvOuvvOw3bvQGkIBnKm
	wltI6+3yFmEhrSUinOA4HJ021ErB6D5FpPN5VnfYEDFEUlymLONPgxL1pagtj+gQEit/2wG5tjk
	3eHi6eT2r4saGdVAjliPyQadFfPx0NKEP8DiWTUfG4NsYAXJcqbZ7SUmcfyWUHhttmH/2C/k82d
	6RfLzllGmpeBLghd0PmkhXIhOnS1q0Y0OizVAWDY568HGuDKEJKYd1ulMWfL5jTtzxUPWsWfgVA
	EtVH8WN9PxGkDZLJ0fg24fhnap2XWg7tQhbLeI5EY+iAu2GheovowszwN9KEVxiLTEJe3depqw9
	Z8E6RUTLYBTnHZerGb3h/wSWhDu7wZ3+fgGKqZP0AaWJAsxXfRXkw1l7Pwbc6Xqo23Q+Um3O9
X-Received: by 2002:a17:90b:288d:b0:38f:26c7:165e with SMTP id 98e67ed59e1d1-39261ff3945mr33151665a91.9.1786415091785;
        Mon, 10 Aug 2026 19:24:51 -0700 (PDT)
X-Received: by 2002:a17:90b:288d:b0:38f:26c7:165e with SMTP id 98e67ed59e1d1-39261ff3945mr33151621a91.9.1786415091338;
        Mon, 10 Aug 2026 19:24:51 -0700 (PDT)
Received: from [10.133.33.43] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392d5195a4dsm1613157a91.4.2026.08.10.19.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 19:24:50 -0700 (PDT)
Message-ID: <802e92d2-b1be-4a0d-bb3c-93b9e510c9d5@oss.qualcomm.com>
Date: Tue, 11 Aug 2026 10:24:46 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ath11k: modify null check logic in
 ath11k_ce_rx_post_pipe()
To: Mikhail Lobanov <m.lobanov@rosalinux.ru>, Kalle Valo <kvalo@kernel.org>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Govindaraj Saminathan <quic_gsamin@quicinc.com>,
        Miles Hu <milehu@codeaurora.org>,
        Sven Eckelmann <seckelmann@datto.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        John Crispin
 <john@phrozen.org>, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
References: <20240909150824.28195-1-m.lobanov@rosalinux.ru>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20240909150824.28195-1-m.lobanov@rosalinux.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDAxNyBTYWx0ZWRfX4uSm2n3w3QW7
 SQMm9eKhLuGCdXi0zCkLMEpb4PfeW4+bnfD+NjNY0qoWc5vMSfaaNYIOm6IQRz8bJOWmITAHwLN
 trklUePtGPkzoYM0JLBEnsWHfQqWlqc=
X-Proofpoint-GUID: Vk1mvzV2NnhuddtWUrSsAABwmwU5Hc-B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDAxNyBTYWx0ZWRfXwkkfoKYgRPz3
 OYL4x5uF7w6nejGpQI4kkTgPfLu7kvSd/QWX342IRlhhKxE1iklmGqfzfKRaQ0qACRMEeU0+HIs
 fCqzUReBacQFD2zY4SJaO1GMSz23apU0wAbmFzLhEXkqhXrfFnqJg5UoTnrqmNUpwWPSt7a+3fu
 kkFLl1qFE/lmgDDKXj9lTRCtBd4FRyVg/8lINWFVrGCG2yJlB4dYdaCAQmsRl4BBfqQWZhqsMI2
 B7mF90lmjLduBusQ26GoGKzsf2Exx5pYrfugKBdUeFyu3Oruthf9fiNSNnDop4OunIYO6BEqihK
 noTsT+ucl3ktTvAzgtuFLAjXnp3zp4AsqPDwY1wErhI+TvW2D9A7sFmfoLPUQLn49yEz7TDPLur
 +dNGD3hT/kAsWrv2rvlAz0IijDagV0QxSwO5r1jfkpbN0trCM0OShWv/Co4q70JcfJE1dqSgbt8
 CpPVGyBt8rcn4caoM6Q==
X-Authority-Analysis: v=2.4 cv=RM+D2Yi+ c=1 sm=1 tr=0 ts=6a7a87f4 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=HH5vDtPzAAAA:8 a=he8YDqbjAAAA:8 a=EUspDBNiAAAA:8 a=e4nBh9WiceBO0ho2o1YA:9
 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22 a=QM_-zKB-Ew0MsOlNKMB5:22
 a=lRF3faHqDRKgy28aj_NN:22
X-Proofpoint-ORIG-GUID: Vk1mvzV2NnhuddtWUrSsAABwmwU5Hc-B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608110017



On 9/9/2024 11:08 PM, Mikhail Lobanov wrote:
> The previous logic in ath11k_ce_rx_post_pipe() incorrectly required both 
> dest_ring and status_ring to be NULL in order to exit the function. 
> This caused the function to continue even if only one of the pointers 
> was NULL, potentially leading to null pointer dereferences in 
> ath11k_ce_rx_buf_enqueue_pipe().
> 
> Fix the condition by modifying the logic so that the function returns 
> early if either dest_ring or status_ring is NULL.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
> ---
>  drivers/net/wireless/ath/ath11k/ce.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/ce.c b/drivers/net/wireless/ath/ath11k/ce.c
> index e66e86bdec20..9d4246d65d68 100644
> --- a/drivers/net/wireless/ath/ath11k/ce.c
> +++ b/drivers/net/wireless/ath/ath11k/ce.c
> @@ -324,7 +324,7 @@ static int ath11k_ce_rx_post_pipe(struct ath11k_ce_pipe *pipe)
>  	dma_addr_t paddr;
>  	int ret = 0;
>  
> -	if (!(pipe->dest_ring || pipe->status_ring))
> +	if (!pipe->dest_ring || !pipe->status_ring)
>  		return 0;
>  
>  	spin_lock_bh(&ab->ce.ce_lock);

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
