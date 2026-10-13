Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3A931E84B
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 01:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791853561; cv=none; b=Vjxb4eCF2q2hlnpOPLgrgNrX3qs2LK/w5URTuaaYrWIFqELJB3Pd0dxFXiHKkVCT5vpxUDu5QyN/eQdBFuQ1QeeAnTe29ggfwSrWgwcnHhdY+KOiUfOXGTWkTycK7y9D3LndKnrQhm5biT535+sy0oTtoF5PR8a95nPf7ugTWr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791853561; c=relaxed/simple;
	bh=hliFxLg/08K/lCxWxcspsNjouNv81fUc8zuqb9TzXng=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LpMxTp2b6X/umvKJh1zTR/y6BhuI9S91CCnuxcI3gWldkpgimIFz/ofR+59LUbpvbcgYDf1mA+lNJI5Ei02OPQ6UgF5kNn1X+OJH6bgzkUk6sY2ZslcuF1tqZKrtPvJLQaGTb0Va/qVXrVdy4q66QrmoevwOJCaCoPcDMlePGcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YLw2yf5Q; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SneJpvDC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YLw2yf5Q";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SneJpvDC"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CJNBjh2911974
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 01:05:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	E9BOepFcQTT/lrMuwWyqaQqUcTrHIMHwmO24mO04/js=; b=YLw2yf5Qedb5Zy2v
	5gUsUxPCOa63JrgXqKSYCq79+I24OFu9mMvF9c3KhFsnjQrATtwcI3viSxS0QOZh
	XlkxFBv/R5wIeuViiH1jKs8roezMOVKtSSJ8Mj0bWGCO9CdKTRf0LNwIBmF1NqVZ
	2er7pTe076o8Bzv8VffbVsbfdM9L76zhbanICv0uN8kjAllDCuQAbo9KH7/RU5i5
	9IkTjndMYaSVV9Q+MOBvZSbF3sgoUa5ZyZYeYtO7jrHYPVdcXdYW72RJqb1MDAKZ
	spw8p1dD6yDGiy9vlQfoI00aqbX95epWuFxcLyjajaras+Xpk3G3YT78t3lhdg6k
	Ufk1Xg==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h940w1gqs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 01:05:58 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-35c5aef2a74so988859eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 18:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791853558; x=1792458358; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E9BOepFcQTT/lrMuwWyqaQqUcTrHIMHwmO24mO04/js=;
        b=SneJpvDCqijGA2rzs4I2T1AZIMSy408HfM4uxLrdU+WFcX1hOFyI1JIUlk/A/EZe/6
         ZPqnpdp6o9v9BcRWDInZnxsQ/qKjeY0dy15bzx12BVqVYyTjMOD77Fn+oNZL57K5W96k
         4jlOpc4lplyr7CYEjbY1Mm8Nh2dtt5QNgrHgmLnrh1dlKvkCqpj1OQDJibXKJt3NhKkH
         gWSa1mQnkhkeB/zKuoSMXi91U8wQurVlzfaxD0tFVFUaj84Jn1vOYMoyHXyPWnV6ULBk
         KrO/nBSlz69NGbBO51isz+WfHuc3tAmvtMz2HcxkOGo9GhBOVp4TECrm+Oghfnt487CX
         X3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791853558; x=1792458358;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E9BOepFcQTT/lrMuwWyqaQqUcTrHIMHwmO24mO04/js=;
        b=bplb5TKEYrsUdH7s91e0rg1TiU7x3zKlC4caUBDYQ/vC9aqf/4GmK5llaSSD/EwjSR
         /vnIV9EL8VTSldvP78s1QHBtOtzn491A4HINhWEE1n9IVuCPGswbC5h1Dg6yebQaXbNu
         lCztOncbZ/9CJF0Rb42JHaKWwxCLCZojPn/ozpdmmL3skMj8qmmSxUGM0T+qvz/rudO5
         bNf7BIKjVzZaXOWxx28ugAf2gpDeJpoUFBtRp43lJDfEq5NG5Ghw4j02OqSUPZXUg1h7
         yoQx6N+WuSP/i7ke0zsl3PQZkWxno6d+qKI1zlnJvRow/zdqmqnQLkkRg3TsUV/Ieg5l
         pAqQ==
X-Gm-Message-State: AFq9FYLFTowfNRsvqRaTEMThzNQmCqacTeng/YeCdp8AG+eb1eNUZJck
	yrKAMzzGDer9fhcXR1Xkhwy+08gYYQ9ybYY305dGuKKKp2Cd0S+EE8P0UX6SxJ+qc6Pj5EIrl5K
	J/znLUiyhb2RikyIaYYbRHGWCtllRiyEeHj98xL1zfeudLgspGpSuI5ITjIXle+pBF0BCrYUjCM
	KB9w==
