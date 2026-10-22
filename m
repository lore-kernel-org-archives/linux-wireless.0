Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792666839;
	b=MEDuIGkd7aet9/Ntu6lvm75uqM2Ip9B4IOpOooMfTd0SYeKxwXeb4NgGMGal6F/Uc5B4
	 HfGWIxKEdm8yEqC+sx3sKNUWhc5Z/c95Kknd8QYNilvAym7tjoYCun7eQZ2haZGFPIpjU
	 TC14lPAhAk9yCprV+3ufbEzPbNPZG5ocYfn6bR07wmfnZo+bb4atmcIRTFtwuC7e7HVek
	 RtkYa7KBzZitIkE1JBIgPqFqakJDz0VZEvT7VXo9pv3d+ptch8Y65CSmZGeKnP4kafdB2
	 mJXG2MTf79auByI+Txqs63RTE3bX5jU4HSsFubkwIQjKHTZWGKvlIdpU91bxS8hAJyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792666839;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=tNgk1Zalkc1M0w3EsqbvSKsYob9Or3oPjo0QS5Err9g=;
	b=x+YrjgetwiyJ+MylT80r3f9/MSG3oU/Bh3kGsas5YP8HSJakrvZtKbgHtHXgai1MLgE7
	 Bp3+1unPb63407INkkY7nHkL3aa+CGUxLaZrEJoOIj+3ekAtIkHaiYE4lkEIvCbiUUHXJ
	 ezxzQTburDfkJwW0wCCOI33iGEnRDpazCsSQ/fdYRuKsOlpqr11Qp88azlegioYn3QjqI
	 3tlHvORY+V900SEaaX70hwB8zMBY56TNH8c3d7xKcVWXRsps7m/+A8A/RFm0+fbqNDqQr
	 DvvQN2ByeEg5ZueDMk7Yrn5x9YZFX/t2hVzIEWR3Z25CJ5m2u/4eDLTzjm40F8PVx0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UaDET+z2;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DlDQeqfT;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D3C606A321
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 11:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56D3C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UaDET+z2;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DlDQeqfT
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M9xxFe1962207
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 11:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tNgk1Zalkc1M0w3EsqbvSKsYob9Or3oPjo0QS5Err9g=; b=UaDET+z2B6Wm/Tl/
	c2YSwGwenIEBpibmySjrKLSrKR4hv/K8MyWg696uyqs+tclMvvoEJ6zGKHGQxcBI
	+d8QC6ZatvL4V38ziy0G+22dZ4oYnXJed+JH34854VVjGp7GTT1aqWYGO3ziHZSe
	tEHr3iGexgVH2roHaVz2bucKKKunKbbmOCAPaODOMRKtCacqlt1qs1CSxtvbqTiq
	HdzmqC4XZRT9P+qeQ4gH+5km1QYYjduTP3rztXZktG1kUeHOYH+3rgZ0U3IRr9jF
	qyx3RIWZv/JGCrW05HG83zhDS6iFfXQlXJwzcQjeifK4+htayLlxme/4sTphU2k/
	WFgzCg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93ajcsj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 11:00:38 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ab27eb38d6so1819993a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 04:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792666838; x=1793271638; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tNgk1Zalkc1M0w3EsqbvSKsYob9Or3oPjo0QS5Err9g=;
        b=DlDQeqfT/AGhVmVSF1p5lNf5xutNccqb0Df60Nmer063kvVDBmsApQBgKFiljdx/7C
         qJ+b4osSE0wIkmwd6U/WkqLBZupfeS1vdQi/+OzSmuijQ59N6/Kg3xn5/k0dzVFRIPi3
         whxFckorDmdQcWG8LKYttZebKn6WnFDHXXarO02zcmbq9lr8w6sMc6GEbfdo6pVKH/+7
         L4iBeU45XV3RsbHEMvcyard5Srq2aWzXWgiQl9aWeZ3jBPKFAdBdPh4NHMO8PIkWL0Xj
         I9GZUPf6OJthcV5NYjdEF6+QHW7dZNVijIylJPUWjCBOuveRBhsduKH3Kg9JstyaMkNJ
         N0SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792666838; x=1793271638;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tNgk1Zalkc1M0w3EsqbvSKsYob9Or3oPjo0QS5Err9g=;
        b=g01mkiA6jYgldABzhPLkUJQrGpQUaUticVrE1+imJt0egHQcouBXS11mOOzRjotsYi
         HQ5qYaTda5ZdZHiOG7uLQFqbo7OZ5c3yr1GCDLATDQ1MBU9Vzni1JngFoaIliV71C1Ln
         Trf4ncE2/3v6iYNAG3xApLxJzX4a0awyzFO4GE4BKJjPIf1wzsxw1epDguvRpa8b5lOB
         A9nMTZoA5GwmZS71Msoe7JVdyXgywrIMz/ljAgYBJTeEh9ihtxHIsgd0fTNZiIg+6RhV
         6GFYCgFAEMZ1Jm3POYscvd0WXtIKLrPVHIii1l9ajq1eJvVXKlSXWdKXhiiaKxU1L3iq
         sEOw==
