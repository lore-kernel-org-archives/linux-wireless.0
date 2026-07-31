Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C69207A32
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785467235; cv=none; b=c7PaFnvwdAQBo3W338/1TpdpvhfxWdtDGo286L9naLpsHLFJpAIVNol5Q626yb0bKvjnPO9+fT+oq0W5mPcXNYokXxkgvBGWXXNY2+GUFyZ8f+0I7Qz/mqU77kTkGkpWSg8QLn+IUSfxBECO3F/dEjjjX9ahFYR9jqgkC4URP6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785467235; c=relaxed/simple;
	bh=vL2uAWXAmfycxsp31+OxgVS/U1yQANdoF5/6yak7oog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j3is9mq0+TGmZrvhSoE8vCm4J3okEVWernufbv41IO32ODjLSb4P95CL6+FqaX/xzpTUErUKH26TYzLsKalDV02spDHhNmkPeTwaqBWkL0QxSFcvG4MgMpoE5td8/KZYfrbGghqdlUAwc+y42nvoGTImTcQmHlqBuG8O8B5MoMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IfQUe+C7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AZOLR0fr; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IfQUe+C7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AZOLR0fr"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V2uO0r2729760
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:07:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	StiQNB/VgRXxVtOeJyl+DtEvUetWYYDQ1khQl5juSWY=; b=IfQUe+C7F3CI/DwO
	u8rqx0uFITn9/Z3ZOWTe7Noy5kzFgisOH+VNS4QD5BWvCcL30ZnSiSDUlO+q8RXz
	DmbqqoC0RxX2bI3VZGdV2fahfdaEw5099hTK9tyLy/2JbZm8p9SLqjKw2ry+x73r
	86w4GGsgKi0XSDZqPwr4RCDyre9H55DIEVoXWxUe3+CY2sys+ob1UXNjcPIUJyhH
	qYQymYAmOMENqOT7TyB+u+S5UFCYFMPFcxZNC+KxEDNZr1+NilLNIJY/6ltavVIW
	XcL8hpfRcyvslvcJtPH4WilgdF4emdWgMWtsLMojMPKzrPL/MvQKGjymiFSrQ/kq
	8lzsVw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frkc5g10p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 03:07:12 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb6ef846b33so275339a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 20:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785467231; x=1786072031; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=StiQNB/VgRXxVtOeJyl+DtEvUetWYYDQ1khQl5juSWY=;
        b=AZOLR0fr2fB2tHmsYbw+lmP2AVJ0QzBVu6EOEYqLPYVY5GQqYd5bqVxvY/S6G3XSyF
         f4+Qt7dEUIi8O1Dl8rVmHeszwBAnGMiRwURB50/Gh/W1eKH/oyIxssDytDjqDIkMYG20
         mNGUuj5QYe/SsNzfVXFnQgIZQZXxPN9o5JtIiZ673xlxuHbu9GldPA0oboEwxQKpbVwk
         ED+jN2iF9R1dqAXTHGZeJCezKsPrkaZhe9gWWIiaT6XNCKjxUTkvdGNlxyRLkj2NUnzS
         AltarEVdWYL2/lP7guVRpR+k/pXqS1w4m5cCtf3vmjC6mPb6injpIc3cfdGFtLLhobGb
         AcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785467231; x=1786072031;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=StiQNB/VgRXxVtOeJyl+DtEvUetWYYDQ1khQl5juSWY=;
        b=pKwUbSfHSQ9JvJnhVqXGJZG9f9i5Tr34ETca8+IUBWq8DfTRV24k8cs5vyGvxIhVDb
         ewL2JPMoy68t6C52F4W3Fd75en6UARGCg4Ouq3rn2zvSJoR5u6WJGm1r//Sde+nuRPkv
         5luB/Irv8nS+9vfaZla+rGpknBf5UxzLR4HdiKEvkZCjKHZUJXvmDkZWj4Dt6UrHzyp+
         j4ct1C2KwBNSPWzBV73vkpGzry8pMo/QcAcM3S42I3bmdTfJJIo75CgjmRUizEkODEEu
         /b7KTpIsRGtidIdseqoUHTP+cUb1ui5rAzvI+hQEDy+oiABEo9xpcKugoDg85C+bFyNy
         Hk9w==
X-Forwarded-Encrypted: i=1; AHgh+RqrSZzy2eKWc34m9zxy8u6iu7qWLS/C1WRUAcjOzzHrdx5QuxYq2PWdO8W0LJr97yfHtr+B17LqtxydLHYqcg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx98sUNHvclFLhSVJT/c2sO6QPimUIvRLMTYEi0LZvFj39IsFe+
	37jlnw05OTVOsFY8NLyw9ykZ0agTtWXZXDQ14DwhO0rMp46TR3Z8fDM8FHGPMg3Cdp0uIXcR3xJ
	A4g1lTi8YNzFHaAsx68z7B+ryb1YDJw4KXH31IAzbSUHeIhCGASLpN5h3LyPBxyj+OcWhEA==
X-Gm-Gg: AR+sD12qlhzuY6U8J4um1MV3SRzJJmqcDC3qFIXqD5i0NmVoutTgOlGKDn+s19hPDul
	tkinmaM15x2DFjtfmuQ+wPMrKSwhlPl/yaQRQ8yiIDwO7qex62JEICN7BEn1b+1YX2XtL9fpcd1
	pAcWyzfyupFNdEbTHY+XJHGTXKDBVgI8H6TIVL2ZXTPIplG/M2QFq1FZSuj5iyCwcQM8FLErRfL
	nHubffnEg0QoIGxZf1BTUat31/YtsyLzkH29fXBjyL6/o5fyE6R03QnEt0swmb01+TTqrmYZjyF
	wX4Vxh+nrlSjiB4Xtu6uzEoKTLv01/qnks7mmTC2UwRUU0vVr66BOyc1KB9gqu5onHr7JfYE7AO
	ESShOedBuJE0qze2F0ykHnp8e4YqFWEm/mxdjuQGBBiOMBGT2zDJou4Tx76/TNgy6S5NkHSOy7Q
	==
