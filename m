Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9731316190
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 02:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785723561; cv=none; b=ebjDccujwolKATAsnP+f6K9OLbah3X6qTyj3zONTtiymVZyXccIZsYYxFPx9qAJjDXMuCFuW/Cvx8ighie47lbcB5pGfBj9n8yNnF832gwoAH5eZqqut0HHsTZ4UuYnG3yt+hvl5MWof5mwI9Du33SpL4Vob2WQ+r8YnBa3VI48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785723561; c=relaxed/simple;
	bh=RZ+nuM9H3+Kd2bUnwX/K1k78hq1WGc/eBFQI7aVEgss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ER3hc1Ov+FKQ+WMMkUGqigwuaiZWh6Zi/GzYS85bY1rgOr1Gs42mxhxVBzIRIsNQutCoI9Pzi6FL3Ty+5lSmT2Ol4VzlKp9BwWUNaZBgALb87qaqV8B6AHbCRVjdYXG/0jp5/oA09hQZX+R5eGmn8n/0Cyr98AAbQnGp5OZ4+vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=N+vU3/da; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EOVec3ze; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="N+vU3/da";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EOVec3ze"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672LVfqC2877080
	for <linux-wireless@vger.kernel.org>; Mon, 3 Aug 2026 02:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LOyUSiGvN7nEzsPVWJSjQGakz4rhGRF4AjJsOR1nUu4=; b=N+vU3/daUs4krDo7
	YKtUXMEHNxmDABca4kdcaA03863OmCQX639haS8TeBNz3hw9fpqNEtNwisHjqOW2
	YM+j8ZrTIDO19t32WttUUaZOlNW3lNcoOl3Y4RzjwM2/8zcPDQqqhX7dXh5t3C7W
	wHbqkyolAs7loSWe/oZe9xC/+adxCpsTLQ1MmvtXZlV/YC32P3UEcKGsL0uctxU2
	7opFQiqSp0Stn4/yovLA3JDCSCjdAvD7hX44dmYJqM1lktxT58iBW0Kx48/rmW/6
	rhi8VZDWBftVD2Zscm1mWoWmSQ5gZ/DC7DuuIJgxWlcl9ClDbxsmAIGC1T/c4L9H
	v1gMfw==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fs8vtc7c7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 02:19:18 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84e048a801dso4304496b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 19:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785723557; x=1786328357; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LOyUSiGvN7nEzsPVWJSjQGakz4rhGRF4AjJsOR1nUu4=;
        b=EOVec3zecEyEnZ/0uOaZSz1VR6t5nJ5w8SSVOTTI6sUDjUfYJbCFpncSnznnXCr8zZ
         R78aE9EBWJtly7CWWXI0ldlmBjCB05W/bGs+XMmyFftu29WR/xEzOIJsQG7u+8ptKQ+T
         znh0HYo6DBHKh6NmB78kPsla3T+GgUVX0bloA3Ux/KjsLBD3UaayRKZcOI8HHcpwzlUx
         ypaNPlOU4Og20WNUtshmvvJns/bNIwqssXrP7WwcWC0FVdkoayWmpfIZ48M1WsrzQZld
         GY5LUQGcE5nU2CrmUQTc/HuFUIbEUXJhaO5jeDOsJUroTRjQrhIQPv+1lQz7mZL+Ei7Z
         SFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785723557; x=1786328357;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LOyUSiGvN7nEzsPVWJSjQGakz4rhGRF4AjJsOR1nUu4=;
        b=lOhnDxkQ+e/+ql2i8c2j8mppWSuGLgzhZ/CPgRq0oH77n334pGhBI8vGwfypdQkoJW
         oPhzTOtYy4CDRYMYwRvNbYHG0urXUW18X5eYfRKKc4Xvis1H9A8kUVUHwF8lxtXXVBtT
         DCdbng7+1fFLdviOhIyhkKNDWzTPdwX1QUDjEPj8aBT73BEQjrMuAtqS01JznDFYnYTX
         BqOojMgmed352FPIDMMhIwY+twPdJDcv8k0YJpKPr67EaZCOs859xCnOjGMwQWiDFDyt
         LHiPWcS2CwbHMBFDVt63iH+V8QMiQJ1/SljSlit4CbcYQyZB1V8yc6hXZdYtAXPr+/c4
         4KBQ==
X-Gm-Message-State: AOJu0YyklCljXIakP1DnZbD/+z9nCpiJGGC7XEu4n8pXH+K+yzbRCzZ3
	2WjBcJOsZ0DehlOJKGXQnGQiRdTh/wmiLAMpWNLaNeVkXjwGN2XgyuVrFkcK+9spjy7eCJbS+ap
	p7/wkW6soptlAgURoQehI4mS8izgc274yqThSTFGHlOqsWVKBy+0okL9zmbRlWmnUBnkfFQ==
X-Gm-Gg: AR+sD12iJtz8YvLTgEiaR508R8fvMgDbc8MSi6t/aPeJCTOXgTw/n8EDFxr8AFqGJe5
	AppS6RheJuu9lXaOv3ytDHFL2lMQDOlYmXk5yBaU9bHbLfCEm5Gdb0naGYS54mw9d1McL0N6+Kj
	Ac1ImcmiXN9AYNzGHQSm9eUDbQS9lx4zgUkl9GvfXoPixRxge2Mnuq3xP000lNsnh+GTvy4NO83
	KCqc95N808HzVNeBXuYES6k8xjDBd3esmgEJXK2rDq6GIrF7i+RQ3H+YKvFcprRZEj/W852aPtn
	2SCb4OvU1PSW96G6tHadrczXjlTdTtrdECxkfRizmWUe+YVN59xmz7DQdNJWaYmdHItcEktSuyX
	9nl29a+rRWOhHL4GZGnNN1my2tvH0mHV3Csx1A4LJ2alWkGf7v9kxSne1wUfMe74M3buM4Gv/Eg
	==
