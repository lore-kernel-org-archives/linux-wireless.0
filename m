Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792696017;
	b=j0uI5l+saWyTtoY0XMOovoca67FrSgj4Rh7415UhZeUeKfqSl5dYKOnO+XGpicwga4Nu
	 o+5Ac+gcaPcPIxbReg3LZLBwAIxvgfHTyVJS0N+dUaAlljRf06ohfLwDak5gFQoXh0Cct
	 Kl5sFnbmioRrWCnvz0I40b+0UFFmfaF+fqv2RPWZo/Gx2L3oXLzBn39bKsjBrsv5qWRnV
	 Zvh3t9yKadCOoHJvjyKtl7UWJCeC82HbWD41zqJNYYg6TXDONHsH8lVae5ovam3W84LHG
	 b/JSAZhRu9QohzeigsqO59kFD6zUcP7o10ADh7JTS4XVN2zLYsaCNPQfTTwyUux364w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792696017;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=WP1RCtA53459OEDtUvLHcE9mHWBQjuh3IU+rXf+WXSk=;
	b=AhZXcBhKYSuXg0iP+uZgt9qvolRndW/pFynaRoal3lqvMvT9LVcbiaXo8GeaYtkZCciK
	 7FALqFuox7A0rz1nHgGf4EaqB+Dmgv5I4B2fUgokIOqOcZTiF9RZCWPc+lCufJ5LbdfKC
	 U76WlnB+eWVR4ULx6ig+VhTRGKnUNO3dcuz7+Dg6tmYXlj2kPsugh5W3voE5dT9IF3jkm
	 /aUCPo8Rb6gtR/PeuTvxUVtzj6Z2qNBX0Tx1reS2/9DezrY1Rx7aNwPciOyN5hP4uVwCz
	 PMptg787XHICLzjRb0MEV6wbG58mnfYvL/rWZ34odQ2zzb3NNDWhfnoS6UhTTiykclg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=BIoNqwJo;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=P1T4fCJp;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB19606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 19:06:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAB19606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=BIoNqwJo;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=P1T4fCJp
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69MIH1UD1509607
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 19:06:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=WP1RCtA53459OEDtUvLHcE9m
	HWBQjuh3IU+rXf+WXSk=; b=BIoNqwJo+9cHw/AmG/yoh2Nuki7TD+lTLAXEY8DU
	yqVhor774k3lFGuWtN2mJZkBFd1iDm09qQlX3EFldoIGWgUvY7vBvCXtLil2PWn5
	Wjk5LYrhD+59pwSlKUNqRz5FF1UPTbLZuYJVEL7RrZjPEisHOZW8TY2ems8ZxAVc
	Z9YkyY7YQxybQG1DUqAViNSM9Nb8dUMid2Z5p3LSKZmMZ+/cqqLkXEdcKvYl+kcf
	egrlF4OqlYtMf0XUl2CkZ6aSmMG8Tz5/iKLjn5ZXm2/7mxwn0cznuuWJDkeQy1sT
	Pj55wKPqvU432hIrIXn9ZZj+onlLGXmXzUT+mQd/PM2EYw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfqmp86es-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 19:06:55 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93dd3c3badbso20405285a.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 12:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792696015; x=1793300815; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WP1RCtA53459OEDtUvLHcE9mHWBQjuh3IU+rXf+WXSk=;
        b=P1T4fCJpvwI0i5E7GuE85/gE8tjt4fzgFMygTpfYFMpZLSzFdS9z7nMSBFGq1+XkPQ
         Bqtf0MyfjavXDCt3CqmDTSHu02YL8kST6kO8OZlNurGfgtpsRPctjQcQa/WfrW4zczeN
         qavoissyiEPDUazja8UhPfLQiWjD89XmyB3iLTs9Z77Zxg9GBoyoHQm5fvynRtDstPog
         oOvALKB2tlOhYWGhvHqdG8lXTrI04dHFOHMb/LC4fswJ+sVFmpv0FnCR4iB9FPsZ+Jcs
         erCkIeJiG0OgskvIsHJ4jKu5G+eSs0BTSK/0/93iS85bFgAYy9QjOj2jzRaYr+6gq18B
         7YLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792696015; x=1793300815;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WP1RCtA53459OEDtUvLHcE9mHWBQjuh3IU+rXf+WXSk=;
        b=Pvz/kieJvp39E5z2TAnB2sqcOCqlML4hmkHgG2vSW4cfhcUflSouDkmEHaW1FRVhVp
         YKKbCzoFAOXXPqTHMSG5l7wTR0iaMLB4D6LxotQmp/1LYT8k6dps2XhgmJZQQnkh/E2h
         8Kay44YzhgvtFGDnAqr55WYEITPTxG/ymD91pYvVX+WTDwd+Za82G0ryQinijhVGyFYX
         9yvPFTKJGcYB2oaI3HoHowE1MFOWXrnKDKDnMPWWocDLGtxABwTGzwjeN6oRWk4umn4U
         hF7VJcfeWTq491NCxCzgoJtOaAiUe8CmPQ6FFgdqMtRIHT/3FzgAzlJYhT0aweO0FlYO
         KJIQ==
