Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821F93CE0A2
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785951458; cv=none; b=aLmacZYiLth7d3opw8CLnjLoIZDvIRGQlep6yrpSeFW83T4unrwXg0iH3AELwAP+9WCgMchL5H6g7bAeF23b7nedqtFXY6zaLIPpsasngfesAjzQr24QzVFVGBLkmbYgEWRPSSAeW89QI5jAg72umqIv6mUGt1sDrDFOfDk+6zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785951458; c=relaxed/simple;
	bh=8nHymJz9Hxwiu1R2ZGOKhk9m52x2+2NplI9DV/JCU+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AmvkGUdSLsNNd0nBlIXy+EOyf/UnXyDumnM6daB4daQMKTBAg84nMZEUKQmIts8BB3zZrejqnAp+HfM53a+uCwndZIUuibOIusEa/07cilRolIECRwgw0u2ZPkv9RRi2OQ/B01dyx/IR6KRh1jZ5QYXIjPFvxqnt2WT8fmPfpBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=knw85JFZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eRhTNqXF; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="knw85JFZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eRhTNqXF"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675HS71w3596364
	for <linux-wireless@vger.kernel.org>; Wed, 5 Aug 2026 17:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tf4LxB/oQgR5MpM2Vnd5nrnEbZ31FkI/3egS5tcFk4g=; b=knw85JFZGjWQz+v6
	PP068AmkKVCnDE6GdejKmCL5uSEyXSrrnM1s5IeFnWEoWEflkOwlbqQ2fl8B6Ca4
	9VJmy5IpC3V2cY6CeRwo2eF+Bq2CYfFAUvNp0EGmKQRsf2Dq4Rq78IL5NHA3xXsI
	Sh1qf2pO08Mgy7K5MQ1+iG9bTRFAbhid659OfkOsDeXyWMKkgLBZf/0sCtvhIz87
	MiugtG8gXvuDD5a7BdSJlPp3iRkrSGybv1WHBNSfE4TJEepLZS6NdiBHUzG+UOD/
	jeGt/UnHkMXfXlPay+xGR4ArzjKUvrHdApTTxhyhzdQnrBqAMqnjtvWFHvYbweok
	/YMF/g==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fv2c0a98h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 17:37:36 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84e3d575d6eso2150614b3a.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 10:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785951455; x=1786556255; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tf4LxB/oQgR5MpM2Vnd5nrnEbZ31FkI/3egS5tcFk4g=;
        b=eRhTNqXFoK9da0W9MNjJEd459L5j9ypIscendaaBLon1Pa+YtJl0dfo4qsles1zkSx
         RACJs/cCFjNS2EpkE/AYe/mVUqDSd7krTaLeblBqd/IoLh57yp1ka2H6XZKtyUUrA/ky
         KLdNTDrBROEXAZK1nWH2lZucB6kCyLqdbmhyH5tkeChSX1ravpFllSN7rmcyYFs1WCQj
         EaLkYra/CXej6gzzM0DU+YSWxAo2iiz/ngaUOZ0GTLKUuKprD0nOBCRiMK1cloNwkueZ
         rDyXlRlher52SynI8Zn8g42BuBUhCPxS7LblbThaSa+7wN3VTvVTp1hAbNG9dPf/70eA
         aqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785951455; x=1786556255;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tf4LxB/oQgR5MpM2Vnd5nrnEbZ31FkI/3egS5tcFk4g=;
        b=cSTmlia/YC8H0fwh8caqLhfGNEQqmgBaIL6Z+41bGL7o5xi+JsI6LARTLNPE48gCRm
         NCRB8/8+P2GLEgglN1IDsnQsXF0pJwdjHLVjkfKdB9dTlqKJRWcH+yr6I8lLjTv0fSso
         yXCYkIECrJ9gPbLlnMAGlnWsb7+y9qgcHxtbnm0d6n4IGdY/xknqBbrveS9XatBAv/42
         0UJZvfhfQpNoQPUWaKUeJeBgA02qtFGWl9kVA+aTxEVOKsx3rAtBi14jY0++r0Zj2LdA
         C+gyaoD8cGs8Ojevfgvy1276PVHTm1yikuYR0Amnxry0GFaED9vJWb5zllWtLCr2zxOw
         dWfA==
X-Gm-Message-State: AOJu0YzWF5Hjk1qTQqtid9YuspnIF9cxBT8R5WUqXOaXKCIbXtkug085
	+qvZZgU/rOsl+ncRfP0P/VBQ32HOeTFHis0l8ct/Bma553iEe5niL4G9T/NeAJWWyRHCOOEMOb0
	KNndXHC+H2HJEdTbc66Fmx2BsvlGspWkilzleX9QmIdOiZugG9p4RLGn3R+f4z2P6Imgtgg==
