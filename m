Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D14339395
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 14:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789827692; cv=none; b=mA6j6dnulg/TbAoQzPDWBtw58dp+kqLac7Bc8EUqBgGkr4xkNsd9HwdNLCfnb/NRnepp/nPzDgDiYKEvschu5zrMLVEQa1qUGd40me2lEGcZ7W5pgk/DNuafJ43rTjdzuIUjA63XL+mx/CHgc9ui61HIHm9UZbWSFjOdivTR6g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789827692; c=relaxed/simple;
	bh=w6oS773srn+oYMaSkw0e1YRDsT0tlnabT6vZ9CCf60w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F2P02j4fB5iZK+uOkz/nSBzFr6zAji+7hveSRdEm4Dmhd+LPJn0PCD4jIUy+JVFbaO+JDG8X2KIIS/J517WoovzR5DJHp5w28cZuv0jW4kVr0TcMcnohMURFAjj3Z1zXIhae5jTyZTesyfaFxGd/IhJ6PatdiEmFN9rfzSx42+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Q0R9EKSG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JdqSYdV2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Q0R9EKSG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JdqSYdV2"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68JDK2Zx049201
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 14:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0gjyz9E6/QmQLRCdy/3pVAAkYuVkZTNhqOb8DDaTX18=; b=Q0R9EKSGLegCyeYl
	BeG4PkHqxQrzu/Je1cWIe5Z/5bDxB2icKexCIasUL+meTiq9eyl6o8t2p+sZndsU
	dBhJo4u0dMXBCJo6uU01boXWq5V3qxa0+aI78ZL6sgtkv6vdl/ToJ1sU4uEq9RN6
	LbEGK3VPvMJQ1WGzi0F2MrIiucwghlkGSrwC52G80dv7n0o7YqCzjX8fZW+u/++c
	QfQbxi3IhafYqKUevNJSIJMxSRUFlI9hhN3wicvDs8289w0kWVkqnOeHryG/JhU3
	VF4vtNP5nRevvAGABu7glerWdWdiUk6eY/s6emUoh6htP8WOeUb+lJpJZoahFKJ5
	nQ1XJg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gshd6164j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 14:21:29 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-381250979d5so2127035a91.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 07:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789827689; x=1790432489; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0gjyz9E6/QmQLRCdy/3pVAAkYuVkZTNhqOb8DDaTX18=;
        b=JdqSYdV2I30HIV/19xtpHwC0B9AJLaDUGrktbeUFLQPvfyW8xkYIm89bfx07xfg9Ir
         l+X2Eqdp8flSwtMX4xyrDvylKnyGt0m3J+UpIGdaV1NPlyQ+L7lheH6qlb+5tbIICLcU
         OPCy8DuDFcHH93xS399NyYCfCFHlmJEqdSZcFUlT52L1+MNfc9lot/3QpQx2TsqcRnEo
         kbGOihlr80uCj8CPpTKgOr64zdVccKC2alzqHaU55DeR3YCFnDZXNMRsU1c+C9ftIhaQ
         zy9sTgVuCOuXGFa4Py/UBgLJsX/nWrNHMLXKVQpqNOMy52EIeVIPsLcQK60DLstqONz+
         eBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789827689; x=1790432489;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0gjyz9E6/QmQLRCdy/3pVAAkYuVkZTNhqOb8DDaTX18=;
        b=bwrWBnvDJw7jQdzNDn8beD1I8mLdhstu6XIAqLpJ4jlLs0TI2aN8edsQmjrGDEXgFN
         KTxmUKLL1Up1fXALFQk3twYJhPxnbplVrPYvD91mtcCWimmRWIlWLg7vmJl4GB2Yk/D4
         wzx1sEnKtZHgjrVc/R6rlh5zu7hwv7ZMsLxESJ1dpCAELwR7nstRr8SUd6AN6MmMpwqk
         ALW+nPV5jxlJmwSVN5ZOJBH5UOBxrYb2jCcRATDRSjdeiEirXh3OmzcqpltUzubZCw8i
         CY7GtPDXPn6+dk3hIu41vXlqvz/7Rv0GQ62C9vHpYqsinASFlW1Id6w0v0j0ZHEt4L0I
         XvDA==
