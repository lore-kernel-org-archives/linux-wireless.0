Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793864884;
	b=YRNk7/T+lUNfYBNHvJsq/JnxGj8y2IEKQUIhIug5sFeibnuDnAKFDkxqMRoB7xQjperZ
	 uhP4W0zDDaQJbMjc1jMJZZg1H02CCK6l8RgFGG+ZhS8AHr0IAOQvGLIaVPzkvTo/dRq8t
	 iAQQgqt5FvvQn/LEnM0SpCaUrR5NRy3t55ijsP9ogb4fG6BEWNXMhd8cuoS9gGowQmR/9
	 dcEwmaiKweeYBdV33wNDy+hECdctchz08pdX6kzAiapN4/l2s+Z/c7Z1yfRXGRU8iSPV1
	 weGzF49fOD0kiXTnKyO6kL3u50qJlUyQXoNOTBMEBkS5Uj3u5H+/cNxKANsxnPnVuHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793864884;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=TsqUtIecYc4cWUR6lNpul5xxF9uJS2uCDAK0tjFOvx0=;
	b=Epu6bN8FiaIn7WfIWiPyPP0ja8ivCxhJGo90ZIO9Ds2HRZ/Cd73udRNhXzP+J/vn9ngt
	 pTtlIm8BIEhhzyV9QLW+e+yk0fyhQmxPwNFMFv8qFQ2olg8gak7PJl3JkUT+XiVjHiVpy
	 uje5IMsVmlwdkadrxEhLdfI5GU/yxSta0KKXFp/mNffceb9GXY4PCpvM6idKFJOoKbhLV
	 /POALCqb9QllrGlyEUI0CKXfu20Zm0Hi0BkoJGXWZw2M7FVIcPKMFpS83+EjJ8Xk06/zV
	 kVa7km7as8xTSTutq6jgNUx2S5YWHeUS8SnkfxiulfXvbM32V+zqsayMXlNRud4q54Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kYhMOBUl;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SxH0l4MS;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8307606A326
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:48:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8307606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kYhMOBUl;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SxH0l4MS
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A56UZA6595348
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 07:48:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TsqUtIecYc4cWUR6lNpul5xxF9uJS2uCDAK0tjFOvx0=; b=kYhMOBUlWigLlbI3
	txvhHy+QmezswITOQf88RqSOg21WsOpcIiBbJtxqedTKu/C6ccryKy54F0rv2WY5
	k4t1WvMmWJV/k3H2Ou6uK9LaFA1ZhZFc8Zr3nfSMGLVoYFBVKtybTNuaQxtzI172
	rgGjOgwlIZ1o2+OH/DsX7l9CwTgDA94MgTJmLZ8doxECbp3tJ3IN3Y82W8C1q/50
	OYIyA6BhttYWwLONSn33L5q2PbP8raCsCTiVfGJXpVPTNU0gtJV45dnonaCA16pq
	gLPr2GcWTlZds0PficZSv0KdpRqLp4ln6XfT9HV19OOr0J4mJcH2FtO3qUcCuShj
	zSGZRQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hr8rv3a90-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 07:48:02 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ed08b07232so14726375ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 23:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793864882; x=1794469682; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TsqUtIecYc4cWUR6lNpul5xxF9uJS2uCDAK0tjFOvx0=;
        b=SxH0l4MSCXkK9wqdiYrOl1/W0FMihO4VMWkjXMYQfYQa/zhgMuYfHo2LqidOO5HYBj
         FmZYcvwQx0YlbLqSNK6GWm6YRKFvzpBMug3j+L8afwlv/VfWElpjdY5uxyWlZjAwPM0g
         SdZ4q+uQtUCjLLf4eov6B4tlqWw+DlHybEmuNxl7c7J5R18bUTDhNjxR8XDEWPLfqG8Y
         hHyrOgQlL5we4iNFnK28Jjf9NmwH2WkwfRo55i9srF4bHGoeVLWu8HPyLPj3NwmpwFrY
         TiLBHqeM/uS2D8EX3T8miraQUQslA7NkjScVBlrugRzkUDFPWL2N9YPfnqjc/woXSeKs
         D4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793864882; x=1794469682;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TsqUtIecYc4cWUR6lNpul5xxF9uJS2uCDAK0tjFOvx0=;
        b=XCj87Wy3CWeB6xUcL+aeuKsP94KVLtls7Cz1f8A0h5By8x9dtaiCH/lttvpCvyk0VS
         jgNYCEaecIX6RIEcYIE2ICaz89Y/s2Kd3R6b1PXAagHcdi2+q93mNgawGvPAzG2GFuzq
         5tZaK2qT5Jp49wg9j9XjxyQFNprQaAgX4mVXIy4AgTbreb5aeqz8F+HZ0YsCOIIgmyI+
         4WzjMHVxK89lzX7Rf+LrYWy0zH6PJXK1IC/vBIBpUYCfPNppUcMgW6MD7K57mTh57gm8
         Xp4C8zrnurpZif8wFIn8AVFyiILoxJdVooCFAY5/edQm37ozizjajpvcHBK6e+H1Twoa
         2Qeg==
