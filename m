Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C31635C6A0
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 17:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788974788; cv=none; b=PBqqfEiSspxgsucJey0XOKmh7zFIfKpr3OMeLlI3QVz5p8cP31cKFvh5H3ag96MwUXDzu715iBF8lQePKtZ9sG+NdHXw8bfqSDBa2LByA6Y9WT9Llzx+nzFVTlGqcN9v8xa4pY6L9rtezL5LLUCJdH4+1sRtQxbU17yp3kUlX1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788974788; c=relaxed/simple;
	bh=YuhMC+ikAd+pjOQay2Ig0CjXXaSBPmUs/yYHR+5uMzM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=BTfIYNyB+cU1h1HmZJK6XM5/AWBP7eUtusT5oGdxbDoQ0JrdhdBdlhg+gKzzDxgE53Vmn80PnwJI7wP/Lzjw7ruFR2YMJje+i8pj3ZTDcGUkoB7DokMBpTt5OO5viRfS9YR6HOJOSAEA/F6F42e0gE2zb5ez1LHznIs+DsgkgcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=L4CMqh96; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=g1LFYfUY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="L4CMqh96";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="g1LFYfUY"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689H7LMq2562019
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 17:26:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TvnR5tjlXGe8UBW8k3JIMB+3DEiF8Somqt3qxNxJN1o=; b=L4CMqh96zJuXA6P3
	VTRI3yFqqw95fvKIuKcU2CC6CMLspWKcEJvHZHajWXz5OGIsGaOWQXzEe8RfCaT4
	boA7iEJSkWCEi8d7Ydk8H1+SPckgNCMkj+brCfTsGe/No5ejIxsf0AWviYC+Scmj
	tbWA2xEk4kCoXJLLZK9BThScM6zDhuOzndM3XpWWtnvrIQBVgzaWABkqQAqLElUX
	a/zpgGWtyaSR//7LKrAhGGjnDt0m+LmYU9O4Y5Oz6tq3bW+bL7yAeiHAX0rKHsC/
	5rORAWcgMsDYM9X7joFWeCvbUbtv9qU4AwoneNJXZVuuWzlXSenvP21gb4woQvjt
	ojHTOA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gk4xj22ey-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 17:26:25 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d001671a54so109797225ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 10:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788974784; x=1789579584; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TvnR5tjlXGe8UBW8k3JIMB+3DEiF8Somqt3qxNxJN1o=;
        b=g1LFYfUYkxYX/BfnH34DSNk7QssZ7Utd/rpiu4lX+oSm+kbSYr/uBdpSh9Y9ZMKWXP
         GXmuA1e1ing82hcf4GLZKkfjKmxQKktf0N1inQRuDUncNS4ykNGnSDuNSIofAj6buFKx
         yjOX4f6VPUC86aeYbIGyFfTrkKMPecNFBs9vMf1uF3kcOltSTq952oo/dI8NxR3trgFG
         bVi2hOCPJBYAAiibwnT2B6QeinJJIqgqP8DsMEyLnxCkr+pS+kruzackK58fXwn6IBJf
         GY03/O/LUVZmXyfQkFCNuFRKFoIUt2DXGeysHZ+q01o4+skmxJ3pzd/G1Hehr4w53WRx
         erqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788974784; x=1789579584;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TvnR5tjlXGe8UBW8k3JIMB+3DEiF8Somqt3qxNxJN1o=;
        b=FVnWi+KvaxGBBhBsuNfW7yLC9X2kB9BMCqC4AhtKeFqiAY7+m2GpLpIxTSFY25sL34
         ruHcN7bUsd2k340SrJm5cR2/f8T5cB3jsnLiX4Z3ZAEQox0CmCLOnbpxOCvsPnehZdoM
         Zclvx+HNjt3TSkYD+nTMcoZmDxAs0Kwo663u7svj2/0NUiUYyI8yT011tGLvcrB0Nhma
         IWh7icWSj0afd+LSD0kbdH3aQt8t7o8Mcg44QP2Gpep4uBbuHZhDnk5pdr6X5u4I8JVX
         m2CQDX7wPknpuZsBWmXZvHcwjzl5HyekmMNCE2BCRh4/dKm6ve4na5m/Jd5w5ClCIVbC
         sUVg==
X-Forwarded-Encrypted: i=1; AKwUvByBvrxVgyhbQsOddr5+QK7Fp+QFKG4NOkHpOvW2jVZpKKgEKjAErtteC4bkca+RQ1sl/vidB5HWwhy77rHQKA==@vger.kernel.org
X-Gm-Message-State: AFuF++nJWDidAYvJccgztqVW9dvJuOdv6Avmc0fpr8Xvkle6+Mbpv2iF
	IhQ3xc1sDwpQDrSWQnZUez9+TxoJUilZZ0+KGhWjSmtCt8vYUF+/LKElnQibT7gAf+jT3n+6dNY
	x0brATr7FW3tTgcJum3gYVk0+R8ZSnjYXQcJIgLccCfVJER3N97/E+4wR2WAtbblD/r14
