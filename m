Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC3246C836
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 12:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018190; cv=none; b=EkJRT54g9yF04yRILVOSxaZw/g6pjcfkTaQNc6mx/KD1polwEtu5Vcq5BNnenU9Hz3HHJ+YO9Usu8hdJQMYRaSQW29njbjT6H3/IJG7bQ94vBg//eH2pZ/1ll9t7DWmWgrUEZr53UcDEEeDCDPltL2Uxq9c1lOLtkCawZf4c9J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018190; c=relaxed/simple;
	bh=jgaLeVL27Ph54JsZW5Ks8bVOsgDEnvw2gXFf1Az1gDM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BiSgkHan2Rpq2OfSi39GX3Eter5wspm7kLsw1lRYwquMpWmINNsSpCKrTK1O4HSEZpst6gQE5AkFEVDaCJQWQp1NWTR0clBxnQsGvUqPqart14khpxPXegmy6XNMrpZwxNuaCCGxOX0FwBJQeFJrvX5NvmfpSmnhtzItUKTqiCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=h2WIKRXn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EfDftZA6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="h2WIKRXn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EfDftZA6"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769neaT1277839
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 12:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=ktRiHTx7t1faG0a+hDMeHugxgAdQx3BfAqT
	E17eP2eM=; b=h2WIKRXnWG1D6DltOfi7KCug7ftXmatSwrjdxe8tcIPfBCFkZUF
	JUjrBLjZBo2KKEcvJ+KpwlC3ZnRjeFE0DuPbq4FqtlNUZJ4oEYHVSc6HayaRqTvB
	nnBFx0Zxls2/hoUi1MwszFtm0QJ99I/MxkLs4lqQ9CdEiXsPUwhSdfozUT/eI2o7
	ljA03j4LPDpclTy05w7OJcDT0+dvDEGHWD+xHDmsFy8M00QxHmjuE7rhx9yxH5h7
	OR7QH3EzRL2mdAU5O5SWELMMkzR4JE3Fkmj4LQfyW/JaKbALzcfnY4OaeCr/ezyn
	BWjCK8YtVU4cvOXGOpxhyD3xA46oqCvoEQQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvjuej1jn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 12:09:47 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38f57e31b6eso1902071a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 05:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786018182; x=1786622982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ktRiHTx7t1faG0a+hDMeHugxgAdQx3BfAqTE17eP2eM=;
        b=EfDftZA6rHdYkzP/Y8yqt/tXCWTj9cxov+oKZDc0h54FIRB2LctKqqy/Tj8wU3+vsb
         EyMSe0q71SabaJnB5bWt1YlDtPQguUiuIVElarO30lj2eTGR16ul3XtSPmEL3tEvjnG5
         +TW+yURB5oMFLO9j7sIZekHwQnVuuoGkONZVWR3Vnq2q3wZ9y4pvkzXMMHTtEGP5V7MT
         o3/yrlGgeENjBdKY3i7+oZEcPPrDYd22Mezq1snR57o04egjMVwzOGmuKoB82k5NVP8e
         Twh6y8Q0vGsQIPbxUp+pZ8pkkBUFCPPXLhI8mXlzCCZm8Ysg1gN1iiqDCtR4wVKK0Ojb
         9UEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786018182; x=1786622982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ktRiHTx7t1faG0a+hDMeHugxgAdQx3BfAqTE17eP2eM=;
        b=ccCa8tcGzDoDtaChnRWgHaQZD/cnsHg/Srs02t5eqaRAoz3vuXtgU27wAaYXzCFIrS
         rpSFbqIoP2Jv4mUxWR6d/zjsQcCkCyReJGPYSV2n7P7QKZTfCcrNAjobCb+07QTaDRWZ
         DNkDJF9HvVPbR6ksz1/93qUXPu0DI1FcPWW7M2MtpDL3CUeM1IYMiAx91TlcEUVsd1li
         Iq/XHNB0BRgZbl8yP3EWMf3UW51HxiQsT1dX8o9gup+nEu+ZBZr3vDsU4wnKLHZWyIwe
         /dl6MDnRaTglxFRCnn7wnDrQ8EPraCBasJfLWgX0YNVl/Jik9dAZVFzTeE10jN2JMHgW
         gTyg==
