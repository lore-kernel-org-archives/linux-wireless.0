Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793342586;
	b=QuNrUejnTJxLNPK5e3RcQ6aMdqHjQzzOuPeowS9g8fMRc7nsUw/lRTDcFYKgHPKDx5mj
	 FDtRy7+oJgf2OaxOnGhMsgxWPZj3t7u1BeBOX6T6F5C+NvSLqgY5u0XM17eb7t1WG4iD2
	 FAimJHXG80zhCZVKXYldZC1aXc6P4N59MtMZJXA7NvM21L/SwqFlMrSAP1sI7Zjxh/xye
	 2DBeMwcPfGbcbFjKrx+esv+SjAQBgB5l3kHyrc10f1hDWaJxeoQw7oIjbvFMh0h8dXHhM
	 hv0uZJoFmcn4/vIGy6YnfBc8+WaOjRttJI5clZVTbRugomdfQ46SDLgu7iHii+R4oqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793342586;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=HTVPcvCt9naqkl1rOj58SO+wRvdNuLhnB2RU4A6z4kQ=;
	b=DXrNfpNS3kJwQTTxlbH6WW3B2ZIxAX52Kwmn43FkSNS5amqa1p6UV2Vo1wH3wMRLlsJ9
	 ///GWurWfaa7aEfttwTkd0YObzVEy0+VWWFZkUOGSv5Ecq4r1VEO9QbpxMbEIMwk5PAb4
	 QUbTqxH/PzAyov6RlyvXcHWg5RBdiNazZTa7Z//sn/WgDXwhSIKIYMXmzODOj3diIuJ0w
	 ztK/TqB/N2W7lZMJOo3BWWKJZbnZyNEOmf+HOxlyTHzk2BvIEjRiL4C/qLHrWa15REXcI
	 GM0rjN7TpnDB8WkCUXbL2lFJTnA3h5f0aUP14RFhuKR6NK9PE4bEaQ2tv+Rvs9D+f3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=f4ojMEOg;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=PVdubdxS;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5260F606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:43:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5260F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=f4ojMEOg;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=PVdubdxS
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U5F06V1738517
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:43:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HTVPcvCt9naqkl1rOj58SO+wRvdNuLhnB2RU4A6z4kQ=; b=f4ojMEOg5WleFuPo
	ZIXA6k8eDK+bMrAIgrb2vegZIY95AlgZS6oXORZ0gsUGjzCwqO7ukfSHLXy/++Y2
	URNEexO/ZHxX85vlTQLFuzXd5wG90b8Ro/VASVqVEymPhwK5coPs4apbOjITR2v8
	z+9SOlalOQMzGLu5aglpPYYoqtoT56tUBT7YIFqpAGfDMx5mh3bCZKvafrPqiHeb
	bh4RLAAnb1WZrkOxyxXn67p5Ad2Sim1RuNk5s4LC2JjZPH/+JGQ6pI4W7lz+TCXH
	e2mpeApRC7/NLVCaNs/AMJ3gLYTsfY5sMlO3KkZZ/0eZtAB8qu8/Rz+iMcHnv0xf
	Oi8aXw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qhk1g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:43:05 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f1e62510cso75762885a.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 23:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793342584; x=1793947384; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HTVPcvCt9naqkl1rOj58SO+wRvdNuLhnB2RU4A6z4kQ=;
        b=PVdubdxS2bOOW/vP2uIwXOqZ+YlLOyITyG1ywBvwkKgwXLzhS0CPfvt+/cdvbd8Avy
         oyEZrVSakk8d3jvyS5ablvWArg3pe2cIRdTxxRxxKwb378vaDJWO3H1zOMWwqJA17tq4
         6AJ06lpEn/Iru2EN2kn65UwUS1LCEaIwnFQHDe3leIz/OUlnwrJXyhNpwDwxfm/rPJQw
         g0Rl6RHbobyFdfWczJJN4cKZ5hDz6CQS2RMYaq2COiXm5R9vjT/OevTvmh9QwoYWLBY1
         CIsSWq5DY9hk0n0Ai1Rylkmo7TXCxZjgmyJMKfz47Nk1+9s8B8A3AFPbAeCgA/aDYNAC
         OoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793342584; x=1793947384;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HTVPcvCt9naqkl1rOj58SO+wRvdNuLhnB2RU4A6z4kQ=;
        b=SAHnErfAxGvRFM0Ll9vhGdkQfLFpKJsTwE8xvjp7hhGwiFPvODzLYrgNm6MzYYHqsg
         LMrQnybWcTL5GptFoi4jowu4WS1FnZqU6r1e4xTfeRTbAOXsZnekMoEjnlDjsFrrpz5u
         Z/53or9Xb+FrFZfAIFpryPaaMHt5JQhgkL1IeKMURS6cARWU3eg7mhRtdZBw+3nPJnvF
         +jj1mw1C51Eh614AuTHkG20ykpVLqfPccgnr7lVU76puSdGQ+GiVhkSe0BcYAje12ST9
         TU+UJM76SoL+poKBnPDJCjJ7Uv6BJxIjSLEXpuL/kQN2Pk9Mv+QAKybEn2W5SZBsygfb
         6AdA==
