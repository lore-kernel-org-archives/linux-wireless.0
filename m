Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792509656;
	b=YkuBVF4dzf7a6pzmmiNxPRbZQzyGvTbO6/HabJuFgbTPd2c9RlJJkM0RdPVzVG/nCROc
	 iX9e4NCplb04Qy+5mY4s1D9U6GS0lH/oB6H4yOObzLvKaMCMX0lCRwM0bTZAsPjax9M/R
	 9ynY95xfQbo6R/U2NP9PlYsE7Q7qGxsVV+ql65wgTjX96w9Hthgjvpg/0JFbCjbuA/mDM
	 CD+vxqUnQBSLY87KSZe4nbwuxhrLi0mQHNDhbFZOBmgXJpNWCb2zsOfK9x9JJ9jk7+1G1
	 3jDfIhlv4WVTxrkwqDlatFzbKHqCjtIWyjCgF7Jc1WfghNCDlpaDGK/t/mFIxaHVFDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792509656;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=maTKDyAADFzJnMGIlNBELxlzoor652/0VlIWqEKmzxw=;
	b=1Fmjsp32setbJMjby1bCTh4koyZx04N8wQ+bp6piTj5/g2VaT6c4Th9YYvgAkhJARm4n
	 YVwC70BhxwE7SwkuEsHN546EFAoSMLlVCilfihBH3hgKHJNoWMk5nE5k2vzwZxKXq3xId
	 RAvZabSpn6F1m8pRec8ixhqF5oriD00tXWJSL5jNr8lMctmc/WGen06ClE4Vsvh2FBjpP
	 SA0hPctzEy0UEo8eL10y2JA1RKt6ktJcOAt0noZOV2XFIMVy0DZBVKtRqGeMC13eZcvZc
	 vs3RLU9NX0nJ219NcRjezm4BHGdy7Wka684CQo1XKYeEROXPrXgc3tgPLw4NqxKGJgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oQOLkUpd;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="Ho/Pye/g";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C99606A31C
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 15:20:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51C99606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oQOLkUpd;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Ho/Pye/g
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69KF0rlq1975619
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 15:20:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	maTKDyAADFzJnMGIlNBELxlzoor652/0VlIWqEKmzxw=; b=oQOLkUpd0m3uAw0Z
	qpBP5eX0If2s8auLavzRyIyLQh57GCIj4nZBMfIRHqkdXJCSIApk0POJJweoRcy9
	XFwqF1gE3GOz0Ymh1/8Sp/RGDegRDkHiKVdsgwNB/hZWmjU47l18ukI5EwznS7WP
	gANQT8zLpwND4VbBYXY5WF/9aCzGTz+l5MTB3WY/F/WFsgQ4ksCOIjNqoLCuugEe
	+YHzCRKDE7UazzP70meNJasee6LscEd72VgWnusthlB3L3rR7UiXkvW5qnzyR8hf
	XOoGKSauv0jJs7LU2m3gClSVeSGGboSSDiOlHTGqhf4MP04GlZU5MPWtxM4N7Tqf
	I5tfGQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdw5n34vk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 15:20:55 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3aaee1fc104so5011391a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792509654; x=1793114454; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=maTKDyAADFzJnMGIlNBELxlzoor652/0VlIWqEKmzxw=;
        b=Ho/Pye/gVlbP/RPIblmTZj+sT05hK7f+kWhv+Q5hUYqDK32gTTopVE2qpYcjfx7XJ9
         UpMSO2cLpyAfpxFl3HCmbYXKPD2fU3M0fDssDun09oysUIq7TN7pZu/pjOI/gkBLdffe
         7yS2DmgBiKmdWeL+d1Yo6WIdHBKfZ8i/UAlNlY7LDx8BTaT7htSAYWRsWKOlEqOrQL1f
         ppjmhCQIFymzgqpYIWlZXauVSsvkhuz54ocVwLWX33ltzG2Dr0kInaLAKvhNuAm57MU+
         w2fi5YQtt1jK6VyAlxdUBmkjncz/2Vtz/lSIln0qUjuNK0SJILPTg7BDVdw3+sH2/AIk
         sw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792509654; x=1793114454;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=maTKDyAADFzJnMGIlNBELxlzoor652/0VlIWqEKmzxw=;
        b=OFn7x7ugD6jQxtbQSrbkg47Mfppa8nCdl2jttU96V2ZdVasQO3tfL9JdPIeUgRdj0I
         3JP3IX2pB9KIpBhIAnsvwo+g4yblETsv6tZ/0gZEzqJsSRXEoSsAN2j0rjscoXGfGo5q
         RWCI5hCnT3+NfFmZ72oMrN7gNNIG0GwIrE9dp4dga5kFs9qiQlmRuRbQCbh80GRrfXsI
         0UQRgi62NCe+cSkTTU6WtuPniHnsDP/k8aHmQfi2fjIseYSwgPxgizGYNvSR30DgyyNW
         50bXTY5Dl26CaAzQQWe7dwjuEpI8j8lFbln/99b3xcHa1JmNA/q+taoWgO2TjufSHLpy
         U1+Q==
