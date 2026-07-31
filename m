Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57ED335C183
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 18:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521935; cv=none; b=LaQFJEWXNMYzJdilUFODBYtGXptJVxqbJXwVk//EFTId1xjZSQJEE4svRWCbHqjN/K/y9JsVZcx3GTF42VBSOJh8vzdaCRiWqIAMo3NhRL4raXAI6a23CNruUIwyXsDdZj4nYa+VQwh0EZIMqm+JVY6FwUCLLWI+Ff3475b6ojs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521935; c=relaxed/simple;
	bh=A3kZVk2D5RpEIPlDeJOXuS6pin23WgE4MZgN/l5ld08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Citu5dD6ocfA5MfZPicliiIBQdyhnarhasmmw28SmNJu+v8ciM9HdLNqEFki6gmi+kcxt1mrGDgbtYBo3E2O2Qx6oGS04tpDZEn3dWAPaYVQ63j0CdJdnuDXqLhYIbQXy0Ebn2dbMSZ2DujWO9A1EG1mjM0MQR7qty6qQbFNgsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mCJCU2PC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gwpm4wwn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mCJCU2PC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gwpm4wwn"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFOtJR404281
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 18:18:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LjZ1dS7XAax/+9FcNAokaI+tqJjGNUhP8Vc5FzSLpsI=; b=mCJCU2PCCkprVW46
	i64BvP6S0yjHnCJaiY5UKZ4me1Dljv7a9FRWOYeETOF3QzWgMWe86fMSCUtFuAUg
	mpYnooVZlbJLkfMXT8cKYwTfjb0CKKveYcQ0WB4bliueUnK9kDMqYpSTVDZb4d2b
	ZGVRsnyB3YN6Lx5qMIH6VZOLKEccaL3o77y8nUiYhY6vRbgQ+mEcBhfhUxs0szF7
	sYCC+Fm54ma3cNT7J3VLSrrUeZneaJCvL8krorvkcU0CfvGOJclMBBQUBx63IU7d
	ScSsIsO/HpIFdaL/TP6tLWpFgCo1fWQ7cFINB2j2p5O+bGh9O1HOlTOWi2AFONEI
	GvHPzQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frufkhqek-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 18:18:53 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-ca860baea9fso2807986a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 11:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785521933; x=1786126733; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LjZ1dS7XAax/+9FcNAokaI+tqJjGNUhP8Vc5FzSLpsI=;
        b=gwpm4wwnmL4wIAtD71wbwtSIMpwVH3gw8vmo5bfvKgWNSxC6mF9xjKyn7fOsLIxkoT
         6VqEO2ARqrhBsZ9MqUpZTvbWWjLFEDHB+xSLj451xUZhkyAKxDPD35lXpIomT8nuKKqw
         oTYMzPrArL9gQrfGTpBoactTKC0vC4Nhl0ozkuKHVSwiWjksBuSGexIIhe0R/wmV73+z
         l7ZKKIZv9gau/n2/Pb8HerR4INmmjESDWNsM4mHDDZvpq9IhmfZJyy6dGUqekZYT0G7s
         VG4SAFOgjXaTSnevyzv7tRLzfW4K8SZ1jA8olAC+9nGCqnJlPsH1XYuhQU3ScoTiF0wZ
         7JLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785521933; x=1786126733;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LjZ1dS7XAax/+9FcNAokaI+tqJjGNUhP8Vc5FzSLpsI=;
        b=a7j6uCjLy39x+GRArfY9Sd+vhy4uEVkF358C6lQJMd4wWWeATLed5b4dQa++rJ1b3O
         utlmnJMKMP4nNdWYM6a7bHOv20v2rm9rqB4cwySBbr5VcYaZ3kEABxbbwWP5wikux4Bk
         2TftWbEkR8LY+bUkTvPQeP2tbje9QvUHMSK91ztRahecdWPuLfldX1UtkuVSscPDLUIb
         JhVCzS7ebl423V2wA5g3fQ8qSfInwvY21CL8Fn2O7DyU1kqxx6BDFQCDcOK8CXPWwwQo
         yU4TZDJYB61TeRVIJXdSznKimfEIwoelPCfSEY4AQqpwxlVI6cvUPyRTdzXHeZN8e10s
         pOfg==
