Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AD33E49D3
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 16:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784650307; cv=none; b=qI5/ml0wYJHW+p5/MfCpellQMn/q9f/paD4FPwQharVKwy9yY582xWMuH22Mp0lBMFvkXXebzsRtIT0P3tRswa1ErySzH5moCej1bX4+KmzEZNw87a0c4NU2/IGzQdXN4QdSHNsH/2ezD6bQ+6dsl5gjT0sy2RR9sI1TzLsCfwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784650307; c=relaxed/simple;
	bh=ZRbPLeIdH12xY5JpoxBgTHWFEu8GrtyKzCgS9tWtGrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fGzEz22WY+IFw+B/E8l47iqabHbGMbxyUxMxbjwM/2iAuomP37XFHO2eeegbMkn1Xd38iWhlTfUz2+CgnsyXaL1+jyGjzsyBkMCs9p619iCBsA2JZ7rNK4WXcSJvIQ0RMKIjlQaha5410Is3FZ76bniuh/TklNAgVLRlWHDk77I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LEk/9VJe; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XHLNwd28; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LEk/9VJe";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XHLNwd28"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LDfpYp1590953
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 16:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mYflFeJGiDlHHnobo387r0vJX1+Zy6ipWPbVmTEI7xs=; b=LEk/9VJeNAlW0YbT
	5OLIhpcDjPQP01Eoab907ZsoC1wOzRqWursRoG9O5RKt5YcNEH2CRiFrmvIRH6L2
	S+KUtsMHdmklfsnaHaihhIcFnBzCOHrjuqK8nG3+C+01OA5tuBi0Ksb6hNuo5XMe
	Ia6cm8Rg5TUiHlu4HLXwqojHz0XETOEYJ6RmJMHa6e7iSXsi9Z9dJBQsOwx/VWb9
	q1r1JZpmczPmCn6DmJo+FsAQTIKtg8Y8AasB7f3Tpa5i5KLP6Wh7xlJq/GvxLTBC
	zaimcB0T8ClTbka9oXJrv2bzzUFWORNgVlatCcZnAMN5m7cMqnDRtE9gfimnt0QZ
	1AzJcw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj0as3rjc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 16:11:45 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb7049fa552so2151043a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 09:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784650305; x=1785255105; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mYflFeJGiDlHHnobo387r0vJX1+Zy6ipWPbVmTEI7xs=;
        b=XHLNwd28xXxy3+EvRonslC90V8c/hMI1WXtlALYf5U4RtvCi8rznrZXKdWUGPD15Wp
         k1wA1gTHmnGKkGfJQnhy06EG7Qq6mNd5eePT29iz3OZmov7QkKx1Jc8oaKBB+bVwGZKv
         /VIPptGWSFF8w3rp4s3E8Al2lHiPxM1mrJ8ThbsD+KR5AztjMiHoWhGIULuLcGbZpivz
         d106TaeuNC/uljKu6+EpB6tfmUUUk0WsXidY0TSA/YqnnVFXYTpCHyeGWgDFvnOjkeMS
         /K8nld2TKxSZTaRgkuIXP/YQ2Ep5CFbEHrHgcM0o9Xr7w9aM6EyR7f79hPX/OOjIq8ng
         t3/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784650305; x=1785255105;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mYflFeJGiDlHHnobo387r0vJX1+Zy6ipWPbVmTEI7xs=;
        b=cjS9mn4b7SzGERrA9B9Tzzgbje6mV4SUy3wJx/nHMkFSapk0eq7FGkuHnli99xVJST
         p4p1KCyO/4x4/Uk9UIQObLr4m12YNeJ/dUErmsUOBl5abFL0xjN5b/k1sD+894w18l+E
         NDK9ZOLZ67N6HcANep/ZuEeXGOtNxp7n0DnjW9RpKumyF9GCWVH/2KXsbCtIfpCYU9A1
         7lnvhLm38C7cHxr9v4Q1xbJDCZZ5nc34WJjd7s/AW1O3/9ECtnwATzOKy8FWcH4zwFnp
         4+GoIVOc9f4N+TfdT1Lfbhx2+5KnJAwCPpxrr41kbR+pOdcCbY+ja4ChKdguaR0s0v2D
         7bsg==
X-Gm-Message-State: AOJu0Yw04x4m/07EE9NKLi425nel6CIzyiEQCo6+RrFts2opQLpWqre3
	Rjcg0zuIxnH+SOQsCcAx+ksykQI2CdM3OyyEGf2/tsudBFpcfuqhu4SgUbcI1yDk6M847R3KndB
	be0RJDksKOag4uQMd9KXaDQWo1HfDt2bOypIZ4/Mw3fj4gWBJXz/fEiT93//WEb54E8ltGRd2vT
	rXCg==