X-Gm-Gg: AYBFou2Qxe8vFpAfcj4CdTrIt4IdJpYSJZ3A0XLC/6X70qAdVtA1prhUY+51CYfysQD
	aeq2PlFalQkKNXWNuHrhqYk1klvWIcF75Lv7CbrTC3pY/IEQ1V1uneTIanVH2yqMPzQ8IZqZLCk
	TS8IA0VE2qmxocYoG8aAbShEg2p1S96zqvMzGoDouQ2/JGFy/IlvBDa9PXKmkd2jbQEx1KEM1xr
	kgA7A+5Biui0LuUMbKjYeoz1gpHpYJZs4mYAfMSZnTAtRgyqzcnlFM/tyEwTcpAbgU59HxYaAue
	FITpo62BmZOJtzLyYL5gWG+ZvSfGiA04k/6mceV0DaQAo79ILQcwwMQCJXoDGZfBcBROPXs2/5m
	lQNcY9++weVaeJ7uiNPbYXfWbbHAIOden0kakXuWdLNMeF5cZh5UCHdU=
X-Received: by 2002:a05:7022:1703:b0:166:b307:5855 with SMTP id a92af1059eb24-16a4ee7e657mr14800899c88.0.1791853557603;
        Mon, 12 Oct 2026 18:05:57 -0700 (PDT)
X-Received: by 2002:a05:7022:1703:b0:166:b307:5855 with SMTP id a92af1059eb24-16a4ee7e657mr14800866c88.0.1791853556900;
        Mon, 12 Oct 2026 18:05:56 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a567bd18sm32904080c88.21.2026.10.12.18.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 18:05:54 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
In-Reply-To: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
References: <20261001045423.493121-1-aaradhana.sahu@oss.qualcomm.com>
Subject: Re: [PATCH ath-next v2] wifi: ath12k: Fix NAPI resource leaks in
 AHB external IRQ paths
Message-Id: <179185355440.3481009.3900302588078400009.b4-ty@b4>
Date: Mon, 12 Oct 2026 18:05:54 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Proofpoint-GUID: MCseKI83AiKC4dMXu9PjyE7zmfb2fc1F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAwNCBTYWx0ZWRfX676va2aY1ggq
 bAenWASLFHPUAcPDgmdf7hKVlYsM6qkPtbqoMo+6ygCI0x6NxGqiHq5f7+svoNyUFTGuALX20kd
 H3sY74EHhxqnwcWqNlW2/30fiGyHEyz+vCambKmln8VN2JrGmXy8RktuQb7QWBYL4jkxlClnL3u
 EvsjYqBYMtfaOykeplMYvgSdcaundoonxk0K4wGoh3L44pD5Pm+bC7ZWrfUVy7p1FkcE7jFhaeP
 TRdU4jFe+Cuhute34DIWwd1q5xS7FkbDpt3uwSCr/TXWEA32LHW0Fag7RSApLZQiicMUmwvgK6F
 w72MMPRVTgOktudFfjxg3ACI8iyDWbJDhYqGkukcmD2eGOLr9a56zagWMbgzeqraNeGbwusGvM9
 nUmX2mk79Bg9VqcIHxUkTaWFxUI7RAcv50Pf7dtlsiBenM1zlmm3WLu/XpIwWgRKbh22IrOghKF
 jD0aUXFcj8jFiM/JOcA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAwNCBTYWx0ZWRfX5kGnp4nY5cOs
 1Js0VLohTGT8513GQjEBzVjLfCh7FGwCBuZeV+VMzK0q30Oc6D+DbPa32VzykH3ob2MwcaI5vXF
 Jc/Fm8MF2E27dI4w3VE01iYR2XSfDtk=
X-Authority-Analysis: v=2.4 cv=ftZJ914f c=1 sm=1 tr=0 ts=6acd83f6 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=5S3J2RfQicqsIEM8LIEA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: MCseKI83AiKC4dMXu9PjyE7zmfb2fc1F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_06,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130004


On Thu, 01 Oct 2026 10:24:23 +0530, Aaradhana Sahu wrote:
> Currently, NAPI instances and their associated netdevs allocated for AHB
> external IRQ groups are not released when external IRQ configuration
> fails. They are also not freed when arch_init() fails after
> ath12k_ahb_config_irq() succeeds during probe, or when the driver is
> unloaded.
> 
> Fix this by adding a common cleanup helper to release the NAPI instances
> and associated netdevs. Call it from the external IRQ configuration error
> path, probe error path, and driver cleanup path.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: Fix NAPI resource leaks in AHB external IRQ paths
      commit: ebc938ba1d5ff33652013b99c7b9a74f05690336

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

