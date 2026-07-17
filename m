Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2362F7EF4
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784253253; cv=none; b=s24bzMGu/keiV9Sm9RQmDvox0NeXyTXNs1Zovon4kUtpEds00mb5yF3Yxo0uk0YpIfHacMGzKS5knRxXWIkMV1Ts4A9jHolaGJKK6Wqxg7W3JvJf2Gkpa1dsFpZddooEvR160D4W9ZcEpeiyjtwp4MfS1+bz7Eny69k1f174yl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784253253; c=relaxed/simple;
	bh=fB6mjJGJ3CpU5noCIyrNfWCqVLH5aAoyz2qKjU494eg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aykRqIpJz4+Fy+yNYoW3F4rpiaMNkMJ8dYEHnKQIy6DhTtrP+wpyZBeMloUE23nnSkdDDdYqCsEaqC7I2ZkYiY8D+6mAb1cWUlfsB57P0Ar+oAEfjTfpIadyTBWbpWch+paxmnvm300f/XInM5q0tmkSbUvdTqA6p/uwut7Y3Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hoxqc+Sz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=asJaaMiN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hoxqc+Sz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="asJaaMiN"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GNIiHl4050325
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XYmYfrikvQI+7+A4AEKNdmuoRFW8vKoYWNnncp4gSAE=; b=hoxqc+SzxrhtfB7i
	H5hh+XNKxSCta6NOdHXjeH9nLIdKDAEVvmJl5FcnwCsW8VwCbUWTUPLK9G3vwQOs
	RIBkvCaaXz0n+3p9tHj2UTAyTBf6+eMXDHBhBIPILHN6qCRkZlxYTVkEp6FOJF6n
	viE+PmUUdRcjeiPPCWR8Yi2xsC5V5m6CN/2vNo2+8nAW9ky8KOTy4WcvS70+YCPS
	ZBVNyTpQrZQJLfjAfHKumV315foRIZRg7XzBIn7CJs1TWQZL2s70fN/33ho5hqFM
	UNyiUcYtVeUyI2Q2BrLNqO2+7c7EDq61szMdu8Blk1NB6HqbzLaPxuP/dq1RlRnM
	mgScZQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ff1wea3yc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:54:11 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e095fd889so7857580a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 18:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784253251; x=1784858051; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XYmYfrikvQI+7+A4AEKNdmuoRFW8vKoYWNnncp4gSAE=;
        b=asJaaMiN5i6zfhdOrkuSwnL1bv/zsFE4SyDoUPpF3Ll2Tb1CMyhUYz4J8k3yYsEowy
         rrRtAI8jvcO3T83lWRhG+5Nu1B4kb7S0AoHO6Y6A8J8ChFMqle/mLO6rJguls6q+utzA
         duOFJ+Ae0ApzwNf3Z8InrCnq/73HK6C/TODrodgA0xjjHhKRQFZMixtAi5aSXD+Nkp++
         AdjUgueqRK99Vo6cV+x5x6t6f3KbNqFdsbP/oaaQI4AaZu4coZtUnafko8U7k7K1xjCn
         lIPuQtM7XPOHG497qEQj9AiIOgzQY/W4rgINIyTCGIlrxsMxfqsu/NdD8MFY1bTRnPK4
         MIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784253251; x=1784858051;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XYmYfrikvQI+7+A4AEKNdmuoRFW8vKoYWNnncp4gSAE=;
        b=NGa+ZKJisj098hYqXZdDObQGJo6CD0VPCXTZxA/SJPJ97UtOMzaNqoQSaaB8IkWkPS
         UGL+hP6HruP1iWB5i352tc9+xIkZM+1BnV/MhqSCU8ZuUzgoxiPcIu/Y5GD/1HlnLl7v
         j27+J/WVURLKoG76SYOmo0FWcjEvlob6lgietkfKoPk7jMv7/o2ii8QjW/59kUsWy90G
         uV2bSkYIfIBS3+b3t3pbJ5ogRZiayvWJhC6+MzQH2QPK1PLv7+BBsAyPfP7s1fjed9Li
         NHxm+GWSv0EnsUM/G9atPUsnXrnF9ef5rpkVzOtn72VucqbSum2b64/nQ26ut+n57hCy
         bm5A==
X-Gm-Message-State: AOJu0YyXF2nXd5TGOfc7DfupnElbo07gTAtRX4U+5pPQbgnYjmBm/eZt
	VUmxNjq63BKdAUFoJsFbl1KNaeO8kJ0ljYgHBMhXXCRw999P8xbw8cXLLmkNOakD4brxuQFYkeD
	jqv93xoO/uAbdMMpSQq3IO9OloDm0Lv9Dajx1lhZPy7YERCCLHttM5bEsiqoaPi6HjFaAAg==
