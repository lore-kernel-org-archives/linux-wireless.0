Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41743B7760
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465384; cv=none; b=LFKTAdridWWKwfYs9iMZoX14SEBueeRw2kHtZr/LHxRxVgIMbUtvXvKHNBAMc7u4QgQwYww8Fwzwga5E4Hx1HiUPR6OVf7K0oWd3RyezghHPMBVj8Dk4IhqTLW2q1TeZITwXt3gAqVBZlS2ZVeyBbBevvMW3gT087Onp72kjOWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465384; c=relaxed/simple;
	bh=ZwH9dIqzqH7BKRp8UZhL29cF/K9ScfQhre1wlRfoKOM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=XxuHFx7sHwAg1SWHlj9Qh0Q30ar3N6DUecASMyd7NpZovqPGnSTMCNLLvX5iYWqJAqNmj9AHxzTHa3exV7UT9CA8Cydp5SONfiVthAZVwe5jVqktaXTJ7dYRHd2DOEbeH190uyE3iJDuzX5QeI6ccxup0cNVZW7tnYXzZpC7dVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HafsB/3J; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iD/y0z9y; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HafsB/3J";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iD/y0z9y"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698BKClW1882733
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 13:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=0W0B5pjteSWh4hsWqWFhjg
	pgfLReXZGt1ZYOhHI9OnI=; b=HafsB/3JMPCGW+Tzlfs628q0Dy4DoBW/908kGB
	xHU1t+aBrk/R162UKEzROVSPKTBsFhbA0fOStXuyQThhALcXXquaYDWBNpPWvNoN
	sou3lPyBCNBsmqYzej4au3lggz91YWdeWycCsf/J2vz5E0fknWi8hnfZMFubGuRw
	XODvGjxq8snVoYliO8T7mvMnx2RyP+jqW6E48nHazGQhK6Xu23wz5WFNNpUDwCSD
	b+BXwwpkSMCTbLkTwJNFvTWQJjgYShKvzz/bNZy9dre9FjtwtZCQUyIzCr/diDmO
	oMS3njgijEm3VDczNDOzdbdrvlMv/e5t4MBQOVU+cKjkFFoA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe2u155-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 13:16:22 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93cb71b1443so1023642885a.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 06:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791465381; x=1792070181; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0W0B5pjteSWh4hsWqWFhjgpgfLReXZGt1ZYOhHI9OnI=;
        b=iD/y0z9yr4v6/xXiTAPso1NVZpXmuKKw6WNxp/y4ODAvPL1bvl6Ycyo4yuPQhYa/Dl
         WIlXjDeHcUrWtXRONIoqYGDGU9VPxzt/y7WnakvYHTo16pAtKdD3qhloCAqDyKgGJxlA
         r9j2WQh+9z2FC1iQuKSXoHvbSMJK9lEs253u5f/zqUhzp58tGSgIltcJ67E3KNL1MLXw
         wq1/PMM7AJEKQ7YEzwnGGdB/bc+Lok8QFnM4q5oJr5uo8/t+HHyNGHPUWPPilIX7lzPC
         CtqkgrJVhds6EevN5i2tVbvbWMikqWrNhu7FW9dlaiO8xzfxGIz624QFn5Ik97jlfZqH
         SWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791465381; x=1792070181;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0W0B5pjteSWh4hsWqWFhjgpgfLReXZGt1ZYOhHI9OnI=;
        b=d/kawSB7DcdJu514JZzksmksm43d6+fZUhFM+EWNGbQ2Jwu8AyRnrx4q/lrMcJq8Ss
         RlD5HsFLQcJlUko1ZTTStwQoCT0Mc1NFDR7hDTj24ZYPnDwpdy7TzR/H5wMOfrcEAR36
         San4Zl5jECXMVkj+R5uAyhE2MjIK9RhbdCho+Igdh29lIDwcHIAD9+DmJtL2neGvLpzk
         +uknz/fgLWzkfxHbiH6NscY40h/W1bOeVJ76Ut4aqN2v/ZCmtFassHNFXm7tSsibeFi7
         Slu6bKsWQukHxAmugjf1rbW8sSK/x3FxJUMm1lsF4UWUW+XyU9Id+1rVssCW07YEGKhe
         5hRQ==
X-Forwarded-Encrypted: i=1; AKwUvBxS8dJRfGR23/EgvRLYzyoXnkzHndVNFAgC0eu3/0zC9kmKxwqOORPnw6jxLZUDpf8+9Nzw8W6TgX3WlVNrpQ==@vger.kernel.org
X-Gm-Message-State: AFuF++k1sjCAadZfmP0QEf2Rcej2v/i1Q7tNs5+LCqpxQTb3W7CLZu05
	14MAlAk6YbTsxtdWG720DMMJM7hZRBfc15RpetGxLF1PVLF3/pW/qLIhH/H0kFJfF+WcrSNJpW4
	LWc3O9j4HDFB/mgOiHbT6c111k3kNX4dLqRr3XUyqjBcBsqcRZQIeUeX0fdyFqsTV+YrW+w==
