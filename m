Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978723C1D48
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785340007; cv=none; b=XkcIFCyCy2w/m/SbDXX/RxdGGwXU1QSvAeZJXbo4XbAzD+wqbycsskCbXhfiIMRpi4zRAQGsTMo/RasXyzjDCjH/ySaDkZ0zVyYQijdpE0E8lGQDqskh6H6g3nU7+sDzBWFHXFIIwXPm1GQOJCRPM9g/L9+wknNSY9wbF+WErKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785340007; c=relaxed/simple;
	bh=cyd4ZjHNcM9AyUsjX3ilsPSbuDYVPRjW63+zzrmsECI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LJzJ/rPMCOWzR91riCXLCn2CLKo78iQHE9QOhcDW6Z5pwpg6DsAJXuj+MwfubJbVpk3h6FUd4CflPKZVx0rvLtCYdwhkUdYLNPLHzKTE491v/5y4KWkCdjUyfbe9wTtnzmt9r9J9qkqvWymzRpDyn3T9k5sBUrajIx7NYAeCPJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=O9CcIpAi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CySMmH+Q; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="O9CcIpAi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CySMmH+Q"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TF3HE73343459
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eTEXbHq/KMfkEcYT+LPWhmkDHUWQdBZJ5ysUFXe6EdI=; b=O9CcIpAiHNExmyC6
	HJvt4XlOoJ3xmCk9EJZGdUvdYrQ/GVQbM2D6CJrNHm8/k/T2j/2hwoOaNYxt2WbR
	Wvry+eYrKA2b4OAJqhhBoe6kpV8QwZ1LgE7P8U63JDLcYXZrldykm7hsh8eaHNds
	/U10rMHpQiP/+9/fJDPs9XcMUM2vaFv8wF3SczfjHqV3o+2xq4aeRTm87rTeD/9E
	4r84g4oY3lL1Sp5eg06Jb5SX1Aj9GK0IBS79/ZMasORvWyn9to60V19FP7fMZOMx
	L57BZ92Vj+5PEEGkceLziHmVOp+zfLFZfiJRZ2+K/HmvjcIp56GUmER/NIglGOQO
	jSTZ6w==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqh3ms4gf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:45 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ce7dff6253so21047585ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785340005; x=1785944805; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eTEXbHq/KMfkEcYT+LPWhmkDHUWQdBZJ5ysUFXe6EdI=;
        b=CySMmH+QAd04G5fanI03azSTuVr6JPa+17OAPOo5xsmWbyWwyi/jUgeCMz8C/pM4TK
         fNEEQ6JEEQ80QbXqEf8buQZ7gFtBR+P3aX8a6NO0lriO2gTRLz6cYbW1zxs46JYew+Ja
         QrYHwmc9zsHVlilc77rZ4D1pwDQGd2N+fc5C1lIfHlZvAya+PeammRDvbvi2oaRf8yxw
         yxc9WATRsHRpRISBOAysHDqq9oc1Z8oruF25rlQ+4UElWdthb4n61VLXR7xF9/fkbcwM
         hpadaHUj3Nn16BzCQ69ESNQQ0XIZ3792gIdGRRJeVRb9qfta+dokvM8UwqQSzurwmhzQ
         3nkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785340005; x=1785944805;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eTEXbHq/KMfkEcYT+LPWhmkDHUWQdBZJ5ysUFXe6EdI=;
        b=h7P5Th/8h6qKp7UmGFkNQfrG7jXKY4LGzM7MN/WyEjhdLHSkFvaRFlggNjrHl1IG6X
         yZlGeaWPda8tKTjG5SU5+i0moIy8VJbNi05IV2ek/ksVj9FPpelLS2jJTXmdClnl6Mlq
         CTpXO4LPS2vlklhkz7maq14tqu5zmK4+EiXCc8NWhNakHE8PDej2fGmBc6F435IF3e6C
         aBqlPogtZIv3f6IYhqUtWOArgbtsVqwvoZdouSk0XXOO4/HbPjfWvktua6Fj867TP5cD
         bB19jeyYgsmYUJLTVF8q6kw5GguzWVH3n6NF4kP3fqQAH9Si56B817SLJOwCC/p3bX97
         Lg4w==
X-Gm-Message-State: AOJu0Yzpm7Al5qDj51o6OK5JZsT8/vPbT6+3PUSVLapgHCcxhxCYPPV7
	db87Qo5CNqvEFjJxzv214bsz/VDGsf7X0o2gt4jY/rWwwr7bn+8k3E4U/NN2TW7dvZwRRXcNZwt
	Meq5MVVDf5zbKn0159O2Xee3dsM2Kvu5M7V3b8067mzsrjMWb6woTvH5/+3ZfqqvI8Xg7bQ==
