Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792634774;
	b=vEwggYpf/O6hIq7xSYBJtCGdgwX1uOym52JaZhyxLwk4EF0mTBpU6rzO1NOKXusQ8lsr
	 SBmSGR/jfL1SU/56LMOgEzxnKgUorx1Q/2uS3mUwEfa5gCTin8MdlyQ3bPXpf2QvlQQ0Y
	 qKBoz6eWQqpo4IguLePYpXgMwt3Vaj1NRakpVFiPQdrBaUX2fUIr3fD2NRM6XBrD74xds
	 8KSV014Tw6alzBX73JlcvzpnWTQ8vRrC+fiIpjxgdoWIiVwmA0YAJTByBbMkVBh/uVz0Z
	 +KTinW/UVYEm1Vq5oNAE7WOdTo3Cz8UQMuua9iD1dIWccb8UeBVEMetPKID76Q/I9xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792634774;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=aEiB+TPrI9w/nNl1unn+ZcBh8ZZfQSBY03uSVOM3OX0=;
	b=YQ7ShnC9tKVS8BGHvItCROQrxberDUJI8aZSgtJugKoaKPRl/Kzw+99w4gpdH0CwIC0d
	 eRe8pL6VELE25Nj9VfrqGJ+9kKErMpbtoRaLanF7xi8bbuHDtXlwj7yuf8T0QtvIFnlrh
	 Pujnd1wYvK1wHGjKW7yJOXQm6Vt4vNvNz9L/IrQMkUF3T4L8FksmdgjmyjRiBAz7U48JL
	 bkvlrSQPFBlkJqep+xq2ZJg3kLL5J9qXejapmw5kZ8xULn54DGbT9kHzlIVDivfp/Ev/i
	 381YYwMi+MSruCyOz6UYC9dfJWtRsxgegSh9wvzGSbFpuRqmp7467rZf9yIQN3HMspA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VmtBHypc;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XJadzX6a;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBF7606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 02:06:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BBF7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VmtBHypc;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XJadzX6a
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M1iUBH2821389
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 02:06:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aEiB+TPrI9w/nNl1unn+ZcBh8ZZfQSBY03uSVOM3OX0=; b=VmtBHypc4uu9hwSV
	0DB7NKDL9viWUojKSSjPlkDII2y4HoEof6MVC21i74+z5x7uJ6Wfe0sRQe5j9Zuf
	ayJ5vqyDrcyvlrMLpJmI7uRvXl/3RyQCVwDInznl9AUwGeKDECDXtcT2q7HKeco0
	jOiOSIMG7k3BI7MCmUKdOE1HtFyz/8Ak67XshNZMSQnP2r5yL2AaWLJOu1QCYKJm
	fYGozBQq1OL3oPD9/yNIlnZYWPsXK7PyrGITCJWlCYYoL0UoKxICyBHSExsB9FkA
	oNd/WJLa6kIAFxtg+5X+HHYEW+iCKYOBIpoAfxcfhbsrmeCqyni93+3yXDnKpc9y
	pJUPfQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93bg4mh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 02:06:12 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc1cdfb337eso772565a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 19:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792634772; x=1793239572; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aEiB+TPrI9w/nNl1unn+ZcBh8ZZfQSBY03uSVOM3OX0=;
        b=XJadzX6anKhxVYKrezzr2kpekAFlCPnFSIkoiX3qUqU0dwsPRrFziRzbGgUmYFLL9C
         /RnUlBR/ojHFFFxjQRPHtj6N4rzZKvGPO0BCxTYJ0OUqmH7oDKQIZfllsKYxItvoDZ2f
         ZEkNgzxg5COzKjgPQ8shTmLoUgq3M60yRLIwaxvhlOHDGS7KWN/KgF0MMEzdZAMiGp5a
         12n9EFIhkw3VxatfzSyg6wH8uqpMOedbz4RyqrAbfqoC0aumbFdxrB+22/F7HXln8Sr/
         DuxzOf4PwY4pWdTjnrFxxjOo+2r3sqeBIdQVaOe5fKnmGacQgv90uX60bitbRjO3n1px
         Cz/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634772; x=1793239572;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aEiB+TPrI9w/nNl1unn+ZcBh8ZZfQSBY03uSVOM3OX0=;
        b=0ayCSkPZrA81BVYWfL5JCS9hsvaCj7BLt+yNlfnJ5+i9M7JEusWdn4+H6wpNiJLbRP
         JObU/JAAdRc+5adcJlf1QvXQm8yu/H7KwIqJZdJ9ElJRKyh3VKKSaRNAI6hT15qQsLaX
         SQ7NEWShRxTHq7xw9K9TwUAbucmLoZYMnY29og2PqN5xoI+rhWtj5OumzuI8Jc7Eyf1W
         j3zLFaa2TiYzAzhJf/cRlLQ8FBqZA5sYsFIQhsKTN+iZ/t5RObnz0tOdw/LQs6WzMGhp
         10UzYWghYy00V9xV6t/C3W/JpeOalAdKM/93FaI95/+4qCyZkx79peosGV+iR2NLa0sm
         SgfQ==
