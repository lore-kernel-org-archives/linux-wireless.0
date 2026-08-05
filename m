Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12D2432BCA
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 11:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785928649; cv=none; b=IYx6cBDQgziCzG1k1pPdj7auhTZf683/lNEJEtI1YRP41eajeNyuEV1L78/VYnPWFu6DbZ2UZ9QyO7s7uysfQy8flnEnvvE/iqe8vOlNKV21S99HTc33V6B/IJSJDMCOx+B8ityx3Frivi3/suWD4LEQkD6OV3O3JZAZr7mZ6Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785928649; c=relaxed/simple;
	bh=WxPtIeE6LPh4w/Kr0BfcrUAaPr2TqymLknXLjMK4FFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H2lTd8mNos0epXgG+/CBJU6yhicrVsSIqhLmL3DzNl54uFyt0lvHzc0qhjzkTQOwdB3IwtGBDh+l36J/9Nrh4lkXHDllaLG1QKQHRe0va9NnLQ++cDPTVIlxf0MyzVUEX0NwTxICdRkFdggnoyPx/QUp9XaBOTmYJVoKNYvwN4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PCTCTYR0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gp6iTANr; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PCTCTYR0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gp6iTANr"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6758d5752073558
	for <linux-wireless@vger.kernel.org>; Wed, 5 Aug 2026 11:17:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Zz5YDsnH4EYX0ARoOKNjKE7qWp0mFP8PTuIplLeGj6w=; b=PCTCTYR0gpIIVkjG
	YiCetGZYW9IEKiKCoJdOsSLoXMDpAb8n9T6A47TlYTMpm3E4fo6WNrZuRvnmsmoq
	NM4Oz5xifPMvXvKrk9f3mdt/9Jt9pmYPOhKSOc5+s+6vG8TAFlioC78jqu0I3Atc
	PF3wMSGVoR/QitRCgcWamiyK75AC5L5hfkctg684exdkBomorhn3uNmYmOcIBQ3I
	sSlsYWB5q8+ADYecQ2N/oZCz0eYY6eaValvrWB6HDydKOdESg6vgIQavOBILqoPu
	WXhE8BiNlXDCgTi9diMLWWByPCUkx8uNo3CMCs8VB39uiSqVdaU/2hboeejuOwyC
	XVEaPg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fuk9u4gec-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 11:17:27 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ccb6823efcso8827065ad.0
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 04:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785928646; x=1786533446; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zz5YDsnH4EYX0ARoOKNjKE7qWp0mFP8PTuIplLeGj6w=;
        b=gp6iTANr71lEMUzcN4CAABpwVl4iwzfZzfNdJJBSCt2rTDimiYCUMzhiZjbL9OATMw
         kNaQd6yjvq1QzNJMdz+W0R0aNlgYeMo4dfUFvX1gntQztHU4wKbtnjRIJ8A4A7Pt05Os
         SQBoqcHSrEwQoXGw8rW25wxeEGnr9vNzCdN2GNAHhwjH1l/I9gh8C91baGcnLLgcQ0Ei
         UnFmQbY4gRbiawnYWIws5lgIDOhAyHiWG2HM/WsUFawQ1N3sZ3AaeSplOaQcZfrJdLrU
         /ExBo6ZgZ8MvMQFSqA98VfKtsMeZbFuCKCb/koux4xEUo+E/DiBmwrAB5e9hZK278xRd
         hDVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928646; x=1786533446;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zz5YDsnH4EYX0ARoOKNjKE7qWp0mFP8PTuIplLeGj6w=;
        b=Tw8I/A/VGyWpgs0xSYRYTmFmiRuRGGXVt9YXQRSZSqRQiGLX8NgkNll17nm954/zLp
         /pbR8a4YdGgOeIr7kPYsS2UqLjpqC6wD20lkXmV/240mlDeYTHTB9Zf1xFdhJkx8u3mr
         XofjsjtuSynBTEX6sD3krF1n+Ccoe+ima2ffUaj1CrxCJxoWgKx9aSb5PjikT7gb3U50
         Adv3o7cXLhxeWxArxCmyYaW1ZfPQ+WWltJEPb1RZDXdSZH5YsxfxIUuWTseq2I1+r/1p
         mNswBVJR6vtmUWRVX03lpqGAkOdlL/87KJneJdPFv3/tlnaFah35vsNyrkCVhMqY0wth
         z0Gw==
X-Gm-Message-State: AOJu0YwmSVKwFRWy+RxcWIYhQm7OL4WsaB/cofE6QzW1GwJ2dzKb1ian
	s9pzpg5LB896bxLfguOEKH6HsNq1OoRdKC36mR/GyMRDREgZzeojdDVMabrgXJsIVVsVVpN4GgP
	vaxv7ZCDzGgN6p7Hy7mcFCr4DHY2kp3gA6+V8JjrVXivDVFWDQHGk5XI+gNMpt3Ww+cneMA==
