Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793102717;
	b=334+b/RfSh1i41bv7UrWH7h942MSmVPrtnfOOLS2c76o/pKNuM1LjVX0nwnR6KGtbpgU
	 /ojAvYSxAg4lJRFMWwpVPI9YtpXDCY4sc/iXtWAzA54Jc8RCe968sdiPzlgRZIdAUoXD4
	 84jpShEJUsGDEMMVpLMwZjeT2r1il3TyK15H6qhRraN71UwD3l05MoKeTyqpzpsU9SEBP
	 PjHhspvO565ww89q4KYcEEUrX7Q5C+5pItgmGca9CG7bDGlC4fORWeqce+xBzLS0pRRSz
	 cBagXuI5X98mxNQcTpI9O7AC27fWOlhR18SrU4v71PHXrj4UJPsCXF91rUEmBznfB3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793102717;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/nGrw5+P3Y0pEQR3QfmVNANaa580jD8MzWmdSsoabTc=;
	b=ofnV+gQkU/TGl/DvPJ9S3wHdyOzsLZluiqiJ1WkUhG1xf0gT/FBpxzByXlGlYfkRbrsi
	 9IM7jqCWX57gwoNzDssjc7/e69A49F9X65a0FKzVFfcV00UMgwwhgx0IhW4ItS6/mLly8
	 uB9u9HUJzx937VlBOE2jaKLsIusObew7NGCxSRXfpZNg5reJwRbBv5g1LwICr+t6lguR+
	 WwsPPZs0pGaKJpnd7Fn6GNm+KQnQrTxjKAic/hRfAy78T8Hls1iEBCZRRpcBLvDdC7FXB
	 D/Mxh72wENuwQ8MJJmeOGk096QScdrIjEsKkAQZ3LBqbkL/2Y65GY4sGwQ2Hb+cRDyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dNk+1EAY;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ISzfUwdn;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F02606A326
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 12:05:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29F02606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dNk+1EAY;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ISzfUwdn
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69RAe9YX432935
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 12:05:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/nGrw5+P3Y0pEQR3QfmVNANaa580jD8MzWmdSsoabTc=; b=dNk+1EAYHKu1SkT5
	NZaJqZrSsebaw/pG8/B8UGFtpN04c7sFTDsnVYp8VJeNtOAFONCavKky3Jw49gyZ
	HgiALa8r0pqhmWwL45lfha85g7MsIGCUCbSFjxZeCp+Bf/N+nnBY8TAy7eKl60om
	TA7lSbQt5wScaYf01w6pRO4jth1T1b+/rBPyGUwBzErUIhoFQVzjHViiLdJ6hNLN
	xE9B83B8TojrqLhC50iJvii9sJ3v3bd9NnasTdvctEL3eR+GyIlEi6rtyex92rs5
	fmjhwM082dn9r20UfvaQEvC4yKiaGn4M2aF8JO4Pl7UOhLMkw/6q+JtnLxw5zI5I
	YCr/GQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjb54kp2y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 12:05:15 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd68b8579f2so1599491a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 05:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793102715; x=1793707515; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/nGrw5+P3Y0pEQR3QfmVNANaa580jD8MzWmdSsoabTc=;
        b=ISzfUwdniHXo22vGXYz2Qu+ItSDxGTHnKxPUmJlORFI82kHcgadQM3PZT1euYdBEIH
         YeVxH/ehtdCWM8xQbi0qoEltQuyNzqkw8FLq2esDtlFGGZU9GCPJ9F+yjDITgjjaw+kP
         wFUt8jrJzmR+2Ife5sOrgwzJAv35z4IbtV9XwVMC/4ZGVZf6PjCuuvwhNWiEj24qfdAl
         FtR0N+Drqf8PWVHQsGEY0can1dfsZLyTbzd+rb1XxLjAowyjNYRkQQHoUN/cP1M7wUnt
         d1FadP9vCAOIIybjW7uRO/rJAVKurHsSjSU20G4dCEqaGNRXy8rK4e3PwusseEpOGe0H
         gHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793102715; x=1793707515;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/nGrw5+P3Y0pEQR3QfmVNANaa580jD8MzWmdSsoabTc=;
        b=FKS2sHKqHLpgFjVDqRm5dOGDXKJOkagcQazLtkmmuJ2U5BTwuPFv5o+ZdQ8nd1HPJB
         IPQgtqxcN127OGTg6N1jq6KGTrlsdtGep9ap9VhlbG74ozTmXvIsUXsPKbgOE9ehfar0
         YhZwqP+ly4V+MHehNdIRt7yhK74HHO4Tg3DOBKqIT7GG1B3BBrSAfeSNb472+gPDtMii
         gMwUPNIyZkcsivVOlnag0ZoAgTCJrVnVXp6T2K4EsosyKIXF5xx5YRL47CBmo2HzTedh
         XwEwF4Ep17XSJwpwmRwBbHge2peF9NbyPDe/nJFnE9Kc9hMr1BNlSgv7R+SRvUww2ahg
         scgA==
