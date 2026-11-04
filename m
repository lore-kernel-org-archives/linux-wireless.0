Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793783897;
	b=bdoDIUyYLzPwkF77bSBI3Z3qVf0HYAlW8dmgvhtxiYi9RKm9b/8Cyb3tfgSMzfKFBoOY
	 qo72tg78FwIBmgJizkm7Tdrabjv5hh9CKR1KQG1F9zg0clk1z3iFSq3I10Z2yXGX6iGn1
	 hq3Mq+udJpVI8M1hp+tfyVhlh3TSB+PzE3n+O5EwqTBKvIqCq52cIXMXoUz96Wfz1Hgk6
	 HWunIeXtW+ZXbXQIPhc46MEBXT8c0Xcxhof9YhsXZ/uVQpNzUd+2OKrGed5v83wmNDFJP
	 1+EgsbYZ1sqG2ey9aAcBMkw2WBYMRRwy9tEXsh6RXFZHkr8TwZc3VJnYlprYWeHlLtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793783897;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Ih8jtYJIgJ1b4QF/L9VcTPbkgOamtjcw//Cirop1plY=;
	b=ajzX5Mcur+RsDYZYoQmyVYgAcrBbzSrTkN/7h+kE9ow1Bd/zL8wsAS8wilGCb9dA4Pdi
	 uVOUhTAUAbxMlLWJGeWRhxZ/JCTXFieIp3FLumg/R5tPfr77HJkXxaqV/a3A3vOkycuFw
	 IB8LPyPHGpcdNzA+VOmj0qppGzZwdTAbF4gLQSed+gxr7j6cmspwaIFmu7VB71efOfs17
	 +4nnGoqr9XhhHYFqjTvlve9YiPOL62uPW4FtR84HMu/mVFTjGLIufeecCqQ+ZTCoLXu8s
	 wM7PEnfLDxY0xYelNqV6ON6JatuXukMnLoUSw5fGoUzkFyhAvNJ2fFe339dSqVI+JMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DEcNrnuq;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OcQQuvWZ;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBE2606A326
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 09:18:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EBE2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DEcNrnuq;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OcQQuvWZ
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A48Kti7715365
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 09:18:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ih8jtYJIgJ1b4QF/L9VcTPbkgOamtjcw//Cirop1plY=; b=DEcNrnuqEqzxxPHK
	eSzBwbPhlH+MQph5OxC/zQpj1dZu1PbIVNJWOm+e+Pp7/TXW+GS1TS2OrEWutU02
	9FDR3Jbasmy6AqYO++NoJHr7Mo1uZ/qXxPRBXBwmu3Ehk5/uu+BY05aeEcvLVWha
	++ophLfkxZ9u5+zo/TInrDJI/sVbY+UmwBDousI7z7Q4MZZoSHnEVwFQMsNJ5BeU
	LFnAKiEU1uzNnDpbKjzBKpuxS8SN95y8igR9nrNOOqiD04DFBO26+qa6m+mLo/LL
	cLYIbJLufCmDCArUvfqnyGff9hS30/aGNK9MWAi2AohjDCl/sNlRryXW75kFq6cR
	85d09g==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqn8y2ywb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 09:18:16 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cd60a365440so455870a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793783895; x=1794388695; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ih8jtYJIgJ1b4QF/L9VcTPbkgOamtjcw//Cirop1plY=;
        b=OcQQuvWZdD6gnz6Rm4t4w9k4Z3jtRoeLLZuUB/Wdiqhybpe5wFzJHTsmSpW8K3oz85
         SlUUaUWDc/NttxGkhgLNt3JwZAho1+QpQCmySNn9S1cBuIhgtbSkQWTFB1U/SC9UFMzL
         Fta+oypuIUiLk9VGYN6C4cO1zlWOi+deei2XyU2VPbPd5BQGghnCW5wxz4BgU2Q9bHcW
         G73Som7mVhepwfG+C4hm6ZIXAMj6Bg0lJH7HGSDEm4za0eocBJYRVxMb9RWREiHs0fqx
         qFTXzQ5jfOhh4ESsuFYaXW1pvlfhJcVnEFEnp30kMuqQhlIR23RbTF8kAA7v5BvpiV85
         XcTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793783895; x=1794388695;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ih8jtYJIgJ1b4QF/L9VcTPbkgOamtjcw//Cirop1plY=;
        b=Y09i8TZYae7ExuOrRwGTWNmuB+HqmEfsakD4F9w68YsTubFOCBQ0lKXVsLI9iyupxP
         uAj/yEckF/GF0Ya/Ad9xbB55xuPhzIg0dAz4MDPIkaxFXndJTsFgShOQb2yQ18L0ykBu
         sjd4fsr2F1OIFymDdWssCnH3vvhNXR+GAXF+l6EUFjvUUGBAaJilaTuh90ioIfnipPIp
         CThQN4Ga17zsmq5ALUfigTq1X3AaKzNWfitheM4Omz9AqidMR4VNJuBPoR2LvejgctvA
         JP8F5TT+VJ2Az3HU60TWb36rb2RxMPLWdLNj+xTfKJFFJsETW76QtWUxEvuBof0+G7Lu
         wdCw==
