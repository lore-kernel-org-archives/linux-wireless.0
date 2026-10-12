Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490F63290AF
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 07:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791789357; cv=none; b=ABT3EVMNis0k6wRsKs/maUwaAUoT0cd6rGA4vOnk0ENyTBpvQJTjW3Jvm4fPZzzTlrec87yL+J31UQASxDNAdLxrXCoWi4sX1DzynQg11rhFk5ot1Q64Gp0ViZSyvy4anLJGp/DdObnjCNsAT9TZPTJrMUM65HexOeJBlpFcx0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791789357; c=relaxed/simple;
	bh=Hd+BN6RDJN6bk1MufXlNzSJch755k2WEFTJLN4wFdKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DemhqDeIZa+ofgZVvy2ZCQtaTzVoRQx1sV4A87Gzhi+AfirNqmoHPYD42KlpdEYsV+dkHCAUwdE+64bi28keiv9PKXLFuYh/gyPkn9qEiiFhZMO8zLi9kelk++rTgxGJQch4otp0g06a7xeYZ5REqWtUNizsfNufCEI2xtECvts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WJyoUWJn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jsYLNK2Y; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WJyoUWJn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jsYLNK2Y"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C5Pa911787025
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 07:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FALdQOa0iewDJ5PNUsXZhf0wCNU9EWPT335/P5eVh18=; b=WJyoUWJnVa80v1H6
	EOaC9TlLKjEtG9ZG3YRlYXMTcTdcU4ysz/tK9Q9XJ11FGo/cVHXjHb4WI6Z+fqej
	uSkC+9VwCsWPgKYs+3bay4Tc0b84YWQmPYtphL1CxqpdcBD5hvddCo6CI/30YP0r
	gGzAwcTWlx/tL5LLf/5szP7x3MJWbll/kkziPrz31C1f60Zcx+fnVCLEnAGhDJf/
	4VNR8clDPXC0X3IZMyE0dDKghB6g7hOYG9+ns95CLW27JTmRQoS4BPtjeavjaUS6
	A0V0EPXONjCRVPfMxAPRBZWr1AtIRtDrdFQY2UvBfxkORtMmNOTLpmqWh/c+GOJG
	OmKWdg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h8sd1rfjg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 07:15:55 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5350d8a2368so3643781cf.2
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 00:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791789355; x=1792394155; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FALdQOa0iewDJ5PNUsXZhf0wCNU9EWPT335/P5eVh18=;
        b=jsYLNK2YFOCVon+jgFlpYowcNpiOUNJkBp1tiFlQhx3jSNFqsokEERuw8fWVRqxwlU
         1sy0pXeXyduJH4xUT91N5z7RyJWX5CFfvg24G2l1PSl0jzMl3GKp+8ezT+6sFG2dl4ku
         2oqDagMie5Es/jL8fHg6LmkT+kjeJtaFVBQnq0SMqBx59x7AisQd+P5gXblGsK4B9ac0
         AxN6F/kjBtNxuDck65+xhbFqoxP5sMae03Q/XxvkDoS8PYpDTWVMbdeYdgw8AI+WA1xi
         Rg4MFOHipwpl9ydIDbZJX+MTJHCsEdaEQ5Pv/ocNs6NCEP22AoFuiBGzbBQbJlQ0NLMJ
         H5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791789355; x=1792394155;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FALdQOa0iewDJ5PNUsXZhf0wCNU9EWPT335/P5eVh18=;
        b=ncIpUCeaDLOb5FNfqq5FD0LlVGKKcEkykiKY6Kk+AtApgfR7887bKI/Z6VjNds+XP5
         kQ+NyLc7duDnS3dnE3C+V2/a1JNf8jJSKQa1gK+q+Hmm/LcCgxKA11UQxTuFFNqaOIiT
         LY5jwXo0ZWmrEC1n0VrfuzEKdPmzp3DS/PmwFbL5xC84vZ1+22jsO93otVWiN8LN4yCl
         L1QEWoYblKyQPYoNW4kFQfEsYTuvzryyhtiuvTeaG3ADgfIfs/5CB/Z10H3DKieVCVOn
         G1E1y/go/2QinyfEApK1ynDsQjYYeuriIh0IsQtIhabIALEhaQmuisL7pj7iW2TIUZ9N
         FWMA==
X-Forwarded-Encrypted: i=1; AKwUvBwNzoQLuQayCvn7QQ6IXmhFFQkyrjsSeZcyC7DDxXbxxdQsI8qr29gdK8SmyOGURg0+Zqgix2F67uAo7bshxA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIDObx5hOBUygyrVJV/x5DgCWs4O3cHuvxsPjvc7/tVKhBkNLJx
	6o3695YFFkjbAK4h+cKtsLYAkigh8s1V7rN+RI1WV9Wi3s5R0fdbyhMNwQ59gHUEh+p+M/xAu8Y
	fuuxsJtjIGwE9TsFj91WMKz0uVIMWjPPkHZKLuZn0/w1IQLm6T8hZEsCRj0q0RoF1QzOxZQ==
