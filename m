Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B353EC81B
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785340010; cv=none; b=Y+oxkUxSvISO/95Ii2khvqUgAumlwwz0TeDDYFTJ1gqqwA2FLJFnygY3iys6AarY8VOvNxS0pUUdMcmCMhvUFESV0ieZJVYLFAj6R+OOdvAlqzghDanWgfci7lNBsjN2FedCv+ihW1nAy+AP86VSVBgdL/Zt9B38VqomZkJqRLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785340010; c=relaxed/simple;
	bh=4ZuJjGDHJNMZqieZ/oOPH5BWxuLan/nGryqztDKErD0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HBIM/urcDe0uzlYfZR9xccGiKKpJBZyeLNhc+aAO6i4IUAK0ke5LzRQpOdME2JtQYL+L+KM3TAraY8JYR72xNu5Tn+Q9Cp1xM6dxg8YdaM6LwEoAivaISNwW/aTJCc/ZRFIntxLCM3EtilIgHSWVP/Q8eQ7JGIhFKoC/sSKrJg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gK99+UQD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZyGtpmga; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gK99+UQD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZyGtpmga"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TF2wY41700082
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IkiG74NfSKDDISSpDipBXrovEe/p+kaap4nyJ1TG+cA=; b=gK99+UQDWTjZgXYZ
	up+sA7gb+Amk0AL3BctnPCn52mjpRPnV6G9wurg/r0OMjO14eztpbp7ZbQ27xP9j
	vM8T7ead5sBqaInGl/+wWh74m5Xr/pSJS8gUtchOPP/ZC7d/6dCWPJAmiVmIXDw3
	S06QkybCSetUbGFDMS0xE48PE5vwoXuS7gnyFWv6Rm8JJ2G+sWzCe/pnthWIpkZT
	1eO9eySUPFqO0+yhNzfN9bn0qmGiCPb9i9p+DvQ9YoHZ2+MB+RmKpyvYDRDbG+9t
	fXmabDsO8gar+8g5GcJESg5NCuwrcKI59oKFeV+maL3iI0PY4I8RpohChnaEqtHe
	3ttVtQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqgrj17r1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:48 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cca3673560so19591565ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785340008; x=1785944808; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IkiG74NfSKDDISSpDipBXrovEe/p+kaap4nyJ1TG+cA=;
        b=ZyGtpmgau6SGkhQONe+hZQfDlVLodKELtopMeBdoxZ6gksnHksDw3hHZ5Cv5FMcN0D
         Elb9Z0XZuZ8qKSr1SCrzR5cfgfotNRTmRTc2SAILrPC7VpFsREqpaMbDeXDFfeeFRtxq
         dCXbTlYkp8E9Qjg+RnMEUG/fB1mvKTUgHsfcIopcqUPIhXjBvUH056QfbRCJeZvG4AeW
         HvPnS5YfK1ZVr+8q5hCjGISAzHbvnUNFF+FKodWXew4YKhsbBuAd3wK+2GV5CntI3jVZ
         k0wjnJ87pQ7R1p+oJbaWFFesKYXmRTzoSAR5ZYUGVDF4mEnLpPtgYaDQRm2nYrBN6Rdf
         Hb/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785340008; x=1785944808;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IkiG74NfSKDDISSpDipBXrovEe/p+kaap4nyJ1TG+cA=;
        b=lBmeZQLASQEZ6TXcSO3fN2Vr94EKu3DYwebAB79r2iC5ZJqwxBQ3+Lo1457Uq6Gz0y
         EcF2IZQp1SScddUXrsBBlt7IbMAUPZL3g2vDPUAE6U5mQ50vUYYkDNDCzKURdJkuB7VU
         oTQslcZczzg5a/BiKMAeTj9wGl14CFIhbPcB35PrvhLXisdMOT2eBTFlWTq4LOpGTwma
         3+UbeYbOvq6Tu9hgBXdBjbPL0w45n27b4+HowzJqtuCdmTlkeNhAhGRGeGY4jo4+iGs1
         rXUQTJZp05eONuTnQ0NhCAWBuYZS2lI4uYT+Aghx3UD/tyG7a+6LsB+v72np2Qd055Z+
         ri1w==
X-Gm-Message-State: AOJu0Yydm2T6n+hNKZipmI2AOjEqdcOtlxv04auW3COXjmUaOtH59PrZ
	2hieEY5PUe089FLFp4zMgSv/Sx94yVENGzuJlqbEKJhct7OZdLJrLYiRiKA7bYPYjXbDhG2ow6+
	g4SaZ0gC2YowGt58RBEMLYmRWYeu93JsyDmSyGtO+Wgw4v4Se8jdpAmAa08UeoZQAYiIoCw==
