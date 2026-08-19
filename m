Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFBB3C988E
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123640; cv=none; b=iKfUD1AG+8Kts84/AYPGgmXl4szLMOpnH9Sc3pAKWbTQSdaHK/HtFaqewwXEo56p32/0DiMsyaHJbED1xv37/HyGvUQ6+yCFRcECaz9PmTZ4rrKBk2jxhNnYI11TcVJ2R6eu4EmEJtJ//NkbrtcMqI2oyxRioPiKbKIyDJR7qZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123640; c=relaxed/simple;
	bh=dVLhDPVVl7P7ehTV5eI8dlveWiLu8W+pDZVJcaeJ6WQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TMCJ2MSHdESS7EjOS4qPuxRZhDQ03K29l8DZog2/AYaFkP+FRUXjV1NjjLPoaCLARBbCjNszy3ksKn+u1tgiontxVW3UShj1RiHs3W1YUhs1swVMzQelxjoGswL0iB3cw056xvzIDCpEhcfAqbEhXaowuZKwx5KM+Fm0BjznQU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=duHz7qwD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cswm4EUS; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="duHz7qwD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cswm4EUS"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J6ZWRQ3691944
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:13:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0DWUB/mMMiSatxzAZzVLW6ob2KvWQH872h+Dc2rdweM=; b=duHz7qwDK/R33HLi
	LiWzghqPhSlCw447IV1qkGl7oAaLahujTtuVw0LHj8UIBFqInInld6e/Pm22F0ag
	PQm7EWDa3yl6SxP9VGqRiciXKHNqTuWKJAz4XprPwK2JlOJ42nIVF6/+/ovYbi8P
	I4iW04lDx9Q5SvSVyzdSgQb4l7nWMELPTQTJzky970Td5LkmUjsls6ZGU3PtUxT8
	jPNUUvfZNUodMOY24CAfxtMxI8i7L12vE2a/jjCMfjZs13MuPU6HJVrRo/K1vhZV
	uNZHOoRGsfcdnsnkp7J39TuPWGmYsp1A2SHPfs2+XIlxU0MvmE7HFB+QWgyJGXM2
	KS/JXA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfk9w83-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:13:57 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cf6acd760cso9062825ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 00:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787123637; x=1787728437; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0DWUB/mMMiSatxzAZzVLW6ob2KvWQH872h+Dc2rdweM=;
        b=cswm4EUSSHwQhHGA4tmr9UI2nuOP0TqsagXwOafonlu0k2XKyGIvL3YHOFS16AD6XI
         aXT5HhieeQrUHNuc0HISaI0cIpkGUT1MHRgoYrQ54sXC06RGAP118x9PwLWuAeIn3rvo
         IG8qhAnmye2HbyD7s2fLMcRpbhx3eMKEFVGvhCzYsMZ2s8PzapDFiNJNfauWtbXUdoAA
         YmoqtFNJK0Q6N4csRBP0WDBx6GN2+mGFFRPnhWechUp+wtYQuZkODJ3+vgCCXfhtG4G3
         fUudS0OydUIOvDvFsGky/lYKVz0aSmpiw4CVrmknRel0zUOEVpCn2khgjhjqg3eABe+4
         hxJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787123637; x=1787728437;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0DWUB/mMMiSatxzAZzVLW6ob2KvWQH872h+Dc2rdweM=;
        b=itaiHnOfQnbDu4o0xbQC3o2A2MNXPEMrTU8i9+EAPuSP0xDCyfpNr2z1Chlf+egGE9
         2gxLXdjlmsJlKcVe8aH/39KxOjjq/uEPOptl8/6uZ7eAb9WdT+wiFjSHNQyxATLaEf9P
         7fAG3ptzyoCnvLDDM77BiVWde8UJFnpymYnzTKTWM7nKLTzxZIW1UaoAgZC1VOKlgSZi
         uByYNIHUYFMR3AKAVM0/ihDsdLu10UpkdxwtABIinwPAi4n2BiRiqwUEQkPI7iFhK110
         IQLx/fWxSDQP6Be8bDR4NFpjLR03OeMsOGyct4ekmH6btXSRjHnobji4v0hLjlUfzWBO
         XQpg==
X-Gm-Message-State: AOJu0Yz3oZndF/LESQbpdreW7+yEeICcjdj894m/toqyInmUnwRqaD5q
	bKwLQUtiFuNp4zCexD6i74L5B0uQ3BKia13BWB5E2HMzf0HlftIhbv/rLoNqIFHMfP66CnMIB5D
	zY9jJAkhPNyNYfjrJYwVD6ALLc9KovJPPymeZhA7G3Uu/YQ3Kp1kddZY8P32XynHr4WuUbw==
