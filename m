Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6AC51354A;
	Wed, 23 Sep 2026 12:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165125; cv=none; b=fhsJv9gHESh1CXVJAi66D1V5nv/XsWC008JTw0YLZc8JKOzq1ptALIqJ6iH6o1k10vvhnmi5QwG1c8y1lpHjpbq4hf0p2rKe82BIyyG68bDHGoL8Mpdna09tQFqIwZmxz9wvpa5OkzaMqS9kGpjnnvgKgxtXxqCfZknRSjnWtmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165125; c=relaxed/simple;
	bh=xwjhHq+axtyNZtf3ucpzpJBoQOgD2kDsTykcF1+22VU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uQ0hpIrS5VSbuYoB/tTcZWuH21+LKZ6vcJak7kjKkLIxUvZSOgRYlPE1HdGl5UvBcB2g6SdvUCEV9ZVcSd0y91NBHGp5lDRy5/H/+BuUTVuVJ4p3AaI3/v87uJYXOE82kd5Yn3TtJqiSysitNhZb1yO6uLaVLHhJiabGgkf0Bcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0WJviDT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0WJviDT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90815C2BD00;
	Wed, 23 Sep 2026 12:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790165121;
	bh=xwjhHq+axtyNZtf3ucpzpJBoQOgD2kDsTykcF1+22VU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=L0WJviDT2c4j9z652S8+95ezSOvIjOT1EoHGwjEk8dIE+bjnQ9zPfEDFUrJCKt5ZB
	 rVfj6B+wjHY4L+yXcT62sTpE0Cu5mtHmftvuEN154YK3x0S3oGn8WNSAdqkKxHtL4j
	 GmZa/lnWsWL71ixP9N+JMVUeTMd5yetmmKd7DrVUsADGoBRVk7gcg48VYpxguD+iB5
	 ivK6Es2UaFq90I+Vwj1VQ58+XybOKrPryo/+y8vmvu+hYwRawK7DaRcooHXvNyzlBn
	 GHgFTO0dIeXSCTK8b6Kn1VFWZLPbY/sE/lL1EiWHLVf3zT8MYhXp76vTPel6Xs3e4O
	 P/EaKufUYdBgg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBBCC9830C;
	Wed, 23 Sep 2026 12:05:21 +0000 (UTC)
From: George Moussalem via B4 Relay <devnull+george.moussalem.outlook.com@kernel.org>
Date: Wed, 23 Sep 2026 16:05:19 +0400
Subject: [PATCH ath-next 13/16] wifi: ath11k: add hw ring mask for QCN6122
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-ipq5018-qcn6122-mpd-v1-13-86729521a75c@outlook.com>
References: <20260923-ipq5018-qcn6122-mpd-v1-0-86729521a75c@outlook.com>
In-Reply-To: <20260923-ipq5018-qcn6122-mpd-v1-0-86729521a75c@outlook.com>
To: Johannes Berg <johannes@sipsolutions.net>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 ath11k@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Vignesh Viswanathan <vignesh.viswanathan@oss.qualcomm.com>, 
 Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>, 
 linux-arm-msm@vger.kernel.org, 
 George Moussalem <george.moussalem@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790165117; l=2926;
 i=george.moussalem@outlook.com; s=20250321; h=from:subject:message-id;
 bh=ZS+ghizA2JnJORyhUeyzkT6PiFQkDEnAqkqpPDbBCt4=;
 b=oc8KKCzLEqR8y0YejgVoqOfzgsPd1UyzJB67HNuqi3DnHAhkRQIBLSDVrtLi/DS0KcxMFmfNa
 TamHpCY+jhXAcFEXohGRlgRkT3YCLTi/HayF26SEjdylq2gKXl9JolP
X-Developer-Key: i=george.moussalem@outlook.com; a=ed25519;
 pk=/PuRTSI9iYiHwcc6Nrde8qF4ZDhJBlUgpHdhsIjnqIk=
