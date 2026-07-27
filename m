Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31E53DDB1E
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 08:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785141503; cv=none; b=DDTwXYgGAQBHxngjb4aCzixAFnEnd4NyBkLKnopp1EfTc+2u3VkLA3NZtLBwKbN4Xp4OkyO+LjGVo0ZxZSriv38Z0kmYK6tedh7q8W/exnChS1uUv0Bcbn8KKYOYF8F8FO2lBdw6Wwi6gAzQzktSs3Htsi55+123LNALHGXmsII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785141503; c=relaxed/simple;
	bh=lbbNnwK3VkwBMs+EmlsI4Fw27haWgx2pGKXP87TLttg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UwDbLq2i964IflroGACWnLyzGKEXBLLdSU3zEGa03tk+Aqj9c9n7OOhPE2wiENEPIn8cDAOhmISX+5rsc9dFp51LSsPwJLC5+PLFmCif94ug4cTuvroPad8YLSbxeGf82Au8REBfEwH5AXuCxoCgYYyidTbptG4uD0R8aszvicw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=b3uBcf+8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kQoYkeTf; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="b3uBcf+8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kQoYkeTf"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R7RfOB2936851
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 08:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JBJODevipv2/JNQZQkU3PGD4+im0nIr+wKclPG5CiQo=; b=b3uBcf+871dDTxsg
	Cd53dTDUPYOBlWM5czBnT1pNS+T44MP4K3yA02G1/YsoptygrNVtEbaOgIzhJR6f
	MN1ajTwymI1pPBr0je5MUw71/U8bH2rX9ksjlrUNmnJ1DZ0hmNiBLvdi8Y001vqT
	29WnQPjkcnjY35P5qPc7Gvs8aGVB0RSrFiIYd3ui8kSW47xG8kWsRGk6mXHsNrkH
	s7/nsxK7RVR1e4qXqofricb9HmQB176l5Ux55pLknXe69kMF+CJAX3F/ArpMJJau
	sxgZhfc5CW77D+c5lT1daa08q5kPaxDcOgVrcSUlziWGmnHcuc9ah5aG4STNTasZ
	A3hyxg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmnwew93b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 08:38:20 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cfca8558d2so36595355ad.2
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 01:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785141500; x=1785746300; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JBJODevipv2/JNQZQkU3PGD4+im0nIr+wKclPG5CiQo=;
        b=kQoYkeTflHwDpWwutbFTjQ5w7+3dUqT8BwvBoihkYYvucVbsxQ+B8EdzzqoZBp3uCO
         Xzz9YnE34bhspxBHO0jvFatSUJhK1JuIq+Pj37v+dXsjkYIynHbB8vw0EqDRMKa/n/ce
         d14g57UJz+cmRpIN1q9Vj753GU7GbwgY++npluEUtrQ5Tc44hXcdgFIEVK9DgqOpYc/y
         qzS1PJr1QU2QXvN0ITNB8F4kzoeGz7y0oHyW4jfZzP1i19Q4sjIZfhuaxM6ezBQelKpq
         PuPCoCQ5CLXkmzikl3r8l1G5pDeSDVT3cZLSozUKxpbweS9aYq8eUNL97qY1VOOZVEyI
         0tnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785141500; x=1785746300;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JBJODevipv2/JNQZQkU3PGD4+im0nIr+wKclPG5CiQo=;
        b=CIqjLj8jyhQjnmUkb5sJ9vlD0EE7POq3zdS6+S4L9BROIAELgXkWT5H9B+TC57XbdT
         DjPnhaC4+slPR+yoq/MnGlKNi45dCOgZTVNznU6h9KRXc42hh5+UaV/EEpDWpRculGaA
         d/VCAhkUTFyuxrHPhR9ZxSZVnRzNij351xlCb7Ucr2F9iqirVStMNswEBqzFUxwlgj9m
         EHaRR69LT5iH2Ql8B66O8BYB8bmdDPwhJqlXaJwkbZdeiG8Z6satpiIuZe8c5qO203kb
         2ES40UR4m3WowTle6JxBNyXmhsOZ3fkykGoBDmvD+OoFay+0Jad8vqzlnruhsr7In6m+
         10RA==
X-Gm-Message-State: AOJu0YyLK0IJK0EEyk481YuJx8gmD321a0pTEG5c6fJl7tHHDH8Kt37U
	kHTVNuyc5A2+W6Sk6Bh4Vo0HR+nivwFli2spXiLbHMZTNC9xGefxjEtg1qwu90wDUd1iMEhfFRt
	WEDBNTZGhbzTK2etjtA0rzD6EICrmEMzkGWV8kfo/0CF6HXZMYSHD4/k8ygW/t45XBVLYZw==
X-Gm-Gg: AR+sD13VdTJX00oCK4rUzsOpOsJ9kMcyBjPtrMq7jE7sPE8YGMX3nYXq210TgbKLkQ2
	JwN+PEbnkEKgsF/PIJMoTC7lwxoGgsdHdQiYrprMGyTLmtNTzNGEQKmklxKlkEh7bMxfjYGqelk
	JioAFsuLgeIii7oi4NDZWxuDCBksRRHSvCqcR7BaSSGm4h9oh+FsI8Bcpg+o10PaW/osIck9dx9
	9M07CVBz8P0+vXuQhPVTaR/sj2Y2bpG4s5zxlOmDplichVzQh+mi3r2IJQq5NSYp4UJqRrlP9Q5
	6aiboqXuJfTjECYgbgXq6sb2qWJ9LnH21uVM1zB11ZyuNAtCg+w5CQctB1v91LmB2E/jC9zsQP7
	xOa0il2A2jXQ42eOHICBd4mtRKlGvZ4k=