X-Forwarded-Encrypted: i=1; AKwUvBxd54hWR+ULuLUdKEjrFWwDzFK6FTVQP0quluoxhNRbF3Q12R92oiK1xdP2JFRxlM1AuMQkldjnkHYMPHozsA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKo7LdrLK7O3N3Bq9YspICbdI6h5g7k1/MUYSZNBm/IFLKlCTA2
	xe6ZTeY9e4kEyHZXUyHJWvh06CCfl1qWl8p8+W+y7Cx+PK49+rXBQPwhscB0pZpPIlkQOcAIW2a
	CBGO2ei7qIAlo7Wbw598/8B5rNxuja5Syt1RrSNrcVGJZx+BZymrmsTnufM/6KrOkuZxF8g==
X-Gm-Gg: AYBFou3daL+Fzgz5dRr3TOu78Lt3XQUixjrOrhneIeDbQhzRfDdsHGkxXqrjbsQwzu6
	Em+8x2oqtN2qrIzIwi3M7VjcM4XRMzH4rMMa1MvOmGMOs3DvOqT5PMXTzLVqRHFYnSLy4yitiJX
	rXeT6DJt8qFgyKSfkJdtRSAGCHHrpsbKtxK4uB8sLgXTGlhJRdt4zyhtyqhbdBPre69m5V5Is7l
	6PilKW16v4C6OUSnxRpcPZt5jnpOnPJWxOueW/TozYOAzfYQUkvir2pGj/yTotrS6F3IIDhUUdE
	Ocwu/jeG0wW2EOOnpGURqpjjV5KGqCD7eK5nW00JnBdFbW/QBNPzcj4UhEReAO2Hqhwj9OsVuj8
	8VCF8QDES1CfVMFf1ylcf/vmKe6OiYT79crvweESfghPmYWea+xZQfw4SNAhobOoPApJgJZXnFp
	M=
X-Received: by 2002:a05:620a:2b89:b0:93f:4d4e:ff6b with SMTP id af79cd13be357-94421585ce2mr235250385a.12.1793342584228;
        Thu, 29 Oct 2026 23:43:04 -0700 (PDT)
X-Received: by 2002:a05:620a:2b89:b0:93f:4d4e:ff6b with SMTP id af79cd13be357-94421585ce2mr235248185a.12.1793342583704;
        Thu, 29 Oct 2026 23:43:03 -0700 (PDT)
