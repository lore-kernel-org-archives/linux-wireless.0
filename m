Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CD12EDD78
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 00:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791937277; cv=none; b=r1ZS/vAk2LqAf4mPlJEK9FwIoRsgrXFWO9w/ynKqHa2A0GtrHTYFDGPldZs4UFzIDZcHT/UJFR7os4vY1k195dByH8iPA/EUhxvZSfsfvVo/18RYDnkJINqrTDEo+OwlNBIS98C6N2hl/btWnkQIqZIjXK4Lu3jZ/dQZJX8lTtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791937277; c=relaxed/simple;
	bh=+tK0b1RAxNQMdQiTT5cRoMWNc7ASdEz1LthT7TUJlKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RYkZbr/xzVdvtbSpHDyvkTIMUCTpR02ovMIvyRgbBdWDoZXAMnb2uHHaQPLWeEbfSPDab52bDzbQoZSQ2ZR/sfhuPPKFlNazu9uoZ/u95S1QDculvRqJSix/UAa0ee61e40aUbRwvJodiD1QaB9wPgolcOzPkae0xVS5/A4FcrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Do8chB8t; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FYKn/caF; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Do8chB8t";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FYKn/caF"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69DKGjhe442764
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 00:21:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uxk3TbtCw88JdAOdSEkADB0LBJ9HmN0IwiUJsngVV5c=; b=Do8chB8twnjrRnAX
	C3eCZ7CFWjJNFOR8gTb5p/Q2oc2zNKlZbB37QhA0ZHt3Lb4nSAACLrEgtkNdpGQn
	2qDF0m8pGmTn9XGXCFPnio+D5Dn5urH+MLl6/x4pv0LjsxuvxCfH8ahSAkoEIIGp
	4NjBm9jI/r8Tg7kwt9dTnnyS0LklLwnGE/e/wiPwNHsRh0p8KLP+dkGTl3OyexZa
	xuVt33bR5mpJ5pfrfyPbKDR5gcqT8e5mHpVrT2W+1Qg3G7cbYZpHXGAjmOxLHW1E
	s2jsXuOhO9oPIgV/gApYW13GUUvGLNbT7LphKo67eDLiyW/jqwFmVJSfBEiEaW6n
	QZyHzA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9n71jrr5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 00:21:13 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-35cbea41088so673391eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 17:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791937272; x=1792542072; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uxk3TbtCw88JdAOdSEkADB0LBJ9HmN0IwiUJsngVV5c=;
        b=FYKn/caFe5TPM3I6qlarBJF3kzNQEXEUX+Kv1esDvp0lmiVqI3tlxz7J3HOqLzS56J
         UznjShJE6PyVPro156bK7TL1kYvgl8UUkBNway/fZYGduzkwn3ar/u8lnt0+zQZtmJt3
         7RTRQ0TcWkF2s311EXh3F6AWLE4ftttGBJU3tZGFLZtU30S5aO/3/S6Uhp1aVcJ2n+/Z
         ZLxBnhL3yrSk3wm5Ob9vwX7uQdxu9AMxH8Q/phvSeEck8gugHfaxBxwqpEAYaukPVfly
         CaCwXdD3y6QtSjOtBix+EbcByfF8IN1XLdh9mmPhWNyfmCvX1Jyb5bo7rsUO7zUNYMyn
         MPhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791937272; x=1792542072;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uxk3TbtCw88JdAOdSEkADB0LBJ9HmN0IwiUJsngVV5c=;
        b=hN++l2UkymKZKq7hZg+CCYiWl9ZZ/IBYdQfB3lmPgYD95cjAMAJwAnbBTqddlmZ8m3
         4zn/8EceM6bD3Fv1H+fycvQSCqh9yZDMixPXSTh9Chl/7GI3HBR/cooUVOhlIta073qv
         ++OQ/brkbA50uhIYXMTMGKimpPNSZS+IMSvkOKvH7pkQlyXzI5xeQFPpqX8+jG08jA7Q
         5xBBqE4l/YxV1Z5wiKhqMutIr8SoOIr9pY6CACqgF7DaSAOnW2Ry83Vma2hVwjG15ilS
         Uy2+2dBa5Ofg1EYJVTD5ZFIuVrC9p1nq9OJfVqFxfsJtbCW/MGwmxuJNU7496d8FXZ3z
         cFcA==