X-Forwarded-Encrypted: i=1; AKwUvByJ5TL3As3NU4vQvrzaT01+YrXg2DCwc+EMYhY608cuxEqZncmeJ7t7daAjh1WX0G3hFSbWwIHa1BDcknpAUg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLEWgIimZCeFFBJcXWyI1of7DdABUPk8YlHmhkXxMOzG3On84KW
	j7CJCiIU9qSCHAvZMhCi9YBNgyoBFMnYRBqkXq+/TTsn55HYCQDrZVTqMT+5VGlGb383EQsT2GE
	J/cdi3sHDtJRR8RN2aDDnaFNbOXxeQiufp7QeU91/tF3Q4JpR+jkni1oaEfrzrtZGShY6mw==
X-Gm-Gg: AYBFou16LnefdDkXLubJ/vXYdvLz8rejQ0P8Kmt5CipsFdDm5yo+bzjSB/oI32T+gI/
	bXxjibLTOp67VPUey8iNoJYEHZ3rt3oBrq8ycNQISlVWSbCcl5Ln6wfeBysA2Wg172u5HSD9SE/
	IoAOeSakuiISyS4XuQMfhr8qJzcl27eFredyFPWHfqhMb0aiaV57STvp1a8gSWJ9AqlJvl0xsV2
	50XT8HS5Wu5d5mn2MFaO9FfkVv79c3Hq3oP98nddRJBYXvTb8xW+0eZ2sRiuwI5NLXx65q89SaW
	dgUM14Knf04xdPaQ1Sk8iGWvDWliBqNW8rJNt+NXRXg3pTNOKwHyP9k0p+qZVn+NRtCvn46+tPL
	EDNa8AvRL+IqxU0Zqv0zaZphN482OQec7vaOm5KxYw7eN3zjQEHKXf4Y5/llZOR94IGtfYQ0OT0
	jWQYPzJKDhxDTq
X-Received: by 2002:a05:620a:8389:b0:93c:c73b:39ed with SMTP id af79cd13be357-93f6f7c4facmr64322985a.39.1792696014903;
        Thu, 22 Oct 2026 12:06:54 -0700 (PDT)
X-Received: by 2002:a05:620a:8389:b0:93c:c73b:39ed with SMTP id af79cd13be357-93f6f7c4facmr64317785a.39.1792696014437;
        Thu, 22 Oct 2026 12:06:54 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfb02a31acsm14215e87.81.2026.10.22.12.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 12:06:53 -0700 (PDT)
Date: Thu, 22 Oct 2026 22:06:51 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: Re: [PULL linux-firmware] ath10k, ath11k and ath12k firmware
 ath-20261022
Message-ID: <vicvgdgj3hc72mj7q2bp6mdskwajufdexr3gz63v2ixrmua36b@ojvj3wo2j4q4>
References: <b1845835-415b-4c20-91c0-fdb23de1e1cb@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1845835-415b-4c20-91c0-fdb23de1e1cb@oss.qualcomm.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA3NiBTYWx0ZWRfX22C2D2PbcPHu
 D9A+QEOpaeTBoh80AE2vyH1Q+nE/73D/FdEWRc9+JHIYdsQ0+chMF1gBwAed2CDOSg2E+jOOYz/
 iJkGkT6Jbu192Gzhtj39UHMaF6MFE5Y=
X-Proofpoint-GUID: Q7dil7AuVEW-QN_vMhnfd-ttgxoKkVUp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA3NiBTYWx0ZWRfXyWGmBAb+aCbK
 T8SMt+xgvt9KJ4cP1Zd6DCwwzrgk6xd2bEgIRF5aw+JdP/7o19vau+OserUEEXFgsMWFsXMdDDP
 igVNO7aMEyNyjiO1rTYvC+ToDxi+gA+ZEGodGjGGK3kUGx3eU/ZMjslzlnXHz5ikt7z5/iXZ4UL
 PJMWyK2pyGEEMbsDyZZ3L10LvnnYQ9XLg2D6U+dmNmYEZEyVz8sFY8LIJX/wKoC8RJbiOZckmGG
 VenMF5jD0cktn0XuOgzLlA68T9mveBXJDZip0n4azLyH973agyqPki6MYZrc1CuOylrh+qGyXZ9
 KspqNjAXDPpgLMcteFWw7onh1cA0PzUyzwrDBm3VH4hz7+ERpoz8SRxbp15JzSS98QoibgNTR2k
 PqKGp2W/XMBEejl1y6hNofOIwo09LkxdiNgldfxStTmC65VOfZi6Km0I0tKLQqAY3o+TM2sTohY
 l3tGac1zAyPJsjx+lPg==
X-Proofpoint-ORIG-GUID: Q7dil7AuVEW-QN_vMhnfd-ttgxoKkVUp
X-Authority-Analysis: v=2.4 cv=BdBNQbt2 c=1 sm=1 tr=0 ts=6ada5ecf cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=p0WdMEafAAAA:8
 a=u3i0YCyx4Cyti68HAGEA:9 a=CjuIK1q_8ugA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 malwarescore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220076

On Thu, Oct 22, 2026 at 10:50:15AM -0700, Jeff Johnson wrote:
> Hi,
> Here's an updated pull request for ath10k, ath11k and ath12k firmware.
> This supersedes the request for ath-20261021.
> 
> There are no changes for ath11k or ath12k.
> 
> For ath10k update WCN3990 shikra/wlanmdsp.mbn to WLAN.HL.3.3.7.c5-00226.
> 
> Please let me know if there are any problems.

Thanks, merged and pushed out:

https://gitlab.com/kernel-firmware/linux-firmware/-/merge_requests/1319


-- 
With best wishes
Dmitry
