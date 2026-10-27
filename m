Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793062057;
	b=XXkWLQRWlAxi7sJMRIdWyVGA3h3dpFT8IjovHKQt/S2rEfnrlUEGdsd82h6Og02zAife
	 iwAW3h3TJknKtlNWalVgQbwMVPBuaf1qW8dMgob+IsF1MmrK12VmTzfszk++MqFOalXIo
	 qPVJ1/8uhlql3p0yfFl+dM1EF48eyfQgrV/jyN/s8No3NqEcOfZeNa18GDuCmGxEhE0NJ
	 TT3aTgXY7WZcmdykBPaPH2gkQsx7fqlPdhu/SMouCGhc8W8zE5YPRQbmuJ+m7WuNjj9D/
	 asB5QC5CiPQogj/6rysLX7yVH7KZm7YLxsARiRBn/TOGFk3sMZh7R/27dq2ug5M1opA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793062057;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=0JwiV77TZFPsGwYE3NQZqCj2nzgHeX9j4cZirnnqmRo=;
	b=jhmcXT6twiTlJjkq3Z8FVa+oUOgZY8we+ck86OR4INmTod76C1P/vjRIEjDw21MwObhm
	 YqX6Xy+jKZt5wFcZM6nhlSImOx2J+MRSq8KEywxiQmLJ4ZBi3kmoAe1kGZiDrYFomtlM7
	 /wcBUm3G3A0ap1QcG7Dz6XihBW3o8p3xbwZ8/E67vmSxhSUMlOgSWPEFNHLDY0WvQyZ6V
	 Sthrr/64gHoVtfhlleT4DMbdQ47ZY70ucvY6i7IxQTVmuQB9IhBHmdQCo4RZgd2rS53lc
	 2TrRJAMma7ChrYgRLWO94bb7k+nWBxQloD2R5Ua5+Xw41CvmjtNWrjomMZfNNrMexxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Y037Lem4;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=iqoSe4R+;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4681606A31D
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 00:47:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4681606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Y037Lem4;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=iqoSe4R+
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QMP0HJ351692
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 00:47:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0JwiV77TZFPsGwYE3NQZqCj2nzgHeX9j4cZirnnqmRo=; b=Y037Lem4XbcYDRHx
	N7xk1Q+i2uzWcHZApOM30dPCzAuOJPbeqV9T8Ms/lfqgEUJ52nIOXfP6UOGjtbB1
	Nmm2MARYkg5ugoLJ1FrpSrFGmQneQuP+hjMX32bKtGyj5d52kMMrc82Pjm6UFZkC
	6CAeuwQ3v57aUUmILBBDzP9j3atsu4BfmhVHh6RzI31/kGqhhoyXreUBWfgfddLE
	0fZrl31/+9xSyRGpEvmJdfh1qUdpb0gWFLwCZvbyAQccaDCcnUjpqOnZUwIBg6Sw
	12Ui6jCdnkVefJkLiZvCOl1Y4NmLzIei6tI0kH4h58KpbdvQ0AqProqE5W3DCNew
	9TRbEg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjfavrds0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 00:47:35 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-351788121cfso61619eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 17:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793062054; x=1793666854; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0JwiV77TZFPsGwYE3NQZqCj2nzgHeX9j4cZirnnqmRo=;
        b=iqoSe4R+P/k0reXGNEowaRUkKEsrodLNzFHUGjksFK+nUO0zsV8gPA0Az3uTVnZAhq
         3OanKtje9NtorBIpgZMlZ0PPnllcmR098DOdM0q4+KfZAnNOFjmimtdeZBc728KIGjN6
         p1XL+7VH6iS+l1jTATI/eKEPyCeOR/O/cLr2Ed+aHy7Wh8wH5uKyKurBNUQkvqFPcgzY
         +K4Z21+gSV99pCrUgEtdYqwmCSH94dN2sSwL36zLrM+OPjs5wQEvucGUUJANM+/rEpWF
         mhJp3bWrn0FcN8znaPgUOl6lqeYFpsxst5GIJVeQEPH7Ymv4t5JlKcLHCWTKl79Y6BQI
         WQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793062054; x=1793666854;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0JwiV77TZFPsGwYE3NQZqCj2nzgHeX9j4cZirnnqmRo=;
        b=YObWyjwZbj2j/47DpX0xao7J7CLJJAKw1DM35tKtj3o237V9EstDjGlXU7EYZZt4z1
         ovuQhrcjqCO4jjmmbjLuh2MaWmqdzbQ7FGFQ1As3WaGAHP7UeyMHN+U8yPvKgrOrEV4H
         nTAYJnD8mhZhCFLhC6tFfjSMJjEnE8qceGxhymywdQbQ8cjvSV7/UgiW3EOfIKOWHmEU
         4Eo5QV3I0xs7atxKPdz4l2F7G+VRJ98oOkBsxP1WE7N+ZR+y1MtlJ9mjNQQF0JEHnx8o
         wbQnROAsZ6xR64Os+WHl10TstqU3lNOCemax2nXviMr9PyoI+sgLwfEtLBP7m5hvg94f
         LjYQ==
