Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9BA33F368
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 12:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788266021; cv=none; b=TyY6iKNj5tnlJVUz1WMVfpUQyXrpJRaoIYzUsVWuzidVlRe+A/DZHC8wF21YIw3rgXQzNCDyFtt7uKG7Zm0K2/lF82m2BBsGQpbHmMZnoJ7hdy/9RVHIkUthDb3+Fxvixa1lVLNtIvu76/s1/DONjBtn0u2sOrx9RlhQ9mtlDh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788266021; c=relaxed/simple;
	bh=ewlYPPhGEgjdDY6cPFrQF6SEDBupCDm4u+JfhTBrrOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/xl1v+7HOj9LQKfJyqiCGQ5FJDRoxtsLLnauE63fQwaklTvnWDwdLpDHSlfmM6qe4Q3sCFwutM5lPhFxTvXSQCknDH4Vh0MFr5LcB+GsNIobrAB7aH0YcF8yAqbHYcCViR3iF4/bR5O2tFbL5/d0e6Unjl3qlM12OA+0aadjUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eWjZsGYA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=T0t+PFu0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eWjZsGYA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="T0t+PFu0"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681AJTpk1137300
	for <linux-wireless@vger.kernel.org>; Tue, 1 Sep 2026 12:33:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=hMw1bZsyl/wsw6eXPmwKbIq6
	QdTazM6/t3F4X+WUBco=; b=eWjZsGYAZj8O5JUmFfCnYfRbww3oq3NlVlYWZXS1
	cqUsAhlg3HoZjGzoS4YlzLMgF1qH2BofiuocRfwAFFr3Y89bl5dAgkfB9TEwQAlg
	Yfykf0OjnTmoOKrma0qRTi6uKbpqgHIeeT6QcbN3bKXM/IbnA46+RaZSGloloi5s
	kwl/tWFfr3cHUXJ2CgyXJEU7fM/+8KmWY2LJrjaUvJ8fs3l+LKcjcMSVTQTJQleL
	63qY5ZqmFHMuDZFEU3nOSQvkU+whOZ0Zc9y4DoJvn8CbQj20Gs2J+0pGlPG7heoT
	cQIrBuS0MhrVaGhwS3xy+kwceHv0oAitHo8EpaPNr/9sNg==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdrcshu99-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 12:33:39 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90cdc69a7b5so71779916d6.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 05:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788266019; x=1788870819; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hMw1bZsyl/wsw6eXPmwKbIq6QdTazM6/t3F4X+WUBco=;
        b=T0t+PFu0sXzbK4eLTvHRO/kz44NV/auMj57VafD5XWz8kSghlXZeVKiU2mjAWh2ADv
         HHFtNUWkW/sEqQZIjc0EFQzc/QoUWtk98JlE3ceoYaX/QDw4qzN1vIJz0daCNi3zmVXs
         0/PoyXreYAm712ftgSJn4qZmyTqiUfMJOteFO4gTje50hUdEiE1I8TZHwxh9pC2Fml4z
         oScfaC36kxhx20+Ir9W3nyZ7sMcsFipt4GZOJK4upASM5kMH1diZiU44S/tnCVPBmuh0
         TGs4a4+0btITFe3Kx9N41jAdsbS/UbxVDFp+i6tIYgheNSQi33VMxVQY9tKnPTFreOFc
         MuVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788266019; x=1788870819;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hMw1bZsyl/wsw6eXPmwKbIq6QdTazM6/t3F4X+WUBco=;
        b=TNPjdF+41qBZ2p2deNf/MLjFLCJriksMHG/jy//N47yMlwWTcp4UEQUNF5ELD/PzK2
         Te5sDYuGJ0r2ZOJeoMA//WsTZyPtoiHSakYaniTyU05QUhUNC8vHrB2JEg1EJ0VO+7Sx
         XkWQH7r3eEEStVMk90lJSfuWQwxI4p7fKLLeyo6WHqMZ3AjXUeAIv7J/KD6RB748G1pR
         ccUgJtBn6YDKzbUM/fXACGGNQs31ugjIp62A437Jry6GSQOX4qI5xodczduDvVOk1iq8
         wn7I2G4nAsXtvaXL43FFsNvejcyRIDCAqZpL3t4jFsYXTyExbP1AX2vN/yZKYnlfPa6w
         SN7Q==
X-Forwarded-Encrypted: i=1; AKwUvBzRDqZAajheGozFFjkld7uMyhvpJfj0gAhDIleDAqRPsbXUMBFJm8RegcGr2QqccbZpy1C5bbMP6MrYbYxVIw==@vger.kernel.org
X-Gm-Message-State: AFuF++lGXOf81d7Tu3IebRlEuQPlLnPCUvAYgYnZfAiPFNlQaRwYV8Mt
	A/NksmEcdfS+QFvdqW8A0+zSKOd88fIdqFWN9UDSdk12Lqo08oPxF2Jp095fZL/yBMlrN5ThYCF
	OZtK4zVvpXa1aWnbkCHZN1KMd71Yo5tUHNaEcGf2I7Vley/Dqta7O59BGUhqAkUQkIpNpGQXj22
	PRzg==
