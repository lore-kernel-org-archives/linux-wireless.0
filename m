Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB2F3955E1
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 03:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519041; cv=none; b=qL0rIeFiTKiCxFdveILoxdmd2gjEB68RdDz3MPxwKG09G3SXSF8XSWlNdR4Mqrz9Ye+0Cpjm5N9ZhiEg1qhmT8A33RbAjC5GFquZq3OTxFZNX8YTG4cEi9Bga9Pw18vhDAoNmSRPtUi6zVXOP75P1ATWyB+ahkV3GLAlBN9hjPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519041; c=relaxed/simple;
	bh=lkA0s6iwAeRPJSPxUGB5e5hM+vCSlA4PndnijjVFqJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ooqim9zZ6alIX2LgewlCLBqfNNdqR+igaF8UjTmkOJntPS1SnzVNNxX9tIzJ620Vhz29VTR5MhStzf+n7qqjZObICAvMaIjyEXGMM0JVhn7QPHZebPQ+sGCY3b6I9KKXN/jmkfmFxdMWd0UAyS1w+i0PU+vaqiUA01EYD0aPkiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nby672tN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GrIc7jm+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nby672tN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GrIc7jm+"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JNsQgm939276
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 03:43:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zbGvV7HPSAZ+/yd6PZ8nTYa5fEnloeHvv5FpQWxD+QI=; b=nby672tNvryi5a6B
	2Ch42w/16HK3npzuuYLCMq4ONshteHUO7whefnAKXYJpOpa7aXcL1fyhD2H8G85L
	239rI4XOKmT6kNiv4Z1xpwQI3MdxfgkSVp4WgpAPv7DhW2dCuehXu8hHJCtrl2WD
	ePKRQ+fkrhjXSlx1gZQucl4JW2NXDRUaK3Tg5vBs2YrxPm+qmYmt4FADsH6kxvxZ
	flxrZZoKHvCFFrCG31nhGrOFCnV7uBUT2I6CVhQSpjBdS1q6tIXeQK0vkJU8Ap3C
	GOiPcxlXYicWJ8/TDnp0WqIbwzrp+rk0yYWsGSPpC9n+eC9afMxSlG+Tl6QrGUNM
	yxCi9g==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2c6c740-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 03:43:58 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-37fca5f21b1so3047362a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 20:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784519038; x=1785123838; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zbGvV7HPSAZ+/yd6PZ8nTYa5fEnloeHvv5FpQWxD+QI=;
        b=GrIc7jm+uWBAfn8YIXQD041lnqSFnRd1kh1FQpPyj9osVuFn4irirB34bAKxP6NVrF
         YZpY1vrB6jnwdiodYxDUjNOmAIIkt6gZQKwS50SooFZfmP/9DiYrdCHyrwBqaG63lI98
         mK6D2nopJPQg5K6+mBv2Qf+NFAl75EpVM/UP7fTjSlz5YfuA6d2XcwIAbZ+9i9lDziE5
         S7XWWl8kNdo7bpBg2dbB6RE4f1XO/qzlNKiTI1zWRdeZ8tQr3dCRRwKqWH7VB9QnPGx4
         eBcM5ezNY4xc2B+FGDw9f0k44Q5Kaw97NaVTLjncmWwtMaU+LWXf6/PGzyusdQzIHUJE
         hLQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784519038; x=1785123838;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zbGvV7HPSAZ+/yd6PZ8nTYa5fEnloeHvv5FpQWxD+QI=;
        b=ebfIQW5Ijc3xXnnurOsxaT/dS7Hvx0GbhoFXoupSHiLesuKW2u6kmvg4OmNmlvleKb
         DnyhJ4svmKc3v3aJ2dj2B/72r8+haEONiuzMRlckmNjDNKnTcCBIRfXx4C2j9tD699lI
         yQIR93gCRRiRRd4SGY5bnskxhK7E2xLeJNN8hmwfHsYEhIh6vqPFh4cwEzoCcBaViPoG
         0RvQMYzhBkZNOWehh34KsCYsJoTg4wi7osqb2Ysw9Cbm8Uj//rGoT0vqowMtXnIZsU8W
         /MJGglQg5TiQDLn3UsOKF929qQDQc8cCZy4c/Hv+XerD/UxTtyZhnG08aRsHgnUx0snK
         O0Ug==
X-Gm-Message-State: AOJu0YyUWlKGCGMEQrSAwZiIWxTt7CF//cVHBCtAZulkbbeatkh0qGt4
	mMkDRGS7mL35fwuPPO/WjN7Y2gC8LOddIMt3z7TSgR3PGqZ1yiI2SX3yfSmvz+VrMgOYhZNqoLe
	0VlYaFHGs/8uxAIkjThnhJIETRyNddvhhjuiAKa7IiQwnfjH/MRH1DPZRA3hTyOEEyWeDouYlP8
	vz2Q==
