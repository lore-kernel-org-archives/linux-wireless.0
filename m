Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793350350;
	b=2kYZ/B0yEaAC0xTt14mtxWIsOTZFIbDOxsgp2enFsfVQryaoa33IRCsEoKLh9UIe6ZP/
	 IEIx5catE22rd0mgQa5RSJ/Uedjre8h0DG/rEgGfoEHkwP7AOf5uRKwxWy9LbZ7ba5+jo
	 LXbymFJM31tnWK6rs47Q7rMvpZzRntPGosTwqD2dKRBvIW86D4j5GPbIScAyw+897fPh5
	 PG+V/76Iob1MBZjMBA0j+V/OfdqrQjIB7IxrfL2mND1pbRlnrCCEz67uJS+pRlxyOWV6Q
	 Yrq651ZkY218Kl+huWb6dDwVoq8XZ4RnRMAKAgs1n1bXnSUWNrvYbBgDXdHgT57AVTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793350350;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=9c8FC79mNw1az87e+cHhmiKEEh8DNlKxvltdbJhUyoI=;
	b=WduXx5ngL38PqeTL89ycf84FG3QyVVMJhQBeLaOuI24r6mUdFszV4KuBycSPsxyZZlaQ
	 1QvW/BnrV9x+GjW6dZ/xZF6KP3SCTfeQuAGN8CIybdyhuI4qQMpdoeyXBVcRb3npY5Nlh
	 8p1kLCxRXlrRuLxILHJ/meUHJgAUgXTwPBZhTanxRiIUCfroawqB5mTw4xTs5EEk64yxP
	 yGhtfwcP5ApQFHvNx/ynqmbebe/1uBaCEFeOEVrx8IZQ4ep/cvgBzugg9a/7zDaghaZUj
	 4MiewmIukwcX5x5VCSm/U6Xz3vMsUAdfImApJ4PwffiBnFROvX00QgcCM2s4wIhTC2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oqTDMPws;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QeSsv6Kg;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894A5606A31C
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 08:52:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 894A5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oqTDMPws;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QeSsv6Kg
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U8F1xu3737853
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 08:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9c8FC79mNw1az87e+cHhmiKEEh8DNlKxvltdbJhUyoI=; b=oqTDMPwssrVKUSMu
	TMAsd0UjLfO+JYoiCLtSW/spNV6D/aRYII/HT8jCpfvlojvhBJ4OKAl49/33j+F5
	EY7HzAJ/DeLoRPW9Ou5QfEH/l27Udq7SiMjxDjEnLh8h0g/cF+PnZtCJRS5ViUWe
	qPsXWCANRpvI6n9887WKkLWQ61SoW4kGdPHfmTDSsHj7tDrTBc18uSxYZa7PiUHv
	uXqcEe+3sPHgdE/iXUYebsbxagonZ0hVa6m5AkjeCzdsquGoWfB4ip9bIC/75G6p
	TceNJ9kenRDe+4VXs3IRF2NvJOQmWPDzmoa6KF+Ar+p9uifaAUm5zEuSHfh5KXbg
	C75KHg==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme7521en-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 08:52:29 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-139b62317d0so1533100c88.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 01:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793350349; x=1793955149; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9c8FC79mNw1az87e+cHhmiKEEh8DNlKxvltdbJhUyoI=;
        b=QeSsv6Kg5EqwJVOAV+NljeUL0WSNCQm/yUgNAEKQOZZQIlG/+nH7TrSMsqnNDSz9l9
         ChiImmYihzDtmRjPHp9plesh+S3ZUulXgjTnJP2IOsyRBWmLJJZGt4bJRspmMPbTP2he
         r7i4oI6WXJ5fJcjxPW8UzBMDb7UpFosVrnBHWmyMu0+BrO9pkL6IW1f8J3w+DKs3M7LU
         0NTU4uzNC4YYxbdssqLKCZKnPDdPO//tTl1lJDLTgJ4AVqYXnZ5Ys/tu0GX3nzXTuwqg
         LgHnfxELx/aLuWMASIpk4+5tpVt2GEp0rxOjg1LKJmGFLydDIrU+xQXEZ9Jhuqx01nlM
         h6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793350349; x=1793955149;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9c8FC79mNw1az87e+cHhmiKEEh8DNlKxvltdbJhUyoI=;
        b=P2UJZgeMY3e7fGMiobA57aRK3z0jEZTy7Cykavm12rh005dVtUOQDjZ+OKQXo/Sayl
         YWSUlfHwJDswiOtpqKo2xjehHM+D20uelvuze62ljmRY5IXX8S3aJZcEv5PLzpoj1nSy
         cP1ZZvasLg23KeSCeQreC12HBOsfutr9XbAabf/9zmtM4+nq5tpULXWBQFN2oNWkWi5Z
         2elLAX9LezhOJsVeQomGWE4tDQQV5LnSGdrgpLe965hO33AwM9PoZ/zddRhIszzPEYGp
         FhtHcBG6vRIZ7d7xqCUZs6L9LwSH12Hf7NEMHIdML2IYE/Ti+/sHN1tzhBm7RocSDarO
         DdEw==
X-Gm-Message-State: AFq9FYIdmQ6M9sQH4pBsVdXv+CG8ozfAbm1zq7Iq7GZC0M1acnbryu41
	dUoviyTG/hKJNtbnGA+A2vhrz4bT6JSORblMvtiKcSndbwPZC1z8ratgH54dCHDvV3izS5Qy48R
	2EoFTJNZ9IXdu0CYKMuQ4yGaaTc6W4LM41IJirvlSxxPiIY+S1zm63MO7DwcjxkAU4fJgxA==
