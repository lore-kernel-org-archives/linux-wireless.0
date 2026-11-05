Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793847374;
	b=u6rGGYpiARc+1kYdYuSr6Ue3vMle/sHeFr8YsQ4nO5MXYr7VlrfBYjoAFsGc3MTAl5am
	 q2ITN5lxbCCHBsaPtr2e/2M5jv8tkr9UCZvudipfhXyiylsHf0dlbeYIaOHswKld1iuQB
	 RIYj+LFfZ4NQHua/swDO1UDY28qG1ujkrQO2fAfr3C97jb6VUgverqTbQd4bGsaFTglQf
	 iIiYoRUAsYLnDfeUV60vs2nNmgI9b/d6okf5Duu3LhZ/Dclv1DIqQSJJP6CfQ8B7qFWmM
	 CgphENp2O0ltUG8bMEDbK0ty4rAgGY6PBOrko+YAdSmfYUe40RnKT4SdZnzNBa699hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793847374;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=JhZhM6VORZEzX3uY6NCIhc5FNlmY+e2EE6erE3rZQyk=;
	b=Wpi32O5IXmSih5XDjDlwlHOa23kdxLK5XYe55t03yNsYtEY7JTGlr8wURu12aSRc++nG
	 ptmSE+PuSQKGXdtGKzb4lKaQIaHaFtcbuW/O86zqdugIn9ZADoQbwQ8o51dug26VToiak
	 Qip0ZB0yQhFHMYX1vDoEyHJQ4c+5dotB8Mp7zwmRZt5swul+xWam85tpIHjZC7hoKZu58
	 PESK7EkM7To2bDY8UvE7rRmfJJXhYhjw6VphN02IO+tAM868L2CQJop2+QcC27TV1rXaK
	 06eSNcs14JfDqZXl8Rcwv27nynWKVsZBHq3a5ekScMf/qe16gzwLBZdvoEJ5T7IeZxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fmgcoNRO;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ffmU8c5h;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA27606A336
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 02:56:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDA27606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fmgcoNRO;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ffmU8c5h
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A51aeVL3182347
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 02:56:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JhZhM6VORZEzX3uY6NCIhc5FNlmY+e2EE6erE3rZQyk=; b=fmgcoNROc4S+B6Ul
	h7YkbSrh/xUCVCVqYuNFrfoYE1rvtDe67Egat3icLB7wsDn7yZpO0y+bH30GeR12
	KPV4WCGlD7+YQRbDF+xg55tMhsHD4oB4AxSqVYahP+W9Y3/Cort/TvlcK0FkC6Kw
	Dtn02zHzk8keeaFMpARgPWL+f5RRatCJSc0Sf4Uivv3Kob1sPBmnDrPocLVIoGW8
	YTZGAnnTuhEPqd+jHf7LBS6faygmAijnnMs+uO/gSjA9YQEXePfUijDuSiC3vATW
	lb0eiDjID/3zzgo/JnBNWQaq/a/l7/Z0HEHRn0AnBriVZqD3v6YdMufymvZbK65N
	MlUvPg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hra5thqgj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 02:56:12 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ad30487d55so2509651a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 18:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793847371; x=1794452171; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JhZhM6VORZEzX3uY6NCIhc5FNlmY+e2EE6erE3rZQyk=;
        b=ffmU8c5hSZy2OqZWm/tqbSA/rALAtvNu0G1nLsJFGV0jnHfL2SyDGUyxjx+u72I4Da
         eWJlbd0uE8vqi/UCptw+J7JcaCQpcPYpmZtV+y8ccLkYMz6Cuzzlc5odIWYlkKVwj3bX
         57It/sMcY8lsrN1g08skq+1ztznwkM8LIjo+LqaBDfUiY1iXuMeHnmlH9r/GRP+rDDKi
         YfRBQx4LA6JVdpKHOoETpPCRV8OLgpHFOv7pwYaOR9DATsSnjxMz7vvTqv2uS/ixlCzq
         0DQyTarH0fNgWlrZYJTtXMY4IiksErkaajWz3lY7NzMEAAQ7hTP7JkhYeYQF73NAML3U
         wfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793847371; x=1794452171;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JhZhM6VORZEzX3uY6NCIhc5FNlmY+e2EE6erE3rZQyk=;
        b=b1e8r3duy5/1JFcd4GZGRHtnl+WoFaB05fTK1UvvBtjlAc12p+m4QMwsQ3/wbJ1h5R
         sQe4oGuquCm9Sr+S2OQtrrM9YBUyRjv6S+aNlQFcwaKqK0daWMk3ZnsmzmxExSa3C7FN
         /a8LBwGigDzaKSpkRxjOQbJKxZs7ZN1866pAzTojmggQlSEDNqUpI4ufOykXbwxrJ1Mf
         QBhw7m5hlRXyYEjMnQY+CwvxUXEGJkUNq90rNHJaRghdyWn9lAg06SPbMc/I6xXO5VBW
         eWtChoIE+hGgKMwK9pVJ7jOEz1rc3n0VFkV+HSbzI/Cpgw/A8ytVdvm4SsDTytL27Lsx
         ZR0Q==
