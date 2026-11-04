Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793773826;
	b=OHSUjoZlc0qwrPGjnMwoMR42nSPH3hd14QOwUbbx4L4Xrvd5xu0bPKv36FjPkhXzeaad
	 G+TJWmqlJELX9BawvjolQz7v5MmvxqOhTL9WF0G3X45gRbzVIsGc3LRycM3Tyou2MiiO/
	 W7MMAW5kZNUvJOnXNv9gMAcsu6EQg9DLBoBuw/l0zKRPKEbMTLetEtJ8MO6R9FpFYr+A7
	 JWyjHhDrPDE0/o3wI/Ip4Y9PFW1jKr8hKv85/iu5Wz1qV2CysyzKVXU1f9EGkhqiRohze
	 vkkH9dzKBYFaUn7vQrG2XJyWMNiWZa4FadlMBt5zJBcLKEYxdEOaFFgSertrb9rDE2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793773826;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=O8cdky/dUq4o/+8BqqMciuYE3yifM3kH+XYEckRYZPA=;
	b=3sGK6R59xeU5Dru2v0dLWxD8Qc9quizKn9iEzOrF+P06yVLzy8+0Nh9MutUdvWuqvQGY
	 xjwEY9omh+Lof+l086WxCDCdUp0OxU/DIY17yuFnDWNgzrV1mYLReg1pdPi+FJyQIilms
	 nC2gDX/8gqXDjK2cbo7+lxjaGv5o8hWxgad7qXP6BoXzakuMZEt4L/N6XJ4SlDUEp57qr
	 s/znkaAroHMfzIdFt2IsgJgAeh/EHywCwURwhmI19l9Ey1Eg/IQGQkl6iSynD5u3VbOwr
	 p5oJjOOaJXfbVhUtNqhqPdx93b3nNgtYmA+r2LvSo2JMQE9XNZ5Ln416nPEecIi/K2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Fs1GCgGD;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IQ8bQCOa;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABC3606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 06:30:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3ABC3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Fs1GCgGD;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IQ8bQCOa
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RFcm1248584
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 06:30:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=O8cdky/dUq4o/+8BqqMciu
	YE3yifM3kH+XYEckRYZPA=; b=Fs1GCgGD/ycySmrQoZfYVeRePW0fDDhNA03IyB
	KamdjQ9o9qlyBQ5ad2VEOngi+296N5jBIsthiYH+Sw/mgvM4/O06B7OzDkkL+CHi
	aGRsgmrR2Q/YVABudGor5KY6wLe6p15Eogv9v7F/gI4DQnBIgu00cNoMJshxXwm0
	3RItuhLoNnrnKGU/juSL4903NpGt3PpBmU7VJCHQoZ6UUeiPwVGvLllIefqRztsW
	OZ6eJbzl0X6M1l5e+HwSveTrq2fb5kdEyo4AClRzmCA4/kreCioVls6HRLNkm0eF
	ObzUOacu/Qh8LcKFPNApDUDP7W1VeQDSz8bwaQQqjp40lkOQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqpuv9wvn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 06:30:24 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ad30487d55so877192a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 22:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793773824; x=1794378624; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=O8cdky/dUq4o/+8BqqMciuYE3yifM3kH+XYEckRYZPA=;
        b=IQ8bQCOad75JFw1EBrkB4SiTACw5Y23fI/mu0Jc3niOdXEDpDWcyb3cRHjW70woAai
         iZKzoLkUVplvrlKOsZYcAxqUlOgWx4WY5LuS/L/2uJwTBdLA1l1yLViTYfeMtaCoE1n3
         skFfOet3go+SnFS0dXpQEM84IQgcOPJI5eslYw3JlTyRA6/DOR5hp+qOUEB37xFc7lQK
         AMvdEabuvOt0Bh02xNdtxFdfxQVfZX2YFfDyoYu/ZwkV32/ugPm+zYCTpNeWTJ1lo08G
         0dfkzUdGmlqSAnaY3PkYKioSbNfxzKoAZ683lYVeFIB6aZBwjMiPkqzIpz5EXHICkoLV
         3gbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793773824; x=1794378624;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=O8cdky/dUq4o/+8BqqMciuYE3yifM3kH+XYEckRYZPA=;
        b=YXqexChXGcbuAgRludSd9FeKKSUie7KPXyU+xsMf/hIhEsVt+r2TT9GaiUzqIvAo6c
         sdBfdaB6FkEDM1fgZpVs1OAC87m0v3T8+C8iR3WrITTg/5UqjGeEuUBNYKUa5pfXn8YZ
         uwNV6tHxcvfFLWQ3Fctb7k5mRXXVico8q3QKdhLoOq8nf0zgEOVOBMyEPKGD9cYqChJG
         jLHvxQ6K4y7ESkXHaejOGmh1yEuBMzE4TyZpfWc46lE0XbuCiuyFZaqiYmNTUEnnh0MD
         YQeb/gxb1zBVGF1KpZVgXM/Z3kpuUlCtjcE0gkpOQPCzBxaQ/DuOIWHrb49v9/pWfiPp
         1M3w==
