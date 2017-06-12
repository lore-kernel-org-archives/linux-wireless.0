Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33220 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752500AbdFLPD2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 11:03:28 -0400
Received: by mail-lf0-f67.google.com with SMTP id u62so9692293lfg.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jun 2017 08:03:27 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v2 08/10] ath10k: add QCA9377 usb hw_param item
Date: Mon, 12 Jun 2017 17:03:09 +0200
Message-Id: <1497279791-9598-9-git-send-email-erik.stromdahl@gmail.com> (sfid-20170612_170333_639426_23316EF7)
In-Reply-To: <1497279791-9598-1-git-send-email-erik.stromdahl@gmail.com>
References: <1497279791-9598-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware parameters for QCA9377 usb devices.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 23 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c20b97b..dc8ea5e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -299,6 +299,29 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.spectral_bin_discard = 0,
 	},
 	{
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
+	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
 		.dev_id = 0,
 		.name = "qca4019 hw1.0",
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index f733e73..cc3d0eb 100644
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
2.7.4
