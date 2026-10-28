Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793200751;
	b=uVrRk7uZPXrgAcksf3KXIN842YQOuS0QmJRCt8GWkuv4795Vn2qO2pANhn/FfNP67UXw
	 JBbHq3ImpVVgs0HP5xDA7PPLFGLnXHQdW6PlNOpfwg7kN40mmdzOnuQ1+BUJho54JUj0a
	 Fb50Ldyyo7sUgS61ZcUVecG2YzCZ8Bp/wFB4iNwm2RYOTHRR5dil2fWQ5DE2yXQUVypB5
	 8DP6oOQU1gB9dooTx94g1fPOleGj5qv9DnVMJ8CEbErWmAGnMKN3JiN5VEwLOkSSXyTZ5
	 TLeheoEYc1+rMEQvGzVZTaxl1JdpBhYFxxO6Jn6lAvkMZvAZAFmfDNeAITKtlLqTDoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793200751;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=jzOyS3p29gFBVVw3tYEEiHDMN8EVI+FbA51qYMqNe6c=;
	b=hRlynx2bMneQBRfKWz2+LJYbm0JHxl1tuQqMazDuoxvHqAplWXp+Or+3H5UKA58E3bVl
	 scsv3ZAIZNQfgIEJ5g6fPcdHLMUExgdJHG14XtUdGwulKDUli8UjDyrZrEqRMXGp6YpFX
	 3drDkAYYhooNYxl4iAQBoXxeckqj+TpllzMKuKvKXWergwQ7nC4gBs0sbOE0aV3Q5S71w
	 btCngTILgWS2plDn+Un6boNq/vvGfCKIqZrUyvHDyLOzjPSDFNk4xSOX6iYybD5MQztT1
	 nEN5gvnDRIdxLCWt0AeJbs/EUrEbMzv6Y+mHhFeRoihcBKNH5/zPdUJMdFoh26fNukg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Gwfbpkwj;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DQayEQnz;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E69606A324
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 15:19:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1E69606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Gwfbpkwj;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DQayEQnz
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SF9tb4966144
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 15:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=jzOyS3p29gFBVVw3tYEEiH
	DMN8EVI+FbA51qYMqNe6c=; b=GwfbpkwjMGjIdDoBcqf6bXS4EUvXJPTURY1x0c
	Hr30wpTsqNxfRhY4rhmcw5NHbbK6PZlbbYidZpFIWumQGaSdHAloJfF7ytzK/8/b
	xonkzimdCCY3c8vLVVR6b1vr9ua+JC9Ltlreko1p9TFTlDLunR+/UIbOMPQcFeRn
	lIfy8JxHNaC/pXmHih2nrc4TMeOHzQhTh7il89EMczWr9RcCzAyyL90M34tcawYr
	EV82ltj/Jv/EtAe0Yz1rV7wwqBRYpzW1KlZ5EtPltACb4slH23jbeec02u8ZYLb/
	Wb0eEnH5+8wXs4Z6FJGxT/4wai5tdmDEeVP3bKjnemZiRzIg==
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkhtjghhq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 15:19:10 +0000 (GMT)
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-6798fd97f3aso1914822d50.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 08:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793200749; x=1793805549; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jzOyS3p29gFBVVw3tYEEiHDMN8EVI+FbA51qYMqNe6c=;
        b=DQayEQnzotsYWbyIC4TyESYZkz3373Y4kPbB3gH6VJgmStXqkyUwA3bz5Y/QX0yVpT
         uXR11mU8Za5JVl7CEmaOHbjhdA/waZonGBowiw0RJijOVugDgE2D/Lvz7PKikcsb1F3J
         cHvmb6zazyuveVDN6Hw9OfIP3rdn0/QX/0vqqjYrmLaFg51MAfTOaxwRU7bb4w1QiUPC
         ImH7f9b2kxWmyI435yCbG5hEERHWLnYV5xdLjKyFP21zUNgs+4EyMlfdTcVdhc5fafQ4
         oxGbvortXZ+o9eYzP3tR/AlNzQ+aaAh1tgkQ0x/UgH99wQBJ3cEI1zSuHj+/icrScuvf
         c3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793200749; x=1793805549;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=jzOyS3p29gFBVVw3tYEEiHDMN8EVI+FbA51qYMqNe6c=;
        b=f6V58CK0D6JWV61sJLtylX/qnJ3576MbP0OcAzgfrXtFhwnmXDqSOm3rkVixnRpncw
         W14xZCV86Dj1ocKytbZUT1HY4Aj+yM2PiICNV4IS5L0X3Jw3fq7kzCTBP5338y4OTuYi
         cb0LDdLflvVJRfuQKX6B9lzSQHkEz0eyIrTU7jgKPfgkSTewuME1z5K3IkjM7EpXe5SE
         41IjjkcVzv9Z+fQfh16bREM7ExmzfzQvD2wR2xq0RaSL/qrlSlrkL3b1kUyOQi2JDdpu
         33k1mym+7WDMgf62Jl2dPUWaOk/bCbCYnKvX0YN5YI+lrXtQSPkNsaUmXb+P57+aOkTI
         pHfA==
X-Forwarded-Encrypted: i=1; AKwUvByPIJ9x7Ylf+sBf3WNstupz2X+KHzsUvbdtolbYYvdidWcQSe4UFRTUGgHzrwZzqcRaHnajFXGa+9Rvb6apng==@vger.kernel.org
X-Gm-Message-State: AFq9FYLUDoNAX6dLOFsriIhatuSLQztxcaZ1ARUpHmFHGMivtYfewrnF
	nVy3NZYb7S/ujWiCfFudemw5SC8hL8ZwcydIPfpeW0yKsxCZvqN7UC2pglHu6Z1Bm31MiPJhq19
	wNDnT+wjqJ8icc9IDjoowMa39k85beiCraGCeAEUpWI0HRPrNjsDMg2+OK/zebA5z0P6tLA==
