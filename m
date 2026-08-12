Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F6044A3EB
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 18:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558941; cv=none; b=fmPOf/G1HpAgicC0q3NdqNPh94oVqctk9kNJNdGZePHLDAsuoS0Bc4F2C4dwuxp1TQ0U+KbHVC3D4CHyTJzNaSKat++aNXvytA7gM639V2FVFv6+GhkQ/SIO5iTZMVTPaUv08NvTrBGfbUeHs759Uig4w9AKeQamRtcIFhsghP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558941; c=relaxed/simple;
	bh=pnD2BMNmuRWB0tjRfmGo3Ky0O8Mz1oGs5qiUrMbzrsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MqdUduJHYR8e+WctI1Zm/XTBqsHHH2cFag/vkoV6x9CcrzhfQ9lGN/RFLDEWW7S0Pehwy2BlV0l+pXuP+UGMmCZs2X90vm/eYNMmj/Mj5v+x5hyxwXV8j4vcIoriegEPJcTDa1VzqTtCJYX9sijao0PWSN0rDUKf4OYymM7i2yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RNoO8uTx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=faVYlBHK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RNoO8uTx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="faVYlBHK"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67CI8sOr3338074
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 18:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=BTpDCdHVX8oh2DPLWNozYILl
	YQ0f211QbctU4RV5Ejg=; b=RNoO8uTxebvsNptxCwD3Ns0BjS7IEodYyNlciKAf
	PBFv3TMp4F6Edo9s49akYyP79KoGii8ogmQfP7SCbv5EBgZzM8RUSphkFbYJgiNA
	zrlbATQcMLuEd520TIyKqJQ1iG/kYyXg+e4MyCMOdNT2NdjmgdAB6PUV7+QVLN3C
	v80I+4BHI//muwfwug0CdLzLrHq8LjQf3sTIEJfgA41HMbV13ADjOP1tuLB/r9gg
	fNlpFZ1eAHpcqK8/ibaeEkybHhKbKmtIR6aF7wRxjlLZA2dSzBBClsS0K5qVg3MK
	sYl2E9rxZLA8wRNYPX/XDmkk9g/itU5cjsBYJcNf5ztdKw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g0hfw3hv8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 18:22:19 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52d28f8737eso23992141cf.2
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 11:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786558939; x=1787163739; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BTpDCdHVX8oh2DPLWNozYILlYQ0f211QbctU4RV5Ejg=;
        b=faVYlBHK7JKA1na/hvuraxG5x/ip3TnU/9oseCVX2/Bjch4oQ8L6lQ1FhANO63A+b9
         PdPamsu1yLm1MvlqPf18CNkttNVcE8MmvPjNa6KwhrS68nL5qhAxDQ5SFBxVM2mDlaLs
         +B4giJy8DsAWufMJ9BreWwy5gwWZUjg2Nx9tEM9zs7PGCUG1B/IPEmkK2vHl0RncqTWQ
         1vBeNlgoo9gf3p8ttK2rg2mYBYHymXpZDOhb35FK0qfjtdKIQ/wyvcLsHKWidMrvmlAZ
         rnOMv464Z6nPFPlFiEqyYpY6Ga7adQoEm3cYvaUA8rdnbE0Z3wy7krzd+XgmJbBcI7Lb
         31bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786558939; x=1787163739;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BTpDCdHVX8oh2DPLWNozYILlYQ0f211QbctU4RV5Ejg=;
        b=TI4AWZDimkLNdb7sZ5ptE2XxyzsXMOssqeKz0GnoIrBbS2Oi97JLymHo1WVEaqGhEg
         MaaSgP0NMEGLYIanDN+cuGrev9TC6zkFhN64idI5M6Jantrc/6festdUYhPuUgv3gXam
         B0sl+8uHVRQ6EBh3+rKRo/zLn7Lf371p/37ZYghkDe1ImuxDx1UzGccJ+gS3cmc9BKXL
         wxYVuZNkaJKOiS1oHBUxepIxyo0HSEG1B7/KQYun53MPPzEWO0LUQWBa4k+7vTwFubwJ
         4T0RfSjCoah57vReg6Nh2C7c9WN+I8udJOP+7Gq2gj5kbqs6vLSysjOBUQIcRQ4Kb7xG
         AMZg==
X-Forwarded-Encrypted: i=1; AHgh+Rol2n4CIw+Ld3tTQhNTOsDfti5KTbeeBOls/MT9d4mNFRt9capaCEFk4PEGZd/gUc2ISRA6uvX64+Im8f2oQw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6zDLRYK6L0B0+6Jt2YsAvvmVmLoppU3LiXylzmzPl4aAMWnu1
	/7EmPAYi+OBRFeOE3H6EneEDvMJvOrvVNv1oRz9V7iSbfXhYikpoNb5EnZzz5RF5CIRX3YWsUyQ
	9hkoesJ/vzWud3wtawhshVgAUAtwSDn1FVr3NWjW7hyWPWtLVdlY9K5aEG64XO8NMRLvgOg==