X-Gm-Message-State: APuU4Z/IZzvUaA7yoHOHnaxjtbaVq/ZSF/6i+6wmAE9VAztzut9ufr8b
	YywNiOIflfURKOVsAAWz61qCFqiC1bAB2eW0I92P4lQChkobiq6Lbm2An1g848iLm1rVwHnm35F
	d8GmKtiIfnkDq1MyUotMXvIm5gc3bxt00UqvGh8HBHvF3nYJLNcyIZDpTdlS83R0LcHZ56Ymq2e
	62Xg==
X-Gm-Gg: AYBFou0SrHjS4w0l7U0kO6sluZpJiHPMasVXEz8H3nfajzwnaLY/OZV7394TPtmQ6t+
	Xmf39swE4ocJchOTFmkhly/xkw8Mw5Xn7xm3Sx4C/InaJ2mnVNYBA/yaKk/ArJXuWzaxrbzYIt8
	reSvgwKu3Gp8L/riFLvKur3GtyQlzuPbQPXL+81tnhckIkQPi8rwZVRaSirOBDZr0dF5u7Lm+E/
	IhOG4BoZPprxouTCbnl+lIDpqAPwhLl5zg+ll/JWclvpNeBR/tXYRkjSiVB9DJotAqIYnPEe3m+
	HUg0b0mRH9QOEn7M8ZmQGZIvmSOBWKlbELx/HVLULabmD4SoqJyXy5ALUpGmGnNxyNfdaUoo/Q4
	McYgdRNaOH/pgNN9WIVsHCuDC29zEp4gMiIGFExBl/+1abiVjStlWcG2CbB3fdo8ggItOf0TkN2
	t7vnEdDGv5V/AUszunTzlW5hWUB9cEpZPQigdxe9p0kJL2F80GLRtPk/DJyio4DmcUL+4+aqgta
	Q==
X-Received: by 2002:a17:90a:da86:b0:3ae:533e:7e40 with SMTP id 98e67ed59e1d1-3ae897eb0c2mr12837028a91.23.1793773823706;
        Tue, 03 Nov 2026 22:30:23 -0800 (PST)
X-Received: by 2002:a17:90a:da86:b0:3ae:533e:7e40 with SMTP id 98e67ed59e1d1-3ae897eb0c2mr12837005a91.23.1793773823150;
        Tue, 03 Nov 2026 22:30:23 -0800 (PST)
Received: from hu-madhgane-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09445f7b3sm2420646a91.5.2026.11.03.22.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 22:30:22 -0800 (PST)
From: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
Subject: [PATCH ath-next v2 0/2] wifi: ath12k: refactor m3/aux_uc firmware
 memory handling
