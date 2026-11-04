Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814783;
	b=vXIWRJmtDQ0nABrhxibdHInde0XezyhCcdc6wGDIdXVqfPveIo2nBzd85GwjVdFqLtQh
	 A2zSTcywUxBB6ToCgLlTdwtyI+gs3KyvCqSjrkKC82M5DJH1WdAHNmB492EemQLzG4m0C
	 DM+w+XpQOjDc+Sya25fadn+RQ25Z0FnRtItwmPS4ziMfgsM9P9tR+XMsU544JB2Ix+SUu
	 5Y1k717oSN27W5+Okaw+GzvPlhOkfNA8ZiMMOH/92lL+rmqgNfEO50aoHCFnmWspNJubB
	 /Vi2hahCwXQXy3mn2pi7vS2kVUYvO3DaiV3Itt4aghq8lijEwqhOnOhj6T59i4kGz9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814783;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=UlkDDkfTbz08Cti70LM+lRTYxUR46151wY6yh2rnh0o=;
	b=xZCE27+cNdqX4baF5jc7z28UsuuUFXUz5JJ8fthp+HhNOeWxRC8u5t2lM4MjMu7sA+73
	 Z7BCdZkU/2jFcZfXSLD+bhUr4LfY9/iiWLt5b9atjhl7S159tQM0btVX6TKvF99tZKrYN
	 HfN7Li/2w/bydQQBjvIYMNegtQeNFB13jeYCgMGJO6atSWGwgu1+4Po3A3lk8Ei3T72pT
	 E5ebRA5C6/RIH2rLEdSPfroG2uzSFEBznaLsaQKdiZLL5YjdU1XIFEdFZ9o9gfvqQXdUu
	 iJhfVx/G8IirQtVkBNZuKZe5OB2IbGilod3mz8MN/L04s+pF26+YP7CvhjTGMTXSWig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=M9IiBFKI;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KX89ZNQ3;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F32F606A7EE
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 17:53:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F32F606A7EE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=M9IiBFKI;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KX89ZNQ3
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A4FjD4w1899693
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 17:53:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UlkDDkfTbz08Cti70LM+lRTYxUR46151wY6yh2rnh0o=; b=M9IiBFKIN/aoZSti
	pUANlYWjEAs7DFWBmGf9DWmdUCLVoh5vHuTXUyzTvdcsrPp+WytdeZgVbL3gJjo8
	q44ig5uLIt2f6bk5Bt6b3X3Ws0ux8B3LON35bN2N9r8lG5nRokUdWmMzuk88fR31
	vVzSSBCoQqX5H09GKAQPt6fLSzyV3DIhm2xw3zaugz6ejjNU8hDDGzqxGdCsIF+J
	7RKrEU1B2cyqiILJN6NOrIFTdp8rFvXVet4/RHplpvEgTB2hMZMuIbdoyjC0yEGr
	3aN2QmssomiGyF4ChHK/50xJ4pu/YNSLe3hKLiAuTBfnI26Hoz1i5p+DeVbJsWVd
	jWiaYw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqvsgbe48-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 17:53:01 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36a1e2485fdso1733721eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 09:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793814781; x=1794419581; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UlkDDkfTbz08Cti70LM+lRTYxUR46151wY6yh2rnh0o=;
        b=KX89ZNQ3IR3kHf77SGV1HJZVjGFsC1oCHXRkhCgYKI2ybo/ZsFDHtAfKp1rM2lNCKp
         Do1n2s4pAykYXeiK4ve8quo6Tyatgv5dnLHKVukW16mOf1gWqMFy8oNzfOz9/haCyvJt
         bfZ+tS6MkHhfNip1Uis46+h9QUqP/AZ84KJtAf1IcP3P2qQuIN6SNoEUezXHRB+d0wL8
         fNywAekwlp6evKv3CzOjnc8dkNn2nxUPpb7Ur5OXPlZw6TKxmjGa1+DJ61OWl+uIqNKN
         hEiRSPOt5tTQC/09glkD8Ug8fmBj+5rlyb8MepoxLcQ6YENI92X31oRG2UgTP+8NCWy+
         WXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793814781; x=1794419581;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UlkDDkfTbz08Cti70LM+lRTYxUR46151wY6yh2rnh0o=;
        b=MuyNJ9zwvGfQeSCdqhBzNfuy9mC2hiPwT/yDpxlqeK/AQJmKinRINeNcAJIhJiai3z
         gwuBnz1pjUaeodB2koj6rlvjAmrvXdST5iSD7xMvb7sOL0Dy3pFn9/lhJPQa3yWOJdy4
         KUlcIOEhp0apNTHZ3h6LDL9URXV1Bo9lsrYbdClMBW/UbE2tbGs00AhCKGSLww91MilE
         opk/c+b8s0Gh5zzZei8pxUUsIgxGeDQzgVrKCPcKNjEd09SnVEbpQ8r9kwE3/qA79T9G
         s7b6MBeS4IfflwlZJWaUQXa9mZ5ru4q4LLLIhCtJ72hPW1oIqWoMWHMONCneWky/Cdw0
         XWhw==
X-Gm-Message-State: APuU4Z+JwZvIzi5yxTxKw8lweOJqfTRMXDqKqK2/2JTqT9/zIdczpK17
	zK1HRoBGBfKoqBCvK/sXWyzindiE1rJQY8EjasBxNtvP55MPTm2i2cvJhGDQXCdigFrTnZzzdpF
	BsRwY9xwZVD2s71ffjVQ5DaEUCHm3PyMfjlUJ3JnVz6l/9YWsCDED7arS84xhXmWYIOfQoQ==