X-Forwarded-Encrypted: i=1; AKwUvBxVPX2tHLzO/7J09EcJtiuXGe0CHruwYAuLMJPHrGSANzzjLOYBLCZUFthVo0AqxfgCrs7N1QvD5HH3VA3bJQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYItXsPfqvBw7m1fWNUB+7lpcQUFPtlWyeOTRRQekqzayrmo5D3+
	9f+7NtKamOFgQwUi3aj/jkDNGe1oS39CnZM/MBL+KxzSXQYebV5SPg4/EoOUM4coktCdkKNcIUj
	OjcKOIIy5CUa6NVS2p6lKXGSSF7Rt9mPTR8V9wV0ydlwi6aorh/OxD2PHfg7qatoi/4XIXw==
X-Gm-Gg: AYBFou0kCXasqrql4peaDHqd9n98fPKSSWgGPAz5mAd4hy6aGGtvdzZL12k6lSxMVLp
	wnLJ+tlVIN/DjP8xrPIgzdTZE4u0RlEJRtJCRpvnfJSVsHjEZ3tFo0MANdDycjYoquJfA83KOGW
	4amGCugd9hdsUKzY0qGkr8Q84hjc6GcuLyPgy/VtLSmarHbcZIAA1XvNNjmQRQvlyKk00aeWknS
	MFR6P3h7vs+UkjCOcBqkOfp+OD2YgcIBLfKLIJ7A7jMC+ORTMj3UOjH9hZFI9kwg4QrPQuZhvlJ
	+Vqotn6NXzZhUGAUyg8AJ7UzxbpO3jkR8ooExhvEWAExn1AvobfYps1kiTqK3QB4p6gB18jQ6uB
	Te6DQBCJ6Zy1IzkMezL22mrqz0u/mkYBsaZrZS6XjlXXooe1Lw3y9EH67oW49cY1tKNX09DvX
X-Received: by 2002:a17:90b:2c90:b0:3ac:8741:e2e8 with SMTP id 98e67ed59e1d1-3ad86dcacf8mr4085416a91.8.1792666837613;
        Thu, 22 Oct 2026 04:00:37 -0700 (PDT)
X-Received: by 2002:a17:90b:2c90:b0:3ac:8741:e2e8 with SMTP id 98e67ed59e1d1-3ad86dcacf8mr4085282a91.8.1792666835602;
        Thu, 22 Oct 2026 04:00:35 -0700 (PDT)
Received: from [10.133.33.125] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4890bb2sm3793372a91.1.2026.10.22.04.00.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 04:00:35 -0700 (PDT)
Message-ID: <0d5d36ae-3d65-4dec-98cd-7409ba4180c2@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 19:00:31 +0800
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
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: Yingying Tang <yingying.tang@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
 <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
 <0423c93c-8359-4fd5-9ba0-17e5ed3927dc@oss.qualcomm.com>
 <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA0MyBTYWx0ZWRfX3i+fvLbBlZMg
 6L86MERI+hcPXicnh542wPo1tG6Hso9zGoVCAa7lAw9Grjlu+F/I6gZL8iBXwpUjzRH6bnyF0sY
 RvKuMX8E+qIw25caNy1taU2mlrbE5OW6j+IF0NDMu8M01rnisLmcUDagkbfpJH6URGi7bkyK2ZG
 vz8oZJCOPSDnAaiR/NGbnCTSZmRqCiE+Ge+l/g8ybTUoO6VrZfczhUbvyw7Fl+d7F7rDXzpO5Rk
 9MMewBok5JtSSyqmZvHfUarLbJWFGck8NfdKrIYrFeYNDFBKPQHpPBfK6vBrb1Ky2UHwRFAb/Lg
 k3ec4axUaXm8atBR0h4tgZueTZwboFEZJW3Gxhya8YbUA25wEYuzd8J5LXClW1z8tcpqdSYuuR2
 oQueTPFJ98p20yrxxlwtKjY7R0/gToe+0RdHiHTlY4f5TJF6nolxrbjdODNM0oBttYvP/bPDQZa
 qf0MSpi+R6lnyqxQzKA==
X-Proofpoint-GUID: cNxfRMW_ylaVxOv484qMcyzBijO40VZU
X-Authority-Analysis: v=2.4 cv=feg4WEQF c=1 sm=1 tr=0 ts=6ad9ecd6 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=Z4Rwk6OoAAAA:8 a=NbhQ5tqkUGBw_Ouk81MA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-ORIG-GUID: cNxfRMW_ylaVxOv484qMcyzBijO40VZU
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA0MyBTYWx0ZWRfX+uELwQ++0Yeh
 KCG1QCAOGCGUmDOwVVy/zRQ0yenOFFuUXKiLDkqLVBzdCR8VEWA9cmvmdRMmonPhyIn4qF3o80l
 6Sr6Wb2uQ2lvlBPbnO3uzXKjnPOcNEY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220043



