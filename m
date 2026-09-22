Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FAD3A4521
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790073299; cv=none; b=PAA7WTJAcgyDKux6hVRvxqUzgJkHbMnfEE3LbK68zkR4apyin2R8JHnHko2cn/aP1mO4t7BxEnPSvFhgxT9VIiV7+jKIjVmXmjk/SVjX/PTVDf6+w2RboBhTTeIjn6PrfD4vHAyTPZ4s5cCieToLY1325Tycij7spsEt9OCOo28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790073299; c=relaxed/simple;
	bh=XO+FI1tvpHWdCbjj0csUD0G607J8vP2lGPzEtMSBNb8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k5IUjiPuXjjGza3+mQGECTASq1Cp3/z4kf/yWdnxuBI/Qtg+VeFQg7adUDZph3nH2r4maeS0YwEITHBmUicqISY8PPFd4wZ+ShpyZU1MqaNl6sJbTFaBRTpsujBwlhxIbG8gKBNbsItUUwkBzvo40JMt6XhsRUeMU4EeLFjv3eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NOgxHJQC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jHMrfKYs; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NOgxHJQC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jHMrfKYs"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68M9WRWl1842270
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TBHydZSyrHff1ApJ9bUoZm9nBCnkiZV5DuxO7M+8nK0=; b=NOgxHJQCsYAwIuOM
	V+zrWwvmFYfGSbq0d+FsFo0WmXqVRidxRBwOMQvWtWu9uoEC3v0dOMNIypiJqOwh
	V5cJe4aL/e60Rce9D+rGpyS5CACnzj0lI5Xz8VtimArMBj80RxIyScXml7GIc4ls
	Ua6+on0W00It1j7Meb+R7iZj6LcpHaFrri+p2NkBc1h3usT1gTXA3V6FwameWBEW
	yYEF/QCgDziGpNcqIKQV9lNYJAsVqRikSDUzmga7pyF4fuFob43TQAQb8ndAlCoS
	lwgMWxdpFFdda4LS7SHeggep0z5ofH1LPxQqPnoBUbkMqPoZHYwPS6y4Ovsh1Z5H
	LEViLA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guj111gq2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:34:54 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-86b70a52946so6347214b3a.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 03:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790073294; x=1790678094; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TBHydZSyrHff1ApJ9bUoZm9nBCnkiZV5DuxO7M+8nK0=;
        b=jHMrfKYsqRgmk4ClMVnSV6uTbzVA4nwk71E9B3/0tfQ1BhgPVX/5M7K4rO+ao6StFl
         sT1qBQkseE2joiMnh4K4OPTyjbbHZ3GJeNE1/MNSpU4FSmXTrQDwIAEXDSDL/8VxJh2e
         c7KRd1NDEjWa3TpbLHLRD9nbT9bXX6FMs6/te6e2W7zLgmt8JElyFFNqrdbxgPadELF/
         ROavnnluhha2chRKznQsFHXKRm/+n8oKWgfmAhu6nto9rgy7OTWgAH9Js4vUQByLQ5nc
         R7wBp0eUWYG8gn0hZwuRC9WCZm38xmetanOlku5wLbQA6P0GSTMdPP4ziLGx5wuvHtY/
         YFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790073294; x=1790678094;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TBHydZSyrHff1ApJ9bUoZm9nBCnkiZV5DuxO7M+8nK0=;
        b=0A/Ig0nx/Ru4YhzH+AjojIsOk0yu19nJW4KRPSlmHs7dB5fbKl1vF6TLRnTevy86OX
         5NsavtWpa1CjHRPMmJ2ERY6QE36aK3meCaN8RALUih7s6peAzk/Q2om7yEuYAhpCByvy
         WCIyy7+sFwrwg6HKnksPDBEIhygH6fXc23zwOT5egJ1eMatkJIQqkWOZ84eU806g4Zs+
         tx7I69b+4G9AOUTC8VAAMVW1yKub1Rr5+4xJx6qXjbRMW+z76PEqOMLZSJHZoYWgNM9C
         xg5vzLsnco1w0E54/wgK/U3LhPnwY73gwLxCuNiq8aYsqfvaJYrYrDzvJ/qciHa6ke1V
         DBYg==
