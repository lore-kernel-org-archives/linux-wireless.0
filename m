Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37009 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbcG0MiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 08:38:23 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix rfc1042 header retrieval in QCA4019 with eth decap mode
Date: Wed, 27 Jul 2016 18:08:05 +0530
Message-ID: <1469623085-13942-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160727_143826_226846_ABED56DD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chipset from QCA99X0 onwards (QCA99X0, QCA9984, QCA4019 & future)
rx_hdr_status is not padded to align in 4-byte boundary. Define a
new hw_params field to handle different alignment behaviour between
different hw. This patch fixes improper retrieval of rfc1042 header
with QCA4019. This patch along with "ath10k: Properly remove padding
from the start of rx payload" will fix traffic failure in ethernet
decap mode for QCA4019.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c   | 12 ++++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c |  5 +++--
 drivers/net/wireless/ath/ath10k/hw.h     |  3 +++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 74d0ace..ea6a8f4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -68,6 +68,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA988X_BOARD_EXT_DATA_SZ,
 		},
 		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
+		.decap_align_bytes = 4,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -87,6 +88,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA9887_BOARD_EXT_DATA_SZ,
 		},
 		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
+		.decap_align_bytes = 4,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -105,6 +107,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
 		},
 		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
+		.decap_align_bytes = 4,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -123,6 +126,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
 		},
 		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
+		.decap_align_bytes = 4,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -141,6 +145,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
 		},
 		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
+		.decap_align_bytes = 4,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -160,6 +165,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
 		},
 		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
+		.decap_align_bytes = 4,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -183,6 +189,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
 		},
 		.hw_rx_desc_ops = &qca99x0_rx_desc_ops,
+		.decap_align_bytes = 1,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -206,6 +213,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
 		},
 		.hw_rx_desc_ops = &qca99x0_rx_desc_ops,
+		.decap_align_bytes = 1,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -228,6 +236,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
 		},
 		.hw_rx_desc_ops = &qca99x0_rx_desc_ops,
+		.decap_align_bytes = 1,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -246,6 +255,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
 		},
 		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
+		.decap_align_bytes = 4,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -264,6 +274,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
 		},
 		.hw_rx_desc_ops = &qca988x_rx_desc_ops,
+		.decap_align_bytes = 4,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -288,6 +299,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA4019_BOARD_EXT_DATA_SZ,
 		},
 		.hw_rx_desc_ops = &qca99x0_rx_desc_ops,
+		.decap_align_bytes = 1,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 36c4809..97d5b07 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1108,6 +1108,7 @@ static void *ath10k_htt_rx_h_find_rfc1042(struct ath10k *ar,
 	size_t hdr_len, crypto_len;
 	void *rfc1042;
 	bool is_first, is_last, is_amsdu;
+	int bytes_aligned = ar->hw_params.decap_align_bytes;
 
 	rxd = (void *)msdu->data - sizeof(*rxd);
 	hdr = (void *)rxd->rx_hdr_status;
@@ -1124,8 +1125,8 @@ static void *ath10k_htt_rx_h_find_rfc1042(struct ath10k *ar,
 		hdr_len = ieee80211_hdrlen(hdr->frame_control);
 		crypto_len = ath10k_htt_rx_crypto_param_len(ar, enctype);
 
-		rfc1042 += round_up(hdr_len, 4) +
-			   round_up(crypto_len, 4);
+		rfc1042 += round_up(hdr_len, bytes_aligned) +
+			   round_up(crypto_len, bytes_aligned);
 	}
 
 	if (is_amsdu)
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 1620e76..1961e67 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -403,6 +403,9 @@ struct ath10k_hw_params {
 	} fw;
 
 	const struct ath10k_hw_rx_desc_ops *hw_rx_desc_ops;
+
+	/* Number of bytes used for alignment in rx_hdr_status of rx desc. */
+	int decap_align_bytes;
 };
 
 struct htt_rx_desc;
-- 
1.9.1

