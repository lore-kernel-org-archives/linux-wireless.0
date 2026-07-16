Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4BE3D6493
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 22:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784240154; cv=none; b=FxVUGvEGcnU11XzdI1yuBf8r9GSu5l7x6M3wLxxN/lhnBIByUdGKHCbWrOAaOKSzkMRW8kWtzKy15gFZ3/jVrTJ3yj5i8uGDu+s2F6hniLVsjTYbPPha5jQhWwptepiv8V6rmsDoRrUL2vdsDXex0oVztYFmHDsqvmGGdTwK4Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784240154; c=relaxed/simple;
	bh=GQqo9CiV7JQLABv+7tA6z3T46isVGIyY4M7cdy9fbpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ot+3QPzwqM14yYrPyeMM5C4Gx+ThVfJ5C4m6/RtNXCsBgljmwqPZMk2uy8NILu16xgYFChkjYall7DGn2yB7bIOkXO4LdDF5Lfs3auYgyQmEMFwlE+bxiUXlgvepvCrqHlaUEnWpHM1VKDFtMyfO51tXI4tN3f7z4GF07YmcML8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EljSp0ew; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TgvWViFp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EljSp0ew";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TgvWViFp"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJolTP3841630
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 22:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NMKQda4dVuMkYRZlsJ1mDDmzA5C8SBekER+swHoK56A=; b=EljSp0ewnO9vdcvY
	YH/kSt83yqKIq4mbO8eHXZbNIvXkxdbJ///BODFPe25shNuu60AwZvUnvovvV1oN
	4FbbgjNmHlQnmsMRto1MjIiq8Ord6QP9NAAG4PcmSz6a4E/Kw0N58abI2fp6B+pb
	xyQz/kCOu7Pg+x1cA9czO9WDw9aceGhMRv1PWtaIcyKCbZrhLkX3KzzF3w33ENQu
	TJw54RRtZqnMnpvacaa1R/UVp74E83CyJ7RI6Yczvg/obU4G1whVFJU0TYXMNWoQ
	TGnlkQJkcKehtwS3Tax3RG/H2YuUfIrvAjaL3lhpbIak4F3RgE/32qdcFKYM/GHm
	WT/Zug==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ff3u80yhb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 22:15:45 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e04a53a7aso4815818a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 15:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784240145; x=1784844945; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NMKQda4dVuMkYRZlsJ1mDDmzA5C8SBekER+swHoK56A=;
        b=TgvWViFpmGWYsv25sxab0c0yVE9RcP0/gnOMuL4WaOv3DuZvVNs2RwpiIoM/iBrt8q
         PCFVDwMuFrhYE7AMTil+6ly3i8su/o5N7bILrBRHXz6+coQVVDhGjd0Iu+z1XCM5FxP7
         fmhc0dE82xxRy6CrTpwBH0KWTHseOlonIFnfoGwqWWL+wgEotU1czPRo00y9QJBkLd/w
         qB98cCf37xVFAxl25v0xaUN98e8TVcrLm1ruedkh32pRKH41hBB8kp/W2tIMtvagfIoR
         roLn1JeLYmtNKCoNYhooT8sZqx4TAJ9BWdbd+nWewWNxVgRuKDo0HWl4hmCMpuqex2uU
         52DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784240145; x=1784844945;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NMKQda4dVuMkYRZlsJ1mDDmzA5C8SBekER+swHoK56A=;
        b=Ui7NPXy9npUYxQWE8ZaSgz/ab7zh1HEYn/kC2bR6mubDhDsx9D2tvrfv+TRQYzL0AW
         gQfONj9obPabtDpKA5nd5zkcBx+++5rBUZ7xoj6IDlDwFQGNjZZRH+q5xzlfta6J5Esz
         zb352Ba/1Fw2Kf4G5Y12DqkIDIOPGMKL7tOxGqgZSMMOTLBgcJS5v/p1acFKPJVaRWDQ
         F8bBhie2XgZRfkX9D2p+IIGp11Q4KBQPIK8G+0pHOqp/zy1gfCwBTEqexJaHsqJF1LsM
         0vVh1yBjAYZVFYNcaba3uLYPSN5ytAMET9eWpAeVQIQqopSUK7w4VxfwV6x6pfXJmOV2
         MBJA==