X-Gm-Message-State: AFq9FYIOjd8fD0yKzjYfoQtCH9wDEdWQwtZivsO54ugmSv0EHlDGYikc
	/nrP6GfuvZVE0Hv43xSyT7m/pxPa1MnfjQhVxZqHFBipoc/meeigP1h4dIRSBmhsVX3KTyAf7cX
	XW2VtL3BENVySxKVsGuVl8W05VmU1RP2JWlLORPAt4eKoaO7bujXPi/XMsdfmGU5qYRqTag==
X-Gm-Gg: AYBFou0hB/XD/Bmt0Lsg5ioUMTB3wc+OMGYiq0UDzYoYAP3wfQKDE1doyCEII6kDiQ8
	jyuGLp0+UgPAPDpYU8jDpXHYijLLaqi5IEG0M5pQArZgb/wBXkn2ea+66+UsvT8vlA45u1d/kau
	JJOlS8IJ8r1WLEZsk+UBNfqVBJOIIJvHSzPbutPQx6yVXPLXDfPPIiGwvo21iRPuhAl0+5bJTx8
	IkiRUNIBc7CewGy37WSwrfH6PA/scqNFzkq5f+AlPTsjKpgRGrVf4/KP9SizStHsNdOCxCdmvhx
	clphaUHg1/cxbmI0pfRk80EGX2wT4beYoX2rjblxz9970WT6qgLG6hW465VVVYbGrqkS4lfDGtA
	AZgipvk3nh6VHz2viEF8ecg0xK5/UMwHZ/IR1I0T8rJyk3hrD61EMRjRJZQ==
X-Received: by 2002:a17:90b:4a0e:b0:3a4:b0f3:6597 with SMTP id 98e67ed59e1d1-3aced88dc1fmr10765515a91.0.1792509654077;
        Tue, 20 Oct 2026 08:20:54 -0700 (PDT)
X-Received: by 2002:a17:90b:4a0e:b0:3a4:b0f3:6597 with SMTP id 98e67ed59e1d1-3aced88dc1fmr10765390a91.0.1792509651496;
        Tue, 20 Oct 2026 08:20:51 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad8029765fsm63462a91.10.2026.10.20.08.20.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 08:20:50 -0700 (PDT)
Message-ID: <9a1272a2-a827-46dc-a2ec-50afc12d45af@oss.qualcomm.com>
Date: Tue, 20 Oct 2026 08:20:49 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath10k: sdio: Use pm_sleep_ptr instead of #ifdef
 CONFIG_PM_SLEEP
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
References: <20251219173217.768713-2-u.kleine-koenig@baylibre.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20251219173217.768713-2-u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: jSok9r8cpEKFemT-4VUoIEFVDGUCloox
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDA2MSBTYWx0ZWRfX9a8u3XYa6PJV
 Iwur5Cy2lwhYSpLwwN37xa+h+5aifbXcygIuGv3pbiKN3ByN9yJixd1m+4COvSHiQSzYUPb0V6D
 dkezEJgwZLbafqoa56NNLdmiI8uVP1w=
X-Proofpoint-ORIG-GUID: jSok9r8cpEKFemT-4VUoIEFVDGUCloox
X-Authority-Analysis: v=2.4 cv=A5z5rKWG c=1 sm=1 tr=0 ts=6ad786d7 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=IpJZQVW2AAAA:8 a=RqDgkBQ7Q9aaOx4vuq8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22 a=IawgGOuG5U0WyFbmm1f5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDA2MSBTYWx0ZWRfX+WHLJT336drm
 jLxQNLeZvJFYMOut99TjqQw9f1sFXZeqLeitNJhH07IQlcA7j9e211n9ZvjK5ei7ullarvyV3BA
 74VWZHcIPaEoqB+dcOZlYqTcZ/wbRPaNDjkX/rXFacOxTzXasOx3GAsDjMhiDHGMGDAw1xfqfdf
 +ih+DTeHVwDwMoqz34gne56Vj7L8lqa60Pu+l7YEkEEQq7hkjE1lGMzNv+w055wG0X/IuY4Iynh
 asRcZLufBJigmr5J8MfY1fuPEAxOI7Yc1bxUhl/xnhsuXEfrMXn453JQrdMZ9n+LPc6pTe5+e7X
 jgfAQmHKxTdT0o60xm5zKdwyD9ZXVYrSl6qmUgYQ0LVMkwdGUC9V7CmLA3jTbX+xvm5pHOIaaJe
 WTasDUCI2dnGY9r4JqcMEk85H+KQF5QPSl1tBbc1j7H/XS7x7DG1kIW82bE8VMB9rk/6I88GEZB
 bTo9lWZMA3FlD4ZXfUw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610200061

On 12/19/2025 9:32 AM, Uwe Kleine-König wrote:
> This increases build coverage and removes an ugly #ifdef block.
> 
> To prevent "defined but not used" warnings use
> DEFINE_SIMPLE_DEV_PM_OPS() instead of the deprecated
> SIMPLE_DEV_PM_OPS().
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> ---
> Changes since (implicit) v1: Switch to DEFINE_SIMPLE_DEV_PM_OPS() to
> prevent warnings. Thanks to Baochen Qiang for the hint.
> 
>  drivers/net/wireless/ath/ath10k/sdio.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)

I'm (finally) getting around to picking this up.
ath10k pci.c seems to have the same pattern.
Do you want to submit a patch for that?
Or I can have my LLM do it based upon your work.

Your call.


/jeff
