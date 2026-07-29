Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987A740A925
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 09:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785315648; cv=none; b=Ns1uJwnTiKu1OVcyDbG6gujFwkCZpzCyYNED/Pu5Hl50wEFW18L01VWin9byWNn8Z/U90edKFdSDZ0jtmWWFRJo2KKOeB3juo57sKyvySoy4rrfKGLjgdgw80HbESOySCkx7gBEoBrsHUcwwu+stKupB/0VIwK1LJT8hp7S3oxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785315648; c=relaxed/simple;
	bh=11kxetmLpCbDYFq9C3Bb2VxronGK1Fttv9GHI4Q1Zy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B5+tqi3uZKoK7ca+tj8n6918qiHk8tkWZFcF8obsx7e95gJvAU1lk8Q8bfD2Yg7w6Z2Z+Ib6Z9AwxQgBRGhUjwhjHVJ6yMIT1xScF9uaPfcq6QSqYbuq1Pvnf5FMwQ0wUyIX+oXBRdC7FsqLV9rrtmO1e1kSHE+hIPYjPzZ9Gjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S8BLB5eH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gdgeIBYM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S8BLB5eH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gdgeIBYM"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T7fVtA1310809
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 09:00:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8vSAh5arwVCztMjmOZ4jFlqD2gwpQfFeJ4x21KNMh8w=; b=S8BLB5eHWpCpjSHw
	msH19dFDJkF8Dnh89uTXaEG3KvdH1UuxoXEUUo176VEVa/llXIBenUjCdHR3OikA
	4tNGGt7G/8Ee9oSY2QRdH4kQ0JRrj1niwpC2ovb3Sf1Az3/g7XzGd9M4MrWPL/sA
	0RESOKMPP9fXaxCAUtkoj2358G1xgaS96PiiKVgTYdyURUpm1wR6rx7jtWAnrez4
	VQuOxi10Ibun4Z3GP2ql+oenKuphriVbOAkN3/iVwaI0I02uh0SDijKju3kQYD74
	1uijUmgmRH5QQLHesBeaVPGu77+7of7BaVeIk9Y8BhIbAbNqkuh8rMCG/clTeHdG
	bGButg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqa331312-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 09:00:46 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cd01a14e81so10837665ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785315645; x=1785920445; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8vSAh5arwVCztMjmOZ4jFlqD2gwpQfFeJ4x21KNMh8w=;
        b=gdgeIBYM1NOS/Rtm7r3QIuGoKw7cV92q27czdKn8nyRxH9UYQFZgSemMdYwgWt4vFU
         q/osbugIpTowWkKBZmG8Qx+ObhOMBTSU6v9ic+XLLP6FK93KcIDLfRYVLA6ottsZffqE
         EGF/kvi3uaJuX9vDni1A32oj54yR2Qafg8FaPga0jTX/qNA/jsPY2fDNuKCNUeI8Co8n
         G1I8qXJvVIkmIC2w1fxHQDRxR+el7wRryLUC6WyPmsOyfB2SVP2SYhl7o5oHShju2fot
         3U/9NHpBnskuuFyqgu/VTmN8At4231D2OATEMLhnB35aysthwGDFq8CKilQ7u2eVkZjP
         D0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785315645; x=1785920445;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8vSAh5arwVCztMjmOZ4jFlqD2gwpQfFeJ4x21KNMh8w=;
        b=DG4lFZZU49rZRsqMDpH86YJKDcQY3A6h/YZWPOb01oKap9lF6hjKWF2tiOqbBSac5g
         7URKxAG8ZuMnVif3K8EKnsgcUz0M9+NCWIlCis/2D12X6UjAqEDkVdykzVndtaOPIOtc
         iTp0jckboY8ShEPD6A8dosa9OuRvwJlnQL/xwWvm0kxUfLUpgVw9owdbASQXbWrgr24K
         Ne5Cfuab5hh1gAQJf9vrjyk7ez+6en4RdybQVqXVmJqb49thye5wrBP/B09tVnqICarR
         irNYhvRNJVwukiqe0ao79qQVqUogEbOBDkzSlYsjYN/ImwZIiokhJTqbexYdmfDSSV7R
         ah6w==
X-Forwarded-Encrypted: i=1; AHgh+Rp8mG3+pqezu5hQ/aSXE3BJj3odz0HVBECckKWIzLruOoLDWrYRvJPKvcKWXZzRU71M5HpVioegj1nBr0kbCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMuu825yHHoL1nlIfZG8ssiXX69rpEUUduzfpYqUDyoFfKsENg
	GllJoZ7xJ/9D1qVfbTpiD/X2QKg/JYQ8gh+Lo+EV7Lw2i5ij2BTaQjdIPMo3nydHjDPp0GTu6fq
	f+Oot1icia20QwcjsgRwAe6GHyQLFjglqlYab4OIZebBOYBqhMoq35hqEWWMmCnimROsPZg==