Received: from [192.168.1.110] ([178.197.218.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d4f9sm1495288f8f.2.2026.10.29.23.43.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 23:43:02 -0700 (PDT)
Message-ID: <43ce3985-b1ff-4661-a670-dc10fe32c99d@oss.qualcomm.com>
Date: Fri, 30 Oct 2026 07:43:00 +0100
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
Subject: Re: [PATCH] wifi: ath10k: Drop unused qmi_elem_info arrays
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
References: <20261029111127.85147-2-krzysztof.kozlowski@oss.qualcomm.com>
 <65a1e88d-6b9e-4aa8-9ee9-7b0b7892b59e@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <65a1e88d-6b9e-4aa8-9ee9-7b0b7892b59e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDAyNiBTYWx0ZWRfXyJaVENe/Ob3t
 BiI3sNKsoSP3O0GO9HvT0mnsvWWmvMXBqGwLjjT5S9vom2HRerqea+F6whZoSXQrcpsfMJ/ySIV
 QKntK617GfbccYAmrdbOIuEYhRm1O8SiCEQrbyaq3/Oyp2V84uj4vRuWsecU9ouClwhz4m7RSqg
 Xr0MH1zGJGx4W8I8khBegNkSJn8pQDl1dSZpD8pfzp2dX8oZfw6vLiZ/tWsmAflCjWjm8hoMl1d
 VRStTsFUms9P2nNvtjBfAB8ISP4j+TtLh6Oz/42SCbZ84zMPFSJnFxGGx14a0yeNlL+/vCkaC4d
 vF83C3FULbuKoDbRP8MQ8WQngcMUjFD90GviR73bTV0iIaKTcIZPqFX82TPxJ+S363sQQMe+L3X
 8oqQ0Rkv+muEyn6iSRF2iuoPHQJL4SniDfjddG5XhKj6G9ow3QeKKLJorAwR2vvmDVabg7BK1Wj
 rZsnfPj3bv1dY2L7CzA==
X-Proofpoint-GUID: ZWcwgEMiFMYR6-fCXUj9YKvHICWg37Ly
X-Proofpoint-ORIG-GUID: ZWcwgEMiFMYR6-fCXUj9YKvHICWg37Ly
X-Authority-Analysis: v=2.4 cv=IumL47/g c=1 sm=1 tr=0 ts=6ae43c79 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=uyPgTw0bjBTS2cVxpiNm5w==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=KKAkSRfTAAAA:8 a=-v5LvTCY6n3Eoa7ktXsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDAyNiBTYWx0ZWRfX3LJTt86w+Ef2
 g9XesxFNmwGpLmWCif3u8JOtKLPCaMo+VH2yjiciunlXMXr7fU6fuWXgBCVXDwXsuE/EBmWOTL6
 aN8qNDLxdifswgWPb9Rds2nCCMDtSiE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300026

On 29/10/2026 20:54, Jeff Johnson wrote:
> On 10/29/2026 4:11 AM, Krzysztof Kozlowski wrote:
>> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>
>> 'wlfw_pin_connect_result_ind_msg_v01_ei' and
>> 'wlfw_initiate_cal_download_ind_msg_v01_ei' are not used anywhere.
>> Dropping them allows to remove bunch of other code referenced purely by
>> these ararys.
> 
> s/ararys/arrays/
> 
> this removes a lot of stuff, by review agent says there is more that can be
> removed...
> 
>   qmi_wlfw_v01.c
>   - static const … wlfw_mem_seg_s_v01_ei[] — line 188
>   - static const … wlfw_mem_seg_resp_s_v01_ei[] — line 229
> 
>   qmi_wlfw_v01.h (removable once the two .c arrays above are gone)
>   - struct wlfw_mem_seg_s_v01 — line 161
>   - struct wlfw_mem_seg_resp_s_v01 — line 168

I got LKP reports for these too.

> 
>   qmi_wlfw_v01.h — now-orphaned size constants (0 refs)
>   - #define QMI_WLFW_MAX_NUM_MEM_SEG_V01 — line 64
>   - #define QMI_WLFW_FUNCTION_NAME_LEN_V01 — line 67
>   - #define QMI_WLFW_MAX_ATHDIAG_DATA_SIZE_V01 — line 70
>   - #define QMI_WLFW_MAC_ADDR_SIZE_V01 — line 76


Ack

Best regards,
Krzysztof