X-Gm-Gg: AfdE7clWENd6zRiLcDpDsujV2x7n1M/yP2DtDnMa4O5rwdvpjZGk8eXnLxeBamoZQcE
	n9hzuJ5fzOctMHLSbA7ONwt1yh6/+FOrg9mxsYPyeKzMcJl4bBVlqCMIaFpDTMRrfOqyAF137tu
	lIKNZQUnpcvVj03i1y3hqyt7TJUcBYtGT5KZzB7SWxRyVl1tSRjwpptGPMFE2f6eplPJqVLiThd
	2wlkY+nNPxbZI4/IZc3oucDQooOoJ32uRR0AJNUEnhyTN5sVW5YM/UKfm/yyWEXay8wpvT7zaZc
	Td+gbnWoqVuAMaaJ0rOcsXH6n9oFcGBTyWpqSjTt8dStK34ie5Tgw2p3W4cNt1ex8AZlYFPQwz7
	H0ZGWIAcCH9fmX+FSBLpa+3aMD+70AcQ+7qm+8IKuhkR7nCg=
X-Received: by 2002:a17:90a:ec8b:b0:38d:ec55:7aa7 with SMTP id 98e67ed59e1d1-38e3d29a193mr18242456a91.19.1784519037487;
        Sun, 19 Jul 2026 20:43:57 -0700 (PDT)
X-Received: by 2002:a17:90a:ec8b:b0:38d:ec55:7aa7 with SMTP id 98e67ed59e1d1-38e3d29a193mr18242444a91.19.1784519037034;
        Sun, 19 Jul 2026 20:43:57 -0700 (PDT)
Received: from [192.168.126.30] ([157.51.77.155])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce29c2a48sm22695420c88.2.2026.07.19.20.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2026 20:43:56 -0700 (PDT)
Message-ID: <550bad80-c4b3-4e24-9103-fac714862f97@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 09:13:50 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: Avoid buffer overread in
 ath12k_wmi_op_rx()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260716-ath12k_wmi_op_rx-overread-v1-1-327a4b1c2372@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260716-ath12k_wmi_op_rx-overread-v1-1-327a4b1c2372@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: iv3v5Ua6gOfhN2GiXK92-qUQXw5Igm5N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDAzNyBTYWx0ZWRfX7vUuh98W26T2
 EGB63FraDrnu4oFVM8CY6AiKsyhdKU/k7diDcpv38mp8DqTzxCUd7SjbB0Ikqbv0+zCX5X9xGQ6
 9pP+HmHZQQCWpRKh1B0L74uNpXCDzeH6P46eipaA4+pip1mmLB4waRfBQ+xUxLRB7O9q2F7SgPk
 xXBSvpDMTP2XbYO5xSVteABWgPG446iKcxkOA6W/qBzTQO9KisfR7TnByVblmWQLrvc6XzY56Oe
 Jm+WOKPqYS4f+Xj0IkFDqzsTHjRwQI0aEg31gr0muXPkz6ipaUCQ3q7OMX9U08SaOkqwSgdrURy
 LNLPNZFkI6ZhytbV4X9jTv1YTMATH4LvOVLTmsrPzbm9Xz78fKaUDia6Je1GyhtMLifo5qtZY2y
 NU31u/uBupV7B891s3MLdp96IIN1oR0wOOc/m39Mlgv/vqPORfDLa8XsxogSYAsEGatDPkjPtTU
 SBAbhA3BWn/t+5A1GnQ==
X-Proofpoint-ORIG-GUID: iv3v5Ua6gOfhN2GiXK92-qUQXw5Igm5N
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDAzNyBTYWx0ZWRfXySjC/MmDhbkK
 2h8iPyVTNeDC4c0+zkEnFk14FVjP+xyHp2sZXd4K4LZOs4C+YQVI75Atf0uma9/UYTJIsHKjJgD
 hANysmJJ/KxPomoxj1HyBJQ1Ot9oWSs=
X-Authority-Analysis: v=2.4 cv=CJQamxrD c=1 sm=1 tr=0 ts=6a5d997e cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Jeo/xMHqCPjs4yjtUlRiiA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=ymRfW-ZP9UeHRcWsrQ4A:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_08,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200037

On 7/17/2026 1:31 AM, Jeff Johnson wrote:
> Currently, in ath12k_wmi_op_rx(), the firmware buffer is read without
> first verifying that the buffer has enough data to hold a header. This
> could result in a buffer overread.
> 
> Update the logic to verify the buffer contains at least enough data to
> hold a wmi_cmd_hdr before reading from the buffer.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
