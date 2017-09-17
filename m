Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35874 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbdIQTkc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Sep 2017 15:40:32 -0400
Received: by mail-lf0-f65.google.com with SMTP id l196so3535726lfl.3
        for <linux-wireless@vger.kernel.org>; Sun, 17 Sep 2017 12:40:31 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v3 08/11] ath10k: add QCA9377 usb hw_param item
Date: Sun, 17 Sep 2017 21:40:10 +0200
Message-Id: <20170917194013.8658-9-erik.stromdahl@gmail.com> (sfid-20170917_214048_341398_DC1C9ACD)
In-Reply-To: <20170917194013.8658-1-erik.stromdahl@gmail.com>
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware parameters for QCA9377 usb devices.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 23 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 1880570989ae..b6893254ef53 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -328,6 +328,29 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 	},
+	{
+		.id = QCA9377_HW_1_1_DEV_VERSION,
+		.dev_id = QCA9377_1_0_DEVICE_ID,
+		.name = "qca9377 hw1.1 usb",
+		.patch_load_addr = QCA9377_HW_1_0_PATCH_LOAD_ADDR,
+		.uart_pin = 6,
+		.otp_exe_param = 0,
+		.channel_counters_freq_hz = 88000,
+		.max_probe_resp_desc_thres = 0,
+		.cal_data_len = 8124,
+		.fw = {
+			.dir = QCA9377_HW_1_0_FW_DIR,
+			.board = QCA9377_HW_1_0_BOARD_DATA_FILE_USB,
+			.board_size = QCA9377_BOARD_DATA_SZ,
+			.board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
+		},
+		.hw_ops = &qca988x_ops,
+		.decap_align_bytes = 4,
+		.max_num_peers = TARGET_QCA9377_HL_NUM_PEERS,
+		.is_high_latency = true,
+		.bus = ATH10K_BUS_USB,
+		.start_once = true,
+	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
 		.dev_id = 0,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index fd0536077404..420851e26a09 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -127,6 +127,7 @@ enum qca9377_chip_id_rev {
 /* QCA9377 1.0 definitions */
 #define QCA9377_HW_1_0_FW_DIR          ATH10K_FW_DIR "/QCA9377/hw1.0"
 #define QCA9377_HW_1_0_BOARD_DATA_FILE "board.bin"
+#define QCA9377_HW_1_0_BOARD_DATA_FILE_USB "board-usb.bin"
 #define QCA9377_HW_1_0_PATCH_LOAD_ADDR	0x1234
 
 /* QCA4019 1.0 definitions */
-- 
2.14.1