X-Gm-Gg: AR+sD127/zj6IDvm3F59AtbhyYwCEBiCRhew3AeK521QUDHlQVr3m4tYvpOyMgwH94/
	W/YMQcf9y6D4UhmoecF8V8foNmmWNu0Vn9JGV8e9uAvDM1EWDmYFlb662M/cuCvv8OnOJNh28bt
	K+xfnPm+fyeM3iAHcboDteOnxwIAJPXDiyGM2VWqsWW8IX/MXYYnmoJ/J/pd9Ku95ghVtvDqJQM
	eN36qXddh6uPwP+LZYtWXOmtQU4XL+LHLylPJ59YzsDauvHVsqDYMm1fiYJmtyS4r7eTyQBRxfB
	g6chn7EL4D2yrCSekk1DCpm+NLagufgYWm8EbHJ3wxjHw3Q98xsOB2legpqwyCVV/UIUnLZi1Uz
	5DjTUqgYm9kw//61ZonBCNhLPb1jJSVzK8H/m9c9auTwX
X-Received: by 2002:a17:90a:ec86:b0:38e:bbf1:de34 with SMTP id 98e67ed59e1d1-3903c537a12mr9389143a91.7.1785951036459;
        Wed, 05 Aug 2026 10:30:36 -0700 (PDT)
X-Received: by 2002:a17:90a:ec86:b0:38e:bbf1:de34 with SMTP id 98e67ed59e1d1-3903c537a12mr9388899a91.7.1785951034787;
        Wed, 05 Aug 2026 10:30:34 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fca2e8ae2sm15689866c88.0.2026.08.05.10.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 10:30:34 -0700 (PDT)
Message-ID: <73d62ad2-439e-470d-a638-bb7c5a02f031@oss.qualcomm.com>
Date: Wed, 5 Aug 2026 23:00:29 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/4] wifi: ath12k: fix timeout while waiting for
 regulatory update on bring-up
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: VO4JAR1450_crLWxtk_a1yn6CYrpO369
X-Authority-Analysis: v=2.4 cv=aOfAb79m c=1 sm=1 tr=0 ts=6a7374e0 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=dBmMSM3fNOV455FkuikA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDE0NCBTYWx0ZWRfX31PueA2sWhe2
 QYkjOntLkvSy7L28Yg8Zt2QJWj4FdYl3iwF/mcUbT8LPbTfP1foOrjo7+v2aqRr533A8XGpi+c8
 3r+Ddg+d+lo00+0Qg++MvYP7D1S8ecs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDE0NCBTYWx0ZWRfXzQk8rJRXNY1C
 /b0TmggZmeYFT21qY8yY3VDquRWvVJR9bQiXvT4tzXP+2SAes73MWJ7OSVP+vzY/Oqz2Tu1+G40
 9kh9JVn1SlGVwhJjFTuKX8/mrR8iBVNZHWkn4KFfviRMliTDMFRNGSF5mK+dJB88kq4SgjRL6wT
 ypNeKEXw2Wr5+qkmVuE9MMU9wgg4iFzWSzFcGQCFIn0TORcTnv5y44LwohxH7+ydnTqZFzDQvWx
 1797wPfPiCdgFcX/fjDVFwvChab48YsrreIOMCvDgDAEZFZygi4uYoLl8lC6gm0xyj54H9kx6K5
 pw0L8uHZxdCAGyeR3aPFN/HH83+BvM/SIrTd5IzbD6i55chx5m+NNRC/0KQkK/JqKvZTDK9DSwl
 YdBkA+QleLaSWVWLfYC7a2t2Fe1+CPqCg1CzVxWv/v86tTvbs1fxsdrRGjUeU8GUH5EXekr0aIJ
 XBqZsXtwXhSNYU2Nlkw==
X-Proofpoint-GUID: VO4JAR1450_crLWxtk_a1yn6CYrpO369
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_05,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 clxscore=1015 phishscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050144

On 7/29/2026 12:48 PM, Baochen Qiang wrote:
> On devices that support setting the current country code, the following
> warning is seen during driver bring-up:
> 
>    Timeout while waiting for regulatory update
> 
> This happens when the country to be set during registration is the same as
> the one already applied at boot time: the regulatory event from firmware
> gets dropped without signalling the completion, so the waiter times out.
> 
> Fix it, and also skip setting the country code when it is unchanged.
> 
> ---
> Baochen Qiang (4):
>        wifi: ath12k: signal regd update completion when reg event is dropped
>        wifi: ath12k: use per-radio ab in ath12k_mac_hw_register()
>        wifi: ath12k: protect new_alpha2 access with base_lock
>        wifi: ath12k: skip setting country code during registration when unchanged
> 
>   drivers/net/wireless/ath/ath12k/mac.c | 31 ++++++++++++++++++++++++++-----
>   drivers/net/wireless/ath/ath12k/wmi.c | 11 +++++++++--
>   2 files changed, 35 insertions(+), 7 deletions(-)
> ---
> base-commit: 4fa10e991f77b4c929d1959900a6ed422b9e2ac5
> change-id: 20260721-ath12k-regd-wait-timeout-6403498ae30b
> 
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
