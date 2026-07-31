Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F9C35F185
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785477256; cv=none; b=LVACKdxdwYdcv9RNyuc1A5M467q7xGQFn0WX4jRQFrrj6CyMs9SopsfUgoX33n214uAFxgyEbiF8Fac3pWaxun/6ME4Q28/xXntR0cBFmMcrLxYURCuLS7v0zR32SBH4fpP1uNlILe3e+pWo8Rz5+GJ7EZSOcfm18TajwrtHeSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785477256; c=relaxed/simple;
	bh=WF0RaYG56zNBKr9KGq4rqoVRsV8jwJaaIY0uB1wt1ok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Aeft4sOqvw2Gf8GlAgZEhXkv0BE6mg6WdNQ49RJx+DXAtIEpJ28yhYUQM0mlQZSPYvEysietuGeheA3Srdsbg6rBfjlymtkCrTPxSLn5hxU7YIku+kZbZKA1FmWKx+tFCkDH55gvMNZ5J02T4xC4ueIyZR2cMyyTLgER5gQMr0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dZvbAmSB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CGf0S/tf; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dZvbAmSB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CGf0S/tf"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V5HRcF3235722
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	c+6uiNxiXp+6XrR6HlL4LxM9vmUmpkD7QjjW6V1Zz68=; b=dZvbAmSBOFtsqPl2
	qD0cAleWoxnxzFFmGfugIJJDISQY5EZlcL4NWkCHmizQuw46GS0znQMyZF8f3ouy
	jqCPrlkRMir75FWrZzN8xri/JB8ta7F60n4w68mQtdwNYntoOoPox+vHborS6ZbO
	ALiRsjBSPOwivc6aT/qw2Hsff391A+cK5FDfje2oN+0hcnukhaeTI93XWaoc+8gX
	XJ9n510RoO/9SLBH1dGg2Q5bcfO1UvzbMGGO63vLEg+q6XDO5Hn6UEOkYXRl5onc
	ym0czP4wQgeSKtFITgG5totFhHwcvbBzyufpfe9aaAHmUB5qehEAh7b39nQq/7ts
	W3tvQg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frne503us-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:54:14 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cacf17c7e0so7674225ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 22:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785477254; x=1786082054; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=c+6uiNxiXp+6XrR6HlL4LxM9vmUmpkD7QjjW6V1Zz68=;
        b=CGf0S/tfsB1E9jDBa1VQ9jnGmGDyR1um3rYzGu+g9LdlYdIfTagyy+kRWdj/o+rM/j
         j4KQk3rhLObEwsza9IScICBGSXTlmRUikxbqWt6JcGX/g0lpaDm+1YoMYZI0aoLeDG1x
         MbDItONa0/mbZDIArj6BFxWEbpCXMYf2VTZlw7FSuAzP/J37wcnDIEEzk62gvd41N/8S
         ziRA9PVO1G4QNfxizZgaii7FEuL8EwF/Y2h0iaA5BFWBTU0aNr1QwkxmRNiojZ47Gd1J
         t6Mu0ka1zsSfnRzRbZZ3ZYIuxC6sEPsqO5kj9VCCEr/RbPxU+/begiRblphL9aMJvsDt
         mnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785477254; x=1786082054;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c+6uiNxiXp+6XrR6HlL4LxM9vmUmpkD7QjjW6V1Zz68=;
        b=hQK/v4211cd4oewAD/6R6qID2i4ZLBd7OaYi1J/JeJXtF4ImIUoE2yLYH0cJR/C+Iy
         FCp+lqp/NqbxLoQLWrzY7goXZlH94eQvwIrroDZIVifWxsqd06lobTWweYz+rMkz30tZ
         I/UaszMlFYIW4SCzCVRcHBI5R5zTUquP8ecRzwHKrzp6XV/35qG61vYbEiQkNI8DmejP
         XZmzGOlu0EEkLXSLpawFrMpju5nY2j9fDNI6zFBLL1l6e2kwdZs/5Q0v37X+guvSMtEY
         qQij2aU+aZ/KYldSj0JcYcrZyimkUX4OhYMYoWqQzJWX8peMoWi2jf//AEqRYjCqdrJc
         CbKA==
X-Gm-Message-State: AOJu0YynCg9HJi+2xqkSlDejCd25xsArvZGnK/eLKyc6YlASnEcPfkD4
	GnIPN0BCDd72lRNfyUP3RqUEGvD+QHk9WiTHm4njbiBA0eGu1emtMjtJD6W8nbFmtKaQAA9iOum
	4Iu2nIhY2JBHVPD8yu4gfgLbfoRX0CJFd1OWlgfzd8d1bW0JfDUh1Aot5oggppBqN5Zd8Yw==
