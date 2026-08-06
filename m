Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7E22F0C62
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 13:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786021530; cv=none; b=ATcGdMM0x90iWA1R88tiaTHVO287u7eDHJHTVDyhRxWD/v9XuwECoGN/KblR7pPZ54iKbL6KrQccesbcHTrv1q1xs9C1dDn7ObFdFWmqBZatkA0AWwKslmV3Kgfl60iwNiNkjGwb1lhdGrAMErQ9T+h2u3iC0uBeGbghXBlAOWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786021530; c=relaxed/simple;
	bh=BQ6nIOCPksvBwD3sWZ9jKk5Mwoh68MrbN9+zqxYmgWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uhfyn2TgXRSZShyZGOM4bkCRQGoR3y1nzqODjlLZ7glSImDOubVImB2soXpgw695OwjPyaFStB3R9gQp8ZsmCCdjXwTI00eMKSLXFQF6vXIIxKUHVNM+5mo5RezSOnUpv/FYpGqo46ve9IntBAiVOaGkq2WLFlgnCGXkqyrelAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=L3KO0A94; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kiUzfLwc; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="L3KO0A94";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kiUzfLwc"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nfnr1277866
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 13:05:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PYx/rTtMraJOAXCXMM/+a4L443yt0RLktBClUFnY+qw=; b=L3KO0A94WSU4yrc1
	PS4v39fAXSJFfnocdAe/B0BtlhEPsn2dGhS+pfQJr/VSQ6mnIqGhRsOaO8XZVvFW
	Prk5e6rVirhcAmSfaBXUvIKp32PyCGNGyWAYX9ewjNqhqhOk+WcGwELTV/feYJDd
	LLLzGTUGERvsAp5LOn+lbKummK9DjqWHwSBdRPjYzoaOCD13J8vVKzfWKy3MLKr0
	bU8BzJigc+JZPpNNM/9S4cCxAf1fFvvoggxx2WUwS6AKF/dvwp2y+tmLaJhH9nCz
	CMjX/7JebnINk6ZxIzJ4F3qGR13W2YSRj2T9m9JNqM3nlOChUt+HnbrTdar77v3q
	qrVcew==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvjuejah2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 13:05:26 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cea6a46766so38230425ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 06:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786021526; x=1786626326; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PYx/rTtMraJOAXCXMM/+a4L443yt0RLktBClUFnY+qw=;
        b=kiUzfLwc2CmEEvfTmIs5OHnD7ZbpfluyQXg0W2qV83UIn+N9O3fmY8X3K7bQRzw1lY
         4wZzg1hRRXIAi3eTzgV6v0KROgjisJ4vyzYDhrzU/Bt3xllqW0AEvTF9DCaHk5CcfX/i
         20b0Z+QYC5Sb7c9wKjd37egRTRCs7a1jy+DFdlQgVfh6O9kIjmeQ6tHuzo/27K94kyVo
         Y0+/VEEcUtnzSQIdZEYMMsXBiN3YneawS9115JI4reDVWfTY1P8xO/U8jbevgj+3ZaW/
         dJGgTs5NJ9l6aFGkcwPBuSaD6u+/BziHbDjwfutGmBQvoqkq1+r2oAD1IbvWueZ47ATm
         J3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786021526; x=1786626326;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PYx/rTtMraJOAXCXMM/+a4L443yt0RLktBClUFnY+qw=;
        b=WCrKU5rTULwUaiH0snzHYxEOUHCjIxSaid0fowCVaK5sXZl99QS4rqe7lLvfqqUF0F
         OtusMbTvqmf4fXbhGCCNwvkkeUQSD3+DlLcYvA9f7HK7ZiLqTK/rLa4wxG4DDvvjFUZZ
         DvRC4p5tjhlX7J69TqKWllBxq5uGYsuNKx+aIYv9pR/e9RWczuyMWZFdyYHkW6p8YusQ
         MW4rW6rjF/TsOsCsL5JOtLSTVpg5DKEIyTBwdqOaS92s+Bxkt2+uf/TrAYswUAH6q7LP
         bXb6ZzfmzoqQSydmJiZ3ikQus/X9qXPfHEkSeW6h5g+pxpq5Z53wkU3uYrknGdwRB+xN
         4XkA==
