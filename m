Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B62347FCD
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785373517; cv=none; b=k7nQDeCBXm3CXvgRh4lVp3CJ0YlkoV3bx7mtSploB+iFJDTji3jk6tzBIUbIeRNMyafYGWrdsuDxHRhY/cYXOAkhMrG4ZaJxgqJDakFKEbptkSTeyb/bfRJqIldhVMAWHZRkzwgCGeqAGcL3Q92hGbhLTDxtBnYi6CYcQsAwlZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785373517; c=relaxed/simple;
	bh=fC1t8irMzrqTCGOKBjonB7JdN/QOcvzgo3NQt+zkMGc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KoJLdGT8tmCaXzgTuntQep6q8TivqpsdTD22PYcb4I7c8H/pUS7J+ikdOEkG09AJhh9NiK9P/iO+f4vrmrlKmnLsZ0wepI6JuiFYIavSDIo9/Ixvi3Vh7fF5Fmlqs9lWEmU7ke+dJn5gz6+pvHU9vbFJpqlBiePiXv25niifvUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=d1FIvwSl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EPeB8W9I; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="d1FIvwSl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EPeB8W9I"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U0pE9r2984516
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=9l214qgUdXGA8WVoj0GqLP3Zunwqu6mDgUR
	nXJ+2pGg=; b=d1FIvwSljNDkAA0Zi0H1WrJhwO8nsALs8ZRiv6YLp2/WC0XZrok
	YMJiscQU8K9k3yltq8dBGdZt+dUsnmp/wsSWt2NT9YenUxpBmIrzXtPhr4QMOwD/
	SbOI5FKE2KPjt33qDN1KU+pKmxH6BrUSybSK4JlLkrKDfl2gL7Pci5gsIJXJTJ9e
	TH1Dd4IzVNH2fvVygBZWBSh+hokN6HxWnHtGYhiT53b0d/ji2cijqYrDfr+rKCps
	Zdxw97tjPdO0JFO2Cuh5yjmGvWvYZQ0G9q7fecRGvKeXj9YFQx9vRorfymTG9Kgw
	7tI3R8/ptKj96ATVeecwE4HolYI7XpGLZ8w==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqveer17b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:05:12 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb835525b13so2030994a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785373512; x=1785978312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9l214qgUdXGA8WVoj0GqLP3Zunwqu6mDgURnXJ+2pGg=;
        b=EPeB8W9Ibpbo21KgLbQ971CDxQ2sglFwvsPmEVSrwP3bshxu6Us0Bgvj/41uZJ5LfI
         OmZ1Kob8uVNduCLj++u7RhEdpVYJwNh0m+jYEqFAI9E6WzFKYQUOC0DybO1zDLbyygIn
         Erl0XRl8jEn1UEwyidFmuNoQpzLfPMNCDSKWjeEHp80nNUGm7CBeyh/mhCdklrF+ORIO
         916FG7z5LV2ht2vrmM3jyekK6vi3CTbVDjZiBj8xb1D3WtTXsg3e6OjYksmQ8+VZAMs3
         wk26Q1iYy8MiL71c+jOR/gGW1NPquj+SGF9B9G9YpHvSv9ns91bR8XkGt07ERhOfzR9j
         3c0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785373512; x=1785978312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9l214qgUdXGA8WVoj0GqLP3Zunwqu6mDgURnXJ+2pGg=;
        b=pGsr3Yt4BFwIepfxYEYZwxRinIi/XBwKCSYiNi5csENz4m/DcwSKC2KKPuHPmBfa+i
         YvLaorKB3muEJD/22/BAUIHXYByqqY2IvwNz/0p4hIoXTIQeKimfJpKkShPjVB+TESCN
         lxHrq7xbaElbEicQlz3gPB/w6hEZf+AWUsyOzIFB1RyqcOKByBON1WXHFKhgUVq9VU4f
         e8Si7C3dQcVxOgoB/c2F7wy9QDqiB2aoqCUXsRjc+bchPFUt4DpIQJqwAC3W56LvcaHp
         +Gr2xKQFY75JcIlogNpl4t3AcSbTnqZDuU5UShbCk9vxuVI72MP01vHw3X3U1BELpLsl
         8gyQ==
X-Forwarded-Encrypted: i=1; AHgh+RrcjlDx1Q+6xfeALgAIeif5qLC6l4Umc043VzA5fU/Qr81Yj8CNyCK+mziBSxSMpLTLCFA6Gei3swIAWCvr+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwT+eUHts2t5oLUD+zeW6ET9wj3d7dgIHH6ZLL58PnZY0OJLPMH
	WtRiGPENInPG/1x872Z/REJLgOoFG2x3ShpcNlPZPkBljnwlKZeFs5bivREtObhskNFWocP32y8
	egs4Ncv07TuZi9Ste0WmVEODeIt/feyo3RlgVtnm/Y8Ewg5yeRsPAZP7TISBI70xq5bDpEA==
