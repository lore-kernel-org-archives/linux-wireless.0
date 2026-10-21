Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560444;
	b=fKnLAGfdYj8/X6SXKqej1IdWoeC48j1o3rSy8ofVh2Emp04UXC0RixNeuR0R4kpA4u9Y
	 kpIHN1e8qYRQwwDjvjQ56OtAxgiKJtRRFTHR3fkmq1k6rX06Q0GfZMBJB6Ka1hPXvwDIW
	 i2c6pin8knnpiVGrJNuRLX7O5QXsQulvNnxEPzYCwmuiLQ7arR7NLb1Rj2JCHiSOW0dy6
	 jlkQQxgipT0LSVZLuBjhHf6NJTHfQRFjwqollm1/KSqCgXR7wCMU4KpPvkRhL7XIXv5RY
	 h8t4Uw210Bx/wLjEMLmMEtUUnf1SWcdGlk8QSNqesf7jF7Yui7pXvZHALvCmrTpg3YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560444;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=jdMNgAjehHI5qPpF5jPX4R7hZm/DeFz7xTp5SYBV/0g=;
	b=yejStMz4xKsJ61jqsJJHGnM9DmHezzKgJet+uImgK8ca1AaGe0vAftxov2Gqwn3JUERX
	 xduDtAh4BXwbdY4N4deiNQCPd8QqugmCVLZIA4ipGQ522wMCdAqVQh5FKhHQb9Hbl40GI
	 e29cby60zg0wMTvACDdpLHUIOWKKZZEIRCrTCSm9fmdSk28oKLc+qrqVWC1MDwNeon0FR
	 LVPV2gLcuCeEntS0AtVQNqFoMI2+yR9h+nSJrmr+p0wGF1Aww5CTVmf6ieo6c47D1tC1q
	 smQn9RspHHQIbv70grUZ15jf6n3nPXpwq2w0kBLN90/FbRqXtgajopYGHEpYNraHPFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Hil7sIMY;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=R+fyrKn1;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D386A606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 05:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D386A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Hil7sIMY;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=R+fyrKn1
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L2F9wx3905512
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 05:27:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jdMNgAjehHI5qPpF5jPX4R7hZm/DeFz7xTp5SYBV/0g=; b=Hil7sIMYzkdqfvGk
	SBDhTM9TiXhFvdVJfYn4qmWAiIO0T/fuFkIr0gEtRpckin+J62Q+TTtJfjxsszm6
	c6elfhGPcZXnqLP3QLaIrDeLnVv3/ceCQaLtxamyjRes6RGtDXhnBgFwBFrVfNdO
	7rLJuHTRWZ/tOf48CVWJXOuR1vLzoLP/lhl9iZ6R87VFyj5jV3zHM/TyhxjSk1+Z
	QfWrKQnooYxa0N1kPZJNQiLUiAAu9bQSq2XBAfJe+FMYQpeb28XAAxWwf314xYnF
	ZY8xqbnG8FKg6fqviA0NUS/9S4CA0CX2DD/OLI2MM6ckMZIvRlXQxLaM4ZouBcqA
	hpQi0g==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hegs01a7k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 05:27:22 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3662e7a9299so1489602eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 22:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792560441; x=1793165241; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jdMNgAjehHI5qPpF5jPX4R7hZm/DeFz7xTp5SYBV/0g=;
        b=R+fyrKn1f7jYcgDdLFpbDJfx9CGYMa06FhXoPgYy1NaMYW6072brNr+AGFT5jxQcwK
         60yyP1pfCeXqTY9xnBvGzCWMyA+R0GpUuhmmACYHTRM96E/+p5S1hYQz3FgsTReDaeOw
         04RQT0tL+fkG61BpotGED7PisSZEpew4GQFxNTSv57r86VOje6WpHEF1Ri1MvtQhCOH1
         LKu/mN1GcIgtOUilXvpfAE3wlEgAX4wtepOaMs2/HzPkCVH/y5LVgt547LUrJ1q4jLSb
         XrlktINo+B4oENiu/4DnWFWiQdHF7lZO0Ids5Q1RZTCIiS5DnQYkIGHCEoIgiKiqmYKJ
         yOHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792560441; x=1793165241;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jdMNgAjehHI5qPpF5jPX4R7hZm/DeFz7xTp5SYBV/0g=;
        b=iv2S2BY/iX5vebdg+bUuuC/Q8vkXy6/D3XgBBbU4UAUnvn9O4VEX06egZG+ql6szO7
         iyoGVKbzSzwBa0PX9SCmG3dUgvfVm3Vs1TJD0rFShw0oclnqY0QKDTyB/+JXdtd7r8/r
         sS8AZ631d+cVkQ8TTSE3ivA5CVGgkbOY9j3zcfEKSON2rrNag+vkHQ8quxfhYOCmWSJU
         NjHaRjhXMpp1MQuwBvLBeVbNHPwc1koJ5hjtmUTku5erGynIv3eQDHwVS2bdrTcYXhX/
         sruda+vqly3X15X9gQkzF/3G1TvPO2afPTwmZhya9Bin9/BY5zlZ3K6Mn0/Cnc3tKuRF
         9+Og==
X-Forwarded-Encrypted: i=1; AKwUvBzvcJ92oePbUoDTm+Rg2+BSNIib6JlKZAsylSbBncJKEGr7ZQinLrYpLmxy6+WHSaAkLaohjgrHm+Jv0icZ7A==@vger.kernel.org
X-Gm-Message-State: AFq9FYKK7ceKNcI+VeZ7YRS7kyBmsTPcuTuPp9vlfjCSv0dg9g4f0mEu
	xcMcmFrR/YOOaLbdbPdpZ3GWdw711znoNPhu1JzfS11AzPQ1ARZzOhUQeBGy32KS8MhcBhZAGZ8
	xDC5wQcci+ruWCFuZwCghFxbDOLilaNXr7o65WEtmmfzGPChvoj36GykxXFjsh3Z46MjZBg==
