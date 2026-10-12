Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6631048A8CC
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 14:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814290; cv=none; b=edByt6o+0ZvZPiZclFk4dBanEgJSRVhz/kps9nnEfAqlLWnU8cFtF7UStiRxsQYGo3lhvr6oGuJu6N9UGwpbtt2Jdgq/UsUVCf1mbEehgGCRItqygQOZe63ZIPUTVxDpoOnqzLQyyOlP4GFgQMRAHQW9eOhCx6Q1Kmi6BN5/qWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814290; c=relaxed/simple;
	bh=UnF3rL1aBzd0WE2YVJcayU8K+KXqubjSqN10uSYTnKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZZqdrVEmxyc1KxwdSH+c28TqeLHvVTffg9d89MQqMcnOjmLxQQzCQR669fN5YpYtTuledQIbxQPXulNfbW9fG9QGwp3r17d3rRDlcOiq5Bqc/xzvfYXiST2orZQULx8aq+MzJVbaQ2I6W+sAv4xt3AInDMCgNmyQrfIXrXGTaI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cB7ViqXi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EA8ftLJt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cB7ViqXi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EA8ftLJt"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CC07aV3292216
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 14:11:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vV0F9WzzjHc+sIpBrZvrViKNuz9fOg54zErptNldCF8=; b=cB7ViqXiOh6NzTSR
	fcjko0xLtwWVPMYd5uUkzpB1Kqn+zkoBkLf3toUgqWeXCvVrxFjy8NJq1LXBg7y2
	lRUoyRRuiYMYPX4pfhMeIeNH718be/9fS0KwhkpZyxD/nxCaGHycrxHodQjLI39C
	zEDEv4qSf/2knbUCA+TFlWoz+pWf+jVvr4nGv/2bbMMBxeYQ8Ef3CKEs938z3rwS
	55HntnqV8WcqvSoLpnzkkzLt0S4BQfT6wqMFyoBvB9jXc5Q+dj53QBciyWWuZe7f
	dfgA0FuH9GrANgRgHkb30grgmDljMtQamv/qAFiqfiJ4FX30FjHlp+Ye5rJSLqX2
	jMhYvg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h8uh3hqby-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 14:11:28 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3580c07911eso5295594eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 07:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791814288; x=1792419088; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vV0F9WzzjHc+sIpBrZvrViKNuz9fOg54zErptNldCF8=;
        b=EA8ftLJtq8l5vJ8H24jRuyPtwT7wP3wuAMi9KIuGGDCe3oMQDtx2jkrf+/rYu1TBPR
         VDsvAvREcMnrB1aqx94KBMp1vBYPXL0F1WCJ8ivhyeC8bhGd33HvnCrex2WHw0+IMrZM
         4x/hsmXObtEx+RiJ/AUdOJYTKLOjO+4nxEi6+i0DV4JrfVbsb2Jm6pBJIIBYR32BVZpi
         RjautVxCGxiExu4Wc/MN2hd9l0aO4NiZHRICwWlOsYh5ePtqKvkqUbXe3wB8F8yLFJKt
         LP2RRO8Oh7GIoW4+ukA/wyOQw83m5ipSMPAwwQqL31zvNfkqqMP1VTp5PC6LAgdPQoQ7
         IoHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791814288; x=1792419088;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vV0F9WzzjHc+sIpBrZvrViKNuz9fOg54zErptNldCF8=;
        b=lskfnjiO9lqkatAHrvLgCW/xJ0gTAcpa9h4/JAiY00/SXCGQu6sNGxIASURHiJSDVF
         kNnVLXsQULeR2OQgOfwSEvEhO83q8ONx4H1WZSR7DlGfSTCKaOJAYAfWIHZEJr1l527D
         XbtVPUMritiBCGMeUQjk6dePMq3kJN9jWtvpZHcvQ/87SFI+MsG6Xe5f1V0BceQ8m/pA
         1YnlX4feFS9ypEpp4LJvlvyOiWeKTCUi8WBBU/iWGqRu19/E9/Dij76hWvQa5Bi6sbLx
         +zNY1Pz2h4mtnIbTrT5Ga8VSvjT/rK3MDjcfMHhSKhzhf7PWVNkmAXtdn+9E9SQF1r0T
         iSaQ==
X-Forwarded-Encrypted: i=1; AKwUvBz1mgx96m6pRcKvKO5zlpwbaoZZaT4pg/fIbZAnO7mon0n1/sQcQZs+/3HJLoVymlYIUAlErNfFCmpRsClAaQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKwXopVxzCMag8Wl9PlHF7lngnQVGvVSd8wXThAdKIpcjS0xEAI
	qiIgnb+XJuFLEiviEIMvrSspZTPrC/XSrVvZNF33ZIWNn8PeY98OAEuh/q2g4EqNIUvE1jzU3sM
	Mg4Xb3gF5WW++FDDdfbfrtxX9EfCsoGR6XVVsjFTiNlllyQuL/wzOQpO5pi7UxjHyzpiI4g==
