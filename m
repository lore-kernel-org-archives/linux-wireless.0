Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529333A641F
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 06:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785306435; cv=none; b=koOLz7IHUUCWqyGqsN4FPP3jeNTrmW5KXcbTKl1Ra479+tjwnxGvcIIw2VOf3oobWvZSKzrJEjwUGe2nifQ9o6oU3t0lmmrV/hcUwwUI/NV8+991L2c279VWaxAWqO/uyE7b7v9XiBqal/VhUSGnYsM3UNW2/fexuaaX3zPI5v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785306435; c=relaxed/simple;
	bh=e0vlTGAQDrdmTjj57VMFO2Lk/7RFesnJt0OUhozhCwI=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=q4Xva5QQa2Po68JAugANA9vluJmcKCsyCJMJyjX2h/rWqZVIWOO2Z76qOUyhszR2jSUUzUXxORuWqa+sVkZ5jPHJ1KRYh5fvbNBOnpqj2K5UAATJ8BuAQdZHVSTxuPjZnGZtszevSImmu+RQ0L0zmVmz5KYqVAC1vH0nC5m2VZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ay9AY1LM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZwEf+9wa; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ay9AY1LM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZwEf+9wa"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T5irIl417157
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 06:27:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OTMHwqggIxKmBk/ZqIK+EKpy4F9qFVTkmu/t5ndrmo8=; b=Ay9AY1LM5rXsxWZH
	YIwyTUra5icda87Z3FSZkzkQ5g4xofJ4vttIodQsgtfG0UHLdXw8W1QxJiOKJWdT
	+dY+H/PySer7xzOIMsxTK14RRC0iS3WE3dPzenOVcxB6enTOcdADfLTZc+90ChjP
	HnbvmX++/eDVP15cZN0pxDA6m6jhYsW/Q7PXrhHn+5W/+ALKYre6ufcpvOeAfUKZ
	VOPU2De7kvMzwqKVJ+29kTzsmDm8TRGMGFycMksRZ1JfsnPGXWp5NMV8MR8tariK
	1ftWfDapuX4WTjx7nGjXJQCIYgHF7IDEIx9Hw4hN1diXM5YrttBxZtS3neDGAQjp
	OkV+Mw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqbn1r4qc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 06:27:13 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-caf5fa127d4so1021333a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 23:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785306433; x=1785911233; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:cc:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OTMHwqggIxKmBk/ZqIK+EKpy4F9qFVTkmu/t5ndrmo8=;
        b=ZwEf+9wasV8euI/+5YqfoQRfMvU59qmsLYLzPssC5a39oGhD9jaDt0XWnaQrDkH1JQ
         ZF9ecHiKPjUn4TDnq/K0x+SqU+dW+0WkFxLWhIplOkKM1ekN8WlIp7FeZotlD4aFx93s
         pvd8gg3t9WMeHjJc5UlTAZGDNmRs1lXCYg9rP44Z2OoF0taGlmCgcRK3urrrpwtE1aaj
         D/3ktHt81ZtVgUDeW5vsap7tXKo2OAiFwGxXBOb1FrCHHXSvhxveWlPYEsusIUZ5cewy
         eN5r/E0NRyg0+t1Etnsi5YyhFay2XRPBKzH5RJhlqLxPvJs74HzJ6CIsxsT/0CA0uWdF
         w0kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785306433; x=1785911233;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:cc:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OTMHwqggIxKmBk/ZqIK+EKpy4F9qFVTkmu/t5ndrmo8=;
        b=ci1iQBUz5aIfgGfjreJM6nWV/XCuNV/kREpkHbbBZaTEz0KqU3S4v1qHLUkRS1Y47A
         gArhKyFMpO1/RY2bB9/Z9CBKS7g9bDnsMDRUdyv1aHguUwjLeVgqfwIzdP6nT/xZ0AGW
         lOXvVxFfcvSoR3d7TO97uNtOUUnJ02KkyjPEA+Aa/UUVZa+x/OIV1jOOijbmtSwyRmTv
         3wHXir++6oM55yabu/t63U5KgqijTuUnahDv9AwkBpdGWYHY5nxfE+9CddKIn4oEX438
         LCfjVRUEs5LCA6XoWaGceYZZ2OYmWJBJacYX1olRVEbdqFbBkWL7B2kEg6VH4Lf5IAus
         SKrg==
X-Forwarded-Encrypted: i=1; AHgh+RrhcZwwtdn3C3txhJ9ZZW/wBiC8V9+P7fk8ME4Poo2qIgxpZIQb9LskpGWFXdVD99xODBrsyJPdRECDH3VZ0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1jfdhv+J+8J57UPANWEHudgJ3hU9S2l2QfaZG4cbTc/6rUPkF
	FPHVEXV2srpetZ5InaQDz+iM1FnwHydd4uQA3MR5ldhOWNVyjmgc1vHm9aS4qi4MNc74QZ8XfbD
	kJrJJi1A/FKxJzklPZ3G1BrpdRN+bUtOSRG72eBsx+vMr+mceajJh718xZx1uGgnWPaEUuQ==