X-Received: by 2002:a17:903:2446:b0:2cf:4505:6bcf with SMTP id d9443c01a7336-2cfde83038amr68156835ad.29.1785141500297;
        Mon, 27 Jul 2026 01:38:20 -0700 (PDT)
X-Received: by 2002:a17:903:2446:b0:2cf:4505:6bcf with SMTP id d9443c01a7336-2cfde83038amr68156635ad.29.1785141499842;
        Mon, 27 Jul 2026 01:38:19 -0700 (PDT)
Received: from [10.231.194.200] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde59b768sm31703235ad.4.2026.07.27.01.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 01:38:19 -0700 (PDT)
Message-ID: <4f08e6f6-29bf-4653-899f-e0b6cf806675@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 16:38:16 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath10k: snoc: use memcpy_fromio() for MSA
 ramdump
To: Linghui Wu <linghui.wu@oss.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        linux-kernel@vger.kernel.org
References: <20260727072629.2297208-1-linghui.wu@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260727072629.2297208-1-linghui.wu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA4NSBTYWx0ZWRfX09BnlSqqTS6W
 RRY0fJlWoIHDdDmklCeUgCFzBLIR48r5FYldgiMJ7yDPi2gToPlbPxKNErDRlTzir+mouco2rlH
 sPCGGUz2xSwPUsL88yGOsXFCJ6L2c738sdnbm7njWGitGHGQRUgn6HKT2ExZ0k1wql/OwM7VGYs
 JrR1wmmNl3s3GAOWy6NDlgqeekipaJoCQCetNZkdRROtI5F6Pt9vjFa4g7Ih9TaLqsU/6GFz2z0
 7FkmGszHbG5M82tkGkhUUWM4bbM+EBZrA6vdpsoELszDnT4MmmVkwzRaqZN1GBb47NNuIhEgQQj
 yimLeUc9HXFrIsYKChncmWgjF6gmbyGSrCTR7PFdKj5nFpgZKZLwajlxIguLBBsyJbYpcvaH4Ev
 m3sxtfcpVHLc8zGzJ5gtw8LcHp2WF9qUmQDYhhrKRmaYPKxLncvXjZvIJkmj9OhbN2PKB4+LNyK
 fjazchPCOr/yKqJEahw==
X-Proofpoint-GUID: szNTdFeAlo-9Am75iejyjsJ_q3z47oH-
X-Authority-Analysis: v=2.4 cv=S77pBosP c=1 sm=1 tr=0 ts=6a6718fc cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=EMxFUL3Ltl7gSd1fbyIA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: szNTdFeAlo-9Am75iejyjsJ_q3z47oH-
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA4NSBTYWx0ZWRfX2yUAOYMnvGbO
 5/APKtbi449GhkpO0LdiTPeCFzSrn7CwM8Bvr48+gnPK22zSrcC9GP4Idoh5sp3Fkdi6q6XdzUZ
 rDjehMDMKx4kvXJ02u7M4+2dm29j1ZM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_02,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270085



On 7/27/2026 3:26 PM, Linghui Wu wrote:
> On WCN3990/SNOC the MSA region is mapped with devm_memremap(MEMREMAP_WT).
> On arm64 such a mapping is not Normal-cacheable, so unaligned accesses to
> it are not permitted. ath10k_msa_dump_memory() copies the region with a
> plain memcpy(), whose optimized __pi_memcpy_generic implementation issues
> wide/unaligned loads. This triggers an alignment fault (FSC=0x21) Oops in
> ath10k_snoc_fw_crashed_dump() while collecting the devcoredump:
> 
>   Unable to handle kernel paging request ... FSC=0x21: alignment fault
>   pc : __pi_memcpy_generic
>   lr : ath10k_snoc_fw_crashed_dump [ath10k_snoc]
> 
> The Oops both leaves the firmware RAM dump buffer zeroed (no dump is
> captured) and crashes the kernel, which in turn breaks modem SSR
> recovery.
> 
> Use memcpy_fromio(), which only performs accesses that are valid for such
> a device-memory mapping. The generic memcpy_fromio() implementation aligns
> the source before issuing word-sized reads and stores the destination with
> put_unaligned(), so it is also safe for the coherent DMA allocation used on
> the non-reserved-memory path. ath11k and ath12k use the same pattern
> when copying target memory into crash dumps, so call it unconditionally
> here too.
> The MEMREMAP_WT pointer is a plain void *, so an explicit __iomem cast is
> needed; use __force to keep sparse happy.
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.3.7.c5-00107-QCAHLSWMTPL-1
> 
> Fixes: 3f14b73c3843 ("ath10k: Enable MSA region dump support for WCN3990")
> Signed-off-by: Linghui Wu <linghui.wu@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

