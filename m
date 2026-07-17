Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87ED3271FD
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784253589; cv=none; b=DfagAP/KqBPnibsH3eOJHNMCS3PTAfKpzpTfB1lIu1J6f6nVxQFjSVR5hmKOP5qhb/ooHfA7JLKWUrM/L7P9hsoorR0HHT9TvF6WvWN+RJ4H3xgBGuxcZl9CZ8bih4mhOuHiLs6hXjZSP+sE+Wd2iaJ4YUk4T2D9bMQ7nnj7JVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784253589; c=relaxed/simple;
	bh=NcIMdgT+q9imiH2U6l4O3fpPAs9lq3jLsSexRwF+Vs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kA0Odzr0aLNoeHeZhJcPOYyucRpJQ3mYUASl2thidM2w8LuB40HBCf4ia1saoPYY73eAO4XmNJq/TSPmDU40TN1967ewTRmMPAbcOYaf9YKqeSFoGsOmQvSvzVOvZ329DyQivnZZeaP2kl1a/O//Xdb+iNW/hVbHm1sx93YMH/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Tv2tnFIF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MMCDG9pt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Tv2tnFIF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MMCDG9pt"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GNIiMS048094
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BxTrnDqlKMkDlQHz63CfY1Rsnl1sEhd6k27eGSO+bKU=; b=Tv2tnFIFVIk7RDeC
	JDzFJkH08kOKi1gzcNp3P249+Qx7vT+vT3HEQtzJe1RCepLoG6crsJ+1TYM09lbC
	XyjIe1D0aG+ka7eDOKfFJuvTsyHBvM/Cv0CNeHiUog4EW6amDuafvXiVIQNzp00m
	AzgyqHrfQq7u4yzIw/EHUi26Aln0+JqnBQcy+5ZIinpOcXUCAMW3ConAZ705IiFr
	ooxFd9/6mFZobFjhafR1csR8L6td66gnMT+M6dNmETr1YVxRK/VZtqiliaFdNivu
	eOEO0HTyodlMtbxDi2JQdwgpZu8nnWpoCr/8Ah1fkLHjGzFi0fGurmsOVyEj/Ym5
	xgXTow==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4feve1ux1c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 01:59:46 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e04a53a7aso4954379a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 18:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784253586; x=1784858386; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BxTrnDqlKMkDlQHz63CfY1Rsnl1sEhd6k27eGSO+bKU=;
        b=MMCDG9ptaFljaqyj2PJWJFN42StF+PgRfsGUvFGQ4jJGZYi5WPsOl5ZHA+QBElWvRZ
         rodrQ1g2C4tlLNKYPs2IUdbsAK4rvXxZrsbTti/wVpvSYc0nLtRGt66uGJ9aD4FGacmq
         DkDBS7RCTKmssAEitisysdiiQ2xOSr30K7SS79siFuIbwbCAhJMM9To1QB5/Q9VKnbL3
         cRdLBizBPTXkpSMAoxbenAiYdmx+z3nQgRFoZUhhJ7EnsEaxPWKJXbZ1/sD5VgesVp6n
         w0AoaP9z9KAdMCjt+0SmkoTIvmpabZmDgpB2DmiUIqom2CL4H0UHeFZRs+0Pxcj2APdb
         S/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784253586; x=1784858386;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BxTrnDqlKMkDlQHz63CfY1Rsnl1sEhd6k27eGSO+bKU=;
        b=B9Vrjs0PHwXCgi/veIJrpLw2fu4L8dxkkhw/slsEW2rzX6PRnYsI141O5xT80bcTG5
         XrtGRM50aP/vqJsuYXDEHTHb8RtPh3ooVePI9gRbk7R+Z7tMW5v2NZnZx7jFyiQOxdNo
         nPWS+7uOdJb1yUFeu/umBloZbyEXWR9UxQBG455xYEWRj6zhdS7BwFaLQ4ucEPAH7IOY
         eXsDtX/qpsmtBLG8H45x8ZDMS634ukGe6fNPhmVlyGZtMgZV11OH550wu0hQosPsilhM
         0arR3hMN6U2J1WBoqn43sJcjwvrvZye6CXJHx+h+P6MUNeDUlcxV5UVcCB8kJQqb6Tpr
         UeNQ==
