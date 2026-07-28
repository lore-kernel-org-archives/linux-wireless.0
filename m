Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BD9432E72
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 12:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785241476; cv=none; b=OIUgqmha5DGIOOSyAG4KGIt9EP9UfKMp1u0l/Q9zJr2Eel73fUoxD56qWPdf143Qqqh5LUinaF1YoL6iNPSR0zMXc7KoIIZOZhdTujXvEMUNndy02dWpqSlDCsxWSdYL77oNT5MC8nO+jvBBtxPAkYmRUjYLuYrHWDdbveWuCc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785241476; c=relaxed/simple;
	bh=qI5eOeU5VmAlid52E6Ap5Nmzf7ZYOtFT9i8ms1iDlBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SyBBp/EHa/CbyUW31Gp5ourzr301yZxGoUpDqA/ay7cb2a3mLmp23BEA4hqXqoUytr+pE49a7pHHLQsIpv25Rwc/YJ3fZ/QM9w8bd4Pg+LAFR6tFwNKP8X7uJZ5PyGlZBqzOwsQL4UmACDrZgDPdPHbkbtt5QFzVnpTtH14M8KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=N3JMg5N7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JV9DmzYu; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="N3JMg5N7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JV9DmzYu"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SBHCbe2121263
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 12:24:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BOuGRv14cYKG+wn2zmuxiqHqCSQOTP9wT54dUBRfhf8=; b=N3JMg5N7DrJLrCjI
	foTumEjALLWc4ddbD9S1BqnTLMbUjPeFc8BdezY1TfRx/dr46jy/GcpXGd+Nr+Dw
	JgMih4wwg+KbMk4fz0Ka0K9XizmWyXv/3RQPbYUNs0LkkJEec4+cCOGWnoSDZWBa
	Xh0/5fSSnlTWxkLXm1xjJYRnn7F8y6y7RMMdewLyVhgHcrXwm5MirJyAIyVI5wwn
	+LoLMz6uI1czLhYmMK4+Gpq+lJnqdaMVlc0xA+b6KHYsBDAUpaI/Fnre8xiz2Izp
	mEUb8oDbvXMExTffU6IYiMWIFcYS5TybAXGhn0LBhaPd1LLUsBg/KmznsexZT96b
	lFVhgA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fppttsh5m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 12:24:34 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso4506906a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 05:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785241474; x=1785846274; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BOuGRv14cYKG+wn2zmuxiqHqCSQOTP9wT54dUBRfhf8=;
        b=JV9DmzYutT5crwfsyadzlOLdYSeLDpagfmIaimnBveOBnWdVsmY65Ofa44HYbgxcn5
         NPyg/x/FpHG6sAhJ8p0d438dgFgiiwPPJNic4mRvWEmWeUV8+r5OuZqvGkIJEBnxruac
         K3pAecqyCAlzzduZKqiBZz8yu33la0zUBT4Le/Du5RJZxRF39WNKTX9r1gr9h34XAGyH
         PUlZqzhI+KztCcOozVAhhZywumRL6JyNClG3xpqF2VP1ZFIM1+EHdx154uPiPRl5RNsI
         utx9vjwvcuj5S0mSsIxt+UvEMwz+c2ZhpCzfMKV4l9e94mrPpuU0XUlDkNd3JIhrt8lV
         UabA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785241474; x=1785846274;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BOuGRv14cYKG+wn2zmuxiqHqCSQOTP9wT54dUBRfhf8=;
        b=AVAzZUMSKxmhblG4uCV6OSKr7ZyCU8wjpmpEl79A8xmj9aq6aukbnoKmIlBAOMWo0K
         Ce3eZ59DmdGPiqfuCumRaEeeoCXBcVOaXR7knIMbRYK96NooqM1OEMsRDx0sMB4l0wMd
         7FqOL8SH1taktP3R+w0ZewNSNzfBV4DnBdGksdVKLyH0yL+UVrioTFJX3dl8l8ArlF2l
         WGtq5RwQI85Ai30+brbAj5pXQYjgAuMIm2M602yYkXWYtCz/X1qVNSdmn51vvqewR4GW
         Is6b4Ub5Z83Uq7gVL7P7SXZcKmok+dUz+o0xHVTXoO3GoJCCanFBZAPlZl9SVA4nEo2o
         KzZg==
X-Gm-Message-State: AOJu0Yy0Z7mxQsKgKl1N3rETxfTpSBmftJY4ixuSBksfo0ZKH0ecB5q/
	2HxhXjZ0h2FY0ot5VvV8bo2GoE0HjULthtDLfgRIIOcNGln0MC4rSlUx7+VxJ27JCxnq2U5cfQ4
	B+hKGGCEMnTFecLoMK/UUuNMq2GNJAtie6zzpsyy36vuuQaxyDYZcB4zvvhIN73Vn/n+YDg==
X-Gm-Gg: AR+sD10tp0yJhb76EAN9pFQL5e4watNjzRUrC9CPCmu+yVK00szamPuP1W/lk2ZAqBF
	5Y9LlnFaXgJxz5csY7GoE4wNZLh/3boHXm52uYwgllX0fgLhArRWwwbFhulnGHWOFrjMoGgDxBi
	HOQ+AO34V5TMGH9MCGt3QwN9GGff053/pwpNQvIpTWdGxKuAOS+rxQkhlFoYUHwE3hk5zQ1wizz
	1M6UYg4jsFD5t9N59LY8k36ldcUQAV3VxpC5GOBzEwxOeTwMh9xNhMF+cdcUZphmygXk+LprcVj
	yOJVbHARTcDOWTl/4fm0GoEXluxenQU8fcx3lvZvXuIx5UyEyX1JhC4LyGEj+O2BJq6TwZF/STI
	fWR2qCqcFaa8GDJOC9ZO4QVO5fhpYnZM=
