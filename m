Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484545;
	b=1qjoyXahCqudUEp+3qqXkAFmFeAnorrd/qwPJKVsVg5SSGvbOO859MJ1TCEGj8HIkmOy
	 QA/7SSzyrGWFLDYO/jNA+rk0j4elaXBIw1blRKO7W5jRv+btx2oiM6JoKPro39ViWnw3V
	 oPmg7EcbUcZb60GbkROtcf15IbD7DK55igCxiVFM8gwyueyflKWRuBTJhSGwO8Yiln7e/
	 nY+WsMzlfF2pfHgQWPaK4BISzNSVyPZ4456hx6PFry2b4pkyKS3ks5jOww0pxspIoSpgv
	 OdNhw4RcpxpebE0d10uadLVfb9kosZlvIwzpbxAJVBE+BHVRdGxRv5QWnm9xWV4qUAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484545;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=YEHc6iDxyYLlDmAzsBo5o5KHEION2Y+pQgLNUDYY3Y8=;
	b=ZcTEVXWZ555er1Cx68nROOV++gcuE2XovICA/S7aKJSlWvjezRLns+p4nspwkAc/XekJ
	 GT/lk5sv06cCHJZq/TAfS5HRFkKO+ZiMPNWzjcvf4wQch1xOCT3s+gp+0k+FDZRZv6LXh
	 4c/phkUmB15XEjxVU06syjsvl9ne9dL1a3AhlXG+6js4pX4a/lFToW8crQjrLxMABhvQ/
	 vKmexAe7UHMWCr8vydxbi9+RUTto2kWHRM3//QTtaZTmtwubzUU4sBcVLRfVxLAE/Cdi/
	 43qPBtmZ1FcfrZOvNZrTeX3PqSSnloy7Tck3YGT4kFe/TscVzbN80XQERsxrzZMRDDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="CCecqKF/";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fuTyOHhI;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A45606A319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:22:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92A45606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CCecqKF/;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fuTyOHhI
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69K8CPqd3305673
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:22:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YEHc6iDxyYLlDmAzsBo5o5KHEION2Y+pQgLNUDYY3Y8=; b=CCecqKF/koHsu7wt
	oCu8RIYOM78A1MWI5uDEoj/WrzFfFg4eNgBQBlTFpDgeqTydBGkPihU0uHOmZQt2
	iOGP65YGA5j5AGzzEoS4bigfpFB/rW3vu3Jm8dbuY+qHEuf166MACnrD8Ns60Z46
	uoOBN9tMex6Cw5Jhd6YYO4BjwuxPjkLq2jr6k0EmBFkMfBRKHcK3EfMQ5HvoqTVy
	gzhMU66z0nj4B/Dp92S4BVkjIzK+umtDs1KQd/Llpa2i6M/W+sl0eoAyBZzqICbj
	hHpEfjK9Bsyf1OQAxm+VcPh99bSKBsehuZEAghkFUCcaHNekUY57HnqlwepqO7EC
	mj3T+A==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdw5ssjbj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:22:23 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39de4e72b33so4341372a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 01:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792484542; x=1793089342; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YEHc6iDxyYLlDmAzsBo5o5KHEION2Y+pQgLNUDYY3Y8=;
        b=fuTyOHhIybz1bRWRlZggdSxoNogYH+MDgKyfgETyrexh78yIThG8Vur2VW31Uov2jF
         pLW4gRDMrDL5i9sTcqLMtuRGoOz72z32XhbgTd/fyb+eZ5ZNM2qfS7MX2/q+EPTRHo8a
         GBLVGOPglrbeNY9/tBvjeYzLjL4Fnh0sqextf5XbT1yukTFEm0AyT80iezJ1LzzQ5AXq
         omsR47ITNIPLj8WYMjEuaiy/NjgeXKxMlu/Z/4gMh3Wz4AATWqccMIugdpNYqAvUb0c4
         HJNs9avIBAa3pxwH/BknbnR3mCX2Qq6baTJqBx61FRxd8pgfXMz4IdiWrYLEdCeGgaqW
         8GGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792484542; x=1793089342;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YEHc6iDxyYLlDmAzsBo5o5KHEION2Y+pQgLNUDYY3Y8=;
        b=x7IDnmhBfk73OC7KxV0EZ1YGNjdQcygd4px4PVJW9oBip5poF+9FrcYtMbMlm509Zx
         iroOyoiom1OSsF0LJXXKFNMKjCTLYgf8s4AKc/R1pbcYNDHl0m1lVhPKO8v6tmHuZruR
         j5QMEXEfGDlw2fE8b4DT0g5x2N+izWfe7f6d53V7Y77GcYI90TRqvY/UazEkZE/fuNiQ
         Jz54UeTXfjrUz1Rf+NYEvpo9pboAfH5IYBeFDToTnhU8x45SpO2xQlWDPzoHQGiq8Y/p
         AYMyKgiEyiSP5y3GCfA3AV04k/P1/rSgaHGv+hHesXcN03Ywr84o2zulyD7cPhRoPVYW
         xSZw==
