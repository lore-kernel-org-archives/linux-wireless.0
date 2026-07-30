Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A513B0598
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 15:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424267; cv=none; b=ae/e7h8h7ufdUu0tp+0ivEgJom03ejTiIM3c/8gIy1CeWzg0Mmn+eLI/8dBbcikBj6+qLVAgtj+0Yte+FKC4jSQ4xLpWrPAf7szK24HIim3FfHDu5HZVfysbxUkH/I2S3PACbZdn1F/HLcokfDNv4Hije2YLvgh4EIuv8U0fx0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424267; c=relaxed/simple;
	bh=2ceRibAi66hpsl0AcvbcupgPpv1snwiChraLfGs+GMM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hUqdmFev9XNh9YhN+2zJBdE4NDQR5aJmFCbYM/9hcSjFSi61NSSyKzIJbDUiuGKSkuM9ks+BZ9Ny8kHAdFzXOLeTP8e/x/+J6WTxSjxZTh5ic1DMab3ppInES9mEWHzRF7x/C6IwYZb4NHp5CZzVvoTevccaifQDl5ImS45+2zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=W0NiijFM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JSKB4GAC; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="W0NiijFM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JSKB4GAC"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UEiodX924903
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 15:11:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ffXtM5ifIR0laVJkvVaEVBvvWKyuEmOutsu9uhzt12Y=; b=W0NiijFMdjIV6EZE
	8efbajQ1bJlPONEgo7uFb2xQlY6BLXryzqzDjpwohl8Mqmp6i1zxyRyLs+eSRz68
	hnUgAXGfNKUu5AE8soZbPUsNtK/5Xa4owMt5Q1TJRkojSD9H3/S+/L/PQ+vzEtc+
	2k0bmBcP2T69nOQnHy+w+NXztPxBlT21Iph+mljYIluHztAz2D6hGU3W6zGuhO59
	9h5/Nq5E0a9z7+zWn3lWe2P0s/ogmBHyBdqywopHrzRkCY6lEScffHWRlmqCUc59
	nzw4Ba6tgdBcZqAkpw4DhvzIp68u8vV6yo7vl8+mCtbNqjsu8RaCZFXmnRDCvW0I
	0HtueQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr8n804uv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 15:11:02 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c9c26587e67so837651a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 08:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785424262; x=1786029062; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ffXtM5ifIR0laVJkvVaEVBvvWKyuEmOutsu9uhzt12Y=;
        b=JSKB4GAC6Z5AqjG8UCMJuxGsgX6qKxfC43+BgGO9F9oF3tpeuKY/wLOcdfmgwag5Ul
         vsUUsF2iJyT9+TBBvKfrV32X+HlgGeYJ4fDxBpSkCcy7D/E3tevVclqSfGC5jLFwSe4y
         GfT4tlAbmR7ROoVYKIMh08jg17oaD3Rt+0WVIgr5FBbvAj1eLjvsdN29c8mH4TLLGpUv
         Q7CZZMuf8qRl9oLSWVnWJtr3+24m18bXH9uL9qUknVRRnqAmWErs1Gh0C8KwHDBxAFuo
         5cMWdb5TgM3QjCcdGFORf4gjnbuhxuMC/8PTLLK2Gnhb8pU+Vcppj4IfG0otYbOtHyho
         nHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785424262; x=1786029062;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ffXtM5ifIR0laVJkvVaEVBvvWKyuEmOutsu9uhzt12Y=;
        b=hrI2MY1RmaERK922yI3A9wYOVnYt4hBlOqYmg5njzdD3sDaJgiDUOVGDVU/P7+EC4D
         LIjUmGb1ZXg5QNPScsR6nuRcfE4AmJo8UohRr6ZoSPkWRKDsF5wxCxAqNnxjBqt4bgUx
         UPLvAwJ8AyViUV1Exa+BIccM9iZ8dQud91p8Gc/EGgCCKAgHudFx4YEt4tbQKF8aHI2z
         /OBnD0x/ZmjUPEXxvWV5lk6u6tiVVput1Fm3pQjV2u99JKi1V5cJQBVfAgm+NrkNDwZl
         2Z44D++GwhCEVLOAmcdLdvAiXyZrmG2DW+vVY43mQF3vSWJS9SG7HlaYVpP2KJFIFE3n
         A2Hw==
X-Gm-Message-State: AOJu0YzlzAoKpzywH3e372ONALZWOEFt6d4NB0lL7sHSxsiFf+C6aG+e
	mSbAm5IUr4ugt2bmhGJFeSxQ3y4M5mWWI9d3fFHR7RJlGhEw7BEEx5NDMF7GnrYSNY72UtovstE
	EfI8AKF4YYr5hbjO5XxDUL0zvWlEfPWrmrw2DQYJaQ9kyKlBTALNG1s8DQZD9TPoMyxQXWg==
