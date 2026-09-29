Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C8C3D3008
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790696390; cv=none; b=oW3cIoadIqNV6uJz/JyxKuHPT47kXEwI86EdZ+XtfCgUFPCEoAOY7eClJGdcD/ikpFHyLHq8Qvo7W7IzguJfxaDhJJONMDUNrGV4r6BfpXa1ea9vNdOdDNHpMOstc78CuOh9zXvNtoo1iXua7pPii7+1SZ6GhJuBrthzHYD0kJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790696390; c=relaxed/simple;
	bh=Ml2kJx7q1qfRKUL7DSbtCoU3DFFGVtivW2tz0z0GlIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GAz5GM/h7g9THQMCNs0e/gz2CBwP19NtvJcOt3m4XxfDjcXkxEImqGYZDlzj1Me1KT4snJ7+HX5iDT+6U7hX7M6P/yWEJAhr9Ct0KkFZxTBjUVFVm1FT9I8+4/KhfMJRH6imgGsp/P5Ba0bFOyW8L9uNeotDoqfSHdLWEzOpvSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oMSKxddr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jH4gyXKR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oMSKxddr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jH4gyXKR"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TFUSKe708269
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 15:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oo0o+sVrULwBqvXSrWGzBfAfBKla/hjOjEt5/j+BmaU=; b=oMSKxddrqHOCHTQ3
	O6/X9ZCcpt4qwGDTbrcuMfFId7FrgAhCz3G2U/MBmnB6kyyYvcPSXYE33egWygpb
	q/UAkR/onCJwuCi81275MSvHTvb3MeopPRalekgM0WRriypBFmMIGIVBenxzLPNF
	Ba8goQ+flVqu9iZtI3DuV4+NTyxfTtZj49w9riMEvskZkDYHArS6LxqF+3oBdWrb
	+Yk6FRaPq9C1UgR1AOcuBuQGY77ypF3rtxbwA0XkR5kcY/u3qcZG7XoVi1+Ax64X
	ugOmAwy/0KHNK7HmrQAYJYsNC3pgk//szoHFWkdBIC1pgNYQu1IrC//+59y/Z3CB
	0w4fvQ==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h0g1kr1fv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 15:39:47 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-349ffa249bdso3412413eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 08:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790696387; x=1791301187; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oo0o+sVrULwBqvXSrWGzBfAfBKla/hjOjEt5/j+BmaU=;
        b=jH4gyXKR/KwhaLvZeC0b4MhvBz8RaiEJDE+G2EzVwnVSmNThwV6McRQNho4dkfWbV2
         ljnbDvhjC6HcuoizyJUOP0EqKaOpcYedwxP8qqhrPKBv9juNFwWII6vclyKkmwkxl6HG
         fKYUuclYperJHTqrWCrlFB1cJ8hW7RR5ebNKNqe0dLfGSgsEpYMlsTUYw8+CQUbTjzLS
         Ka1AqIqaeITDURMftXQ0lq0P5XcOepAYcF/3Q9LL+k2X2xzOCnf2iAvXpgeGc7N+gYOp
         mc5TimVikaMNbPSEWOShIhYM5umy7fw2nCuiC6A29lle6xQKW8s4PNE6Zjx0HYFO5Eb1
         0g8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790696387; x=1791301187;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oo0o+sVrULwBqvXSrWGzBfAfBKla/hjOjEt5/j+BmaU=;
        b=y7l7zTsC22UDZ/6Mz3mou3qKsuwJcKv56ir+MFUAeWYB2qdTn4lHC/TvZKlXmpyHwZ
         CVjS6otWHSRItz/xrapJwEsMDNGopJCKst0WDUisS9jeZd7/8LDkfHRiJN43YvHEY7LF
         IwkKDLnrpDDQZ28jGKsbjp2lf6FeRNaz8oIeeN1wZRxirHp2OHilvvRSTyeit0KST6UM
         ByncvgLS9t4sWLebo8+SOsPLX3ORap+aaloXAl+tjp0XhcTK5ElnQX+5UOto72JfEma+
         o51WTqrfpkrbHkoDVtZda9iJh+1O29vZRhfy6n4FCwCvKC9eLlZFboW8lYF/iePQ5QXd
         6Wow==
X-Forwarded-Encrypted: i=1; AKwUvBx+p8sJouwlLRnDnVj4D0PtAiru4V7y3AmoW4kqWjh10jnGMjaaCtNfzXS/c/1xifcmrz8890q+WgPAv5awYA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJaxXrAl/Ad7rQM9mKFKAgymjWE7ehkgkhdtZdJpQCp770C2Ret
	A6rpn7ixc7B+TczmhY3B1Xjl62Nl4zM2XygLqAQxAn4U/Uw7Vv1GG9Ra23rLlX200jQ401EsWzo
	NaSmdndOR23BGCKDooiLwMB2U4ojTj7l16NbKWkMrSYGo9tIHVck9io8/qvGnoNaStr2fGA==
