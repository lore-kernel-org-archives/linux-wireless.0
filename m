Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C83D513569;
	Wed, 23 Sep 2026 12:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165125; cv=none; b=B6jjJs/m46keiogupbI+bbLVbGY3jEGK9ZMVglYL+UrzyjxHt8NiXt1KauujllpsXVG49GCsU7X2Op3N/8Vp+Gd52mqreEsUh/d0an2xMFBIHueUPHc8L8fFi4bB7A85fWSPJzvbg9jD5rlJBccZKctT6M+YM3S7EngACNU29aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165125; c=relaxed/simple;
	bh=V8EpBw6k67scWE9ppUReXHMdRE5KShJwjQSCU4ziemI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cT/CMGL2c1EQnIfVzorxYFFsGl2p1PkcH8VEs73MFaKuexXfhkM6J2WGHra8sl5omyBpGlZAO4FgvkxSq0znqsPkmkt6zVP7Gjt3623jXRckaxLeE4WFk1IYw1HMFchMmYQx1tq0y2P/nQxSdSkwIkl0fknTeOkiTRa314bGHlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlR4E/nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlR4E/nf"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F617C32782;
	Wed, 23 Sep 2026 12:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790165121;
	bh=V8EpBw6k67scWE9ppUReXHMdRE5KShJwjQSCU4ziemI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LlR4E/nfchZUCMdSpV8rOxOIZp5F1Y6zZ/Y1xIDBA18/T3SZiSoUKhA3ylfUCWGkQ
	 bM4G0L0GUvkWMPkV655WydwWUBbwuJs1ysSR/RfPUy1UHzREqy3UiFIiniAKKFNeik
	 9w4etVnod5thmRgyZaIHP4zWWKZN6xz6Waa//7AsLh5p14h7QkY3D4NkEZrZLkAIfC
	 tG56pqhzzeJcKgWTCkNWEM9MftM2tzlelkUjvcgUpAp9o0M9KOeFIVNiO0FmcnH52D
	 COQquHD+gzX0dK1MHmsTmWVCG8mM0Ki4Tj+/cOG7kKf96lQ9ohseEwV2zLCz2dRJu3
	 RdosGFyM1MtmQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3A1C982FA;
	Wed, 23 Sep 2026 12:05:21 +0000 (UTC)
From: George Moussalem via B4 Relay <devnull+george.moussalem.outlook.com@kernel.org>
Date: Wed, 23 Sep 2026 16:05:18 +0400
Subject: [PATCH ath-next 12/16] wifi: ath11k: add hal regs for QCN6122
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-ipq5018-qcn6122-mpd-v1-12-86729521a75c@outlook.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790165117; l=4921;
 i=george.moussalem@outlook.com; s=20250321; h=from:subject:message-id;
 bh=BNVxrxCvphr2PbaY3QLCfMXAa89mIJNLaIy4fyfiBB0=;
 b=CyIsVjJsILDCihgmPBFEa8x1E/e4/uO3WqMYyXCmeOHB6ipTjw7ii0YjhmtSz2AbRWThG2u00
 w1VU9u3YWSKAgo/WYatWR/amSb/0pTU3ELNMKnl0l0J45jY/ye8TWgw
X-Developer-Key: i=george.moussalem@outlook.com; a=ed25519;
 pk=/PuRTSI9iYiHwcc6Nrde8qF4ZDhJBlUgpHdhsIjnqIk=
X-Endpoint-Received: by B4 Relay for george.moussalem@outlook.com/20250321
 with auth_id=364
X-Original-From: George Moussalem <george.moussalem@outlook.com>
Reply-To: george.moussalem@outlook.com

From: George Moussalem <george.moussalem@outlook.com>

Add HAL changes required to support QCN6122. While offsets for QCN6122
are similar to those of WCN6750, QCN6122 does not support shadow regs
and the PCIE PCS/Serdes tuning register offsets do not apply to QCN6122.
So add its own HAL register offsets.

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
---
 drivers/net/wireless/ath/ath11k/core.c |  1 +
 drivers/net/wireless/ath/ath11k/hw.c   | 75 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/hw.h   |  1 +
 3 files changed, 77 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 0a38db1ee175..cf37975fa4cf 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -949,6 +949,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.bdf_addr = 0x4D200000,
 		.hw_ops = &ipq5018_ops,
 		.internal_sleep_clock = false,
+		.regs = &qcn6122_regs,
 		.qmi_service_ins_id = ATH11K_QMI_WLFW_SERVICE_INS_ID_V01_QCN6122,
 		.host_ce_config = ath11k_host_ce_config_qcn9074,
 		.ce_count = CE_CNT_5018,
diff --git a/drivers/net/wireless/ath/ath11k/hw.c b/drivers/net/wireless/ath/ath11k/hw.c
index 93f9a03c48dc..8442fbeb9c58 100644
--- a/drivers/net/wireless/ath/ath11k/hw.c
+++ b/drivers/net/wireless/ath/ath11k/hw.c
@@ -2836,6 +2836,81 @@ const struct ath11k_hw_hal_params ath11k_hw_hal_params_ipq5018 = {
 	.num_tx_rings = ARRAY_SIZE(ath11k_hw_tcl2wbm_rbm_map_ipq5018),
 };
 