X-Gm-Message-State: AOJu0YybZ6oic5qrledwxyhViyC/IHrbJBmYK8+eprTm7YB3NsGrHYoU
	iwWRaAtuiUpgKr+ZfUdK82UjpUuDocDZwSsBt2YDJFGtrMp5TujTEfNsF9SjER8m+rLUl6bNu3z
	l7njiF8FhzEz2+hV4X3F9V6B015qTPP6kFnYfYfPvEQU72DNGDGska1ipCNBFb7N4PkhUFA==
X-Gm-Gg: AR+sD13HKfp75/mVhMpojnxVKhMFIiIewCWxY+ie+UD1rVAIIzCFTNELrisA+eamTly
	WCbCHoAqQO0cv8WUW72xgzwZ3HZMa4GmFpaO+ScRRiNgceviZ9j4y8FAzatrT5GSPPStpkW9PXT
	gnn0zudDpPM9HI1VhrMIejYHocSPUZAXFZrRcnnfOlGnhHKvaIajSv/IV1TBF9a0XgXTGzDAPek
	eyvD0uZMvZNT9w+QQv1GnKMVJS5NNOD19USAzb9VittwQiMWSnjz4fWX3jx1YStkQlbmSJlhYq3
	QdyuDxi5Knz49+Aq+bILOPbU1i4UfxTBHrqGmyO0VU6+yviN85WYfgpeX/cWXoMC4en14skqcaL
	AY9yCHre+l9h+zNYJ3eIlTtFYqrp1kphk8q18fgd5ew==
X-Received: by 2002:a17:902:e948:b0:2ca:d658:d874 with SMTP id d9443c01a7336-2d0ca961e2dmr184396595ad.23.1786021526163;
        Thu, 06 Aug 2026 06:05:26 -0700 (PDT)
X-Received: by 2002:a17:902:e948:b0:2ca:d658:d874 with SMTP id d9443c01a7336-2d0ca961e2dmr184395505ad.23.1786021525580;
        Thu, 06 Aug 2026 06:05:25 -0700 (PDT)
