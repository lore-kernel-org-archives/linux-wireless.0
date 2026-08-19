Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122931B4138
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787117578; cv=none; b=VoCW+R6wozoum73VbPF0mEOP5QKsO8uKHTpYulZdIgLLOljNIs6mXBULNdlUGTgv6rVPFA9ulVl57EqDws1U2PZ2//NYJ9nX6JA+TTOfsHQ5eZ1zVo6HNvl2OuTZ6kBBQq3sUttVSckvroqlLudOeAo5MuYAJIGD/gaogrhoQEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787117578; c=relaxed/simple;
	bh=93Rb2eNb1EsEzwm7GdxTBi2l5oJLBr4U5TOT0qkoPOo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sS4QXf5qczX5Mf4kX//O6UkL/1otQvIrJnYx6mooMnt/rZTcakxX9tacDoVv13T6pgT7MI0JjszWmUF8a/oiBrbE/0pC0Ft0e1Sp4s0v5jlsQiAxAg9KY2uZtCj6z5T/e48zo5Ily7QimhW8gCg8V0K9qqtQtPAIp2ZGc7jNvQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LKsdzTTW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SIdAARQQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LKsdzTTW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SIdAARQQ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J5I7GU2555110
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=XrAx1khjQTS3f7t6iHsWptHfkk8Zh7xYgrz
	gV1ecDnA=; b=LKsdzTTWJMTyRFboxB4PkQITY2rb5ac3/cD5KF7igyh3l4fEjJT
	+YXIu1+HlAFO/7JvA4ldK5ca95mgIf722xXW1Yd3l66BEOwglwIlFThV+LcnOFJh
	RPpUk8h+5YupXTzUuaPnumev0tfZd1ZnIzV7TvNogvVqM0ss4pKH2AbSPZyOnfGt
	s22IpTU8upT/mGx4eBjgDc1IkVI85Gf88MXj8oKhb2ojZdBkWQCtVi+PHDeELNDT
	xlDAddhm4Da0VipcR2CK98Wy4fULVPCFkUzTiAltGWLsZMc3dHm0NCCJoMiFJoYD
	/p4N3WO9L4+YqOVSTEP9gMtbD7H/DmRQmzg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfm1g7e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:32:56 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e6d253330so696337a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 22:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787117575; x=1787722375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XrAx1khjQTS3f7t6iHsWptHfkk8Zh7xYgrzgV1ecDnA=;
        b=SIdAARQQfdgLwF251wFTTTB33OGlkGpAbKJEGmCXxg4pSSrI4v7Hk5Jlnj9JjPFiVQ
         Qo9kctILnQ5JxGFxYSYQRxjJ9tE8bX5mG5UF2bvuobE4frEzerZnF7dShY35NKCW7C5f
         n8BHoIU1K+tHgrRc2qEQtxoCFq3WpsFCQTZtZUt38ZdY9YciWkkEvH2BHlAoSqJcy8g/
         vb/Kz8T8T6AxtNWu8yTz2XSH1Ei3wVWHH9j8XWFSKdeLaq5D+nO2jC3TWbXht8/LbKMk
         fd56rqyiLq+4nMAJ7+zyncFoQgyHKdFfUNWvHb33kftGd68mzMOdtmtWyOIoVKTcPfi7
         7VQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787117575; x=1787722375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XrAx1khjQTS3f7t6iHsWptHfkk8Zh7xYgrzgV1ecDnA=;
        b=jnQ7ViUPasheXBcbm4EVCYQOJnl8Z0OOCHRYV28D+5gu2l/1NtubM/Ap7Gn9Tig19P
         t6l1lIrhIa6DovAihCZnLwDAehOaX0KO/6OMHEyAR+bbyBgeRgw2h+6sTx9fNDjkeqhc
         /R1XW2y/iFhbbIabgqC7I42J8c77f0TCa/ieOKFql3im3INiCxvXSkTUrKLIKee5uXMM
         cg48oTqu2BHx1SHULZcGSUQM8FSAW32+dii5zOC8tEqvI7Xv+bbT3cuT9mzpon1rB4JO
         I9V4sJwwnatiCqLKQd5Eu8wY+d7yRfXzWhzu15U1RgFSHT9A5GveT36xonOuyhqi7DAt
         RjTg==
X-Gm-Message-State: AOJu0Yy552Yb2Ud/ygnVUT6uCxAkA4+Yuxk8otE60GFP3yD5llmdNZyI
	WkEZmXO1Ssi8k2QBMXtEyUL0LR9kTC3f9RWpYqgFgplEmdpRXlc5QG1/UXOLOTo8YDq3wTecdvv
	rbNlC2dJrHG0ebu9Bn0D4vT6Hs0UQQHoeaQrvlhwPqfUj45M96QWX8fzN8LSQ652z5/FKqw==