X-Gm-Gg: AR+sD1288DXC8MQTTwrJa0qArHZ9x0/fwy7+89WIC6BwNUOC4LeePKO4Cp+HQ0NmGYg
	ID8B0u1EglPzJT/JW6th/WMZ+uRhd9/jjBsbWtCGFzIsWkVfnuhuDZLeMyiXxegpoFko0GfwSm8
	ervW9LasG/gN8qbxfyb6xaw1RLG3gFOFubIQl1wSE+pql87ChuB2qS8ChGViY3wiY/htlWyv4lg
	dV3wUQvrdL2wkhG67QnCVO3D4eVW8EdhD26rWnKJ02S9Nl2PTAhtTdf8BE/I6C/hpxknYlG8mBv
	Uh/YR2b0rvloH/b/8Wj70sCRQG6KYlsLMKZEyL6DtIqYsPNzVJLoQLRV/Fc2Q3+HeQu2Qh046MA
	92LeIeuLVjxczQvLnFuQ8IEV5tlp5YYxy+qlOFJE//I+B
X-Received: by 2002:a05:6a00:4c8d:b0:847:8250:2b2b with SMTP id d2e1a72fcca58-84e93348ac6mr5706365b3a.52.1785306432920;
        Tue, 28 Jul 2026 23:27:12 -0700 (PDT)
X-Received: by 2002:a05:6a00:4c8d:b0:847:8250:2b2b with SMTP id d2e1a72fcca58-84e93348ac6mr5706339b3a.52.1785306432537;
        Tue, 28 Jul 2026 23:27:12 -0700 (PDT)
Received: from [10.152.204.133] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe24e6csm852274b3a.5.2026.07.28.23.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 23:27:11 -0700 (PDT)
Message-ID: <907535d1-1d0a-4174-9513-11ef27002f36@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 11:57:08 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: karthikeyan.periyasamy@oss.qualcomm.com,
        Jeff Johnson <jjohnson@kernel.org>, ath11k@lists.infradead.org
Subject: Re: [RFC PATCH 2/3] wifi: ath11k: make external IRQ control
 idempotent
To: Mark Ruvald Pedersen <wabsie@gmail.com>, linux-wireless@vger.kernel.org
References: <20260719215817.2468580-1-wabsie@gmail.com>
 <20260719215817.2468580-3-wabsie@gmail.com>
Content-Language: en-US
From: Karthikeyan Periyasamy <karthikeyan.periyasamy@oss.qualcomm.com>
In-Reply-To: <20260719215817.2468580-3-wabsie@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA1MCBTYWx0ZWRfX8M5hdWDf7NHE
 cPzszYxm/ocjhKwbz5HoH9xUpEEDCXOg22j6/1G45FZP0YCmXhH3omisehpYEOohnfzop8/meFr
 TBPWdKMPzL0OUmSkWgoNXhmENXS8P/0=
X-Proofpoint-ORIG-GUID: WpgLCRoPr4iIrx-6Tc-csBU2mngVGMxb
X-Authority-Analysis: v=2.4 cv=csCrVV4i c=1 sm=1 tr=0 ts=6a699d41 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=g0inFw8NqRCQxjTZg7MA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA1MCBTYWx0ZWRfX2Gc47yZ9Tguk
 rCwC25NeV2ayC4k1x1U9AxJFYTEZtaUhmflPqx9AWkfAFUPbpxA7fvd8rkWMZkvNyf9ekbOUgHg
 hz3AccF0BrwF0Ng+ReDe7xDYKAhbQNJGcBe8fOwp0djLzutxpYqFnZOk4QLWlQ4lJIkCa+cgfPu
 DTS/4arK166eKdM6YEAw5i6MNb0nVYnhvCrSinaBZqqTaU6JDjyQyV+Zs3Pdx+pnSNJHuO6aYR/
 HrcNozAALbD1HVu1hew6YS0o/qodbWKj/497qvYhWIHfZQcZmBbDuMDQ8U1mx2W78Tnp7iF8aIg
 /ERWszFu9H69m0hcVl0MoD7TDjBWvOjU+r4egPzDGE9Rv6UN1J3jVkjI18YBGykNfjZ7iTguwMK
 AMWewNt4bwDceR4JhrChUWbEwgUj1q4w7b9WaEJmrAwPaXKNsWMLVIpsebgysQwZUCJjHCHn49B
 AzAntpgqK+VBlpFv8Dw==
X-Proofpoint-GUID: WpgLCRoPr4iIrx-6Tc-csBU2mngVGMxb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_02,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1011 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290050



On 7/20/2026 3:28 AM, Mark Ruvald Pedersen wrote:
> ath11k tracks each external IRQ group's NAPI lifecycle with napi_enabled,
> but calls the physical IRQ enable and disable helpers outside the state
> guards. Repeating a lifecycle disable therefore increments Linux's IRQ
> disable depth on AHB and multi-MSI PCI even when NAPI is already
> disabled. One later enable leaves the IRQ masked.


can you elaborate the scenario where the repeated lifecycle disable 
happen for better understand ?


-- 
Karthikeyan Periyasamy
--
கார்த்திகேயன் பெரியசாமி