X-Gm-Gg: AYBFou2LkdZzzd0rBDqL58PnOPW6j+hcIUyFl4EwerIsp9JODNIcRhctIz88TJjgDJL
	FBor+B5fFYo/3HV3nBYzwd8cxvZGYFOg6ekATTZkRRX1PyCMRuxm5MRez9qNHfQZe+lnkU8P7US
	LmAx0lKH/5yXKAAZbve75E6lAk7cdoodyFuN+cn2zU6XmFs8xCdASIGE3MFA17YxUR/1xD03uG9
	EAHfiUulD4co8gttjWPxDx/PVugufDUpQfvJt+lK65fsESiuFhe5PY2EWPXKd6yJAhuir69saNS
	81YNUVK8d5d3E895r8G8MiAjoiDGWFdbfoS/31su/pgIz+bHwY3OkYxgy8pjgVBLa9bpM8v2TI8
	afV19G5+qYBRsgJFUCJ4OMg==
X-Received: by 2002:a05:620a:2b4e:b0:93e:6d87:4f69 with SMTP id af79cd13be357-93ebd1e4d57mr1612193585a.3.1791789354485;
        Mon, 12 Oct 2026 00:15:54 -0700 (PDT)
X-Received: by 2002:a05:620a:2b4e:b0:93e:6d87:4f69 with SMTP id af79cd13be357-93ebd1e4d57mr1612190985a.3.1791789354033;
        Mon, 12 Oct 2026 00:15:54 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3382b8953asm199591466b.21.2026.10.12.00.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 00:15:52 -0700 (PDT)
Message-ID: <8ff749b8-2ed2-4ccd-9f7d-e7bca7aeb38b@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 09:15:49 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: skip hardware rfkill setup on Microsoft
 Surface Pro 11
To: Dale Whinham <daleyo@gmail.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: =?UTF-8?Q?Fran=C3=A7ois_Roux?= <franzelfranzel@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio
 <konradybcio@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        =?UTF-8?Q?J=C3=A9r=C3=B4me_de_Bretagne?= <jerome.debretagne@gmail.com>,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261004165132.4313-1-franzelfranzel@gmail.com>
 <d791e70f-9c3f-4916-94de-8d76517339bf@oss.qualcomm.com>
 <CAFcmK8haaN=O+aqvcRr4t6jc6dr4Bf2QDDPso-aT_frqEfSPWA@mail.gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <CAFcmK8haaN=O+aqvcRr4t6jc6dr4Bf2QDDPso-aT_frqEfSPWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: b-SFvC6xfTHeZHrJxAnNVwrp995ZcuAH
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAyOCBTYWx0ZWRfX/672PWx9oCaU
 iNNz8IyHlopgfgjOL1AfZpzpkpfHAo5pJ30Gf6ob6FyV/3Q1J2PwXkEwjV2eKfgilC4/73uolrR
 /45UVibA3nubmAjxlTPuat0IRPYRGys=
X-Authority-Analysis: v=2.4 cv=QtHLTlyd c=1 sm=1 tr=0 ts=6acc892b cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=p15cCi0eOIm9mb8E23UA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: b-SFvC6xfTHeZHrJxAnNVwrp995ZcuAH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAyOCBTYWx0ZWRfX6vUNqiLM8eMd
 mMK0/1bvPPcHM1yIuOLsdw+XnFO4KTykAGE8RtL/+p//86eeLoYPE6sUvNN+6FxpSfik0Sw6jit
 cxrWPk+z4zqfnkO/JgWo11U7z0sbkysu9U6AA80206RYF5xNPqV3U/iN35X+KU/LKMrJVR0zs5Y
 jcJTtJiAlP+0e7k45sZRVntqcxiMEiX542VouoOP7dylq3GZWyoL7fofeTRYVlb1cqR/sKShW+6
 ygDZooyjhXNYj7ZIgGYUvvoAvcOQd3qI1fGc9P9EWDXSbvu4I1kGl4bgLxt2GIRYSAPunmKGhp5
 BzQgRLi+FagU2NiMplfKnq6qYz9MDaPgyPye9Sy8HwEiVbv2SEtL88VhCEEd7EDH+cgIHAtI1XW
 g14UlrXmTi7cLeUf2fpyeZO4KKmzKqh91Tgk7mnHdqL2UJDglbrB1HCPL9klmgn4u2lpGTlSTlE
 imuEd74Df8uWZmWEC3g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_02,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 impostorscore=0 phishscore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120028

On 10/5/26 6:50 PM, Dale Whinham wrote:
> On Mon, 5 Oct 2026 at 14:37, Jeff Johnson <jeff.johnson@oss.qualcomm.com> wrote:
>> my preference would to to break this out into a separate table-driven function
>> so that if other devices have this issue they would just need to add to the table.
> 
> Indeed, as far as I know Microsoft Surface Laptop 7 (aka. Romulus) is
> also affected by this issue.

I can confirm

Konrad