X-Gm-Gg: AR+sD10/2Z7AMEkgEft133D3RZA9nch1v6sI4rkK/kxEpQO9U00Kxb7xc9170VFh5GS
	a7MJUEVvm2skIfMmmVypH5C+K47c3HPgvIGi6Tp118/WTiSvez0w88X+l9n1Vel0hE/BGBZ1zhL
	EIeyzwecGosEnIfoag49/nQyhYb4QV03L1l0CH/YuGAN2W7cddFE+e1thezkKuWT+uEHLQxTi30
	BdequaPR/cioyVC1N4wtHIlRR7qbwzYeE2cwTCxMNVrGDhNZZqjLH8dmW46x/e0knPjAsqTe+zq
	G8Bqm3OCZh3NYafWTPIWSPgOhhkCL2HqIqmM9Sro4OtlVj3fcRJezF7U2mlksVbLmFViYOHQW/B
	IQTToUk14IgfRbcStJP/GHCaIr+lJSHJbD2oioCAYZMIBMiDUNML8
X-Received: by 2002:a17:90b:3b50:b0:385:3ab:fecb with SMTP id 98e67ed59e1d1-3957f8b5579mr1965965a91.4.1787117575054;
        Tue, 18 Aug 2026 22:32:55 -0700 (PDT)
X-Received: by 2002:a17:90b:3b50:b0:385:3ab:fecb with SMTP id 98e67ed59e1d1-3957f8b5579mr1965934a91.4.1787117574476;
        Tue, 18 Aug 2026 22:32:54 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f4c9918sm404261a91.0.2026.08.18.22.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 22:32:54 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v4 0/8] wifi: ath12k: extend device DP stats for TX and RX observability
Date: Wed, 19 Aug 2026 11:02:39 +0530
Message-Id: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: aBS80kAzZXZH0HNs8QEwJT3XLAi68LaN
X-Authority-Analysis: v=2.4 cv=bth8wkai c=1 sm=1 tr=0 ts=6a854008 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=86WhgQvHTe_COOI2mw8A:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: aBS80kAzZXZH0HNs8QEwJT3XLAi68LaN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX57gpl8quEtth
 sEva+S+5B1gsozhc858c2Kt4v7dVLZAOiC4lOljQtlc9HMFyzxBpoCH11WXQFBstuGqWFx1qawC
 ax2ICvqA23k2FvlvNiif4dMOiaGa2sCVtFvM5avwu3Htcl9jcgBB0MEHswLYgLy63MLwaJ8wGM+
 blshbJNaDTB5LXgTVQZ0Y8iEi9N5OFfcPv027WUXtFeBY366Cbvty3NrXpxOa3qxAp3HS0mc+jz
 81nDkkXanwYReQHrXxIuka8CQy9eG0etkotWJQbNIM8F0bsy5pXdZdX0/omAvlDINt4f2U04LUO
 yD/8b9pKUBeNvYwFVQf0dvlydf3R2trEQwLCJaxSNdg8AoXGpzz5PkE5lWzH7WRSugKeTknYfoS
 xhoCioKahy6PAV/kU0a+YzrFciSYy2CtWrAtJ6dxX4FNHJR39jOoa3Ejw2VkeVPL0hdBAy7VquH
 6njveWN1EU8GSXQdURg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX16a7zgKbtQMV
 ZzpuMTACjayQUpVYAbslxturtnPFppzJuzYVLm5iFWvkqmoNkh3mq/47Dz47SVxcsElAdmJQ35J
 Xtf60Dr4fLiFALdfqn0krk4bToHNC84=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_01,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608190039

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

v4 changes:
- Rename WBM_ERR_GET_SW_DESC -> WBM_ERR_DROP_GET_SW_DESC and
  WBM_ERR_DESC_PARSE -> WBM_ERR_DROP_DESC_PARSE for naming consistency
  with all other enum values in the same enum (patch 5).
- Remove extra space before = in wbm_rx_drop[] array initializer (patch 5).
- Drop ath12k_warn() on unsupported command in the stats reset handler;
  -EINVAL is the correct user-facing mechanism, consistent with all other
  .write() handlers in the same file (patch 4).
- Fix missing colon in "REO sent to stack" section header; all other
  section headers in the same function use ":\n" (patch 6).

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

 drivers/net/wireless/ath/ath12k/debugfs.c     | 78 ++++++++++++++++++-
 drivers/net/wireless/ath/ath12k/dp.h          | 14 +++-
 drivers/net/wireless/ath/ath12k/dp_stats.h    | 25 ++++++
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 52 ++++++++++---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 27 ++++---
 .../net/wireless/ath/ath12k/wifi7/hal_rx.c    |  5 +-
 6 files changed, 175 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_stats.h

base-commit: e07447e654476262558bee570f4cf456e2b32565
--
2.34.1

