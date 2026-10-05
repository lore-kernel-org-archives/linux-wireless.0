Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCF64BFE6F
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 15:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212992; cv=none; b=k7lIF82JQFC89OMYun6N3OfS1z7NH9q2sNZ8ZnM+UUWWj7TON8Cv8tTlEyHybwZ0/l8RAS2ScLIa0vUXBm4k+rRcErQL4CjR4n2vv934kLtImyRnWWufDFpDXq4OOV8YO1LWJKIGrDOlECjv+wIm12FbELlHWkdeUNSvENSyLEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212992; c=relaxed/simple;
	bh=/kfpMn3Rhh0LHxUmOG711W9hxb+9tHhjOBHmw//ii2o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IUT69M7S15pKTzxW3A1Z+nIuPZEh7iDi37J47+3jl/gEX6t5JtQqhc0jRO6kaMGLeHBtJCG9h9Xc1auTRPiCOCmdsJU1TQEknTY9ycEirq3J0UL/6tTNfvNnGPn67iQGnGPX8WZsj3wSMxSapC14TSebdisDkZ0P8YIfFh8YEms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=p4CTEhhw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PQBjancV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="p4CTEhhw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PQBjancV"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695EP0Wu2178390
	for <linux-wireless@vger.kernel.org>; Mon, 5 Oct 2026 15:09:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UM8vKsYqKY/wxwyZHCLaCwEcwikM4wfFgIbAvvc2gqc=; b=p4CTEhhwfSlDneDZ
	ZZY+iofFHKMWy0sj+CNKSLzOVsYQY7c3Vron0txDlT5Vm5JUTbRkXoUS04ndsywE
	KVj0KXLWYOoaq+lWGkJFXf+89USyurqYelHgRxTMPcpXYBIvWbtyDHK455GbEv7Q
	ADPKkVMvVMOZCZWj5rFeTcvfttiMP6U4RKPydAanST93FeCXL4VkjvQSfB7VdUXZ
	2VY9/MQ+NXP+6T0Ag60wn8cxxN1P6uX/ihhkF5gCveGzmMlE+b9Gn138Zhdo1j2Y
	gSWNGo9LQbxdo+7zT0A5MR2hYwAt2DJ7X4vDQy4abTYIjAMfK/4/Q+5daFaM1cVR
	0dYjjQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4cj60gq6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 15:09:49 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e2d83bb68cso16793335ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 08:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791212988; x=1791817788; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UM8vKsYqKY/wxwyZHCLaCwEcwikM4wfFgIbAvvc2gqc=;
        b=PQBjancVz83R05SVNSRJKK+rs7jdd/0zdlu6I8WvRV0ZX3gd4u42Lpod9FqnqNwcxk
         KuUfYEquK9lD3AHkvneLJxWWvsq1Bgswv2bDI/2HqYu+BbSUl2QeqsKBFLomo+otV4Ae
         GJplxZZEtcDKDS5uGLoCPFaJlFU5T69iGsezL3jd/6VDcatCnklOXVnk7eXBolwWldmt
         TEK7Vk96Yh6Oydzk+S4W/xyKtUfX9HYftL39ECIE7F8aPwN6wU8Qx6y6YbLSZ5g2sKfh
         9ztdogdzIoLqxGUebts4fho9gaGrkRNgpmkhCeYHBEA3RS5bZ2SUw+7O/EKdQsEGqHaL
         sS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791212988; x=1791817788;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UM8vKsYqKY/wxwyZHCLaCwEcwikM4wfFgIbAvvc2gqc=;
        b=sqD0Q7l6Qg8TRl2/HMCkbPIxNhHUd3yjPqUzTvAfUonLyxdNC57MudlBepIB/ctrYF
         ijQv+7gBuDGerv+Owx7/2qeIlL6+Xf38tKcxyVJdOgiXzDn0ASBjfVVYZqekO0X5LiUu
         SCtdr/WJVQ4aqPTqkBbiR6tMJDr1r/Eow3V0PTK2fyqicdBSxHEJfJkB7Cjtj0RbKPIE
         A2vBgspEl0PQ/yk+GqUiOqYyD5qSMpYAikxpRE0lw55WqYHajdFdqV63RM8CTEdA9GRr
         66CfiSXlaoLAlK/m8rHy86LtnidghRgTGy45dhVE5l2fcPDccvpl3EUUqOTi+SuEZI0H
         RCRg==
X-Gm-Message-State: AFq9FYIOZXRZLF6OTVCH1XO3orkhBkcRhq7+SnVOkIJRMWB1CrsE0cwg
	28ae/uVXeHHR9HTAOvfUehyWKdc22TLnOZOXS+6eccW/qSLoYN3oACvjrz8LPhk27bSRk08EXuD
	pkxKIz08LqPRZ37jmD0Q76LXFmTHLn3xKmtsw/6lqikFI6qHoTcsuen5JSW/IB7O6jBTFPg==