X-Gm-Message-State: AOJu0YyQD1MLgqMyZrhPKEweUABnH3/e1GbKYt5zP3kNBEJffd2bXRO9
	rDevVp8fuVKtdmH1nlBdnyXGuGlz9LLGnmwKqSChXw0j/3um6nzGT+GfD2bfHBbm2lJ1FyATLqS
	bUyAOoze2QgzXKyOKDH51n19gfYZOo+wLmygV5T9KJU7BwcGh8XGMFktThMXN+fTmJPJhEQ==
X-Gm-Gg: AR+sD12tk7f8ApHZht404x02r7OiLs7d6gDxF4R9IQmkHX7ulqss0S9tju9nyEr3PXz
	n2CsR+OfGpEVEJe/6eCGVUR8LTkq+zmxDvhdzKU1OeAO0Sl21kLG9lbl130kUusF2CZhVF/042G
	3i0K9Q2MpSGRy31Oeuj+4kUYoN/NBvGg6OU3P708A8Zrc0WUti+I9cFOzv5rT+tiIB+wz0NuapY
	aqXS2zkKTt+HvKiCNbMHwKCPOJGgcknsstqrLJ4XkBcOfHvQXJXdn1f33wH2m7zA6611mcARvlv
	pXucODJ3QniW7dbegGhGvTBdMnlKIlWWGFJHKUGLh0qcNvtrRyosdi8qy8rLyiI/6aWOK6JlShx
	OtdnsWZZBhdlBH+3zsGjyyek5P2jGEqslb6JWc5HcFUoWhaphzRMe
X-Received: by 2002:a17:90b:17c5:b0:37c:607b:2cd9 with SMTP id 98e67ed59e1d1-3903b9f3ee3mr12286129a91.0.1786018181905;
        Thu, 06 Aug 2026 05:09:41 -0700 (PDT)
X-Received: by 2002:a17:90b:17c5:b0:37c:607b:2cd9 with SMTP id 98e67ed59e1d1-3903b9f3ee3mr12285830a91.0.1786018179780;
        Thu, 06 Aug 2026 05:09:39 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085db4a6csm1469079a91.3.2026.08.06.05.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:09:39 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 0/8] wifi: ath12k: extend device DP stats for TX and RX observability
Date: Thu,  6 Aug 2026 17:39:19 +0530
Message-Id: <20260806120927.3607733-1-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=aNzAb79m c=1 sm=1 tr=0 ts=6a74798b cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=olAotSUzlDmdGhVfZMkA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: KFWdjwsxhKOWNgxQkWTmTuyBf8rGqb6k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA5NSBTYWx0ZWRfX43zciB+0uBtv
 UpWg0uzPpagNhRj97X853+ZIck5EMgIUeuQ9IV90Sly6asO6vthHVz9r5e3CWDNt5SAOqW7HKSe
 FTBHLnux54fN0XwTbOz57YBV0873tVySoyFj5Su8MCtU27pSKvPOMi5l+8UDFny5Q5SEAKf4hah
 vn00mh1f9E9YBUAPgyrsuEzIbpSVnWtkRxUnlpzz4l+sHOf/OKU5eBTMQjuraL8Sj3InwWUOfC6
 oq/WBGHe0mbW/ttQc0ES5LrO+0ZLnIOcQwMp9gRnDlmgCeqAlRYEepIWrk7KGx6lQjR0T6R7GPR
 4Ij+7oMiSsrzaWXJVxWRQqTMeEO5vORkiKKK8WW577DJ/qhOtggvo66rwqPx5StPLNVzSF+TkZX
 cmZ8NgnLTTNNhf56sXE3W8m/dXvIlBUYVudZ4e2ExxgsrHRo7154AKooDeIPukkPoxYLzLCJn/g
 htFFpn0zZqyZjs00OBQ==
X-Proofpoint-ORIG-GUID: KFWdjwsxhKOWNgxQkWTmTuyBf8rGqb6k
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA5NSBTYWx0ZWRfX3rjGz1MRyWx4
 JS0io2Bh2wcRsTnxrmN2txV/UfBJSBMeOTAFaoBKUZVRyXTjImEx9MDjbe9aNd3bCmxd9mxIys9
 S6mtfrPod3I9p0B9NZQAqaaqCzcVtgM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060095

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