X-Forwarded-Encrypted: i=1; AKwUvBzyjyR9YCo7pi6i1k96mb87FmG42PtX2YjG5FWkXjOMCEYBzongPLGvttFCrLmN3J8iEPZXKAuffB2wkAALEQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYL51D/HT4nk9Dz1Rt5IMf28oYrbqAs9Bi7IzgHmRPyeP7o/VzVT
	CMyQg28IrJ2rzywIlx4ORXIjRm1unXVFrFci8jd2MfQDOC1fntQYG5/VBlfZRtvgw0dodVlAY5F
	e2nVCCiIv99X2ClAxLLEi/OQ7fRSlfzxCT0tEL+y1Gk2TQSg2rf9QjRN/aQQS/A2JWSQnOw==
X-Gm-Gg: AYBFou3Q2SZ+oGCDIeAyRCgHIw0vrvVYLTpM9AcNE69n32aXmftbaX/+nGhbz/snFT3
	LYaWvlP5FjgkXjp/vMQSr4u74RIUOiWgS5Kd7cDZ2VjvUM4A1GxV98LZlUnFOQadKtsrSxbOVLr
	IRn8esFPmDU0hZ1tvBGppH2X2ZQUHbFnB0x1JOhzrWnMomRCW/HdJ8BiEJ4N6Zf4jdFjb5BaTRh
	F0ghv+jvNodjdcgNOfJmIcxsTn+kLT3HNrljSDSG27n7qok7wiYaiP9/2vpXMwYjt20jyOJXcEa
	+a552pv/qwS/CID7Pm3znttjaoplZC7a6BNdr7ExmTUO8vWfNinngpIgBFhas4QLe1tmtdI0Kz0
	NQs1IXHSyH7+exsUKVb7xLmlvYQGqsr4mxJC5jE7cGc2VL49uwWYs9tDaZw==
X-Received: by 2002:a05:7300:d209:b0:35a:47ed:c39a with SMTP id 5a478bee46e88-35a47edc590mr10691798eec.37.1791937272092;
        Tue, 13 Oct 2026 17:21:12 -0700 (PDT)
X-Received: by 2002:a05:7300:d209:b0:35a:47ed:c39a with SMTP id 5a478bee46e88-35a47edc590mr10691765eec.37.1791937271328;
        Tue, 13 Oct 2026 17:21:11 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb68e56sm42940011eec.29.2026.10.13.17.21.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 17:21:10 -0700 (PDT)
Message-ID: <bbd65b93-816b-427b-8abe-1d1fd1cf4e70@oss.qualcomm.com>
Date: Tue, 13 Oct 2026 17:21:07 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath12k: fix frequency range for
 single-pdev devices
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Shenghan Gao <gsh20040816@gmail.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260715065218.41232-1-gsh20040816@gmail.com>
 <5ca16013-e8a0-4403-a2b3-b3b43ea2bb2d@oss.qualcomm.com>
 <CAMVcGaDKC626A6=VC+10vtw3KVNm2NM_yPXTbgnA9Efd5eyL7A@mail.gmail.com>
 <9dd4e992-5810-429f-bc54-036c4eb276a7@oss.qualcomm.com>
 <b4fcaa4f-8c4e-4fc0-898c-6c97e1446323@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <b4fcaa4f-8c4e-4fc0-898c-6c97e1446323@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=FuqQbGrq c=1 sm=1 tr=0 ts=6acecaf9 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=Xp_5AQX54b4_orL4JKgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: j7NtJtL7DYMVXbXN1yiK7DZJJHK2AP0A
X-Proofpoint-ORIG-GUID: j7NtJtL7DYMVXbXN1yiK7DZJJHK2AP0A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDAwMSBTYWx0ZWRfX1iY4CqjprB5T
 WIL+LUV+8kLU2juDs7U7MdlUB6chtTTD/ei8qz8Qd2KjQ2EufnVrgKbpEFeECMwpf2Qxwp0rANu
 QqPE6dj4SmGdhCUSY1B3qkUHlypazmh/wfPASiKdH+zPglZ8EJR+riSx4KamQOPRw7hej+m5yKx
 8ENN7k4oYjQeAd670jSB4d1cmOQbL5uawRNyRhSVJgH1ojTAh18uFT22B2JJsYDwb/0yh/AMSIr
 BDNISt7rTuVlYbSCdGdSOTb6bnIFJsY7PKhZudo56xslb0dJH6XJW2TIX5sU98XtRI1aWstWWjW
 nXEoaaOlujYWo8Dwvz1i653uNVhcEf2LZLACv9FZN7GnsEaRY0H2NJfAL8j/Y+RhTY893zssTJP
 ObZMYuz0/JZRA8Pdyce3lEOXVgFRZT1yJixNpsN4V2kjZ1HkCpe+UT/8MXTriYLkPLBK01itiMe
 iOJxlc3AFUIQdo9Y83A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDAwMSBTYWx0ZWRfX9R7pnKt5DCcX
 5R6lJ+xM9MqRSzXD3S0i6nze5mgEUqgjjTWezRFdtxftkoaLD8M/hXRyQvVohrPxd7xUfRJf6u+
 5c6334siU/b7pWurY5iTg7F8EZEKOUc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140001