X-Forwarded-Encrypted: i=1; AKwUvBybhUOKaeR2hlEPd3Mmg8hpfbK6t1wAa/T1OzxIXGKZs9FU6vBDmPxA23UxhuK5ku4d9paDaREv5FYfba2+RQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKj5UCVEDPeqlCluxjmaBozkp72nWf/1WKuy73HlaxlQ9iFAYhl
	/8mnyH4u3Gen/9OjcXvRpZwXjGyTsHumj2ct/J/9xsWeBnE3IwxP2dqI/CQJVyjjg4iZSv0/wpa
	gesi1K2zssBJIk/ffm6eLn/EKe59Cpd/3otTOtVvS5bidPKwXMhzFdXCym7r3g7FYPMxxCQ==
X-Gm-Gg: AYBFou1TGPUq4TtvXrSUcu1IUBH5FBSiqrAp8cqfdFm6VsHFT4yQmW3y/O89yFk4thE
	pasHfwLIdQLQ6tLAC7yV7+hCGxwk+cmROmEb+8sslgoh49kbEOoSySH4fLmLwZw7QF8mdphtvJ5
	RyNrOxfaIHHqcWXy8twedoQRey/ropWU7E/cFkkNUVDYzDW4Pgz+fV8H6JNl8JjypOdvmL/dfN6
	fp4TmPU9lfIHouSh+G2V2z/pXOC/Qzh2BIYEKXjlDQF9seVS+Z6O9jdjxo3Enn2b8N1NBux+alm
	YG9Q8QBMpqN4uvECADbKDHqasl4pomas/S5yq1aqk4gU2o0lUCPTA1picE6vUBmy+A5CvydLg9+
	QO+eF6Ykt0aj4gOBeZhWa96A5uNkAesY=
X-Received: by 2002:a17:90b:57e3:b0:3ab:17b6:9a93 with SMTP id 98e67ed59e1d1-3adeb0fc65emr8055416a91.52.1793102714704;
        Tue, 27 Oct 2026 05:05:14 -0700 (PDT)
X-Received: by 2002:a17:90b:57e3:b0:3ab:17b6:9a93 with SMTP id 98e67ed59e1d1-3adeb0fc65emr8055353a91.52.1793102714216;
        Tue, 27 Oct 2026 05:05:14 -0700 (PDT)
Received: from [10.204.101.238] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae404746b3sm3697041a91.17.2026.10.27.05.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 05:05:13 -0700 (PDT)
Message-ID: <1c24fbfd-bc88-41d9-8632-76c5dad9f2c8@oss.qualcomm.com>
Date: Tue, 27 Oct 2026 17:34:57 +0530
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
Subject: Re: [PATCH v10] media: qcom: Pass proper PAS ID to set_remote_state
 API
To: Sumit Garg <sumit.garg@kernel.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, bod@kernel.org
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-remoteproc@vger.kernel.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, robin.clark@oss.qualcomm.com, sean@poorly.run,
        akhilpo@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
        jesszhan0024@gmail.com, marijn.suijten@somainline.org,
        airlied@gmail.com, simona@ffwll.ch, vikash.garodia@oss.qualcomm.com,
        mchehab@kernel.org, elder@kernel.org, andrew+netdev@lunn.ch,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jjohnson@kernel.org, mathieu.poirier@linaro.org,
        trilokkumar.soni@oss.qualcomm.com, mukesh.ojha@oss.qualcomm.com,
        pavan.kondeti@oss.qualcomm.com, jorge.ramirez@oss.qualcomm.com,
        tonyh@qti.qualcomm.com, vignesh.viswanathan@oss.qualcomm.com,
        srinivas.kandagatla@oss.qualcomm.com,
        amirreza.zarrabi@oss.qualcomm.com, jenswi@kernel.org,
        op-tee@lists.trustedfirmware.org, apurupa@qti.qualcomm.com,
        skare@qti.qualcomm.com, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@kernel.org>,
        Sumit Garg
 <sumit.garg@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20261027-pas-id-media-v10-1-8a5312d3050e@oss.qualcomm.com>
