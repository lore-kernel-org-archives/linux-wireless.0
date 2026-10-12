Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2B525228D
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 06:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791787400; cv=none; b=gH0ZitzxvMINDdRLZ6FPS8lSIu/VwpgCG9oim1eAc05WH9lP+/ArJ55mPFfrZTyi9Ic6o+/G2W+1m76lZEdGrQ8tOm+yybc0xeMlKYvikfAW9O0Na7uAmgcHbupwPZ9eF36OM0KMRl2sD3FjA1An5oaCkq/kWt7dJqmViN1nYnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791787400; c=relaxed/simple;
	bh=iT8Zllnsx06aEqmJ78b90QgkejKZANkL5dtvVz5wjGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ov73gMw7IHlguFbVLjeDWAP+JlpQUreQvWJO5sVSWrK1vklYpb4Sje7u3oTlqN7Fmn4DfIH++e6nJotIRXtGtr9o69gzs8UrySfmBSQZBvcfIXcu9IedXB387y5cGkAbDVXEEkN/XbBxza7bWNfNMqB04DTKNdYW+g5xsNq1ggk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZZEsZ+4R; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NV32MvoI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZZEsZ+4R";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NV32MvoI"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C55hNo474955
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 06:43:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+UcS8DdSjOk8FBpL85zZqOzwaOXP+zI2mFu8qLHfSew=; b=ZZEsZ+4RcASTU7zJ
	JR5BjNX/RaPONI/1+vWFAdzS1CZXbuC4b4A7F64kk9wigiQ595s0+Md/U73FPeuu
	aYCOxQWFU1C47Mh+s34BawqciZlcf9jB1HETVYYNgtn4kjzHn6qq2L7OCksW9TgL
	ZbywMfk+8UP6S2guG25NArOiEkwxCFF8E8QEQV+pOIswXcghVMKMYTl0wFdeIL8g
	mGZ4S1QpnvihwVT/Bee5S18EfZacEi0mRLyuzMdTrsMnvwUksBAyfeM6qLv7FPtn
	f1qnMaDHTmna/9P4Bqi1qSB+yAvJIw9hYoTpGuDXE8YF0KBhfmzLiO+17z6UPyJf
	xZNtGw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7en9w0jy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 06:43:18 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e827b3a6b4so24542525ad.2
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 23:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791787398; x=1792392198; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+UcS8DdSjOk8FBpL85zZqOzwaOXP+zI2mFu8qLHfSew=;
        b=NV32MvoIWY1Z2+Ak60TU2+bUh4Nkf/zkuIdQorh2BreKjOxTk0ucMrxTxSiC0JNCTv
         nsmI/eLsbLFewnwC6Rgvo0j6fkkfjhQPKvm+GBzSZOoa4IxU5sMuY0A92t6oZ9K2eBvj
         VozwMt6ColgQkll+OezvOvwh+lQtX54+XeeNiF9Auf3l7MQOTTXgvYOeScIOwq7CGaFJ
         5AYfwP1sTsGsHQCoNInzg+s89fa/sJYioKJrFscxyEQTIdpp3LLkkoOgNpU7z2C/FKjG
         9auQqayOJjQ12Z/Zg2uKAqKM6dS9ydEEDF91VoGGvh9ODD+9Ga9+GKdZ9RSzdewjwbyJ
         zqJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791787398; x=1792392198;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+UcS8DdSjOk8FBpL85zZqOzwaOXP+zI2mFu8qLHfSew=;
        b=Z/VQgi5K7rG8O+CZ76Q5G0W8abar++V8u4u+Qw6Pmp9WCamo5r5DSG9MLvIqbvO18S
         EEsPKJZrmaFxfCKTPHylbkDCXlhfUP67+qBiDjiriSRK3klufrzvkpWZ+NvCA+soLBSs
         3vL4i/EI8db4cnzyyTG+bvqc6R9uXkIjovGCMVzGrk8jOnk6BcChS5nQiywZ+hcfBhzs
         D+q0M28zBafwRYzzychKwrNsUiFHt7xcGdhsjHeVga3ecHy0bWNg9vNcTETIhRdXhsyn
         qGzla832x13asPv5waK7m477lt6Hmlg8mZ0ZRHh5GndlPiCzc3kAoIKusHSU4cnPOeML
         g0rw==
X-Forwarded-Encrypted: i=1; AKwUvBxQvFDFAm4Knd82U/SwWwYGcOUWi5doC0D0GCleR1CkqQ5Wx0KyMoW6lx9JXoBF+jEq614yffqNqCU84x6Plg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLysSxT3TzBDw3hVy3ChteFxNd0E8tEL/xAB3h4QRb7+FmM7l02
	MeDlgHlC4JrAbxVS+aCxo2ayu4L6PknMfxiY4Hli0/6IDPEU+JLGpVL5mJ7T5Q0hwVzLLl5UPgc
	ka28/Zw9wtAAZRAoZ3/fiV4jkKJZk+f6ANIN/uAuk0P+p+9LJh1ihuI/X8uft7jk4jYHJGg==
