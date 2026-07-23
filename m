Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC407479893
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811306; cv=none; b=C9lAB1Nhi1seLwNgm0OJnhHyT2fWbX2bKKxW0P44PLfKDN6FZX7sQxRhNs5iW2rr5FpXdeaxExd5+p0X2NOdSQpqzAXj1iOCLleFXxYSfX3M9W9IgXAjeld5NuhssV/RPN4zcXoxmDOS1MXMQPVDDEHxi6gOrXpNPwkkwQNklGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811306; c=relaxed/simple;
	bh=eQ81LDohidWuLHRQqfYg+ptJn9IjGhVMIKjL2PeEPDo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qT236TPhal0iUXu2BKMQHNElYwTVt4Ev2bbzPvknNW/rfoSMg7Q+Y8WEv6IbymwNGf2jphzQHIxj4entPiEHLiRZqM12LcmUAefmAmo+a3fAZ/t0be1Hcs4wVHwHHxI5d+U068mhb8ogoclfMB/hYcAuDYh+bG5SfZkPJb08HNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZxDW5iMp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J7qldY+x; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZxDW5iMp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J7qldY+x"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NC68dh3833609
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=8vCpuwFlIE7J68gbfeaPjuoEMsKTxTMOFUw
	fz2f10NQ=; b=ZxDW5iMpNTDK71+QEAGAzq2BBiaFlApDBa9jbYYQYMmgC3bAjXu
	MhJZQ7ggFZf0Cop1/dBp2yrqdvoEGuSzE2HqcnlzmAEvsxDo17uuMPKrl2d7ouOY
	LBilYi8feOi9eB+u55qveFmsgbslmVYM1m9a9vf8c33TG7cVYHe1y2I76COx5ymg
	OPrkMeC4U/BH1RcrmPRN83GnvzejfnPEE81gSIYZILVQNyjkyVXZxhIvM69Be8Ai
	Mu8yVSoJ889vCqz1q6Espks0kr+XkOD2fFo4/znvhwfQekHmjNAda8oai3RRI6nV
	Lsj1LV2CKNZ7qxAChlWugGJWC3ry2iSvuTA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkjnu869e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:02 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cacd6d37edso11065205ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 05:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784811302; x=1785416102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8vCpuwFlIE7J68gbfeaPjuoEMsKTxTMOFUwfz2f10NQ=;
        b=J7qldY+xY0VWUz4DDM+tPMlCQfmMxd8CAZ0xDyHdmZE7GoyJK0BEP/T7N/jvcLT1ja
         t+wsmErQpmKkJAWblWUHr4qMCznI6W0MiBnAowTAcCxn4XyM4b3UNWozMtKisJbNsvBY
         dikGZciTjx3jgzrZrn7uCVHYY6eYQ3z8LLlMjIdYkosgdlZGqiMlQOKfpXtPeMqEeShG
         BnTBfJE4/WNSBcQUK3mLzz8TrLeZwNhUbbDWfFENe7BJ5oqwOSm3vnDY6Sj39ck8OUq6
         9axu8Xu6kmBbkUwTHLvDbb0ZkSHQqQEkPHQwweZZfD19OWkHhMjigyx5WiocEeOCgBRw
         diUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784811302; x=1785416102;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8vCpuwFlIE7J68gbfeaPjuoEMsKTxTMOFUwfz2f10NQ=;
        b=CSf+IvpgyBEjPux4ZSjFknVoRoCo5+cUh7+BMs5MGtOjvE1dJzEH6CZMraiTllljgU
         2wPF4NWvANKO7aY8HMAtb1wmliDNqXp0ZownWPMM1X0j9ptjzOI7V+wbbzMzJUuSaoaK
         twSsqpAGzVxh3nSzdVmZFKxnctO5lWBjg6vGQ/uqKOmDdu/qvLbXE2rnWyf6N+CNG4+j
         1KKcFQDiDF0ZSxHWUySQwYYQb/rIQ9zTWx56J78QVlaJK7d2zdTXAP8bWl0/INihAI1q
         /ePj8/TAGwed+1S0TatDWaA+ksd14MYnvbB5e+LSvSC3q246dKY9PFS1DkC5gIgDpCO+
         9BXw==
X-Gm-Message-State: AOJu0YxunpQEa8eULHBtVnaKxEjx2Rcbu0sx/X06x27LnhZ9djlucR28
	PmiMPMxyJKAaud1Sq65/6rIsGmFKhTOH2Rpn7OFthQFNBAyr9l+mAufVyOb3mswR4RzeEesMYmX
	y1hKVw4Vn+Pn7mZX8hUvIEmQqAozc7jzsD2rjhoUnLz0RuDlbfMyNJBRAEWg6m72KGXymOA==
X-Gm-Gg: AR+sD10IqWfNz0aSVyxem74ncKAkZMZT63fuTn1blBCHVT9Exb5qcCHdBLddm4X7k4G
	mmc5w8LFo0LHHed9d9NrdjhZp4qTc0ieMCYUzTRoLL6Z96/JPO5OhnMmAqfHJ3BjMaqoLBD/pJn
	t6ze64Zf54s4Il1iSTegmLwJmrJu2e2MWj5i19Ufc+MkPgApvDmSWATIg3brKybB+xZakYTIfXr
	dncCbwRxkorvOS+W1bfHJolCs7Ut3+72Q9R8omeNyOWjBmkmuFGJLw3Ifudwn+yHFhCvFyCQwRn
	F0zvt6ANfGul3wBZjir+5rMH6e5ucKKVzZ8yTO0QCvKtGRv2Uu4fFF/2L/AUgAD867w+4CWWsfb
	q6dKg8STUt0PtLg9FVLSk4mli+vULvDd7h1TvXyqaKcMlPKYgaRjh