X-Forwarded-Encrypted: i=1; AKwUvBw7Tu/Qt5+ALeBu6f3cI6KeLRQziwAn2HO7i2jOgtwq68vdVFy2/g7ZJwsXQb6upVLxPkw9CPFhQg2fEYU2Rg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLUVHTHj83+n5Rx/HnPoSZQ59MGoraNdeMQn+zXTROz7iZpSAF9
	+kkqzQ58Lv8NeqoeG0HItUf76/zoPaVR3Qbaqh6yVbXyjUl8juZpvF4QUoMXjeZMDbisJuiBLO4
	0HO/4WcVekDNzmy98B8UUccrZJqrgphv6CYnWnRF9Ksfnps8CsB66PQVpqqWaG0JN3FcTmg==
X-Gm-Gg: AYBFou0zEM5X5ZC7QFYy9oIClQJt01m3k0EMMfnY1hDwuRiUTMfz8tFbDS18r3jAPzp
	7Q0MQhZTFFz45p99TR0KUgy2Qk9ZBTw/8QZW2734ZVc2Qq6skLbq6q0l5tlzzioSMqi8/Z8B5Yg
	6n2tqV10eWFAxRjZt4X+Chb/3uYogAbvMc7r1OZN8S7DrPCzAvZYnQ/PwPEGEcqKutLX8oBgRn3
	kTVSDffpZwwUIjrzUsqJZ2LigJRUEL+1uJf+TzgmWmMgzVhyhJZrcX99ZJmfRCw/horYLvTI23R
	/fPuP6/8neEUFmi5XC4pkTTgUWsYfHpvLxO5JsLx1W8KEU1sUb9oECLFln/Ceh1KF+Y+GD2e6Cj
	EEsFMEiWWEYWNsMc6VtH4Jql7sFKE7KYgMFmOAJfbmpsFuAjvx/CzJsbbQw==
X-Received: by 2002:a05:7301:dd89:b0:369:9eea:cd25 with SMTP id 5a478bee46e88-369e842d28dmr12705664eec.7.1793062054194;
        Mon, 26 Oct 2026 17:47:34 -0700 (PDT)
X-Received: by 2002:a05:7301:dd89:b0:369:9eea:cd25 with SMTP id 5a478bee46e88-369e842d28dmr12705631eec.7.1793062053486;
        Mon, 26 Oct 2026 17:47:33 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a01fa4c58sm29144011eec.21.2026.10.26.17.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 17:47:33 -0700 (PDT)
Message-ID: <7ada1074-9c84-4708-b5d6-9790b9f6f3c5@oss.qualcomm.com>
Date: Mon, 26 Oct 2026 17:47:31 -0700
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
Subject: Re: [PATCH ath-next] wifi: ath12k: change MAC buffer ring size to
 4096
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Yingying Tang <yingying.tang@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
 <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
 <0423c93c-8359-4fd5-9ba0-17e5ed3927dc@oss.qualcomm.com>
 <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y> <atoTUgEIfkg6b29U@QCOM-aGQu4IUr3Y>
 <cbfa35c9-cfa5-4eb5-a203-09c9069e3b0b@oss.qualcomm.com>
 <atrJv0wgF20tmuDr@QCOM-aGQu4IUr3Y>
 <38fc5a6d-c019-43bb-98f6-ba6a667c64e1@oss.qualcomm.com>
 <atrYGgGWB_zQIrc1@QCOM-aGQu4IUr3Y>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <atrYGgGWB_zQIrc1@QCOM-aGQu4IUr3Y>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: FKfgrmq8entfl2GR6lmjkomyKEcggFI7
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDAwMiBTYWx0ZWRfX+J9RiTQ8q06l
 5hjIv+Opwb6oALgK1bVgd/P9IISH+2ZmLXmTCQtfdxyXVkDlEerSAVmj/yyHa+riNKoALVz0nkz
 5ljVLBqfn1ZemvXSy5L6wG1ejmzGDTE=