X-Gm-Gg: AYBFou0c3AB/WVKHXjl9P7+vzOOzDZE7+108S1ogLlL0q2+EZv83GKsIS5LtWoa4AGy
	zC/qZDGEcJGqgJSgwPbNsG/Za3N7T5UYbX0QNfunPh2NPq44nhlgHWss/3pfDOAS0lRHIDu+JyU
	hGFcQhk7j4+VuP8pL4ahZpNZrJf+BjVJ6EB4GPV+dO99LAE+wjFol10TCpjDZHyFXicFanmQFA3
	FTzv6El+oMk0oYxUl/RhJNxOgrLv9B+T/1Qodx7xylADYMB5cJoikDyFLu9p3XxcdkhkGI8Y+cN
	8ttFr4YkPUwAHxdz1x4k4abHO0LhswIr9Wva1fXnfNnc58Wr52oq8rEuxAemja60+jbdMLWEjIm
	niuBd1fTpANqHmYFP04BM4cG5dCvxAsOjNj3qIjKLZhbaoRtgl1lU3HUSTBBmH69DaATaLoA168
	hL+IYnKYn18g/65OwXvBNQ
X-Received: by 2002:a05:7022:3c81:b0:1a9:f97a:34d with SMTP id a92af1059eb24-1ac5bbb4858mr2126246c88.13.1793350348795;
        Fri, 30 Oct 2026 01:52:28 -0700 (PDT)
X-Received: by 2002:a05:7022:3c81:b0:1a9:f97a:34d with SMTP id a92af1059eb24-1ac5bbb4858mr2126219c88.13.1793350348187;
        Fri, 30 Oct 2026 01:52:28 -0700 (PDT)
Received: from [10.152.221.90] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac19c6b969sm5157429c88.14.2026.10.30.01.52.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 01:52:27 -0700 (PDT)
Message-ID: <e197c34a-9cbd-42d0-b2b2-878b4f37520c@oss.qualcomm.com>
Date: Fri, 30 Oct 2026 14:22:23 +0530
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath12k: don't advertise EHT-MCS15 to
 firmware unless we support it
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Vladimir Petrzhikovskii <vladimir@dfb.sh>
References: <20261029-ath12k-mcs15-v1-1-3bcfab101f00@oss.qualcomm.com>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20261029-ath12k-mcs15-v1-1-3bcfab101f00@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: IKkaaLKmitYu8TDSWmQSZ4h-doV_0lAi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDAzNSBTYWx0ZWRfX41QakmDVc/Jh
 U+/4p3LGdLakK921maGh8vAXTbsiJLr5i3xcDc7SqC2lpc0HhyfhfLf7Kqn/oOLZ4qM2O19bMTd
 3OsF9LUD9MdWJNFsi1EFlZfUwG0k9Lf2FwgnrtS8WdnMYnXwZa5b0EKFZy/TBWQ3d6DneOex/pM
 Hpwl1ut6U5XnsmZl65IThahhWbU3YWQv+xcAo71ttfd88TwJGHH124Ym5801Ro2t7Pu1ZZwB27h
 ss/iSC1gYcZwBPUFfhOyN4AFvQR00UqeZTfd6LE8cpSIhMG1Isu7/uLOgzYSKUBhWCaZJnZOvtw
 9FVmb9aCT6ttaeHETn9RyzWBtG7DLZC5fNYHayMm+8tvvsv/vspkEKa0yvBfLQ6lKIXufEygLk5
 qRRYJJwqNpqquZfZ1XrwdOwuDt3EQBPD+2BwkhMkfSIMZiaxXryXrkNXvLekd4Q2M/LAZE2K6UA
 dHfo4HjfCJxlFF1bWYQ==
X-Proofpoint-ORIG-GUID: IKkaaLKmitYu8TDSWmQSZ4h-doV_0lAi
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDAzNSBTYWx0ZWRfX6amuvXEd9bi4
 03CvI42lBCiDAzL1iaX5Qs8zBCe7MzGqPWKYFckDAqTl40RxUzW1rOCAVKMnFO2ZkTr7cGn+D00
 3jSFCWxqjD8CeHsoqFHABoeme/2iXVM=
X-Authority-Analysis: v=2.4 cv=KdtHIgYD c=1 sm=1 tr=0 ts=6ae45acd cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=KICNIvf8-xFwCwObymsA:9 a=QEXdDO2ut3YA:10
 a=vBUdepa8ALXHeOFLBtFW:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610300035



On 29-10-2026 07:48, Baochen Qiang wrote:
> ath12k_peer_assoc_h_eht() copies the peer's EHT PHY capabilities into
> the WMI peer assoc command as is, including the EHT-MCS15 support bits.
> Firmware rate control enables EHT-MCS15 for TX whenever those bits are
> set, without checking whether the local PHY supports MCS15.
> 
> Currently WCN7850 firmware does not support EHT-MCS15 for TX and does
> not advertise it in its own EHT PHY capabilities. When connected to an
> AP that advertises MCS15 support, rate control may still select
> EHT-MCS15, and every PPDU at that rate is aborted by the PHY before it
> goes on the air. TX then stops for minutes while the association stays
> up, and frames sit in the queue until the firmware releases them as aged.
> 
> Keep only the peer's MCS15 support bits that we also support ourselves
> to fix it. Chips that support MCS15 are not affected.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 17bbb8aa74fd ("wifi: ath12k: prepare EHT peer assoc parameters")
> Reported-by: Vladimir Petrzhikovskii <vladimir@dfb.sh>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=222136
> Tested-by: Vladimir Petrzhikovskii <vladimir@dfb.sh>
> Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
