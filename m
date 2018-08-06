Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-blr-01.qualcomm.com ([103.229.18.197]:2659 "EHLO
        alexa-out-blr-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732373AbeHFRG0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 13:06:26 -0400
From: Rakesh Pillai <pillair@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Skip resetting rx filter for WCN3990
Date: Mon,  6 Aug 2018 20:18:08 +0530
Message-Id: <1533566888-22221-1-git-send-email-pillair@codeaurora.org> (sfid-20180806_165702_652152_91030FCE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WCN3990 has the MAC_PCU_ADDR1 configured properly
and hence it will not send spurious ack frames
during boot up.

Hence the reset_rx_filter workaround is not needed
for WCN3990. Add a hw_param to indicate if hardware rx
filter reset is needed and skip the reset_rx_filter for
WCN3990.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 17 ++++++++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h   |  5 +++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index dfaf7e3..b3ebb37 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -91,6 +91,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA988X_HW_2_0_VERSION,
@@ -124,6 +125,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -157,6 +159,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -189,6 +192,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -221,6 +225,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -253,6 +258,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -288,6 +294,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -326,6 +333,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -369,6 +377,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -411,6 +420,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -443,6 +453,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -477,6 +488,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -516,6 +528,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
@@ -539,6 +552,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = true,
 		.shadow_reg_support = true,
 		.rri_on_ddr = true,
+		.hw_filter_reset_required = false,
 	},
 };
 
@@ -2414,7 +2428,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	 * possible to implicitly make it correct by creating a dummy vdev and
 	 * then deleting it.
 	 */
-	if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
+	if (ar->hw_params.hw_filter_reset_required &&
+	    mode == ATH10K_FIRMWARE_MODE_NORMAL) {
 		status = ath10k_core_reset_rx_filter(ar);
 		if (status) {
 			ath10k_err(ar,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index a274bd8..7a8da75 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -589,6 +589,11 @@ struct ath10k_hw_params {
 
 	/* Number of bytes to be the offset for each FFT sample */
 	int spectral_bin_offset;
+
+	/* targets which require hw filter reset during boot up,
+	 * to avoid it sending spurious acks.
+	 */
+	bool hw_filter_reset_required;
 };
 
 struct htt_rx_desc;
-- 
2.7.4
