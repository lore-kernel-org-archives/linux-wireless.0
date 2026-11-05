Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793893917;
	b=yypkJ4QvWPf8RpE3u1kHAhaK3rbD/XKOyExwcn6x+ZWhoMXTBA5U3JPfQr2zUNM4Olnn
	 kGRdC0pRxX1nHpzNyDBdTVaANC5BlGVyz9Q2E6euNfhT2N/VdsEIAtTrlZMpvxJsZPTlv
	 DXOKnMsz46JQWTS76yhNX0i1pGFm53t/5VODcyvwT+ra0Faa/tU5FyHWXCDQZsXnZ5DBQ
	 9N6jYHtUtbGJ2LH6PKojruSMwK70/1OVpnXigOAmMWBWVQB0vG0VAKD4oBBmvg/0IhDhy
	 DKkWhlLUsgCgQAvGIeGQPm0OfXXByRf3745t3qogPCcVbNLQU1NdksUfdkrO+Pit1xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793893917;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=SJo7jnqF1M1rwKNOXnxitcspRC/aTbZyuZtyigERipk=;
	b=nzKvcG3DIZ53MrrSGblu4ytzHIqEk/vHpcACDLtGLD9q3IbZDEXQoZqeTkx1H1yl2W6+
	 uGbOV7AFvUevZVQUTG1UZdy3x0uIgpaiePUB5/kLqkgyo05AcdfDIwQxaj4OJiXPz+kub
	 flaw5yBobVAVKlXCPLv9OG3Q4m/uCkW2qHzhu7IN1mMu9uZ3eFlDT3OQu/DNAhjHjB+hN
	 H7ZpKBPjCn+1Lk9PenCtlIgTHoUcF2D73BiQYZ3hhcyWe6zFNCoZ2hw+vuZzfRZEwrHi6
	 oRJPCEjKOOmjNCEPex6YMJpvO+kJkBPCVbjMXFx54JRa7A4Fv0YJfAXMUfA+z+6HHBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SU6Cafza;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=EQuIqV1f;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60EE606D804
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 15:51:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B60EE606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SU6Cafza;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=EQuIqV1f
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5EQHrw1630998
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 15:51:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SJo7jnqF1M1rwKNOXnxitcspRC/aTbZyuZtyigERipk=; b=SU6CafzaJUVRtnA5
	pFTLGbVhd67aGS4mk+XjjE9pYfdBXf1FB2jB7PKf1AIcSsOHxaHMUvDphUe9B3De
	X2fyp+awX++0LQCf+B5judTxia9K5H7Ey5u13q/NcjOAG5NPfQGukQ1p7FdvxX3L
	nGUto40dL8y6CzF+xYTrSa7SUv0q5SKNNNHvrA5u/3IkjwTmNm6cU89t5q3jVrWa
	EmafBGunumXmce+1Go5Ep7WTesWeZrsjO3Ue3sJ4Y9PhjIK/p1YTqLcm54ghbIFC
	TltEI3/XRIXZVRFdFlRed3uUkb91RHlpwBn2erYlYpT3/UnIuVfrX2wHa1pE+D4T
	Bomcdg==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrkaqamme-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 15:51:55 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-84c4dce8182so2518663a34.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 07:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793893915; x=1794498715; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SJo7jnqF1M1rwKNOXnxitcspRC/aTbZyuZtyigERipk=;
        b=EQuIqV1f+N3nlyC32uMBHktjqcRM5PMYz9GEfhPvAxuGE4elJFhI2ZkWaVWMVXnSLt
         8rEZ8+TsfusMZGUGGtHUFg1vf15qWuz8LpZjBDfVYQBhF6TEBMtvEJyt6KnTmnMcSkBr
         vmGTmTiLEktASbqTV1189NShi/fYd0kAu0SKuKGatyYL+LfjHj3AvH8+IcpBTpqC2NU4
         3Nk02baxMNz9wKTbED09gjcO59RyiCDQ4gWlacLiPfo8CoE7O4nEdaZwClIrYAhv4Wru
         eJKe+zRk71/9zzGqZNCmBi7ngRy4Oh//dPQ+55VFV1Ui0oGiWLN7a4lzJznXLpv0gjtH
         rNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793893915; x=1794498715;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SJo7jnqF1M1rwKNOXnxitcspRC/aTbZyuZtyigERipk=;
        b=WlgQL1bC2Xj9ktj4Zj41owxqR3XLtRxGUOK6NI+A5M8W878T6ugHMCY7xxdisAGxS3
         QBg7C8QldNOGrHp5bEQhYK3aABKbjxBoakJxM32trxYpxVC0Cqo/rhMbsDjmJu5HA4us
         IIFpsg1l2pqkNzndu+T6ElAR44wc40cEpVORO9H7dx+QhqEseoZYgmKPjtHCzySwNte8
         iXZELYyl9tcTsoIdiT20GFjWAjELkAE9KCNhMiQtbi5ps4ANYwjj7tr+4wXVjW6mkEXX
         xBTlJw5KHX92oBiP8CtAwZtBfqhDbDtOpYFHg63uLH/n1JeB8yzWyFnx8yIlUozhFoOe
         aL1g==
