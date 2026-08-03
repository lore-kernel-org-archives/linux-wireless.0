Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4388A4137BA
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 15:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785770861; cv=none; b=HCpYoPpSKXsiISqiEo2fuy/+6pI+BHE0tQt1sovydKw/RMT+h2iCYGJtPwapgmW0dFiRlUL2cDIwQu3ofsGf3eBZN7F+l7YDlp+GUooK7wCy6i9XsyAgxaQzLiMy8b9ZmMLrCDwEtcfeycUufUULtga1GoSRBYw2Kv1/Itbd/1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785770861; c=relaxed/simple;
	bh=c2vXKiq7DSrIU9oU3HbOkXvwhlZ8W9HsgtJyk+YAtow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rxi5wPTDVIy3w5R4pTCBqsXtbhSJHFhBZEuUM6uu8y8NfanymlS4HowA97vfGnklj57L0tw/yz+4fZ7GZuaR+dYLUj0aXBLxLDCvrUdW9HQl3s5hLW26PvLPdB6I7W3AJQSqDtqcNuuv+f3QHcwuBjfPaJ/yeUirKxgIDQqkmO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nUyNmum3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Fr34Zwds; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nUyNmum3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Fr34Zwds"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673EBo67826855
	for <linux-wireless@vger.kernel.org>; Mon, 3 Aug 2026 15:27:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GGYViWXurUa0HzGP77CTZFQ5h9rjO9etmSEsVqjPpLE=; b=nUyNmum3kYC4RjEN
	NGeYtedex4pArQGhwwv67zupdSWUTPOKi4ZiwM7pVf586zWVCAuYsoUH3CUeHTDM
	cCFhM8cgGoFWIiSJoIveSb1YiGqO0hkRecPfK1QlS0nZLLH/1IF3D9hDrhZYR1sU
	051eOjSC+pCVI9uciNaO4eoIhp4hlfTZGKRO2+pGHWwrFCEhflm5ngBiBdymOZDi
	LxtVvU2H7syYibeAriJzHuxDHHnuz3iGmbYHDuSA+6T0OF8SqvI9r5nITj2EC80B
	VfxBcZk+tnWMOVebFYcwEbHL4PNka7OK36LX/eaD5BGprAS3RNqYo5gfoNJQA4Nb
	YBSGQQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ftnhkjab1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 15:27:39 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ce7fabf76so1654840a91.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 08:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785770858; x=1786375658; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GGYViWXurUa0HzGP77CTZFQ5h9rjO9etmSEsVqjPpLE=;
        b=Fr34ZwdsD//xhTfa8Uwnb/n/ZRtS2s8c8/mZ6VIYoY5KXoROq+GIMjEaAvgy74hwLB
         1Cq3fnha72bsohAEAdpzIHRuE1m3h3PdRLvF5kMy5tLsdMwQUGATTA/Q3Yo3uM2X0lSQ
         W0jBWbPUWXSQ2WgzyEQkL2XaLWQJEMYOY+Cb2Iyjmf3jYicEezQSy3VQzlVhdjrP9Ddo
         tAmmOcdYhrctBcYpXKeNEydzBQdjKA8p5v0Mc/PX1xIjMGbqrsDO3I4FyZxPeCQHgLUc
         x31WuSjfKjrP3sdTkKRepZddlEeqEAEwnQnKC7Kl3rnVfX0WkTG5mQiqKOwhwx/LKqpr
         rphw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785770858; x=1786375658;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GGYViWXurUa0HzGP77CTZFQ5h9rjO9etmSEsVqjPpLE=;
        b=hOL5WIlwvr+t2zz7CcAlqlu+Ca/Em/WXOhwf0Epw6o1W8qgXPdN2ADuu2KIkIAQZXK
         e3FqkKQAcT84QiJt+NPV1HUUJhX3EUI4Ft4fpssNwHU6Qv6LIZH0awDj2wHICsKs4tgw
         15qbX0A2RI20wxKv3EADs7nIJ3rMrvYjBx8sesxC+np9IYcDbxhfjIB7vESy0mZmgULD
         803tmOLwlIMFZBM6NgSbXfwtHXdp9Il2/dh3JrEr5Zzpzt+afKJJo0SLHxhxSYqcO0nB
         lE6zOQc/rbbXquhYDWD8KmAnDvlXMa5KuenuDZZwebCmABEiIaLBtue24jpkHqQWJqdS
         rLDA==
X-Gm-Message-State: AOJu0YwxqvQTdNuUxXmahV0ZTK737NaDYt/ZRBm4/Owt2z97jhcci5Fi
	BDH4snk0GaVBT8ZnvadFbtffWrOfX3xYReLg2KceUiwA08OSz/NsnW3SwAJkcAMn1KWKukSomUE
	yNZGQMqvHPTjO+13kmlk4k5mC4TUUk36VV4fsFgck6DK+PNGzUoZubZ/zfMx6vdVEge6uCw==
