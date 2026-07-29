Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10A14052A9
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785340012; cv=none; b=XkjNAfybHid1olP5ZDlXqPQ+ZNlExPq1AwCq8X0ROCpZ+7VhTx0do/IDCdGzUfghI1ZKAZz2gakZh9TC5jfZaqihhjb4ULMyZj9v9fEYWODWspturbF1+AVhfkS866nHHc99V4dRnhrt6FWlalP+sirRken9KdpDb4LkUaESFTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785340012; c=relaxed/simple;
	bh=141hLMEXLrYqsEb1IAynEGw04Wg9vePRH/mEYB3RA9k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TZ3I2XVr1NqRlqgNQeQvwrK/LIGu/eyUwbijDYf5KtO2wr9rV6JQP7RGixcxmcS+Bh8V3Bab7qzBQ479EkpkX8pYoEdUvqNHlBOy6KDo9nPdV6ygEhTuUPT37YvGPZtixXeDGaJUaSKGU+RpBT/V8LAydY7z1DMGJlDIAcX9HRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=naKyNRbw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VbjUQ9db; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="naKyNRbw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VbjUQ9db"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TF3AwJ1700433
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wvMXtT1G8NnwWQRBRD5KYhitgr4PdwSykYCBd297j9c=; b=naKyNRbwpi1oyCxl
	K1gxQPbU8+ax/LLWb7XgjzmYwlHJ167B2ZgbyyQfz7T6ljmF7LkoU7xIAir+VIaQ
	QrYznVOjeK51m6HWiHIBtwckAwXmmXXSOixrGiJkcFNDc4mbApdche0jeClWQI6k
	J76OznLQE323o92xBTYo5S+vdENwMJV5p7r63rusQ4hNQr/PSGcMDdo7gvEyW3ae
	wmqxfiyt2mwWb/xzW/M1KVMEK1WQHhm8CbpOwkHKjDbFvFPqSJoyXAEtx2TM51bZ
	TBdhhawGVq/P0WEEkkwR8Oeecm29nytK25FSH2K8TnuV/9dKqTEWBy8wvp0GL+xE
	cz2blw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqgrj17r7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:49 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cea6a46766so20740755ad.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785340009; x=1785944809; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wvMXtT1G8NnwWQRBRD5KYhitgr4PdwSykYCBd297j9c=;
        b=VbjUQ9dbVF+zE9X/wohRzGzokameAUtVZPlK9KpfROFqzzQ+8+L9IYXamaN3JGuyFt
         0F4Wnx9lMM3pfNuTTGE8+fzlkZlmt3ge9a2TNF28yyODEt7urzQXxYkbWEG05uCCYEsJ
         uSHqW8Ry2xTpnH+HEcWmZsvQ1Y6VHXgd6/oGSr0T9dkEgTcN77TXjSA48s4ab1+b9642
         duLvmUv9tRApOp9TUjYIxE91EX99QSQkiSlSeJy91blh9ywWZcjAsUpwEk3qSek8slZO
         K9hqPNr1yW7M/fSouTRgMBi7Z6reHrULlDEOq7uT/dSOT+c2C7ep2DNVNUiyY5Adb6My
         cgSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785340009; x=1785944809;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wvMXtT1G8NnwWQRBRD5KYhitgr4PdwSykYCBd297j9c=;
        b=JURPD1hdx/MHqknfwpDXwANaOIqFREfMnQD1j8X3o5b1Uv4pVnmmiLiUTxYF3CB0QU
         AkkRoIGh+OnLaPoLRA7V437Hze4pWrESOcJOrd9TYTcQ9JdGkjIskHPvCt5DIHM6sU6M
         e7F8BP0/Pmnq/d9vnCKcvf3WOhQ5xxwNyxFNViW1ASsRqTlNFOkXjnNMAOCyoJ6pGeJv
         sbzfs0rDX/8Q+eHy54aK+C2GhrQAG8rdQOEO8+4Rxdw5uhzrqcUGFliQxhop84RqDbpi
         lo3D/C72CfU+UNGPCDab0uVUNzlgkYlQiBbdyyXY7ymelCahO5KsxpIAiG+Gzs6K+uuG
         5zbg==
X-Gm-Message-State: AOJu0YxqMMt+hqT7H8caAA8uG3ad6g0pR9qUR2scc11s2GOZH1Z8VEhI
	/PtUkGcu5y2PglRJoem0SK8Gl1DwLDIdGpLVfWgjKi/NU//LQYaZ6HrCTAHrfz2MwxKfE8ftQ8c
	gPawR4y6KSbDVNkdTWSGrpAN9tG/A/96QqdwprRGc6lBiOMkLR2Bz9taWnuNkKqQPmMJXpTatHI
	m9TQ==