X-Forwarded-Encrypted: i=1; AKwUvBz+Azt36zPUpT9JcaZfbOgQ7hRxI3H8us6/u4zqRlzgEekcfUwAzMz3JpPs0DcUhNmqNFQ7fsH55dogMebVbA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLLVtf2GJM4aGi6MzzR1tqFgXd9Lj1AwiNQ0d62UVfkZmY9IvOT
	zVEupZHsHNuQrwEttN8vIFgmsFZLL1gqu0bnfdygDJMhI5jxK4euDWpigzVoRPeO0/OjHDRRPJa
	ooLyng7vTFpEI+MsDw1FpzlXMqdLi3dK0JnF+1F04vfr7tBfcW9S071wzsQ8jcv+nXt5Gsb1G2P
	IkZLW/BYo=
X-Gm-Gg: AYBFou2/4tD9jorxST+WjG31xfwNhX18PflpQKYBBPNQVySWQwPeCIDCK08I0xoRiXb
	xYPaNV7B6TGpIyDxVaPCCzpoLTL9e3z9eAJWWAfEXEVyL4XDFvjxEY4qXeIfhN1HgIlvXheDX6A
	97/7zaBHA8dDJTmhl6lY+kRzsSwF4SftI8M4CC9HuKGBd9dIJ2XW0y+oas/wl8nGmNk5iF7I1qk
	iUGstBjczojr9B+xvF8Z6UmiZjUEDlnXnTneGQ/7qAEc1FYYmfBDXhVTd3iPfCOGnC8p2v82u6d
	7o1Vgl0Mim6E1UQaXqCbaOxtMw2P2tAJ86oN8ENBWC+z+KWd43jMa77nKlSchlVKwdceY1hCsTf
	nLikCyHaBj0g1AecmlPDiEB+x/yxyDACKSMqCecObFFHcZtz1dHPHIq0tjnvbfbbAvw==
X-Received: by 2002:a17:90b:2e46:b0:3ac:9e76:aa9e with SMTP id 98e67ed59e1d1-3acee276f13mr9186226a91.3.1792484541970;
        Tue, 20 Oct 2026 01:22:21 -0700 (PDT)
X-Received: by 2002:a17:90b:2e46:b0:3ac:9e76:aa9e with SMTP id 98e67ed59e1d1-3acee276f13mr9186205a91.3.1792484541413;
        Tue, 20 Oct 2026 01:22:21 -0700 (PDT)
Received: from [10.133.33.35] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad5d6df937sm2776327a91.12.2026.10.20.01.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 01:22:20 -0700 (PDT)
Message-ID: <5a65491d-5fc6-42a8-b2c7-acebe5e23324@oss.qualcomm.com>
Date: Tue, 20 Oct 2026 16:21:57 +0800
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
Subject: Re: [PATCH ath-next 5/8] wifi: ath10k: check the recovery deadline on
 its own timeline
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
 <20260925-10k-sdio-crash-v1-5-14baf913df94@oss.qualcomm.com>
 <CAFEp6-1t7s9zX5GMyiZ_PP09Zz1qRZ_tRRTmo2m_vBqOBj-Mhw@mail.gmail.com>
