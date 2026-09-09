Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF1D58596D
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963142; cv=none; b=o5ghpfZf99C3WG7P2MkdIrQvkGwUTRZu5fMqbEKf4/atWJOdnHd8RKyziacIIdlGRQwUozac0Mjwzx7sITAeClgbOKcumEYpcsXE7fjN1fkrWjb0qS9J6zrKTAzN+TqEmtxbSWoe/+QgKhyG4ff8ud8gXWZ2Op0ebrkFmIZ362Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963142; c=relaxed/simple;
	bh=BvWUGhq18+3DDKj4XOXKcGt9/9H5QQsRsuO5iI193ZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qCFOojBdep2W51X8ZeoA/lpxX4rjiFCxz5kX+RaRlOUuDoHwuZO4QStnZqhU84YaUMkewdnV1iiT88G7AiMQYnm+IbJU1KH1Y+FkwEIxur+Rjxqbd3DuaHmzStO1w/f11Kx6XpUba/dp3EKuWElj8tzXFF64i64C9LJrTpcFRDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Mve06kLB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bIdYk4Z0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Mve06kLB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bIdYk4Z0"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689DIRj32080978
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 14:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xlSdF2HOZ+5NxjHLPVwVCj4ppBlOqupjBhscykPtotc=; b=Mve06kLBnKeOZsKi
	Hzeymo+goblE/6clqovkahHG8lF7r9juI7sdgFXISJbil00mdLwcsbNc4MQlh+XG
	WRiPDggvMYBWXhWM2bDkC5kRtBOBVIHbYmGkDMhJN8AjziHYct36+7yDajq0IQMA
	YBwT26Pkdpe90mmKFaavJySoAEd5T9tb3XwnAQtQUdfjeavFm8MhiXV1W6kpvraI
	jfr4FvgMb9o04oWTphqLFrh95GLKitHhYRAVsIKSMJqU8Cc4mJso4xIrBYXKk7OU
	CS3Berc+GM3Kgy5lKiMx+hAaU9vbTO7bzAiosCJPWBbhRBhXTc1w58FbJEhjnMw7
	kyeE2w==
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com [209.85.128.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gk87r092u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 14:12:20 +0000 (GMT)
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-858b746a9a8so91243567b3.2
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 07:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788963139; x=1789567939; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xlSdF2HOZ+5NxjHLPVwVCj4ppBlOqupjBhscykPtotc=;
        b=bIdYk4Z03BfNN41I3NkU6gqQuhgj0P0nyUBXzrzueJ7a1TODw5DdpomFlUY7iqIUte
         NrbA4QL504MqO2CR2L2Y5PilExB9Pu2aNJA8RhASNQZTZ2gHWHj4tZa3WaTS/YyL/y5U
         s9VBx/MIt0GUi1aM1wE2N34aJYihssMPFVq62XI7Jx4NL1I+IZWadzHNd5j657pDiDPh
         c3FxaRFKA9yHsvO63lEDT9F5Fwsu3yAg+OEemp1htE5qDpoOtNDn3sUTBjUbTrtk+VbA
         9VBd3jUToVt6lNbWkv4mi0MKcL+Im8id067abJiIHYfrqWf4yyMk1895oRhJ+hQa+rTd
         LHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788963139; x=1789567939;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xlSdF2HOZ+5NxjHLPVwVCj4ppBlOqupjBhscykPtotc=;
        b=qI5IXzuVIUixBxNURg0qRYxonHR61YB0FOaRUaO6B014x15Ht7pwo0GckWEqrNPiY4
         zys/yR8w28f+KMtqMgdfjP5Ffnew8pJ3JU4JNxZiedmLaPdqOJbVELVwwYW9cBBSaz47
         y3MRCDmTGF4xcBjRAaWmLan+b7FgWm6fGAghOK/p4Gy39X2GGZmhNogCS+H51QLvh/Gf
         0nqKlcvgkdbOECPieSUSFMxhYOQUG4cct4CTZ6KzFHA8IZ5PQJU3k8ZG5PklYgAaK9da
         4soCAHPBx2dNPMa8J2Qhvca7vnGKfp7BSzgQqLPV4eBGGFydcHdVGXYKMwhWUmMHAGda
         Tqfg==
X-Forwarded-Encrypted: i=1; AKwUvBxcywAWx5BsAbK7RkFahHbOaKEKB1roGX8UUUJwi1Ve3SY+qrYVV0EGn17lRSlokJZY9i8njuVvlFkycPl1tw==@vger.kernel.org
X-Gm-Message-State: AFuF++m4/G34VjLcT3gsRoOy2jzw6FdEzArmmBu/QGL34KRtLtmIKrKy
	88F1Y6NmgYhsdtccZEGj61LQevFMSBcuzuX+UrQd3qY7Xv9FHtzcY7juN1TKa9WyvIe/gVLMcCL
	wQL7ALjktN64i1jR70qp14vz457Z2Q/yF0RR8okQZqONCQp/R20t1387oAXKgcbgbo+vZNg==
X-Gm-Gg: AYBFou3LpKm6Nc35HxsJRt8uo+kwm/5egyZjVcRgG0wOpRVa1XHASMBdjts2vwdTttM
	E7ilSw+rMRBZFW9HzQ2vBeeyrS90MHp1CxKVkfVZiZhnTwpxNw56+fUoG1SKsAVX+cbvr1nCEKR
	jn2wS08pWYEFt9J7z5VkC/hDEIXzYmqQNbsmTwnb1huGo+2NtYmKD1qWG7CruqFAkNSF7Cc5Rey
	yA/ntQezFbd94lFGGq10nxa2r+84WKlu4mt54+FtYF1Bwx5qGz29CtXdqDAbE5htzgXSKvjsAdP
	4Jq2Y3UiGdjiPUw4kk893KjlaDYSSNQIngzKgPDNqj9sX3qeVkqVfCqcm7fs2qL/6zkPZpt/Npp
	r7ThkpyJH8TAz2wuCR4lH/X2TFYzq/yyxiknCLDGUJVrdXsadnqpqosEtRTZI
X-Received: by 2002:a05:690c:6aca:b0:81f:64e8:cac5 with SMTP id 00721157ae682-87f22b7eb90mr28852527b3.7.1788963134156;
        Wed, 09 Sep 2026 07:12:14 -0700 (PDT)
X-Received: by 2002:a05:690c:6aca:b0:81f:64e8:cac5 with SMTP id 00721157ae682-87f22b7eb90mr28851897b3.7.1788963133502;
        Wed, 09 Sep 2026 07:12:13 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714b52f641sm109480327b3.37.2026.09.09.07.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 07:12:12 -0700 (PDT)
Message-ID: <80b5c9ab-de1a-4170-9ea2-26242b767e93@oss.qualcomm.com>
Date: Wed, 9 Sep 2026 07:12:10 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility
 Domain (SMD) AP support
To: Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
 <20260908125017.0fb226c5@kernel.org>
 <404004c4c97bf776077685b7ec33a14fa777cd70.camel@sipsolutions.net>
 <80266eb9666d6106110d998cb6330868da55bf59.camel@sipsolutions.net>
 <20260908132004.29176fec@kernel.org>
 <0e950f7f0c3f5a2c1f6476e255716b09876624f4.camel@sipsolutions.net>
 <e7089219-ed02-4288-a678-660a52289e61@oss.qualcomm.com>
 <e9b36721c9e2b0b24c89c2e1b5b03b17c438f30c.camel@sipsolutions.net>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <e9b36721c9e2b0b24c89c2e1b5b03b17c438f30c.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=AImJJIpd c=1 sm=1 tr=0 ts=6aa16944 cx=c_pps
 a=0mLRTIufkjop4KoA/9S1MA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=Q5NyMDGURezFpV5zReYA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=WgItmB6HBUc_1uVUp3mg:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE1OSBTYWx0ZWRfX6KZdJtvdOBrj
 AXzkbmaArJoPLnhgPYe5xkO9WMuEJnmMFNubRnRSgTVQ/UY+CICmHlYK63cEm7wix7p45KqgHgJ
 SAlyyy4PkYS1C/2kPIj55Q0b/wKIIMvZKgmToXL5dOfyg58Qi3AAX4Oen28ZHIT9bocSVG3JN5V
 Xu6ddO65xuGygbmpPFDE6omlEFJGUiRyT8lLQDrplrK0DtT/P0JuqVanj8TU4Fh/VJHRh1GY7d+
 BDuMhudCJC0p1Fr7eDKR3/jLbbsb/Fc5k5fa56tn/cajFMYMtgbYHy1/nr33iBwK0QPJlMV/07D
 lEToECqWU7OZrXGoJaRBymHzIj9dD80VjgSYxm69BbS1SMwLOBxcdpw3U/TLRQOcun5t080SU2l
 kLBKa8T3OCkX5lM8eM9HNmF4nVAd9zdNEU84dyVnudVlu8vpPepC0HAm4ykMPu8SW9H4hQnGXig
 T9/KcLXJv+9HRyNm1zQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE1OSBTYWx0ZWRfXyOkVTMV+Nz63
 1H6zl0oArgvBUSm4EnvKeu/5jNVmHqvIyE38FeJlpbhXd/cGDnJDNu8XDa4K6A2I8lDace/Z0aE
 MYoxg/3uaRLKa/X4N0OomwPqp83oJdg=
X-Proofpoint-ORIG-GUID: kHNsYHzisydqP3DYVVdIB_hzkpoCpRQz
X-Proofpoint-GUID: kHNsYHzisydqP3DYVVdIB_hzkpoCpRQz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609090159

On 9/8/2026 10:53 PM, Johannes Berg wrote:
> On Tue, 2026-09-08 at 17:20 -0700, Jeff Johnson wrote:
>>
>> Apologies for the AI-like commit messages. Those are at my prompting since I
>> want these patches to be understandable by folks who may not know or
>> understand the underlying details of SMD roaming so I requested they contain
>> enough detail that referencing the spec should not be necessary.
>>
>> AFAIK none of this code is AI generated.
> 
> Did you read it? The comments (in patch 1 we were talking about) are
> also all clearly generated.
Commit text was AI assisted. IDK about code comments but I've asked the
developers to be as detailed as necessary to justify the design/code,
especially the SKB extension proposal.

/jeff
