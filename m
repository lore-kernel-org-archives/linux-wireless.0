Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CF43537FE
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791127040; cv=none; b=Lr6IFaQVL+4+62MdMudQ9X28xthy3mUHyp1onNjLYbtWGQdD/vkFfSegOX/BJ9bp4CwgN7pcog6vE/dfVLZjKRdYRR+JEaAprwDMUuBH22mz+MrlBsy5+K83ZDxZRUv2bOLFhi8GD+g780I43IzfUJn64a8oq9rs6dG50lZ3S4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791127040; c=relaxed/simple;
	bh=lCTrtLhr3Z5Si0YNt7XHi0cDL4mce6KWKT1snu/cC40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DZ69KTEOJhUuDnrmQ/6lZKntl4+N75es9XTAbliaFIkOTWx6bQMZq7Kgpbwy0IsiH2OBm+S/khK7LD4naMObgbzV4ROV2x1ExJNiNAcDOYNaGk4txGgQ11YZPzcTxJ0dgczJ9QndgnjH/ktGek1xjnDpXhW9ptnGXhO0gOBoTyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E9CfEAsl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PYnWg4aQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E9CfEAsl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PYnWg4aQ"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 694EeApn3725685
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 15:17:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gWVnNLZ8wBkC28PmXBu8obcfbzjX+m7XPpwB3x8JuCU=; b=E9CfEAslMJtg1Ra5
	nzR7t+TtC1Sjqx4nCfS2lCHDxhdJ88Bp/yxA4hdhGO3CfNwbnCa3GgY2GSLpevn0
	mHxoMZdtBytrTZp4wXO3cWMQWSlG6ydDOo+HGdfenPyx2GawLDeKUviAZfiWTpAd
	p/NfOXiJRaA96gM7uV2JvjmajoepMUhFPm1JQmm472LcpYc+ViHqrt8kNPztPUaN
	58lLQ2l3GYhoAqdx/YHyeU1CX+htL9cfVz4MJckG49aLbLNZ/iaXr5IO0E/uqVVw
	rJsVJsctb5lZ+b6+bKss4Ai6vsHL4tfPfolDxL5gwvxLb+sXQ51cJWSmj5ntl1+S
	bRgYFA==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h2spa397q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 15:17:16 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30f1b904861so1269842eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 08:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791127036; x=1791731836; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gWVnNLZ8wBkC28PmXBu8obcfbzjX+m7XPpwB3x8JuCU=;
        b=PYnWg4aQDV9b4Xi5+n4sDtMr5wULR8SLCyBQFwZK89DcivMmUi9QGkyNzIYLKikaVj
         qKfX3wX8veIrACqUduIHDcalh4onDnqoKkWTJERoqKrJng/JfGd/SreR/GQD/tf6RnGB
         sVbqbJIxuhhzOnRggoARvLCRuDb1OwTiaq0y+XK9VD0nuv+qfR0wiK+/F0lWdoph06n1
         mRvpefBOsGMTkrIPrWFi+/NGyi9chCUyaKJnpcF1PkGmXSt2aDrrKsPPc6H8XEY7rXub
         WcpxNwou2fSDdDYY1HRdMQBV5LOR1VwWYLgsfMmHB/LQBgZno36/nv8+Y6LcfcMo08Hl
         eq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791127036; x=1791731836;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gWVnNLZ8wBkC28PmXBu8obcfbzjX+m7XPpwB3x8JuCU=;
        b=sr0IdqXNQ8FDNG8EUZ2BJy+3hGTyS6c+joKZOuBgL1ioDX6/KFeGMoOsucekFJLdvG
         /MAM6ZToYWH4Z/Mw4Cv3jm9SfaATR+pG7bgT+ftykTs6PGqS+XAlhX4+lp5ZwMDAH7yX
         BmWXOMA5glz4ehF+lUtkTCZQBeYXxcf2cYzcrysbsHOlif3j8dYyLRYQP8kUSZ/v3+q/
         Fg3m0o7Zd+gFBzNM/ubk8LWSVTtoOB/m3GAEc8IK9OrerzqAhSzoPDwv/cRsugNdiYGc
         HVP76uewst5pr87ZZdNgg4tOQrWRMzk3QUEvVd9IFUq5Y2r1qQEpM821FLpQXFIYv3Ve
         1yHg==
X-Forwarded-Encrypted: i=1; AKwUvBzjyWNJEZuh7+PFgNrt7Ks5Qo+6Jm3KThq2TLLlmgPFozC4POIb2RrHmBKOe6y6skz5k5T1q470feP+41cMUw==@vger.kernel.org
X-Gm-Message-State: AFuF++kCyWJS2hSZyEjzsLKOJ8jQhBvSfwn3vkNGpoTrkQn/d97HGJjk
	yO9sKqepdIFI4wXyvTuc3pKEw9AL22glGuBAF2T0wGmE/CK93dV+33EbXfrCi3fVjsV4/kJQVv+
	HpTO6D5Kt2lG8+D9224w5pCPmCJ4SkSwAgBaE8sWDDBXciirBDWSJHspiB7VwHuajdQn79Q==