X-Gm-Gg: AYBFou12YYFlrN/ij3SezNl6IDsqfUHlc9//o7DXlmnLQLOxtOi27CJHxiEzKhTzUl8
	Yezfuer+53VvZyTFe3ajXwk01h7xXY+q+JdOU7nlWsmsgguEdAGkHaKAOEWS+UMypKS95on1cZ2
	75QShCwNkfWAAqyJUvSwcCrzXYh/IMHXWtbguuOaGplt0Aconu2KYaq+Xt7aMPhGQCmevAy+LlE
	W5R0T1YrYxTTybcAdj9ZK8k/beDAttMs4g5joGpYj19JVtuAk07luF0Wk0vdf7ffMeMhfIFIi9B
	2DsHnDOufmQZsrbTcGjeiWQft2klAjkQkok3QZjYU+8mldP6nUquqmmkV/ryxDQTsVqKvYLaOAK
	m8+xLNhhqdUvYm5Gbv2BAUITCzZBOOJlk7Q==
X-Received: by 2002:a17:902:ccc2:b0:2d9:2149:57c0 with SMTP id d9443c01a7336-2e842aaeb61mr76706825ad.22.1791787398016;
        Sun, 11 Oct 2026 23:43:18 -0700 (PDT)
X-Received: by 2002:a17:902:ccc2:b0:2d9:2149:57c0 with SMTP id d9443c01a7336-2e842aaeb61mr76706715ad.22.1791787397479;
        Sun, 11 Oct 2026 23:43:17 -0700 (PDT)
Received: from [10.152.193.243] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b0aa4sm38539625ad.35.2026.10.11.23.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 23:43:16 -0700 (PDT)
Message-ID: <3fc7d852-b36b-4d89-9e9e-fd690d258587@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 12:13:12 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 01/17] dt-bindings: net: wireless: Add QCN6432
 device tree binding documentation
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath12k@lists.infradead.org
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
 <20261008-mpp_bringup-v1-1-2c5797b5e4ac@oss.qualcomm.com>
 <20261009-brainy-alpaca-of-focus-31fbbd@quoll>
 <fb81a042-82b5-4565-9a5c-1a3c038a0d14@oss.qualcomm.com>
 <8befec82-035d-40b6-a3b0-f1ff2ec9e53e@kernel.org>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <8befec82-035d-40b6-a3b0-f1ff2ec9e53e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Woe+otfv c=1 sm=1 tr=0 ts=6acc8186 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=iJS4XZidABw9b6rZcNIA:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: 95V42xAITHNWHotJ16T5cvVIxqV3fBz5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAyNiBTYWx0ZWRfX5QFb76hjAKVn
 exBPgT4Koo47rIyLWmm8F5leBohx+3zZb4FvSuMCMSEX4uH3yuK4t6eXr5++iqaAsoZ4fffjjXA
 7kwUFCU26cdL5TFSllorEzwJoF+Z3aE3Nr8BC9gietHiRNtnuyMmOx/+l1Riujdm44vwvkfWves
 tDc3fEu5DXvFkKqrd62hCDMeUx0F2w6QxKJnwhg4OrWKFMWMDK6xlInRNcdR+P4EGYfpw/AsNHp
 2Fc5/mzO/J6zltrpxktpERC0QCWm6o6pItayipTScgnfyp/hYV7SM0+DZucO/KuKtzJgL2rTg5b
 L0mK+1y9gZ3xtcRm2u58NskR3LkaT4YKI35VxUBXGmeELufY6RHSsVvN+kWOYpHFOsI638B17+E
 +rMtWtTvia8ECeOXL2mOZ6LI5HNX0OyMLxy0u7b9tbrcgxwnJ0W7LFHSUAKHTG3YjMbdvzVLu6f
 OCrO8m/FOEWtYvtOqYg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAyNiBTYWx0ZWRfX9VeUu8WLxyVI
 jjhqZn/fe1Kn0KGW7Eb3PPLTslkQ/KMgHmTdC+I7nIdwqqC4r2fSMdbS6SBucuzLIKp0IHqRxWy
 Ywy1ClPurs/xUXsZe1hre0E6iHVOLBY=
X-Proofpoint-ORIG-GUID: 95V42xAITHNWHotJ16T5cvVIxqV3fBz5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_02,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120026



On 10/12/2026 11:26 AM, Krzysztof Kozlowski wrote:
> On 12/10/2026 07:29, Aaradhana Sahu wrote:
>>>> +  Qualcomm Technologies QCN6432 is an IEEE 802.11be Wi-Fi device
>>>> +  associated with the WCSS Q6 subsystem. The device is represented
>>>> +  as a platform device and uses MSI interrupts for its Copy Engine
>>>> +  (CE) and Data Path (DP) rings.
>>>> +
>>>> +properties:
>>>> +  compatible:
>>>> +    enum:
>>>> +      - qcom,qcn6432-wifi
>>>
>>> Is there qcn6432-something-else as well? Neither commit msg nor
>>> description explain that.
>>>
>>> Best regards,
>>> Krzysztof
>>>
>>
>> QCN6432 is a Wi-Fi device supported by the ath12k driver, and there are no
>> other variants requiring a separate compatible string.
>> Hence, qcom,qcn6432-wifi is used to identify this device.
> 
> Then it is qcom,qcn6432.
> 
> 
> Best regards,
> Krzysztof

Thanks for the clarification. I'll update it to qcom,qcn6432 in the next version.
