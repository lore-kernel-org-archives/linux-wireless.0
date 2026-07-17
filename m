Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F1A3F8EDF
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 16:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307432; cv=none; b=Zufvhn+9anDJwulVm3djX4f2g3kOIjDqvoB1e4bsf8lO21JFnBlIRpACvbqG3QiLLS9bPXGx6M+Nclw4cwEutVah09+7UUHXvOK72LBXFq96Xb+h40QrXIVvgEfvUQp2kTEAe1K6doRcGwcm0gNF53EiP9JDoEMtLHjK7TozbXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307432; c=relaxed/simple;
	bh=2vzZT0067HKYTBp551U1/IFiClT+laI6deaFUNqrcZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=glcTusETkIt/MAQxodmTCBqgieXiMz9TbF3kDBqvl/Yc0ucwtkI96EMFPd7swIakbwYOZTQtEtB8GCA70btq0oezoKJetYIXjx46sH0jR1d3BOGA3v3CxKYG8LXPje+nOTz5w3godYKKqs1cvtEIY6yaEyZtjRSmQoJZp48++HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=G7XdTxrG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=guuEplxR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="G7XdTxrG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="guuEplxR"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HGo4sg2244839
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 16:57:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DSY/c8X4QNDRsgky4WEPtXl65kYd8TI3cwZ3M9kfC4w=; b=G7XdTxrGFuADNFw2
	Ciop7rnmpdTsVTZ0Gxtlz9Hc4tgqqEKhYuCGsu3Iidj60czRSXlkxGokK6N46Gdn
	8OUbFbSdaIrSr7YOEfg1FbSGxuq7GoaXps1g9i7qjoTY+CM7icARnBQLRXmeaAWX
	n7kfQk1lReNwbJjQTCx9DlINACSGLJoB1bhyrJVUDVq94TBk86KW9idOZjhAwvD1
	5I7kDVsthui277bvp6j1+muMH0Tphohtr/u6N5aSYiZTdq3PO0AJxIGn0Q4EgJYx
	UsaR2stQoK4GJ3bFx1TTjZYJw96VRq4Jx15CwQHDlnoBgKy+nbqpL/sse4NcMilV
	a2aZzA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fff9padt0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 16:57:09 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso453989a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 09:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784307429; x=1784912229; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DSY/c8X4QNDRsgky4WEPtXl65kYd8TI3cwZ3M9kfC4w=;
        b=guuEplxRJ2OYUq67fTPlQnrnYGC6o6MmmwbRThOkpe9HoEIwgOFqSuUKCpw+EtJKsa
         8SXFs0+8j/XQfxcd3iN7x8ZeDjOe0ipZVSBKdDNCuq4XDFsVUQc3k/c003JNjGaHzIoQ
         lxMSZXaog6eU4WtT90GDi5CQqqScxczjhGYsY3mZxRCkdenfNViqz2TLMOmbc8kEcKb4
         ZYG2ufbz3yJYZDK2Zn1Lsojvx4NqFaegwQPn8hsx2jY398fn1r9I0ASaMeut27BZIt7D
         yKJRWBbDbvACsNtbsIRIfGqUsdacOOncFO502F2AwzG2eqhN9oV8y0cFCjFAb75HIEpK
         9QRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784307429; x=1784912229;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DSY/c8X4QNDRsgky4WEPtXl65kYd8TI3cwZ3M9kfC4w=;
        b=hiajU0t2GLUH1EdfyJclE4iPEJa9gIhp/flc2vnCtPWZRQCuVE035cPuE1Q7Ugo1W4
         WkxF+cWxxXBdWL7xtT7ArupyMtwJyfjAUjfR7n3Tg84mopis403yQLlUwgIT0+692mvc
         hlB14VfRwQ8uGHrItYtJnlo4gVMwxYvtZtUyX/HlmZa0Kq/oBdMiXu3vwr+sAq+lsQkh
         BpWDXhHnts0O6VZXhIqU07M5wEaQZtmsAxy02FuWA4hKByYnjZaJHySaUP8uqvI5J9ub
         pEAizwRlJtOyDvBebhUXp+4QgPMunN71ZPgOya9GfA2CgnLpPe/kElnb/y0rlGDw/5by
         D9DQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro+t94VYN0rRWmuvMoj+F9URVkPCeyZVsNHUuMNfR6nbDOzl0GdcIqs31S5FWYZxr1izId32Plu+m8f9Cd5yA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1GyEC5I2MbNm4VSuHNGNBUmgbOGIKlI3VgfMdGbhBr1BAvqX5
	ckCTBWx1fCUtGmBAs7EWtJCbcaH4rHjF8j9iU734Q4FdmxbKsfbAx8c3BXTLtRjnlRwR84694QB
	JTaHl1ohExQdklYJYX0qNa7kuwgGsFELr0bDbunEX0Z4Bd8/ePSgsmr81fLE93wlh3kCfTg88b/
	SMuw==
X-Gm-Gg: AfdE7cmg2LbL99SmSMOx2mkcuw7WN8D5CoCEij7uPE5iv2OFYLLPIFb8RMEQOBwuNUm
	z+rbJOqOUh4xlyDQJyaoNFNBROSsT4gN1fTVtlRXJtL5NGQRucZoSRe5JomjH2JHDGzqScUjONF
	5IhWBMKCE2Nh+FVduUa9TgKGBM5ebRWmBZ3L5yo5J0JcRPfy7a3VNmA/+Svf/2m8rAWfqUVhD2m
	fEad3Dx9/U5hHafwQoc2xh+MdtfooePjY2Oi6ZEgikxmvvdQk5k8p587WR0E+56bmAALFbwZHO3
	1+PZRYTErvB+U2amb9v9aNB49EQnuJwvZNGCDA8voa2ENW0qhCRGpnk02xYvjI2eHZ0erUBDlAI
	MdDfmQlbRYoo1DVyMaAlvPOfA2jBYmS2nl3CP9NXkze2+G8bdnkgeEpSrmQ==