X-Gm-Gg: AR+sD11aQh/h1kiVCuv5TPlL5OzqBd4lgUfj8/d6M+KYnlYaDRP3l+h5IrydymYPfUH
	D3mwwRoMvneXtE5GoNpDz8P1NXt7AaWU9Llw4fslhWVn9Twdw5WLco3R4I7PQoXXH3g7Y9C3k2m
	bO4hGKoFjDuyCsChGxFAqQ+fJIrM6sjwjAVomBa2wA9sUWkSCJZLNTFmCiYtL2fGkobk0ez8XAl
	dHe1VmTGZlLU0T1FA8iZAqb7WqNCd3TYR6GmjmREBIcpl5mDv+86z7blqMSdnF/cCmgwk2YQmkO
	U7oYM0ZIiVRS3b3ZPTTfT2aRvFZ1B+fArJjyOwNnxxSaT7hCwFm1fMASYvCSV96yQsae4E1c6Ju
	2p2912G6vFNcUjdaDDWX/JTVvFf1HaGtMpg23eZsb
X-Received: by 2002:a05:6a20:43a9:b0:3c3:7e9c:e292 with SMTP id adf61e73a8af0-3cb85f49477mr7067173637.25.1785928646393;
        Wed, 05 Aug 2026 04:17:26 -0700 (PDT)
X-Received: by 2002:a05:6a20:43a9:b0:3c3:7e9c:e292 with SMTP id adf61e73a8af0-3cb85f49477mr7067122637.25.1785928645982;
        Wed, 05 Aug 2026 04:17:25 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fca6576b7sm12059674c88.7.2026.08.05.04.17.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 04:17:25 -0700 (PDT)
Message-ID: <6cded053-d8d1-40c4-b3a5-753cd5482b6b@oss.qualcomm.com>
Date: Wed, 5 Aug 2026 16:47:21 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: remove skb->data check in
 ath12k_wmi_process_tpc_stats()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260728-ath12k_wmi_process_tpc_stats-skb-check-v1-1-01b7d09be20d@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260728-ath12k_wmi_process_tpc_stats-skb-check-v1-1-01b7d09be20d@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=NInlPU6g c=1 sm=1 tr=0 ts=6a731bc7 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=xk6P7Knj3mn-WFlMDu8A:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: KGLl-aJMXoIQf7dTRHnVbar2Lgv1gztE
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA5MCBTYWx0ZWRfXy8IpqDc8o7xp
 w0hWLRJDFSFia/lPOcpeZTMn4oPJ2KWKcV34spaMYlr0mxVpc6xWzTp/ENtXiGd7AH2SSGIdqRx
 UBISEVkeWJtAJ2wNRD0COmRaJvHa9UY=
X-Proofpoint-ORIG-GUID: KGLl-aJMXoIQf7dTRHnVbar2Lgv1gztE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA5MCBTYWx0ZWRfX6zylEcZUpYZ2
 IoOawyHMpXFUAHxRazEmo1/K5c/IbGAFxtrEy533zM2h8KtCBcQBNY1es82RxYWldCQnOIulQ1p
 DYgBqb28RYlf2QwBEVCQ7Nub6Gs8KCP8wKl46qaBxCaphyZQlxI4mEzeY+Az5MNhz5Wxrq3FGii
 ljaWdBdpMUFvM7jQkejmo+ZhROTdcZ7+jIcbrl/Drw9LtISZ2IasRxcpxcqpnNA+k8gu2OWHZ2o
 HQjQ135WLcmPpuXKAKvLOpVGrjDRnniVZQpggjE6g6eK5kJqMI3fwB5Yarf9drAN0SJoMDs4V4G
 jVqcOIffF9svgS2ra5xiAwpOunfiPJZU1aChc4GSOLdwgmCnHFAA8BjfYeGocwnJur+te+lA+S0
 kPp3ZvcqOXVULqgi/THHzur1Br81Az0eNhU+nLseyA25X9LfAexB7qqOnwsLcfMvVivx2hhMIyY
 weRqacpBrjXd0SgLNKw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_03,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 suspectscore=0 clxscore=1015 adultscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050090

On 7/29/2026 6:45 AM, Jeff Johnson wrote:
> Currently, ath12k_wmi_process_tpc_stats() has a !skb->data check.  This
> check is pointless since skb->data is accessed by ath12k_wmi_op_rx() in
> order to dispatch the message to this function, therefore it is always
> non-NULL.
> 
> Remove the pointless check and its associated warning message.
> 
> Compile tested only.
> 
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
