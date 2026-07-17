Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A24C33F394
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 04:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784264394; cv=none; b=fM08f6fhhgWGNoesFJsDenRViCAN3LhqoktrBi4RXZs5rmqkgOKdsdGg3ag1ZVHzBjxLBZohghPtGlIYc/ciBCP/grKyLsgQtELMrhce/OPHuh9fXuDSmU/+EWzcRY3bcRFPbFdwknQ/6hY/vJO0s2k1gLuaGE1gqhx1cmSYAg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784264394; c=relaxed/simple;
	bh=fgJBOijGjrCiiJ7TRQUTDT3NbT7QlrhbVJHlICJUcmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Npz+XKWcOqeJsrCNkXwlfoXrV/HOPIOj+EKKGHozKgfpCGswdiY5bTO/FZRLj8QQQ/JFnF526akkDJ3uF2g5n99Mk4nShoLhfUm+JO1S6+7X12uROe1OGS9L8BR46zDlDacPvG8QahA3UpJB3pw0gUFuwIFAmn4aqU2lrH/EnmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=p3fqzGBJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ko/sEYkn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="p3fqzGBJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ko/sEYkn"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66H33f6q580737
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 04:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9cQa0I1D+pUzRftAtYM2RH4GCKjsFGpCoRwLdn0OnO8=; b=p3fqzGBJEVLFpfD8
	Fl/x4b9Xz78mb1ax9/ZiyjBlAr2TzN5fuwBL+f66qre2QTfBoAAV+I5e13ouLtWh
	bqelaYnQ82YdGVySSyrx7ja1BZIqzL1PkNFMcKEUQ192PgN2bfnstTiKKSkyIn+L
	vmnwer90NQF+fpxuq+xZpwxPkIQsM06WVDBrruqsHlhzyf04ZBE/k1Qn3G0SAwtG
	xNENSuwb2t01/7+Lsj9TA0tCTpKwpE6F2qjVfKCNozsQuksVqNBNfjk3xivQGl4i
	SOgSMEqE4zsuGsb8ZAVlvn2zXrOiWq4yIKXTPjpQFmtQKMgSXV4I1ODYUi7J8WdD
	tMf/sQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffbqugd73-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 04:59:52 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so886895a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 21:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784264391; x=1784869191; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9cQa0I1D+pUzRftAtYM2RH4GCKjsFGpCoRwLdn0OnO8=;
        b=Ko/sEYknPpI9Dmt5BN3+DkruMk1dadkQeN8sYnylloZQt+KFtQ77W8wjtdHVHZFt95
         OYqjwDTIzbhp8tkT2RMvpqkpRfQkgRhihsZMDuHDRnooeY6oewbE+qxW27bg82/kq1u3
         Jp9zd8NTzVH1HGuRB0H9xDHAIvunhdPJ2UaLMxaYbqmeQdGU8gdyhSrWZkbULuEBlnMd
         T3QSE42V5VyMyITBksGeIHMNabDeqgYTa9owsA2pr1kYpy81ASZ3WzEk4YhbkbuqjgCH
         ka8TFrtdeQewpSqCAHCUHGEz83+UeUZd3yiUVFLXEmZ3xAjTMlSiStdC7fniDHdOv5p5
         UTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784264391; x=1784869191;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9cQa0I1D+pUzRftAtYM2RH4GCKjsFGpCoRwLdn0OnO8=;
        b=RMBdDhoPekV8XScy7f7UXM30HuTKwtL1I1/jxCW36+OAM+mbVT3fFKRWp5Cs10ccSk
         ezx9UDE1v3vYRTNDO06sDf2NaL64e5WXvQ/z66m4mbCOWns/+QpE7RDVTiBWHzZFQk1l
         AngcM9kVRfzwB7L+0zcdKsfDY+P97UxPHIQugriParOdEFpZ02rnz6FuV84s2WY6pvSp
         +RuzF4d6ODOgFS9pFOO7b/T/Q2DWslP8HMHjBIHUeJzt/477zwS2UPxChJjOqH5l5H6r
         8Qh5UV4lZRbSO0OaI9DgDV5ktPkTUxfnTvsCR1KYn6H1JpYaIQOhqN0HjY+Nh/Otm5ZP
         dDmA==
X-Forwarded-Encrypted: i=1; AHgh+RosXxkbgBVMHq2BoCbf8y1qVxlKZ9oIJfkuXFAwLAWDuWhOLVSvGHAWeg0iBNb+pBRqTFY9QP/kGkqWVOZnSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp83WawCUhEw41CExpmzjDZCgXDDNCzFGWuTMpyEahkvudFOgg
	53nMXJXoeCOFz2CLrdwb3Fh56wlVjXYO1HF1nnO/AVHpEyCzUcMp0ZdAYK4C5tcLU396p/XVgaQ
	aFYnbDbt6MHGUwjmAeRPpt2OywuwO+Bxu1EGXnxn9AJBZwVka/TW0K7l29VLktAhfKmM0jw==