+const struct ath11k_hw_regs qcn6122_regs = {
+	/* SW2TCL(x) R0 ring configuration address */
+	.hal_tcl1_ring_base_lsb = 0x00000694,
+	.hal_tcl1_ring_base_msb = 0x00000698,
+	.hal_tcl1_ring_id = 0x0000069c,
+	.hal_tcl1_ring_misc = 0x000006a4,
+	.hal_tcl1_ring_tp_addr_lsb = 0x000006b0,
+	.hal_tcl1_ring_tp_addr_msb = 0x000006b4,
+	.hal_tcl1_ring_consumer_int_setup_ix0 = 0x000006c4,
+	.hal_tcl1_ring_consumer_int_setup_ix1 = 0x000006c8,
+	.hal_tcl1_ring_msi1_base_lsb = 0x000006dc,
+	.hal_tcl1_ring_msi1_base_msb = 0x000006e0,
+	.hal_tcl1_ring_msi1_data = 0x000006e4,
+	.hal_tcl2_ring_base_lsb = 0x000006ec,
+	.hal_tcl_ring_base_lsb = 0x0000079c,
+
+	/* TCL STATUS ring address */
+	.hal_tcl_status_ring_base_lsb = 0x000008a4,
+
+	/* REO2SW(x) R0 ring configuration address */
+	.hal_reo1_ring_base_lsb = 0x000001ec,
+	.hal_reo1_ring_base_msb = 0x000001f0,
+	.hal_reo1_ring_id = 0x000001f4,
+	.hal_reo1_ring_misc = 0x000001fc,
+	.hal_reo1_ring_hp_addr_lsb = 0x00000200,
+	.hal_reo1_ring_hp_addr_msb = 0x00000204,
+	.hal_reo1_ring_producer_int_setup = 0x00000210,
+	.hal_reo1_ring_msi1_base_lsb = 0x00000234,
+	.hal_reo1_ring_msi1_base_msb = 0x00000238,
+	.hal_reo1_ring_msi1_data = 0x0000023c,
+	.hal_reo2_ring_base_lsb = 0x00000244,
+	.hal_reo1_aging_thresh_ix_0 = 0x00000564,
+	.hal_reo1_aging_thresh_ix_1 = 0x00000568,
+	.hal_reo1_aging_thresh_ix_2 = 0x0000056c,
+	.hal_reo1_aging_thresh_ix_3 = 0x00000570,
+
+	/* REO2SW(x) R2 ring pointers (head/tail) address */
+	.hal_reo1_ring_hp = 0x00003028,
+	.hal_reo1_ring_tp = 0x0000302c,
+	.hal_reo2_ring_hp = 0x00003030,
+
+	/* REO2TCL R0 ring configuration address */
+	.hal_reo_tcl_ring_base_lsb = 0x000003fc,
+	.hal_reo_tcl_ring_hp = 0x00003058,
+
+	/* SW2REO ring address */
+	.hal_sw2reo_ring_base_lsb = 0x0000013c,
+	.hal_sw2reo_ring_hp = 0x00003018,
+
+	/* REO CMD ring address */
+	.hal_reo_cmd_ring_base_lsb = 0x000000e4,
+	.hal_reo_cmd_ring_hp = 0x00003010,
+
+	/* REO status address */
+	.hal_reo_status_ring_base_lsb = 0x00000504,
+	.hal_reo_status_hp = 0x00003070,
+
+	/* WCSS relative address */
+	.hal_seq_wcss_umac_ce0_src_reg = 0x01b80000,
+	.hal_seq_wcss_umac_ce0_dst_reg = 0x01b81000,
+	.hal_seq_wcss_umac_ce1_src_reg = 0x01b82000,
+	.hal_seq_wcss_umac_ce1_dst_reg = 0x01b83000,
+
+	/* WBM Idle address */
+	.hal_wbm_idle_link_ring_base_lsb = 0x00000874,
+	.hal_wbm_idle_link_ring_misc = 0x00000884,
+
+	/* SW2WBM release address */
+	.hal_wbm_release_ring_base_lsb = 0x000001ec,
+
+	/* WBM2SW release address */
+	.hal_wbm0_release_ring_base_lsb = 0x00000924,
+	.hal_wbm1_release_ring_base_lsb = 0x0000097c,
+};
+
 const struct ath11k_hw_hal_params ath11k_hw_hal_params_ipq8074 = {
 	.rx_buf_rbm = HAL_RX_BUF_RBM_SW3_BM,
 	.tcl2wbm_rbm_map = ath11k_hw_tcl2wbm_rbm_map_ipq8074,
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index 5a1100ceb895..d9646a491808 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -433,6 +433,7 @@ extern const struct ath11k_hw_regs qcn9074_regs;
 extern const struct ath11k_hw_regs wcn6855_regs;
 extern const struct ath11k_hw_regs wcn6750_regs;
 extern const struct ath11k_hw_regs ipq5018_regs;
+extern const struct ath11k_hw_regs qcn6122_regs;
 
 static inline const char *ath11k_bd_ie_type_str(enum ath11k_bd_ie_type type)
 {

-- 
2.53.0


