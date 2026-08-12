Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2F243C7C5
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 13:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786543069; cv=none; b=t/gdm5omVR/XWJS+UuW6HPJvdaEDlM4umiopySy7BYvOgQ1dh1o/Linf6JMY5QoXce7Eq5un4IdheppI78wTKLUC2a5sCtq1WkxHitRdqUvO8bdjS0l3VQnGtH9goj+YhycnQXKQt7zuQ+iJ0pkI1fsOgia0kpfdDNxzIbOqz1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786543069; c=relaxed/simple;
	bh=OAIDiSDyDhw2isijVu2V4lU0QzwBxBd9eJWRtaCaqcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u/ccDW/XSYRiRlba5W84/cNYz3G+vpREFOYqTDDCrRQGqhl2rVg20p5ABTAmjSJ43qSc6YsGjE9lL6gtUBIKL7fve4x+0cRWagjdioJN6UxliW0EdOqobr+p7l9gTLmVb60SYuRNMCaMJNvBe4ylfnZQjX4tfNdC9+JEg4URcCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QWuVHkjE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hRIQLAth; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QWuVHkjE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hRIQLAth"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67CDbYv63597622
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 13:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QA7KzlY9x7gvQ1g1k6P+VytRGMpS/xj6mic75F2DUHA=; b=QWuVHkjEmSDpSYfY
	ffL72E9Y3oaOSHYhk2H3bkSIphzq+wkbUbBNLn1BFL1UpmuT3v5mZZfq512jsYDP
	gZjPBO6b9ExU+iJQWKqOofkRq+cg5MEdNer+oAMuFwsBQvIWt2jYdSrodMUo9r1f
	tH6gNkR4QWLBECtF9cIB0XNyUXiEEa4CKYLfS5JXIqjkTCQ711S1+2yPBifCvYuE
	LR2wImPI+LpOBERLRV/P8iCDbXwQjbtYVQmUDz52eaoNNKCX49DfwixXl08h4Ugx
	IW3AS9h8CDPZR3NHlsmrDgT4fAbswtqMhOeL6w8fgPvogmQWEF853ZyZSpQ+ubgU
	R8GI2A==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g08jrm5jh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 13:57:46 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e9ee20bde0so623806a34.2
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 06:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786543066; x=1787147866; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QA7KzlY9x7gvQ1g1k6P+VytRGMpS/xj6mic75F2DUHA=;
        b=hRIQLAth/xlLmxtO7J5MCq0Ss8wYli7c3rEeWh8CTTX4b0oAGcLY7/HYhf3sRJrt4Q
         CHd8sOxEFfdRyZjRPPFrA3dcnVjndhRQUYr9N8rn2+M7qYI5XXJ3mj8Q4pWYWpmuOZG1
         Dg01lkm5u7UDg/Wc6mLwtZ/Yciqjn5R0dIX/GrtndjAri4nKiSNe3OgKiDI16y8DVfpz
         eqNE7bLjGVH4HEjLVwiHo+CNEyi0X5kMi1CQ1ZgcVd2Zhv6/oikkJ4VfHYCF4FKKFTeO
         Q2lC+9H/6BsCXtYya7c6wRxUD50IRvs3m7wUisrnKYMkw0JeR/FX4W4xeGrGoJSaYAq3
         CEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786543066; x=1787147866;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QA7KzlY9x7gvQ1g1k6P+VytRGMpS/xj6mic75F2DUHA=;
        b=UnaUYO1q7TfuXowEQef1H4s8khfnVgV8T1cgO4VddqZY2lLvtgKbimD+JaQjoT3PUL
         i7lvpPsyhyAykpCYDpl0Vl54giehxk+HlL/kXDaeAOOrTMnfAxfceZXwjjiMMRGVWejN
         w3d8XR6ZuVVl2J8CuEHzACN5dpKVhIqYODSaGrWl5VHWaQv/9WvpmqafjXLZfqceG1cq
         pxjdEwoZiW0d60jV75r2WlleH4v2Ho+s6hAKdUrQPk5GyMgMpAEPrB2USmoJSk841blM
         eDdTNaPLda7Anj76FKF2cJ5iLWCFxBOtLW9RSOrm+hC8mquCCLqBa8w6Z9AcQDh3FAyo
         z/0g==
X-Gm-Message-State: AOJu0Yzpw1slrGr7jpVtHsahl+SrOZ9wxYKx6Nt2kHuzrNLQrUPgBm+q
	2EajEVzJTqVSzwNOz9TuSIIUTjLD5xSAMgF1k/w8tZTgn+wRT0XGyIWQkKR3w8zMGw2cQQleEJ5
	Uv8aooBIj9P4OOxSCeF7+00iYQEKQ+pZlXtrGqzedeX/oSe4AQrrwQGMzrThWO83MK8UlSg==