X-Gm-Gg: AR+sD10165h92Hw4NGmvcfcwyJf9vwkpZqca+Q5oRfR15qOgKloizPJmBYu4CbI00tz
	NTBd7+Sd1+9x849cYoN9J/hoffEsXDMkRCX43BW7iqEXG4qRYti3XsrimUqQrfh7uPxIOPvW0tv
	CMpjiTJQ22Ab7GlJZ95mSdo8l/nWQOgA1OSSIjuuwKTERep6RvlJPOmXw8KBQ9SBGJ15Ml/6LK5
	6Yr9EFrNzPXopW5g3FBq5KnHeae7lDPpTei6heAC5KFzBAVQ6PtLs5rG643YPYaug31e7Ve6Xzp
	3k1de0P9PYn7uW3uICdtjWEuUBQZLV2Yh1CZutmY9Tt5a7ikL0KfylvPtoeu+hPzPPedn879+vE
	nWLWTgLkWuPtirnRXZgxX2KMLBy8cW83AshG6EcFqtki/VTAW25UOPuc=
X-Received: by 2002:a17:903:ad0:b0:2c9:d277:2cdb with SMTP id d9443c01a7336-2d0266ce46bmr27057215ad.9.1785340005234;
        Wed, 29 Jul 2026 08:46:45 -0700 (PDT)
X-Received: by 2002:a17:903:ad0:b0:2c9:d277:2cdb with SMTP id d9443c01a7336-2d0266ce46bmr27056985ad.9.1785340004812;
        Wed, 29 Jul 2026 08:46:44 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a76a5bsm13577185ad.35.2026.07.29.08.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:46:43 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260725-consolidate-firmware_mode-v1-0-aedff0ce0ba5@oss.qualcomm.com>
References: <20260725-consolidate-firmware_mode-v1-0-aedff0ce0ba5@oss.qualcomm.com>
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: Cleanup
 ath12k_firmware_mode enumeration
Message-Id: <178534000343.2826154.1163759345155368715.b4-ty@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 08:46:43 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyNiBTYWx0ZWRfXzidfvgI15dFF
 HcHBpa32Gmdmv+SSVxVHH85vyl1DooAy3ZUFPfKrhkw083dlHWrGedz540rcUZZpcnJReyeDAxz
 4i9FKbfy5cVVs1Xy5cHW8JJd7aFGe84RH/noS3bp/jytyRWpbSE01P8Fe9sGsjooDlMedjXvbLv
 pLeOrwBF3asYw4+WUTmGhtWg3sQhicoau47xO8fXadHvTUTSJUjCm79RdrLVwF5pz24EB++nxc5
 BgrVvchyxfVxy7qs1EI+rtPgwEXfqIHMhEc5qa2+TYzUpV/A8xIFcQUeteTw06FJ06mXY+R7eGB
 vDvG1qWOslEGDDfKwAFskRGbnUqgQUGE3WI8KP48Jl+tRY/U3ab6fdU7b46Ly954OLUR8Y3lvio
 876L5Ua5IetOnd2DU2KIVXvmrXZvA2Qnrs+d+VhvC5c5uxL1Y9Z5s8BDi8ad3a9WIbnfSYBWdAX
 vjOErvuNGCb+BT4V/bg==
X-Authority-Analysis: v=2.4 cv=F49nsKhN c=1 sm=1 tr=0 ts=6a6a2066 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=G7SgPBRoAAAA:8 a=EUspDBNiAAAA:8 a=bRq12EJsMpg52VJJ_SIA:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22 a=2rYB-OeQH5pmQqQB7sEg:22
X-Proofpoint-GUID: bwg92cFcf37PVipxJwSuGc61DkU77tOe
X-Proofpoint-ORIG-GUID: bwg92cFcf37PVipxJwSuGc61DkU77tOe
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyNiBTYWx0ZWRfX/Ksh5QpRg3p2
 zQ0yzD2Q+kCFTGT/YFTkxQfyaJCYvG4o9l3uOZICTCQyPW0n+SM+dt7fIP/CqBLECHnCAh1qplL
 TAveev9dmkZSNAG+Fi8fTtrnhxaWy3c=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290126


On Sat, 25 Jul 2026 11:11:44 -0700, Jeff Johnson wrote:
> This series inspired by [1] for ath11k, but takes a more comprehensive
> approach.
> 
> [1] https://lore.kernel.org/all/TYZPR01MB55561DF4543A0265B47A58CDC9C92@TYZPR01MB5556.apcprd01.prod.exchangelabs.com/
> 

Applied, thanks!

[1/2] wifi: ath12k: move firmware_mode enum to qmi.h
      commit: 0702eddffff1b637a9e90187785a0b44542bb365
[2/2] wifi: ath12k: rename firmware_mode enum members to use QMI namespace
      commit: 0090ec7ad252f1a597d782b7bce7eff7bdde00c0

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