X-Forwarded-Encrypted: i=1; AKwUvBxZcwNJXzejljCvrAp5uhxtZ+G5pl7i6b0nx+Vn8rGkUOjW9qCxGCKaoU4gDQSsXqiU9sEXCG5A4MntQerlng==@vger.kernel.org
X-Gm-Message-State: APuU4Z8tAUU+amDT8yBJmg+D1nW4p+bQ6Q0E1mJZeyZPNJCjTYpruuun
	Wn0x1rUMKTNx3azNMUYiKPo4SA6hYD2/m/Mc47glZ9gACwOoHEeUENDEhbHEXE1eDQjxps0jgJt
	J9klgHpHDOWEf9TFqwp6HtxiXNwOiYEx2fzk/jI9P8PwhdDCmvyqr2D2vVSb74okW9yW/wEDhge
	NmNWFf
X-Gm-Gg: AYBFou2DDZxvFtzy0Q+WA57I7VedQLPqtetX96lkqSJt9tCOTkiEhqqTXNNEGloFeb6
	tj+inOkW5DcuKeriWodbIc+vSzrZKSrgD7v8avysIfRDth2D42IHP88Ct9aMp4XDkaeb8rfv8O/
	0wZusb69YBxUK7DecTKGftWn58s+ZkCvbKhT5BZp/00gagQcrMw/1rmDjXnh4OzyfATlChw4qeP
	R2qbYiq1Kj9KaJrjlcwGjTtIOR8aAOHWYPAAeULRE61FJgZA+RpVuwWaYX89UWoLdLt7pLeJ83c
	aNlFxFchCFmezBiPph6Cr1qEhafScbvGlWbKBCZSxSOrihDp2nxIIC1p35pVcfDFOOzsa2oHRy2
	rAKH/T8t0wJKcwBMAMunWrHsGPDR1xP3WeHGetgY5xrtbUORhd0Jh9NNkbCXmnFTCRVyzog/QIG
	CYB75SJ4zPMmEupiSxFwTPzkC4GioE25lHzgbMyhH6pg5D4w==
X-Received: by 2002:a17:90b:3c0d:b0:3aa:f4af:1e0b with SMTP id 98e67ed59e1d1-3ae8957d281mr13815858a91.8.1793864881711;
        Wed, 04 Nov 2026 23:48:01 -0800 (PST)
X-Received: by 2002:a17:90b:3c0d:b0:3aa:f4af:1e0b with SMTP id 98e67ed59e1d1-3ae8957d281mr13815848a91.8.1793864881107;
        Wed, 04 Nov 2026 23:48:01 -0800 (PST)
Received: from [10.133.33.112] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b31aa128sm2627641a91.11.2026.11.04.23.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 23:48:00 -0800 (PST)
Message-ID: <583c7d55-fa7b-4429-8ef5-d2c2bb2c1071@oss.qualcomm.com>
Date: Thu, 5 Nov 2026 15:47:58 +0800
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
Subject: Re: [PATCH wireless-next v2 4/6] wifi: ath12k: register regulatory
 before wiphy
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20261105072451.1710800-8-johannes@sipsolutions.net>
 <20261105072451.1710800-11-johannes@sipsolutions.net>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261105072451.1710800-11-johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Vtm2kO2n c=1 sm=1 tr=0 ts=6aec34b2 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=QyXUC8HyAAAA:8 a=EUspDBNiAAAA:8 a=CuQedIim8sXQmKELWzQA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDAzMCBTYWx0ZWRfX4IIshSCDim85
 EtwVNRMIl38uLzoNDFBbXFBnqU/81xcAugKUMFC+gQuSjpUEiL06En0znDPFBtDfyUsojbxy6Yh
 Mwf2m/W4Ti7b6Assj+KqqCOb3UAyCT4=
X-Proofpoint-ORIG-GUID: M9fTPZqVMpGv2t6TFT9Vv2YxiC42dX3H
X-Proofpoint-GUID: M9fTPZqVMpGv2t6TFT9Vv2YxiC42dX3H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDAzMCBTYWx0ZWRfX7VBv7TwRll0m
 14mLqS7ee4JlfWUwtmq2IfL250rKkcACk/GtSu9D2D2RcRQSKjEB+UoBpE06pNcNAYUYqvdY4mz
 SM8ue/WWRrBkE9SkW64S0HSBFfWz3Cn6R0EImSbRWaUtZKWdDiWvn5jzfTdKGw5+a0FHueZu2TK
 +lYhyYJQS3retCFFc+KpdXaMEDRYWaaXfnRou0YwJllfHtYPCcnljR09ueDXt74KMfNKPMrLJd0
 my/AnRrniH1NpULbmH8j328qyydQbTMJw/BaAt/u2Cv+7ZBg1CS+zDUx/3HbOBa+iPyQSIoI0F4
 hmSWP0Yi6RK0ZVO2Zi2my3NoPABbxLb1zjKVfb+zbueh+9rwTYoo0N4RHf0SgUoVca3+1wu7y4g
 W+ZDtvDQKT5FuPAuTOeNlm7dGkLBv1GYYiQZTfmOnHNe2/L9E/TSO5uiph7SDOLDELC71OXuotV
 A7EN5peDKwtLJiWg9zQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050030



On 11/5/2026 3:23 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Soon cfg80211 is going to require self-managed wiphys
> to have their own regdomain before registration. Add
> one for ath12k, but keep the old regdomain update due
> to potential races with user hints.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