X-Authority-Analysis: v=2.4 cv=EIeTQFZC c=1 sm=1 tr=0 ts=6adff4a7 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=0oYm2DgIxsn4U9MLWVAA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: FKfgrmq8entfl2GR6lmjkomyKEcggFI7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDAwMiBTYWx0ZWRfXzTpjN/ZP5X00
 PvDFTDt9NDhq9v42gtySANmnZ+1qpY8/8yEPBa7RNHhkNz0CPutM4lBd/iqA7KPqIHvzGYyxj/F
 evjJlb0hL5m05nap27simdu2otQDFUpRrr4xwsgfgdNEsAZsRQFpoLYrwkTmD2xAgtwYducCmEE
 BJcjvphihgHKrMM5bvph6NV3zqovuP7McoaP/ANtLNPB8HB022mNIPkQmMjug+dn26UScbyRty6
 BTIJLlcQlWHXQ1vuqttASeGym4b8lpSp1LearCm87Kp64AJ76JdDf7Y+K3p+GGvxvii+8o4ufhB
 PUUSZB/lWeftp4t9U4mOfR68U2tSbqcis6elMG2XREQFLws0elpoA1OQetyc2V9oQoxSKyg2LTq
 MidFdOwYHxLpruSlyYfsXBiCgt0ceJ06QfQzHifAau7RxZT5An5aZFnlhXbnaQPXDo5hO5vk3pV
 X/83q66hdxGXRPI1fog==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610270002

On 10/22/2026 8:44 PM, Shawn Guo wrote:
> + Jeff
> 
> On Fri, Oct 23, 2026 at 11:13:56AM +0800, Baochen Qiang wrote:
>>
>>
>> On 10/23/2026 10:43 AM, Shawn Guo wrote:
>>> On Fri, Oct 23, 2026 at 10:13:18AM +0800, Baochen Qiang wrote:
>>>> On 10/22/2026 9:44 PM, Shawn Guo wrote:
>>>
>>> [...]
>>>
>>>>> I bisected drivers/net/wireless/ath/ath12k between v7.3 (broken) and
>>>>> the ath tag (working). It lands on:
>>>>>
>>>>>   15f7603b69a8 ("wifi: ath12k: Increase RXDMA buffer ring size for default memory profile")
>>>>>
>>>>> The previous commit, 643f0bf93617, still has 4096 entries and is broken.
>>>>> 15f7603b69a8 changes one line, .rxdma_buf_ring_size from 4096 to 8192,
>>>>> and works.
>>>>
>>>> thanks for sharing this. I can repro it using the 481 firmware once get 15f7603b69a8 reverted.
>>>
>>> Thanks for confirming!
>>>
>>>> so the rule here seems that rxdma_buf_ring_size must be at least twice as large as
>>>> DP_RX_MAC_BUF_RING_SIZE (I also tries four times large, it works). This rule looks
>>>> reasonable to me, since WCN7850 get twos HW MACs and its firmware setups rx_mac_buf ring
>>>> for each, and each ring fills itself using the buffers all from the single RXDMA buffer ring.
>>>>
>>>> maybe I should submit a patch mandate this rule.
>>>
>>> I'm more concerned about how we would fix the regression for 7.3.x stable
>>> kernel.
>>
>> we can try to ask stable team to backport 15f7603b69a8 ?
> 
> Ok, I can do the backport after the commit lands mainline, assuming it's
> part of Jeff's PR for 7.4 merge window.
It's in Linus' tree now
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=15f7603b69a83a0acc7fcc8992ecbea6110f9424

Would obviously need to backport the entire series:
https://lore.kernel.org/all/20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com/

/jeff
