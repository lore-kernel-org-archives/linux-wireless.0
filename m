Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB55440627B
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 09:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785923506; cv=none; b=q8A+phizljy1aQZq6JvNlO9LZv0kIdr0iaTnLeII+8+/IKNBuNO3rTpLEWaSv+swZUfW4RJt2iLWPoKMqqxUCppiG0vvMl10no+La84o02lzWjSin9mbDkQegqsP5+5uaEmT8vQX0fmg8RPnOudcPadYpXovwRcv7nEeinVPeDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785923506; c=relaxed/simple;
	bh=QFM7AMKU4RXwGP9obr9bM9LikH8JUn/fNm7E3dfSGRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XihOB3p5Ovs/y8PGhKUrDHULSoAZZ1vPDv5EdRnmjQ+uQkqjbR24Wx5CD/x1d1O8SgEbuh6uNl3ojH+6h0fwJd214qJMvUWeZbBdRlcZ6whkz8fpcoaCtk6Nm5zi2sJL+3pLVrUQYKQGokZz0kyywZLNbXTC5OD4WruYuTYqz3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=meZ1yApO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=j7PAkvhR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="meZ1yApO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="j7PAkvhR"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6758dPAv2663308
	for <linux-wireless@vger.kernel.org>; Wed, 5 Aug 2026 09:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1IU+TsuZ564fFaBd33xIc9jlaZuK+lX3HGJbEgaHb8g=; b=meZ1yApO36DwW3G5
	W2RlIfPaGWXXsr4/9NKjL8wrNqrfq9z2iBHeeWFAiN7OGo9zFg45utFeNQ1LWqxH
	j5474T9+wznaWwdvwrmiAuBUmwgv8lhoqIesbIYS3m0ETKWcu8CGQyVwjAtHFF3j
	mJwJ7ed1XCMqa/cJISRWGHUsQYhgrktqgqcZc8/Es2RYT+cj9sRAGMOnPDCyz70w
	ATWfBb5T8OAtU5LN/8J7dDSRNaaGz1sn6QIE8jzJOEq/nsNuds5FoOf6/+OcxNLq
	S6cGpQuFazHVYyiKvmMb+H1osRPA2WEg6tmHeGH09Wt++dBva5kBujlCXGehrYLv
	8RymtQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fv14w8k3a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 09:51:43 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cc5faecf01so15941525ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 02:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785923502; x=1786528302; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1IU+TsuZ564fFaBd33xIc9jlaZuK+lX3HGJbEgaHb8g=;
        b=j7PAkvhRJpIq3mX0ZPacQSu5pOjlNymmBVRW1A+R5qm8dm0fFjHBNyo/qUpf7GNMSF
         Y3IuTjT75BoluCIN3c60dZDbFlJ0f9y7Pllv9CdbxOmRibtiyXzzsR4SNrujZvSmd8xZ
         bLiwjGQl5Og0/JtkLQkbhUFgbfXmUCpTNqEoehRcGt9peu1WOFZR+MstuBEgdYjrHYrT
         OjxK6Cfwf19pmgrH7k1rPuu3bgssTJKRWO7C0GSIb3yrGA1zq9DTS1ft9gx3DRBhJ5gv
         aWs4tupMVXdkDZsN27fF0b/Yh1n3hTyOYBVRicIu6z3a9qLpOPu2C+NX4fke9kf+0m3p
         Uwhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785923502; x=1786528302;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1IU+TsuZ564fFaBd33xIc9jlaZuK+lX3HGJbEgaHb8g=;
        b=LT3Nn7D13S3v/CvJNeV571J4m6ZtsF24dXM/A5IQymlw29u+TLD6KWCB3/1z0dZPzk
         meLCZ1aYlU5/kXJ555/yyVEosQpzSQSsO7SIIMCNjek7uuXgPNaoLJb4/lw3QY8bFnY7
         MIvSjuToa5vf5S65rRq2L77evIiBJBViTzTlUQkE0Oq64kRDlzxOnTLyvFAlOuoPfgOX
         RewkLfywW8zYINF7dGIUc7ytva1OmAMxexC3DsECPyxzrtiIkoWvsVLphPe/6P8uDmWS
         wVtCMxCqq3+mHuPMjCcJqNyxiMRkOj7p5qtXhhcfLqmuktMfl8ruxJbCq6Hvhyh6i960
         MDNA==
X-Forwarded-Encrypted: i=1; AHgh+Rr/LFaBICxO4hF2QDCwR+DCLwgSTZnAiyEDoZtmN9ZQc5HUSZ7xdK9GerfgqZqoLnQlqDmb1ANAsYogmJSOVQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzPaGuBCiAB9gdkUtHLkpFTqY0rQtWABmEQ5NkSFSK1WqCcFPB+
	sd+dR/FAvZ5dNf9r8J2sOmSrskjywUHFHtrdHVmYg5X9pfo5zsqWeq+a7knQCu/R3d5zlwlLUxo
	ljpU0SsEepUpCI7Sxvg/43GUc3ahB9K2sTbfg6nGqP54payPZf3Dw6RXKltuwuJLY2xZsvw==