X-Forwarded-Encrypted: i=1; AKwUvBxhgUvETxSE9RD8geIY2XYRXzFlKeQB2qzQEXzk/HXmpMNiLTEU+MQqKTLgt3idOaa3tg6wpnDFdSh4UrqZHg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJGojXl0q19Fi8RfMuyFV7koUMiJVuzEf43czq+jnwSmpQ0hz89
	q0OTtf7aEPBnwCHpV1r24ghuxct6k1MPNFMxX/HyZh2yNeHVTVv4InlwMw3fyEXzc9PEaDxqRpk
	abaBlsdNYXoZwNmaEda482ubqVN+jzIx2H7+tCUN2tghOE9RsfjGN9sFytfp8JMHiSeDwfQ==
X-Gm-Gg: AYBFou0f4Ck+yrpUyGiX+ZUaTB6r8wrPTjr2DexSjW1Z1PlmGTbYTiWBfoMbXKLUl1F
	aFGUVtxvpbKQ4cP8OJskGzQoUuYnIFVwU5d+rOD97PVRGiOaspaEUN+eP2MemlQ9tcGwlD/zB70
	K2IPFkoNya6IP0aAafNedSD0DlLiVfa3kvz1x3tkL/KgIKnUcFZ5GWw2pZmUKPD+JKi3sK5d2We
	lXLKtWtoMcLGR7/yCCbGCbzyYsAOVAg/4/JrozCw+67KQUiOdzyp1VwmVy6E9ZJ76sefsx1VMCI
	2wF5+h5exrymhGmFSkheZ61PyrON9BxZb97yNC2k7EcxzbLOwgq4YyaKoNRdNvrfUrF/pJKjQcg
	0pRkmjKBCUE9tUXwq0KBRBhb4l7Of8ygNWV3K+zeuiLzw7xNn0poyCoPObcYELYHL5hY=
X-Received: by 2002:a05:6a21:a247:b0:3e2:a9cc:3ecd with SMTP id adf61e73a8af0-3e2a9cc4222mr20190637.7.1792634771865;
        Wed, 21 Oct 2026 19:06:11 -0700 (PDT)
X-Received: by 2002:a05:6a21:a247:b0:3e2:a9cc:3ecd with SMTP id adf61e73a8af0-3e2a9cc4222mr20158637.7.1792634771252;
        Wed, 21 Oct 2026 19:06:11 -0700 (PDT)
Received: from [10.133.33.35] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd6b8482207sm594009a12.9.2026.10.21.19.06.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 19:06:10 -0700 (PDT)
Message-ID: <c49d0198-7207-4439-9be4-22d35e741ac9@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 10:06:07 +0800
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
Subject: Re: [PATCH ath-next v2 1/8] wifi: ath10k: fix SDIO aux workqueue
 starvation in recovery detection
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
 <20261021-10k-sdio-crash-v2-1-5df80bf16e86@oss.qualcomm.com>
 <CAFEp6-3UB=U16NkQNM_H4gUA71XWvYLcmcO_mJhFpX=9yC=HiQ@mail.gmail.com>
