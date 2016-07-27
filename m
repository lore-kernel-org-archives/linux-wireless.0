Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43344 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbcG0MhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 08:37:23 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 1/4] ath10k: Move ath10k_hw_params definition to hw.h
Date: Wed, 27 Jul 2016 18:06:43 +0530
Message-ID: <1469623006-13178-2-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160727_143727_041641_5DA61605)
In-Reply-To: <1469623006-13178-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1469623006-13178-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to prepare for rx descriptor abstraction where we'll
be dereferencing ath10k_hw_params member in hw.h. Moreover
hw.h looks more suitable to house ath10k_hw_params definition
than core.h

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 48 +---------------------------------
 drivers/net/wireless/ath/ath10k/hw.h   | 48 ++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 30ae5bf..5ace413 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -715,53 +715,7 @@ struct ath10k {
 	struct ath10k_htc htc;
 	struct ath10k_htt htt;
 
-	struct ath10k_hw_params {
-		u32 id;
-		u16 dev_id;
-		const char *name;
-		u32 patch_load_addr;
-		int uart_pin;
-		u32 otp_exe_param;
-
-		/* Type of hw cycle counter wraparound logic, for more info
-		 * refer enum ath10k_hw_cc_wraparound_type.
-		 */
-		enum ath10k_hw_cc_wraparound_type cc_wraparound_type;
-
-		/* Some of chip expects fragment descriptor to be continuous
-		 * memory for any TX operation. Set continuous_frag_desc flag
-		 * for the hardware which have such requirement.
-		 */
-		bool continuous_frag_desc;
-
-		/* CCK hardware rate table mapping for the newer chipsets
-		 * like QCA99X0, QCA4019 got revised. The CCK h/w rate values
-		 * are in a proper order with respect to the rate/preamble
-		 */
-		bool cck_rate_map_rev2;
-
-		u32 channel_counters_freq_hz;
-
-		/* Mgmt tx descriptors threshold for limiting probe response
-		 * frames.
-		 */
-		u32 max_probe_resp_desc_thres;
-
-		/* The padding bytes's location is different on various chips */
-		enum ath10k_hw_4addr_pad hw_4addr_pad;
-
-		u32 tx_chain_mask;
-		u32 rx_chain_mask;
-		u32 max_spatial_stream;
-		u32 cal_data_len;
-
-		struct ath10k_hw_params_fw {
-			const char *dir;
-			const char *board;
-			size_t board_size;
-			size_t board_ext_size;
-		} fw;
-	} hw_params;
+	struct ath10k_hw_params hw_params;
 
 	/* contains the firmware images used with ATH10K_FIRMWARE_MODE_NORMAL */
 	struct ath10k_fw_components normal_mode_fw;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index e014cd7..1315557 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -363,6 +363,54 @@ enum ath10k_hw_cc_wraparound_type {
 	ATH10K_HW_CC_WRAP_SHIFTED_EACH = 2,
 };
 
+struct ath10k_hw_params {
+	u32 id;
+	u16 dev_id;
+	const char *name;
+	u32 patch_load_addr;
+	int uart_pin;
+	u32 otp_exe_param;
+
+	/* Type of hw cycle counter wraparound logic, for more info
+	 * refer enum ath10k_hw_cc_wraparound_type.
+	 */
+	enum ath10k_hw_cc_wraparound_type cc_wraparound_type;
+
+	/* Some of chip expects fragment descriptor to be continuous
+	 * memory for any TX operation. Set continuous_frag_desc flag
+	 * for the hardware which have such requirement.
+	 */
+	bool continuous_frag_desc;
+
+	/* CCK hardware rate table mapping for the newer chipsets
+	 * like QCA99X0, QCA4019 got revised. The CCK h/w rate values
+	 * are in a proper order with respect to the rate/preamble
+	 */
+	bool cck_rate_map_rev2;
+
+	u32 channel_counters_freq_hz;
+
+	/* Mgmt tx descriptors threshold for limiting probe response
+	 * frames.
+	 */
+	u32 max_probe_resp_desc_thres;
+
+	/* The padding bytes's location is different on various chips */
+	enum ath10k_hw_4addr_pad hw_4addr_pad;
+
+	u32 tx_chain_mask;
+	u32 rx_chain_mask;
+	u32 max_spatial_stream;
+	u32 cal_data_len;
+
+	struct ath10k_hw_params_fw {
+		const char *dir;
+		const char *board;
+		size_t board_size;
+		size_t board_ext_size;
+	} fw;
+};
+
 /* Target specific defines for MAIN firmware */
 #define TARGET_NUM_VDEVS			8
 #define TARGET_NUM_PEER_AST			2
-- 
1.9.1