X-Gm-Gg: AYBFou3WtKc0eVtHZ1LdGpwz0w34Hf+Ct0LQiSQsUTO0oZ/LbdmLUVObAhkymxPY9Uz
	wVwPpA7intHsjZbLRjnKmReVzu+mDTRqMv2Fv/Z+JL5IA0fgPb3D8qX6X2up6iu2eeILooQx/ly
	95NX38Nz/BZEh0yM1esNeZDffNIHvkL4Y3xO4PzY+eUMxZpqq2yPPSMmbNxY49Pmcn2OaNwCk9r
	PH9yse9fCcWjB69oR4n6siyjjR3CzGKUSIG0+F6YX82z+Xttok3ko0K5ezH5pnA7S86/mBioKXt
	0rej+uYoheIO1Dr+qeKIepXCrBeH7DsWTOvfYiWU1gNQm8ftnd/EzEQy4AEfvbeZrLn9Dz4AIFG
	qjEh4qzzkREzyjWdf2Tg9Dj4FFFnvpJZMrozkjaZOmVV6Y4/lQaLULJF94y2jArVVVYPDWsGtyG
	YC5TRIRxnro6BsZXCch6jwdhVBXdFfG1s=
X-Received: by 2002:a05:693c:8951:20b0:36d:f46a:87b8 with SMTP id 5a478bee46e88-36df46a8ed9mr73479eec.37.1793814780624;
        Wed, 04 Nov 2026 09:53:00 -0800 (PST)
X-Received: by 2002:a05:693c:8951:20b0:36d:f46a:87b8 with SMTP id 5a478bee46e88-36df46a8ed9mr73434eec.37.1793814779881;
        Wed, 04 Nov 2026 09:52:59 -0800 (PST)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38d36besm14147740eec.11.2026.11.04.09.52.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 09:52:59 -0800 (PST)
Message-ID: <d00469f1-886b-48d6-9b15-341d8abadce8@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 09:52:58 -0800
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
Subject: Re: [PATCH ath-next v2 2/2] wifi: ath12k: refactor m3 and aux_uc
 firmware memory handling
To: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
 <20261104-m3_and_aux_ucode-v2-2-b6c335c14dfe@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261104-m3_and_aux_ucode-v2-2-b6c335c14dfe@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=GtnXaU1C c=1 sm=1 tr=0 ts=6aeb70fd cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=YWIT4pjlzJolhlQAvkYA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: ITVtwyEuMvYW_WPrgFRod5z--pG0YQJe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDA3MSBTYWx0ZWRfXx/c4OQlhA3Xr
 J3wRfHGkFRe82jPBSlMbHEl9Mf4A7LOMggNjylF9cr+HdaFrFZlndGP6yjlh0vXFpekaWDrjZus
 w3HStpDTL26SLlTsgY0IPeQ98k1BjPpyup0o87fcC9DLf81uUD/srxfFr2GiEjGVmwfhdmK8jNF
 8YsZkXnnSV96Rpn6DG0QBBvPJF3ISLmtIs2RGMMfK46ggFzPut7azZMINbR0w3a/nwF4nsiDHBd
 w82BGKPj9aYNTeUt0mGutYUOPDTO07fdbxvsj3Ai9HuLYFlfIgW1oFdouljyKc3apSIjv7tGVB+
 hIRuCnLbMSfJl16lcasfH8Ly4nQXtyBJ7zHoFp8+idpaeoXqkS6dX5SLb91E5ABPYESLibgSxLe
 grV3nrAA66hOqfJ+K5s9NOowx/mUFO+zPnk6ugq0hOhOSvdg/Nm86VTy4yiK7UhOnpF9+NAmlBG
 O50TDs9OOlU5k6UNcZg==
X-Proofpoint-GUID: ITVtwyEuMvYW_WPrgFRod5z--pG0YQJe
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDA3MSBTYWx0ZWRfX1ZA4fFrCE0Cv
 ZgZSNlVaws8eOjS1Zuujt4Dk4y5IvIPKjg64VfPSJf5cYXLN257gvv6xU/pENZoYdmU+Nvs5pWb
 GlV/d5Lz3MylZuYfMvuEJiBXejRGQy4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 spamscore=0 bulkscore=0 clxscore=1015 phishscore=0 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040071

On 11/3/2026 10:30 PM, Madhavan Ganesan wrote:
> -	m3_mem->vaddr = dma_alloc_coherent(ab->dev,
> -					   m3_len, &m3_mem->paddr,
> -					   GFP_KERNEL);
> -	if (!m3_mem->vaddr) {
> -		ath12k_err(ab, "failed to allocate memory for M3 with size %zu\n",
> -			   m3_len);
> +	mem_region->vaddr = dma_alloc_coherent(ab->dev, len, &mem_region->paddr,
> +					       GFP_KERNEL);
> +	if (!mem_region->vaddr) {
> +		ath12k_err(ab, "failed to allocate memory for %s with size %zu\n",
> +			   filename, len);

I've dropped this logging in my pending branch:
1) checkpatch complains about it since the failure is already logged by
   dma_alloc_coherent()
2) the pre-existing M3 logging doesn't trigger the checkpatch warning only
   because checkpatch has a 3-line lookback for this issue, and in the
   existing code there are four lines between the assignment and the 'if'
   statement that checks the result. had the original code only used 2 lines
   for the dma_alloc_coherent() instead of 3, it would have been flagged as
   well.
3) in the case where the memory is embedded in board-2.bin:
       if (embedded_data && embedded_len > 0)
   the filename is not applicable so the message is actually misleading

https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/commit/?h=pending&id=f4d0341946db1dcd3c36296d7577f2444cd7d412
