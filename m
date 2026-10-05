Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FFF4BD119
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 15:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212663; cv=none; b=M2v5goIXYjjU8wBOk+U2UZszCLLx9WK7HRHz/tK8vVfIXHHANzQPyBhDdxlO5l163srO5Op04wvsDGlwqU2Y/1LEUmUTIdzONYjpO7dD2xoaf5DI0KoPsYvV3L+LHZA5ZbdIJAckd4KlCpuP8ioZ/7zCo9U3zlvRD7GEaoaODOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212663; c=relaxed/simple;
	bh=yRthJvUVYmdOUHaQib6uAytRZ2NbWX/AgD4FklHnb8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UmLF9Vw4UoCvtRZOmbmgQROBCo3PhnydS7qyJF+syu4yOE3vOc3xd7B6Tr533PcaqIs2nXJc9Wk7qZvr8ewybGLGUXKy9mdOimjzy0+QEgjuZ3vbD6kCmdK+l1MMoDwunBzhAKhEXWFWcVh8Y1qOvYYxbuezv3iWR59AB0Ek8Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gk1HZM7X; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cIMzAyRH; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gk1HZM7X";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cIMzAyRH"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695EP4Zf2179012
	for <linux-wireless@vger.kernel.org>; Mon, 5 Oct 2026 15:04:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qXVGuZtFOH8Mp5oPSiOEDvmQpYflZiDKAoRzGqIO4R4=; b=gk1HZM7XybugdCpJ
	J0BOmRtb/fP2GoAxIPiccRbCqRGR6mJVAYxZbCWq/kEcaFTbuSECy1mt14JBLBq3
	AdxwgC88xDk9WeqQXHp8KAWF3b2QfBsMS2n+/WvNL+9b1Qd4Iw1u/0SSyDCYayd0
	rT88qBV5DvfD9mH4nlWebvLgSM02x4dggW946+Fibq3PGpLgrF32lCwKcS67iW28
	YTrcvBi0Qyxvz7nH7H8Ra389eW//fB5mlIy7pHP0cNsPtme6zCTtCKy1G3j+NgK4
	vbP+yOpFgFAjuzgF1ctISGKaT7PioG8ZJ17bphL/uBdkayVXjZLMOEoldN8t0NxJ
	PUBzUA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4cj60fwy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 15:04:20 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d6f75c1219so27734345ad.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 08:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791212659; x=1791817459; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qXVGuZtFOH8Mp5oPSiOEDvmQpYflZiDKAoRzGqIO4R4=;
        b=cIMzAyRHbPE/OW/zVrExyDoX4wK7YqWD+f8fjORpM8u73ABoqH6smkr5EgyJXeK8fz
         CI4+wOrfbmvXJZmmUdpTn3V3umYqB/dT+QMxKgLVGqTGgDYtwBUA0X38zL6V9YEXjJzR
         KY9mXVJQteJhEMfJJM+C+eGvFsuCa9lw01BQuJ8ElyJJ70Zt223JH0fPMj1u1H1dJ/yf
         WXp8lsR2lEWSnMXEER6mF+G+ExZzLeBfeIM0Fn8p7bxyEJqCn6AW6tNzlW/ZxW3hWFKg
         GYdfjw5RxhsftYtYf51I+udCBCoLXdbXUBvZTt2qqC6Yboo/u2AFaUIZtTKWqF5xsEXR
         JFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791212659; x=1791817459;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qXVGuZtFOH8Mp5oPSiOEDvmQpYflZiDKAoRzGqIO4R4=;
        b=sOVWWvWcIQ6QBlHuiFYDb6RbPViplNWsjsE/MgampXc3XwCvmp6evlAntcbX2Hxnkq
         jvPwM8O4UdV2gx07AtsHYi3rxxur3235PDkFs6DJlACBALtZpWkDRDFrrqSAaRKpCviR
         S9At9As1zDvPbOUCA6Q15Por56itKK6ynAF7PV+6rsKWo5N2pIPo10J5FWhPd0hbzr1F
         G6cKImdMOAM11PVmG+m4diSxP4YYQjqFSprEvXm9DBcysk1utGXzJPKDSOFt1ngFmtHX
         HK4bKXKzDmDKMpNafIkJbvHMUalrxOTnbtE1Vv/uwsbnaWLKT81jr0C66yDdugCk0FTi
         kmew==
X-Forwarded-Encrypted: i=1; AKwUvBzyJ2K0i4CIrEcmq7IAedpaybIuTwG5Tn8hUX+qr4+/ggnlokTsF0rjmyPFk6KxhLqbR4KAadIlzDgsEorWsQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYI+l79dj4pd554t7fDLo1yH4QTSNbca5Igyh8O0hJlIw5vW+cwJ
	rysA6RTpKsc54i/h9nKp+QMGtUu6aB88djBEpE+ipMgTyNXYpRtLsigBOr2ve2XEEenEU6Se1Ta
	pnjRcb8dayrpPSlGaivFjLGPJtgCvT88uAc20lGv0Mx51aRGiB+qYUhRAq26qcyA+Ruz76A==