Received: from [192.168.1.8] ([106.222.221.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867c6a29sm28059990eec.29.2026.08.06.06.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 06:05:24 -0700 (PDT)
Message-ID: <e7167621-56f7-4b47-80ba-ffe45df47f38@oss.qualcomm.com>
Date: Thu, 6 Aug 2026 18:35:21 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: nl80211: add support to configure 6
 GHz non-HT duplicate transmission
To: Mahendran P <mahendran.p@oss.qualcomm.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <20260805-dup-beacon-v1-1-68574869c896@oss.qualcomm.com>
 <d9cde078-ad54-4938-8bb2-51193ecddaa2@oss.qualcomm.com>
Content-Language: en-US
From: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
In-Reply-To: <d9cde078-ad54-4938-8bb2-51193ecddaa2@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=aNzAb79m c=1 sm=1 tr=0 ts=6a748696 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=3IYGOxckUg5mZvWsHK4c/Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=VZlDbt5aG2oc34zNraQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: EyFnpkAw8IbJ3V32cKQ428nYj2FacQuF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEwMyBTYWx0ZWRfX2vcTCPypb1xs
 qZBLNS8VXIYgvPGoEA0HJgjaxuRiNZRl+SQel+m29/9s63gF9yQhrFqAE2BNpuC7SLkPMahjC+I
 d+86CW1n1KsI3No7w+onwJqNo2gTIewsmHfd9C0p4VTvaoigcNxN6oICoxAw7TUuRjCNxfi7va+
 l2UujO/cnH7unInfLWMCvchJml7uZ+gDVgZqLvX9cCQt61E6OjuRTIOhs2MA0p+Z+9UbUr6SmLD
 FtTRFj9jEAhNKkq/AsqgnkYkZW4vKqZRMIhBSyK4XgkYafw8/5bQCpN0NeXbdYgbTaXf0Qleq4W
 RRKpHmeoenfguxb6XKznLBz3nhBvH0PK2Unl7MGe1VlTkwfUZI30k61YZg7EUQyamsGG0o2TfNQ
 27XZ4uNE2RvOL6sxJ+WJzWOZ5Xb5crajIAxxGEsxvmd1Tu/Rx400FmU0uIPJBU01VCz1kBekRSn
 aTRElT0d/A1YWOLROxw==
X-Proofpoint-ORIG-GUID: EyFnpkAw8IbJ3V32cKQ428nYj2FacQuF
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEwMyBTYWx0ZWRfXxgSqLxLJRQWD
 104GWgHGMwrn+SUiINGnYOd5tZwmllWrB+YBa+OQ5uYR4igwYxTD3S6q++3PZ9VgKLCxD8z5Vae
 dWKjoiqxnWlXk+1FQoAmAXcuKEEQO9M=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060103



On 8/6/2026 8:44 AM, Mahendran P wrote:
> 
> On 8/5/2026 2:56 PM, Manish Dharanenthiran wrote:
>> As per IEEE Std 802.11-2024, subclause 26.17.2.2, a 6 GHz AP can transmit
>> a Beacon frame using a non-HT duplicate PPDU, so that stations scanning
>> only PSC channels can discover it. Currently, there is no mechanism
>> to request the driver to transmit non-HT duplicate Beacon frames.
>>
>> In [1], changes were made to parse the Beacon from user-space to set
>> the non-HT duplicate flag in the kernel. However, it was suggested that
>> non-HT transmission be part of the Beacon TX rate settings. Hence, add
>> NL80211_TXRATE_6GHZ_NON_HT_DUP as a flag attribute under
>> NL80211_ATTR_TX_RATES to let user-space request the driver to transmit
>> non-HT duplicate Beacons.
>>
>> Also add validation to reject the Beacon if non-HT duplicate Beacon
>> transmission is enabled when legacy rates are not configured.
>>
>> [1]  https://lore.kernel.org/all/1644914581-21682-1-git-send-email- 
>> quic_ramess@quicinc.com/
>>
>> Signed-off-by: Manish Dharanenthiran 
>> <manish.dharanenthiran@oss.qualcomm.com>
>> ---
>> Note: Users(ath11k&ath12k) of this new NL attribute will be posted later
>> once this gets approved.
>> ---

[snip]

>>       u32 count_ht, count_vht, count_he, count_eht, i;
>>       u32 rate = beacon_rate->control[band].legacy;
>> +    bool nonht_dup = beacon_rate->control[band].nonht_dup_6ghz;
>>       /* Allow only one rate */
>>       if (hweight32(rate) > 1)
>> @@ -6405,6 +6415,9 @@ static int validate_beacon_tx_rate(struct 
>> cfg80211_registered_device *rdev,
>>           (!rate && !count_ht && !count_vht && !count_he && !count_eht))
>>           return -EINVAL;
>> +    if (nonht_dup && !rate)
>> +        return -EINVAL;
> 
> 
> Since the changes introduce NL80211_TXRATE_6GHZ_NON_HT_DUP as a separate 
> configuration parameter,
> should cfg80211 verify consistency with the Beacon template's HE 
> operation duplicate beacon subfield?
> 
> 
cfg80211 won't verify the beacon element status, but it does verify 
other necessary data validations. IMHO this aligns with respect to other 
existing capabilities/operation parameters in beacon.

>> +
>>       if (rate &&
>>           !wiphy_ext_feature_isset(&rdev->wiphy,
>>                        NL80211_EXT_FEATURE_BEACON_RATE_LEGACY))
>>
>> ---
>> base-commit: 6c5fc504d0d6934132637aa3db4b9b58148eaa78
>> change-id: 20260805-dup-beacon-0d074e15ecf7
>>
>>

-- 
- Manish D

