Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502703F6C3B
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 22:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785968582; cv=none; b=OYhGLwv8Igy8ZzqKE3PvEKchaslvL81wC3stVHfE7Nk6dC+4MhWLn7Klp4INUQezZ8YcJgG548YCK9h5uZ592t3C59scZDuQPSD/OLYzP5ggoiQpcHiPNuy4hW7e16JbE5fSJhCk5oXUpkey9yrjwFwf+1+36Lf2XnEDOOHcdpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785968582; c=relaxed/simple;
	bh=OHnRjIHFjIh6JN/AxKvenjOteXf62zvdZGHGUigHpV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=knrEknLHGjUTHup4++zSSgM/fL4cOPHFJM41RGA4J+0RVON/BbITch2GERyySJ1XmJOgLhq+GqvIW7VotnltooLfouBq/MAs0fvWxmHEfQebi3hb4NLx+MqftjRWvXYHx5SmP+pg+bVWBC5hDAA7lR98d/hPXCGQNQ4i7paIErk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DxXAU+FV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PRAxNk6J; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DxXAU+FV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PRAxNk6J"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675HRgWC561051
	for <linux-wireless@vger.kernel.org>; Wed, 5 Aug 2026 22:23:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	a6BAVQ9ThanieDXugfzEu/sNGCAt8Zw60hFjdT0UDDI=; b=DxXAU+FVPnXkEnko
	Yf/qW+VDDAXPcNbCi9VghuDBjMfQwwG1eRhaZTN6OtWvml3jpdZkTtnhAF4Z5YJD
	yFThydPazJ570cJNak6yWxJG5UINa6hjcnk2NkEGovlSq2sRjgayag6025IMUmnR
	VHfIPk8aPThW4Ch06903k1cd2qFbuK7t3YetOhY+CesElUs4haP1gWmiyKaxNJ2A
	640keZxgJThBcL0N2KGTqo7zUt4+xYTisJLXqxJZaTij9LmCfvMSbi6uDmL1FrYE
	YRx1o7dGakHJDCV7JCW8KwPb65KEUtkQ0rWXeQ1UCkSopYIRYfPSoZZBLS7GQTnw
	PNR+Qw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fv9dmh4wq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 22:23:00 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cf7dd9fd91so13902205ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 15:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785968580; x=1786573380; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a6BAVQ9ThanieDXugfzEu/sNGCAt8Zw60hFjdT0UDDI=;
        b=PRAxNk6Jt5MoCIvTlzMOsAng9nHyIps+RUTfzQf2XcARc31sQWXoYzTloYcLVkrf6U
         jgS6bnirmC6dCCJNgEHsgQJq6JbdcSYTeKzs4CMIoMQRkVRi1cD6SrFxjzq7K2bIEGOx
         B/r1c6x+FKYu16XoFtmKxx+TAxKtEA/Q8gLlnUKPZcsMWzVVAa12ITkyYonxEZbOgxYm
         wHzEb/a+2M4h1liCKdUX3bXTzRzyQg5jiS+TXZtDgjlwDZEv5sVrNdvgq7AcNwYibVXo
         H4RLB5UaFWaRbrt4dYqkiWwJxlfMUoqBzKL97UlG+on54yBRIraW0FUe8tBFKv08qqFf
         7TdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785968580; x=1786573380;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a6BAVQ9ThanieDXugfzEu/sNGCAt8Zw60hFjdT0UDDI=;
        b=ZkqUlI0rNT33Gw34zzty+q71cyleMG2LwvcI8aCIUaJj8Q48rc+aZFcxpZbWbK//4v
         7AzZJFECFjYeprGxzpQG5z+HSRNOyRl9JLy4tm++Ymeai7YDX8jrmejAZdIjDt2O6J0L
         ZruiLB2WyK1DqpnaZU+LQWAqJlYWygtRZ5oBaWvvx7dTK1A/fQtcfTSpWzQmQYonWC+y
         NwAnWrJuACoznBtY1/qvUZTh/TNnzBh4b0X6Xj79H/FMIN+b7ysB6CUUXfqEiOf9iAyl
         R+xirLi/xDGG/5YdI7LWd1c6tkU0O1AhaJcyiZM+NcTGX2P6ebI1DuEaFJIri2vKY5HU
         3XgA==
X-Forwarded-Encrypted: i=1; AHgh+RpT/1mT7JjVNA57tc2MO6LBW2MdBHNQWhxBwfz4whpDP99KelmRdy3AJ7cbidnXqf5nynfYqO2SssD/oXsFrw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeyTjpRuIMyZnue6MFRNGOzl4arszLOZdQUO8d/r4c87wRiOm6
	xdY1T/znFE+zzZdWUmTHpI88nyn7/v1H271ht86RBAXjfhwa/WnyI20Qn/lkat1UGZ5IwgRUGws
	S89utge7eY/B/luAk716WQbAvTi4KjJDgtxHYuGwZ017xhWIfwJ1Wa78GvLCTrt6W/R0x6g==
X-Gm-Gg: AR+sD11exY80rBsu8oF+4F+BGqV9NvreuV6sO0QUQCbaD9wiC18fXUZmP1qpKdobsgm
	g0UalMVFzr5o88baU+VUQ00HlhS4mMf79C8UX2X1S/YILKRKuYEyLZjzTfItFKkQXZKlvZt5z/R
	KwMF2ZdgDEbgP9zPRDgp5h5BIHUGE5FUpoMulUW3ldpaS9iNCZalBZYvMJjhO295O74AFqhqLon
	WCE0NieEUUDcHK8Q9EFRDV2ZYWv7ILGEt4pLVL+B1UtuF3ibqrGEQ1uzPJffkXK2ftF4OCIoNvz
	ta4hl6QrPWCPbX9tcneZlYuem1fnkEpptfNI08wvRPt5wPAgminJOfBBJKCFcN0dl3gktJkNYdr
	ItyrW0rcMwO4iNffwp37TzQP6HOLkC0M2zLwAH7kWk+oI8vyBx8m+iIGfAld5