X-Forwarded-Encrypted: i=1; AKwUvBymt+rzqxEuoygIc+eRboe6nQJQWV2g8bcGWUzUqKpmYJmebmdWJSIhBLppWBphpdfgHgOBg/jnAc6iqXrTDA==@vger.kernel.org
X-Gm-Message-State: AFuF++lR89nUn82mNF29H3ppoyMOQLMGLfyV4697xAM8geCRFRnDzxTM
	0DEot8wMNZzhM+5yPFLUqMCHH3fUhZY1IIWD++F+eECLzY+jFE6tVGluL96Q+93JI+3hqZVSXfU
	eKidgxceDz9Aw2Slp+RuVOxJS586kVWZASb23mdUbBpOpCxkVVpZA80wSh4c+75fA7e05Tg==
X-Gm-Gg: AYBFou1eI044DpS2s3xSfwSqqxQ8WSWKjh20v71QPQi4BzxhiZOn+fkduy0IZkbCjXp
	BTkIIptXK9/7513CNHoB7p6mFY5z2oAqIBur817yK0d6iGY7T3xpFbGvGACjZppwszrYCG69Qi4
	ZzazWQsD5GLrfqWhriMfLM7YjBjbFGYu9XQsnAiv2/fvgK25BQIZ7mfZObD4NXKuSaGZeuoRtnf
	GMivEIoZEqWJlJvPIFJ6+9Nmzp4iDg7psv7s8r5QVKVdJXTlND9THnhdTL6KHcT8qwrY6heC4dP
	BuDX8ABD+A6x3onUFsi40cvuOs+IZNHLPKh5qG+/g3LWFFx5jKuoEHPwELZcMoNQxOSciZ6GOpD
	/LEqRvVMUxBPIogryONyfNeHqKTOqR8TmfpqQscGOYu7CiXOgMSsE8jWYQNw96N+sWgeI
X-Received: by 2002:a05:6a00:1152:b0:862:72a7:eb59 with SMTP id d2e1a72fcca58-87c81bb7802mr782690b3a.4.1790073293513;
        Tue, 22 Sep 2026 03:34:53 -0700 (PDT)
X-Received: by 2002:a05:6a00:1152:b0:862:72a7:eb59 with SMTP id d2e1a72fcca58-87c81bb7802mr782654b3a.4.1790073292817;
        Tue, 22 Sep 2026 03:34:52 -0700 (PDT)
Received: from [10.133.33.151] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87c32ea8d7bsm626000b3a.43.2026.09.22.03.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 03:34:52 -0700 (PDT)
Message-ID: <d38ed0b7-c9fe-4958-8abb-ddc7900350ff@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 18:34:48 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v3] wifi: ath12k: advertise interface MAC address
 pool
To: Vitor Soares <ivitro@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Vitor Soares <vitor.soares@toradex.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        baochen.qiang@oss.qualcomm.com
References: <20260921173033.846332-2-ivitro@gmail.com>
 <974e540d-d6e2-4ebf-8714-98e4056083d9@oss.qualcomm.com>
 <c30b21e218bfb00a1eb3c52ea0b7c9f0dc828592.camel@gmail.com>
Content-Language: en-US
From: Kang Yang <kang.yang@oss.qualcomm.com>
In-Reply-To: <c30b21e218bfb00a1eb3c52ea0b7c9f0dc828592.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Ji5A-gfmdbAJgkuz4XSfp_ggtayrYhB7
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE1MiBTYWx0ZWRfXx2TLPL2MwI97
 G+kKrBf4MPjxT/Xs5lgViFn28xoNbt0ME5Ug99tpGR0WTxCgYOdgELKrWiPVtyfYimyspCTRxG7
 fpzhleV8JoWRROASxfKrnXGZD+tEpto=