Content-Language: en-US
From: Kang Yang <kang.yang@oss.qualcomm.com>
In-Reply-To: <CAFEp6-3UB=U16NkQNM_H4gUA71XWvYLcmcO_mJhFpX=9yC=HiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAwOCBTYWx0ZWRfX6SRh7uI0iebS
 JVmfATmJQQkzctH5UhE0NdpTKU6/ODt2owe4RVv3Q5bno5FE74wdRhevPXsVlBf6h2HTg3JWFmU
 Yd5U8eK55n7VqS3ypkpW5vvcv6m3DuFqvjS+nyxPSMvxSIDKhsiUItjAmJevt2rqzbRbM5ax5Bs
 //cRZryiM6sB5swGfCyNPftqm6kSEq/QWty69v7nkHKs/2LtWCnWL3P6DrI5jSZHAmdStJ32q6k
 6T2xi93I6otjwlE3rlkSgsVJkidXN+Fe9Ended0qQj0ajGJ0tqWkDTywhqgqwcp3i6hO0b4NC/F
 6mV1q7B5uv8lWuUFeVo8xlKG8+XF5KaECn4zMFv48e/2RNJnsNeZsLMC21UTq8umEeTLfNr64NN
 D8KmmnV53ufIKNX7ICeN9odJNeocG5H31pOKQBVf1rsV31Ik5Rx0fTUy1T7kNsoLWVxfLAR/4DX
 ExIJdoZ+sU40srKoYWw==
X-Proofpoint-GUID: KrCPzRbDOd0LV94zaThd-LtbybodFaHN
X-Proofpoint-ORIG-GUID: KrCPzRbDOd0LV94zaThd-LtbybodFaHN
X-Authority-Analysis: v=2.4 cv=CMy/zhrD c=1 sm=1 tr=0 ts=6ad96f95 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=ryoBpbmvVPDUnakTGygA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAwOCBTYWx0ZWRfXxvgusHL+WnXi
 B21nsiNESnsy+6X+a9p0m3az9Pwlqg6luEsJu4H6FmbMkfJ+l3nSouiPrQIlSGI/SX0kNB3A5fg
 sGUWFVBpTA99hS8H6Ik12PMgqeMjqio=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220008