X-Gm-Gg: AfdE7clxHvU4KbNcZK7AWWUGd92uT8lBW2oxscbjNycBoARXVK/M3+uHTxEB3wimEIY
	aZpxGFrvN3yDPS2p9wtgzqY9yLa6jS4AUnWHCMLBWH2KptbvZ0IXp+aTPAZdOdB9GH1uW6r5ns7
	IfMQhs4OUdmkUhU5MW/2e9Jnd9FfaXHS4mKqbkkdhvE3/dKlqqsoJmaIFDB//xCVKA9FLJR4Le+
	rdHhORyNFfn/xF37Ba0lu4Lm2+07AadW3VQjD6IwSnp+/QyDgvYg0mqZYiaBaiEFok699R22zNy
	/q5779U9tao2wTI0dxjR6lEGRqI0g5IiQjEfYs+Mqy+q3s07a6fyH3DITKVctmRRwrqjSRt/BVz
	Lhe9tcIFCUQvtdiPU2uyTBa8RcGrIKhYyTLxuhEdNAVdSmhd+N0WlivpgexWt3btYDCe0Xj/p
X-Received: by 2002:a17:90b:5608:b0:38e:488f:7068 with SMTP id 98e67ed59e1d1-38e4b43108bmr533317a91.2.1784253250673;
        Thu, 16 Jul 2026 18:54:10 -0700 (PDT)
X-Received: by 2002:a17:90b:5608:b0:38e:488f:7068 with SMTP id 98e67ed59e1d1-38e4b43108bmr533294a91.2.1784253250093;
        Thu, 16 Jul 2026 18:54:10 -0700 (PDT)
Received: from [10.133.33.98] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e39e2354dsm2073580a91.8.2026.07.16.18.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 18:54:09 -0700 (PDT)
Message-ID: <f3159efe-bf29-4b7f-b1d0-5a658b9e829a@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 09:54:06 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current 5/8] wifi: ath12k: introduce host_alloc_ml_id
 hardware parameter
To: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260713-ath12k-fw-allocated-ml-peer-id-v1-0-d0a2a1a519eb@oss.qualcomm.com>
 <20260713-ath12k-fw-allocated-ml-peer-id-v1-5-d0a2a1a519eb@oss.qualcomm.com>
 <a906aae4-b695-4f5f-9ee7-51d40700f8c8@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <a906aae4-b695-4f5f-9ee7-51d40700f8c8@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDAxNSBTYWx0ZWRfX6tNdSjjeUqDF
 VMBq+wgXjaJJtNEG7T2YfWlhfDXrWxpG/fEsGvDlFyGgokdb15yN/1ZLVIXBvzn0Ej1jXMDb26z
 USuUxkne3CrHQ7QvEM3s7MIlnAY8dH+IXWWu1I5MOX7EiNQqVtDIT0ebhCkQAskuq/kXpesOt+G
 mSjZMRP0etFoHNUs/os+PsBfjusvHm3ukUMUEE1kFyx1Vi4jl40EYMThTwi5PT5nvtGVTGZNntS
 e8nifEuzt3oY/rHo0ZYKw8U4msDhTqdqMM0WvArYXyy1Bid/A6ErdqHqDek2aJgWRe3KI5X+qJF
 yV/UtCKj6RTtgWI2/GpfhcgqNBkWStXEkrl5siJ8zq3Q4NUb8LNqawX+rD2WL06Wu4GUwpQxiOF
 bPzwVHZFoZFNuHPjirXiLd1wrJ3nN0H46hio8O5XXVEgWuQpMQBssY+WL83gV97vwBjQzK4ZUQj
 u+w0iZIGO2Pa6dFRUGA==
X-Authority-Analysis: v=2.4 cv=JJ8LdcKb c=1 sm=1 tr=0 ts=6a598b43 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Di5Tgb74uudud7Oqj5sA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDAxNSBTYWx0ZWRfX8HyYHz7MRjQU
 4h8Bs6tSycwszNyj4lr/09HSW1g1RLZaNNR4KATgxkFDSu3W0CGQWBhmvj2082GV3VGxyXa4dkc
 +DNP+uouj0TDpgUIeerzOvE22UPL5xo=
X-Proofpoint-ORIG-GUID: 1qWvEMoKvCdriV9YojfI0rJtnrShIAoD
X-Proofpoint-GUID: 1qWvEMoKvCdriV9YojfI0rJtnrShIAoD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_08,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170015