X-Gm-Gg: AYBFou3MmUvSue8UajV6Jt64wBC2m0/jvCaHmOOfc10MRCwVdDKTCy7Iy+7dNTzMuTh
	BShq4upOrgtiCmHs8s3A7LJqDh8+WQSLYmItUfZK1Rzv6xn4yVWsp78wMRh1hP49fJgwcf7rFC5
	Gw8TGgeXTqk/bN0k7qMVVKxNJLQnFKK6QIAaXVIi/ITS82CpPxmgl8qjfzUAP73YzYBg0Dfjpu3
	BFMjzhLKEL8F2MZ2B45E2GU+xcsyduJzP/ZdDhNWeOF5TapNp+hCzy3G4JDfK6e71OD8EERSYhg
	dwydcFUsaHwQaCJO1hbK+nQNxLTbqTBtQQInNGGTOiXb/tJGrQGhcnOK4fYBDNSLmabGkKx9guF
	5lPUDASEszip38vMaJSdN8JR8E+J8h2AB7mhnGTCUpp2Ao5iaMyGFdTjqSA==
X-Received: by 2002:a05:7300:d407:b0:34e:cd68:4a9e with SMTP id 5a478bee46e88-3511147a75dmr7955766eec.22.1791127035785;
        Sun, 04 Oct 2026 08:17:15 -0700 (PDT)
X-Received: by 2002:a05:7300:d407:b0:34e:cd68:4a9e with SMTP id 5a478bee46e88-3511147a75dmr7955731eec.22.1791127035151;
        Sun, 04 Oct 2026 08:17:15 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3512713c9a6sm5547160eec.5.2026.10.04.08.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2026 08:17:14 -0700 (PDT)
Message-ID: <720d7a14-763e-42f1-b892-c5a22be4a8dc@oss.qualcomm.com>
Date: Sun, 4 Oct 2026 08:17:13 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 ath-next] wifi: ath9k: delete channel-context timers on
 deinit
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
References: <20260911213144.130192-1-rosenp@gmail.com>
 <87eceydgiz.fsf@toke.dk>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <87eceydgiz.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA0MDA2MCBTYWx0ZWRfX7DCqRLiBTJ9L
 WpdM2JSo2njTMKOjDQppeQE4H4bK2yy5d185N33gYPQDtGYeRWpe0bTm7ZAAKGnVOD5rOES7T2E
 1zsrt5RyPUoOTPlbGotuekrlC2yUR4SpscFKLc+xi8PB+LGN2Qag7E159k47p90iNuc5vlINCXT
 zJ0stuvdJrdMbPYlMSOWgEIWHb8Jjzy93bwdSKqfThkVhwnuUt5Tl2xWcSeYNQn/WSj90bN27bt
 i6ubL3XdA1JKny9DpAK9NMFKgVe6nn75DgvQAc9zHOy/+94SvwfuTrkv2jVekF8r8MbCFNnyqF7
 +fxRb4Tbeb1QYkSiJMcTBhzD2zZCLpixNz6rY77thGtyDGuCxSkBHFLZpWOWRYWAxydLgTXhzj3
 RRiLB2WZSzaGMn8Uoe3iBPZD35ALpQKgCetW/fo4LXc+jsCLwPC6F7+IsMIyqQ613RoL9UfCVwH
 Vd22BgrOrXQqi6xR1rA==
X-Authority-Analysis: v=2.4 cv=b7MncdGx c=1 sm=1 tr=0 ts=6ac26dfc cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=-Ohwa1HQkvWuuYyCLrcA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: i1JIdZ2C_1E5TuFaArsyliZoxrqb4lDM
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA0MDA2MCBTYWx0ZWRfXyI9ndIK7dKpY
 d+lSj88DtpheRuhr0A8ih9PkKbo2uua8SvifpWQhynjdnYntN20EW7xcadUwBTkA2BukYtdW8BL
 jA92130Yn7m82JgVTe4NyF+LOZLEQNk=
X-Proofpoint-GUID: i1JIdZ2C_1E5TuFaArsyliZoxrqb4lDM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-04_04,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610040060

On 9/12/2026 1:23 AM, Toke Høiland-Jørgensen wrote:
> Rosen Penev <rosenp@gmail.com> writes:
> 
>> ath9k_deinit_channel_context() cancels chanctx_work but does not delete
>> the offchannel and sched timers set up by ath9k_init_channel_context().
>> If either timer fires after deinit (e.g. during driver unload or
>> suspend), it accesses sc->sc_ah which may already be freed by
>> ath9k_hw_deinit(), causing a use-after-free.
>>
>> Delete both timers with timer_shutdown_sync() before cancelling the work
>> item.
>>
>> Assisted-by: LLM
>> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> 
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>

I'm picking this up now. Will add the following suggested by my review agent:

Fixes: 705d0bf83dbe ("ath9k: Add a routine for initializing channel contexts")
Cc: stable@vger.kernel.org # v6.2+

