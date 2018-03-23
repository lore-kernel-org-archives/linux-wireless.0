Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47164 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbeCWFEL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 01:04:11 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 11/13] ath10k: Check all CE for data if irq summary is not retained
Date: Fri, 23 Mar 2018 10:33:42 +0530
Message-Id: <1521781424-24972-12-git-send-email-govinds@codeaurora.org> (sfid-20180323_060417_688125_A2CCB56D)
In-Reply-To: <1521781424-24972-1-git-send-email-govinds@codeaurora.org>
References: <1521781424-24972-1-git-send-email-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rakesh Pillai <pillair@codeaurora.org>

WCN3990 has interrupts per CE and the interrupt summary
is not retained after the interrupt handler has finished
execution. We need to check if we received any
ce in rx and tx completion path.

Generate a interrupt summary with all CE interrupts if
the target does not retain interrupt summary after the
execution of interrupt handler.

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/ce.h   | 10 +++++++---
 drivers/net/wireless/ath/ath10k/core.c | 13 +++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  3 +++
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 2c3c8f5..d8f9da3 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -355,14 +355,18 @@ static inline u32 ath10k_ce_base_address(struct ath10k *ar, unsigned int ce_id)
 	(((x) & CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_MASK) >> \
 		CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_LSB)
 #define CE_WRAPPER_INTERRUPT_SUMMARY_ADDRESS			0x0000
+#define CE_INTERRUPT_SUMMARY		(GENMASK(CE_COUNT_MAX - 1, 0))
 
 static inline u32 ath10k_ce_interrupt_summary(struct ath10k *ar)
 {
 	struct ath10k_ce *ce = ath10k_ce_priv(ar);
 
-	return CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_GET(
-		ce->bus_ops->read32((ar), CE_WRAPPER_BASE_ADDRESS +
-		CE_WRAPPER_INTERRUPT_SUMMARY_ADDRESS));
+	if (!ar->hw_params.per_ce_irq)
+		return CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_GET(
+			ce->bus_ops->read32((ar), CE_WRAPPER_BASE_ADDRESS +
+			CE_WRAPPER_INTERRUPT_SUMMARY_ADDRESS));
+	else
+		return CE_INTERRUPT_SUMMARY;
 }
 
 #endif /* _CE_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 61443f5..64479ac 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -119,6 +119,7 @@
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.per_ce_irq = false,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -148,6 +149,7 @@
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.per_ce_irq = false,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -176,6 +178,7 @@
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.per_ce_irq = false,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -204,6 +207,7 @@
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.per_ce_irq = false,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -232,6 +236,7 @@
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.per_ce_irq = false,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -263,6 +268,7 @@
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.per_ce_irq = false,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -297,6 +303,7 @@
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.per_ce_irq = false,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -336,6 +343,7 @@
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.per_ce_irq = false,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -374,6 +382,7 @@
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.per_ce_irq = false,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -402,6 +411,7 @@
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.per_ce_irq = false,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -432,6 +442,7 @@
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.per_ce_irq = false,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -467,6 +478,7 @@
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
+		.per_ce_irq = false,
 	},
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
@@ -487,6 +499,7 @@
 		.num_wds_entries = TARGET_HL_10_TLV_NUM_WDS_ENTRIES,
 		.target_64bit = true,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL_DUAL_MAC,
+		.per_ce_irq = true,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 413b1b4..3041eba 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -568,6 +568,9 @@ struct ath10k_hw_params {
 
 	/* Target rx ring fill level */
 	u32 rx_ring_fill_level;
+
+	/* target supporting per ce IRQ */
+	bool per_ce_irq;
 };
 
 struct htt_rx_desc;
-- 
1.9.1
