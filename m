Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F337E43802B
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010843; cv=none; b=slYds11jHY+Rb+KqS1jCknY8/AhDvWrYBvkc0aQNevhJyd/H0I13H2jMta74kIOM5hwbxvCHxZCzIrOR5nU7BdtXAegxeSFJaGJAdmYsdN5JoQy8ohfLp8T5ujoy9PNkLH4/QKdoUjXmXA+XdmI6/sClGkbZjj2xncKTFUYFgXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010843; c=relaxed/simple;
	bh=eC14d5EXEQWUUdaYKSg9i7bXg77495BAIdRoBzsO1Tg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qUQePHILQ4wBG9iXn3iu4qNvezSeLQOH3ynJ6H6dDXKYPF52Q257vAOpSAenWvUCol69gpqnYVdpXE02MmFGHiqiHLDmeoHSpb8xH60iN+tye4Y1yT3GdR8FCtgUAGvZywJQTW0owyB/Ww9Yb5aTFopfF8JyqCMK1MrRpJdbhgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BP8hglFJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TbVuMCZr; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BP8hglFJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TbVuMCZr"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769necR1533992
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:07:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=TgZ91MLPKAVq/SGJJKRiq+McaAg9n408pI6
	pgpZr9i8=; b=BP8hglFJ99g0ct5ST3f/AL2BD9V46a5RrUL0qAoSZo4s9/L9i3x
	nVC1eMrlhThb3JiaxgQx97sglIAChX7xacajS9WO5KaXBcMj31epbbeg0nZcKBmz
	xdU3cBh0FQmA1iq1kjy0V99mHbywNDuc4kLl4XXVB01Kmk/0PNeI//hnlIvAs4rW
	mo2mDDoAfhnlunKiMPhOLawLho78zAUlHVebXTGD9JCh/Z7eH7W5qYSPVJtogfWW
	low/hl89NoDq20mFF7OyWmH5579bg3NpyvpihJjnNaSJ8vBHrQJ1iJZ60pRuM14G
	fdn73ZVlvCwMz557Oq2KOuG7mUfv1mErWYw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvn8prv0x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:07:14 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ccd1958e8fso36556605ad.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786010833; x=1786615633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TgZ91MLPKAVq/SGJJKRiq+McaAg9n408pI6pgpZr9i8=;
        b=TbVuMCZr6n5bzAKn7KjaYIXUJb7+sI68cR2vGhXuy8pFGhfHXiWpZtDJMLd/8lM841
         JMbKL6KSuAyc+xQIc56BI5+dDj3C9iK5ctDIHvwfwA9UYtRWzognpQ1j9sDI77oBprDt
         Nq8duksXbvi/lzgTEvv2zY9Z/7zuivzPWA8dDBw06z0jlajgM6oknvxA5cHQnYGfKGNk
         kAMp6od3dVgrtWqXtjsAQtY8bt839HjeSscqNlKSPAY/6pctofbEGeHtgP7LVk3f1TL4
         BvViENFf7URsn2YsJ4BFT1kPdDqWOeFnAcAqIXGSbrJDoc7kWxmj2tD4zqjApld6ZoJM
         NvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786010833; x=1786615633;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TgZ91MLPKAVq/SGJJKRiq+McaAg9n408pI6pgpZr9i8=;
        b=HjupjhX5qlV+aEWyNy7sw6m0uChQ8Q+T4I3GRcPmb4Hu71bpWA0ozS57qhjIhCINzY
         s8lOyqTlgt+J8iHcJZZLMtcletC1GxbvNfksOXjrTH15IvB3Gjfp00SebR61XOMRF1XF
         nblFT70jk+wCKLa/nz+fm53jv/fa/KMYf69epqefZiolP2183gKK3OocvYZAwAgWcO9b
         adVnbI4RjEPi7HGWbIdNQosrH2ZmeeV7aPSbPN/+vcOXFql4TnR5weKJeyf6M59JdBeB
         M/mOGgYK69RSfnbw2SW3BJbt6qI9Qplvd9dn4Phycx96RpaDX44mxd4Q/n1ieGpdjbDu
         e16A==
