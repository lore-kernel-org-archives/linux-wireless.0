Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B1F339365
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791480642; cv=none; b=IDlO1WzeelJiSwBE6CnCDB7NegCw2ZZAj1xIUKElhQE9Q2asENwXTd60+8pneffraelWGZI3b/pzfmOWPquz1Q8fR28oAVIQk22VCM3/nQYuEVb2cEne3k3QPvdAccY0R46ACoSqP3C3f+hZ74Hd0TGlvz5ME/vFPu7hyCaDXHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791480642; c=relaxed/simple;
	bh=kbBbyZTdB2VqOzHzVOpsG37cV8GEZBvzhLOSioAjTSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IxvsY3AL2N1+wjB6kV4ebbMMGYgPdTRhPYp/6SqL4Z4bWVu3ikOxD36kOQhewJ0Ku76ORPWPhFhQ3G80aW8oQGoyg6hIRIelZp7vMe0+CSM7/pA1VF9DLo2PTTTLNGBC8mF5QEavDHI5Ze/lumzIafFMchhvDzjwquAcS1MtSio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RPgbO7v0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iNP/moW5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RPgbO7v0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iNP/moW5"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698EVDVZ3145542
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 17:30:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BpnrZueYXCCjEcEkDcfSAk1x1RAKDgY0ujsITMSD4t4=; b=RPgbO7v03FDFpiVh
	MWLdcPcflpO2sXv0TY9cH59v6+SDFow+DAdbcIiFtU6j/ZgbgbDI0Qw9Hd/jpto7
	NVguRyO8M/y821gwl0LCYFue9TjTVRAkdON+BPoEJiLkTornUhBS9MNfufCqNWih
	UKDHs1wdcx30Dm4xm3yfBj8y0tH2xYrY73motGBjx9MOTi/mDkz1mqBoW9OUBpsv
	zg8iXqn0cI+ZZ1A3eidZNdIyWRE4hEI58JxY+RsaF6o/+rfOyL9Yj8bCrpzqYEu6
	6aXDLS4MXLaR9awwdU4byVnfxV1VWaHDt+E4LhsAQlZQ8JI4gcs2vh27bXhzJxxY
	OrPQbg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6baj1457-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 17:30:39 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso10393378eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791480638; x=1792085438; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BpnrZueYXCCjEcEkDcfSAk1x1RAKDgY0ujsITMSD4t4=;
        b=iNP/moW5cLGXT7PJTFi+7GT1MwgxD4490idWX8kNX9xEVCxadbDwcCxZaIf+HBxJva
         eHY5pN/MKWuicQmEUeibGslzYv6bjkTaI6cICcuTjAwzCn/ILTReo6Q4qmty/cXeFrYF
         KGtzd5LL8XXQ2+YWtCyUhPvatIRGUZOJdBvCimRR0kTCvMKZoIBb2Ta8INS4iaKmWqr9
         FkkouNorslvmNfCUKYtqMzl9GhHC7GymRKEuzmheKJSqbkn6HTOgWvv6bcB4rDbA6YaE
         E2iHJPpcHFBqpm00Ulncsd1emtOu0WmnIaL+W1Mjxfx75v1XpnUFI+NvfDoPMiAzCRDF
         cDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791480638; x=1792085438;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BpnrZueYXCCjEcEkDcfSAk1x1RAKDgY0ujsITMSD4t4=;
        b=YV2+tmCgqXLal6eT0mJT2TJkX8HSPDPFJVYO7I0wgl/W0egzLvvEizzOEX63ZBMVqZ
         Yr6aOw+Dieic6TvTfP+j2XASfyKnyX4qXZozZBfMuwz8kkp4JcEFAqpaXkEeVIieTj89
         EpUOvjIZ+e4ScTXuirKJdDEsgnV7jnpAxsX2Dt1WZxSLA8+d01fEqbCREAzMq3zMMJY/
         JgBcVQFW9sBFGmMkv6X8NRfMewC9GbVJwux5XaXFfFfdF9irFibszXp0IikGyuEpw12R
         2tBhr/6XtgjtO+GesE7Y9/0rVXdwp7E5kEPuFWYzqffk5x3mDat/nCfYB8as5JO/UmQ1
         Hnew==
X-Gm-Message-State: AFq9FYKp8JXax1/gIVciCY0xlpOmsGetCUAi+gxud0aGPHMQ4gBxVpDE
	piQw1Jx03P7BMO60Ekkp0zm53vmeEwqJHdC4cDRDxcWSTj89TDLm9MtHgxdpSoK59LvEPgTMaUv
	JWEd1VduuASa0gd5a2z6GLRDzo1AMlEiWqiw9si6CPUhEGDgp/MkQe2oFCB6rEXEUZyc955Mz+u
	2fzQ==