X-Forwarded-Encrypted: i=1; AKwUvBxfmuqcJfOSKgF/CInbwpnYWdUcq1g2zjQnjMGI2OLjtzv7zSmmrNuWJ5MZlxGN+elMm2VsmJKDV/tE0YkNww==@vger.kernel.org
X-Gm-Message-State: APuU4Z+Coy5XyrIyJYBlXoTd7SmF82bq96vh0OWjNVpay5gIIcLQ3dah
	hf/tdAepB4FnRJFG6PJGd9NS7mKAt+gWAeI9pHfftGT0MgGhJ5HVbgPQLkZZ5Yud6VPYyBPCSUm
	qAqj9od4Z9vIRFrfR6Qg37Nme+ehTBAQN37zDpJEZ0JAy/J2QenvcEZBpEg8esFEkLH6QIlIty2
	3WFVf0
X-Gm-Gg: AYBFou2RPsWKb88EVRR7bsYCIbI86knsQWfRUiPqEUk16iTHVivBwX180UPgj9GQJri
	1ng+Ir2VG3ae6nHAsKyK517VqvwXRpJLZm1F4JWEWRXAHE4rdJ/UI4maG8L4AZcdjS9Fzz4LiK1
	QwCMF2bE53s7DlaIJ4C5kJowU2xVs/pQTp49fFwyfAXDYv2S6RBi9w5WXvx2JhblLr+mNKqjzpB
	v/1b7Fm1JNycT986boIsXxyj56F92vjGsUeVE5ElkhhCHW2ZVox2zcRGilBzdDPNFIivuXKXQ6x
	IPiqE27767PQYW24RfPvaDg3vlwjdbwRMH68JsDmTjGZ64MMrJ2aT7fQAGLicRSlw/kJlnF9BLV
	/Lqg1aPlvi4D10nNthhEwN8r3IdTBH4SeqEyidjL2QVYBVkZkIR2Y1ESt81eS7rVRmyi8HfyWnF
	yUBh4=
X-Received: by 2002:a17:90b:5868:b0:39e:6c68:c77a with SMTP id 98e67ed59e1d1-3ae8984b11bmr15507994a91.48.1793847371278;
        Wed, 04 Nov 2026 18:56:11 -0800 (PST)
X-Received: by 2002:a17:90b:5868:b0:39e:6c68:c77a with SMTP id 98e67ed59e1d1-3ae8984b11bmr15507973a91.48.1793847370740;
        Wed, 04 Nov 2026 18:56:10 -0800 (PST)
