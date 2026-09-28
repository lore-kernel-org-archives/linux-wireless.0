Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97E34BCABA
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 16:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790614710; cv=none; b=CCckWCzX0d+9uNMA1KSPpODYd7iH07h8rTn4BYts8tZ+4HOGYvNTZq1mm/WIGlIK+fPDdzA+HeWQr2aESv7S+OIlS9fbQDTQ4XkjWX+WVm827RMv121NM6BVjX7DB3igd3lIPXedzGCw9lprD5zsggfPnXduY3MrEXDOQ3MsoOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790614710; c=relaxed/simple;
	bh=KVMNJqNww6TBAiEhHCC7Zg//yujvZYO99Nitrw7vGqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NSupO5lll/d8x7Md1IsHa+1he0CWXlhLVHDDAWWvkqrgy3sQPGF4jvxtsEUL8giZuKwmZzuahilLjdaKXkMThlnJTFE1/QCchMS9KjnMyqJuOsShQRmZPQ02cXx0sq34+cjCPCZ80WjpRHtOrL89fRiGvhnuXx7/43uPokBcFM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=l6diSA2b; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GF5qqy/f; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="l6diSA2b";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GF5qqy/f"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SEdroT1908463
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 16:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	o+2kKaVgsH8aYlHLbn2zMClqTNhp5rcXnKcP0njRaow=; b=l6diSA2bWvfGwhno
	75t2RmDPlnMXhwVbAzP6E1hpMB1UQkuKg4YFzDjIWVc4NoWrGfcSfkVP9UrGfVWy
	S28+tvMGML2+3NqibgUpK0zuvMDnQrK/o/cSU8mtiohVc02JlmMDdnx3O4MkVw7S
	P+v43Sm3WNEuVDH3rNODIXL75P0yY5P0q0EF7eFnmZiXMMXhoWJL72MX2yJdT/9d
	yYZLdtji1tqMCnPVhH41CSbgoqQi9yeXE5oBDDxVYtbBxwIyVn7XVGPWUfFDwf0N
	DU4erIGNO2v1P/E+gk5SHr+2V70OboVsnocSNdqx8UIoB9mMXrBgZZfDJN4hGVE6
	cjElcw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gyjkxjj9f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 16:58:27 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-349ffa249bdso1562740eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 09:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790614706; x=1791219506; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=o+2kKaVgsH8aYlHLbn2zMClqTNhp5rcXnKcP0njRaow=;
        b=GF5qqy/fyC5/1LWxJ6a6f7eqrvX0iPCNLQYJJybcpIOnFIYEeFKWmr9EWD3sCwvmtI
         Vrtb77gOTp7WNVtGCv1PJMkSKdhAgNuO/ToowaR1TyL7WuhmjWNpgj9Wpt6yRFU3UVb0
         7RsY9XXaSDVoLjtkiHNPpQgP5gGp63Njrxl83gS+TBfQZOG+VFqlid2mm7dZ3T8FOA19
         p+UGFjTqFiYA0UteHJZLCTglEbVAnKi02TeGaYCnKAWGHe3DzCk3vmX1hkA87V4E5TIn
         lbiSdKlFxQSpiODX+57gM59oi9MoYTBj/bKZmzswosS9VATKLmiVreqEOFSdlv3hjUgw
         08IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790614706; x=1791219506;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o+2kKaVgsH8aYlHLbn2zMClqTNhp5rcXnKcP0njRaow=;
        b=IAvCUQhs/SkooC5A4qMr59os+GoTcrjxWPEEfsCxEnwwrACG1j43AIaOylX5LdlZZB
         WfnQ9WF29Y9rIGfpey52FuW5W7FRkaUraoh+cNdHoUJKwoIqM+PbbgpCh6+ulBWW6gE0
         ntv0hDcH+Fvgym/InSEj+Q61XcJ9r9aKJ1gglfxBozRrQQXPSvMUTevq1yfTqPrIbHgq
         tBejw4IHMEl03CjK3qa98piJkSdsyhpz+DYxYfQ8SlvsuoMNPkZMv+eCHkhi8sJaC7tz
         j3t78izDwkg/iYYFVRo+B3R1wPREOCqWwhYvRS4RVuyTOj0sAF6YsupvX2qvmV01ngQG
         neKw==
X-Gm-Message-State: AFuF++kHz+Q10EFQ29WyGOjybVPZpRZrdYk0GQodt1cvHdObMwaJ5YOP
	rNGgKnNN0LDRDxuhbnVRHmvvrlXp1+9W7BUtNMWInuleC/EiLYkyuB4JzLUXq/C4NNYvYDR4lfn
	Ys+pxFA4KxGNzJ5QlS7Ul+wQd4cQiCQe+cIAu+KdyVV7zJfx2NeOkYNsKNkHvXwmrqO9YIe35sE
	H/8A==
X-Gm-Gg: AYBFou1/b2PJtlb0i16U5Mrmuvg4zVixgXEHs30T2rfXR2vUMvQyTG8kgVV7cy4c+xS
	c7gDyNgXa72jSF2TlrXqb74pZhD41N/QYLaekbhGE6MY+NMDLn0MtiTJjSelDw+GDAZw5b1yMTF
	1PzFN6S2wJ76pcrBLt7iVDFQAVZkQ7e/dNnJ4qaSCQOs0eUKcOqy7obLYpuAPLBKU05hBuimLM9
	JrAI7sxHvWjcnkFccgZAqVbTdLvmihpOAMX8Tm0FrxgneMVggkreUWDrmSEkj3oaxqLnVjIPxYV
	2W7OqcdJPrhlE+X/cRta/ma17b1VGnMgdNhL8d1EwjwYWgjGT6O7UGqqrV9JGTFJx69uEcT66x2
	cn4wAJQ/33aRQW9goBfgP4XIh5R99LoO0LMdUVs11SAE=