On 10/21/2026 9:33 PM, Loic Poulain wrote:
> On Wed, Oct 21, 2026 at 11:09 AM Kang Yang <kang.yang@oss.qualcomm.com> wrote:
>>
>> Recovery monitoring runs on workqueue_aux, which is also
>> used by SDIO RX dispatch and WMI SERVICE_READY handling.
>>
>> A single firmware crash may generate multiple recovery
>> triggers. Recovery detection currently handles each one by
>> waiting for recovery completion on workqueue_aux. On SDIO,
>> this blocks the same workqueue needed to deliver recovery
>> traffic, preventing recovery from completing.
>>
>> As a result, otherwise recoverable firmware crashes fail
>> with:
>>    ctl_resp never came in (-110)
>>
>> Treat duplicate recovery triggers as part of a single
>> recovery attempt by gating recovery startup in
>> ath10k_core_start_recovery() with an atomic_cmpxchg() on
>> pending_recovery, and by making the monitor path check the
>> elapsed time since the attempt started instead of blocking
>> on a completion.
>>
>> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
>> Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189
>>
>> Fixes: f35a07a4842a ("wifi: ath10k: move recovery check logic into a new work")
>> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/core.c | 64 +++++++++++++++++++---------------
>>   drivers/net/wireless/ath/ath10k/core.h |  2 ++
>>   2 files changed, 37 insertions(+), 29 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
>> index 7c2939cbde5f..07beefa06c4c 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -2494,46 +2494,52 @@ static int ath10k_init_hw_params(struct ath10k *ar)
>>   static void ath10k_core_recovery_check_work(struct work_struct *work)
>>   {
>>          struct ath10k *ar = container_of(work, struct ath10k, recovery_check_work);
>> -       long time_left;
>> +       unsigned long recovery_start = READ_ONCE(ar->recovery_start_jiffies);
>> +       int fail_count;
>>
>> -       /* Sometimes the recovery will fail and then the next all recovery fail,
>> -        * so avoid infinite recovery.
>> -        */
>> -       if (atomic_read(&ar->fail_cont_count) >= ATH10K_RECOVERY_MAX_FAIL_COUNT) {
>> -               ath10k_err(ar, "consecutive fail %d times, will shutdown driver!",
>> -                          atomic_read(&ar->fail_cont_count));
>> -               ar->state = ATH10K_STATE_WEDGED;
>> +       if (ar->state == ATH10K_STATE_WEDGED)
>>                  return;
>> -       }
>>
>> -       ath10k_dbg(ar, ATH10K_DBG_BOOT, "total recovery count: %d", ++ar->recovery_count);
>> +       /*
>> +        * Pure monitor: only ath10k_core_start_recovery() starts a fresh
>> +        * cycle. Bail if there is nothing in flight.
>> +        */
>> +       if (!atomic_read(&ar->pending_recovery))
>> +               return;
>>
>> -       if (atomic_read(&ar->pending_recovery)) {
>> -               /* Sometimes it happened another recovery work before the previous one
>> -                * completed, then the second recovery work will destroy the previous
>> -                * one, thus below is to avoid that.
>> -                */
>> -               time_left = wait_for_completion_timeout(&ar->driver_recovery,
>> -                                                       ATH10K_RECOVERY_TIMEOUT_HZ);
>> -               if (time_left) {
>> -                       ath10k_warn(ar, "previous recovery succeeded, skip this!\n");
>> -                       return;
>> -               }
>> +       if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT_HZ))
> 
> You can use time_is_after_jiffies() for this.
> 
>> +               return;
>>
>> -               /* Record the continuous recovery fail count when recovery failed. */
>> -               atomic_inc(&ar->fail_cont_count);
>> +       /* Record the continuous recovery fail count when recovery is late. */
>> +       fail_count = atomic_inc_return(&ar->fail_cont_count);
>>
>> -               /* Avoid having multiple recoveries at the same time. */
>> -               return;
>> +       if (fail_count >= ATH10K_RECOVERY_MAX_FAIL_COUNT) {
>> +               ath10k_err(ar, "consecutive fail %d times, will shutdown driver!",
>> +                          fail_count);
>> +               ar->state = ATH10K_STATE_WEDGED;
>>          }
>> -
>> -       atomic_inc(&ar->pending_recovery);
>> -       queue_work(ar->workqueue, &ar->restart_work);
> 
> So we are not re-arming anymore for additional tries? or I miss something.
> 
>>   }
>>
>>   void ath10k_core_start_recovery(struct ath10k *ar)
>>   {
>> -       /* Use workqueue_aux to avoid blocking recovery tracking */
>> +       if (ar->state == ATH10K_STATE_WEDGED)
>> +               return;
>> +
>> +       /*
>> +        * SDIO raises several triggers within microseconds of one crash;
>> +        * only the first winner starts a fresh cycle and stamps the
>> +        * deadline. Losers do nothing while the owner runs recovery.
>> +        */
>> +       if (atomic_cmpxchg(&ar->pending_recovery, 0, 1) != 0)
>> +               return;
>> +       ath10k_dbg(ar, ATH10K_DBG_BOOT, "total recovery count: %d",
>> +                  ++ar->recovery_count);
>> +       /* Start a fresh failure budget; the last cycle may not have completed. */
>> +       atomic_set(&ar->fail_cont_count, 0);
>> +       WRITE_ONCE(ar->recovery_start_jiffies, jiffies);
>> +       queue_work(ar->workqueue, &ar->restart_work);
>> +
>> +       /* Start monitoring after publishing the recovery timestamp. */
>>          queue_work(ar->workqueue_aux, &ar->recovery_check_work);
> 
> So now that the recovery check is no longer blocking, it seems to me
> that this could be implemented as a simple timer (alternatively, a
> delayed work) as it would avoid having to perform the timeout
> calculation...
> 

Patch 5 will change it into delayed work, let me think if i need to 
merge patch 5 into patch 1.


>>   }
>>   EXPORT_SYMBOL(ath10k_core_start_recovery);
>> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
>> index dfee432615eb..c739fbadc8bb 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -1215,6 +1215,8 @@ struct ath10k {
>>          unsigned int recovery_count;
>>          /* continuous recovery fail count */
>>          atomic_t fail_cont_count;
>> +       /* jiffies when the current recovery attempt started */
>> +       unsigned long recovery_start_jiffies;
>>
>>          /* cycle count is reported twice for each visited channel during scan.
>>           * access protected by data_lock
>>
>> --
>> 2.34.1
>>