X-Gm-Message-State: AOJu0YxWd5L4QuosJsRA0y/6A44daXF4dXtoVucUSRMiE1PwfneNu/i3
	y2BFUO1sxl8FdIm0NQPlmh33YWW3LIDCvHeKn/2Cvyat5XpqEk5+7bZJPkoSnWIRk4ag+w4w1P2
	jpLfi79SQFFouYBFzZ2fo/zT/jgbbaBejphalHHdarv02boU0f/hIUujuJ7UbqyPjQLV6x8UPkP
	S3EQ==
X-Gm-Gg: AR+sD10M3U1q+tVtdsUXk5hNheAyzzFDJ2FoW4Ik4QTz5MWDIZztgSrpc86HAIRQ8kx
	bbEKOa5RR2A3UZ1fg3YAZnk7jsJDM/lVXONOQ5F4IULRekMDTUzQXFuT2lNjE/5TituPUg7L5Qi
	4TXtaNK6XwDOkRxIKIWZRAqkRSj6S5BWhRHpHsQXBakO3QjccqpasMnKzS4KEakvBX6BGzoSG7L
	07PkGwt306Ax5QJn1mqhbliZfiife1YlRneck1ofJ5Qt2PcK3sPuSNGeECNlXStfopwXFC8D+fz
	Bnw9pHZZajzZCsaM/1Cubz282M1uxbGqSBpsKEPhCID6IOdehtDsa1uQJ9QGB61alNGBdLrp1G9
	53dRhHxaba5YmdaWoy9wBt4+YAD0iC4Ges3lkHW5IHFHyVAOn6s21UUqHiC9x
X-Received: by 2002:a05:6a21:600a:b0:3bf:b9de:8570 with SMTP id adf61e73a8af0-3c92a5cd5e8mr779484637.19.1785521933036;
        Fri, 31 Jul 2026 11:18:53 -0700 (PDT)
X-Received: by 2002:a05:6a21:600a:b0:3bf:b9de:8570 with SMTP id adf61e73a8af0-3c92a5cd5e8mr779462637.19.1785521932566;
        Fri, 31 Jul 2026 11:18:52 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e06f88fsm7754080eec.20.2026.07.31.11.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 11:18:51 -0700 (PDT)
Message-ID: <8dcc424b-32b1-4152-b75b-10bdac0af9d8@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 11:18:51 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] ath12k: NULL deref in ath12k_mac_op_hw_scan() when a scan
 is requested during firmware recovery (IPQ5332 + QCN9274)
To: Kamil Bienkiewicz <perceivalpercy@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
References: <20260731094141.2410630-1-perceivalpercy@gmail.com>
 <20260731175103.1745248-1-perceivalpercy@gmail.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260731175103.1745248-1-perceivalpercy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDE0MCBTYWx0ZWRfXyiXj2ZqEAI/Q
 c61KV+bi7KBDezaUxG/GmG1FqbUHaHHmnEQkpIAhPlysY/88fwmByn4PUajUpATVcZomAAtXAQt
 u02ZPLQ7b62bNpc9T3UcPPa8wuUvI8w=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDE0MCBTYWx0ZWRfX3FPPs3x4z5d+
 3exGfOG1eP2cRgyVU8XzthSIqXITIBCFbCDvWyrOS7DgWLBi9b9e0lm1WyhcFhZM5nnTFeMeQdE
 quGUgp5xHpWQClznQDr2FDcbqhD0dFGUx1aR/RRwoPJpc/yF3HAWdLho+j8hIttc5JCIreMVF5h
 7tg2XWzxV76zZNaE2glewVLSDQlX0flOtRw8GRvEU7yL1zdH+VikARoakQ/wF/9WrPIX21K1DiR
 YqQ6QkFgciF351i0pPhsStmuhBVBO2eROYN+P7z5EfydqUKEX+WdUk9TU4s/KLJOJkkpiBTZ8sL
 0YEjJ2TKaWsjnWOjir5ZXCyYmIoOK6rCFOHF4h0NtMBWPs+SLY07+b/BdzeLHPd+5zIWeNWnO9h
 EbpE7V089CfbzMPsh+tRn9YFFOqTagI0YOpNufxpDdgWdWincs52Zan+LQo5aXa/n+2aFVmJhez
 6gP9g2eQJ+b4Jsc8+Hg==