X-Forwarded-Encrypted: i=1; AHgh+RqRUrAyRFLFg+03lICwmmyw0ZoSaHeSZ+N5L6dVUrvUPVj9gCWvrWzJ+fHqQms45c1eir8QzahuhK2Y3RXllw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxY+xHrlPQr1qQ9IzZs6HRVQ/jzqiO9cncw6AAxi9wSQ8xzmRxm
	n/sps3HPmmaZRLpGFS/YrOVsiDXRsrmhoUzQYyNrhOd0PfO0iBmxuAGvg9pG5E5ygkvLXo1Ynq4
	Hvlwj9KMIzIlesJIVTwxRj13yqSVGQucv99UQ77lM7JKkaGCiuDnPJFMr0Q9jR2nSyopE2Q==
X-Gm-Gg: AfdE7ckGUJ6cFOscF6RphkEUYmnUYfxZwjMctQSZyCQH477FEw1jOycR99zVo2KM7yR
	6lVL3wddVkLcG1ufHS4lc/PiRk4qHUW5EWRkOLBZNarVCLjCcfh5VB2fSJCQWWvPgruU2J0pt6Z
	JeyS5HOzGll+a1uPmn/AcqnfjkdA/gbf1RdRnznl2A3hN7UYSdJ7mrzAyj+5nSTH9SDFolgVEbd
	BCrKqc+5b0b5qkL+23yXMxbPKzrq4W0c/5FywUurjicf/VskyUOv2jOscX/2PE7xB7n3Pf5HzHO
	bdFFbeAXU3OdtrMIetbx4OxKVDGhuEB3+87PxG+ps2sfkD90pT1WH2CGP1WTJmYoGDIEt8yaA6f
	zTCPzWdvXBkTaSIdhmtCmS0ulrqNnHpe46L2hoNSClCoRVezxeIXU3FOgoY+iX1YfKdZbRu/Y
X-Received: by 2002:a17:90b:520d:b0:380:534f:58c2 with SMTP id 98e67ed59e1d1-38e4b59bd1amr515426a91.30.1784253585607;
        Thu, 16 Jul 2026 18:59:45 -0700 (PDT)
X-Received: by 2002:a17:90b:520d:b0:380:534f:58c2 with SMTP id 98e67ed59e1d1-38e4b59bd1amr515401a91.30.1784253585113;
        Thu, 16 Jul 2026 18:59:45 -0700 (PDT)
Received: from [10.133.33.98] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e47ff3511sm226044a91.1.2026.07.16.18.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 18:59:44 -0700 (PDT)
Message-ID: <5ce57e40-8fe8-4cfe-93e0-950965c0313a@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 09:59:41 +0800
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
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260717014302.284034-1-daizhuang.bai@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDAxNSBTYWx0ZWRfX+GZDChSQqrMK
 AwyCvVpJvE7oI0QRBr4UxSjm3fw1kdMD+5+MGhv4CdLpcvJrfVlduk2OIxZWraVDsc1FGzhuUU3
 Zzc9l+l4xF285aQYurZLRk6010bgqIiJnunLTEMWIomV7/lrKxUYPpwdqiU4ZGrPRGxyYy4WTWp
 +zjtwFAasJUQlEHpKb13+okRkdqE5u8NkfVFrUSt4movxGSxBOzS6lgG8csGHQGMBSGckPyQK2Q
 kP2s1oFTDkGLMzeC82AKOJQ9UIsHgMDtky10c0cNRztG7e9nX8Wrh5vvDIJx5RPCrx125ib/7Sh
 Z7gHwtV2VTEiqh42IQXWbRkM2zowhOkYILmPY82bR1QL6mm+ztm/YBaAtKUDKug2znyif3UljHe
 DYceVCDX8NHVCKDeBt0D5MmYAULObKFfcKspBvuFXc7jo2tS0bIFO8gY+s/N8SICf04Blfkj2+4
 gHrkDTkkfpjhz6UJVlw==
X-Authority-Analysis: v=2.4 cv=DvpmPm/+ c=1 sm=1 tr=0 ts=6a598c92 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=PIsBSLMAwA0o3fhTwyAA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: h67a8SRbFRsJP8yNVM-apJaaUlo23EdP
X-Proofpoint-ORIG-GUID: h67a8SRbFRsJP8yNVM-apJaaUlo23EdP
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDAxNSBTYWx0ZWRfX8qWsvV50BDCq
 5POaPcjLxTpLtnRpSSlJJB/sGLyNGrUgIZr6uQ11vmdLf5At0sFTfELdkxT5yFvvGdewiE6yQtt
 FHV+Xr9VuSJCCaRRqQtMhSkM0cjBThg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_08,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607170015



On 7/17/2026 9:43 AM, Daizhuang Bai wrote:
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

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