X-Received: by 2002:a17:903:b0b:b0:2cf:9f0b:b560 with SMTP id d9443c01a7336-2cfa748ca31mr36991645ad.29.1784811301982;
        Thu, 23 Jul 2026 05:55:01 -0700 (PDT)
X-Received: by 2002:a17:903:b0b:b0:2cf:9f0b:b560 with SMTP id d9443c01a7336-2cfa748ca31mr36991305ad.29.1784811301425;
        Thu, 23 Jul 2026 05:55:01 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f350475sm32998385ad.70.2026.07.23.05.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:55:00 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 0/8] wifi: ath12k: extend device DP stats for TX and RX observability
Date: Thu, 23 Jul 2026 18:24:40 +0530
Message-Id: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 3qQshKyrV1qZxB4YVz7WipDf30DvglsB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfX91SrnlxhqtEd
 8wrWvtT1EAmFdGrZGf/ru0xCDlxOwRqGV7/UUlgHLeAZBe1ioOlohQOAPfrLoHl+wiXD+hLS/Os
 PVPEEaQic7eqqZK1ME9JcxMBcojx6VDpJaa3jLl1xcwADEzmyhreUGb7+5GB65jpgGYPIZqk/vi
 QaJSt8+rL9ix0DYi4gp98gW3vJ7TmIgXLmUQShfL7lvs/N1SNKTUBOjCjqiHdW9YpdoI11X0tUS
 9BKvi07zZQz0185/vkhf52cZZY9ufF2vP1tfXbCZY2PVxMnpc2p9/HoSmeThrYQI6/WVvK0hs+d
 3eCxJMevtrvUSMam15hlW7/t1YYPZxNVXgk8GFdafaP1p8lNQLso/yotZym4TP/N3Ewn2S9KPbo
 38GO7L2kdwyLWlgaYwNXnQPwAJAo08aGYW++DXROkK3+9I+XFkKDrF5lZYu8YgGcuOC2xwt0jDA
 Bcz78rnhYNArxPB8lqQ==
X-Authority-Analysis: v=2.4 cv=Een4hvmC c=1 sm=1 tr=0 ts=6a620f26 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=XRJRJbIxxDQRkIj6_doA:9 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfX9C3iewDTSg+n
 ZksuAAMxjm17TKuZbCCIYquroCI3niKcq8mEiXEkCbfeihHYACtJM3e2/ZGR8oKFN5bQDmkS4k9
 ctRaHuATT1HXlZOVrhzjrd5m+svNyWo=
X-Proofpoint-GUID: 3qQshKyrV1qZxB4YVz7WipDf30DvglsB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 impostorscore=0 clxscore=1011 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230127

From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

Extend ath12k device DP stats for TX and RX path observability.

Patch 1 fixes out-of-bounds array access on TX stats arrays
fw_tx_status[], tx_wbm_rel_source[] and tqm_rel_reason[] by adding
likely()/WARN_ON_ONCE() bounds checks before each increment.

Patch 2 renames the local variable wbm_status to htt_status in
ath12k_dp_tx_process_htt_tx_complete() to accurately reflect the field
origin, and simplifies ts.acked to use true directly.

Patch 3 adds a per-TCL-ring TX buffer allocation failure counter
txbuf_na[] to track how often ath12k_dp_tx_assign_buffer() fails, and
exposes it in device_dp_stats debugfs.

Patch 4 adds a write handler to device_dp_stats debugfs so that writing
'reset' clears all device DP stats counters without reloading the driver.

Patch 5 introduces a new dp_stats.h header with the
ath12k_wbm_err_drop_reason enum, adds per-drop-reason counters in the
WBM RX error path, and exposes them in device_dp_stats debugfs.

Patch 6 adds a per-REO-ring sent_to_stack[] counter to track successful
MSDU deliveries to the network stack, and exposes it in device_dp_stats
debugfs.

Patch 7 fixes the REO Rx Received debugfs output to use 0-based ring
indexing and lowercase "ring%d:" consistent with other ring counters.

Patch 8 adds a dedicated sw_desc_fallback counter to track how often the
WBM RX error path falls back to SW descriptor retrieval when HW CC is
not done, distinct from actual packet drops.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---

Aniruddha Mishra (2):
  wifi: ath12k: add WBM RX error drop statistics
  wifi: ath12k: add WBM SW desc fallback counter

Hariharan Ramanathan (4):
  wifi: ath12k: rename wbm_status to htt_status in HTT TX completion
  wifi: ath12k: add TCL ring TX buffer allocation failure counter
  wifi: ath12k: add device DP stats reset support via debugfs
  wifi: ath12k: track per-ring RX sent-to-stack count

Pardeep Kaur (2):
  wifi: ath12k: fix out-of-bounds access on TX stats arrays
  wifi: ath12k: fix 1-based ring index in REO Rx Received debugfs output

 drivers/net/wireless/ath/ath12k/debugfs.c     | 74 ++++++++++++++++++-
 drivers/net/wireless/ath/ath12k/dp.h          | 14 +++-
 drivers/net/wireless/ath/ath12k/dp_stats.h    | 25 +++++++
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 52 ++++++++++---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 29 +++++---
 .../net/wireless/ath/ath12k/wifi7/hal_rx.c    |  5 +-
 6 files changed, 173 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_stats.h

base-commit: 32f39e331f889a0424f7a0a82893f628e2705727
--
2.34.1