X-Gm-Gg: AYBFou0EEC+EKyH8qdWALSZ7xlqET1oxGZK3SH4/U3FAVLKTGtkRNafVaCAIL2ryKLn
	6OsvtwhhwAtVnaHZO8QgfO3nOcFHCBmyXH6+Fa79UaH+eFODhlXi61HzcOBgEi8rZloHcWLkUDI
	2/YZeQrtC9WJ1a91gLrLzqc2a0dE9MzGjZ4jnNxH3WArh7Kmi/N0ptyEMdtXwc5Mu9BYInvMRRC
	QT2HwgvVWv2don/yrZgjkftLO/0FpsWgyiEF+bm2hr2qa/lsUbUofoLvoRT9i8bz+GBP2xh9U52
	3AJMHFtDS2CNr6AR71aXsqRb/1lXMEyjn0/v/97VIQ01FWPTDZgKWpHIQy+LVaLfDrLmxx+Yb2E
	m75dFFUxlkM/a4AXije3DIylFqreZK57HCHBtQ8D4Em0=
X-Received: by 2002:a05:693c:6088:b0:315:afc1:72db with SMTP id 5a478bee46e88-3515dd32f70mr7367069eec.9.1791480637883;
        Thu, 08 Oct 2026 10:30:37 -0700 (PDT)
X-Received: by 2002:a05:693c:6088:b0:315:afc1:72db with SMTP id 5a478bee46e88-3515dd32f70mr7366162eec.9.1791480621711;
        Thu, 08 Oct 2026 10:30:21 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3515afab2c5sm16076109eec.21.2026.10.08.10.30.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 10:30:21 -0700 (PDT)
Message-ID: <6454da30-157a-40c5-b1e5-d4ff0bfaed55@oss.qualcomm.com>
Date: Thu, 8 Oct 2026 23:00:17 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: Remove unused
 HAL_RX_REO_QUEUE_INFO macros
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260413-hal_rx_reo_queue_info2_msdu_count-v1-1-c4c92ccf77b9@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260413-hal_rx_reo_queue_info2_msdu_count-v1-1-c4c92ccf77b9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA2OSBTYWx0ZWRfX50978IBKPy9U
 l+uziAqgdfeoNxjZI0SKcLbaoo67rgfn+1nBGK2ZiXTwGxKxTJSZiPbuv6MGMVk1ffHwTQ1Njp+
 +s80L4u8JxlWonSQ9meIXJ0odw0SSQ0jHKLNCk2epBQ/fiqRBghx3Pr/kZijT806Rii7IX1L0u9
 jPUOA7TrCvIBRRP9eaffchxtkO2t3mWA5skoiUMmDYHCDSKV8WTVEogDY7tsrvXjaR6V0EZOMKI
 P7fkSqJfV4Xe0u1KzFBO9YBlNkpc8T4wRK4OyEUTtzc42y6OO4xMZJKIGtmYLiJBLPzPVXbW7uX
 EHn05BNHGKy7XdXbKfALvaltJ2/xJwSFkvASTlRqYs1tfn8FW+vrUPuRDhY4J15fQDt5IeigF14
 7mZQySMkLMERk0ycrvO3IV3D81bQCPeZhqJW7qDPIgH8X9aGlP6jUqf421MCHrT7SZ6YV/9IXcq
 al3JzRZTrdOwAIUFwYg==
X-Proofpoint-GUID: 3jMD1xiQ0DikTjt5rMh9TxV3M69S_uh8
X-Authority-Analysis: v=2.4 cv=H/dOUOYi c=1 sm=1 tr=0 ts=6ac7d33f cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=S2GIDFmybDkgDShTZ0oA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: 3jMD1xiQ0DikTjt5rMh9TxV3M69S_uh8
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA2OSBTYWx0ZWRfXw7I5jfM5l/R2
 NJxPqSOCCDpf0lD8As0m5nCAuk2wg76aNAvCHH+x7SEPFQcFwTYPfLJ9CZxZdWDXHhMcWLinvKQ
 U/yUTlLMzW5N6ibOODvuMhQuYOLog70=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_05,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610020000
 definitions=main-2610080069

On 4/14/2026 5:28 AM, Jeff Johnson wrote:
> Many of the HAL_RX_REO_QUEUE_INFO macros are unused, so remove them.
> 
> No functional change. Compile Tested only.
> 
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