X-Gm-Gg: AR+sD13iBFkz8fo1j+5V4UvaWq2MJgXCDAbwWjVP4PTNWnblaY+qSeeZVD/dHHWMCky
	Bgs7QD4QuGXYMWVNYXkwRY6d08LN18E6Tjnowepk7XiEwrsMrGGu159cWTqvKNpwY4KJP2JRqFd
	yt0oe8inbZ0apmmh6zI/45QLZz7qK0ZLCZsGeoT4jeAGqXbDwu3IwDkwB76k0QMA606r2GzIU3r
	L7++niwQx37slVZkGsdRd0/q/bodENKa97ZVttMq9K++ckeY2DHlvL0pwo91fQCpoUEnHX89RC/
	6ic+lUHiyg5d/LmU6U90CDF6L18UEb3mvsQ9ySarUzdPBxANMoK88IJJTGGogmsZwqQwwO4duMo
	ui8AnvGsr8Oy0c9gm4h0VaXgmDMAtM2sFrFH90bxt7xxKwgU9c0yF1EU=
X-Received: by 2002:a05:6a20:7f92:b0:39b:bc11:9ec5 with SMTP id adf61e73a8af0-3c90d7e58d3mr784464637.13.1785424261956;
        Thu, 30 Jul 2026 08:11:01 -0700 (PDT)
X-Received: by 2002:a05:6a20:7f92:b0:39b:bc11:9ec5 with SMTP id adf61e73a8af0-3c90d7e58d3mr784444637.13.1785424261574;
        Thu, 30 Jul 2026 08:11:01 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e72643a12sm34502171c88.5.2026.07.30.08.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 08:11:00 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260729160458.201962-1-ekffu200098@gmail.com>
References: <20260729160458.201962-1-ekffu200098@gmail.com>
Subject: Re: [PATCH ath-next v3] wifi: ath6kl: return 0 explicitly in
 ath6kl_init_upload()
Message-Id: <178542425995.3503956.8194688554917829056.b4-ty@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 08:10:59 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDExNSBTYWx0ZWRfXyMLy7I9Sdxmv
 Hx7PT+j8H5UiU58yIZvkTX2SS+1i9jA6cY3qY2wI1envr8AhoNBawL0rgZH871c0WSLUaozCjJj
 wKVi7Kn4DAs0IvOi+R3dQ/CgRGEexJK2WruvXF/tsj/hUIfKWWQBEQx9gRRWIGoc0ZJBeNhONrY
 EH5iia4lxOBzuVZH6Ryuw5Ij8kcmtmlz+SQeBIz/9NuYcf4MrzmQFO/hMrlfai1aLR6+0kdcjVB
 kTHZHO3glII/Ujh9UzsDLtT1RpiWNDrzx0j/xikavy5jq01jbQ1OPKdXpjAtVggHrsuekSvITJM
 lLDAN/lpkRavybiH7+cPbUi6KUK+GWg98wExsfPop+Ro/DRNGnjbkUXaNUam9FkFllVVhAP6qpJ
 KGMQspUHumCaE8S0Vrf6jWCExhizC36p7wPn+lL0KsOXCgQjj1mWkLjhBB7i29cTHgOcV/nMFSx
 BXZwA4yvSbOZ9FpqE/w==
X-Authority-Analysis: v=2.4 cv=DNq/JSNb c=1 sm=1 tr=0 ts=6a6b6986 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=7vjUJS6vIspU3N46yZUA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: RsJMEUi4rFjPB67-sP8US_Tm0eVTm3nx
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDExNSBTYWx0ZWRfX5bhvDpkfWGL4
 neVjgkKDyw1p/FlQEIdeUL5pR1GHIPckoRNb4dfPFrdggfkIl0hNUJe2hPip0VvAy08iQ/cwAlB
 edjsUGMkbilrz3lfvufmV2YyqwkTp4w=
X-Proofpoint-GUID: RsJMEUi4rFjPB67-sP8US_Tm0eVTm3nx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300115


On Thu, 30 Jul 2026 01:04:56 +0900, Sang-Heon Jeon wrote:
> status is always zero at the last return in ath6kl_init_upload().
> Explicitly return 0 on the success path instead of returning status.
> 
> No functional change.
> 
> 

Applied, thanks!

[1/1] wifi: ath6kl: return 0 explicitly in ath6kl_init_upload()
      commit: 8b8202b2e31367434a5079a6faee31588e5b4aa4

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