X-Gm-Gg: AR+sD127sq7CM3+HkgR4ljdtcd1AlKnrWDSSRQDPKXruH3WZO2wRCKZC+qF4aPIXQz7
	pYo7C6oIIpeYmvXW2wyBchtv3R9NpIp7/5bkC7Us0w1db2TTAAag0iDUkJiTZKDo/6TwXNBFGzi
	bYcft1EuY+1JHSSvKklxPuRM3gvfE267VGdmlAZgks4JZ4SRB2MCUoVtx9hsnlF5Ni1e4zgLWni
	GZCPqiDwkowVzF54XK57TLdbJSdducgdxCiU3lWvOOV+Z9zfoVSsfowhuisf5Yq9HjrHlQte4hy
	MCozcjV3FN4l4njtgTzOWhlR1AS6L5xKA8Zx4VIuGP6hpK27f6Ugf30cRwpJAV6TYLNufseyKQY
	sODR/0iW5UiaeTzJZO4bnYfME7im/4dcALe7uFNJujm8WFfmjXB9nPRqi1I8=
X-Received: by 2002:a05:6a00:600d:b0:84e:915:d7e0 with SMTP id d2e1a72fcca58-84ebc3e1323mr546602b3a.44.1785373511906;
        Wed, 29 Jul 2026 18:05:11 -0700 (PDT)
X-Received: by 2002:a05:6a00:600d:b0:84e:915:d7e0 with SMTP id d2e1a72fcca58-84ebc3e1323mr546568b3a.44.1785373511513;
        Wed, 29 Jul 2026 18:05:11 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23120sm2168563b3a.11.2026.07.29.18.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 18:05:11 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [PATCH ath-current 0/3] wifi: ath11k: fix QRTR readiness related WLAN initialization failures
Date: Thu, 30 Jul 2026 09:05:02 +0800
Message-Id: <20260730010505.143458-1-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: khql-R-6sqngg8yocO47Paas8Lrv7uqh
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAwNCBTYWx0ZWRfX4osAfj3fCQnL
 rs/cGAvwiczInlVeQ5r5DGbp1IujwyaOPwgR/nED7iDyFO1L93fL+53dsyPlQ0imNYLKRyEJin2
 +jh8Mrb4hK8aYv61nwENpmrBvJBSP6g=
X-Authority-Analysis: v=2.4 cv=Xp/K/1F9 c=1 sm=1 tr=0 ts=6a6aa34a cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=Hy-6OMvPWsRTGNkc5tYA:9
 a=zZCYzV9kfG8A:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: khql-R-6sqngg8yocO47Paas8Lrv7uqh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAwNCBTYWx0ZWRfXyknFUrmDYbgV
 z+5qad2mNEnqUW2yPtn56lmIGm5mfXWcDQqGdVLT+7IlSmEluYMtxcRHRre8FMrCDiZwkpgA5cH
 cyBaqRqv8YZOhQRxZ3jasxPE0pGdTddc7lcYXljrEWSuR1d03PrRcT5sGREWJMGCT2DnZheQoFr
 +KqGY8cJzUhzod5Q6FRJz5Hbw4TqEGDEOQswzy7X3Q0bii9EK5mQq+tedRjVWDy01SLENguHcgu
 tmm8/AqvqwVjl2+37YUoRXT1lu+rXpjddSohn/z6opdSvxcIDD2VQoCDE6yLb/POgWsY8Dtcb/n
 Q2MYbwqnMsiSgVs8k4ls6MNQEAEX6OtYdAD1dzOp5QsZvX6F06NUKjr/0n6gehGkWBewsewhAFN
 dQP6cBuO/Ey/n7C1zxDD8Pa78CyC4MaPeL96KrTmzNaap42NEVsHRAebZNKMmfirfcaOfDK48yY
 LMwsM97WR6eBy5gVPNw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300004

On WCN6750 platforms, QRTR SMD may not be available when ath11k starts
during boot. If QMI messages never arrive, WLAN initialization can stall,
leaving firmware running but no wireless interface created.

It also hardens the cleanup path to avoid crashes when deinitializing
partially initialized devices after QMI setup failures.

---
Miaoqing Pan (3):
  wifi: ath11k: fix sporadic WLAN initialization failures
  wifi: ath11k: fix NULL dereference in ahb remove when QMI init
    incomplete
  wifi: ath11k: unregister PM notifier on QMI init failure path

 drivers/net/wireless/ath/ath11k/Kconfig | 3 +++
 drivers/net/wireless/ath/ath11k/ahb.c   | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)


base-commit: 6776197cc88d0d397084bc47bca7e983017cecc2
-- 
2.34.1