X-Gm-Gg: AR+sD10yca2keJgqlE4CWrtWyc972g5mry2xco85AKzUeQJP1iA4B2b7XFymuniyeZR
	/esCffhZo+D4z8F/sAaujycydl9pD6BOlW7e/UX1ClxZfU6XcnNv/VrvUOb0UYgeqQIgd+oxF8S
	xlWC08zkiA67VnxCKVx42MR7d02sHOxeLlXH4Xfz1EuiTDCTdyKF9V3h7Dsv275KKTdCfq1HN9+
	4x+te/m28f3D2KcDGLGwYL/XBaewK9J7VfxC84laBvCEtq2pJwp0yYnZBM2gQ8d19Xk2tfrovpq
	ggaK9ECvbHFnnH4AwAPFCvDkjbTtIAi152ugbXKDZfftLgrloEquMwJnlg2IPqzG6LmjpsJ+uzu
	kqfBmBXF9oz1GdeWV60/C9dSR9RbsK75T1uNOOKjqxNLNViDww1ZXQfPAESmRT88a99xA33Rdjg
	==
X-Received: by 2002:a17:903:37c5:b0:2ca:e62c:9e96 with SMTP id d9443c01a7336-2d015b0021bmr63920095ad.5.1785315645442;
        Wed, 29 Jul 2026 02:00:45 -0700 (PDT)
X-Received: by 2002:a17:903:37c5:b0:2ca:e62c:9e96 with SMTP id d9443c01a7336-2d015b0021bmr63909705ad.5.1785315629857;
        Wed, 29 Jul 2026 02:00:29 -0700 (PDT)
Received: from [10.133.33.108] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bc8400sm8046265ad.47.2026.07.29.02.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 02:00:29 -0700 (PDT)
Message-ID: <b9e32b0e-ceea-4089-b7da-b53525cd9ce6@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 17:00:26 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath: fix stride mismatch in
 mac_phy_caps_parse
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260728-mac_phy_caps_parse-stride-mismatch-v1-0-27a9c1a3fbd0@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260728-mac_phy_caps_parse-stride-mismatch-v1-0-27a9c1a3fbd0@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA3MyBTYWx0ZWRfX45UHGfrpVh6T
 EfEw/hYe8HWQzEeziu42Lc7TFTi2AG2u3KJqNhKYIRV8Uk8nYSfDiHnY29G7zgCZSTQJU1ZO5gX
 qryqcSRCltCwBi4K84RfLnsQ0iJG3mAlvzrGjC4NbQPyxGsnEoZa/iOwDQnzEj/ItZHdO1qsQlm
 H74FJxDKD+vcAH0oPXBvPcCYEcqNulmwyVygwzKxgw1fNbjA4SHVTiaV1VeloUoWT35c7F2ZeKB
 60W58NY4siP2CVAegRWTwG/EAXcSCdW4pP/Ry/qHlyA9502utZGO5GDRZl8hGcgbwgkFWJiP6F7
 VJPRZQJx8rFwjE4pPrBu5AagwHIlrl2LVat+ct/z0IlP5TpocI3+pTTySsjRlos9znXpQ5qYfgE
 CWwFfTAhfgoktHMJFkT/yoWuZbSLbKmfkxDcpKRS6ymYh/SxlZt7a6GuGMuU8Csa/aLuEgS63FA
 o/G3D8r+mh5Oc5TJSQg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA3MyBTYWx0ZWRfX/L/RVePprlbq
 01iDT4+Y5buSKwD5NTK/BMT0nkhJ4BnO67Lx6fcuJn5AfqlL+7ruqt4eOeo39jctkn0JAx5Xqog
 kFj9TPonMzX4Q/pAYDlGqu5pkweELQc=
X-Proofpoint-ORIG-GUID: QsDneSH1QOAbyUSKVuL7VLX_AL0GNmtI
X-Authority-Analysis: v=2.4 cv=Ap/eGu9P c=1 sm=1 tr=0 ts=6a69c13e cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=iviOFIqGMEcFCaixUmcA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: QsDneSH1QOAbyUSKVuL7VLX_AL0GNmtI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 malwarescore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290073



On 7/29/2026 9:05 AM, Jeff Johnson wrote:
> Both ath11k and ath12k have the same issue.
> 
> ---
> Jeff Johnson (2):
>       wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()
>       wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()
> 
>  drivers/net/wireless/ath/ath11k/wmi.c | 8 +++++---
>  drivers/net/wireless/ath/ath12k/wmi.c | 8 +++++---
>  2 files changed, 10 insertions(+), 6 deletions(-)
> ---
> base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af
> change-id: 20260720-mac_phy_caps_parse-stride-mismatch-e7292580f072
> 

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

> 