On 9/9/2026 2:46 AM, Baochen Qiang wrote:
> 
> 
> On 8/3/2026 4:36 PM, Baochen Qiang wrote:
>>
>>
>> On 7/20/2026 5:25 PM, Shenghan Gao wrote:
>>> The update sequence is as follows.
>>>
>>> ath12k_regd_update() first resets ar->freq_range to zero. On the
>>> tested WCN7850 under the CN regulatory domain, the 2 GHz branch
>>> calculates a valid range, so the first call to
>>> ath12k_mac_update_freq_range() sets ar->freq_range to 2402-2482 MHz.
>>>
>>> The existing 5 GHz branch is skipped because ar->supports_6ghz is true.
>>>
>>> When the new regulatory domain is built, reg_freq_6ghz.end_freq is
>>> reset to zero. Since the CN regulatory event contains no 6 GHz rules,
>>> it remains zero. The 6 GHz branch therefore calculates freq_high as
>>> zero, and ath12k_mac_update_freq_range() returns without extending the
>>> existing range.
>>>
>>> Consequently, ar->freq_range remains 2402-2482 MHz, and the subsequent
>>> channel-list update filters out all 5 GHz channels.
>>
>> Thanks, now I get the root cause.
>>
>> However the change of this patch looks more like a workaround rather than a proper fix:
>>
>> Current radio frequency logic has been architecturally wrong from the start. Ever since
>> 657b0c72c4ad introduced reg_freq_*, the entire purpose of this code has been to compute a
>> per-radio frequency range (to advertise each radio's own Frequency Range to user space —
>> Idx 0/Idx 1 in iw phyX info). Since the quantity is per-radio, reg_freq_2ghz/5ghz/6ghz
>> should not live in struct ath12k_base (per-device). Storing a per-radio quantity in a
>> per-device field is a layer mismatch, and every problem below derives from it.
>>
>> Two problems caused by keeping them in ath12k_base:
>>
>> (a) A cross-phy race that silently drops a range. Firmware sends WMI_REG_CHAN_LIST_CC_EXT
>> per phy. build_regd() resets all three ab->reg_freq_* to {INT_MAX, 0} and refills only its
>> own phy's band on every event, while regd_update() runs per-ar off a workqueue reading
>> that shared per-device state. A later phy's event can reset, e.g., reg_freq_5ghz back to
>> {INT_MAX, 0} before an earlier radio's regd_update_work runs; that radio then computes
>> freq_high = min(high_5ghz_chan, 0) = 0 and the range is silently dropped by
>> ath12k_mac_update_freq_range(). This is a real shared-state race.
>>
>> (b) It forces the ar->supports_6ghz proxy — which is where your change comes from. Because
>> ab->reg_freq_* is per-device, regd_update() can't tell from it which band this radio
>> covers, so it falls back to ar->supports_6ghz to guess whether this is the 6 GHz-only
>> radio. That proxy only holds on split-pdev; on single-pdev (one pdev covers 5+6 GHz,
>> supports_6ghz=true) it breaks, which is exactly why you had to add the || single_pdev_only
>> exception to rescue 5 GHz. The awkward compound gate is rooted in using a per-device proxy
>> to decide per-radio band ownership.
>>
>> Based on above, I would suggest making reg_freq_2ghz/5ghz/6ghz per-radio, in struct
>> ath12k_pdev. ath12k_pdev is the driver's canonical per-radio object (1:1 with a radio,
>> holding ar/cap/mac_addr), and this operating range is a property of the radio — so it
>> belongs there, right next to cap (the HW freq limits), which is the same class of data (HW
>> capability vs. the rule-intersected actual range). Both problems then dissolve:
>>
>> - (a) is gone: each radio's range is isolated; a later phy's event can no longer clobber
>> another's.
>> - (b) is gone: the gate can ask the ground-truth question — "did this radio receive reg
>> rules for this band?" (end_freq != 0) — with no supports_6ghz proxy:
>>
>>   if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP &&
>>       ar->pdev->reg_freq_5ghz.end_freq) {
> 
> Shenghan, any thoughts on the suggestion?

Working through my backlog. Is there any action on this?