X-Received: by 2002:a05:6a00:3e1e:b0:848:6720:6fee with SMTP id d2e1a72fcca58-84ee4909218mr7113928b3a.40.1785723556988;
        Sun, 02 Aug 2026 19:19:16 -0700 (PDT)
X-Received: by 2002:a05:6a00:3e1e:b0:848:6720:6fee with SMTP id d2e1a72fcca58-84ee4909218mr7113905b3a.40.1785723556566;
        Sun, 02 Aug 2026 19:19:16 -0700 (PDT)
Received: from [10.133.33.123] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe3963dc08sm2914848a12.6.2026.08.02.19.19.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2026 19:19:16 -0700 (PDT)
Message-ID: <fbf43d4e-9e59-4bbd-b1ac-aa3a9e2fc123@oss.qualcomm.com>
Date: Mon, 3 Aug 2026 10:19:13 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2] wifi: ath11k: reset ar->num_station on
 hardware start
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260730140306.133718-1-nico.escande@gmail.com>
 <4160b5e1-c82f-4083-aa36-18e4a42f909a@oss.qualcomm.com>
 <DKCTQGTORU5H.H4ANSP32B0PU@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <DKCTQGTORU5H.H4ANSP32B0PU@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDAxNiBTYWx0ZWRfX3OIaxHPhyw11
 sLpmpNtugH6jHPVGbO4IoAcSD/yv/GtlowzJgN4ylyICKuw5rL05sSTB1Ev913DArt1S88+yPXP
 WTeuKPIoNPH2fLsOsGjFvP4cyr9yXh4=
X-Proofpoint-ORIG-GUID: Y4croIK-sEECV3rkWWAbazDqPhCvwy8H
X-Proofpoint-GUID: Y4croIK-sEECV3rkWWAbazDqPhCvwy8H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDAxNiBTYWx0ZWRfX9WZAgfvlSlnN
 Mf2GYjstTvNh3i3kIRfhWRocJBxgxmDjXjm+IiWRUozX3a81IrD3nYfr+qeqGLp5GjLXA229o52
 lY40P+G9hP9x7+goSu5OuD4EAiL6rQ80VXMBYa+cuTYgdjwW6SDmZ98kNSBQTaNnRuzdw+Sw99u
 dYMsqUc0JMJdHXhZcJWNpZ8FmcWgG27J1sLuaLKMGwJAL46QG3N+gQtFF8QLGE205pPLdL8iGsQ
 hlRz3KpNcrDRP9x2ACSnc0XEp7vbUdCLOwyTNjs1UDAgcTEk4pBnbuCqNVmybM98BZOCOKDIu8L
 KBmAMSRgzaHNytS7XMKFIQiQsS0xFYRXe3Ilwl1AuehUSx427LBY0OK1UMRJL1bl3Mf5oS93c3G
 LY+W+tq4AQJ5baIGQW18+lTD0Py3ryY/KTEQSuOp3mOGj+iLKx/23Nh0YB7IKJd0clNpgjQO5Z8
 Bj/uR7P39GDsdvyqN2A==
X-Authority-Analysis: v=2.4 cv=fKMJG5ae c=1 sm=1 tr=0 ts=6a6ffaa6 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=pGLkceISAAAA:8 a=uyKc_MerV7-7T7EwjgEA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 phishscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608030016



On 7/31/2026 10:25 PM, Nicolas Escande wrote:
> On Fri Jul 31, 2026 at 7:41 AM CEST, Baochen Qiang wrote:
>> s/ar->num_station/ar->num_stations/ in subject
>>
>>
>> On 7/30/2026 10:03 PM, Nicolas Escande wrote:
>>> When (multiple) hw restart occurs, we end up in a situation where we
>>
>> by hw restart do you mean firmware crash and then recovers ?
> 
> Yes firmware crash indeed.
>  
>>
>>> cannot accept new stations / mesh peers. This seems to be the
>>> 'num_stations' in 'struct ath11k' that did not get reset properly in
>>> this case. In ath11k_mac_op_start(), it was indeed the only accounting var
>>> that did not get reset so let's clear it too.
>>
>> the root cause description looks confused to me: if it is firmware crash and recover, we
>> should run the path ath11k_core_reset() -> ath11k_core_post_reconfigure_recovery() ->
>> ath11k_core_halt() -> ath11k_mac_peer_cleanup_all() and in that function ar->num_stations
>> is cleared.
> 
> So about how I came up to this fix:
> 
> When I first saw it I though I would be able to reproduce it using the
> debugfs simulate firmware crash feature, but I was not. Then from the logs
> I had at the time I noticed that there were multiple crashes back to back,
> sometimes while still recovering from the first one. I think thats why I was
> not able to properly simulate it and find the race condition leading to this.
> 

do you still have the complete logs? especially the time when you saw the back-to-back crash?

> In the meantime I wondered why we hit the num_station checks and not the
> others like num_peers for example, and found that it was missing in
> ath11k_mac_op_start(). So I made this change as I do not see how it hurts,
> and I've never hit the issue again.

Yeah, the code change seems safe to me. Just the commit log we need a second thought.

> 
>>>
>>> This avaoids problems like those:
>>
>> s/avaoids/avoids/
>>
> [...]
>>>
>>> Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1
>>>
>>> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
>>> Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
> [...]
> I'll spin a new revision with all the feedback taken into account at some point