X-Forwarded-Encrypted: i=1; AKwUvByVsj7rzH3lViO1gcdSsl2lJHAL7hc5gmde7HxQxAWHr9XTyazpXkIGBZ5O+PU/HSPgqfrNa6YmCHG/9F1rXw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9+NT6VYOmJyVlBw5UOilK1WpQipmpW4m7pgnCwh26/++tbnTmK
	Yr5q+HZPjv9zfWInxFcJqWdtwcKuSarrskAqmuwR6mVs9ht5kv77SP6j9k9hbuuVk8tk/JgxDz5
	9amSbCL8uI1HqBhMLPsSkJAbLF/zIXy7PBSl9CE9ArhlaQPFgiHe6VdKzDm1HLafIZsEjbWamVk
	TSWA==
X-Gm-Gg: AYBFou1XZvFqlKoExXFLJG6+2P6JWhEkfPRdDtAIsXQxSKNtOz5fGFxTypHoven3G3L
	Wh8WR8aNz3Jjqfj4raDsGqgZI768rLZ+HcZW0ypBMYirFba81EVJ1058odspOPb7VzmFW9PCj1i
	bpRDpVmvOseUQxjVj1GXwqx+Uk5JpV4l348rJkzqjMztTFA30XjCIXdJxwDkQlkiM+Sm+hInRGn
	uYb7y1sw7j6eU3LWUgNwX9qrMolf+jYpDCPohO7UUA0iVn7qMQD4BsG0tVqj902JxqjskkAE0MX
	7rKrqzpL4FxSTY0fOs5nyypUmEBRCjQrlYoaioGnEAXIGwa+MeBFyUFO/skmikUjy9iG3/vTiB6
	Lj+qgcBnJmV+k87nLZ1Exadnbhf5y2w8iyjQpmTkdXSJlxmdL0Vnnc0Ov3H/gsLyYWjEd/DH2MZ
	0dt6ehD3Y0RU8R/uaU3ubX8rn6H4qgQocjb2qQ45U1+9E=
X-Received: by 2002:a05:6a21:7903:b0:3e2:8f4:ce69 with SMTP id adf61e73a8af0-3e928ab2d4fmr10312318637.5.1793783895183;
        Wed, 04 Nov 2026 01:18:15 -0800 (PST)
X-Received: by 2002:a05:6a21:7903:b0:3e2:8f4:ce69 with SMTP id adf61e73a8af0-3e928ab2d4fmr10312307637.5.1793783894634;
        Wed, 04 Nov 2026 01:18:14 -0800 (PST)
