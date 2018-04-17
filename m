Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43014 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752974AbeDQMHU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 08:07:20 -0400
From: pillair@codeaurora.org
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH v2 1/4] ath10k: Add hw params for shadow register support
Date: Tue, 17 Apr 2018 17:36:58 +0530
Message-Id: <1523966821-21903-2-git-send-email-pillair@codeaurora.org> (sfid-20180417_140724_584666_77C447F9)
In-Reply-To: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rakesh Pillai <pillair@codeaurora.org>

wcn3990 supports shadow register for ce write.

Add a hw param for shadow register support.

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 14 ++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  4 ++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 64479acd9dc5..5a9d222acfe6 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -90,6 +90,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = QCA988X_HW_2_0_VERSION,
@@ -120,6 +121,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.per_ce_irq = false,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -150,6 +152,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.per_ce_irq = false,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -179,6 +182,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.per_ce_irq = false,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -208,6 +212,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.per_ce_irq = false,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -237,6 +242,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.per_ce_irq = false,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -269,6 +275,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.per_ce_irq = false,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -304,6 +311,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.per_ce_irq = false,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -344,6 +352,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.per_ce_irq = false,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -383,6 +392,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.per_ce_irq = false,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -412,6 +422,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.per_ce_irq = false,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -443,6 +454,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.per_ce_irq = false,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -479,6 +491,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.per_ce_irq = false,
+		.shadow_reg_support = false,
 	},
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
@@ -500,6 +513,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.target_64bit = true,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL_DUAL_MAC,
 		.per_ce_irq = true,
+		.shadow_reg_support = true,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 3041eba61e54..74faee5a2578 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018 The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -571,6 +572,9 @@ struct ath10k_hw_params {
 
 	/* target supporting per ce IRQ */
 	bool per_ce_irq;
+
+	/* target supporting shadow register for ce write */
+	bool shadow_reg_support;
 };
 
 struct htt_rx_desc;
-- 
2.14.1
