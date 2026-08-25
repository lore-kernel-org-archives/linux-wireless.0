Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA3A40243B
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787668596; cv=none; b=vBGLse0gqJiyKLf4LVMUP2XDl26mbYPN+bseSWfmy9/wla5I70ZldkKZSlTshnfi9Ls7lQaRgz2vCn9p0UUYDcKcOuzJks9hmZJ5KGaM21e6s+Ca1rM4Es+Z0Met23nAFdOaYfa6NUMJGG+jAnl96WDgCl04sfcG8k2fuGacqOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787668596; c=relaxed/simple;
	bh=3i66pj55mhBhDjeU7OJOb/KTTbeGUuHuHyPg+qJMsJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JkUGpDRRXjKFs53IVCn0BpifPSBqUBU4NKr4bmR7JLUM9jlJ99LnHvp08EYKr3ErUYewGZbnNv5SSzgeKb9ia/lDfi1plMEgeje4LXHMlB6aVwTy50918cxQguKU+OQrhi1Szoz5cRLPgmFpDv3cJT2+QuXbq+tQ07ITqX96JAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YqIFvd5o; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SgBuILkT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YqIFvd5o";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SgBuILkT"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67PEUqVB2243783
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 14:36:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nqb1hLPCdBMX9bDD357agm6jzjxUoiWPN5Gk3Bmu7w8=; b=YqIFvd5oCNH7HRGx
	xQ6d9eQN0oa9ar90Ocv/ts8ADYck9PRGrtx5mdBwZcNpszaPhayC2bQ9KePkMAf7
	3DhJHd11WsIrpUCmadBLAvWwjeNSsh0tdA2nnomzJTrjyGWPNVGvxwayaqa7PoC5
	+2dCjTb2Op+RCBa1JgNpBIFYbGjeIrmdn6JdP2LlK+zp8DlWg4hkCQsmLm0EgDrx
	QoPMVR22SQ9RT7C1Drf5NzVPOJdBx5Qp3Xb3NUjWoYsPk8J2xMZPMENWzoXKodPr
	XY2H9ItfFRZFZsDuZarAkgFK90kOhIzoEMci/CMozxXwhneZVA8ItcVFjAgajfzA
	RHUckA==
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g96absy88-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 14:36:33 +0000 (GMT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4ab4dd46ddeso3959502b6e.3
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 07:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787668593; x=1788273393; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nqb1hLPCdBMX9bDD357agm6jzjxUoiWPN5Gk3Bmu7w8=;
        b=SgBuILkTwalAHz70Yaoac1oqaGnJ4AOFT7aF4tlq7RMN8sVIxKJbV49l/gqkZC8+0c
         qeU2mPTwjCYi5kqw6hrP5YsfHSXNQ3e6cCfKJGDCbd/S9WtY1VvtdyLaFeBjIv5pUNMv
         +f44AqQ6Q5SQpJIE7ZKNd5xYKe3bepkYNrvfmmxECvlRZ+NuBmoQJp/OK15i/5r5ckAY
         loRi1YqhcY9OJYnuBAJVptTnoW3kMaNpHdSC4Wh/cWhgU5qnNf9QtvvJfqSui8G7xUYz
         tZ5MUiPMP3mMuy1FwK26azkAk+aLHfMxD54ArLcB7Q9+0+Qk0ukrfpyzMgq+3siRkGIW
         D4jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787668593; x=1788273393;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nqb1hLPCdBMX9bDD357agm6jzjxUoiWPN5Gk3Bmu7w8=;
        b=ZAuYvQIp5ufJcbgZBrTzaGVXPzXP2NF7gIsSSyiNCRQKIDEv3filmgS+H+6/3imL4n
         WvtqQR8sgIIZk8PKDjfg8TwEAhApIj/jZjlOcORhYinOI0vgsx6/HodSzoNisvwjkl1C
         k6BgMDN3EXCkGEC8FIa36a2lj5saJmbrBqifhbqyyh5c4jb9j5d6U+BKpO2yBVsBI2Dg
         AG6bMEwXxeYxXnhvtFiNF3vi+eyhtxzrBDX7BqlM6YA6hvlpA01w0cek20bnImpYzbus
         SkHYaa2VOHWWHtnKoSQGDyiRBxO83gWcMxpUlSWmTGmiTFCrMBU1WVOMEvJCtfaMTqj0
         wCbA==
X-Gm-Message-State: AFuF++nQfG1AksmmAbdAe8EgBk3c3oHs57nCT5DI1ebQD11ft5BT1qg2
	wAG/9pFsqqUcVFocHPC4D4rlL4/AK3b6yB+8ie61UM8p8nmqWMBS7YT+01yUyAQhlIZPzZ+isSe
	4cNeb5w8yKIdboG9+Z3B+gFrezgN79iZhzh+2qUPG5RbXv19UYA88y6IzxfAjZZWUuwSqRA==
X-Gm-Gg: AR+sD12Qdv6OypVGucpattbNnHZCmvqCvJmTk9tInfChOjcqGeQyHU4VFx+c29f5m2r
	7N/0JGuniJifxffCn560WpHF4GScGOcJbBWlNSAwQnUqeo/DpktpWpVyV0wb4fSMIZHIOfDsFlT
	i9OVKJ0pnZQTg85ZlDY+qk4MM2BRFFH0AEPlBPhQmxu1seV6EgOfvCEo4K4gXIsRTUzEG6bCKrb
	YCS2JiZgDq9bgfXbsovXU55cJYUQDUKCJDQnjWhG/lDqM3zjsVXes5qysU8b3uunQ8K2C/O6wUk
	2GGQ8hJzJ6Ba4pt9vi8yOSqbG4+kTyh27w1/gTfD0Z862n86MH/HhkSascn9LBaLHpaCzMcjzlo
	Z7NyRmNJuUDOisGo04yEGsdigXUI5WyW9NuHuf3EEKCCSLSOo8DmPhgFyuGp9
X-Received: by 2002:a05:6808:c292:b0:49b:33c8:4b75 with SMTP id 5614622812f47-4b309a50d08mr25270521b6e.5.1787668592652;
        Tue, 25 Aug 2026 07:36:32 -0700 (PDT)
X-Received: by 2002:a05:6808:c292:b0:49b:33c8:4b75 with SMTP id 5614622812f47-4b309a50d08mr25270466b6e.5.1787668592157;
        Tue, 25 Aug 2026 07:36:32 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b32c8c8093sm5746072b6e.17.2026.08.25.07.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 07:36:31 -0700 (PDT)
Message-ID: <2280a747-03d3-4468-86c6-6fdcb2154285@oss.qualcomm.com>
Date: Tue, 25 Aug 2026 07:36:30 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ath10k_pci: QCA9377 hard lock on resume from S3/deep suspend
To: Omar Abuzaid <omarabuzaid587@gmail.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CA+kcdF5BtM9dZJ6JNAvvsTfFZ18xcio06iSsYHGY4S7xDjtZ2A@mail.gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <CA+kcdF5BtM9dZJ6JNAvvsTfFZ18xcio06iSsYHGY4S7xDjtZ2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI1MDEyNCBTYWx0ZWRfX6xojwolnwK2Z
 //QGVKBLkwewOX3LKjUxIsW4vJYsOOMHv3EjG7ahiGKGjB5pHr9JqK96djZmYGSd2q/LjmNVxiT
 +3GETc6hVlC6UDtbyKOIu3+FmAxo9yjLLJBRRGN97qoj/1XTs72YczOWbLM+ltGdx1HCJO4z0Xi
 MveaPUGlsSrqgUAw1Gi1SuaHwdBRnbscTos4KrerRBHluGeUfMHrhCm7gOJt5x8DDRhA/us5Mw9
 p9aZI5inXV3jCg49NJPcxgyMow57HXWQpetGghbNpnK4wGdmJfjicw8XUsVAiNsuoyIvr6ILA8k
 5MJcuurl4IkYxxcbyz+kJyZshapBw7otYK6UV9R6OpdRAMLYC3K099c2nAzb3vsAQiSEV9pyDUk
 BqyJ7WsvYCaLxDf6q5Bg+pwCn37p6mTXX23GQJAXnf2XgB0ZHeoAkXKQCqDlVkafmO2EI+V3OLF
 MT/G1CH+lYRUF9MK84w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI1MDEyNCBTYWx0ZWRfX2gPOWwVpu54T
 Vc+Ky+ILT0+HHN3wqsl6wL8I7iwtgXGqT/pYcXTEDh2WlO8UTro/lbmvnl6LwywdQthRTBhmihe
 0LBbzMdJoen3rftiRFumJBiQv8yoqvc=
X-Proofpoint-GUID: apQmCF4y2ti5KEli8cbDyANNCmnZNHbf
X-Proofpoint-ORIG-GUID: apQmCF4y2ti5KEli8cbDyANNCmnZNHbf
X-Authority-Analysis: v=2.4 cv=SaHHsPRu c=1 sm=1 tr=0 ts=6a8da871 cx=c_pps
 a=4ztaESFFfuz8Af0l9swBwA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=i5WpYceg8j5kjbeVgd0A:9 a=QEXdDO2ut3YA:10
 a=TPnrazJqx2CeVZ-ItzZ-:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-25_04,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608250124

On 8/24/2026 11:41 PM, Omar Abuzaid wrote:
> Qualcomm Atheros QCA9377 using ath10k_pci can cause a complete system
> hard lock when resuming from deep/S3 suspend. During the failed
> resume, the kernel log shows repeated PCIe AER Physical Layer and Data
> Link Layer errors involving the QCA9377.
> 
> Unloading ath10k_pci before suspend prevents the problem.
> 
> System
> 
> Fedora Linux 44
> 
> Kernel:
> 7.1.10-200.fc44.x86_64
> 
> Architecture:
> x86_64
> 
> Kernel taint:
> 0
> 
> BIOS:
> 1.32.0
> 09/03/2024
> 
> Suspend modes:
> s2idle [deep]
> 
> Wi-Fi device:
> Qualcomm Atheros QCA9377 802.11ac Wireless Network Adapter [168c:0042] (rev 31)
> 
> Subsystem:
> Dell Device [1028:1810]
> 
> Driver:
> ath10k_pci
> 
> Problem
> 
> When the system resumes from deep/S3 suspend with ath10k_pci loaded,
> the entire system can hard-freeze.
> 
> When this happens:
> 
> The system becomes completely unresponsive.
> Caps Lock does not toggle.
> Magic SysRq does not respond.
> A forced power-off is required.
> 
> The kernel log around resume contains repeated PCIe AER errors such as:
> 
> ath10k_pci 0000:02:00.0: PCIe Bus Error: severity=Correctable,
> type=Physical Layer, (Receiver ID)
> ath10k_pci 0000:02:00.0: device [168c:0042] error status/mask=000000c1/00006000
> ath10k_pci 0000:02:00.0: [ 0] RxErr (First)
> 
> pcieport 0000:00:1c.7: AER: Multiple Correctable error message
> received from 0000:02:00.0
> 
> ath10k_pci 0000:02:00.0: PCIe Bus Error: severity=Correctable,
> type=Data Link Layer, (Receiver ID)
> 
> There are also ACPI errors during resume:
> 
> ACPI BIOS Error (bug): Could not resolve symbol [_SB.PCI0.GLAN.GPEH],
> AE_NOT_FOUND
> ACPI Error: Aborting method _GPE._L6D due to previous error (AE_NOT_FOUND)
> ACPI Error: AE_NOT_FOUND, while evaluating GPE method [_L6D]
> 
> Steps to reproduce
> 
> Boot normally with ath10k_pci loaded.
> Confirm the QCA9377 is using ath10k_pci.
> Suspend using deep/S3 suspend.
> Wake the system.
> The system may completely hard-lock during resume.
> 
> Isolation test / workaround
> 
> Before suspend:
> 
> sudo modprobe -r ath10k_pci
> systemctl suspend
> 
> With ath10k_pci unloaded, the system resumes normally without the hard lock.
> 
> After resume:
> 
> sudo modprobe ath10k_pci
> 
> The driver reloads and Wi-Fi reconnects normally.
> 
> Simply unloading and reloading ath10k_pci without suspending also
> works normally.
> 
> PCIe information
> 
> LnkCap: Speed 2.5GT/s, Width x1, ASPM L0s L1
> LnkCtl: ASPM L0s L1 Enabled
> LnkSta: Speed 2.5GT/s, Width x1
> 
> L1 PM substates are enabled:
> 
> PCI-PM_L1.2+
> PCI-PM_L1.1+
> ASPM_L1.2+
> ASPM_L1.1+
> 
> This appears to involve the QCA9377/ath10k PCIe resume or PCIe
> power-management path, although I cannot determine whether the root
> cause is ath10k, PCIe power management, device firmware, or system
> ACPI firmware.
> 
> I also filed this with Fedora as Bugzilla #2523243.
> 
> I can provide the complete previous-boot kernel log and perform
> additional tests if needed.

Please see:
https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath11k/bugreport.html

Although that is an ath11k link, the same guidance should be used for ath10k,
substituting ath10k for ath11k where necessary. Having a Bugzilla record
allows the issue to be assigned and tracked.