X-Proofpoint-ORIG-GUID: Ji5A-gfmdbAJgkuz4XSfp_ggtayrYhB7
X-Authority-Analysis: v=2.4 cv=atQnmiZV c=1 sm=1 tr=0 ts=6ab259ce cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=m8ToADvmAAAA:8 a=EUspDBNiAAAA:8 a=W7MpxnUmcWWQ-iNiEcIA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22 a=kCrBFHLFDAq2jDEeoMj9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE1MiBTYWx0ZWRfX00SbaJYdVe7n
 D8NhXWsafW3mfkwKSYbslCZoG9NlQ85/MRXAAVOqnE3ZoIbTiXkUvPXhAGSCUycvLnXVlSU7Fog
 eB//uR/0jXgr+rkHj5BFiJjymSiPRgLXTTWLV8TfQDV6NYVSOzBP848DpF2Rez/PzbyZHZ0w24c
 +NjrPPIWVhV4oToB3MhloWKZilGxkdC1o3AuL2KpcM0qAUm2ttrHXnDMOijAwZiPgYGfrtoiCbU
 CVNpZGVLSD8W7a1flBeo6hueDUb5LNT+QF7/lHZ+AGm6GKLF52aRhRRaBgVWIEX6AXudzkMI30y
 SPYawA19VM+KfJvWRFGpZrAtBXx2HnHkQh6gPrY5eEZY6P5IhV/hqltqQwSjhDdwPdR9ffNwIx0
 IT7hd/MPdAgomRt5eDm1naYSv31lA+TVRBx2i3qC1Y3PQ79/zP9kKV3vliu7M3rUoX8xr0RWfa9
 DHXM6L9qDTqdRs0KZSw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_07,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 adultscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220152



On 9/22/2026 5:29 PM, Vitor Soares wrote:
> On Tue, 2026-09-22 at 14:13 +0800, Kang Yang wrote:
>>
>>
>> On 9/22/2026 1:30 AM, Vitor Soares wrote:
>>> From: Vitor Soares <vitor.soares@toradex.com>
>>>
>>> ath12k supports creating vdevs with addresses provided by mac80211.
>>> Userspace can already make concurrent interfaces work by explicitly
>>> assigning different locally administered addresses.
>>>
>>> However, ath12k does not advertise an address list, so when a second
>>> interface is created without an explicit address, mac80211 has nothing
>>> to pick from and falls back to the permanent address. If the first
>>> interface is already running with that address, bringing up the second
>>> one fails with -ENOTUNIQ.
>>>
>>> As in ath11k, provide a list of usable addresses so
>>> ieee80211_assign_perm_addr() can hand each new interface an unused one.
>>> Keep the first entry as the wiphy's permanent MAC address. Generate the
>>> remaining entries as locally administered variants by changing only the
>>> upper nibble of the first octet, which naturally limits the pool to 16
>>> unique addresses.
>>>
>>> The cfg80211 definition of wiphy->addresses does not specify where the
>>> addresses must come from. Some ath12k platforms use it as an interface
>>> MAC address pool, while others use it for firmware-provided per-radio
>>> addresses. Gate the generated address pool behind
>>> advertise_iface_mac_pool and enable it for WCN7850 and QCC2072.
>>>
>>> Other platforms keep the existing behavior.
>>>
>>> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-
>>> QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
>>>
>>
>>
>>
>> I just did test on QCC2072:
>>
>> root@yk-Mayan:/home/yk# sudo iw dev wlo1 interface add wlo2 type station
>> root@yk-Mayan:/home/yk# sudo iw dev wlo1 interface add wlo3 type station
>> phy#0
>>           Interface wlo3
>>                   ifindex 6
>>                   wdev 0x3
>>                   addr 22:03:7f:12:be:cd
>>                   type managed
>>
>>           Interface wlo2
>>                   ifindex 5
>>                   wdev 0x2
>>                   addr 12:03:7f:12:be:cd
>>                   type managed
>>
>>           Interface wlo1
>>                   ifindex 4
>>                   wdev 0x1
>>                   addr 00:03:7f:12:be:cd
>>                   type managed
>>
>>
>>
>>
>> Tested-on: QCC2072 hw1.0 PCI
>> WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1
>>
> 
> Thanks for testing this on QCC2072.
> 
> I've added the QCC2072 Tested-on line for v4. Could you reply with your Tested-
> by so I can pick it up?
> 

Tested-by: Kang Yang <kang.yang@oss.qualcomm.com>


> 
> Best regards,
> Vitor