X-Gm-Gg: AR+sD12LQc46Snx5bw6rJrYyuL/14mQfZcdbm1U9d8F/tWDr7Euw69KPdfoF1EdKTUi
	380QegKzzMRivt8EmqzKN0B42RRTTvPK4K91hJSY9sSRKinNFfsD82LG0q/ZoN6ZmJCjSYFKj/1
	ze3f9nZQLvxiZ+IRbQkmvnF38Wfas1pDWBPoTqZux3w42QcsUxiSvbLaCy0OTiqp5t7a5LK/bC4
	bcHH1XTYwuj2FDVMNEVdSokI+VhWgj2PcrSZdGZdlcxtC8YkFo3JGUzsI5yr/2WklNFH2n/MmX2
	Q5yModLv11C7VEwpf2GZvpsRTzzGYjyFlhmpz1wpxZDsoKjNABaxe/wu0CnxDThpAjxAqldCYtg
	ZGXJJ6fQ7xS/1uC328hLfvF8Aux0NuWJx/xJx14zuTyiW0EQyQaSpYRJTVH+RwOk2qPex6HNFXR
	yrwU9EzHYzOQuM
X-Received: by 2002:a05:622a:4c15:b0:516:e249:e30f with SMTP id d75a77b69052e-52d73df0ab2mr834061cf.42.1786558930133;
        Wed, 12 Aug 2026 11:22:10 -0700 (PDT)
X-Received: by 2002:a05:622a:4c15:b0:516:e249:e30f with SMTP id d75a77b69052e-52d73df0ab2mr833301cf.42.1786558929327;
        Wed, 12 Aug 2026 11:22:09 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b44d0477desm659199e87.74.2026.08.12.11.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 11:22:07 -0700 (PDT)
Date: Wed, 12 Aug 2026 21:22:05 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: Re: [PULL linux-firmware] ath10k, ath11k and ath12k firmware
 ath-20260812
Message-ID: <rrkoosnnkdkzgbqzfmpk3uwndoxuvfvanx2kjy7j4rp5ch4rop@wujgojy3qxxo>
References: <7736f627-e80d-48f5-a11c-97bf81597d6c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7736f627-e80d-48f5-a11c-97bf81597d6c@oss.qualcomm.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEyMDE0NyBTYWx0ZWRfXx6e7BSsC3iYj
 pm8ZUcDksTPGeiL9+2aieJZ4YcCsyVhqfj0cdbSgsek/YG4tWnwQZlTsXXW/L/RmmF0lBIePe3I
 lvkB4h4+zI5mvLVG/hgtksdR0jA5RTY=
X-Proofpoint-GUID: hWlxYhEhAMyGpS6C1m8ehdiaSzUNhyDz
X-Authority-Analysis: v=2.4 cv=fpDsol4f c=1 sm=1 tr=0 ts=6a7cb9db cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=p0WdMEafAAAA:8
 a=W2b0fEEQJ4TDHmAVsWEA:9 a=CjuIK1q_8ugA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-ORIG-GUID: hWlxYhEhAMyGpS6C1m8ehdiaSzUNhyDz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDE0NyBTYWx0ZWRfX34DNSo4JN78j
 EzlO+Xiy0OM6rrvZYNJ2Ggv7TFpgiFbnFFuH6mH2jYR00YysVWGtNH81swm0sTUgNMyuZrMIJvm
 7JYghUtRC9HzL6rjs8jzFyhf5HrP0LTCjJXZPwhKNgAdSBQlPjHOnJGAdnxYwtokJAtQoIJixWw
 Ecg/6qHNLDN49uO+SjvdpxtWC7DUDnIXnV1t53sQ6yam0yFdA0Yg56E+kHhWnSMrM6hzrJ0VwZy
 4GZ5Z1ExkkSTV7+WZf5L/Yv/mc6f6BjsO5hKXD9dD4Lb3UDLt4HH8eAi3YpgxuDeg921rLLGjq0
 pu1HCs/U5EQhmH2zJZI3nW1tvZamvVgO/0w4b9U1OyitUgAqbG8YK8wYivHy+6FPp2dlqJyPCGJ
 So1EwJ7WgiBIUUeykSfQjasKdHgPVeRBduW4sOVN0Lsq91OxdTmrcDizetsfTqdQ183KhNNGUHG
 UKR3dadjgNWpAUDkV3Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-12_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608120147

On Wed, Aug 12, 2026 at 10:44:05AM -0700, Jeff Johnson wrote:
> Hi,
> Here's a new pull request for ath10k, ath11k and ath12k firmware.
> 
> There are no changes for ath10k or ath11k.
> 
> For ath12k, update the QCC2072 hw1.0 firmware to WLAN.COL.1.0.c2-00228.
> 
> Please let me know if there are any problems.

Thanks, merged and pushed out:
https://gitlab.com/kernel-firmware/linux-firmware/-/merge_requests/1177


-- 
With best wishes
Dmitry