Received: from [10.133.33.51] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb46326f8bsm792744a12.0.2026.11.04.01.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 01:18:14 -0800 (PST)
Message-ID: <5abcac80-3eae-42e6-bf56-7b3e9a232577@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 17:18:11 +0800
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
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <9efc1e507a2c7eaf6ab68ea0be0f5f02178ff4c7.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: w-AFBbHC0JLK84OCWQSa74OkD0OnTEeN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAzNiBTYWx0ZWRfX1vg/S3wMgdB2
 4kx1IJBHQw05hESrKsAu83a0pUROXo4N8fV1Q/7pOqQtaJaU+qvn+iXnx0zPIcqwmo0VKEi02OG
 wKFwlNBRjGTYcMnHBkr0WLhxZ+W8ij3N/pGxdzugIbkXqtHGAXO/tdr4lLkymXjibcZnJL3izsH
 EiLlW78Uqu7wWrt4ZxwgzcMfMAvFK7HnnI38xqWbrj2JzIijw++PsRAjACh2A/nO6HUyfi7ddC9
 UdTOSFjbv+sWexuNsGT5M68BfbRn6xWYXR7vX+RjQbATLRAXCTrCy8K3iA2RxU6sUl+YMShZ2RB
 BB83ya1qmfSRhu3XhO5Sj/NrFHU6dawRMJGpqN72nR7g1jZm4tqAzUGYl5Lhog71IJzC5Kvz0c+
 DoDjYjLG68n49kBkAexHPNiXBFlSTrq/UqfyN9inNRzWooE5Pt7F22FwUSLQN7nCTKJjbbLlJtD
 R7ZHRnvuqOe3V6WOQ6Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAzNiBTYWx0ZWRfX8Kr3jcsb5zEw
 tKfjg/N6cOSpYOAVaDeT8Jnd8Qt1UntmsIwJ6gc8SiYEQLqPuXYeU62pBR58HeBhIoUEOko8IiW
 FJy4oeWkYpejrr8o61rabEO/tAQhKJI=
X-Proofpoint-ORIG-GUID: w-AFBbHC0JLK84OCWQSa74OkD0OnTEeN
X-Authority-Analysis: v=2.4 cv=NP5AaE6g c=1 sm=1 tr=0 ts=6aeaf858 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=QGPgvQJsVKPgUTAzkCIA:9 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_02,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040036



On 11/4/2026 4:36 PM, Johannes Berg wrote:
> Hi Baochen,
> 
>> Hmm, this might reopens the race that 906619a00967 ("wifi: ath12k: handle regulatory hints
>> during mac registration") fixed: With this patch there is no ath12k_regd_update() call
>> after wiphy registration. So when there is userspace regdomain hint sent during
>> registration, that hint is sent to firmware and firmware update to host with a new
>> regdomain, however the new regdomain is simply ignored.
>>
>> I'd suggest keeping this old call (to make sure the new regdomain is handled) and
>> also adding the new call before wiphy registration as this patches does.
> 
> I'm not sure if you changed your mind about this since you sent the ACK
> a few seconds later?

I ACKed on the ath11k change, not this ath12k one.

ath11k regdomain handling is slightly different from ath12k, because of what we won't hit
the same issue there.

> 
> Despite the long commit message I don't really understand the commit you
> point to, I guess I'm missing the FW side of things. Also not exactly

Yes, there is a race between firmware processing the new hint and host reporting the
regdomain during registration.

> sure what you mean by the userspace regdomain hint "during
> registration", I thought this was self-managed?

Yeah, ath11k/ath12k are both self-managed, but still open to userspace regdomain
configuration like 'iw reg set ...' if necessary CONFIGs are enabled.

> 
> But I can also change the patch to do both, cfg80211 won't really care
> about the second call after the registration, although it might send
> another notification to userspace and cause quite a bit of work.

Understand the concern. The regdomain code in ath driver is currently a bit mess, I am
planning to clean it up someday.