On 10/22/2026 5:20 PM, Shawn Guo wrote:
> On Thu, Oct 22, 2026 at 10:30:45AM +0800, Baochen Qiang wrote:
>>
>>
>> On 10/20/2026 4:53 PM, Shawn Guo wrote:
>>> + linux-arm-msm
>>>
>>> On Tue, Jun 09, 2026 at 08:13:58PM -0700, Yingying Tang wrote:
>>>> For WCN7850, MAC buffer ring size is updated to 2048 in
>>>> 955df16f2a4c3 ("wifi: ath12k: change MAC buffer ring size to 2048")
>>>> to increase peak throughput.
>>>>
>>>> But during the RX process, a phenomenon can still be observed where
>>>> the throughput drops by about 30% from its peak value and then recovers,
>>>> and this behavior repeats during RX.
>>>>
>>>> After increasing MAC buffer ring size to 4096, the data rate drop has
>>>> gone.
>>>>
>>>> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
>>>>
>>>> Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>
>>>
>>> FYI, in case someone else runs into this: with this change (merged in
>>> v7.3), WiFi on my Lenovo Yoga Slim 7x (X1E80100, WCN7850 hw2.0) stopped
>>> working with the older firmware that Debian trixie still ships
>>> (firmware-atheros 20250410-2):
>>>
>>>   WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
>>>
>>> Probe and firmware download succeed, but every WMI command times out
>>> once the interface is brought up:
>>>
>>>   ath12k_wifi7_pci 0004:01:00.0: wmi command 16387 timeout
>>>   ath12k_wifi7_pci 0004:01:00.0: failed to send WMI_PDEV_SET_PARAM cmd
>>>   ath12k_wifi7_pci 0004:01:00.0: failed to enable PMF QOS: -11
>>>   ath12k_wifi7_pci 0004:01:00.0: fail to start mac operations in pdev idx 0 ret -11
>>>
>>> Bisecting ath12k between v7.2 and v7.3 lands on this commit, and
>>> reverting it on v7.3 brings WiFi back with the old firmware.
>>>
>>> Unmodified v7.3 works fine after updating to the current linux-firmware
>>> image:
>>>
>>>   WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
>>>
>>> On Debian trixie that one is available from trixie-backports
>>> (firmware-atheros 20260916-1~bpo13+1).
>>>
>>> So nothing needs fixing on the driver side. I'm just leaving this here
>>> so that anyone who sees "wmi command ... timeout" on WCN7850 after a
>>> kernel upgrade knows to update the firmware first.
>>
>> Hi Shawn, thanks for reporting this. I just had a quick test
>> WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3 with the latest ath tree
>> (ath-202610191908), everything looks good, simple connection and ping pass, I don't see
>> any ath12k warning.
>>
>> The firmware images I am using comes from the first commit adding WCN7850 firmware:
>>
>> 	fb04a7f4b750 ("ath12k: add new driver and firmware for WCN7850")
>>
>> and the md5 values are:
>>
>> linux-firmware/ath12k/WCN7850/hw2.0$ md5sum ./*
>> d3750b67b1013fe82358d0538fb131b0  ./amss.bin
>> c79c410d585360000c0490f16fda43e2  ./board-2.bin
>> 73056f1d2aff886ce9bff313f455e963  ./m3.bin
>> d0ee61498bf1a205147cdbcf645391e7  ./Notice.txt
>>
>> can you share the md5 values of your images?
> 
> Hi Baochen,
> 
> Here are md5 values of the old firmware shipped by trixie firmware-atheros
> 20250410-2.
> 
> $ md5sum /lib/firmware/ath12k/WCN7850/hw2.0/*
> d3750b67b1013fe82358d0538fb131b0  /lib/firmware/ath12k/WCN7850/hw2.0/amss.bin
> 5dacdfbe6c3c25d9e0605be8a9f1f6e4  /lib/firmware/ath12k/WCN7850/hw2.0/board-2.bin

this is different from mine, can you try mine?

> 73056f1d2aff886ce9bff313f455e963  /lib/firmware/ath12k/WCN7850/hw2.0/m3.bin
> 
>> and have you ever tried the upstream mainline
>> kernel or the latest ath.git tree?
> 
> I'm not sure what you mean by upstream mainline kernel, but v7.3 should

I mean Linus's tree

> be the mainline kernel released a few days ago.
> 
> On the other hand, I just tested ath.git tree at tag ath-202610191908,
> and it worked with the old firmware. So it seems there are some gaps
> between v7.3 and ath kernel.

can you share the exact tag of v7.3 kernel? is it just below tag?

commit c03c1a14507dfaf8b856c2608f9ac216021fc222 (tag: v7.3)
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Oct 18 13:14:58 2026 -1000

    Linux 7.3

diff --git a/Makefile b/Makefile
index 0dc1a9f4e63e..c61ea07ee505 100644
--- a/Makefile
+++ b/Makefile
@@ -2,7 +2,7 @@
 VERSION = 7
 PATCHLEVEL = 3
 SUBLEVEL = 0
-EXTRAVERSION = -rc7
+EXTRAVERSION =
 NAME = Baby Opossum Posse

 # *DOCUMENTATION*


> 
> Shawn