X-Received: by 2002:a05:701b:270c:b0:148:722b:7cbc with SMTP id a92af1059eb24-148723ac1a6mr7135627c88.14.1790614706328;
        Mon, 28 Sep 2026 09:58:26 -0700 (PDT)
X-Received: by 2002:a05:701b:270c:b0:148:722b:7cbc with SMTP id a92af1059eb24-148723ac1a6mr7135534c88.14.1790614704487;
        Mon, 28 Sep 2026 09:58:24 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145acc47ab8sm30120394c88.6.2026.09.28.09.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 09:58:24 -0700 (PDT)
Message-ID: <02a86a9a-fdbb-432a-9fcf-09aade56b5dc@oss.qualcomm.com>
Date: Mon, 28 Sep 2026 22:28:19 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath11k: fix unbalanced IRQ
 enable/disable during suspend/resume
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Julius Bairaktaris <julius@bairaktaris.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
References: <20260928-ath11k-unbalanced-irq-enable-disable-v1-1-75166f534763@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260928-ath11k-unbalanced-irq-enable-disable-v1-1-75166f534763@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: GD2UIrNuhcwZFAVLyPK299hB5qLLAaX6
X-Proofpoint-ORIG-GUID: GD2UIrNuhcwZFAVLyPK299hB5qLLAaX6
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA2NyBTYWx0ZWRfX8WhxWu+yLCXz
 y2pjli2UkHborUEenDHRfBBEM0DkY8cbQgPIWWrDK7r59SyM4p2g7ECD3mqhjWrPi4rw76sEcwi
 UXiRxybVE29ov/lnGxUsZXNqaId2dFM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA2NyBTYWx0ZWRfX0DZf3evhNA8Y
 Ap4VIpaIWv9RY2Me3yAXgOZld2NGfg5Bzr+JKPnbs65X6L95/Vv/A5FWBTm5mK53eOsODybWGOB
 yVRZslDhusDzUPtKOW39T8J2haCEg0905n4sRsgXUFYpaOW2kv6M/YrOcikSfanyZ8eGjaMEDcf
 SkvEUOKnEOshJFWKF/bTw7XNqwL8A/QorEKs6uT1FMi1aFhbu80UH3tEwm2Sk6fEWzCYKKvRIQP
 OGQr8CDrGQMdc/j/IRdTMTtYkgvKqaFNBDbwGKsiUJ995VO+ESHjVxPYCT4UNdhdI8WD64ymOJf
 bo+u6rG+Oy71trQJrnM4SQsYwRl80s0T3eQrhUduIFloLLuDE3wXeBwdLdkInATh10c9oydkW/F
 68u7KcC5aE9EAq/BNH3LcjBwFeCRdZCLD+D7tXcF8oZspXNZK+fONXc8VZ09sWMZAyji72WjXNf
 ig2vDoowWV6HVnhrUBg==
X-Authority-Analysis: v=2.4 cv=QZfzLcbv c=1 sm=1 tr=0 ts=6aba9cb3 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=hD80L64hAAAA:8 a=EUspDBNiAAAA:8 a=ZvQbaIHpGuiZngXRD0IA:9
 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 suspectscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280067

On 9/28/2026 4:15 PM, Baochen Qiang wrote:
> Commit f7a74e131d3f ("wifi: ath11k: disable interrupts during firmware
> crash recovery") added an unconditional ath11k_hif_irq_disable()/
> ath11k_hif_ce_irq_disable() pair inside
> ath11k_core_reconfigure_on_crash(), guarded by "if (!ab->is_reset)", to
> stop the DP NAPI from touching rings that have just been torn down. That
> fixes AHB device recovery, but breaks PCI device suspend/resume. During
> suspend, IRQs are disabled once in ath11k_core_suspend_late(). Then during
> resume, ath11k_core_reconfigure_on_crash() sees ab->is_reset clear and
> disables them a second time. Those IRQs are enabled only once during
> the following reinitialization, leaving the IRQ lines masked. As a result,
> HTC control responses never arrive, and resume fails:
> 
>    failed to receive control response completion, polling..
>    failed to connect to HTT: -110
>    failed to reconfigure driver on crash recovery
>    failed to resume core: -110
> 
> Fix this by disabling the IRQs unconditionally at the top of
> ath11k_core_reconfigure_on_crash(), and instead drop the disable
> calls from the two places that already disable IRQs before this
> function can run: ath11k_core_suspend_late() and ath11k_core_reset().
> This keeps a single disable per recovery/suspend cycle regardless of
> which path (recovery or suspend) triggers it, so the refcount on
> PCI parts stays balanced while AHB parts keep getting the disable
> that the original commit needed.
> 
> Fixes: f7a74e131d3f ("wifi: ath11k: disable interrupts during firmware crash recovery")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Closes: https://lore.kernel.org/linux-wireless/a068a857-a549-4cc2-ae0f-3ef119d3a859@samsung.com/
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Julius Bairaktaris <julius@bairaktaris.de>
> Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