X-Proofpoint-GUID: y5wBNO-j-W7vJQcVYKdMbmPtf5qikzmF
X-Authority-Analysis: v=2.4 cv=BpOtB4X5 c=1 sm=1 tr=0 ts=6a6ce70d cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=sTRtGAPE7L7RgN1B:21 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=A4jFpDQB2FOHWKhnbncA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: y5wBNO-j-W7vJQcVYKdMbmPtf5qikzmF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 bulkscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310140

On 7/31/2026 10:51 AM, Kamil Bienkiewicz wrote:
> On 7/31/2026, Jeff Johnson wrote:
>> Unless you reproduce this with the upstream kernel you should be reporting
>> this to the OpenWrt team, not here.
> 
> Understood, and I realise the taint makes this hard to act on. Two things
> that may change the calculus, and then I will happily take it elsewhere.
> 
> First, the reproduction you are asking for is not available to me: this
> board is IPQ5332 with the wifi7 AHB path, and that platform has no mainline
> support at all — there is no upstream kernel that boots it. So "reproduce on
> upstream" is not a bar I can clear on this hardware, rather than one I have
> not bothered with.
> 
> Second, and more usefully: the code that crashes carries no local changes.
> 
>   - ath12k_mac_op_hw_scan() in the backports tree we build is byte-identical
>     to drivers/net/wireless/ath/ath12k/mac.c in mainline master. I diffed the
>     whole function; there is no delta.
>   - None of the out-of-tree ath12k patches in our build touch the scan path.
>   - The condition that leaves the device un-recovered is also upstream code.
>     ath12k_core_reset() returns early when ATH12K_FLAG_QMI_FW_READY_COMPLETE
>     is unset (core.c, "ignore reset dev flags"), so a firmware crash during
>     early boot skips recovery entirely. Our tree only adds a clearer warning
>     and a coredump call at that point; the control flow is yours.
> 
> That is the whole failure: firmware dies before QMI ready, recovery is
> skipped by design, the device stays half-initialised, and an nl80211 scan
> arriving in that window dereferences a pointer that is not valid yet.
> Faulting address 0x1508 is a small structure offset from NULL, and the
> faulting task is hostapd — it is running the 20/40 MHz coexistence scan for
> a 40 MHz BSS on 2.4 GHz, and hostapd retries that on -EBUSY, so the driver
> gets asked repeatedly for the whole recovery window.
> 
> I am not asking you to take a fix on this evidence. But if the intended
> contract is that ath12k may be scanned while a reset has been skipped, then
> ath12k_mac_op_hw_scan() failing the scan (-EBUSY or -ENETDOWN) rather than
> dereferencing looks like the correct behaviour regardless of platform, and
> both mac80211 and hostapd handle a refused scan cleanly — hostapd already
> retries on -EBUSY today.
> 
> If you would still prefer this against OpenWrt, say so and I will file it
> there. I have full pstore dumps (dmesg-ramoops with the complete log from
> boot to oops) and a deterministic trigger, and I am happy to test any patch
> on this hardware.

I've cc'd the dev team to have a look at this issue.

There are quite a few error path patches in the pipeline, both internally from
Qualcomm and in public from the community, so if this hasn't already been
addressed, hopefully the dev team can do so. especially since the full
IPQ5332+QCN* support is under internal review.

/jeff