X-Gm-Gg: AR+sD10psyIv/xjvT/US0rWlFvLW0Ykm3/CW4Gr58kaZuWYVa7v6NLHvUveakcmRGXe
	3CGKV3ngB1qG6r8RXzREoMp8vUIkTmRpOl0+luUJ6HfpE7iDvHyCep0ZwAO1RtpBWC0+QF3/lgo
	hsB3lCj637wly/JjluUe5V6pmRgErY22BQLNYzHvfw6slQurpLahSjTXusDHx7ay5CaJatqJOif
	sPcgRB3Wclcql3eMN7bi+0LVxeecOzSpEg7ELzaC7JuMd8//fsOxd0XlMJGpGOqRXVnsvs0QLUb
	BbRwiaeKGcdKUHqR8CIGVkKiorbjyZUehC5Xm1LQM3ndbeqtUbbcQ607o9AHecGBZYzkKy/E3aD
	WuZuBtvaG/UjTBtl7zaACQ4F1q5FKT0iiPAvqA4BzLGu+x8Owbud1prRzbPB6
X-Received: by 2002:a05:6830:7103:b0:7e7:8dc0:3951 with SMTP id 46e09a7af769-7f3b77281e8mr5210723a34.8.1786543066274;
        Wed, 12 Aug 2026 06:57:46 -0700 (PDT)
X-Received: by 2002:a05:6830:7103:b0:7e7:8dc0:3951 with SMTP id 46e09a7af769-7f3b77281e8mr5210677a34.8.1786543065920;
        Wed, 12 Aug 2026 06:57:45 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f3b33cd109sm2886716a34.18.2026.08.12.06.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 06:57:45 -0700 (PDT)
Message-ID: <4bd5214b-d2fc-4849-93eb-a088cb8849e2@oss.qualcomm.com>
Date: Wed, 12 Aug 2026 06:57:43 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: add support to load shared
 firmware on multiPD
To: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com
References: <20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com>
 <c66e03b5-4f49-45e6-ad18-96bb8370cead@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <c66e03b5-4f49-45e6-ad18-96bb8370cead@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: s--DNn4j5PGF-6K4Ci_Bt95f89V5eI3P
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEyMDExNCBTYWx0ZWRfX8/jPHzlvMDFY
 MZSoHy8C7e4mnD2SR/MWg6ZNrsPMAIfVRG6VHzHGnfPdxbfTtW7gBPiIpRNpL2ccdI3T9hFhbpM
 QEKrO0UkzholP2yd30NIv7uqlqCiTv8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDExNCBTYWx0ZWRfXxyPGqTNfGooX
 74SI5PEv0shLyzYXbMlegFweg3s6qoqqh4lYaLQTQTdT6cXj77PmdvLbnzBrYJzahtTdl0ypFYY
 Mg9ovzV2YLP4Ik5F2l54uJnEPgHi8ov63yaPdpD0XsQ1F8UZ7i0jQxYopSbHUi7EouDDy3eC94T
 ePL0SvFqGphui0PyPxtEabN7VJMf5cTUeX2uG75EkZruajsL3EW4OMvgEzHmUTIVcgfdz6T+fN+
 j9X5PDhRnHPNuAXkaycnczL+/QpO0W3IfcZNgmTVZYJ7jSzqlN7zhzUyBx9lg1nhLedtb9/Q0g/
 9GwU1eWfTup7e4HjZhvl/h7h9TWyPIyPkf3lUcOqt8jANBE16LXY46DHt3oiTzqzjP2t2sScOWv
 l/J5rumwhAg3Og9Mir/JSFk9ZuYM1lYCnYyHMsojiGRUCFWFx3rXwWzwkAr/PKh7x8cec+fLQWI
 oi7EM6xgJzXoEV4ULJg==
X-Authority-Analysis: v=2.4 cv=Z7Dc2nRA c=1 sm=1 tr=0 ts=6a7c7bdb cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=W8Ni8Xc4stYUzYjHn6wA:9 a=QEXdDO2ut3YA:10 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-ORIG-GUID: s--DNn4j5PGF-6K4Ci_Bt95f89V5eI3P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-12_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608120114

On 8/11/2026 2:08 AM, Vasanthakumar Thiagarajan wrote:
> On 8/11/2026 11:13 AM, Aaradhana Sahu wrote:
>> +static int ath12k_ahb_load_auth_shared_fw(struct ath12k_base *ab,
>> +					  struct ath12k_ahb_rproc_info *rproc_info,
>> +					  const char *fw_name, u32 pasid)
>> +{
>> +	int ret;
>> +
> 
> nit: move this empty line below after the declaration part.
> 
>> +	const struct firmware *fw __free(firmware) = NULL;

Note the when using __free() the declaration should be contiguous with the
assignment, so the current format is correct. That is one exception to the
rule about having declarations separate from code.

/jeff