X-Forwarded-Encrypted: i=1; AKwUvBwxdQnyy1LcHcpiXJl/qsRpMLln69ypNAFQwZDADEQOc0VTqQiXLkDBZagTSrdXKhyNVBVeEkGO8pU8xl+8kA==@vger.kernel.org
X-Gm-Message-State: AFuF++ncjrSDZJxN8EDX8MUr+p1YYp10QolHodTBSi3fKdJdaZf0jHgM
	Ap2Z9kj61ed0p/fM4pArITMMbV8MbQ3lL1avs037/hdb9X24edeJvXuc+k9GZEQbWnO/x0MD0Rw
	40LlSKeLjzl2AcEHg3ITjWZOgI6tsW2+48cHzl0pLboUz3pvfWXdGeOyvKzsfzHInw1VlgbYTmB
	jHzw==
X-Gm-Gg: AYBFou1NdTU15149z/dtLL+Zo+EdMAlmpmkdycTGh9IXx3puJSb1S/5P4TIxyyyTPOC
	CFLkXWH7qRUc5lojTV3s0Y+H1H3bPKKJUUOtFq0ae2SoDvkv/IGYLA8hIvIusVeu7OB3f8S8+qY
	AwfgH36rk1fvhy8EDcf+EE01FIdhxnoXdmjRK5xGW3SfGVg20k/KSnA7m/ijl5pjiHlDE8H2rme
	UWEwVSTuNpzIidUryaViUHkgaJxTRUzpU4tH+MZZaoPCWQ0amVr0aNzE8uHqNh7byaTpywRQkdP
	rvQKtj4Wc7Q69aG2eoYqxbJgzjZL7MbOfbvcsmgnm5jGP+etzdRgyyjTehNmxrkYO/Px/UKwIQE
	BQAGm2h1UcGBhjAR1FPYl6fLkjaymh/6GBuRuYFkBQZW+MKfV4R9msfejLg==
X-Received: by 2002:a17:90b:2f03:b0:39e:1693:c3c1 with SMTP id 98e67ed59e1d1-39e54e3d374mr11379037a91.17.1789827688492;
        Sat, 19 Sep 2026 07:21:28 -0700 (PDT)
X-Received: by 2002:a17:90b:2f03:b0:39e:1693:c3c1 with SMTP id 98e67ed59e1d1-39e54e3d374mr11378999a91.17.1789827687974;
        Sat, 19 Sep 2026 07:21:27 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144d54b248esm944821c88.1.2026.09.19.07.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2026 07:21:27 -0700 (PDT)
Message-ID: <0c08df2f-21db-4cda-9d38-491b98d8f207@oss.qualcomm.com>
Date: Sat, 19 Sep 2026 07:21:26 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WCN7850 on Surface Pro 11: no board-2.bin entry, firmware reports
 no board ID
To: Dale Whinham <daleyo@gmail.com>, ath12k@lists.infradead.org
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org
References: <CAFcmK8h2nv5VPFErt-E93G6cKb-Ju33hfc=pSrTABK7nu_4kRg@mail.gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <CAFcmK8h2nv5VPFErt-E93G6cKb-Ju33hfc=pSrTABK7nu_4kRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDIwOCBTYWx0ZWRfXyC0nPZf+FIV1
 /roYR77IGumnlLaLvCYUq0s72MB7i0aLf/LXzpr+XBIHVnyxHKqxzkNulnD4RVBqMsCzgKPyapC
 PTKkN+OwfYWccFswj/wDw7IojnCz6w3VKsj0WbgcBTTt7kDqId6+fmtpKmyUAeyOchtesmJ2hyq
 x00RhbDFuKLbToYTzAObIB71HINEDP7+KQWXJPO2ipwBLMaZfLeW7gvcW6ntJqHoINQrueH/n6E
 bbtn6AJwSg5htH191UE/YNAz+PPmOpIHjuKFl8s73BgYBcyWQnP+jH0rcs61ioxls/84mSL6DcS
 Mn56QU2P89+/45nCuV16yNRgBhgprZZDjXte1ndGccKzhd+qmtu1Cd6PIcg3qmx4TD9v8x0tPQT
 /6fQAo8jC5ESBxaKE2QYb7KuU4QcnFuQtqVY2J2UBer7uOXR0w+CvFvT/RAhqDtDvtJDFRqO4SV
 vFmfYuRZt0sTLnHVNoA==
