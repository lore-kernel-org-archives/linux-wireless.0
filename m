Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0912E6CB3
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 13:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786022685; cv=none; b=lh7s3/irL3kxRFv3lNSRf2rcw6kzC3ht5dfXP1kAr3Jm6DrTsJAb2nmOMuh/M2yAGyy/0m7Qx0+xmRnrQN3Z23g7abGgr9SvPwFc9G0X3cbuVKZoFlpbQUtw3madr/Ki2P+aa8cqAWaMEK0aUnSj1pXqrSmlXXRAlYA/L9l1Ehw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786022685; c=relaxed/simple;
	bh=jgaLeVL27Ph54JsZW5Ks8bVOsgDEnvw2gXFf1Az1gDM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q8EcYdXQUsB7uvUlblNHF3f7fP5KrRGvmWikr4IEbFdtYHjJjV7t68luhhliGh7Vurbzp0+P+xi1tTY7gPygDZumYXkkdtjJE3cvaFLDX13JDZSnSW1jevNfLG90SAuWqHNG5a9t6Ka6SvOGXC/QMH+FGAYki94Hi9/i3q+wb7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AFn17/8J; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iBZ5YGb7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AFn17/8J";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iBZ5YGb7"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769ndlp1580595
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 13:24:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=ktRiHTx7t1faG0a+hDMeHugxgAdQx3BfAqT
	E17eP2eM=; b=AFn17/8J8PCUxpa+793ze9B/H+1wrjcV7naTOcnIUCH5zCixGVz
	dEs+L7XloG1Eu7CAbEJV7snkLijMyOFHPGRtjC3Y28kNNiVit41SapnPkHY6XzKA
	AFEt9BV6joEIW/nY4udL49NeSPJkAtzpjVL1Jc85m1FS1d+nR9wghYDSI9Hny+T8
	yUMwJrOwO4NteX1dToCftJ/HZ7XRhmTblFris+vC/8XHN1iQx8ynm66SkFJl5Kf0
	MmK/EpLAkBg815BGNS2v1anjIDiODcsnDpbEXqTsq1C+9e3M5af99OJQJYPAPxfg
	IrXLbVZrB1rL2iWhP+5yrYEEHSrETdPKGVA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvmrjhvp0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 13:24:40 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84857446424so3741620b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 06:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786022679; x=1786627479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ktRiHTx7t1faG0a+hDMeHugxgAdQx3BfAqTE17eP2eM=;
        b=iBZ5YGb7QwwSeJ8AYO9SkdwtITjRuLQGfq/NyuNmTlp8L4Ec9MKd0ly4Z3oltRNtud
         XPB3xEc1Ncj4PZRcY2EP+IVO1JoK1e30wvKNZJeGRh1PYluX17W4jJmbvr6j0EiiL4FJ
         YgpkADkDlAaQLH5g46IYVWJlIKxjGbHCYzHAUk12DRgDknpt9sgTP+DmK/be30rZaZ9Q
         hxj2oYHql7Ttgl4avm63VD2PorPSE0nyjpLUeypPLk8Vzt5tXHqAs1MAJLOMgVu0+Ioo
         c7DoXtJC2DgT4KmuTOsVveh571LCRIrAUKmg5fFAs+eN1/KM+zxYS+YBN1zD6oJgmrkb
         xSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786022679; x=1786627479;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ktRiHTx7t1faG0a+hDMeHugxgAdQx3BfAqTE17eP2eM=;
        b=SzKmFv3U8IK5lmEPfNdd7ygbsfM78+EA4r4DRsYUtOf2IOEhovl/Pdzm3T8qBQMSiE
         3xVqoSXbhlX8pJ/stRIq18l97IvYXpDaOvlo5/jyeq83cqycNcDu4vvcz6BDYdL+eRCo
         QFOzX2/eNtuTeNe4+2OFQN/yiyMRDucCAGK/jq2zdw0Rk3GD+QD3Xf/W8bKhpbmQoPoB
         7xFlYlVCgWsG1cfLrsDTXbBs3Y3dSf+iSPk689WaTbW99phI1JEOSYI8oEu4GLW25LPS
         Eprh8SHhMErOfclyeL+6W1iHSOglZXUufvZoV4t/Bav+lKx20zd0NnZypQEjBO5UieRy
         UmvQ==