Received: from [10.239.104.253] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b3160634sm1439848a91.6.2026.11.04.18.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 18:56:10 -0800 (PST)
Message-ID: <3abdad84-66b6-43da-9eee-c3a537230821@oss.qualcomm.com>
Date: Thu, 5 Nov 2026 10:56:07 +0800
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
Subject: Re: [PATCH wireless-next 4/6] wifi: ath12k: register regulatory
 before wiphy
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
References: <20261022101836.148512-8-johannes@sipsolutions.net>
 <20261022101836.148512-11-johannes@sipsolutions.net>
 <d613e20e-16c3-4a39-b9a6-538a8740d2d6@oss.qualcomm.com>
 <9efc1e507a2c7eaf6ab68ea0be0f5f02178ff4c7.camel@sipsolutions.net>
 <5abcac80-3eae-42e6-bf56-7b3e9a232577@oss.qualcomm.com>
 <4abefad9689c00bb0343619687581ba7f33b5ded.camel@sipsolutions.net>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <4abefad9689c00bb0343619687581ba7f33b5ded.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDAxMCBTYWx0ZWRfX99/n5VNYl1Po
 67ojqdQBKns53qP198YxOGuVd1QyrtnaFd9eK/vNiDt6xjzcpZJh0Ue9oXD/ETcmaiAa3LVeXKI
 9qvnGg+KVPc0q/tF4JfLpSeGmotKEz4=
X-Proofpoint-ORIG-GUID: lmY5g7N74XVY1TywwJMpROiBmHpNLWt_
X-Authority-Analysis: v=2.4 cv=P/6vFSAu c=1 sm=1 tr=0 ts=6aebf04c cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=zXj1vgSgYCrzNcyJPIMA:9 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: lmY5g7N74XVY1TywwJMpROiBmHpNLWt_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDAxMCBTYWx0ZWRfX68lmKjVZPjWR
 Wej8re49yTBOkceAGF+saUuOOEkl+/14L6Fa7VfZEDjEyGo/bc0P6ze41fES0fYoVIviyjQbnbH
 HBooyBR1FGqoyNeX/GchKCkAoOF1LcG33cI0BIvKnXh8Uv8EwiNL+xp85IO2rBGQlU4TJ4Rq7yV
 W63On20jn0teTt+C5YyS7ow3uslvx7OtyegpnxSMAFgxcIXcJmjvqbnnLR99gROyFdNOPFOZ+xZ
 yLCaZmfPuv0gUBdGaFLuuxmzB1Hik20QZMBvtg6/tSkROn6apjmwdcY1r9XDbJordCEJiIPvW2J
 lY9wDlGHJdOOTuv6/TduFFljq+MtSyBm+zbOV+HBTANDkqyGJLJc5nYBa62T0RgC7gvrZ8hTDdu
 FMYobqGSRsjvRh+JLVacb1O1wvpPxx38nu53HB00vgF8oeACaT1bZTWfKTqvyUwy8R1PinQdfHg
 TVCmZBh6WIpeBY37UCQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_01,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050010



On 11/4/2026 8:44 PM, Johannes Berg wrote:
> On Wed, 2026-11-04 at 17:18 +0800, Baochen Qiang wrote:
>>
>> I ACKed on the ath11k change, not this ath12k one.
> 
> Oops, right, my bad.
> 
>> ath11k regdomain handling is slightly different from ath12k, because of what we won't hit
>> the same issue there.
> 
> OK.
> 
>>> Despite the long commit message I don't really understand the commit you
>>> point to, I guess I'm missing the FW side of things. Also not exactly
>>
>> Yes, there is a race between firmware processing the new hint and host reporting the
>> regdomain during registration.
> 
> Hmm. But during registration now we just get the hint back from
> cfg80211, at least after the last patch in this series?

From my reading of the code, the userspace hint itself still reaches the driver
synchronously from wiphy_regulatory_register(), that part is not changed by patch 6 ?

> 
>>> sure what you mean by the userspace regdomain hint "during
>>> registration", I thought this was self-managed?
>>
>> Yeah, ath11k/ath12k are both self-managed, but still open to userspace regdomain
>> configuration like 'iw reg set ...' if necessary CONFIGs are enabled.
> 
> Right, OK.
> 
>>> But I can also change the patch to do both, cfg80211 won't really care
>>> about the second call after the registration, although it might send
>>> another notification to userspace and cause quite a bit of work.
>>
>> Understand the concern. The regdomain code in ath driver is currently a bit mess, I am
>> planning to clean it up someday.
> 
> I sort of just want to do the cfg80211 cleanup/fix, so I'm happy to do
> whatever you think I should in ath12k - just keep both calls for now?
Yes, please.