X-Gm-Gg: AYBFou2cxtE8obN4uNNfT3AJYkxj+KVxpwUxB7d1pGkchdR32C8YnuVEUTBPCnc9OAv
	AheEQjsB5A5Euz+JtaFdZwncu4BlodRQhC0c3l3Z4VAX3dZ1WS1cLeBRy0J1WRIDapqW0r5YqV7
	OjjasGkTmsNqOr+tzIAUHzR8MjDCi60E52GsjeVtvNjxIZd3oP+0o0zajWa2tHjle+kwCm6BDmc
	oKQFekmVfcYurWU57Y5aFEXer4zCDbs64cUxM3HnortlQMVi86gmLbQlQo3dL0pj4kZHZ7Ns9g6
	Kf0REkAdOYOJ7z3tOQgbp+TYUVYdjin7z1u31RvjnDg9NbwVlAOw9bVoNADYlTAYOTYEzGIlWt6
	7VLZTetXb9KW+yB2Becj7caHYKXGSkn3Wnu5YluC/UbMV9zOqaitfEONNAw==
X-Received: by 2002:a17:903:947:b0:2e2:d77b:e587 with SMTP id d9443c01a7336-2e510523256mr76423365ad.18.1791212659398;
        Mon, 05 Oct 2026 08:04:19 -0700 (PDT)
X-Received: by 2002:a17:903:947:b0:2e2:d77b:e587 with SMTP id d9443c01a7336-2e510523256mr76422975ad.18.1791212658941;
        Mon, 05 Oct 2026 08:04:18 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5ec7bf7sm9018055ad.45.2026.10.05.08.04.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 08:04:18 -0700 (PDT)
Message-ID: <9de3fe85-6a53-437d-b2b5-9a5ac83b9c95@oss.qualcomm.com>
Date: Mon, 5 Oct 2026 08:04:16 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] Revert "wifi: ath12k: add panic handler"
To: Joonhoe Kim <26rote@gmail.com>,
        Yingying Tang <yingying.tang@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        yintang@qti.qualcomm.com,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
References: <20260612032332.2278338-1-yingying.tang@oss.qualcomm.com>
 <20261004093456.74263-1-26rote@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261004093456.74263-1-26rote@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA1OCBTYWx0ZWRfX0uzJm15q5wf8
 nXlUm1fUna5cLxQpUPMkm0Zul4duWXbo8T5GGZFWOeRqRNpREJ5lr08LT8K9cBdQDJybwMl0MEh
 1PoS4hw3lESsu+GFmMytoHK4Vzc9HTkseqznrshnE7l290w1JQypSwmmKI2OYxumGQXY5d1OJuK
 V55RJ6zuK+eimJh5D3tUwyyPgvzK5MOZXMsGfVPUea3xlfcZe06JHib83cwKbwAo4yyWZdl2rbI
 di3YvBTqtsoqZmXAUzxfZ46oI+RylSbwjN3OYfSBSsf5E3sL26BGUFVrZnMAFhZ+PRVTnOht7Uw
 bfqm3WTZddNcbZ6klHXk3aFFbqDF/jAyTsAIr8FYQv1BG/JW1IBMyXV+Ir3obYq6PQFnVDmQb4F
 1FqsgaVv9tdTCmJHslpNFAoXM3uO1XbJ4PDKVuTjdkfIJVi1YPQxtLmzS2VVRuuEiuJRz6hJ4NI
 gJT55tyu0yeGuLLds/w==
X-Proofpoint-GUID: T9yCpMTVZRLCwMekzNPVsnhDhOcbGFUt
X-Proofpoint-ORIG-GUID: T9yCpMTVZRLCwMekzNPVsnhDhOcbGFUt
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA1OCBTYWx0ZWRfXyeQ+UsjV/YVS
 IjrnMqmQujqoW3SWSmcopQiJJKOAk40b7DkbAIrJx2IDnOJWmrQPfOj/aX95QO935Es8Df2E85z
 8CeO1ecBUquW+dMyeaQ1QxiZSMpyKn4=
X-Authority-Analysis: v=2.4 cv=bpTZl0ai c=1 sm=1 tr=0 ts=6ac3bc74 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=pGLkceISAAAA:8 a=eD00KxpnBtPYGZ8zRHUA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_04,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610050058

On 10/4/2026 2:34 AM, Joonhoe Kim wrote:
> On Thu, Jun 11, 2026 at 08:23:32PM -0700, Yingying Tang wrote:
>> ath12k_core_panic_handler() is invoked via atomic_notifier_call_chain(),
>> which runs inside an RCU read-side critical section.
> 
> I hit this on a WCN7860 (hw2.0, PCI) in a Lenovo Legion Tab Y700 Gen 5
> (Kaanapali), v7.3-rc4 plus board patches. Here the panic never got past
> the notifier:
> 
>   SMP: stopping secondary CPUs
>   Voluntary context switch within RCU read-side critical section!
>    schedule_timeout
>    __mhi_device_get_sync
>    ath12k_wifi7_pci_bus_wake_up
>    ath12k_pci_read32
>    ath12k_pci_sw_reset
>    ath12k_pci_panic_handler
>    atomic_notifier_call_chain
>    vpanic
> 
> A hung_task panic stayed hung until a forced restart, and a sysrq crash
> only ended in a reset after about 50 s.
> 
> With the handler removed, a sysrq crash reboots normally, and after the
> reboot WCN7860 is enumerated again (PCIe Gen3 x2 link up) and Wi-Fi
> works.
> 
> Tested-by: Joonhoe Kim <26rote@gmail.com>
> 
> On Baochen's question, the handler came in with 809055628bce, so:
> Fixes: 809055628bce ("wifi: ath12k: add panic handler")

I'll pick this up and make the applicable cleanups.

/jeff
