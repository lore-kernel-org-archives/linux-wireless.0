Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793942312;
	b=EN7uRu+EdZU+gOHlAcYqiDYrCGbPSHi189Gjstgvq3f8kwiI9qLg4/9Hk+ztcGYeLJMT
	 f9/2FVmjWfd9IU7tMJxJVOA7EVBhb/8PEmmaeJE/ETKsXnd54XClL5ZmOKogUSFnVEjrC
	 77uRD0i1yB3NirWUBIUaChCwq7LDx5toqAsBzLp38ve9Lq0iUnsP1ZLQd1WKogWHp0+Rz
	 RuBH5oY4jyU+mZnDduK/IqtgrXSCF+Iz4r4RrOQJ8Izau5Ibci0sBASy8T0sntgUaf0ci
	 gG+eJ3hWHkvsHtywZUhuTfD7MNqJYsmVJDVHnyf99lha0lR5pT9RsZVcFG4ahklkE/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793942312;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=SHm7fq390Dtjc8Onlz0SZtEKIajeqAq825ln7gB1Au0=;
	b=1RP5xUqxyuipA31SM0oK80H+sp4tJP1RFrb+TcKyj0xRxRId37FvhpBTNavjsMlvEwAQ
	 yTRK5dzfoTsOdQcK3YVOzEqTER9ha59bQn4/z6gVhpjcm2amfQHerJe71PXc7cUnlCTec
	 U2Q+5sf44WNv/4KURKA/ccUnLmyGnI9Ml2/ie4c9UI81iKPUrBYpnXnUpTnI4UZSESiXu
	 1xgXwTqgjwy4k9yWR3jQve/SywgU1OMjFaZctZrFtrwTIwArfahszqp/Vd5x14TLlRhIJ
	 d5KQrPun/llpMYobHgVNdlCz4t3cNfKOpMKjf3+WZzM6jGWniON/Qo1ifoIya5KuRQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=B6hMBRZ0;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="TV/ObCaK";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FED9606A331
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 05:18:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FED9606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=B6hMBRZ0;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TV/ObCaK
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6404A33440450
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 05:18:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SHm7fq390Dtjc8Onlz0SZtEKIajeqAq825ln7gB1Au0=; b=B6hMBRZ07j9GPB7D
	oq9yu/HbJ2GEFAKwfjO9W0DugjJO6njmGlwttciROW1UUDQEuPyiYFeZdwswUHmt
	8yTmMm+VvVFldsvE5zwRMb8HdMYwuC1OdDClvCGD5kJvI25DxjVyzLD8pv3Zg9Lq
	4iViED4YWFLyVsd8S06kwFF3GINRjcTmf6mwVPfL0pmpEtzXEtOk54YLcsqMT6dV
	4KoFSNpg6HIf8T4pqa3+3llLIBf4mcJFMGg3M2IF1af5q093FxZMmHJRoAZoHA2L
	Q2yY1GQZasKRaKCPtj0wX23MEXxjJE5O+jn7jbb1YDvAsD3rTjf+HSzBJmQCeDuH
	nUPUnw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pas1u5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 05:18:30 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b07b06027eso439461a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 21:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793942310; x=1794547110; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SHm7fq390Dtjc8Onlz0SZtEKIajeqAq825ln7gB1Au0=;
        b=TV/ObCaKedDQkoMBmHUAryIKepICI/Kj2Isp/VxMtOjTa1lcADmViUeWAo+E5+rL3S
         uXg/RXODqWP8zE/ugWegFTgsHfOi0OWw3/7EbJP3mJR6aiNxBwdLzBeMjsvYHkcyNcdC
         uoYXOpieYhtsr+cfUMz8gjgGkiA2vLFb9L0WF8L1GJIGrfsG/zUd+WuWRjOp1jHjieF+
         o6yZp72HeOM569RP6jRPRpMLMPwxlX+lhqS0QI661civ0nsuTmJSNme/gSCN54cUCU8R
         AvEntF0sb0fZlDxm9vg4N8qm73bpNnuHkwqsdyhNQoKjaMwGZVz8baIhUPu2p4xdrG/Y
         njrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793942310; x=1794547110;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SHm7fq390Dtjc8Onlz0SZtEKIajeqAq825ln7gB1Au0=;
        b=r7YaBgt0yqUZD+ZRuXeaPmHoOOauo+UeLdmKhhjXLBcNnQxxOcamp0LEDc2BhJElGq
         dQXAdw3Xl6ZouiD9E6eDdZaYR3hO0c8yBtvSPRRc/cPEEDht6Spte3yxY3th+UoFsZSS
         ts8Hfbt/KI1dBBh/qE7TgD7HQ1uimPe9WwdQlda6yw8SWTbbSDyQabh2dNSbjaOz2cEW
         qRLde22IAqctEnMX9BMWYWHpCN1+K7kdKXWB3bXr/TZXVWZi1DfVPoKOleFnYvduyMrV
         PLfW9vIJQOVRaPIGLvNpimjmbVZhNsdtArZEjob+E/kAR2b2bVJiX0PHiKMqbK5zVgbE
         1XLQ==