X-Received: by 2002:a17:90b:3c43:b0:385:393e:7124 with SMTP id 98e67ed59e1d1-38e4b48ec79mr3712952a91.14.1784307428647;
        Fri, 17 Jul 2026 09:57:08 -0700 (PDT)
X-Received: by 2002:a17:90b:3c43:b0:385:393e:7124 with SMTP id 98e67ed59e1d1-38e4b48ec79mr3712925a91.14.1784307428145;
        Fri, 17 Jul 2026 09:57:08 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a20b1f3sm9002731eec.26.2026.07.17.09.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 09:57:07 -0700 (PDT)
Message-ID: <4c9d3a9f-ba1e-475e-a8df-7afd13effbf3@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 09:57:05 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] wifi: ath11k: move ATH11K_FIRMWARE_MODE_OFF to
 ath11k_firmware_mode
To: Ziyang Huang <hzyitc@outlook.com>, johannes@sipsolutions.net
Cc: jjohnson@kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <TYZPR01MB55561DF4543A0265B47A58CDC9C92@TYZPR01MB5556.apcprd01.prod.exchangelabs.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <TYZPR01MB55561DF4543A0265B47A58CDC9C92@TYZPR01MB5556.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: PJ8q4DLTx-w0gh4oPkcX8kP-tlm8KX22
X-Proofpoint-ORIG-GUID: PJ8q4DLTx-w0gh4oPkcX8kP-tlm8KX22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE3MSBTYWx0ZWRfX8pOia/1TOn+N
 pupSFGZBBmwEQUzKm3+R5ycbeOdlAfyH981rSCTb0nm4IuC4VcoD/GEX82ZF+lSeTX6E/pqLEPR
 XBnsLfFomnogmhT2CQu7RUv5xi4HPuhbi29l8nzAlo5UQChCvxXoLQAhYuRdt3wiPwsLZxeRdaY
 tLdKaQaKsrTaTkbr4MXcXhY7LvkG2/vIK1MUgdMSqK+SQHGy4G0smD/oHPzrNvNo9vIfG3JkARj
 6VE1vJnmQRT6XKXY+SwqVl4eOgzVh1Gy4ao+RrgUAC/Q0NSwZsgZq67XpU/h0NzeDkz8DrPvZKU
 xGVaQl9NvO+7eegQ8EQNxorpGmfZrk1TtvDu1REB0A2BINWaMnwMW+MkXyxt3fkd0uvCPqA6xXW
 m+UHNFDaWA7l9KrExaaAktNY2uZf3O1YGUYKn3iFBlhDb3kM1kls6MwYPZKPOwC64908hP+IE/S
 Y5C9GfOntJ+6HBWirZA==
X-Authority-Analysis: v=2.4 cv=TaqmcxQh c=1 sm=1 tr=0 ts=6a5a5ee5 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=UqCG9HQmAAAA:8 a=FN9edgLifu2y3Mit8RIA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE3MSBTYWx0ZWRfX6B8gMLG/zEH4
 QQIL+P9HdmtjnoFpS9eM2/Z1e698BRlBN7HVGs+PtfuBdwX7mP/k9Org235mVAoss1E2SlwgqkT
 mrpbAJ/1fikRQgqfgZfQL9AROMS0CgE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_05,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170171

On 3/3/2025 7:31 AM, Ziyang Huang wrote:
> Put it together with other modes.

your commit text should be more descriptive:
Describe your changes ... as if you are giving orders to the codebase to
change its behaviour.

> 
> Signed-off-by: Ziyang Huang <hzyitc@outlook.com>
> ---
>  drivers/net/wireless/ath/ath11k/core.h | 3 +++
>  drivers/net/wireless/ath/ath11k/qmi.h  | 1 -
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
> index a9dc7fe7765a..bfa2e8b21b5f 100644
> --- a/drivers/net/wireless/ath/ath11k/core.h
> +++ b/drivers/net/wireless/ath/ath11k/core.h
> @@ -158,6 +158,9 @@ enum ath11k_firmware_mode {
>  	/* factory tests etc */
>  	ATH11K_FIRMWARE_MODE_FTM,
>  
> +	/* power off */
> +	ATH11K_FIRMWARE_MODE_OFF = 4,
> +
>  	/* Cold boot calibration */
>  	ATH11K_FIRMWARE_MODE_COLD_BOOT = 7,
>  };
> diff --git a/drivers/net/wireless/ath/ath11k/qmi.h b/drivers/net/wireless/ath/ath11k/qmi.h
> index 7e06d100af57..5e8fd22bb9a0 100644
> --- a/drivers/net/wireless/ath/ath11k/qmi.h
> +++ b/drivers/net/wireless/ath/ath11k/qmi.h
> @@ -36,7 +36,6 @@
>  #define QMI_WLFW_FW_INIT_DONE_IND_V01		0x0038
>  
>  #define QMI_WLANFW_MAX_DATA_SIZE_V01		6144
> -#define ATH11K_FIRMWARE_MODE_OFF		4
>  #define ATH11K_COLD_BOOT_FW_RESET_DELAY		(60 * HZ)
>  
>  #define ATH11K_QMI_DEVICE_BAR_SIZE		0x200000

I like what this is doing, however IMO there is room for improvement.
the firmware mode is part of the QMI ABI and hence the enum should actually be
located in qmi.h. And that means any .c files which need the relocated enum
would need to include qmi.h

And if you post a v2, use ath-next as the branch tag, [PATCH ath-next v2]

/jeff