X-Gm-Gg: AR+sD11XeRL8vZOItDDHBJqKyWeOTwZZPoHLRxAh6iM7qx4DTmzn8ihMQfbRu3jORbo
	MyoGpDnm0d9jH8TQ1gbS+TftiKonWhAzxwNsYyt/A5AqNUeL3wDEeqExy3QjkqqvlNxdq/yle0S
	6koHp0N6DciL5TQkGfNIlAgkJNIGFe2L5swCmKoVqHjZ8z5sYdEqvMdyje0gArsWfZtDAVebOrC
	RRDcIbmQ44XYWrBlGltcaAFePQQEBNiYWGA/C7W7zuTskmHJWLBP9hlBRIPFMZTLFANFSJi4Gtt
	Z3EoW4BrYMltsWvjRbPm4qPgNVzVIlk1c9tgPeehFrIZEBGz5iImqppvzeR2BcaPJc4bDadf6bv
	n78Wu9cNNSpTx1zW5qbDWKyGjGtEurMuIcwM4TE81
X-Received: by 2002:a17:903:11c9:b0:2d0:8b28:517c with SMTP id d9443c01a7336-2d5fd5ff2e9mr46122685ad.3.1787123636632;
        Wed, 19 Aug 2026 00:13:56 -0700 (PDT)
X-Received: by 2002:a17:903:11c9:b0:2d0:8b28:517c with SMTP id d9443c01a7336-2d5fd5ff2e9mr46122055ad.3.1787123636198;
        Wed, 19 Aug 2026 00:13:56 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bef6ec40sm4152747eec.7.2026.08.19.00.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 00:13:55 -0700 (PDT)
Message-ID: <40159684-8324-4c7a-8289-d7a8a17870d2@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 12:43:49 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: fix truncated TX buffer DMA
 address in MSDU ext descriptor
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260818-ath12k-truncated-tx-dma-addr-v1-1-ead978969371@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260818-ath12k-truncated-tx-dma-addr-v1-1-ead978969371@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: SKJEuhYp-E1nC2Dr9sZ1JJvK1qIBQRmE
X-Proofpoint-ORIG-GUID: SKJEuhYp-E1nC2Dr9sZ1JJvK1qIBQRmE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA1MyBTYWx0ZWRfX8uXSTrdHuO4e
 pe2BPjkV00x1it685mT9hirDbVnOXuvHHWhB8auyf1vEvcUoM3BuEKYHL74C2GwuEUFzXJD9aIF
 CnDnnR+LvgqTiCHmTEgA9fL/WivpfwBMv4PbVXSOWq0qJyMuuhymkI+llnZtXJMKs2oNvqA4nb4
 mqhFjBv9FuV5SMy+lWC6XriKQhsWHIh/Zk5diZvH1uT8DQ9NJYPM/fQZFTvhW1HlRZYPERys1Cv
 0zS7hDpuK30W4/QKm6puq4YMp9WzNVIFYXSsKEAj6bF/6u2pYp6M9NdF4HKjeoN71W6MW2ZzjOC
 B3/Z18vQi76LxQBNKkRSOJSR6WSO7wsGxyppeEz89OK6WbINIIH2hXDffvN2HlgAqJQagmCQWbZ
 WRRzo3DbD16yi60PEJwFxL7b/vGFMl63g9QN2y0/TiCTFWFglMlTt6dywrfdTr1uqGFPteYh5wN
 6o8B2uyglZFs5NHuH7g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA1MyBTYWx0ZWRfXwqfCAfo4HaF+
 RhjetU/E8GiJbk3EJ0bQz8joLJKvkBu84uCmEgPeHMLb79/lGfN5frgyiB0nYw1OAfMujxT9I8Z
 hYXEgh9Iz4J2BMwJiD++JYDywqm1S/Q=
X-Authority-Analysis: v=2.4 cv=fvfsol4f c=1 sm=1 tr=0 ts=6a8557b5 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=Up9l7ocf1wBoMnR3cVYA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190053

On 8/18/2026 7:33 AM, Baochen Qiang wrote:
> ath12k_wifi7_hal_tx_cmd_ext_desc_setup() programs the low 32 bits of the
> TX buffer physical address into HAL_TX_MSDU_EXT_INFO0_BUF_PTR_LO but
> hardcodes the high bits field HAL_TX_MSDU_EXT_INFO1_BUF_PTR_HI to 0x0.
> 
> dma_addr_t is 64-bit on platforms with CONFIG_ARCH_DMA_ADDR_T_64BIT, so
> whenever a TX buffer is mapped above the 4 GB boundary the upper bits of
> paddr are dropped and the firmware is handed a truncated address,
> leading to potential TX failures.
> 
> Write the upper bits of paddr into BUF_PTR_HI to fix this issue.
> 
> Issue found during code review, compile tested only.
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