X-Gm-Gg: AfdE7ckLL8F7YHd2EXLQYlcEMBIbAOW/xTk8Sm6kJl4zelvkvo/hLfLUU52/P9cc7IU
	mkUDVO00Fzx3CPJ0O0bcjlumedkWjpDXZ6rRXS8Y0Llf3qUR29YmaLVs7GeMjuK6n9Up98G4iiz
	y+VO2OP+MtgmkRUVj62ZgfGe1YGA9U7Y07b0mfqkTeXo5Z9uOwkImVzRTsbar1xiaEXIuoF6kK9
	J4K1jyakAMwZmM6bVTeir5Rw2+hCAuGOTMmqw0G4SCg6WLF4idC28cYuUXBy6eWq0HBJbkxS65Y
	qnBXmTlGiWc8xeq3b+Mj5JuaEBGV/WueOGdTiM3pP+RzbaV5e2OwxPHHtdXm9381qMoFZVy0/BQ
	MYCqw0ZIxBlJIw2JK2feQe5WbxFnzTqiABQrkvNsb
X-Received: by 2002:a17:90b:3bcd:b0:387:e0cb:c8e1 with SMTP id 98e67ed59e1d1-38e4b594dadmr984698a91.42.1784264391436;
        Thu, 16 Jul 2026 21:59:51 -0700 (PDT)
X-Received: by 2002:a17:90b:3bcd:b0:387:e0cb:c8e1 with SMTP id 98e67ed59e1d1-38e4b594dadmr984676a91.42.1784264390951;
        Thu, 16 Jul 2026 21:59:50 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm3696495eec.21.2026.07.16.21.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 21:59:50 -0700 (PDT)
Message-ID: <4f317363-381a-45bf-94a2-fad10b9104b9@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 10:29:46 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: Set DTIM policy to stick mode for
 station interface
To: Daizhuang Bai <daizhuang.bai@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260717014302.284034-1-daizhuang.bai@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260717014302.284034-1-daizhuang.bai@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: SJBMz3hl_8AIu5Tgdzg0_Pst4sD0nNfY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDA0NiBTYWx0ZWRfX1nzoVioyNOFx
 r0uUEWtt4cSjqITRlmYN99h+Gh841JP9eIQ8PILT6adeFaj8eYEX0dx7PMA8sO0aqweiDTX1ZHZ
 X3iNHNa0b+vqJiIdaUbWas0enTXish7Kjsy/rfDmN1AO/bMY/ZMTEZg0UdFAQNyh2t4K2rzeonT
 PBkXhj12HU4P466BfFnzNzQKjuzj+4zNLg58jJpPjthMNNOh2dYQow/ylVRqfNkDdujJJ5rUEc2
 jiz32DGYv5MIorhdOKm9rIRjNJ9swq4NMFIALtEYTWdJm5lQwRjJQEhWOCnkHt+s3OkgsSKQ4+6
 86rj31ZW5p8Q27z3WnoVMLec7u2Fr/dvi7wxUl3/3MRjCj/fIefFc0GbPWQbpy41LY8vOIbA/es
 qtcsjhCMwgxn/GbtwFnTebRe2Ew9OmGAmIk7M+IJmikB33bJtKjQ5t79szz9hUrlDg/bgsiu3sY
 tYr2kOL/U3IkPMZxEcA==
X-Authority-Analysis: v=2.4 cv=NZ3WEWD4 c=1 sm=1 tr=0 ts=6a59b6c8 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=PIsBSLMAwA0o3fhTwyAA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: SJBMz3hl_8AIu5Tgdzg0_Pst4sD0nNfY
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDA0NiBTYWx0ZWRfX0Nao3do91NPQ
 NrkP8Xj0pCwsVdT4Ur2D1Dk1XaPAirWwHRXXVS6zeUstbfIYcKa5G04+coPgRlvmQJAIEJ8U++n
 Le1MDCbqdUn/f+VCP6+pI7vdAFyQzA8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_01,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170046

On 7/17/2026 7:13 AM, Daizhuang Bai wrote:
> Currently, the station always follows the listen interval regardless of
> the DTIM value. The DTIM function does not work as expected. The default
> value of the listen interval is 5 so that the STA wakes up every 500ms
> when power save is on. This can cause a data transmission delay.
> 
> Set the DTIM policy to DTIM stick mode so that the station follows the AP
> DTIM interval rather than the listen interval, which is set in the peer
> assoc command. DTIM stick mode is preferable per the firmware team's request.
> 
> Apply this only for STA vdevs and only when STA power save is supported, to
> avoid affecting unsupported targets and P2P client vdevs.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Signed-off-by: Daizhuang Bai <daizhuang.bai@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