X-Gm-Gg: AfdE7cnh9VYwX1ZpayyNmzwqb/LVJtnCBpLymg4sqAfLjEddHOQRWp/2l8dsUBVQ5F2
	6FTKcwp5wLxoObDUSH0S4X/wuvPbgmvoZHh1BdUAqL3/HZoRxx1ilYXRSm47pEiKXi3Z3ldMLme
	nQ/zJdzzhSzuFRLxAaZ/XXh9z6UJQTNS/mmvh9X7hcV0yD/5Nt/jl8sTewInGVyjWpbfgBXf3HE
	tKZgHEdpafegQYtCdM+tyndR08HoIg5qlMng/iEwk9iiWcV5G+rsg1ZLDT+82y7xlr7Ndp88KH5
	pAuKzAdodd2yTc6xfFHLIWM4ovB0snW6GURqxMbgnMT7AkrEgLJnBdU3YAJyUFEx4KpRYP5tBbK
	+6IO5q/EsxsEHWMDLlYz6z8N7qK4y/VQPfRiEkRFf+lZ8Q7x+I22kfgVu1aej
X-Received: by 2002:a05:6a21:1506:b0:3c3:81c2:fa47 with SMTP id adf61e73a8af0-3c3ad7a3880mr21206287637.12.1784650304762;
        Tue, 21 Jul 2026 09:11:44 -0700 (PDT)
X-Received: by 2002:a05:6a21:1506:b0:3c3:81c2:fa47 with SMTP id adf61e73a8af0-3c3ad7a3880mr21206260637.12.1784650304209;
        Tue, 21 Jul 2026 09:11:44 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e07000fsm678017eec.21.2026.07.21.09.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 09:11:43 -0700 (PDT)
Message-ID: <90548090-8609-4068-bcdc-814963edbf71@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 09:11:42 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DESIGN RFC] EHT/UHR Critical update handling
To: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260625050326.2946848-1-manish.dharanenthiran@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260625050326.2946848-1-manish.dharanenthiran@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE3MSBTYWx0ZWRfX47cGVeyT4szZ
 z4pQft7TkXG1qyCweF8o673H8J8c05ZunFbDZMIAbyS2hIm/PaXxQKg5VwSVJITufIvkfnSaWR3
 o2ev1QAj0OutfaKm979L9vJjCL4PjEr4SqagXU7BH/jKLNM4ju+Qx83iFLVCNFZbNJl6OgfleMe
 /BGh8wUlTbZTw/VVCxG+pvheAzjUmw/7l+Sc5gX7EmPlJc2L7MWbe1PB/bSpBDobf0z1T4o4LuC
 Pg10sF7flXdOS2cYDvtPMO8hcVE52XMj0AxDZGbrk25f4902gbr3532Z6bGw6G27YxYcClUypPZ
 rzs47Zjk9pOeGEYvV9AshAPXknwzv6g7vEkfot+3hlYzIwy8P1O7Jt+u+Oha4jHmuC3iiDUa475
 2uUNP2mVi8C5IvLymjqsgYguIHrkxvt3EjLkZ6iWUDEEI0/8+lRvu3DQrkISGTouG1RjqwsQEhU
 NyK4CxqB+l6SV57AjLA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE3MSBTYWx0ZWRfXw3CIW+j3KR2e
 QXM5uL8WVCKT/jat2zzMMp7aiOSJI3ICsoAuxja7lxjrJ6vpfXhLPehs4wjMTBlFQJbXX4goqxB
 QhKu2JUYgjguY8k+xUoJ80SsAu6vESM=
X-Authority-Analysis: v=2.4 cv=DoFmPm/+ c=1 sm=1 tr=0 ts=6a5f9a41 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=pIbJr0qklbRdVuy0jGYA:9 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-GUID: UnOpv3lgqy6_qNqUdzIxj62PMr8JCJJr
X-Proofpoint-ORIG-GUID: UnOpv3lgqy6_qNqUdzIxj62PMr8JCJJr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210171

On 6/24/2026 10:03 PM, Manish Dharanenthiran wrote:
> Hi,
> 
> This RFC outlines a proposed approach for handling EHT/UHR Critical Update (CU)
> procedures across different driver models. The focus is on ensuring correct and
> consistent behavior of beacon and management frames, while addressing timing
> constraints and scalability challenges observed in the previously discussed
> approaches.

The Qualcomm team would appreciate any feedback to this RFC. We are eager to
have an upstream implementation of this functionality that can be leveraged by
all AP vendors.

/jeff