X-Received: by 2002:a17:90b:1b06:b0:387:e0bb:57ff with SMTP id 98e67ed59e1d1-38f6a4810c0mr2405814a91.38.1785241473633;
        Tue, 28 Jul 2026 05:24:33 -0700 (PDT)
X-Received: by 2002:a17:90b:1b06:b0:387:e0bb:57ff with SMTP id 98e67ed59e1d1-38f6a4810c0mr2405538a91.38.1785241468283;
        Tue, 28 Jul 2026 05:24:28 -0700 (PDT)
Received: from [192.168.0.12] ([49.207.202.171])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f6414383csm1225455a91.13.2026.07.28.05.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 05:24:27 -0700 (PDT)
Message-ID: <b0265df9-a937-48c8-a191-061077b46f28@oss.qualcomm.com>
Date: Tue, 28 Jul 2026 17:54:24 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 6/8] wifi: ath12k: track per-ring RX
 sent-to-stack count
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
References: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
 <20260723125448.922361-7-pardeep.kaur@oss.qualcomm.com>
 <c455a465-254c-48e6-9183-7b67d4b76dc1@oss.qualcomm.com>
Content-Language: en-US
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
In-Reply-To: <c455a465-254c-48e6-9183-7b67d4b76dc1@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDEwOSBTYWx0ZWRfXy9xwof5fY0U8
 U8O0q6uay6Wd2ze0vSuWQNOJFuPJ/F2AidKRj7/xxg8qfgflgARqe8JghJ9KLJk7Z2ODc2jroLc
 6iVsMnLvPisqp/9xfeYPuSBb6305X2w=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDEwOSBTYWx0ZWRfX2omAu34jcBO5
 HNdRLuBa7HS19OjIo+dn6wtN1iwBIdLy7kyjPsktcyc4LiK5c8NmDwrTU6IZ69DdUS+D6TDG8tj
 iOf5w5iwLAIVz6X2c3YQviDWnRyEoGtT3PncsEbftpfbFIZLPrVoOQCx4QWmRdtpJ1J4p6Vqxen
 hRaNSULko+J8wv6EoWJxhHU0EvAyH+gGkC1VPhWY53LMTPO+7oZdkWxRA8htE/pvLE5WxHNlNzz
 cCDONNBqpFtAfmNEf/CdQPSsVUhqsS7tBtx6jEWoWGUOYt5mhiDKrdkPUIyo2yvCDCGXpPpJG1I
 i6aUYTfRUMe6e8Mglf4Uo2er9Mcd/mNDULMwxnuvtxeAYNEpEbB86PTemJFY2FmZd8IlMlTXqJ1
 ZMw0i9cpVUv/SYkARrRsVzAQkeKEHK57Qq5NY1t9JowMOz1K7IPCoU8augv61BX05654WrLSr7F
 s1DeJwcDUHM+1H8aSNg==
X-Authority-Analysis: v=2.4 cv=aa1RWxot c=1 sm=1 tr=0 ts=6a689f82 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=wDio1FLaKedB3uI5tWxtsQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=5FGsjyyMLv1_ifA18zAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: 6EE436VFdCUPtcVzJpZ80dpsLjhNLvvX
X-Proofpoint-ORIG-GUID: 6EE436VFdCUPtcVzJpZ80dpsLjhNLvvX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_03,2026-07-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280109


On 26-07-2026 21:41, Jeff Johnson wrote:
> On 7/23/2026 5:54 AM, Pardeep Kaur wrote:
>> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
>> index b203513d63cc..33c4c89eefb5 100644
>> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
>> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
>> @@ -651,7 +651,10 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
>>   			dev_kfree_skb_any(msdu);
>>   			continue;
>>   		}
>> -
>> +		if (likely(ring_id < DP_REO_DST_RING_MAX))
>> +			partner_dp->device_stats.sent_to_stack[ring_id]++;
> My review agent had the following finding which I did not try to validate:
>
> sent_to_stack[] is incremented on partner_dp but reo_rx[] is on dp — this
> splits correlated stats across two devices' debugfs files in MLO
>
> In a 2-device MLO group, ath12k_wifi7_dp_rx_process_received_packets()
> increments partner_dp->device_stats.sent_to_stack[ring_id] (the msdu's
> originating device), while ath12k_wifi7_dp_rx_process() increments
> dp->device_stats.reo_rx[ring_id][device_id] (the ring owner).
>
> Reading /sys/kernel/debug/.../device0/device_dp_stats shows reo_rx[ring0]=N
> but sent_to_stack[ring0]=0; device1's file shows the reverse. The two counters
> meant to track the same traffic path cannot be compared from a single file.
will handle this with adding the device_id and ring id
>
>
>> +		else
>> +			WARN_ON_ONCE(1);
>>   		ath12k_dp_rx_deliver_msdu(dp_pdev, napi, msdu, &rx_info);
>>   	}
>>   
