Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA2D34D397
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 14:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556531; cv=none; b=ox1To4xOcKqFlU70RRyvfja0ZP5QsnS0vNfYmohJZbz9a6praIULBmeejE7JkbqIM8oRnQXAgBu/87hwIyrtEBlKeWmOlY+zcimZ875QHZxByDDZtAYoQ83iuvkrmwYlIvlbL6j2B/m9UGx0sADFtPbK+n1liDIrr+JMuPMDthE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556531; c=relaxed/simple;
	bh=e8x7ufUxCGd8393PEZNgbfhNu5UICq+F6xhE//cv6t4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WPPIeB0NkAMBjJJMuCgMDYOxb89uo3Sq3PIKpZ6sF3vzQWbS0IrGu8l3s3oSRxydaxHquXxTdSvuFmT7mP3ik5Fc//pysw25ewJnSLwlHFQd36d2sFTsYbpXDhO4Tjk0wuwzrOptLkVRBRP6z46IGbFph25i6yUMsh54qhmaL/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HmYopKqU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kjnLZvNz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HmYopKqU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kjnLZvNz"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699DKYSN1061013
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 14:35:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tIJ6J/MXQ1oSPeoJJWVdhdjnJM9MuB6zXdDPPg31KzY=; b=HmYopKqU81XlFDTO
	vBvaMvXXKOT8rRXLMR36QxiyUYuoNHAbyGxr/m8nCWr8zz18LtYWLiiLVdxt1Cio
	MMQg+/VIArQcM0fSk7uI3VDfmLmPI4wdhnl8YjKq2MgLg1zvc59WkG3qGSTmH+9y
	HV8Ew5rc/sQlKFGuRF6m/MzM8I4pl5hWjTwPgWzynNpq81szDL8r7d6YNbGC8ofb
	p/wQAJEkLR6/3Rl/4YltJpXLIni5iDKE6+peH5Dqtv+C+HDNZ9LwkM3RWRGYTCuH
	8UvL9TE+764K3AVy6Dw5jRsWVSS/yIKTUjhLb/mbX6oNgbntBZrdpsF8nAkaWrkp
	3YL0sA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6fxk40ck-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 14:35:28 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5339732335dso87738761cf.3
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 07:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791556527; x=1792161327; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tIJ6J/MXQ1oSPeoJJWVdhdjnJM9MuB6zXdDPPg31KzY=;
        b=kjnLZvNzvTuw8d9JtR2RPBGE6kf+vm3af/ZdPMYCUsJgv6xoKofd/Vpr12+xWhdFln
         XaSTxM7DQ4XcSNjVCxWUY5IsQOR0JT3RZyJGD5kzYjR1hogccpM2DMLb0fE3ZGfIhDuT
         1BbqlixEuOT2JGC1RdhGt5GKBhzHEnn4HgSTils0I7cdpBi6TFnp/MOosb6sjM25VYC3
         qStle4nGajXyvtOgeuGXH72K04XZ+XrYvhJd8d+3StFAxzEAzBaGcUnbSiAq+/1BKIj5
         CMlbbHZCo+7vfE4GhaXjS0SlBxPqbyQwSKRP9chWHFnuiNy9mW8iv1at8TELycxNr60r
         PBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791556527; x=1792161327;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tIJ6J/MXQ1oSPeoJJWVdhdjnJM9MuB6zXdDPPg31KzY=;
        b=hwukFK2jJ/xY6gwMN207Gr1yns8Zl+y0VJXLglxK2lCc31fWQ66IThlMtoCcPFCauT
         8ZxUSaRbGxVpcbkoWFw5BA+UK1nKDRNsQcBejpAsfXnTLPGi4rpKAu5Sh5WcXQyaSNsx
         eZ0CWaiCDiACYJ/9bi0zwvqcAOuYDc7YCRqCGSV+3kYpaH3dGgwvyB2sUD9kLevcI/rd
         g6b0TKL49GO05+OtC2x6pjPkMlx9jeLMu4RU9TsSaDo2mS1MI289bRik5f9aBO8SYZQx
         iSUJcSG15eSXKFajfMqCZ1IE6Y+tG+oITRqNrycJTR2nwEk3uO6VPrLgOcUQS9GIt7rK
         2ZHA==
X-Gm-Message-State: AFq9FYLhUwByasTnd7coTjoY5xySst5FcRnfqJhq5H68a8dMCnddf/0w
	0AXq55IlAYlMx4FxI2HaXFyvIXDf7mB3sgnkbMptgRIZFz1iFN4eTx85Z2FE60Ff7W41F41QQPT
	ydjyL0AaSe0llS9/UCk4ksyrYGXYQw288RYr7o9xD6rrRoSGp91VzxVRDZdIqA1bH2+JTgQ==