X-Gm-Gg: AYBFou19Tpm9SgnwYuI3HLzgRx+A0prrQZPOUDemeShbeucUQRhaTsO9WcXiNTyIFvp
	G0t+XIrOH2HNpdqP7vRNDB9b1JDPe96/0k4Ay816HDKYVmQtLeN6YlC56jh5+AtsQrkvrQ+v2In
	amwEIOPbItkZjlM0MKOL+Y0Xj8ZPfgjr7RI85k1QTxZMYmO8oL5Ii+4RWuxhKRRApQS5X7ldLry
	emom10EmnPJW1AM2gabzHDIBIdjin3EF8AZl2cDmHyP0CTgi8Pwyx4+6DiM9YN+1mhU0ivkqz7o
	dfeMSWq2Z7nelESHBzo3iKaJCdebyiOOnYzyGG1fuNHChTkmkdP6pVVUOLGGXdScBYWunt5DuHG
	IZAIGNp44SrjbcWUQocRn9w7snN5shRqtUZ/mBb/TDUj7bi2zW+d4ga56O1L9
X-Received: by 2002:a05:693c:26c9:b0:33b:b0c8:73d2 with SMTP id 5a478bee46e88-3426fccb337mr12767169eec.3.1790696386600;
        Tue, 29 Sep 2026 08:39:46 -0700 (PDT)
X-Received: by 2002:a05:693c:26c9:b0:33b:b0c8:73d2 with SMTP id 5a478bee46e88-3426fccb337mr12767121eec.3.1790696385980;
        Tue, 29 Sep 2026 08:39:45 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34c350be57bsm449540eec.1.2026.09.29.08.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 08:39:45 -0700 (PDT)
Message-ID: <61215980-3b66-4e3b-8be9-f8f6de94cac5@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 08:39:44 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: pull-request: ath-current-20260929
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
References: <2b42b119-4271-4b9d-8a7d-1673c6ef62ee@oss.qualcomm.com>
 <126186f5f19d13dcb9ff0618faed010adf1afee4.camel@sipsolutions.net>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <126186f5f19d13dcb9ff0618faed010adf1afee4.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Bh0MfBW-dfDbSfww1O7s_Qtzj4NQ5ilj
X-Proofpoint-ORIG-GUID: Bh0MfBW-dfDbSfww1O7s_Qtzj4NQ5ilj
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA2MiBTYWx0ZWRfX4SUtJyFDQZaP
 KHHPJE/AHXshG0juSD9yyTSKArin4DGcg+J8QRh46S0nQq7ZzjCeeoQJqxFxxaD+d/Wi3TlQjbV
 cm9jxrPCB8ryVdQRGkPjLiBGgDrqJWE=
X-Authority-Analysis: v=2.4 cv=Ysia1IYX c=1 sm=1 tr=0 ts=6abbdbc3 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=NGaSfe1XjQSTNm8fpUcA:9 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA2MiBTYWx0ZWRfX41XYgMm+Dm62
 Jg81U7/5j4AlgUnoIh/FJbZqFmp5NB/QpPKm9+q+fFMyZDzMLshoNxiCjhdw1hAsfmEqwJXA/1B
 iLQHiHZEunsJ07SY/dtVmmZOtFRmxgp+3zplUAPWSw2fm0qaIvFbvU6S5OqKCu9drqRB3//8ZBa
 cS3aUZn8Lk6EeOzZqk8ib9mEdTzTi6h4xLXP7Q7fAyAcOQ6iXyOx5EKEFPXLu51ZXDmQV5HTxIs
 ea2ngh5BB9nCJ3uVjyh8hTO2BC2mRxOKbeI6i9YxIZlNDyHAjs4/7o8gkU8LNmT2CWwneTqUaDu
 B4kVBgBVlovZDzdPt6+h5xvxXmOt8jnj7C4OK42eu5HzR4fEQ3u5dEZVtfKbq7qhsvQEtoAH/Gs
 N7ee/A3jJ7BMoX6ACr1momSu9zV3z6mwYX1SgEiqtHKV9EGGt0m6NufdQIwrHvrthU/yTeNJN3D
 QNdrrrWUdD55drfw39w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609290062

On 9/29/2026 8:14 AM, Johannes Berg wrote:
> On Tue, 2026-09-29 at 07:58 -0700, Jeff Johnson wrote:
>>
>> Baochen Qiang (1):
>>       wifi: ath11k: fix unbalanced IRQ enable/disable during suspend/resume
>>
> Hmm, it's complaining that the fixes doesn't exist, and that does seem
> to be in wireless-next only? The patch/PR applies anyway, but does it
> then cause a problem if the fix lands before the bug?
> 
> johannes

let me revisit this