X-Gm-Gg: AR+sD13/Xn5Bb2FqVi6aacLPp6FZwUk3AkVsboHrewFVc8Lz4CITs1GWsc7Pi1YS+84
	tqvE2FSpkgs4q4KdnMC5tqOsEGsr7W9TybniSlgvYnqP670fOQ2JRTpwRzfPS8OdfM1mIBZj1S8
	50xxEzUuv+ZUms2OOsWaRM6BEpm3g5d4E7v4pJ1E2zDWNHDGHYdTocmpWbOeII5yoNz7ra+LwyL
	p9aN1h6LNcowOQaiW4SySwreBUbXizcB0AZ7hBmLRnu3lMVhQzbsNvPMXNCbW6f66ShXErpf7FK
	U+eQZGuTlALc/z4hNq6s3FrzKz4dsNIy8Ba7kRNiEHHV+vX3dcxjReuqokaN9kNf4HvKxzbBFDs
	jtwAdYUPrLod2C19N7nDspG7uoVxxKVvZfjyTsgwg6KLt1YaDA1zfXjjORWvY
X-Received: by 2002:a17:90b:164e:b0:381:dc88:7c09 with SMTP id 98e67ed59e1d1-38fbc56cda4mr10079844a91.33.1785770858127;
        Mon, 03 Aug 2026 08:27:38 -0700 (PDT)
X-Received: by 2002:a17:90b:164e:b0:381:dc88:7c09 with SMTP id 98e67ed59e1d1-38fbc56cda4mr10079824a91.33.1785770857730;
        Mon, 03 Aug 2026 08:27:37 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab4cb50dsm53886955c88.10.2026.08.03.08.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 08:27:36 -0700 (PDT)
Message-ID: <81733f86-829e-4c5a-8a52-58b594d7301c@oss.qualcomm.com>
Date: Mon, 3 Aug 2026 08:27:35 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: pull-request: mm81x-next-2026-07-31
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, arien.judge@morsemicro.com,
        dan.callaghan@morsemicro.com
References: <3wboegj7eyorursqi7gftc2s3jqtrfi5fv3k57eoqrr5arxmnh@2jextspacknp>
 <c0d041baca23377772791242ce0ef241aaba4112.camel@sipsolutions.net>
 <2uamaledjzr2qlvixwrnhrd532ugmbyeajpnljpjurj2tflld2@ak3ym3aalkn3>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <2uamaledjzr2qlvixwrnhrd532ugmbyeajpnljpjurj2tflld2@ak3ym3aalkn3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: VmYZ5gbWVixE800GOxQyIgbgBGI61i2R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDEzOCBTYWx0ZWRfX2THbGaJSkPur
 xQcKKW2iukuemOGKGhouGFnRLS+QAQa2XjAduKDQOoSaV0zhjRN+hYF+IhJeNidRsAkk7c4+0ip
 TLBUdH345ApEKs17+qh778SU1JLMhLjnxb7+Cl+WMIu/iG4PMYD7M9DlSSudXq8DJLV+3tymW+U
 I2/4VQO8Plw7K6hqc6r/Y2AYvNpocSBiTgkTUjn9eySYSpvXvgpixEKGAK+sK/qqa3mq26YRyyQ
 HCckhlwBAhN0cxLAK8OAEQ6oJ1ZIDsz69HtDfizL1Qm7qUzs+LyYswrXNUfvfggrMhL13JBITZa
 Y0RFIogQUYQcQIw5BKF62q6n0Y7ziLni4H6L5tzwH3iE+CCoVq1/SrGFHmNBbPSloLQXx2PlhfG
 u7jxfauq9CCojaRlUI0Y111+JNMq7b/Qwwmfejlmsg/1I/ZFKk8Lo8jGtSoGL9WmfqOwnPj+J9A
 EXEdEN5SCbsE8rlLaPg==
X-Proofpoint-ORIG-GUID: VmYZ5gbWVixE800GOxQyIgbgBGI61i2R
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDEzOCBTYWx0ZWRfX9MaHrtEm3lwk
 pGBW6cNTsJCgJOxMHI+j5ubXwYAYIui/IhIwsj3yhW7Kx+X4seCrncwRhn63ERsyE1h7AzoPepv
 CXKAO8wQyB/eho9V3F2UwDneKrq+ECs=
X-Authority-Analysis: v=2.4 cv=UIjt2ify c=1 sm=1 tr=0 ts=6a70b36b cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=xA6h9QslmyXtgN1B4EYA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_03,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608030138

On 8/2/2026 10:26 PM, Lachlan Hodges wrote:
>> I guess signed would be nice, if you can arrange it, then I probably
>> will check less ;-)
> 
> No problem, I will sort that out.

In case you need the pointer...

https://docs.kernel.org/process/maintainer-pgp-guide.html