X-Forwarded-Encrypted: i=1; AHgh+RpHPEpyZ48jFDBxZJM92KiZTw9iD6r+Gj0xB5+UG8vv3q26N+08chiTNlwPjGoYR1MkBx6cfHbyRq+6YlLMWw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWoXjXyLwFZI1UkRmH6e5+8yrqpm0tmhjfk0uhoa0EzjNj8LBL
	AnpGIFbLkrnWzx8RkHppKauWCj8uHcF29G2GHejJ2GQDWo7qbpF5qjes27A6x8liwRhvtV+C0XO
	dhXjxXzrj1wBS+lOgmJ3x3pKmdakqxnlZXEcLjbUhFv69G6Ml4aYzTxSxoCRTRQFQOzwP1w==
X-Gm-Gg: AfdE7cmq4zcPuMgrQaM5h46cD9Rlm7KsA1p8STEBoRUhSjWB9AAbH0pVMxMJfzfuiWg
	ddr6v57AvOG82h3lNp5G/dAw3UgkRGMTawp9CD0L7QwHmgVzMZZfS+Lf4BvvztMPBNVuocxULy7
	GXkfpiNiRScIlC+6MKiNWw6tZggPZcz+mySupDPE+0Hq4ZJYdMdH3hh6yBSa9dMGMItLuK+So2g
	XsI88ZsvIPnoAiV0Z86RGqwByqqRHsCUIg3Ri1aKWUMROFr5lR9h+dRajrqfuHMVROCcdRzK0X5
	pQ8nq6bY74lVCeQHCnYU8KnCawZIgVTOm0+DAMzBf4NsMNxqlkUyniBvzW/DEvmIy4fWljOGg+w
	PCzIxbQ+2MFMd9NMNrm6BGHsLm99LzExw4ckD2QImJ06Rpp6S1gGzPFLGhg==
X-Received: by 2002:a17:90b:528d:b0:380:ced0:ecf9 with SMTP id 98e67ed59e1d1-38e29ff9736mr8333495a91.4.1784240144768;
        Thu, 16 Jul 2026 15:15:44 -0700 (PDT)
X-Received: by 2002:a17:90b:528d:b0:380:ced0:ecf9 with SMTP id 98e67ed59e1d1-38e29ff9736mr8333446a91.4.1784240144155;
        Thu, 16 Jul 2026 15:15:44 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429f9d444sm21764eec.6.2026.07.16.15.15.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 15:15:43 -0700 (PDT)
Message-ID: <7bd71d11-d6f2-473d-b5ae-f5fbc972ef40@oss.qualcomm.com>
Date: Thu, 16 Jul 2026 15:15:41 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ar5523: fix integer underflow in
 ar5523_data_rx_cb()
To: pip-izony <eeodqql09@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg
 <johannes.berg@intel.com>,
        Roopni Devanathan <quic_rdevanat@quicinc.com>
Cc: Kyungtae Kim <Kyungtae.Kim@dartmouth.edu>,
        Pontus Fuchs <pontus.fuchs@gmail.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251103195519.3152385-2-eeodqql09@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20251103195519.3152385-2-eeodqql09@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyNiBTYWx0ZWRfXw7yzsfC9pPTU
 ZoQlZFj2VsJKFYUJSnVpP+XFR6jHrOvx31sffPPZSnNnXaAJQmnTssEjCPuP8oFUch7gOVnYv0N
 k1i52qQCzC2z6PDgHagNO9sVtcvbxF8WLF+mwJrozW7oxqYAIyzWkdk5cCkCu0hP6CNPCZGUUN5
 DhEJsNsGsj1DB1V4JESJLVn2BUkByGxYceqkNUmkkbwzP/pJx9hSwHHJkeKzIOdYaLcvyu1f6it
 3lbRxreZUfpwFfOzn9+IIco+YQlcTaJ0J2Wgb8JdurnL68BgJlVYQdR6gRAhgh5sbddZ8Vpqvmy
 EMXJl1WX1nUaYQl/UwdzN4CL76qJqbM4YRWaWZsqP9umG6Bef2YSq8qBAyxpQtt5SoK8xKinosW
 QJ8z7zVmnjQlzdUwoWY6hJl5FCQ7qi3ElbwNFhnElbTymuc4BWS4Fx3PxN9UtueBdC0iUhBwLEh
 7MUyud7wUe8hnCHN4AA==