X-Gm-Gg: AR+sD10nSa1mgYZrL7QaPgKgYEmS1UQKkKXQY2q8ZUYXczN0AZrACZ4cbWAzwGl51c9
	pfipksvM1B99r7FeSb2j6NLs1oy5tolrNjQygBj+rqE3Khl7a1DujXvksLjebBAgAKkZhISJGTN
	8pqCl2jWhrLLQVaRT74Vx/duQBXhf4ojOFvNwIho9tBo0814/qogqqvKJ3Dp6VdSZowxLwW8zMp
	6Y7bEIhlaPRdP6q7+bzIMvhXWDecCQYoe8ZahbnUaE6UpO5ygd7YP3rcmNfGhNSZgF7VBsYHbAT
	nkGk8tm5tAN7Cx8QsobYL0IRptEVNadc0DSdNs0iHtmRMns863W6AeexwVx+P/Zcj3m7nIv0agQ
	lttZbpNEuoOpYAPQF2OoLiO0iU8nUEjG+Z2J9Zj/FZGj5+DDBKT0mD88=
X-Received: by 2002:a17:903:124a:b0:2c9:bf82:dd11 with SMTP id d9443c01a7336-2d015ace749mr80489865ad.7.1785340007914;
        Wed, 29 Jul 2026 08:46:47 -0700 (PDT)
X-Received: by 2002:a17:903:124a:b0:2c9:bf82:dd11 with SMTP id d9443c01a7336-2d015ace749mr80489575ad.7.1785340007498;
        Wed, 29 Jul 2026 08:46:47 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a76a5bsm13577185ad.35.2026.07.29.08.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:46:45 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org,
        Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260721110459.2203038-1-pavankumar.nandeshwar@oss.qualcomm.com>
References: <20260721110459.2203038-1-pavankumar.nandeshwar@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: Use different RX release ring
 sizes as per memory profiles
Message-Id: <178534000498.2826154.2195115585246629060.b4-ty@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 08:46:44 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=RJOD2Yi+ c=1 sm=1 tr=0 ts=6a6a2068 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=2nvQBFXYXNaE2xgrtYAA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: VZ4GjbpRTmQWpWoel-1IXOReEbtALd7V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyNiBTYWx0ZWRfX4gG8ijmmtQRv
 wKYRQ1UsNHMPSqBUTk+PJKYBlpCdb1pW4mXhRvWhnsY6gZOAsVyoR5f7PImwJXiRQ8O3NjWryWP
 PZNxxjaiuzOlY/AYueKeVvjLUlO/g7iM+UWmVHk4K8f/k/WM4Z2u1Ds9lyHExPSg4xw47DTouVp
 vYESlUDFEDEM90+MlXDiWmfF9Hh7eenHUTM3Te4a/zvU8UX9HJ7zasIrUeFNDlP0UpyFN1p7Car
 apB2H4vD/CftB8zgqMaR4YWgPFKRySrSZE3Bmk31R/KYh9n7fdWn8yJqwYzIxI+iTzPrtc1J4xp
 fsW7saCtaCA2UR70Z+MRyZZ+Ta+zCwRRC/o9DU3pKLFt3lmYLAy8siD/6X5XE4Rv2/zzF6MTafc
 uymUZiDhlwun1RPSHeFNXVadTJkMIKYmZLuRAe4YjfVQsX26YhtNKAsIgXY8sqNxjwr8YHti3DG
 AdibR/OVrTaM/6TOpKQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyNiBTYWx0ZWRfXwVe6N2OxWAx+
 j4k+l6ZyGuu1bUWtkM5DutKJERLG7KhhxQ23YKpMYjbaiaM/dz/azpeA62iJL+VfQmHz97Qc/Cm
 fBw+usJ+8+51/QaSn95ci0xdnv70kcM=
X-Proofpoint-GUID: VZ4GjbpRTmQWpWoel-1IXOReEbtALd7V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 clxscore=1015 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290126


On Tue, 21 Jul 2026 16:34:59 +0530, Pavankumar Nandeshwar wrote:
> Currently, the RX release ring size is hardcoded to 1024 entries via
> DP_RX_RELEASE_RING_SIZE. This value was sufficient for older generations,
> but is not adequate for Wi-Fi 7 scenarios with higher aggregation,
> parallel processing, and increased likelihood of error bursts.
> 
> In Wi-Fi 7, a PPDU can carry up to 1024 MPDUs and each MPDU may contain
> multiple MSDUs. In error scenarios such as REO out-of-order (OOR) events,
> a large number of MSDUs can be pushed to the RX release ring in a short
> duration. With multiple PPDUs being processed in parallel (e.g. multi-core
> or MLO scenarios), this can lead to significant bursts of descriptors.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: Use different RX release ring sizes as per memory profiles
      commit: 534459ac562b207ba1a9bb2c95dba77b5939e2da

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