X-Gm-Message-State: APuU4Z9t4HfdiDSiGDRQ+W+H69yiFvJ1K1qm2ZBA9+iJGhNRMrKpuRfH
	4J25zw6ZjfeiL28aTOz8fhbNBYZl7y7sR8ZSuRFXhoKLpouW4QTFK9ZpY3Pw7z2wmBjbq1jjPmK
	QLNojdrOjKJrTRTVSXMazBWM/VJ6MpKXgOVE2Z/EmByzmYYiTkDEqFxzxRVbQQDt880gthg==
X-Gm-Gg: AYBFou14j6mr0RS1L2rOEI0NFTDoBHpu3GcmdRzt/iSoDpZryRpPF+Pc7jfveoutI1v
	XjLEd7Go8ZbwMcrVqwAs5rePJus/A5xLna0wMyIKV5q1Oay29FSZxW+ctnRYyAsfya2tY18IlQk
	xl4KvgmPlq7RP4UENWzAttrS2yqkKIVWok9Pr1BsoJMw3VqVMM7NIBcYEeXHIipfjTQOeTt+EIR
	Eao9ec/E8ujmi0DZLwKViAZnerv95YzoiRdNYDcjhLtoUvixlrp1qaoE4q7iftkHg4qYDRTkjDz
	T/hf5lpvwj5whohMQgUiW5NZPSSE0J/2mAfrkov8VzPe8eZ69FKO8W9R4JnRUL13fY/7XSnwxPL
	8+YWLSSkpaXHTuRCJxCHHdbQLdaqGPRFQ7FjdrvJWjLcl4coW6ajQ1fwJqRBAZb7zZLbBUMsY9b
	NhMnIBkJsNz97EoIp/s9s5heO3o2r8Ms5PfMkQ8AOAvEcS
X-Received: by 2002:a17:90b:1fc8:b0:3ab:d26b:c2d1 with SMTP id 98e67ed59e1d1-3b0db6a8e8emr1372397a91.11.1793942309924;
        Thu, 05 Nov 2026 21:18:29 -0800 (PST)
X-Received: by 2002:a17:90b:1fc8:b0:3ab:d26b:c2d1 with SMTP id 98e67ed59e1d1-3b0db6a8e8emr1372385a91.11.1793942309450;
        Thu, 05 Nov 2026 21:18:29 -0800 (PST)
Received: from [10.133.33.112] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0d7c8ff96sm1762352a91.13.2026.11.05.21.18.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 21:18:29 -0800 (PST)
Message-ID: <23e722c5-c569-4bdb-a01c-1e58c77c639b@oss.qualcomm.com>
Date: Fri, 6 Nov 2026 13:18:25 +0800
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
Subject: Re: [PATCH] wifi: ath12k: Fix potential SRNG configuration leak on
 init failure
To: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261104-db9e3c75b3-wifi-ath12k-1@mail.sdu.edu.cn>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261104-db9e3c75b3-wifi-ath12k-1@mail.sdu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAyMCBTYWx0ZWRfX5FHiJYMq6pl/
 rq70D2DbvYUd0N+sPUshIbHqgrVQGqHOGw4aUKagD/QZWXp+li8Qw3cK8js5fPJKPaNHj5gnZRX
 d8ClSQoo3uAAIkwYi7o09YbkSs7KVMP5s0lB5BexBmYaGdH5P6HFI6GUj0rcAWFPtscYuYMpZYM
 cWXpUt0ThoIwj6+IIv/2Hb2uY7JXFOHHfyH2+qIdojGhNd1bsIW1m76ngzAhHdAXCcjR+Rch3B0
 Jj2njVo93tTZwRSoAievOFx315xcf0vREl8SQbKo2AgSNRwJ4CaX3BxEtfWakS0xTUDfJZGMbcl
 Rotrcj8SW+phfKdQCpp/Veoc7eggZpaerPou2gOwsISLvtKp/9eFNXpg+jrp/hISLQmPj2r4iKq
 I+dRWF1oTybxae01InlJXlhCWV2Wx/PPnfoL4UbfDH/DvtuyUu1Ps+2NP7HE6s/M7QI1MVVQ+JP
 hH8Q3FsR+mHsHTnLveA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAyMCBTYWx0ZWRfX3a61v6iQIpQH
 pLDcb0/SKegliDfZXy1rqNUOYhV0FR3USj4k8O6ZkN02tJHtJX0+VlUV9A3eO+/o4/UM+0TkfJ+
 vCGQm6ZjtIQv2k4N9q0O6hwpqlF7UZg=
X-Proofpoint-GUID: y_ubHjNzw_YzTQCf1TMxis4gIZnTXwbH
X-Authority-Analysis: v=2.4 cv=P4ivFSAu c=1 sm=1 tr=0 ts=6aed6326 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=pKS8v8zPedG5d943xKEA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: y_ubHjNzw_YzTQCf1TMxis4gIZnTXwbH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_01,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060020



On 11/4/2026 10:33 AM, Guangshuo Li wrote:
> If either DMA pointer-buffer allocation fails after the SRNG
> configuration is copied, HAL initialization returns without freeing
> the copy. Its callers skip HAL deinitialization on this error.
> 
> Free the configuration on both allocation failure paths and clear
> its pointer before returning.
> 
> This issue was found by our static analysis tool under development.
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