X-Forwarded-Encrypted: i=1; AKwUvBycrNJm5jH38qGMQ+tIz/g85QPbnMJx7/qT9kLttD2l7has7QhQBD97ECB0LrSzqHAXRgenqa9W+GHkmRP4hw==@vger.kernel.org
X-Gm-Message-State: APuU4Z99OXJxxzF3Tdq1Q+k2FD3bzNOZlirfeqrRR/xxilNuRYeLcHN4
	4pT3pdGSYOH+xUjHIIP2YNM4CgGhBUdOcJT7gD/L210qjr62cm1fzx4ZTJwXfuyj042lEACw/K1
	71tzWLX6e1l6dV7dDwBvkk4KOBNnBJH/vuRzTgFsjQVP51AnEtukbPh2remcpgTYwx0i9NQ==
X-Gm-Gg: AYBFou3cxK9U/fBahWNeC0hRsrmE8uaNnyu3/fI66YZspSk/pQ1t+JZikpk4Z3b75PE
	oTVJkjObXpJ6PGCM9oo7AceJ0JkOCJd6ItCPuFemNKIde4CUQuACWdB1eS+tuEhbK0PQk2+xuIp
	uUHmjBeyJ/7zlyR597RPLYPHa746vTC1hjn9UQWg1vKcCd2h9S++qIhfFhiBcx4uGPi5HuP5Dl/
	H/wCl71lOI6ETkyAWF12RJym810LNDGQUKf6PxkldHzijrDO+Dp0r2BenKe3BxIDo/h0PTClBZ6
	1026xrofNv+LjMb/4yhwDUHDDYLU5Ar5EuR+u39OlF38LDbrkLrPB2Dmj6WF8mKqB0WyYe39m/+
	GGVwS4BFQi6AH87G6Kd7ccgj95cqPoN/Y79SjnpqslYyVU+Xsno3Hx1T5XCFV2qdq5lg3PnATe+
	Paz9Dfji1eosRaTRlRQlfZ9UmRl45pZQ==
X-Received: by 2002:a05:6830:640e:b0:819:1804:d208 with SMTP id 46e09a7af769-85d3650b7d4mr16481900a34.13.1793893914662;
        Thu, 05 Nov 2026 07:51:54 -0800 (PST)
X-Received: by 2002:a05:6830:640e:b0:819:1804:d208 with SMTP id 46e09a7af769-85d3650b7d4mr16481875a34.13.1793893914117;
        Thu, 05 Nov 2026 07:51:54 -0800 (PST)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85ef3d7617asm4814965a34.4.2026.11.05.07.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 07:51:53 -0800 (PST)
Message-ID: <18053a92-36a3-4d02-bb73-25e9aacf976f@oss.qualcomm.com>
Date: Thu, 5 Nov 2026 07:51:52 -0800
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
Subject: Re: pull-request: ath-current-20261102
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
References: <8e38f8dc-88f9-4974-8f98-687795fb360a@oss.qualcomm.com>
 <61e49149-5096-4440-b261-ffe2d250f6f4@oss.qualcomm.com>
 <6792cdaa627ba4755fd0836a74474977496f9670.camel@sipsolutions.net>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <6792cdaa627ba4755fd0836a74474977496f9670.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 632I8TUhFvZckXAByOnNhN8isbM94sUX
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA2MyBTYWx0ZWRfXwI5xMYd5E+7R
 KQz9Xxglb5e3NMKPZ0z+cGAdpBaCbLiI57a92aqAmU48U/20b+LQikE2X1E1XP3OL39q2BSFqZv
 /Xp0vM31l5t9Vk33niK/j2o60ywOkW4=
X-Proofpoint-ORIG-GUID: 632I8TUhFvZckXAByOnNhN8isbM94sUX
X-Authority-Analysis: v=2.4 cv=OZoNnRTY c=1 sm=1 tr=0 ts=6aeca61b cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=5KJ2qN9qyuHGAc2nJd8A:9 a=QEXdDO2ut3YA:10 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA2MyBTYWx0ZWRfX+fLxnmDr9/jx
 sco81+F6eehcUTO9wXWZRJOGwkZ2u4PjeqT21IwP5ieXbT3jsdYvXY5bJMaGfDxhVyOGsiaE13/
 iROiZGfVVj8RkLPUuvE+7r+wq93fnAQWPY1R6CY+6iuwAwQDUkcjBQj1k29kAmLyfEvuMiDvhzH
 m6NAj4SkKkdJUfYetWFEKr0MwJ6lpYEnuJZO05hgqVv3gc94se/iijeUeK92yLi/ZjWbu/Yh5wU
 qF/rW20IiHNkNgc9pI1jboWsVK4baWZ/wgqwuNmDaXjtvR6mxRhYPq+HPmLCsf6TSvdnyEfpr25
 Gs4HRWnO6sP4Pqa7+rfsW+RgRivqaJ8OwZbwDNzPZwPhZKA3GBtfa3kBvEDnwSrJWxH0TpEuvIv
 kW9+6CnGx/58ZS2P1MA5VZaeHcW1CAR4OStjNUSmGxCNhpxo3XI2Ghk11c40xy2rgz/scLcXYRv
 Yxhhr1sSJDakM2vc46A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_04,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050063

On 11/4/2026 11:29 PM, Johannes Berg wrote:
> Hi Jeff,
> 
> On Wed, 2026-11-04 at 17:11 -0800, Jeff Johnson wrote:
>>
>> I missed the window for your wireless-2026-11-02 release.
> 
> Very narrowly too ...
> 
>> Since you have now
>> fast-forwarded I hope you can pick this up so that I can also fast-forward. I
>> have a series that depends upon a revert that went straight into Linus' tree.
> 
> I did, but I was also going to wait until net lands in Linus's tree,
> which should be soon (today/tomorrow) and fast forward again, so we're
> really aligned. Hope that's OK.
That's perfect, thanks!