X-Gm-Gg: AYBFou1AnnNFCPDAd55ArNzdvMb4rpVXIHW528wuIH6p571yL8SRBqzmAh5EY9hQDTV
	vhhOMdEfN42RuN/HMltPgcIMDSoSdexqB6WjSHwwlXH++3JvMYz6Y4m3DBpF/2Jg+l6JJ0VGlNm
	mKuI6r/ytM6Fs/DFRawDQWqINM+XZ2n6BX6c5sVK8RNc6dtSTnu8Md2Hq7xAAprAEXrQxAFZjTM
	VvtmSL0T/l2ba9klOlJ3FAjePAM/jVY5Wntf9QMM8e2Sj+SPgJoJAWEmi47xJ7sXMpo4xxeXC8k
	SjB7JXZCiHlS8MtF3GEq8bsLWfmlODBwltsPw6sq3fMVLvY+0sJuJ8N2bQsTlQxpI/CfXSdp7LY
	Lutr7aaOmedfpnVGZ+0lnHYR9R4DoCx+y0Q==
X-Received: by 2002:a05:7300:dc14:b0:358:cc1e:e23e with SMTP id 5a478bee46e88-3674e164bbamr2292199eec.38.1792560441384;
        Tue, 20 Oct 2026 22:27:21 -0700 (PDT)
X-Received: by 2002:a05:7300:dc14:b0:358:cc1e:e23e with SMTP id 5a478bee46e88-3674e164bbamr2292158eec.38.1792560440663;
        Tue, 20 Oct 2026 22:27:20 -0700 (PDT)
Received: from [10.152.193.243] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-367411bc89fsm4184662eec.16.2026.10.20.22.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 22:27:17 -0700 (PDT)
Message-ID: <7db04008-5dd7-40f0-be6c-eb230bb3490e@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 10:57:09 +0530
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
Subject: Re: [PATCH ath-next v2 01/17] dt-bindings: net: wireless: Add QCN6432
 device tree binding documentation
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath12k@lists.infradead.org
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
 <20261016-mpp-bringup-v2-1-f510c33bfcf5@oss.qualcomm.com>
 <20261017-little-fanatic-bulldog-e84f9d@quoll>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <20261017-little-fanatic-bulldog-e84f9d@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=S/NMU4sP c=1 sm=1 tr=0 ts=6ad84d3a cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=P-IC7800AAAA:8 a=EUspDBNiAAAA:8 a=saEJ52dEQi1JaZ5hwHYA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAyMSBTYWx0ZWRfX2gECHyX4fl74
 4n4v6pBcP5JJwCmLdTDWhphZPOt5rnUoBUL3DAVk2h1JgsJQ+ZdvefYzJ8MYbE7abNdsIHan+TT
 1XeJdfmXwnXLbSrISs/BBXVaatM0KPSrsACplmqKvOcHp1jkkShAx3Z2L++f5Mvqpv5FZ51g/Uf
 pbm3pTWOZi97TajYDpQN6NzAr6+yI4A5m3J9rGGMJsa08XGmwQ4M+HrIN5aVebKjqe7S7Elcq6w
 O2ENjMPs4bCasK33m+CVwE58iJuLy13RidVdB47RAoLWLpmu/Cw2gjouqzyPuSyhawvgK3pa4cq
 SklSuIKpLWznSojKXIjhtJh84pjFTP96w9E90pdlZ/JdZntvrhPEHSeFpfyY8BtcuZeO2y94NLR
 41GzMrKeJjY8pinIudkm5ZAxXibsUB8Tm36v6jNR091C3MbOIldoYoWrZN+c7iJD3+AHbfOOwT2
 IJNMCk+hlHwPRCZNPeA==
X-Proofpoint-ORIG-GUID: KA8PGM-hmg-9-uKhhdO_k2nxgy2u_WSP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAyMSBTYWx0ZWRfX1GItu9V762g5
 OkT2+jGcb5BrkqbhGPn7Rr+pNNKqEAZGwfD+80f8D7C98CxOWNob9Z1OkdrGZiT7Ihfrq5LTqv/
 l93LcYvtPUppVdijYh9iNONMBeau6Y8=
X-Proofpoint-GUID: KA8PGM-hmg-9-uKhhdO_k2nxgy2u_WSP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_01,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210021



On 10/17/2026 10:30 PM, Krzysztof Kozlowski wrote:
> On Fri, Oct 16, 2026 at 08:51:38AM +0530, Aaradhana Sahu wrote:
>> Add Devicetree binding documentation for the Qualcomm QCN6432 IEEE 802.11be
>> wireless device.
>>
>> QCN6432 is attached to the WCSS Q6 subsystem and is represented as an AHB
>> platform device, even though the Wi-Fi hardware interfaces over PCIe.
>> Document the compatible string and the resources, including the Q6 remote
>> processor phandle, MSI interrupts, SMEM states and memory regions.
>>
>> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
> 
> I missed during previous review - you almost hit combo. If you added
> YAML or schema it would be the most redundant information ever. Well,
> pity, no combo.
> 
> A nit, subject: drop second/last, redundant "device tree binding documentation". The
> "dt-bindings" prefix is already stating these.
> See also:
> https://elixir.bootlin.com/linux/v7.1-rc7/source/Documentation/devicetree/bindings/submitting-patches.rst#L23
> 
> With subject fixed:
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> 
> Best regards,
> Krzysztof
> 

Thanks, I'll update the subject and send the next version.