X-Gm-Gg: AYBFou3+LyfNcpNUeHlsk0nlzbohtOszhkoDNJNdyd6ATd9Umg5ijMzMRvEdbShautJ
	dRhig+Aty2yJjfqNNeCdCa39QpxFLQ+T0BxZIPdbo0jW9+mI8hIj/C/BMg1KEWorz3USODmTXSc
	pXkiT+ZAL3ZOBl0XKD7sspkfwf23x7U6wD84geMoVLqTN63P8dgrq108H8sXD7LYsdy5BXmaMA2
	fe//9SEVAU9bycfqwu9b52+pvV6TCuGtJgsUxn+NilDXR0DIWsZto0+/nwX1uPXuU/yHUFap8GD
	dc8ldnzQ27xWXW68hGylg0KOrvvin2MvvngQE7H2l73ggnR58Q23fruDI7Fioqz/MbUoQYpmhy3
	9oNiDFFwj/9uHcBj/y2elou+7rcQMnL6IX3+WmgGsfUn1aWwTQGARLphE0fxW
X-Received: by 2002:ac8:5a4e:0:b0:535:341c:e2c with SMTP id d75a77b69052e-5359fb8f878mr30395391cf.39.1791556527379;
        Fri, 09 Oct 2026 07:35:27 -0700 (PDT)
X-Received: by 2002:ac8:5a4e:0:b0:535:341c:e2c with SMTP id d75a77b69052e-5359fb8f878mr30394691cf.39.1791556526688;
        Fri, 09 Oct 2026 07:35:26 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b7dba11sm18937931cf.26.2026.10.09.07.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 07:35:26 -0700 (PDT)
Message-ID: <d34e6792-558e-4970-9b8c-3a2ce7d899b5@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 07:35:24 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] wifi: ath12k: use private page-frag caches for
 RXDMA rings
To: Nikolai Semendiaev <agent00791@gmail.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org, wabsie@gmail.com
References: <cover.1791408913.git.agent00791@gmail.com>
 <bd52182ca4916b55632a710be2f5c9cfd25f07a2.1791408913.git.agent00791@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <bd52182ca4916b55632a710be2f5c9cfd25f07a2.1791408913.git.agent00791@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=fKesTpae c=1 sm=1 tr=0 ts=6ac8fbb0 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=2qyhcpLnmCfHRKMOYrAA:9
 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: rFT9p5tf0A5B0Nh4RxZnc6Q3_zuRio7R
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA1OCBTYWx0ZWRfX/H+llpQc/tes
 65WMwQCapOsCpjSP2XkWmpe8CVVgYch/iW4NDpl7ZG/bhhatZ09xmw5I3ilWCRWKXw2Dah0NAIW
 X4ehHmdKediDo5VsKXB0XcOCVmA5vZk=
X-Proofpoint-ORIG-GUID: rFT9p5tf0A5B0Nh4RxZnc6Q3_zuRio7R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA1OCBTYWx0ZWRfX48Wa5XCWt1PX
 ifsSSbOKWW/TX1gHBBSTOEywuUaHD7NHYTj7aMciU4pUWHqPObb8aWd+GMtY56lIJcNdHoRI1e+
 xUx2B3dXEiV0vHrZQhqzMOYKcM/QVGQcZ5YO6/DEKJZUIlDHtwD4pWkVmvPa5AkM2TFUAx6jWNA
 FLyxZTv5hLMuqi4s/mRohBiLvJIHrhI6dMUSeMcSttxGKFfXs8GDfXafIieYK54O7oiabNNpYbL
 1KyLZKPKZtxjAKVuNPiMleNw6p09dUSYrSY/3aX2uMgZIpUu1em+fwb16gxVKYTAR5knOSXjExP
 VXl9oHqjL+7TcQqnxCqQgF+EuLl+qG2UmrAtjyWFwJ85Ya0uJIFkNWoXbdLs+970MGKg0dK96sj
 5uZRsfBEvRneIZTICsO8L83tygAT8T3R2p6f09SH13o+93W/jDzWFFxDk7Ys9KvG7LD1UhJeFUN
 kwnwLpq7HcxpKu+rsyw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_04,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 clxscore=1015 suspectscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090058

On 10/7/2026 2:38 PM, Nikolai Semendiaev wrote:
> RXDMA buffers allocated with dev_alloc_skb() share per-CPU page-fragment
> caches with other network users. Long-lived ring buffers can pin mostly
> unused 32-KiB backing pages as short-lived network allocations cycle
> through those caches. On QCN9274, OOM was observed during sustained WAN
> downloads when Ethernet and ath12k processing shared a CPU.
> 
> Give regular and monitor RXDMA rings private page-fragment caches. The
> existing refill SRNG locks serialize cache access. Preserve NET_SKB_PAD,
> allocation flags and the DMA mapping and unmapping operations.
> 
> Drain each monitor cache after releasing its IDR-owned buffers, and the
> regular RX cache after releasing its cookie-conversion descriptors.
> Disable external IRQ/NAPI processing before non-reset crash teardown;
> the reset worker already does so.
> 
> Use skb_reserve() for DMA alignment because skb_pull() cannot advance
> an empty skb. Allocate extra alignment space for monitor status buffers
> to preserve at least RX_MON_STATUS_BUF_SIZE of DMA capacity.
> 
> Based on Mark Ruvald Pedersen's ath11k per-ring page-fragment isolation.
> 
> Link: https://lore.kernel.org/linux-wireless/20260719215817.2468580-4-wabsie@gmail.com/
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Nikolai Semendiaev <agent00791@gmail.com>

This conflicts with a different proposal:
https://lore.kernel.org/all/20261008-ath12k-pp-v1-3-68f888cd7eec@oss.qualcomm.com/

