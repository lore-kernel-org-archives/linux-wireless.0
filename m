Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F703F9F56
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786373093; cv=none; b=ONkUDYknx3V4/DGPdt9uYX5A3eyNV3jgTsyk14iSmlYRPPvpYYix1Kdrowv+E010bA3PYN4pHvgLFIdfY9JMkjlE42tfZy2iJG0UCyR0XgncjLBKjQ44JjlXV4F9j9RPaMEP5wvpbLMNYYklNKornLpAcNXP3Hu4tfQfutp6x/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786373093; c=relaxed/simple;
	bh=aTOg1ju88uuJX9QNuUcbRy0WvFZb6VYwTLBi9AKabRY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nAf4ZzG4Z8o0cojqrDuroDxalUwDjJ1hplBCBJbIJBeEwvM6FRHJwh+W4K+mb2mMOAav1MxXb5CP5yqbwHekXVq3KQ8mrPkCIV2t6vNDcwDWAUCR8RkAROeOlombINOcFVt+Oc4UQqgiIMLbv3/8UhUiH8uW15I/LKT4r9J6w28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EML9HzMb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XI7OWOVt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EML9HzMb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XI7OWOVt"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACjKn01308973
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:44:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=iM2U/yypuTZBTMptELc9jAfcUPywYPhDAWL
	I3nFxvgc=; b=EML9HzMbfNXjULngkuQvpvLM3EV4gISZ1JuM+8h3AHr5vqyVaJ/
	cPbCSAbi3xx0ZVEJSMT2NWQduuhp5fQ5wy30xVsgo7GDlhSg54ydGqW0LsSr7Cs4
	nMaKwb+TsKk8OXo1m6Jpc2vZ5D6IChjFJoUnjy0Ys37m7c47madWuI7tYBLzef1P
	CLS43nHguVXo+h1HMlf7TocQ2iLNh3iUg3ix5ii9Uy+HR4kjThBCRYkUSA0z0W/1
	63SJBgL8Ul4IZQ9pIODhy/kFd8I3FLPfqgcwscEcbijp/lJ8kpB0vUo6jj0iQEzc
	MntVZkoa806yLGETfuIns9L0Vr9paCHg8OQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fyccqs4n7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:44:51 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e25e4b41cso2511830a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 07:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786373090; x=1786977890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iM2U/yypuTZBTMptELc9jAfcUPywYPhDAWLI3nFxvgc=;
        b=XI7OWOVtLJGfovZsQJAErLTSNe7tc4qs+7k6uCvb7CV/KOIg0fsRX8aO59eiETn5zU
         pS06HhQszw2pPVXTbDlNeMqq2NK8vy7PWhGZoyWVkG1OmyxmE8SlfFv4EIBQ1IAt7jzj
         ZP5zM/GJ8OXegKjhNfyqpumomdT9fjKP6OPATDn/gTG1AeXjHXtX77V8j8qT75OqvWjF
         PTCKaPTJtbj3eEUfr+twEouijBs7M+3CZ+gS54hecu2G9mxeuCz400H73PSCVwZBSbHi
         RR/3z/iDr74DO6uSn6MjKMgQjykTzKd+OnJzSlt3PKM3OekjfQg/lD3w38fDvufWZl53
         VzLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786373090; x=1786977890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iM2U/yypuTZBTMptELc9jAfcUPywYPhDAWLI3nFxvgc=;
        b=FeYwVYY2Fxp2hAdjQpJZy3XcAujM18wCI+93ndLPl+6TJtkgkm3unFVEEDDgZvtCae
         C3WdItPLZ1vb+u6pT9SMMQEkd0RiJS66YGVNLZouSH2/k5Up1Y4Nw9SMXacIXFeEiW6N
         arLZkvLxV68LIfC3sTmFhDXEQuGBII3jn4D347oBpexcts3EGPMtK37TQiHPI73S+K3R
         obXR10lyP31NGfj2BOSN31EoHKE59eDHItjf5NxTHI7qDzoxVggIyrHq7J9IPqDT2WOW
         aaP2cVGlaC0+hxo/t2F1oMOewGIm6miLCzPKOJZQHHE+NOvUDIbUCez5NEZtIphV2srK
         p5yg==