X-Received: by 2002:a05:6a21:e598:b0:3c6:6f25:594 with SMTP id adf61e73a8af0-3c91aa0a4f5mr251200637.38.1785467231564;
        Thu, 30 Jul 2026 20:07:11 -0700 (PDT)
X-Received: by 2002:a05:6a21:e598:b0:3c6:6f25:594 with SMTP id adf61e73a8af0-3c91aa0a4f5mr251164637.38.1785467231071;
        Thu, 30 Jul 2026 20:07:11 -0700 (PDT)
Received: from [10.133.33.108] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe3836a898sm101127a12.15.2026.07.30.20.07.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 20:07:10 -0700 (PDT)
Message-ID: <de4c4eea-4d5c-4395-9a80-bd53f65069cd@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 11:07:07 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath11k: fix SoC reboot on firmware
 crash on AHB
To: Julius Bairaktaris <julius@bairaktaris.de>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        vasanthakumar.thiagarajan@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com
References: <20260726221908.104873-1-julius@bairaktaris.de>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260726221908.104873-1-julius@bairaktaris.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAxNyBTYWx0ZWRfXyp8TDibL7BnC
 +R5+GTmacKPanilT2u9tqu8xrXKe71mJipUHrGQL64TZxTbA68segkM4z7W2dY5Zr6hzoBzVqUi
 3EHhri7FUCJCnXmzF2ebXcQpGVkCjlE98rU11CTFgQLSRXRK6ecxAXB1fK/ZpyPfKvZIN00r29e
 h1OP1h4CGhoPx18gtF5CoOTuJ1DAfVDUO92CGpcVVbBBVVqe+UhHKU3ZFGUTrjQbczfTQDm8Hs/
 OpcIm4A5TlPk4HeRAY27SQQ7qhWBIDjSgteuHn3z9vw3KMP3oaaE9F47vg5eBlrYxzFPn2s80NQ
 CN+5vgJQp4QvfBAJ48e06YjEU/w15dtyoNvpComHLmarNAyVe19r0eLWmimqXMRD2eprF70ibOo
 BTF6sq4t8TEd7VHqEdXyI2za6NOOeOfzu7mMu2x01f74LgV0ZZmCETJyGio6x08y6lAfz/A/R2+
 +iUl79B5mLduD4XMkYA==
X-Proofpoint-GUID: N7Nuy-lCF_MzizWhxChKnOs97SwU8hGO
X-Proofpoint-ORIG-GUID: N7Nuy-lCF_MzizWhxChKnOs97SwU8hGO
X-Authority-Analysis: v=2.4 cv=Bs2tB4X5 c=1 sm=1 tr=0 ts=6a6c1160 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=hCEygx0HL4Tx5WVe8Q4A:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAxNyBTYWx0ZWRfXz6ZU7KX+jCiH
 oloy4tMpY9socl6vX8Af01XhhnmjD4HmkUwntWIlvSc971M3beXdYQMRgEqOEeD/x6erRGO4LSk
 C/jyAkaDDBdeZFH2Fs3gYx99lnEEgGA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310017



On 7/27/2026 6:19 AM, Julius Bairaktaris wrote:
> On IPQ8074 every firmware assert takes the whole SoC down. The DP NAPI
> keeps polling while ath11k_core_reconfigure_on_crash() frees the data
> path underneath it, and dereferences a ring the teardown has already
> cleared.
> 
> The interrupts used to be disabled at the top of that function.
> commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
> moved the disable into ath11k_core_reset(), which AHB parts never reach
> on a real firmware crash: reset_work is queued only from mhi.c and from
> the debugfs hw-restart handler. Patch 2 puts the disable back on the
> crash path. Patch 1 is a prerequisite - the CE half of the quiesce is a
> no-op on AHB today because the bus never implemented the hif ops.
> 
> Reproduced and fixed on a Xiaomi AX3600 (IPQ8074 hw2.0), with no
> out-of-tree modules loaded, using the debugfs simulate_fw_crash
> 'assert' trigger:
> 
>   before: 2/2 asserts panic in ath11k_dp_rx_process_mon_status() and
>           reboot the SoC
>   after:  3/3 asserts recover, 5 firmware boots across a single 397 s
>           uptime, no panics, both radios stay up
> 
> Note the debugfs 'hw-restart' trigger does not reproduce this, since it
> goes through ath11k_core_reset() - the one path that still disables the
> interrupts. Only a real firmware assert does.
> 
> Patch 1 is by inspection: it makes ath11k_hif_ce_irq_disable() take
> effect on AHB, which also fixes the existing call in
> ath11k_core_reset(). I have not managed to trigger a CE-side crash on
> its own, so if you would rather see that split out or dropped, say so.
> 
> Changes in v2 (no functional change, review comments from Jeff on 2/2):
> - separate the ath-specific Tested-on tag from the upstream tags with a
>   blank line
> - use the standard kernel block comment style, with /* on its own line
> 
> v1: https://lore.kernel.org/ath11k/20260725141757.1316877-1-julius@bairaktaris.de/
> 
> Julius Bairaktaris (2):
>   wifi: ath11k: implement CE interrupt enable/disable for AHB
>   wifi: ath11k: disable interrupts during firmware crash recovery
> 
>  drivers/net/wireless/ath/ath11k/ahb.c  |  9 ++++++++-
>  drivers/net/wireless/ath/ath11k/core.c | 10 ++++++++++
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