X-Gm-Gg: AYBFou0SKBRp1/2pRTQetFWvRrbCH9azU853JJFjpw+vd9XqGTh261TIQdA0705KDkr
	eKAY6zfS6gl2XJyOXhp9HDlyCinXqsGaKAY/z9QugALqIu0VRU2yMln6SJ2GdNELJ9lQKJp58tZ
	ozkj99ZijF+ROCnm9vVa6vtTeBHEU6sYip7IyqBq/1JAePSKj79l0APEEP/hj9y9FQj9P7Pgq+9
	27qiBoRjhy8iqlLUjaANYa2CE6mwQSaOEnbPFCJwxV2zEjaBbRfIj+2XnEQY7Cqbq6HmVFDoAQJ
	lJduV2dv03wHCGC+7blxM5SYT081GqPMb+R6JrK7iT7zL7OLqdEQYhV0IcDwiWCSgJlWU9eBTji
	j9Y+4rGdaK30RZbUOp0MpO7VuwyOxDLZ02+sHtKzvYIqlUs7q0NheNkWng5QP
X-Received: by 2002:a05:7300:2392:b0:34b:101f:cda2 with SMTP id 5a478bee46e88-3537e0cd902mr22245471eec.27.1791814287603;
        Mon, 12 Oct 2026 07:11:27 -0700 (PDT)
X-Received: by 2002:a05:7300:2392:b0:34b:101f:cda2 with SMTP id 5a478bee46e88-3537e0cd902mr22245266eec.27.1791814285401;
        Mon, 12 Oct 2026 07:11:25 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb1e05esm35157578eec.25.2026.10.12.07.11.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 07:11:24 -0700 (PDT)
Message-ID: <52d0917d-49c3-4d24-b43e-d9321d8e1a2e@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 07:11:24 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: cfg80211: allow IR on a channel the wiphy already
 operates on
To: TangYi <1914018426@qq.com>, linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, johannes@sipsolutions.net
References: <20261012125955.1519379-1-1914018426@qq.com>
 <tencent_B6DCCE2CE592B4FCCDD65E6D07A91C4D6307@qq.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <tencent_B6DCCE2CE592B4FCCDD65E6D07A91C4D6307@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA1NiBTYWx0ZWRfX+7cmqLzVdolL
 GNUIRqe/x4PpOm8nrhMZQrl07uv1ZznhSH8i0bW5FP4yAhfZWQaSZSOIgR+LMNnHBGX3QdJXDLr
 5jtnjaOx93hBOzgR12K446VCjTgoNaCnyuyUHi2+0dtSyIwjVImUYEakDLUwU4ybj6iIEgX2Z8p
 UfIlC8jXS9jYqbluf3K3smv/UJ0LaGWG1AFbooo/Ns1mTLX3U96RuxC0VU45Bvc4IM464Dq+2s3
 A0jzw3nTD7v+pj4EhUpcxfyFbm3oL9m0DTojw0iZCpNKgNuQLDXkr2MEDCA2wAsXgjOXYHwFyso
 6ja4/rOTytBLP7Nx0J+IWIgUBiVmNUlvSqeIldUjJOPr24RvTF9LW8Pv1T5EwtnHRx+dDJi+VyI
 6TMs5xuH4ILwHr4+nYGAZ0AIJi7tfSS55BCTjReSHbnvAq52KYKVUblCJwGOqd+Oe6/csneN/2q
 SXVK7IX/58z9pp4welQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA1NiBTYWx0ZWRfX4LSxQtYx/oaT
 /h1XO+9jbmcwK5jhVlYFXnbXlxMROzrTCWP/vUJPyRob+lj6Bg1ecl3k/j5YdAGbl6f+28KY21S
 n3FCUDMxjSKsDreo6CablhUa0Umh7H4=
X-Authority-Analysis: v=2.4 cv=QO391QLL c=1 sm=1 tr=0 ts=6accea90 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=dZbOZ2KzAAAA:8 a=MYps2yIq8nXn-yX_PDYA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: Q7U89c7JBX-0w90_9b-hpc2nOxnekC9e
X-Proofpoint-GUID: Q7U89c7JBX-0w90_9b-hpc2nOxnekC9e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_04,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120056

On 10/12/2026 6:42 AM, TangYi wrote:
> On Mon, 2026-10-12 at 20:59 +0800, Johannes Berg wrote:
>> This isn't how regulatory works, sorry.
> 
> Thanks for the correction - the "already radiating" argument was the
> wrong frame, please disregard that reasoning.
> 
> Let me ask the constructive version, with the concrete observation that
> led me here. On this iwlwifi device (Meteor Lake CNVi, firmware in LAR),
> after the station associates on ch149:
> 
>  - iw reg get (phy section) shows the learned domain marking
>    5735-5775 MHz as IR-CONCURRENT;
> 
>  - iw phy shows channel 5745 with plain "no IR" and no IR_CONCURRENT
>    flag;
> 
>  - and the iwlwifi source contains no IR_CONCURRENT handling at all.
> 
> So the domain rules and the per-channel flags disagree, and the
> reg_can_beacon relaxation cannot trigger (it requires the channel
> flag). Should the driver be propagating the domain's IR_CONCURRENT rule
> onto the channel flags once the firmware has a usable domain? Or is AP
> operation on such channels simply not intended until a country is
> learned?
> 
> Happy to take this to the iwlwifi side if that's where the fix belongs.
> 
> TangYi

off topic: you need to figure out your mail agent since this reply was not
threaded properly.

It indicates In-Reply-To: <20261012125955.1519379-1-1914018426@qq.com> but
that was not the Message-Id of either your patch or Johannes' reply.