X-Gm-Message-State: AOJu0YxA00zsb2GUnNLXpxUBlTlicZ5oTLgU5c27jjMPderIdxb0RfGs
	KNU9/DP48675sWi7vGIVPh5xISfpQPl7v1QvnNQm/AYRtO5uLvfVQJnvluOt7LHgUNpY7WiUepn
	sJVkf6tiyTRSw2AydM9l/jM/ighbiAbePg5B3SvFRyv12zHoIpdXMoWjoufVGPVB37U1dNw==
X-Gm-Gg: AR+sD112GOF6ZmrpPFlOsCGniBqz90TTrH7Bm4f5ckUagiK/ogiNfvOGAghVS12m2Z4
	LiCMVWsEs7wqm3xDfXJ7NLRotf3/uA4AhJ/0gDFIvFtxfKS2vJ/l2RNwcNInMDClTthO1p05YRu
	DqRAyYyd0BS0UxSmcYZGz8LYEJ9q48YdI2KPf7pFN/KqheZhI4cRE/Bf9RKu0KgoCPw67mEiWgY
	9RNy+J/dKWYFeoVMzEEh2fKRhPbz/TP3IztrA4+E4zvhlXgYRBmXDNj4ltSw8OdCJYNy2Arw988
	EHsEdA6L3km0Uka9ISZVA+l0D8usrZEvGi4bOd/BHGFudSS+/IKcnPcv/cefHj5mP4avyEcwxU/
	bi0K0Xzbg2SWLeUslCeRQyoguYT82/xWLC+66d2P8n7SBrt+on3ru
X-Received: by 2002:aa7:9303:0:b0:848:77b3:579a with SMTP id d2e1a72fcca58-84f2dfeb92dmr17780650b3a.17.1786022678893;
        Thu, 06 Aug 2026 06:24:38 -0700 (PDT)
X-Received: by 2002:aa7:9303:0:b0:848:77b3:579a with SMTP id d2e1a72fcca58-84f2dfeb92dmr17780612b3a.17.1786022678358;
        Thu, 06 Aug 2026 06:24:38 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f456b785dsm1411637b3a.36.2026.08.06.06.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 06:24:37 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 0/8] wifi: ath12k: extend device DP stats for TX and RX observability
Date: Thu,  6 Aug 2026 18:54:19 +0530
Message-Id: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=VNPtWdPX c=1 sm=1 tr=0 ts=6a748b18 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=olAotSUzlDmdGhVfZMkA:9 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: GF5LrNpy5omkx-0uutkhXbu5OqBqhSOy
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX8IkVD/Lkb40A
 dUjlBZnvZV60JSk5iN5tbhbXxag8VWNV9qr2eDm+046Eqa2rIlf+psIhww/564c1ghDaRWiXuWq
 MLIaYIHyau8DaeCfnlyKbArOqIT977Q=
X-Proofpoint-GUID: GF5LrNpy5omkx-0uutkhXbu5OqBqhSOy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX7mI9If5tH8u1
 qgCeFZeE3V4k4rPZBWV6GQZFLfMwrbjWMviba6Ry6HJzC4PmXF7xAdtDB4J7Pd0bOjeCEavrEc8
 cQpj8L658g1apZUOnnMj1I5AKozwTPOKTMYBwdlXVT8mAeW2jJzJuiNQ2musZAIaAD23AS9HXDk
 HRW7Y4+fKM7JBvIE0lGCTq1MGFsoGzKkwoP7N3Ro9k5xlL8doqpbSeikMMXitydS9LgVCHvqZUp
 SzvZ6OvV1S/p6Vsk2f6SQsmt5UZNGaF7aNfJ/qcbSwbAK8Y6WddRr0OsrDrPxrjWAR+ojyNg9HW
 ojigt5qUQXKlsBkn5F/dn46OFNrD25yxG4ZTTUWHbieLmDlRt3GI4BIJvvY6cRYYZJGWlRC2t2m
 E+nHRLpcnGIiLUGj2IYP76YX0o7hMwI4ukFlnNcoUv0z9zPRaLZIeI6Oa+wO2QWfn32xLya1yVi
 7iYubQi5biVkgxTJd3g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060105

