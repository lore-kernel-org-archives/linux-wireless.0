Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2992A576EB6
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 17:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790097267; cv=none; b=GI4akHj8ohKUHSmKh3AfZw9RxlgRUWncZ4TboCNnaLLnvnlH4fvnIfR+N0hwf0MrdbSFKd1JjiQcJxzQrk/WQSCH41wHCLNBRL8a/ZnfEV8h9N3LdugQjCTtuyp1ezZokB1gPyKg0ALPQunPb7H+aWrEqev4u9MPiVfneL8nAAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790097267; c=relaxed/simple;
	bh=YoKdxzXqcxs8aDLJDgxMewiJDR0phHL0RqzGzKoDtbA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ve6SYq4xYjFMPxD9NQn5+6IWXKHH7uypXxoMOSQBmVNCx7J38CeK/sg8Y3XWWmFC0f+yP1ocS3Xd890myBEFQS0Vdq8oBuRBwwTh9BXn0s1vfyhbaBvyOUaoIk4xEWkXDDqWiFL5bods3StAFMiTG3tPFDwn3tFK+zOIDhu5c/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SH+LZHyY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LTzBuDrQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SH+LZHyY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LTzBuDrQ"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MEivPF1584089
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 17:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YoKdxzXqcxs8aDLJDgxMewiJDR0phHL0RqzGzKoDtbA=; b=SH+LZHyYwm2EFfev
	dC5BCRUX03669BE8eC0oX2/hVQM7GGQdKVUNUdu4Itf5aHF9qQvWOX7MmQOwrZGg
	kWcnsZWveGgyMRCrEn2H8nN6mhJLWFQPRtULJLFNTYv1cSWibtySAPnLuuDosrK2
	WuJsH+sc9vYBtwbhj9SZDjxSCF4nMV1MYxKEGmRGckPPpNkjIjpzDsALZHYkyV4A
	Wi0miG0scxa/iKB0GevgxH2N8lUg9+pVqEZ1MI+zPx9gUdwdAbwL2ZWWDOoCZ8u8
	/779x+jpuN2xDyu7BTMFi1aVqBky7lF6RSzfZ/PAHroxEQ2nZzWlv/2Sj++WFsJf
	6Sha7g==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guqycswvc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 17:14:25 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-78830f4bebaso18690137.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790097264; x=1790702064; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YoKdxzXqcxs8aDLJDgxMewiJDR0phHL0RqzGzKoDtbA=;
        b=LTzBuDrQM9/ievMqIR8scbOGzJHFlb+lxwB7lHQLh1ZWJPsvfFvSu5SL88NTZ6o8HA
         udd2wQkDXS5iFthPodSoo2T2xDzIEiHfM872GT6SgosVXXkcs/Ll9j/KnakDZ2Ro1Y1A
         Dg+/LzZmP9P5kjpijj4bdFyj3YXWjYaDJaIL5FWOMsHGam26/iMJuAK0iBTiATIy5OB2
         w6WZCLlEKIVaxRF/5puLsi/EchcJNmFh9YSLzUYW343/HrdWFiD7usLBf1m4poVJ9w9H
         8qKrYKHnjVyOya+IdLllNsy9iQ5LmXvo5KQ6867Tqwg/N4aVc+642gWu+hRwXwbrnGm4
         EC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790097264; x=1790702064;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YoKdxzXqcxs8aDLJDgxMewiJDR0phHL0RqzGzKoDtbA=;
        b=yC8pDdxoVZHkfzlCoK3RsRvH5zNH2kR62KVs4mEjz1UW8EdHo7W5emjCtigqXpWDwt
         RbO1CCdB9aLmgPTvrgvD0b+0xeEm7vkiwPeuRI6oyODIiQG+pHPBHRRvSbikgTln4JPN
         cnHvGMCD1CdDI9/hOJ0532OHknziBbL0GyOd2q3oObK2xrt4UDAoUSb+45yqGnPNnOnV
         WQrZCGAA9PJ6iuEENy8NZ7OeVKqM2WS75S/FFBc00xxFwLi25LbDG105/fCJ5e4xOqRp
         BnASOJlKsG3QOAC3HxTpBacOMJcc0kxejumVOkILvsb4aYYmNm2ARCORT2CXh0/thpcC
         urCQ==
X-Forwarded-Encrypted: i=1; AKwUvBw/cQxwLUgqQhgLcK4UXJsei+/G00J/1CQLsP/fap94oxmb6b9ick9Fkx6XPOjNUpZan1YdFpaKrwEjJaRI6Q==@vger.kernel.org
X-Gm-Message-State: AFuF++lcXvy9o/2jBkonU3cuBltXx6zRof86hvMD2WB+o/39xVGCsZoL
	UsjX+vOfaTT6i+lGnm50qnExmTyyxcI4n9uzxvbW8nV+pSxt6Yy1tRZQl9vDNr3WOgBJQ9kR69E
	vcABtDHX1fhdMgpMgz8CRnRH1kVEvzcn44QDIzTl0Ib806DJLW2e3uKRx9oene0hifLitng==