X-Gm-Gg: AR+sD130UyEfGFgtDnSytBHRVsMOUzzFrWqbZQQfDYwR+pUX4SpKxjf1CuojRRxtbMq
	rllCMzVG0PcW4VMLTO+qto2yuFXKWjWoff/8qh0Q2Qw1hHFRNT26Cu1iH0VwT2MtAs12x39RFEp
	6Esjq+v+YUgJFomtb7ty84fL6Xu5Z43OPTA5BnHQH1NvMGfzMw6vlHqV0wDrCiETTX2lz9nU7g1
	xZ41MJmSLoEsiC2Qi6euX9ejsisapdrSJwEqQJ9aiHjNx4tlxlEW5MzTIr/WN5rb45mClcPPgC8
	HhnfEkDUmfQMCtrgL7KBERvNP1vmMHTZHciP83H0twCKsAwyyjMJTHZJ91DeJOAH778DKWRz/8d
	J2EfFPziVPH81r8K/1obfzlEl+exyn2znVE5zGH0gJjkJX3WM+84K764=
X-Received: by 2002:a17:902:da8c:b0:2cc:7e4a:bcc5 with SMTP id d9443c01a7336-2d015d48a03mr74927615ad.32.1785340009213;
        Wed, 29 Jul 2026 08:46:49 -0700 (PDT)
X-Received: by 2002:a17:902:da8c:b0:2cc:7e4a:bcc5 with SMTP id d9443c01a7336-2d015d48a03mr74927425ad.32.1785340008799;
        Wed, 29 Jul 2026 08:46:48 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a76a5bsm13577185ad.35.2026.07.29.08.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:46:47 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org,
        Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260723054653.2794550-1-pavankumar.nandeshwar@oss.qualcomm.com>
References: <20260723054653.2794550-1-pavankumar.nandeshwar@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: skip MLO multicast links during
 crash recovery in Tx path
Message-Id: <178534000763.2826154.462337785259615514.b4-ty@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 08:46:47 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=RJOD2Yi+ c=1 sm=1 tr=0 ts=6a6a2069 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=3KUpPwZqX_pmD2fy2jUA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: pwuxDMALNIBqiQKQJqdhfDfdvJg5gc1V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyNiBTYWx0ZWRfX51TUIi6zdryO
 RG0zkmDHdYATjK5IQ6qqCFszfDiutI+wuCSuBkN44H9QuAv+rb+NGZK3MHFgbbLJ8HPPjgIpzIR
 BBJqNE8s6QPfl8iiE7AxXucxizyk0qSvUv3BkYL+BuBp+Z20AjQ66I0RuGRtdH0B6sJLWh7hAyf
 LDTcOPRXNzhW/ectG5y32kEO7EcQWVR02+ppFlZCj5jYXkGd7fjzTNyyM7vLWW1kjcGllhIF/ti
 1yUdfTt3xZCIB819K55Ihe/nrLuVk/AUxQCjY3RctB6k7p4+eQjKe/Jmlk4vNF+KSPHRCYiKlCD
 UcloJF9y53akNgV0ku0SGcishfhPxgO7cRxOroGmznkkbjmvv+XsMQeshLOuKP5zHhKD6heTBp6
 0RoUgd0D9DSZZM+K5iLvwHnQNa4njtaR9tfMf2ujwG4F40xX15LedW+yTdNQhHNpCeW52a5Ei4/
 8YnyBv2u+JTCOtMAaOg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyNiBTYWx0ZWRfX2fh1tqAkwyO2
 QrhPKuuw7By3YSWE/kF3aDs6ueiJbSN/GaWudJ8kt4Dc9iTV/nCBaLI1P0ysHbFJ+EPPdo8bxkt
 oAKWzkbFBBbZsE7vJI3Fwh38sgqDlfM=
X-Proofpoint-GUID: pwuxDMALNIBqiQKQJqdhfDfdvJg5gc1V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 clxscore=1015 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290126


On Thu, 23 Jul 2026 11:16:53 +0530, Pavankumar Nandeshwar wrote:
> In ath12k_wifi7_mac_op_tx(), the MLO multicast broadcast path iterates
> over all active links and copies the original skb for transmission on
> each link. When firmware crash recovery is underway (ATH12K_FLAG_CRASH_FLUSH
> set), the per-link copy is allocated and partially processed before
> ath12k_wifi7_dp_tx() eventually rejects it with -ESHUTDOWN.
> 
> This wastes GFP_ATOMIC memory and produces spurious "failed to transmit
> frame" warnings for every active MLO link during the recovery window.
> The unicast and non-MLO paths are unaffected: they call ath12k_wifi7_dp_tx()
> directly, which already guards against the flag at its entry.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: skip MLO multicast links during crash recovery in Tx path
      commit: 43c521c11ce8fe904e14d1ae0566ffea931cf2e9

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