X-Proofpoint-ORIG-GUID: P5qlobuBdonDxdrp29UI_Bm3EFPLxmY5
X-Proofpoint-GUID: P5qlobuBdonDxdrp29UI_Bm3EFPLxmY5
X-Authority-Analysis: v=2.4 cv=VMvtWdPX c=1 sm=1 tr=0 ts=6a595811 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=pGLkceISAAAA:8 a=AuuJo6D-WAaWUL1cUgMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyNiBTYWx0ZWRfX8ADfXmKlMtJ1
 In2WzVQ2WVJbCF9eXXQYD3RoKDNoUEkf/qCTXO5JJh8UsBhg4tUaBz+wbWg/JYh7u58KVR+Qh0L
 XRBab42bEJehyipU7wQ3DBN4JU1VaIQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607160226

On 11/3/2025 11:55 AM, pip-izony wrote:
> From: Seungjin Bae <eeodqql09@gmail.com>
> 
> In ar5523_data_rx_cb(), the `rxlen` variable is derived from desc->len,
> which is provided by the USB device.
> 
> The function checks for an upper bound (rxlen > ar->rxbufsz) and for a
> zero value (!rxlen), but it fails to check for a proper lower bound
> against the size of the descriptor.
> 
> If a malicious device provides an `rxlen` value that is positive
> but smaller than sizeof(struct ar5523_rx_desc), the subtraction in
> the call to skb_put() will result in an integer underflow.
> 
> This passes a very large unsigned value to skb_put(), which then
> triggers a kernel panic upon detecting the potential buffer overflow.
> 
> Fix this by adding a check to ensure `rxlen` is at least
> sizeof(struct ar5523_rx_desc) before performing the substraction.
> 
> Fixes: b7d572e1871df ("ar5523: Add new driver")
> Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
> ---
>  drivers/net/wireless/ath/ar5523/ar5523.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
> index 1230e6278f23..dfaccf241560 100644
> --- a/drivers/net/wireless/ath/ar5523/ar5523.c
> +++ b/drivers/net/wireless/ath/ar5523/ar5523.c
> @@ -589,6 +589,12 @@ static void ar5523_data_rx_cb(struct urb *urb)
>  		goto skip;
>  	}
>  
> +	if (rxlen < sizeof(struct ar5523_rx_desc)) {
> +		ar5523_dbg(ar, "RX: Bad descriptor (len=%d is too small)\n",
> +			   rxlen);
> +		goto skip;
> +	}
> +
>  	skb_reserve(data->skb, sizeof(*chunk));
>  	skb_put(data->skb, rxlen - sizeof(struct ar5523_rx_desc));
>  

Since this is an orphaned driver, this patch has been sitting in my patchwork
queue for a very long time. Today I decided to take a look.

The patch does address the issue mentioned, but really doesn't completely
address the crux of the issue. I believe there should be a fixed correlation
between the rxlen and the usblen. I posed the following question to my review
agent:

given that the usblen should account for the ar5523_chunk header, the payload,
and the ar5523_rx_desc, shouldn't the rxlen always be the same as the usblen -
sizeof(ar5523_chunk)?

And my agent agreed:

Yes, that's exactly right. Looking at the struct comment "msg length including
header" for desc->len and the frame layout:

  [ar5523_chunk (4B)] [802.11 payload] [ar5523_rx_desc]
   ←──────────────────── usblen ──────────────────────→

  The invariant should be:

  rxlen == usblen - sizeof(ar5523_chunk)

  Because rxlen covers [802.11 payload] + [ar5523_rx_desc], and usblen covers
everything including the chunk header.

  The code never cross-validates them. It independently bounds-checks usblen
(via AR5523_MIN_RXBUFSZ) and rxlen (upper bound vs rxbufsz, lower bound added
by the patch), but if a malicious device provides rxlen > usblen -
sizeof(ar5523_chunk), then:

  skb_put(data->skb, rxlen - sizeof(struct ar5523_rx_desc));

  ...would expose bytes beyond the actual 802.11 payload — potentially biting
into the ar5523_rx_desc trailer bytes, or uninitialized skb tail space up to
rxbufsz, and pass that garbage to ieee80211_rx_irqsafe().

  The existing upper bound check rxlen > ar->rxbufsz prevents a skb_put
overflow (since the skb is allocated with rxbufsz), but it's far too loose.
The right check would be:

  if (rxlen != usblen - sizeof(struct ar5523_chunk))
      goto skip;

  Or at minimum a strict upper bound:

  if (rxlen > usblen - sizeof(struct ar5523_chunk))
      goto skip;

  So the patch fixes the underflow but misses this inconsistency between rxlen
and usblen that could allow overreading valid-but-wrong data within the skb
buffer.

So please consider this analysis and propose a v2

/jeff