X-Gm-Message-State: AOJu0YxaY6Dzx6LSFK+4gDl/rywbTBuoK29VBNcJoxE+mgYU2lIz4bPE
	OER3qckzMOSkZszAUlMEHouj6GAhwt9y4suQrhc6j38PmENMkZ4QdZFf1OZ9vVPaNUGtvceR0st
	xifqekagU40Of37akdLBuQ8MvT1GCCuW0Z8iHFbx/KZ8o44g0q1GYIWS0iwUGeZyrbYqIOg==
X-Gm-Gg: AR+sD129wxlt+heTJ2wFY+hQQ7whDKIocYfWaoCOpGUN4m8ya6JZ1yUJejm74n7Izfj
	5ZQQW10GByk1BOs7eo1I2rRYOsnFShslfrHzH5XrCPI61/DLfnagGi1kMR7XHG4X/S8ewpa6XmI
	pXHS0Hc4jCNgUyQhzmO5EpUq75M0/ZkPwF7gJpeZ42/T5iAO08U+yI6YasMzyzS/0Ou+eoRRZkb
	TxdbPb6jUqjcnU7UpOdR/AAjjsPkHJ6GBNiCaKs3zOnySjBdnNrXIDWBPX0vLjuOXopm9/dIwrT
	YYOHh6V8K7sLvYQBhpYbsvE/vrkWCmKb6tDsO6H9N0ualm8xVAC31c912aqmZUDK/VS2liXz/n+
	W5cW9ry1FZf5WAuetShkYJXAW4Y5CvMHX+geyr2otEDYzGYHbvo7y
X-Received: by 2002:a17:902:f708:b0:2c0:b6c7:227e with SMTP id d9443c01a7336-2d106a1a049mr1338575ad.5.1786010832986;
        Thu, 06 Aug 2026 03:07:12 -0700 (PDT)
X-Received: by 2002:a17:902:f708:b0:2c0:b6c7:227e with SMTP id d9443c01a7336-2d106a1a049mr1337905ad.5.1786010832474;
        Thu, 06 Aug 2026 03:07:12 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0b6fbf2c6sm24027115ad.34.2026.08.06.03.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:07:11 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 0/8] wifi: ath12k: extend device DP stats for TX and RX observability
Date: Thu,  6 Aug 2026 15:36:54 +0530
Message-Id: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfXxSdg+i6BqIhX
 xnVilLGkGAdNVeJ3U1mql7adDl5E5NRmdSNE9NskGpCqNY7Ciu74kkV0yuKyNDcMhNDUVOy911U
 D7/X1QbP4Ydkfzyu0gyiMa0VyknnTTM=
X-Authority-Analysis: v=2.4 cv=RPeD2Yi+ c=1 sm=1 tr=0 ts=6a745cd2 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=XRJRJbIxxDQRkIj6_doA:9 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: yW_gDvjoya1Icl4x_wRvX1BKxLjNx0ej
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX3ADDrKnh466+
 xmfMPn9TmtOOoDucwdUA7Yu5vl745vG0sUfPf+rld2w809C0wgYLLGbfN3vklrr+FpfvZ5oxvv/
 P60NQwmGbEN2yseToxPyp+bAAV73XnDPmpsl4t3b4UiFT4E2cjUfaI/yY1J8i2ShumNTAd8r3qI
 fBkh/SHA787mtXOqVdHnYzfjUlw7WSuysw9umnJYloPPOSwsXn2vgUgfCRImN3hFUJrUNVbCkmG
 s/hwQyAlR1RnFM3Jrmr9gahKdZ11OzwC61Wv3mZchz2GCGq7hLiH7iBplw5Dh7Z8r/t4jRBdOSX
 uvKp9X1JmwcQzCYzcA2GgjmvoTiVjgJn6/KAIuy6VwLlN3ZTMGzN1BidGdKIAG4BE2vXx67ipL3
 Sbv3XwCW/8kJ+OoCX9ZFt2csXG1olM9z7+6lDW6BPKkZIT+58zmc1k2XIZo1yC0iwAK7r/+sx5h
 Xxcoz/KrZpx4IIQtH8g==
X-Proofpoint-ORIG-GUID: yW_gDvjoya1Icl4x_wRvX1BKxLjNx0ej
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060079

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