On 7/16/2026 10:55 PM, Rameshkumar Sundaram wrote:
> On 7/13/2026 1:03 PM, Baochen Qiang wrote:
>> Different ath12k devices diverge on who allocates MLD peer id:
>> WCN7850/QCC2072 have the firmware allocate it and notify the host via
>> HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP event; While others let the host allocate
>> it and pass it down through WMI_PEER_ASSOC_CMDID with
>> ATH12K_WMI_FLAG_MLO_PEER_ID_VALID set.
>>
>> Currently ath12k host allocates this ID and sends it to firmware by
>> default for all devices. This breaks WCN7850/QCC2072, because the host
>> maintained ID may be different from the firmware-allocated one.
>> Consequently data path may fail to find the dp peer and drop some received
>> packets. From user point of view, this results in bugs reported in [1] or
>> the 4-way handshake timeout issue.
>>
>> Add host_alloc_ml_id flag to struct ath12k_hw_params (and a copy on struct
>> ath12k_hw for hot-path access) so subsequent patches can branch on it. Set
>> true for QCN9274/IPQ5332/IPQ5424, false for WCN7850/QCC2072. The flag will
>> be consumed by subsequent patches.
>>
>> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=221039 # 1
>> Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath12k/core.h     |  1 +
>>   drivers/net/wireless/ath/ath12k/hw.h       |  2 ++
>>   drivers/net/wireless/ath/ath12k/mac.c      | 17 ++++++++++++++++-
>>   drivers/net/wireless/ath/ath12k/wifi7/hw.c | 12 ++++++++++++
>>   4 files changed, 31 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/
>> core.h
>> index fc5127b5c1a3..1f56474efbea 100644
>> --- a/drivers/net/wireless/ath/ath12k/core.h
>> +++ b/drivers/net/wireless/ath/ath12k/core.h
>> @@ -793,6 +793,7 @@ struct ath12k_hw {
>>       enum ath12k_hw_state state;
>>       bool regd_updated;
>>       bool use_6ghz_regd;
>> +    bool host_alloc_ml_id;
>>         u8 num_radio;
>>   diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
>> index d135b2936378..8091501cf742 100644
>> --- a/drivers/net/wireless/ath/ath12k/hw.h
>> +++ b/drivers/net/wireless/ath/ath12k/hw.h
>> @@ -232,6 +232,8 @@ struct ath12k_hw_params {
>>           u32 max_client_dbs;
>>           u32 max_client_dbs_sbs;
>>       } client;
>> +
>> +    bool host_alloc_ml_id;
>>   };
>>     struct ath12k_hw_ops {
>> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
>> index 7d0d7d5fbf53..9e5fcbf8c730 100644
>> --- a/drivers/net/wireless/ath/ath12k/mac.c
>> +++ b/drivers/net/wireless/ath/ath12k/mac.c
>> @@ -15382,8 +15382,9 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
>>       int mac_id, device_id, total_radio, num_hw;
>>       struct ath12k_base *ab;
>>       struct ath12k_hw *ah;
>> -    int ret, i, j;
>> +    bool conf = false;
>>       u8 radio_per_hw;
>> +    int ret, i, j;
>>         total_radio = 0;
>>       for (i = 0; i < ag->num_devices; i++) {
>> @@ -15423,6 +15424,19 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
>>               }
>>                 ab = ag->ab[device_id];
>> +
>> +            /*
>> +             * the assumption is all devices within an ah
>> +             * share the same host_alloc_ml_id configuration
>> +             */
>> +            if (j == 0) {
>> +                conf = ab->hw_params->host_alloc_ml_id;
>> +            } else if (conf != ab->hw_params->host_alloc_ml_id) {
>> +                ath12k_warn(ab, "inconsistent ML ID config within ah, device 0 uses %s
>> allocated ID, while device %u doesn't\n",
>> +                        conf ? "host" : "firmware", device_id);
> 
> a garbage ret will be returned in this err path.

Good catch, will fix in next revision.

> 
>> +                goto err;
>> +            }
>> +
>>               pdev_map[j].ab = ab;
>>               pdev_map[j].pdev_idx = mac_id;
>>               mac_id++;
>> @@ -15447,6 +15461,7 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
>>           }
>>             ah->dev = ab->dev;
>> +        ah->host_alloc_ml_id = conf;
>>             ag->ah[i] = ah;
>>           ag->num_hw++;
> 
> -- 
> Ramesh