X-Gm-Gg: AYBFou3y8I6kLZ/K/3Erkmkn4fuQpteFy+jaJXWfY0Id/jdx48Tb4cnvsNkAK5f8Rii
	Ign+LkpquMuLcwXapk1wo8fRA/NpG5ZPWbGuvZ+iFu2BB6j1X5A2peq5wQ7w2LvM5cmEj+E/QDi
	/om3r9IUlcYazcX/DGj1p4BQ3kCoVmhZ6j6iCosHeuAg7NuwSeskp0RrwqG84t8auLgBw9rY+OT
	zLjsQWnioUYTgDSAmBSNwFnjMdwlWieU8wqEPvBoOBoaTiBW+/2yZUGys5BkSYrFVY7o9mrt0cj
	shneAfGHL5WdiMWu6BoLCFfOY9FtxbdwQxj7R/VpWDDcbOr4IOaUMzwr9LJcQSxZDRsd63e+rzM
	pmkqO5zUtW7q7OLVy5UWYA94Dxp27Yw==
X-Received: by 2002:a17:902:ccca:b0:2c9:aae1:a61a with SMTP id d9443c01a7336-2db127cc2afmr548653485ad.14.1788974784256;
        Wed, 09 Sep 2026 10:26:24 -0700 (PDT)
X-Received: by 2002:a17:902:ccca:b0:2c9:aae1:a61a with SMTP id d9443c01a7336-2db127cc2afmr548652735ad.14.1788974783562;
        Wed, 09 Sep 2026 10:26:23 -0700 (PDT)
Received: from [192.168.0.108] ([49.206.13.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1495b40esm77278825ad.22.2026.09.09.10.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 10:26:12 -0700 (PDT)
Message-ID: <03b61010-2210-4923-8172-545c30fd97df@oss.qualcomm.com>
Date: Wed, 9 Sep 2026 22:55:46 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: Re: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility
 Domain (SMD) AP support
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
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
 <80b5c9ab-de1a-4170-9ea2-26242b767e93@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <80b5c9ab-de1a-4170-9ea2-26242b767e93@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE5MyBTYWx0ZWRfX1Br+AwoogSIs
 x9gRIRxApnVpf/WohnxVPfS74NNFv3LWvyX7F8Mqe2OO5tIaFh9COux/l61wHnk9a4pS1QBY3Ug
 v4s0/Ko6Kt5uGbRG7jbZK9ugTIY9rs4=
X-Authority-Analysis: v=2.4 cv=J52aKgnS c=1 sm=1 tr=0 ts=6aa196c1 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=1GmPaZxtcqOdqSZF9xWxyA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=ly1jUebXebrwMyEau08A:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: iyO57ezePKY9vAJLoOYwD-lb9a8s9Vil
X-Proofpoint-GUID: iyO57ezePKY9vAJLoOYwD-lb9a8s9Vil
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE5MyBTYWx0ZWRfX64ntvZZr+lO3
 bvRDX94Z2ozheGZionmveovBxsbffQiLYkWugCj+AQ1h3DDUSYTzdJy6+fL1RV6iasurXd5Bin7
 vIXrVfsuX5AnMUjHYpbQava8iFRE27wK8sG9Q7P2v6GUx3MTFvAUvZYiGQ8O9z3ygeiN8hhRx/J
 RMd4zGLWBdSSN6bJE3zSfLbHJ3Jq/EhNA6XDcqIteCNF0XGip2+rQI2AG8fNo0GDzaOt+rl19f0
 UbjaVpNuSHMcdoeNmtRx7k14u6kEG23bnn7yWYG+2Q/sm3ivAg1N9Gov4rg4ZJS/57Ef7mH0Rjd
 UunEYTnIfGl3n7UoP9Y+l9aui+yhr2XNopfiXcjfDiiBP/X8NhHJt0TIU2dHZk9vYSeKgE2+RsR
 VnnOIGQiLPZXs9gJKwCdnmV4atoyXnh5iwehD+Iw37hLJfL4wd3GBcsUPopcMaHh2rgUrUI84CQ
 ydCh3tmCDIsWKFtU+4A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0
 suspectscore=0 impostorscore=0 bulkscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090193



On 09-09-2026 07:42 pm, Jeff Johnson wrote:
> On 9/8/2026 10:53 PM, Johannes Berg wrote:
>> On Tue, 2026-09-08 at 17:20 -0700, Jeff Johnson wrote:
>>>
>>> Apologies for the AI-like commit messages. Those are at my prompting since I
>>> want these patches to be understandable by folks who may not know or
>>> understand the underlying details of SMD roaming so I requested they contain
>>> enough detail that referencing the spec should not be necessary.
>>>
>>> AFAIK none of this code is AI generated.
>>
>> Did you read it? The comments (in patch 1 we were talking about) are
>> also all clearly generated.
> Commit text was AI assisted. IDK about code comments but I've asked the
> developers to be as detailed as necessary to justify the design/code,
> especially the SKB extension proposal.
> 
> /jeff

Thanks, Jakub, Johannes, and Paolo, for your feedback.

My apologies once again for the AI-like documentation. I think because of the design justification details and multiple rounds of AI-assisted reviews, the texts ended up reading more mechanical and AI-like.

Based on Paolo's and Johannes' feedback, I will come back with a v2 that explores an SKB extensions alternative and is more wireless-contained (with concise documentation).
