Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49BF4BD7B6
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 17:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271839; cv=none; b=D0p5Pr/U8ojZAb9s+qF12PV75PdBWfqRvuOltk9oeKjFa+4/JWBOaGfNPeNBRxp9z1jsAitoyFHhoROyjaLkuu8rGm1sLmSALk5MKNB2mHdiayHjzLUGfYkW+Ea5V/fNXAjfyodd8twp23qUObxrzJqe75rdPJQUBgkXRitStKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271839; c=relaxed/simple;
	bh=IeCLqcL942H9osUXUI5rqj3WJDkZ3mZRjzv7hf6aMAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H5ZcaEzoY0QZ4YPBO8izVhiz/QBG1dWOcel7jiqUeDI95Hfrfb54DupoT6yu64cQ02aLa6hZl0gIXIinXADd0FrZXOzdBy3xn2RWQzm3/OJiQBUVs9KJk3+9OmvC0wMU9HaDALwWe/g4NXo719ZY7096cSkc963NXN8/IILOUug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OcC1W5SQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=f0Dr0W8X; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OcC1W5SQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="f0Dr0W8X"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OFeJAs2469509
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 17:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8M/0y/yNt6Au7No9QSBsCFPvZ5a324F3UBcrEIuQcW0=; b=OcC1W5SQy+gpK6qq
	hjVQa8Rlvd1UrGSM/s1vNLblgktVLq/YH9S9aQU8+2loHXHzTjCMLzykaeTJxjoj
	uECM7PFPCGAnPgjSmdiMWFBrWrVRY7Z6i8ePKP28SZzd4I1Lm7LjjFFgIbR9I5+w
	BFuWRKc0i+jQW2mDK+WDDF4pky1qcWTKuIFvtrEX1ZI4gO8Z/0GBfPPwXVv2pb5t
	1hqB12eLUsfi+4+MK+jLX0B0icc8SpHxtwyadRE/aN67E0CRXpNnhtyALlEZM9Lk
	uWBrmNKQ/oYIVdsll6aQVoUZlNp1APwHGGEcOQItFZupPDu6VSzffDpXW2Mrf2/T
	NMOpdQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw5q8rum3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 17:43:56 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-86a6f4ba619so95913b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790271835; x=1790876635; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8M/0y/yNt6Au7No9QSBsCFPvZ5a324F3UBcrEIuQcW0=;
        b=f0Dr0W8XyQCVbOkY5EmJQ0cInzD3y1pq3MU8t4rJbbYBa4U1Pp07JivXH5mBMoijBJ
         jPJjDT7+AlrTRG7LUbUVmyjVVm6tTmyL1uKypG3WW2wLCTzpjbG69foFPtiXq1u+CbEi
         7QhmJ8Z2kcyhKVTdtweAxkTIMZRZByFNgmxdyo/SbCMyhSbKwCCZfTyl6INeFR0ibxHy
         xrCzox0TiuHSVEXwKU4QX/CaIu571fqOy5RpAu/cvVbA2z/LAbgPswa+QeXGSVYdiA0c
         ijnvaiha3wCbaXNCXtWx+GJ2uAaRaJw8KWt4Eot9lrpbCh2bVIKSGiekHPXv1HmHDB5t
         aONg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790271835; x=1790876635;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8M/0y/yNt6Au7No9QSBsCFPvZ5a324F3UBcrEIuQcW0=;
        b=RQMdYBDPOby6C3wap9suhEPkk+k41YIMknqbHnVhzFp6SQF6MV59Y8RhkIhlsbJBgt
         8789dx0kEJyuAevcbkGQAsYnzS2wrJaHpim+cpz0uARWulc14XJmtyUxSUoyl5/uo/CJ
         B1vZiDuO9B8ed+XTkYqHooVYGHm1zoZgvwPOTtR6q6gS7ZUr5+gSWDr/C+9nRbMBh4qo
         RRe0CZa9VgsROTWKbyExqWNdLMYUDsjOoytYtX0q+fw6V63Wao+DLEz+Ie0sHcA0HPW4
         hpjljkkf2ExiAMMU0NDiZQLr+U/f0o9m4ZSK4eq/rDoWl2zS34Fppcsm+ZrLhIouaz7c
         j1Dw==
X-Gm-Message-State: AFuF++kCDaktdTLbEJ/qIc0jLdiDKbe8vP7i5PDz2ybGFn/jQAfLVBT2
	H603nNPPwXs+fpM6cqAq8FEJy9ywP6X9dLfYdUfNNXjyiU7FLXpINd3xJUIzNs6UshcegOXRERC
	ItEz9LQqpa0KgwMmYRP7hlzkOmO5KfXtPqWCHhHl3Y2RZwiOPFUiCT7NJ8M9GIYYxEH7vnw==