From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

Extend ath12k device DP stats for TX and RX path observability.

Patch 1 fixes out-of-bounds array access on TX stats arrays
fw_tx_status[], tx_wbm_rel_source[] and tqm_rel_reason[] by adding
likely()/WARN_ON_ONCE() bounds checks before each increment.

Patch 2 renames the local variable wbm_status to htt_status in
ath12k_dp_tx_process_htt_tx_complete() to accurately reflect the field
origin, and simplifies ts.acked to use true directly.

Patch 3 adds a per-pool TX descriptor allocation failure counter
txbuf_na[] indexed by pool_id to track which traffic class ran out of
TX descriptors, and exposes it in device_dp_stats debugfs.

Patch 4 adds a write handler to device_dp_stats debugfs so that writing
'reset' clears all device DP stats counters without reloading the driver.

Patch 5 introduces a new dp_stats.h header with the
ath12k_wbm_err_drop_reason enum, adds per-drop-reason counters in the
WBM RX error path, and exposes them in device_dp_stats debugfs.

Patch 6 adds a 2D sent_to_stack[ring_id][device_id] counter to track
successful MSDU deliveries to the network stack, attributed to the ring
owner's dp so it is directly comparable with reo_rx[] in the same
debugfs file in MLO configurations.

Patch 7 fixes the REO Rx Received debugfs output to use 0-based ring
indexing and lowercase "ring%d:" consistent with other ring counters.

Patch 8 adds a dedicated sw_desc_fallback counter to track how often the
WBM RX error path falls back to SW descriptor retrieval when HW CC is
not done, distinct from actual packet drops.

v2 changes:
- Fix txbuf_na[] indexing: use pool_id instead of ring_id so the counter
  tracks TX descriptor pool exhaustion per traffic class, not per CPU
  ring (patch 3).
- Fix sent_to_stack[] to use a 2D array [ring_id][device_id] attributed
  to the ring owner's dp, making it directly comparable with reo_rx[] in
  the same debugfs file in MLO configurations (patch 6).
- Fix double-counting of WBM_ERR_DROP_RXDMA_GENERIC: move the increment
  inside rxdma_err()'s default: branch so it counts only unhandled RXDMA
  errors, consistent with WBM_ERR_DROP_REO_GENERIC (patch 5).
- Remove WBM_ERR_INV_PEER_ID, WBM_ERR_DROP_INV_COOKIE and
  WBM_ERR_DROP_INV_PUSH_RSN from the drop reason enum; these have no
  corresponding increment sites in the datapath (patch 5).
- Remove leading space from "WBM Rx Drop Count" section header (patch 5).
- Add likely()/WARN_ON_ONCE() bounds check on ring_id before indexing
  sent_to_stack[] (patch 6).
- Update commit messages for patches 3 and 6 to reflect corrected
  semantics.

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

 drivers/net/wireless/ath/ath12k/debugfs.c     | 79 ++++++++++++++++++-
 drivers/net/wireless/ath/ath12k/dp.h          | 14 +++-
 drivers/net/wireless/ath/ath12k/dp_stats.h    | 25 ++++++
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 52 +++++++++---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 29 ++++---
 .../net/wireless/ath/ath12k/wifi7/hal_rx.c    |  5 +-
 6 files changed, 178 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_stats.h

base-commit: 691e5e43b2aa5da35b044532845a3b230e540894
--
2.34.1