X-Gm-Message-State: AOJu0YwhPSs6VNUV2g3s+ubbls3/gn5XR4MNS4Gcab6hlrmEzD+09XXX
	IUCAkocRow/Py0w412KOODIILnz9ClAj5LhKLSslmdN88QTIkAkDJpIOkuCoemI5dhqlG8dTPCA
	HNbrwcpWKnkjCAZ22qYp+/vhwzjoq1cJS4PKH81eUCBQe+sdxjOdr+vU4OLrVfNMiwxHoq8OzXO
	XRDQ==
X-Gm-Gg: AR+sD11k4rE7i5UJbznE6j9zpQqNkLH/YDA1JLVV8t9bxcjgqV9oIrOdB6f358PYYVR
	yWmSB1ulhXX8B25hO9EajINkJGJcjEcTxL4FZ60rE67q1b7FIDUH/m3hnXz1m6Ibl2XpZVM1ZdW
	ogyyPvS8Okc2a4uf6CsqmyLVHrmtt2M/lEec1oeVCnWyb8cuekgmLMWKCJbUaynoAUYDbixWudr
	F4G9tbcmTrsDiYNw1N3iD+UcTVpDqefn4JxPwJb1/c9uD8/GGHQtlOBJUmJcauB7/fe7KMLQho5
	g+eJqL5XhXYfGgz18waz781Ulgnn0ctyCnDyJhtrQxOqmhes7NY2ubDMn/kx7rbKt3VJ2JHMwKf
	iyMjLRQ72YefOFl8nAQTzKXjUrrUFCniIM4P3iZJk46O5RY/qoNXG
X-Received: by 2002:a17:90a:c2c4:b0:38c:a59b:5189 with SMTP id 98e67ed59e1d1-392cca3507dmr1997439a91.15.1786373090484;
        Mon, 10 Aug 2026 07:44:50 -0700 (PDT)
X-Received: by 2002:a17:90a:c2c4:b0:38c:a59b:5189 with SMTP id 98e67ed59e1d1-392cca3507dmr1997394a91.15.1786373089857;
        Mon, 10 Aug 2026 07:44:49 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm12797317a91.2.2026.08.10.07.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:44:49 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v3 0/8] wifi: ath12k: extend device DP stats for TX and RX observability
Date: Mon, 10 Aug 2026 20:14:36 +0530
Message-Id: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: XfKDn7OPcDSwo2tYOkBNjsOJUBKgw5Ee
X-Proofpoint-ORIG-GUID: XfKDn7OPcDSwo2tYOkBNjsOJUBKgw5Ee
X-Authority-Analysis: v=2.4 cv=WNVPmHsR c=1 sm=1 tr=0 ts=6a79e3e3 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=xUrUGq4uUGx-1kL8JP8A:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfX1QUAEz02XGFx
 AalivuIuPS7uTe0vVRuj7dlgR6bjLZot1DYdIKxXWuegiBabUWQg4NVzxuh+Ee+jPyn1nq6Decq
 uepvO+7JTsBzifvsLaM9Vu/vgnnbudmgLUGBli/vsoBcxyZohX6UFmCN6zTdDio43Sz8ZvFifE7
 aFjYY46YBtR2SWiC6824V3T6WXLdNdX+BjU0pX9HLKSqgmYiQ9BZN/b4+6Hbl02J4RhHq9z3Y/I
 7UtzrF0vBPUTPzSxFWSHQ/5MKJ08cqIdyUusC9Jy31qGtY6EB9I/zku8iNfTPbaOl6vorGYRfuN
 TK+0ICjQvaAXCM02csUvAdwHrAvqVHZNoo1Ah1fvmBUY/CB03MYhRHj5WFz1x/JZUvptnT1w+xq
 nMAJeJSM3RY0o5kyKKxQykhXbu8V/3RZFJDwsl3DySvGs/7YVsM3B5G2GnTbxJf6i7rOIoGIW/z
 DRpzTOVrzH32RrLIdcA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfXxTbhO6Gp7H+r
 j9xLqBdfx5kUoO9ezY+34GQ+qkMjGI1P6IcepY3abCMVGca4WcEkzGRe1y7As7wsAh3MuifZVRA
 ii5hh4LKop2t+1r2cKhsL6HsJcj5vnY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_03,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100126