X-Gm-Gg: AYBFou2T1bVJz4xETR0fxadEtvywuvid1UbtVk56lihRfu1pV32LuyMYCs38bsZNQiq
	oBfJoCj8wb1hiXPrJOklBehz26HhMHNhA2miHPE93v0tnZ0hmJ4rbKMtV6c+A6NgOEaoMYrqUn+
	HSwtwtE3EMhocLXExZNB1asiSCaW/o9d4HXG29VPkWhB4haExQ5G9f7VunJ257SdoqOPo1OYh58
	fGyh3kBN7tB8kB2HjxvDo7WJV23U4MUqaJsIRg+lwYtXUZaV+x0cRStdV5NXGYSPJwNTcs4ZGc+
	mgOPj8ptZacrGY8PuazO0dMd+yPacSSzlzlrYuWV7aJtTaWzFxDe0U5OqbUeNRa4FQxWft19lHY
	LbErojvCIcxbGqbXjS3szRN/wM6ZiyIkOgmff8TPtvskkqXR2TqiXc1u2oeWmBPq42mnJ8dv/OR
	uHnBG6Dvk/Rbf1
X-Received: by 2002:a05:6214:4908:b0:90e:976d:fd2e with SMTP id 6a1803df08f44-90e976dfd5emr49205826d6.13.1788266018607;
        Tue, 01 Sep 2026 05:33:38 -0700 (PDT)
X-Received: by 2002:a05:6214:4908:b0:90e:976d:fd2e with SMTP id 6a1803df08f44-90e976dfd5emr49204746d6.13.1788266018042;
        Tue, 01 Sep 2026 05:33:38 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a31e5fc6f7sm16578891fa.16.2026.09.01.05.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 05:33:36 -0700 (PDT)
Date: Tue, 1 Sep 2026 15:33:35 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: Re: [PULL linux-firmware] ath10k, ath11k and ath12k firmware
 ath-20260831
Message-ID: <lh3sniuz6oxovkjdhdrjmjmoczjx5y5gnxfv3lteq3tpmjvwpr@x2n7qbbeqnnk>
References: <a1b69517-a18c-49ba-8ef3-9b5de089eba5@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1b69517-a18c-49ba-8ef3-9b5de089eba5@oss.qualcomm.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDExMSBTYWx0ZWRfX1gnmYMrk8hvS
 UYIf64eNhPQa/xKoY9qkTaLSXCnVaKBcSWafo0oUrRB+Oj2tzcQW4rEFwsVfbFmOix1YZBuF9Xt
 GhK5L1i43Oni3opjxBkypwqYwCm6jYc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDExMSBTYWx0ZWRfX1YCQgcaHpiat
 Q+gyYyECsUmIx0PtoLg9U13MRHvxBoJGmzFTh/2qLA2acB9DhX8f/Vwvy2kMbtAtaEAzK9bHP2c
 2hwj0UOgLBG8RxpVlpryN+GT+/aAEYLSasT9x/dNIyBbFK9lO5l8qKbILTNdONx8t5tzFllOD61
 9yNo8fMflAuQIxIA6E4GHTRvjM27Mf2y++v5V1fxARjvicfHkcbhVVzUneAcSqQFHNCUP7UBcgB
 aeUDwuQK6cJUU9/MKl5MdaQOGiLq9XZ40JW7KudE5Y6iXpqehiM1Dql2DxHDNxzxL9bCJR9j3fe
 YdEqn/7xCvMxtNWuz3HPWhJMG/I7z5og3SObAtCp32y9nCKQSUtfj7xNAHB7gs5To7jPOX97ZpK
 wyHogo/s5EG+tCC1s3bZQ35/UDvF4AfnVdNQAU9d6oqQPGnX3OTeV1PaeHQKer/bo49qfgPtFQ6
 xmbzbAsEouF740936SQ==
X-Proofpoint-GUID: vwszBXws5GMgZcBcS7kfhMnuV8aWNV1l
X-Proofpoint-ORIG-GUID: vwszBXws5GMgZcBcS7kfhMnuV8aWNV1l
X-Authority-Analysis: v=2.4 cv=QsNuG1yd c=1 sm=1 tr=0 ts=6a96c623 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=p0WdMEafAAAA:8
 a=W2b0fEEQJ4TDHmAVsWEA:9 a=CjuIK1q_8ugA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 phishscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010111

On Mon, Aug 31, 2026 at 11:49:36AM -0700, Jeff Johnson wrote:
> Hi,
> Here's a new pull request for ath10k, ath11k and ath12k firmware.
> 
> There are no changes for ath10k or ath11k.
> 
> For ath12k, update the QCC2072 hw1.0 firmware to WLAN.COL.1.0.c2-00228.
> This version enables Multi-link Operation (MLO).
> 
> Please let me know if there are any problems.

Thanks, merged and pushed out:

https://gitlab.com/kernel-firmware/linux-firmware/-/merge_requests/1211


-- 
With best wishes
Dmitry