Content-Language: en-US
From: Gourav Kumar <gourav.kumar@oss.qualcomm.com>
In-Reply-To: <20261027-pas-id-media-v10-1-8a5312d3050e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA0OCBTYWx0ZWRfX6vwDvL6z3hBm
 9GFlfSXrn88+9cfVsLaROnf3ZZERMr1QOqBCd3JKfI4oL7HIHyFcOu6XpA6DmkxEMUANNDzHKJc
 DU9oI7T7B+kLNP+6ZSJTnNSJznq4k0M=
X-Authority-Analysis: v=2.4 cv=bsnZl0ai c=1 sm=1 tr=0 ts=6ae0937b cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=rTiepDLV5_WpOwre6ukA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: EZZXr92ibMc4x9VsI1m7fhj3pNgKdKHY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA0OCBTYWx0ZWRfX3UhdW3+pP+2k
 mlh+4BjGtpEVZwTxPrpOV7sAPXFy+CJVoP148QUVEOr0SEYcbLVwt9FYoKHJJ5bCzK6tE1KkA+O
 cGxilHh6YdbFEzpDX5KidZIaxVIrJ7cTF94NdfJG1lw+dIbjgtfwrQXB8UAi4DRZFseT46ZNIuD
 RcUBanvTjRZ2kLsjDHBUp8tAHKRlt/6KDVjBGjDcorEd/nRdPaa5Lxee5m2ZbXIfLFTrnMUoYEX
 jUIxdRO6ussKJ7BXAHH0jFKEujWCtU86+Pio9jGRvhT8RCSHZDtfb3a9spqemyLlcU8Wgeeu2Hw
 vs8sgPZFFujkmFYyi3T/pGvBKAnQtsI7whXFMjR7ibwXW2WAIYD3WmZllwc/Q2B9DYxRNwuhi1G
 IotaU0TeEj3ukJLHhC2ut6gU4HywMxlfay24vhnRgpvOogNwYT7dHkf/mbtJG38s00dFU9UEXWR
 I43QW4pd2WovTLFQYqQ==
X-Proofpoint-GUID: EZZXr92ibMc4x9VsI1m7fhj3pNgKdKHY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610270048



On 10/27/2026 5:32 PM, Sumit Garg wrote:
> From: Sumit Garg <sumit.garg@oss.qualcomm.com>
> 
> As per testing the SCM backend just ignores it while OP-TEE makes
> use of it to for proper book keeping purpose.
> 
> Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> # Lemans
> Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> ---
> Changes in v10:
> - Resent standalone, as all the earlier patches of the series are merged.
> - Link to v9: https://lore.kernel.org/all/20260702115835.167602-11-sumit.garg@kernel.org/
> ---
>  drivers/media/platform/qcom/iris/iris_firmware.c | 2 +-
>  drivers/media/platform/qcom/venus/firmware.c     | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/iris/iris_firmware.c b/drivers/media/platform/qcom/iris/iris_firmware.c
> index 21f57d37da18..ed2bd0e83797 100644
> --- a/drivers/media/platform/qcom/iris/iris_firmware.c
> +++ b/drivers/media/platform/qcom/iris/iris_firmware.c
> @@ -262,5 +262,5 @@ int iris_fw_unload(struct iris_core *core)
>  
>  int iris_set_hw_state(struct iris_core *core, bool resume)
>  {
> -	return qcom_pas_set_remote_state(resume, 0);
> +	return qcom_pas_set_remote_state(resume, IRIS_PAS_ID);
>  }
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index 3a38ff985822..3c0727ea137d 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -59,7 +59,7 @@ int venus_set_hw_state(struct venus_core *core, bool resume)
>  	int ret;
>  
>  	if (core->use_tz) {
> -		ret = qcom_pas_set_remote_state(resume, 0);
> +		ret = qcom_pas_set_remote_state(resume, VENUS_PAS_ID);
>  		if (resume && ret == -EINVAL)
>  			ret = 0;
>  		return ret;
> 
> ---
> base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
> change-id: 20261027-pas-id-media-7cc70fc5716f
> 
> Best regards,

Reviewed-by: Gourav Kumar <gourav.kumar@oss.qualcomm.com>