Content-Language: en-US
From: Kang Yang <kang.yang@oss.qualcomm.com>
In-Reply-To: <CAFEp6-1t7s9zX5GMyiZ_PP09Zz1qRZ_tRRTmo2m_vBqOBj-Mhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDAzMyBTYWx0ZWRfX1qYB84O3n6MY
 +Ef8D3uYP7To9vExumvLHAbA5ucJn3W1w5Xf7NjI7rDMQMFxQPMnEZoBJcLnjtRoIP/Y7Z4AjsB
 tHK7kr8/xVzapoLGvAOk5xmnOGHGc00lGtUEC2K4YDfUqdqBRLLAmDVOOI/J3UfoKco0vh77vk+
 KEaATQsRgecgQQkss6Ekll+ThvrDWy5EB03yujCB2Y689CYnPjm0Mg8SirkbuhopxopzDmLrar/
 drWi3ng23e19DwBEyYBP/YSFCNvBLseHnlrs8IzcihpVpsHun0GxNO7iWIc0fW70ZuGWKxSgX3s
 MdG0DUtZZX8FWJ/990QdbaBQ3wvQfyLKPQDFet9hOu17qMxnI3n3LgqSk+f3oCXWlJ3ndMi804O
 jUonF3CAr/T6SwmPjPvxSL3YLEm8UGsBbkCXuUxn1LpehX8nldTmDxjY4qCQJ5fJR16jEvJwxWP
 wFyuIMhY+30dcrSg6oA==
X-Authority-Analysis: v=2.4 cv=fIusTpae c=1 sm=1 tr=0 ts=6ad724bf cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=VoPCmNj33lMcq5cueVEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: uaufc5lPfL2-ZVGITbzmGeTH6CBOhk0m
X-Proofpoint-ORIG-GUID: uaufc5lPfL2-ZVGITbzmGeTH6CBOhk0m
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDAzMyBTYWx0ZWRfXyvpfeyodrBug
 bsX98A7FrEM4fY8nZto4gGQ7tdtbPonVrONqCdomVr9deuJDCH6qx//mftAfbazsHigDg6jJuVT
 sK0ROnLxHzPQImtQjv+0CXeTduiOaW0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_01,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610200033



On 10/20/2026 3:36 PM, Loic Poulain wrote:
> On Fri, Sep 25, 2026 at 2:27 PM Kang Yang <kang.yang@oss.qualcomm.com> wrote:
>>
>> Recovery timeout enforcement currently advances only when
>> new recovery triggers arrive.
>>
>> In practice, the interval between triggers is not bounded.
>> Additional timeout handling, workqueue congestion, or other
>> recovery-related activities may delay subsequent triggers,
>> causing the effective recovery timeout to extend well beyond
>> the intended ATH10K_RECOVERY_DEADLINE_HZ limit.
>>
>> If recovery becomes stuck and no further trigger is generated,
>> deadline enforcement may stop progressing entirely.
>>
>> Convert recovery_check_work() into self-rearming delayed_work
>> so timeout monitoring follows its own timeline while recovery
>> is in progress, independent of future recovery triggers.
>>
>> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
> 
> Are you using b4 (or ./scripts/get_maintainer.pl) for this series? It
> looks like a lot of relevant To: and Cc: recipients are missing, which
> makes it harder to get proper review coverage.

I didn't use "b4 prep --auto-to-cc", will use it in next version.