From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

Extend ath12k device DP stats for TX and RX path observability.

Patch 1 fixes out-of-bounds array access on TX stats arrays
fw_tx_status[], tx_wbm_rel_source[] and tqm_rel_reason[] by adding
likely() bounds checks before each increment. The default: case of the
switch statement that follows already handles unknown values with
ath12k_warn(), so no WARN_ON_ONCE is added for fw_tx_status to avoid
double-warning on an out-of-range htt_status value.

Patch 2 renames the local variable wbm_status to htt_status in
ath12k_dp_tx_process_htt_tx_complete() to accurately reflect the field
origin, and simplifies ts.acked to use true directly.

Patch 3 adds a per-pool TX descriptor allocation failure counter
txbuf_na[] indexed by pool_id to track which traffic class ran out of
TX descriptors, and exposes it in device_dp_stats debugfs.

Patch 4 adds a write handler to device_dp_stats debugfs so that writing
'reset' clears all device DP stats counters without reloading the driver.
Uses simple_write_to_buffer() to correctly handle partial writes and
non-zero ppos, consistent with ath12k_write_simulate_fw_crash().

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

v3 changes:
- Remove WARN_ON_ONCE for fw_tx_status out-of-range: the default: branch
  of the switch already calls ath12k_warn() for unknown htt_status values
  so adding WARN_ON_ONCE would double-warn (patch 1).
- Replace copy_from_user() with simple_write_to_buffer() in the stats
  reset handler to correctly handle split writes and non-zero ppos (patch 4).
- Drop Fixes: tag from patch 7; cosmetic debugfs fix not needing backport.

v2 changes:
- Fix txbuf_na[] indexing: use pool_id instead of ring_id so the counter
  tracks TX descriptor pool exhaustion per traffic class (patch 3).
- Fix sent_to_stack[] to use a 2D array [ring_id][device_id] attributed
  to the ring owner's dp, making it directly comparable with reo_rx[] in
  the same debugfs file in MLO configurations (patch 6).
- Fix double-counting of WBM_ERR_DROP_RXDMA_GENERIC: move the increment
  inside rxdma_err()'s default: branch (patch 5).
- Remove WBM_ERR_INV_PEER_ID, WBM_ERR_DROP_INV_COOKIE and
  WBM_ERR_DROP_INV_PUSH_RSN from the drop reason enum; no increment
  sites in the datapath (patch 5).
- Remove leading space from "WBM Rx Drop Count" section header (patch 5).
- Add likely()/WARN_ON_ONCE() bounds check on ring_id for sent_to_stack[]
  (patch 6).
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

 drivers/net/wireless/ath/ath12k/debugfs.c     | 80 ++++++++++++++++++-
 drivers/net/wireless/ath/ath12k/dp.h          | 14 +++-
 drivers/net/wireless/ath/ath12k/dp_stats.h    | 25 ++++++
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 52 +++++++++---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 27 ++++---
 .../net/wireless/ath/ath12k/wifi7/hal_rx.c    |  5 +-
 6 files changed, 177 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_stats.h

base-commit: 691e5e43b2aa5da35b044532845a3b230e540894
--
2.34.1