Date: Wed, 04 Nov 2026 12:00:06 +0530
Message-Id: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIAO7Q6moC/3WNTQ6CMBCFr2JmbQlDQYkr72EIKe1UaqTVthAM4
 e4WXLt5yZf3t0AgbyjA5bCAp8kE42yC4ngA2Qt7J2ZUYijy4oSYczbwVljVinFuR+kUsZrzc1f
 XiFUlIdVenrSZ98kbiNgzS3OE5ueEsXuQjNvilu1NiM5/9vcJ98b/owlZzghLjVwrLUq8uhCy9
 yie0g1DlgSadV2/CiWCctMAAAA=
X-Change-ID: 20261103-m3_and_aux_ucode-8337b881155c
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=O6SsLx9W c=1 sm=1 tr=0 ts=6aead100 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=xzHXWKMcZAd5FHHA1I4A:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: Z35j19ZlZ2nt93WEj3A1_Wl_V0V0Mmvn
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyNSBTYWx0ZWRfXxinVDYuylr6I
 9BqxoFkHl0jkkUKmaSVlWsnoGWfx9yC+hq+bVOGMcx7BK1txdWNZCwkSRIKlPrpVueCWb476yH2
 j+oRv01XBEirFkb7GjU2+An3vpM/QJg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyNSBTYWx0ZWRfX8OhTXyIyrP5w
 y5hT/g9s1VSDFJmqBKFR2efb0fCDA1epA+2/th5uNn5cAhZJg6JzKSEyCTVPgHa2LGRE/Z/29u4
 iSUG9pgIWNpp9SGo3Iba/jhqbURPfq5giz2ISBXT0HB3cWd0wa9kW1NQvYaG8tCHQfOlxM5KS5N
 WyfHePuyTEQqLjMb7+XxLNNyI+i15HV7kGgT6/mhqzhLS3KbTgWUdlVdSoLcYgKDZ8jMH1oE+54
 ZncKaD6Aj4FS2KcVUrwXN598fNXnVEXFNBWqeyfnXE8uW4VIe1B9AML7FOMLG1T63EiQPYd2h9m
 /5DgyGSDfdFuISkG0R1wyM+XyN/oUzYk0ej+eiZUqiqxJO7UaHEzUfjExCpFzW2aEM4p2fS7o9j
 Bgk/3mcDTqtWXOXnV+ZfhfXkaTuZr95xXCyvcvG5ilgqX9iaIj/fFTx3d6yjWX/KLXd7OeGPUi0
 cjOMur/3lrQWGfnAceg==
X-Proofpoint-GUID: Z35j19ZlZ2nt93WEj3A1_Wl_V0V0Mmvn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040025

ath12k_qmi_m3_free()/ath12k_qmi_m3_load() and
ath12k_qmi_aux_uc_free()/ath12k_qmi_aux_uc_load() carry near-identical
logic for freeing a DMA-coherent firmware memory region and loading
firmware into it. Factor the shared logic into common helpers.

Patch 1 is a preparatory, no-functional-change rename of
struct m3_mem_region to struct ath12k_fw_mem_region, since the type
is also used for the aux_uc region and the old name no longer
reflects its purpose.

Patch 2 refactors the shared free/load logic into
ath12k_qmi_free_mem_region() and ath12k_qmi_fw_mem_load(), and
rewires the m3 and aux_uc wrappers to use them.

---
Changes in v2:
- Addressed the review comments.
 
---
Madhavan Ganesan (2):
      wifi: ath12k: rename m3_mem_region to ath12k_fw_mem_region
      wifi: ath12k: refactor m3 and aux_uc firmware memory handling
 
 drivers/net/wireless/ath/ath12k/qmi.c | 168 ++++++++++++----------------------
 drivers/net/wireless/ath/ath12k/qmi.h |   6 +-
 2 files changed, 60 insertions(+), 114 deletions(-)
---
base-commit: a2da7677eb9a12e7860814b70a1f6f5b0e347d7d
change-id: 20261103-m3_and_aux_ucode-8337b881155c