> 
>>
>> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/core.c | 20 ++++++++++++++------
>>   drivers/net/wireless/ath/ath10k/core.h |  2 +-
>>   drivers/net/wireless/ath/ath10k/mac.c  |  5 ++++-
>>   3 files changed, 19 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
>> index 29ca34a643ed..93dc7332c759 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -2522,7 +2522,8 @@ static void ath10k_core_enter_wedged(struct ath10k *ar)
>>
>>   static void ath10k_core_recovery_check_work(struct work_struct *work)
>>   {
>> -       struct ath10k *ar = container_of(work, struct ath10k, recovery_check_work);
>> +       struct ath10k *ar = container_of(work, struct ath10k,
>> +                                        recovery_check_work.work);
>>          unsigned long recovery_start = READ_ONCE(ar->recovery_start_jiffies);
>>          int fail_count;
>>
>> @@ -2536,8 +2537,11 @@ static void ath10k_core_recovery_check_work(struct work_struct *work)
>>          if (!atomic_read(&ar->pending_recovery))
>>                  return;
>>
>> -       if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT_HZ))
>> +       if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT_HZ)) {
>> +               queue_delayed_work(ar->workqueue_aux, &ar->recovery_check_work,
>> +                                  ATH10K_RECOVERY_TIMEOUT_HZ);
>>                  return;
>> +       }
>>
>>          /* Record the continuous recovery fail count when recovery is late. */
>>          fail_count = atomic_inc_return(&ar->fail_cont_count);
>> @@ -2547,7 +2551,12 @@ static void ath10k_core_recovery_check_work(struct work_struct *work)
>>                  ath10k_err(ar, "recovery timeout %ums, fail count %d, shutting down driver!",
>>                             jiffies_to_msecs(jiffies - recovery_start), fail_count);
>>                  ath10k_core_enter_wedged(ar);
>> +               return;
>>          }
>> +
>> +       /* Keep checking on our own even if no further trigger arrives. */
>> +       queue_delayed_work(ar->workqueue_aux, &ar->recovery_check_work,
>> +                          ATH10K_RECOVERY_TIMEOUT_HZ);
>>   }
>>
>>   void ath10k_core_start_recovery(struct ath10k *ar)
>> @@ -2574,9 +2583,8 @@ void ath10k_core_start_recovery(struct ath10k *ar)
>>          atomic_set(&ar->fail_cont_count, 0);
>>          WRITE_ONCE(ar->recovery_start_jiffies, jiffies);
>>          queue_work(ar->workqueue, &ar->restart_work);
>> -
>> -       /* Start monitoring after publishing the recovery timestamp. */
>> -       queue_work(ar->workqueue_aux, &ar->recovery_check_work);
>> +       queue_delayed_work(ar->workqueue_aux, &ar->recovery_check_work,
>> +                          ATH10K_RECOVERY_TIMEOUT_HZ);
>>   }
>>   EXPORT_SYMBOL(ath10k_core_start_recovery);
>>
>> @@ -3758,7 +3766,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
>>
>>          INIT_WORK(&ar->register_work, ath10k_core_register_work);
>>          INIT_WORK(&ar->restart_work, ath10k_core_restart);
>> -       INIT_WORK(&ar->recovery_check_work, ath10k_core_recovery_check_work);
>> +       INIT_DELAYED_WORK(&ar->recovery_check_work, ath10k_core_recovery_check_work);
>>          INIT_WORK(&ar->set_coverage_class_work,
>>                    ath10k_core_set_coverage_class_work);
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
>> index 0319da3ec022..a1ded2cba103 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -1213,7 +1213,7 @@ struct ath10k {
>>
>>          struct work_struct register_work;
>>          struct work_struct restart_work;
>> -       struct work_struct recovery_check_work;
>> +       struct delayed_work recovery_check_work;
>>          struct work_struct bundle_tx_work;
>>          struct work_struct tx_complete_work;
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index 8e604697d6c2..d10126351fce 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -5427,7 +5427,7 @@ static void ath10k_stop(struct ieee80211_hw *hw, bool suspend)
>>          cancel_work_sync(&ar->set_coverage_class_work);
>>          cancel_delayed_work_sync(&ar->scan.timeout);
>>          cancel_work_sync(&ar->restart_work);
>> -       cancel_work_sync(&ar->recovery_check_work);
>> +       cancel_delayed_work_sync(&ar->recovery_check_work);
>>   }
>>
>>   static int ath10k_config_ps(struct ath10k *ar)
>> @@ -8175,6 +8175,9 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
>>                  atomic_set(&ar->fail_cont_count, 0);
>>                  atomic_set(&ar->pending_recovery, 0);
>>
>> +               /* Stop the self-rearming monitor after recovery succeeds. */
>> +               cancel_delayed_work(&ar->recovery_check_work);
>> +
>>                  if (ar->hw_params.hw_restart_disconnect) {
>>                          list_for_each_entry(arvif, &ar->arvifs, list) {
>>                                  if (arvif->is_up && arvif->vdev_type == WMI_VDEV_TYPE_STA)
>>
>> --
>> 2.34.1
>>
>>