X-Received: by 2002:a17:903:3c68:b0:2c8:f34c:82c0 with SMTP id d9443c01a7336-2d0ca7120ccmr120510005ad.2.1785968579724;
        Wed, 05 Aug 2026 15:22:59 -0700 (PDT)
X-Received: by 2002:a17:903:3c68:b0:2c8:f34c:82c0 with SMTP id d9443c01a7336-2d0ca7120ccmr120509575ad.2.1785968579243;
        Wed, 05 Aug 2026 15:22:59 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158673be99sm34518778eec.15.2026.08.05.15.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 15:22:58 -0700 (PDT)
Message-ID: <39262e9c-e41c-49d3-9b95-6aeb81d2e864@oss.qualcomm.com>
Date: Wed, 5 Aug 2026 15:22:57 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] wifi: support authorized roaming offload reporting
To: Jason Huang <Jason.Huang2@infineon.com>, linux-wireless@vger.kernel.org
Cc: wlan-kernel-dev-list@infineon.com
References: <20260804030450.232028-1-Jason.Huang2@infineon.com>
 <20260805110116.35884-1-Jason.Huang2@infineon.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260805110116.35884-1-Jason.Huang2@infineon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=TJR1jVla c=1 sm=1 tr=0 ts=6a73b7c4 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=bUQKSiCPAAAA:8 a=2yOEcQvKnnliPOLPb-sA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22 a=-fHZXUhsFbuwFN3fwQAr:22
X-Proofpoint-GUID: 3qjWHcUbV5fOvnJpb3HUJVxHjy2Q9msS
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDE4NCBTYWx0ZWRfX1yMOQReDwo/V
 tStqITkaNeqPLZ7h6VXfGFlJDaqW+mME9MppZ5vzru3m6JpQPn0+KrySVfJrFJ/+jSYfLTBtiZ9
 ll2dluFDjKn8e5IumEavx2tsIuzvoKc=
X-Proofpoint-ORIG-GUID: 3qjWHcUbV5fOvnJpb3HUJVxHjy2Q9msS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDE4NCBTYWx0ZWRfXyh/kdYxIdVCG
 IpHdZIdnJ+/Y3vBvTyev+k+3OC0pbXEkHiS1asJPp0j3kTqkDVVxJ4ZCorGwzyy90n3nW+HuWxv
 q1/OpNURLTABBtII0xGSwKvgucxNVIXux7lG56AxW/DFuFny5XWlx20P+KHlJBd90p7riGkJsmJ
 Chsuv2iZ18OLadPDPiOU2Sa40YvZ6c5NSQU7OZMnts7J2dkdxQokbU+/t8d+PVh0E27zbJNNeeb
 jecL3xDPR6MOYpQZzSPZTjIVQSb6JZb8jDVCtNrkDRkfpDx2Z6pkoG4UTRpPaRQXutmNa79fhQ2
 iB/aiNF6brFOfEFyKxn7/jtL+ugjr6znWQXNB5W4xAxE2IJBBj/HxNX8Fmg/zIOGpAo0uZSPpWE
 4QaL510ziXE2XEY6rl3DHpfMWsU6/puIBE1pjzy6ISW3bZ/u+ay3RAoEExLxMNLHYjgckKVwBtr
 bQbmfOjUoCGVsYKDZTw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_05,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050184

On 8/5/2026 4:01 AM, Jason Huang wrote:
> From: Jason Huang <jason.huang2@infineon.com>
> 
> This is a shorter resend of the cfg80211/nl80211 API patches from the
> previous 7-patch series. The earlier submission appears to have been
> partially processed, so resend only these two prerequisite patches as a
> standalone series.
> 
> The series lets drivers report connect and roam events that are already
> authorized by firmware offload, and adds a roam offload extended feature
> so userspace can provide PMK material for FT/OKC roaming offload without
> requiring full 802.1X 4-way handshake offload support.
> 
> Changes in v2:
> - Resend as a shorter 2-patch series for nipa processing.
> - No code changes
> 
> Jason Huang (2):
>   wifi: cfg80211: report authorized connect and roam events
>   wifi: nl80211: add roam offload extended feature
> 
>  include/net/cfg80211.h       |  6 ++++++
>  include/uapi/linux/nl80211.h |  8 +++++++-
>  net/wireless/nl80211.c       | 10 ++++++++--
>  net/wireless/sme.c           |  2 ++
>  4 files changed, 23 insertions(+), 3 deletions(-)
> 
> 
> base-commit: 6c5fc504d0d6934132637aa3db4b9b58148eaa78

You need to figure out your patch posting.

You posted a v2 cover letter as a separate thread (which is correct), but
without the two actual patches.
https://lore.kernel.org/all/20260805105716.35643-1-Jason.Huang2@infineon.com/

You then posted a v2 cover letter with the 2 patches, but as a reply to the V1
which is not correct. The new version should have been a separate thread.
https://lore.kernel.org/all/20260805110116.35884-1-Jason.Huang2@infineon.com/
(has In-Reply-To: <20260804030450.232028-1-Jason.Huang2@infineon.com>)

If you are new to posting then I strongly suggest using 'b4' to post patches
since it takes care of almost all of these details for you.

/jeff
