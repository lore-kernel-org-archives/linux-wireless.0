Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33720 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751551AbdIQTkd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Sep 2017 15:40:33 -0400
Received: by mail-lf0-f67.google.com with SMTP id y15so3543597lfd.0
        for <linux-wireless@vger.kernel.org>; Sun, 17 Sep 2017 12:40:32 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v3 09/11] ath10k: add QCA9377 sdio hw_param item
Date: Sun, 17 Sep 2017 21:40:11 +0200
Message-Id: <20170917194013.8658-10-erik.stromdahl@gmail.com> (sfid-20170917_214050_305903_16B3BE8A)
In-Reply-To: <20170917194013.8658-1-erik.stromdahl@gmail.com>
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware parameters for QCA9377 sdio devices.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 25 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b6893254ef53..146a9f61b5f0 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -351,6 +351,31 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.bus = ATH10K_BUS_USB,
 		.start_once = true,
 	},
+	{
+		.id = QCA9377_HW_1_1_DEV_VERSION,
+		.dev_id = QCA9377_1_0_DEVICE_ID,
+		.name = "qca9377 hw1.1 sdio",
+		.patch_load_addr = QCA9377_HW_1_0_PATCH_LOAD_ADDR,
+		.uart_pin = 19,
+		.otp_exe_param = 0,
+		.channel_counters_freq_hz = 88000,
+		.max_probe_resp_desc_thres = 0,
+		.cal_data_len = 8124,
+		.fw = {
+			.dir = QCA9377_HW_1_0_FW_DIR,
+			.board = QCA9377_HW_1_0_BOARD_DATA_FILE_SDIO,
+			.board_size = QCA9377_BOARD_DATA_SZ,
+			.board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
+		},
+		.hw_ops = &qca6174_ops,
+		.hw_clk = qca6174_clk,
+		.target_cpu_freq = 176000000,
+		.decap_align_bytes = 4,
+		.max_num_peers = TARGET_QCA9377_HL_NUM_PEERS,
+		.is_high_latency = true,
+		.bus = ATH10K_BUS_SDIO,
+		.start_once = true,
+	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
 		.dev_id = 0,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 420851e26a09..77011a6cafa1 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -128,6 +128,7 @@ enum qca9377_chip_id_rev {
 #define QCA9377_HW_1_0_FW_DIR          ATH10K_FW_DIR "/QCA9377/hw1.0"
 #define QCA9377_HW_1_0_BOARD_DATA_FILE "board.bin"
 #define QCA9377_HW_1_0_BOARD_DATA_FILE_USB "board-usb.bin"
+#define QCA9377_HW_1_0_BOARD_DATA_FILE_SDIO "board-sdio.bin"
 #define QCA9377_HW_1_0_PATCH_LOAD_ADDR	0x1234
 
 /* QCA4019 1.0 definitions */
-- 
2.14.1
