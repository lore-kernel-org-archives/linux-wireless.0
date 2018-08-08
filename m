Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35592 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbeHHM7l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 08:59:41 -0400
From: Wen Gong <wgong@codeaurora.org>
To: ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
Date: Wed,  8 Aug 2018 18:40:02 +0800
Message-Id: <1533724802-30944-3-git-send-email-wgong@codeaurora.org> (sfid-20180808_124037_578033_860F5C09)
In-Reply-To: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upstream kernel has an interface to help adjust sk_pacing_shift to help
improve TCP UL throughput.
The sk_pacing_shift is 8 in mac80211, this is based on test with 11N
WiFi chips with ath9k. For QCA6174/QCA9377 PCI 11AC chips, the 11AC
VHT80 TCP UL throughput testing result shows 6 is the optimal.
Overwrite the sk_pacing_shift to 6 in ath10k driver for QCA6174/9377 PCI.

Tested with QCA6174 PCI with firmware
WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
It's not a regression with new firmware releases.

There have 2 test result of different settings:

ARM CPU based device with QCA6174A PCI with different
sk_pacing_shift:

 sk_pacing_shift  throughput(Mbps)             CPU utilization
         6            500(-P5)      ~75% idle, Focus on CPU1: ~14%idle
         7            454(-P5)      ~80% idle, Focus on CPU1: ~4%idle
         8               288        ~90% idle, Focus on CPU1: ~35%idle
         9              ~200        ~92% idle, Focus on CPU1: ~50%idle

5G TCP UL VTH80 on X86 platform with QCA6174A PCI with sk_packing_shift
set to 6:

  tcp_limit_output_bytes            throughput(Mbps)
 default(262144)+1 Stream                 336
 default(262144)+2 Streams                558
 default(262144)+3 Streams                584
 default(262144)+4 Streams                602
 default(262144)+5 Streams                598
 changed(2621440)+1 Stream                598
 changed(2621440)+2 Streams               601

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
V2:
-add the optimal for configurable for each hardware type
 drivers/net/wireless/ath/ath10k/core.c | 6 ++++++
 drivers/net/wireless/ath/ath10k/hw.h   | 6 ++++++
 drivers/net/wireless/ath/ath10k/mac.c  | 3 +++
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 85c58eb..fbd13ec 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -189,6 +189,7 @@
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.tx_sk_pacing_shift = SK_PACING_SHIFT_6174,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -221,6 +222,7 @@
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.tx_sk_pacing_shift = SK_PACING_SHIFT_6174,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -253,6 +255,7 @@
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.tx_sk_pacing_shift = SK_PACING_SHIFT_6174,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -288,6 +291,7 @@
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.tx_sk_pacing_shift = SK_PACING_SHIFT_6174,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -443,6 +447,7 @@
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.tx_sk_pacing_shift = SK_PACING_SHIFT_9377,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -477,6 +482,7 @@
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.tx_sk_pacing_shift = SK_PACING_SHIFT_9377,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index a274bd8..1f956d6 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -161,6 +161,9 @@ enum qca9377_chip_id_rev {
 
 #define REG_DUMP_COUNT_QCA988X 60
 
+#define SK_PACING_SHIFT_6174 6
+#define SK_PACING_SHIFT_9377 6
+
 struct ath10k_fw_ie {
 	__le32 id;
 	__le32 len;
@@ -589,6 +592,9 @@ struct ath10k_hw_params {
 
 	/* Number of bytes to be the offset for each FFT sample */
 	int spectral_bin_offset;
+
+	/* Number of shift to override the default value of ieee80211_hw*/
+	u8 tx_sk_pacing_shift;
 };
 
 struct htt_rx_desc;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 95243b4..4f2c07f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8361,6 +8361,9 @@ int ath10k_mac_register(struct ath10k *ar)
 	ar->hw->wiphy->max_scan_ssids = WLAN_SCAN_PARAMS_MAX_SSID;
 	ar->hw->wiphy->max_scan_ie_len = WLAN_SCAN_PARAMS_MAX_IE_LEN;
 
+	if (ar->hw_params.tx_sk_pacing_shift != 0)
+		ar->hw->tx_sk_pacing_shift = ar->hw_params.tx_sk_pacing_shift;
+
 	ar->hw->vif_data_size = sizeof(struct ath10k_vif);
 	ar->hw->sta_data_size = sizeof(struct ath10k_sta);
 	ar->hw->txq_data_size = sizeof(struct ath10k_txq);
-- 
1.9.1
