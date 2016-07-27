Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36821 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbcG0Mhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 08:37:36 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 2/4] ath10k: Add provision for Rx descriptor abstraction
Date: Wed, 27 Jul 2016 18:06:44 +0530
Message-ID: <1469623006-13178-3-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160727_143739_544859_EE936DCA)
In-Reply-To: <1469623006-13178-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1469623006-13178-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are slight differences in Rx hw descriptor information
among different chips. So far driver does not use those new
information for any functionalities, but there is one important
information which is available from QCA99X0 onwards to indicate
the number of bytes that hw padded at the begining of the rx
payload and this information is needed to undecap the rx
packet. Add an abstraction for Rx desc to make use of the
new desc information available. The callback that this patch
defines to retrieve the padding bytes will be used in follow-up
patch.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 12 ++++++++++++
 drivers/net/wireless/ath/ath10k/hw.c   | 13 +++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   | 12 ++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index e889829..9c5e93b 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -68,6 +68,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA988X_BOARD_DATA_SZ,
 			.board_ext_size = QCA988X_BOARD_EXT_DATA_SZ,
 		},
+		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -87,6 +88,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA9887_BOARD_DATA_SZ,
 			.board_ext_size = QCA9887_BOARD_EXT_DATA_SZ,
 		},
+		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -104,6 +106,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA6174_BOARD_DATA_SZ,
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
 		},
+		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -122,6 +125,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA6174_BOARD_DATA_SZ,
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
 		},
+		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -140,6 +144,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA6174_BOARD_DATA_SZ,
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
 		},
+		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -159,6 +164,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA6174_BOARD_DATA_SZ,
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
 		},
+		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -182,6 +188,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA99X0_BOARD_DATA_SZ,
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
 		},
+		.hw_rx_desc_ops = &qca99x0_rx_desc_ops,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -205,6 +212,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA99X0_BOARD_DATA_SZ,
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
 		},
+		.hw_rx_desc_ops = &qca99x0_rx_desc_ops,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -227,6 +235,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA99X0_BOARD_DATA_SZ,
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
 		},
+		.hw_rx_desc_ops = &qca99x0_rx_desc_ops,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -244,6 +253,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA9377_BOARD_DATA_SZ,
 			.board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
 		},
+		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -261,6 +271,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA9377_BOARD_DATA_SZ,
 			.board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
 		},
+		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -285,6 +296,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA4019_BOARD_DATA_SZ,
 			.board_ext_size = QCA4019_BOARD_EXT_DATA_SZ,
 		},
+		.hw_rx_desc_ops = &qca99x0_rx_desc_ops,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index f903d46..6149aa9 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -219,3 +219,16 @@ void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 	survey->time = CCNT_TO_MSEC(ar, cc);
 	survey->time_busy = CCNT_TO_MSEC(ar, rcc);
 }
+
+const struct ath10k_hw_rx_desc_ops qca988x_rx_desc_ops = {
+};
+
+static int ath10k_qca99x0_rx_desc_get_l3_pad_bytes(struct htt_rx_desc *rxd)
+{
+	return MS(__le32_to_cpu(rxd->msdu_end.qca99x0.info1),
+		  RX_MSDU_END_INFO1_L3_HDR_PAD);
+}
+
+const struct ath10k_hw_rx_desc_ops qca99x0_rx_desc_ops = {
+	.rx_desc_get_l3_pad_bytes = ath10k_qca99x0_rx_desc_get_l3_pad_bytes,
+};
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 1315557..a281544 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -409,8 +409,20 @@ struct ath10k_hw_params {
 		size_t board_size;
 		size_t board_ext_size;
 	} fw;
+
+	const struct ath10k_hw_rx_desc_ops *hw_rx_desc_ops;
 };
 
+struct htt_rx_desc;
+
+/* Defines needed for Rx descriptor abstraction */
+struct ath10k_hw_rx_desc_ops {
+	int (*rx_desc_get_l3_pad_bytes)(struct htt_rx_desc *rxd);
+};
+
+extern const struct ath10k_hw_rx_desc_ops qca988x_rx_desc_ops;
+extern const struct ath10k_hw_rx_desc_ops qca99x0_rx_desc_ops;
+
 /* Target specific defines for MAIN firmware */
 #define TARGET_NUM_VDEVS			8
 #define TARGET_NUM_PEER_AST			2
-- 
1.9.1