X-Gm-Gg: AYBFou06BmdIollU1jkG/0Ktu4et9RlXOTrKaUgkN7HfVlpiB7E1QHqvpTzvQOCjiGl
	MIjMezwKNI7tWIOXlf2hKdmatSizv9jk2/xkq7+b3LbNFGbn5uAaAJ3ElJXIB9Dlq5K4qd8EHHA
	gxxggs9sJgxCSTf1lwBviRFLDYnp56nHI3W9RblSnlxQKCEqfDYRJ12wP5z33ag2s8I3j3itRsZ
	pGcp2WJzyQGBAZxSIWyr6ey03pAyIUF/AujbOJlnTY7GlTdPmec6QQ3CYO+c7ClB6LNE80+o1u4
	QHxFuA0L3lKkDPDoDloNmWIh1gb7l4f6tavhFLr1apQnpV/y0WxzwM0eyH7iTMjjaowTwYQv8OU
	GsONiqetAq32YLSCjwz/Ac2/uF1aZ8MSv63oq4g/RvCuJGlWsYgmWqxzQ8Q==
X-Received: by 2002:a05:6a00:e06:b0:870:c2db:da53 with SMTP id d2e1a72fcca58-87e995718a5mr2950621b3a.23.1790271835409;
        Thu, 24 Sep 2026 10:43:55 -0700 (PDT)
X-Received: by 2002:a05:6a00:e06:b0:870:c2db:da53 with SMTP id d2e1a72fcca58-87e995718a5mr2950596b3a.23.1790271834795;
        Thu, 24 Sep 2026 10:43:54 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87fea8894d7sm48218b3a.26.2026.09.24.10.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 10:43:54 -0700 (PDT)
Message-ID: <ac840cef-511a-413d-8e24-308b9e301dde@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 10:43:52 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
To: Ping-Ke Shih <pkshih@realtek.com>, Luka Gejak <luka.gejak@linux.dev>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Straube <straube.linux@gmail.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-7-luka.gejak@linux.dev>
 <45eb7d5908f8fff9a18cba603fd3a4abfe8695f9.camel@sipsolutions.net>
 <31285267ebc43aab631a4199059a247a8d937814@linux.dev>
 <c208152fc5cb45e19ae7d4660394dbf2bc5e0271.camel@sipsolutions.net>
 <bcd5a280-8184-4457-ae52-47a9e0fe763c@oss.qualcomm.com>
 <ffe834a8a469d5febb7e73de371d662f9a0d115f@linux.dev>
 <fe3c6884a96b476799f415a06314f1ba@realtek.com>
 <c419df59280e52baa5e25f665eff599592f3cdff@linux.dev>
 <2694defa2e284ee894005c59197325a0@realtek.com>
 <a4339de07daae1d3ad274067006ed6dfc021434d@linux.dev>
 <5458e6c0dca04e9dbbdc5b714d150252@realtek.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <5458e6c0dca04e9dbbdc5b714d150252@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA3MiBTYWx0ZWRfX0zXfkGzWvvZ1
 6yVIB6eufO211IgIDVGtmFILaZhf7Omjjphad86AzmDUzOI164ivo58hkDIF7NUHnYO43FH6ANj
 0nhBHnQEhmZpZwjVfYt3x5L4Ik5jr7w=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA3MiBTYWx0ZWRfX4Wx8BgrVgu3P
 04MYtYHUK8HbpKsPS2n7IzyqxVxMRutBnA4TosILVdyw/Ie+SA9tNved7PERXOnjAlKFFGNIOT7
 L/pZRJgYmU3YO1+w5fAEZaHPhgiS3ukgztuysG1avJe8DZJDlnWvuZ2mmKWa+5furOxd7F1qWpB
 tqZOvqa30NVMV5Z7mEPxue4tns3f8LMongrXlT2dCVjWfvZq/WVxinZCP6UUinEXIOkJQthul3P
 MkYPGno7woThFQnRUthBzlB+ZIDHi7GrXKiJhivnvrD/oKqrwbeK8p9kjT40pjrjK3pjhL9vTU1
 DkDKEPLtP1UY2y5Su5KszGCAB2P2QVmDZbmHb/2S41ITlLMVsoajD/5mOUMCsv8+cgDG9ya6jGB
 JieEf4v9CBc/RuVLj2HruT6put4f/6eCkTklvLHMkawPwlLXS56tB6n8VB9c1v+vK5VY2UtdG7t
 iOknfcMMrBkEzvx2Jrg==
X-Authority-Analysis: v=2.4 cv=SYRi5fRu c=1 sm=1 tr=0 ts=6ab5615c cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=ofqPYY_WaIQwRNNNXq0A:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: kfjd8AyfrB9jFF_izdfaWgnxo2r1r4tr
X-Proofpoint-ORIG-GUID: kfjd8AyfrB9jFF_izdfaWgnxo2r1r4tr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240072

On 9/23/2026 6:42 PM, Ping-Ke Shih wrote:
> Luka Gejak <luka.gejak@linux.dev> wrote:
>>>
>>> In fact, even you aren't in list of MAINTAINERS, you can still review
>>> patches. Just subscribe linux-wireless mailing list (I think you did),
>>> and reply patches you have reviewed.
>>
>> I would prefer to be listed as a reviewer because as such I am
>> CC'd on each patch for rtw88. I'm not subscribed to wireless
>> mailing list as linux.dev service provided by linux foundation
>> states that we shouldn't subscribe to high volume lists.
> 
> Though you only want to review the patches for rtw88, still suggest to
> subscribe wireless mailing list. Otherwise, you will miss to read something
> discussed in other patches. 
You should consider using korgalore to populate your mailbox. This delivers
messages by retrieving them from lore.kernel.org and pushing them directly
into your mailbox.

https://korgalore.docs.kernel.org/en/latest/

/jeff