X-Gm-Gg: AYBFou2skT/Qr986IjSWMuZgvhMwZmV74o8GB0HjNYZ3Vl3DnDifnA0SCG1oBoHyM5P
	ZwSDQrnVm2h7VHUhJPgMl1MmPTrb9e83RT6qrqd1PWmlC8SVR9NlbUYxZYF2w9CGKqcabmO2YSA
	p4jy4MoxjCJvXCqaGQlUyPBi+6PgSLTLNOx+lWNdudTfBEFtaLK+qQ01DGQq0DkePQzmpFFe/iT
	qQjusSLLguhzOxQ51uTbC/S0Hazc4ClxJlqXOxJnov7Io4sJ4kIVoTzEB406/UbJ4bEeFMyZcKW
	1yREWkL5z6DzgSYOkp0uYO9doVzd4TXUiutVVlQU/Qud35pxgfDrRs3DGGo638f7ArfmlY3crMe
	yHsar73P68ebe1Ykeiwp7acQ9Fy3zE4bMNuLWzA/k6OwmcoTBIkBa4To=
X-Received: by 2002:a17:902:d548:b0:2e4:bfcb:2788 with SMTP id d9443c01a7336-2e4bfcb3bbemr78035755ad.72.1791212988342;
        Mon, 05 Oct 2026 08:09:48 -0700 (PDT)
X-Received: by 2002:a17:902:d548:b0:2e4:bfcb:2788 with SMTP id d9443c01a7336-2e4bfcb3bbemr78035265ad.72.1791212987726;
        Mon, 05 Oct 2026 08:09:47 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5cae1bfsm9130075ad.28.2026.10.05.08.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 08:09:46 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Julius Bairaktaris <julius@bairaktaris.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
In-Reply-To: <20260928-ath11k-unbalanced-irq-enable-disable-v1-1-75166f534763@oss.qualcomm.com>
References: <20260928-ath11k-unbalanced-irq-enable-disable-v1-1-75166f534763@oss.qualcomm.com>
Subject: Re: [PATCH ath-current] wifi: ath11k: fix unbalanced IRQ
 enable/disable during suspend/resume
Message-Id: <179121298614.2358654.4522764311358973732.b4-ty@oss.qualcomm.com>
Date: Mon, 05 Oct 2026 08:09:46 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA1OSBTYWx0ZWRfXy1OWv6SzXaVs
 Gr29PL6zPeO1nMLARiJmkLfh1R8btfOaEWzCv4pFDJrCQUXLMG//sj/1rN9zIbPF2ZWW1zjjvwC
 QwG95eqdFMa21hJV6Rc4uBl9AKHqyY3qAyTu1ZxmxFTlu37/KPgyHbwQX8XCbcVC2tQ0rHyX5F/
 FC/5VXfEb72LQzc8ZqUTEuvD+3Wk68aAbzqsm3jfxCpg9osMWM1QOZi5zvUK2qhPr6hn0p6gTty
 KHgjMDBd+sWqXAGen2WumYXzzCbbisvw/GjZkJgMYdN+jXCFWG7upMSxqj4kExzUDNoNtoIzkqU
 a1NVeDCfbH2JGHHbtF1d84NePofTGzO8a/yjl3g94gzIUjmetN3zFtj+wP5/fKJye7fpnfkN31s
 RHhK9DXzUIumXDhyN7isward19tGAvDQtZ8E/PGYy9NksUwrHk+l5lFDG37s+Z2IV3na63iDVhh
 gKSIUfWhS8NcobaOK4w==
X-Proofpoint-GUID: CXdjf3qwaT3lSpNqfExGlxnx51U4JkGT
X-Proofpoint-ORIG-GUID: CXdjf3qwaT3lSpNqfExGlxnx51U4JkGT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA1OSBTYWx0ZWRfX7J00TtDYsoUq
 k6nJtlNDBJpkjT8AuB6etu0TcPVx53FT0bLs3WXrWuEQ2Qoo5KPhahXFCrW508Bshn2bjIYE0tG
 oiZRv+JA2lhNtN/qjn730PKVdWQ1Cl8=
X-Authority-Analysis: v=2.4 cv=bpTZl0ai c=1 sm=1 tr=0 ts=6ac3bdbd cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=Tf6FFpAjyP9XlBvCETIA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_04,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610050059


On Mon, 28 Sep 2026 18:45:25 +0800, Baochen Qiang wrote:
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
> [...]

Applied, thanks!

[1/1] wifi: ath11k: fix unbalanced IRQ enable/disable during suspend/resume
      commit: e56c9d429ba004d5416b03091fd7656187cdcaf1

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