X-Gm-Gg: AYBFou1ohf9SvYF+Se+9b3PmWk6hH5LLJZkDY84y+ksqG3IcY0HGc2c9BfBgKeD+U2y
	366FtNb3/GWUbd/aRIaE6dItAFGEli+mC7UW9TnNRnO9xT5L9rrRvrUJM8aLJzo0PW4XkpIZRej
	lsofkVDzdO/gagkw/yFlo/zEkoQvbvsXGZ+1cw/MBcPTMcCJXUga9smvRG3U9ueanQlA/qSu7WH
	71k9yYGB4sMTakM6WnFIDXHmAOMnfgaNph3dPaewafGXNNzFDPrD89dGy+6iRXGas85Ilgixqa4
	cdqa1Db10qUDc8lc2aqRTA3i3lhAyqnLH6r8dQhcQFDo3q8CRCMgUv4uQAicZPrhvwf6AaKvFF2
	8otNGUeqpY5ye9Q==
X-Received: by 2002:a05:620a:2844:b0:93c:612e:9b57 with SMTP id af79cd13be357-93e9b84f3a4mr1029126685a.56.1791465380860;
        Thu, 08 Oct 2026 06:16:20 -0700 (PDT)
X-Received: by 2002:a05:620a:2844:b0:93c:612e:9b57 with SMTP id af79cd13be357-93e9b84f3a4mr1029118185a.56.1791465380154;
        Thu, 08 Oct 2026 06:16:20 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843e8c41sm63155195e9.15.2026.10.08.06.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 06:16:19 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Subject: [PATCH 0/3] wifi: ath12k: add page_pool support for rx data path
Date: Thu, 08 Oct 2026 15:15:57 +0200
Message-Id: <20261008-ath12k-pp-v1-0-68f888cd7eec@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAwNz3cSSDEOjbN2CAt1Ui2QzoyRTkxRzUzMloPqCotS0zAqwWdGxtbU
 ACasDnlsAAAA=
X-Change-ID: 20261007-ath12k-pp-e8c62b54d756
To: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Ripan Deuri <quic_rdeuri@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA1MiBTYWx0ZWRfX9WBSy6f4pUvM
 VlI1pKfQddwbI89GnXmOHb4XGXEqXfG8jta34La5Lso3V92EM8gnHswrbh9WdB/uF6j8vyt+5Ms
 3zliWdmzQcaSfQF/AUdfGV+TziG1PwI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA1MiBTYWx0ZWRfX9M0l4et1zan4
 K3505jL0uwjaMIvBnFisExNyjqexI077yQxoDvRGj2NDautQiA0uIFkuDnGAJ5xyEqkFl8o6OQh
 f6CxulfwH6ZNal0MBBiYC6tiMqw3jxjoIWt/6Wp/NphSh7TVt4sUPT1GL5dp0UdsSwOKnZsBQ/a
 JAmKcn5XP1p6N1RU8OgfPIKOAQx2VrY62sXZIXszqc4ZJQ293y1SutW/ci0rHUzbN/DhURIJfnK
 etDxYxRBhK0L3rCUAM9CtYChKsmW/VwQ2ADrvybaOHgiNg+y37/8hVeRhTh6iLOUa6fy0yYbUjs
 qwB24Z6m6oF3mhtyuFLSwLn/DW80D/+iAVqCRn4uchbcnTyUwyo47pbXu1v6xo/kSSvqWbL5AOU
 LqQb9afpRJV/EekJjsO/WDNkVLBtCOWOWjqgGnp0d/0/Rj/SjHAcsxtbTwwRyiVMbCdF8OMRYlx
 gDLp5+4qMVTpWm1/Zwg==
X-Proofpoint-ORIG-GUID: upLbu0c9yPisY5ittcjCpn9LwXZi3LhK
X-Proofpoint-GUID: upLbu0c9yPisY5ittcjCpn9LwXZi3LhK
X-Authority-Analysis: v=2.4 cv=CIm/zhrD c=1 sm=1 tr=0 ts=6ac797a6 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=RaDjGGdyF9MjWTccV1AA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_04,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1011 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080052

Convert the Rx refill buffers to the page_pool API instead of allocating
an skb with dev_alloc_skb() and mapping it with dma_map_single().
Fix DMA direction for reinjeced packets.

---
Lorenzo Bianconi (3):
      wifi: ath12k: fix datapath lookup in ath12k_wifi7_dp_rx_process_err()
      wifi: ath12k: fix DMA direction for re-injected Rx buffers
      wifi: ath12k: rely on page_pool APIs for buffer allocation

 drivers/net/wireless/ath/ath12k/Kconfig        |   1 +
 drivers/net/wireless/ath/ath12k/core.h         |   1 +
 drivers/net/wireless/ath/ath12k/dp.c           |   5 +-
 drivers/net/wireless/ath/ath12k/dp.h           |   1 +
 drivers/net/wireless/ath/ath12k/dp_rx.c        | 101 +++++++++++++++++--------
 drivers/net/wireless/ath/ath12k/dp_rx.h        |  29 +++++++
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c |   5 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c  |  67 ++++++++--------
 8 files changed, 138 insertions(+), 72 deletions(-)
---
base-commit: 17e4b9ea527b6c9491bed60f646bb2eff7d8db7b
change-id: 20261007-ath12k-pp-e8c62b54d756

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