X-Authority-Analysis: v=2.4 cv=RMQmjIi+ c=1 sm=1 tr=0 ts=6aae9a69 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=JWOnVAuZ3AbGg8kBoHkA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: R1AOrpWiSkgKp-_YQSROIOL5aqzv-RWb
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDIwOCBTYWx0ZWRfXz7yiuuWyRmkS
 wlKPzeesmkf2mqU1xrxxycs3YHmdu2dCNFK8kxjXGfDoCx7OrfU3gRe8IDN4IfFNrOcYwhNXviz
 Ypv28vPRPDI4JfVufCTUaw7RxZzbqU0=
X-Proofpoint-GUID: R1AOrpWiSkgKp-_YQSROIOL5aqzv-RWb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-19_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190208

On 9/18/2026 5:13 PM, Dale Whinham wrote:
> Hi,
> 
> The WCN7850 in the Microsoft Surface Pro 11 (X1E80100) finds no entry in
> ath12k/WCN7850/hw2.0/board-2.bin and falls through to the board.bin
> API-1 path. I am looking for some advice on what the correct fix is.
> 
> The device reports:
> 
>   chip_id 0x2 chip_family 0x4 board_id 0xff soc_id 0x40170200
>   PCI 17cb:1107, subsystem 17cb:1107
> 
> A debug print in ath12k_qmi_request_target_cap() shows board_info is
> absent from the capability response:
> 
>   cap_resp board_info_valid 0 chip_info_valid 1 soc_info_valid 1
> 
> chip_info and soc_info are present, so the response itself is fine. The
> 0xff is ATH12K_BOARD_ID_DEFAULT, substituted by the driver.
> 
> The names ath12k then looks up are:
> 
>   bus=pci,vendor=17cb,device=1107,subsystem-vendor=17cb,subsystem-device=1107,qmi-chip-id=2,qmi-board-id=255
>   bus=pci,qmi-chip-id=2,qmi-board-id=255
> 
> Neither exists in board-2.bin (linux-firmware-atheros 20260810-2).
> The only subsystem-device=1107 entries there are qmi-board-id=44 and
> qmi-board-id=82.
> 
> Using a different entry from the same board-2.bin as board.bin does work
> (i.e. extract using ath12k-bdencoder and rename). I have been running
> the subsystem-device=3378, qmi-board-id=255 entry, which associates and
> passes traffic normally. That may be another board's data rather than a fix,
> but it does suggest the firmware accepts entries from this
> linux-firmware release, and that what is missing is an entry under a
> name this device derives.
> 
> I also checked what Windows provides:
> 
>   - Windows loads bdwlan.elf on this machine, via the catch-all
>     PCI\VEN_17CB&DEV_1107 section of qcwlanhmt8380.inf. The same file
>     appears in that driver for several other 8380 devices, so it is not
>     Surface-specific.
> 
>   - That file fails against the upstream firmware with -110 ("qmi failed
>     to load bdf file"). It works if the Windows firmware and PHY ucode
>     are used with it, so the data is valid for the part but looks tied
>     to the firmware version:
> 
>     Windows:  WLAN.HMT.1.1.c5-00310-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1
>     upstream: WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> What is the right way to give this device board data? Happy to provide
> further info or test patches.
> 
> Thanks,
> Dale

Can you create a bug report per:
https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k/bugreport.html

Then I can assign that.

/jeff