X-Gm-Gg: AR+sD10VSiMAVm09ODZcfKLzEyxLwnpM8cw2x8+5cyM0SnEp+SQETnZ2V7LjdPSIBH+
	6Q4BmFOfedQNv7CkduLU3FFimsH0JzUOjg6CFYEqBn9o2y4HN/oa9ZjaFDa41KXiY/ZEwxsd6kX
	KCdehOk1pW4CJaVPgLb0qrDZ888YaOAr4cktJLGUr907GugCoTTzhUUmp6p/G7S5PVD6LYGdjVq
	fNAGs1k7XiFnUKaX84kVkKyB2BcvQYuibvBEogsPsGjoTU66qXeT1Tbxphf9280onEt8KfV0baE
	bUyI4B+NsgQgwJ0sRVfLSi8VOZxFfTWHO10MRWyu23dlrGloICiX4kXuw1v0imQ7Vmxn9ae0Nsz
	CF7YF8ZsJ4AeIp19ZyTTFUI3imLsctq9T/KGcDTdb
X-Received: by 2002:a17:90b:4c0e:b0:385:d033:d9f1 with SMTP id 98e67ed59e1d1-38fb1451e8cmr760197a91.28.1785477253556;
        Thu, 30 Jul 2026 22:54:13 -0700 (PDT)
X-Received: by 2002:a17:90b:4c0e:b0:385:d033:d9f1 with SMTP id 98e67ed59e1d1-38fb1451e8cmr760183a91.28.1785477253154;
        Thu, 30 Jul 2026 22:54:13 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd4e666sm2466110eec.4.2026.07.30.22.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 22:54:12 -0700 (PDT)
Message-ID: <217852fe-5e01-4d10-8767-c44844db714b@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 11:24:08 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath10k: snoc: use memcpy_fromio() for MSA
 ramdump
To: Linghui Wu <linghui.wu@oss.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        linux-kernel@vger.kernel.org
References: <20260727072629.2297208-1-linghui.wu@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260727072629.2297208-1-linghui.wu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=ftzsol4f c=1 sm=1 tr=0 ts=6a6c3886 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=EMxFUL3Ltl7gSd1fbyIA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAzOCBTYWx0ZWRfX3CKC+EkDuRqw
 tMzVe+xLduuk5fFZzx5JlB7d6Nli7DYuFL4GYtX50TahZxh6Z51W32joJfK3ItL3DGTKM9jVI1t
 TVXkPdR/bYT+F2wLNbqdrXKGWSxaWhA=
X-Proofpoint-ORIG-GUID: ZRHVWO36tBn1JrqzMtS1qd7CbQpst53V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAzOCBTYWx0ZWRfX39r1WFd9h0ym
 s8JXzDESUF0RBwo+GmiZJ9mT11N6V5HMiVGcuHfiOeZVjO54NUepE9V94ZdjvoraDA6XYRKL7q2
 p4GNupiHTjxLvaoiHkHr/3+T8C6qIkc3ritKHm2nofv357jgjQlW2v4m38rPEqTSJyIbU3t5WxW
 ZBVP5IBFrjRZ9lfGs7KGZsHmaUCCGvMBDF9TW8VxeBmFPgBr/oR6285wEWSbLnbs26ULmCMhCbG
 vkiAf0SmatY/0D2FNOJgxNJeVe2S2hf0R8a72vq2C/8JkZP76h0keEso2D/oEwP69ClHDPW5YHm
 DWlIo3N0kfPK42eOtYSNSEa4U4PwYPVbmTDrxWhgy14ocT5xcPHniKzn5quqsH6HdSiLCD3FsnO
 ISa/N14rq524N1lEZGMJhOI3dblN4JbIQUqzwnmC8pAOJdo+MW9bnl7VMarMwXQbQOMqLdSOSWz
 0AyObpzi9JEENGr5W0A==
X-Proofpoint-GUID: ZRHVWO36tBn1JrqzMtS1qd7CbQpst53V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607310038

On 7/27/2026 12:56 PM, Linghui Wu wrote:
> On WCN3990/SNOC the MSA region is mapped with devm_memremap(MEMREMAP_WT).
> On arm64 such a mapping is not Normal-cacheable, so unaligned accesses to
> it are not permitted. ath10k_msa_dump_memory() copies the region with a
> plain memcpy(), whose optimized __pi_memcpy_generic implementation issues
> wide/unaligned loads. This triggers an alignment fault (FSC=0x21) Oops in
> ath10k_snoc_fw_crashed_dump() while collecting the devcoredump:
> 
>    Unable to handle kernel paging request ... FSC=0x21: alignment fault
>    pc : __pi_memcpy_generic
>    lr : ath10k_snoc_fw_crashed_dump [ath10k_snoc]
> 
> The Oops both leaves the firmware RAM dump buffer zeroed (no dump is
> captured) and crashes the kernel, which in turn breaks modem SSR
> recovery.
> 
> Use memcpy_fromio(), which only performs accesses that are valid for such
> a device-memory mapping. The generic memcpy_fromio() implementation aligns
> the source before issuing word-sized reads and stores the destination with
> put_unaligned(), so it is also safe for the coherent DMA allocation used on
> the non-reserved-memory path. ath11k and ath12k use the same pattern
> when copying target memory into crash dumps, so call it unconditionally
> here too.
> The MEMREMAP_WT pointer is a plain void *, so an explicit __iomem cast is
> needed; use __force to keep sparse happy.
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.3.7.c5-00107-QCAHLSWMTPL-1
> 
> Fixes: 3f14b73c3843 ("ath10k: Enable MSA region dump support for WCN3990")
> Signed-off-by: Linghui Wu <linghui.wu@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