X-Gm-Gg: AYBFou0ZD6HkQojPrp6M/CSSV3LSJuZkPgHjlskF1r9FGpM1MCztXlDLvnPibbzbYmD
	aV3njbrNWqBw003a+/+KGhIMHCopiA6g9d4+tJtZ15vOwOiIa+yd5IDFABE3WaqsiMZmrYCDVIk
	Sms3rEH64M+5JsHsUhbiSeKSitWKvoazU+0TpD0lD4Fib0Vdt6UcUfNMBOl9UNp8oR6+Q4r9dfI
	1817yxrdou59m8vc6TFhefxb4xKrXveN+BfktWSiDdbpRMiW2GXyP2if4T8BZnxEOnFS+yyat4M
	KwUmpJUIjrRwH5ne9juwnxdIt6H5M/JwXsnWBeiqz5snmJ0JP71gxRyocX10h2pZOFStsslVxXl
	c4hMZ5p3mwlcb6bE/xROy8z1AswAVkhOyIHLFoMw=
X-Received: by 2002:a05:6102:f85:b0:7a7:19aa:f0d1 with SMTP id ada2fe7eead31-7a719aaf773mr6957686137.30.1790097264296;
        Tue, 22 Sep 2026 10:14:24 -0700 (PDT)
X-Received: by 2002:a05:6102:f85:b0:7a7:19aa:f0d1 with SMTP id ada2fe7eead31-7a719aaf773mr6957615137.30.1790097263755;
        Tue, 22 Sep 2026 10:14:23 -0700 (PDT)
Received: from [10.243.142.186] ([212.136.9.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdaaf0074sm59131665e9.3.2026.09.22.10.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 10:14:23 -0700 (PDT)
Message-ID: <a16d507e-17f7-4074-8817-4b8da3a71c3b@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 18:14:21 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] net: qrtr: Assign unique node id for MHI endpoints
To: manivannan.sadhasivam@oss.qualcomm.com,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        Bjorn Andersson <andersson@kernel.org>,
        Chris Lew <christopher.lew@oss.qualcomm.com>,
        Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
        Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
        Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
        Jeff Hugo <jeff.hugo@oss.qualcomm.com>
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-2-27dd80d841a0@oss.qualcomm.com>
Content-Language: en-US
From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
In-Reply-To: <20260921-qrtr-multi-ep-v2-2-27dd80d841a0@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: E82LNLAaE8zzzXUU8fG-ax5apNKxHrcK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDI1MiBTYWx0ZWRfXyMVGHCUGLu3X
 3c5d5DXEYtpY0+a7VcOu7zV8hmZ/nPdKmI0T69AniVcK/taAJycR+Aq0KwrsBgOTFokSaCnjPgV
 iIoW5Y8Z0qdUMWm5//tDG0KWJ0BvvxoBbDUuDdgRIheeETzp9peEuOfFmvedwiUNJQ0qIR5RJrA
 iQDw700fVvUazIfwNDFpE2Yvf/tE/fG9cXOwyDAYMbe+b/1dE15Iuh/dIjEf1w0/Ph8jOPuYhXB
 DSJTsXx3SlTKpjbGpOJ5gqziYVDYUi+OITPonRmlV9QVfZ2q578g7qlH+GHnDjM5Qs6+Jmpwb8o
 FvoTrZUBMrJcYOytgMkzuGzc4BsM3TIcRyAVtWrvPE//YDBCg6Bs5Et7Sql56l5+zkQn61e+2uw
 +Oz8EvjnEzdFBHlvAtmHewQQPKSR3FaLzjzEM8zh/0RszIaDGCyAz1m4JSnKm0g7H+t0eEJCpQS
 OgW4vogrWJ7z8MjVdpQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDI1MiBTYWx0ZWRfX4X4HwOePPI4Y
 EHENlrAaKYpOhs7VgVlRlpb0KKDm0JIfv7uxhvXUzNlQv6gDHujZXtqMXR1O9glfqo47pMof2zQ
 so5EOgxSNOgkHjfTbDPubTD1Iw5cSmQ=
X-Authority-Analysis: v=2.4 cv=c8I+0h9l c=1 sm=1 tr=0 ts=6ab2b771 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=dNlqnMcrdpbb+gQrTujlOQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=ar2LfINMGabpzH7QhtgA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-ORIG-GUID: E82LNLAaE8zzzXUU8fG-ax5apNKxHrcK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0
 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220252



On 9/21/2026 12:23 PM, Manivannan Sadhasivam via B4 Relay wrote:
> +
> +/* The offset is chosen carefully to not collide with the node ids allocated by
> + * the remote nodes. All the remote nodes use node ids in range 0 to 0xffff.
This assumption does not hold up for QRTR V1 headers where the node ids are 32bit.
QAIC devices use BHI_SERIALNUM as the node ID, and it is definitely larger than
0xFFFF.> + */
> +#define QRTR_NODE_HOST_BASE 0x10000u
>
Thanks,
Youssef