X-Endpoint-Received: by B4 Relay for george.moussalem@outlook.com/20250321
 with auth_id=364
X-Original-From: George Moussalem <george.moussalem@outlook.com>
Reply-To: george.moussalem@outlook.com

From: George Moussalem <george.moussalem@outlook.com>

Add ring mask for QCN6122 and register them in hw params.

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
---
 drivers/net/wireless/ath/ath11k/core.c |  1 +
 drivers/net/wireless/ath/ath11k/hw.c   | 37 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/hw.h   |  1 +
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index cf37975fa4cf..8fa1171b6bdd 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -948,6 +948,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.max_radios = MAX_RADIOS_5018,
 		.bdf_addr = 0x4D200000,
 		.hw_ops = &ipq5018_ops,
+		.ring_mask = &ath11k_hw_ring_mask_qcn6122,
 		.internal_sleep_clock = false,
 		.regs = &qcn6122_regs,
 		.qmi_service_ins_id = ATH11K_QMI_WLFW_SERVICE_INS_ID_V01_QCN6122,
diff --git a/drivers/net/wireless/ath/ath11k/hw.c b/drivers/net/wireless/ath/ath11k/hw.c
index 8442fbeb9c58..bb375efd50fe 100644
--- a/drivers/net/wireless/ath/ath11k/hw.c
+++ b/drivers/net/wireless/ath/ath11k/hw.c
@@ -2070,6 +2070,43 @@ const struct ath11k_hw_ring_mask ath11k_hw_ring_mask_wcn6750 = {
 	},
 };
 
+const struct ath11k_hw_ring_mask ath11k_hw_ring_mask_qcn6122 = {
+	.tx  = {
+		ATH11K_TX_RING_MASK_0,
+		ATH11K_TX_RING_MASK_1,
+		ATH11K_TX_RING_MASK_2,
+	},
+	.rx_mon_status = {
+		0, 0, 0,
+		ATH11K_RX_MON_STATUS_RING_MASK_0,
+	},
+	.rx = {
+		0, 0, 0, 0,
+		ATH11K_RX_RING_MASK_0,
+		ATH11K_RX_RING_MASK_1,
+		ATH11K_RX_RING_MASK_2,
+		ATH11K_RX_RING_MASK_3,
+	},
+	.rx_err = {
+		0, 0, 0, 0, 0, 0, 0, 0,
+		ATH11K_RX_ERR_RING_MASK_0,
+	},
+	.rx_wbm_rel = {
+		0, 0, 0, 0, 0, 0, 0, 0, 0,
+		ATH11K_RX_WBM_REL_RING_MASK_0,
+	},
+	.reo_status = {
+		0, 0, 0,
+		ATH11K_REO_STATUS_RING_MASK_0,
+	},
+	.rxdma2host = {
+		ATH11K_RXDMA2HOST_RING_MASK_0,
+	},
+	.host2rxdma = {
+		ATH11K_HOST2RXDMA_RING_MASK_0,
+	},
+};
+
 /* Target firmware's Copy Engine configuration for IPQ5018 */
 const struct ce_pipe_config ath11k_target_ce_config_wlan_ipq5018[] = {
 	/* CE0: host->target HTC control and raw streams */
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index d9646a491808..2bcfdae9519b 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -296,6 +296,7 @@ extern const struct ath11k_hw_ring_mask ath11k_hw_ring_mask_ipq8074;
 extern const struct ath11k_hw_ring_mask ath11k_hw_ring_mask_qca6390;
 extern const struct ath11k_hw_ring_mask ath11k_hw_ring_mask_qcn9074;
 extern const struct ath11k_hw_ring_mask ath11k_hw_ring_mask_wcn6750;
+extern const struct ath11k_hw_ring_mask ath11k_hw_ring_mask_qcn6122;
 
 extern const struct ce_ie_addr ath11k_ce_ie_addr_ipq8074;
 extern const struct ce_ie_addr ath11k_ce_ie_addr_ipq5018;

-- 
2.53.0