X-Gm-Gg: AR+sD10Nwnr/bhFjP9zvajqj+IAV23pPBTmIXmi92YgMWX6ynZaKNy6J5R462WKIJM7
	gKX5Dbguy++BQPp+0zqdr0sO9cvmxj8NSUQKIcbXN1qnhw0lvdcrKBctCjp6OYpoHxJjkvsnnGn
	bErsKaa7dlu3b2DnPGETp4BXFRAFgqywDxo0C1AyrwhGzUstiYCto1NwehAaSh4d+ImOBr60mus
	b9ccgRfdH82vyzBaeIfEcgAoCmEKYdJmUzIUL1E2EMHg0NQE6tHdMwlLMwjY5JFEZPihVSmi/BV
	WP04HZb6H/ntZIbOIRbw5bB0GWbzMYzzIA8q/GcBHcKXi8+Bxy+qU2xFGy3ZsP9nc2wknWQ973C
	gji1hfoAeYSWAee/dwN1wkcLDH7UAecZRgaPZfUIM
X-Received: by 2002:a17:903:4688:b0:2cc:f5aa:9513 with SMTP id d9443c01a7336-2d0ca7fbc9amr66562515ad.10.1785923502440;
        Wed, 05 Aug 2026 02:51:42 -0700 (PDT)
X-Received: by 2002:a17:903:4688:b0:2cc:f5aa:9513 with SMTP id d9443c01a7336-2d0ca7fbc9amr66561995ad.10.1785923502033;
        Wed, 05 Aug 2026 02:51:42 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867d7e4csm14825638eec.31.2026.08.05.02.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 02:51:41 -0700 (PDT)
Message-ID: <63a41170-b20b-4a9a-8d60-12d2226e2f76@oss.qualcomm.com>
Date: Wed, 5 Aug 2026 15:21:35 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath11k: Fix possible memory leak in
 ath11k_dp_srng_setup()
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>, jjohnson@kernel.org
Cc: nathan@kernel.org, ndesaulniers@google.com, morbo@google.com,
        justinstitt@google.com, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, baochen.qiang@oss.qualcomm.com,
        stable@vger.kernel.org
References: <20260801114911.91483-1-nihaal@cse.iitm.ac.in>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260801114911.91483-1-nihaal@cse.iitm.ac.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA3OCBTYWx0ZWRfX9lk7IdqRL0mu
 H5UH/SzinX0LPQxw4D5Q8WGEe4UT1R6B2FmKZ++p+Jxv3GCECdXQqZ1IyNvp/6J6HUgafNmcfOE
 ewOO1GtqIZ0WlHQiOMcgmAWimJrAxPQ=
X-Proofpoint-ORIG-GUID: q3tqnD-ajcaWA4d99epsThIMpq1vXG5A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA3OCBTYWx0ZWRfXzi4/m7S7jwW5
 X8LlY2R8daR0CBEEygmF/HkLwJgqSLFgPjJ+IosWvIV+gOaTliV18rVkqaPFAxjUZYcdUV2hgTb
 3EyG55whvj721tVUQy6zjMD2mOF/UDdJwKjOX3j8tQm2BlSgvW/zNf6gLWHkC7CldQ91J3fI1L2
 jlgq8bKF9PFao1oFEH9SUFMOyIDDjJekPTEE7L9wtssk6CwK15TVYYBql9gYPxoLBUMLGFF9v8t
 +UJ1bLMrHDceb4MG/YLXkBLtIDlN0sBq2wGFnqWyinmnfaFm7wqRT0gVMfELhest1kMtB/tS5h6
 79Xgu6RcMJr0ffkJAJXSdvzNy4DFZCMiGqKNShIj2NNJdt0JV6v1ETXeWZR4u3vUF2h3ao4psCt
 c/msLeKcCX+jltTppLm5qqtHlfjq16WDHJ5xUuDvoY8OKr6pI1IZkSfyF4xyE6P7gMrVNN/pw2u
 VP4Fzu/GCvTr5xgVemw==
X-Proofpoint-GUID: q3tqnD-ajcaWA4d99epsThIMpq1vXG5A
X-Authority-Analysis: v=2.4 cv=Cu+PtH4D c=1 sm=1 tr=0 ts=6a7307af cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=i0Dr3GctjLOm-fFF1aoA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_03,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 malwarescore=0 spamscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050078

On 8/1/2026 5:19 PM, Abdun Nihaal wrote:
> In ath11k_dp_srng_setup(), the memory allocated for
> ring->vaddr_unaligned is not freed in the error paths that follow.
> Fix that by calling ath11k_dp_srng_cleanup() in those error paths.
> 
> Compile tested only. Issue found using a prototype static analysis tool
> built on the LLVM compiler infrastructure.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-sonnet-4-6
> Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