X-Gm-Gg: AYBFou3MZVh/FHiOIkkV6gIBAJTfLPOGTSOdh4XCDk+LJocCV+1jppCKSHAuZY1uElt
	doesLCeFSwoWa2s9Sy/1BYnbrncRBxme0/7tPboZJZUqVhbGBliusJptQoCoQjH54EHQszSNz9S
	OfblF63gvahx8EEpKjjDq/H5RDvY1OE8/Qu/FJ7y5kwso7wt5hBbAeJAfUQYxp7L3CVpYif/X5N
	x+ABd1l6H+PrBTpNAR8SvzqNc4mgncqXNBHMDmzbRPvzUHtuHKP9T9O3Ht+yRf9F/XrFk0bMFzM
	VmXK9SZJViVRd8SuK7hG05sQZ1kNbxSuZxgT0Fy9Ijs8oASuy2IEK65ZhOJqP/VnzLa/ku65hWL
	+xM+vxWryxOlmuHy7jbc54VFitk3YhmOyvU+zC1UvqojUC+DnQxh3lVyPlAqZUHDad67SYNNjEt
	3VhzAAwvVeDDg3o1YIurNOgykIgcI=
X-Received: by 2002:a53:d58e:0:b0:679:ab13:5517 with SMTP id 956f58d0204a3-67a7bcec2a6mr1229181d50.104.1793200749031;
        Wed, 28 Oct 2026 08:19:09 -0700 (PDT)
X-Received: by 2002:a53:d58e:0:b0:679:ab13:5517 with SMTP id 956f58d0204a3-67a7bcec2a6mr1229158d50.104.1793200747701;
        Wed, 28 Oct 2026 08:19:07 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a79d7cd76sm1966851d50.0.2026.10.28.08.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:19:07 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 08:19:04 -0700
Subject: [PATCH ath-next] wifi: ath10k: Add Loic Poulain as maintainer
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-ath10k-maint-v1-1-1e6ee9fb2616@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAGcS4moC/22NQQ6CMBREr2L+2pKWIjWuvIdhUduPfJVW20Iwh
 LtbcOtmksm8mZkhYiCMcNrNEHCkSN5lI/Y7MJ12N2Rks4eSl7XgpWI6dYI/WK/JJYYHWUlVHdE
 oC7nyCtjStM1dIJPM4ZSg+SVxuN7RpHVtZTuKyYfP9jyKrfH/ZBRMMFVjqyyvpBT27GMs3oN+G
 t/3RRZolmX5AvRS12bLAAAA
X-Change-ID: 20261027-ath10k-maint-e5343748ec7d
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA2MCBTYWx0ZWRfX69QdseCwodFE
 A78P04JTbu9LK+NrvY+702bSjoXcfsvkjAsT9ElOaB0ZNL6fr/CYQUdKEUOtMo3szvL2aeZvsBC
 779bbIpGU75/uP94VyvtqDEFuO9I1QqcK8HvgXYb04er5jsDPAIreP6PKorWOysm6e3u/t/jFhI
 gA5Bp8p0qDa7Y7BVtX8ZQrCrpfwZ6w1P9fM2MJOYVQHqyfUj20J5HtPvm/V8uQok9YoXYKL+UMf
 n2LVVLQ+7TGcB+X0/6WzIwoYhGgr24sj9aZoNyeHnF53ARVa1GWhi84pYHy7I4HYaADsaW3zk1z
 M6Bj+WsiKDJhWzdSaR7G6zDS9vX1LA9qaGce8Y0ERbEnkbB4Herja1s+BQQeVWVdb+bsHzrMHps
 JiZ5mBZqsz3ICkZMHElOLJDwmyIhxkQl663bwCCBQJE+n5d7ye8lcs3tGPlP5fNKBpBkpo+/m+o
 pf4hplAt+MCmQEE5DsQ==
X-Proofpoint-GUID: duj0epdT1L8JEKdL9TvoT8ILEVtsaZCu
X-Proofpoint-ORIG-GUID: duj0epdT1L8JEKdL9TvoT8ILEVtsaZCu
X-Authority-Analysis: v=2.4 cv=LdipeTfi c=1 sm=1 tr=0 ts=6ae2126e cx=c_pps
 a=VEzVgl358Dq0xwHDEbsOzA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=ni65MP5vFf2Be6WRXWMA:9
 a=QEXdDO2ut3YA:10 a=uujmmnXaIg8lM0-o0HFK:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA2MCBTYWx0ZWRfX0WKtZb1mr87K
 3KMl0TLPP/YYpTZVogueRPBLMBICcHoEXiUclbtVfbgBxgTiu2kacyXal+io7RFc9YcDHaJtHl1
 TMmsYXKe62x9ffSizEqDFMVkp4kLrb8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280060

Loic is maintainer of the wcn36xx driver, and is now actively
working on ath10k, so he makes the perfect co-maintainer.

Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bc64d98a080b..7adcdcc77d5e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22417,6 +22417,7 @@ N:	ath12k
 
 QUALCOMM ATHEROS ATH10K WIRELESS DRIVER
 M:	Jeff Johnson <jjohnson@kernel.org>
+M:	Loic Poulain <loic.poulain@oss.qualcomm.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath10k@lists.infradead.org
 S:	Supported

---
base-commit: 6a9b6e4b4fce0ba899eb6f830736af565a2f4fa4
change-id: 20261027-ath10k-maint-e5343748ec7d

